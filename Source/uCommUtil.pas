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

unit uCommUtil;

interface

uses Windows, SysUtils, Classes, Controls, Dialogs, Graphics, ExtCtrls,
     WinCodec, Registry, ComCtrls, ShellAPI, IniFiles;

type
  TRegHelper = class helper for TRegistry
  public
    function ReadStringDef(const Name, Default: string): string;
    function ReadIntegerDef(const Name: string; const Default: integer): integer;
    function ReadBoolDef(const Name: string; const Default: boolean): boolean; inline;

    function ReadBinaryStream(const Name: string; Stream: TStream): boolean;
    function ReadStringMulti(const Name: string; Strings: TStrings): boolean;

    procedure WriteStringChk(const Name, Value, Default: string);
    procedure WriteIntegerChk(const Name: string; const Value, Default: integer);
    procedure WriteBoolChk(const Name: string; const Value, Default: boolean); inline;

    function WriteBinaryStream(const Name: string; Stream: TStream; const Count: integer): boolean;
    function WriteStringMulti(const Name: string; Strings: TStrings): boolean;
  end;

  TMemIniHelper = class helper for TMemIniFile
  public
    procedure SaveToFile(const FileName: string); overload;
    procedure SaveToFile(const FileName: string; Encoding: TEncoding); overload;
  end;

function RegReadMulti(CurrentKey: HKEY; const Name: string; Strings: TStrings): boolean;
function RegWriteMulti(CurrentKey: HKEY; const Name: string; Strings: TStrings): boolean;

function PathCompactPathExW(pszOut: PChar; pszSrc: PChar; cchMax: UINT; dwFlags: DWORD): BOOL; stdcall; external 'shlwapi.dll';

function CanLockFile(const FileName: string; const Access: DWORD = GENERIC_READ or GENERIC_WRITE): boolean;

function GetFileVer(const FileName: string): string;
function GetFileTime(const FileName: string): TDateTime;

procedure DisplayWIC(var Source: TWICImage; Image: TImage);
procedure ScaleWIC(var Source: TWICImage; const Width, Height: integer);

procedure LoadImage(const Name: string; Image: TImage);

function DeleteWithShell(FileName: string; const AllowUndo: boolean = true): boolean;

procedure Log(const Text: string); overload; inline;
procedure Log(const Text: string; const Args: array of const); overload;

function CommandLineToArgs(const CommandLine: string): TStringList;
function ExpandFileNameTo(const FileName, BaseDir: string): string;
function CompactFileNameTo(const FileName, BaseDir: string): string;

function LoadIconWithScaleDown(hinst: HINST; pszName: LPCWSTR; cx: Integer;
    cy: Integer; var phico: HICON): HResult; stdcall; external 'comctl32.dll';
{$EXTERNALSYM LoadIconWithScaleDown}

function CommandLineToArgvW(lpCmdLine: LPCWSTR; var pNumArgs: integer): PPWideChar; stdcall; external 'shell32.dll';
{$EXTERNALSYM CommandLineToArgvW}

function PathIsRelativeW(pszPath: LPCWSTR): BOOL; stdcall; external 'shlwapi.dll';
{$EXTERNALSYM PathIsRelativeW}

function PathCanonicalizeW(lpszDst: PChar; lpszSrc: PChar): LongBool; stdcall;
  external 'shlwapi.dll';
{$EXTERNALSYM PathCanonicalizeW}

function PathRelativePathToW(pszPath: PChar; pszFrom: PChar; dwAttrFrom: DWORD;
  pszTo: PChar; dwAttrTo: DWORD): LongBool; stdcall; external 'shlwapi.dll';
{$EXTERNALSYM PathRelativePathToW}

function StrCmpLogicalW(psz1, psz2: PWideChar): Integer; stdcall; external 'shlwapi.dll';
{$EXTERNALSYM StrCmpLogicalW}

function TextRight(const S: string; const Separator: char = '.'): string;
function TextLeft(const S: string; const Separator: char = '.'): string;

function GetWindowTitle(const hwnd: HWND): string;
function GetWindowClass(const hwnd: HWND): string;
procedure BringWindowToFront(const Handle: HWND);

function FileSizeToStr(const Value: uint64; const Round: byte;
  const Divisor: extended = 1024): string;
function GetFiles(dir: string; subdir: Boolean; List: TStringList): uint64;

procedure ColorProgress(const Control: TProgressBar); inline;

function NextImageName(Directory: string; const ImageBase: string = 'vdisk'): string;

function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string; Parent: TWinControl): Boolean;

function TryLoadIni(const FileName: string): TMemIniFile;
procedure TryLoadList(Stream: TStream; List: TStrings; const Origin: int64 = 0);

//színek a háttérszín alapján
function GetTextColor(const Color: TColor): TColor;
function GetLinkColor(Color: TColor): TColor;

//Source: https://stackoverflow.com/questions/1581975/how-to-pop-up-the-windows-context-menu-for-a-given-file-using-delphi/1584204
procedure ShowSysPopup(aFile: string; x, y: integer; HND: HWND);

implementation

uses ComObj, ShlObj, ActiveX, FileCtrl;

resourcestring
  InfWinBox = 'WinBox.inf';

function TryLoadIni(const FileName: string): TMemIniFile;
begin
  try
    Result := TMemIniFile.Create(FileName, TEncoding.UTF8);
  except
    on E: EEncodingError do
      try
        FreeAndNil(Result);
        Result := TMemIniFile.Create(FileName);
      except
        on E: EFOpenError do
          FreeAndNil(Result);
        else
          raise;
      end;
    on E: EFOpenError do
      FreeAndNil(Result);
    else
      raise;
  end;
end;

procedure TryLoadList(Stream: TStream; List: TStrings; const Origin: int64 = 0);
begin
  try
    List.LoadFromStream(Stream, TEncoding.UTF8);
	except
	  on E: EEncodingError do begin
	    List.Clear;
		  Stream.Position := Origin;
      List.LoadFromStream(Stream);
    end
    else
      raise;
  end;
end;

function SelectDirectory(const Caption: string; const Root: WideString;
  var Directory: string; Parent: TWinControl): Boolean;
begin
  if Win32MajorVersion >= 6 then
    with TFileOpenDialog.Create(nil) do
      try
        Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];

        DefaultFolder := Directory;
        FileName := Directory;

        Result := Execute(Parent.Handle);
        if Result then
          Directory := FileName;
      finally
        Free;
      end
    else
      Result := FileCtrl.SelectDirectory(Caption, Root, Directory,
                                         [sdNewUI, sdNewFolder], Parent);
end;

function NextImageName(Directory: string; const ImageBase: string): string;
const
  Formats: array [0..3] of string = ('.img', '.ima', '.vhd', '.vfd');
var
  UUID: TGUID;
  I, J: integer;
  Found: boolean;
  Temp: string;
begin
  Directory := IncludeTrailingPathDelimiter(Directory);

  Result := '';
  for I := 0 to 99 do begin
    Temp := format(ImageBase + '%.2d', [I]);
    Found := false;
    for J := 0 to High(Formats) do begin
      Found := Found or FileExists(Directory + Temp + Formats[J]);
      if Found then
        break;
    end;

    if not Found then begin
      Result := Directory + Temp;
      break;
    end;
  end;

  if Result = '' then begin
    CreateGUID(UUID);
    Result := GUIDToString(UUID);
  end;
end;

function CanLockFile(const FileName: string; const Access: DWORD): boolean;
var
  Handle: THandle;
begin
  Handle := CreateFile(PChar(FileName), Access,
                       0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);

  Result := (Handle <> 0) and (Handle <> INVALID_HANDLE_VALUE);
  if Result then
    CloseHandle(Handle);
end;

function GetTextColor(const Color: TColor): TColor;
begin
  if (Color = clBtnFace) or (Color = clWindow) then
    Result := clWindowText
  else if 0.299 * GetRValue(Color) + 0.587 * GetGValue(Color) +
      0.114 * GetBValue(Color) > 127 then
    Result := clBlack
  else
    Result := clWhite;
end;

function GetLinkColor(Color: TColor): TColor;
var
  R, G, B, A: byte;
const
  VisibleDelta = 15;
begin
  if (Color = clBtnFace) or (Color = clWindow) or (Color = clNone) then
    Result := clHotLight
  else begin
    Color := ColorToRGB(Color);
    R := GetRValue(Color);
    G := GetGValue(Color);
    B := GetBValue(Color);

    A := byte((longword(R) + G + B) div 3);

    if (abs(R - A) + abs(B - A) + abs(G - A)) div 3 > VisibleDelta then
       Result := RGB($FF - R, $FF - G, $FF - B)
    else if A < 128 then
       Result := clWhite
    else
       Result := clBlack;
  end;
end;

procedure ColorProgress(const Control: TProgressBar); inline;
begin
  if Control.Position > 90 then
    Control.State := pbsError
  else if Control.Position > 75 then
    Control.State := pbsPaused
  else
    Control.State := pbsNormal;
end;

function FileSizeToStr(const Value: uint64; const Round: byte;
  const Divisor: extended): string;
var
  I: integer;
  fValue: extended;
const
  szA: array [0..8] of char = (' ', 'k', 'M', 'G', 'T', 'P', 'E', 'P', 'Z');
begin
  fValue := Value;
  I := 0;
  while (fValue >= Divisor) and (I < 9) do begin
    fValue := fValue / Divisor;
    inc(I);
  end;
  Result := FloatToStrF(fValue, ffNumber, 8, Round) + ' ' + szA[I] + 'B';
end;

function GetFiles(dir: string; subdir: Boolean; List: TStringList): uint64;
var
  rec: TSearchRec;
  found: Integer;
  size: _LARGE_INTEGER;
begin
  Result := 0;
  if dir[Length(dir)] <> '\' then dir := dir + '\';
  found := FindFirst(dir + '*.*', faAnyFile, rec);
  while found = 0 do
  begin

    size.QuadPart := 0;
    size.LowPart := GetCompressedFileSize(PChar(dir + rec.Name), @size.HighPart);
    Result := Result + uint64(size.QuadPart);

    if (rec.Attr and faDirectory > 0) and (rec.Name[1] <> '.') and (subdir = True) then
      Inc(Result, GetFiles(dir + rec.Name, True, List));

    if (rec.Attr and faDirectory = 0) then
      List.Add(dir + rec.Name);
    found := FindNext(rec);
  end;
  FindClose(rec);
end;

function TextLeft(const S: string; const Separator: char = '.'): string;
var
  P: integer;
begin
  P := pos(Separator, S);
  if P <> 0 then
    Result := Copy(S, 1, P - 1)
  else
    Result := '';
end;

function TextRight(const S: string; const Separator: char = '.'): string;
var
  P: integer;
begin
  P := pos(Separator, S);
  if P <> 0 then
    Result := Copy(S, P + 1, MaxInt)
  else
    Result := '';
end;

function CompactFileNameTo(const FileName, BaseDir: string): string;
var
  Path: array[0 .. MAX_PATH - 1] of char;
begin
  PathRelativePathToW(@Path[0], PChar(BaseDir),
     FILE_ATTRIBUTE_DIRECTORY, PChar(FileName), 0);

  Result := Path;
end;

function ExpandFileNameTo(const FileName, BaseDir: string): string;
var
  Buffer: array [0..MAX_PATH-1] of Char;
begin
  if PathIsRelativeW(PChar(FileName)) then begin
    Result := IncludeTrailingPathDelimiter(BaseDir)+FileName;
  end else begin
    Result := FileName;
  end;
  if PathCanonicalizeW(@Buffer[0], PChar(Result)) then begin
    Result := Buffer;
  end;
end;

function CommandLineToArgs(const CommandLine: string): TStringList;
var
  Buffer: PPWideChar;
  Count, I: integer;
begin
  Result := TStringList.Create;
  Buffer := CommandLineToArgvW(PChar(CommandLine), Count);
  if Buffer <> nil then
    for I := 0 to Count - 1 do
      Result.Add(PPWideChar(NativeInt(Buffer) + I * SizeOf(Pointer))^);
  LocalFree(THandle(Buffer));
end;

function GetWindowTitle(const hwnd: HWND): string;
var
  Buffer: array [0..MAX_PATH + 1] of char;
begin
  GetWindowText(hwnd, @Buffer, MAX_PATH);
  Result := string(Buffer);
end;

function GetWindowClass(const hwnd: HWND): string;
var
  Buffer: array [0..MAX_PATH + 1] of char;
begin
  GetClassName(hwnd, @Buffer, MAX_PATH);
  Result := string(Buffer);
end;

procedure BringWindowToFront(const Handle: HWND);
var
  Placement: TWindowPlacement;
begin
  Placement.length := SizeOf(Placement);

  if GetWindowPlacement(Handle, Placement) and
     ((Placement.showCmd and SW_SHOWMINIMIZED) <> 0) then begin
       Placement.showCmd := SW_SHOWNORMAL;
       SetWindowPlacement(Handle, Placement);
     end;
  BringWindowToTop(Handle);
end;

procedure Log(const Text: string);
begin
  OutputDebugString(PChar(Text));
end;

procedure Log(const Text: string; const Args: array of const);
begin
  OutputDebugString(PChar(format(Text, Args)));
end;

function DeleteWithShell(FileName: string; const AllowUndo: boolean): boolean;
var
  FileOp: TSHFileOpStruct;
begin
  FillChar(FileOp, SizeOf(FileOp), #0);
  FileName := FileName + #0#0;
  with FileOp do begin
    wFunc := FO_DELETE;
    pFrom := @FileName[1];
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;

    if AllowUndo then
      fFlags := fFlags or FOF_ALLOWUNDO;
  end;
  Result := SHFileOperation(FileOp) = 0;
end;

procedure ScaleWIC(var Source: TWICImage; const Width, Height: integer); overload;
var
  Factory: IWICImagingFactory;
  Scaler: IWICBitmapScaler;
begin
  if not Assigned(Source) then
    exit;

  try
    Factory := TWICImage.ImagingFactory;
    Factory.CreateBitmapScaler(Scaler);
    Scaler.Initialize(Source.Handle, Width, Height,
      WICBitmapInterpolationModeHighQualityCubic);
  finally
    Source.Handle := IWICBitmap(Scaler);
    Scaler := nil;
    Factory := nil;
  end;
end;

procedure DisplayWIC(var Source: TWICImage; Image: TImage);
var
  Temp: TWICImage;
begin
  Temp := TWICImage.Create;
  Temp.Assign(Source);
  ScaleWIC(Temp, Image.Width, Image.Height);
  Image.Picture.Assign(Temp);
  Temp.Free;
end;

procedure LoadImage(const Name: string; Image: TImage);
var
  Bitmap: TWICImage;
  Stream: TResourceStream;
begin
  Bitmap := TWICImage.Create;
  Stream := TResourceStream.Create(hInstance, Name, RT_RCDATA);
  try
    Bitmap.LoadFromStream(Stream);
    DisplayWIC(Bitmap, Image);
  finally
    Stream.Free;
    Bitmap.Free;
  end;
end;

function GetFileVer(const FileName: string): string;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  if not FileExists(FileName) then
    exit;

  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
          Result := Format('v%d.%d.%d.%d', [
            HiWord(dwFileVersionMS),
            LoWord(dwFileVersionMS),
            HiWord(dwFileVersionLS),
            LoWord(dwFileVersionLS)]);
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

function GetFileTime(const FileName: string): TDateTime;
var
  SystemTime, LocalTime: TSystemTime;
  fad: TWin32FileAttributeData;
begin
  if GetFileAttributesEx(PChar(FileName), GetFileExInfoStandard, @fad) and
     FileTimeToSystemTime(fad.ftLastWriteTime, SystemTime) and
     SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
       Result := SystemTimeToDateTime(LocalTime)
  else
       Result := 0;
end;

function RegReadMulti(CurrentKey: HKEY; const Name: string; Strings: TStrings): boolean;
var
  Buffer, Temp: PChar;
  ValueType, ValueLen: DWORD;
begin
  Result := RegQueryValueEx(CurrentKey, PChar(Name), nil, @ValueType, nil, @ValueLen) = ERROR_SUCCESS;
  if Result and (ValueType = REG_MULTI_SZ) then begin
    GetMem(Buffer, ValueLen);
    try
      Result := RegQueryValueEx(CurrentKey, PChar(Name), nil, nil, PByte(Buffer), @ValueLen) = ERROR_SUCCESS;
      Temp := Buffer;
      if Result then
        while Temp^ <> #0 do begin
          Strings.Add(Temp);
          Temp := PChar(Pointer(NativeInt(Temp) + (lstrlen(Temp) + 1) * SizeOf(Char)));
        end;
    finally
      FreeMem(Buffer, ValueLen);
    end;
  end;
end;

function RegWriteMulti(CurrentKey: HKEY; const Name: string; Strings: TStrings): boolean;
var
  Text, S: string;
begin
  Text := '';
  for S in Strings do
    Text := Text + S + #0;
  Text := Text + #0;

  Result := RegSetValueEx(CurrentKey, PChar(Name), 0, REG_MULTI_SZ,
    Pointer(@Text[1]), Length(Text) * SizeOf(Char)) = ERROR_SUCCESS;
end;

{ TRegHelper }

function TRegHelper.ReadStringDef(const Name, Default: string): string;
begin
  if ValueExists(Name) and (GetDataType(Name) in [rdString, rdExpandString]) then
    Result := ReadString(Name)
  else
    Result := Default;
end;

function TRegHelper.ReadBoolDef(const Name: string;
  const Default: boolean): boolean;
begin
  Result := ReadIntegerDef(Name, ord(Default)) <> 0;
end;

function TRegHelper.ReadIntegerDef(const Name: string; const Default: integer): integer;
begin
  if ValueExists(Name) and (GetDataType(Name) = rdInteger) then
    Result := ReadInteger(Name)
  else
    Result := Default;
end;

function TRegHelper.ReadBinaryStream(const Name: string; Stream: TStream): boolean;
var
  Buffer: Pointer;
  Size: integer;
begin
  Result := false;
  if Assigned(Stream) and ValueExists(Name) and (GetDataType(Name) = rdBinary) then begin
    Size := GetDataSize(Name);
    GetMem(Buffer, Size);
    try
      ReadBinaryData(Name, Buffer^, Size);
      Stream.WriteBuffer(Buffer^, Size);
      Result := true;
    finally
      FreeMem(Buffer, Size);
    end;
  end;
end;

function TRegHelper.ReadStringMulti(const Name: string; Strings: TStrings): boolean;
begin
  Result := RegReadMulti(CurrentKey, Name, Strings);
end;

procedure TRegHelper.WriteIntegerChk(const Name: string; const Value,
  Default: integer);
begin
  DeleteValue(Name);

  if Value <> Default then
    WriteInteger(Name, Value);
end;

procedure TRegHelper.WriteStringChk(const Name, Value, Default: string);
begin
  DeleteValue(Name);

  if Value <> Default then
    WriteString(Name, Value);
end;

procedure TRegHelper.WriteBoolChk(const Name: string; const Value,
  Default: boolean);
begin
  WriteIntegerChk(Name, ord(Value), ord(Default));
end;

function TRegHelper.WriteBinaryStream(const Name: string; Stream: TStream;
  const Count: integer): boolean;
var
  Buffer: Pointer;
  Size: integer;
begin
  Result := false;
  if Assigned(Stream) and (Count > 0) then begin
    Size := GetDataSize(Name);
    GetMem(Buffer, Size);
    try
      Stream.ReadBuffer(Buffer^, Size);

      DeleteValue(Name);

      WriteBinaryData(Name, Buffer^, Size);
      Result := true;
    finally
      FreeMem(Buffer, Size);
    end;
  end;
end;

function TRegHelper.WriteStringMulti(const Name: string;
  Strings: TStrings): boolean;
begin
  DeleteValue(Name);

  Result := RegWriteMulti(CurrentKey, Name, Strings);
end;

{ TMemIniHelper }

procedure TMemIniHelper.SaveToFile(const FileName: string);
begin
  SaveToFile(FileName, Encoding);
end;

procedure TMemIniHelper.SaveToFile(const FileName: string; Encoding: TEncoding);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    GetStrings(L);
    L.SaveToFile(FileName, Encoding);
  finally
    L.Free;
  end;
end;

//Source: https://stackoverflow.com/questions/1581975/how-to-pop-up-the-windows-context-menu-for-a-given-file-using-delphi/1584204
procedure ShowSysPopup(aFile: string; x, y: integer; HND: HWND);
var
  Root: IShellFolder;
  ShellParentFolder: IShellFolder;
  chEaten,dwAttributes: ULONG;
  FilePIDL,ParentFolderPIDL: PItemIDList;
  CM: IContextMenu;
  Menu: HMenu;
  Command: LongBool;
  ICM2: IContextMenu2;

  ICI: TCMInvokeCommandInfo;
  ICmd: integer;
  P: TPoint;
Begin
  OleCheck(SHGetDesktopFolder(Root));//Get the Desktop IShellFolder interface

  OleCheck(Root.ParseDisplayName(HND, nil,
    PWideChar(WideString(ExtractFilePath(aFile))),
    chEaten, ParentFolderPIDL, dwAttributes)); // Get the PItemIDList of the parent folder

  OleCheck(Root.BindToObject(ParentFolderPIDL, nil, IShellFolder,
  ShellParentFolder)); // Get the IShellFolder Interface  of the Parent Folder

  OleCheck(ShellParentFolder.ParseDisplayName(HND, nil,
    PWideChar(WideString(ExtractFileName(aFile))),
    chEaten, FilePIDL, dwAttributes)); // Get the relative  PItemIDList of the File

  ShellParentFolder.GetUIObjectOf(HND, 1, FilePIDL, IID_IContextMenu, nil, CM); // get the IContextMenu Interace for the file

  if CM = nil then Exit;
  P.X := X;
  P.Y := Y;

  Windows.ClientToScreen(HND, P);

  Menu := CreatePopupMenu;

  try
    CM.QueryContextMenu(Menu, 0, 1, $7FFF, CMF_EXPLORE or CMF_CANRENAME);
    CM.QueryInterface(IID_IContextMenu2, ICM2); //To handle submenus.
    try
      Command := TrackPopupMenu(Menu, TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_RIGHTBUTTON or
        TPM_RETURNCMD, p.X, p.Y, 0, HND, nil);
    finally
      ICM2 := nil;
    end;

    if Command then
    begin
      ICmd := LongInt(Command) - 1;
      FillChar(ICI, SizeOf(ICI), #0);
      with ICI do
      begin
        cbSize := SizeOf(ICI);
        hWND := 0;
        lpVerb := MakeIntResourceA(ICmd);
        nShow := SW_SHOWNORMAL;
      end;
      CM.InvokeCommand(ICI);
    end;
  finally
     DestroyMenu(Menu)
  end;
End;

initialization
  randomize;

end.
