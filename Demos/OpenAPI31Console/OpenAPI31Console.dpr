{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}

/// <summary>
///   Console sanity check for the OpenAPI 3.1 / JSON Schema 2020-12 support:
///   builds a document exercising the 2020-12 keywords, prints the generated
///   JSON, round-trips it, and smoke-tests every file under Demos/Data/samples.
/// </summary>
program OpenAPI31Console;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  System.JSON,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,
  OpenAPI.Model.Classes in '..\..\Source\OpenAPI.Model.Classes.pas',
  OpenAPI.Model.Schema in '..\..\Source\OpenAPI.Model.Schema.pas',
  OpenAPI.Model.Reference in '..\..\Source\OpenAPI.Model.Reference.pas',
  OpenAPI.Model.Any in '..\..\Source\OpenAPI.Model.Any.pas',
  OpenAPI.Model.Base in '..\..\Source\OpenAPI.Model.Base.pas',
  OpenAPI.Model.Expressions in '..\..\Source\OpenAPI.Model.Expressions.pas',
  OpenAPI.Model.JsonPointer in '..\..\Source\OpenAPI.Model.JsonPointer.pas',
  OpenAPI.Core.Exceptions in '..\..\Source\OpenAPI.Core.Exceptions.pas',
  OpenAPI.Core.Interfaces in '..\..\Source\OpenAPI.Core.Interfaces.pas',
  OpenAPI.Neon.Serializers in '..\..\Source\OpenAPI.Neon.Serializers.pas';

function SamplesDir: string;
begin
  // Exe lives in Demos\Bin, samples live in Demos\Data\samples
  Result := TPath.GetDirectoryName(TPath.GetDirectoryName(ParamStr(0))) + '\Data\samples\';
end;

procedure TryOpenSample(const AConfig: INeonConfiguration; const AFileName: string);
var
  LSampleDoc: TOpenAPIDocument;
  LSampleJSON: TJSONObject;
begin
  Write('Opening ', AFileName, ' ... ');
  try
    LSampleJSON := TJSONObject.ParseJSONValue(TFile.ReadAllText(SamplesDir + AFileName)) as TJSONObject;
    try
      LSampleDoc := TOpenAPIDocument.Create(TOpenAPIVersion.v311);
      try
        TNeon.JSONToObject(LSampleDoc, LSampleJSON, AConfig);
        TNeon.ObjectToJSONString(LSampleDoc, AConfig); // force full re-serialize too
        Writeln('OK');
      finally
        LSampleDoc.Free;
      end;
    finally
      LSampleJSON.Free;
    end;
  except
    on E: Exception do
      Writeln('FAILED: ', E.ClassName, ': ', E.Message);
  end;
end;

procedure BuildAndCheckDocument(const AConfig: INeonConfiguration);
var
  LDoc, LDoc2: TOpenAPIDocument;
  LSchema, LRefSchema: TOpenAPISchema;
  LJSONText: string;
  LJSON: TJSONObject;
begin
  LDoc := TOpenAPIDocument.Create(TOpenAPIVersion.v311);
  try
    LDoc.Info.Title := 'OpenAPI 3.1 Console Check';
    LDoc.Info.Summary := 'A short summary';
    LDoc.Info.Version := '1.0.0';
    LDoc.Info.License.Name := 'Apache-2.0';
    LDoc.Info.License.Identifier := 'Apache-2.0';

    // Schema keyword checks
    LSchema := LDoc.Components.AddSchema('Nullable');
    LSchema.Types := ['string', 'null'];
    LSchema.ExclusiveMinimum := 0.5;
    LSchema.Const_.ValueFrom<string>('foo');
    LSchema.AddPrefixItem.Type_ := 'string';
    LSchema.AddPatternProperty('^x-').Type_ := 'string';

    // $ref + sibling keyword (2020-12 allows this; OAS 3.0 didn't)
    LRefSchema := LDoc.Components.AddSchema('RefWithSibling');
    LRefSchema.Description := 'A sibling description next to $ref';
    LRefSchema.SetSchemaReference('Nullable');

    // Webhook -> Components.PathItems via $ref
    LDoc.Components.AddPathItem('pingItem').AddOperation(TOperationType.Post).Summary := 'Ping';
    LDoc.AddWebhook('ping').SetPathItemReference('pingItem');

    LJSONText := TNeon.ObjectToJSONString(LDoc, AConfig);
    Writeln('--- Serialized 3.1 document ---');
    Writeln(LJSONText);
    Writeln;

    Writeln('--- Checks ---');
    Writeln('Contains "nullable" (should be False): ', LJSONText.Contains('"nullable"'));
    Writeln('Contains type array (should be True): ', LJSONText.Contains('"type": [') or LJSONText.Contains('"type":['));
    Writeln('Contains numeric exclusiveMinimum (should be True): ', LJSONText.Contains('"exclusiveMinimum": 0.5') or LJSONText.Contains('"exclusiveMinimum":0.5'));
    Writeln('Contains const foo (should be True): ', LJSONText.Contains('"const": "foo"') or LJSONText.Contains('"const":"foo"'));
    Writeln('Contains jsonSchemaDialect (should be True): ', LJSONText.Contains('jsonSchemaDialect'));
    Writeln('Contains webhooks (should be True): ', LJSONText.Contains('"webhooks"'));
    Writeln('Contains components.pathItems (should be True): ', LJSONText.Contains('"pathItems"'));
    Writeln('RefWithSibling has both $ref and description (should be True): ',
      LJSONText.Contains('sibling description') and LJSONText.Contains('$ref'));
    Writeln;

    // Round-trip: deserialize back and re-serialize
    LJSON := TJSONObject.ParseJSONValue(LJSONText) as TJSONObject;
    try
      LDoc2 := TOpenAPIDocument.Create(TOpenAPIVersion.v311);
      try
        TNeon.JSONToObject(LDoc2, LJSON, AConfig);
        Writeln('--- Round-trip re-serialized ---');
        Writeln(TNeon.ObjectToJSONString(LDoc2, AConfig));
      finally
        LDoc2.Free;
      end;
    finally
      LJSON.Free;
    end;
  finally
    LDoc.Free;
  end;
end;

var
  LConfig: INeonConfiguration;
  LFileName: string;
begin
  try
    LConfig := TOpenAPISerializer.GetNeonConfig;

    BuildAndCheckDocument(LConfig);

    Writeln;
    Writeln('--- Opening every file under Demos/Data/samples ---');
    for LFileName in TDirectory.GetFiles(SamplesDir, '*.json') do
      TryOpenSample(LConfig, TPath.GetFileName(LFileName));

    Writeln;
    Writeln('DONE');
  except
    on E: Exception do
    begin
      Writeln('EXCEPTION: ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
