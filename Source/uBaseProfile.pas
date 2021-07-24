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

unit uBaseProfile;

interface

uses Windows, SysUtils, Classes, Graphics, Registry;

type
  TProfile = class
    private
      FWorkingDirectory: string;
      procedure SetWorkingDirectory(const Value: string);
    public
      ProfileID: string;

      FriendlyName,
      Description,
      ExecutablePath,
      OptionalParams: string;

      Color: TColor;

      EraseProt,
      Fullscreen,
      HasIcon: boolean;

      Icon: TWICImage;

      LoggingMode,
      DebugMode,
      CrashDump: integer;

      constructor Create(const AProfileID: string; const AutoLoad: boolean);
      destructor Destroy; override;

      procedure CreateID;

      class procedure Delete(const AProfileID: string);
      class procedure GetList(Strings: TStrings);

      procedure Default; virtual;
      procedure DefaultIcon;

      procedure Reload; virtual;
      procedure ReloadIcon;

      function GetLogFile: string;

      procedure ImportWinBox(const AProfileID: string);
      class procedure GetWinBoxVMs(Strings: TStrings);

      procedure Import86Mgr(const AFriendlyName: string);
      class procedure Get86MgrVMs(Strings: TStrings);

      procedure Save;

      property WorkingDirectory: string read FWorkingDirectory write SetWorkingDirectory;
  end;

var
  DefProfile: TProfile;

implementation

uses uCommUtil, uCommText, uConfigMgr, uLang, IOUtils;

var
  AutoLogsPath: string;

resourcestring
  RegMachineKey = 'Software\Laci bá''\WinBox for 86Box\Virtual Machines\';

  KeyFriendlyName     = 'FriendlyName';
  KeyWorkingDirectory = 'WorkingDirectory';
  KeyDescription      = 'Description';
  KeyExecutablePath   = 'ExecutablePath';
  KeyOptionalParams   = 'OptionalParams';
  KeyColor            = 'BackgroundColor';
  KeyEraseProt        = 'EraseProtection';
  KeyFullscreen       = 'Fullscreen';
  KeyGlobalDebug      = 'GlobalDebug';
  KeyDebugMode        = 'DebugMode';
  KeyCrashDump        = 'CrashDump';
  KeyLogging          = 'LoggingMode';

  ImportWinBoxVMs = 'Software\Laci bá''\WinBox\Profiles.86Box\';
  Import86MgrVMs  = 'Software\86Box\Virtual Machines';

  EInvalidRegProfile   = 'WinBox.EInvalidRegProfile';
  EInvalid86MgrVersion = 'WinBox.EInvalid86MgrVersion';

  DefAutoLogsPath   = 'WinBox for 86Box\Log Files\';
  DefLocalLogSingle = '86Box.log';
  DefLocalLogAuto   = 'logs\';

{ TProfile }

constructor TProfile.Create(const AProfileID: string; const AutoLoad: boolean);
begin
  Icon := TWICImage.Create;

  if AProfileID = '' then
    CreateID
  else
    ProfileID := AProfileID;

  if AutoLoad then
    Reload
  else
    Default;
end;

procedure TProfile.CreateID;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  ProfileID := GUIDToString(GUID);
end;

procedure TProfile.Default;
begin
  WorkingDirectory := Config.MachineRoot + ProfileID + PathDelim;
  FriendlyName := ProfileID;
  Description := '';
  ExecutablePath := Config.EmulatorPath;
  OptionalParams := '';
  Color := clNone;
  EraseProt := Config.EraseProtLvl > 1;
  Fullscreen := false;

  DebugMode := 0;
  CrashDump := 0;
  LoggingMode := 0;

  DefaultIcon;
end;

procedure TProfile.DefaultIcon;
var
  Stream: TResourceStream;
begin
  HasIcon := false;
  Stream := TResourceStream.Create(hInstance, VmIconRes, RT_RCDATA);
  try
    Icon.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

class procedure TProfile.Delete(const AProfileID: string);
begin
  with TRegistry.Create(KEY_ALL_ACCESS) do
    try
      if OpenKey(RegMachineKey, false) then
        try
          DeleteKey(AProfileID);
        finally
          CloseKey;
        end;
    finally
      Free;
    end;
end;

destructor TProfile.Destroy;
begin
  Icon.Free;
  inherited;
end;

class procedure TProfile.Get86MgrVMs(Strings: TStrings);
begin
  with TRegistry.Create(KEY_READ) do
    try
      if OpenKeyReadOnly(Import86MgrVMs) then
        try
          GetValueNames(Strings);
        finally
          CloseKey;
        end;
    finally
      Free;
    end;
end;

class procedure TProfile.GetList(Strings: TStrings);
begin
  with TRegistry.Create(KEY_READ) do
    try
      if OpenKeyReadOnly(RegMachineKey) then
        try
          GetKeyNames(Strings);
        finally
          CloseKey;
        end;
    finally
      Free;
    end;
end;

function TProfile.GetLogFile: string;
var
  Temp: integer;
begin
  if LoggingMode = 0 then
    Temp := Config.LoggingMode
  else
    Temp := LoggingMode - 1;

  case Temp of
    0: Result := '';
    1: Result := Config.GlobalLogFile;
    2: Result := AutoLogsPath + FormatDateTime(StrDateTimeAsLogName, Now) + '.log';
    3: Result := WorkingDirectory + DefLocalLogSingle;
    4: Result := WorkingDirectory + DefLocalLogAuto + FormatDateTime(StrDateTimeAsLogName, Now) + '.log';
  end;
end;

class procedure TProfile.GetWinBoxVMs(Strings: TStrings);
begin
  with TRegistry.Create(KEY_READ) do
    try
      if OpenKeyReadOnly(ExcludeTrailingPathDelimiter(ImportWinBoxVMs)) then
        try
          GetKeyNames(Strings);
        finally
          CloseKey;
        end;
    finally
      Free;
    end;
end;

procedure TProfile.Import86Mgr(const AFriendlyName: string);
const
  Version: array [0..6] of byte = ($31, $2E, $37, $2E, $32, $2E, $30);
  VersionOffset = $2A;

  DataOffset = $13C;
var
  TextLen, I: byte;
  Text: UTF8String;
begin
  CreateID;
  EraseProt := Config.EraseProtLvl > 0;

  with TRegistry.Create(KEY_READ) do
   try
     if OpenKeyReadOnly(Import86MgrVMs) then
       try
         if ValueExists(AFriendlyName) then
           with TMemoryStream.Create do
             try
               SetSize(GetDataSize(AFriendlyName));
               ReadBinaryData(AFriendlyName, Memory^, Size);

               if not CompareMem(Pointer(NativeInt(Memory) + VersionOffset),
                                 @Version[0], length(Version)) then
                 raise Exception.Create(_T(EInvalid86MgrVersion));

               Seek(DataOffset, soFromBeginning);
               for I := 1 to 3 do begin
                 ReadBuffer(TextLen, 1);

                 SetLength(Text, TextLen);
                 Text[High(Text)] := #0;
                 if Size > 0 then
                   ReadBuffer(Text[1], TextLen);

                 Seek(5, soFromCurrent);

                 case I of
                   1: FriendlyName     := String(Text);
                   2: Description      := String(Text);
                   3: WorkingDirectory := String(Text);
                 end;
               end;
             finally
               SetLength(Text, 0);
               Free;
             end;
       finally
         CloseKey;
       end;
   finally
     Free;
   end;

   if AFriendlyName = '' then
     FriendlyName := ProfileID;

   if WorkingDirectory = '' then begin
     WorkingDirectory := Config.MachineRoot + ProfileID + PathDelim;
     raise Exception.CreateFmt(_T(EInvalidRegProfile),
      [Import86MgrVMs, 'TProfile.Import86Mgr, AFriendlyName: ' + AFriendlyName]);
   end
   else
     WorkingDirectory := IncludeTrailingPathDelimiter(WorkingDirectory);
end;

procedure TProfile.ImportWinBox(const AProfileID: string);
begin
  ProfileID := AProfileID;
  FriendlyName := AProfileID;
  WorkingDirectory := Config.MachineRoot + AProfileID + PathDelim;
  EraseProt := Config.EraseProtLvl > 0;

  with TRegIniFile.Create(ImportWinBoxVMs, KEY_READ) do
    try
      ExecutablePath := ReadString(ProfileID, KeyExecutablePath, ExecutablePath);
      FriendlyName := ReadString(ProfileID, KeyFriendlyName, FriendlyName);
      WorkingDirectory := ReadString(ProfileID, KeyWorkingDirectory, WorkingDirectory);

      //Ennél a két értéknél fix default értékkel dolgozott a program, amt
      // tiszteletben kell tartani importálásnál. A többinél nincs ilyen.
      OptionalParams := ReadString(ProfileID, KeyOptionalParams, '');
      Color := TColor(ReadInteger(ProfileID, KeyColor, Integer(clNone)));
    finally
      Free;
    end;
end;

procedure TProfile.Reload;
begin
  Default;

  with TRegistry.Create(KEY_READ) do
    try
      if OpenKeyReadOnly(RegMachineKey + ProfileID) then
        try
          WorkingDirectory := ReadStringDef(KeyWorkingDirectory, WorkingDirectory);
          FriendlyName := ReadStringDef(KeyFriendlyName, FriendlyName);
          Description := ReadStringDef(KeyDescription, Description);
          ExecutablePath := ReadStringDef(KeyExecutablePath, ExecutablePath);
          OptionalParams := ReadStringDef(KeyOptionalParams, OptionalParams);
          Color := TColor(ReadIntegerDef(KeyColor, Integer(Color)));
          EraseProt := ReadBoolDef(KeyEraseProt, EraseProt);
          Fullscreen := ReadBoolDef(KeyFullscreen, Fullscreen);
          DebugMode := ReadIntegerDef(KeyDebugMode, DebugMode);
          CrashDump := ReadIntegerDef(KeyCrashDump, CrashDump);
          LoggingMode := ReadIntegerDef(KeyLogging, LoggingMode);
        finally
          CloseKey;
        end;
    finally
      Free;
    end;
end;

procedure TProfile.ReloadIcon;
begin
  if FileExists(FWorkingDirectory + VmIconFile) then begin
    HasIcon := true;
    Icon.LoadFromFile(FWorkingDirectory + VmIconFile);
  end
  else
    DefaultIcon;
end;

procedure TProfile.Save;
begin
  with TRegistry.Create(KEY_ALL_ACCESS) do
    try
      if OpenKey(RegMachineKey + ProfileID, true) then
        try
          //Ennél a két paraméternél nem elég a DefProfile-lal összehasonlítani.
          WriteStringChk(KeyWorkingDirectory, WorkingDirectory, Config.MachineRoot + ProfileID + PathDelim);
          WriteStringChk(KeyFriendlyName, FriendlyName, ProfileID);
          //A többinél viszont igen.
          WriteStringChk(KeyDescription, Description, DefProfile.Description);
          WriteStringChk(KeyExecutablePath, ExecutablePath, DefProfile.ExecutablePath);
          WriteStringChk(KeyOptionalParams, OptionalParams, DefProfile.OptionalParams);
          WriteIntegerChk(KeyColor, Integer(Color), Integer(DefProfile.Color));
          WriteBoolChk(KeyEraseProt, EraseProt, DefProfile.EraseProt);
          WriteBoolChk(KeyFullscreen, Fullscreen, DefProfile.Fullscreen);
          WriteIntegerChk(KeyDebugMode, DebugMode, DefProfile.DebugMode);
          WriteIntegerChk(KeyCrashDump, CrashDump, DefProfile.CrashDump);
          WriteIntegerChk(KeyLogging, LoggingMode, DefProfile.LoggingMode);
        finally
          CloseKey;
        end;
    finally
      Free;
    end;
end;

procedure TProfile.SetWorkingDirectory(const Value: string);
begin
  FWorkingDirectory := Value;
  ReloadIcon;
end;

initialization
  AutoLogsPath := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath) + DefAutoLogsPath;
  DefProfile := TProfile.Create('{00000000-0000-0000-0000-000000000000}', false);

finalization
  DefProfile.Free;

end.
