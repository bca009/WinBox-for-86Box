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

unit uVirtDisk;

interface

uses Windows;

type
  _VIRTUAL_STORAGE_TYPE = record
    DeviceId: ULONG;
    VendorId: TGUID;
  end;
  VIRTUAL_STORAGE_TYPE = _VIRTUAL_STORAGE_TYPE;
  PVIRTUAL_STORAGE_TYPE = ^_VIRTUAL_STORAGE_TYPE;

  TVirtualStorageType = _VIRTUAL_STORAGE_TYPE;
  PVirtualStorageType = ^_VIRTUAL_STORAGE_TYPE;

  _OPEN_VIRTUAL_DISK_PARAMETERS = record
    Version: DWORD;
    case Integer of
      0: (
            RWDepth: ULONG;
         );
      1: (
            GetInfoOnly: BOOL;
            ReadOnly: BOOL;
            ResiliencyGuid: TGUID;
         );
  end;
  OPEN_VIRTUAL_DISK_PARAMETERS = _OPEN_VIRTUAL_DISK_PARAMETERS;
  POPEN_VIRTUAL_DISK_PARAMETERS =  ^_OPEN_VIRTUAL_DISK_PARAMETERS;

  TOpenVirtualDiskParameters = _OPEN_VIRTUAL_DISK_PARAMETERS;
  POpenVirtualDiskParameters = ^_OPEN_VIRTUAL_DISK_PARAMETERS;

const
  OPEN_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0;
  OPEN_VIRTUAL_DISK_VERSION_1 = 1;
  OPEN_VIRTUAL_DISK_VERSION_2 = 2;

  OPEN_VIRTUAL_DISK_RW_DEPTH_DEFAULT = 1;

  VIRTUAL_STORAGE_TYPE_DEVICE_UNKNOWN = 0;
  VIRTUAL_STORAGE_TYPE_DEVICE_ISO = 1;
  VIRTUAL_STORAGE_TYPE_DEVICE_VHD = 2;
  VIRTUAL_STORAGE_TYPE_DEVICE_VHDX = 3;

  VIRTUAL_STORAGE_TYPE_VENDOR_UNKNOWN: TGUID =
    '{00000000-0000-0000-0000-000000000000}';
  VIRTUAL_STORAGE_TYPE_VENDOR_MICROSOFT: TGUID =
    '{EC984AEC-A0F9-47e9-901F-71415A66345B}';

  VIRTUAL_DISK_ACCESS_ATTACH_RO = $00010000;
  VIRTUAL_DISK_ACCESS_ATTACH_RW = $00020000;
  VIRTUAL_DISK_ACCESS_DETACH    = $00040000;
  VIRTUAL_DISK_ACCESS_GET_INFO  = $00080000;
  VIRTUAL_DISK_ACCESS_CREATE    = $00100000;
  VIRTUAL_DISK_ACCESS_METAOPS   = $00200000;
  VIRTUAL_DISK_ACCESS_READ      = $000D0000;
  VIRTUAL_DISK_ACCESS_ALL       = $003F0000;
  VIRTUAL_DISK_ACCESS_WRITABLE  = $00320000;

  OPEN_VIRTUAL_DISK_FLAG_NONE = 0;
  OPEN_VIRTUAL_DISK_FLAG_NO_PARENTS = 1;
  OPEN_VIRTUAL_DISK_FLAG_BLANK_FILE = 2;
  OPEN_VIRTUAL_DISK_FLAG_BOOT_DRIVE = 3;
  OPEN_VIRTUAL_DISK_FLAG_CACHED_IO = 4;
  OPEN_VIRTUAL_DISK_FLAG_CUSTOM_DIFF_CHAIN = 5;
  OPEN_VIRTUAL_DISK_FLAG_PARENT_CACHED_IO = 6;
  OPEN_VIRTUAL_DISK_FLAG_VHDSET_FILE_ONLY = 7;
  OPEN_VIRTUAL_DISK_FLAG_IGNORE_RELATIVE_PARENT_LOCATOR = 8;
  OPEN_VIRTUAL_DISK_FLAG_NO_WRITE_HARDENING = 9;
  OPEN_VIRTUAL_DISK_FLAG_SUPPORT_COMPRESSED_VOLUMES = 10;

const
  ATTACH_VIRTUAL_DISK_FLAG_NONE = 0;
  ATTACH_VIRTUAL_DISK_FLAG_READ_ONLY = 1;
  ATTACH_VIRTUAL_DISK_FLAG_NO_DRIVE_LETTER = 2;
  ATTACH_VIRTUAL_DISK_FLAG_PERMANENT_LIFETIME = 3;
  ATTACH_VIRTUAL_DISK_FLAG_NO_LOCAL_HOST = 4;
  ATTACH_VIRTUAL_DISK_FLAG_NO_SECURITY_DESCRIPTOR = 5;
  ATTACH_VIRTUAL_DISK_FLAG_BYPASS_DEFAULT_ENCRYPTION_POLICY = 6;
  ATTACH_VIRTUAL_DISK_FLAG_NON_PNP = 7;
  ATTACH_VIRTUAL_DISK_FLAG_RESTRICTED_RANGE = 8;
  ATTACH_VIRTUAL_DISK_FLAG_SINGLE_PARTITION = 9;
  ATTACH_VIRTUAL_DISK_FLAG_REGISTER_VOLUME = 10;

  ATTACH_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0;
  ATTACH_VIRTUAL_DISK_VERSION_1 = 1;
  ATTACH_VIRTUAL_DISK_VERSION_2 = 2;

type
  _ATTACH_VIRTUAL_DISK_PARAMETERS = record
    Version: DWORD;
    case Integer of
      0: (
            Reserved: ULONG;
          );
      1: (
            RestrictedOffset: ULONGLONG;
            RestrictedLength: ULONGLONG;
         );
  end;
  ATTACH_VIRTUAL_DISK_PARAMETERS = _ATTACH_VIRTUAL_DISK_PARAMETERS;
  PATTACH_VIRTUAL_DISK_PARAMETERS = ^_ATTACH_VIRTUAL_DISK_PARAMETERS;
  TAttachVirtualDiskParameters = _ATTACH_VIRTUAL_DISK_PARAMETERS;
  PAttachVirtualDiskParameters = ^_ATTACH_VIRTUAL_DISK_PARAMETERS;

const
  COMPACT_VIRTUAL_DISK_FLAG_NONE = 0;
  COMPACT_VIRTUAL_DISK_FLAG_NO_ZERO_SCAN = 1;
  COMPACT_VIRTUAL_DISK_FLAG_NO_BLOCK_MOVES = 2;

  COMPACT_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0;
  COMPACT_VIRTUAL_DISK_VERSION_1 = 1;

type
  _COMPACT_VIRTUAL_DISK_PARAMETERS = record
    Version: DWORD;
    case Integer of
      0: (
            Reserved: ULONG;
         );
  end;
  COMPACT_VIRTUAL_DISK_PARAMETERS = _COMPACT_VIRTUAL_DISK_PARAMETERS;
  PCOMPACT_VIRTUAL_DISK_PARAMETERS = ^_COMPACT_VIRTUAL_DISK_PARAMETERS;

  TCompactVirtualDiskParameters = _COMPACT_VIRTUAL_DISK_PARAMETERS;
  PCompactVirtualDiskParameters = ^_COMPACT_VIRTUAL_DISK_PARAMETERS;

const
  CREATE_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0;
  CREATE_VIRTUAL_DISK_VERSION_1 = 1;
  CREATE_VIRTUAL_DISK_VERSION_2 = 2;

  CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_BLOCK_SIZE = 0;
  CREATE_VIRTUAL_DISK_PARAMETERS_512_KB_BLOCK_SIZE = $80000;
  CREATE_VIRTUAL_DISK_PARAMETERS_2_MB_BLOCK_SIZE = $200000;

  CREATE_VIRTUAL_DISK_PARAMETERS_DEFAULT_SECTOR_SIZE = $200;

  CREATE_VIRTUAL_DISK_FLAG_NONE = 0;
  CREATE_VIRTUAL_DISK_FLAG_FULL_PHYSICAL_ALLOCATION = 1;
  CREATE_VIRTUAL_DISK_FLAG_PREVENT_WRITES_TO_SOURCE_DISK = 2;
  CREATE_VIRTUAL_DISK_FLAG_DO_NOT_COPY_METADATA_FROM_PARENT = 3;
  CREATE_VIRTUAL_DISK_FLAG_CREATE_BACKING_STORAGE = 4;
  CREATE_VIRTUAL_DISK_FLAG_USE_CHANGE_TRACKING_SOURCE_LIMIT = 5;
  CREATE_VIRTUAL_DISK_FLAG_PRESERVE_PARENT_CHANGE_TRACKING_STATE = 6;
  CREATE_VIRTUAL_DISK_FLAG_VHD_SET_USE_ORIGINAL_BACKING_STORAGE = 7;
  CREATE_VIRTUAL_DISK_FLAG_SPARSE_FILE = 8;
  CREATE_VIRTUAL_DISK_FLAG_PMEM_COMPATIBLE = 9;
  CREATE_VIRTUAL_DISK_FLAG_SUPPORT_COMPRESSED_VOLUMES = 10;

type
  PCreateVirtualDiskParameters = ^TCreateVirtualDiskParameters;
  _CREATE_VIRTUAL_DISK_PARAMETERS = record
    Version: DWORD;
    UniqueId: TGUID;
    MaximumSize: ULONGLONG;
    BlockSizeInBytes: ULONG;
    SectorSizeInBytes: ULONG;
    ParentPath: LPCWSTR;
    SourcePath: LPCWSTR;
    case Integer of
      0: (
         );
      1: (
            OpenFlags: DWORD;
            ParentVirtualStorageType: _VIRTUAL_STORAGE_TYPE;
            SourceVirtualStorageType: _VIRTUAL_STORAGE_TYPE;
            ResiliencyGuid: TGUID;
         );
  end;
  TCreateVirtualDiskParameters = _CREATE_VIRTUAL_DISK_PARAMETERS;
  CREATE_VIRTUAL_DISK_PARAMETERS = _CREATE_VIRTUAL_DISK_PARAMETERS;

const
  DETACH_VIRTUAL_DISK_FLAG_NONE = 0;

  DEPENDENT_DISK_FLAG_NONE = 0;
  DEPENDENT_DISK_FLAG_MULT_BACKING_FILES = 1;
  DEPENDENT_DISK_FLAG_FULLY_ALLOCATED = 2;
  DEPENDENT_DISK_FLAG_READ_ONLY = 3;
  DEPENDENT_DISK_FLAG_REMOTE = 4;
  DEPENDENT_DISK_FLAG_SYSTEM_VOLUME = 5;
  DEPENDENT_DISK_FLAG_SYSTEM_VOLUME_PARENT = 6;
  DEPENDENT_DISK_FLAG_REMOVABLE = 7;
  DEPENDENT_DISK_FLAG_NO_DRIVE_LETTER = 8;
  DEPENDENT_DISK_FLAG_PARENT = 9;
  DEPENDENT_DISK_FLAG_NO_HOST_DISK = 10;
  DEPENDENT_DISK_FLAG_PERMANENT_LIFETIME = 11;
  DEPENDENT_DISK_FLAG_SUPPORT_COMPRESSED_VOLUMES = 12;

  GET_STORAGE_DEPENDENCY_FLAG_NONE = 0;
  GET_STORAGE_DEPENDENCY_FLAG_HOST_VOLUMES = 1;
  GET_STORAGE_DEPENDENCY_FLAG_DISK_HANDLE = 2;
  GET_STORAGE_DEPENDENCY_FLAG_PARENTS = GET_STORAGE_DEPENDENCY_FLAG_HOST_VOLUMES;

  STORAGE_DEPENDENCY_INFO_VERSION_UNSPECIFIED = 0;
  STORAGE_DEPENDENCY_INFO_VERSION_1 = 1;
  STORAGE_DEPENDENCY_INFO_VERSION_2 = 2;

type
  _STORAGE_DEPENDENCY_INFO_TYPE_1 = record
    DependencyTypeFlags: DWORD;
    ProviderSpecificFlags: ULONG;
    VirtualStorageType: TVirtualStorageType;
  end;                       STORAGE_DEPENDENCY_INFO_TYPE_1 = _STORAGE_DEPENDENCY_INFO_TYPE_1;
  PSTORAGE_DEPENDENCY_INFO_TYPE_1 = ^_STORAGE_DEPENDENCY_INFO_TYPE_1;

  TStorageDependencyInfoType1 = _STORAGE_DEPENDENCY_INFO_TYPE_1;
  PStorageDependencyInfoType1 = ^_STORAGE_DEPENDENCY_INFO_TYPE_1;

  _STORAGE_DEPENDENCY_INFO_TYPE_2 = record
    DependencyTypeFlags: DWORD;
    ProviderSpecificFlags: ULONG;
    VirtualStorageType: TVirtualStorageType;
    AncestorLevel: ULONG;
    DependencyDeviceName: LPWSTR;
    HostVolumeName: LPWSTR;
    DependentVolumeName: LPWSTR;
    DependentVolumeRelativePath: LPWSTR;
  end;
  STORAGE_DEPENDENCY_INFO_TYPE_2 = _STORAGE_DEPENDENCY_INFO_TYPE_2;
  PSTORAGE_DEPENDENCY_INFO_TYPE_2 = ^_STORAGE_DEPENDENCY_INFO_TYPE_2;

  TStorageDependencyInfoType2 = _STORAGE_DEPENDENCY_INFO_TYPE_2;
  PStorageDependencyInfoType2 = ^_STORAGE_DEPENDENCY_INFO_TYPE_1;

  _STORAGE_DEPENDENCY_INFO = record
    Version: DWORD;
    NumberEntries: ULONG;
    case Integer of
      0: (
            Version1Entries: PStorageDependencyInfoType1;
         );
      1: (
            Version2Entries: PStorageDependencyInfoType2;
         );
  end;
  STORAGE_DEPENDENCY_INFO = _STORAGE_DEPENDENCY_INFO;
  PSTORAGE_DEPENDENCY_INFO = ^_STORAGE_DEPENDENCY_INFO;

  TStorageDependencyInfo = _STORAGE_DEPENDENCY_INFO;
  PStorageDependencyInfo = ^_STORAGE_DEPENDENCY_INFO;

const
  GET_VIRTUAL_DISK_INFO_UNSPECIFIED = 0;
  GET_VIRTUAL_DISK_INFO_SIZE = 1;
  GET_VIRTUAL_DISK_INFO_IDENTIFIER = 2;
  GET_VIRTUAL_DISK_INFO_PARENT_LOCATION = 3;
  GET_VIRTUAL_DISK_INFO_PARENT_IDENTIFIER = 4;
  GET_VIRTUAL_DISK_INFO_PARENT_TIMESTAMP = 5;
  GET_VIRTUAL_DISK_INFO_VIRTUAL_STORAGE_TYPE = 6;
  GET_VIRTUAL_DISK_INFO_PROVIDER_SUBTYPE = 7;
  GET_VIRTUAL_DISK_INFO_IS_4K_ALIGNED = 8;
  GET_VIRTUAL_DISK_INFO_PHYSICAL_DISK = 9;
  GET_VIRTUAL_DISK_INFO_VHD_PHYSICAL_SECTOR_SIZE = 10;
  GET_VIRTUAL_DISK_INFO_SMALLEST_SAFE_VIRTUAL_SIZE = 11;
  GET_VIRTUAL_DISK_INFO_FRAGMENTATION = 12;
  GET_VIRTUAL_DISK_INFO_IS_LOADED = 13;
  GET_VIRTUAL_DISK_INFO_VIRTUAL_DISK_ID = 14;
  GET_VIRTUAL_DISK_INFO_CHANGE_TRACKING_STATE = 15;

type
  _GET_VIRTUAL_DISK_INFO_SIZE = record
    VirtualSize: ULONGLONG;
    PhysicalSize: ULONGLONG;
    BlockSize: ULONG;
    SectorSize: ULONG;
  end;

  _GET_VIRTUAL_DISK_INFO_PARENT_LOCATION = record
    ParentResolved: BOOL;
    ParentLocationBuffer: array [0..0] of WCHAR;
  end;

  _GET_VIRTUAL_DISK_INFO_PHYSICAL_DISK = record
    LogicalSectorSize: ULONG;
    PhysicalSectorSize: ULONG;
    IsRemote: BOOL;
  end;

  _GET_VIRTUAL_DISK_INFO_CHANGE_TRACKING_STATE = record
    Enabled: BOOL;
    NewerChanges: BOOL;
    MostRecentId: array [0..0] of WCHAR;
  end;

  _GET_VIRTUAL_DISK_INFO = record
    Version: DWORD;
    case Integer of
      0: (
        Size: _GET_VIRTUAL_DISK_INFO_SIZE;
        Identifier: TGUID;
        ParentLocation: _GET_VIRTUAL_DISK_INFO_PARENT_LOCATION;
        ParentIdentifier: TGUID;
        ParentTimestamp: ULONG;
        VirtualStorageType: TVirtualStorageType;
        ProviderSubtype: ULONG;
        Is4kAligned: BOOL;
        IsLoaded: BOOL;
        PhysicalDiks: _GET_VIRTUAL_DISK_INFO_PHYSICAL_DISK;
        VhdPhysicalSectorSize: ULONG;
        SmallestSafeVirtualSize: ULONGLONG;
        FragmentationPercentage: ULONG;
        VirtualDiskId: TGUID;
        ChangeTrackingState: _GET_VIRTUAL_DISK_INFO_CHANGE_TRACKING_STATE;
      );
  end;
  GET_VIRTUAL_DISK_INFO = _GET_VIRTUAL_DISK_INFO;
  PGET_VIRTUAL_DISK_INFO = ^_GET_VIRTUAL_DISK_INFO;

  TGetVirtualDiskInfo = _GET_VIRTUAL_DISK_INFO;
  PGetVirtualDiskInfo = ^_GET_VIRTUAL_DISK_INFO;

type
  _VIRTUAL_DISK_PROGRESS = record
    OperationStatus: DWORD;
    CurrentValue: ULONGLONG;
    CompletionValue: ULONGLONG;
  end;
  VIRTUAL_DISK_PROGRESS = _VIRTUAL_DISK_PROGRESS;
  PVIRTUAL_DISK_PROGRESS = ^_VIRTUAL_DISK_PROGRESS;

  TVirtualDiskProgress = _VIRTUAL_DISK_PROGRESS;
  PVirtualDiskProgress = ^_VIRTUAL_DISK_PROGRESS;

const
  EXPAND_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0;
  EXPAND_VIRTUAL_DISK_VERSION_1 = 1;

  EXPAND_VIRTUAL_DISK_FLAG_NONE = 0;

type
  _EXPAND_VIRTUAL_DISK_PARAMETERS = record
    Version: DWORD;
    case Integer of
      0: (
            NewSize: ULONGLONG;
          );
  end;
  EXPAND_VIRTUAL_DISK_PARAMETERS = _EXPAND_VIRTUAL_DISK_PARAMETERS;
  PEXPAND_VIRTUAL_DISK_PARAMETERS = ^_EXPAND_VIRTUAL_DISK_PARAMETERS;

  TExpandVirtualDiskParameters = _EXPAND_VIRTUAL_DISK_PARAMETERS;
  PExpandVirtualDiskParameters = ^TExpandVirtualDiskParameters;

const
  MERGE_VIRTUAL_DISK_FLAG_NONE = 0;

  MERGE_VIRTUAL_DISK_VERSION_UNSPECIFIED = 0;
  MERGE_VIRTUAL_DISK_VERSION_1 = 1;
  MERGE_VIRTUAL_DISK_VERSION_2 = 2;

  MERGE_VIRTUAL_DISK_DEFAULT_MERGE_DEPTH = 1;

type
  _MERGE_VIRTUAL_DISK_PARAMETERS = record
    Version: DWORD;
    case Integer of
      0: (
            MergeDepth: ULONG;
         );
      1: (
            MergeSourceDepth: ULONG;
            MergeTargetDepth: ULONG;
         );
  end;
  MERGE_VIRTUAL_DISK_PARAMETERS = _MERGE_VIRTUAL_DISK_PARAMETERS;
  PMERGE_VIRTUAL_DISK_PARAMETERS = ^_MERGE_VIRTUAL_DISK_PARAMETERS;

  TMergeVirtualDiskParameters = _MERGE_VIRTUAL_DISK_PARAMETERS;
  PMergeVirtualDiskParameters = ^_MERGE_VIRTUAL_DISK_PARAMETERS;

const
  SET_VIRTUAL_DISK_INFO_UNSPECIFIED = 0;
  SET_VIRTUAL_DISK_INFO_PARENT_PATH = 1;
  SET_VIRTUAL_DISK_INFO_IDENTIFIER = 2;
  SET_VIRTUAL_DISK_INFO_PARENT_PATH_WITH_DEPTH = 3;
  SET_VIRTUAL_DISK_INFO_PHYSICAL_SECTOR_SIZE = 4;
  SET_VIRTUAL_DISK_INFO_VIRTUAL_DISK_ID = 5;
  SET_VIRTUAL_DISK_INFO_CHANGE_TRACKING_STATE = 6;
  SET_VIRTUAL_DISK_INFO_PARENT_LOCATOR = 7;

type
  _SET_VIRTUAL_DISK_INFO_PARENT_PATH = record
    ChildDepth: ULONG;
    ParentFilePath: LPCWSTR;
  end;

  _SET_VIRTUAL_DISK_INFO_PARENT_LOCATOR = record
    LinkageId: TGUID;
    ParentFilePath: LPCWSTR;
  end;

  _SET_VIRTUAL_DISK_INFO = record
    Version: DWORD;
    case Integer of
      0: (
           ParentFilePath: LPWSTR;
           UniqueIdentifier: TGUID;
           ParentPathWithDepthInfo: _SET_VIRTUAL_DISK_INFO_PARENT_PATH;
           VhdPhysicalSectorSize: ULONG;
           VirtualDiskId: TGUID;
           ChangeTrackingEnabled: BOOL;
           ParentLocator: _SET_VIRTUAL_DISK_INFO_PARENT_LOCATOR;
         );
  end;
  SET_VIRTUAL_DISK_INFO = _SET_VIRTUAL_DISK_INFO;
  PSET_VIRTUAL_DISK_INFO = ^_SET_VIRTUAL_DISK_INFO;

  TSetVirtualDiskInfo = _SET_VIRTUAL_DISK_INFO;
  PSetVirtualDiskInfo = ^_SET_VIRTUAL_DISK_INFO;

const
  VirtDisk = 'VirtDisk.dll';

function OpenVirtualDisk(
  var VirtualStorageType: TVirtualStorageType;
  Path: LPCWSTR;
  VirtualDiskAccessMask: DWORD;
  Flags: DWORD;
  Parameters: POpenVirtualDiskParameters;
  var Handle: THandle): DWORD; stdcall; external VirtDisk;

function AttachVirtualDisk(
  VirtualDiskHandle: THandle;
  SecurityDescriptor: PSecurityDescriptor;
  Flags: DWORD;
  ProviderSpecificFlags: ULONG;
  var Parameters: TAttachVirtualDiskParameters;
  Overlapped: POverlapped): DWORD; stdcall; external VirtDisk;

function CompactVirtualDisk(
  VirtualDiskHandle: THandle;
  Flags: DWORD;
  var Parameters: TCompactVirtualDiskParameters;
  Overlapped: POverlapped): DWORD; stdcall; external VirtDisk;

function CreateVirtualDisk(
  var VirtualStorageType: TVirtualStorageType;
  Path: LPCWSTR;
  VirtualDiskAccessMask: DWORD;
  SecurityDescriptor: PSecurityDescriptor;
  Flags: DWORD;
  ProviderSpecificFlags: ULONG;
  var Parameters: TCreateVirtualDiskParameters;
  Overlapped: POverlapped;
  var Handle: THandle): DWORD; stdcall; external VirtDisk;

function DetachVirtualDisk(
  VirtualDiskHandle: THandle;
  Flags: DWORD;
  ProviderSpecificFlags: ULONG): DWORD; stdcall; external VirtDisk;

function GetStorageDependencyInformation(
  ObjectHandle: THandle;
  Flags: DWORD;
  StorageDependencyInfoSize: ULONG;
  var StorageDependencyInfo: TStorageDependencyInfo;
  SizeUsed: PULONG): DWORD; stdcall; external VirtDisk;

function GetVirtualDiskInformation(
  VirtualDiskHandle: THandle;
  var VirtualDiskInfoSize: ULONG;
  var VirtualDiskInfo: TGetVirtualDiskInfo;
  var SizeUsed: ULONG): DWORD; stdcall; external VirtDisk;

function GetVirtualDiskOperationProgress(
  VirtualDiskHandle: THandle;
  var Overlapped: TOverlapped;
  var Progress: TVirtualDiskProgress): DWORD; stdcall; external VirtDisk;

function GetVirtualDiskPhysicalPath(
  VirtualDiskHandle: THandle;
  var DiskPathSizeInBytes: ULONG;
  DiskPath: LPWSTR): DWORD; stdcall; external VirtDisk;

function ExpandVirtualDisk(
  VirtualDiskHandle: THandle;
  Flags: DWORD;
  var Parameters: TExpandVirtualDiskParameters;
  Overlapped: POverlapped): DWORD; stdcall; external VirtDisk;

function MergeVirtualDisk(
  VirtualDiskHandle: THandle;
  Flags: DWORD;
  var Parameters: TMergeVirtualDiskParameters;
  Overlapped: POverlapped): DWORD; stdcall; external VirtDisk;

function SetVirtualDiskInformation(
  VirtualDiskHandle: THandle;
  var VirtualDiskInfo: TSetVirtualDiskInfo): DWORD; stdcall; external VirtDisk;

implementation

end.
