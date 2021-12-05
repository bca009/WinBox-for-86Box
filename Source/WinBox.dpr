program WinBox;

uses
  MidasLib,
  Windows,
  uCommUtil,
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
  dmGraphUtil in 'dmGraphUtil.pas' {IconSet: TDataModule};

{$R *.res}
{$R '..\Data\rcWinBox.RES'}

var
  Handle: HWND;

begin
  Handle := FindWindow('TWinBoxMain', nil);
  if (Handle <> 0) then begin
    BringWindowToFront(Handle);
    Halt(1);
  end;

  if FindWindow('TWinBoxSplash', nil) <> 0 then
    Halt(2);

  Application.Initialize;

  WinBoxSplash := TWinBoxSplash.Create(nil);
  WinBoxSplash.Show;
  Application.ProcessMessages;

  Application.MainFormOnTaskbar := True;
  Application.Title := 'WinBox for 86Box';
  Application.ActionUpdateDelay := 50;
  Application.CreateForm(TIconSet, IconSet);
  Application.CreateForm(TWinBoxMain, WinBoxMain);
  Application.CreateForm(THDSelect, HDSelect);
  Application.Run;
end.
