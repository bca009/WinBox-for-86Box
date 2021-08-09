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

unit uProcProfile;

interface

uses Windows, SysUtils, Classes, Forms, uBaseProfile, uProcessMon;

const
  PROFILE_STATE_UNKNOWN        = -1;
  PROFILE_STATE_STOPPED        = 0;
  PROFILE_STATE_RUNNING        = 1;
  PROFILE_STATE_PAUSED         = 2; //Késõbbiekben használva, mivel VM-ekrõl van szó.
                                    //Nem azt jelenti hogy a folyamat suspended/nem.
  PROFILE_STATE_ERROR_MULTINST = 3;
  PROFILE_STATE_RUN_PENDING    = 4;

type
  TProcessProfile = class(TProfile)
  private
    FIndexMap: TArray<integer>;
    FStarted: longword;
    FState: integer;
    FMonitor: TProcessMonitor;
    FChange: TNotifyEvent;
    function GetBytesOfRAM: uint64;
    function GetCount: integer;
    function GetPercentCPU: extended;
    function GetPercentRAM: extended;
    function GetProcess(I: integer): TProcess;
    function GetHandle(I: integer): NativeUInt;
  protected
    function GetState: integer; virtual;
    function CheckProcess(const Process: TProcess): boolean; virtual;
  public
    constructor Create(const AProfileID: string; AMonitor: TProcessMonitor); reintroduce; virtual;

    function Start(const Parameters: string = '';
      const nShow: integer = SW_SHOWNORMAL): boolean; virtual;
    procedure Terminate(const All: boolean = true);

    procedure UpdateState;
    procedure UpdatePIDs;
    procedure UpdatePending;

    property Monitor: TProcessMonitor read FMonitor;
    property Handles[I: integer]: NativeUInt read GetHandle;
    property Processes[I: integer]: TProcess read GetProcess; default;
    property Count: integer read GetCount;
    property PercentCPU: extended read GetPercentCPU;
    property PercentRAM: extended read GetPercentRAM;
    property BytesOfRAM: uint64 read GetBytesOfRAM;
    property State: integer read FState;

    property OnChange: TNotifyEvent read FChange write FChange;
  end;

var
  dbgLogProcessOp:  boolean = false;
  dbgLogProfAssign: boolean = false;
  dbgLogCreateData: boolean = false;
  dbgLogProfChange: boolean = false;

implementation

uses uConfigMgr, uCommUtil, uLang;

resourcestring
  EInvalidEmulatorPath = 'WinBox.EInvEmulatorPath';
  EInvWorkingDirectory = 'WinBox.EInvWorkingDirectory';
  EProcessPending      = 'WinBox.EProcessPending';
  EProcessRunning      = 'WinBox.EProcessRunning';

{ TProcessProfile }

function TProcessProfile.CheckProcess(const Process: TProcess): boolean;
begin
  Result := WideUpperCase(Process.ExecutablePath) =
            WideUpperCase(ExecutablePath);
end;

constructor TProcessProfile.Create(const AProfileID: string;
  AMonitor: TProcessMonitor);
begin
  FState := PROFILE_STATE_STOPPED;
  FMonitor := AMonitor;
  FStarted := 0;
  inherited Create(AProfileID, true);
end;

function TProcessProfile.GetBytesOfRAM: uint64;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to High(FIndexMap) do
    Result := Result + GetProcess(I).WorkingSetSize;
end;

function TProcessProfile.GetCount: integer;
begin
  Result := length(FIndexMap);
end;

function TProcessProfile.GetHandle(I: integer): NativeUInt;
begin
  Result := GetProcess(I).Data;
end;

function TProcessProfile.GetPercentCPU: extended;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to High(FIndexMap) do
    Result := Result + GetProcess(I).PercentCPU;
end;

function TProcessProfile.GetPercentRAM: extended;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to High(FIndexMap) do
    Result := Result + GetProcess(I).PercentRAM;
end;

function TProcessProfile.GetProcess(I: integer): TProcess;
begin
  if Assigned(Monitor) and (I >= 0) and (I < length(FIndexMap))
     and (FIndexMap[I] >= 0) and (FIndexMap[I] < Monitor.Count) then
    Result := Monitor[FIndexMap[I]]
  else
    Result := DefProcess;
end;

function TProcessProfile.GetState: integer;
begin
  if not Assigned(FMonitor) then
    exit(PROFILE_STATE_UNKNOWN);

  case length(FIndexMap) of
    0: if FStarted <> 0 then
         Result := PROFILE_STATE_RUN_PENDING
       else
         Result := PROFILE_STATE_STOPPED;

    1: begin
         Result := PROFILE_STATE_RUNNING;
         FStarted := 0;
       end;

    else Result := PROFILE_STATE_ERROR_MULTINST;
  end;
end;

function TProcessProfile.Start(const Parameters: string;
  const nShow: integer): boolean;
var
  szAppName, szWorkDir, szCmdLine: string;
  siStartup: TStartupInfo;
  piProcess: TProcessInformation;
begin
  if not FileExists(ExecutablePath) then
    raise Exception.Create(_T(EInvalidEmulatorPath));

  if not DirectoryExists(ExcludeTrailingPathDelimiter(WorkingDirectory)) then
    raise Exception.Create(_T(EInvWorkingDirectory));

  if FStarted <> 0 then
    raise Exception.Create(_T(EProcessPending));

  if length(FIndexMap) > 0 then
    raise Exception.Create(_T(EProcessRunning));

  szAppName := #0;
  szCmdLine := format('"%s" %s %s'#0, [ExecutablePath, Parameters, OptionalParams]);
  szWorkDir := ExcludeTrailingPathDelimiter(ExtractFilePath(ExecutablePath)) + #0;

  FillChar(piProcess, SizeOf(piProcess), #0);
  FillChar(siStartup, SizeOf(siStartup), #0);
  siStartup.cb := SizeOf(siStartup);
  siStartup.dwFlags := STARTF_USESHOWWINDOW;
  siStartup.wShowWindow := nShow;

  Result := CreateProcess(nil, @szCmdLine[1], nil, nil, false, 0, nil,
                 @szWorkDir[1], siStartup, piProcess);

  if not Result then
    RaiseLastOSError;

  if dbgLogProcessOp then begin
    if Result then
      Log('CreateProcess: Success')
    else
      Log('CreateProcess: Failed!. Reason: %s.', [SysErrorMessage(GetLastError)]);

    Log('CommandLine: %s, PID: %d, TID: %d',
        [szCmdLine, piProcess.dwProcessID, piProcess.dwThreadID]);
  end;

  FStarted := GetTickCount; //a monitor visszajelzéséig "indítás folyamatban" állapot, ha sikerült az indítás
  UpdateState;

  CloseHandle(piProcess.hProcess);
  CloseHandle(piProcess.hThread);

  if Config.MinimizeOnStart then
    Application.Minimize;
end;

procedure TProcessProfile.Terminate(const All: boolean);
var
  I: Integer;
begin
  for I in FIndexMap do begin
    KillProcess(FMonitor[I].ProcessID);

    if dbgLogProcessOp then
      Log('Kill process PID %d', [FMonitor[I].ProcessID]);

    if not All then
      break;
  end;
  UpdateState;
end;

procedure TProcessProfile.UpdatePending;
begin
  if (FStarted <> 0) and
     ((GetTickCount - FStarted) >= Cardinal(Config.LaunchTimeout)) then begin
       FStarted := 0;
       UpdateState;
     end;
end;

procedure TProcessProfile.UpdatePIDs;
var
  I: integer;
begin
  SetLength(FIndexMap, 0);
  if Assigned(FMonitor) then
    for I := 0 to FMonitor.Count - 1 do begin
      if CheckProcess(FMonitor[I]) then begin
        SetLength(FIndexMap, length(FIndexMap) + 1);
        FIndexMap[High(FIndexMap)] := I;

        if FStarted <> 0 then
          FStarted := 0;

        if dbgLogProfAssign then
          Log('PID %u, Data 0x%.16x is Profile %s (%s)',
            [FMonitor[I].ProcessID, FMonitor[I].Data, FriendlyName, ProfileID]);
      end;
    end;

  UpdateState;
end;

procedure TProcessProfile.UpdateState;
var
  NewState: Integer;
begin
  NewState := GetState;
  if NewState <> FState then begin
    FState := NewState;
    if Assigned(FChange) then begin
      if dbgLogProfChange then
        Log('TProcessProfile.OnChange() called, Name %s ID %s', [FriendlyName, ProfileID]);
      FChange(Self);
    end;
  end;
end;

end.
