object NewFloppy: TNewFloppy
  Left = 0
  Top = 0
  ActiveControl = btnOK
  BorderStyle = bsDialog
  Caption = #218'j hajl'#233'konylemez k'#233'pf'#225'jl l'#233'trehoz'#225'sa'
  ClientHeight = 309
  ClientWidth = 479
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    479
    309)
  PixelsPerInch = 96
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
  object btnCancel: TButton
    Tag = 1
    Left = 383
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&M'#233'gse'
    ModalResult = 1
    TabOrder = 0
  end
  object btnOK: TButton
    Tag = -1
    Left = 302
    Top = 273
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object pcPages: TPageControl
    Left = 142
    Top = 0
    Width = 337
    Height = 263
    ActivePage = tabData
    Align = alClient
    TabOrder = 2
    object tabData: TTabSheet
      Caption = 'tabData'
      ImageIndex = 2
      TabVisible = False
      DesignSize = (
        329
        253)
      object lbTitle: TLabel
        Left = 16
        Top = 16
        Width = 217
        Height = 13
        Caption = #218'j hajl'#233'konylemez k'#233'pf'#225'jl l'#233'trehoz'#225'sa'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 16
        Top = 46
        Width = 297
        Height = 34
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Adja meg a helyet, ahol a lemezk'#233'pf'#225'jlt t'#225'rolni k'#237'v'#225'nja.'
        WordWrap = True
      end
      object lbFileName: TLabel
        Left = 16
        Top = 67
        Width = 39
        Height = 13
        Caption = '&F'#225'jln'#233'v:'
        FocusControl = edFileName
      end
      object lbNoteFileName: TLabel
        Left = 16
        Top = 115
        Width = 289
        Height = 38
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Ha m'#225'r tudja melyik virtu'#225'lis g'#233'phez k'#237'v'#225'nja felcsatolni, c'#233'lsze' +
          'r'#369' annak a munkak'#246'nyvt'#225'r'#225'ba elhelyezni azt.'
        WordWrap = True
      end
      object lbType: TLabel
        Left = 16
        Top = 156
        Width = 258
        Height = 13
        Caption = 'A k'#233'pf'#225'jl form'#225'tum'#225't az al'#225'bbi &list'#225'b'#243'l v'#225'laszthatja ki:'
        FocusControl = cbType
      end
      object lbNoteDMF: TLabel
        Left = 16
        Top = 225
        Width = 292
        Height = 13
        Caption = 'Az 1.72M form'#225'tumot a Windows NT rendszerek nem kezelik.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edFileName: TEdit
        Left = 32
        Top = 86
        Width = 234
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'D:\teszt.img'
      end
      object btnBrowse: TButton
        Left = 272
        Top = 84
        Width = 35
        Height = 25
        Anchors = [akTop, akRight]
        Caption = '...'
        TabOrder = 1
        OnClick = btnBrowseClick
      end
      object cbType: TComboBox
        Left = 32
        Top = 175
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemIndex = 6
        TabOrder = 2
        Text = '3.5'#39#39' DS HD 1.44M'
        Items.Strings = (
          '5.25'#39#39' SS DD-8 160k'
          '5.25'#39#39' DS DD-8 320k'
          '5.25'#39#39' SS DD-9 180k'
          '5.25'#39#39' DS DD-9 360k'
          '5.25'#39#39' DS HD 1.2M'
          '3.5'#39#39' DS DD 720k'
          '3.5'#39#39' DS HD 1.44M'
          '3.5'#39#39' DS HD 1.68M'
          '3.5'#39#39' DS HD 1.72M'
          '3.5'#39#39' DS ED 2.88M')
      end
      object cbFormat: TCheckBox
        Left = 32
        Top = 202
        Width = 265
        Height = 17
        Caption = 'K'#233'pf'#225'jl for&m'#225'z'#225'sa FAT12 f'#225'jlrendszerrel'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.ima'
    Filter = 
      'Hajl'#233'konylemez k'#233'pf'#225'jlok (*.ima; *.vfd)|*.ima;*.vfd|Nyers lemezk' +
      #233'pf'#225'jlok (*.im?; *.vfd)|*.im?;*.vfd|Minden f'#225'jl (*.*)|*.*'
    Left = 80
    Top = 168
  end
end
