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

unit frmNewFloppy;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Dialogs,
  StdCtrls, Controls, ComCtrls, ExtCtrls, uLang, uCommText;

type
  TNewFloppy = class(TForm, ILanguageSupport)
    btnCancel: TButton;
    btnOK: TButton;
    bvBottom: TBevel;
    imgBanner: TImage;
    pcPages: TPageControl;
    tabData: TTabSheet;
    lbTitle: TLabel;
    lbDescFileName: TLabel;
    lbFileName: TLabel;
    edFileName: TEdit;
    btnBrowse: TButton;
    lbNoteFileName: TLabel;
    lbType: TLabel;
    cbType: TComboBox;
    lbNoteDMF: TLabel;
    cbFormat: TCheckBox;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    procedure UMIconsChanged(var Msg: TMessage); message UM_ICONSETCHANGED;
  public
    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;

    procedure TypeFrom86Box(FloppyType: string);
  end;

var
  NewFloppy: TNewFloppy;

implementation

{$R *.dfm}

uses dmGraphUtil, uImaging;

resourcestring
  ENoSupportedFloppy = 'Imaging.ENoSupportedFloppy';
  ECantCreateFloppy = 'Imaging.ECantCreateFloppy';

procedure TNewFloppy.btnBrowseClick(Sender: TObject);
begin
  SaveDialog.InitialDir := ExtractFilePath(edFileName.Text);
  SaveDialog.FileName := ExtractFileName(edFileName.Text);
  ForceDirectories(SaveDialog.InitialDir);
  if SaveDialog.Execute then
    edFileName.Text := SaveDialog.FileName;
end;

procedure TNewFloppy.btnOKClick(Sender: TObject);
begin
  if (edFileName.Text = '') or (edFileName.Text = '\') then begin
    FocusControl(edFileName);
    raise Exception.Create(SysErrorMessage(ERROR_INVALID_PARAMETER));
  end;

  if FileExists(edFileName.Text) and (MessageBox(Handle, _P(ImFileExists),
     PChar(Application.Title), MB_YESNO or MB_ICONWARNING) <> mrYes) then exit;

  if cbType.ItemIndex < 0 then begin
    FocusControl(cbType);
    raise Exception.Create(SysErrorMessage(ERROR_INVALID_PARAMETER));
  end;

  ForceDirectories(ExtractFilePath(edFileName.Text));
  if CreateFloppyImage(edFileName.Text, cbType.ItemIndex, cbFormat.Checked) then
    ModalResult := mrOK
  else
    raise Exception.Create(ECantCreateFloppy);
end;

procedure TNewFloppy.FlipBiDi;
begin
  BiDiMode := BiDiModes[LocaleIsBiDi];
  FlipChildren(true);
end;

procedure TNewFloppy.FormCreate(Sender: TObject);
begin
  ApplyActiveStyle;
  Perform(UM_ICONSETCHANGED, 0, 0);

  Translate;
  if LocaleIsBiDi then
    FlipBiDi;
end;

procedure TNewFloppy.GetTranslation(Language: TLanguage);
begin
  Language.GetTranslation('NewFloppy', Self);
  Language.GetTranslation('OpenDialog.Floppy', SaveDialog.Filter);
end;

procedure TNewFloppy.Translate;
begin
  Language.Translate('NewFloppy', Self);
  SaveDialog.Filter := _T('OpenDialog.Floppy');
end;

procedure TNewFloppy.TypeFrom86Box(FloppyType: string);
type
  TIndexData = record
    Name: string; //LowerCase
    Index: integer;
  end;
const
  Indices: array [0..10] of TIndexData =
    ((Name: '525_1dd'; Index: 2),
     (Name: '525_2dd'; Index: 3),
     (Name: '525_2qd'; Index: 3),
     (Name: '525_2hd_ps2'; Index: 4),
     (Name: '525_2hd'; Index: 4),
     (Name: '525_2hd_dualrpm'; Index: 4),
     (Name: '35_2dd'; Index: 5),
     (Name: '35_2hd_ps2'; Index: 6),
     (Name: '35_2hd'; Index: 6),
     (Name: '35_2hd_3mode'; Index: 6),
     (Name: '35_2ed'; Index: 9));
var
  Data: TIndexData;
begin
  FloppyType := LowerCase(FloppyType);
  cbType.ItemIndex := -1;
  for Data in Indices do
    if FloppyType = Data.Name then begin
      cbType.ItemIndex := Data.Index;
      break;
    end;

  if cbType.ItemIndex = -1 then begin
    MessageBox(Handle, _P(ENoSupportedFloppy),
      PChar(Application.Title), MB_ICONINFORMATION or MB_OK);
    cbType.ItemIndex := 6;
  end;
end;

procedure TNewFloppy.UMIconsChanged(var Msg: TMessage);
begin
  IconSet.LoadImage('BANNER_FLOPPY', imgBanner,
    DefScaleOptions - [soBiDiRotate]);
end;

end.
