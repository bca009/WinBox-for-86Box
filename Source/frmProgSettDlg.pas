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

unit frmProgSettDlg;

interface

uses
  Types, Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, Vcl.Samples.Spin,
  CheckLst, Menus, Registry, ShellAPI, IniFiles, uLang, uCommText,
  uConfigMgr;

type
  TProgSettDlg = class(TForm, ILanguageSupport)
    pcPages: TPageControl;
    btnOK: TButton;
    btnCancel: TButton;
    tabGeneral: TTabSheet;
    tabAppearance: TTabSheet;
    grpDefaultPath: TGroupBox;
    imgNewVM: TImage;
    lbDefaultPath: TLabel;
    lbPath: TLabel;
    edPath: TEdit;
    btnPath: TButton;
    btnDefPath: TButton;
    btnOpenPath: TButton;
    lbEraseProt: TLabel;
    cbEraseProt: TComboBox;
    imgInfo: TImage;
    lbOnlyNewVM: TLabel;
    grpBehavior: TGroupBox;
    cbMinimizeOnStart: TCheckBox;
    lbTrayBehavior: TLabel;
    cbTrayBehavior: TComboBox;
    lbLaunchTimeout: TLabel;
    spLaunchTimeout: TSpinEdit;
    lbMilliseconds: TLabel;
    grpAppearance: TGroupBox;
    imgDisplay: TImage;
    lbDefaultDisplay: TLabel;
    lbFullscreenSizing: TLabel;
    lbWindowSizing: TLabel;
    rbDefaultDisplay: TRadioButton;
    rbCustomDisplay: TRadioButton;
    clbCustomOptions: TCheckListBox;
    cbFullscreenSizing: TComboBox;
    cbWindowSizing: TComboBox;
    rbManualOptions: TRadioButton;
    mmManualOptions: TMemo;
    rbNoDisplayOptions: TRadioButton;
    btnManOptLoad: TButton;
    tabTools: TTabSheet;
    grpTools: TGroupBox;
    imgTools: TImage;
    lbTools: TLabel;
    lvTools: TListView;
    btnToolAdd: TButton;
    btnToolClear: TButton;
    btnToolDelete: TButton;
    btnToolModify: TButton;
    grpToolProperties: TGroupBox;
    lbToolName: TLabel;
    lbToolPath: TLabel;
    edToolName: TEdit;
    mmToolPath: TMemo;
    btnToolBrowse: TButton;
    tabEmulator: TTabSheet;
    grpDefEmulator: TGroupBox;
    imgEmulator: TImage;
    lbDefEmulator: TLabel;
    lbAffectedVMs: TLabel;
    lb86BoxPath: TLabel;
    ed86Box: TEdit;
    btnDef86Box: TButton;
    btnOpen86Box: TButton;
    btn86Box: TButton;
    grpAutoUpdate: TGroupBox;
    lbArtifact: TLabel;
    cbAutoUpdate: TCheckBox;
    cbGetSource: TCheckBox;
    edArtifact: TEdit;
    tabSpecial: TTabSheet;
    grpExtraPaths: TGroupBox;
    lbExtraPaths: TLabel;
    imgExtraPaths: TImage;
    lbCustomTemplates: TLabel;
    edCustomTemplates: TEdit;
    btnCustomTemplates: TButton;
    btnOpenCustomTemplates: TButton;
    btnDefCustomTemplates: TButton;
    grpDebug: TGroupBox;
    lbDebug: TLabel;
    imgDebug: TImage;
    lbLogging: TLabel;
    cbLogging: TComboBox;
    cbDebugMode: TCheckBox;
    cbCrashDump: TCheckBox;
    lbGlobalLog: TLabel;
    edGlobalLog: TEdit;
    btnGlobalLog: TButton;
    btnDefGlobalLog: TButton;
    btnImport: TButton;
    pmImport: TPopupMenu;
    miImportWinBox: TMenuItem;
    miImport86Mgr: TMenuItem;
    od86Box: TOpenDialog;
    odTools: TOpenDialog;
    odLogFiles: TOpenDialog;
    lbVersion: TLabel;
    lbAppearance: TLabel;
    N1: TMenuItem;
    miDefaults: TMenuItem;
    odConfigFiles: TOpenDialog;
    lbWinBoxUpdate: TLabel;
    cbWinBoxUpdate: TComboBox;
    tvArtifact: TTreeView;
    tabLanguage: TTabSheet;
    grpLanguage: TGroupBox;
    imgLanguage: TImage;
    lbLanguage: TLabel;
    lbProgLang: TLabel;
    cbProgLang: TComboBox;
    btnDefProgLang: TButton;
    lbEmuLang: TLabel;
    rbEmuLangSync: TRadioButton;
    rbEmuLangFix: TRadioButton;
    cbEmuLang: TComboBox;
    rbEmuLangFree: TRadioButton;
    lbEmuLangAvail: TLabel;
    btnDefEmuLang: TButton;
    cbEmuLangForced: TCheckBox;
    tabUI: TTabSheet;
    lbProgIconSet: TLabel;
    cbProgIconSet: TComboBox;
    btnDefProgIconSet: TButton;
    cbEmuIconSet: TComboBox;
    btnDefEmuIconSet: TButton;
    lbPositionSavedDesc: TLabel;
    lbPositionSaved: TLabel;
    btnPositionClear: TButton;
    lbPositionCurrentDesc: TLabel;
    lbPositionCurrent: TLabel;
    btnPositionSave: TButton;
    pmPosition: TPopupMenu;
    miCompleteState: TMenuItem;
    N2: TMenuItem;
    miPositionOnly: TMenuItem;
    miSizeOnly: TMenuItem;
    miLayoutOnly: TMenuItem;
    N3: TMenuItem;
    miDefaults2: TMenuItem;
    grpPositionData: TGroupBox;
    grpIconSets: TGroupBox;
    lbEmuIconSet: TLabel;
    Témák: TTabSheet;
    lbEmuIconSetNote: TLabel;
    lbIconSetDesc: TLabel;
    grpThemes: TGroupBox;
    lbStyleName: TLabel;
    lbStyleColor: TLabel;
    cbStyleName: TComboBox;
    rbStyleSystem: TRadioButton;
    rbStyleColor: TRadioButton;
    cbStyleColor: TComboBox;
    rbStyleCustom: TRadioButton;
    lbStylePreview: TLabel;
    lbStyleDesc: TLabel;
    pnStylePreview: TPanel;
    lbQuadEq: TLabel;
    spQuadEqA: TSpinEdit;
    spQuadEqC: TSpinEdit;
    spQuadEqB: TSpinEdit;
    lbQuadEqA: TLabel;
    lbQuadEqB: TLabel;
    lbQuadEqC: TLabel;
    mmQuadEq: TMemo;
    btnQuadEqSolve: TButton;
    imgStyle: TImage;
    procedure Reload(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbLoggingChange(Sender: TObject);
    procedure UpdateApperance(Sender: TObject);
    procedure lvToolsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CustomDisplayChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCustomDropDown(Sender: TObject);
    procedure miImportWinBoxClick(Sender: TObject);
    procedure miImport86MgrClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnToolsClick(Sender: TObject);
    procedure ed86BoxChange(Sender: TObject);
    procedure miDefaultsClick(Sender: TObject);
    procedure btnManOptLoadClick(Sender: TObject);
    procedure edArtifactChange(Sender: TObject);
    procedure tvArtifactChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure UpdateLangRadio(Sender: TObject);
    procedure cbProgIconSetDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnPositionClick(Sender: TObject);
    procedure UpdateStyleControls(Sender: TObject);
    procedure btnQuadEqSolveClick(Sender: TObject);
  private
    LangName: string;
    ProgLangs, EmuLangs: TStringList;

    PositionData: TPositionData;

    procedure UpdateTools(Tools: TStrings);
    procedure UpdateLanguages(const Mode: integer);
    procedure UpdateIconSets(const Mode: integer);
    procedure UpdateStyles(const Mode: integer);

    function GetSelectedStyle: string;

    procedure UMIconsChanged(var Msg: TMessage); message UM_ICONSETCHANGED;
  protected
    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;
  end;

var
  ProgSettDlg: TProgSettDlg;

implementation

uses uCommUtil, frmMainForm, dmGraphUtil, Graphics, Themes;

resourcestring
  StrLvToolsColumn0 = '.lvTools.Column[0]';
  StrLvToolsColumn1 = '.lvTools.Column[1]';

  StrTvArifactStIx1 = '.tvArtifact.Nodes[%d]';

  AskNewVMPath = '.AskNewVMPath';
  AskTemplatePath = '.AskTemplatePath';
  AskSaveChanges = '.AskSaveChanges';

  EOpenConfigLocked = '.EOpenConfigLocked';
  StrPositionFmt = '(%dx%d)';

  StrLightStyle = 'Windows';
  StrDarkStyle  = 'Windows10 DarkExplorer';

  StrQuadEqNo      = 'QuadEq.NoSolution';
  StrQuadEqAny     = 'QuadEq.AnySolution';
  StrQuadEqLinear  = 'QuadEq.LinearSolution';
  StrQuadEqSingle  = 'QuadEq.SingleSolution';
  StrQuadEqDouble  = 'QuadEq.DoubleSolution';
  StrQuadEqComplex = 'QuadEq.ComplexSolution';

{$R *.dfm}

procedure TProgSettDlg.btnBrowseClick(Sender: TObject);
var
  Directory: string;
begin
  case (Sender as TComponent).Tag of
    1: begin
         Directory := ExcludeTrailingPathDelimiter(edPath.Text);
         if SelectDirectory(_T(LangName + AskNewVMPath), '', Directory, Self) then
           edPath.Text := IncludeTrailingPathDelimiter(Directory);
       end;
    2: begin
         od86Box.InitialDir := ExtractFilePath(ed86Box.Text);
         od86Box.FileName := ExtractFileName(ed86Box.Text);
         if od86Box.Execute then
           ed86Box.Text := od86Box.FileName;
       end;
    3: begin
         Directory := ExcludeTrailingPathDelimiter(edCustomTemplates.Text);
         if SelectDirectory(_T(LangName + AskTemplatePath), '', Directory, Self) then
           edCustomTemplates.Text := IncludeTrailingPathDelimiter(Directory);
       end;
    4: begin
         odLogFiles.InitialDir := ExtractFilePath(edGlobalLog.Text);
         odLogFiles.FileName := ExtractFileName(edGlobalLog.Text);
         if odLogFiles.Execute then
           edGlobalLog.Text := odLogFiles.FileName;
       end;
    5: begin
         odTools.InitialDir := ExtractFilePath(mmToolPath.Text);
         odTools.FileName := ExtractFileName(mmToolPath.Text);
         if odTools.Execute then begin
           if (edToolName.Text = '') or (WideLowerCase(
               ChangeFileExt(ExtractFileName(mmToolPath.Text), ''))
                  = WideLowerCase(edToolName.Text)) then
              edToolName.Text := ChangeFileExt(ExtractFileName(odTools.FileName), '');

           mmToolPath.Text := odTools.FileName;
         end;
       end;
  end;
end;

procedure TProgSettDlg.btnDefaultClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    1: edPath.Text := Defaults.MachineRoot;
    2: ed86Box.Text := Defaults.EmulatorPath;
    3: edCustomTemplates.Text := Defaults.CustomTemplates;
    4: edGlobalLog.Text := Defaults.GlobalLogFile;
    5: begin
         cbProgLang.ItemIndex := ProgLangs.IndexOf(Defaults.ProgramLang);
         cbProgLang.OnChange(cbProgLang);
       end;
    6: cbEmuLang.ItemIndex := EmuLangs.IndexOf(Defaults.EmulatorLang);
    7: cbProgIconSet.ItemIndex := cbProgIconSet.Items.IndexOfName(Defaults.ProgIconSet);
    8: cbEmuIconSet.ItemIndex := cbEmuIconSet.Items.IndexOfName(Defaults.EmuIconSet);
  end;
end;

procedure TProgSettDlg.btnCustomDropDown(Sender: TObject);
begin
  if Sender is TButton then
    with Sender as TButton do
      if Assigned(DropDownMenu) and Assigned(Parent) then
        with Parent.ClientToScreen(Point(Left +
          ord(LocaleIsBiDi) * Width, Top + Height)) do
            DropDownMenu.Popup(X, Y);
end;

procedure TProgSettDlg.btnManOptLoadClick(Sender: TObject);
var
  Config: TMemIniFile;
begin
  with WinBoxMain do
    if IsSelectedVM then
      odConfigFiles.InitialDir := Profiles[List.ItemIndex - 2].WorkingDirectory;

  if odConfigFiles.Execute then begin
    if FileExists(odConfigFiles.FileName) and
       CanLockFile(odConfigFiles.FileName, GENERIC_READ) then begin
           Config := TryLoadIni(odConfigFiles.FileName);
           try
             with Config do begin
               mmManualOptions.Clear;
               Config.DeleteKey('General', 'window_fixed_res');
               Config.DeleteKey('General', 'language');
               Config.DeleteKey('General', 'iconset');
               Config.ReadSectionValues('General', mmManualOptions.Lines);
               UpdateApperance(mmManualOptions);
             end;
           finally
             Config.Free;
           end;
       end
    else
      raise Exception.Create(_T(LangName + EOpenConfigLocked, [odConfigFiles.FileName]));
  end;
end;

procedure TProgSettDlg.btnOKClick(Sender: TObject);
var
  I: integer;

  procedure FixPath(const Control: TEdit; const EndDelim: boolean);
  begin
    if EndDelim then
      Control.Text := IncludeTrailingPathDelimiter(Control.Text);

    if (Control.Text = '') or (Control.Text = '\') or (Control.Text = '/') then begin
      if Assigned(Control.Parent) and Assigned(Control.Parent.Parent)
         and (Control.Parent.Parent is TTabSheet) then begin
           pcPages.ActivePage := Control.Parent.Parent as TTabSheet;
           FocusControl(Control);
         end;
      raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA));
    end;

    //Ha rossz fájlnév van megadva az emulátornak, akkor indításnál
    // kell majd exceptiont feldobni -> lehetõség utólagos frissítésre.
    //Ezen felül ha itt lenne ellenõrizve, és még nincs letöltve semmi,
    // a Defaults.EmulatorPath is exceptiont dobna ezen a ponton.
  end;

begin
  FixPath(edPath, true);
  FixPath(ed86Box, false);
  FixPath(edCustomTemplates, true);
  FixPath(edGlobalLog, false);

  if Assigned(lvTools.Selected) then
    with lvTools.Selected do begin
      if ((Caption <> edToolName.Text) or
           ((SubItems.Count > 0) and (mmToolPath.Text <> SubItems[0]))) and
           (edToolName.Text <> '') and (mmToolPath.Text <> '') and
         (MessageBox(Handle, _P(LangName + AskSaveChanges),
           PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = mrYes) then
            btnToolModify.Click;
    end
  else if (edToolName.Text <> '') and (mmToolPath.Text <> '') and
          (MessageBox(Handle, _P(LangName + AskSaveChanges),
            PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = mrYes) then
              btnToolAdd.Click;

  with Config do begin
    MachineRoot := edPath.Text;
    EmulatorPath := ed86Box.Text;
    CustomTemplates := edCustomTemplates.Text;
    GlobalLogFile := edGlobalLog.Text;

    EraseProtLvl := cbEraseProt.ItemIndex;
    TrayBehavior := cbTrayBehavior.ItemIndex;
    WinBoxUpdate := cbWinBoxUpdate.ItemIndex;
    LoggingMode := cbLogging.ItemIndex;

    Repository := Defaults.Repository;
    Artifact := edArtifact.Text;

    MinimizeOnStart := cbMinimizeOnStart.Checked;
    AutoUpdate := cbAutoUpdate.Checked;
    GetSource := cbGetSource.Checked;
    DebugMode := cbDebugMode.Checked;
    CrashDump := cbCrashDump.Checked;

    LaunchTimeout := spLaunchTimeout.Value;

    Tools.Clear;
    for I := 0 to lvTools.Items.Count - 1 do
      with lvTools.Items[I] do
        if SubItems.Count > 0 then
          Tools.AddPair(Caption, SubItems[0]);

    if rbCustomDisplay.Checked then
      DisplayMode := 1
    else if rbManualOptions.Checked then
      DisplayMode := 2
    else if rbNoDisplayOptions.Checked then
      DisplayMode := 3
    else
      DisplayMode := 0;

    case DisplayMode of
      0:    DisplayValues.Assign(Defaults.DisplayValues);
      1, 2: DisplayValues.Assign(mmManualOptions.Lines);
      3:    DisplayValues.Clear;
    end;

    if rbEmuLangFix.Checked then
      EmuLangCtrl := 1
    else if rbEmuLangFree.Checked then
      EmuLangCtrl := 2
    else
      EmuLangCtrl := 0;

    EmuLangCtrl := EmuLangCtrl or (ord(cbEmuLangForced.Checked) shl 16);

    if Assigned(ProgLangs) and
      (cbProgLang.ItemIndex >= 0) and
      (cbProgLang.ItemIndex < ProgLangs.Count) then
        ProgramLang := ProgLangs[cbProgLang.ItemIndex];

    if Assigned(EmuLangs) and
      (cbEmuLang.ItemIndex >= 0) and
      (cbEmuLang.ItemIndex < EmuLangs.Count) then
        EmulatorLang := EmuLangs[cbEmuLang.ItemIndex];

    ProgIconSet := TextLeft(cbProgIconSet.Text, '=');
    EmuIconSet  := TextLeft(cbEmuIconSet.Text, '=');
    StyleName   := GetSelectedStyle;

    PositionData := Self.PositionData;

    Save;
  end;

  ModalResult := mrOK;
end;

procedure TProgSettDlg.btnOpenClick(Sender: TObject);
var
  Path: string;
begin
  case (Sender as TComponent).Tag of
    1: Path := ExcludeTrailingPathDelimiter(edPath.Text);
    2: Path := ExtractFileDir(ed86Box.Text);
      //Ez leveszi alapból a \ jelet, szemben az ExtractFilePath
      // függvénnyel (ami ráteszi, vagy csak nem veszi el?).
    3: Path := ExcludeTrailingPathDelimiter(edCustomTemplates.Text);
  end;

  SysUtils.ForceDirectories(Path); //nem a FileCtrl verzió kell
  ShellExecute(Handle, 'open', PChar(Path), nil, nil, SW_SHOWNORMAL);
end;

procedure TProgSettDlg.btnPositionClick(Sender: TObject);
const
  SizeSep = '; ';
var
  I, Value: integer;

  function PosToStr(const X, Y: integer; const Default: string): string;
  begin
    if (X = 0) and (Y = 0) then
      Result := Default
    else
      Result := format(StrPositionFmt, [X, Y]);
  end;

begin
  if Assigned(Sender) and (Sender is TComponent) then begin
    Value := (Sender as TComponent).Tag;

    if Value = 0 then
      PositionData := Defaults.PositionData
    else if Assigned(WinBoxMain) then
      with PositionData do
        for I := 0 to SizeOf(Value) * 8 - 1 do
          if (Value and (integer(1) shl I)) <> 0 then
            case I of
              0: begin
                   Position.X := WinBoxMain.Left;
                   Position.Y := WinBoxMain.Top;
                 end;
              1: begin
                   Size.X := WinBoxMain.Width;
                   Size.Y := WinBoxMain.Height;
                 end;
              2: begin
                   MainRatio := Round(WinBoxMain.SideRatio * 100);

                   if Assigned(WinBoxMain.Frame86Box) then
                     FrameRatio := Round(WinBoxMain.Frame86Box.SideRatio * 100);
                 end;
            end;
  end;

  with lbPositionSaved, PositionData do
    Caption :=
      PosToStr(Position.X, Position.Y, Hint) + SizeSep +
      PosToStr(Size.X, Size.Y, Hint);

  if Assigned(WinBoxMain) then
    with lbPositionCurrent, WinBoxMain.BoundsRect do
      Caption :=
        PosToStr(Left, Top, Hint) + SizeSep +
        PosToStr(Width, Height, Hint);
end;

procedure TProgSettDlg.btnQuadEqSolveClick(Sender: TObject);
const
  StrSign: array [boolean] of string = ('-', '+');
var
  a, b, c, D, R: extended;
begin
  (* Hogy minek ez a kód ebbe a programba?
     Totál semmi értelme itt, de miért ne. :D *)

  a := spQuadEqA.Value;
  b := spQuadEqB.Value;
  c := spQuadEqC.Value;

  if a <> 0 then begin
    D := b * b - 4 * a * c;
    R := -b / (2 * a);

    if D < 0 then begin
      mmQuadEq.Text := format(_T(StrQuadEqComplex),
       [R, StrSign[a >= 0], sqrt(-D) / (2 * abs(a)),
        R, StrSign[a < 0], sqrt(-D) / (2 * abs(a))])
    end
    else if D = 0 then
      mmQuadEq.Text := format(_T(StrQuadEqSingle),
       [R + sqrt(D) / (2 * a)])
    else
      mmQuadEq.Text := format(_T(StrQuadEqDouble),
       [R + sqrt(D) / (2 * a), R - sqrt(D) / (2 * a)]);
  end
  else if b <> 0 then
    mmQuadEq.Text := format(_T(StrQuadEqLinear), [-c/b])
  else if c <> 0 then
    mmQuadEq.Text := _T(StrQuadEqNo)
  else
    mmQuadEq.Text := _T(StrQuadEqAny);

  (*  Just for fun. mint az egész téma és ikonredszer!
      Remélem a fordítók is értékelni fogják az új
      szükséges sorokat :P *)
end;

procedure TProgSettDlg.btnToolsClick(Sender: TObject);

  function ValidateInput: boolean;
  begin
    Result := (edToolName.Text <> '') and (mmToolPath.Text <> '');
  end;

  function Find(const S: string): integer;
  var
    I: Integer;
  begin
    Result := -1;
    for I := 0 to lvTools.Items.Count - 1 do
      if lvTools.Items[I].Caption = S then
        exit(I);
  end;

  procedure Error;
  begin
    if edToolName.Text = '' then
      edToolName.SetFocus
    else
      mmToolPath.SetFocus;
    raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA));
  end;

begin
  case (Sender as TComponent).Tag of
    4: begin
         lvTools.Clear;
         lvTools.ItemIndex := -1;
       end;
    3: begin
         lvTools.DeleteSelected;
         lvTools.ItemIndex := -1;
       end;
    2: if Assigned(lvTools) and ValidateInput then
         with lvTools.Selected do begin
           Caption := edToolName.Text;
           SubItems.Clear;
           SubItems.Add(mmToolPath.Text);
         end
       else
         Error;

    1: if not ValidateInput then begin
         btnToolBrowse.Click;
         if ValidateInput then
           with lvTools.Items.Add do begin
             Caption := edToolName.Text;
             SubItems.Add(mmToolPath.Text);
             lvTools.ItemIndex := Index;
           end
         else
           Error;
       end
       else if Find(edToolName.Text) = -1 then
         with lvTools.Items.Add do begin
           Caption := edToolName.Text;
           SubItems.Add(mmToolPath.Text);
         end
  end;
end;

procedure TProgSettDlg.cbProgIconSetDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do
    ComboDrawBiDi(Canvas, Rect, Items.ValueFromIndex[Index]);
end;

procedure TProgSettDlg.cbLoggingChange(Sender: TObject);
begin
  edGlobalLog.Enabled := cbLogging.ItemIndex = 1;
  btnGlobalLog.Enabled := edGlobalLog.Enabled;
  btnDefGlobalLog.Enabled := edGlobalLog.Enabled;
end;

procedure TProgSettDlg.CustomDisplayChange(Sender: TObject);
var
  I: integer;

  procedure WriteKey(const Name: string; const Value, Default: integer);
  begin
    if Value <> Default then
      mmManualOptions.Lines.AddPair(Name, IntToStr(Value));
  end;

begin
  if rbCustomDisplay.Checked then
    with mmManualOptions.Lines do begin
      BeginUpdate;
      Clear;

      for I := 0 to High(CheckListKeys) do
        with CheckListKeys[I] do
          WriteKey(Name, ord(clbCustomOptions.Checked[I]), Default);

      case cbWindowSizing.ItemIndex of
        1, 2: AddPair('vid_resize', IntToStr(cbWindowSizing.ItemIndex));
        3:    begin
                AddPair('vid_resize', '1');
                AddPair('scale', '0');
              end;
        4, 5: begin
                AddPair('vid_resize', '1');
                AddPair('scale', IntToStr(cbWindowSizing.ItemIndex - 2));
              end;
      end;

      WriteKey(ComboBoxKeys[2].Name,
               cbFullscreenSizing.ItemIndex,
               ComboBoxKeys[2].Default);

      EndUpdate;
    end;
end;

procedure TProgSettDlg.ed86BoxChange(Sender: TObject);
begin
  if FileExists(ed86Box.Text) then
    lbVersion.Caption := format(_T(StrVersion) ,[GetFileVer(ed86Box.Text)])
  else
    lbVersion.Caption := format(_T(StrVersion) ,[_T(StrUnknown)]);

  UpdateLanguages(1);
  UpdateIconSets(1);
end;

procedure TProgSettDlg.edArtifactChange(Sender: TObject);
var
  Selected, Node: TTreeNode;
begin
  Selected := nil;
  Node := tvArtifact.Items.GetFirstNode;
  while Assigned(Node) do begin
    if (Node.Text = edArtifact.Text) and
       (Node.GetFirstChild = nil) then begin
         Selected := Node;
         break;
    end;

    Node := Node.GetNext;
  end;

  tvArtifact.Selected := Selected;
end;

procedure TProgSettDlg.FlipBiDi;
begin
  BiDiMode := BiDiModes[LocaleIsBiDi];
  FlipChildren(true);

  SetScrollBarBiDi(mmToolPath.Handle, LocaleIsBiDi);
  SetCommCtrlBiDi(tvArtifact.Handle, LocaleIsBiDi);
  SetListViewBiDi(lvTools.Handle, LocaleIsBiDi);
end;

procedure TProgSettDlg.FormCreate(Sender: TObject);
begin
  pcPages.ActivePageIndex := 0;
  LangName := Copy(ClassName, 2, MaxInt);

  ApplyActiveStyle;
  Perform(UM_ICONSETCHANGED, 0, 0);

  Translate;
  if LocaleIsBiDi then
    FlipBiDi;
end;

procedure TProgSettDlg.FormDestroy(Sender: TObject);
begin
  if Assigned(ProgLangs) then
    FreeAndNil(ProgLangs);

  if Assigned(EmuLangs) then
    FreeAndNil(EmuLangs);
end;

procedure TProgSettDlg.lvToolsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  with lvTools do
    if Assigned(Selected) then begin
      edToolName.Text := Selected.Caption;
      if Selected.SubItems.Count > 0 then
        mmToolPath.Text := Selected.SubItems[0]
      else
        mmToolPath.Text := '';
    end
    else begin
      edToolName.Text := '';
      mmToolPath.Text := '';
    end;
end;

procedure TProgSettDlg.miImport86MgrClick(Sender: TObject);
begin
  with T86MgrImport.Create(true) do
    try
      edPath.Text := MachineRoot;
      ed86Box.Text := EmulatorPath;

      cbMinimizeOnStart.Checked := MinimizeOnStart;
      cbTrayBehavior.ItemIndex := TrayBehavior;
      spLaunchTimeout.Value := LaunchTimeout;

      edGlobalLog.Text := GlobalLogFile;
      cbLogging.ItemIndex := LoggingMode;
      cbLoggingChange(Self);

      mmManualOptions.Lines.Assign(DisplayValues);
      case DisplayMode of
        0: rbDefaultDisplay.Checked := true;
        1: rbCustomDisplay.Checked := true;
        2: rbManualOptions.Checked := true;
        3: rbNoDisplayOptions.Checked := true;
      end;
      UpdateApperance(Self);
    finally
      Free;
    end;
end;

procedure TProgSettDlg.miImportWinBoxClick(Sender: TObject);
begin
  with TWinBoxImport.Create(true) do
    try
      edPath.Text := MachineRoot;
      edArtifact.Text := Artifact;

      cbAutoUpdate.Checked := AutoUpdate;
      cbGetSource.Checked := GetSource;

      if FileExists(EmulatorPath) then
        ed86Box.Text := EmulatorPath;

      UpdateTools(Tools);

      mmManualOptions.Lines.Assign(DisplayValues);
      case DisplayMode of
        0: rbDefaultDisplay.Checked := true;
        1: rbCustomDisplay.Checked := true;
        2: rbManualOptions.Checked := true;
        3: rbNoDisplayOptions.Checked := true;
      end;
      UpdateApperance(Self);
    finally
      Free;
    end;
end;

procedure TProgSettDlg.UpdateStyleControls(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TRadioButton) then
    UpdateStyles(1);

  TStyleManager.ChangeControlStyle(
    pnStylePreview, GetSelectedStyle, true);

  pnStylePreview.Visible :=
    rbStyleSystem.Enabled and (pnStylePreview.StyleName <> '');
  lbStylePreview.Visible :=
    pnStylePreview.Visible;
end;

procedure TProgSettDlg.UMIconsChanged(var Msg: TMessage);
begin
  inherited;
  with IconSet do begin
    DisplayIcon(8,  imgExtraPaths, DefScaleOptions - [soBiDiRotate]);
    DisplayIcon(11, imgInfo, DefScaleOptions - [soBiDiRotate]);
    DisplayIcon(13, imgNewVM, DefScaleOptions - [soBiDiRotate]);

    DisplayIcon(30, imgDisplay, DefScaleOptions - [soBiDiRotate]);
    DisplayIcon(31, imgEmulator, DefScaleOptions - [soBiDiRotate]);
    DisplayIcon(32, imgTools, DefScaleOptions - [soBiDiRotate]);
    DisplayIcon(33, imgDebug, DefScaleOptions - [soBiDiRotate]);

    DisplayIcon(35, imgLanguage, DefScaleOptions - [soBiDiRotate]);
  end;
end;

procedure TProgSettDlg.UpdateApperance(Sender: TObject);
var
  I: integer;

  function ReadKey(const Name: string; const Default: integer): integer;
  var
    I: integer;
  begin
    if TryStrToInt(mmManualOptions.Lines.Values[Name], I) then
      Result := I
    else
      Result := Default
  end;

begin
  clbCustomOptions.Enabled := rbCustomDisplay.Checked;
  cbFullscreenSizing.Enabled := rbCustomDisplay.Checked;
  cbWindowSizing.Enabled := rbCustomDisplay.Checked;

  mmManualOptions.Enabled := rbManualOptions.Checked;
  btnManOptLoad.Enabled := rbManualOptions.Checked;

  if rbDefaultDisplay.Checked then
    mmManualOptions.Lines.Assign(Defaults.DisplayValues);

  //> Lásd miért: uConfig.pas, 54. sor
  I := mmManualOptions.Lines.IndexOfName('window_remember');
  if I <> -1 then
    mmManualOptions.Lines.Delete(I);
  //> ---

  for I := 0 to High(CheckListKeys) do
    with CheckListKeys[I] do
      clbCustomOptions.Checked[I] := ReadKey(Name, Default) <> 0;

  case ReadKey(ComboBoxKeys[0].Name, ComboBoxKeys[0].Default) of
    1: cbWindowSizing.ItemIndex := 1;
    2: cbWindowSizing.ItemIndex := 2;
    else case ReadKey(ComboBoxKeys[1].Name, ComboBoxKeys[1].Default) of
           0: cbWindowSizing.ItemIndex := 3;
           1: cbWindowSizing.ItemIndex := 0;
           2: cbWindowSizing.ItemIndex := 4;
           3: cbWindowSizing.ItemIndex := 5;
           else
             cbWindowSizing.ItemIndex := -1;
         end;
  end;

  I := ReadKey(ComboBoxKeys[2].Name, ComboBoxKeys[2].Default);
  if (I < cbFullscreenSizing.Items.Count) and (I >= 0) then
    cbFullscreenSizing.ItemIndex := I
  else
    cbFullscreenSizing.ItemIndex := -1;
end;

procedure TProgSettDlg.UpdateIconSets(const Mode: integer);
var
  IconSets: TStringList;
  Bookmark: string;
begin
  //Program iconsets part

  if Mode = 0 then
    with cbProgIconSet do begin
      IconSets := IconSet.GetAvailIconSets;
      try
        IconSets.Insert(0, Defaults.ProgIconSet + '=' + Hint);

        Items.Assign(IconSets);
        ItemIndex := Items.IndexOfName(Config.ProgIconSet);

        if ItemIndex = -1 then
          ItemIndex := 0;
      finally
        IconSets.Free;
      end;
    end;

  //Emulator iconsets part

  if Mode <= 1 then
    with cbEmuIconSet do begin
      IconSets := IconSet.GetAvailIconSets(
        ExtractFilePath(ed86Box.Text) + PathEmuIconSets);
      try
        IconSets.Insert(0, Defaults.EmuIconSet + '=' + Hint);

        Bookmark := TextLeft(Text, '=');
        Items.Assign(IconSets);

        if Mode = 0 then
          ItemIndex := Items.IndexOfName(Config.EmuIconSet)
        else
          ItemIndex := Items.IndexOfName(Bookmark);

        if ItemIndex = -1 then
          ItemIndex := 0;
      finally
        IconSets.Free;
      end;
    end;
end;

function GetResourceLanguages(hModule: HMODULE; lpszType, lpszName: LPCTSTR;
   wIDLanguage: WORD; lParam: TStringList): BOOL; stdcall;
begin
  lParam.Add(GetLanguage(wIDLanguage));
  Result := true;
end;

(*
  Üzemmódok:
    0: Teljes frissítés (minden ComboBox és vezérlõ)
    1: Csak az emulátor nyelvek frissítése (ed86Box.OnChange)
    2: Csak a rádiógombokkal kapcsolatos vezérlõk frissítése
*)
procedure TProgSettDlg.UpdateLangRadio(Sender: TObject);
begin
  UpdateLanguages(2);
end;

procedure TProgSettDlg.UpdateLanguages(const Mode: integer);
var
  I, Index: integer;
  DispMode: DWORD;

  h86Box: THandle;
  Temp, Bookmark: string;

  procedure FindEmuLang(const S: string);
  begin
    cbEmuLang.ItemIndex := EmuLangs.IndexOf(S);

    if cbEmuLang.ItemIndex = -1 then
      btnDefEmuLang.Click;

    if (cbEmuLang.ItemIndex = -1) and (cbEmuLang.Items.Count > 0) then
      cbEmuLang.ItemIndex := 0;
  end;

begin
  if pos('en-', Locale) = 1 then
    DispMode := LOCALE_SENGLISHDISPLAYNAME
  else
    DispMode := LOCALE_SLOCALIZEDDISPLAYNAME;

  //Program language part

  if Mode = 0 then begin
    if Assigned(ProgLangs) then
      FreeAndNil(ProgLangs);

    ProgLangs := GetAvailLangs;
    ProgLangs.Insert(0, PrgSystemLanguage);
    Index := 0;

    Temp := cbProgLang.Items[0];
    cbProgLang.Clear;
    cbProgLang.Items.Add(Temp);

    with ProgLangs do
      for I := 1 to Count - 1 do begin
        if Strings[I] = Config.ProgramLang then
          Index := I;
        cbProgLang.Items.Add(GetLocaleText(Strings[I], DispMode));
      end;

    cbProgLang.ItemIndex := Index;
  end;

  //Emulator language part

  if Mode <= 1 then begin
    Bookmark := EmuDefaultLanguage;
    if Assigned(EmuLangs) then begin
      if (cbEmuLang.ItemIndex >= 0) and
         (cbEmuLang.ItemIndex < EmuLangs.Count) then
           Bookmark := EmuLangs[cbEmuLang.ItemIndex];

      FreeAndNil(EmuLangs);
    end;

    EmuLangs := TStringList.Create;
    EmuLangs.Add(EmuSystemLanguage);
    Index := 0;

    Temp := cbEmuLang.Items[0];
    cbEmuLang.Clear;
    cbEmuLang.Items.Add(Temp);

    h86Box := LoadLibraryEx(PChar(ed86Box.Text), 0, $20);
    if h86Box <> 0 then
      try
        EnumResourceLanguages(h86Box, RT_MENU, 'MainMenu',
          @GetResourceLanguages, NativeUInt(EmuLangs));
      finally
        FreeLibrary(h86Box);
      end;

    with EmuLangs do
      for I := 1 to Count - 1 do begin
        if Strings[I] = Config.EmulatorLang then
          Index := I;
        cbEmuLang.Items.Add(GetLocaleText(Strings[I], DispMode));
      end;

    if Mode = 0 then
      FindEmuLang(Bookmark)
    else
      cbEmuLang.ItemIndex := Index;

    case LoWord(Config.EmuLangCtrl) of
      0: rbEmuLangSync.Checked := true;
      1: rbEmuLangFix.Checked := true;
      2: rbEmuLangFree.Checked := true;
    end;

    cbEmuLangForced.Checked := boolean(HiWord(Config.EmuLangCtrl));
  end;

  //Emulator control update part

  cbEmuLang.Enabled := rbEmuLangFix.Checked;
  btnDefEmuLang.Enabled := rbEmuLangFix.Checked;

  cbEmuLangForced.Enabled :=
    rbEmuLangFix.Checked or rbEmuLangSync.Checked;
  cbEmuLangForced.Checked :=
    cbEmuLangForced.Checked and cbEmuLangForced.Enabled;

  if (rbEmuLangSync.Checked) and
     Assigned(ProgLangs) and
     (cbProgLang.ItemIndex >= 0) and
     (cbProgLang.ItemIndex < ProgLangs.Count) then
    FindEmuLang(ProgLangs[cbProgLang.ItemIndex])
  else if rbEmuLangFree.Checked then
    FindEmuLang(Defaults.EmulatorLang);
end;

procedure TProgSettDlg.UpdateStyles;
var
  AStyle: string;
begin
  rbStyleSystem.Enabled := not LocaleIsBiDi;
  rbStyleCustom.Enabled := rbStyleSystem.Enabled;
  rbStyleColor.Enabled :=
    rbStyleSystem.Enabled and (Win32MajorVersion >= 10); //licenszelés szerint

  if Mode = 0 then
    with cbStyleName, Items do begin
      BeginUpdate;
      try
        Clear;
        for AStyle in TStyleManager.StyleNames do
           if (AStyle <> StrLightStyle) and
              (AStyle <> StrDarkStyle) and
              ((pos('Windows10', AStyle) = 0) or //licenszelés szerint
               rbStyleColor.Enabled) then
                Add(AStyle);

        Sorted := true;
        ItemIndex := IndexOf(Config.StyleName);

        if ItemIndex = -1 then begin
          if (Config.StyleName = StrLightStyle) and rbStyleColor.Enabled then begin
            rbStyleColor.Checked := true;
            cbStyleColor.ItemIndex := 0;
          end
          else if (Config.StyleName = StrDarkStyle) and rbStyleColor.Enabled then begin
            rbStyleColor.Checked := true;
            cbStyleColor.ItemIndex := 1;
          end
          else
            rbStyleSystem.Checked := true;
        end
        else
          rbStyleCustom.Checked := true;
      finally
        EndUpdate;
      end;
    end;

  cbStyleColor.Enabled :=
    rbStyleSystem.Enabled and rbStyleColor.Checked and rbStyleColor.Enabled;

  with cbStyleName do begin
    if (Items.Count > 0) and (ItemIndex = -1) then
      ItemIndex := 0;

    Enabled :=
      rbStyleSystem.Enabled and rbStyleCustom.Checked and (ItemIndex <> -1);
  end;

  if Mode = 0 then
    UpdateStyleControls(nil);
end;

procedure TProgSettDlg.UpdateTools(Tools: TStrings);
var
  I: integer;
begin
  edToolName.Text := '';
  mmToolPath.Text := '';

  lvTools.Clear;
  for I := 0 to Tools.Count - 1 do
    with lvTools.Items.Add do begin
      Caption := Tools.Names[I];
      SubItems.Add(Tools.ValueFromIndex[I]);
    end;
  lvTools.ItemIndex := -1;
end;

procedure TProgSettDlg.Reload(Sender: TObject);
begin
  miImportWinBox.Enabled := TWinBoxImport.IsExists;
  miImport86Mgr.Enabled := T86MgrImport.IsExists;
  btnImport.Enabled := miImportWinBox.Enabled or miImport86Mgr.Enabled;

  with Config do begin
    edPath.Text := MachineRoot;
    ed86Box.Text := EmulatorPath;
    edCustomTemplates.Text := CustomTemplates;
    edGlobalLog.Text := GlobalLogFile;

    cbEraseProt.ItemIndex := EraseProtLvl;
    cbTrayBehavior.ItemIndex := TrayBehavior;
    cbWinBoxUpdate.ItemIndex := WinBoxUpdate;

    cbLogging.ItemIndex := LoggingMode;
    cbLoggingChange(Self);

    edArtifact.Text := Artifact;

    cbMinimizeOnStart.Checked := MinimizeOnStart;
    cbAutoUpdate.Checked := AutoUpdate;
    cbGetSource.Checked := GetSource;
    cbDebugMode.Checked := DebugMode;
    cbCrashDump.Checked := CrashDump;

    spLaunchTimeout.Value := LaunchTimeout;

    UpdateTools(Tools);

    mmManualOptions.Lines.Assign(DisplayValues);
    case DisplayMode of
      0: rbDefaultDisplay.Checked := true;
      1: rbCustomDisplay.Checked := true;
      2: rbManualOptions.Checked := true;
      3: rbNoDisplayOptions.Checked := true;
    end;

    UpdateLanguages(0);
    UpdateIconSets(0);
    UpdateStyles(0);

    Self.PositionData := PositionData;
    btnPositionClick(nil);
  end;
end;

function TProgSettDlg.GetSelectedStyle: string;
begin
  if rbStyleSystem.Checked then
    Result   := ''
  else if rbStyleColor.Checked then
    case cbStyleColor.ItemIndex of
      1:   Result := StrDarkStyle
      else Result := StrLightStyle;
    end
  else
    Result := cbStyleName.Text;
end;

procedure TProgSettDlg.GetTranslation(Language: TLanguage);
var
  Node: TTreeNode;
begin
  with Language do begin
    GetTranslation(LangName, Self);
    GetTranslation(pmImport.Name, pmImport.Items);
    GetTranslation(pmPosition.Name, pmPosition.Items);

    GetTranslation(LangName + StrLvToolsColumn0, lvTools.Column[0].Caption);
    GetTranslation(LangName + StrLvToolsColumn1, lvTools.Column[1].Caption);

    Node := tvArtifact.Items.GetFirstNode;
    while Assigned(Node) do begin
      if Node.StateIndex >= 0 then
        GetTranslation(format(LangName + StrTvArifactStIx1,
                       [Node.StateIndex]), Node.Text);

      Node := Node.GetNext;
    end;

    GetTranslation(OpenDlg86Box, od86Box.Filter);
    GetTranslation(OpenDlgExecutables, odTools.Filter);
    GetTranslation(OpenDlgLogFiles, odLogFiles.Filter);
  end;
end;

procedure TProgSettDlg.miDefaultsClick(Sender: TObject);
var
  Temp: TConfiguration;
begin
  Temp := Config;
  Config := Defaults;
  Reload(Self);
  Config := Temp;
end;

procedure TProgSettDlg.Translate;
var
  Node: TTreeNode;
begin
  with Language do begin
    Translate(LangName, Self);
    Translate(pmImport.Name, pmImport.Items);
    Translate(pmPosition.Name, pmPosition.Items);

    lvTools.Column[0].Caption := _T(LangName + StrLvToolsColumn0);
    lvTools.Column[1].Caption := _T(LangName + StrLvToolsColumn1);

    Node := tvArtifact.Items.GetFirstNode;
    while Assigned(Node) do begin
      if Node.StateIndex >= 0 then
        Node.Text := _T(format(LangName + StrTvArifactStIx1,
                               [Node.StateIndex]));

      Node := Node.GetNext;
    end;

    od86Box.Filter := _T(OpenDlg86Box);
    odTools.Filter := _T(OpenDlgExecutables);
    odLogFiles.Filter := _T(OpenDlgLogFiles);
    odConfigFiles.Filter := _T(OpenDlgConfig);

    Caption := ReadString(LangName, LangName, Caption);
  end;
end;

procedure TProgSettDlg.tvArtifactChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and
     (Node.GetFirstChild = nil) and
     (Node.Text <> edArtifact.Text) then
        edArtifact.Text := Node.Text;
end;

end.
