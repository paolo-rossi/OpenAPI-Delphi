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
    panGeneral: TCategoryPanel;
    CategoryButtons1: TCategoryButtons;
    CategoryPanel1: TCategoryPanel;
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
    procedure FormDestroy(Sender: TObject);
    procedure actAddInfoExecute(Sender: TObject);
    procedure actAddServersExecute(Sender: TObject);
    procedure actAddPathsExecute(Sender: TObject);
    procedure actCompAddResponsesExecute(Sender: TObject);
    procedure actCompAddSchemasExecute(Sender: TObject);
    procedure actCompAddSecurityDefsExecute(Sender: TObject);
    procedure actAddSecurityExecute(Sender: TObject);
    procedure actCompAddParametersExecute(Sender: TObject);
    procedure actJSONGenerateExecute(Sender: TObject);
    procedure actJSONReplaceExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FDocument: TOpenAPIDocument;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FDocument.Free;
end;

procedure TfrmMain.actAddInfoExecute(Sender: TObject);
begin
  FDocument.Info.Title := 'OpenAPI Demo';
  FDocument.Info.Description := 'OpenAPI Demo Description';
  FDocument.Info.Contact.Name := 'Paolo Rossi';
  FDocument.Info.Contact.URL := 'https://github.com/paolo-rossi';
  FDocument.Info.License.Name := 'Apache-2.0';
  FDocument.Info.License.URL := 'http://www.apache.org/licenses/';
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
      LParameter.Schema.Enum.ValueFrom<TArray<string>>(['enum1', 'enum2']);

      LParameter := LOperation.AddParameter('country', 'query');
      LParameter.Description := 'Country Code';
      LParameter.Schema.Type_ := 'string';
      LParameter.Schema.Enum.ValueFrom<TArray<string>>(['it', 'en', 'de', 'ch', 'fr']);

      LParameter := LOperation.AddParameter('date', 'query');
      LParameter.Description := 'Date';
      LParameter.Schema.Type_ := 'string';
      LParameter.Schema.Format := 'date-time';
      LParameter.Schema.Enum.ValueFrom<TArray<string>>(['it', 'en', 'de', 'ch', 'fr']);

      // Uses a JSON schema already existing as a TJSONObject
      LParameter := LOperation.AddParameter('person', 'query');
      LParameter.Description := 'Person Entity';
      LParameter.Schema.SetJSONObject(TNeonSchemaGenerator.ClassToJSONSchema(TPerson));

      // Uses #ref
      LParameter := LOperation.AddParameter('order', 'query');
      LParameter.Description := 'Order Entity';
      LParameter.Schema.Reference.Ref := '#comp/deidjed/';
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
  LParameter.Schema.Enum.ValueFrom<TArray<string>>(['enum1', 'enum2']);
  LParameter.Schema.MaxLength := 123;
end;

procedure TfrmMain.actJSONGenerateExecute(Sender: TObject);
begin
  memoDocument.Lines.Text :=
    TNeon.ObjectToJSONString(FDocument, TOpenAPISerializer.GetNeonConfig);
end;

procedure TfrmMain.actJSONReplaceExecute(Sender: TObject);
begin
  memoDocument.Lines.Text :=
    StringReplace(memoDocument.Lines.Text, '\/', '/', [rfReplaceAll]);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDocument := TOpenAPIDocument.Create('3.0.3');
end;

end.
