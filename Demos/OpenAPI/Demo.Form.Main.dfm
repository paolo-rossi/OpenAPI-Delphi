object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'OpenAPI Demo'
  ClientHeight = 580
  ClientWidth = 902
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object memoDocument: TMemo
    Left = 200
    Top = 0
    Width = 702
    Height = 580
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object catMenu: TCategoryPanelGroup
    Left = 0
    Top = 0
    Height = 580
    VertScrollBar.Tracking = True
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    TabOrder = 1
    object panGeneral: TCategoryPanel
      Top = 0
      Height = 441
      Caption = 'OpenAPI Document'
      TabOrder = 0
      object CategoryButtons1: TCategoryButtons
        Left = 0
        Top = 0
        Width = 194
        Height = 415
        Align = alClient
        ButtonFlow = cbfVertical
        ButtonOptions = [boFullSize, boGradientFill, boShowCaptions, boUsePlusMinus]
        Categories = <
          item
            Caption = 'General'
            Color = 15466474
            Collapsed = False
            Items = <
              item
                Action = actAddInfo
              end
              item
                Action = actAddInfoExtensions
              end
              item
                Action = actAddServers
              end>
          end
          item
            Caption = 'Components'
            Color = 16771818
            Collapsed = False
            Items = <
              item
                Action = actCompAddSchemas
              end
              item
                Action = actCompAddResponses
              end
              item
                Action = actCompAddSecurityDefs
              end
              item
                Action = actCompAddParameters
              end>
          end
          item
            Caption = 'Optional Sections'
            Color = 16771839
            Collapsed = False
            Items = <
              item
                Action = actAddPaths
              end
              item
                Action = actAddSecurity
              end
              item
              end>
          end>
        RegularButtonColor = clWhite
        SelectedButtonColor = 15132390
        TabOrder = 0
      end
    end
    object CategoryPanel1: TCategoryPanel
      Top = 441
      Height = 120
      Caption = 'JSON Generation'
      TabOrder = 1
      object CategoryButtons2: TCategoryButtons
        Left = 0
        Top = 0
        Width = 194
        Height = 94
        Align = alClient
        ButtonFlow = cbfVertical
        Categories = <>
        RegularButtonColor = clWhite
        SelectedButtonColor = 15132390
        TabOrder = 0
      end
      object catJSON: TCategoryButtons
        Left = 0
        Top = 0
        Width = 194
        Height = 94
        Align = alClient
        ButtonFlow = cbfVertical
        ButtonOptions = [boFullSize, boGradientFill, boShowCaptions, boUsePlusMinus]
        Categories = <
          item
            Caption = 'Generation'
            Color = 15466474
            Collapsed = False
            Items = <
              item
                Action = actJSONGenerate
              end
              item
                Action = actJSONReplace
              end>
          end>
        RegularButtonColor = clWhite
        SelectedButtonColor = 15132390
        TabOrder = 1
      end
    end
  end
  object aclCommands: TActionList
    Images = imgCommands
    Left = 64
    Top = 144
    object actAddInfo: TAction
      Caption = 'Add Info Object'
      OnExecute = actAddInfoExecute
    end
    object actAddInfoExtensions: TAction
      Caption = 'Add Info Object Extensions'
      OnExecute = actAddInfoExtensionsExecute
    end
    object actAddServers: TAction
      Caption = 'Add Servers'
      OnExecute = actAddServersExecute
    end
    object actAddPaths: TAction
      Caption = 'Add Paths && Params'
      OnExecute = actAddPathsExecute
    end
    object actAddSecurity: TAction
      Caption = 'actAddSecurity'
      OnExecute = actAddSecurityExecute
    end
    object actCompAddSchemas: TAction
      Caption = 'Add Schemas'
      OnExecute = actCompAddSchemasExecute
    end
    object actCompAddResponses: TAction
      Caption = 'Add Responses'
      OnExecute = actCompAddResponsesExecute
    end
    object actCompAddSecurityDefs: TAction
      Caption = 'Add SecurityDefs'
      OnExecute = actCompAddSecurityDefsExecute
    end
    object actCompAddParameters: TAction
      Caption = 'Add Parameters'
      OnExecute = actCompAddParametersExecute
    end
    object actCompAddRequestBodies: TAction
      Caption = 'Add RequestBodies'
    end
    object actJSONGenerate: TAction
      Caption = 'Generate JSON'
      OnExecute = actJSONGenerateExecute
    end
    object actJSONReplace: TAction
      Caption = 'Replace Escaped Slash "/"'
      OnExecute = actJSONReplaceExecute
    end
  end
  object imgCommands: TImageList
    Left = 72
    Top = 216
  end
end
