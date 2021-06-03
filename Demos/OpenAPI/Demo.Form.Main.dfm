object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'OpenAPI Demo'
  ClientHeight = 549
  ClientWidth = 902
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
    Left = 166
    Top = 0
    Width = 736
    Height = 549
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'memoDocument')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnAddInfo: TButton
    Left = 8
    Top = 8
    Width = 121
    Height = 25
    Caption = 'Add Info'
    TabOrder = 1
    OnClick = btnAddInfoClick
  end
  object btnDocumentGenerate: TButton
    Left = 8
    Top = 240
    Width = 121
    Height = 25
    Caption = 'Generate JSON'
    TabOrder = 2
    OnClick = btnDocumentGenerateClick
  end
  object btnAddServers: TButton
    Left = 8
    Top = 39
    Width = 121
    Height = 25
    Caption = 'Add Servers'
    TabOrder = 3
    OnClick = btnAddServersClick
  end
  object btnAddPaths: TButton
    Left = 8
    Top = 70
    Width = 121
    Height = 25
    Caption = 'Add Paths'
    TabOrder = 4
    OnClick = btnAddPathsClick
  end
  object btnAddComponents: TButton
    Left = 8
    Top = 101
    Width = 121
    Height = 25
    Caption = 'Add Components'
    TabOrder = 5
    OnClick = btnAddComponentsClick
  end
  object btnAddCompSchemas: TButton
    Left = 24
    Top = 132
    Width = 121
    Height = 25
    Caption = 'Add Schemas'
    TabOrder = 6
    OnClick = btnAddCompSchemasClick
  end
  object btnAddResponse: TButton
    Left = 24
    Top = 163
    Width = 121
    Height = 25
    Caption = 'btnAddResponse'
    TabOrder = 7
    OnClick = btnAddResponseClick
  end
  object btnAddSecurityDefs: TButton
    Left = 8
    Top = 304
    Width = 121
    Height = 25
    Caption = 'Add SecurityDefs'
    TabOrder = 8
    OnClick = btnAddSecurityDefsClick
  end
  object Button1: TButton
    Left = 8
    Top = 516
    Width = 75
    Height = 25
    Caption = 'Replace \/'
    TabOrder = 9
    OnClick = Button1Click
  end
  object btnAddSecurity: TButton
    Left = 54
    Top = 335
    Width = 75
    Height = 25
    Caption = 'Add Security'
    TabOrder = 10
    OnClick = btnAddSecurityClick
  end
end
