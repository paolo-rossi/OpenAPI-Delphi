program DemoOpenAPI;

uses
  Vcl.Forms,
  Demo.Form.Main in 'Demo.Form.Main.pas' {frmMain},
  OpenAPI.Core.Interfaces in '..\..\Source\OpenAPI.Core.Interfaces.pas',
  OpenAPI.Core.Exceptions in '..\..\Source\OpenAPI.Core.Exceptions.pas',
  OpenAPI.Model.Any in '..\..\Source\OpenAPI.Model.Any.pas',
  OpenAPI.Model.Schema in '..\..\Source\OpenAPI.Model.Schema.pas',
  OpenAPI.Model.Classes in '..\..\Source\OpenAPI.Model.Classes.pas',
  OpenAPI.Model.Reference in '..\..\Source\OpenAPI.Model.Reference.pas',
  OpenAPI.Model.Expressions in '..\..\Source\OpenAPI.Model.Expressions.pas',
  OpenAPI.Model.JsonPointer in '..\..\Source\OpenAPI.Model.JsonPointer.pas',
  OpenAPI.Neon.Serializers in '..\..\Source\OpenAPI.Neon.Serializers.pas',
  OpenAPI.Model.Base in '..\..\Source\OpenAPI.Model.Base.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
