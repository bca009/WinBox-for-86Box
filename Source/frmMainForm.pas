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

unit frmMainForm;

interface

uses
  Types, UITypes, Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  TypInfo, Dialogs, Actions, ActnList, Menus, StdCtrls, ExtCtrls, VclTee.TeeGDIPlus,
  ComCtrls, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series,
  BaseImageCollection, ImageCollection, ImageList, ImgList, VirtualImageList,
  GraphUtil, Generics.Collections, u86Box, Vcl.ToolWin, uLang, AppEvnts, frm86Box,
  Vcl.ExtDlgs, frmUpdaterDlg, uCommText, uConfigMgr;

type
  TListBox = class(StdCtrls.TListBox)
  private
    procedure CNDrawItem(var Msg: TWMDrawItem); message CN_DRAWITEM;
  end;

  TToolBar = class(ComCtrls.TToolBar)
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  end;

  TTrayIcon = class(ExtCtrls.TTrayIcon)
  public
    property Data;
  end;

  TWinBoxMain = class(TForm, ILanguageSupport)
    Actions: TActionList;
    MainMenu: TMainMenu;
    acDbgProcList: TAction;
    acDbgDumpList: TAction;
    acDbgProcUpd: TAction;
    acDbgProcChg: TAction;
    miDebug: TMenuItem;
    acDbgDumpList1: TMenuItem;
    acDbgProcChg1: TMenuItem;
    acDbgProcList1: TMenuItem;
    acDbgProcUpd1: TMenuItem;
    acDbgProcOps: TAction;
    acDbgPrfAsgn: TAction;
    N2: TMenuItem;
    acDbgProcChg2: TMenuItem;
    acDbgProcChg3: TMenuItem;
    acDbgMonData: TAction;
    N3: TMenuItem;
    acDbgMonData1: TMenuItem;
    acDbgMonQuery: TAction;
    ProcessMonitorQuerykiratsa1: TMenuItem;
    acDbgProfChg: TAction;
    N1: TMenuItem;
    ProcessProfileOnChangeesemnyhvsok1: TMenuItem;
    List: TListBox;
    Pages: TPageControl;
    tabHome: TTabSheet;
    lbWelcomeTip: TLabel;
    lbWelcome: TLabel;
    ImgWelcome: TImage;
    tabPerfMon: TTabSheet;
    pgCharts: TPageControl;
    tabCPU: TTabSheet;
    ChartCPU: TChart;
    tabRAM: TTabSheet;
    ChartRAM: TChart;
    tabVMs: TTabSheet;
    ChartVMs: TChart;
    pnpBottom: TPanel;
    pnpRight: TPanel;
    lbHRAM: TLabel;
    pbRAM: TProgressBar;
    pnpLeft: TPanel;
    lbHCPU: TLabel;
    pbCPU: TProgressBar;
    tab86Box: TTabSheet;
    Splitter: TSplitter;
    StatusBar: TStatusBar;
    acProgramSettings: TAction;
    acUpdateList: TAction;
    miTools: TMenuItem;
    Programbelltsok1: TMenuItem;
    N4: TMenuItem;
    acStart: TAction;
    acStop: TAction;
    acPause: TAction;
    acStopForced: TAction;
    miMachine: TMenuItem;
    acStart1: TMenuItem;
    acStart3: TMenuItem;
    acStart4: TMenuItem;
    acProfileSettings: TAction;
    acProfileSettings1: TMenuItem;
    miFile: TMenuItem;
    acImportVM: TAction;
    acImportVM1: TMenuItem;
    aDbgErrAccViol: TAction;
    aDbgErrExcept: TAction;
    aDbgErrConvErr: TAction;
    aDbgErrSystem: TAction;
    aDbgErrorMath: TAction;
    acDbgErrInvCast: TAction;
    miWinBoxMonitor: TMenuItem;
    miExceptions: TMenuItem;
    KivtelfeldobsaEAccessViolation1: TMenuItem;
    KivtelfeldobsaEConvertError1: TMenuItem;
    KivtelfeldobsaException1: TMenuItem;
    KivtelfeldobsaException2: TMenuItem;
    KivtelfeldobsaEMathError1: TMenuItem;
    miView: TMenuItem;
    miHelp: TMenuItem;
    acAbout: TAction;
    Nvjegy1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    ac86BoxSettings: TAction;
    acCtrlAltDel: TAction;
    acCtrlAltEsc: TAction;
    acHWReset: TAction;
    acBringToFront: TAction;
    CtrlAltDelkldse1: TMenuItem;
    Virtulisgplelltsa1: TMenuItem;
    N7: TMenuItem;
    CtrlAltEsckldse1: TMenuItem;
    Virtulisgphardveresjraindtsa1: TMenuItem;
    Hardverbelltsok1: TMenuItem;
    Virtulisgpeltrbehozsa1: TMenuItem;
    N8: TMenuItem;
    VMMenu: TPopupMenu;
    Virtulisgpindtsa1: TMenuItem;
    Virtulisgpszneteltetse1: TMenuItem;
    N14: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N15: TMenuItem;
    MenuItem4: TMenuItem;
    Virtulisgpknyszertettlelltsa1: TMenuItem;
    N16: TMenuItem;
    MenuItem5: TMenuItem;
    Hardverbelltsok2: TMenuItem;
    Profilbelltsok1: TMenuItem;
    N9: TMenuItem;
    HomeMenu: TPopupMenu;
    Meglvvirtulisgpimportlsa1: TMenuItem;
    N10: TMenuItem;
    Virtulisgpeklistjnakfrisstse1: TMenuItem;
    acStopAll: TAction;
    acStopAllForced: TAction;
    N11: TMenuItem;
    Virtulisgplelltsa2: TMenuItem;
    acStopAllForced1: TMenuItem;
    N12: TMenuItem;
    Azsszesvirtulisgplelltsa1: TMenuItem;
    Azsszesvirtulisgpknyszertettlelltsa1: TMenuItem;
    TrayIcon: TTrayIcon;
    AppEvents: TApplicationEvents;
    acClose: TAction;
    N13: TMenuItem;
    Kilps1: TMenuItem;
    N17: TMenuItem;
    KilpsaWinBoxfor86Boxalkalmazsbl1: TMenuItem;
    acOpenPrinterTray: TAction;
    acOpenScreenshots: TAction;
    acOpenWorkDir: TAction;
    N18: TMenuItem;
    Kpernykpekmegnyitsa1: TMenuItem;
    Kpernykpekmegnyitsa2: TMenuItem;
    N19: TMenuItem;
    Munkaknyvtrmegnyitsa1: TMenuItem;
    N20: TMenuItem;
    Kpernykpekmegnyitsa3: TMenuItem;
    Nyomtattlcamegnyitsa1: TMenuItem;
    N21: TMenuItem;
    Munkaknyvtrmegnyitsa2: TMenuItem;
    acNewVM: TAction;
    acNewHDD: TAction;
    tbGlobal: TToolBar;
    tbNewVM: TToolButton;
    tbNewHDD: TToolButton;
    ToolButton3: TToolButton;
    tbStopAll: TToolButton;
    tbUpdateList: TToolButton;
    tbProgSettDlg: TToolButton;
    ToolButton12: TToolButton;
    tbAbout2: TToolButton;
    tbVMs: TToolBar;
    tbStart: TToolButton;
    tbStop: TToolButton;
    ToolButton4: TToolButton;
    tbCtrlAltDel: TToolButton;
    tbHWReset: TToolButton;
    tbSettings: TToolButton;
    ToolButton9: TToolButton;
    tbBringToFront: TToolButton;
    tbPrinterTray: TToolButton;
    ToolButton13: TToolButton;
    tbAbout1: TToolButton;
    tmrUpdate: TTimer;
    acDbgRTTILogFile: TAction;
    SaveLogDialog: TSaveDialog;
    RTTIadatokmentsenaplfjlba1: TMenuItem;
    N22: TMenuItem;
    acDbgNameDefsFile: TAction;
    acDbgLanguageFile: TAction;
    Nvdefincisfjlelmentse1: TMenuItem;
    N23: TMenuItem;
    acDbgGetSysLocale: TAction;
    acDbgGetProgLocale: TAction;
    acDbgGetCmdLine: TAction;
    Jelenleginyelvifjlmentse1: TMenuItem;
    N24: TMenuItem;
    Arendszernyelvneklekrdezse1: TMenuItem;
    Aprogramnyelvneklekrdezse1: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    miPerfCPU1: TMenuItem;
    miExportMetafile1: TMenuItem;
    miExportBitmap1: TMenuItem;
    miPrint1: TMenuItem;
    N27: TMenuItem;
    miShow1: TMenuItem;
    miPerfRAM1: TMenuItem;
    miExportMetafile2: TMenuItem;
    miExportBitmap2: TMenuItem;
    miPrint2: TMenuItem;
    N28: TMenuItem;
    miShow2: TMenuItem;
    miPerfVMs1: TMenuItem;
    miExportMetafile3: TMenuItem;
    miExportBitmap3: TMenuItem;
    miPrint3: TMenuItem;
    N29: TMenuItem;
    miShow3: TMenuItem;
    N30: TMenuItem;
    SaveBmp: TSavePictureDialog;
    SaveEmf: TSavePictureDialog;
    PrintDialog: TPrintDialog;
    acDbgFolderChg: TAction;
    FolderMonitorOnChangenaplzsa1: TMenuItem;
    N31: TMenuItem;
    jvirtulisgpltrehozsa1: TMenuItem;
    jvirtulismerevlemezltrehozsa1: TMenuItem;
    N32: TMenuItem;
    jvirtulisgpltrehozsa2: TMenuItem;
    jvirtulismerevlemezltrehozsa2: TMenuItem;
    N33: TMenuItem;
    ColorDialog: TColorDialog;
    acChangeColor: TAction;
    acResetColor: TAction;
    acUpdateFull: TAction;
    Virtulisgpinformcikfrisstse1: TMenuItem;
    N34: TMenuItem;
    Httrsznmegvltoztatsa1: TMenuItem;
    Httrsznvisszalltsa1: TMenuItem;
    Virtulisgpinformcikfrisstse2: TMenuItem;
    Httrsznmegvltoztatsa2: TMenuItem;
    Httrsznvisszalltsa2: TMenuItem;
    acUpdateTools: TAction;
    Felhasznlieszkzklistjnakfrisstse1: TMenuItem;
    miSepUserTools: TMenuItem;
    miUserTools: TMenuItem;
    PerfMenu: TPopupMenu;
    miPerfCPU2: TMenuItem;
    miExportMetafile4: TMenuItem;
    miExportBitmap4: TMenuItem;
    miPrint4: TMenuItem;
    N36: TMenuItem;
    miShow4: TMenuItem;
    miPerfRAM2: TMenuItem;
    miExportMetafile5: TMenuItem;
    miExportBitmap5: TMenuItem;
    miPrint5: TMenuItem;
    N37: TMenuItem;
    miShow5: TMenuItem;
    miPerfVMs2: TMenuItem;
    miExportMetafile6: TMenuItem;
    miExportBitmap6: TMenuItem;
    miPrint6: TMenuItem;
    N38: TMenuItem;
    miShow6: TMenuItem;
    acDeleteVM: TAction;
    N39: TMenuItem;
    Akijelltvirtulisgpeltvoltsa1: TMenuItem;
    DeleteDialog: TTaskDialog;
    N40: TMenuItem;
    Akijelltvirtulisgpeltvoltsa2: TMenuItem;
    acDiskDatabase: TAction;
    N41: TMenuItem;
    Merevlemezadatbzismegnyitsa1: TMenuItem;
    acAutoUpdate: TAction;
    N42: TMenuItem;
    Emultorfrisstsekkeresse1: TMenuItem;
    N43: TMenuItem;
    miOnlineDocs1: TMenuItem;
    N44: TMenuItem;
    miOnlineLinks2: TMenuItem;
    miOnlineLinks4: TMenuItem;
    miOnlineLinks1: TMenuItem;
    miOnlineLinks5: TMenuItem;
    miOnlineLinks3: TMenuItem;
    acNewFloppy: TAction;
    jhajlkonylemezkpfjlltrehozsa1: TMenuItem;
    jhajlkonylemezkpfjlltrehozsa2: TMenuItem;
    Emultorfrisstsekkeresse2: TMenuItem;
    jvirtulismerevlemezltrehozsa3: TMenuItem;
    jhajlkonylemezkpfjlltrehozsa3: TMenuItem;
    N35: TMenuItem;
    N45: TMenuItem;
    ovbbilehetsgek1: TMenuItem;
    Virtulisgpeklistjnakfrisstse2: TMenuItem;
    N46: TMenuItem;
    Programbelltsok2: TMenuItem;
    Programbelltsok3: TMenuItem;
    Merevlemezadatbzismegnyitsa2: TMenuItem;
    N49: TMenuItem;
    miOnlineDocs2: TMenuItem;
    KivtelfeldobsaEInvalidCast1: TMenuItem;
    MissingDiskDlg: TTaskDialog;
    acWinBoxUpdate: TAction;
    Programfrisstsekkeresse1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acDebugExecute(Sender: TObject);
    procedure btnChartClick(Sender: TObject);
    procedure ListDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListClick(Sender: TObject);
    procedure acProgramSettingsExecute(Sender: TObject);
    procedure acUpdateListExecute(Sender: TObject);
    procedure acVMsUpdate(Sender: TObject);
    procedure acVMsExecute(Sender: TObject);
    procedure acFileExecute(Sender: TObject);
    procedure acErrorExecute(Sender: TObject);
    procedure pnpBottomResize(Sender: TObject);
    procedure acGlobalUpdate(Sender: TObject);
    procedure acGlobalExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AppEventsMinimize(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acCloseExecute(Sender: TObject);
    procedure acWaitFirstUpdate(Sender: TObject);
    procedure tmrUpdateTimer(Sender: TObject);
    procedure ListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure acUpdateToolsExecute(Sender: TObject);
    procedure acSaveLangFile(Sender: TObject);
    procedure acDeleteVMExecute(Sender: TObject);
    procedure acURLExecute(Sender: TObject);
    procedure ListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ListDblClick(Sender: TObject);
    procedure acWinBoxUpdateExecute(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
      NewDPI: Integer);
  private
    //Lista kirajzolásához szükséges cuccok
    HalfCharHeight, BorderThickness: integer;

    clHighlight1, clHighlight2,
    clDisabled1, clDisabled2: TColor;

    procedure ResetChart(Chart: TChart);
    procedure AddSeries(Chart: TChart; AColor: TColor; const FriendlyName: string);
    procedure AddValue(ASeries: TFastLineSeries; const Value: extended);

    procedure CMStyleChanged(var Msg: TMessage); message CM_STYLECHANGED;

    procedure UMIconsChanged(var Msg: TMessage); message UM_ICONSETCHANGED;
    procedure UMDoFirstUpdate(var Msg: TMessage); message UM_DOFIRSTUPDATE;

    procedure WMEnterSizeMove(var Msg: TMessage); message WM_ENTERSIZEMOVE;
    procedure WMSettingChange(var Msg: TMessage); message WM_SETTINGCHANGE;
  public
    //Nyelvváltáskor, a program eredeti címének megtartása
    InitialTitle: string;

    //A lista az ablak és a PageControl közti aránytartáshoz, méretezéskor
    DefaultSize: TPoint;
    SideRatio: single;

    //Belsõ cuccok
    IsAllStopped,
    IsAnyRunning,          //not IsAllStopped
    IsSelectedVM,
    FirstUpdateDone: boolean;
    UpdateCount: integer;

    Updater: TUpdaterDlg;
    Monitor: T86BoxMonitor;
    Profiles: T86BoxProfiles;
    Frame86Box: TFrame86Box;
    Icons: TObjectList<TWICImage>;
    procedure DummyUpdate(Sender: TObject);
    procedure MonitorUpdate(Sender: TObject);
    procedure MonitorChange(Sender: TObject);
    procedure ListReload(Sender: TObject);
    procedure ProfileChange(Sender: TObject);
    procedure UserToolClick(Sender: TObject);

    procedure DeleteVM(DeleteFiles: boolean);

    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;

    procedure ChangeBiDi(const NewBiDi: boolean);
    procedure ChangeLanguage(const ALocale: string);
    procedure ChangeIconSet(const AIconSet: string);
    procedure ChangeStyle(const AStyle: string; const Mode: integer);
    procedure ChangePosition(AData: TPositionData);

    procedure GetRttiReport(Result: TStrings);
  end;

var
  WinBoxMain: TWinBoxMain;

resourcestring
  StrMissingDiskDlg = 'MissingDiskDlg';
  ImgWelcomeLogo = 'WELCOME';

implementation

uses JclDebug, uProcessMon, uProcProfile, uCommUtil, frmProgSettDlg,
  frmProfSettDlg, frmImportVM, uWinProfile, ShellAPI, dmGraphUtil,
  Rtti, frmErrorDialog, frmAboutDlg, frmSelectHDD, frmNewFloppy,
  frmWizardHDD, frmWizardVM, uBaseProfile, frmSplash, dmWinBoxUpd,
  WinCodec, Themes, VCLTee.TeCanvas;

const
  MaxPoints = 60;
  ScrollPoints = 1;

resourcestring
  EInvalidActionTag = 'Invalid action tag.';
  StrTerminateConf = 'WinBox.TerminateConfirm';
  UnableToDelete = 'WinBox.UnableToDelete';
  StrDeleteDialog = 'DeleteDialog';
  StrChartBase = 'PerfMon.Chart%s';
  StrChartAxisBase = 'PerfMon.Chart%s.Axis%s';
  ImFloppyImages = 'Floppy Disk Images';
  WizNewVM = 'WizardVM.NewVM';
  StrLangNeedsRestart = 'WinBox.LangNeedsRestart';

{$R *.dfm}

procedure TWinBoxMain.acCloseExecute(Sender: TObject);
begin
  OnClose := nil;
  Close;
end;

procedure TWinBoxMain.acDebugExecute(Sender: TObject);
var
  L: TStringList;
begin
  case (Sender as TComponent).Tag of
    -1: if IsSelectedVM and SaveLogDialog.Execute then
          Profiles[List.ItemIndex - 2].NameDefs.SaveToFile(SaveLogDialog.FileName);
    1: dbgDumpProcList(Monitor, false);
    2: dbgDumpProcList(Monitor, true);
    3: begin
         dbgLogUpdates := not dbgLogUpdates;
         (Sender as TAction).Checked := dbgLogUpdates;
       end;
    4: begin
         dbgLogChanges := not dbgLogChanges;
         (Sender as TAction).Checked := dbgLogChanges;
       end;
    5: begin
         dbgLogProcessOp := not dbgLogProcessOp;
         (Sender as TAction).Checked := dbgLogProcessOp;
       end;
    6: begin
         dbgLogProfAssign := not dbgLogProfAssign;
         (Sender as TAction).Checked := dbgLogProfAssign;
       end;
    7: begin
         dbgLogCreateData := not dbgLogCreateData;
         (Sender as TAction).Checked := dbgLogCreateData;
       end;
    8: Log(Monitor.Query);
    9: begin
         dbgLogProfChange := not dbgLogProfChange;
         (Sender as TAction).Checked := dbgLogProfChange;
       end;
    10: begin
          L := TStringList.Create;
          try
            GetRttiReport(L);
          finally
            try
              if SaveLogDialog.Execute then
                L.SaveToFile(SaveLogDialog.FileName);
            finally
              L.Free;
            end;
          end;
        end;
    11: ShowMessage(GetSystemLanguage);
    12: ShowMessage(Locale);
    13: ShowMessage(GetCommandLine);
    14: begin
          dbgLogFolderChanges := not dbgLogFolderChanges;
          (Sender as TAction).Checked := dbgLogFolderChanges;
        end;
    else
      raise Exception.Create(EInvalidActionTag);
  end;
end;

procedure TWinBoxMain.acDeleteVMExecute(Sender: TObject);
var
  Buffer: array [0..50] of char;
  Temp: string;
begin
  if IsSelectedVM then
    with Profiles[List.ItemIndex - 2] do begin
      if PathCompactPathExW(@Buffer[0], PChar(WorkingDirectory), 50, 0) then begin
        Buffer[50] := #0;
        Temp := String(Buffer);
      end
      else
        Temp := WorkingDirectory;

      with DeleteDialog do begin
        Text :=
          _T(StrDeleteDialog + '.Text',
             [FriendlyName,
              FileSizeToStr(DiskSize, 2)]);
        ExpandedText :=
          _T(StrDeleteDialog + '.ExpandedText',
             [ProfileID,
              Temp,
              _T(format(StrSwitchText, [ord(EraseProt)]))]);
        Buttons[1].Enabled := not EraseProt;
        if Execute then
          case ModalResult of
            100: DeleteVM(false);
            101: DeleteVM(true);
            else exit;
          end;
      end;
    end;
end;

procedure TWinBoxMain.acErrorExecute(Sender: TObject);
var
  P: Pointer;
  F: single;
begin
  P := nil;
  case (Sender as TAction).Tag of
    0: IntToStr(PByte(P)^);
    1: StrToInt('Invalid number.');
    2: raise Exception.Create('Custom Error Message.');
    3: begin
         CreateFile(nil, 0, 0, nil, 0, 0, 0);
         RaiseLastOSError;
       end;
    4: begin
         F := 0;
         FloatToStr(2 / F);
       end;
    5: (Sender as TStream).Seek(0, soFromBeginning);
  end;
end;

procedure TWinBoxMain.acFileExecute(Sender: TObject);
var
  I: integer;
begin
  with Sender as TAction do
    case Tag of
      1: with TImportVM.Create(Self) do
           try
             if ShowModal = mrOK then
               acUpdateList.Execute;
           finally
             Free;
           end;
      -1: with TAboutDlg.Create(Self) do
           try
             ShowModal;
           finally
             Free;
           end;
      2: with TWizardVM.Create(Self) do
           try
             SetFriendlyName(_P(WizNewVM, [Profiles.Count + 1]));
             if Execute(true) then begin
               acUpdateList.Execute;
               I := Profiles.FindByID(GetProfileID);
               if I + 2 < List.Count then begin
                 WinBoxMain.List.ItemIndex := I + 2;
                 WinBoxMain.ListClick(Self);

                 if GetOpenSettings then
                   ac86BoxSettings.Execute;
               end;
             end;
           finally
             Free;
           end;
      3: with Updater do begin
           Refresh;
           if AskUpdateAction then
             ShowModal;
         end;
      4: with HDSelect do begin
           SetConnectorFilter(false);
           ShowModal;
         end;
      5: with TNewFloppy.Create(Self) do
           try
             if IsSelectedVM then
               with Profiles[List.ItemIndex - 2] do begin
                 edFileName.Text := NextImageName(WorkingDirectory + ImFloppyImages + PathDelim, 'floppy') + '.ima';
                 TypeFrom86Box(ConfigData.Floppy[1]);
               end
             else
               edFileName.Text := NextImageName(Config.DiskImages + ImFloppyImages + PathDelim, 'floppy') + '.ima';

             ShowModal;
           finally
             Free;
           end;
      6: with TWizardHDD.Create(Self) do
           try
             if IsSelectedVM then
               with Profiles[List.ItemIndex - 2] do begin
                 edFileName.Text := NextImageName(WorkingDirectory, 'vdisk') + '.img';
                 TypeFrom86Box(ConfigData.HDD[1].Connector, ConfigData.Machine);
               end
             else
               edFileName.Text := NextImageName(Config.DiskImages, 'vdisk') + '.img';

             Execute(true);
           finally
             Free;
           end;
      else
        raise Exception.Create(EInvalidActionTag);
    end;
end;

procedure TWinBoxMain.acGlobalExecute(Sender: TObject);
var
  P: T86BoxProfile;
begin
  with (Sender as TAction) do
    if Enabled then
      case Tag of
        1, 2:
          if (Tag = 1) or (MessageBox(Handle, _P(StrTerminateConf),
            PChar(Application.Title), MB_ICONWARNING or MB_YESNO) = mrYes) then
              for P in Profiles do
                P.Stop(Tag = 2);
      end;
end;

procedure TWinBoxMain.acGlobalUpdate(Sender: TObject);
begin
  with (Sender as TAction) do
    case HelpContext of
      0: Enabled := FirstUpdateDone and IsAllStopped;
      1: Enabled := FirstUpdateDone and IsAnyRunning;
    end;
end;

procedure TWinBoxMain.acProgramSettingsExecute(Sender: TObject);
begin
  with TProgSettDlg.Create(Application) do
    try
      if ShowModal = mrOK then begin
        FormShow(Sender);

        ChangeLanguage(Config.ProgramLang);
        ChangeIconSet(Config.ProgIconSet);

        //bugos szar, ne csináljuk inkább
        //ChangeStyle(Config.StyleName, -1);

        if Config.StyleName <> Self.StyleName then
          MessageBox(Handle, _P(StrDeferStyleChange),
          PChar(Application.Title), MB_ICONINFORMATION or MB_OK);

        DefProfile.Default;
        acUpdateList.Execute;
      end;
    finally
      Free;
    end;
end;

procedure TWinBoxMain.acSaveLangFile(Sender: TObject);
begin
  try
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Self.GetTranslation(Language);

      if Assigned(Frame86Box) then
        Frame86Box.GetTranslation(Language);

      if Assigned(Updater) then
        Updater.GetTranslation(Language);

      with TProgSettDlg.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TProfSettDlg.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TImportVM.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TExceptionDialog.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TAboutDlg.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with THDSelect.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TNewFloppy.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TWizardHDD.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;

      with TWizardVM.Create(nil) do
        try
          GetTranslation(Language);
        finally
          Free;
        end;
    finally
      Screen.Cursor := crDefault;
      if SaveLogDialog.Execute then
        Language.SaveToFile(SaveLogDialog.FileName);
    end;
  except
    raise;
  end;
end;

procedure TWinBoxMain.acVMsExecute(Sender: TObject);
var
  Temp: string;
begin
  with Sender as TAction do
    if Enabled then
      case Tag of
        -1: case HelpContext of
              1: with TProfSettDlg.Create(Self) do
                   try
                     Profile := Profiles[List.ItemIndex - 2];
                     edFriendlyName.Enabled :=
                       Profiles[List.ItemIndex - 2].State = PROFILE_STATE_STOPPED;
                     if ShowModal = mrOK then
                       acUpdateList.Execute
                     else
                       Profile.ReloadIcon;
                   finally
                     Free;
                   end;
              2: Profiles[List.ItemIndex - 2].Settings;
              else
                raise Exception.Create(EInvalidActionTag);
            end;
        -2: with Profiles[List.ItemIndex - 2] do begin
              BringToFront;
              case HelpContext of
                1: ;
                2: Execute(IDM_ACTION_RESET_CAD);
                3: Execute(IDM_ACTION_CTRL_ALT_ESC);
                4: Execute(IDM_ACTION_HRESET);
                else
                  raise Exception.Create(EInvalidActionTag);
              end;
            end;
        -5..-3:
            with Profiles[List.ItemIndex - 2] do begin
              case Tag of
                -3: Temp := WorkingDirectory;
                -4: Temp := PrinterTray;
                -5: Temp := Screenshots;
              end;

              ForceDirectories(Temp);

              Temp := ExcludeTrailingPathDelimiter(Temp) + #0;
              ShellExecute(Handle, 'open', @Temp[1], nil, nil, SW_SHOWNORMAL);
            end;
        -6: Profiles[List.ItemIndex - 2].BringToFront;
        -7: with Profiles[List.ItemIndex - 2] do begin
              if Color = clNone then
                ColorDialog.Color := ColorToRGB(clWindow)
              else
                ColorDialog.Color := ColorToRGB(Color);

              if ColorDialog.Execute then begin
                Color := ColorDialog.Color;
                Save;
                if Assigned(Frame86Box) then
                  Frame86Box.UpdateColor(Profiles[List.ItemIndex - 2]);
              end;
            end;
        -8: with Profiles[List.ItemIndex - 2] do begin
              Color := clNone;
              Save;
              if Assigned(Frame86Box) then
                Frame86Box.UpdateColor(Profiles[List.ItemIndex - 2]);
            end;
        -9: if Assigned(Frame86Box) then
              Frame86Box.UpdateFull(Profiles[List.ItemIndex - 2]);
        0: if (HelpContext = 0) or (MessageBox(Handle, _P(StrTerminateConf),
             PChar(Application.Title), MB_ICONWARNING or MB_YESNO) = mrYes) then
               Profiles[List.ItemIndex - 2].Stop(HelpContext <> 0);
        else Profiles[List.ItemIndex - 2].SetState(Tag, HelpContext <> 0);
      end;
end;

procedure TWinBoxMain.acVMsUpdate(Sender: TObject);
begin
  with Sender as TAction do begin
    if IsSelectedVM then
      with Profiles[List.ItemIndex - 2] do
        case Tag of
          -4:  Enabled := HasPrinterTray;
          //-1:  Enabled := State = PROFILE_STATE_STOPPED;
          -2:  Enabled := State = PROFILE_STATE_RUNNING;
          -6:  Enabled := State <> 0;
          -7, -8:  Enabled := IconSet.IsColorsAllowed;
          -127: Enabled := State = 0;
          else if Tag >= 0 then
            Enabled := CanState(Tag)
          else
            Enabled := true;
         end
    else
      Enabled := false;
  end;
end;

procedure TWinBoxMain.acWaitFirstUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := FirstUpdateDone;
end;

procedure TWinBoxMain.acWinBoxUpdateExecute(Sender: TObject);
begin
  with WinBoxUpd do begin
    Refresh;
    if AskUpdateAction then
      Execute;
  end;
end;

procedure TWinBoxMain.AddSeries(Chart: TChart; AColor: TColor;
  const FriendlyName: string);
begin
  with Chart.AddSeries(TFastLineSeries.Create(Chart)) as TFastLineSeries do begin
    Title := FriendlyName;
    Color := AColor;
    AutoRepaint := true;
    XValues.Order := loNone;
    LinePen.OwnerCriticalSection := nil;
    FastPen := true;
  end;
end;

procedure TWinBoxMain.AddValue(ASeries: TFastLineSeries; const Value: extended);
var
  Temp: extended;
begin
  with ASeries do begin
    if Count > MaxPoints then begin
      Delete(0, ScrollPoints);

      Temp := XValues.Last;
      GetHorizAxis.SetMinMax(
        Temp - MaxPoints + ScrollPoints,
        Temp + ScrollPoints);
    end;

    if Count = 0 then
      AddXY(1, Value)
    else
      AddXY(XValues.Last + 1, Value);
  end;
end;

procedure TWinBoxMain.AppEventsMinimize(Sender: TObject);
begin
  if Config.TrayBehavior = 2 then begin
    WindowState := wsMinimized;
    Hide;
  end;
end;

procedure TWinBoxMain.btnChartClick(Sender: TObject);
begin
  if FirstUpdateDone then
    with Sender as TMenuItem do
      case HelpContext of
        1: begin
             List.ItemIndex := 1;
             ListClick(List);
             pgCharts.ActivePageIndex := Tag;
           end;
        2: if PrintDialog.Execute then
             (pgCharts.Pages[Tag].Controls[0] as TChart).Print;
        3: if SaveBmp.Execute then
             (pgCharts.Pages[Tag].Controls[0] as TChart).SaveToBitmapFile(SaveBmp.FileName);
        4: if SaveEmf.Execute then
             with pgCharts.Pages[Tag].Controls[0] as TChart do begin
               if LowerCase(ExtractFileExt(SaveEmf.FileName)) = '.wmf' then
                 SaveToMetafile(SaveEmf.FileName)
               else
                 SaveToMetafileEnh(SaveEmf.FileName);
             end;
      end;
end;

procedure TWinBoxMain.ChangeBiDi(const NewBiDi: boolean);
begin
  if NewBiDi <> LocaleIsBiDi then begin
    LocaleIsBiDi := NewBiDi;

    //if the new language is RTL disable styling
    if NewBiDi then
      TStyleManager.TrySetStyle('Windows', false);
    //else ha implementálva lesz egy on-fly layout swith
    // TStyleManager.TrySetStyle('Windows10 DarkExplorer', false);

    FlipBiDi;
  end;
end;

procedure TWinBoxMain.ChangeIconSet(const AIconSet: string);
begin
  if AIconSet <> '' then
    IconSet.Path := IconSet.GetIconSetRoot + AIconSet
  else
    IconSet.Path := '';
end;

procedure TWinBoxMain.ChangeLanguage(const ALocale: string);
var
  I: integer;

  NewLoc: string;
  NewLang: TLanguage;
  NewBiDi: boolean;

  function IsProgSettVisible: boolean;
  var
    I: integer;
  begin
    Result := false;
    for I := 0 to Screen.FormCount - 1 do
      if Screen.Forms[I] is TProgSettDlg then
        exit(true);
  end;

begin
  NewLoc := ALocale;
  NewLang := TryLoadLocale(NewLoc, NewBiDi);

  if (((NewLoc = PrgBaseLanguage) and (Locale <> NewLoc))
      or (NewBiDi <> LocaleIsBiDi)) and IsProgSettVisible then begin
    MessageBox(Handle, _P(StrLangNeedsRestart),
      PChar(Application.Title), MB_ICONINFORMATION or MB_OK);
    NewLang.Free;
    exit;
  end
  else if NewLoc = Locale then
    exit
  else begin
    Locale := NewLoc;

    if Assigned(Language) then
      Language.Free;

    Language := NewLang;
  end;

  Frame86Box.Translate;

  for I := 0 to Screen.FormCount - 1 do
    if Supports(Screen.Forms[I], ILanguageSupport) then
      (Screen.Forms[I] as ILanguageSupport).Translate;

  ChangeBiDi(NewBiDi);
end;

procedure TWinBoxMain.ChangePosition(AData: TPositionData);

  procedure SetRatio(AWindow, AControl: TControl; ARatio: integer;
    const DefRatio: integer; Callback: TNotifyEvent);
  begin
    if not (Assigned(AWindow) and Assigned(AControl)) or
       ((ARatio = 0) and (DefRatio = 0)) then
      exit;

    if ARatio = 0 then
      ARatio := DefRatio;

    AControl.Width := AWindow.ClientWidth * ARatio div 100;

    if Assigned(Callback) then
      Callback(Self);
  end;

begin
  if AData.Size.IsZero then
    AData.Size := DefaultSize;

  if AData.Position.IsZero or
     (Screen.MonitorFromPoint(AData.Position, mdNull) = nil) then
    with Screen.PrimaryMonitor.WorkareaRect do
      AData.Position := Point(
        Left + (Width - AData.Size.X) div 2,
        Top + (Height - AData.Size.Y) div 2);

  with AData do
    SetBounds(Position.X, Position.Y, Size.X, Size.Y);

  SetRatio(Self, List, AData.MainRatio,
    Defaults.PositionData.MainRatio, SplitterMoved);

  SetRatio(Frame86Box, Frame86Box.RightPanel, AData.FrameRatio,
    Defaults.PositionData.FrameRatio, Frame86Box.OnEnterSizeMove);
end;

procedure TWinBoxMain.ChangeStyle(const AStyle: string;
  const Mode: integer);
begin
  IconSet.Style := AStyle;

  //Ha külsõ üzenet hatására kell megcsinálni, itt kell frissíteni.
  if Mode = -1 then
    ListClick(List);
  //Ellenkezõ esetben vagy nem kell (OnCreate),
  //  vagy alapból van frissítés (acUpdateList.Execute).
end;

procedure TWinBoxMain.CMStyleChanged(var Msg: TMessage);
var
  IsSystemStyle: boolean;
  H, L, S: word;
  BkColor, TextColor, TitleColor, GridColor: TColor;
const
  TitleColors: array [boolean] of TColor = (clHighlight, clBlue);
  BkColors: array [boolean] of TColor = (clBtnFace, clWindow);

  procedure ProcessChart(Chart: TChart);
  begin
    with Chart do begin
      Color := BkColor;
      Legend.Color := BkColor;

      Frame.Color := TextColor;
      Legend.Font.Color := TextColor;
      Legend.Frame.Color := TextColor;
      LeftAxis.LabelsFont.Color := TextColor;
      BottomAxis.LabelsFont.Color := TextColor;
      LeftAxis.Title.Font.Color := TextColor;
      BottomAxis.Title.Font.Color := TextColor;

      LeftAxis.Grid.Color := GridColor;
      BottomAxis.Grid.Color := GridColor;

      Title.Font.Color := TitleColor;
    end;
  end;

begin
  inherited;
  IsSystemStyle := StyleServices(Self).IsSystemStyle;

  //Lista kirajzolási eljárás segédlet
  HalfCharHeight := Canvas.TextHeight('Wg');
  BorderThickness :=
    (List.ItemHeight - IconSet.ListIcons.Height) div 2;

  clHighlight1 := StyleServices(Self).GetSystemColor(clHighlight);
  ColorRGBToHLS(clHighlight1, H, L, S);
  clDisabled1 := ColorHLSToRGB(H, L, 0);

  L := L * 10 div 8;
  clHighlight2 := ColorHLSToRGB(H, L, S);
  clDisabled2 := ColorHLSToRGB(H, L, 0);

  TitleColor := TitleColors[IsSystemStyle];
  BkColor := StyleServices(Self).GetSystemColor(BkColors[IsSystemStyle]);
  GridColor := StyleServices(Self).GetSystemColor(clGrayText);

  if IsSystemStyle then
    TextColor :=
      StyleServices(Self).GetSystemColor(clWindowText)
  else
    TextColor :=
      StyleServices(Self).GetStyleFontColor(sfTextLabelNormal);

  ProcessChart(ChartCPU);
  ProcessChart(ChartRAM);
  ProcessChart(ChartVMs);
end;

procedure TWinBoxMain.DeleteVM(DeleteFiles: boolean);
var
  FItemIndex: integer;
  FWorkingDirectory: string;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    if not IsSelectedVM then
      exit;

    FItemIndex := List.ItemIndex;

    if FItemIndex < List.Count - 1 then
      List.ItemIndex := FItemIndex + 1
    else
      List.ItemIndex := 0;

    ListClick(Self);
    with Profiles[FItemIndex - 2] do begin
      FWorkingDirectory := ExcludeTrailingPathDelimiter(WorkingDirectory);
      DeleteFiles := DeleteFiles and not EraseProt;
      T86BoxProfile.Delete(ProfileID);
    end;

    acUpdateList.Execute;

    if (FWorkingDirectory <> '') and DeleteFiles then begin
      if not DeleteWithShell(FWorkingDirectory) and (MessageBox(0,
          _P(UnableToDelete), PChar(Application.Title),
          MB_ICONINFORMATION or MB_YESNO) = mrYes) then
        ShellExecute(0, 'open', PChar(FWorkingDirectory), nil, nil, SW_SHOWNORMAL);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TWinBoxMain.UMDoFirstUpdate(var Msg: TMessage);
begin
  inherited;
  if (Msg.LParam = 7) and (Msg.WParam = 13) and Assigned(WinBoxSplash) then
    try //Validity Test
      List.Enabled := true;
      Pages.Enabled := true;

      Screen.Cursor := crDefault;

      WinBoxSplash.OnClose := nil;
      WinBoxSplash.Close;
      FreeAndNil(WinBoxSplash);

      if IsAllStopped and Updater.AskAutoUpdate then
        Updater.ShowModal;
    finally
      FirstUpdateDone := true;
    end;
end;

procedure TWinBoxMain.UMIconsChanged(var Msg: TMessage);
begin
  inherited;
  IconSet.IconsMaxDPI.GetIcon(6, DeleteDialog.CustomMainIcon);
  IconSet.LoadImage(ImgWelcomeLogo, ImgWelcome,
    DefScaleOptions - [soBiDiRotate, soOverScale]);

  DefProfile.Icon.Assign(
    IconSet.ActionImages.Images[21].SourceImages[0].Image);

  if Assigned(Profiles) then
    ListReload(Self);
end;

procedure TWinBoxMain.DummyUpdate(Sender: TObject);
begin
  ;
end;

procedure TWinBoxMain.acUpdateListExecute(Sender: TObject);
var
  State: boolean;
begin
  State := Monitor.Enabled;
  Monitor.Enabled := false;
  try
    Profiles.Reload(Monitor);
  finally
    Monitor.Enabled := State;
  end;
end;

procedure TWinBoxMain.acUpdateToolsExecute(Sender: TObject);
var
  I: integer;
  M: TMenuItem;
begin
  miUserTools.Clear;
  for I := Config.Tools.Count - 1 downto 0 do begin
    M := TMenuItem.Create(miUserTools);
    M.Caption := Config.Tools.Names[I];
    M.Hint := Config.Tools.ValueFromIndex[I];
    M.OnClick := UserToolClick;

    miUserTools.Add(M);
  end;
  miUserTools.Visible := miUserTools.Count > 0;
  miSepUserTools.Visible := miUserTools.Visible;
end;

procedure TWinBoxMain.acURLExecute(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar((Sender as TMenuItem).Hint), nil, nil, SW_SHOWNORMAL);
end;

procedure TWinBoxMain.FlipBiDi;
begin
  SetCommCtrlBiDi(Handle, LocaleIsBiDi);

  HomeMenu.BiDiMode := BiDiModes[LocaleIsBiDi];
  PerfMenu.BiDiMode := BiDiModes[LocaleIsBiDi];
  VMMenu.BiDiMode := BiDiModes[LocaleIsBiDi];

  IconSet.RefreshImages;

  SetCommCtrlBiDi(List.Handle, LocaleIsBiDi);
  SetCommCtrlBiDi(StatusBar.Handle, LocaleIsBiDi);

  if LocaleIsBiDi then begin
    MissingDiskDlg.Flags := MissingDiskDlg.Flags + [tfRtlLayout];
    DeleteDialog.Flags := DeleteDialog.Flags + [tfRtlLayout];
  end
  else begin
    MissingDiskDlg.Flags := MissingDiskDlg.Flags - [tfRtlLayout];
    DeleteDialog.Flags := DeleteDialog.Flags - [tfRtlLayout];
  end;

  SetCommCtrlBiDi(tabHome.Handle, LocaleIsBiDi);
  SetCommCtrlBiDi(tabPerfMon.Handle, LocaleIsBiDi);

  SetCommCtrlBiDi(tabCPU.Handle, false);
  SetCommCtrlBiDi(tabRAM.Handle, false);
  SetCommCtrlBiDi(tabVMs.Handle, false);

  SetCommCtrlBiDi(tbGlobal.Handle, LocaleIsBiDi);
  SetCommCtrlBiDi(tbVMs.Handle, LocaleIsBiDi);

  Frame86Box.FlipBiDi;
end;

procedure TWinBoxMain.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI,
  NewDPI: Integer);
begin
  IconSet.Initialize(Self);
  Perform(UM_ICONSETCHANGED, 0, 0);

  //az Align visszadobja, de szükséges mert eltûnnek a gombok a szélérõl váltáskor
  tbVMs.Width := tbVMs.Width + 1;

  if Assigned(Profiles) then
    ListReload(Self);
end;

procedure TWinBoxMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Config.TrayBehavior = 3 then begin
    WindowState := wsMinimized;
    Hide;
    Action := caNone;
  end;
end;

procedure TWinBoxMain.FormCreate(Sender: TObject);
var
  I: integer;
begin
  //GUI part
  InitialTitle := Application.Title;

  IconSet.Initialize(Self);
  List.Constraints.MinWidth := IconSet.ListIcons.Width * 3 div 2;

  for I := 0 to Pages.PageCount - 1 do
    Pages.Pages[I].TabVisible := false;
  Pages.ActivePageIndex := 0;
  pgCharts.ActivePageIndex := 0;

  miDebug.Visible := IsDebuggerPresent;

  Frame86Box := TFrame86Box.Create(nil);
  with Frame86Box do begin
    Parent := tab86Box;
    Align := alClient;
    //csak úgy scalel a TCategoryGroup ha nyitva van alapból -> be kell csukni itt
    for I := 0 to cgPanels.Panels.Count - 1 do
      if cgPanels.Panels[I] <> cpSystem then
        (TObject(cgPanels.Panels[I]) as TCategoryPanel).Collapsed := true;
  end;

  //mentsük el a form skálázott tervezési pozícióját
  DefaultSize := Point(Width, Height);

  Locale := '-'; //cseréljük ki az alapérték '' nyelvet akármire
  if LocaleOverride = '' then
    ChangeLanguage(Config.ProgramLang) //azért hogy ez végigfusson
  else
    ChangeLanguage(LocaleOverride);

  ChangeStyle(Config.StyleName, 0);
  Perform(CM_STYLECHANGED, 0, 0);

  //töltsük be az ikonkészletet, majd tükrözzük meg a képeket
  //  és tiltsuk le a színeket ha szükséges
  ChangeIconSet(Config.ProgIconSet);

  Application.CreateForm(TWinBoxUpd, WinBoxUpd);

  tbVMs.ShowCaptions := true;
  tbGlobal.ShowCaptions := true;

  DeleteDialog.Caption := Application.Title;
  MissingDiskDlg.Caption := Application.Title;

  Updater := TUpdaterDlg.Create(nil);

  //Internal part
  FirstUpdateDone := false;
  UpdateCount := 0;

  Monitor := T86BoxMonitor.Create(false);
  Monitor.OnChange := MonitorChange;
  Monitor.OnUpdate := MonitorUpdate;

  Icons := TObjectList<TWICImage>.Create;

  Profiles := T86BoxProfiles.Create;
  Profiles.OnReload := ListReload;
  Profiles.Reload(Monitor);

  Monitor.Enabled := true;
end;

procedure TWinBoxMain.FormDestroy(Sender: TObject);
var
  TrayData: TNotifyIconData;
begin
  TrayData := TrayIcon.Data;
  Shell_NotifyIcon(NIM_DELETE, @TrayData);

  Updater.Free;

  Icons.Free;
  Profiles.Free;
  Monitor.Free;
  Frame86Box.Free;
end;

procedure TWinBoxMain.FormResize(Sender: TObject);
begin
  //List.Width := Round(ClientWidth * SideRatio);
end;

procedure TWinBoxMain.FormShow(Sender: TObject);
begin
  TrayIcon.Visible := Config.TrayBehavior > 0;
  acUpdateToolsExecute(Self);

  //pozícionáljuk a formot és a framet a beállítások szerint
  // (csak itt lehet, az OnCreate eseményben még nem,
  //  és csak akkor ha nem a ProgramSettings hívja meg)
  if Sender = Self then
    ChangePosition(Config.PositionData);
end;

procedure TWinBoxMain.ListClick(Sender: TObject);
var
  Success: boolean;
begin
  IsSelectedVM := (List.ItemIndex - 2 < Profiles.Count) and (List.ItemIndex - 2 >= 0);

  case List.ItemIndex of
    -1: Pages.ActivePageIndex := 0;
    0, 1: Pages.ActivePageIndex := List.ItemIndex;
    else if IsSelectedVM then begin
      Pages.ActivePageIndex := 2;
      Frame86Box.UpdateFull(Profiles[List.ItemIndex - 2]);
    end;
    (*else begin
      Core.ItemIndex := List.ItemIndex - 2;

      Core.FolderMonitor.Folder := Core.Profiles[Core.ItemIndex].WorkingDirectory;
      if not DirectoryExists(Core.FolderMonitor.Folder) then
        case MessageBox(Handle, _P('StrTheVirtualMachine'),
               PChar(Application.Title), MB_ICONQUESTION or MB_YESNO) of
          mrYes:
            with Core do begin
              TWinBoxProfile.DeleteProfile(Profiles[ItemIndex].ProfileID,
                                           Profiles[ItemIndex].SectionKey);
              ReloadProfiles(Self);
              exit;
            end
          else ForceDirectories(Core.FolderMonitor.Folder);
        end;

      //Core.FolderMonitor.Active := true;

      //Pages.ActivePageIndex := Core.Profiles[Core.ItemIndex].Tag;
      //(Pages.ActivePage.Controls[0] as IWinBoxFrame).UpdateFull;    *)
  //  end;
  end;

  Success := LockWindowUpdate(Handle);
  try
    tbVMs.Visible := List.ItemIndex > 1;
    tbGlobal.Visible := not tbVMs.Visible;
  finally
    if Success then begin
      LockWindowUpdate(0);
      Invalidate;
    end;
  end;
end;

procedure TWinBoxMain.ListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  Mouse: TPoint;
begin
  Handled := GetCursorPos(Mouse);
  if Handled then
    case List.ItemIndex of
      0: HomeMenu.Popup(Mouse.X, Mouse.Y);
      1: PerfMenu.Popup(Mouse.X, Mouse.Y);
      else VMMenu.Popup(Mouse.X, Mouse.Y);
    end;
end;

procedure TWinBoxMain.ListDblClick(Sender: TObject);
begin
  if IsSelectedVM then
    with Profiles[List.ItemIndex - 2] do
      case State of
        PROFILE_STATE_STOPPED: Start();
        else BringToFront();
      end;
end;

procedure TWinBoxMain.ListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  StateText: string;
  IconLeft, TextLeft: integer;
begin
  try
    with IconSet, Control as TListBox, Canvas do
      with StyleServices(Self) do begin
        if Enabled and (odSelected in State) then begin
          Brush.Color := GetSystemColor(clHighlight);
          Font.Color  := GetSystemColor(clHighlightText);
          GradientFillCanvas(Canvas, clHighlight2, clHighlight1, Rect, gdVertical);
        end
        else if (odSelected in State) then begin
          Brush.Color := GetSystemColor(cl3DDkShadow);
          Font.Color  := GetSystemColor(cl3DLight);
          GradientFillCanvas(Canvas, clDisabled2, clDisabled1, Rect, gdVertical);
        end
        else begin
          Brush.Color := GetSystemColor(clWindow);
          Font.Color  := GetSystemColor(clWindowText);
          FillRect(Rect);
        end;

      Brush.Style := bsClear;

      TextLeft := Rect.Left + ListIcons.Width + 2 * BorderThickness + 1;
      IconLeft := Rect.Left + BorderThickness;

      HalfCharHeight := TextHeight('Wg') div 2;
      if Index < 2 then begin
        ListIcons.Draw(Canvas, IconLeft,
                        Rect.Top + BorderThickness, Index);

        Font.Style := [fsBold];
        TextOut(TextLeft,
                (Rect.Top + Rect.Bottom) div 2 - HalfCharHeight,
                Items[Index]);
      end
      else begin
          Draw(IconLeft,
               Rect.Top + BorderThickness,
               Icons[Index - 2]);

          Font.Style := [fsBold];
          TextOut(TextLeft,
                  Rect.Top + (Rect.Bottom - Rect.Top) div 3 - HalfCharHeight,
                  Items[Index]);

          Font.Style := [];
          StateText := _T(format(StrState, [Profiles[Index - 2].State]));
          TextOut(TextLeft,
                  Rect.Top + (Rect.Bottom - Rect.Top) div 3 * 2 - HalfCharHeight,
                  StateText);
      end;
    end;
  except
    List.OnDrawItem := nil;
    raise;
  end;
end;

procedure TWinBoxMain.ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT,
             VK_HOME, VK_END, VK_PRIOR, VK_NEXT] then
    IsSelectedVM := false;
end;

procedure TWinBoxMain.ListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not IsSelectedVM then
    ListClick(Self);
end;

procedure TWinBoxMain.ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TempIndex: integer;
  Handled: boolean;
begin
  TempIndex := List.ItemIndex;
  List.ItemIndex := List.ItemAtPos(Point(X, Y), true);
  if (List.ItemIndex = -1) and (TempIndex >= 0) and (TempIndex < List.Count) then
    List.ItemIndex := TempIndex;

  ListClick(List);

  //Megoldja azt a bugot, hogy BiDi-módban nem mûködik a List.ContextPopup
  Handled := false;
  if (Button = mbRight) and LocaleIsBiDi then
    ListContextPopup(Sender, Point(X, Y), Handled);
end;

procedure TWinBoxMain.ListReload(Sender: TObject);
var
  Profile: T86BoxProfile;
  State: boolean;
  Item: string;
  Image: TWICImage;
  cTemp: TColor;
begin
  State := Monitor.Enabled;
  Monitor.Enabled := false;
  try
    with List, Items do begin
      if ItemIndex <> -1 then
        Item := Items[ItemIndex]
      else
        Item := '';

      BeginUpdate;
      Icons.Clear;
      Clear;
      ResetChart(ChartCPU);
      ResetChart(ChartRAM);
      Add(tabHome.Caption);
      Add(tabPerfMon.Caption);
      for Profile in Profiles do begin
        Add(Profile.FriendlyName);
        Profile.OnChange := ProfileChange;

        Image := TWICImage.Create;
        if Profile.HasIcon then
          Image.Assign(Profile.Icon)
        else
          Image.Assign(DefProfile.Icon);

        ScaleWIC(Image,
          IconSet.ListIcons.Width,
          IconSet.ListIcons.Height,
          DefScaleOptions - [soBiDiRotate, soOverScale]);

        Icons.Add(Image);

        cTemp := RGB(random($100), random($100), random($100));
        AddSeries(ChartCPU, cTemp, Profile.FriendlyName);
        AddSeries(ChartRAM, cTemp, Profile.FriendlyName);
      end;
      EndUpdate;

      if Item <> '' then
        ItemIndex := IndexOf(Item)
      else
        ItemIndex := 0;

      ListClick(Sender);

      ResetChart(ChartVMs);
      AddSeries(ChartVMs, clRed, Pages.Pages[2].Caption);
    end;
  finally
    Monitor.Enabled := State;
    MonitorChange(Sender);
  end;
end;

procedure TWinBoxMain.MonitorChange(Sender: TObject);
var
  State: boolean;
  P: T86BoxProfile;
begin
  State := Monitor.Enabled;
  Monitor.Enabled := false;
  try
    Profiles.UpdatePIDs;

    IsAllStopped := true;
    for P in Profiles do
      if P.State <> PROFILE_STATE_STOPPED then begin
        IsAllStopped := false;
        break;
      end;

    IsAnyRunning := not IsAllStopped;

    List.Invalidate;
  finally
    Monitor.Enabled := State;
  end;
end;

procedure TWinBoxMain.MonitorUpdate(Sender: TObject);
begin
  if UpdateCount > 2 then begin
    if not miDebug.Visible then
      Monitor.OnUpdate := DummyUpdate
    else
      Monitor.OnUpdate := nil;

    PostMessage(Handle, UM_DOFIRSTUPDATE, 13, 7);
  end
  else
    inc(UpdateCount);
end;

procedure TWinBoxMain.ProfileChange(Sender: TObject);
begin
  List.Invalidate;
end;

procedure TWinBoxMain.ResetChart(Chart: TChart);
begin
  Chart.RemoveAllSeries;
  Chart.Axes.Bottom.Scroll(60 - Chart.Axes.Bottom.Maximum);
end;

procedure TWinBoxMain.SplitterMoved(Sender: TObject);
begin
  Constraints.MinWidth :=
    List.Width +
    Frame86Box.RightPanel.Constraints.MinWidth +
    50 * CurrentPPI div 96;

  Perform(WM_ENTERSIZEMOVE, 0, 0);
end;

procedure TWinBoxMain.tmrUpdateTimer(Sender: TObject);
var
  I: integer;
  CPU, RAM, Temp: extended;
  RAMBytes: uint64;
  VMs, FState: integer;
begin
  if not FirstUpdateDone then
    exit;

  try
    if Visible and (Pages.ActivePageIndex = 2) and IsSelectedVM then
      Frame86Box.UpdateDelta(Profiles[List.ItemIndex - 2]);

    CPU := 0; RAM := 0;
    VMs := 0; RAMBytes := 0;

    for I := 0 to Profiles.Count - 1 do
      with Profiles[I] do begin
        FState := State;
        if FState <> 0 then begin
          inc(VMs);

          Temp := PercentCPU;
          CPU := CPU + Temp;
          AddValue(ChartCPU.Series[I] as TFastLineSeries, Temp);

          Temp := PercentRAM;
          RAM := RAM + Temp;
          AddValue(ChartRAM.Series[I] as TFastLineSeries, Temp);

          RAMBytes := RAMBytes + BytesOfRAM;

          case FState of
            PROFILE_STATE_PAUSED,
            PROFILE_STATE_RUNNING: UpdateState;
            PROFILE_STATE_RUN_PENDING: UpdatePending;
          end;
        end
        else begin
          AddValue(ChartCPU.Series[I] as TFastLineSeries, 0);
          AddValue(ChartRAM.Series[I] as TFastLineSeries, 0);
        end;
      end;

    AddValue(ChartVMs.Series[0] as TFastLineSeries, VMs);

    lbHRAM.Caption := _T('WinBox.HostRAM', [RAM, FileSizeToStr(RAMBytes, 2)]);
    pbRAM.Position := Round(RAM);
    ColorProgress(pbRAM);

    lbHCPU.Caption := _T('WinBox.HostCPU', [CPU]);
    pbCPU.Position := Round(CPU);
    ColorProgress(pbCPU);
  except
    with (Sender as TTimer) do begin
      Enabled := false;
      OnTimer := nil;
    end;
    raise;
  end;
end;

procedure TWinBoxMain.GetRttiReport(Result: TStrings);
var
  Context: TRttiContext;
  Field: TRttiField;

  I: integer;
  Temp: string;

  procedure DumpProfile(const Profile: T86BoxProfile);
  var
    Field, SubField: TRttiField;
    Value: TValue;
  begin
    for Field in (Context.GetType(T86BoxProfile) as TRttiInstanceType).GetFields do begin
      Value := Field.GetValue(Profile);
      case Field.FieldType.TypeKind of
        tkRecord: begin
                    Result.Add(#9#9 + Field.Name + '=(');
                    for SubField in Context.GetType(Value.TypeInfo).AsRecord.GetFields do
                      if (SubField.Name = 'Serial') or (SubField.Name = 'Parallel') then
                        Result.Add(#9#9#9 + SubField.Name + '=?')
                      else
                        try
                          Result.Add(#9#9#9 + SubField.Name + '=' +
                                     SubField.GetValue(Value.GetReferenceToRawData).ToString);
                        except
                          Result.Add(#9#9#9 + SubField.Name + '=?');
                        end;
                    Result.Add(#9#9');');
                  end;
        else
          Result.Add(#9#9 + Field.Name + '=' + Value.ToString);
      end;
    end;
  end;

begin
  Context := TRttiContext.Create;
  Result.Add('Config=(');
  for Field in (Context.GetType(TConfiguration) as TRttiInstanceType).GetFields do begin
    Result.Add(#9 + Field.Name + '=' + Field.GetValue(Config).ToString);
    if Field.Name = 'DisplayValues' then begin
      Result.Add(#9'DisplayValues.Items=(');
      for Temp in Config.DisplayValues do
        Result.Add(#9#9 + Temp);
      Result.Add(#9');');
    end;

    if Field.Name = 'Tools' then begin
      Result.Add(#9'Tools.Items=(');
      for Temp in Config.Tools do
        Result.Add(#9#9 + Temp);
      Result.Add(#9');');
    end;
  end;
  Result.Add(');');

  Result.Add('');
  Result.Add('WinBoxMain=(');
  for Field in (Context.GetType(TWinBoxMain) as TRttiInstanceType).GetFields do
    if Field.Name = 'Profiles' then
      for I := 0 to Profiles.Count - 1 do begin
        Result.Add(#9'Profiles[' + IntToStr(I) + ']=(');
        DumpProfile(Profiles[I]);
        Result.Add(#9#9'GetFileVer(ExecutablePath)=' + GetFileVer(Profiles[I].ExecutablePath));
        Result.Add(#9');');
      end
    else begin
      Result.Add(#9 + Field.Name + '=' + Field.GetValue(Self).ToString);
      if Field.Name = 'List' then begin
        Result.Add(#9'List.ItemIndex=' + IntToStr(List.ItemIndex));
        Result.Add(#9'List.Items.Count=' + IntToStr(List.Items.Count));
      end;
    end;
  Result.Add(');');
  Result.Add('');

  if Assigned(Frame86Box) then
    Frame86Box.GetRttiReport(Result);
end;

procedure TWinBoxMain.GetTranslation(Language: TLanguage);
var
  I: integer;
begin
  with Language do begin
    GetTranslation('WinBoxMain', Self);
    GetTranslation('Actions', Actions);
    GetTranslation('MainMenu', MainMenu.Items);
    GetTranslation('HomeMenu', HomeMenu.Items);
    GetTranslation('PerfMenu', PerfMenu.Items);
    GetTranslation('VMMenu', VMMenu.Items);

    for I := 0 to DeleteDialog.Buttons.Count - 1 do
      with DeleteDialog.Buttons[I] as TTaskDialogButtonItem do begin
        GetTranslation(StrDeleteDialog + format('.Buttons[%d]', [I]), Caption);
        GetTranslation(StrDeleteDialog + format('.Buttons[%d].Hint', [I]), CommandLinkHint);
      end;

    GetTranslation(StrDeleteDialog + '.Title', DeleteDialog.Title);
    GetTranslation(StrDeleteDialog + '.FooterText', DeleteDialog.FooterText);
  end;
end;

procedure TWinBoxMain.Translate;
var
  I: integer;
begin
  with Language do begin
    SetThreadUILanguage(GetLCID(Locale));

    Caption := InitialTitle;
    Translate('WinBoxMain', Self);
    Application.Title := Caption;

    Translate('Actions', Actions);
    Translate('MainMenu', MainMenu.Items);
    Translate('HomeMenu', HomeMenu.Items);
    Translate('PerfMenu', PerfMenu.Items);
    Translate('VMMenu', VMMenu.Items);

    SaveBmp.Filter := _T('OpenDialog.BmpImage');
    SaveEmf.Filter := _T('OpenDialog.EmfImage');
    SaveLogDialog.Filter := _T(OpenDlgLogFiles);

    for I := 0 to DeleteDialog.Buttons.Count - 1 do
      with DeleteDialog.Buttons[I] as TTaskDialogButtonItem do begin
        Caption := _T(StrDeleteDialog + format('.Buttons[%d]', [I]));
        CommandLinkHint := _T(StrDeleteDialog + format('.Buttons[%d].Hint', [I]));
      end;
    DeleteDialog.Title := _T(StrDeleteDialog + '.Title');
    DeleteDialog.FooterText := _T(StrDeleteDialog + '.FooterText');

    for I := 0 to MissingDiskDlg.Buttons.Count - 1 do
      with MissingDiskDlg.Buttons[I] as TTaskDialogButtonItem do
        Caption := _T(StrMissingDiskDlg + format('.Buttons[%d]', [I]));
    MissingDiskDlg.Title := _T(StrMissingDiskDlg + '.Title');
    MissingDiskDlg.FooterText := _T(StrMissingDiskDlg + '.FooterText');

    ChartCPU.Title.Text.Text := _T(format(StrChartBase, ['CPU']));
    ChartCPU.BottomAxis.Title.Caption := _T(format(StrChartAxisBase, ['CPU', 'X']));
    ChartCPU.LeftAxis.Title.Caption := _T(format(StrChartAxisBase, ['CPU', 'Y']));

    ChartRAM.Title.Text.Text := _T(format(StrChartBase, ['RAM']));
    ChartRAM.BottomAxis.Title.Caption := _T(format(StrChartAxisBase, ['RAM', 'X']));
    ChartRAM.LeftAxis.Title.Caption := _T(format(StrChartAxisBase, ['RAM', 'Y']));

    ChartVMs.Title.Text.Text := _T(format(StrChartBase, ['VMs']));
    ChartVMs.BottomAxis.Title.Caption := _T(format(StrChartAxisBase, ['VMs', 'X']));
    ChartVMs.LeftAxis.Title.Caption := _T(format(StrChartAxisBase, ['VMs', 'Y']));
  end;
end;

procedure TWinBoxMain.TrayIconDblClick(Sender: TObject);
begin
  Show;
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TWinBoxMain.UserToolClick(Sender: TObject);
begin
  if Sender is TMenuItem then
    with Sender as TMenuItem do
      ShellExecute(Handle, 'open', PChar(Hint), nil,
                   PChar(ExtractFileDir(Hint)), SW_SHOWNORMAL);
end;

procedure TWinBoxMain.WMEnterSizeMove(var Msg: TMessage);
begin
  if (List.Width <> 0) and (ClientWidth <> 0) then
    SideRatio := List.Width / ClientWidth
  else
    SideRatio := Defaults.PositionData.MainRatio / 100;

  if Assigned(Frame86Box) then
    Frame86Box.OnEnterSizeMove(Self);

  inherited;
end;

procedure TWinBoxMain.WMSettingChange(var Msg: TMessage);
begin
  if (Msg.LParam <> 0) and
     (PChar(Pointer(Msg.LParam)) = 'ImmersiveColorSet') and
     IconSet.UpdateDarkMode and
     (Config.StyleName = '') then
    //ChangeStyle('', -1); bugos szar a témaváltás runtime
    MessageBox(Handle, _P(StrDeferStyleChange),
      PChar(Application.Title), MB_ICONINFORMATION or MB_OK);

  inherited;
end;

procedure TWinBoxMain.pnpBottomResize(Sender: TObject);
begin
  pnpRight.Width := pnpBottom.ClientWidth div 2;
end;

{ TListBox }

procedure TListBox.CNDrawItem(var Msg: TWMDrawItem);
begin
  with Msg.DrawItemStruct^ do
    itemState := itemState and not ODS_FOCUS;
  inherited;
end;

{ TToolBar }

procedure TToolBar.WMPaint(var Msg: TWMPaint);
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

initialization
  Include(JclStackTrackingOptions, stRawMode);
  Include(JclStackTrackingOptions, stStaticModuleList);
  JclStartExceptionTracking;

finalization
  JclStopExceptionTracking;

end.
