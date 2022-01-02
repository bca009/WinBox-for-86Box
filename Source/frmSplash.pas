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

unit frmSplash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TWinBoxSplash = class(TForm)
    imgSplash: TImage;
    rcBorder: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  WinBoxSplash: TWinBoxSplash;

implementation

{$R *.dfm}

uses dmGraphUtil;

procedure TWinBoxSplash.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.ExStyle := Params.ExStyle and not WS_EX_APPWINDOW;
  Params.WndParent := Application.Handle;
end;

procedure TWinBoxSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
end;

procedure TWinBoxSplash.FormCreate(Sender: TObject);
begin
  if IsDebuggerPresent then
    FormStyle := fsNormal;

  LoadImageRes('SPLASH', imgSplash, DefScaleOptions - [soOverScale]);
  Screen.Cursor := crAppStart;
  Application.ProcessMessages;
end;

end.
