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

unit uFolderMon;

interface

uses SysUtils, Classes, Windows;

const
  DefFilter = FILE_NOTIFY_CHANGE_FILE_NAME or
              FILE_NOTIFY_CHANGE_DIR_NAME  or
              FILE_NOTIFY_CHANGE_SIZE      or
              FILE_NOTIFY_CHANGE_LAST_WRITE;

type
  TFolderEvent = procedure (Sender: TObject; FileName: string; ChangeType: Cardinal) of object;

  TFolderMonitor = class(TComponent)
  private
    FThread: TThread;
    FFolder: string;
    FFilter, FSubFolders: integer;

    FOnChange: TFolderEvent;
    FOnActivate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;

    function GetActive: Boolean;
    function GetFilter: Cardinal;
    function GetSubFolders: boolean;
    procedure SetActive(const Value: Boolean);
    procedure SetFilter(const Value: Cardinal);
    procedure SetSubFolders(const Value: boolean);

    procedure SetFolder(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active: Boolean read GetActive write SetActive;
    property Filter: Cardinal read GetFilter write SetFilter;
  published
    property Folder: string read FFolder write SetFolder;
    property SubFolders: boolean read GetSubFolders write SetSubFolders;

    property OnChange: TFolderEvent read FOnChange write FOnChange;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
  end;

  TFolderThread = class(TThread)
  private
    FMonitor: TFolderMonitor;
    FFolder: THandle;

    ItemName: string;
    ItemType: Cardinal;
    procedure ItemChange;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TFolderMonitor); reintroduce;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WinBox', [TFolderMonitor]);
end;

const
  FILE_LIST_DIRECTORY = $0001;

type
  _FILE_NOTIFY_INFORMATION = packed record
    NextEntryOffset: DWORD;
    Action: DWORD;
    FileNameLength: DWORD;
    FileName: WideChar;
  end;
  FILE_NOTIFY_INFORMATION = _FILE_NOTIFY_INFORMATION;
  PFILE_NOTIFY_INFORMATION = ^FILE_NOTIFY_INFORMATION;

{ TFolderMonitor }

constructor TFolderMonitor.Create(AOwner: TComponent);
begin
  FFilter := DefFilter;
  FSubFolders := 1;
  FThread := nil;

  inherited Create(AOwner);
end;

destructor TFolderMonitor.Destroy;
begin
  SetActive(false);
  inherited;
end;

function TFolderMonitor.GetActive: Boolean;
begin
  Result := Assigned(FThread);
end;

function TFolderMonitor.GetFilter: Cardinal;
begin
  Result := Cardinal(FFilter);
end;

function TFolderMonitor.GetSubFolders: boolean;
begin
  Result := FSubFolders <> 0;
end;

procedure TFolderMonitor.SetActive(const Value: Boolean);
begin
  if (Value = GetActive) and (Value = false) then
    exit
  else if Value then begin
    if FFilter = 0 then
      raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA));
    if not DirectoryExists(FFolder) then
      raise Exception.Create(SysErrorMessage(ERROR_PATH_NOT_FOUND));

    FThread := TFolderThread.Create(Self);

    if Assigned(FOnActivate) then
      FOnActivate(Self);
  end
  else begin
    if Assigned(FThread) then begin
      if FThread is TFolderThread then
        (FThread as TFolderThread).FMonitor := nil;
      FThread.Terminate;
    end;
    FThread := nil;

    if Assigned(FOnDeactivate) then
      FOnDeactivate(Self);
  end;
end;

procedure TFolderMonitor.SetFilter(const Value: Cardinal);
begin
  InterlockedExchange(FFilter, Integer(Value));
end;

procedure TFolderMonitor.SetFolder(const Value: string);
begin
  if Active then
    raise Exception.Create(SysErrorMessage(ERROR_ACCESS_DENIED));

  FFolder := Value;
end;

procedure TFolderMonitor.SetSubFolders(const Value: boolean);
begin
  InterlockedExchange(FSubFolders, ord(Value));
end;

{ TFolderThread }

constructor TFolderThread.Create(AOwner: TFolderMonitor);
begin
  FMonitor := AOwner;
  if not Assigned(FMonitor) then
    raise Exception.Create(SysErrorMessage(ERROR_INVALID_ADDRESS));

  inherited Create(False);
  FreeOnTerminate := True;

  FFolder := CreateFile(PChar(FMonitor.FFolder),
                        FILE_LIST_DIRECTORY or GENERIC_READ,
                        FILE_SHARE_READ or FILE_SHARE_WRITE or FILE_SHARE_DELETE,
                        nil,
                        OPEN_EXISTING,
                        FILE_FLAG_BACKUP_SEMANTICS,
                        0);
end;

procedure TFolderThread.Execute;
const
  BufSize = 32768;
var
  Buffer: Pointer;

  vCount: DWord;
  vOffset: DWord;
  vFileInfo: PFILE_NOTIFY_INFORMATION;
begin
  GetMem(Buffer, BufSize);
  try
    while not Terminated do begin
      if not Assigned(FMonitor) then
        exit;

      if ReadDirectoryChangesW(FFolder, Buffer, BufSize,
                               FMonitor.FSubFolders <> 0,
                               Cardinal(FMonitor.FFilter),
                               @vCount, nil, nil)
         and (vCount > 0) then begin
           if not Assigned(FMonitor) then
             exit;

           vFileInfo := Buffer;
           repeat
             vOffset := vFileInfo^.NextEntryOffset;

             ItemName := WideCharLenToString(@(vFileInfo^.FileName), vFileInfo^.FileNameLength);
             SetLength(ItemName, vFileInfo^.FileNameLength div 2);
             ItemType := vFileInfo^.Action;
             Synchronize(ItemChange);

             PByte(vFileInfo) := PByte(DWORD(vFileInfo) + vOffset);
           until vOffset=0;
      end;
    end;
  finally
    CloseHandle(FFolder);
    FreeMem(Buffer, BufSize);
  end;
end;

procedure TFolderThread.ItemChange;
begin
  if Assigned(FMonitor) and Assigned(FMonitor.FOnChange) then
    FMonitor.FOnChange(FMonitor, ItemName, ItemType);
end;

end.
