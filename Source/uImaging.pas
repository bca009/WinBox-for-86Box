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

unit uImaging;

interface

uses Windows, SysUtils, Classes, Forms, ComCtrls, uVirtDisk, Zip;

type
  TDiskGeometry = record
    C, H, S: integer;
    function IsEmpty: boolean;
    function Size: uint64;
  end;

  TDiskData = record
    dgPhysicalGeometry,
    dgTranslatedGeometry: TDiskGeometry;
    dwNominalSize, dwLandZone, dwWritePreComp: integer;
    szManufacturer: array [0..34] of char;
    szModel: array [0..29] of char;
    szConnector: array [0..19] of char;
  end;

const
  BytesPerSector = 512;

  FloppyGeometry: array [0..9] of TDiskGeometry =
    ((C: 40; H: 1; S:  8),  //5.25'' SS DD-8 160k
     (C: 40; H: 2; S:  8),  //5.25'' DS DD-8 320k
     (C: 40; H: 1; S:  9),  //5.25'' SS DD-9 180k
     (C: 40; H: 2; S:  9),  //5.25'' DS DD-9 360k
     (C: 80; H: 2; S: 15),  //5.25'' DS HD   1.2M
     (C: 80; H: 2; S:  9),  //3.5''  DS DD   720k
     (C: 80; H: 2; S: 18),  //3.5''  DS HD   1.44M
     (C: 80; H: 2; S: 21),  //3.5''  DS DMF  1.68M
     (C: 82; H: 2; S: 21),  //3.5''  DS DMF  1.72M
     (C: 80; H: 2; S: 36)); //3.5''  DS ED   2.88M

function CreateDiskImage(const FileName: string; const Geometry: TDiskGeometry): boolean;
function CreateSparseImage(const FileName: string; const Geometry: TDiskGeometry): boolean;
function HasOverlappedIoCompleted(const lpOverlapped: OVERLAPPED): BOOL; inline;
function CreateVHDImage(const FileName: string; const Geometry: TDiskGeometry;
  const DynAlloc: boolean): boolean;
function CreateFloppyImage(const FileName: string; const Index: integer;
  const Formatted: boolean): boolean;

implementation

uses dmGraphUtil, frmWaitForm;

const
  FloppyImages: array [0..9] of string =
   ('5.25/160k.IMA',  //5.25'' SS DD-8 160k
    '5.25/180k.IMA',  //5.25'' DS DD-8 320k
    '5.25/320k.IMA',  //5.25'' SS DD-9 180k
    '5.25/360k.ima',  //5.25'' DS DD-9 360k
    '5.25/1.2M.ima',  //5.25'' DS HD   1.2M
    '3.5/720k.IMA',   //3.5''  DS DD   720k
    '3.5/144.ima',    //3.5''  DS HD   1.44M
    'DMF/168.IMA',    //3.5''  DS DMF  1.68M
    'DMF/172.IMA',    //3.5''  DS DMF  1.72M
    '3.5/288M.IMA');  //3.5''  DS ED   2.88M

function CreateDiskImage(const FileName: string; const Geometry: TDiskGeometry): boolean;
var
  I, Count, BufferSize: integer;
  Buffer: Pointer;
begin
  Result := true;
  with Geometry do begin
    BufferSize := H * S * 512;
    Count := C;
  end;

  GetMem(Buffer, BufferSize);
  try
    FillChar(Buffer^, BufferSize, #0);
      with TWaitForm.Create(Application) do
        try
          ProgressBar.Max := Count;
          IconSet.UpdateTaskbar(0, Count, PROGRESS_NORMAL);
          Show;
          with TFileStream.Create(FileName, fmCreate) do
            try
              for I := 1 to Count do begin
                WriteBuffer(Buffer^, BufferSize);
                ProgressBar.Position := I;
                Application.ProcessMessages;
                IconSet.UpdateTaskbar(I, -1, -1);
              end;
            finally
              Free;
            end;
        finally
          IconSet.UpdateTaskbar(0, -1, PROGRESS_NONE);
          Close;
          Free;
        end;
  finally
    FreeMem(Buffer, BufferSize);
  end;
end;

function CreateSparseImage(const FileName: string; const Geometry: TDiskGeometry): boolean;
var
  BytesReturned: longword;
const
  faSparseFile = $200;
  cbTestSize = 524288; //512 kB
begin
  with TFileStream.Create(FileName, fmCreate) do begin
    Result := DeviceIoControl(Handle, FSCTL_SET_SPARSE, nil, 0, nil, 0, BytesReturned, nil);
    SetFilePointerEx(Handle, cbTestSize, nil, FILE_BEGIN);
    SetEndOfFile(Handle);
    Free;
  end;

  {$WARN SYMBOL_PLATFORM OFF}

  BytesReturned := GetCompressedFileSize(PChar(FileName), @BytesReturned);
  Result := Result and ((FileGetAttr(FileName) and faSparseFile) = faSparseFile) and
      (BytesReturned < cbTestSize);

  {$WARN SYMBOL_PLATFORM ON}

  if Result then
    with TFileStream.Create(FileName, fmCreate) do begin
      Result := DeviceIoControl(Handle, FSCTL_SET_SPARSE, nil, 0, nil, 0, BytesReturned, nil);
      SetFilePointerEx(Handle, Geometry.Size, nil, FILE_BEGIN);
      SetEndOfFile(Handle);
      Free;
    end;
end;

function HasOverlappedIoCompleted(const lpOverlapped: OVERLAPPED): BOOL;
begin
  Result := LONG(lpOverlapped.Internal) <> STATUS_PENDING;
end;

function CreateVHDImage(const FileName: string; const Geometry: TDiskGeometry;
  const DynAlloc: boolean): boolean;
var
  StorageType: TVirtualStorageType;
  Params: TCreateVirtualDiskParameters;

  Overlapped: TOverlapped;

  RetVal: DWORD;
  Handle: THandle;
const
  Flags: array [boolean] of DWORD =
    (CREATE_VIRTUAL_DISK_FLAG_FULL_PHYSICAL_ALLOCATION,
     CREATE_VIRTUAL_DISK_FLAG_NONE);
begin
  if FileExists(FileName) then
    DeleteFile(FileName);

  with StorageType do begin
    DeviceId := VIRTUAL_STORAGE_TYPE_DEVICE_VHD;
    VendorId := VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT;
  end;

  FillChar(Params, SizeOf(Params), #0);
  with Params do begin
    Version:= CREATE_VIRTUAL_DISK_VERSION_1;
    CreateGUID(UniqueID);
    MaximumSize := Geometry.Size;
    BlockSizeInBytes := CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_BLOCK_SIZE;
    SectorSizeInBytes := CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_SECTOR_SIZE;
  end;

  Handle := INVALID_HANDLE_VALUE;
  FillChar(Overlapped, SizeOf(Overlapped), #0);
  RetVal := CreateVirtualDisk(StorageType, PChar(FileName),
       VIRTUAL_DISK_ACCESS_CREATE, nil,
       Flags[DynAlloc], 0,
       Params, @Overlapped, Handle);
  if (RetVal <> ERROR_SUCCESS) and (RetVal <> ERROR_IO_PENDING) then begin
    if (Handle <> 0) and (Handle <> INVALID_HANDLE_VALUE) then
      CloseHandle(Handle);
    RaiseLastOSError;
  end;

  case GetLastError of
    ERROR_IO_PENDING:
      with TWaitForm.Create(Application) do
        try
          ProgressBar.Style := pbstMarquee;
          IconSet.UpdateTaskbar(0, -1, PROGRESS_MARQUEE);
          Show;
          while not HasOverlappedIoCompleted(Overlapped) do
            Application.ProcessMessages;
        finally
          IconSet.UpdateTaskbar(0, -1, PROGRESS_NONE);
          Close;
          Free;
        end;
    else begin
      if (Handle <> 0) and (Handle <> INVALID_HANDLE_VALUE) then
        CloseHandle(Handle);
      RaiseLastOSError;
    end;
  end;

  if (Handle <> 0) and (Handle <> INVALID_HANDLE_VALUE) then
    CloseHandle(Handle);

  Result := FileExists(FileName);
end;

function CreateFloppyImage(const FileName: string; const Index: integer;
  const Formatted: boolean): boolean;
var
  StreamRes, StreamFile, StreamZip: TStream;
  Header: TZipHeader;
begin
  Result := false;
  if not (Index in [0..9]) then
    exit;

  if Formatted then begin
    StreamRes := TResourceStream.Create(hInstance, 'FLOPPY', RT_RCDATA);
    StreamFile := TFileStream.Create(FileName, fmCreate);
    try
      with TZipFile.Create do
        try
          Open(StreamRes, zmRead);
          Read(FloppyImages[Index], StreamZip, Header);
          try
            StreamFile.CopyFrom(StreamZip, StreamZip.Size);
          finally
            StreamZip.Free;
          end;
          Close;
        finally
          Free;
        end;
    finally
      StreamFile.Free;
      StreamRes.Free;

      Result := FileExists(FileName);
    end;
  end
  else
    Result := CreateDiskImage(FileName, FloppyGeometry[Index]);
end;

{ TDiskGeometry }

function TDiskGeometry.IsEmpty: boolean;
begin
  Result := (C = 0) or (H = 0) or (S = 0);
end;

function TDiskGeometry.Size: uint64;
begin
  Result := uint64(C) * word(H) * word(S) * BytesPerSector;
end;

end.