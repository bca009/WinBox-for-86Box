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

unit uCommText;

interface

uses Messages;

const
  //User Messages starting from WM_USER

  UM_DOFIRSTUPDATE  = WM_USER + $000; //TWinBoxMain
  UM_ICONSETCHANGED = WM_USER + $001; //TIconSet
  UM_CREATEDETAILS  = WM_USER + $100; //TExceptionDialog

  //Up to WM_USER + $7FFF.

resourcestring
  VmConfigFile     = '86Box.cfg';
  VmIconFile       = 'vm-icon.png';
  VmIconRes        = 'EMPTY';

  OpenDlg86Box       = 'OpenDialog.86Box';
  OpenDlgExecutables = 'OpenDialog.Executables';
  OpenDlgLogFiles    = 'OpenDialog.LogFiles';
  OpenDlgWICPic      = 'OpenDialog.WICImage';
  OpenDlgConfig      = 'OpenDialog.Config';

  StrUnknown         = 'Strings.Unknown';
  StrVersion         = 'Strings.Version';
  StrSwitchText      = 'Strings.SwitchText[%d]';
  StrStandard        = 'Strings.Standard';

  StrState           = 'WinBox.ProfileStates[%d]';

  ImFileExists       = 'Imaging.AskFileExists';

  StrDateTimeAsLogName = 'yyyy_mm_dd-hh_nn_ss';

  DlgDetailsText        = 'UpdateDlg.DetailsText';
  DlgDetailsChanges     = 'UpdateDlg.DetailsChanges';
  ECantAccessServer     = 'UpdateDlg.ECantAccessServer';

  Str86MgrPathNeeded = 'WinBox.86MgrPathNeeded';
  Str86MgrPathOf     = 'WinBox.86MgrPathOf';

  StrDeferStyleChange = 'IconSet.DeferStyleChange';

  AppModelID = 'com.laciba.WinBox-for-86Box';

implementation

end.
