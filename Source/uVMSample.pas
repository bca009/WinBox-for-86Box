(*

    WinBox Reloaded R2 - An universal GUI for many emulators

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

unit uVMSample;

interface

uses Windows, SysUtils, Classes, IniFiles, Zip, Generics.Collections,
     Generics.Defaults, uLang, uImaging;

type
  TVMSample = class
  private
    FFileName: string;
    FDiskData: TDiskData;
    FYear: integer;
    FHasHDD: boolean;
    FManufacturer: string;
    FConfigFile: string;
    FNoteForCDROM: string;
    FType: string;
    FDescription: string;
    FSupportedOS: string;
    FOptionCDROM: boolean;
    FHasCDROM: boolean;
    FOptions: array [0..3] of TStringList;
    FSlotOfHDD: string;
    FDescOfCDROM: string;
    FConnectorHDD: string;
    FOptionHDD: boolean;
    FAuthor: string;
    procedure SetFileName(const Value: string);
  protected
    Data: TMemIniFile;
    Keys: TStringList;
    procedure InternalReload;
    procedure WriteSection(const Section: string; ConfigFile: TCustomIniFile);
  public
    constructor Create;
    destructor Destroy; override;

    function GetRenameList: TStringList;

    function GetOptionName(const Index: integer): string;
    procedure GetOptions(const Index: integer; List: TStrings);
    function GetCustomKey(const Section, Name, Default: string): string;

    procedure AddOption(const Index: integer; const Option: string; ConfigFile: TCustomIniFile);
    procedure AddCDROM(ConfigFile: TCustomIniFile);

    procedure Reload;

    property FileName: string read FFileName write SetFileName;
    property Author: string read FAuthor;
    property Manufacturer: string read FManufacturer;
    property Description: string read FDescription;
    property Year: integer read FYear;
    property EmulatorType: string read FType;
    property ConfigFile: string read FConfigFile write FConfigFile;

    property NoteForCDROM: string read FNoteForCDROM;
    property OptionCDROM: boolean read FOptionCDROM;
    property HasDefCDROM: boolean read FHasCDROM;
    property DescOfCDROM: string read FDescOfCDROM;

    property ConnectorHDD: string read FConnectorHDD;
    property OptionHDD: boolean read FOptionHDD;
    property SlotOfHDD: string read FSlotOfHDD;
    property HasDefHDD: boolean read FHasHDD;
    property DiskDataHDD: TDiskData read FDiskData;

    property SupportedOS: string read FSupportedOS;

    procedure TranslateStr(var S: string);
  end;

  TVMSampleFilter = class(TObjectList<TVMSample>)
  public
    procedure Load(SamplesFolder: string);
    procedure GetManufacturers(List: TStrings);
    procedure GetByManufacturers(const Manufacturer: string; List: TStrings);
  end;

implementation

uses uCommUtil, uCommText;

resourcestring
  StrUnknownManufact = 'WizardVM.NoManufaturer';

{ TVMSample }

procedure TVMSample.AddCDROM(ConfigFile: TCustomIniFile);
begin
  WriteSection('CDROM', ConfigFile);
end;

procedure TVMSample.AddOption(const Index: integer; const Option: string;
  ConfigFile: TCustomIniFile);
begin
  if (Index in [0..3]) then
    case FOptions[Index].Count of
      0, 1: exit;
      2: ConfigFile.WriteString(
           TextLeft(FOptions[Index].Strings[1]),
           TextRight(FOptions[Index].Strings[1]),
           Data.ReadString('Option' + IntToStr(Index), Option, ''));
      else if FOptions[Index].IndexOfName(Option) <> -1 then
        WriteSection('Option' + IntToStr(Index) + '.' +
          FOptions[Index].Values[Option], ConfigFile);
    end;
end;

constructor TVMSample.Create;
var
  I: Integer;
begin
  Data := TMemIniFile.Create('');
  Keys := TStringList.Create;
  Language.ReadSectionValues('Templates', Keys);

  for I := 0 to Keys.Count - 1 do
    Keys.ValueFromIndex[I] := UnescapeString(Keys.ValueFromIndex[I]);

  for I := 0 to 3 do
    FOptions[I] := TStringList.Create;
end;

destructor TVMSample.Destroy;
var
  I: integer;
begin
  for I := 0 to 3 do
    FOptions[I].Free;

  Keys.Free;
  Data.Free;
  inherited;
end;

function TVMSample.GetCustomKey(const Section, Name, Default: string): string;
begin
  Result := Data.ReadString(Section, Name, Default);
end;

function TVMSample.GetOptionName(const Index: integer): string;
begin
  if (Index in [0..3]) and (FOptions[Index].Count > 0) then begin
    Result := FOptions[Index].Strings[0];
    TranslateStr(Result);
  end
  else
    Result := '-';
end;

procedure TVMSample.GetOptions(const Index: integer; List: TStrings);
var
  I: Integer;
  Temp: string;
begin
  List.Clear;

  if (Index in [0..3]) then
    case FOptions[Index].Count of
      0, 1: exit;
      2: Data.ReadSection('Option' + IntToStr(Index), List);
      else for I := 1 to FOptions[Index].Count - 1 do
        List.Add(FOptions[Index].Names[I]);
    end;

  for I := 0 to List.Count - 1 do begin
    Temp := List[I];
    TranslateStr(Temp);
    List[I] := List[I] + '=' + Temp;
  end;
end;

function TVMSample.GetRenameList: TStringList;
begin
  Result := TStringList.Create;
  Data.ReadSectionValues('RenameFiles', Result);
end;

procedure TVMSample.InternalReload;
var
  I: Integer;
begin
  FillChar(FDiskData, SizeOf(FDiskData), #0);
  FHasHDD := Data.SectionExists('HDD');
  FOptionHDD := Data.ReadInteger('General', 'OptionHDD', ord(FHasHDD)) <> 0;
  if FHasHDD then begin
    FConnectorHDD := Data.ReadString('HDD', 'Connector', 'IDE');
    StrPLCopy(@FDiskData.szConnector[0], Data.ReadString('HDD', 'Filter', FConnectorHDD), 19);
    FSlotOfHDD := Data.ReadString('HDD', 'Slot', '0:0');

    with FDiskData.dgPhysicalGeometry do begin
      C := Data.ReadInteger('HDD', 'C', 1024);
      H := Data.ReadInteger('HDD', 'H', 16);
      S := Data.ReadInteger('HDD', 'S', 63);
    end;
  end;

  FHasCDROM := Data.SectionExists('CDROM');
  FOptionCDROM := Data.ReadInteger('General', 'OptionCDROM', ord(FHasCDROM)) <> 0;
  FNoteForCDROM := Data.ReadString('General', 'NoteForCDROM', '-');
  FDescOfCDROM := Data.ReadString('General', 'DescOfCDROM', '-');

  FYear := Data.ReadInteger('General', 'Year', 1970);
  FManufacturer := Data.ReadString('General', 'Manufacturer', _T(StrUnknownManufact));
  FConfigFile := Data.ReadString('General', 'ConfigFile', '');
  FType := Data.ReadString('General', 'Type', '');
  FDescription := Data.ReadString('General', 'Description', ChangeFileExt(ExtractFileName(FFileName), ''));
  FSupportedOS := Data.ReadString('General', 'SupportedOS', _T(StrUnknown));
  FAuthor := Data.ReadString('General', 'Author', _T(StrUnknown));

  for I := 0 to 3 do begin
    FOptions[I].Clear;
    ExtractStrings(['|'], [],
      PChar(Data.ReadString('General', 'Option' + IntToStr(I), '')), FOptions[I]);
  end;

  TranslateStr(FManufacturer);
  TranslateStr(FNoteForCDROM);
  TranslateStr(FType);
  TranslateStr(FDescription);
  TranslateStr(FSupportedOS);
  TranslateStr(FDescOfCDROM);
end;

procedure TVMSample.Reload;
var
  Header: TZipHeader;
  Stream: TStream;
  List: TStringList;
begin
  SetFileName(FFileName);

  with TZipFile.Create do
    try
      Open(FFileName, zmRead);
      try
        if IndexOf('winbox.' + Locale) <> -1 then
          Read('winbox.' + Locale, Stream, Header)
        else
          Read('winbox.inf', Stream, Header);
        List := TStringList.Create;
        try
          Stream.Seek(0, soFromBeginning);
          TryLoadList(Stream, List);
          Data.SetStrings(List);
        finally
          List.Free;
        end;
      finally
        Stream.Free;
      end;
    finally
      Free;
    end;

  InternalReload;
end;

procedure TVMSample.SetFileName(const Value: string);
begin
  if not FileExists(Value) then
    raise Exception.Create(SysErrorMessage(ERROR_PATH_NOT_FOUND));

  if not TZipFile.IsValid(Value) then
    raise Exception.Create(SysErrorMessage(ERROR_FILE_INVALID));

  FFileName := Value;
end;

procedure TVMSample.TranslateStr(var S: string);
var
  I: integer;
begin
  for I := 0 to Keys.Count - 1 do
    S := StringReplace(S, '%' + Keys.Names[I] + '%', Keys.ValueFromIndex[I], [rfReplaceAll]);
end;

procedure TVMSample.WriteSection(const Section: string;
  ConfigFile: TCustomIniFile);
var
  List: TStringList;
  I: Integer;
begin
  if not Data.SectionExists(Section) then
    exit;

  List := TStringList.Create;
  Data.ReadSectionValues(Section, List);

  for I := 0 to List.Count - 1 do
    ConfigFile.WriteString(
      TextLeft(List.Names[I]),
      TextRight(List.Names[I]),
      List.ValueFromIndex[I]);

  List.Free;
end;

{ TVMSampleFilter }

procedure TVMSampleFilter.GetByManufacturers(const Manufacturer: string;
  List: TStrings);
var
  L: TList<TVMSample>;
  I: integer;
begin
  L := TList<TVMSample>.Create;
  for I := 0 to Count - 1 do
    if Items[I].Manufacturer = Manufacturer then
      L.Add(Items[I]);

  L.Sort(TComparer<TVMSample>.Construct(
      function (const L, R: TVMSample): integer
      begin
         Result := L.Year - R.Year;
         if Result = 0 then
           Result := StrCmpLogicalW(PChar(L.Description), PChar(R.Description));
      end));

  List.Clear;
  for I := 0 to L.Count - 1 do
    List.AddObject(L[I].Description, L[I]);

  L.Free;
end;

procedure TVMSampleFilter.GetManufacturers(List: TStrings);
var
  L: TStringList;
  I: integer;
begin
  L := TStringList.Create;
  L.Duplicates := dupIgnore;
  L.Sorted := true;

  for I := 0 to Count - 1 do
    L.Add(Items[I].Manufacturer);

  List.Assign(L);
  L.Free;
end;

procedure TVMSampleFilter.Load(SamplesFolder: string);
var
  SR: TSearchRec;
begin
  if not DirectoryExists(SamplesFolder) then
    exit;

  SamplesFolder := IncludeTrailingPathDelimiter(SamplesFolder);
  if FindFirst(SamplesFolder + '*.zip', faAnyFile, SR) = 0 then begin
    repeat
      if TZipFile.IsValid(SamplesFolder + SR.Name) then
        with Items[Add(TVMSample.Create)] do begin
          FileName := SamplesFolder + SR.Name;
          Reload;
        end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

end.
