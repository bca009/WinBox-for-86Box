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

(*

  ToDo in refactor:
    lehetõség skippelni a templateket
    automatikusan mentsen log fájlt a vhd/img mellé
    kicserélni a felsõ részt (itt és más fájlokban is)

*)

unit frmWizardVM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Vcl.Samples.Spin, ComCtrls, ExtCtrls, uBaseProfile, uVMSample,
  frmSelectHDD, frmWizardHDD, ShellAPI, IniFiles, Zip, uLang, Registry,
  uImaging;

type
  IWizardVM = interface
    ['{1AD7EC11-8D44-4A44-8D73-13C29AA4A33C}']
    function GetProfileID: PChar; stdcall;
    function GetWorkingDirectory: PChar; stdcall;
    procedure SetWorkingDirectory(const Value: PChar); stdcall;
    function GetFriendlyName: PChar; stdcall;
    function GetDiskData: TDiskData; stdcall;
    function GetOpenSettings: boolean; stdcall;
    procedure SetFriendlyName(const Value: PChar); stdcall;

    procedure RecreateProfileID; stdcall;

    function Execute(const AutoCreate: boolean): boolean; stdcall;
    //function TryCreate: boolean; stdcall;

    property DiskData: TDiskData read GetDiskData;
    property WorkingDirectory: PChar read GetWorkingDirectory write SetWorkingDirectory;
    property ProfileID: PChar read GetProfileID;
    property FriendlyName: PChar read GetFriendlyName write SetFriendlyName;
    property OpenSettings: boolean read GetOpenSettings;
  end;

  TWizardVM = class(TForm, IWizardVM, ILanguageSupport)
    bvBottom: TBevel;
    btnNext: TButton;
    btnPrev: TButton;
    imgBanner: TImage;
    pcPages: TPageControl;
    tabWelcome: TTabSheet;
    lbWelcome: TLabel;
    lbGreetings: TLabel;
    tabTemplates: TTabSheet;
    lbTemplateTitle: TLabel;
    lbTemplateDesc: TLabel;
    tabFinish: TTabSheet;
    lbFinishTitle: TLabel;
    lbFinishDesc: TLabel;
    tabEmpty: TTabSheet;
    lbManufacturerDesc: TLabel;
    lbManufacturer: TListBox;
    lbModel: TListBox;
    lbSupportedOSDesc: TLabel;
    lbSupportedOS: TLabel;
    tabOptions: TTabSheet;
    lbOptionsTitle: TLabel;
    lbOptionsDesc: TLabel;
    lbOptionsNote: TLabel;
    lbOption1: TLabel;
    cbOption1: TComboBox;
    cbOption2: TComboBox;
    cbOption3: TComboBox;
    cbOption4: TComboBox;
    lbOption2: TLabel;
    lbOption3: TLabel;
    lbOption4: TLabel;
    tabStorage: TTabSheet;
    lbStorageTitle: TLabel;
    lbStorageDesc: TLabel;
    cbHDD: TCheckBox;
    lbType1: TLabel;
    lbGeometry: TLabel;
    lbHDD: TLabel;
    lbCHS: TLabel;
    cbCDROM: TCheckBox;
    lbType2: TLabel;
    lbCDROM: TLabel;
    imgWarning: TImage;
    lbStorageNote: TLabel;
    btnHDD: TButton;
    lbNoteCDROMDesc: TLabel;
    lbNoteCDROM: TLabel;
    cbOpenSettings: TCheckBox;
    tabBasic: TTabSheet;
    lbBasicInfo: TLabel;
    lbName: TLabel;
    edName: TEdit;
    lbNameDesc: TLabel;
    lbWorkingDirDesc: TLabel;
    lbWorkingDir: TLabel;
    edPath: TEdit;
    btnBrowse: TButton;
    btnOpenWorkingDir: TButton;
    lbNoTemplate: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbManufacturerClick(Sender: TObject);
    procedure lbModelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnHDDClick(Sender: TObject);
    procedure cbHDDClick(Sender: TObject);
    procedure btnOpenWorkingDirClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure cbOption1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbNoTemplateClick(Sender: TObject);
    procedure tabTemplatesShow(Sender: TObject);
  private
    FAutoCreate: boolean;
    ADiskData: TDiskData;
    ProfileID: string;
  protected
  public
    Samples: TVMSampleFilter;
    DiskTool: IWizardHDD;
    function GetProfileID: PChar; stdcall;
    function GetWorkingDirectory: PChar; stdcall;
    function GetFriendlyName: PChar; stdcall;
    function GetDiskData: TDiskData; stdcall;
    function GetOpenSettings: boolean; stdcall;
    procedure SetWorkingDirectory(const Value: PChar); stdcall;

    function Execute(const AutoCreate: boolean): boolean; stdcall;
    procedure RecreateProfileID; stdcall;
    function TryCreate: boolean; stdcall;
    function GetGeometry: TDiskGeometry;
    procedure UpdateCHS;

    procedure FixItemIndex(Control: TCustomListControl);
    procedure SetFriendlyName(const Value: PChar); stdcall;

    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
  end;

var
  WizardVM: TWizardVM;

implementation

uses uCommUtil, uCommText, uConfigMgr, frmMainForm;

resourcestring
  WizSelectWorkDir = 'WizardVM.SelectWorkDir';

const
  Extensions: array [boolean] of string = ('.img', '.vhd');

{$R *.dfm}

{ TWizardVM }

procedure TWizardVM.btnNextClick(Sender: TObject);
begin
  with pcPages do begin
    if Sender = btnNext then
      case ActivePageIndex of
        1: begin
             if edPath.Text = '' then begin
               FocusControl(edPath);
               raise Exception.Create(SysErrorMessage(ERROR_INVALID_PARAMETER));
             end;

             if (edPath.Text = '') or (edPath.Text = '\') then begin
               FocusControl(edPath);
               raise Exception.Create(SysErrorMessage(ERROR_PATH_NOT_FOUND));
             end;

             edPath.Text := IncludeTrailingPathDelimiter(edPath.Text);
             ActivePage := tabTemplates;
           end;
        2: begin
             if lbModel.ItemIndex = -1 then begin
              FocusControl(lbModel);
              raise Exception.Create(SysErrorMessage(ERROR_INVALID_PARAMETER));
             end;

             with lbModel.Items.Objects[lbModel.ItemIndex] as TVMSample do begin
               lbOption1.Caption := GetOptionName(0);
               lbOption2.Caption := GetOptionName(1);
               lbOption3.Caption := GetOptionName(2);
               lbOption4.Caption := GetOptionName(3);
               GetOptions(0, cbOption1.Items);
               GetOptions(1, cbOption2.Items);
               GetOptions(2, cbOption3.Items);
               GetOptions(3, cbOption4.Items);
               FixItemIndex(cbOption1);
               FixItemIndex(cbOption2);
               FixItemIndex(cbOption3);
               FixItemIndex(cbOption4);
             end;

             ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
             if (not (cbOption1.Enabled or cbOption2.Enabled
                 or cbOption3.Enabled or cbOption4.Enabled)) then begin
                   btnNextClick(Sender);
                   exit;
             end;
           end;
       3: with lbModel.Items.Objects[lbModel.ItemIndex] as TVMSample do begin
            Cursor := crHourGlass;
            btnNext.Enabled := false;
            Application.ProcessMessages;
            try
              ADiskData := DiskDataHDD;

              cbHDD.Enabled := HasDefHDD;
              cbHDD.Checked := cbHDD.Enabled and OptionHDD;
              btnHDD.Enabled := cbHDD.Checked;
              if cbHDD.Enabled then begin
                  with HDSelect as ISelectHDD do begin
                     DiskData := ADiskData;
                     LocatePhysCHS;
                     SetConnectorFilter(false);
                     SetCHSFilter(true);
                     if Execute(true) then
                       ADiskData := DiskData;
                  end;

                DiskTool.DiskData := ADiskData;
                DiskTool.FileName := PChar(NextImageName(edPath.Text) + Extensions[DiskTool.GetIsVHD]);
                DiskTool.SetConnectorFilter(true);
              end;

              UpdateCHS;

              lbCDROM.Caption := DescOfCDROM;
              lbNoteCDROM.Caption := NoteForCDROM;

              cbCDROM.Enabled := HasDefCDROM;
              cbCDROM.Checked := cbCDROM.Enabled and OptionCDROM;

              ActivePage := tabStorage;
            finally
              Cursor := crDefault;
            end;
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
        4: begin
             ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
             if (not (cbOption1.Enabled or cbOption2.Enabled
                 or cbOption3.Enabled or cbOption4.Enabled)) then begin
                   btnNextClick(Sender);
                   exit;
             end;
           end;
        5: if lbModel.ItemIndex = -1 then
             ActivePage := tabTemplates
           else
             ActivePage := tabStorage;
        else
          ActivePageIndex := ActivePageIndex + (Sender as TComponent).Tag;
      end;

    btnPrev.Enabled := ActivePageIndex > 0;
    btnNext.Enabled := ActivePageIndex < PageCount - 1;
  end;
end;

procedure TWizardVM.btnBrowseClick(Sender: TObject);
var
  Directory: string;
begin
  SysUtils.ForceDirectories(edPath.Text);
  Directory := ExcludeTrailingPathDelimiter(edPath.Text);
  if SelectDirectory(_T(WizSelectWorkDir), '', Directory, Self) then
    edPath.Text := IncludeTrailingPathDelimiter(Directory);
end;

procedure TWizardVM.btnOpenWorkingDirClick(Sender: TObject);
begin
  SysUtils.ForceDirectories(edPath.Text);
  ShellExecute(Handle, 'open', PChar(ExcludeTrailingPathDelimiter(edPath.Text)),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TWizardVM.cbHDDClick(Sender: TObject);
begin
  btnHDD.Enabled := cbHDD.Checked;
end;

procedure TWizardVM.cbOption1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with Control as TComboBox do begin
    Canvas.TextRect(Rect, Rect.Left, Rect.Top, Items.ValueFromIndex[Index]);
  end;
end;

procedure TWizardVM.btnHDDClick(Sender: TObject);
begin
  if lbModel.ItemIndex <> -1 then
    with lbModel.Items.Objects[lbModel.ItemIndex] as TVMSample do begin
      if DiskTool.Execute(false) then begin
        ADiskData := DiskTool.DiskData;
        UpdateCHS;
      end
      else if String(DiskTool.FileName) = '' then
        DiskTool.FileName := PChar(NextImageName(edPath.Text) + Extensions[DiskTool.GetIsVHD]);
    end;
end;

function TWizardVM.Execute(const AutoCreate: boolean): boolean;
begin
  FAutoCreate := AutoCreate;
  Result := ShowModal = mrOK;
end;

procedure TWizardVM.FixItemIndex(Control: TCustomListControl);
begin
  if Control.GetCount > 0 then begin
    Control.ItemIndex := 0;
    Control.Enabled := true;
  end
  else begin
    Control.ItemIndex := -1;
    Control.Enabled := false;
  end;
end;

procedure TWizardVM.FormCreate(Sender: TObject);
begin
  LoadImage('BANNER_NEW', imgBanner);
  WinBoxMain.Icons32.GetIcon(0, imgWarning.Picture.Icon);

  Samples := TVMSampleFilter.Create(true);
  DiskTool := CreateWizardHDD(Self);

  RecreateProfileID;
end;

procedure TWizardVM.FormDestroy(Sender: TObject);
begin
  Samples.Free;
end;

procedure TWizardVM.FormShow(Sender: TObject);
begin
  Translate;

  pcPages.ActivePageIndex := 0;
  Samples.Clear;
  Samples.Load(Templates);
  Samples.Load(Config.CustomTemplates);
  Samples.GetManufacturers(lbManufacturer.Items);

  FixItemIndex(lbManufacturer);
  lbManufacturerClick(Self);
end;

function TWizardVM.GetDiskData: TDiskData;
begin
  Result := ADiskData;
end;

function TWizardVM.GetFriendlyName: PChar;
begin
  Result := PChar(edName.Text);
end;

function TWizardVM.GetGeometry: TDiskGeometry;
begin
  if not ADiskData.dgPhysicalGeometry.IsEmpty then
    Result := ADiskData.dgPhysicalGeometry
  else
    Result := ADiskData.dgTranslatedGeometry;
end;

function TWizardVM.GetOpenSettings: boolean;
begin
  Result := cbOpenSettings.Checked;
end;

function TWizardVM.GetProfileID: PChar;
begin
  Result := PChar(ProfileID);
end;

procedure TWizardVM.GetTranslation(Language: TLanguage);
begin
  if Assigned(Language) then
    Language.GetTranslation('WizardVM', Self);
end;

function TWizardVM.GetWorkingDirectory: PChar;
begin
  Result := PChar(edPath.Text);
end;

procedure TWizardVM.lbManufacturerClick(Sender: TObject);
begin
  if lbManufacturer.ItemIndex >= 0 then
    Samples.GetByManufacturers(
      lbManufacturer.Items[lbManufacturer.ItemIndex], lbModel.Items);

  FixItemIndex(lbModel);
  lbModelClick(Self);
end;

procedure TWizardVM.lbModelClick(Sender: TObject);
begin
  if lbModel.ItemIndex <> -1 then
    with lbModel.Items.Objects[lbModel.ItemIndex] as TVMSample do
      lbSupportedOS.Caption := SupportedOS;
end;

procedure TWizardVM.lbNoTemplateClick(Sender: TObject);
begin
  lbModel.ItemIndex := -1;
  cbOpenSettings.Checked := true;
  pcPages.ActivePage := tabFinish;
end;

procedure TWizardVM.RecreateProfileID;
var
  G: TGUID;
begin
  CreateGUID(G);
  ProfileID := GUIDToString(G);
  edPath.Text := Config.MachineRoot + ProfileID + PathDelim;
  edName.Text := ProfileID;
end;

procedure TWizardVM.SetFriendlyName(const Value: PChar);
begin
  edName.Text := Value;
end;

procedure TWizardVM.SetWorkingDirectory(const Value: PChar);
begin
  if (Value = '') or (Value = '\') then
    exit
  else
    edPath.Text := IncludeTrailingPathDelimiter(Value);
end;

procedure TWizardVM.tabTemplatesShow(Sender: TObject);
begin
  if (lbModel.Count > 0) and (lbModel.ItemIndex = -1) then begin
    lbModel.ItemIndex := 0;
    lbModelClick(lbModel);
  end;
end;

procedure TWizardVM.Translate;
begin
  if Assigned(Language) then
    Language.Translate('WizardVM', Self);
end;

function TWizardVM.TryCreate: boolean;
var
  Sample: TVMSample;
  Config: TCustomIniFile;

  CustomSample: boolean;
  I: integer;
begin
  //Result := false;

  CustomSample := lbModel.ItemIndex = -1;
  if CustomSample then begin
    Sample := TVMSample.Create;
    Sample.ConfigFile := '86Box.cfg';
  end
  else
    Sample := lbModel.Items.Objects[lbModel.ItemIndex] as TVMSample;

  try
    with TZipFile.Create do
      try
        SysUtils.ForceDirectories(edPath.Text);

        if not CustomSample then begin
          ExtractZipFile(Sample.FileName, edPath.Text);
          DeleteWithShell(edPath.Text + 'winbox.*', false);
        end;

        Config := TryLoadIni(edPath.Text + Sample.ConfigFile);
        try
          if not CustomSample then begin
            if cbOption1.ItemIndex <> -1 then
              Sample.AddOption(0, cbOption1.Items.Names[cbOption1.ItemIndex], Config);
            if cbOption2.ItemIndex <> -1 then
              Sample.AddOption(1, cbOption2.Items.Names[cbOption2.ItemIndex], Config);
            if cbOption3.ItemIndex <> -1 then
              Sample.AddOption(2, cbOption3.Items.Names[cbOption3.ItemIndex], Config);
            if cbOption4.ItemIndex <> -1 then
              Sample.AddOption(3, cbOption4.Items.Names[cbOption4.ItemIndex], Config);

            if cbCDROM.Checked then
              Sample.AddCDROM(Config);

            if cbHDD.Checked then
              with GetGeometry do begin
                Config.WriteString('Hard disks', 'hdd_01_parameters',
                  format('%d, %d, %d, 0, %s', [S, H, C, LowerCase(Sample.ConnectorHDD)]));
                Config.WriteString('Hard disks', 'hdd_01_fn',
                  Copy(CompactFileNameTo(
                       DiskTool.FileName,
                       ExcludeTrailingPathDelimiter(edPath.Text)), 3, MaxInt));
                  if LowerCase(Sample.ConnectorHDD) = 'scsi' then
                    Config.WriteString('Hard disks', 'hdd_01_scsi_id', Sample.SlotOfHDD)
                  else
                    Config.WriteString('Hard disks',
                      format('hdd_01_%s_channel', [LowerCase(Sample.ConnectorHDD)]),
                      Sample.SlotOfHDD);
                  DiskTool.TryCreate;
                  DiskTool.SaveLogFile(PChar(ChangeFileExt(DiskTool.FileName, '.log')));
               end;
           end;

          Config.WriteString('WinBox', 'window_fixed_res',
            Sample.GetCustomKey('General', 'WindowSize', '960x720'));

          with uConfigMgr.Config do
            if DisplayMode <> 3 then begin
              for I := 0 to DisplayValues.Count - 1 do
                Config.WriteString('General',
                  DisplayValues.Names[I], DisplayValues.ValueFromIndex[I]);

              Config.WriteString('General', 'window_fixed_res',
                Sample.GetCustomKey('General', 'WindowSize', '960x720'));
            end;

          with TProfile.Create(ProfileID, false) do
            try
              WorkingDirectory := edPath.Text;
              FriendlyName := edName.Text;
              Save;
            finally
              Free;
            end;

          Result := true;
        finally
          Config.UpdateFile;
          Config.Free;
        end;
      finally
        Free;
      end;
  finally
    if CustomSample then
      FreeAndNil(Sample);
  end;
end;

procedure TWizardVM.UpdateCHS;
var
  Geometry: TDiskGeometry;
  HDType: string;
begin
  if lbModel.ItemIndex <> -1 then
    with lbModel.Items.Objects[lbModel.ItemIndex] as TVMSample do
      HDType := ConnectorHDD
  else
    HDType := '';

  Geometry := GetGeometry;
  if cbHDD.Enabled then begin
    lbHDD.Caption := format('%s %s', [FileSizeToStr(Geometry.Size, 2, 1000),
      HDType]);
    with Geometry do
      lbCHS.Caption := format('C: %d H: %d S: %d', [C, H, S]);
  end
  else begin
    lbHDD.Caption := Language.ReadString('Templates', 'Text.None', 'Text.None');
    lbCHS.Caption := lbHDD.Caption;
  end;
end;

end.
