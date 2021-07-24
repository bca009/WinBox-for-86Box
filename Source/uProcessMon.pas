(*

    WinBox for 86Box - An alternative manager for 86Box VMs

    Copyright (C) 2020, Laci bá'

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

unit uProcessMon;

interface

uses Windows, SysUtils, Classes;

type
  TProcess = record
    ProcessID: DWORD;
    ExecutablePath: string;
    CommandLine: string;
    KernelModeTime: uint64;
    UserModeTime: uint64;
    WorkingSetSize: uint64;
    PercentCPU,
    PercentRAM: extended;
    Data: NativeUInt;
  end;

  TProcessMonitor = class
  private
    FQuery: string;
    FInterval, FEnabled: integer;
    FChange: TNotifyEvent;
    function GetCount: integer;
    function GetProcess(I: integer): TProcess;
    function GetEnabled: boolean;
    procedure SetEnabled(const Value: boolean);
    procedure SetInterval(const Value: integer);
  protected
    FList: TArray<TProcess>;
    FThread: TThread;

    FUpdate: TNotifyEvent;
    FLastSystemTime: uint64;
    function CreateDataField(const Process: TProcess): Integer; virtual;
    procedure InternalUpdate(var ProcessList: TArray<TProcess>);
    function CheckChanges(var ProcessList: TArray<TProcess>): boolean;
  public
    constructor Create(const AEnabled: boolean); reintroduce;
    destructor Destroy; override;

    function FindByPID(const PID: DWORD): integer;
    property Processes[I: integer]: TProcess read GetProcess; default;

    property Enabled: boolean read GetEnabled write SetEnabled;
    property Interval: integer read FInterval write SetInterval;
    property Query: string read FQuery write FQuery;

    property Count: integer read GetCount;
    property OnUpdate: TNotifyEvent read FUpdate write FUpdate;
    property OnChange: TNotifyEvent read FChange write FChange;
  end;

  TProcessThread = class(TThread)
  private
    FOwner: TProcessMonitor;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TProcessMonitor);
  end;

procedure dbgDumpProcList(Monitor: TProcessMonitor; const Verbose: boolean);

function KillProcess(const PID: DWORD): boolean;

var
  dbgLogUpdates: boolean = false;
  dbgLogChanges: boolean = false;

const
  DefProcess: TProcess =
    (ProcessID: DWORD(-1);
     ExecutablePath: '';
     CommandLine: '';
     KernelModeTime: 0;
     UserModeTime: 0;
     WorkingSetSize: 0;
     PercentCPU: 0;
     PercentRAM: 0;
     Data: 0);

implementation

uses Variants, ActiveX, uWbem, uCommUtil;

var
  MemoryStatus: TMemoryStatusEx;

procedure dbgDumpProcList(Monitor: TProcessMonitor; const Verbose: boolean);
var
  I: integer;
begin
  if Assigned(Monitor) then
    for I := 0 to Monitor.Count - 1 do
      if Verbose then
        with Monitor[I] do
          Log('ProcessID: %u'#13#10 +
              'ExecutablePath: %s'#13#10 +
              'CommandLine: %s'#13#10 +
              'KernelModeTime: %s'#13#10 +
              'UserModeTime: %s'#13#10 +
              'WorkingSetSize: %s'#13#10 +
              'PercentCPU: %.2f'#13#10 +
              'PercentRAM: %.2f'#13#10 +
              'Data: 0x%.16x',
              [ProcessID,
               ExecutablePath,
               CommandLine,
               UIntToStr(KernelModeTime),
               UIntToStr(UserModeTime),
               UIntToStr(WorkingSetSize),
               PercentCPU,
               PercentRAM,
               Data])
      else
        with Monitor[I] do
          Log('%u  %s  %s', [ProcessID, ExecutablePath, CommandLine]);
end;

function FileTimeToUInt64(const FileTime: TFileTime): uint64; inline;
var
  I: _LARGE_INTEGER;
begin
  I.LowPart := FileTime.dwLowDateTime;
  I.HighPart := FileTime.dwHighDateTime;
  Result := uint64(I.QuadPart);
end;

function GetSystemCPUUsage: uint64;
var
  ftSysIdle, ftSysKernel, ftSysUser: TFileTime;
begin
  GetSystemTimes(ftSysIdle, ftSysKernel, ftSysUser);
  Result := FileTimeToUInt64(ftSysKernel) + FileTimeToUInt64(ftSysUser);
end;

function GetProcessCPUUsage(const Process: TProcess): uint64; inline;
begin
  Result := Process.KernelModeTime + Process.UserModeTime;
end;

function GetProcessListEx(Query: TWbemQuery): TArray<TProcess>;
var
  I: integer;
  Value: OleVariant;
begin
  Query.Refresh;
  SetLength(Result, Query.Count);

  for I := 0 to Query.Count - 1 do begin
    Result[I] := DefProcess;
    with Result[I] do begin
      if Query.TryGetValue(I, 'ProcessId', Value) then
        ProcessID := Value;

      if Query.TryGetValue(I, 'ExecutablePath', Value) then
        ExecutablePath := Value;

      if Query.TryGetValue(I, 'CommandLine', Value)  then
        CommandLine := Value;

      if Query.TryGetValue(I, 'UserModeTime', Value) then
        UserModeTime := Value;

      if Query.TryGetValue(I, 'KernelModeTime', Value) then
        KernelModeTime := Value;

      if Query.TryGetValue(I, 'WorkingSetSize', Value) then
        WorkingSetSize := Value;

      PercentCPU := 0;
      PercentRAM := WorkingSetSize / MemoryStatus.ullTotalPhys * 100;
      Data := 0;
    end;
  end;
end;

function KillProcess(const PID: DWORD): boolean;
var
  hProcess: THandle;
begin
  hProcess := OpenProcess(PROCESS_TERMINATE, false, PID);
  if (hProcess <> INVALID_HANDLE_VALUE) and (hProcess <> 0) then begin
    Result := TerminateProcess(hProcess, 1);
    CloseHandle(hProcess);
  end
  else
    Result := false;
end;

{ TProcessMonitor }

constructor TProcessMonitor.Create(const AEnabled: boolean);
begin
  FLastSystemTime := 0;
  FInterval := 250;
  FEnabled := ord(AEnabled);
  FQuery := 'SELECT * FROM Win32_Process';

  FThread := TProcessThread.Create(Self);
  FThread.Suspended := false;
end;

function TProcessMonitor.CreateDataField(const Process: TProcess): Integer;
begin
  Result := 0;
end;

destructor TProcessMonitor.Destroy;
begin
  FThread.Free;
  inherited;
end;

function TProcessMonitor.FindByPID(const PID: DWORD): integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FList) do
    if FList[I].ProcessID = PID then
      exit(I);
end;

function TProcessMonitor.GetCount: integer;
begin
  Result := length(FList);
end;

function TProcessMonitor.GetEnabled: boolean;
begin
  Result := FEnabled <> 0;
end;

function TProcessMonitor.GetProcess(I: integer): TProcess;
begin
  Result := FList[I];
end;

function TProcessMonitor.CheckChanges(
  var ProcessList: TArray<TProcess>): boolean;
var
  I, Index: integer;
begin
  Result := length(ProcessList) = length(FList);

  if Result then
    for I := 0 to High(ProcessList) do
      with ProcessList[I] do begin
        Index := FindByPID(ProcessID);

        Result := Result and (Index <> -1) and
                  (FList[I].ExecutablePath = ExecutablePath) and
                  (FList[I].CommandLine = CommandLine);

        if not Result then
          break;
      end;

  Result := not Result;
end;

procedure TProcessMonitor.InternalUpdate(var ProcessList: TArray<TProcess>);
var
  I, Index: integer;
  SystemTime: uint64;
  Changed: boolean;
begin
  Changed := CheckChanges(ProcessList);

  SystemTime := GetSystemCPUUsage;

  for I := 0 to High(ProcessList) do
    with ProcessList[I] do begin
      Index := FindByPID(ProcessID);

      if Index <> -1 then begin
        Data := FList[Index].Data;
        if FLastSystemTime <> 0 then
          PercentCPU := (GetProcessCPUUsage(ProcessList[I]) - GetProcessCPUUsage(FList[Index])) /
                        (SystemTime - FLastSystemTime) * 100;
      end
      else begin
        PercentCPU := 0;
        Data := 0;
      end;

      Data := CreateDataField(ProcessList[I]);
    end;

  FList := ProcessList;
  FLastSystemTime := SystemTime;

  if Assigned(FUpdate) then begin
    if dbgLogUpdates then
       Log('TProcessMonitor.OnUpdate() called.');
    FUpdate(Self);
  end;

  if Changed and Assigned(FChange) then begin
    if dbgLogChanges then
       Log('TProcessMonitor.OnChange() called.');
    FChange(Self);
  end;
end;

procedure TProcessMonitor.SetEnabled(const Value: boolean);
begin
  InterlockedExchange(FEnabled, ord(Value));
end;

procedure TProcessMonitor.SetInterval(const Value: integer);
begin
  InterlockedExchange(FInterval, Value);
end;

{ TProcessThread }

constructor TProcessThread.Create(AOwner: TProcessMonitor);
begin
  FOwner := AOwner;
  inherited Create(false);
end;

procedure TProcessThread.Execute;
var
  ProcessList: TArray<TProcess>;
  FQuery: TWbemQuery;

  FInterval, FEnabled: integer;
begin
  try
    CoInitialize(nil);
    try
      FQuery := TWbemQuery.Create(nil);

      while not Terminated do begin
        Synchronize(
          procedure
          begin
            FInterval := FOwner.FInterval;
            FEnabled := FOwner.FEnabled;
            FQuery.Query := FOwner.FQuery;
          end);

        if FEnabled = 1 then begin
          ProcessList := GetProcessListEx(FQuery);
          Synchronize(
            procedure
            begin
              FOwner.InternalUpdate(ProcessList);
            end);
        end;

        Sleep(FInterval);
      end;
    finally
      FQuery.Free;
    end;
  finally
    CoUninitialize;
    EndThread(0);
  end;
end;

initialization
  MemoryStatus.dwLength := SizeOf(MemoryStatus);
  GlobalMemoryStatusEx(MemoryStatus);

end.
