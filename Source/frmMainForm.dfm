object WinBoxMain: TWinBoxMain
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  Caption = 'WinBox for 86Box'
  ClientHeight = 448
  ClientWidth = 703
  Color = clBtnFace
  Constraints.MinHeight = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  ParentBiDiMode = False
  OnActivate = FormFirstActivate
  OnAfterMonitorDpiChanged = FormAfterMonitorDpiChanged
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 209
    Top = 104
    Height = 325
    OnMoved = SplitterMoved
    ExplicitLeft = 210
    ExplicitTop = 98
  end
  object List: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 107
    Width = 206
    Height = 319
    Margins.Right = 0
    Style = lbOwnerDrawFixed
    Align = alLeft
    BiDiMode = bdLeftToRight
    Enabled = False
    ItemHeight = 48
    ParentBiDiMode = False
    TabOrder = 0
    OnContextPopup = ListContextPopup
    OnDblClick = ListDblClick
    OnDrawItem = ListDrawItem
    OnKeyDown = ListKeyDown
    OnKeyUp = ListKeyUp
    OnMouseDown = ListMouseDown
  end
  object Pages: TPageControl
    Left = 212
    Top = 104
    Width = 491
    Height = 325
    ActivePage = tabHome
    Align = alClient
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object tabHome: TTabSheet
      Caption = 'Kezd'#337'lap'
      DesignSize = (
        483
        297)
      object lbWelcomeTip: TLabel
        Left = 19
        Top = 45
        Width = 288
        Height = 249
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Caption = 
          'Az ablak bal oldal'#225'n l'#233'v'#337' list'#225'ban l'#225'thatja a "Terhel'#233'sfigyel'#337'" ' +
          'alatt a sz'#225'm'#237't'#243'g'#233'pen l'#233'trehozott virtu'#225'lis g'#233'peket. '#13#10#13#10'Ha m'#233'g n' +
          'em rendelkezik ilyennel, az "'#218'j virtu'#225'lis g'#233'p l'#233'trehoz'#225'sa..." me' +
          'n'#252'pontban, vagy az "'#218'j g'#233'p" eszk'#246'zt'#225'ri gombbal l'#233'trehozhat egyet' +
          '.'#13#10#13#10'Ha seg'#237'ts'#233'gre van sz'#252'ks'#233'ge haszn'#225'lja a "S'#250'g'#243'" men'#252' lehet'#337's'#233 +
          'geit.'
        WordWrap = True
        ExplicitWidth = 272
        ExplicitHeight = 208
      end
      object lbWelcome: TLabel
        Left = 19
        Top = 16
        Width = 288
        Height = 16
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'K'#246'sz'#246'nti '#246'nt a WinBox for 86Box!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ImgWelcome: TImage
        Left = 321
        Top = 16
        Width = 142
        Height = 145
        Anchors = [akTop, akRight]
        Proportional = True
      end
    end
    object tabPerfMon: TTabSheet
      Caption = 'Teljes'#237'tm'#233'nyfigyel'#337
      ImageIndex = 1
      object pgCharts: TPageControl
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 463
        Height = 230
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        ActivePage = tabCPU
        Align = alClient
        TabOrder = 0
        object tabCPU: TTabSheet
          Caption = 'Gazdag'#233'p processzor'
          object ChartCPU: TChart
            Left = 0
            Top = 0
            Width = 455
            Height = 202
            Legend.CheckBoxes = True
            Title.Text.Strings = (
              'A virtu'#225'lis g'#233'pek terhel'#233'se a gazdag'#233'pen')
            BottomAxis.Automatic = False
            BottomAxis.AutomaticMaximum = False
            BottomAxis.AutomaticMinimum = False
            BottomAxis.Axis.Width = 1
            BottomAxis.Maximum = 60.000000000000000000
            BottomAxis.Minimum = 1.000000000000000000
            BottomAxis.RoundFirstLabel = False
            BottomAxis.Title.Caption = 'Id'#337' [s]'
            ClipPoints = False
            LeftAxis.Automatic = False
            LeftAxis.AutomaticMaximum = False
            LeftAxis.AutomaticMinimum = False
            LeftAxis.Axis.Width = 1
            LeftAxis.Maximum = 100.000000000000000000
            LeftAxis.Title.Caption = 'Terhel'#233's [%]'
            RightAxis.Automatic = False
            RightAxis.AutomaticMaximum = False
            RightAxis.AutomaticMinimum = False
            RightAxis.Visible = False
            TopAxis.Visible = False
            View3D = False
            Align = alClient
            BevelOuter = bvNone
            Color = clWindow
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            PrintMargins = (
              15
              28
              15
              28)
            ColorPaletteIndex = 13
          end
        end
        object tabRAM: TTabSheet
          Caption = 'Gazdag'#233'p mem'#243'ria'
          ImageIndex = 1
          object ChartRAM: TChart
            Left = 0
            Top = 0
            Width = 455
            Height = 202
            Legend.CheckBoxes = True
            Title.Text.Strings = (
              'A virtu'#225'lis g'#233'pek mem'#243'ri'#225'ja a gazdag'#233'pen')
            BottomAxis.Automatic = False
            BottomAxis.AutomaticMaximum = False
            BottomAxis.AutomaticMinimum = False
            BottomAxis.Axis.Width = 1
            BottomAxis.Maximum = 60.000000000000000000
            BottomAxis.Minimum = 1.000000000000000000
            BottomAxis.RoundFirstLabel = False
            BottomAxis.Title.Caption = 'Id'#337' [s]'
            ClipPoints = False
            LeftAxis.Automatic = False
            LeftAxis.AutomaticMaximum = False
            LeftAxis.AutomaticMinimum = False
            LeftAxis.Axis.Width = 1
            LeftAxis.Maximum = 100.000000000000000000
            LeftAxis.Title.Caption = 'Terhel'#233's [%]'
            RightAxis.Automatic = False
            RightAxis.AutomaticMaximum = False
            RightAxis.AutomaticMinimum = False
            RightAxis.Visible = False
            TopAxis.Visible = False
            View3D = False
            Align = alClient
            BevelOuter = bvNone
            Color = clWindow
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            PrintMargins = (
              15
              28
              15
              28)
            ColorPaletteIndex = 13
          end
        end
        object tabVMs: TTabSheet
          Caption = 'Fut'#243' virtu'#225'lis g'#233'pek'
          ImageIndex = 2
          object ChartVMs: TChart
            Left = 0
            Top = 0
            Width = 455
            Height = 202
            Legend.CheckBoxes = True
            Title.Text.Strings = (
              'Egyidej'#369'leg fut'#243' virtu'#225'lis g'#233'pek')
            BottomAxis.Automatic = False
            BottomAxis.AutomaticMaximum = False
            BottomAxis.AutomaticMinimum = False
            BottomAxis.Axis.Width = 1
            BottomAxis.Maximum = 60.000000000000000000
            BottomAxis.Minimum = 1.000000000000000000
            BottomAxis.RoundFirstLabel = False
            BottomAxis.Title.Caption = 'Id'#337' [s]'
            ClipPoints = False
            LeftAxis.Axis.Width = 1
            LeftAxis.Increment = 1.000000000000000000
            LeftAxis.Title.Caption = 'Virtu'#225'lis g'#233'pek [db]'
            RightAxis.Automatic = False
            RightAxis.AutomaticMaximum = False
            RightAxis.AutomaticMinimum = False
            RightAxis.Visible = False
            TopAxis.Visible = False
            View3D = False
            Align = alClient
            BevelOuter = bvNone
            Color = clWindow
            TabOrder = 0
            DefaultCanvas = 'TGDIPlusCanvas'
            PrintMargins = (
              15
              28
              15
              28)
            ColorPaletteIndex = 13
          end
        end
      end
      object pnpBottom: TPanel
        Left = 0
        Top = 250
        Width = 483
        Height = 47
        Align = alBottom
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        OnResize = pnpBottomResize
        object pnpRight: TPanel
          Left = 224
          Top = 0
          Width = 259
          Height = 47
          Align = alRight
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          DesignSize = (
            259
            47)
          object lbHRAM: TLabel
            Left = 0
            Top = 6
            Width = 74
            Height = 26
            Caption = 'Mem'#243'ria: 0,0%'#13#10' (0,00 B)'
          end
          object pbRAM: TProgressBar
            Left = 86
            Top = 11
            Width = 155
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
          end
        end
        object pnpLeft: TPanel
          Left = 0
          Top = 0
          Width = 224
          Height = 47
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            224
            47)
          object lbHCPU: TLabel
            Left = 11
            Top = 14
            Width = 54
            Height = 13
            Caption = 'CPU: 0,0%'
          end
          object pbCPU: TProgressBar
            Left = 80
            Top = 12
            Width = 121
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
          end
        end
      end
    end
    object tab86Box: TTabSheet
      Caption = '86Box VM-ek'
      ImageIndex = 2
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 429
    Width = 703
    Height = 19
    BiDiMode = bdLeftToRight
    Panels = <>
    ParentBiDiMode = False
    SimplePanel = True
  end
  object tbGlobal: TToolBar
    Left = 0
    Top = 52
    Width = 703
    Height = 52
    ButtonHeight = 52
    ButtonWidth = 77
    Caption = 'tbGlobal'
    DoubleBuffered = False
    DrawingStyle = dsGradient
    Images = IconSet.Icons32
    ParentDoubleBuffered = False
    TabOrder = 3
    Transparent = True
    object tbNewVM: TToolButton
      Tag = 9
      Left = 0
      Top = 0
      Action = acNewVM
    end
    object tbNewHDD: TToolButton
      Tag = 10
      Left = 77
      Top = 0
      Action = acNewHDD
    end
    object ToolButton3: TToolButton
      Left = 154
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 13
      ImageName = '13 - move'
      Style = tbsSeparator
    end
    object tbStopAll: TToolButton
      Tag = 11
      Left = 162
      Top = 0
      Action = acStopAll
    end
    object tbUpdateList: TToolButton
      Tag = 12
      Left = 239
      Top = 0
      Action = acUpdateList
    end
    object tbProgSettDlg: TToolButton
      Tag = 13
      Left = 316
      Top = 0
      Action = acProgramSettings
    end
    object ToolButton12: TToolButton
      Left = 393
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 0
      ImageName = '0 - warning'
      Style = tbsSeparator
    end
    object tbAbout2: TToolButton
      Tag = 8
      Left = 401
      Top = 0
      Action = acAbout
    end
  end
  object tbVMs: TToolBar
    Left = 0
    Top = 0
    Width = 703
    Height = 52
    ButtonHeight = 52
    ButtonWidth = 78
    Caption = 'tbVMs'
    DoubleBuffered = False
    DrawingStyle = dsGradient
    Images = IconSet.Icons32
    ParentDoubleBuffered = False
    TabOrder = 4
    Transparent = True
    Visible = False
    object tbStart: TToolButton
      Tag = 1
      Left = 0
      Top = 0
      Action = acStart
    end
    object tbStop: TToolButton
      Tag = 2
      Left = 78
      Top = 0
      Action = acStop
    end
    object ToolButton4: TToolButton
      Left = 156
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 13
      ImageName = '13 - move'
      Style = tbsSeparator
    end
    object tbCtrlAltDel: TToolButton
      Tag = 3
      Left = 164
      Top = 0
      Action = acCtrlAltDel
    end
    object tbHWReset: TToolButton
      Tag = 4
      Left = 242
      Top = 0
      Action = acHWReset
    end
    object tbSettings: TToolButton
      Tag = 5
      Left = 320
      Top = 0
      Action = ac86BoxSettings
    end
    object ToolButton9: TToolButton
      Left = 398
      Top = 0
      Width = 8
      Caption = 'ToolButton11'
      ImageIndex = 13
      ImageName = '13 - move'
      Style = tbsSeparator
    end
    object tbBringToFront: TToolButton
      Tag = 6
      Left = 406
      Top = 0
      Action = acBringToFront
    end
    object tbPrinterTray: TToolButton
      Tag = 7
      Left = 484
      Top = 0
      Action = acOpenPrinterTray
    end
    object ToolButton13: TToolButton
      Left = 562
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 0
      ImageName = '0 - warning'
      Style = tbsSeparator
    end
    object tbAbout1: TToolButton
      Tag = 8
      Left = 570
      Top = 0
      Action = acAbout
    end
  end
  object Actions: TActionList
    Images = IconSet.Icons16
    Left = 616
    Top = 232
    object acAutoUpdate: TAction
      Tag = 3
      Category = 'Eszk'#246'z'#246'k'
      Caption = 'Emul'#225'tor &friss'#237't'#233'sek keres'#233'se...'
      ImageIndex = 27
      ImageName = '27 - update'
      ShortCut = 16469
      OnExecute = acFileExecute
      OnUpdate = acGlobalUpdate
    end
    object acDbgRTTILogFile: TAction
      Tag = 10
      Category = 'Hibakeres'#233's'
      Caption = 'R&TTI-adatok ment'#233'se napl'#243'f'#225'jlba...'
      ImageIndex = 33
      ImageName = '33 - debug_start'
      OnExecute = acDebugExecute
    end
    object acDiskDatabase: TAction
      Tag = 4
      Category = 'Eszk'#246'z'#246'k'
      Caption = 'Merevlemez &adatb'#225'zis megnyit'#225'sa...'
      ImageIndex = 10
      ImageName = '10 - hdd'
      OnExecute = acFileExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acDbgNameDefsFile: TAction
      Tag = -1
      Category = 'Hibakeres'#233's'
      Caption = '&N'#233'vdefin'#237'ci'#243's f'#225'jl elment'#233'se...'
      OnExecute = acDebugExecute
      OnUpdate = acVMsUpdate
    end
    object acDbgGetCmdLine: TAction
      Tag = 13
      Category = 'Hibakeres'#233's'
      Caption = '&A program parancssor'#225'nak lek'#233'rdez'#233'se...'
      OnExecute = acDebugExecute
    end
    object acDbgGetProgLocale: TAction
      Tag = 12
      Category = 'Hibakeres'#233's'
      Caption = 'A &program nyelv'#233'nek lek'#233'rdez'#233'se...'
      OnExecute = acDebugExecute
    end
    object acDbgGetSysLocale: TAction
      Tag = 11
      Category = 'Hibakeres'#233's'
      Caption = 'A &rendszer nyelv'#233'nek lek'#233'rdez'#233'se...'
      OnExecute = acDebugExecute
    end
    object acNewVM: TAction
      Tag = 2
      Category = 'F'#225'jl'
      Caption = '&'#218'j virtu'#225'lis g'#233'p l'#233'trehoz'#225'sa...'
      ImageIndex = 14
      ImageName = '14 - new'
      ShortCut = 24654
      OnExecute = acFileExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acNewFloppy: TAction
      Tag = 5
      Category = 'F'#225'jl'
      Caption = #218'j &hajl'#233'konylemez k'#233'pf'#225'jl l'#233'trehoz'#225'sa...'
      ImageIndex = 34
      ImageName = '34 - new_floppy'
      ShortCut = 41030
      OnExecute = acFileExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acNewHDD: TAction
      Tag = 6
      Category = 'F'#225'jl'
      Caption = #218'j virtu'#225'lis merev&lemez l'#233'trehoz'#225'sa...'
      ImageIndex = 28
      ImageName = '28 - new_hdd'
      ShortCut = 41038
      OnExecute = acFileExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acImportVM: TAction
      Tag = 1
      Category = 'F'#225'jl'
      Caption = 'Megl'#233'v'#337' virtu'#225'lis g'#233'p &import'#225'l'#225'sa...'
      ShortCut = 24649
      OnExecute = acFileExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acDbgFolderChg: TAction
      Tag = 14
      Category = 'WinBox-folyamatmonitor'
      Caption = 'T&FolderMonitor.OnChange esem'#233'nyh'#237'v'#225'sok'
      ImageIndex = 33
      ImageName = '33 - debug_start'
      OnExecute = acDebugExecute
    end
    object acStopAll: TAction
      Tag = 1
      Category = 'F'#225'jl'
      Caption = 'Az &'#246'sszes virtu'#225'lis g'#233'p le'#225'll'#237't'#225'sa...'
      HelpContext = 1
      ImageIndex = 20
      ImageName = '20 - stop_all'
      OnExecute = acGlobalExecute
      OnUpdate = acGlobalUpdate
    end
    object acStop: TAction
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p &le'#225'll'#237't'#225'sa...'
      ImageIndex = 19
      ImageName = '19 - stop'
      ShortCut = 115
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acStopForced: TAction
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p &k'#233'nyszer'#237'tett le'#225'll'#237't'#225'sa...'
      HelpContext = 1
      ShortCut = 16499
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acStopAllForced: TAction
      Tag = 2
      Category = 'F'#225'jl'
      Caption = 'Az '#246'sszes virtu'#225'lis g'#233'p &k'#233'nyszer'#237'tett le'#225'll'#237't'#225'sa...'
      HelpContext = 1
      OnExecute = acGlobalExecute
      OnUpdate = acGlobalUpdate
    end
    object acStart: TAction
      Tag = 1
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p &ind'#237't'#225'sa...'
      ImageIndex = 18
      ImageName = '18 - start'
      ShortCut = 114
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acPause: TAction
      Tag = 2
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p &sz'#252'nteltet'#233'se...'
      ShortCut = 16498
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acBringToFront: TAction
      Tag = -2
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p &el'#337't'#233'rbe hoz'#225'sa...'
      HelpContext = 1
      ImageIndex = 24
      ImageName = '24 - bringtofront'
      ShortCut = 8306
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acCtrlAltEsc: TAction
      Tag = -2
      Category = 'G'#233'p'
      Caption = 'Ctrl+Alt+&Esc k'#252'ld'#233'se...'
      HelpContext = 3
      ShortCut = 16411
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acCtrlAltDel: TAction
      Tag = -2
      Category = 'G'#233'p'
      Caption = 'Ctrl+Alt+&Del k'#252'ld'#233'se...'
      HelpContext = 2
      ImageIndex = 2
      ImageName = '2 - cad'
      ShortCut = 16430
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acHWReset: TAction
      Tag = -2
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p hardveres &'#250'jraind'#237't'#225'sa...'
      HelpContext = 4
      ImageIndex = 25
      ImageName = '25 - hwreset'
      ShortCut = 16466
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acOpenScreenshots: TAction
      Tag = -5
      Category = 'G'#233'p'
      Caption = '&K'#233'perny'#337'k'#233'pek megnyit'#225'sa...'
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acOpenPrinterTray: TAction
      Tag = -4
      Category = 'G'#233'p'
      Caption = '&Nyomtat'#243't'#225'lca megnyit'#225'sa...'
      ImageIndex = 15
      ImageName = '15 - print'
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acOpenWorkDir: TAction
      Tag = -3
      Category = 'G'#233'p'
      Caption = '&Munkak'#246'nyvt'#225'r megnyit'#225'sa...'
      ImageIndex = 8
      ImageName = '8 - folder'
      ShortCut = 119
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object aDbgErrAccViol: TAction
      Category = 'Hibakezel'#233's'
      Caption = 'Kiv'#233'tel feldob'#225'sa: EAccess&Violation...'
      OnExecute = acErrorExecute
    end
    object aDbgErrConvErr: TAction
      Tag = 1
      Category = 'Hibakezel'#233's'
      Caption = 'Kiv'#233'tel feldob'#225'sa: E&ConvertError...'
      OnExecute = acErrorExecute
    end
    object aDbgErrExcept: TAction
      Tag = 2
      Category = 'Hibakezel'#233's'
      Caption = 'Kiv'#233'tel feldob'#225'sa: &Exception...'
      OnExecute = acErrorExecute
    end
    object aDbgErrSystem: TAction
      Tag = 3
      Category = 'Hibakezel'#233's'
      Caption = 'Kiv'#233'tel feldob'#225'sa: E&OSError...'
      OnExecute = acErrorExecute
    end
    object acDbgProcList: TAction
      Tag = 1
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProcessMonitor: folyamat&lista k'#233'sz'#237't'#233'se'
      OnExecute = acDebugExecute
    end
    object acProfileSettings: TAction
      Tag = -1
      Category = 'G'#233'p'
      Caption = '&Profilbe'#225'll'#237't'#225'sok...'
      HelpContext = 1
      ShortCut = 40973
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acDbgDumpList: TAction
      Tag = 2
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProcessMonitor: &teljes folyamat inform'#225'ci'#243'k'
      OnExecute = acDebugExecute
    end
    object acDbgProcUpd: TAction
      Tag = 3
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProcessMonitor.On&Update esem'#233'nyh'#237'v'#225'sok'
      OnExecute = acDebugExecute
    end
    object acDbgProcChg: TAction
      Tag = 4
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProcessMonitor.On&Change esem'#233'nyh'#237'v'#225'sok'
      OnExecute = acDebugExecute
    end
    object acDbgProcOps: TAction
      Tag = 5
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProfile.Start, Stop, ..., &esem'#233'nyek gener'#225'l'#225'sa'
      OnExecute = acDebugExecute
    end
    object acDbgPrfAsgn: TAction
      Tag = 6
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProfile.UpdatePIDs &hozz'#225'rendel'#233'sek lek'#246'vet'#233'se'
      OnExecute = acDebugExecute
    end
    object acDbgMonData: TAction
      Tag = 7
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProfile.Create&DataField tal'#225'latok ki'#237'rat'#225'sa'
      OnExecute = acDebugExecute
    end
    object acDbgMonQuery: TAction
      Tag = 8
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProcessMonitor: &Query mez'#337' ki'#237'rat'#225'sa'
      OnExecute = acDebugExecute
    end
    object acDbgProfChg: TAction
      Tag = 9
      Category = 'WinBox-folyamatmonitor'
      Caption = 'TProcess&Profile.OnChange esem'#233'nyh'#237'v'#225'sok'
      OnExecute = acDebugExecute
    end
    object acProgramSettings: TAction
      Category = 'Eszk'#246'z'#246'k'
      Caption = 'P&rogrambe'#225'll'#237't'#225'sok...'
      ImageIndex = 29
      ImageName = '29 - gears2'
      ShortCut = 49165
      OnExecute = acProgramSettingsExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acUpdateList: TAction
      Category = 'N'#233'zet'
      Caption = 'Virtu'#225'lis g'#233'pek list'#225'j'#225'nak &friss'#237't'#233'se'
      ImageIndex = 16
      ImageName = '16 - reload'
      ShortCut = 16500
      OnExecute = acUpdateListExecute
      OnUpdate = acWaitFirstUpdate
    end
    object aDbgErrorMath: TAction
      Tag = 4
      Category = 'Hibakezel'#233's'
      Caption = 'Kiv'#233'tel feldob'#225'sa: E&MathError...'
      OnExecute = acErrorExecute
    end
    object acDbgErrInvCast: TAction
      Tag = 5
      Category = 'Hibakezel'#233's'
      Caption = 'Kiv'#233'tel feldob'#225'sa: E&InvalidCast...'
      OnExecute = acErrorExecute
    end
    object acAbout: TAction
      Tag = -1
      Category = 'S'#250'g'#243
      Caption = '&N'#233'vjegy...'
      ImageIndex = 12
      ImageName = '12 - logo_v2'
      ShortCut = 112
      OnExecute = acFileExecute
      OnUpdate = acWaitFirstUpdate
    end
    object ac86BoxSettings: TAction
      Tag = -1
      Category = 'G'#233'p'
      Caption = '&Hardverkonfigur'#225'ci'#243'...'
      HelpContext = 2
      ImageIndex = 9
      ImageName = '9 - gears'
      ShortCut = 32781
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acClose: TAction
      Category = 'F'#225'jl'
      Caption = '&Kil'#233'p'#233's a WinBox for 86Box alkalmaz'#225'sb'#243'l'
      ImageIndex = 4
      ImageName = '4 - close2'
      OnExecute = acCloseExecute
    end
    object acDbgLanguageFile: TAction
      Tag = -2
      Category = 'Hibakeres'#233's'
      Caption = '&Jelenlegi nyelvi f'#225'jl ment'#233'se...'
      OnExecute = acSaveLangFile
    end
    object acUpdateFull: TAction
      Tag = -9
      Category = 'G'#233'p'
      Caption = 'Virtu'#225'lis g'#233'p &inform'#225'ci'#243'k friss'#237't'#233'se'
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acChangeColor: TAction
      Tag = -7
      Category = 'G'#233'p'
      Caption = '&H'#225'tt'#233'rsz'#237'n megv'#225'ltoztat'#225'sa...'
      ImageIndex = 5
      ImageName = '5 - colorsphere'
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acResetColor: TAction
      Tag = -8
      Category = 'G'#233'p'
      Caption = 'H'#225'tt'#233'rsz'#237'n &vissza'#225'll'#237't'#225'sa'
      OnExecute = acVMsExecute
      OnUpdate = acVMsUpdate
    end
    object acUpdateTools: TAction
      Category = 'N'#233'zet'
      Caption = 'Fel&haszn'#225'l'#243'i eszk'#246'z'#246'k list'#225'j'#225'nak friss'#237't'#233'se'
      ShortCut = 24692
      OnExecute = acUpdateToolsExecute
      OnUpdate = acWaitFirstUpdate
    end
    object acDeleteVM: TAction
      Tag = -127
      Category = 'F'#225'jl'
      Caption = 'A kijel'#246'lt virtu'#225'lis g'#233'p &elt'#225'vol'#237't'#225'sa...'
      ImageIndex = 6
      ImageName = '6 - delete'
      ShortCut = 24622
      OnExecute = acDeleteVMExecute
      OnUpdate = acVMsUpdate
    end
    object acWinBoxUpdate: TAction
      Category = 'Eszk'#246'z'#246'k'
      Caption = 'Programfri&ss'#237't'#233'sek keres'#233'se...'
      ShortCut = 24661
      OnExecute = acWinBoxUpdateExecute
    end
  end
  object MainMenu: TMainMenu
    Images = IconSet.Icons16
    Left = 584
    Top = 280
    object miFile: TMenuItem
      Caption = '&F'#225'jl'
      object jvirtulisgpltrehozsa2: TMenuItem
        Action = acNewVM
      end
      object jvirtulismerevlemezltrehozsa2: TMenuItem
        Action = acNewHDD
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object acImportVM1: TMenuItem
        Action = acImportVM
      end
      object jhajlkonylemezkpfjlltrehozsa1: TMenuItem
        Action = acNewFloppy
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object Azsszesvirtulisgplelltsa1: TMenuItem
        Action = acStopAll
      end
      object Azsszesvirtulisgpknyszertettlelltsa1: TMenuItem
        Action = acStopAllForced
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object Akijelltvirtulisgpeltvoltsa1: TMenuItem
        Action = acDeleteVM
      end
      object N39: TMenuItem
        Caption = '-'
      end
      object Kilps1: TMenuItem
        Action = acClose
        ShortCut = 32883
      end
    end
    object miMachine: TMenuItem
      Caption = '&G'#233'p'
      object acStart1: TMenuItem
        Action = acStart
      end
      object acStart4: TMenuItem
        Action = acPause
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object CtrlAltDelkldse1: TMenuItem
        Action = acCtrlAltDel
      end
      object CtrlAltEsckldse1: TMenuItem
        Action = acCtrlAltEsc
      end
      object Virtulisgphardveresjraindtsa1: TMenuItem
        Action = acHWReset
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Virtulisgplelltsa1: TMenuItem
        Action = acStop
      end
      object acStart3: TMenuItem
        Action = acStopForced
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Hardverbelltsok1: TMenuItem
        Action = ac86BoxSettings
      end
      object acProfileSettings1: TMenuItem
        Action = acProfileSettings
      end
      object N18: TMenuItem
        Caption = '-'
      end
      object Kpernykpekmegnyitsa1: TMenuItem
        Action = acOpenScreenshots
      end
      object Kpernykpekmegnyitsa2: TMenuItem
        Action = acOpenPrinterTray
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object Munkaknyvtrmegnyitsa1: TMenuItem
        Action = acOpenWorkDir
      end
    end
    object miView: TMenuItem
      Caption = '&N'#233'zet'
      object Virtulisgpeltrbehozsa1: TMenuItem
        Action = acBringToFront
      end
      object Virtulisgpinformcikfrisstse1: TMenuItem
        Action = acUpdateFull
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object Httrsznmegvltoztatsa1: TMenuItem
        Action = acChangeColor
      end
      object Httrsznvisszalltsa1: TMenuItem
        Action = acResetColor
      end
      object N34: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Action = acUpdateList
      end
      object Felhasznlieszkzklistjnakfrisstse1: TMenuItem
        Action = acUpdateTools
      end
    end
    object miTools: TMenuItem
      Caption = '&Eszk'#246'z'#246'k'
      object Emultorfrisstsekkeresse1: TMenuItem
        Action = acAutoUpdate
      end
      object Programfrisstsekkeresse1: TMenuItem
        Action = acWinBoxUpdate
      end
      object N42: TMenuItem
        Caption = '-'
      end
      object miPerfCPU1: TMenuItem
        Caption = '&Processzorterhel'#233's'
        ImageIndex = 22
        ImageName = '22 - cpu'
        object miShow1: TMenuItem
          Caption = '&Megjelen'#237't'#233's...'
          HelpContext = 1
          ShortCut = 120
          OnClick = btnChartClick
        end
        object N27: TMenuItem
          Caption = '-'
        end
        object miPrint1: TMenuItem
          Caption = '&Nyomtat'#225's...'
          HelpContext = 2
          ImageIndex = 15
          ImageName = '15 - print'
          OnClick = btnChartClick
        end
        object miExportBitmap1: TMenuItem
          Caption = 'Export'#225'l'#225's &bitk'#233'pk'#233'nt...'
          HelpContext = 3
          OnClick = btnChartClick
        end
        object miExportMetafile1: TMenuItem
          Caption = 'E&xport'#225'l'#225's metaf'#225'jlk'#233'nt...'
          HelpContext = 4
          OnClick = btnChartClick
        end
      end
      object miPerfRAM1: TMenuItem
        Caption = 'Lefoglalt &mem'#243'ria'
        ImageIndex = 23
        ImageName = '23 - memory'
        object miShow2: TMenuItem
          Tag = 1
          Caption = '&Megjelen'#237't'#233's...'
          HelpContext = 1
          ShortCut = 121
          OnClick = btnChartClick
        end
        object N28: TMenuItem
          Caption = '-'
        end
        object miPrint2: TMenuItem
          Tag = 1
          Caption = '&Nyomtat'#225's...'
          HelpContext = 2
          ImageIndex = 15
          ImageName = '15 - print'
          OnClick = btnChartClick
        end
        object miExportBitmap2: TMenuItem
          Tag = 1
          Caption = 'Export'#225'l'#225's &bitk'#233'pk'#233'nt...'
          HelpContext = 3
          OnClick = btnChartClick
        end
        object miExportMetafile2: TMenuItem
          Tag = 1
          Caption = 'E&xport'#225'l'#225's metaf'#225'jlk'#233'nt...'
          HelpContext = 4
          OnClick = btnChartClick
        end
      end
      object miPerfVMs1: TMenuItem
        Caption = 'Fut'#243' virtu'#225'lis g'#233'pek &sz'#225'ma'
        ImageIndex = 21
        ImageName = '21 - empty'
        object miShow3: TMenuItem
          Tag = 2
          Caption = '&Megjelen'#237't'#233's...'
          HelpContext = 1
          ShortCut = 123
          OnClick = btnChartClick
        end
        object N29: TMenuItem
          Caption = '-'
        end
        object miPrint3: TMenuItem
          Tag = 2
          Caption = '&Nyomtat'#225's...'
          HelpContext = 2
          ImageIndex = 15
          ImageName = '15 - print'
          OnClick = btnChartClick
        end
        object miExportBitmap3: TMenuItem
          Tag = 2
          Caption = 'Export'#225'l'#225's &bitk'#233'pk'#233'nt...'
          HelpContext = 3
          OnClick = btnChartClick
        end
        object miExportMetafile3: TMenuItem
          Tag = 2
          Caption = 'E&xport'#225'l'#225's metaf'#225'jlk'#233'nt...'
          HelpContext = 4
          OnClick = btnChartClick
        end
      end
      object N30: TMenuItem
        Caption = '-'
      end
      object Programbelltsok1: TMenuItem
        Action = acProgramSettings
      end
      object miSepUserTools: TMenuItem
        Caption = '-'
      end
      object miUserTools: TMenuItem
        Caption = 'Felhaszn'#225'l'#243'i &eszk'#246'z'#246'k'
      end
      object N41: TMenuItem
        Caption = '-'
      end
      object Merevlemezadatbzismegnyitsa1: TMenuItem
        Action = acDiskDatabase
      end
    end
    object miDebug: TMenuItem
      Caption = '&Hibakeres'#233's'
      object N25: TMenuItem
        Action = acDbgGetCmdLine
        ImageIndex = 11
        ImageName = '11 - info'
      end
      object N26: TMenuItem
        Caption = '-'
      end
      object Arendszernyelvneklekrdezse1: TMenuItem
        Action = acDbgGetSysLocale
      end
      object Aprogramnyelvneklekrdezse1: TMenuItem
        Action = acDbgGetProgLocale
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object Nvdefincisfjlelmentse1: TMenuItem
        Action = acDbgNameDefsFile
      end
      object Jelenleginyelvifjlmentse1: TMenuItem
        Action = acDbgLanguageFile
      end
      object N31: TMenuItem
        Caption = '-'
      end
      object FolderMonitorOnChangenaplzsa1: TMenuItem
        Action = acDbgFolderChg
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object miWinBoxMonitor: TMenuItem
        Caption = '&WinBox-folyamatmonitor'
        object acDbgProcList1: TMenuItem
          Action = acDbgProcList
        end
        object acDbgDumpList1: TMenuItem
          Action = acDbgDumpList
        end
        object ProcessMonitorQuerykiratsa1: TMenuItem
          Action = acDbgMonQuery
        end
        object N3: TMenuItem
          Caption = '-'
        end
        object acDbgProcUpd1: TMenuItem
          Action = acDbgProcUpd
        end
        object acDbgProcChg1: TMenuItem
          Action = acDbgProcChg
        end
        object N2: TMenuItem
          Caption = '-'
        end
        object acDbgProcChg2: TMenuItem
          Action = acDbgProcOps
        end
        object acDbgMonData1: TMenuItem
          Action = acDbgMonData
        end
        object acDbgProcChg3: TMenuItem
          Action = acDbgPrfAsgn
        end
        object N1: TMenuItem
          Caption = '-'
        end
        object ProcessProfileOnChangeesemnyhvsok1: TMenuItem
          Action = acDbgProfChg
        end
      end
      object miExceptions: TMenuItem
        Caption = '&Hibakezel'#233's bemutat'#225'sa'
        object KivtelfeldobsaException2: TMenuItem
          Action = aDbgErrExcept
        end
        object KivtelfeldobsaException1: TMenuItem
          Action = aDbgErrSystem
        end
        object KivtelfeldobsaEMathError1: TMenuItem
          Action = aDbgErrorMath
        end
        object KivtelfeldobsaEInvalidCast1: TMenuItem
          Action = acDbgErrInvCast
        end
        object KivtelfeldobsaEAccessViolation1: TMenuItem
          Action = aDbgErrAccViol
        end
        object KivtelfeldobsaEConvertError1: TMenuItem
          Action = aDbgErrConvErr
        end
      end
      object N23: TMenuItem
        Caption = '-'
      end
      object RTTIadatokmentsenaplfjlba1: TMenuItem
        Action = acDbgRTTILogFile
      end
    end
    object miHelp: TMenuItem
      Caption = '&S'#250'g'#243
      object miOnlineDocs1: TMenuItem
        Caption = 'Online dokument'#225'ci'#243': &WinBox for 86Box'
        Hint = 'https://github.com/laciba96/WinBox-for-86Box/wiki'
        ImageIndex = 7
        ImageName = '7 - earth'
        OnClick = acURLExecute
      end
      object miOnlineDocs2: TMenuItem
        Caption = 'Online dokument'#225'ci'#243': &86Box, x86 emulator'
        Hint = 'https://86box.readthedocs.io/en/latest/'
        ImageIndex = 7
        ImageName = '7 - earth'
        OnClick = acURLExecute
      end
      object N43: TMenuItem
        Caption = '-'
      end
      object miOnlineLinks1: TMenuItem
        Caption = 'All&BootDisks: ind'#237't'#243'lemez let'#246'lt'#233'sek'
        Hint = 'https://www.allbootdisks.com/'
        ImageIndex = 26
        ImageName = '26 - download'
        OnClick = acURLExecute
      end
      object miOnlineLinks2: TMenuItem
        Caption = '&ClassicDOSGames: r'#233'gi j'#225't'#233'k let'#246'lt'#233'sek'
        Hint = 'https://www.classicdosgames.com/'
        ImageIndex = 26
        ImageName = '26 - download'
        OnClick = acURLExecute
      end
      object miOnlineLinks3: TMenuItem
        Caption = '&Linux Distros: telep'#237't'#337'lemez let'#246'lt'#233'sek'
        Hint = 'https://www.linux-distros.com/'
        ImageIndex = 26
        ImageName = '26 - download'
        OnClick = acURLExecute
      end
      object miOnlineLinks4: TMenuItem
        Caption = '&Vogon'#39's Drivers: illeszt'#337'program let'#246'lt'#233'sek'
        Hint = 'http://vogonsdrivers.com/'
        ImageIndex = 26
        ImageName = '26 - download'
        OnClick = acURLExecute
      end
      object miOnlineLinks5: TMenuItem
        Caption = 'W&inWorldPC: r'#233'gi szoftver let'#246'lt'#233'sek'
        Hint = 'https://winworldpc.com'
        ImageIndex = 26
        ImageName = '26 - download'
        OnClick = acURLExecute
      end
      object N44: TMenuItem
        Caption = '-'
      end
      object Nvjegy1: TMenuItem
        Action = acAbout
      end
    end
  end
  object VMMenu: TPopupMenu
    Images = IconSet.Icons16
    Left = 616
    Top = 56
    object Virtulisgpindtsa1: TMenuItem
      Action = acStart
    end
    object Virtulisgpszneteltetse1: TMenuItem
      Action = acPause
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object MenuItem1: TMenuItem
      Action = acCtrlAltDel
    end
    object MenuItem2: TMenuItem
      Action = acCtrlAltEsc
    end
    object MenuItem3: TMenuItem
      Action = acHWReset
    end
    object N15: TMenuItem
      Caption = '-'
    end
    object MenuItem4: TMenuItem
      Action = acStop
    end
    object Virtulisgpknyszertettlelltsa1: TMenuItem
      Action = acStopForced
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object Hardverbelltsok2: TMenuItem
      Action = ac86BoxSettings
    end
    object Profilbelltsok1: TMenuItem
      Action = acProfileSettings
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object ovbbilehetsgek1: TMenuItem
      Caption = '&Tov'#225'bbi lehet'#337's'#233'gek'
      object MenuItem5: TMenuItem
        Action = acBringToFront
      end
      object Virtulisgpinformcikfrisstse2: TMenuItem
        Action = acUpdateFull
      end
      object N40: TMenuItem
        Caption = '-'
      end
      object jvirtulismerevlemezltrehozsa3: TMenuItem
        Action = acNewHDD
      end
      object jhajlkonylemezkpfjlltrehozsa3: TMenuItem
        Action = acNewFloppy
      end
      object N45: TMenuItem
        Caption = '-'
      end
      object Httrsznmegvltoztatsa2: TMenuItem
        Action = acChangeColor
      end
      object Httrsznvisszalltsa2: TMenuItem
        Action = acResetColor
      end
      object N20: TMenuItem
        Caption = '-'
      end
      object Kpernykpekmegnyitsa3: TMenuItem
        Action = acOpenScreenshots
      end
      object Nyomtattlcamegnyitsa1: TMenuItem
        Action = acOpenPrinterTray
      end
    end
    object N35: TMenuItem
      Caption = '-'
    end
    object Akijelltvirtulisgpeltvoltsa2: TMenuItem
      Action = acDeleteVM
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object Munkaknyvtrmegnyitsa2: TMenuItem
      Action = acOpenWorkDir
    end
  end
  object HomeMenu: TPopupMenu
    Images = IconSet.Icons16
    Left = 512
    Top = 128
    object jvirtulisgpltrehozsa1: TMenuItem
      Action = acNewVM
    end
    object jvirtulismerevlemezltrehozsa1: TMenuItem
      Action = acNewHDD
    end
    object N32: TMenuItem
      Caption = '-'
    end
    object Meglvvirtulisgpimportlsa1: TMenuItem
      Action = acImportVM
    end
    object jhajlkonylemezkpfjlltrehozsa2: TMenuItem
      Action = acNewFloppy
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Virtulisgplelltsa2: TMenuItem
      Action = acStopAll
    end
    object acStopAllForced1: TMenuItem
      Action = acStopAllForced
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object Emultorfrisstsekkeresse2: TMenuItem
      Action = acAutoUpdate
    end
    object Merevlemezadatbzismegnyitsa2: TMenuItem
      Action = acDiskDatabase
    end
    object N49: TMenuItem
      Caption = '-'
    end
    object Programbelltsok3: TMenuItem
      Action = acProgramSettings
    end
    object Virtulisgpeklistjnakfrisstse1: TMenuItem
      Action = acUpdateList
    end
    object N17: TMenuItem
      Caption = '-'
    end
    object KilpsaWinBoxfor86Boxalkalmazsbl1: TMenuItem
      Action = acClose
    end
  end
  object TrayIcon: TTrayIcon
    PopupMenu = HomeMenu
    OnDblClick = TrayIconDblClick
    Left = 392
    Top = 240
  end
  object AppEvents: TApplicationEvents
    OnMinimize = AppEventsMinimize
    Left = 336
    Top = 216
  end
  object tmrUpdate: TTimer
    OnTimer = tmrUpdateTimer
    Left = 296
    Top = 152
  end
  object SaveLogDialog: TSaveDialog
    DefaultExt = '.log'
    Filter = 
      'Napl'#243'f'#225'jlok (*.log)|*.log|Sz'#246'vegf'#225'jlok (*.txt)|*.txt|Minden f'#225'jl' +
      ' (*.*)|*.*'
    Left = 256
    Top = 208
  end
  object SaveBmp: TSavePictureDialog
    DefaultExt = '.bmp'
    Left = 256
    Top = 256
  end
  object SaveEmf: TSavePictureDialog
    DefaultExt = '.emf'
    Left = 256
    Top = 312
  end
  object PrintDialog: TPrintDialog
    Left = 328
    Top = 312
  end
  object ColorDialog: TColorDialog
    Left = 408
    Top = 320
  end
  object PerfMenu: TPopupMenu
    Images = IconSet.Icons16
    Left = 560
    Top = 56
    object miPerfCPU2: TMenuItem
      Caption = '&Processzorterhel'#233's'
      ImageIndex = 22
      ImageName = '22 - cpu'
      object miShow4: TMenuItem
        Caption = '&Megjelen'#237't'#233's...'
        HelpContext = 1
        ShortCut = 120
        OnClick = btnChartClick
      end
      object N36: TMenuItem
        Caption = '-'
      end
      object miPrint4: TMenuItem
        Caption = '&Nyomtat'#225's...'
        HelpContext = 2
        ImageIndex = 15
        ImageName = '15 - print'
        OnClick = btnChartClick
      end
      object miExportBitmap4: TMenuItem
        Caption = 'Export'#225'l'#225's &bitk'#233'pk'#233'nt...'
        HelpContext = 3
        OnClick = btnChartClick
      end
      object miExportMetafile4: TMenuItem
        Caption = 'E&xport'#225'l'#225's metaf'#225'jlk'#233'nt...'
        HelpContext = 4
        OnClick = btnChartClick
      end
    end
    object miPerfRAM2: TMenuItem
      Caption = 'Lefoglalt &mem'#243'ria'
      ImageIndex = 23
      ImageName = '23 - memory'
      object miShow5: TMenuItem
        Tag = 1
        Caption = '&Megjelen'#237't'#233's...'
        HelpContext = 1
        ShortCut = 121
        OnClick = btnChartClick
      end
      object N37: TMenuItem
        Caption = '-'
      end
      object miPrint5: TMenuItem
        Tag = 1
        Caption = '&Nyomtat'#225's...'
        HelpContext = 2
        ImageIndex = 15
        ImageName = '15 - print'
        OnClick = btnChartClick
      end
      object miExportBitmap5: TMenuItem
        Tag = 1
        Caption = 'Export'#225'l'#225's &bitk'#233'pk'#233'nt...'
        HelpContext = 3
        OnClick = btnChartClick
      end
      object miExportMetafile5: TMenuItem
        Tag = 1
        Caption = 'E&xport'#225'l'#225's metaf'#225'jlk'#233'nt...'
        HelpContext = 4
        OnClick = btnChartClick
      end
    end
    object miPerfVMs2: TMenuItem
      Caption = '&Fut'#243' virtu'#225'lis g'#233'pek sz'#225'ma'
      ImageIndex = 21
      ImageName = '21 - empty'
      object miShow6: TMenuItem
        Tag = 2
        Caption = '&Megjelen'#237't'#233's...'
        HelpContext = 1
        ShortCut = 123
        OnClick = btnChartClick
      end
      object N38: TMenuItem
        Caption = '-'
      end
      object miPrint6: TMenuItem
        Tag = 2
        Caption = '&Nyomtat'#225's...'
        HelpContext = 2
        ImageIndex = 15
        ImageName = '15 - print'
        OnClick = btnChartClick
      end
      object miExportBitmap6: TMenuItem
        Tag = 2
        Caption = 'Export'#225'l'#225's &bitk'#233'pk'#233'nt...'
        HelpContext = 3
        OnClick = btnChartClick
      end
      object miExportMetafile6: TMenuItem
        Tag = 2
        Caption = 'E&xport'#225'l'#225's metaf'#225'jlk'#233'nt...'
        HelpContext = 4
        OnClick = btnChartClick
      end
    end
    object N46: TMenuItem
      Caption = '-'
    end
    object Programbelltsok2: TMenuItem
      Action = acProgramSettings
    end
    object Virtulisgpeklistjnakfrisstse2: TMenuItem
      Action = acUpdateList
    end
  end
  object DeleteDialog: TTaskDialog
    Buttons = <
      item
        Caption = 'T'#246'rl'#233's csak a list'#225'b'#243'l'
        CommandLinkHint = 'A virtu'#225'lis g'#233'p t'#246'rl'#233'se, a f'#225'jlok megtart'#225'sa mellett.'
        ModalResult = 100
      end
      item
        Caption = 'Minden adat elt'#225'vol'#237't'#225'sa'
        CommandLinkHint = 'A virtu'#225'lis g'#233'p '#233's a f'#225'jlok egyidej'#369' t'#246'rl'#233'se.'
        ModalResult = 101
      end>
    CommonButtons = [tcbCancel]
    DefaultButton = tcbCancel
    Flags = [tfUseHiconMain, tfAllowDialogCancellation, tfUseCommandLinks]
    FooterIcon = 1
    FooterText = 
      'A m'#369'velet nem visszaford'#237'that'#243', c'#233'lszer'#369' el'#337'tte biztons'#225'gi m'#225'sol' +
      'atot k'#233'sz'#237'teni.'
    RadioButtons = <>
    Text = 
      #214'n jelenleg a "%s" nev'#369' virtu'#225'lis g'#233'p elt'#225'vol'#237't'#225's'#225'ra k'#233'sz'#252'l. Hog' +
      'yan k'#237'v'#225'nja az elt'#225'vol'#237't'#225'st elv'#233'gezni?'
    Title = 'Virtu'#225'lis g'#233'p elt'#225'vol'#237't'#225'sa'
    Left = 480
    Top = 328
  end
  object MissingDiskDlg: TTaskDialog
    Buttons = <
      item
        Caption = 'Hi'#225'nyz'#243' el'#233'r'#233'si utak &elt'#225'vol'#237't'#225'sa'
        ModalResult = 101
      end>
    CommonButtons = [tcbCancel]
    DefaultButton = tcbCancel
    FooterIcon = 1
    FooterText = 
      'A m'#369'velet nem visszaford'#237'that'#243', c'#233'lszer'#369' el'#337'tte biztons'#225'gi m'#225'sol' +
      'atot k'#233'sz'#237'teni.'
    MainIcon = 2
    RadioButtons = <>
    Text = 
      'A "%s" nev'#369' virtu'#225'lis g'#233'p elind'#237't'#225'sa nem lehets'#233'ges, mivel az el' +
      'ind'#237't'#225's'#225'hoz sz'#252'ks'#233'ges lemezk'#233'pek hi'#225'nyozni'
    Title = 'Hi'#225'nyz'#243' lemezk'#233'pek'
    Left = 552
    Top = 344
  end
  object Taskbar: TTaskbar
    TaskBarButtons = <
      item
        Action = acNewVM
        ButtonState = []
        Icon.Data = {
          0000010001001010200000000000680400001600000028000000100000002000
          0000010020000000000000040000000000000000000000000000000000000000
          000000000000FFFFFF08EAEAEA19EAEAD619D6D6D619D6D6D619D6D6D619D6D6
          D619D6D6D619E1E1E11ADFDFDF10000000000000000000000000000000000000
          000000000000E3E3E352E4E4E4F6E2E3E2EEE6E5E8EEE5E4E6EEE2E3E2EEE2E3
          E2EEE4E4E5EEE3E3E3F3DCDCDCCABFBFBF080000000000000000000000000000
          000000000000E8E8E859E5E5E5FFDEDDE0FFD5E7C0FFD7E6C6FFE9E8EAFFECEB
          E7FFECEDEDFFEAEAEAFFE2E2E2FFC6C6C6510000000000000000000000000000
          000000000000E8E8E859E9E9E9FFE2E2E3FFE3E8DDFFE2E7DEFFE8E7E8FFECEB
          E6FFECECEDFFEAEAEAFFE4E4E4FFC8C8C8B80000000000000000000000000000
          000000000000D6D6D651D9D9D9FFD1D1D1FFD1D0D1FFD1D0D1FFCECECEFFCECE
          CFFFCDCDCDFFCDCDCDFFCECECEFFCBCBCBFBCFCFCF3000000000000000000000
          000000000000ADADAD16AFAFAFE7B8B8B8FFBFBFBFFFC2C2C2FFC3C3C3FFC2C2
          C2FFC1C1C1FFBCBCBCFFB6B6B6FFD1D1D1FFCCCCCC5600000000000000000000
          00000000000000000000C9C9C9A3E3E3E3FFE2E2E2FFE0E0E0FFDFDFDFFFE0E0
          E0FFE1E1E1FFE2E2E2FFC4C4C4FFC7C7C7FFCBCBCB5400000000000000000000
          00000000000000000000DFDFDF926F6F6FFF464646FF4B4B4BFF535353FF5B5B
          5BFF606060FF888888FFD0D0D0FFBEBEBEFFCCCCCC5500000000000000000000
          00000000000000000000CECECE941A1A1AFF000000FF141414FF212121FF2A2A
          2AFF262626FF525252FFD0D0D0FFB0B0B0F8B9B9B94200000000000000000000
          00000000000000000000C9C9C994252525FF151515FF2B2B2BFF3B3B3BFF4646
          46FF454545FF696969FFD3D3D3FFB0B0B0B80000000000000000000000000000
          00000000000000000000C9C9C9942B2B2BFF1F1F1FFF373737FF4A4A4AFF5A5A
          5AFF5C5C5CFF7B7977FFD9D4D2FFB5AFAAB00000000000000000000000000000
          00000000000000000000CECECE942E2E2EFF202020FF3A3A3AFF505050FF6666
          66FF716F6DFF7B8A96FF9DCFEBFF8EAEC9BA0000000000000000000000000000
          00000000000000000000D6D6D698505050FF3B3B3BFF4F4F4FFF616161FF7674
          73FF7B848EFF49BBE8FF36E1FFFF3CCDFBFB47B0FB4B00000000000000000000
          00000000000000000000E3E3E370D6D6D6C8D2D2D2C7CFCFCFD8D0D0D0DDD7D4
          D1DCB0CDE2EB3ED8FFFF33EDFCFE3AE7FFFF47B6FB8C00000000000000000000
          00000000000000000000000000000000000000000000FFFFFF07E5E5E50AFFFF
          DA076DADF51C41C1FCCE3BDCFFFF3FC8FCF24CABF74600000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000048A3F51C49B0F96149ABF5340000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000}
      end
      item
        Action = acNewHDD
        ButtonState = []
        Icon.Data = {
          0000010001001010200000000000680400001600000028000000100000002000
          0000010020000000000000040000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000001313131A0B121244070B
          0B400A0A00180303034100000015000000000000000000000000000000000000
          00001E1E1E191919192815151552131313810D0D0DB70D0D0DEE0B0C0CFF0506
          06F7020202ED010101FF0F0F0F92000000000000000000000000000000002222
          22161A1A1AE0121212FA121212FF0E0E0EFF060606FF050505FF040404FF0606
          06FF060606FF000000FF090909EA191919140000000000000000000000000000
          001C191919F4454545FF656565FF5B5B5BFF464646FF4F4F4FFF3F3F3EFF4A4A
          4AFF464646FF1B1B1BFF000000FF151515550000000000000000000000000000
          0000363636AD9A9A9AFF636363FF777777FF858584FF3F475FFF545967FF9A9A
          99FF818181FF535455FF0D1722FF101013A90000000000000000000000000000
          00002222223B575757FF444444FFB3B3B3FFACACABFF787D8BFF606573FF8F8F
          8EFF6D6C6BFF43474EFF4B81B8FF16202AEA0B00001600000000000000000000
          0000000000002A2A2AB8989898FFBEBEBEFFADADADFFB0B0AEFFA1A1A0FF9191
          91FFB3B3B3FFB3B6B8FF8B96A0FF2A2A2AFF0B0B0B5800000000000000000000
          00000000000036363646818181FFA6A6A6FFB9B9B9FFC1C1C1FFC8C8C8FFBBBB
          BBFFC0C1C1FFC5C4C4FFC2C1BFFF93918FFF141411AC00000000000000000000
          00000000000000000000626262C2B5B5B5FFBFBFBFFFC6C6C6FFA0A0A0FF8888
          88FF989898FFC4C3C3FFBFBFC1FFA5B5C4FF323132EC00000018000000000000
          0000000000000000000025252551A4A4A4FFC1C1C1FFC4C4C4FF8E8E8EFF8080
          80FF898685FFA7B9C7FF5BC2F3FF47CCFBFF40A2D1FF356DA356000000000000
          0000000000000000000000000003575757CCB8B8B8FFC3C3C3FFC0C0C0FFB5B4
          B4FFB9BBBFFF62BEF1FF35DEFFFF33E7FCFF38E0FFFF44B3F4C3557FE90C0000
          00000000000000000000000000000000005C414141FF8F8F8FFFABABABFFAEAD
          ADFFA4A6ADFF52C2F7FF32E2FBFD2FE9F9FC34E2FDFF42BCFADA5555FF090000
          000000000000000000000000000000000009000000B9090909BB2A2A2A8A2F2F
          2A5B3434433145B4FB9E3DDBFFFF35E0FFFD3DD7FFFF46B1FBA27F2AD4060000
          0000000000000000000000000000000000000000000200000000000000000000
          00000000000048A0F72347B5FB9244BBFCCF48B3FB98489DFF15000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000557FE90C0000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000}
      end
      item
        Action = acNewFloppy
        ButtonState = []
        Icon.Data = {
          0000010001001010200000000000680400001600000028000000100000002000
          0000010020000000000000040000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000969696319B9B9B24000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000AAAAAA03949494D39A9A9AF6BFBFBFC5C4C4C47ECDCDCD33FFFFFF020000
          0000000000000000000000000000000000000000000000000000000000000000
          000096969631999999FDB3B3B3FFABABABFFD4D4D4FFD4D4D4FEB1B1B1C98B8B
          8B739393931334291F313A2C23903929235D0000000000000000000000000000
          00009797977B9F9E9FFFACACACFFA9A9A9FFD6D6D6FFD6D6D6FFA7A7A7FF908F
          8FFF4C3C35DC3A2B24FB3F2F28FF382A23C80000000000000000000000000000
          0000A4A5A4C7D2D6D2FFBABDBAFFAEAFAEFFAFAFAFFFB3B2B3FF979797FF7C79
          77FF3E2D26FF3C2C26FF3A2B25FF362823FC3025202F00000000000000008B8B
          8B2AB1B2B1F9E9F1E9FFEEF7EEFFEEF6EEFFDDE3DDFFC1C4C1FFA4A5A4FF5E5E
          5BFF3A2C25FF3B2B25FF382924FF372A24FF3127238100000000000000009193
          916DBCCEBCFFE1E8E1FFDEDFDEFFE3E7E3FFE0E8E0FFF0F9F1FFABACAAFF453B
          36F5382B24C1382B26EA362923FD352822FF312520D23F3F3F04000000009795
          976F4FA84FEE59CA59FF8CDF8CFFBDE8BDFFDBE7DBFFE7EBE8FF888481FF352A
          276D0000000034312B58362A24FF322620FF2E231CFF2E221D3C000000000000
          0000896B891A5C895C5B479947AB3DA53DEA4AC14AFF87BF87FF675A5AFF3028
          247D000000002C28247D2E211BFF332720FF42353BFF2A111172000000000000
          0000000000000000000000000000AD5CAD16505042D4606455FF43342FFF3427
          21FD372F27E04C433FFE7C747AFFB9B4C4FF9AB9EFFF3572A0E03D8CB81D0000
          0000000000000000000000000000000000003B25207C402D27FF5B4F4AFF4A3D
          38FF615989FFCCCBE5FFCFCEECFFC1CBF2FF4AD7FFFF36EFFFFF41BDF89B0000
          00000000000000000000000000000000000023110B2BA39C96FAE6E4E0FFA49B
          90FF3C3472FFC6C6F6FFCAC8DCF9ADB6D0BE3CC8F8E03AE1FFFF45BBFB840000
          00000000000000000000000000000000000000000000A89B8FC5E4CEB7FFB3A6
          98FF332837CE8A86B07B9797852A0000000046AAFF2448B3FB4A388DE2090000
          000000000000000000000000000000000000000000005E4D455C84736C94504B
          4236000000020000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000}
      end
      item
        Action = acStopAll
        ButtonState = []
        Icon.Data = {
          0000010001001010200000000000680400001600000028000000100000002000
          0000010020000000000000040000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000B95F0000BFA00000B79A0000B19A0000AAA00000AB55000000000000
          0000000000000000000000000000E1E1E111E6E6E66AE7E5E76EE7E2E96DF2F7
          E1682828C8D10000D7FF0000CBFF0000C2FF0000BEFF0000A893000000000000
          0000000000000000000000000000E6E6E629E1E1E2FFE8ECE3FFE3EED7FFF9F8
          F0FF5757D5FF0000CFFF0000CAFF0000C3FF0000C1FF0000B18D000000000000
          0000000000000000000000000000DFDFDF20DFDFDFF8E2E3E0FFDEE2DAFFECEB
          E2FF5252D1FF0000D2FF0000CFFF0000CAFF0000CAFF0000B68D000000000000
          0000E1E1E123E6E6E652E7E7E74DDCDCDC61BCBCBCF2C3C3C3FFC7C7C8FFCDCD
          C6FF4242C8FF0000D5FF0000D3FF0000D4FF0000DAFF0000BD93000000000000
          0000E6E6E673EDECEEFFE3EBD9FFE5EAE0FFD7D6D7FFC7C6C7FFC7C6C7FFCCCB
          C8FF7A7AC3FF5151CCFF5151C7FF2525C4BA0000C2980000B553000000000000
          0000E2E2E273EAE9EAFFE0E5D9FFE6E8E2FFC5C9C6FF1A311AFF1F311FFF2E3E
          2EFF354930FF8B9083FFCFCEC6FFD6D6BB4C0000000000000000000000000000
          0000C3C3C356C5C5C5FFC6C5C6FFCCCBCCFFADB2ADFF0C240CFF242C24FF3C3D
          3CFF3F423FFF878887FFC0C0C0E1A5A5A5140000000000000000000000000000
          0000A1A1A113CAC7CAE7D6D5D6FFD7D5D7FFB3B7B3FF162816FF323B32FF5058
          50FF606260FF9A9A9AFFC0C0C0D77F7F7F060000000000000000000000000000
          0000FFFFFF07879487DA2C3D2CFF354535FF848D84FF404F40FF4A534AFF6871
          68FF838483FFB3B3B3FFC0C0C0DB999999050000000000000000000000000000
          0000FFFFFF09647364DB071E07FF232B23FF6D6F6DFF939393FFC0BFC0FFC8C8
          C8DCD0D0D09AD5D5D5A1BDBDBD807F7F7F020000000000000000000000000000
          0000FFFFFF09697469DB192819FF3D423DFF535753FF5A5A5AFFB6B6B6FFB8B8
          B89C000000000000000000000000000000000000000000000000000000000000
          0000FFFFFF09788378E3283828FF485548FF677167FF787978FFC3C3C3FFB9B9
          B99D000000000000000000000000000000000000000000000000000000000000
          0000FFFFFF06C9CEC999B3B3B3BAB8B8B8C6BFBFBFC9C7C7C7C9CECECED1B4B4
          B474000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000000000000}
      end>
    ProgressMaxValue = 100
    TabProperties = []
    Left = 480
    Top = 272
  end
end
