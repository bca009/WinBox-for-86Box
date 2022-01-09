object AboutDlg: TAboutDlg
  Left = 0
  Top = 0
  ActiveControl = btnOK
  BiDiMode = bdLeftToRight
  BorderStyle = bsDialog
  Caption = 'N'#233'vjegy'
  ClientHeight = 357
  ClientWidth = 358
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentBiDiMode = False
  Position = poMainFormCenter
  StyleElements = [seFont, seBorder]
  OnCreate = FormCreate
  PixelsPerInch = 96
  DesignSize = (
    358
    357)
  TextHeight = 13
  object imgSplash: TImage
    Left = 0
    Top = 0
    Width = 358
    Height = 156
    Align = alTop
    Stretch = True
    ExplicitTop = 8
  end
  object lbTitle: TLabel
    Left = 0
    Top = 145
    Width = 358
    Height = 19
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    BiDiMode = bdLeftToRight
    Caption = 'WinBox for 86Box'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
  end
  object lbVersion: TLabel
    Left = 24
    Top = 176
    Width = 73
    Height = 20
    AutoSize = False
    Caption = 'Verzi'#243':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDeveloper: TLabel
    Left = 24
    Top = 195
    Width = 73
    Height = 20
    AutoSize = False
    Caption = '&K'#233'sz'#237'tette:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbDeveloperInfo: TLabel
    Left = 94
    Top = 195
    Width = 191
    Height = 20
    AutoSize = False
    Caption = 'Laci b'#225#39', 2020-2021'
  end
  object lbTranslator: TLabel
    Left = 24
    Top = 214
    Width = 73
    Height = 20
    AutoSize = False
    Caption = '&Ford'#237'totta:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbTranslatorInfo: TLabel
    Left = 94
    Top = 214
    Width = 191
    Height = 20
    AutoSize = False
    Caption = 'Ez a program alapnyelve.'
  end
  object lbWebApplication: TLabel
    Left = 291
    Top = 176
    Width = 60
    Height = 20
    Cursor = crHandPoint
    Hint = 'https://github.com/86Box/WinBox-for-86Box'
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Weboldal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = lbWebApplicationClick
  end
  object lbWebDeveloper: TLabel
    Left = 291
    Top = 195
    Width = 60
    Height = 20
    Cursor = crHandPoint
    Hint = 'http://users.atw.hu/laciba'
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Weboldal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = lbWebApplicationClick
  end
  object lbConnProjects: TLabel
    Left = 24
    Top = 240
    Width = 135
    Height = 20
    AutoSize = False
    Caption = 'Kapcsol'#243'd'#243' projektek:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb86Box: TLabel
    Left = 157
    Top = 240
    Width = 128
    Height = 20
    AutoSize = False
    Caption = '86Box, x86 emul'#225'tor'
  end
  object lbUsedProjects: TLabel
    Left = 24
    Top = 259
    Width = 135
    Height = 20
    AutoSize = False
    Caption = 'Felhaszn'#225'lt projektek:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbWeb86Box: TLabel
    Left = 291
    Top = 240
    Width = 60
    Height = 20
    Cursor = crHandPoint
    Hint = 'https://github.com/86Box/86Box'
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Weboldal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = lbWebApplicationClick
  end
  object lbJCL: TLabel
    Left = 157
    Top = 259
    Width = 128
    Height = 20
    AutoSize = False
    Caption = 'JEDI Code Library (JCL)'
  end
  object lbWebJCL: TLabel
    Left = 291
    Top = 259
    Width = 60
    Height = 20
    Cursor = crHandPoint
    Hint = 'https://github.com/project-jedi/jcl'
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Weboldal'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHotLight
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    StyleElements = [seClient, seBorder]
    OnClick = lbWebApplicationClick
  end
  object lbLicensing: TLabel
    Left = 0
    Top = 287
    Width = 358
    Height = 20
    Alignment = taCenter
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = 'A program szabad szoftver GNU GPL v3 alatt.'
  end
  object edVersion: TEdit
    Left = 94
    Top = 176
    Width = 191
    Height = 20
    AutoSize = False
    BorderStyle = bsNone
    ReadOnly = True
    TabOrder = 0
    Text = 'edVersion'
    StyleElements = [seBorder]
  end
  object btnOK: TButton
    Left = 260
    Top = 313
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 1
  end
end
