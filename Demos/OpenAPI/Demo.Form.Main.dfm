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
    Left = 141
    Top = 0
    Width = 761
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
end
