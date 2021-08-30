unit dmWinBoxUpd;

interface

uses
  Windows, SysUtils, Classes, ComCtrls, Controls, Dialogs, Forms;

type
  TWinBoxUpd = class(TDataModule)
    AskUpdateDialog: TTaskDialog;
    procedure DataModuleCreate(Sender: TObject);
    procedure AskUpdateDialogHyperlinkClicked(Sender: TObject);
  private
    { Private declarations }
  public
    Build, URL, Installer, Changes,
      Current, FileName: string;
    BuildDate: TDateTime;
    procedure Refresh;
    function AskUpdateAction: boolean;
    function AskAutoUpdate: boolean;
    procedure Execute;
    procedure DoUpdate;
  end;

var
  WinBoxUpd: TWinBoxUpd;

implementation

uses uWebUtils, uCommUtil, uConfigMgr, uLang, uCommText, frmWaitForm,
     Generics.Collections, JSON, DateUtils, ShellAPI, IOUtils;

resourcestring
  WinBoxRepo =   'https://api.github.com/repos/laciba96/WinBox-for-86Box/releases/latest';
  GitHubReqHdr = 'User-Agent: WinBox-for-86Box'#13#10 +
                 'Content-Type: application/json';
  StrInstaller = 'WinBox-for-86Box-Installer.exe';
  StrParams1   = '/CLOSEAPPLICATIONS';
  StrParams2   = '/VERYSILENT /EXEC';
  WbuDialogTitle = 'WinBoxUpd.DialogTitle';
  WbuAskAllowUpdate = 'WinBoxUpd.AskAllowUpdate';
  WbuAskLocalNewer = 'WinBoxUpd.AskLocalNewer';
  WbuDetailsInfo = 'WinBoxUpd.DetailsInfo';

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{
  0: Ne keressen új WinBox verziókat
  1: Kézi letöltési lehetõség, egyéni frissítés
  2: Telepítõ letöltése, végigkísért telepítés
  3: Telepítõ letöltése, automatikus telepítés
}

function EncodeJsonTime(const Input: string): TDateTime;
var
  _Y, _M, _D, H, M, S: Cardinal;
begin
  //2021-08-23T09:51:02Z

  if TryStrToUInt(Copy(Input, 1, 4), _Y) and
     TryStrToUInt(Copy(Input, 6, 2), _M) and
     TryStrToUInt(Copy(Input, 9, 2), _D) and
     TryStrToUInt(Copy(Input, 12, 2), H) and
     TryStrToUInt(Copy(Input, 15, 2), M) and
     TryStrToUInt(Copy(Input, 18, 2), S) then
       Result := EncodeDateTime(Word(_Y), Word(_M), Word(_D),
                                Word(H), Word(M), Word(S), 0)
  else
    Result := 0;
end;

function TWinBoxUpd.AskAutoUpdate: boolean;
begin
  if Config.WinBoxUpdate = 0 then
    Result := false
  else begin
    Refresh;
    if (Build <> '') and (URL <> '') and (Installer <> '')
       and (Build <> Current) then
      Result := AskUpdateAction
    else
      Result := false;
  end;
end;

function TWinBoxUpd.AskUpdateAction: boolean;
var
  Path: array [0..52] of char;
begin
  with AskUpdateDialog do begin
    PathCompactPathExW(@Path[0], PChar(ExtractFilePath(paramstr(0))), High(Path), 0);
    Path[High(Path)] := #0;

    if Build = '' then
      raise Exception.Create(_T(ECantAccessServer))
    else if (Self.URL = '') or (Installer = '') then
      raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA))
    else if Build = Current then begin
      Text     := _T(WbuAskLocalNewer);
      MainIcon := tdiWarning;
    end
    else begin
      Text     := _T(WbuAskAllowUpdate);
      MainIcon := tdiInformation;
    end;

    ExpandedText := _T(DlgDetailsText, [Self.URL, String(Path)]);

    if BuildDate <> 0 then
      ExpandedText := ExpandedText + #13#10#13#10 +
        _T(WbuDetailsInfo, [Build, DateTimeToStr(BuildDate)]);

    if (Changes <> '') and (MainIcon = tdiInformation) then
      ExpandedText := ExpandedText + #13#10#13#10 +
        _T(DlgDetailsChanges) + #13#10 + UnescapeString(Changes);

    Execute;
    Result := ModalResult = mrYes;
  end;
end;

procedure TWinBoxUpd.AskUpdateDialogHyperlinkClicked(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(AskUpdateDialog.URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TWinBoxUpd.DataModuleCreate(Sender: TObject);
begin
  Current := GetFileVer(paramstr(0));
  FileName := IncludeTrailingPathDelimiter(TPath.GetTempPath) + StrInstaller;

  if FileExists(FileName) then
    DeleteFile(FileName);

  with AskUpdateDialog do begin
    Caption := Application.Title;
    Title := _T(WbuDialogTitle);
  end;

  if Config.WinBoxUpdate <> 0 then
    Refresh;

  if AskAutoUpdate then
    Execute;
end;

procedure TWinBoxUpd.DoUpdate;
var
  FFileName, FInstaller: string;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      FFileName := FileName;
      FInstaller := Installer;
    end);

  httpsGet(FInstaller, FFileName);

  EndThread(0);
end;

procedure TWinBoxUpd.Execute;
var
  Thread: TThread;
  Params: PChar;
begin
  if Config.WinBoxUpdate < 2 then begin
    ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
    exit;
  end;

  with TWaitForm.Create(Self) do
    try
      Show;
      ProgressBar.Style := pbstMarquee;
      Application.ProcessMessages;

      Thread := TThread.CreateAnonymousThread(DoUpdate);
      Thread.Suspended := false;

      while WaitForSingleObject(Thread.Handle, 10) <> WAIT_OBJECT_0 do
        Application.ProcessMessages;
    finally
      Free;
    end;

  Thread.Free;

  if Config.WinBoxUpdate = 2 then
    Params := PChar(StrParams1)
  else
    Params := PChar(StrParams2);

  ShellExecute(0, 'open', PChar(FileName), Params, nil, SW_SHOWNORMAL);

  Application.Terminate;
end;

procedure TWinBoxUpd.Refresh;
var
  Query, Temp: string;
  Value: TJSONValue;
  ArrVal: TJSONArray;

  I: Integer;
begin
  if not CheckForAccess(WinBoxRepo) then begin
    Build := '';
    exit;
  end;

  Query := httpsGetEx(WinBoxRepo, GitHubReqHdr);
  Value := TJSONObject.ParseJSONValue(Query);
  try
    if Value.TryGetValue<string>('tag_name', Build) then begin

      if not Value.TryGetValue<string>('html_url', URL) then
        URL := '';

      if not Value.TryGetValue<string>('body', Changes) then
        Changes := '';

      if Value.TryGetValue<string>('published_at', Temp) then
        BuildDate := EncodeJsonTime(Temp)
      else
        BuildDate := 0;

      Installer := '';
      if Value.TryGetValue<TJSONArray>('assets', ArrVal) then
        for I := 0 to ArrVal.Count - 1 do
          with (ArrVal.Items[I] as TJSONObject) do begin
            if TryGetValue<string>('name', Temp) and
               (LowerCase(ExtractFileExt(Temp)) = '.exe') then begin
                 if not TryGetValue<string>('browser_download_url', Installer) then
                   Installer := '';
                 break;
               end;
          end;
    end
    else
      Build := '';
  finally
    Value.Free;
  end;
end;

end.
