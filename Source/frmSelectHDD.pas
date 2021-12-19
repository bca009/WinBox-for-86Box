(*

    WinBox Reloaded R2 - An universal GUI for many emulators

    Copyright (C) 2020, Laci bá'

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

unit frmSelectHDD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Data.DB, Grids, DBGrids, DBCtrls,
  StdCtrls, ExtCtrls, Vcl.Samples.Spin, Datasnap.DBClient,
  uLang, uImaging, uCommText;

type
  ISelectHDD = interface
    ['{BCC01793-CEDA-4491-B1FF-98F9723BB6AA}']
    function Execute(const Silent: boolean): boolean; stdcall;
    function GetDiskData: TDiskData; stdcall;
    procedure SetDiskData(const Data: TDiskData); stdcall;
    procedure SetConnectorFilter(const Lock: boolean); stdcall;
    procedure SetCHSFilter(const Enabled: boolean); stdcall;

    function LocatePhysCHS: boolean; stdcall;
    function LocateTransCHS: boolean; stdcall;

    property DiskData: TDiskData read GetDiskData write SetDiskData;
  end;

  THDSelect = class(TForm, ISelectHDD, ILanguageSupport)
    ClientDataSet: TClientDataSet;
    DBGrid: TDBGrid;
    gbFilter: TGroupBox;
    cbManufacturer: TComboBox;
    lbManufacturer: TLabel;
    lbC: TLabel;
    lbH: TLabel;
    lbS: TLabel;
    spC: TSpinEdit;
    spH: TSpinEdit;
    spS: TSpinEdit;
    rbFilterByGeometry: TRadioButton;
    rbFilterByCapacity: TRadioButton;
    spCapLimitHigh: TSpinEdit;
    spCapLimitLow: TSpinEdit;
    lbMB2: TLabel;
    lbMB1: TLabel;
    cbCapLimitLow: TComboBox;
    cbCapLimitHigh: TComboBox;
    rbNoFilter: TRadioButton;
    lbConnector: TLabel;
    cbConnector: TComboBox;
    pnTop: TPanel;
    pnBottom: TPanel;
    btnShowFilter: TButton;
    btnHideFilter: TButton;
    cbSortBy: TComboBox;
    lbSortBy: TLabel;
    btnCancel: TButton;
    btnOK: TButton;
    DBNavigator: TDBNavigator;
    DataSource: TDataSource;
    edModel: TEdit;
    lbModel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ClientDataSetFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FilterChange(Sender: TObject);
    procedure btnShowFilterClick(Sender: TObject);
    procedure cbSortByChange(Sender: TObject);
    procedure DBGridCellClick(Column: TColumn);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridColumnMoved(Sender: TObject; FromIndex, ToIndex: Integer);
  private
    FDiskData: TDiskData;
    FBookmark: TBookmark;

    FStandard: string;

    procedure UMIconsChanged(var Msg: TMessage); message UM_ICONSETCHANGED;
  protected
  public
    procedure LoadTable;
    function Execute(const Silent: boolean): boolean; stdcall;

    function GetDiskData: TDiskData; stdcall;
    procedure SetDiskData(const Data: TDiskData); stdcall;
    procedure SetConnectorFilter(const Lock: boolean); stdcall;
    procedure SetCHSFilter(const Enabled: boolean); stdcall;

    function LocatePhysCHS: boolean; stdcall;
    function LocateTransCHS: boolean; stdcall;

    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;
  end;

var
  HDSelect: THDSelect;

implementation

{$R *.dfm}

uses dmGraphUtil;

resourcestring
  EFailedToAddRow    = 'SelectHDD.EFailedToAddRow';
  EInvalidRecord     = 'SelectHDD.EInvalidRecord';
  StrClientDataSet   = 'SelectHDD.ClientDataSet.FieldDefs[%d]';
  StrAnyManufacturer = 'SelectHDD.AnyManufacturer';
  StrAnyConnector    = 'SelectHDD.AnyConnector';

procedure THDSelect.btnShowFilterClick(Sender: TObject);
begin
  pnBottom.Visible := not pnBottom.Visible;
  gbFilter.Visible := not gbFilter.Visible;

  if pnBottom.Visible then begin
    ClientHeight := ClientHeight - gbFilter.Height + pnBottom.Height;
    Top := Top - (pnBottom.Height - gbFilter.Height) div 2;
  end
  else begin
    ClientHeight := ClientHeight + gbFilter.Height - pnBottom.Height;
    Top := Top - (pnBottom.Height + gbFilter.Height) div 2;
  end;

  if Top < 0 then
    Top := 0;
end;

procedure THDSelect.btnOKClick(Sender: TObject);
begin
  with FDiskData, ClientDataSet do begin
    StrPLCopy(@szManufacturer[0], Fields[1].AsString + #0, 35);
    StrPLCopy(@szModel[0], Fields[2].AsString + #0, 30);
    dwNominalSize := Fields[3].AsInteger;
    dgPhysicalGeometry.C := Fields[4].AsInteger;
    dgPhysicalGeometry.H := Fields[5].AsInteger;
    dgPhysicalGeometry.S := Fields[6].AsInteger;
    dwWritePreComp := Fields[7].AsInteger;
    dwLandZone := Fields[8].AsInteger;
    StrPLCopy(@szConnector[0], Fields[9].AsString + #0, 20);
    dgTranslatedGeometry.C := Fields[10].AsInteger;
    dgTranslatedGeometry.H := Fields[11].AsInteger;
    dgTranslatedGeometry.S := Fields[12].AsInteger;
  end;
  ModalResult := mrOK;
end;

procedure THDSelect.ClientDataSetFilterRecord(DataSet: TDataSet; var Accept: Boolean);

  function CheckValue(A, B, Op: integer): boolean;
  begin
    case Op of
      0: Result := A = B;  //egyenlõ
      1: Result := A <> B; //nem egyenlõ
      2: Result := A < B;  //kisebb
      3: Result := A <= B; //kisebb, vagy egyenlõ
      4: Result := A > B;  //nagyobb
      5: Result := A >= B; //nagyobb, vagy egyenlõ
      else Result := true;
    end;
  end;

begin
  if cbManufacturer.ItemIndex > 0 then
    Accept := Accept and (ClientDataSet.Fields[1].AsString = cbManufacturer.Items[cbManufacturer.ItemIndex]);

  if cbConnector.ItemIndex > 0 then
    Accept := Accept and (ClientDataSet.Fields[9].AsString = cbConnector.Items[cbConnector.ItemIndex]);

  if rbFilterByGeometry.Checked then
    Accept := Accept and
              (ClientDataSet.Fields[4].AsInteger = spC.Value) and
              (ClientDataSet.Fields[5].AsInteger = spH.Value) and
              (ClientDataSet.Fields[6].AsInteger = spS.Value)
  else if rbFilterByCapacity.Checked then begin
    Accept := Accept and
              CheckValue(ClientDataSet.Fields[3].AsInteger,
                         spCapLimitLow.Value,
                         cbCapLimitLow.ItemIndex) and
              CheckValue(ClientDataSet.Fields[3].AsInteger,
                         spCapLimitHigh.Value,
                         cbCapLimitHigh.ItemIndex);
  end;

  if edModel.Text <> '' then
    Accept := Accept and
              (pos(edModel.Text, UpperCase(ClientDataSet.Fields[2].AsString)) <> 0);
end;

procedure THDSelect.cbSortByChange(Sender: TObject);
begin
  if cbSortBy.ItemIndex > 0 then
    ClientDataSet.IndexFieldNames := cbSortBy.Text
  else
    ClientDataSet.IndexFieldNames := '';
end;

procedure THDSelect.DBGridCellClick(Column: TColumn);
begin
  DBGrid.SelectedRows.CurrentRowSelected := True;
end;

procedure THDSelect.DBGridColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
  (Sender as TDBGrid).Columns[ToIndex].Index := FromIndex;
end;

function THDSelect.Execute(const Silent: boolean): boolean;
begin
  if Silent then begin
    FormShow(Self);
    btnOKClick(Self);
    Result := true;
  end
  else
    Result := ShowModal = mrOK;
end;

procedure THDSelect.FormCreate(Sender: TObject);
var
  I: Integer;
const
  HiddenColumns: set of byte = [0];
begin
  ApplyActiveStyle;
  Perform(UM_ICONSETCHANGED, 0, 0);

  Translate;
  if LocaleIsBiDi then
    FlipBiDi;

  if ClientDataSet.State = dsInactive then
    ClientDataSet.CreateDataSet;

  for I := 0 to DBGrid.Columns.Count - 1 do
    if I in HiddenColumns then
      DBGrid.Columns[I].Visible := false
    else
      cbSortBy.Items.Add(ClientDataSet.FieldDefs[I].Name);

  cbSortBy.ItemIndex := 3;
  cbSortByChange(cbSortBy);

  FDiskData.szConnector := '';
  LoadTable;
end;

procedure THDSelect.FormShow(Sender: TObject);
begin
  if not FDiskData.dgPhysicalGeometry.IsEmpty then begin
    spC.Value := FDiskData.dgPhysicalGeometry.C;
    spH.Value := FDiskData.dgPhysicalGeometry.H;
    spS.Value := FDiskData.dgPhysicalGeometry.S;
  end;
end;

function THDSelect.GetDiskData: TDiskData;
begin
  Result := FDiskData;
end;

function DownCase(Ch: Char): Char;
begin
  if CharInSet(Ch, ['A'..'Z']) then
    Result := Chr(Ord(Ch) - Ord('A') + Ord('a'))
  else
    Result := Ch;
end;

function CorrectNames(const Name: string): string;
const
  Alpha = ['0'..'9', 'a'..'z', 'A'..'Z'];
var
  I, J, K: integer;
begin
  Result := Name;

  if (Result = '') or (length(Result) <= 3) or (Result[1] = '(') then
    exit;

  J := 1;
  K := -1;
  for I := 1 to High(Name) do begin
    if CharInSet(Result[I], Alpha) then begin
      if (J = -1) then
        Result[I] := DownCase(Result[I])
      else begin
        Result[I] := UpCase(Result[I]);
        J := -1;
      end;
    end
    else
      J := 1;

    if (K = -1) and (Result[I] = ' ') then
      K := I;
  end;

  if (K <= 4) and (K <> -1) then
    for I := 1 to K do
      Result[I] := UpCase(Result[I]);
end;

procedure THDSelect.LoadTable;
var
  R: TResourceStream;
  List, Rec: TStringList;
  I, J: Integer;

  procedure FixNumbers(const Indices: array of integer);
  var
    I: integer;
  begin
    for I := Low(Indices) to High(Indices) do
      if Rec.Count > Indices[I] then
        Rec[Indices[I]] := StringReplace(Rec[Indices[I]], ',', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  end;

begin
  with ClientDataSet do begin
    ReadOnly := false;
    DisableControls;

    cbManufacturer.Clear;
    cbManufacturer.Items.Add('-');
    cbConnector.Clear;
    cbConnector.Items.Add('-');

    List := TStringList.Create;
    try
      R := TResourceStream.Create(hInstance, 'HDD_TABLA', RT_RCDATA);
      List.LoadFromStream(R);
      R.Free;

      EmptyDataSet;
      Self.Translate;
      Rec := TStringList.Create;
      try
        for I := 0 to List.Count - 1 do begin
          Rec.Clear;
          ExtractStrings([';'],[], PChar(List[I]), Rec);

          if (Rec.Count >= 2) then
            Rec[1] := StringReplace(Rec[1], '%STANDARD%', FStandard, []);

          if (Rec.Count >= 10) then begin
            if (cbManufacturer.Items.IndexOf(Rec[1]) = -1) then
                cbManufacturer.Items.Add(CorrectNames(Rec[1]));
            if (cbConnector.Items.IndexOf(Rec[9]) = -1)
               and ((FDiskData.szConnector = '') or (pos(String(FDiskData.szConnector), Rec[9]) <> 0)) then
                cbConnector.Items.Add(Rec[9]);
          end;

          FixNumbers([4, 5, 6, 7, 8, 10, 11, 12]);

          Append;

          Fields[0].Value := Rec[0];
          Fields[1].Value := CorrectNames(Rec[1]);
          for J := 2 to Rec.Count - 1 do
            try
              Fields[J].Value := Rec[J];
            except
                on E: EDatabaseError do begin
                   Cancel;  // Failed, discard the record
                   MessageBox(Handle, PChar(
                     format(_T(EInvalidRecord), [I + 1, J, Rec[J]])),
                     PChar(Application.Name), MB_ICONERROR or MB_OK);
                   break;    // Continue with next record
                end;
              end;

          if State = dsInsert then // It's not dsInsert if we Cancelled the Insert
            try
              Post;
            except
              on E:EDatabaseError do begin
                // log error instead of showing
                MessageBox(Handle, PChar(
                     format(_T(EFailedToAddRow), [List[I], I + 1])),
                     PChar(Application.Name), MB_ICONERROR or MB_OK);
                ClientDataSet.Cancel;
              end;
            end;
        end;
      finally
        Rec.Free;
      end;
    finally
      cbManufacturer.ItemIndex := 0;
      if FDiskData.szConnector = '' then
        cbConnector.ItemIndex := 0
      else if cbConnector.Items.Count > 1 then
        cbConnector.ItemIndex := 1;
      EnableControls;
      ReadOnly := true;
      Filtered := false;
      Filtered := true;
      List.Free;
    end;
  end;
end;

function THDSelect.LocatePhysCHS: boolean;
var
  A: Variant;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    if FDiskData.dgPhysicalGeometry.IsEmpty then
      exit(false);

    A := VarArrayCreate([0, 2], varVariant);
    A[0] := FDiskData.dgPhysicalGeometry.C;
    A[1] := FDiskData.dgPhysicalGeometry.H;
    A[2] := FDiskData.dgPhysicalGeometry.S;
    Result := ClientDataSet.Locate('C;H;S', A, []);
  finally
    Screen.Cursor := crDefault;
  end;
end;

function THDSelect.LocateTransCHS: boolean;
var
  A: Variant;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    if FDiskData.dgTranslatedGeometry.IsEmpty then
      exit(false);

    A := VarArrayCreate([0, 2], varVariant);
    A[0] := FDiskData.dgTranslatedGeometry.C;
    A[1] := FDiskData.dgTranslatedGeometry.H;
    A[2] := FDiskData.dgTranslatedGeometry.S;
    Result := ClientDataSet.Locate('TC;TH;TS', A, []);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure THDSelect.SetCHSFilter(const Enabled: boolean);
begin
  if Enabled then
    rbFilterByGeometry.Checked := true
  else
    rbNoFilter.Checked := true;

  FilterChange(Self);
end;

procedure THDSelect.SetConnectorFilter(const Lock: boolean);
begin
  with cbConnector do begin
    if FDiskData.szConnector <> '' then
      ItemIndex := Items.IndexOf(string(FDiskData.szConnector));
    if ItemIndex = -1 then
      ItemIndex := 0;

    FilterChange(Self);
    Enabled := (not Lock) or (ItemIndex = 0);
  end;
end;

procedure THDSelect.SetDiskData(const Data: TDiskData);
begin
  FDiskData := Data;
end;

procedure THDSelect.GetTranslation(Language: TLanguage);
var
  I: integer;
begin
  Language.GetTranslation('SelectHDD', Self);
  for I := 0 to ClientDataSet.FieldDefs.Count - 1 do
    Language.GetTranslation(format(StrClientDataSet, [I]), ClientDataSet.FieldDefs[I].Name);
end;

procedure THDSelect.Translate;
var
  I, Temp: integer;
  Standard: string;
begin
  if ClientDataSet.Fields.Count > 0 then
    for I := 0 to ClientDataSet.Fields.Count - 1 do begin
      ClientDataSet.Fields[I].DisplayLabel := _T(format(StrClientDataSet, [I]));

      Temp := cbSortBy.ItemIndex;
      cbSortBy.Items[I + 1] := ClientDataSet.Fields[I].DisplayLabel;
      cbSortBy.ItemIndex := Temp;
    end;

  Temp := cbConnector.ItemIndex;
  if cbConnector.Items.Count > 0 then
    cbConnector.Items[0] := _T(StrAnyConnector);
  cbConnector.ItemIndex := Temp;

  Standard := _T(StrStandard);
  Temp := cbManufacturer.ItemIndex;
  if cbManufacturer.Items.Count > 0 then
    cbManufacturer.Items[0] := _T(StrAnyManufacturer);

  for I := 0 to cbManufacturer.Items.Count - 1 do
    cbManufacturer.Items[I] := StringReplace(
      cbManufacturer.Items[I], FStandard, Standard, []);
  cbManufacturer.ItemIndex := Temp;
  FStandard := Standard;

  Language.Translate('SelectHDD', Self);
end;

procedure THDSelect.UMIconsChanged(var Msg: TMessage);
begin
  IconSet.Icons16.GetIcon(10, Icon);
end;

procedure THDSelect.FilterChange(Sender: TObject);
begin
  with ClientDataSet do begin
    FBookmark := GetBookmark;

    Filtered := false;
    Filtered := true;

    if BookmarkValid(FBookmark) then
      GotoBookmark(FBookmark);
  end;

  spC.Enabled := rbFilterByGeometry.Checked;
  spH.Enabled := rbFilterByGeometry.Checked;
  spS.Enabled := rbFilterByGeometry.Checked;

  cbCapLimitLow.Enabled := rbFilterByCapacity.Checked;
  cbCapLimitHigh.Enabled := rbFilterByCapacity.Checked;
  spCapLimitLow.Enabled := rbFilterByCapacity.Checked;
  spCapLimitHigh.Enabled := rbFilterByCapacity.Checked;
end;

procedure THDSelect.FlipBiDi;
begin
  BiDiMode := BiDiModes[LocaleIsBiDi];
  FlipChildren(true);
end;

end.
