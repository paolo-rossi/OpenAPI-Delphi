{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.ReferenceIO;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils, DUnitX.TestFramework,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,

  OpenAPI.Model.Classes,
  OpenAPI.Model.Reference,
  OpenAPI.Model.Schema,

  OpenAPI.Tests.Utils;

type
  /// <summary>
  ///   Reading and writing "$ref" through the Neon serializers: every object that can be a
  ///   Reference Object, path-level members, and a round-trip of the sample documents.
  /// </summary>
  [TestFixture]
  [Category('reference')]
  TTestOpenAPIReferenceIO = class(TObject)
  private
    FDocument: TOpenAPIDocument;
    FErrors: TStringList;
    function Config: INeonConfiguration;
    procedure Load(const AJSON: string);
    function Save: TJSONObject;
    class function JSONAt(AValue: TJSONValue; const APath: array of string): TJSONValue; static;
    class procedure CollectRefs(AValue: TJSONValue; AList: TStrings); static;
    class function SamplesDir: string; static;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestReadSchemaReference;

    [Test]
    procedure TestReadSchemaReferenceWithSiblingKeyword;

    [Test]
    procedure TestReadParameterReference;

    [Test]
    procedure TestWriteParameterReferenceAlone;

    [Test]
    procedure TestReadResponseReference;

    [Test]
    procedure TestReadRequestBodyReference;

    [Test]
    procedure TestReadExampleReference;

    [Test]
    procedure TestReadHeaderReference;

    [Test]
    procedure TestReadPathItemReference;

    [Test]
    procedure TestReadPathLevelMembers;

    [Test]
    procedure TestNonComponentsReferencesRoundTrip;

    [Test]
    procedure TestNullReferenceIsIgnored;

    [Test]
    procedure TestSampleDocumentsKeepEveryReference;
  end;

implementation

const
  DocHeader = '{"openapi":"3.1.1","info":{"title":"t","version":"1"},';

{ TTestOpenAPIReferenceIO }

procedure TTestOpenAPIReferenceIO.Setup;
begin
  FDocument := TOpenAPITestUtils.NewDocument;
  FErrors := TStringList.Create;
end;

procedure TTestOpenAPIReferenceIO.TearDown;
begin
  FErrors.Free;
  FDocument.Free;
end;

function TTestOpenAPIReferenceIO.Config: INeonConfiguration;
var
  LErrors: TStringList;
begin
  LErrors := FErrors;
  Result := TOpenAPITestUtils.Config;
  Result.SetOnError(
    procedure (const AMessage: string; AOperation: TNeonOperation)
    begin
      LErrors.Add(AMessage);
    end
  );
end;

procedure TTestOpenAPIReferenceIO.Load(const AJSON: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AJSON);
  Assert.IsNotNull(LJSON, 'Invalid test JSON');
  try
    TNeon.JSONToObject(FDocument, LJSON, Config);
  finally
    LJSON.Free;
  end;
  Assert.AreEqual('', FErrors.Text, 'Neon logged errors while reading');
end;

function TTestOpenAPIReferenceIO.Save: TJSONObject;
begin
  Result := TNeon.ObjectToJSON(FDocument, Config) as TJSONObject;
  Assert.AreEqual('', FErrors.Text, 'Neon logged errors while writing');
end;

class function TTestOpenAPIReferenceIO.JSONAt(AValue: TJSONValue; const APath: array of string): TJSONValue;
var
  LKey: string;
begin
  // Walks object keys and array indexes; keys may contain '/' (paths), so no JSON-path syntax
  Result := AValue;
  for LKey in APath do
  begin
    if Result is TJSONObject then
      Result := TJSONObject(Result).Values[LKey]
    else if Result is TJSONArray then
      Result := TJSONArray(Result).Items[LKey.ToInteger]
    else
      Result := nil;
    if Result = nil then
      Exit;
  end;
end;

class procedure TTestOpenAPIReferenceIO.CollectRefs(AValue: TJSONValue; AList: TStrings);
var
  LPair: TJSONPair;
  LItem: TJSONValue;
begin
  if AValue is TJSONObject then
  begin
    for LPair in TJSONObject(AValue) do
      if (LPair.JsonString.Value = '$ref') and (LPair.JsonValue is TJSONString) then
        AList.Add(LPair.JsonValue.Value)
      else
        CollectRefs(LPair.JsonValue, AList);
  end
  else if AValue is TJSONArray then
    for LItem in TJSONArray(AValue) do
      CollectRefs(LItem, AList);
end;

class function TTestOpenAPIReferenceIO.SamplesDir: string;

  function FindUpwards(const AStart: string): string;
  var
    LDir: string;
  begin
    Result := '';
    LDir := AStart;
    while LDir <> '' do
    begin
      if TDirectory.Exists(TPath.Combine(LDir, 'Demos\Data\samples')) then
        Exit(TPath.Combine(LDir, 'Demos\Data\samples'));
      if TPath.GetDirectoryName(LDir) = LDir then
        Exit;
      LDir := TPath.GetDirectoryName(LDir);
    end;
  end;

begin
  // The exe normally lives in Tests\Bin, the samples in Demos\Data\samples. When the exe is
  // built elsewhere, run it from inside the repository
  Result := FindUpwards(TPath.GetDirectoryName(ParamStr(0)));
  if Result = '' then
    Result := FindUpwards(GetCurrentDir);
end;

procedure TTestOpenAPIReferenceIO.TestReadSchemaReference;
var
  LSchema: TOpenAPISchema;
begin
  Load(DocHeader + '"components":{"schemas":{"Pet":{"type":"object","properties":' +
    '{"owner":{"$ref":"#/components/schemas/Person"}}}}}}');

  LSchema := FDocument.Components.Schemas['Pet'].Properties['owner'];
  Assert.IsTrue(LSchema.IsReference);
  Assert.AreEqual('Person', LSchema.Reference.Id);
  Assert.IsTrue(LSchema.Reference.Target = TOpenAPIReferenceTarget.Schemas);
end;

procedure TTestOpenAPIReferenceIO.TestReadSchemaReferenceWithSiblingKeyword;
var
  LSchema: TOpenAPISchema;
  LJSON: TJSONObject;
begin
  // JSON Schema 2020-12: keywords next to $ref are part of the schema
  Load(DocHeader + '"components":{"schemas":{"Pet":{"$ref":"#/components/schemas/Animal",' +
    '"description":"A pet"}}}}');

  LSchema := FDocument.Components.Schemas['Pet'];
  Assert.AreEqual('Animal', LSchema.Reference.Id);
  Assert.AreEqual('A pet', LSchema.Description.Value);

  LJSON := Save;
  try
    Assert.AreEqual('#/components/schemas/Animal', JSONAt(LJSON, ['components', 'schemas', 'Pet', '$ref']).Value);
    Assert.AreEqual('A pet', JSONAt(LJSON, ['components', 'schemas', 'Pet', 'description']).Value);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadParameterReference;
var
  LParam: TOpenAPIParameter;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"parameters":[{"$ref":"#/components/parameters/Id"}],' +
    '"responses":{"200":{"description":"ok"}}}}}}');

  LParam := FDocument.Paths['/a'].Get.Parameters[0];
  Assert.IsTrue(LParam.IsReference);
  Assert.AreEqual('Id', LParam.Reference.Id);
  Assert.IsTrue(LParam.Reference.Target = TOpenAPIReferenceTarget.Parameters);
end;

procedure TTestOpenAPIReferenceIO.TestWriteParameterReferenceAlone;
var
  LParams: TJSONValue;
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"parameters":[{"$ref":"#/components/parameters/Id"}],' +
    '"responses":{"200":{"description":"ok"}}}}}}');

  LJSON := Save;
  try
    // A parameter must have name and in, but a Reference Object has only $ref
    LParams := JSONAt(LJSON, ['paths', '/a', 'get', 'parameters', '0']);
    Assert.IsTrue(LParams is TJSONObject);
    Assert.AreEqual(1, TJSONObject(LParams).Count, LParams.ToJSON);
    Assert.AreEqual('#/components/parameters/Id', TJSONObject(LParams).Values['$ref'].Value);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadResponseReference;
var
  LResponse: TOpenAPIResponse;
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"responses":{"default":{"$ref":"#/components/responses/Error"}}}}}}');

  LResponse := FDocument.Paths['/a'].Get.Responses['default'];
  Assert.AreEqual('Error', LResponse.Reference.Id);
  Assert.IsTrue(LResponse.Reference.Target = TOpenAPIReferenceTarget.Responses);

  LJSON := Save;
  try
    Assert.AreEqual('{"$ref":"#/components/responses/Error"}',
      JSONAt(LJSON, ['paths', '/a', 'get', 'responses', 'default']).ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadRequestBodyReference;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"post":{"requestBody":{"$ref":"#/components/requestBodies/Body"},' +
    '"responses":{"200":{"description":"ok"}}}}}}');

  Assert.AreEqual('Body', FDocument.Paths['/a'].Post.RequestBody.Reference.Id);
  Assert.IsTrue(FDocument.Paths['/a'].Post.RequestBody.Reference.Target = TOpenAPIReferenceTarget.RequestBodies);

  LJSON := Save;
  try
    Assert.AreEqual('{"$ref":"#/components/requestBodies/Body"}',
      JSONAt(LJSON, ['paths', '/a', 'post', 'requestBody']).ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadExampleReference;
var
  LMediaType: TOpenAPIMediaType;
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"responses":{"200":{"description":"ok","content":' +
    '{"application/json":{"examples":{"first":{"$ref":"#/components/examples/Cursor"}}}}}}}}}}');

  LMediaType := FDocument.Paths['/a'].Get.Responses['200'].Content['application/json'];
  Assert.AreEqual('Cursor', LMediaType.Examples['first'].Reference.Id);
  Assert.IsTrue(LMediaType.Examples['first'].Reference.Target = TOpenAPIReferenceTarget.Examples);

  LJSON := Save;
  try
    Assert.AreEqual('#/components/examples/Cursor', JSONAt(LJSON, ['paths', '/a', 'get', 'responses',
      '200', 'content', 'application/json', 'examples', 'first', '$ref']).Value);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadHeaderReference;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"responses":{"200":{"description":"ok","headers":' +
    '{"X-Rate":{"$ref":"#/components/headers/Rate"}}}}}}}}');

  Assert.AreEqual('Rate', FDocument.Paths['/a'].Get.Responses['200'].Headers['X-Rate'].Reference.Id);

  LJSON := Save;
  try
    Assert.AreEqual('{"$ref":"#/components/headers/Rate"}',
      JSONAt(LJSON, ['paths', '/a', 'get', 'responses', '200', 'headers', 'X-Rate']).ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadPathItemReference;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"webhooks":{"ping":{"$ref":"#/components/pathItems/PingItem"}}}');

  Assert.AreEqual('PingItem', FDocument.Webhooks['ping'].Reference.Id);
  Assert.IsTrue(FDocument.Webhooks['ping'].Reference.Target = TOpenAPIReferenceTarget.PathItems);

  LJSON := Save;
  try
    Assert.AreEqual('{"$ref":"#/components/pathItems/PingItem"}', JSONAt(LJSON, ['webhooks', 'ping']).ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestReadPathLevelMembers;
var
  LPath: TOpenAPIPathItem;
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"summary":"S","description":"D",' +
    '"servers":[{"url":"https://example.com"}],' +
    '"parameters":[{"$ref":"#/components/parameters/Version"},{"name":"id","in":"path","required":true}],' +
    '"get":{"responses":{"200":{"description":"ok"}}}}}}');

  LPath := FDocument.Paths['/a'];
  Assert.AreEqual('S', LPath.Summary.Value);
  Assert.AreEqual('D', LPath.Description.Value);
  Assert.AreEqual(1, LPath.Servers.Count);
  Assert.AreEqual('https://example.com', LPath.Servers[0].Url);
  Assert.AreEqual(2, LPath.Parameters.Count);
  Assert.AreEqual('Version', LPath.Parameters[0].Reference.Id);
  Assert.AreEqual('id', LPath.Parameters[1].Name);
  Assert.IsNotNull(LPath.Get, 'Operations are still read');

  LJSON := Save;
  try
    Assert.AreEqual('#/components/parameters/Version',
      JSONAt(LJSON, ['paths', '/a', 'parameters', '0', '$ref']).Value);
    Assert.AreEqual('https://example.com', JSONAt(LJSON, ['paths', '/a', 'servers', '0', 'url']).Value);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestNonComponentsReferencesRoundTrip;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"components":{"schemas":{"Node":{"type":"object","properties":{' +
    '"a":{"$ref":"#/$defs/Child"},' +
    '"b":{"$ref":"common.json#/components/schemas/Pet"},' +
    '"c":{"$ref":"common.json"}}}}}}');

  LJSON := Save;
  try
    Assert.AreEqual('#/$defs/Child',
      JSONAt(LJSON, ['components', 'schemas', 'Node', 'properties', 'a', '$ref']).Value);
    Assert.AreEqual('common.json#/components/schemas/Pet',
      JSONAt(LJSON, ['components', 'schemas', 'Node', 'properties', 'b', '$ref']).Value);
    Assert.AreEqual('common.json',
      JSONAt(LJSON, ['components', 'schemas', 'Node', 'properties', 'c', '$ref']).Value);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIReferenceIO.TestNullReferenceIsIgnored;
begin
  Load(DocHeader + '"components":{"schemas":{"Pet":{"$ref":null,"type":"object"}}}}');

  Assert.IsFalse(FDocument.Components.Schemas['Pet'].IsReference);
  Assert.AreEqual('object', FDocument.Components.Schemas['Pet'].Type_.Value);
end;

procedure TTestOpenAPIReferenceIO.TestSampleDocumentsKeepEveryReference;
var
  LDir, LFile: string;
  LIn: TJSONValue;
  LOut: TJSONObject;
  LRefsIn, LRefsOut: TStringList;
  LCount: Integer;
begin
  LDir := SamplesDir;
  if LDir = '' then
    Assert.Fail('Demos\Data\samples not found above the exe or the current directory');

  LCount := 0;
  LRefsIn := TStringList.Create;
  LRefsOut := TStringList.Create;
  try
    for LFile in TDirectory.GetFiles(LDir, '*.json') do
    begin
      FDocument.Free;
      FDocument := TOpenAPITestUtils.NewDocument;
      LRefsIn.Clear;
      LRefsOut.Clear;

      LIn := TJSONObject.ParseJSONValue(TFile.ReadAllText(LFile, TEncoding.UTF8));
      try
        TNeon.JSONToObject(FDocument, LIn, Config);
        CollectRefs(LIn, LRefsIn);
      finally
        LIn.Free;
      end;

      LOut := Save;
      try
        CollectRefs(LOut, LRefsOut);
      finally
        LOut.Free;
      end;

      LRefsIn.Sort;
      LRefsOut.Sort;
      Assert.AreEqual(LRefsIn.Text, LRefsOut.Text, TPath.GetFileName(LFile) + ': $ref values differ');
      Assert.AreEqual('', FErrors.Text, TPath.GetFileName(LFile) + ': Neon logged errors');
      Inc(LCount);
    end;
  finally
    LRefsIn.Free;
    LRefsOut.Free;
  end;

  Assert.IsTrue(LCount > 0, 'No sample documents found in ' + LDir);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIReferenceIO);

end.
