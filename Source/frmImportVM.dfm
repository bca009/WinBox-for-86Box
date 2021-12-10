object ImportVM: TImportVM
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Virtu'#225'lis g'#233'p import'#225'l'#225'sa'
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
  OnShow = Reload
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
    ExplicitLeft = 1
    ExplicitTop = 265
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
    ActivePage = tabWelcome
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
        Width = 256
        Height = 13
        Caption = 'Virtu'#225'lis g'#233'p import'#225'l'#225'sa - '#252'dv'#246'zli a var'#225'zsl'#243'!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbGreetings: TLabel
        Left = 16
        Top = 40
        Width = 297
        Height = 203
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Caption = 
          'Ez a var'#225'zsl'#243' v'#233'gigvezeti '#214'nt egy megl'#233'v'#337' 86Box virtu'#225'lis g'#233'p im' +
          'port'#225'l'#225's'#225'nak folyamat'#225'n.'#13#10#13#10'Mivel import'#225'l'#225'skor csak a g'#233'p speci' +
          'fikus be'#225'll'#237't'#225'sok ker'#252'lnek '#225'tvitelre, er'#337'sen aj'#225'nlott a kapcsol'#243 +
          'd'#243' program be'#225'll'#237't'#225'sainak import'#225'l'#225'sa is a m'#369'velet megkezd'#233'se el' +
          #337'tt.'#13#10#13#10'A glob'#225'lis be'#225'll'#237't'#225'sok import'#225'l'#225's'#225't a Programbe'#225'll'#237't'#225'sok' +
          ' p'#225'rbesz'#233'dablakban v'#233'gezheti el, amit az ablak jobb als'#243' sark'#225'ba' +
          'n lev'#337' hivatkoz'#225'ssal nyithat meg.'#13#10#13#10'Ha k'#233'szen '#225'll kattintson a ' +
          'Tov'#225'bb gombra.'
        WordWrap = True
      end
      object lbProgramSettings: TLabel
        Left = 216
        Top = 222
        Width = 90
        Height = 13
        Cursor = crHandPoint
        Alignment = taRightJustify
        Anchors = [akRight, akBottom]
        Caption = 'Programbe'#225'll'#237't'#225'sok'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clHotLight
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        StyleElements = [seClient, seBorder]
        OnClick = lbProgramSettingsClick
      end
    end
    object tabSource: TTabSheet
      Caption = 'tabSource'
      ImageIndex = 5
      TabVisible = False
      object lbSource: TLabel
        Left = 16
        Top = 16
        Width = 110
        Height = 13
        Caption = 'Forr'#225's kiv'#225'laszt'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbSelectSource: TLabel
        Left = 16
        Top = 40
        Width = 297
        Height = 34
        AutoSize = False
        Caption = 
          'A WinBox bizonyos programokb'#243'l k'#233'pes '#225'tvenni virtu'#225'lis g'#233'peket, ' +
          'a be'#225'll'#237't'#225'saikkal egy'#252'tt.'
        WordWrap = True
      end
      object lb86BoxManager: TLabel
        Left = 32
        Top = 93
        Width = 273
        Height = 36
        AutoSize = False
        Caption = 
          'Virtu'#225'lis g'#233'pek import'#225'l'#225'sa kiz'#225'r'#243'lag a v1.7.2.0 verzi'#243' eset'#233'n l' +
          'ehets'#233'ges.'
        WordWrap = True
      end
      object lbImportWinBox: TLabel
        Left = 32
        Top = 150
        Width = 273
        Height = 35
        AutoSize = False
        Caption = 
          'A virtu'#225'lis g'#233'pek import'#225'l'#225's'#225'nak lehet'#337's'#233'ge a v1.14 verzi'#243'val be' +
          'z'#225'r'#243'lag biztos'#237'tott.'
        WordWrap = True
      end
      object lbManualImport: TLabel
        Left = 32
        Top = 207
        Width = 265
        Height = 43
        AutoSize = False
        Caption = 
          'Csak akkor v'#225'lassza ezt a megold'#225'st, ha probl'#233'm'#225'i vannak a fente' +
          'bbi opci'#243'kkal.'
        WordWrap = True
      end
      object rb86BoxManager: TRadioButton
        Left = 16
        Top = 72
        Width = 249
        Height = 17
        Caption = 'Import'#225'l'#225's innen: &86Box Manager'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object rbWinBox: TRadioButton
        Left = 16
        Top = 127
        Width = 225
        Height = 17
        Caption = 'Import'#225'l'#225's innen: &WinBox Reloaded'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object rbManualImport: TRadioButton
        Left = 16
        Top = 184
        Width = 273
        Height = 17
        Caption = 'Import'#225'l'#225's &k'#233'zi megad'#225'ssal (halad'#243'knak)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
      end
    end
    object tabMachineList: TTabSheet
      Caption = 'tabMachineList'
      ImageIndex = 6
      TabVisible = False
      object lbSelectVM: TLabel
        Left = 16
        Top = 16
        Width = 158
        Height = 13
        Caption = 'Virtu'#225'lis g'#233'pek kiv'#225'laszt'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbImport: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 13
        AutoSize = False
        Caption = 'V'#225'lassza ki a &list'#225'b'#243'l az import'#225'lni k'#237'v'#225'nt virtu'#225'lis g'#233'peket:'
        FocusControl = lvImport
      end
      object lvImport: TListView
        Left = 16
        Top = 67
        Width = 297
        Height = 134
        Checkboxes = True
        Columns = <
          item
            Caption = 'N'#233'v'
            Width = 120
          end
          item
            Caption = 'Munkak'#246'nyvt'#225'r'
            Width = 300
          end>
        GridLines = True
        Items.ItemData = {
          05510000000100000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000
          000852006500740072006F002000500043001044003A005C005400650073007A
          0074002000500043005C0076006D0073005C00D87B6F19FFFF}
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object btnSelectAll: TButton
        Tag = 1
        Left = 79
        Top = 207
        Width = 115
        Height = 25
        Caption = 'Az &'#246'sszes kijel'#246'l'#233'se'
        TabOrder = 1
        OnClick = btnLvSelectClick
      end
      object btnDeselectAll: TButton
        Left = 200
        Top = 207
        Width = 110
        Height = 25
        Caption = 'Kijel'#246'l'#233's &t'#246'rl'#233'se'
        TabOrder = 2
        OnClick = btnLvSelectClick
      end
    end
    object tabEnding1: TTabSheet
      Caption = 'tabEnding1'
      ImageIndex = 7
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbReady1: TLabel
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
      object lbFinale1: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 153
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'A var'#225'zsl'#243' most m'#225'r minden sz'#252'ks'#233'ges adatot ismer a kijel'#246'lt vir' +
          'tu'#225'lis g'#233'pek import'#225'l'#225's'#225'hoz.'#13#10#13#10'A befejez'#233'shez kattintson a Tov'#225 +
          'bb gombra.'
        WordWrap = True
      end
    end
    object tabManual: TTabSheet
      Caption = 'tabManual'
      ImageIndex = 6
      TabVisible = False
      OnShow = tabManualShow
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
        Top = 85
        Width = 23
        Height = 13
        Alignment = taRightJustify
        Caption = '&N'#233'v:'
        FocusControl = edName
      end
      object lbDescOfName: TLabel
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
      object lbDescOfConfig: TLabel
        Left = 18
        Top = 111
        Width = 287
        Height = 54
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'A konfigur'#225'ci'#243't a 86Box.cfg f'#225'jl tartalmazza, ami az import'#225'land' +
          #243' g'#233'p munkak'#246'nyvt'#225'r'#225'ban tal'#225'lhat'#243'.'
        WordWrap = True
      end
      object lbConfig: TLabel
        Left = 34
        Top = 152
        Width = 86
        Height = 13
        Caption = 'Konfigur'#225'ci'#243's &f'#225'jl:'
        FocusControl = edConfig
      end
      object lbNoteForStoring: TLabel
        Left = 16
        Top = 208
        Width = 297
        Height = 42
        AutoSize = False
        Caption = 
          'A virtu'#225'lis g'#233'p f'#225'jlai az eredeti munkak'#246'nyvt'#225'rban lesznek t'#225'rol' +
          'va, elmozgat'#225'sra nem ker'#252'lnek az import'#225'l'#225'skor.'
        WordWrap = True
      end
      object edName: TEdit
        Left = 71
        Top = 82
        Width = 210
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 0
      end
      object edConfig: TEdit
        Left = 40
        Top = 171
        Width = 218
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        TabOrder = 1
      end
      object btnConfig: TButton
        Left = 264
        Top = 169
        Width = 35
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '&...'
        TabOrder = 2
        OnClick = btnConfigClick
      end
    end
    object tabEnding2: TTabSheet
      Caption = 'tabEnding2'
      ImageIndex = 4
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbReady2: TLabel
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
      object lbFinale2: TLabel
        Left = 16
        Top = 48
        Width = 297
        Height = 153
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ennyi adat most elegend'#337' a virtu'#225'lis g'#233'p import'#225'l'#225's'#225'hoz, mivel a' +
          ' nem bek'#233'rt '#233'rt'#233'kek a glob'#225'lis program be'#225'll'#237't'#225'sok szerint ker'#252'l' +
          'nek kit'#246'lt'#233'sre.'#13#10#13#10'Ha az import'#225'l'#225'sa ut'#225'n szeretne finombe'#225'll'#237't'#225 +
          'sokat elv'#233'gezni, haszn'#225'lja az al'#225'bbi jel'#246'l'#337'n'#233'gyzetet.'#13#10#13#10#13#10#13#10#13#10'A' +
          ' befejez'#233'shez kattintson a Tov'#225'bb gombra.'
        WordWrap = True
      end
      object cbProfileSettings: TCheckBox
        Left = 16
        Top = 144
        Width = 289
        Height = 17
        Caption = '&Profilbe'#225'll'#237't'#225'sok megnyit'#225'sa az import'#225'l'#225's ut'#225'n'
        TabOrder = 0
      end
    end
    object tabEmpty: TTabSheet
      Caption = 'tabEmpty'
      ImageIndex = 6
      TabVisible = False
    end
  end
  object odConfig: TOpenDialog
    DefaultExt = '.cfg'
    FileName = '86Box.cfg'
    Filter = 
      '86Box konfigur'#225'ci'#243's f'#225'jlok (86box.cfg)|86box.cfg|Minden f'#225'jl (*.' +
      '*)|*.*'
    Left = 48
    Top = 192
  end
end
