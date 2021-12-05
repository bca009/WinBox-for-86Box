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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WinBoxSplash: TWinBoxSplash;

implementation

{$R *.dfm}

uses dmGraphUtil;

procedure TWinBoxSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
end;

procedure TWinBoxSplash.FormCreate(Sender: TObject);
begin
  if IsDebuggerPresent then
    FormStyle := fsNormal;

  LoadImageRes('SPLASH', imgSplash);
  Screen.Cursor := crAppStart;
  Application.ProcessMessages;
end;

end.
