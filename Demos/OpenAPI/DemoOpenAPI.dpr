program DemoOpenAPI;

uses
  Vcl.Forms,
  Demo.Form.Main in 'Demo.Form.Main.pas' {frmMain},
  OpenAPI.Any in '..\..\Source\OpenAPI.Any.pas',
  OpenAPI.Exceptions in '..\..\Source\OpenAPI.Exceptions.pas',
  OpenAPI.Expressions in '..\..\Source\OpenAPI.Expressions.pas',
  OpenAPI.Interfaces in '..\..\Source\OpenAPI.Interfaces.pas',
  OpenAPI.JsonPointer in '..\..\Source\OpenAPI.JsonPointer.pas',
  OpenAPI.Models in '..\..\Source\OpenAPI.Models.pas',
  OpenAPI.Nullables in '..\..\Source\OpenAPI.Nullables.pas',
  OpenAPI.Reference in '..\..\Source\OpenAPI.Reference.pas',
  OpenAPI.Schema in '..\..\Source\OpenAPI.Schema.pas',
  OpenAPI.Serializer in '..\..\Source\OpenAPI.Serializer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
