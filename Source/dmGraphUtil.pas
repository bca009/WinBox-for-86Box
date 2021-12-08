unit dmGraphUtil;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Forms,
  ImageList, WinCodec, ComCtrls, ExtCtrls, Generics.Collections,
  ImgList, VirtualImageList, BaseImageCollection, ImageCollection,
  StdCtrls, Themes;

type
  TIconSet = class(TDataModule)
    ListImages: TImageCollection;
    ListIcons: TVirtualImageList;
    ActionImages: TImageCollection;
    Icons32: TVirtualImageList;
    Icons16: TVirtualImageList;
  private
    FPath: string;
    procedure SetPath(const Value: string);
  protected
    BkupListImages,
    BkupActionImages: TObjectDictionary<string, TWICImage>;

    function BackupImageList(const Images: TImageCollection): TObjectDictionary<string, TWICImage>;
    procedure ChangeImageList(Images: TImageCollection; Path: string); overload;
    procedure ChangeImageList(Images: TImageCollection; List: TObjectDictionary<string, TWICImage>); overload;
  public
    //Virtuális gépek színének engedélyezése/letiltása (pl. BiDi-nél letiltva)
    IsColorsAllowed: boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    //Ha már a MainForm is létre van hozva, beállítani mindent.
    procedure Initialize(AControl: TControl);

    //Képek frissítése pl. képrajzoló eljárások cseréje után
    procedure RefreshImages;

    //Tükrözött képrajzoló eljárások
    procedure GetBitmapBiDi(ASourceImage: TWICImage; AWidth,
      AHeight: Integer; out ABitmap: TBitmap);
    procedure DrawBiDi(ASourceImage: TWICImage;
      ACanvas: TCanvas; ARect: TRect; AProportional: Boolean);

    //Kép betöltése erõforrásból, vagy fájlból (attól függ)
    procedure LoadImage(const Name: string; Image: TImage;
      const BiDiRotate: boolean = true);

    //elérhetõ ikonkészletek lekérése
    function GetAvailIconSets(Root: string = ''): TStringList;
    function GetIconSetRoot: string;

    property Path: string read FPath write SetPath;
  end;

  TStyleExtensions = class helper for TStyleManager
  public
    class procedure FixHiddenEdits(Control: TWinControl; const AllLevels, IsSystemStyle: boolean);
  end;

var
  IconSet: TIconSet;

//töltõcsík színezése töltöttség szerint
procedure ColorProgress(const Control: TProgressBar); inline;

//egyedileg rajzolt ComboBox BiDi-kompatibilis rajzolása
procedure ComboDrawBiDi(Canvas: TCanvas; Rect: TRect; ItemText: string);

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
procedure LoadImageRes(const Name: string; Image: TImage;
   const BiDiRotate: boolean = true);

//Üzenet eljuttatása a program minden ablakához
procedure BroadcastMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);

//Source: https://coderedirect.com/questions/441320/prevent-rtl-tlistview-from-mirroring-check-boxes-and-or-graphics
const
  LAYOUT_RTL                        = $01;
  LAYOUT_BITMAPORIENTATIONPRESERVED = $08;

function GetLayout(DC: HDC): DWORD; stdcall; external 'gdi32.dll';
function SetLayout(DC: HDC; dwLayout: DWORD): DWORD; stdcall; external 'gdi32.dll';

procedure InvariantBiDiLayout(const DC: HDC); inline;

resourcestring
  PfIconSetPath   = 'Iconsets\';
  PathEmuIconSets = 'roms\icons\';

implementation

uses uCommText, uLang;

resourcestring
  PfActionImages = 'Actions\';
  PfListImages   = 'List\';
  PfDataImages   = 'Others\';
  PfIconInfo = 'iconinfo.txt';

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure ComboDrawBiDi(Canvas: TCanvas; Rect: TRect; ItemText: string);
begin
  if LocaleIsBiDi then begin
    Canvas.FillRect(Rect);
    Canvas.TextRect(Rect, ItemText, [tfRtlReading, tfRight]);
  end
  else
    Canvas.TextRect(Rect, Rect.Left, Rect.Top, ItemText);
end;

procedure BroadcastMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
var
  I: Integer;
begin
  for I := 0 to Screen.FormCount - 1 do
    PostMessage(Screen.Forms[I].Handle, Msg, wParam, lParam);
end;

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

  if Image.Visible and Assigned(Image.Parent) and Image.Parent.Visible then
    Image.Parent.Invalidate;
end;

procedure LoadImageRes(const Name: string; Image: TImage;
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

function TIconSet.BackupImageList(
  const Images: TImageCollection): TObjectDictionary<string, TWICImage>;
var
  I: integer;
  Clone: TWICImage;
begin
  Result := TObjectDictionary<string, TWICImage>.Create;

  with Images do
    for I := 0 to Images.Count - 1 do
      with Images[I], SourceImages.Items[0] do begin
        Clone := TWICImage.Create;
        Clone.Assign(Image);

        Result.Add(Name, Clone);
      end;
end;

procedure TIconSet.ChangeImageList(Images: TImageCollection;
  List: TObjectDictionary<string, TWICImage>);
var
  I: integer;
  ListImage: TWICImage;
begin
  if not Assigned(List) then
    exit;

  with Images do
    for I := 0 to Images.Count - 1 do
      with Images[I], SourceImages.Items[0] do
        if List.TryGetValue(Name, ListImage) then
          Image.Assign(ListImage);
end;

procedure TIconSet.ChangeImageList(Images: TImageCollection; Path: string);
var
  I: integer;
  FileName: string;
begin
  Path := IncludeTrailingPathDelimiter(Path);

  with Images do
    for I := 0 to Images.Count - 1 do
    with Images[I], SourceImages.Items[0] do begin
      FileName := Path + Name + '.png';

      if FileExists(FileName) then
        Image.LoadFromFile(FileName);
    end;
end;

constructor TIconSet.Create(AOwner: TComponent);
begin
  inherited;
  IsColorsAllowed := true;

  //Induljunk valami olyan szöveggel amit fixen mindig le kell cserélni
  FPath := '?';

  //Mentsük le az eredeti képlistákat (visszaállításhoz)
  BkupListImages := BackupImageList(ListImages);
  BkupActionImages := BackupImageList(ActionImages);
end;

//Az AProportional tulajdonság jelenleg nem támogatott ezen a módon.
destructor TIconSet.Destroy;
begin
  BkupActionImages.Free;
  BkupListImages.Free;
  inherited;
end;

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
function TIconSet.GetAvailIconSets(Root: string): TStringList;
var
  SearchRec: TSearchRec;
  IconInfo: TextFile;
  Description, FileName: string;
begin
  if Root = '' then
    Root := GetIconSetRoot;

  Root := IncludeTrailingPathDelimiter(Root);
  Result := TStringList.Create;

  if FindFirst(Root + '*.*', faAnyFile, SearchRec) = 0 then begin
    repeat
      with SearchRec do
        if (Name <> '.') and (Name <> '..') and
           ((Attr and faDirectory) <> 0) then begin
             Description := Name;
             FileName := Root + Name + PathDelim + PfIconInfo;

             if FileExists(FileName) then begin
               AssignFile(IconInfo, FileName);
               try
                 Reset(IconInfo);
                 ReadLn(IconInfo, Description);
               finally
                 CloseFile(IconInfo);
               end;
             end;

             Result.Add(Name + '=' + Description);
           end;

    until FindNext(SearchRec) <> 0;

    FindClose(SearchRec);
  end;
end;

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


function TIconSet.GetIconSetRoot: string;
begin
  Result := ExtractFilePath(paramstr(0)) + PfIconSetPath;
end;

procedure TIconSet.Initialize(AControl: TControl);
const
  ListIconSize = 42;
begin
  //Állítsuk be a DPI-nek megfelelõen a lista méreteket
  with AControl do begin
    Icons16.SetSize(GetSystemMetrics(SM_CXSMICON),
                    GetSystemMetrics(SM_CYSMICON));

    Icons32.SetSize(GetSystemMetrics(SM_CXICON),
                    GetSystemMetrics(SM_CYICON));

    ListIcons.SetSize(ListIconSize * CurrentPPI div 96,
                      ListIconSize * CurrentPPI div 96);
  end;
end;

procedure TIconSet.LoadImage(const Name: string; Image: TImage;
  const BiDiRotate: boolean);
var
  FileName: string;
  Bitmap: TWICImage;
begin
  FileName := FPath + PfDataImages + Name + '.png';

  if (FPath = '') or not FileExists(FileName) then
    dmGraphUtil.LoadImageRes(Name, Image, BiDiRotate)
  else begin
    Bitmap := TWICImage.Create;
    try
      Bitmap.LoadFromFile(FileName);
      DisplayWIC(Bitmap, Image, BiDiRotate);
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TIconSet.RefreshImages;
begin
  IsColorsAllowed := not LocaleIsBiDi and StyleServices.IsSystemStyle;

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

procedure TIconSet.SetPath(const Value: string);
begin
  if ((FPath = '') and (Value = '')) or
     (FPath = IncludeTrailingPathDelimiter(Value)) then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;

  try
    if Value = '' then begin
      FPath := '';
      ChangeImageList(ListImages, BkupListImages);
      ChangeImageList(ActionImages, BkupActionImages);
    end
    else begin
      FPath := IncludeTrailingPathDelimiter(Value);
      ChangeImageList(ListImages, FPath + PfListImages);
      ChangeImageList(ActionImages, FPath + PfActionImages);
    end;

    ListImages.Change;
    ActionImages.Change;
    RefreshImages;
    BroadcastMessage(UM_ICONSETCHANGED, 0, 0);
  finally
    Screen.Cursor := crArrow;
  end;
end;

{ TStyleExtensions }

class procedure TStyleExtensions.FixHiddenEdits(Control: TWinControl;
  const AllLevels, IsSystemStyle: boolean);
var
  I: Integer;
begin
  if Assigned(Control) then
    for I := 0 to Control.ControlCount - 1 do begin
      if Control.Controls[I] is TEdit then
        with Control.Controls[I] as TEdit do
          if BorderStyle = bsNone then begin
            StyleElements := [];

            if IsSystemStyle then begin
              ParentColor := true;
              ParentFont := true;
            end
            else begin
              Color :=
                TStyleManager.ActiveStyle.GetSystemColor(clBtnFace);
              Font.Color :=
                TStyleManager.ActiveStyle.GetStyleFontColor(sfTextLabelNormal);
            end;
          end;

      if AllLevels and (Control.Controls[I] is TWinControl) and
         ((Control.Controls[I] as TWinControl).ControlCount > 0) then
           FixHiddenEdits(Control.Controls[I] as TWinControl,
             AllLevels, IsSystemStyle);
    end;
end;

end.
