(*

    WinBox for 86Box - An alternative manager for 86Box VMs

    Copyright (C) 2020-2022, Laci bá'

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

program WinBox;

uses
  MidasLib,
  Windows,
  uCommUtil,
  uCommText,
  Forms,
  frmMainForm in 'frmMainForm.pas' {WinBoxMain},
  uProcessMon in 'uProcessMon.pas',
  uBaseProfile in 'uBaseProfile.pas',
  uProcProfile in 'uProcProfile.pas',
  uWinProfile in 'uWinProfile.pas',
  u86Box in 'u86Box.pas',
  frmErrorDialog in 'frmErrorDialog.pas' {ExceptionDialog},
  frmProfSettDlg in 'frmProfSettDlg.pas' {ProfSettDlg},
  frmProgSettDlg in 'frmProgSettDlg.pas' {ProgSettDlg},
  frmImportVM in 'frmImportVM.pas' {ImportVM},
  frm86Box in 'frm86Box.pas' {Frame86Box: TFrame},
  frmAboutDlg in 'frmAboutDlg.pas' {AboutDlg},
  frmUpdaterDlg in 'frmUpdaterDlg.pas' {UpdaterDlg},
  frmSelectHDD in 'frmSelectHDD.pas' {HDSelect},
  frmNewFloppy in 'frmNewFloppy.pas' {NewFloppy},
  frmWaitForm in 'frmWaitForm.pas' {WaitForm},
  frmWizardHDD in 'frmWizardHDD.pas' {WizardHDD},
  frmWizardVM in 'frmWizardVM.pas' {WizardVM},
  frmSplash in 'frmSplash.pas' {WinBoxSplash},
  dmWinBoxUpd in 'dmWinBoxUpd.pas' {WinBoxUpd: TDataModule},
  dmGraphUtil in 'dmGraphUtil.pas' {IconSet: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  uJumpList in 'uJumpList.pas';

{$R *.res}
{$R '..\Data\rcWinBox.RES'}

var
  Handle: HWND;

begin
  SetAppModelID;

  Handle := FindWindow('TWinBoxMain', nil);
  if (Handle <> 0) then begin
    TWinBoxMain.SendCommandLine(Handle);
    Halt(1);
  end;

  if FindWindow('TWinBoxSplash', nil) <> 0 then
    Halt(2);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  with TStyleManager do begin
    UseSystemStyleAsDefault := true;
    SystemHooks := SystemHooks - [shDialogs];
    TrySetStyle('Windows10 DarkExplorer', false);
  end;

  WinBoxSplash := TWinBoxSplash.Create(nil);
  WinBoxSplash.Show;
  Application.ProcessMessages;

  Application.Title := 'WinBox for 86Box';
  Application.ActionUpdateDelay := 50;
  Application.CreateForm(TIconSet, IconSet);
  Application.CreateForm(TWinBoxMain, WinBoxMain);
  Application.Run;
end.
