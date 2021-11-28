object ProfSettDlg: TProfSettDlg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Profilbe'#225'll'#237't'#225'sok'
  ClientHeight = 516
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = Reload
  PixelsPerInch = 96
  DesignSize = (
    460
    516)
  TextHeight = 13
  object btnCancel: TButton
    Left = 357
    Top = 478
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&M'#233'gse'
    ModalResult = 2
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 276
    Top = 478
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object pcPages: TPageControl
    Left = 8
    Top = 8
    Width = 444
    Height = 458
    ActivePage = tabEmulator
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object tabGeneral: TTabSheet
      Caption = #193'ltal'#225'nos'
      DesignSize = (
        436
        430)
      object grpInformations: TGroupBox
        Left = 14
        Top = 264
        Width = 406
        Height = 153
        Caption = 'Inform'#225'ci'#243'k'
        TabOrder = 2
        DesignSize = (
          406
          153)
        object lbInternalID: TLabel
          Left = 53
          Top = 47
          Width = 235
          Height = 30
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lbInternalID'
        end
        object lbDescOfID: TLabel
          Left = 22
          Top = 28
          Width = 195
          Height = 21
          AutoSize = False
          Caption = 'Bels'#337' azonos'#237't'#243':'
        end
        object lbDescOfWkDir: TLabel
          Left = 22
          Top = 75
          Width = 195
          Height = 22
          AutoSize = False
          Caption = 'Munkak'#246'nyvt'#225'r:'
        end
        object lbWorkingDirectory: TLabel
          Left = 53
          Top = 94
          Width = 235
          Height = 31
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          BiDiMode = bdLeftToRight
          Caption = 'lbWorkingDirectory'
          ParentBiDiMode = False
          WordWrap = True
        end
        object btnOpenWorkDir: TButton
          Tag = 9
          Left = 294
          Top = 83
          Width = 91
          Height = 25
          Caption = '&Megnyit'#225's...'
          TabOrder = 1
          OnClick = ActionClick
        end
        object cbEraseProt: TCheckBox
          Left = 22
          Top = 123
          Width = 315
          Height = 17
          Caption = 'A munkak'#246'nyvt'#225'rban lev'#337' f'#225'jlok v'#233'delme &t'#246'rl'#233's ellen'
          TabOrder = 2
        end
        object btnOpenConfig: TButton
          Tag = 8
          Left = 294
          Top = 32
          Width = 93
          Height = 25
          Caption = '&Konfigur'#225'ci'#243'...'
          TabOrder = 0
          OnClick = ActionClick
        end
      end
      object grpBasicInfo: TGroupBox
        Left = 14
        Top = 19
        Width = 406
        Height = 134
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Alapadatok'
        TabOrder = 0
        DesignSize = (
          406
          134)
        object bvIcon: TBevel
          Left = 30
          Top = 24
          Width = 64
          Height = 64
        end
        object imgIcon: TImage
          Tag = 6
          Left = 30
          Top = 24
          Width = 64
          Height = 64
          Cursor = crHandPoint
          Center = True
          Proportional = True
          Stretch = True
          OnClick = OpenImgClick
        end
        object lbFriendlyName: TLabel
          Left = 120
          Top = 26
          Width = 41
          Height = 27
          AutoSize = False
          Caption = '&N'#233'v:'
          FocusControl = edFriendlyName
        end
        object lbDescription: TLabel
          Left = 120
          Top = 59
          Width = 41
          Height = 22
          AutoSize = False
          Caption = '&Le'#237'r'#225's:'
          FocusControl = mmDescription
        end
        object edFriendlyName: TEdit
          Left = 160
          Top = 23
          Width = 225
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          TabOrder = 0
        end
        object mmDescription: TMemo
          Left = 160
          Top = 59
          Width = 225
          Height = 54
          Anchors = [akLeft, akTop, akRight, akBottom]
          ScrollBars = ssVertical
          TabOrder = 1
          WantReturns = False
        end
        object btnDelete: TButton
          Tag = 7
          Left = 22
          Top = 94
          Width = 84
          Height = 25
          Caption = '&T'#246'rl'#233's'
          TabOrder = 2
          OnClick = ActionClick
        end
      end
      object grpAppearance: TGroupBox
        Left = 14
        Top = 159
        Width = 406
        Height = 99
        Caption = 'Megjelen'#233's'
        TabOrder = 1
        DesignSize = (
          406
          99)
        object rcColor: TShape
          Left = 108
          Top = 24
          Width = 53
          Height = 24
          Brush.Color = clFuchsia
          Pen.Style = psClear
        end
        object bvColor: TBevel
          Tag = 4
          Left = 108
          Top = 23
          Width = 53
          Height = 25
          Cursor = crHandPoint
        end
        object lbColor: TLabel
          Left = 41
          Top = 29
          Width = 65
          Height = 20
          AutoSize = False
          Caption = '&H'#225'tt'#233'rsz'#237'n:'
        end
        object cbFullscreen: TCheckBox
          Left = 22
          Top = 64
          Width = 291
          Height = 17
          Caption = 'A virtu'#225'lis g'#233'p ind'#237't'#225'sa &teljes k'#233'perny'#337's '#252'zemm'#243'dban'
          TabOrder = 1
        end
        object btnResetColor: TButton
          Tag = 5
          Left = 230
          Top = 24
          Width = 153
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'H'#225'tt'#233'rsz'#237'n &t'#246'rl'#233'se'
          TabOrder = 0
          OnClick = ActionClick
        end
      end
    end
    object tabEmulator: TTabSheet
      Caption = 'Emul'#225'tor'
      ImageIndex = 3
      DesignSize = (
        436
        430)
      object grpEmulator: TGroupBox
        Left = 18
        Top = 16
        Width = 402
        Height = 241
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Emul'#225'tor'
        TabOrder = 0
        DesignSize = (
          402
          241)
        object imgEmulator: TImage
          Left = 16
          Top = 24
          Width = 32
          Height = 32
          Stretch = True
        end
        object lbDefEmulator: TLabel
          Left = 60
          Top = 24
          Width = 315
          Height = 41
          AutoSize = False
          Caption = 
            'Ezen a f'#252'l'#246'n megadhatja a specifikusan ezzel a virtu'#225'lis g'#233'ppel ' +
            'haszn'#225'lni k'#237'v'#225'nt 86Box verzi'#243' adatait.'
          WordWrap = True
        end
        object lbOptionalParams: TLabel
          Left = 24
          Top = 156
          Width = 193
          Height = 21
          AutoSize = False
          Caption = 'Egy'#233'ni &param'#233'terek:'
        end
        object lbVersion: TLabel
          Left = 246
          Top = 71
          Width = 138
          Height = 26
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'v3.0.0.1024'
        end
        object lb86BoxPath: TLabel
          Left = 24
          Top = 71
          Width = 145
          Height = 26
          AutoSize = False
          Caption = '&El'#233'r'#233'si '#250't:'
          FocusControl = ed86Box
        end
        object mmOptionalParams: TMemo
          Left = 24
          Top = 175
          Width = 353
          Height = 50
          Anchors = [akLeft, akTop, akRight, akBottom]
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          ScrollBars = ssVertical
          TabOrder = 4
          WantReturns = False
        end
        object ed86Box: TEdit
          Left = 24
          Top = 90
          Width = 311
          Height = 21
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          TabOrder = 0
          Text = 'ed86Box'
          OnChange = ed86BoxChange
        end
        object btn86Box: TButton
          Tag = 1
          Left = 341
          Top = 87
          Width = 42
          Height = 26
          Caption = '&...'
          TabOrder = 1
          OnClick = ActionClick
        end
        object btnOpen86Box: TButton
          Tag = 3
          Left = 232
          Top = 117
          Width = 142
          Height = 25
          Caption = 'K'#246'nyvt'#225'r meg&nyit'#225'sa...'
          TabOrder = 3
          OnClick = ActionClick
        end
        object btnDef86Box: TButton
          Tag = 2
          Left = 120
          Top = 117
          Width = 106
          Height = 25
          Caption = '&Alap'#233'rtelmezett'
          TabOrder = 2
          OnClick = ActionClick
        end
      end
      object grpDebug: TGroupBox
        Left = 18
        Top = 263
        Width = 402
        Height = 154
        Caption = 'Hibakeres'#233's'
        TabOrder = 1
        object lbLogging: TLabel
          Left = 18
          Top = 67
          Width = 133
          Height = 21
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Napl'#243'z'#225's:'
          FocusControl = cbLogging
        end
        object lbDebugMode: TLabel
          Left = 16
          Top = 94
          Width = 135
          Height = 21
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&Hibakeres'#233'si '#252'zemm'#243'd:'
        end
        object lbCrashDump: TLabel
          Left = 16
          Top = 121
          Width = 135
          Height = 30
          Alignment = taRightJustify
          AutoSize = False
          Caption = '&'#214'sszeoml'#225'si mem'#243'riak'#233'pek:'
        end
        object lbDebug: TLabel
          Left = 60
          Top = 26
          Width = 321
          Height = 37
          AutoSize = False
          Caption = 
            'Az al'#225'bbi be'#225'll'#237't'#225'sok seg'#237'ts'#233'g'#233'vel az emul'#225'tor futtat'#225'sakor g'#233'pe' +
            'nk'#233'nt elt'#233'rhet a glob'#225'lis hibakeres'#233'si opci'#243'kt'#243'l.'
          WordWrap = True
        end
        object imgDebug: TImage
          Left = 16
          Top = 27
          Width = 32
          Height = 32
        end
        object cbLogging: TComboBox
          Left = 157
          Top = 63
          Width = 228
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 0
          Text = 'Alap'#233'rtelmezett'
          Items.Strings = (
            'Alap'#233'rtelmezett'
            'Kikapcsolva'
            'Glob'#225'lisan, mindent egyetlen napl'#243'f'#225'jlba'
            'Glob'#225'lisan, ind'#237't'#225'sonk'#233'nt gener'#225'lt f'#225'jlokba'
            'G'#233'penk'#233'nt, munkak'#246'nyvt'#225'ronk'#233'nt egy f'#225'jlba'
            'G'#233'penk'#233'nt, ind'#237't'#225'sonk'#233'nt gener'#225'lt f'#225'jlokba')
        end
        object cbDebugMode: TComboBox
          Left = 157
          Top = 90
          Width = 228
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 1
          Text = 'Alap'#233'rtelmezett'
          Items.Strings = (
            'Alap'#233'rtelmezett'
            'Kikapcsolva'
            'Bekapcsolva')
        end
        object cbCrashDump: TComboBox
          Left = 157
          Top = 117
          Width = 228
          Height = 21
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 2
          Text = 'Alap'#233'rtelmezett'
          Items.Strings = (
            'Alap'#233'rtelmezett'
            'Kikapcsolva'
            'Bekapcsolva')
        end
      end
    end
  end
  object od86Box: TOpenDialog
    DefaultExt = '.exe'
    FileName = '86Box.exe'
    Filter = 
      '86Box bin'#225'risok (86Box*.exe)|86Box*.*|Futtathat'#243' f'#225'jlok (*.exe; ' +
      '*.com; *.bat; *.cmd)|*.exe; *.com; *.bat; *.cmd|Minden f'#225'jl (*.*' +
      ')|*.*'
    Left = 400
    Top = 120
  end
  object cdColors: TColorDialog
    Left = 400
    Top = 64
  end
  object opdIcon: TOpenPictureDialog
    DefaultExt = '.png'
    Left = 400
    Top = 8
  end
end
