object WinBoxUpd: TWinBoxUpd
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 202
  Width = 296
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
    RadioButtons = <>
    Text = 
      'A WinBox '#225'ltal haszn'#225'lt 86Box emul'#225'torhoz friss'#237't'#233's '#233'rhet'#337' el'#145'.'#13 +
      #10'K'#237'v'#225'nja let'#246'lteni '#233's telep'#237'teni?'
    Title = 'Emul'#225'tor friss'#237't'#233'se'
    OnHyperlinkClicked = AskUpdateDialogHyperlinkClicked
    Left = 111
    Top = 56
  end
end
