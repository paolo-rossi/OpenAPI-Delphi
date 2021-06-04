unit Demo.Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Rtti, Vcl.StdCtrls, System.JSON,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  OpenAPI.Models,
  OpenAPI.Schema,
  OpenAPI.Serializer, Vcl.CategoryButtons, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList;

type
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
  FDocument.Servers.Add(TOpenAPIServer.Create('https://api.mycompany.com/rest/app/', 'Production Server'));
  FDocument.Servers.Add(TOpenAPIServer.Create('https://beta.mycompany.com/rest/app/', 'Beta Server API v2'));
  FDocument.Servers.Add(TOpenAPIServer.Create('https://test.mycompany.com/rest/app/', 'Testing Server'));
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

end;

procedure TfrmMain.actCompAddResponsesExecute(Sender: TObject);
var
  LResponse: TOpenAPIResponse;
  LMediaType: TOpenAPIMediaType;
begin
  LResponse := FDocument.Components.AddResponse('200', 'Successful response');
  LMediaType := LResponse.AddMediaType('application/json');
  LMediaType.Schema.Reference.Ref := '#components/schemas/country';
end;

procedure TfrmMain.actCompAddSchemasExecute(Sender: TObject);
var
  LSchema: TOpenAPISchema;
  LProperty: TOpenAPISchema;
begin
  LSchema := FDocument.Components.AddSchema('Category');
  LSchema.Type_ := 'object';
    LProperty := LSchema.AddProperty('id');
    LProperty.Type_ := 'integer';
    LProperty.Format := 'int64';

    LProperty := LSchema.AddProperty('name');
    LProperty.Type_ := 'string';
end;

procedure TfrmMain.actCompAddSecurityDefsExecute(Sender: TObject);
begin
  FDocument.Components.AddSecurityApiKey('key_auth', 'Key Standard Authentication', 'X-ApiKey', tapikeylocation.Header);
  FDocument.Components.AddSecurityHttp('basic_auth', 'Basic Authentication', 'Basic', '');
  FDocument.Components.AddSecurityHttp('bearer_auth', 'Bearer Authentication', 'Bearer', 'Bearer');
end;

procedure TfrmMain.actAddSecurityExecute(Sender: TObject);
begin
  FDocument.AddSecurity('basic_auth', []);
  FDocument.AddSecurity('bearer_auth', []);
end;

procedure TfrmMain.actCompAddParametersExecute(Sender: TObject);
var
  LParameter: TOpenAPIParameter;
begin
  LParameter := FDocument.Components.AddParameter('idParam', 'id', 'query');
  LParameter.Description := 'Customer ID';
  LParameter.Schema.Type_ := 'string';
  LParameter.Schema.Enum.ValueFrom<TArray<string>>(['enum1', 'enum2']);
end;

procedure TfrmMain.actJSONGenerateExecute(Sender: TObject);
begin
  memoDocument.Lines.Text := TNeon.ObjectToJSONString(FDocument, TOpenAPISerializer.GetNeonConfig);
end;

procedure TfrmMain.actJSONReplaceExecute(Sender: TObject);
begin
  memoDocument.Lines.Text := StringReplace(memoDocument.Lines.Text, '\/', '/', [rfReplaceAll]);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDocument := TOpenAPIDocument.Create;
  FDocument.OpenAPI := '3.0.3';
end;

end.
