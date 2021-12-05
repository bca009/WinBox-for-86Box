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

unit frmWizardHDD;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, StdCtrls, ComCtrls,
  Controls, ExtCtrls, uImaging, uLang, Vcl.Samples.Spin;

type
  IWizardHDD = interface
    ['{57E94996-C896-45BD-811D-08BA692D0B49}']
    function GetIsVHD: boolean; stdcall;
    procedure SetIsVHD(const Value: boolean); stdcall;
    function GetSparse: boolean; stdcall;
    procedure SetSparse(const Value: boolean); stdcall;
    function GetFileName: PChar; stdcall;
    procedure SetFileName(const Value: PChar); stdcall;
    function GetDiskData: TDiskData; stdcall;
    procedure SetDiskData(const Value: TDiskData); stdcall;
    procedure SetConnectorFilter(const Lock: boolean); stdcall;
    function Execute(const AutoCreate: boolean): boolean; stdcall;
    function TryCreate: boolean; stdcall;
    procedure SaveLogFile(const FileName: PChar); stdcall;

    property Sparse: boolean read GetSparse write SetSparse;
    property FileName: PChar read GetFileName write SetFileName;
    property DiskData: TDiskData read GetDiskData write SetDiskData;
  end;

  TWizardHDD = class(TForm, IWizardHDD, ILanguageSupport)
    imgBanner: TImage;
    pcPages: TPageControl;
    bvBottom: TBevel;
    btnNext: TButton;
    tabWelcome: TTabSheet;
    btnPrev: TButton;
    lbWelcome: TLabel;
    lbGreetings: TLabel;
    tabBasic: TTabSheet;
    lbBasicInfo: TLabel;
    lbFileName: TLabel;
    edFileName: TEdit;
    btnBrowse: TButton;
    lbFileNameDesc: TLabel;
    lbFileNameNote: TLabel;
    lbParamMode: TLabel;
    cbParamMode: TComboBox;
    tabCapacity: TTabSheet;
    lbCapacityTitle: TLabel;
    lbCapacityDesc: TLabel;
    lbConnectorNote: TLabel;
    imgWarning: TImage;
    lbConnector: TLabel;
    cbConnector: TComboBox;
    lbCapacity: TLabel;
    tbCapacity: TTrackBar;
    lbCapacitySelected: TLabel;
    lbAutoC: TLabel;
    lbAutoH: TLabel;
    spAutoC: TSpinEdit;
    spAutoH: TSpinEdit;
    lbAutoS: TLabel;
    spAutoS: TSpinEdit;
    tabParameters: TTabSheet;
    lbParametersTitle: TLabel;
    lbParametersDesc: TLabel;
    lbTranslationNote: TLabel;
    lbC: TLabel;
    spC: TSpinEdit;
    lbH: TLabel;
    spH: TSpinEdit;
    lbS: TLabel;
    spS: TSpinEdit;
    lbWPCom: TLabel;
    spWPCom: TSpinEdit;
    lbLZone: TLabel;
    spLZone: TSpinEdit;
    btnAutoFill: TButton;
    bvLeftLine: TBevel;
    tabResults: TTabSheet;
    lbReportTitle: TLabel;
    mmReport: TMemo;
    lbReport: TLabel;
    btnSaveReport: TButton;
    lbReportNote: TLabel;
    imgInfo: TImage;
    btnPrintReport: TButton;
    tabEmpty: TTabSheet;
    SaveDialog: TSaveDialog;
    LogDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    tabFormat: TTabSheet;
    lbFormatTitle: TLabel;
    lbFormatDesc: TLabel;
    rbVhdDisk: TRadioButton;
    lbVhdDisk: TLabel;
    rbImgDisk: TRadioButton;
    lbImgDisk: TLabel;
    cbSparse: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbConnectorChange(Sender: TObject);
    procedure tbCapacityChange(Sender: TObject);
    procedure btnAutoFillClick(Sender: TObject);
    procedure tabResultsShow(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnSaveReportClick(Sender: TObject);
    procedure btnPrintReportClick(Sender: TObject);
    procedure rbVhdDiskClick(Sender: TObject);
  private
    FAutoCreate: boolean;
    FDiskChanged, FFirst: boolean;
    procedure UpdateUI;
  public
    FDiskData: TDiskData;
    function GetIsVHD: boolean; stdcall;
    procedure SetIsVHD(const Value: boolean); stdcall;
    function GetSparse: boolean; stdcall;
    procedure SetSparse(const Value: boolean); stdcall;
    function GetFileName: PChar; stdcall;
    procedure SetFileName(const Value: PChar); stdcall;
    function GetDiskData: TDiskData; stdcall;
    procedure SetDiskData(const Value: TDiskData); stdcall;
    procedure SetConnectorFilter(const Lock: boolean); stdcall;
    function Execute(const AutoCreate: boolean): boolean; stdcall;
    function TryCreate: boolean; stdcall;
    procedure SaveLogFile(const FileName: PChar); stdcall;

    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
    procedure FlipBiDi; stdcall;

    procedure TypeFrom86Box(const Connector, Machine: string);
  end;

var
  WizardHDD: TWizardHDD;

function CreateWizardHDD(const AOwner: TComponent): IWizardHDD; stdcall;

implementation

{$R *.dfm}

uses uCommUtil, uCommText, frmSelectHDD, Printers, frmErrorDialog,
  dmGraphUtil;

resourcestring
  OpenDlgVhdDisk = 'OpenDialog.VhdDisk';
  OpenDlgRawDisk = 'OpenDialog.RawDisk';
  ImFullReport = 'Imaging.FullReport';
  ImLiteReport = 'Imaging.LiteReport';
  ImMinReport = 'Imaging.MinReport';
  ImIsSparse = 'Imaging.IsSparse';
  ECantGetFreeSpace = 'Imaging.ECantGetFreeSpace';
  ECantCreateVhd = 'Imaging.ECantCreateVHD';
  ECantCreateSparse = 'Imaging.ECantCreateSparse';
  ImAskFullAlloc = 'Imaging.AskFullAlloc';

function CreateWizardHDD(const AOwner: TComponent): IWizardHDD; stdcall;
begin
  Result := TWizardHDD.Create(AOwner) as IWizardHDD;
end;

procedure TWizardHDD.btnNextClick(Sender: TObject);
var
  SelectDlg: ISelectHDD;
begin
  with pcPages do begin
    if Sender = btnNext then
      case ActivePageIndex of
        0: begin
             if FFirst then begin
               cbConnectorChange(Self);
               tbCapacity.Position := 1024;
               tbCapacityChange(Self);

               cbSparse.Checked := (FDiskData.szConnector = '') or
                                   (pos('IDE', FDiskData.szConnector) <> 0) or
                                   (pos('SCSI', FDiskData.szConnector) <> 0);

               rbVhdDisk.Checked := cbSparse.Checked;
               rbImgDisk.Checked := not cbSparse.Checked;
               rbVhdDiskClick(rbVhdDisk);

               FFirst := false;
             end;
             ActivePage := tabFormat;
           end;

      2: begin
           if (edFileName.Text = '') or (DirectoryExists(edFileName.Text)) then
             raise Exception.Create(SysErrorMessage(ERROR_PATH_NOT_FOUND));

           if FileExists(edFileName.Text) and (MessageBox(Handle, _P(ImFileExists),
              PChar(Application.Title), MB_YESNO or MB_ICONWARNING) <> mrYes) then exit;

           case cbParamMode.ItemIndex of
             2: ActivePage := tabParameters;
             1: begin
                  SelectDlg := HDSelect as ISelectHDD;
                  Cursor := crHourGlass;
                  try
                    SelectDlg.DiskData := FDiskData;
                    if not FDiskData.dgPhysicalGeometry.IsEmpty then
                      SelectDlg.LocatePhysCHS
                    else if not FDiskData.dgTranslatedGeometry.IsEmpty then
                      SelectDlg.LocateTransCHS;
                    SelectDlg.SetConnectorFilter(not cbSparse.Enabled);
                    if SelectDlg.Execute(false) then begin
                      pcPages.ActivePageIndex := pcPages.ActivePageIndex + 2;
                      FDiskData := SelectDlg.DiskData;
                      FDiskChanged := true;
                    end
                    else
                      exit;
                    SelectDlg := nil;
                    ActivePage := tabResults;
                  finally
                    Cursor := crDefault;
                  end;
                end;
             0: ActivePage := tabCapacity;
           end;
         end;

       3: with FDiskData, dgTranslatedGeometry do begin
            C := spAutoC.Value;
            H := spAutoH.Value;
            S := spAutoS.Value;
            dgPhysicalGeometry.C := 0;
            dgPhysicalGeometry.H := 0;
            dgPhysicalGeometry.S := 0;
            dwWritePreComp := C div 2;
            dwLandZone := C + 1;
            szModel := '';

            case cbConnector.ItemIndex of
              0: szConnector := 'ESDI';
              6: szConnector := 'SCSI';
              else szConnector := 'IDE';
            end;

            FDiskChanged := true;
            ActivePage := tabResults;
          end;

       4: with FDiskData, dgTranslatedGeometry do begin
            C := spC.Value;
            H := spH.Value;
            S := spS.Value;
            dgPhysicalGeometry.C := 0;
            dgPhysicalGeometry.H := 0;
            dgPhysicalGeometry.S := 0;
            dwWritePreComp := spWPCom.Value;
            dwLandZone := spLZone.Value;
            szConnector := '';
            szModel := '';

            FDiskChanged := true;
            ActivePage := tabResults;
          end;

       5: if (not FAutoCreate) or TryCreate then
            ModalResult := mrOK
          else
            exit;

        else
          ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
      end;

    if Sender = btnPrev then
      case ActivePageIndex of
        4, 5: ActivePage := tabBasic;
        else
          ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
      end;

    UpdateUI;

    if ActivePage = tabResults then
      tabResultsShow(tabResults);

    btnPrev.Enabled := ActivePageIndex > 0;
    btnNext.Enabled := ActivePageIndex < PageCount - 1;
  end;
end;

procedure TWizardHDD.btnBrowseClick(Sender: TObject);
begin
  SaveDialog.FileName := ExtractFileName(edFileName.Text);
  SaveDialog.InitialDir := ExtractFilePath(edFileName.Text);
  ForceDirectories(SaveDialog.InitialDir);
  if SaveDialog.Execute then
    edFileName.Text := SaveDialog.FileName;
end;

procedure TWizardHDD.btnAutoFillClick(Sender: TObject);
begin
  spWPCom.Value := spC.Value div 2;
  spLZone.Value := spC.Value + 1;
end;

procedure TWizardHDD.btnSaveReportClick(Sender: TObject);
begin
  LogDialog.FileName := ChangeFileExt(ExtractFileName(edFileName.Text), '.log');
  LogDialog.InitialDir := ExtractFilePath(edFileName.Text);
  ForceDirectories(LogDialog.InitialDir);
  if LogDialog.Execute then
    mmReport.Lines.SaveToFile(LogDialog.FileName);
end;

procedure TWizardHDD.btnPrintReportClick(Sender: TObject);
var
  F: TextFile;
  S: string;
begin
  if PrintDialog.Execute then begin
    AssignPrn(F);
    try
      Rewrite(F);
      for S in mmReport.Lines do
        WriteLn(F, S);
    finally
      CloseFile(F);
    end;
  end;
end;

procedure TWizardHDD.cbConnectorChange(Sender: TObject);
const
  Limits: array [-1..6, 1..3] of integer =
    ((    1,  1,  1),
     (42366, 16, 99),
     ( 1024, 16, 63),
     ( 4096, 16, 63),
     ( 8192, 16, 63),
     (16320, 16, 63),
     (66576, 16, 63),
     ( 2658, 255, 99));
begin
  spAutoC.MaxValue := Limits[cbConnector.ItemIndex, 1];
  spAutoH.MaxValue := Limits[cbConnector.ItemIndex, 2];
  spAutoS.MaxValue := Limits[cbConnector.ItemIndex, 3];
  tbCapacity.Max := Integer(int64(spAutoC.MaxValue) *
    spAutoH.MaxValue * spAutoS.MaxValue div 2048);
  tbCapacity.Frequency := tbCapacity.Max div 100;
end;

function TWizardHDD.Execute(const AutoCreate: boolean): boolean;
begin
  FAutoCreate := AutoCreate;
  Result := ShowModal = mrOK;
end;

procedure TWizardHDD.FlipBiDi;
begin
  BiDiMode := BiDiModes[LocaleIsBiDi];
  FlipChildren(true);
end;

procedure TWizardHDD.FormCreate(Sender: TObject);
var
  Data: TDiskData;
begin
  FillChar(Data, SizeOf(Data), #0);
  HDSelect.SetDiskData(Data);
  HDSelect.SetConnectorFilter(false);
  HDSelect.rbNoFilter.Checked := true;
  HDSelect.FilterChange(HDSelect.rbNoFilter);

  FDiskChanged := false;
  FFirst := true;
  LoadImage('BANNER_HDD', imgBanner, false);

  with IconSet do begin
    Icons32.GetIcon(0, imgWarning.Picture.Icon);
    Icons32.GetIcon(11, imgInfo.Picture.Icon);
  end;
end;

procedure TWizardHDD.FormShow(Sender: TObject);
begin
  Translate;
  if LocaleIsBiDi then
    FlipBiDi;

  pcPages.ActivePageIndex := 0;
  btnPrev.Enabled := false;
  btnNext.Enabled := true;
end;

function TWizardHDD.GetDiskData: TDiskData;
begin
  Result := FDiskData;
end;

function TWizardHDD.GetFileName: PChar;
begin
  Result := PChar(edFileName.Text);
end;

function TWizardHDD.GetIsVHD: boolean;
begin
  Result := rbVhdDisk.Checked;
end;

function TWizardHDD.GetSparse: boolean;
begin
  Result := cbSparse.Checked;
end;

procedure TWizardHDD.GetTranslation(Language: TLanguage);
begin
  Language.GetTranslation('WizardHDD', Self);
end;

procedure TWizardHDD.rbVhdDiskClick(Sender: TObject);
begin
  if rbVhdDisk.Checked then begin
     SaveDialog.Filter := _T(OpenDlgVhdDisk);
     SaveDialog.DefaultExt := '.vhd';
   end
   else begin
     SaveDialog.Filter := _T(OpenDlgRawDisk);
     SaveDialog.DefaultExt := '.img';
   end;

   if (edFileName.Text <> '') and (edFileName.Text <> '\') then
     edFileName.Text := ChangeFileExt(edFileName.Text, SaveDialog.DefaultExt);
end;

procedure TWizardHDD.SaveLogFile(const FileName: PChar);
begin
  tabResultsShow(tabResults);
  mmReport.Lines.SaveToFile(FileName);
end;

procedure TWizardHDD.SetConnectorFilter(const Lock: boolean);
begin
  if Lock and (FDiskData.szConnector = '') then
    exit;

  UpdateUI;
  cbParamMode.Enabled := (cbParamMode.ItemIndex <> 1) or not Lock;
  cbConnector.Enabled := not Lock;
  cbSparse.Enabled := cbParamMode.Enabled;
end;

procedure TWizardHDD.SetDiskData(const Value: TDiskData);
begin
  FDiskData := Value;

  cbSparse.Checked := (FDiskData.szConnector = '') or
                       (pos('IDE', FDiskData.szConnector) <> 0) or
                       (pos('SCSI', FDiskData.szConnector) <> 0);

  SetIsVHD(cbSparse.Checked);
end;

procedure TWizardHDD.SetFileName(const Value: PChar);
begin
  edFileName.Text := Value;
end;

procedure TWizardHDD.SetIsVHD(const Value: boolean);
begin
  rbVhdDisk.Checked := cbSparse.Checked;
  rbImgDisk.Checked := not cbSparse.Checked;
  rbVhdDiskClick(rbVhdDisk);
end;

procedure TWizardHDD.SetSparse(const Value: boolean);
begin
  cbSparse.Checked := Value;
end;

procedure TWizardHDD.tabResultsShow(Sender: TObject);
begin
  mmReport.Clear;
  if (not FDiskData.dgPhysicalGeometry.IsEmpty) and (FDiskData.szModel <> '') then
    with FDiskData do
      mmReport.Text := _T(ImFullReport,
        [edFileName.Text, FileSizeToStr(UInt64(dwNominalSize) * 1000 * 1000, 2, 1000),
         szManufacturer, szModel, dgPhysicalGeometry.C, dgPhysicalGeometry.H,
         dgPhysicalGeometry.S, dgTranslatedGeometry.C, dgTranslatedGeometry.H,
         dgTranslatedGeometry.S, szConnector, dwWritePrecomp, dwLandZone])
  else if FDiskData.szConnector <> '' then
    with FDiskData do
      mmReport.Text := _T(ImLiteReport,
        [edFileName.Text,
         FileSizeToStr(dgTranslatedGeometry.Size, 2, 1000),
         dgTranslatedGeometry.C, dgTranslatedGeometry.H,
         dgTranslatedGeometry.S, szConnector, dwWritePrecomp, dwLandZone])
  else with FDiskData do
      mmReport.Text := _T(ImMinReport,
        [edFileName.Text,
         FileSizeToStr(dgTranslatedGeometry.Size, 2, 1000),
         dgTranslatedGeometry.C, dgTranslatedGeometry.H,
         dgTranslatedGeometry.S, dwWritePrecomp, dwLandZone]);

  if cbSparse.Checked then
    mmReport.Lines.Add(_T(ImIsSparse));
end;

procedure TWizardHDD.tbCapacityChange(Sender: TObject);
begin
  spAutoH.Value := spAutoH.MaxValue;
  spAutoS.Value := spAutoS.MaxValue;
  spAutoC.Value := int64(tbCapacity.Position * 2048 div spAutoH.Value div spAutoS.Value);

  lbCapacitySelected.Caption := IntToStr(Integer(Int64(spAutoC.Value) *
    spAutoH.Value * spAutoS.Value div 2048)) + ' MB';
end;

procedure TWizardHDD.Translate;
begin
  if Assigned(Language) then begin
    Language.Translate('WizardHDD', Self);
    if SaveDialog.DefaultExt = '.vhd' then
      SaveDialog.Filter := _T(OpenDlgVhdDisk)
    else
      SaveDialog.Filter := _T(OpenDlgRawDisk);

    LogDialog.Filter := _T(OpenDlgLogFiles);
  end;
end;

function TWizardHDD.TryCreate: boolean;
var
  FreeAvail,
  TotalSpace: Int64;

  Input: integer;
begin
  Result := false;
  Input := -1;

  if (edFileName.Text = '') or DirectoryExists(edFileName.Text) then begin
    pcPages.ActivePage := tabBasic;
    FocusControl(edFileName);
    raise Exception.Create(SysErrorMessage(ERROR_PATH_NOT_FOUND));
  end;

  ForceDirectories(ExtractFilePath(edFileName.Text));

  if not SysUtils.GetDiskFreeSpaceEx(
    PChar(IncludeTrailingPathDelimiter(ExtractFilePath(edFileName.Text))),
    FreeAvail, TotalSpace, nil) then
      raise Exception.Create(ECantGetFreeSpace);

  with FDiskData.dgTranslatedGeometry do
    if FreeAvail < FDiskData.dgTranslatedGeometry.Size then
      raise Exception.Create(SysErrorMessage(ERROR_DISK_FULL));

  try
    if rbVhdDisk.Checked then begin
      Input := 0;
      Result := CreateVHDImage(edFileName.Text, FDiskData.dgTranslatedGeometry, cbSparse.Checked);
    end
    else if not cbSparse.Checked then begin
      Input := 1;
      Result := CreateDiskImage(edFileName.Text, FDiskData.dgTranslatedGeometry);
    end
    else begin
      Input := 2;
      Result := CreateSparseImage(edFileName.Text, FDiskData.dgTranslatedGeometry);
    end;
  except
    on E: Exception do begin
      TExceptionDialog.ExceptionHandler(Self, E);

      case Input of
        0: if MessageBox(Handle, _P(ECantCreateVhd), PChar(Application.Title),
                MB_YESNO or MB_ICONQUESTION) = mrYes then begin
             rbVhdDisk.Checked := false;
             rbImgDisk.Checked := true;
             rbVhdDiskClick(rbVhdDisk);
             exit(TryCreate);
           end;
        2: if MessageBox(Handle, _P(ECantCreateSparse), PChar(Application.Title),
                MB_YESNO or MB_ICONQUESTION) = mrYes then begin
              Result := CreateDiskImage(edFileName.Text,
                                        FDiskData.dgTranslatedGeometry);
              exit;
           end;
        else
          Result := false;
      end;
    end;
  end;
end;

procedure TWizardHDD.TypeFrom86Box(const Connector, Machine: string);
begin
  if Connector = '' then begin
    StrPLCopy(@FDiskData.szConnector[0], 'MFM', 19);
    MessageBox(Handle, _P('Imaging.ENoSupportedHDD'), PChar(Application.Title), MB_OK or MB_ICONINFORMATION);
  end
  else if (Connector = 'ESDI') and
          (pos('ibmps2', Machine) <> 0) then
    StrPLCopy(@FDiskData.szConnector[0], 'ESDI PS/2', 19)
  else
    StrPLCopy(@FDiskData.szConnector[0], Connector, 19);

  FDiskData.szConnector[19] := #0;
  SetConnectorFilter(false);
end;

procedure TWizardHDD.UpdateUI;
const
  DefCHS: TDiskGeometry = (C: 1024; H: 16; S: 63);
var
  ACHS: TDiskGeometry;
  Temp: boolean;
begin
  if (pos('MFM', UpperCase(FDiskData.szConnector)) <> 0) or
     (pos('RLL', UpperCase(FDiskData.szConnector)) <> 0) or
     (pos('PS/2', UpperCase(FDiskData.szConnector)) <> 0) then
    cbParamMode.ItemIndex := 1
  else if pos('ESDI', UpperCase(FDiskData.szConnector)) <> 0 then
    cbConnector.ItemIndex := 0
  else if pos('SCSI', UpperCase(FDiskData.szConnector)) <> 0 then
    cbConnector.ItemIndex := 6
  else
    cbConnector.ItemIndex := 5;
  cbConnectorChange(Self);

  Temp := (FDiskData.szConnector = '') or
          (pos('IDE', FDiskData.szConnector) <> 0) or
          (pos('SCSI', FDiskData.szConnector) <> 0);
  if not Temp and cbSparse.Checked and FDiskChanged then
    if MessageBox(Handle, _P(ImAskFullAlloc),
       PChar(Application.Title), MB_YESNO or MB_ICONQUESTION) = mrYes then begin
           cbSparse.Checked := Temp;
           tabResultsShow(tabResults);
         end;
  FDiskChanged := false;

  if not FDiskData.dgTranslatedGeometry.IsEmpty then
    ACHS := FDiskData.dgTranslatedGeometry
  else if not FDiskData.dgPhysicalGeometry.IsEmpty then
    ACHS := FDiskData.dgPhysicalGeometry
  else with DefCHS do begin
    ACHS := DefCHS;
    FDiskData.dwWritePreComp := ACHS.C div 2;
    FDiskData.dwLandZone := ACHS.C + 1;
  end;

  with ACHS do begin
    spAutoC.Value := C;
    spAutoH.Value := H;
    spAutoS.Value := S;
    tbCapacity.Position := Integer(Int64(C) * H * S div 2048);
    lbCapacitySelected.Caption := IntToStr(tbCapacity.Position) + ' MB';

    spC.Value := C;
    spH.Value := H;
    spS.Value := S;
  end;

  spWPCom.Value := FDiskData.dwWritePreComp;
  spLZone.Value := FDiskData.dwLandZone;
end;

end.
