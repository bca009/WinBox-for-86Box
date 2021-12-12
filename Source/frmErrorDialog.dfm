object ExceptionDialog: TExceptionDialog
  Left = 310
  Top = 255
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = '%s - hiba'#252'zenet'
  ClientHeight = 403
  ClientWidth = 513
  Color = clBtnFace
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    513
    403)
  TextHeight = 13
  object BevelDetails: TBevel
    Left = 8
    Top = 208
    Width = 503
    Height = 3
    Anchors = [akLeft, akTop, akRight]
    Shape = bsSpacer
  end
  object imgIcon: TImage
    Left = 8
    Top = 8
    Width = 58
    Height = 49
    Center = True
  end
  object SaveBtn: TButton
    Left = 400
    Top = 146
    Width = 105
    Height = 25
    Hint = 'A hibajelent'#233'si napl'#243' f'#225'jlba ment'#233'se.'
    Anchors = [akTop, akRight]
    Caption = '&Ment'#233's...'
    TabOrder = 0
    OnClick = SaveBtnClick
  end
  object OkBtn: TButton
    Left = 400
    Top = 8
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object DetailsBtn: TButton
    Left = 400
    Top = 177
    Width = 105
    Height = 25
    Hint = 'Tov'#225'bbi technikai inform'#225'ci'#243'k megjelen'#237't'#233'se, vagy elrejt'#233'se.'
    Anchors = [akTop, akRight]
    Caption = '&R'#233'szletek >>'
    Enabled = False
    TabOrder = 2
    OnClick = DetailsBtnClick
  end
  object DetailsMemo: TMemo
    Left = 8
    Top = 217
    Width = 497
    Height = 178
    Hint = 
      'A kiv'#233'telr'#337'l napl'#243' k'#233'sz'#252'lt r'#233'szletes technikai inform'#225'ci'#243'kkal.'#13#10 +
      'A gener'#225'l'#225's id'#337'pontja: %s.'#13#10#13#10'Ha a hiba v'#225'ratlan volt, '#233's oka is' +
      'meretlen, '#233'rdemes a napl'#243't a'#13#10' fejleszt'#337' sz'#225'm'#225'ra tov'#225'bb'#237'tani, mi' +
      'vel nagyban seg'#237'theti '#337't hiba'#13#10' ok'#225'nak meg'#233'rt'#233's'#233'ben.'
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ReadOnly = True
    ScrollBars = ssBoth
    ShowHint = False
    TabOrder = 3
    WantReturns = False
    WordWrap = False
  end
  object TextMemo: TScrollBox
    Left = 72
    Top = 8
    Width = 315
    Height = 194
    BorderStyle = bsNone
    TabOrder = 4
    object lbMessage1: TLabel
      Left = 8
      Top = 3
      Width = 289
      Height = 23
      AutoSize = False
      Caption = 'A program fut'#225'sa sor'#225'n kezeletlen kiv'#233'tel t'#246'rt'#233'nt.'
      WordWrap = True
    end
    object lbMessage2: TLabel
      Left = 8
      Top = 64
      Width = 289
      Height = 105
      AutoSize = False
      Caption = 
        'Ha a hiba'#252'zenet egy'#233'rtelm'#369', '#233's meg'#225'llap'#237'that'#243' az oka is, '#13#10'a kiv' +
        #233'tel figyelmen k'#237'v'#252'l hagyhat'#243', puszt'#225'n v'#233'delmi c'#233'l'#369'.'#13#10#13#10'Ha a hib' +
        'a oka ismeretlen, az alkalmaz'#225's instabill'#225' v'#225'lhat, '#13#10'ilyenkor az' +
        ' adatveszt'#233's elker'#252'l'#233'se '#233'rdek'#233'ben '#233'rdemes '#13#10'elmenteni a munk'#225'j'#225't' +
        ' '#233's bez'#225'rni az programot.'
      WordWrap = True
    end
    object TextLines: TMemo
      Left = 8
      Top = 32
      Width = 273
      Height = 26
      Hint = 
        'Ezt a sz'#246'veget a v'#225'g'#243'lapra tudja m'#225'solni a Ctrl+C billenty'#369'kombi' +
        'n'#225'ci'#243' seg'#237'ts'#233'g'#233'vel.'
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Lines.Strings = (
        'Memo1')
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WantReturns = False
      StyleElements = []
    end
  end
end
