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

unit frmAboutDlg;

interface

uses
  Windows, Classes, Forms, StdCtrls, Controls, ExtCtrls, uLang;

type
  TAboutDlg = class(TForm, ILanguageSupport)
    imgSplash: TImage;
    lbTitle: TLabel;
    lbVersion: TLabel;
    lbDeveloper: TLabel;
    edVersion: TEdit;
    lbDeveloperInfo: TLabel;
    lbTranslator: TLabel;
    lbTranslatorInfo: TLabel;
    lbWebApplication: TLabel;
    lbWebDeveloper: TLabel;
    lbConnProjects: TLabel;
    lb86Box: TLabel;
    lbUsedProjects: TLabel;
    lbWeb86Box: TLabel;
    lbJCL: TLabel;
    lbWebJCL: TLabel;
    lbLicensing: TLabel;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lbWebApplicationClick(Sender: TObject);
  private
    { Private declarations }
  public
    LangName: string;
    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;
  end;

var
  AboutDlg: TAboutDlg;

implementation

{$R *.dfm}

uses uCommUtil, dmGraphUtil, ShellAPI;

procedure TAboutDlg.FlipBiDi;
begin
  BiDiMode := BiDiModes[LocaleIsBiDi];
  FlipChildren(true);
end;

procedure TAboutDlg.FormCreate(Sender: TObject);
begin
  LoadImageRes('ABOUT', imgSplash, false);
  LangName := Copy(ClassName, 2, MaxInt);

  Translate;
  if LocaleIsBiDi then
    FlipBiDi;

  edVersion.Text := GetFileVer(ParamStr(0));
  lbTitle.Left := (ClientWidth - lbTitle.Width) div 2;
  lbLicensing.Left := (ClientWidth - lbLicensing.Width) div 2;
end;

procedure TAboutDlg.GetTranslation(Language: TLanguage);
begin
  Language.GetTranslation(LangName, Self);
end;

procedure TAboutDlg.lbWebApplicationClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar((Sender as TLabel).Hint), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutDlg.Translate;
begin
  Language.Translate(LangName, Self);
  Caption := Language.ReadString(LangName, LangName, Caption);
end;

end.
