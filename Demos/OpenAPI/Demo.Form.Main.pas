unit Demo.Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CategoryButtons,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList,
  System.Rtti, System.JSON,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  Neon.Core.Persistence.JSON.Schema,
  OpenAPI.Model.Classes,
  OpenAPI.Model.Schema,
  OpenAPI.Neon.Serializers;

type
  TPerson = class
  private
    FAge: Integer;
    FName: string;
  public
    property Age: Integer read FAge write FAge;
    property Name: string read FName write FName;
  end;

  TfrmMain = class(TForm)
    memoDocument: TMemo;
    catMenu: TCategoryPanelGroup;
    pnlSections: TCategoryPanel;
    CategoryButtons1: TCategoryButtons;
    pnlDocument: TCategoryPanel;
    CategoryButtons2: TCategoryButtons;
    catJSON: TCategoryButtons;
    aclCommands: TActionList;
    imgCommands: TImageList;
    actAddInfo: TAction;
    actAddServers: TAction;
    actAddPaths: TAction;
    actAddSecurity: TAction;
    actCompAddSchemas: TAction;
    actCompAddResponses: TAction;
    actCompAddSecurityDefs: TAction;
    actJSONGenerate: TAction;
    actJSONReplace: TAction;
    actCompAddParameters: TAction;
    actCompAddRequestBodies: TAction;
    actAddInfoExtensions: TAction;
    actDocumentOpen: TAction;
    actDocumentSave: TAction;
    dlgOpenJSON: TOpenDialog;
    actDocumentNew: TAction;
    actDocumentClose: TAction;
    dlgSaveDocument: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actAddInfoExecute(Sender: TObject);
    procedure actAddInfoExtensionsExecute(Sender: TObject);
    procedure actAddServersExecute(Sender: TObject);
    procedure actAddPathsExecute(Sender: TObject);
    procedure actCompAddResponsesExecute(Sender: TObject);
    procedure actCompAddSchemasExecute(Sender: TObject);
    procedure actCompAddSecurityDefsExecute(Sender: TObject);
    procedure actAddSecurityExecute(Sender: TObject);
    procedure actCompAddParametersExecute(Sender: TObject);
    procedure actDocumentCloseExecute(Sender: TObject);
    procedure actDocumentNewExecute(Sender: TObject);
    procedure actJSONGenerateExecute(Sender: TObject);
    procedure actDocumentOpenExecute(Sender: TObject);
    procedure actDocumentSaveExecute(Sender: TObject);
    procedure actJSONReplaceExecute(Sender: TObject);
  private
    FDocumentName: string;
    FDocument: TOpenAPIDocument;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.IOUtils;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  dlgOpenJSON.InitialDir := TPath.GetDirectoryName(TPath.GetDirectoryName(Application.ExeName)) + '\Data\samples\';
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FDocument.Free;
end;

procedure TfrmMain.actAddInfoExecute(Sender: TObject);
begin
  FDocument.Info.Title := 'OpenAPI Demo';
  FDocument.Info.Version := '1.0.2';
  FDocument.Info.Description := 'OpenAPI Demo Description';
  FDocument.Info.Contact.Name := 'Paolo Rossi';
  FDocument.Info.Contact.URL := 'https://github.com/paolo-rossi';
  FDocument.Info.License.Name := 'Apache-2.0';
  FDocument.Info.License.URL := 'http://www.apache.org/licenses/';
end;

procedure TfrmMain.actAddInfoExtensionsExecute(Sender: TObject);
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('url', '/images/wirl.png');
  LJSON.AddPair('backgroundColor', '#000000');
  LJSON.AddPair('altText', 'WiRL Logo');

  FDocument.Info.Extensions.Add('x-logo', LJSON);

  // Testing the Dictionary serialization for Extensions
  //FDocument.Info.Ext.Add('test', 'prova');
  //FDocument.Info.Ext.Add('xyz', TStringList.Create.Add('Prova Item 1'));

end;

procedure TfrmMain.actAddServersExecute(Sender: TObject);
begin
  FDocument.Servers.Add(TOpenAPIServer.Create('https://api.wirl.com/rest/app/', 'Production Server'));
  FDocument.Servers.Add(TOpenAPIServer.Create('https://beta.wirl.com/rest/app/', 'Beta Server API v2'));
  FDocument.Servers.Add(TOpenAPIServer.Create('https://test.wirl.com/rest/app/', 'Testing Server'));
end;

procedure TfrmMain.actAddPathsExecute(Sender: TObject);
var
  LPath: TOpenAPIPathItem;
  LOperation: TOpenAPIOperation;
  LParameter: TOpenAPIParameter;
begin
  LPath := FDocument.AddPath('/customers');
  LPath.Description := 'Customers resource';

    LOperation := LPath.AddOperation(TOperationType.Get);
    LOperation.Summary := 'Get all customers';
    LOperation.OperationId := 'CustomerList';

      LParameter := LOperation.AddParameter('id', 'query');
      LParameter.Description := 'Customer ID';
      LParameter.Schema.Type_ := 'string';

      LParameter := LOperation.AddParameter('country', 'query');
      LParameter.Description := 'Country Code';
      LParameter.Schema.Type_ := 'string';
      LParameter.Schema.AddEnum('it');
      LParameter.Schema.AddEnum('br');
      LParameter.Schema.AddEnum('us');
      LParameter.Schema.AddEnum('uk');

      LParameter := LOperation.AddParameter('date', 'query');
      LParameter.Description := 'Date';
      LParameter.Schema.Type_ := 'string';
      LParameter.Schema.Format := 'date-time';

      // Uses a JSON schema already existing as a TJSONObject
      LParameter := LOperation.AddParameter('person', 'query');
      LParameter.Description := 'Person Entity';
      LParameter.Schema.SetJSONObject(TNeonSchemaGenerator.ClassToJSONSchema(TPerson));

      // Uses #ref
      LParameter := LOperation.AddParameter('order', 'query');
      LParameter.Description := 'Order Entity';
      LParameter.Schema.Reference.Ref := '#components/schemas/order';
end;

procedure TfrmMain.actCompAddResponsesExecute(Sender: TObject);
var
  LResponse: TOpenAPIResponse;
  LMediaType: TOpenAPIMediaType;
begin
  LResponse := FDocument.Components.AddResponse('200', 'Successful Response');
  LMediaType := LResponse.AddMediaType('application/json');
  LMediaType.Schema.Reference.Ref := '#components/schemas/country';
end;

procedure TfrmMain.actCompAddSchemasExecute(Sender: TObject);
var
  LSchema: TOpenAPISchema;
  LProperty: TOpenAPISchema;
begin
  LSchema := FDocument.Components.AddSchema('Person');
  LSchema.Type_ := 'object';

    LProperty := LSchema.AddProperty('id');
    LProperty.Title := 'ID Value';
    LProperty.Description := 'AutoInc **ID** value';
    LProperty.Type_ := 'integer';
    LProperty.Format := 'int64';

    LProperty := LSchema.AddProperty('firstname');
    LProperty.Type_ := 'string';

    LProperty := LSchema.AddProperty('lastname');
    LProperty.Type_ := 'string';

    LProperty := LSchema.AddProperty('birthdate');
    LProperty.Title := 'Birth Date';
    LProperty.Description := 'Birth Date';
    LProperty.Type_ := 'string';
    LProperty.Format := 'date-time';
end;

procedure TfrmMain.actCompAddSecurityDefsExecute(Sender: TObject);
begin
  FDocument.Components.AddSecurityApiKey('key_auth', 'Key Standard Authentication', 'X-ApiKey', tapikeylocation.Header);
  FDocument.Components.AddSecurityHttp('basic_auth', 'Basic Authentication', 'Basic', '');
  FDocument.Components.AddSecurityHttp('jwt_auth', 'JWT (Bearer) Authentication', 'Bearer', 'JWT');
end;

procedure TfrmMain.actAddSecurityExecute(Sender: TObject);
begin
  FDocument.AddSecurity('basic_auth', []);
  FDocument.AddSecurity('jwt_auth', []);
end;

procedure TfrmMain.actCompAddParametersExecute(Sender: TObject);
var
  LParameter: TOpenAPIParameter;
begin
  LParameter := FDocument.Components.AddParameter('idParam', 'id', 'query');
  LParameter.Description := 'Customer ID';
  LParameter.Schema.Type_ := 'string';
  LParameter.Schema.MaxLength := 20;
end;

procedure TfrmMain.actDocumentCloseExecute(Sender: TObject);
begin
  FreeAndNil(FDocument);
  memoDocument.Clear;
  pnlSections.Visible := False;
end;

procedure TfrmMain.actDocumentNewExecute(Sender: TObject);
begin
  FDocument := TOpenAPIDocument.Create(TOpenAPIVersion.v303);
  pnlSections.Visible := True;
  FDocumentName := 'MyAPI';
end;

procedure TfrmMain.actJSONGenerateExecute(Sender: TObject);
begin
  memoDocument.Lines.Text :=
    TNeon.ObjectToJSONString(FDocument, TOpenAPISerializer.GetNeonConfig);
end;

procedure TfrmMain.actDocumentOpenExecute(Sender: TObject);
var
  LDocument: TOpenAPIDocument;
  LJSON: TJSONObject;
  LConfig: INeonConfiguration;
begin
  if not dlgOpenJSON.Execute() then
    Exit;

  LDocument := TOpenAPIDocument.Create(TOpenAPIVersion.v303);
  try
    LJSON := TJSONObject.ParseJSONValue(TFile.ReadAllText(dlgOpenJSON.FileName)) as TJSONObject;
    try
      LConfig := TOpenAPISerializer.GetNeonConfig;

      TNeon.JSONToObject(LDocument, LJSON, LConfig);
    finally
      LJSON.Free;
    end;

    // Serialization in order to see the document loaded
    memoDocument.Text := TNeon.ObjectToJSONString(LDocument, LConfig);
  finally
    LDocument.Free;
  end;
  FDocumentName := TPath.GetFileNameWithoutExtension(dlgOpenJSON.FileName);
end;

procedure TfrmMain.actDocumentSaveExecute(Sender: TObject);
begin
  dlgSaveDocument.FileName := FDocumentName + '.json';
  if not dlgSaveDocument.Execute then
    Exit;

  memoDocument.Lines.SaveToFile(dlgSaveDocument.FileName, TEncoding.UTF8);
end;

procedure TfrmMain.actJSONReplaceExecute(Sender: TObject);
begin
  memoDocument.Lines.Text :=
    StringReplace(memoDocument.Lines.Text, '\/', '/', [rfReplaceAll]);
end;

end.
