(*

  WinBox for 86Box - An alternative manager for 86Box VMs

  Copyright (C) 2020-2021, Laci bá'

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this file,
  You can obtain one at http://mozilla.org/MPL/2.0/.

  The Original Code is from ExceptDlg.pas.
  The Original File is part of the Project JEDI Code Library (JCL).
                                                                                                   
  The Initial Developer of the Original Code is Petr Vones.                                        
  Portions created by Petr Vones are Copyright (C) of Petr Vones.

  Alternatively, the contents of this file may be used under the terms
  of the GNU General Public License Version v3, as described below:

  This file is free software: you may copy, redistribute and/or modify
  it under the terms of the GNU General Public License as published by the
  Free Software Foundation, either version v3 of the License, or (at your
  option) any later version.

  This file is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
  Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program. If not, see http://www.gnu.org/licenses/.

*)

unit frmErrorDialog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AppEvnts,
  JclSysUtils, JclUnitVersioning, JclUnitVersioningProviders, JclDebug,
  Vcl.ComCtrls, uLang;


const
  UM_CREATEDETAILS = WM_USER + $100;

type
  TExceptionDialog = class(TForm, ILanguageSupport)
    SaveBtn: TButton;
    OkBtn: TButton;
    DetailsBtn: TButton;
    BevelDetails: TBevel;
    DetailsMemo: TMemo;
    imgIcon: TImage;
    TextMemo: TScrollBox;
    lbMessage1: TLabel;
    lbMessage2: TLabel;
    TextLines: TMemo;
    procedure SaveBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DetailsBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FDetailsVisible: Boolean;
    FThreadID: DWORD;
    FLastActiveControl: TWinControl;
    FNonDetailsHeight: Integer;
    FFullHeight: Integer;
    function GetReportAsText: string;
    procedure SetDetailsVisible(const Value: Boolean);
    procedure UMCreateDetails(var Message: TMessage); message UM_CREATEDETAILS;
  protected
    procedure AfterCreateDetails; dynamic;
    procedure BeforeCreateDetails; dynamic;
    procedure CreateDetails; dynamic;
    procedure CreateReport;
    function ReportMaxColumns: Integer; virtual;
    function ReportNewBlockDelimiterChar: Char; virtual;
    procedure NextDetailBlock;
    procedure UpdateTextMemoScrollBars;
  public
    procedure CopyReportToClipboard;
    class procedure ExceptionHandler(Sender: TObject; E: Exception);
    class procedure ExceptionThreadHandler(Thread: TJclDebugThread);
    class procedure ShowException(E: TObject; Thread: TJclDebugThread);
    property DetailsVisible: Boolean read FDetailsVisible
      write SetDetailsVisible;
    property ReportAsText: string read GetReportAsText;

    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
  end;

  TExceptionDialogClass = class of TExceptionDialog;

var
  ExceptionDialogClass: TExceptionDialogClass = TExceptionDialog;

implementation

{$R *.dfm}

uses
  ClipBrd, Math, uCommUtil, uCommText,
  JclBase, JclFileUtils, JclHookExcept, JclPeImage, JclStrings, JclSysInfo, JclWin32,
  frmMainForm;

resourcestring
  RsExceptionClass = 'Exception class: %s';
  RsExceptionMessage = 'Exception message: %s';
  RsExceptionAddr = 'Exception address: %p';
  RsStackList = 'Stack list, generated %s';
  RsModulesList = 'List of loaded modules:';
  RsOSVersion = 'System   : %s %s, Version: %d.%d, Build: %x, "%s", Language: %s';
  RsProcessor = 'Processor: %s, %s, %d MHz';
  RsMemory = 'Memory: %d; free %d';
  RsScreenRes = 'Display  : %dx%d pixels, %d bpp, %d DPI';
  RsActiveControl = 'Active Controls hierarchy:';
  RsThread = 'Thread: %s';
  RsMissingVersionInfo = '(no module version info)';
  RsExceptionStack = 'Exception stack';
  RsMainThreadID = 'Main thread ID = %d';
  RsExceptionThreadID = 'Exception thread ID = %d';
  RsMainThreadCallStack = 'Call stack for main thread';
  RsThreadCallStack = 'Call stack for thread %d %s "%s"';
  RsExceptionThreadCallStack = 'Call stack for exception thread %s';
  RsDetailsIntro = #13#10#13#10' Application Title: %s' + NativeLineBreak +
                   ' Application File: %s' + NativeLineBreak +
                   ' Command Line: %s' + NativeLineBreak +
                   ' Program Language: %s';
  RsMonitorDesc = ' %d.: %dx%d pixels, %d DPI, Primary: %s, Active: %s';
  RsMonitors = 'Monitors: %d';
  StrAcquiringRTTIData = 'Acquiring RTTI data failed, reason: ';
  StrRTTILogOfMostImp = 'RTTI log of most important objects:';

var
  ExceptionDialog: TExceptionDialog;

//============================================================================
// Helper routines
//============================================================================

// SortModulesListByAddressCompare
// sorts module by address
function SortModulesListByAddressCompare(List: TStringList;
  Index1, Index2: Integer): Integer;
var
  Addr1, Addr2: TJclAddr;
begin
  Addr1 := TJclAddr(List.Objects[Index1]);
  Addr2 := TJclAddr(List.Objects[Index2]);
  if Addr1 > Addr2 then
    Result := 1
  else if Addr1 < Addr2 then
    Result := -1
  else
    Result := 0;
end;

//============================================================================
// TApplication.HandleException method code hooking for exceptions from DLLs
//============================================================================

// We need to catch the last line of TApplication.HandleException method:
// [...]
//   end else
//    SysUtils.ShowException(ExceptObject, ExceptAddr);
// end;

procedure HookShowException(ExceptObject: TObject; ExceptAddr: Pointer);
begin
  if JclValidateModuleAddress(ExceptAddr)
    and (ExceptObject.InstanceSize >= Exception.InstanceSize) then
    TExceptionDialog.ExceptionHandler(nil, Exception(ExceptObject))
  else
    SysUtils.ShowException(ExceptObject, ExceptAddr);
end;

//----------------------------------------------------------------------------

function HookTApplicationHandleException: Boolean;
const
  CallOffset      = $86;   // Until D2007
  CallOffsetDebug = $94;   // Until D2007
  CallOffsetWin32 = $7A;   // D2009 and newer
  CallOffsetWin64 = $95;   // DXE2 for Win64
type
  PCALLInstruction = ^TCALLInstruction;
  TCALLInstruction = packed record
    Call: Byte;
    Address: Integer;
  end;
var
  TApplicationHandleExceptionAddr, SysUtilsShowExceptionAddr: Pointer;
  CALLInstruction: TCALLInstruction;
  CallAddress: Pointer;
  WrittenBytes: Cardinal;

  function CheckAddressForOffset(Offset: Cardinal): Boolean;
  begin
    try
      CallAddress := Pointer(TJclAddr(TApplicationHandleExceptionAddr) + Offset);
      CALLInstruction.Call := $E8;
      Result := PCALLInstruction(CallAddress)^.Call = CALLInstruction.Call;
      if Result then
      begin
        if IsCompiledWithPackages then
          Result := PeMapImgResolvePackageThunk(Pointer(SizeInt(CallAddress) + Integer(PCALLInstruction(CallAddress)^.Address) + SizeOf(CALLInstruction))) = SysUtilsShowExceptionAddr
        else
          Result := PCALLInstruction(CallAddress)^.Address = SizeInt(SysUtilsShowExceptionAddr) - SizeInt(CallAddress) - SizeOf(CALLInstruction);
      end;
    except
      Result := False;
    end;
  end;

begin
  TApplicationHandleExceptionAddr := PeMapImgResolvePackageThunk(@TApplication.HandleException);
  SysUtilsShowExceptionAddr := PeMapImgResolvePackageThunk(@SysUtils.ShowException);
  if Assigned(TApplicationHandleExceptionAddr) and Assigned(SysUtilsShowExceptionAddr) then
  begin
    Result := CheckAddressForOffset(CallOffset) or CheckAddressForOffset(CallOffsetDebug) or
      CheckAddressForOffset(CallOffsetWin32) or CheckAddressForOffset(CallOffsetWin64);
    if Result then
    begin
      CALLInstruction.Address := SizeInt(@HookShowException) - SizeInt(CallAddress) - SizeOf(CALLInstruction);
      Result := WriteProtectedMemory(CallAddress, @CallInstruction, SizeOf(CallInstruction), WrittenBytes);
    end;
  end
  else
    Result := False;
end;

//============================================================================
// Exception dialog
//============================================================================

var
  ExceptionShowing: Boolean;

//=== { TExceptionDialog } ===============================================

procedure TExceptionDialog.AfterCreateDetails;
begin
  SaveBtn.Enabled := True;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.BeforeCreateDetails;
begin
  SaveBtn.Enabled := False;
end;

//----------------------------------------------------------------------------

function TExceptionDialog.ReportMaxColumns: Integer;
begin
  Result := 78;
end;



//----------------------------------------------------------------------------

procedure TExceptionDialog.SaveBtnClick(Sender: TObject);
begin
  with TSaveDialog.Create(Self) do
  try
    DefaultExt := '.log';
    FileName := ExtractFileName(Application.ExeName) + '-exception-' + FormatDateTime('yyyy-mm-dd_hh-mm-ss', Now) + '.log';
    Filter := _T(OpenDlgLogFiles);
    Options := [ofHideReadOnly,ofPathMustExist,ofNoReadOnlyReturn,ofEnableSizing,ofDontAddToRecent];
    if Execute then
      DetailsMemo.Lines.SaveToFile(FileName);
  finally
    Free;    
  end;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.CopyReportToClipboard;
begin
  ClipBoard.AsText := ReportAsText;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.CreateDetails;
begin
  Screen.Cursor := crHourGlass;
  DetailsMemo.Lines.BeginUpdate;
  try
    CreateReport;

    DetailsMemo.SelStart := 0;
    SendMessage(DetailsMemo.Handle, EM_SCROLLCARET, 0, 0);
    AfterCreateDetails;
  finally
    DetailsMemo.Lines.EndUpdate;
    OkBtn.Enabled := True;
    DetailsBtn.Enabled := True;
    OkBtn.SetFocus;
    Screen.Cursor := crDefault;
  end;
end;

//----------------------------------------------------------------------------

procedure TExceptionDialog.CreateReport;
var
  SL: TStringList;
  I: Integer;
  ModuleName: TFileName;
  NtHeaders32: PImageNtHeaders32;
  NtHeaders64: PImageNtHeaders64;
  ModuleBase: TJclAddr;
  ImageBaseStr: string;
  C: TWinControl;
  CpuInfo: TCpuInfo;
  ProcessorDetails: string;
  StackList: TJclStackInfoList;
  ThreadList: TJclDebugThreadList;
  AThreadID: DWORD;
  PETarget: TJclPeTarget;
begin
  DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsMainThreadID)), [MainThreadID]));
  DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsExceptionThreadID)), [MainThreadID]));
  NextDetailBlock;

  SL := TStringList.Create;
  try
    // Except stack list
    StackList := JclGetExceptStackList(FThreadID);
    if Assigned(StackList) then
    begin
      DetailsMemo.Lines.Add(RsExceptionStack);
      DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
      StackList.AddToStrings(DetailsMemo.Lines, True, True, True, False);
      NextDetailBlock;
    end;

    // Main thread
    StackList := JclCreateThreadStackTraceFromID(False, MainThreadID);
    if Assigned(StackList) then
    begin
      DetailsMemo.Lines.Add(LoadResString(PResStringRec(@RsMainThreadCallStack)));
      DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
      StackList.AddToStrings(DetailsMemo.Lines, True, True, True, False);
      NextDetailBlock;
    end;

    // All threads
    ThreadList := JclDebugThreadList;
    ThreadList.Lock.Enter; // avoid modifications
    try
      for I := 0 to ThreadList.ThreadIDCount - 1 do
      begin
        AThreadID := ThreadList.ThreadIDs[I];
        if (AThreadID <> FThreadID) then
        begin
          StackList := JclCreateThreadStackTrace(False, ThreadList.ThreadHandles[I]);
          if Assigned(StackList) then
          begin
            DetailsMemo.Lines.Add(Format(RsThreadCallStack, [AThreadID, ThreadList.ThreadInfos[AThreadID], ThreadList.ThreadNames[AThreadID]]));
            DetailsMemo.Lines.Add(Format(LoadResString(PResStringRec(@RsStackList)), [DateTimeToStr(StackList.TimeStamp)]));
            StackList.AddToStrings(DetailsMemo.Lines, True, True, True, False);
            NextDetailBlock;
          end;
        end;
      end;
    finally
      ThreadList.Lock.Leave;
    end;

    // System and OS information
    DetailsMemo.Lines.Add(Format(RsOSVersion, [GetWindowsVersionString, NtProductTypeString,
      Win32MajorVersion, Win32MinorVersion, Win32BuildNumber, Win32CSDVersion, GetSystemLanguage]));
    GetCpuInfo(CpuInfo);
    ProcessorDetails := Format(RsProcessor, [CpuInfo.Manufacturer, CpuInfo.CpuName,
      RoundFrequency(CpuInfo.FrequencyInfo.NormFreq)]);
    if not CpuInfo.IsFDIVOK then
      ProcessorDetails := ProcessorDetails + ' [FDIV Bug]';
    if CpuInfo.ExMMX then
      ProcessorDetails := ProcessorDetails + ' MMXex';
    if CpuInfo.MMX then
      ProcessorDetails := ProcessorDetails + ' MMX';
    if sse in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE';
    if sse2 in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE2';
    if sse3 in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE3';
    if ssse3 in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSSE3';
    if sse41 in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE41';
    if sse42 in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE42';
    if sse4A in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE4A';
    if sse5 in CpuInfo.SSE then
      ProcessorDetails := ProcessorDetails + ' SSE5';
    if CpuInfo.Ex3DNow then
      ProcessorDetails := ProcessorDetails + ' 3DNow!ex';
    if CpuInfo._3DNow then
      ProcessorDetails := ProcessorDetails + ' 3DNow!';
    if CpuInfo.Is64Bits then
      ProcessorDetails := ProcessorDetails + ' 64 bits';
    if CpuInfo.DEPCapable then
      ProcessorDetails := ProcessorDetails + ' DEP';
    DetailsMemo.Lines.Add(ProcessorDetails);
    DetailsMemo.Lines.Add(Format(RsMemory, [GetTotalPhysicalMemory div 1024 div 1024,
      GetFreePhysicalMemory div 1024 div 1024]));
    DetailsMemo.Lines.Add(Format(RsScreenRes, [Screen.Width, Screen.Height, GetBPP, Screen.PixelsPerInch]));
    DetailsMemo.Lines.Add(Format(RsMonitors, [Screen.MonitorCount]));
    for I := 0 to Screen.MonitorCount - 1 do
      DetailsMemo.Lines.Add(Format(RsMonitorDesc, [I, Screen.Monitors[I].Width,
        Screen.Monitors[I].Height, Screen.Monitors[I].PixelsPerInch, BoolToStr(Screen.Monitors[I].Primary, true),
        BoolToStr(Screen.MonitorFromWindow(Application.MainFormHandle) = Screen.Monitors[I], true)]));
    NextDetailBlock;

    // Modules list
    if LoadedModulesList(SL, GetCurrentProcessId) then
    begin
      DetailsMemo.Lines.Add(RsModulesList);
      SL.CustomSort(SortModulesListByAddressCompare);
      for I := 0 to SL.Count - 1 do
      begin
        ModuleName := SL[I];
        ModuleBase := TJclAddr(SL.Objects[I]);
        DetailsMemo.Lines.Add(Format('[' + HexDigitFmt + '] %s', [ModuleBase, ModuleName]));
        PETarget := PeMapImgTarget(Pointer(ModuleBase));
        NtHeaders32 := nil;
        NtHeaders64 := nil;
        if PETarget = taWin32 then
          NtHeaders32 := PeMapImgNtHeaders32(Pointer(ModuleBase))
        else
        if PETarget = taWin64 then
          NtHeaders64 := PeMapImgNtHeaders64(Pointer(ModuleBase));
        if (NtHeaders32 <> nil) and (NtHeaders32^.OptionalHeader.ImageBase <> ModuleBase) then
          ImageBaseStr := Format('<' + HexDigitFmt32 + '> ', [NtHeaders32^.OptionalHeader.ImageBase])
        else
        if (NtHeaders64 <> nil) and (NtHeaders64^.OptionalHeader.ImageBase <> ModuleBase) then
          ImageBaseStr := Format('<' + HexDigitFmt64 + '> ', [NtHeaders64^.OptionalHeader.ImageBase])
        else
          ImageBaseStr := StrRepeat(' ', 11);
        if VersionResourceAvailable(ModuleName) then
          with TJclFileVersionInfo.Create(ModuleName) do
          try
            DetailsMemo.Lines.Add(ImageBaseStr + BinFileVersion + ' - ' + FileVersion);
            if FileDescription <> '' then
              DetailsMemo.Lines.Add(StrRepeat(' ', 11) + FileDescription);
          finally
            Free;
          end
        else
          DetailsMemo.Lines.Add(ImageBaseStr + RsMissingVersionInfo);

      end;
      NextDetailBlock;
    end;

    // Active controls
    if (FLastActiveControl <> nil) then
    begin
      DetailsMemo.Lines.Add(RsActiveControl);
      C := FLastActiveControl;
      while C <> nil do
      begin
        DetailsMemo.Lines.Add(Format('%s "%s"', [C.ClassName, C.Name]));
        C := C.Parent;
      end;
      NextDetailBlock;
    end;

    //RTTI Log
    if Assigned(WinBoxMain) then
      try
        DetailsMemo.Lines.Add(StrRTTILogOfMostImp);
        try
          WinBoxMain.GetRttiReport(DetailsMemo.Lines);
        except on E: Exception do
          DetailsMemo.Lines.Add(StrAcquiringRTTIData + E.Message + '.');
        end;
      finally
        NextDetailBlock;
      end;

  finally
    SL.Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.DetailsBtnClick(Sender: TObject);
begin
  DetailsVisible := not DetailsVisible;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ExceptionHandler(Sender: TObject; E: Exception);
begin
  if Assigned(E) then
    if ExceptionShowing then
      Application.ShowException(E)
    else
    begin
      ExceptionShowing := True;
      try
        if IsIgnoredException(E.ClassType) then
          Application.ShowException(E)
        else
          ShowException(E, nil);
      finally
        ExceptionShowing := False;
      end;
    end;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ExceptionThreadHandler(Thread: TJclDebugThread);
var
  E: Exception;
begin
  E := Exception(Thread.SyncException);
  if Assigned(E) then
    if ExceptionShowing then
      Application.ShowException(E)
    else
    begin
      ExceptionShowing := True;
      try
        if IsIgnoredException(E.ClassType) then
          Application.ShowException(E)
        else
          ShowException(E, Thread);
      finally
        ExceptionShowing := False;
      end;
    end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormCreate(Sender: TObject);
var
  Handle: HICON;
  Icon: TIcon;
begin
  FFullHeight := ClientHeight;
  DetailsVisible := False;
  Translate;

  if Succeeded(LoadIconWithScaleDown(0, MakeIntResource(IDI_ERROR),
      GetSystemMetrics(SM_CXICON), GetSystemMetrics(SM_CYICON), Handle)) then begin
        Icon := TIcon.Create;
        Icon.ReleaseHandle;
        Icon.Handle := Handle;
        imgIcon.Picture.Assign(Icon);
        OnPaint := nil;
        Icon.Free;
      end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormDestroy(Sender: TObject);
begin

end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and (ssCtrl in Shift) then
  begin
    CopyReportToClipboard;
    MessageBeep(MB_OK);
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormPaint(Sender: TObject);
begin
  DrawIcon(Canvas.Handle, (TextMemo.Left - GetSystemMetrics(SM_CXICON)) div 2,
    TextMemo.Top, LoadIcon(0, IDI_ERROR));
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormResize(Sender: TObject);
begin
  UpdateTextMemoScrollBars;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.FormShow(Sender: TObject);
begin
  BeforeCreateDetails;
  MessageBeep(MB_ICONERROR);
  if (GetCurrentThreadId = MainThreadID) and (GetWindowThreadProcessId(Handle, nil) = MainThreadID) then
    PostMessage(Handle, UM_CREATEDETAILS, 0, 0)
  else
    CreateReport;
end;

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.GetReportAsText: string;
begin
  Result := StrEnsureSuffix(NativeCrLf, TextLines.Text) + NativeCrLf + DetailsMemo.Text;
end;

//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.NextDetailBlock;
begin
  DetailsMemo.Lines.Add(StrRepeat(ReportNewBlockDelimiterChar, ReportMaxColumns));
end;

//--------------------------------------------------------------------------------------------------

function TExceptionDialog.ReportNewBlockDelimiterChar: Char;
begin
  Result := '-';
end;


//--------------------------------------------------------------------------------------------------

procedure TExceptionDialog.SetDetailsVisible(const Value: Boolean);
const
  DirectionChars: array [0..1] of Char = ( '<', '>' );
var
  DetailsCaption: string;
begin
  FDetailsVisible := Value;
  DetailsCaption := Trim(StrRemoveChars(DetailsBtn.Caption, DirectionChars));
  if Value then
  begin
    Constraints.MinHeight := FNonDetailsHeight + 100;
    Constraints.MaxHeight := Screen.Height;
    DetailsCaption := '<< ' + DetailsCaption;
    ClientHeight := FFullHeight;
    DetailsMemo.Height := FFullHeight - DetailsMemo.Top - DetailsMemo.Left;
  end
  else
  begin
    FFullHeight := ClientHeight;
    DetailsCaption := DetailsCaption + ' >>';
    if FNonDetailsHeight = 0 then
    begin
      ClientHeight := BevelDetails.Top;
      FNonDetailsHeight := Height;
    end
    else
      Height := FNonDetailsHeight;
    Constraints.MinHeight := FNonDetailsHeight;
    Constraints.MaxHeight := FNonDetailsHeight
  end;
  DetailsBtn.Caption := DetailsCaption;
  DetailsMemo.Enabled := Value;
end;

//--------------------------------------------------------------------------------------------------

class procedure TExceptionDialog.ShowException(E: TObject; Thread: TJclDebugThread);
var
  Msg: string;
begin
  if ExceptionDialog = nil then
    ExceptionDialog := ExceptionDialogClass.Create(Application);
  try
    with ExceptionDialog do
    begin
      if Assigned(Thread) then
        FThreadID := Thread.ThreadID
      else
        FThreadID := MainThreadID;
      FLastActiveControl := Screen.ActiveControl;
      if E is Exception then
        Msg := AdjustLineBreaks(StrEnsureSuffix('.', Exception(E).Message))
      else
        Msg := AdjustLineBreaks(StrEnsureSuffix('.', E.ClassName));

      TextLines.Text := Msg;
      UpdateTextMemoScrollBars;
      lbMessage2.Top := TextLines.Top + TextLines.Height;

      NextDetailBlock;
      //Arioch: some header for possible saving to txt-file/e-mail/clipboard/NTEvent...
      DetailsMemo.Lines.Add(Format(DetailsMemo.Hint + RsDetailsIntro, [DateTimeToStr(Now),
        Application.Title + ' ' + GetFileVer(Application.ExeName), Application.ExeName, GetCommandLine, Locale]));
      NextDetailBlock;
      DetailsMemo.Lines.Add(Format(RsExceptionClass, [E.ClassName]));
      if E is Exception then
        DetailsMemo.Lines.Add(Format(RsExceptionMessage, [StrEnsureSuffix('.', Exception(E).Message)]));
      if Thread = nil then
        DetailsMemo.Lines.Add(Format(RsExceptionAddr, [ExceptAddr]))
      else
        DetailsMemo.Lines.Add(Format(RsThread, [Thread.ThreadInfo]));
      NextDetailBlock;
      ShowModal;
    end;
  finally
    FreeAndNil(ExceptionDialog);
  end;
end;

procedure TExceptionDialog.GetTranslation(Language: TLanguage);
begin
  Language.GetTranslation('ErrorDialog', Self);
  Language.WriteString('ErrorDialog', 'ExceptionDialog',
    '%s' + Copy(Caption, length(Application.Title) + 1, MaxInt));
end;

procedure TExceptionDialog.Translate;
begin
  Language.Translate('ErrorDialog', Self);
  Caption := Language.ReadString('ErrorDialog', 'ExceptionDialog', Caption);
  Caption := Format(Caption, [Application.Title]);
end;

procedure TExceptionDialog.UMCreateDetails(var Message: TMessage);
begin
  Update;
  CreateDetails;
end;

procedure TExceptionDialog.UpdateTextMemoScrollBars;
var
  CharHeight: integer;
begin
  Canvas.Font := TextMemo.Font;
  CharHeight := Canvas.TextHeight('Wg');
  TextLines.ClientHeight := CharHeight;
  while TextLines.Lines.Count * CharHeight >= TextLines.ClientHeight do
    TextLines.ClientHeight := TextLines.ClientHeight + CharHeight;
end;

//--------------------------------------------------------------------------------------------------


//==================================================================================================
// Exception handler initialization code
//==================================================================================================

var
  AppEvents: TApplicationEvents = nil;

procedure InitializeHandler;
begin
  if AppEvents = nil then
  begin
    AppEvents := TApplicationEvents.Create(nil);
    AppEvents.OnException := TExceptionDialog.ExceptionHandler;
    JclStackTrackingOptions := JclStackTrackingOptions + [stTraceAllExceptions];
    JclStackTrackingOptions := JclStackTrackingOptions + [stStaticModuleList];
    JclStackTrackingOptions := JclStackTrackingOptions + [stDelayedTrace];
    JclDebugThreadList.OnSyncException := TExceptionDialog.ExceptionThreadHandler;
    JclHookThreads;
    JclStartExceptionTracking;
    if HookTApplicationHandleException then
      JclTrackExceptionsFromLibraries;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure UnInitializeHandler;
begin
  if AppEvents <> nil then
  begin
    FreeAndNil(AppEvents);
    JclDebugThreadList.OnSyncException := nil;
    JclUnhookExceptions;
    JclStopExceptionTracking;
    JclUnhookThreads;
  end;
end;

//--------------------------------------------------------------------------------------------------


initialization
  InitializeHandler;

finalization
  UnInitializeHandler;

end.
