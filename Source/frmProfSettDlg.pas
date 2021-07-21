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

unit frmProfSettDlg;

interface

uses
  UITypes, Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uBaseProfile, uLang, Menus,
  ShellAPI, ExtDlgs;

type
  TBevel = class(ExtCtrls.TBevel)
  public
    property OnClick;
  end;

  TProfSettDlg = class(TForm, ILanguageSupport)
    btnCancel: TButton;
    btnOK: TButton;
    od86Box: TOpenDialog;
    pcPages: TPageControl;
    tabGeneral: TTabSheet;
    tabEmulator: TTabSheet;
    grpEmulator: TGroupBox;
    imgEmulator: TImage;
    lbDefEmulator: TLabel;
    grpBasicInfo: TGroupBox;
    bvIcon: TBevel;
    imgIcon: TImage;
    lbFriendlyName: TLabel;
    edFriendlyName: TEdit;
    lbDescription: TLabel;
    mmDescription: TMemo;
    btnDelete: TButton;
    lbInternalID: TLabel;
    grpInformations: TGroupBox;
    lbDescOfID: TLabel;
    lbDescOfWkDir: TLabel;
    lbWorkingDirectory: TLabel;
    btnOpenWorkDir: TButton;
    cbEraseProt: TCheckBox;
    btnOpenConfig: TButton;
    grpAppearance: TGroupBox;
    rcColor: TShape;
    cbFullscreen: TCheckBox;
    lbColor: TLabel;
    bvColor: TBevel;
    btnResetColor: TButton;
    cdColors: TColorDialog;
    lbOptionalParams: TLabel;
    mmOptionalParams: TMemo;
    lbVersion: TLabel;
    lb86BoxPath: TLabel;
    ed86Box: TEdit;
    btn86Box: TButton;
    btnOpen86Box: TButton;
    btnDef86Box: TButton;
    grpDebug: TGroupBox;
    lbLogging: TLabel;
    cbLogging: TComboBox;
    lbDebugMode: TLabel;
    cbDebugMode: TComboBox;
    cbCrashDump: TComboBox;
    lbCrashDump: TLabel;
    lbDebug: TLabel;
    imgDebug: TImage;
    opdIcon: TOpenPictureDialog;
    procedure ed86BoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Reload(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ActionClick(Sender: TObject);
    procedure OpenImgClick(Sender: TObject);
  private
    { Private declarations }
  public
    Profile: TProfile;
    IconChanged: boolean;
    LangName: string;
    procedure GetTranslation(Language: TLanguage); stdcall;
    procedure Translate; stdcall;
  end;

var
  ProfSettDlg: TProfSettDlg;

implementation

{$R *.dfm}

uses uCommUtil, uCommText, frmMainForm;

resourcestring
  AskVmIconDel = '.AskVmIconDel';

procedure TProfSettDlg.ActionClick(Sender: TObject);
var
  Path: string;
begin
  case (Sender as TComponent).Tag of
    1: begin
         od86Box.FileName := ed86Box.Text;
         if od86Box.Execute then
           ed86Box.Text := od86Box.FileName;
       end;
    2: ed86Box.Text := DefProfile.ExecutablePath;
    3: begin
         Path := ExtractFileDir(ed86Box.Text);
         SysUtils.ForceDirectories(Path);
         ShellExecute(Handle, 'open', PChar(Path), nil, nil, SW_SHOWNORMAL);
       end;
    4: if cdColors.Execute then
         with rcColor.Brush do begin
           Color := cdColors.Color;
           Style := bsSolid;
         end;
    5: rcColor.Brush.Style := bsClear;
    7: if not cbEraseProt.Checked or (MessageBox(Handle, _P(LangName + AskVmIconDel),
            PChar(Application.Title), MB_ICONWARNING or MB_YESNO) = mrYes) then begin
         Profile.DefaultIcon;
         IconChanged := true;

         DisplayWIC(Profile.Icon, imgIcon);
         bvIcon.Invalidate;
       end;
    8: ShellExecute(Handle, 'open', 'notepad.exe',
         PChar('"' + Profile.WorkingDirectory + VmConfigFile + '"'), nil, SW_SHOWNORMAL);
    9: ShellExecute(Handle, 'open', PChar(Profile.WorkingDirectory), nil, nil, SW_SHOWNORMAL);
    else raise Exception.Create('Invalid action tag.');
  end;
end;

procedure TProfSettDlg.btnOKClick(Sender: TObject);
begin
  if (edFriendlyName.Text = '') then begin
    pcPages.ActivePage := tabGeneral;
    FocusControl(edFriendlyName);
    raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA));
  end;

  with ed86Box do
    if (Text = '') or (Text = '\') or (Text = '/') then begin
      if Assigned(Parent) and Assigned(Parent.Parent)
         and (Parent.Parent is TTabSheet) then begin
           pcPages.ActivePage := Parent.Parent as TTabSheet;
           FocusControl(ed86Box);
         end;
      raise Exception.Create(SysErrorMessage(ERROR_INVALID_DATA));
    end;

  if Assigned(Profile) then
    with Profile do begin
      Description := mmDescription.Text;
      FriendlyName := edFriendlyName.Text;
      ExecutablePath := ed86Box.Text;
      OptionalParams := mmOptionalParams.Text;
      EraseProt := cbEraseProt.Checked;
      Fullscreen := cbFullscreen.Checked;
      LoggingMode := cbLogging.ItemIndex;
      DebugMode := cbDebugMode.ItemIndex;
      CrashDump := cbCrashDump.ItemIndex;

      case rcColor.Brush.Style of
        bsClear: Color := clNone;
        bsSolid: Color := rcColor.Brush.Color;
      end;

      if IconChanged then
        DeleteWithShell(WorkingDirectory + VmIconFile, true);

      if HasIcon then
        Icon.SaveToFile(WorkingDirectory + VmIconFile);

      Save;
      Reload;
    end;

  ModalResult := mrOK;
end;

procedure TProfSettDlg.ed86BoxChange(Sender: TObject);
begin
  if FileExists(ed86Box.Text) then
    lbVersion.Caption := format(_T(StrVersion) ,[GetFileVer(ed86Box.Text)])
  else
    lbVersion.Caption := format(_T(StrVersion) ,[_T(StrUnknown)])
end;

procedure TProfSettDlg.FormCreate(Sender: TObject);
begin
  Profile := nil;
  IconChanged := false;

  bvColor.OnClick := ActionClick;

  pcPages.ActivePageIndex := 0;
  LangName := Copy(ClassName, 2, MaxInt);

  WinBoxMain.Icons32.GetIcon(31, imgEmulator.Picture.Icon);
  WinBoxMain.Icons32.GetIcon(33, imgDebug.Picture.Icon);
  Translate;
end;

procedure TProfSettDlg.Reload(Sender: TObject);
const
  MaxLen = 40;
var
  CompactPath: array [0..MaxLen - 1] of char;
begin
  if Assigned(Profile) then
    with Profile do begin
      edFriendlyName.Text := FriendlyName;
      ed86Box.Text := ExecutablePath;
      lbInternalID.Caption := ProfileID;
      mmDescription.Text := Description;

      DisplayWIC(Icon, imgIcon);
      bvIcon.Invalidate;

      FillChar(CompactPath[0], MaxLen * SizeOf(Char), #0);
      if PathCompactPathExW(@CompactPath[0], PChar(WorkingDirectory), MaxLen, 0) then
        lbWorkingDirectory.Caption := String(CompactPath)
      else
        lbWorkingDirectory.Caption := WorkingDirectory;

      mmOptionalParams.Text := OptionalParams;
      cbEraseProt.Checked := EraseProt;
      cbFullscreen.Checked := Fullscreen;
      cbLogging.ItemIndex := LoggingMode;
      cbDebugMode.ItemIndex := DebugMode;
      cbCrashDump.ItemIndex := CrashDump;

      if Color = clNone then
        rcColor.Brush.Style := bsClear
      else begin
        rcColor.Brush.Color := Color;
        rcColor.Brush.Style := bsSolid;
      end;
    end;
end;

procedure TProfSettDlg.OpenImgClick(Sender: TObject);
var
  Image: TWICImage;
begin
  if cbEraseProt.Checked and (MessageBox(Handle, _P(LangName + AskVmIconDel),
      PChar(Application.Title), MB_ICONWARNING or MB_YESNO) <> mrYes) then
        exit;

  if opdIcon.Execute then begin
    Image := TWICImage.Create;

    Image.LoadFromFile(opdIcon.FileName);
    ScaleWIC(Image, 512, 512);
    Image.ImageFormat := wifPng;

    Profile.Icon.Free;
    Profile.Icon := TWICImage.Create;
    Profile.Icon.Assign(Image);
    Profile.HasIcon := true;

    Image.Free;
    IconChanged := true;

    DisplayWIC(Profile.Icon, imgIcon);
    bvIcon.Invalidate;
  end;
end;

procedure TProfSettDlg.GetTranslation(Language: TLanguage);
begin
  with Language do begin
    GetTranslation(LangName, Self);
    GetTranslation(OpenDlg86Box, od86Box.Filter);
    GetTranslation(OpenDlgWICPic, opdIcon.Filter);
  end;
end;

procedure TProfSettDlg.Translate;
begin
  with Language do begin
    Translate(LangName, Self);

    od86Box.Filter := _T(OpenDlg86Box);
    opdIcon.Filter := _T(OpenDlgWICPic);

    Caption := ReadString(LangName, LangName, Caption);
  end;
end;

end.
