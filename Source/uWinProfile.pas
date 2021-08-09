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

unit uWinProfile;

interface

uses Windows, Messages, SysUtils, uProcProfile;

(*

  Ez a profiltípus feltételezi hogy a magához rendelt TProcess.Data mezõ
    HWND értéket tartalmaz. Ezzel kapcsolatban tartalmaz lehetõségeket.

*)

type
  TWinProfile = class(TProcessProfile)
  public
    procedure BringToFront(const Index: integer = 0);
    function Execute(const CommandID: NativeUInt; const Index: integer = 0): boolean; inline;
    function IsChecked(const CommandID: NativeUInt; const Index: integer = 0): boolean;
    function Perform(const Msg, WParam, LParam: NativeUInt; const Index: integer = 0): NativeUInt;
    function Close(const Index: integer = 0): boolean; inline;

    function GetTitle(const Index: integer = 0): string;
    procedure SetTitle(const Value: string; const Index: integer = 0);
  end;

  TWinBoxProfile = class abstract(TWinProfile)
  protected
    function CanPause: boolean; //Támogatott-e a mûvelet?
  public
    function Pause(const Suspend: boolean): boolean; virtual; abstract;
    //Suspend: true = Pause, false = Resume

    function Stop(const Force: boolean): boolean;

    function CanState(const Target: integer): boolean;
    function SetState(const Target: integer; const Forced: boolean): boolean;
  end;

  TFindWindow = record
    dwFindType,
    dwPID: DWORD;
    szClassName,
    szTitle: array [0..MAX_PATH + 1] of char;
    hwnd: HWND;
  end;
  PFindWindow = ^TFindWindow;

const
  FIND_WINDOW_MAIN = 1;
  FIND_WINDOW_VISIBLE = 2;
  FIND_WINDOW_CLASSNAME = 4;
  FIND_WINDOW_TITLE = 8;

function FindWindowByPID(hwnd: HWND; pFindWindow: PFindWindow): BOOL; stdcall;

implementation

uses uCommUtil;

function FindWindowByPID(hwnd: HWND; pFindWindow: PFindWindow): BOOL; stdcall;
var
  lpdwProcessId, I: DWORD;
  szBuffer: array [0..MAX_PATH + 1] of char;

  Found: boolean;
begin
  GetWindowThreadProcessId(hwnd, lpdwProcessId);
  Found := pFindWindow^.dwPID = lpdwProcessId;
  if Found then
    for I := 0 to 3 do
      if ((1 shl I) and pFindWindow^.dwFindType) <> 0 then
        case I of
          0: Found := Found and (GetWindow(hwnd, GW_OWNER) = 0);
          1: Found := Found and IsWindowVisible(hwnd);
          2: begin
               GetClassName(hwnd, @szBuffer[0], MAX_PATH);
               Found := Found and
                 (StrComp(PWideChar(@szBuffer[0]), Addr(pFindWindow^.szClassName[0])) = 0);
             end;
          3: begin
               GetWindowText(hwnd, @szBuffer[0], MAX_PATH);
               Found := Found and
                 (StrComp(PWideChar(@szBuffer[0]), Addr(pFindWindow^.szTitle[0])) = 0);
             end;
        end;

  if Found then
    pFindWindow^.hwnd := hwnd;
  Result := not Found;
end;

{ TWinProfile }

procedure TWinProfile.BringToFront(const Index: integer);
begin
  if (Index >= 0) and (Index < Count) then
    BringWindowToFront(Handles[Index]);

  if dbgLogProcessOp then
    Log('TWinProfile.BringToFront, Index: %d', [Index]);
end;

function TWinProfile.Close(const Index: integer): boolean;
begin
  Result := Perform(WM_CLOSE, 0, 0, Index) = 0;

  if dbgLogProcessOp then
    Log('TWinProfile.Close, Index: %d, Result: %d', [Index, ord(Result)]);
end;

function TWinProfile.Execute(const CommandID: NativeUInt;
  const Index: integer): boolean;
begin
  BringToFront(Index);
  Result := Perform(WM_COMMAND, CommandID, 0, Index) = 0;

  if dbgLogProcessOp then
    Log('TWinProfile.Execute, CommandId: %u, Index: %d, Result: %d', [CommandId, Index, ord(Result)]);
end;

function TWinProfile.GetTitle(const Index: integer): string;
begin
  if (Index >= 0) and (Index < Count) then
    Result := GetWindowTitle(Handles[Index])
  else
    Result := '';

  if dbgLogProcessOp then
    Log('TWinProfile.GetTitle, Index: %d, Result: %s', [Index, Result]);
end;

function TWinProfile.IsChecked(const CommandID: NativeUInt;
  const Index: integer): boolean;
begin
  if (Index >= 0) and (Index < Count) then
    Result := (GetMenuState(GetMenu(Handles[Index]), CommandID, MF_BYCOMMAND) and MF_CHECKED) <> 0
  else
    Result := false;

  //if dbgLogProcessOp then
  //  Log('TWinProfile.IsChecked, CommandId: %u, Index: %d, Result: %d', [CommandID, Index, ord(Result)]);
end;

function TWinProfile.Perform(const Msg, WParam, LParam: NativeUInt;
  const Index: integer): NativeUInt;
begin
  if (Index >= 0) and (Index < Count) and (Processes[0].Data <> 0) then begin
    PostMessage(Processes[0].Data, Msg, WParam, LParam);
    Result := 0;
  end
  else
    Result := NativeUInt(-1);

  if dbgLogProcessOp then
    Log('TWinProfile.Perform, %u, %u, %u, %d, Result: %u',
      [Msg, WParam, LParam, Index, Result]);
end;

procedure TWinProfile.SetTitle(const Value: string; const Index: integer);
begin
  if (Index >= 0) and (Index < Count) then
    SetWindowText(Handles[Index], PChar(Value));

  if dbgLogProcessOp then
    Log('TWinProfile.SetTitle, Value: %s, Index: %d', [Value, Index]);
end;

{ TWinBoxProfile }

function TWinBoxProfile.CanPause: boolean;
type
  TPause = function (const Suspend: boolean): boolean of object;
var
  Impl: TPause;
  Base: TPause;
  ClassTProfile: TClass;
begin
  Impl := Pause;
  ClassTProfile := Self.ClassType;

  while (ClassTProfile <> nil) and (ClassTProfile <> TWinBoxProfile) do
    ClassTProfile := ClassTProfile.ClassParent;

  if ClassTProfile = nil then
    exit(false);

  Base := TWinBoxProfile(@ClassTProfile).Pause;
  Result := TMethod(Impl).Code <> TMethod(Base).Code;
end;

function TWinBoxProfile.CanState(const Target: integer): boolean;
var
  Current: integer;
begin
  Current := State;

  case Current of
    PROFILE_STATE_STOPPED: Result := (Target = PROFILE_STATE_RUNNING);
    PROFILE_STATE_RUNNING: Result := (Target = PROFILE_STATE_STOPPED) or
                                     (CanPause and
                                      (Target = PROFILE_STATE_PAUSED));
    PROFILE_STATE_PAUSED:  Result := CanPause and
                                     ((Target = PROFILE_STATE_STOPPED) or
                                      (Target = PROFILE_STATE_RUNNING));
    PROFILE_STATE_ERROR_MULTINST: Result := (Target = PROFILE_STATE_STOPPED)
    else
      Result := false;
  end;
end;

function TWinBoxProfile.SetState(const Target: integer;
  const Forced: boolean): boolean;
var
  Current: integer;
begin
  Current := State;
  Result := false;

  case Current of
    PROFILE_STATE_STOPPED:
      if (Target = PROFILE_STATE_RUNNING) then
        Result := Start;
    PROFILE_STATE_RUNNING:
      if Target = PROFILE_STATE_STOPPED then
        Result := Stop(Forced)
      else if CanPause and (Target = PROFILE_STATE_PAUSED) then
        Result := Pause(true);
    PROFILE_STATE_PAUSED:
      begin
        if not CanPause then exit;

        if Target = PROFILE_STATE_STOPPED then
          Result := Stop(Forced)
        else if Target = PROFILE_STATE_RUNNING then
          Result := Pause(false);
      end;
    PROFILE_STATE_ERROR_MULTINST:
      if Target = PROFILE_STATE_STOPPED then
        Result := Stop(Forced);
  end;
end;

function TWinBoxProfile.Stop(const Force: boolean): boolean;
var
  I: integer;
begin
  Result := true;
  if Force then
    Terminate(true)
  else
    for I := 0 to Count - 1 do
      Result := Result and Close(I);

  if dbgLogProcessOp then
    Log('TWinBoxProfile.Stop, Force: %d, Result: %d', [ord(Force), ord(Result)]);
end;

end.
