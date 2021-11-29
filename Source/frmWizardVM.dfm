object WizardVM: TWizardVM
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #218'j virtu'#225'lis g'#233'p l'#233'trehoz'#225'sa'
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    479
    309)
  TextHeight = 13
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
  object btnNext: TButton
    Tag = 1
    Left = 383
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Tov'#225'bb >'
    TabOrder = 0
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
    TabOrder = 1
    OnClick = btnNextClick
  end
  object pcPages: TPageControl
    Left = 142
    Top = 0
    Width = 337
    Height = 263
    ActivePage = tabBasic
    Align = alClient
    TabOrder = 2
    object tabWelcome: TTabSheet
      Caption = 'tabWelcome'
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbWelcome: TLabel
        Left = 16
        Top = 16
        Width = 200
        Height = 13
        Caption = #218'j virtu'#225'lis g'#233'p - '#252'dv'#246'zli a var'#225'zsl'#243'!'
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
          'Ez a var'#225'zsl'#243' v'#233'gigvezeti '#214'nt egy '#250'j WinBox virtu'#225'lis g'#233'p l'#233'treh' +
          'oz'#225's'#225'nak a folyamat'#225'n.'#13#10#13#10'Hab'#225'r az el'#337're defini'#225'lt sablonok megk' +
          #246'nny'#237'tik az adott feladatra alkalmas g'#233'p l'#233'trehoz'#225's'#225't, ennek ell' +
          'en'#233're sz'#252'ks'#233'g lehet alapszint'#369' ismeretekre a sz'#225'm'#237't'#243'g'#233'pek fel'#233'p'#237 +
          't'#233's'#233'vel '#233's a hardverekkel kapcsolatban.'#13#10#13#10'A l'#233'p'#233'sek megkezd'#233's'#233'h' +
          'ez kattintson a Tov'#225'bb gombra.'
        WordWrap = True
        ExplicitHeight = 184
      end
    end
    object tabBasic: TTabSheet
      Caption = 'tabBasic'
      ImageIndex = 6
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
      object lbName: TLabel
        Left = 34
        Top = 87
        Width = 23
        Height = 13
        Caption = '&N'#233'v:'
        FocusControl = edName
      end
      object lbNameDesc: TLabel
        Left = 18
        Top = 45
        Width = 287
        Height = 34
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          #205'rja be a virtu'#225'lis g'#233'p nev'#233't, amivel k'#233's'#337'bb azonos'#237'thatja a Win' +
          'Box list'#225'j'#225'ban.'
        WordWrap = True
      end
      object lbWorkingDirDesc: TLabel
        Left = 18
        Top = 120
        Width = 287
        Height = 41
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'A munkak'#246'nyvt'#225'rban az emul'#225'tor sz'#225'm'#225'ra sz'#252'ks'#233'ges konfigur'#225'ci'#243's, ' +
          #233's lemezk'#233'pf'#225'jlok lesznek megtal'#225'lhat'#243'ak.'
        WordWrap = True
      end
      object lbWorkingDir: TLabel
        Left = 18
        Top = 160
        Width = 78
        Height = 13
        Caption = '&Munkak'#246'nyvt'#225'r:'
        FocusControl = edPath
      end
      object edName: TEdit
        Left = 71
        Top = 85
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 0
      end
      object edPath: TEdit
        Left = 18
        Top = 181
        Width = 240
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 1
        Text = 'edPath'
      end
      object btnBrowse: TButton
        Left = 264
        Top = 177
        Width = 35
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 2
        OnClick = btnBrowseClick
      end
      object btnOpenWorkingDir: TButton
        Left = 128
        Top = 208
        Width = 171
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Munkak'#246'nyvt'#225'r meg&nyit'#225'sa...'
        TabOrder = 3
        OnClick = btnOpenWorkingDirClick
      end
    end
    object tabTemplates: TTabSheet
      Caption = 'tabTemplates'
      ImageIndex = 1
      TabVisible = False
      OnShow = tabTemplatesShow
      DesignSize = (
        329
        253)
      object lbTemplateTitle: TLabel
        Left = 16
        Top = 16
        Width = 112
        Height = 13
        Caption = 'Sablon kiv'#225'laszt'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbTemplateDesc: TLabel
        Left = 119
        Top = 44
        Width = 185
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = '&Sablonok:'
        WordWrap = True
      end
      object lbManufacturerDesc: TLabel
        Left = 16
        Top = 44
        Width = 37
        Height = 13
        Caption = '&Gy'#225'rt'#243':'
      end
      object lbSupportedOSDesc: TLabel
        Left = 16
        Top = 176
        Width = 165
        Height = 13
        Caption = 'T'#225'mogatott &oper'#225'ci'#243's rendszerek:'
      end
      object lbSupportedOS: TLabel
        Left = 16
        Top = 195
        Width = 297
        Height = 29
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Caption = 
          'Lorem Ipsum is simply dummy text of the printing and typesetting' +
          ' industry. Lorem Ipsum has been the industry'#39's standard dummy te' +
          'xt ever since the 1500s, when an unknown printer took a galley o' +
          'f type and scrambled it to make a type specimen book. It has sur' +
          'vived not only five centuries, but also the leap into electronic' +
          ' typesetting, remaining essentially unchanged. It was popularise' +
          'd in the 1960s with the release of Letraset sheets containing Lo' +
          'rem Ipsum passages, and more recently with desktop publishi'
        WordWrap = True
      end
      object lbNoTemplate: TLabel
        Left = 116
        Top = 230
        Width = 197
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'Sablon n'#233'lk'#252'li g'#233'p k'#233'sz'#237't'#233'se (halad'#243'knak)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHighlight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = lbNoTemplateClick
      end
      object lbManufacturer: TListBox
        Left = 16
        Top = 63
        Width = 97
        Height = 107
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbManufacturerClick
      end
      object lbModel: TListBox
        Left = 119
        Top = 63
        Width = 194
        Height = 107
        ItemHeight = 13
        TabOrder = 1
        OnClick = lbModelClick
      end
    end
    object tabOptions: TTabSheet
      Caption = 'tabOptions'
      ImageIndex = 4
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbOptionsTitle: TLabel
        Left = 16
        Top = 16
        Width = 184
        Height = 13
        Caption = 'Opcion'#225'lis be'#225'll'#237't'#225'si lehet'#337's'#233'gek'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbOptionsDesc: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 31
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ezen az oldalon be'#225'll'#237'thatja a l'#233'trehozand'#243' virtu'#225'lis g'#233'p legfon' +
          'tosabb param'#233'tereit.'
        WordWrap = True
      end
      object lbOptionsNote: TLabel
        Left = 16
        Top = 200
        Width = 297
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Az itt megadott adatok, a finombe'#225'll'#237't'#225'sokkal egy'#252'tt a k'#233's'#337'bbiek' +
          'ben is m'#243'dos'#237'that'#243'ak lesznek.'
        WordWrap = True
      end
      object lbOption1: TLabel
        Left = 16
        Top = 85
        Width = 82
        Height = 21
        AutoSize = False
        Caption = '&Option 1:'
        FocusControl = cbOption1
      end
      object lbOption2: TLabel
        Left = 16
        Top = 113
        Width = 82
        Height = 25
        AutoSize = False
        Caption = '&Option 1:'
        FocusControl = cbOption2
      end
      object lbOption3: TLabel
        Left = 16
        Top = 143
        Width = 82
        Height = 22
        AutoSize = False
        Caption = '&Option 1:'
        FocusControl = cbOption3
      end
      object lbOption4: TLabel
        Left = 16
        Top = 172
        Width = 82
        Height = 22
        AutoSize = False
        Caption = '&Option 1:'
        FocusControl = cbOption4
      end
      object cbOption1: TComboBox
        Left = 104
        Top = 85
        Width = 193
        Height = 22
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        OnDrawItem = cbOption1DrawItem
      end
      object cbOption2: TComboBox
        Left = 104
        Top = 112
        Width = 193
        Height = 22
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        OnDrawItem = cbOption1DrawItem
      end
      object cbOption3: TComboBox
        Left = 104
        Top = 139
        Width = 193
        Height = 22
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
        OnDrawItem = cbOption1DrawItem
      end
      object cbOption4: TComboBox
        Left = 104
        Top = 167
        Width = 193
        Height = 22
        Style = csOwnerDrawFixed
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 3
        OnDrawItem = cbOption1DrawItem
      end
    end
    object tabStorage: TTabSheet
      Caption = 'tabStorage'
      ImageIndex = 5
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbStorageTitle: TLabel
        Left = 16
        Top = 16
        Width = 89
        Height = 13
        Caption = 'T'#225'rol'#243'eszk'#246'z'#246'k'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbStorageDesc: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 33
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ezen az oldalon kiv'#225'laszthatja milyen h'#225'tt'#233'rt'#225'rol'#243'kat k'#237'v'#225'n alka' +
          'lmazni a l'#233'trehozand'#243' virtu'#225'lis g'#233'pben.'
        WordWrap = True
      end
      object lbType1: TLabel
        Left = 32
        Top = 102
        Width = 29
        Height = 13
        Caption = 'T'#237'pus:'
      end
      object lbGeometry: TLabel
        Left = 32
        Top = 120
        Width = 53
        Height = 13
        Caption = '&Geometria:'
      end
      object lbHDD: TLabel
        Left = 104
        Top = 102
        Width = 29
        Height = 13
        Caption = 'lbHDD'
      end
      object lbCHS: TLabel
        Left = 104
        Top = 120
        Width = 28
        Height = 13
        Caption = 'lbCHS'
      end
      object lbType2: TLabel
        Left = 32
        Top = 163
        Width = 29
        Height = 13
        Caption = '&T'#237'pus:'
      end
      object lbCDROM: TLabel
        Left = 104
        Top = 163
        Width = 45
        Height = 13
        Caption = 'lbCDROM'
      end
      object imgWarning: TImage
        Left = 18
        Top = 208
        Width = 32
        Height = 32
        Anchors = [akLeft, akBottom]
        Stretch = True
      end
      object lbStorageNote: TLabel
        Left = 64
        Top = 211
        Width = 249
        Height = 26
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = 
          'Ha m'#225'r rendelkezik merevlemez k'#233'pf'#225'jllal, akkor ezen a ponton ne' +
          ' adjon meg merevlemezt.'
        WordWrap = True
      end
      object lbNoteCDROMDesc: TLabel
        Left = 32
        Top = 182
        Width = 61
        Height = 13
        Caption = '&Megjegyz'#233's:'
      end
      object lbNoteCDROM: TLabel
        Left = 104
        Top = 182
        Width = 68
        Height = 13
        Caption = 'lbNoteCDROM'
      end
      object cbHDD: TCheckBox
        Left = 16
        Top = 79
        Width = 281
        Height = 17
        Caption = '&Merevlemez'
        TabOrder = 0
        OnClick = cbHDDClick
      end
      object cbCDROM: TCheckBox
        Left = 16
        Top = 140
        Width = 289
        Height = 17
        Caption = 'CD-meghajt'#243
        TabOrder = 1
      end
      object btnHDD: TButton
        Left = 216
        Top = 105
        Width = 83
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&Be'#225'll'#237't'#225's...'
        TabOrder = 2
        OnClick = btnHDDClick
      end
    end
    object tabFinish: TTabSheet
      Caption = 'tabFinish'
      ImageIndex = 4
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbFinishTitle: TLabel
        Left = 16
        Top = 16
        Width = 103
        Height = 13
        Caption = 'Minden k'#233'szen '#225'll!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbFinishDesc: TLabel
        Left = 16
        Top = 48
        Width = 289
        Height = 145
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'A var'#225'zsl'#243' most m'#225'r minden sz'#252'ks'#233'ges adatot ismer az '#250'j virtu'#225'li' +
          's g'#233'p l'#233'trehoz'#225's'#225'hoz.'#13#10#13#10'Ha a g'#233'p l'#233'trehoz'#225'sa ut'#225'n szeretne fino' +
          'mbe'#225'll'#237't'#225'sokat elv'#233'gezni, haszn'#225'lja az al'#225'bbi jel'#246'l'#337'n'#233'gyzetet.'#13#10 +
          #13#10#13#10#13#10#13#10'A befejez'#233'shez kattintson a Tov'#225'bb gombra.'
        WordWrap = True
      end
      object cbOpenSettings: TCheckBox
        Left = 16
        Top = 128
        Width = 289
        Height = 17
        Caption = '&Tov'#225'bbi be'#225'll'#237't'#225'sok megjelen'#237't'#233'se a l'#233'trehoz'#225's ut'#225'n'
        TabOrder = 0
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
end
