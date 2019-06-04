unit Demo.Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Rtti, Vcl.StdCtrls,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  OpenAPI.Models,
  OpenAPI.Serializer;

type
  TfrmMain = class(TForm)
    memoDocument: TMemo;
    btnAddInfo: TButton;
    btnDocumentGenerate: TButton;
    btnAddServers: TButton;
    btnAddPaths: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddInfoClick(Sender: TObject);
    procedure btnAddServersClick(Sender: TObject);
    procedure btnDocumentGenerateClick(Sender: TObject);
    procedure btnAddPathsClick(Sender: TObject);
  private
    FDocument: TOpenAPIDocument;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDocument := TOpenAPIDocument.Create;
end;

procedure TfrmMain.btnAddInfoClick(Sender: TObject);
begin
  FDocument.OpenAPI := '3.0.2';
  FDocument.Info.Title := 'OpenAPI Demo';
  FDocument.Info.Description := 'OpenAPI Demo Description';
  FDocument.Info.Contact.Name := 'Paolo Rossi';
  FDocument.Info.Contact.URL := 'https://github.com/paolo-rossi';
  FDocument.Info.License.Name := 'Apache-2.0';
  FDocument.Info.License.URL := 'http://www.apache.org/licenses/';
end;

procedure TfrmMain.btnAddServersClick(Sender: TObject);
begin
  FDocument.Servers.Add(TOpenAPIServer.Create('https://api.mycompany.com/rest/app/', 'Production Server'));
  FDocument.Servers.Add(TOpenAPIServer.Create('https://beta.mycompany.com/rest/app/', 'Beta Server API v2'));
  FDocument.Servers.Add(TOpenAPIServer.Create('https://test.mycompany.com/rest/app/', 'Testing Server'));
end;

procedure TfrmMain.btnDocumentGenerateClick(Sender: TObject);
begin
  memoDocument.Lines.Text := TNeon.ObjectToJSONString(FDocument, TOpenAPISerializer.GetNeonConfig);
end;

procedure TfrmMain.btnAddPathsClick(Sender: TObject);
var
  LPath: TOpenAPIPathItem;
  LOperation: TOpenAPIOperation;
begin
  LPath := TOpenAPIPathItem.Create;
  LPath.Description := 'Customers resource';

    LOperation := TOpenAPIOperation.Create;
    LOperation.Summary := 'Get all customers';
    LOperation.OperationId := 'CustomerList';
    LPath.Operations.Add(TOperationType.Get, LOperation);

  FDocument.Paths.Add('/customers', LPath);
end;

end.
