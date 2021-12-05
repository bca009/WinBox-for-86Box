(*

    WinBox for 86Box - An alternative manager for 86Box VMs

    Copyright (C) 2020-2021, Laci bá'

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

*)

unit frmImportVM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, uLang, frmMainForm;

type
  TListView = class(ComCtrls.TListView)
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  end;

  TImportVM = class(TForm, ILanguageSupport)
    bvBottom: TBevel;
    btnNext: TButton;
    btnPrev: TButton;
    imgBanner: TImage;
    pcPages: TPageControl;
    tabWelcome: TTabSheet;
    lbWelcome: TLabel;
    lbGreetings: TLabel;
    tabManual: TTabSheet;
    lbBasicInfo: TLabel;
    lbName: TLabel;
    lbDescOfName: TLabel;
    lbDescOfConfig: TLabel;
    lbConfig: TLabel;
    edName: TEdit;
    edConfig: TEdit;
    btnConfig: TButton;
    tabEnding2: TTabSheet;
    lbReady2: TLabel;
    lbFinale2: TLabel;
    cbProfileSettings: TCheckBox;
    lbNoteForStoring: TLabel;
    tabSource: TTabSheet;
    lbSource: TLabel;
    rb86BoxManager: TRadioButton;
    lbSelectSource: TLabel;
    lb86BoxManager: TLabel;
    rbWinBox: TRadioButton;
    lbImportWinBox: TLabel;
    tabMachineList: TTabSheet;
    lbSelectVM: TLabel;
    lvImport: TListView;
    lbImport: TLabel;
    btnSelectAll: TButton;
    btnDeselectAll: TButton;
    tabEnding1: TTabSheet;
    lbReady1: TLabel;
    lbFinale1: TLabel;
    lbProgramSettings: TLabel;
    rbManualImport: TRadioButton;
    lbManualImport: TLabel;
    tabEmpty: TTabSheet;
    odConfig: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure Reload(Sender: TObject);
    procedure tabMachineListShow(Sender: TObject);
    procedure btnLvSelectClick(Sender: TObject);
    procedure lbProgramSettingsClick(Sender: TObject);
    procedure tabManualShow(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
  private
    procedure ListForWinBox;
    procedure ListFor86Mgr;

    function ImportList: boolean;
    function ImportManual: boolean;
  public
    LangName: string;
    RootOf86Mgr: string;
    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;
  end;

var
  ImportVM: TImportVM;

implementation

{$R *.dfm}

uses dmGraphUtil, uConfigMgr, uBaseProfile, frmProfSettDlg, uCommText;

resourcestring
  ImgBannerImport = 'BANNER_IMP';
  EDuplicateWorkDir = '.EDuplicateWorkDir';
  EInvalidWorkDir = '.EInvalidWorkDir';
  ENoSelectedItems = '.ENoSelectedItems';
  StrImportedVM = '.ImportedVM';
  StrLvImportColumn0 = '.lvImport.Column[0]';
  StrLvImportColumn1 = '.lvImport.Column[1]';
  InfoRemovedVMs = '.InfoRemovedVMs';

{ TForm1 }

procedure TImportVM.btnNextClick(Sender: TObject);
var
  I, J: integer;
begin
  with pcPages do begin
    if Sender = btnNext then
      case ActivePageIndex of
        1: if rbManualImport.Checked then
             ActivePage := tabManual
           else begin
             ActivePageIndex := ActivePageIndex + 1;
             tabMachineListShow(tabMachineList);
           end;

        2: begin
             J := 0;
             for I := 0 to lvImport.Items.Count - 1 do
               if lvImport.Items[I].Checked then
                 inc(J);

             if J = 0 then begin
               FocusControl(lvImport);
               raise Exception.Create(_T(LangName + ENoSelectedItems));
             end
             else
               ActivePageIndex := ActivePageIndex + 1;
           end;

        3: if ImportList then
             ModalResult := mrOK
           else
             exit;

        4: begin
             if edName.Text = '' then begin
               FocusControl(edName);
               raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA));
             end;

             if not FileExists(edConfig.Text) then begin
               FocusControl(edConfig);
               raise Exception.Create(SysErrorMessage(ERROR_FILE_NOT_FOUND));
             end;

             if WinBoxMain.Profiles.FindByWorkDir(ExtractFilePath(edConfig.Text)) <> -1 then begin
               FocusControl(edConfig);
               raise Exception.Create(_T(LangName + EDuplicateWorkDir));
             end;

             ActivePageIndex := ActivePageIndex + 1;
           end;

        5: if ImportManual then
             ModalResult := mrOK
           else
             exit;
        else
          ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
      end;

    if Sender = btnPrev then
      case ActivePageIndex of
        4: ActivePage := tabSource;
        else
          ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
      end;

    btnPrev.Enabled := ActivePageIndex > 0;
    btnNext.Enabled := ActivePageIndex < PageCount - 1;
  end;
end;

procedure TImportVM.btnConfigClick(Sender: TObject);
begin
  if odConfig.Execute then
    edConfig.Text := odConfig.FileName;
end;

procedure TImportVM.btnLvSelectClick(Sender: TObject);
var
  I: TListItem;
begin
  for I in lvImport.Items do
    I.Checked := (Sender as TComponent).Tag <> 0;
end;

procedure TImportVM.FlipBiDi;
begin
  BiDiMode := BiDiModes[LocaleIsBiDi];
  FlipChildren(true);

  edName.Alignment := Alignments[LocaleIsBiDi];
  SetListViewBiDi(lvImport.Handle, LocaleIsBiDi);
end;

procedure TImportVM.FormCreate(Sender: TObject);
begin
  LoadImage(ImgBannerImport, imgBanner, false);
  pcPages.ActivePageIndex := 0;

  LangName := Copy(ClassName, 2, MaxInt);
  Translate;
  if LocaleIsBiDi then
    FlipBiDi;

  RootOf86Mgr := '';
end;

procedure TImportVM.Reload(Sender: TObject);
begin
  rbManualImport.Checked := true;

  rbWinBox.Enabled := TWinBoxImport.IsExists;
  rbWinBox.Checked := rbWinBox.Enabled;

  rb86BoxManager.Enabled := T86MgrImport.IsExists;
  rb86BoxManager.Checked := rb86BoxManager.Enabled;
end;

function TImportVM.ImportList: boolean;
var
  I: TListItem;
begin
  Result := false;

  for I in lvImport.Items do
    if I.Checked then begin
      if rb86BoxManager.Checked then
        with TProfile.Create('', false) do
          try
            Import86Mgr(I.Caption, RootOf86Mgr);
            Save;
            Result := true;
          finally
          end
      else if rbWinBox.Checked then
        with TProfile.Create('', false) do
          try
            ImportWinBox(I.SubItems[1]);
            Save;
            Result := true;
          finally
          end
    end;
end;

function TImportVM.ImportManual: boolean;
var
  AProfile: TProfile;
begin
  AProfile := TProfile.Create('', false);
  with AProfile do
    try
     WorkingDirectory := ExtractFilePath(edConfig.Text);
     FriendlyName := edName.Text;
     EraseProt := Config.EraseProtLvl > 0;
     Save;

     if cbProfileSettings.Checked then
       with TProfSettDlg.Create(Self) do
         try
           Profile := AProfile;
           ShowModal;
           Profile := nil;
         finally
           Free;
         end;

      Result := true;
    finally
      Free;
    end
end;

procedure TImportVM.lbProgramSettingsClick(Sender: TObject);
begin
  WinBoxMain.acProgramSettings.Execute;
end;

procedure TImportVM.ListFor86Mgr;
var
  Import: TStringList;
  Leave: TStringList;
  S: string;
begin
  Import := TStringList.Create;
  Leave := TStringList.Create;
  try
    TProfile.Get86MgrVMs(Import);
    for S in Import do
      with TProfile.Create('', false) do
        try
          Import86Mgr(S, RootOf86Mgr);
          if (WinBoxMain.Profiles.FindByWorkDir(WorkingDirectory) <> -1)
             or not DirectoryExists(WorkingDirectory) then
               Leave.Add(FriendlyName)
          else with lvImport.Items.Add do begin
              Caption := S;
              SubItems.Add(WorkingDirectory);
            end;
        finally
          Free;
        end;

    if Leave.Count <> 0 then
      MessageBox(Handle, _P(LangName + InfoRemovedVMs, ['86Box Manager', Leave.Text]),
        PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
  finally
    Import.Free;
    Leave.Free;
  end;
end;

procedure TImportVM.ListForWinBox;
var
  Import: TStringList;
  Leave: TStringList;
  S: string;
begin
  Import := TStringList.Create;
  Leave := TStringList.Create;
  try
    TProfile.GetWinBoxVMs(Import);
    for S in Import do
      with TProfile.Create('', false) do
        try
          ImportWinBox(S);

          if (WinBoxMain.Profiles.FindByID(WorkingDirectory) <> -1)
             or (WinBoxMain.Profiles.FindByWorkDir(WorkingDirectory) <> -1)
             or not DirectoryExists(WorkingDirectory) then
            Leave.Add(FriendlyName)
          else with lvImport.Items.Add do begin
            Caption := FriendlyName;
            SubItems.Add(WorkingDirectory);
            SubItems.Add(ProfileID);
            StateIndex := 0;
          end;
        finally
          Free;
        end;

    if Leave.Count <> 0 then
      MessageBox(Handle, _P(LangName + InfoRemovedVMs, ['WinBox Reloaded', Leave.Text]),
        PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
  finally
    Import.Free;
    Leave.Free;
  end;
end;

procedure TImportVM.tabMachineListShow(Sender: TObject);
begin
  WinBoxMain.acUpdateList.Execute;
  lvImport.Clear;

  if rb86BoxManager.Checked then
    ListFor86Mgr
  else
    ListForWinBox;
end;

procedure TImportVM.tabManualShow(Sender: TObject);
begin
  WinBoxMain.acUpdateList.Execute;
  if edName.Text = '' then
    edName.Text := _T(LangName + StrImportedVM, [WinBoxMain.Profiles.Count + 1]);
end;

procedure TImportVM.GetTranslation(Language: TLanguage);
begin
  with Language do begin
    GetTranslation(LangName, Self);

    GetTranslation(LangName + StrLvImportColumn0, lvImport.Column[0].Caption);
    GetTranslation(LangName + StrLvImportColumn1, lvImport.Column[1].Caption);
    GetTranslation(OpenDlgConfig, odConfig.Filter);
  end;
end;

procedure TImportVM.Translate;
begin
  with Language do begin
    Translate(LangName, Self);

    lvImport.Column[0].Caption := _T(LangName + StrLvImportColumn0);
    lvImport.Column[1].Caption := _T(LangName + StrLvImportColumn1);

    odConfig.Filter := _T(OpenDlgConfig);

    Caption := ReadString(LangName, LangName, Caption);
  end;
end;


{ TListView }

procedure TListView.WMPaint(var Msg: TWMPaint);
var
  PS: TPaintStruct;
begin
  Msg.DC := BeginPaint(Handle, PS);
  try
    InvariantBiDiLayout(Msg.DC);
  finally
    inherited;
    EndPaint(Handle, PS);
  end;
end;

end.
