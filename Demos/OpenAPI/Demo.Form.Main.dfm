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
    ExplicitLeft = 203
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
    object pnlSections: TCategoryPanel
      Top = 192
      Height = 369
      Caption = 'Fill Document Sections'
      TabOrder = 0
      Visible = False
      object CategoryButtons1: TCategoryButtons
        Left = 0
        Top = 0
        Width = 194
        Height = 343
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
              end>
          end
          item
            Caption = 'Serialization'
            Color = 16777194
            Collapsed = False
            Items = <
              item
                Action = actJSONGenerate
              end>
          end>
        RegularButtonColor = clWhite
        SelectedButtonColor = 15132390
        TabOrder = 0
        ExplicitHeight = 327
      end
    end
    object pnlDocument: TCategoryPanel
      Top = 0
      Height = 192
      Caption = 'OpenAPI Document'
      TabOrder = 1
      object CategoryButtons2: TCategoryButtons
        Left = 0
        Top = 0
        Width = 194
        Height = 166
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
        Height = 166
        Align = alClient
        ButtonFlow = cbfVertical
        ButtonOptions = [boFullSize, boGradientFill, boShowCaptions, boUsePlusMinus]
        Categories = <
          item
            Caption = 'Document'
            Color = 15466474
            Collapsed = False
            Items = <
              item
                Action = actDocumentNew
              end
              item
                Action = actDocumentClose
              end
              item
                Action = actDocumentOpen
              end
              item
                Action = actDocumentSave
              end>
          end
          item
            Caption = 'General'
            Color = 16771818
            Collapsed = False
            Items = <
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
    Left = 176
    Top = 168
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
      Caption = 'Add Security'
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
      Caption = 'Generate JSON Document'
      OnExecute = actJSONGenerateExecute
    end
    object actJSONReplace: TAction
      Caption = 'Replace Escaped Slash "/"'
      OnExecute = actJSONReplaceExecute
    end
    object actDocumentOpen: TAction
      Caption = 'Load Document (JSON)'
      OnExecute = actDocumentOpenExecute
    end
    object actDocumentSave: TAction
      Caption = 'Save Document (JSON)'
      OnExecute = actDocumentSaveExecute
    end
    object actDocumentNew: TAction
      Caption = 'New Document'
      OnExecute = actDocumentNewExecute
    end
    object actDocumentClose: TAction
      Caption = 'Close Document'
      OnExecute = actDocumentCloseExecute
    end
  end
  object imgCommands: TImageList
    Left = 184
    Top = 216
  end
  object dlgOpenJSON: TOpenDialog
    Filter = 'Schema Documents|*.json|All Files|*.*'
    Left = 440
    Top = 296
  end
  object dlgSaveDocument: TSaveDialog
    DefaultExt = 'json'
    Filter = 'OpenAPI Document|*.json'
    Left = 440
    Top = 360
  end
end
