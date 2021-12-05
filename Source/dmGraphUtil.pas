unit dmGraphUtil;

interface

uses
  Windows, SysUtils, Classes, Controls, Graphics, Forms,
  ImageList, ImgList, WinCodec, ComCtrls, ExtCtrls,
  VirtualImageList, BaseImageCollection, ImageCollection;

type
  TIconSet = class(TDataModule)
    ListImages: TImageCollection;
    ListIcons: TVirtualImageList;
    ActionImages: TImageCollection;
    Icons32: TVirtualImageList;
    Icons16: TVirtualImageList;
  public
    //Virtuális gépek színének engedélyezése/letiltása (pl. BiDi-nél letiltva)
    IsColorsAllowed: boolean;

    constructor Create(AOwner: TComponent); override;

    //Ha már a MainForm is létre van hozva, beállítani mindent.
    procedure Initialize(AControl: TControl);

    //Képek frissítése pl. képrajzoló eljárások cseréje után
    procedure RefreshImages;

    //Tükrözött képrajzoló eljárások
    procedure GetBitmapBiDi(ASourceImage: TWICImage; AWidth,
      AHeight: Integer; out ABitmap: TBitmap);
    procedure DrawBiDi(ASourceImage: TWICImage;
      ACanvas: TCanvas; ARect: TRect; AProportional: Boolean);
  end;

var
  IconSet: TIconSet;

procedure ColorProgress(const Control: TProgressBar); inline;

//színek a háttérszín alapján
function GetTextColor(const Color: TColor): TColor;
function GetLinkColor(Color: TColor): TColor;

function LoadIconWithScaleDown(hinst: HINST; pszName: LPCWSTR; cx: Integer;
    cy: Integer; var phico: HICON): HResult; stdcall; external 'comctl32.dll';
{$EXTERNALSYM LoadIconWithScaleDown}

procedure ScaleWIC(var Source: TWICImage; const Width, Height: integer;
  const BiDiRotate: boolean = true); overload;
procedure DisplayWIC(var Source: TWICImage; Image: TImage;
  const BiDiRotate: boolean = true);
procedure LoadImage(const Name: string; Image: TImage;
  const BiDiRotate: boolean = true);

//Source: https://coderedirect.com/questions/441320/prevent-rtl-tlistview-from-mirroring-check-boxes-and-or-graphics
const
  LAYOUT_RTL                        = $01;
  LAYOUT_BITMAPORIENTATIONPRESERVED = $08;

function GetLayout(DC: HDC): DWORD; stdcall; external 'gdi32.dll';
function SetLayout(DC: HDC; dwLayout: DWORD): DWORD; stdcall; external 'gdi32.dll';

procedure InvariantBiDiLayout(const DC: HDC); inline;

implementation

uses uLang;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

//Ez a verzió visszaírja a képbe az új Handle-t
procedure ScaleWIC(var Source: TWICImage; const Width, Height: integer;
  const BiDiRotate: boolean); overload;
var
  Factory: IWICImagingFactory;
  Scaler: IWICBitmapScaler;
  Rotator: IWICBitmapFlipRotator;
begin
  if not Assigned(Source) then
    exit;

  try
    Factory := TWICImage.ImagingFactory;

    if LocaleIsBiDi and BiDiRotate then
      try
        Factory.CreateBitmapFlipRotator(Rotator);
        Rotator.Initialize(Source.Handle,
          WICBitmapTransformFlipHorizontal);
      finally
        Source.Handle := IWICBitmap(Rotator);
        Rotator := nil;
      end;

    Factory.CreateBitmapScaler(Scaler);
    Scaler.Initialize(Source.Handle, Width, Height,
      WICBitmapInterpolationModeHighQualityCubic);
  finally
    Source.Handle := IWICBitmap(Scaler);
    Scaler := nil;
    Factory := nil;
  end;
end;

procedure DisplayWIC(var Source: TWICImage; Image: TImage;
  const BiDiRotate: boolean);
var
  Temp: TWICImage;
begin
  Temp := TWICImage.Create;
  Temp.Assign(Source);
  ScaleWIC(Temp, Image.Width, Image.Height, BiDiRotate);
  Image.Picture.Assign(Temp);
  Temp.Free;
end;

procedure LoadImage(const Name: string; Image: TImage;
  const BiDiRotate: boolean);
var
  Bitmap: TWICImage;
  Stream: TResourceStream;
begin
  Bitmap := TWICImage.Create;
  Stream := TResourceStream.Create(hInstance, Name, RT_RCDATA);
  try
    Bitmap.LoadFromStream(Stream);
    DisplayWIC(Bitmap, Image, BiDiRotate);
  finally
    Stream.Free;
    Bitmap.Free;
  end;
end;

function GetTextColor(const Color: TColor): TColor;
begin
  if (Color = clBtnFace) or (Color = clWindow) then
    Result := clWindowText
  else if 0.299 * GetRValue(Color) + 0.587 * GetGValue(Color) +
      0.114 * GetBValue(Color) > 127 then
    Result := clBlack
  else
    Result := clWhite;
end;

function GetLinkColor(Color: TColor): TColor;
var
  R, G, B, A: byte;
const
  VisibleDelta = 15;
begin
  if (Color = clBtnFace) or (Color = clWindow) or (Color = clNone) then
    Result := clHotLight
  else begin
    Color := ColorToRGB(Color);
    R := GetRValue(Color);
    G := GetGValue(Color);
    B := GetBValue(Color);

    A := byte((longword(R) + G + B) div 3);

    if (abs(R - A) + abs(B - A) + abs(G - A)) div 3 > VisibleDelta then
       Result := RGB($FF - R, $FF - G, $FF - B)
    else if A < 128 then
       Result := clWhite
    else
       Result := clBlack;
  end;
end;

procedure ColorProgress(const Control: TProgressBar); inline;
begin
  if Control.Position > 90 then
    Control.State := pbsError
  else if Control.Position > 75 then
    Control.State := pbsPaused
  else
    Control.State := pbsNormal;
end;

//Source: https://coderedirect.com/questions/441320/prevent-rtl-tlistview-from-mirroring-check-boxes-and-or-graphics
procedure InvariantBiDiLayout(const DC: HDC);
var
  Layout: DWORD;
begin
  Layout := GetLayout(DC);
  if (Layout and LAYOUT_RTL) <> 0 then
    SetLayout(DC, Layout or LAYOUT_BITMAPORIENTATIONPRESERVED);
end;

{ TIconSet }

constructor TIconSet.Create(AOwner: TComponent);
begin
  inherited;
  IsColorsAllowed := true;
end;

//Az AProportional tulajdonság jelenleg nem támogatott ezen a módon.
procedure TIconSet.DrawBiDi(ASourceImage: TWICImage; ACanvas: TCanvas;
  ARect: TRect; AProportional: Boolean);
begin
  if ARect.IsEmpty then
    Exit;

  if ASourceImage <> nil then begin
    ASourceImage.InterpolationMode := wipmHighQualityCubic;
    ACanvas.StretchDraw(ARect, ASourceImage);
  end;
end;

//Ez a verzió bitképpé konvertálja a kép új Handle-jét, és felszabadítja
procedure TIconSet.GetBitmapBiDi(ASourceImage: TWICImage; AWidth,
  AHeight: Integer; out ABitmap: TBitmap);
var
  RotatedImage: TWICImage;
  BufferImage: TWICImage;
  Factory: IWICImagingFactory;
  Rotator: IWICBitmapFlipRotator;
begin
  Factory := TWICImage.ImagingFactory;
  Factory.CreateBitmapFlipRotator(Rotator);
  Rotator.Initialize(ASourceImage.Handle, WICBitmapTransformFlipHorizontal);

  ABitmap := TBitmap.Create;

  RotatedImage := TWICImage.Create;
  RotatedImage.Handle := IWICBitmap(Rotator);

  try
    if (ASourceImage.Width = AWidth) and (ASourceImage.Height = AHeight) then
      ABitmap.Assign(RotatedImage)
    else begin
      BufferImage := RotatedImage.CreateScaledCopy(AWidth, AHeight,
        wipmHighQualityCubic);
      try
        ABitmap.Assign(BufferImage);
      finally
        BufferImage.Free;
      end;
    end;
  finally
    RotatedImage.Free;
  end;

  if ABitmap.PixelFormat = pf32bit then
    ABitmap.AlphaFormat := afIgnored;
end;


procedure TIconSet.Initialize(AControl: TControl);
const
  ListIconSize = 42;
begin
  with AControl do begin
    Icons16.SetSize(GetSystemMetrics(SM_CXSMICON),
                    GetSystemMetrics(SM_CYSMICON));

    Icons32.SetSize(GetSystemMetrics(SM_CXICON),
                    GetSystemMetrics(SM_CYICON));

    ListIcons.SetSize(ListIconSize * CurrentPPI div 96,
                      ListIconSize * CurrentPPI div 96);
  end;
end;

procedure TIconSet.RefreshImages;
begin
  IsColorsAllowed := not LocaleIsBiDi;

  if LocaleIsBiDi then begin
    ListImages.OnDraw := DrawBiDi;
    ListImages.OnGetBitmap := GetBitmapBiDi;

    ActionImages.OnDraw := DrawBiDi;
    ActionImages.OnGetBitmap := GetBitmapBiDi;
  end
  else begin
    ListImages.OnDraw := nil;
    ListImages.OnGetBitmap := nil;

    ActionImages.OnDraw := nil;
    ActionImages.OnGetBitmap := nil;
  end;

  Icons16.UpdateImageList;
  ListIcons.UpdateImageList;

  ActionImages.OnDraw := nil;
  ActionImages.OnGetBitmap := nil;

  Icons32.UpdateImageList;
end;

end.
