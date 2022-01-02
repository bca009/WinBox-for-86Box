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
