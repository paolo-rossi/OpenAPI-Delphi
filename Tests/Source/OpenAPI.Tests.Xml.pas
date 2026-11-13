{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Xml;

interface

uses
  System.SysUtils, System.Classes, System.JSON, DUnitX.TestFramework,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,

  OpenAPI.Model.Classes,
  OpenAPI.Model.Schema,

  OpenAPI.Tests.Utils;

type
  /// <summary>
  ///   The XML Object ("xml" on a Schema Object)
  /// </summary>
  [TestFixture]
  [Category('xml')]
  TTestOpenAPIXml = class(TObject)
  private
    FDocument: TOpenAPIDocument;
    FErrors: TStringList;
    function Config: INeonConfiguration;
    procedure Load(const AJSON: string);
    function Save: TJSONObject;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestXmlIsNotCreatedByDefault;

    [Test]
    procedure TestReadXml;

    [Test]
    procedure TestXmlRoundTrip;

    [Test]
    procedure TestXmlFromCode;

    [Test]
    procedure TestSchemaWithOnlyXmlIsNotEmpty;

    [Test]
    procedure TestXmlExtensionsRoundTrip;
  end;

implementation

const
  DocHeader = '{"openapi":"3.1.1","info":{"title":"t","version":"1"},';
  PetSchema =
    '{"type":"object",' +
    '"properties":{' +
      '"id":{"type":"integer","xml":{"attribute":true}},' +
      '"name":{"type":"string"},' +
      '"tags":{"type":"array","items":{"type":"string","xml":{"name":"tag"}},"xml":{"name":"tags","wrapped":true}}},' +
    '"xml":{"name":"pet","namespace":"https://example.com/schema","prefix":"ex"}}';

{ TTestOpenAPIXml }

procedure TTestOpenAPIXml.Setup;
begin
  FDocument := TOpenAPITestUtils.NewDocument;
  FErrors := TStringList.Create;
end;

procedure TTestOpenAPIXml.TearDown;
begin
  FErrors.Free;
  FDocument.Free;
end;

function TTestOpenAPIXml.Config: INeonConfiguration;
var
  LErrors: TStringList;
begin
  LErrors := FErrors;
  Result := TOpenAPITestUtils.Config;
  Result.SetPrettyPrint(False);
  Result.SetOnError(
    procedure (const AMessage: string; AOperation: TNeonOperation)
    begin
      LErrors.Add(AMessage);
    end
  );
end;

procedure TTestOpenAPIXml.Load(const AJSON: string);
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

function TTestOpenAPIXml.Save: TJSONObject;
begin
  Result := TNeon.ObjectToJSON(FDocument, Config) as TJSONObject;
  Assert.AreEqual('', FErrors.Text, 'Neon logged errors while writing');
end;

procedure TTestOpenAPIXml.TestXmlIsNotCreatedByDefault;
var
  LJSON: TJSONObject;
begin
  FDocument.Components.AddSchema('Plain').Type_ := 'string';
  Assert.IsNull(FDocument.Components.Schemas['Plain'].Xml);

  LJSON := Save;
  try
    Assert.AreEqual('{"type":"string"}', LJSON.FindValue('components.schemas.Plain').ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIXml.TestReadXml;
var
  LPet: TOpenAPISchema;
begin
  Load(DocHeader + '"components":{"schemas":{"Pet":' + PetSchema + '}}}');

  LPet := FDocument.Components.Schemas['Pet'];
  Assert.IsNotNull(LPet.Xml);
  Assert.AreEqual('pet', LPet.Xml.Name.Value);
  Assert.AreEqual('https://example.com/schema', LPet.Xml.Namespace.Value);
  Assert.AreEqual('ex', LPet.Xml.Prefix.Value);
  Assert.IsTrue(LPet.Xml.Attribute.IsNull);

  Assert.IsTrue(LPet.Properties['id'].Xml.Attribute.Value);
  Assert.IsNull(LPet.Properties['name'].Xml);
  Assert.IsTrue(LPet.Properties['tags'].Xml.Wrapped.Value);
  Assert.AreEqual('tag', LPet.Properties['tags'].Items.Xml.Name.Value);
end;

procedure TTestOpenAPIXml.TestXmlRoundTrip;
var
  LJSON: TJSONObject;
  LExpected: TJSONValue;
begin
  Load(DocHeader + '"components":{"schemas":{"Pet":' + PetSchema + '}}}');

  LJSON := Save;
  LExpected := TJSONObject.ParseJSONValue(PetSchema);
  try
    // Compare parsed values, not text: member order follows the class declaration
    Assert.AreEqual(LExpected.FindValue('xml').ToJSON, LJSON.FindValue('components.schemas.Pet.xml').ToJSON);
    Assert.AreEqual('{"attribute":true}', LJSON.FindValue('components.schemas.Pet.properties.id.xml').ToJSON);
    Assert.IsNull(LJSON.FindValue('components.schemas.Pet.properties.name.xml'));
    Assert.AreEqual('{"name":"tags","wrapped":true}',
      LJSON.FindValue('components.schemas.Pet.properties.tags.xml').ToJSON);
    Assert.AreEqual('{"name":"tag"}', LJSON.FindValue('components.schemas.Pet.properties.tags.items.xml').ToJSON);
  finally
    LExpected.Free;
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIXml.TestXmlFromCode;
var
  LSchema: TOpenAPISchema;
  LJSON: TJSONObject;
begin
  LSchema := FDocument.Components.AddSchema('Order');
  LSchema.Type_ := 'object';
  LSchema.AddXml.Name := 'order';
  Assert.IsTrue(LSchema.AddXml = LSchema.Xml, 'AddXml returns the existing object');
  LSchema.AddProperty('id').AddXml.Attribute := True;

  LJSON := Save;
  try
    Assert.AreEqual('{"name":"order"}', LJSON.FindValue('components.schemas.Order.xml').ToJSON);
    Assert.AreEqual('{"attribute":true}', LJSON.FindValue('components.schemas.Order.properties.id.xml').ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIXml.TestSchemaWithOnlyXmlIsNotEmpty;
var
  LSchema: TOpenAPISchema;
begin
  LSchema := TOpenAPISchema.Create;
  try
    Assert.IsTrue(LSchema.IsEmpty);
    LSchema.AddXml.Name := 'x';
    Assert.IsFalse(LSchema.IsEmpty);
  finally
    LSchema.Free;
  end;
end;

procedure TTestOpenAPIXml.TestXmlExtensionsRoundTrip;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"components":{"schemas":{"A":{"type":"string","xml":{"name":"a","x-custom":"v"}}}}}');

  LJSON := Save;
  try
    Assert.AreEqual('a', LJSON.FindValue('components.schemas.A.xml.name').Value);
    Assert.AreEqual('v', LJSON.FindValue('components.schemas.A.xml.x-custom').Value);
  finally
    LJSON.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIXml);

end.
