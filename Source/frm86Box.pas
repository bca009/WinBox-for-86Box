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

unit frm86Box;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Buttons, ComCtrls, ExtCtrls, StdCtrls, uFolderMon,
  uPicturePager, u86Box, uLang;

type
  TCategoryPanel =  class(ExtCtrls.TCategoryPanel)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TCategoryPanelGroup = class(ExtCtrls.TCategoryPanelGroup)
  protected
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
  end;

  TFrame86Box = class(TFrame, ILanguageSupport)
    cgPanels: TCategoryPanelGroup;
    cpPorts: TCategoryPanel;
    lbParallel: TLabel;
    lbSerialDesc: TLabel;
    lbSerial: TLabel;
    lbParallelDesc: TLabel;
    cpInput: TCategoryPanel;
    edJoystick: TEdit;
    lbMouseDesc: TLabel;
    edMouse: TEdit;
    lbJoystickDesc: TLabel;
    cpNetwork: TCategoryPanel;
    edNetType: TEdit;
    lbNetCardDesc: TLabel;
    edNetCard: TEdit;
    lbNetTypeDesc: TLabel;
    cpStorage: TCategoryPanel;
    edSCSI: TEdit;
    lbCDROM: TLabel;
    lbHDD: TLabel;
    lbFloppy: TLabel;
    lbFloppyDesc: TLabel;
    lbHDDDesc: TLabel;
    lbCDROMDesc: TLabel;
    lbSCSIDesc: TLabel;
    lbExStorDesc: TLabel;
    lbExStor: TLabel;
    cpSound: TCategoryPanel;
    edMidi: TEdit;
    lbSndCardDesc: TLabel;
    edSndCard: TEdit;
    lbMidiDesc: TLabel;
    cpVideo: TCategoryPanel;
    ed3dfx: TEdit;
    lbGfxCardDesc: TLabel;
    edGfxCard: TEdit;
    lb3dfxDesc: TLabel;
    cpSystem: TCategoryPanel;
    edEmulator: TEdit;
    lbMachineDesc: TLabel;
    edMachine: TEdit;
    lbMemoryDesc: TLabel;
    lbMemory: TLabel;
    edCPU: TEdit;
    lbCPUDesc: TLabel;
    lbEmulatorDesc: TLabel;
    bvBottom: TBevel;
    btnPrinter: TButton;
    lbStateDesc: TLabel;
    RightPanel: TPanel;
    lbHostCPU: TLabel;
    lbHostCPUDesc: TLabel;
    lbHostMemoryRAM: TLabel;
    lbHostRAM: TLabel;
    lbScreenshots: TLabel;
    lbDiskSizeDesc: TLabel;
    lbDiskSize: TLabel;
    pbHostCPU: TProgressBar;
    pbHostRAM: TProgressBar;
    btnImgNext: TButton;
    btnImgPrev: TButton;
    edState: TEdit;
    bvScreenshots: TBevel;
    lbNone: TLabel;
    TopPanel: TPanel;
    lbFriendlyName: TLabel;
    btnWorkDir: TSpeedButton;
    Splitter: TSplitter;
    DelayChange: TTimer;
    procedure cgPanelsResize(Sender: TObject);
    procedure PicturePagerContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure FrameResize(Sender: TObject);
    procedure PicturePagerClick(Sender: TObject);
    procedure btnWorkDirClick(Sender: TObject);
    procedure DelayChangeTimer(Sender: TObject);
  private
    DirectoryChange: string;
    DirectoryChgType: Cardinal;

    procedure CMStyleChanged(var Msg: TMessage); message CM_STYLECHANGED;
  public
    PicturePager: TPicturePager;
    FolderMonitor: TFolderMonitor;
    SideRatio: single;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure UpdateColor(const Profile: T86BoxProfile);
    procedure UpdateFull(const Profile: T86BoxProfile);
    procedure UpdateData(const Profile: T86BoxProfile);
    procedure UpdateDelta(const Profile: T86BoxProfile);

    procedure OnDirectoryChange(Sender: TObject; FileName: string;
      ChangeType: Cardinal);

    procedure OnEnterSizeMove(Sender: TObject);
    procedure GetRttiReport(Result: TStrings);

    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;
  end;

resourcestring
  StrCPUD = '%.0f%%';
  StrMemoryD = '%.0f%% (%s)';
  Str86BoxVersionStr = '86Box %s';

const
  DefSideRatio = 0.36;

var
  dbgLogFolderChanges: boolean = false;

implementation

uses uCommUtil, uCommText, frmMainForm, ShellAPI, Rtti,
     dmGraphUtil, Themes;

resourcestring
  StrWorkDirRemoved = 'WinBox.WorkDirRemoved';

{$R *.dfm}

{ Tfrm86Box }

procedure TFrame86Box.btnWorkDirClick(Sender: TObject);
begin
  ForceDirectories((Sender as TControl).Hint);
  ShellExecute(Handle, 'open',
    PChar(ExcludeTrailingPathDelimiter((Sender as TControl).Hint)),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TFrame86Box.cgPanelsResize(Sender: TObject);
var
  Success: boolean;
  Panel: TCategoryPanel;
  Surface: TCategoryPanelSurface;
  Control: TControl;
  I, J, S: Integer;
begin
  S := lbSerialDesc.Canvas.TextHeight('Wg');
  with Sender as TCategoryPanelGroup do
    for I := 0 to Panels.Count - 1 do begin
      Panel := TObject(Panels[I]) as TCategoryPanel;
      Surface := Panel.Controls[0] as TCategoryPanelSurface;
      Success := LockWindowUpdate(Surface.Handle);
      try
        for J := 0 to Surface.ControlCount - 1 do begin
          Control := Surface.Controls[J];
          if Control is TEdit then begin
            Control.Width := ClientWidth - Control.Left;
            Control.Height := S;
          end;
        end;
      finally
        if Success then begin
          LockWindowUpdate(0);
          Invalidate;
        end;
      end;
    end;
end;

procedure TFrame86Box.CMStyleChanged(var Msg: TMessage);
var
  IsSystemStyle: boolean;
begin
  IsSystemStyle := StyleServices.IsSystemStyle;
  TStyleManager.FixHiddenEdits(cgPanels, true, IsSystemStyle);

  if IsSystemStyle then begin
    Color := clWindow;
    Font.Color := clWindowText;
  end
  else begin
    Color :=
      TStyleManager.ActiveStyle.GetSystemColor(clBtnFace);
    Font.Color :=
      TStyleManager.ActiveStyle.GetStyleFontColor(sfTextLabelNormal);
  end;

  edState.ParentColor := true;
  edState.Font.Color := Font.Color;
end;

constructor TFrame86Box.Create(AOwner: TComponent);
begin
  inherited;
  SideRatio := DefSideRatio;

  SetWindowLongPtr(cgPanels.Handle, GWL_STYLE,
    GetWindowLongPtr(cgPanels.Handle, GWL_STYLE) and not WS_BORDER);

  PicturePager := TPicturePager.Create(nil);
  with PicturePager do begin
    ParentBiDiMode := false;
    BiDiMode := bdLeftToRight;
    Parent := RightPanel;
    with bvScreenshots do
      PicturePager.SetBounds(Left + 1, Top + 1, Width - 2, Height - 2);
    Anchors := [akLeft, akTop, akRight, akBottom];
    ButtonNext := btnImgNext;
    ButtonPrev := btnImgPrev;

    Stretch := smFixAspect;
    AspectX := 4;
    AspectY := 3;

    OnContextPopup := PicturePagerContextPopup;
    OnClick := PicturePagerClick;
  end;

  Perform(CM_STYLECHANGED, 0, 0);

  FolderMonitor := TFolderMonitor.Create(nil);
  FolderMonitor.OnChange := OnDirectoryChange;

  if dbgLogFolderChanges then
    Log('FolderMonitor initialized.');
end;

procedure TFrame86Box.DelayChangeTimer(Sender: TObject);
var
  Profile: T86BoxProfile;
begin
  DelayChange.Enabled := false;

  if WinBoxMain.IsSelectedVM then begin
    Profile := WinBoxMain.Profiles[WinBoxMain.List.ItemIndex - 2];
    Profile.OnDirectoryChange(Sender, DirectoryChange, DirectoryChgType);
    if (DirectoryChange = '86BOX.CFG') then begin
      if dbgLogFolderChanges then
        Log('Calling UpdateData');

      UpdateData(Profile);
    end
    else if DirectoryChange = 'PRINTER' then
      btnPrinter.Enabled := Profile.HasPrinterTray
    else if DirectoryChange = 'SCREENSHOTS' then
      PicturePager.UpdateList;
  end;

  DirectoryChange := '';
  DirectoryChgType := 0;
  DelayChange.Enabled := false;
end;

destructor TFrame86Box.Destroy;
begin
  FolderMonitor.Free;
  PicturePager.Free;
  inherited;
end;

procedure TFrame86Box.FlipBiDi;
begin
  SetCommCtrlBiDi(Handle, LocaleIsBiDi);
  SetCatPanelsBiDi(cgPanels, LocaleIsBidi);
end;

procedure TFrame86Box.FrameResize(Sender: TObject);
begin
  //RightPanel.ClientWidth := Round(ClientWidth * SideRatio);
end;

procedure TFrame86Box.GetRttiReport(Result: TStrings);
var
  Context: TRttiContext;
  Field: TRttiField;

  procedure DumpObject(const Name: string; AClass: TClass; Instance: Pointer);
  var
    Field: TRttiField;
  begin
    Result.Add(#9 + Name + '=(');
    for Field in (Context.GetType(AClass) as TRttiInstanceType).GetFields do
      Result.Add(#9#9 + Field.Name + '=' + Field.GetValue(Instance).ToString);
    Result.Add(#9');');
  end;

begin
  Context := TRttiContext.Create;
  Result.Add('Frame86Box=(');
  for Field in (Context.GetType(TFrame86Box) as TRttiInstanceType).GetFields do
    if Field.Name = 'PicturePager' then
      DumpObject('PicturePager', TPicturePager, PicturePager)
    else if Field.Name = 'FolderMonitor' then
      DumpObject('FolderMonitor', TFolderMonitor, FolderMonitor)
    else
      Result.Add(#9 + Field.Name + '=' + Field.GetValue(Self).ToString);

  Result.Add(');');
  Result.Add(' ');
end;

procedure TFrame86Box.PicturePagerClick(Sender: TObject);
var
  FileName: string;
begin
  FileName := '';

  if (PicturePager.ItemIndex >= 0) and (PicturePager.ItemIndex < PicturePager.Count) then
    FileName := PicturePager.FileName[PicturePager.ItemIndex];

  if FileExists(FileName) then
    ShellExecute(Handle, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrame86Box.PicturePagerContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  FileName: string;
begin
  Handled := true;
  FileName := '';

  if (PicturePager.ItemIndex >= 0) and (PicturePager.ItemIndex < PicturePager.Count) then
    FileName := PicturePager.FileName[PicturePager.ItemIndex];

  if FileExists(FileName) then
    ShowSysPopup(FileName, MousePos.X, MousePos.Y, RightPanel.Handle);
end;

procedure TFrame86Box.GetTranslation(Language: TLanguage);
begin
  Language.GetTranslation('Frame86Box', Self);
end;

procedure TFrame86Box.Translate;
begin
  Language.Translate('Frame86Box', Self);
end;

procedure TFrame86Box.OnDirectoryChange(Sender: TObject; FileName: string;
  ChangeType: Cardinal);
var
  I: integer;
begin
  FileName := UpperCase(FileName);
  I := pos(PathDelim, FileName);
  if I <> 0 then
    FileName := Copy(FileName, 1, I - 1);

  if dbgLogFolderChanges then
    Log('File Changed: %s', [FileName]);

  DirectoryChange := FileName;
  DirectoryChgType := ChangeType;
  DelayChange.Enabled := true;
end;

procedure TFrame86Box.OnEnterSizeMove(Sender: TObject);
begin
  if (RightPanel.Width <> 0) and (ClientWidth <> 0) then
    SideRatio := RightPanel.Width / ClientWidth
  else
    SideRatio := DefSideRatio;
end;

procedure TFrame86Box.UpdateColor(const Profile: T86BoxProfile);
var
  Success: boolean;
begin
  if not IconSet.IsColorsAllowed then
    exit;

  Success := LockWindowUpdate(Handle);
  try
    if Assigned(Profile) then
      with Profile do begin
        if Color = clNone then
          Self.Color := clWindow
        else
          Self.Color := Color;

        cgPanels.GradientBaseColor := Self.Color;
        cgPanels.GradientColor := Self.Color;

        Font.Color := GetTextColor(Color);
        edState.Font.Color := Font.Color;
        lbScreenshots.Font.Color := GetLinkColor(Color);

        cgPanels.ChevronColor := Font.Color;
        cgPanels.HeaderFont.Color := Font.Color;
      end;
  finally
    if Success then begin
      LockWindowUpdate(0);
      Invalidate;
    end;
  end;
end;

procedure TFrame86Box.UpdateData(const Profile: T86BoxProfile);
var
  Success: boolean;
begin
  Success := LockWindowUpdate(Handle);
  try
    if Assigned(Profile) then
      with Profile, ConfigData do begin
        edMachine.Text := Resolve('machine', Machine);

        if CPUSpeed < 10000000 then
          edCPU.Text := format('%s / %.2f MHz',
            [Resolve('cpu_family', CPUType), Trunc(CPUSpeed / 1e4) / 1e2])
        else
          edCPU.Text := format('%s / %d MHz',
            [Resolve('cpu_family', CPUType), CPUSpeed div 1000000]);

        lbMemory.Caption := FileSizeToStr(uint64(Memory) * 1024, 0);

        edEmulator.Hint := ExecutablePath;
        if FileExists(ExecutablePath) then
          edEmulator.Text := '86Box ' + GetFileVer(ExecutablePath)
        else
          edEmulator.Text := _T(StrUnknown);

        edGfxCard.Text := Resolve('gfxcard', GfxCard);
        if HasVoodoo then begin
          ed3dfx.Text := Resolve('voodoo', IntToStr(VoodooType));
          if SLI then
            ed3dfx.Text := ed3dfx.Text + ' SLI';
        end
        else
          ed3dfx.Text := Resolve('gfxcard', 'none');

        edSndCard.Text := Resolve('sndcard', SndCard);
        edMidi.Text := Resolve('midi_device', Midi);

        lbFloppy.Caption := Resolve('floppy', Floppy[1]) + ', ' +
                            Resolve('floppy', Floppy[2]);

        if LowerCase(Floppy[3]) <> 'none' then
          lbFloppy.Caption := lbFloppy.Caption + ', ...';

        lbHDD.Caption := ResolveIfEmpty(FormatHDDs);
        lbCDROM.Caption := ResolveIfEmpty(FormatCDROMs);
        lbExStor.Caption := ResolveIfEmpty(FormatExStors);
        edSCSI.Text := FormatSCSI(Resolve);

        edNetCard.Text := Resolve('net_card', NetCard);
        edNetType.Text := Resolve('net_type', NetType);

        edMouse.Text := Resolve('mouse_type', Mouse);
        edJoystick.Text := Resolve('joystick', Joystick);

        lbSerial.Caption := ResolveIfEmpty(FormatCOMs);
        lbParallel.Caption := ResolveIfEmpty(FormatLPTs);
      end;
  finally
    if Success then begin
      LockWindowUpdate(0);
      Invalidate;
    end;
  end;
end;

procedure TFrame86Box.UpdateDelta(const Profile: T86BoxProfile);
var
  Success: boolean;
  Temp: extended;

  procedure Empty;
  begin
    lbHostCPU.Caption := format(StrCPUD, [0.00]);
    pbHostCPU.Position := 0;

    lbHostRAM.Caption := format(StrMemoryD, [0.00, '0 B']);
    pbHostRAM.Position := 0;
  end;

begin
  Success := LockWindowUpdate(Handle);
  try
    edState.Tag := -1;

    if Assigned(Profile) then begin
      edState.Tag := Profile.State;

      if edState.Tag <> 0 then
        with Profile do begin
          Temp := PercentCPU;
          lbHostCPU.Caption := format(StrCPUD, [Temp]);
          pbHostCPU.Position := Round(Temp);
          ColorProgress(pbHostCPU);

          Temp := PercentRAM;
          lbHostRAM.Caption :=
            format(StrMemoryD, [Temp, FileSizeToStr(BytesOfRAM, 0)]);
          pbHostRAM.Position := Round(Temp);
          ColorProgress(pbHostRAM);
        end
      else
        Empty;

      lbDiskSize.Caption := FileSizeToStr(Profile.DiskSize, 2);
    end
    else
      Empty;

    edState.Text := _T(format(StrState, [edState.Tag]));
  finally
    if Success then begin
      LockWindowUpdate(0);
      Invalidate;
    end;
  end;
end;

procedure TFrame86Box.UpdateFull(const Profile: T86BoxProfile);
var
  HasWorkDir: boolean;
begin
  PicturePager.Folder := '';
  if dbgLogFolderChanges then
    Log('FolderMonitor deactivated.');
  FolderMonitor.Active := false;

  if Assigned(Profile) then
    with Profile, ConfigData do begin
      HasWorkDir := DirectoryExists(WorkingDirectory);

      if not HasWorkDir then begin
        if (MessageBox(Handle, _P(StrWorkDirRemoved),
            PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = mrYes) then begin
              WinBoxMain.DeleteVM(false);
              WinBoxMain.acUpdateList.Execute;
              exit;
        end
        else begin
          ForceDirectories(WorkingDirectory);
          WinBoxMain.acUpdateList.Execute;
          exit;
        end;
      end
      else begin
        if dbgLogFolderChanges then
          Log('FolderMonitor activation with "%s".', [WorkingDirectory]);

        FolderMonitor.Folder := WorkingDirectory;
        FolderMonitor.Active := true;
      end;

      with AspectRatio do begin
        PicturePager.AspectX := X;
        PicturePager.AspectY := Y;
      end;
      PicturePager.Folder := Screenshots;

      btnPrinter.Hint := Profile.PrinterTray;
      btnPrinter.Enabled := HasPrinterTray;

      btnWorkDir.Hint := Profile.WorkingDirectory;

      lbScreenshots.Hint := Screenshots;
      lbFriendlyName.Caption := FriendlyName;
    end;

  UpdateData(Profile);
  UpdateColor(Profile);
  UpdateDelta(Profile);
end;

{ TCategoryPanel }

constructor TCategoryPanel.Create(AOwner: TComponent);
begin
  inherited;
  BevelOuter := bvNone;
end;

{ TCategoryPanelGroup }

function TCategoryPanelGroup.DoMouseWheel(Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint): Boolean;
var
  I: Integer;
begin
  Result := PtInRect(ClientRect, ScreenToClient(MousePos));
  if Result then begin
    for I := 1 to Mouse.WheelScrollLines do
    try
      if WheelDelta > 0 then
        Perform(WM_VSCROLL, SB_LINEUP, 0)
      else
        Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    finally
      Perform(WM_VSCROLL, SB_ENDSCROLL, 0);
    end;
  end
  else
    inherited;
end;

end.
