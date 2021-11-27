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

unit u86Box;

interface

uses Windows, SysUtils, Classes, uProcessMon, uWinProfile, Generics.Collections,
     Generics.Defaults, IniFiles;

type
  T86BoxStorage = record
    Connector: string;
    FileName: string;
    Size: uint64;
  end;

  T86BoxResolve = function (const NameTable, Value: string): string of object;

  T86BoxConfig = record
    Machine,
    CPUType,
    GfxCard,
    SndCard,
    Midi,
    NetCard,
    NetType,
    Mouse,
    Joystick: string;

    Memory, CPUSpeed, VoodooType: integer;
    HasVoodoo, SLI, HasCassette, HasCartridge: boolean;

    AspectRatio: TPoint;

    ScsiCard: array [0..4] of string;
    Floppy: array [1..4] of string;
    Serial: array [1..4] of boolean;
    Parallel: array [1..3] of boolean;

    HDD: array [1..4] of T86BoxStorage;
    CDROM: array [1..4] of T86BoxStorage;
    ZIP: array [1..4] of T86BoxStorage;
    MO: array [1..4] of T86BoxStorage;

    function IsAT: boolean; //assumption for 86Box's IS_AT at src\config.c

    procedure Reload(const ConfigFile: string; NameDefs: TMemIniFile);

    procedure GetCDROM(Config: TCustomIniFile; const ID: integer;
      var Storage: T86BoxStorage);
    procedure GetHDD(Config: TCustomIniFile; const ID: integer;
      var Storage: T86BoxStorage);
    procedure GetExStor(Config: TCustomIniFile; const Kind: string;
      const ID: integer; var Storage: T86BoxStorage);
    procedure GetAspectRatio(Config: TCustomIniFile; var Result: TPoint);

    procedure RemoveHDDs(const ConfigFile: string; Indices: TList<integer>);

    function FormatHDDs: string;
    function FormatCDROMs: string;
    function FormatExStors: string;
    function FormatCOMs: string;
    function FormatLPTs: string;
    function FormatSCSI(const ResolveProc: T86BoxResolve): string;
  end;

  T86BoxProfile = class(TWinBoxProfile)
  private
    NameDefFile,
    ConfigFile: string;
  protected
    function GetState: integer; override;
    function CheckProcess(const Process: TProcess): boolean; override;
  public
    IDM_ACTION_SCREENSHOT,
    IDM_ACTION_HRESET,
    IDM_ACTION_RESET_CAD,
    IDM_ACTION_EXIT,
    IDM_ACTION_CTRL_ALT_ESC,
    IDM_ACTION_PAUSE,
    IDM_CONFIG: integer;

    HasPrinterTray: boolean;
    Screenshots,
    PrinterTray: string;

    DiskSize: uint64;

    NameDefs: TMemIniFile;
    ConfigData: T86BoxConfig;

    function Resolve(const NameTable, Value: string): string;
    function ResolveIfEmpty(const Value: string): string;

    function Pause(const Suspend: boolean): boolean; override;

    procedure Default; override;
    procedure Reload; override;

    constructor Create(const AProfileID: string; AMonitor: TProcessMonitor); override;
    destructor Destroy; override;

    procedure OnDirectoryChange(Sender: TObject; FileName: string; ChangeType: Cardinal);

    function Settings(const Index: integer = 0): boolean;
    function Start(const Parameters: string = ''; const nShow: integer = SW_SHOWNORMAL): boolean; override;
  end;

  T86BoxMonitor = class(TProcessMonitor)
  protected
    function CreateDataField(const Process: TProcess): Integer; override;
  end;

  T86BoxProfiles = class(TObjectList<T86BoxProfile>)
  private
    FReload: TNotifyEvent;
  public
    procedure Reload(const AMonitor: T86BoxMonitor);
    procedure UpdatePIDs;

    function FindByID(const AProfileID: string): integer;
    function FindByWorkDir(const Path: string): integer;

    property OnReload: TNotifyEvent read FReload write FReload;
  end;

const
  DefStorage: T86BoxStorage =
   (Connector: ''; FileName: ''; Size: 0);

  DefConfig: T86BoxConfig =
   (Machine:  'ibmpc';
    CPUType:  '8088';
    GfxCard:  'cga';
    SndCard:  'none';
    Midi:     'none';
    NetCard:  'none';
    NetType:  'none';
    Mouse:    'none';
    Joystick: 'none';

    Memory:      64;
    CPUSpeed:    4772728;
    VoodooType:  0;
    HasVoodoo:   false;
    SLI:         false;
    HasCassette:  true;
    HasCartridge: false;

    AspectRatio: (X: 4; Y: 3);

    ScsiCard: ('none', 'none', 'none', 'none', 'none');
    Floppy: ('525_2dd', '525_2dd', 'none', 'none');
    Serial: (true, true, false, false);
    Parallel: (true, false, false));

resourcestring
  PathScreenshots = 'screenshots\';
  PathPrinterTray = 'printer\';

implementation

uses uProcProfile, uConfigMgr, uCommUtil, uLang, frmMainForm;

resourcestring
  StrNameDefsInf = 'namedefs.inf';

{ T86BoxProfile }

function T86BoxProfile.CheckProcess(const Process: TProcess): boolean;
var
  I: integer;
  Path: string;
begin

(*
    Note!

    If the short parameters will change again in 86box.c,
    you have to keep this section up-to-date. The other
    sections are fine with long parameters.

*)

  Path := '';
  with CommandLineToArgs(Process.CommandLine) do
    try
       for I := 0 to Count - 1 do
        if ((UpperCase(Strings[I]) = '-P') or
            (UpperCase(Strings[I]) = '--VMPATH'))
           and (I < Count - 1) then begin
             Path := IncludeTrailingPathDelimiter(
               ExpandFileNameTo(
                 ExcludeTrailingPathDelimiter(Strings[I + 1]),
                 ExtractFilePath(Process.ExecutablePath)));
           end
        else if ((UpperCase(Strings[I]) = '-Z') or
                 (UpperCase(Strings[I]) = '--LASTVMPATH'))
                and (I < Count - 1) then begin
                  Path := IncludeTrailingPathDelimiter(
                             ExpandFileNameTo(
                               ExcludeTrailingPathDelimiter(Strings[Count - 1]),
                               ExtractFilePath(Process.ExecutablePath)));
                end;
    finally
      Free;
    end;

  if Path = '' then
     Path := ExtractFilePath(Process.ExecutablePath);

  Result := WideUpperCase(
    IncludeTrailingPathDelimiter(Path)) =
           WideUpperCase(
    IncludeTrailingPathDelimiter(WorkingDirectory));
end;

constructor T86BoxProfile.Create(const AProfileID: string;
  AMonitor: TProcessMonitor);

begin
  NameDefs := nil;
  ConfigData := DefConfig;
  inherited;
end;

procedure T86BoxProfile.Default;
begin
  inherited;

  IDM_ACTION_SCREENSHOT   := 40011;
  IDM_ACTION_HRESET       := 40012;
  IDM_ACTION_RESET_CAD    := 40013;
  IDM_ACTION_EXIT         := 40014;
  IDM_ACTION_CTRL_ALT_ESC := 40015;
  IDM_ACTION_PAUSE	      := 40016;
  IDM_CONFIG	        	  := 40020;
end;

destructor T86BoxProfile.Destroy;
begin
  if Assigned(NameDefs) then
    NameDefs.Free;
  inherited;
end;

function T86BoxProfile.GetState: integer;
begin
  Result := inherited;

  if Result = PROFILE_STATE_RUNNING then
    Result := Result + ord(IsChecked(IDM_ACTION_PAUSE));
end;

procedure T86BoxProfile.OnDirectoryChange(Sender: TObject; FileName: string;
  ChangeType: Cardinal);
var
  L: TStringList;
begin
  if (FileName = '86BOX.CFG') and CanLockFile(ConfigFile, GENERIC_READ) then
    ConfigData.Reload(ConfigFile, NameDefs)
  else if FileName = 'PRINTER' then
    HasPrinterTray := DirectoryExists(PrinterTray);

  L := TStringList.Create;
  try
    DiskSize := GetFiles(WorkingDirectory, true, L);
  finally
    L.Free;
  end;
end;

function T86BoxProfile.Pause(const Suspend: boolean): boolean;
begin
  if Suspend <> (State = PROFILE_STATE_PAUSED) then begin
    Result := Execute(IDM_ACTION_PAUSE);
    if Result then
      UpdateState;
  end
  else
    Result := false;
end;

procedure T86BoxProfile.Reload;
var
  List: TStringList;
  Stream: TStream;

  I: integer;
begin
  inherited;
  Screenshots := WorkingDirectory + PathScreenshots;
  PrinterTray := WorkingDirectory + PathPrinterTray;

  NameDefFile := ExtractFilePath(ExecutablePath) + StrNameDefsInf;
  ConfigFile  := WorkingDirectory + '86box.cfg';

  HasPrinterTray := DirectoryExists(PrinterTray);

  if Assigned(NameDefs) then
    FreeAndNil(NameDefs);

  if FileExists(NameDefFile) then
    try
      NameDefs := TryLoadIni(NameDefFile);
    except
      FreeAndNil(NameDefs);
    end;

  if not Assigned(NameDefs) then begin
    NameDefs := TMemIniFile.Create('');
    List := TStringList.Create;
    try
      Stream := TResourceStream.Create(hInstance, 'NAMEDEFS', RT_RCDATA);
      try
        TryLoadList(Stream, List);
        NameDefs.SetStrings(List);
      finally
        Stream.Free;
      end;
    finally
      List.Free;
    end;
  end;

  if Assigned(NameDefs) then begin
    List := TStringList.Create;
    try
      Language.ReadSectionValues('NameDefs', List);

      IDM_ACTION_SCREENSHOT   := NameDefs.ReadInteger('patch', 'IDM_ACTION_SCREENSHOT', IDM_ACTION_SCREENSHOT);
      IDM_ACTION_HRESET       := NameDefs.ReadInteger('patch', 'IDM_ACTION_HRESET', IDM_ACTION_HRESET);
      IDM_ACTION_RESET_CAD    := NameDefs.ReadInteger('patch', 'IDM_ACTION_RESET_CAD', IDM_ACTION_RESET_CAD);
      IDM_ACTION_EXIT         := NameDefs.ReadInteger('patch', 'IDM_ACTION_EXIT', IDM_ACTION_EXIT);
      IDM_ACTION_CTRL_ALT_ESC := NameDefs.ReadInteger('patch', 'IDM_ACTION_CTRL_ALT_ESC', IDM_ACTION_CTRL_ALT_ESC);
      IDM_ACTION_PAUSE        := NameDefs.ReadInteger('patch', 'IDM_ACTION_PAUSE', IDM_ACTION_PAUSE);
      IDM_CONFIG              := NameDefs.ReadInteger('patch', 'IDM_ACTION_CONFIG', IDM_CONFIG);

      for I := 0 to List.Count - 1 do
        NameDefs.WriteString(TextLeft(List.Names[I]),
         TextRight(List.Names[I]), List.ValueFromIndex[I]);
    finally
      List.Free;
    end;
  end;

  OnDirectoryChange(Self, '86BOX.CFG', 0);
end;

function T86BoxProfile.Resolve(const NameTable, Value: string): string;
begin
  if Assigned(NameDefs) then
    Result := NameDefs.ReadString(NameTable, Value, Value)
  else
    Result := Value;
end;

function T86BoxProfile.ResolveIfEmpty(const Value: string): string;
begin
  if Value = '' then begin
    if Assigned(NameDefs) then
      Result := NameDefs.ReadString('gfxcard', 'none', 'none')
    else
      Result := 'none';
  end
  else
    Result := Value;
end;

function T86BoxProfile.Settings(const Index: integer): boolean;
begin
  if (Index = 0) and (Index < Count) then begin
    BringToFront;
    Result := Execute(IDM_CONFIG);
  end
  else if State = PROFILE_STATE_STOPPED then
    Result := Start('--settings --noconfirm')
  else
    Result := false;

  if dbgLogProcessOp then
    Log('T86BoxProfile.Settings, Result: %d', [ord(Result)]);
end;

function T86BoxProfile.Start(const Parameters: string;
  const nShow: integer): boolean;
var
  CommandLine, LogFile, Temp, Line: string;
  Device: T86BoxStorage;

  Files: TStringList;
  Indices: TList<integer>;
  Buffer: array [0..50] of char;
  I: integer;
begin
  CommandLine := format('--vmpath "%s" %s',
    [ExcludeTrailingPathDelimiter(WorkingDirectory), Parameters]);

  if NameDefs.ReadInteger('params', 'Support.VmName', 0) <> 0 then
    CommandLine := format('--vmname "%s" %s', [FriendlyName, CommandLine]);

  if boolean(HiWord(Config.EmuLangCtrl)) and
     (LoWord(Config.EmuLangCtrl) <> 2) and
     (NameDefs.ReadInteger('params', 'Support.LangCtrl', 0) <> 0) then
    CommandLine := format('--lang "%s" %s', [Config.AdjustEmuLang, CommandLine]);

  if Fullscreen then
    CommandLine := '--fullscreen ' + CommandLine;

  if (DebugMode = 2) or ((DebugMode = 0) and Config.DebugMode) then
    CommandLine := '--debug ' + CommandLine;

  if (CrashDump = 2) or ((CrashDump = 0) and Config.CrashDump) then
    CommandLine := '--crashdump ' + CommandLine;

  if not ((LoggingMode = 1) or
      ((LoggingMode = 0) and (Config.LoggingMode = 0))) then begin
         LogFile := GetLogFile;
         ForceDirectories(ExtractFilePath(LogFile));
         CommandLine := format('--logfile "%s" %s', [LogFile, CommandLine]);
      end;

  Files := TStringList.Create;
  Indices := TList<integer>.Create;
  try
    for I := Low(ConfigData.HDD) to High(ConfigData.HDD) do begin
      Device := ConfigData.HDD[I];
      if (Device.FileName <> '') then begin
        Temp := ExpandFileNameTo(Device.FileName, WorkingDirectory);
        if not FileExists(Temp) then begin
          Files.Add(Temp);
          Indices.Add(I);
        end
        else if not CanLockFile(Temp) then
          raise Exception.Create(_T('WinBox.ELockedHardDisk'));
      end;
    end;

    if Files.Count > 0 then
      with WinBoxMain.MissingDiskDlg do begin
        Line := _T(StrMissingDiskDlg + '.ExpandedText');
        for Temp in Files do
          if PathCompactPathExW(@Buffer[0], PChar(Temp), 50, 0) then begin
            Buffer[50] := #0;
            Line := Line + #13#10'   ' + String(Buffer);
          end
          else
            Line := Line + #13#10'   ' + ExtractFileName(Temp);

        ExpandedText := Line;
        Text := _T(StrMissingDiskDlg + '.Text', [FriendlyName]);

        Execute;
        case ModalResult of
          101: ConfigData.RemoveHDDs(ConfigFile, Indices);
          else exit(false);
        end;
      end;
  finally
    Indices.Free;
    Files.Free;
  end;

  Result := inherited Start(CommandLine, nShow);
end;

{ T86BoxProfiles }

function T86BoxProfiles.FindByID(const AProfileID: string): integer;
var
  I: integer;
begin
  for I := 0 to Count - 1 do
    if AProfileID = Items[I].ProfileID then
      exit(I);

  Result := -1;
end;

function T86BoxProfiles.FindByWorkDir(const Path: string): integer;
var
  I: integer;
begin
  for I := 0 to Count - 1 do
    if WideLowerCase(IncludeTrailingPathDelimiter(Path)) =
         WideLowerCase(Items[I].WorkingDirectory) then
      exit(I);

  Result := -1;
end;

procedure T86BoxProfiles.Reload(const AMonitor: T86BoxMonitor);
var
  List, Names: TStringList;
  Temp, Query: string;

  State: boolean;
begin
  Clear;
  List := TStringList.Create;
  Names := TStringList.Create;

  Names.Sorted := true;
  Names.Duplicates := dupIgnore;
  Names.Add(WideLowerCase(ExtractFileName(Config.EmulatorPath)));
  try
    State := AMonitor.Enabled;
    AMonitor.Enabled := false;
    try
      T86BoxProfile.GetList(List);
      for Temp in List do
        with Items[Add(
          T86BoxProfile.Create(Temp, AMonitor))] do
            Names.Add(WideLowerCase(ExtractFileName(ExecutablePath)));
    finally
      List.Free;
    end;
    Sort(TComparer<T86BoxProfile>.Construct(
      function (const L, R: T86BoxProfile): integer
      begin
         Result := StrCmpLogicalW(PChar(L.FriendlyName), PChar(R.FriendlyName));
      end));

    Query := 'SELECT * FROM Win32_Process WHERE';
    for Temp in Names do
      Query := Query + format(' Name LIKE "%%%s%%" OR', [Temp]);

    AMonitor.Query := Copy(Query, 1, length(Query) - 3);
    
    if Assigned(FReload) then
      FReload(Self);                   

    AMonitor.Enabled := State;
  finally
    Names.Free;
  end;
end;

procedure T86BoxProfiles.UpdatePIDs;
var
  P: T86BoxProfile;
begin
  for P in Self do
    P.UpdatePIDs;
end;

{ T86BoxMonitor }

function T86BoxMonitor.CreateDataField(const Process: TProcess): Integer;
var
  FindWindow: TFindWindow;
  NextClass: string;
begin
  Result := 0;

  if (Process.Data <> 0) and IsWindow(Process.Data) and
     (GetWindowClass(Process.Data) = '86BoxMainWnd') then begin
    if dbgLogCreateData then
      Log('PID: %d, HWND: 0x%.8x, ClassName: %s - passthrough',
        [Process.ProcessID, FindWindow.hwnd, NextClass]);
    exit(Process.Data);
  end;

  with FindWindow do begin
    dwFindType := FIND_WINDOW_CLASSNAME;
    dwPID := Process.ProcessID;
    StrPLCopy(@szClassName[0], '86BoxMainWnd'#0, 260);
    hwnd := 0;
  end;
  EnumWindows(@FindWindowByPID, NativeInt(@FindWindow));

  if FindWindow.hwnd <> 0 then begin
    if dbgLogCreateData then
      Log('PID: %d, HWND: 0x%.8x, ClassName: %s - FindWindow',
        [Process.ProcessID, FindWindow.hwnd, NextClass]);
    exit(FindWindow.hwnd);
  end;
end;

{ T86BoxConfig }

function T86BoxConfig.FormatCDROMs: string;
var
  I, C: integer;
begin
  Result := '';
  C := 0;
  for I := Low(CDROM) to High(CDROM) do
    with CDROM[I] do begin
      if Connector <> '' then begin
        if C = 2 then
          Result := Result + ' ...'
        else
          Result := Result + format(', %dx %s', [Size, Connector]);
      end;
      inc(C);
    end;

  Result := Copy(Result, 3, MaxInt);
end;

function T86BoxConfig.FormatCOMs: string;
var
  I: integer;
begin
  Result := '';
  for I := Low(Serial) to High(Serial) do
    if Serial[I] then
      Result := Result + format(', COM%d', [I]);

  Result := Copy(Result, 3, MaxInt);
end;

function T86BoxConfig.FormatExStors: string;
var
  I: integer;
begin
  Result := '';
  if HasCassette then
    Result := Result + ', ' + _T('Strings.Cassette');

  if HasCartridge then
    Result := Result + ', ' + _T('Strings.Cartridge');

  for I := Low(ZIP) to High(ZIP) do
    with ZIP[I] do
      if Connector <> '' then begin
        Result := Result + format(', %s ZIP', [Connector]);
        break;
      end;

  for I := Low(MO) to High(MO) do
    with MO[I] do
      if Connector <> '' then begin
        Result := Result + format(', %s MO', [Connector]);
        break;
      end;

  Result := Copy(Result, 3, MaxInt);
end;

function T86BoxConfig.FormatHDDs: string;
var
  I, C: integer;
begin
  Result := '';
  C := 0;
  for I := Low(HDD) to High(HDD) do
    with HDD[I] do
      if (Size > 0) and (Connector <> '') then begin
        if C = 2 then begin
          Result := Result + ' ...';
          break;
        end
        else begin
          inc(C);
          Result := ', ' + FileSizeToStr(Size, 0, 1000) + ' ' + Connector;
        end;
      end;

  Result := Copy(Result, 3, MaxInt);
end;

function T86BoxConfig.FormatLPTs: string;
var
  I: integer;
begin
  Result := '';
  for I := Low(Parallel) to High(Parallel) do
    if Parallel[I] then
      Result := Result + format(', LPT%d', [I]);

  Result := Copy(Result, 3, MaxInt);
end;

function T86BoxConfig.FormatSCSI(const ResolveProc: T86BoxResolve): string;
var
  I, C: integer;
begin
  Result := '';
  C := 0;
  for I := Low(ScsiCard) to High(ScsiCard) do
    if ScsiCard[I] <> 'none' then begin
      Result := Result + ', ' + ResolveProc('scsicard', ScsiCard[I]);
      inc(C);
      if C = 2 then begin
        Result := Result + ', ...';
        break;
      end;
    end;

  Result := Copy(Result, 3, MaxInt);

  if Result = '' then
    Result := ResolveProc('scsicard', 'none')
end;

procedure T86BoxConfig.GetAspectRatio(Config: TCustomIniFile;
  var Result: TPoint);
var
  Text: string;
begin
  Text := Config.ReadString('General', 'window_fixed_res', '');

  if Text = '' then
    Text := Config.ReadString('WinBox', 'WindowSize', '960x720');

  Result.X := 1;
  Result.Y := 1;
  TryStrToInt(TextLeft(Text, 'x'), Result.X);
  TryStrToInt(TextRight(Text, 'x'), Result.Y);
end;

procedure T86BoxConfig.GetCDROM(Config: TCustomIniFile; const ID: integer;
  var Storage: T86BoxStorage);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    ExtractStrings([','], [' '], PChar(
      Config.ReadString('Floppy and CD-ROM drives', 'cdrom_0' + IntToStr(ID) + '_parameters', '0, none')), L);

    if (L.Count >= 2) and (L[1] <> 'none') then
      Storage.Connector := UpperCase(L[1])
    else
      Storage.Connector := '';

    Storage.Size := Config.ReadInteger('Floppy and CD-ROM drives', 'cdrom_0' + IntToStr(ID) + '_speed', 8);
    Storage.FileName := Config.ReadString('Floppy and CD-ROM drives', 'cdrom_0' + IntToStr(ID) + 'image_path', '');
  finally
    L.Free;
  end;
end;

procedure T86BoxConfig.GetExStor(Config: TCustomIniFile; const Kind: string;
  const ID: integer; var Storage: T86BoxStorage);
var
  L: TStringList;
  i1: integer;
begin
  L := TStringList.Create;
  try
    ExtractStrings([','], [' '], PChar(
      Config.ReadString('Other removable devices',
         format('%s_0%d_parameters', [Kind, ID]), '0, none')), L);

    if (L.Count >= 2) and (L[1] <> 'none') and TryStrToInt(L[0], i1) then begin
      Storage.Size := i1;
      Storage.Connector := UpperCase(L[1]);
    end
    else begin
      Storage.Size := 0;
      Storage.Connector := '';
    end;

    Storage.FileName := Config.ReadString('Other removable devices',
      format('%s_0%d_image_path', [Kind, ID]), '');
  finally
    L.Free;
  end;

end;

procedure T86BoxConfig.GetHDD(Config: TCustomIniFile; const ID: integer;
  var Storage: T86BoxStorage);
var
  L: TStringList;
  i1, i2, i3: integer;
begin
  L := TStringList.Create;
  try
    ExtractStrings([','], [' '], PChar(
      Config.ReadString('Hard disks', 'hdd_0' + IntToStr(ID) + '_parameters', '0, 0, 0, 0, none')), L);

    if (L.Count >= 5) and (L[4] <> 'none') and TryStrToInt(L[2], i3)
      and TryStrToInt(L[1], i2) and TryStrToInt(L[0], i1) then begin
        Storage.Size := int64(i1) * i2 * i3 * 512;
        Storage.Connector := UpperCase(L[4]);
      end
    else begin
        Storage.Size := 0;
        Storage.Connector := '';
    end;

    Storage.FileName := Config.ReadString('Hard disks', 'hdd_0' + IntToStr(ID) + '_fn', '');
  finally
    L.Free;
  end;
end;

function T86BoxConfig.IsAT: boolean;
begin
  //The default value is dependent by the IS_AT macro of 86Box src\config.c.
  //However while WinBox don't know the flags from the machines table, it's
  // rather just an assumption.

  if Machine = 'xi8088' then
    exit(true)
  else if Machine = 'hed919' then
    exit(false)
  else
    Result := (CPUType <> '8088') and
              (CPUType <> '8088_europc') and
              (CPUType <> '8086');

  //Also the call of IsAT assumes, that tha Machine, and CPUType fields
  // have been read correctly before.
end;

procedure T86BoxConfig.Reload(const ConfigFile: string; NameDefs: TMemIniFile);
var
  Config: TMemIniFile;
  I, J: integer;

  Config_SCSI,
  Config_Cassette,
  Config_Cartridge: integer;
begin
  Self := DefConfig;

  Config_SCSI      := NameDefs.ReadInteger('config', 'Mode.SCSI', 0);
  Config_Cassette  := NameDefs.ReadInteger('config', 'Mode.Cassette', 0);
  Config_Cartridge := NameDefs.ReadInteger('config', 'Mode.Cartridge', 0);

  Config := TryLoadIni(ConfigFile);

  if Assigned(Config) then
    with Config do
      try
        Machine    := ReadString('Machine',               'machine',        Machine);
        CPUType    := ReadString('Machine',               'cpu_family',     CPUType);
        GfxCard    := ReadString('Video',                 'gfxcard',        GfxCard);
        SndCard    := ReadString('Sound',                 'sndcard',        SndCard);
        Midi       := ReadString('Sound',                 'midi_device',       Midi);
        NetCard    := ReadString('Network',               'net_card',       NetCard);
        NetType    := ReadString('Network',               'net_type',       NetType);
        Mouse      := ReadString('Input devices',         'mouse_type',       Mouse);
        Joystick   := ReadString('Input devices',         'joystick_type', Joystick);

        for I := Low(Floppy) to High(Floppy) do
          Floppy[I] := ReadString('Floppy and CD-ROM drives',
                         'fdd_0' + IntToStr(I) + '_type', Floppy[I]);

        Memory      := ReadInteger('Machine',              'mem_size',         Memory);
        CPUSpeed    := ReadInteger('Machine',              'cpu_speed',        CPUSpeed);
        VoodooType  := ReadInteger('3DFX Voodoo Graphics', 'type',             VoodooType);
        HasVoodoo   := ReadInteger('Video',                'voodoo',           ord(HasVoodoo)) <> 0;
        SLI         := ReadInteger('3DFX Voodoo Graphics', 'sli',              ord(SLI)) <> 0;

        GetAspectRatio(Config, AspectRatio);

        for I := Low(Serial) to High(Serial) do
          Serial[I] := ReadInteger('Ports (COM & LPT)',
                         'serial' + IntToStr(I) + '_enabled', ord(Serial[I])) <> 0;

        for I := Low(Parallel) to High(Parallel) do
          Parallel[I] := ReadInteger('Ports (COM & LPT)',
                         'lpt' + IntToStr(I) + '_enabled', ord(Parallel[I])) <> 0;

        for I := Low(CDROM) to High(CDROM) do
          GetCDROM(Config, I, CDROM[I]);

        for I := Low(HDD) to High(HDD) do
          GetHDD(Config, I, HDD[I]);

        for I := Low(ZIP) to High(ZIP) do
          GetExStor(Config, 'zip', I, ZIP[I]);

        for I := Low(MO) to High(MO) do
          GetExStor(Config, 'mo', I, MO[I]);

        //Config_SCSI:
        // 0: csak scsicard -> [1]
        // 1: mind az öt scsicard -> [0..4]
        // 2: négy scsicard, alap felülírja -> [1..4]

        J := 0;
        if Config_SCSI > 0 then
          for I := Low(ScsiCard) to High(ScsiCard) do begin
            ScsiCard[I] := ReadString('Storage controllers',
                           'scsicard_' + IntToStr(I),   ScsiCard[I]);
            if ScsiCard[I] <> 'none' then
              inc(J);
          end;

        if J = 0 then
          ScsiCard[ord(boolean(Config_SCSI = 2))] :=
            ReadString('Storage controllers', 'scsicard', ScsiCard[ord(boolean(Config_SCSI = 2))]);

        //Config_Cassette:
        // 0: letiltva
        // 1: alapból engedélyezve, implicit letiltás
        // 2: alapból engedélyezve AT gépeken, implicit letiltás

        case Config_Cassette of
          0: HasCassette := false;
          1: HasCassette := ReadInteger('Storage controllers',  'cassette_enabled', ord(HasCassette)) <> 0;
          2: HasCassette := ReadInteger('Storage controllers',  'cassette_enabled', ord(not IsAT)) <> 0;
        end;

        //Config_Cartridge:
        // 0: letiltva
        // 1: engedélyezve ha MACHINE_CARTRIDGE flag benn van
        //     (egyelőre csak IBM PCjr)

        case Config_Cartridge of
          0: HasCartridge := false;
          1: HasCartridge := Machine = 'ibmpcjr';
        end;
    finally
      Free;
    end;
end;

procedure T86BoxConfig.RemoveHDDs(const ConfigFile: string;
  Indices: TList<integer>);
var
  I: integer;
  Config: TMemIniFile;
begin
  try
    Config := TryLoadIni(ConfigFile);
  except
    FreeAndNil(Config);
    raise;
  end;

  if Assigned(Config) then
    with Config do
      try
        for I in Indices do begin
          Config.DeleteKey('Hard disks', 'hdd_0' + IntToStr(I) + '_fn');
          Config.DeleteKey('Hard disks', 'hdd_0' + IntToStr(I) + '_parameters');
          HDD[I] := DefStorage;
        end;
        Config.UpdateFile;
      finally
        Config.Free;
      end;
end;

end.
