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

unit uJumpList;

interface

uses
  Windows, SysUtils, Classes,  ComObj, ActiveX, ShlObj, PropSys,
  PropKey, ObjectArray, Vcl.JumpList, Generics.Collections;

(*

  The Delphi VCL has a TJumpList component, but it's kinda rudimentary.

  When I wanted to use it with WinBox I've faced two problems with it:

    - It does not allow to use resource-index of icons for list.
      This practically means that every list item will have the same
      icon in your jump list (unless you use seperate icon files),
      which is unacceptable.

    - It generates access violation when you create a jump item without
      collection. A single "if Assigned(Collection) then" line would fix
      that, but since you have to set private variables in the constructor
      you can't fix it by overriding it.

  As for the first thing, the problem is in TJumpList.GetAsIShellLink,
  where you got back every time 0 for icon index in the result. The bad
  thing is, that this routine is not virtual, or dynamic, so needs hooking.

  As for the second error, you have to create an empty collection for
  each item, and free them after you've used it. It's necessary for adding recent
  recent items. This was avoided by TWinBoxProfile.GetShellLink.

  Another useful stuff is added - a compare and replace stuff for recents.
  This helps to keep the recent list tidy, even when you delete a VM, rename, etc.

*)

type
  TJumpListValidator = reference to function (const Arguments: string): IUnknown; // :IShellLink;

  TJumpListHelper = class helper for TJumpList
  public
    class procedure ValidateRecents(const AppModelID: string; Validator: TJumpListValidator);
  end;

implementation

(*

  To make this work you only have to type a number into the Icon field.
  This means an icon-index inside your program.

*)

type
  TJumpListItemHook = class(TJumpListItem)
  public
    function GetAsIShellLink2: IShellLink;
  end;


{ TJumpListItemHook }

function TJumpListItemHook.GetAsIShellLink2: IShellLink;
var
  PropStore: IPropertyStore;
  PropVar: TPropVariant;

  IconIndex: integer;
begin
  if FriendlyName = '' then begin
    Result := nil;
    exit;
  end;

  Result := CreateComObject(CLSID_ShellLink) as IShellLink;
  OleCheck(Result.QueryInterface(IPropertyStore, PropStore));

  //Set FriendlyName
  OleCheck(InitPropVariantFromString(PChar(FriendlyName), PropVar));
  OleCheck(PropStore.SetValue(PKEY_Title, PropVar));
  OleCheck(PropStore.Commit);
  OleCheck(PropVariantClear(PropVar));

  //Set Arguments
  with Result do begin
    if Arguments <> '' then
      OleCheck(SetArguments(PChar(Arguments)));

    //Set Path
    if Path = '' then
      OleCheck(SetPath(PChar(paramstr(0))))
    else
      OleCheck(SetPath(PChar(Path)));

    //Set Icon
    if TryStrToInt(Icon, IconIndex) then
      OleCheck(SetIconLocation(PChar(paramstr(0)), IconIndex))
    else if Icon <> '' then
      OleCheck(SetIconLocation(PChar(Icon), 0))
    else
      OleCheck(SetIconLocation(PChar(paramstr(0)), 0));
  end;
end;

procedure HookProc(const OldProc, NewProc: Pointer);
const
  Size = SizeOf(byte) + SizeOf(Pointer);
var
  OldProtect, NewProtect: DWORD;
begin
  (* This procedure is limited for i386, or x86-64. *)

  if not (Assigned(OldProc) and Assigned(NewProc)) then
    exit;

  if OldProc = NewProc then
    exit;

  //Check for absolute memory jump
  //00000000  FF2500000000      jmp dword [dword 0x0]

  if PWord(OldProc)^ = $25FF then begin
    HookProc(Pointer(NativeUInt(OldProc) + SizeOf(word)), NewProc);
    exit;
  end;

  NewProtect := PAGE_EXECUTE_READWRITE;
  if not VirtualProtect(OldProc, Size, NewProtect, OldProtect) then
    RaiseLastOSError;

  //Write a single byte relative jump
  //00000000  E900000000        jmp dword 0x5

  PByte(OldProc)^ := $E9;
  PNativeUInt(NativeUInt(OldProc) + SizeOf(Byte))^ :=
    NativeUInt(NewProc) - NativeUInt(OldProc) - Size;

  //MSDN: https://docs.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-flushinstructioncache
  FlushInstructionCache(GetCurrentProcess, nil, 0);
  if not VirtualProtect(OldProc, Size, OldProtect, NewProtect) then
    RaiseLastOSError;
end;

{ TJumpListHelper }

class procedure TJumpListHelper.ValidateRecents(const AppModelID: string;
  Validator: TJumpListValidator);
var
  Items: IObjectArray;
  ShellLink: IShellLink;

  I: integer;
  Count: Cardinal;
  Buffer: array [0 .. MAX_PATH + 1] of char;

  Temp: IUnknown;
  Links: TList<IShellLink>;
begin
  if not CheckWin32Version(6, 1) then
    exit;

  Links := TList<IShellLink>.Create;
  try
    if GetRecentList(AppModelID, Items) and
       Succeeded(Items.GetCount(Count)) then
      for I := Integer(Count) - 1 downto 0 do
        if Succeeded(Items.GetAt(I, IID_IShellLink, ShellLink)) and
           Succeeded(ShellLink.GetArguments(@Buffer[0], MAX_PATH)) then begin
            Temp := Validator(String(Buffer));
            if Assigned(Temp) then
              Links.Add(Temp as IShellLink);
        end;

    RemoveAllFromRecent(AppModelID);

    for I := 0 to Links.Count - 1 do begin
      AddToRecent(Links[I]);
      Links[I] := nil;
    end;
  finally
    Links.Free;
  end;
end;

initialization
  HookProc(@TJumpListItem.GetAsIShellLink, @TJumpListItemHook.GetAsIShellLink2);

end.
