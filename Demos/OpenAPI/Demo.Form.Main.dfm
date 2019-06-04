object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'OpenAPI Demo'
  ClientHeight = 523
  ClientWidth = 570
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object memoDocument: TMemo
    Left = 141
    Top = 0
    Width = 429
    Height = 523
    Align = alRight
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'memoDocument')
    ParentFont = False
    TabOrder = 0
  end
  object btnDocumentCreate: TButton
    Left = 8
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Create Document'
    TabOrder = 1
    OnClick = btnDocumentCreateClick
  end
  object btnDocumentGenerate: TButton
    Left = 8
    Top = 48
    Width = 121
    Height = 25
    Caption = 'Generate JSON'
    TabOrder = 2
    OnClick = btnDocumentGenerateClick
  end
end
