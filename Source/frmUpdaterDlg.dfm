object UpdaterDlg: TUpdaterDlg
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Emul'#225'tor friss'#237't'#233'se'
  ClientHeight = 214
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  DesignSize = (
    457
    214)
  TextHeight = 13
  object rcBackground: TShape
    Left = 0
    Top = 0
    Width = 457
    Height = 136
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Brush.Color = clWindow
    Pen.Style = psClear
    ExplicitHeight = 129
  end
  object imgIcon: TImage
    Left = 17
    Top = 12
    Width = 32
    Height = 32
  end
  object lbDescription: TLabel
    Left = 62
    Top = 38
    Width = 376
    Height = 26
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'Az emul'#225'tor leg'#250'jabb verzi'#243'j'#225'nak let'#246'lt'#233'se '#233's telep'#237't'#233'se folyama' +
      'tban van.'#13#10'Ez a m'#369'velet ak'#225'r t'#246'bb percig is eltarthat.'
  end
  object lbProgress: TLabel
    Left = 17
    Top = 81
    Width = 49
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = '&Folyamat:'
    ExplicitTop = 90
  end
  object lbFileName: TLabel
    Left = 381
    Top = 81
    Width = 57
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'lbFileName'
    ExplicitTop = 74
  end
  object lbInformation: TLabel
    Left = 80
    Top = 81
    Width = 71
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'lbInformation'
    ExplicitTop = 74
  end
  object lbTitle: TLabel
    Left = 62
    Top = 12
    Width = 121
    Height = 20
    Caption = 'Emul'#225'tor friss'#237't'#233'se'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 11085846
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object bvFooter: TBevel
    Left = 0
    Top = 177
    Width = 457
    Height = 37
    Align = alBottom
    Anchors = [akRight, akBottom]
    Shape = bsTopLine
    ExplicitTop = 160
  end
  object imgFooter: TImage
    Left = 17
    Top = 187
    Width = 16
    Height = 16
    Anchors = [akRight, akBottom]
    ExplicitTop = 180
  end
  object lbFooter: TLabel
    Left = 41
    Top = 187
    Width = 359
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 
      'A folyamat erej'#233'ig lehet'#337's'#233'g szerint ne bontsa az internetkapcso' +
      'latot.'
    ExplicitTop = 180
  end
  object btnTerminate: TButton
    Left = 337
    Top = 142
    Width = 101
    Height = 25
    Hint = '&Kil'#233'p'#233's'
    Anchors = [akRight, akBottom]
    Caption = '&Megszak'#237't'#225's'
    TabOrder = 0
    OnClick = btnTerminateClick
  end
  object pbProgress: TProgressBar
    Left = 17
    Top = 100
    Width = 421
    Height = 17
    Anchors = [akRight, akBottom]
    TabOrder = 1
  end
  object AskUpdateDialog: TTaskDialog
    Buttons = <>
    CommonButtons = [tcbYes, tcbNo]
    DefaultButton = tcbNo
    ExpandedText = 
      'Let'#246'lt'#233'si forr'#225's: <a href="https://ci.86box.net/job/86Box-Dev/">' +
      'Link</a>'#13#10'Emul'#225'tor el'#233'r'#233'si '#250't: C:\Users\laciba\AppData\Roaming\W' +
      'inBox\86Box'#13#10#13#10'Build sz'#225'm: 3042'#13#10'Kiad'#225'si d'#225'tum: 2021. 07. 09. 23' +
      ':58:56'#13#10#13#10'Legfrissebb v'#225'ltoz'#225'sok:'#13#10'    TGUI96x0 banking fixes'
    Flags = [tfEnableHyperlinks, tfAllowDialogCancellation, tfSizeToContent]
    FooterIcon = 1
    FooterText = 'A jelenlegi 86Box verzi'#243' a friss'#237't'#233's sor'#225'n elt'#225'vol'#237't'#225'sra ker'#252'l.'
    MainIcon = 0
    RadioButtons = <>
    Text = 
      'A WinBox '#225'ltal haszn'#225'lt 86Box emul'#225'torhoz friss'#237't'#233's '#233'rhet'#337' el'#145'.'#13 +
      #10'K'#237'v'#225'nja let'#246'lteni '#233's telep'#237'teni?'
    Title = 'Emul'#225'tor friss'#237't'#233'se'
    OnHyperlinkClicked = AskUpdateDialogHyperlinkClicked
    Left = 232
    Top = 40
  end
end
