object Frame86Box: TFrame86Box
  Left = 0
  Top = 0
  Width = 526
  Height = 345
  DoubleBuffered = False
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentBackground = False
  ParentColor = False
  ParentDoubleBuffered = False
  ParentFont = False
  TabOrder = 0
  OnResize = FrameResize
  PixelsPerInch = 96
  DesignSize = (
    526
    345)
  object bvBottom: TBevel
    AlignWithMargins = True
    Left = 3
    Top = 308
    Width = 520
    Height = 34
    Align = alBottom
    Shape = bsTopLine
    ExplicitLeft = 0
    ExplicitTop = 307
    ExplicitWidth = 526
  end
  object lbStateDesc: TLabel
    Left = 18
    Top = 318
    Width = 50
    Height = 24
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = '&'#193'llapot:'
    FocusControl = edState
    ExplicitTop = 330
  end
  object Splitter: TSplitter
    AlignWithMargins = True
    Left = 332
    Top = 46
    Height = 254
    Margins.Left = 0
    Margins.Top = 5
    Margins.Right = 0
    Margins.Bottom = 5
    Align = alRight
    Beveled = True
    OnMoved = OnEnterSizeMove
    ExplicitLeft = 338
    ExplicitTop = 47
    ExplicitHeight = 276
  end
  object edState: TEdit
    Left = 64
    Top = 318
    Width = 185
    Height = 24
    Anchors = [akLeft, akBottom]
    AutoSelect = False
    AutoSize = False
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    Text = 'Ismeretlen'
    StyleElements = [seBorder]
  end
  object cgPanels: TCategoryPanelGroup
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 324
    Height = 258
    Margins.Right = 5
    VertScrollBar.Tracking = True
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    ChevronColor = clWindowText
    GradientBaseColor = clWindow
    GradientColor = clWindow
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    ParentColor = True
    TabOrder = 0
    OnResize = cgPanelsResize
    object cpPorts: TCategoryPanel
      Top = 563
      Height = 78
      Caption = 'Portok'
      ParentColor = True
      TabOrder = 0
      ExplicitWidth = 320
      object lbSerialDesc: TLabel
        Left = 16
        Top = 8
        Width = 65
        Height = 13
        Caption = 'Soros portok:'
      end
      object lbParallelDesc: TLabel
        Left = 16
        Top = 27
        Width = 85
        Height = 13
        Caption = 'P'#225'rhuzamos port:'
      end
      object lbSerial: TLabel
        Left = 111
        Top = 8
        Width = 3
        Height = 13
      end
      object lbParallel: TLabel
        Left = 111
        Top = 27
        Width = 3
        Height = 13
      end
    end
    object cpInput: TCategoryPanel
      Top = 485
      Height = 78
      Caption = 'Beviteli eszk'#246'z'#246'k'
      ParentColor = True
      TabOrder = 1
      ExplicitWidth = 320
      object lbMouseDesc: TLabel
        Left = 16
        Top = 8
        Width = 26
        Height = 13
        Caption = '&Eg'#233'r:'
        FocusControl = edMouse
      end
      object lbJoystickDesc: TLabel
        Left = 16
        Top = 27
        Width = 65
        Height = 13
        Caption = '&J'#225't'#233'kvez'#233'rl'#337':'
        FocusControl = edJoystick
      end
      object edJoystick: TEdit
        Left = 99
        Top = 27
        Width = 71
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object edMouse: TEdit
        Left = 99
        Top = 8
        Width = 65
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
    end
    object cpNetwork: TCategoryPanel
      Top = 407
      Height = 78
      Caption = 'H'#225'l'#243'zat'
      ParentColor = True
      TabOrder = 2
      ExplicitWidth = 320
      object lbNetCardDesc: TLabel
        Left = 16
        Top = 8
        Width = 77
        Height = 13
        Caption = '&H'#225'l'#243'zati eszk'#246'z:'
        FocusControl = edNetCard
      end
      object lbNetTypeDesc: TLabel
        Left = 16
        Top = 27
        Width = 70
        Height = 13
        Caption = '&Csatol'#225'si m'#243'd:'
        FocusControl = edNetType
      end
      object edNetType: TEdit
        Left = 99
        Top = 27
        Width = 26
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object edNetCard: TEdit
        Left = 99
        Top = 8
        Width = 47
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
    end
    object cpStorage: TCategoryPanel
      Top = 271
      Height = 136
      Caption = 'T'#225'rol'#243
      ParentColor = True
      TabOrder = 3
      ExplicitWidth = 320
      object lbFloppyDesc: TLabel
        Left = 16
        Top = 8
        Width = 36
        Height = 13
        Caption = 'Floppy:'
      end
      object lbHDDDesc: TLabel
        Left = 16
        Top = 27
        Width = 61
        Height = 13
        Caption = 'Merevlemez:'
      end
      object lbCDROMDesc: TLabel
        Left = 16
        Top = 46
        Width = 67
        Height = 13
        Caption = 'CD-meghajt'#243':'
      end
      object lbSCSIDesc: TLabel
        Left = 16
        Top = 84
        Width = 66
        Height = 13
        Caption = '&SCSI-vez'#233'rl'#337':'
        FocusControl = edSCSI
      end
      object lbExStorDesc: TLabel
        Left = 16
        Top = 65
        Width = 65
        Height = 13
        Caption = 'K'#252'ls'#337' t'#225'rol'#243'k:'
      end
      object lbExStor: TLabel
        Left = 93
        Top = 65
        Width = 3
        Height = 13
      end
      object lbCDROM: TLabel
        Left = 93
        Top = 46
        Width = 3
        Height = 13
      end
      object lbHDD: TLabel
        Left = 93
        Top = 27
        Width = 3
        Height = 13
      end
      object lbFloppy: TLabel
        Left = 93
        Top = 8
        Width = 3
        Height = 13
      end
      object edSCSI: TEdit
        Left = 93
        Top = 84
        Width = 92
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
    end
    object cpSound: TCategoryPanel
      Top = 193
      Height = 78
      Caption = 'Audi'#243
      ParentColor = True
      TabOrder = 4
      ExplicitWidth = 320
      object lbSndCardDesc: TLabel
        Left = 16
        Top = 8
        Width = 61
        Height = 13
        Caption = '&Hangeszk'#246'z:'
        FocusControl = edSndCard
      end
      object lbMidiDesc: TLabel
        Left = 16
        Top = 27
        Width = 62
        Height = 13
        Caption = 'M&IDI eszk'#246'z:'
        FocusControl = edMidi
      end
      object edMidi: TEdit
        Left = 93
        Top = 27
        Width = 25
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object edSndCard: TEdit
        Left = 93
        Top = 8
        Width = 25
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
    end
    object cpVideo: TCategoryPanel
      Top = 115
      Height = 78
      Caption = 'K'#233'perny'#337
      ParentColor = True
      TabOrder = 5
      ExplicitWidth = 320
      object lbGfxCardDesc: TLabel
        Left = 16
        Top = 8
        Width = 61
        Height = 13
        Caption = '&Vide'#243'k'#225'rtya:'
        FocusControl = edGfxCard
      end
      object lb3dfxDesc: TLabel
        Left = 16
        Top = 27
        Width = 64
        Height = 13
        Caption = '&3D gyors'#237't'#225's:'
        FocusControl = ed3dfx
      end
      object ed3dfx: TEdit
        Left = 93
        Top = 27
        Width = 25
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object edGfxCard: TEdit
        Left = 93
        Top = 8
        Width = 111
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
    end
    object cpSystem: TCategoryPanel
      Top = 0
      Height = 115
      Caption = 'Rendszer'
      ParentColor = True
      TabOrder = 6
      ExplicitWidth = 320
      object lbMachineDesc: TLabel
        Left = 16
        Top = 8
        Width = 29
        Height = 13
        Caption = '&T'#237'pus:'
        FocusControl = edMachine
      end
      object lbMemoryDesc: TLabel
        Left = 16
        Top = 27
        Width = 44
        Height = 13
        Caption = 'Mem'#243'ria:'
      end
      object lbCPUDesc: TLabel
        Left = 16
        Top = 46
        Width = 56
        Height = 13
        Caption = '&Processzor:'
        FocusControl = edCPU
      end
      object lbEmulatorDesc: TLabel
        Left = 16
        Top = 65
        Width = 46
        Height = 13
        Caption = 'Em&ul'#225'tor:'
        FocusControl = edEmulator
      end
      object lbMemory: TLabel
        Left = 80
        Top = 27
        Width = 3
        Height = 13
      end
      object edEmulator: TEdit
        Tag = 1
        Left = 80
        Top = 65
        Width = 30
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 0
      end
      object edMachine: TEdit
        Left = 80
        Top = 8
        Width = 34
        Height = 13
        Hint = 'Machine.machine'
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object edCPU: TEdit
        Left = 80
        Top = 46
        Width = 50
        Height = 13
        AutoSize = False
        BorderStyle = bsNone
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object btnPrinter: TButton
    Tag = 2
    Left = 401
    Top = 312
    Width = 115
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Nyomtat'#243't'#225'lca...'
    TabOrder = 1
    OnClick = btnWorkDirClick
  end
  object RightPanel: TPanel
    AlignWithMargins = True
    Left = 338
    Top = 44
    Width = 178
    Height = 253
    Margins.Right = 10
    Margins.Bottom = 8
    Align = alRight
    BevelEdges = []
    BevelOuter = bvNone
    Constraints.MinHeight = 170
    Constraints.MinWidth = 170
    DoubleBuffered = True
    ParentBackground = False
    ParentColor = True
    ParentDoubleBuffered = False
    TabOrder = 2
    DesignSize = (
      178
      253)
    object lbNone: TLabel
      Left = 11
      Top = 37
      Width = 162
      Height = 101
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = '(nincs)'
      Layout = tlCenter
      ExplicitWidth = 168
      ExplicitHeight = 113
    end
    object lbHostCPU: TLabel
      Left = 112
      Top = 144
      Width = 61
      Height = 26
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0%'
      ExplicitTop = 156
    end
    object lbHostCPUDesc: TLabel
      Left = 11
      Top = 144
      Width = 78
      Height = 26
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = '&CPU:'
      ExplicitTop = 156
    end
    object lbHostMemoryRAM: TLabel
      Left = 11
      Top = 186
      Width = 86
      Height = 27
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = '&Mem'#243'ria:'
      ExplicitTop = 198
    end
    object lbHostRAM: TLabel
      Left = 80
      Top = 186
      Width = 93
      Height = 27
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0% (0 B)'
      ExplicitTop = 198
    end
    object lbScreenshots: TLabel
      Tag = 3
      Left = 11
      Top = 12
      Width = 88
      Height = 19
      Cursor = crHandPoint
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = '&K'#233'perny'#337'k'#233'pek:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      StyleElements = [seClient, seBorder]
      OnClick = btnWorkDirClick
    end
    object lbDiskSizeDesc: TLabel
      Left = 11
      Top = 232
      Width = 118
      Height = 13
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'Elfoglalt lemezter'#252'let:'
      ExplicitTop = 244
    end
    object lbDiskSize: TLabel
      Left = 120
      Top = 232
      Width = 53
      Height = 21
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      AutoSize = False
      Caption = '0 MB'
      ExplicitTop = 244
    end
    object bvScreenshots: TBevel
      Left = 11
      Top = 37
      Width = 162
      Height = 101
      Anchors = [akLeft, akTop, akRight, akBottom]
      ExplicitWidth = 168
      ExplicitHeight = 113
    end
    object pbHostCPU: TProgressBar
      Left = 11
      Top = 163
      Width = 162
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 0
    end
    object pbHostRAM: TProgressBar
      Left = 11
      Top = 205
      Width = 162
      Height = 17
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 1
    end
    object btnImgNext: TButton
      Left = 139
      Top = 6
      Width = 33
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '>'
      Enabled = False
      TabOrder = 2
    end
    object btnImgPrev: TButton
      Left = 105
      Top = 6
      Width = 33
      Height = 25
      Anchors = [akTop, akRight]
      Caption = '<'
      Enabled = False
      TabOrder = 3
    end
  end
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 15854306
    ParentBackground = False
    TabOrder = 4
    object btnWorkDir: TSpeedButton
      Tag = 1
      Left = 0
      Top = 0
      Width = 526
      Height = 41
      HelpType = htKeyword
      HelpKeyword = '    Ismeretlen PC'
      Align = alClient
      Caption = '  Ismeretlen PC'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Margin = 0
      ParentFont = False
      StyleElements = [seClient, seBorder]
      OnClick = btnWorkDirClick
      ExplicitHeight = 38
    end
  end
  object DelayChange: TTimer
    Interval = 500
    OnTimer = DelayChangeTimer
    Left = 248
    Top = 168
  end
end
