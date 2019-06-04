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
    btnDocumentCreate: TButton;
    btnDocumentGenerate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnDocumentCreateClick(Sender: TObject);
    procedure btnDocumentGenerateClick(Sender: TObject);
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

procedure TfrmMain.btnDocumentCreateClick(Sender: TObject);
begin
  FDocument.OpenAPI := '3.0.2';
  FDocument.Info.Title := 'OpenAPI Demo';
  FDocument.Info.Description := 'OpenAPI Demo Description';
  FDocument.Info.Contact.Name := 'Paolo Rossi';
  FDocument.Info.Contact.URL := 'https://github.com/paolo-rossi';
  FDocument.Info.License.Name := 'Apache-2.0';
  FDocument.Info.License.URL := 'http://www.apache.org/licenses/';
end;

procedure TfrmMain.btnDocumentGenerateClick(Sender: TObject);
begin
  memoDocument.Lines.Text := TNeon.ObjectToJSONString(FDocument, TOpenAPISerializer.GetNeonConfig);
end;

end.
