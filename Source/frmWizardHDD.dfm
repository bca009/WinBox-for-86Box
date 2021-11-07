object WizardHDD: TWizardHDD
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #218'j virtu'#225'lis merevlemez l'#233'trehoz'#225'sa'
  ClientHeight = 309
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    479
    309)
  TextHeight = 13
  object imgBanner: TImage
    AlignWithMargins = True
    Left = 1
    Top = 2
    Width = 140
    Height = 260
    Margins.Left = 1
    Margins.Top = 2
    Margins.Right = 1
    Margins.Bottom = 1
    Align = alLeft
    Center = True
    Proportional = True
    Stretch = True
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitHeight = 263
  end
  object bvBottom: TBevel
    Left = 0
    Top = 263
    Width = 479
    Height = 46
    Align = alBottom
    Shape = bsSpacer
    ExplicitTop = 280
    ExplicitWidth = 496
  end
  object pcPages: TPageControl
    Left = 142
    Top = 0
    Width = 337
    Height = 263
    ActivePage = tabResults
    Align = alClient
    TabOrder = 0
    object tabWelcome: TTabSheet
      Caption = 'tabWelcome'
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbWelcome: TLabel
        Left = 16
        Top = 16
        Width = 250
        Height = 13
        Caption = #218'j virtu'#225'lis merevlemez - '#252'dv'#246'zli a var'#225'zsl'#243'!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbGreetings: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 202
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Caption = 
          'Ez a var'#225'zsl'#243' v'#233'gigvezeti '#214'nt egy '#250'j, az emul'#225'tor szoftverekhez ' +
          'alkalmazhat'#243' nyers virtu'#225'lis merevlemez k'#233'pf'#225'jl l'#233'trehoz'#225's'#225'nak f' +
          'olyamat'#225'n.'#13#10#13#10'A megfelel'#337' kapacit'#225's kiv'#225'laszt'#225'sakor gondoskodjon' +
          ' arr'#243'l, hogy a kijel'#246'lt helyen rendelkezik-e a megadott m'#233'retnek' +
          ' megfelel'#337' mennyis'#233'g'#369' lemezter'#252'lettel.'#13#10#13#10'A l'#233'p'#233'sek megkezd'#233's'#233'he' +
          'z kattintson a Tov'#225'bb gombra.'
        WordWrap = True
        ExplicitHeight = 184
      end
    end
    object tabFormat: TTabSheet
      Caption = 'tabFormat'
      ImageIndex = 6
      TabVisible = False
      object lbFormatTitle: TLabel
        Left = 16
        Top = 16
        Width = 173
        Height = 13
        Caption = 'K'#233'pf'#225'jl form'#225'tum kiv'#225'laszt'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbFormatDesc: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 41
        AutoSize = False
        Caption = 
          'Ezen a f'#252'l'#246'n eld'#246'ntheti hogy a WinBox milyen form'#225'tumot haszn'#225'lj' +
          'on az '#250'j virtu'#225'lis merevlemez l'#233'trehoz'#225'sakor.'
        WordWrap = True
      end
      object lbVhdDisk: TLabel
        Left = 28
        Top = 111
        Width = 285
        Height = 42
        AutoSize = False
        Caption = 
          'Ez a form'#225'tum k'#246'zvetlen'#252'l felcsatolhat'#243' meghajt'#243'k'#233'nt, '#233's lehet'#337's' +
          #233'get ad linkelt kl'#243'nok k'#233'sz'#237't'#233's'#233're is. '
        WordWrap = True
      end
      object lbImgDisk: TLabel
        Left = 28
        Top = 171
        Width = 285
        Height = 54
        AutoSize = False
        Caption = 
          'Ezt a form'#225'tumot a legt'#246'bb emul'#225'tor t'#225'mogatja, viszont ImDisk, W' +
          'inImage vagy m'#225's szoftverrel m'#243'dos'#237'that'#243'. '
        WordWrap = True
      end
      object rbVhdDisk: TRadioButton
        Left = 16
        Top = 88
        Width = 297
        Height = 17
        Caption = 'Virtu'#225'lis merevlemez (*.vhd)'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        TabStop = True
        OnClick = rbVhdDiskClick
      end
      object rbImgDisk: TRadioButton
        Left = 16
        Top = 148
        Width = 289
        Height = 17
        Caption = 'Nyers merevlemez k'#233'pf'#225'jl (*.img)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = rbVhdDiskClick
      end
      object cbSparse: TCheckBox
        Left = 16
        Top = 216
        Width = 310
        Height = 20
        Caption = '&Dinamikusan b'#337'v'#252'l'#337' helyfoglal'#225's (csak IDE/SCSI eset'#233'n!)'
        TabOrder = 2
      end
    end
    object tabBasic: TTabSheet
      Caption = 'tabBasic'
      ImageIndex = 1
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbBasicInfo: TLabel
        Left = 16
        Top = 16
        Width = 127
        Height = 13
        Caption = 'Alapadatok megad'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbFileName: TLabel
        Left = 16
        Top = 75
        Width = 39
        Height = 13
        Caption = '&F'#225'jln'#233'v:'
        FocusControl = edFileName
      end
      object lbFileNameDesc: TLabel
        Left = 16
        Top = 50
        Width = 297
        Height = 34
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Adja meg a helyet, ahol a lemezk'#233'pf'#225'jlt t'#225'rolni k'#237'v'#225'nja.'
        WordWrap = True
      end
      object lbFileNameNote: TLabel
        Left = 16
        Top = 123
        Width = 289
        Height = 38
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ha m'#225'r tudja melyik virtu'#225'lis g'#233'phez k'#237'v'#225'nja felcsatolni, c'#233'lsze' +
          'r'#369' annak a munkak'#246'nyvt'#225'r'#225'ba elhelyezni azt.'
        WordWrap = True
      end
      object lbParamMode: TLabel
        Left = 16
        Top = 157
        Width = 145
        Height = 13
        Caption = '&Param'#233'terek megad'#225'si m'#243'dja:'
        FocusControl = cbParamMode
      end
      object lbConnectorNote: TLabel
        Left = 56
        Top = 210
        Width = 251
        Height = 38
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'MFM, '#233's RLL '#233's PS/2 ESDI merevlemezek eset'#233'n a c'#233'lszer'#369' a merevl' +
          'emez-adatb'#225'zisb'#243'l v'#225'lasztani.'
        WordWrap = True
      end
      object imgWarning: TImage
        Left = 16
        Top = 209
        Width = 32
        Height = 32
        Stretch = True
      end
      object edFileName: TEdit
        Left = 16
        Top = 94
        Width = 250
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'D:\teszt.img'
      end
      object btnBrowse: TButton
        Left = 272
        Top = 92
        Width = 35
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
      object cbParamMode: TComboBox
        Left = 16
        Top = 176
        Width = 289
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemIndex = 0
        TabOrder = 2
        Text = 'Kapacit'#225's megad'#225'sa, automatikus param'#233'terek'
        Items.Strings = (
          'Kapacit'#225's megad'#225'sa, automatikus param'#233'terek'
          'Kiv'#225'laszt'#225's a merevlemez-adatb'#225'zisb'#243'l'
          'Param'#233'terek k'#233'zzel t'#246'rt'#233'n'#337' megad'#225'sa (halad'#243'knak)')
      end
    end
    object tabCapacity: TTabSheet
      Caption = 'tabCapacity'
      ImageIndex = 2
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbCapacityTitle: TLabel
        Left = 16
        Top = 16
        Width = 117
        Height = 13
        Caption = 'Kapacit'#225's megad'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbCapacityDesc: TLabel
        Left = 16
        Top = 48
        Width = 281
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Miel'#337'tt kiv'#225'lasztan'#225' a k'#233'pf'#225'jl m'#233'ret'#233't, adja meg a param'#233'terek g' +
          'ener'#225'l'#225's'#225'hoz a csatol'#243'fel'#252'let t'#237'pus'#225't.'
        WordWrap = True
      end
      object lbConnector: TLabel
        Left = 16
        Top = 87
        Width = 70
        Height = 13
        Caption = 'Csa&tol'#243'fel'#252'let:'
        FocusControl = cbConnector
      end
      object lbCapacity: TLabel
        Left = 16
        Top = 144
        Width = 50
        Height = 13
        Caption = '&Kapacit'#225's:'
        FocusControl = tbCapacity
      end
      object lbCapacitySelected: TLabel
        Left = 184
        Top = 144
        Width = 113
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = '1024 MB'
      end
      object lbAutoC: TLabel
        Left = 16
        Top = 214
        Width = 11
        Height = 13
        Caption = '&C:'
        FocusControl = spAutoC
        Visible = False
      end
      object lbAutoH: TLabel
        Left = 111
        Top = 214
        Width = 11
        Height = 13
        Caption = '&H:'
        FocusControl = spAutoH
        Visible = False
      end
      object lbAutoS: TLabel
        Left = 208
        Top = 214
        Width = 10
        Height = 13
        Caption = '&S:'
        FocusControl = spAutoS
        Visible = False
      end
      object cbConnector: TComboBox
        Left = 16
        Top = 106
        Width = 281
        Height = 21
        Style = csDropDownList
        ItemIndex = 5
        TabOrder = 0
        Text = 'IDE (28-bit LBA BIOS, 137 GB limit)'
        OnChange = cbConnectorChange
        Items.Strings = (
          'ESDI'
          'IDE (INT 13H BIOS, 504 MB limit)'
          'IDE (Enhanced BIOS, 2 GB limit)'
          'IDE (Enhanced BIOS, 4 GB limit)'
          'IDE (Enhanced BIOS, 8.4 GB limit)'
          'IDE (28-bit LBA BIOS, 137 GB limit)'
          'SCSI')
      end
      object tbCapacity: TTrackBar
        Left = 16
        Top = 163
        Width = 281
        Height = 45
        Frequency = 10
        TabOrder = 1
        OnChange = tbCapacityChange
      end
      object spAutoC: TSpinEdit
        Left = 33
        Top = 211
        Width = 64
        Height = 22
        MaxValue = 1
        MinValue = 1
        ReadOnly = True
        TabOrder = 2
        Value = 1
        Visible = False
      end
      object spAutoH: TSpinEdit
        Left = 128
        Top = 211
        Width = 64
        Height = 22
        MaxValue = 1
        MinValue = 1
        ReadOnly = True
        TabOrder = 3
        Value = 1
        Visible = False
      end
      object spAutoS: TSpinEdit
        Left = 224
        Top = 211
        Width = 73
        Height = 22
        MaxValue = 1
        MinValue = 1
        ReadOnly = True
        TabOrder = 4
        Value = 1
        Visible = False
      end
    end
    object tabParameters: TTabSheet
      Caption = 'tabParameters'
      ImageIndex = 3
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbParametersTitle: TLabel
        Left = 16
        Top = 16
        Width = 137
        Height = 13
        Caption = 'Param'#233'terek megad'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbParametersDesc: TLabel
        Left = 16
        Top = 48
        Width = 289
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ebben a m'#243'dban lehet'#337's'#233'g van egy, az adatb'#225'zisban nem szerepl'#337' m' +
          'erevlemez geometriai adatait megadni.'
        WordWrap = True
      end
      object lbTranslationNote: TLabel
        Left = 16
        Top = 187
        Width = 281
        Height = 42
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ha t'#246'bb geometria is el'#233'rhet'#337' akkor a c'#237'mford'#237't'#225'shoz javasoltat ' +
          #233'rdemes megadni, itt '#233's majd a BIOS-ban is.'
        WordWrap = True
      end
      object lbC: TLabel
        Left = 24
        Top = 95
        Width = 11
        Height = 13
        Caption = '&C:'
        FocusControl = spC
      end
      object lbH: TLabel
        Left = 24
        Top = 123
        Width = 11
        Height = 13
        Caption = '&H:'
        FocusControl = spH
      end
      object lbS: TLabel
        Left = 24
        Top = 151
        Width = 10
        Height = 13
        Caption = '&S:'
        FocusControl = spS
      end
      object lbWPCom: TLabel
        Left = 154
        Top = 95
        Width = 41
        Height = 13
        Caption = '&WPCom:'
        FocusControl = spWPCom
      end
      object lbLZone: TLabel
        Left = 154
        Top = 123
        Width = 33
        Height = 13
        Caption = '&LZone:'
        FocusControl = spLZone
      end
      object bvLeftLine: TBevel
        Left = 136
        Top = 92
        Width = 12
        Height = 78
        Shape = bsLeftLine
      end
      object spC: TSpinEdit
        Left = 49
        Top = 92
        Width = 72
        Height = 22
        MaxValue = 99999
        MinValue = 1
        TabOrder = 0
        Value = 1024
      end
      object spH: TSpinEdit
        Left = 49
        Top = 120
        Width = 72
        Height = 22
        MaxValue = 255
        MinValue = 1
        TabOrder = 1
        Value = 16
      end
      object spS: TSpinEdit
        Left = 49
        Top = 148
        Width = 72
        Height = 22
        MaxValue = 99
        MinValue = 1
        TabOrder = 2
        Value = 63
      end
      object spWPCom: TSpinEdit
        Left = 209
        Top = 92
        Width = 72
        Height = 22
        MaxValue = 65535
        MinValue = -1
        TabOrder = 3
        Value = 512
      end
      object spLZone: TSpinEdit
        Left = 209
        Top = 120
        Width = 72
        Height = 22
        MaxValue = 99999
        MinValue = -1
        TabOrder = 4
        Value = 1025
      end
      object btnAutoFill: TButton
        Left = 168
        Top = 148
        Width = 115
        Height = 25
        Caption = '&Automata kit'#246'lt'#233's'
        TabOrder = 5
        OnClick = btnAutoFillClick
      end
    end
    object tabResults: TTabSheet
      Caption = 'tabResults'
      ImageIndex = 4
      TabVisible = False
      OnShow = tabResultsShow
      DesignSize = (
        329
        253)
      object lbReportTitle: TLabel
        Left = 16
        Top = 16
        Width = 164
        Height = 13
        Caption = 'Eredem'#233'nyek '#246'sszefoglal'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbReport: TLabel
        Left = 16
        Top = 48
        Width = 173
        Height = 13
        Caption = 'A l'#233'trehozand'#243' k'#233'pf'#225'jl &param'#233'terei:'
        FocusControl = mmReport
      end
      object lbReportNote: TLabel
        Left = 56
        Top = 210
        Width = 257
        Height = 40
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = 
          'Mivel ezekre a be'#225'll'#237't'#225'sokra sz'#252'ks'#233'ge lehet m'#233'g a g'#233'p konfigur'#225'l' +
          #225'sa sor'#225'n, c'#233'lszer'#369' lementeni '#337'ket.'
        WordWrap = True
      end
      object imgInfo: TImage
        Left = 18
        Top = 208
        Width = 32
        Height = 32
        Anchors = [akLeft, akBottom]
        Stretch = True
      end
      object mmReport: TMemo
        Left = 16
        Top = 67
        Width = 297
        Height = 102
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          'F'#225'jln'#233'v: %s'
          'N'#233'vleges kapacit'#225's: %s'
          'Geometria:  C: %d H: %d S: %d B: 512'
          #205'r'#225's-el'#337'kompenz'#225'ci'#243' (WPCom): %d'
          'Fej parkol'#243'poz'#237'ci'#243' (LZone): %d')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object btnSaveReport: TButton
        Left = 184
        Top = 175
        Width = 131
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'F'#225'jlba &ment'#233's...'
        TabOrder = 1
        OnClick = btnSaveReportClick
      end
      object btnPrintReport: TButton
        Left = 88
        Top = 175
        Width = 90
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = '&Nyomtat'#225's...'
        TabOrder = 2
        OnClick = btnPrintReportClick
      end
    end
    object tabEmpty: TTabSheet
      Caption = 'tabEmpty'
      DoubleBuffered = False
      ImageIndex = 5
      ParentDoubleBuffered = False
      TabVisible = False
    end
  end
  object btnNext: TButton
    Tag = 1
    Left = 383
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Tov'#225'bb >'
    TabOrder = 1
    OnClick = btnNextClick
  end
  object btnPrev: TButton
    Tag = -1
    Left = 302
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '< &Vissza'
    Enabled = False
    TabOrder = 2
    OnClick = btnNextClick
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.img'
    Filter = 'Merevlemez k'#233'pf'#225'jlok (*.im?)|*.im?|Minden f'#225'jl (*.*)|*.*'
    Left = 80
    Top = 168
  end
  object LogDialog: TSaveDialog
    DefaultExt = '.log'
    Filter = 
      'Napl'#243'f'#225'jlok (*.log)|*.log|Sz'#246'vegf'#225'jlok (*.txt)|*.txt|Minden f'#225'jl' +
      ' (*.*)|*.*'
    Left = 80
    Top = 120
  end
  object PrintDialog: TPrintDialog
    Left = 80
    Top = 72
  end
end
