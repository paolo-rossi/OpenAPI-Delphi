{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Document;

interface

uses
  System.SysUtils, DUnitX.TestFramework,

  OpenAPI.Model.Classes,

  OpenAPI.Tests.Utils;

type
  /// <summary>
  ///   Document-level OpenAPI 3.1 additions: jsonSchemaDialect, info.summary,
  ///   license.identifier, webhooks and components.pathItems.
  /// </summary>
  [TestFixture]
  [Category('document')]
  TTestOpenAPIDocument31 = class(TObject)
  private
    FDocument: TOpenAPIDocument;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestOpenapiVersionString310;

    [Test]
    procedure TestOpenapiVersionString311;

    [Test]
    procedure TestJsonSchemaDialectIsDefaultedOnCreate;

    [Test]
    procedure TestJsonSchemaDialectIsOverridable;

    [Test]
    procedure TestInfoSummarySerializes;

    [Test]
    procedure TestLicenseIdentifierSerializes;

    [Test]
    procedure TestAddPathItemIsIdempotentByKey;

    [Test]
    procedure TestAddWebhookIsIdempotentByKey;

    [Test]
    procedure TestWebhookReferencingComponentsPathItem;

    [Test]
    procedure TestPathItemReferenceIsExclusiveOfOperations;
  end;

implementation

procedure TTestOpenAPIDocument31.Setup;
begin
  FDocument := TOpenAPITestUtils.NewDocument;
end;

procedure TTestOpenAPIDocument31.TearDown;
begin
  FDocument.Free;
end;

procedure TTestOpenAPIDocument31.TestOpenapiVersionString310;
var
  LDoc: TOpenAPIDocument;
begin
  LDoc := TOpenAPIDocument.Create(TOpenAPIVersion.v310);
  try
    Assert.AreEqual('3.1.0', LDoc.Openapi);
  finally
    LDoc.Free;
  end;
end;

procedure TTestOpenAPIDocument31.TestOpenapiVersionString311;
begin
  Assert.AreEqual('3.1.1', FDocument.Openapi);
end;

procedure TTestOpenAPIDocument31.TestJsonSchemaDialectIsDefaultedOnCreate;
begin
  Assert.IsFalse(FDocument.JsonSchemaDialect.IsNull);
  Assert.IsTrue(FDocument.JsonSchemaDialect.Value.Contains('2020-12') or
    FDocument.JsonSchemaDialect.Value.Contains('3.1'));
end;

procedure TTestOpenAPIDocument31.TestJsonSchemaDialectIsOverridable;
begin
  FDocument.JsonSchemaDialect := 'https://example.com/my-dialect';
  Assert.AreEqual('https://example.com/my-dialect', FDocument.JsonSchemaDialect.Value);
end;

procedure TTestOpenAPIDocument31.TestInfoSummarySerializes;
var
  LJSON: string;
begin
  FDocument.Info.Title := 'Test API';
  FDocument.Info.Version := '1.0.0';
  FDocument.Info.Summary := 'A short summary';
  LJSON := TOpenAPITestUtils.SerializeDocument(FDocument);

  Assert.IsTrue(LJSON.Contains('"summary"'));
  Assert.IsTrue(LJSON.Contains('A short summary'));
end;

procedure TTestOpenAPIDocument31.TestLicenseIdentifierSerializes;
var
  LJSON: string;
begin
  FDocument.Info.Title := 'Test API';
  FDocument.Info.Version := '1.0.0';
  FDocument.Info.License.Name := 'Apache-2.0';
  FDocument.Info.License.Identifier := 'Apache-2.0';
  LJSON := TOpenAPITestUtils.SerializeDocument(FDocument);

  Assert.IsTrue(LJSON.Contains('"identifier"'));
end;

procedure TTestOpenAPIDocument31.TestAddPathItemIsIdempotentByKey;
var
  LFirst, LSecond: TOpenAPIPathItem;
begin
  LFirst := FDocument.Components.AddPathItem('ping');
  LSecond := FDocument.Components.AddPathItem('ping');

  Assert.IsTrue(LFirst = LSecond);
  Assert.AreEqual(1, FDocument.Components.PathItems.Count);
end;

procedure TTestOpenAPIDocument31.TestAddWebhookIsIdempotentByKey;
var
  LFirst, LSecond: TOpenAPIPathItem;
begin
  LFirst := FDocument.AddWebhook('newPet');
  LSecond := FDocument.AddWebhook('newPet');

  Assert.IsTrue(LFirst = LSecond);
  Assert.AreEqual(1, FDocument.Webhooks.Count);
end;

procedure TTestOpenAPIDocument31.TestWebhookReferencingComponentsPathItem;
var
  LJSON: string;
begin
  FDocument.Components.AddPathItem('pingItem').AddOperation(TOperationType.Post).Summary := 'Ping';
  FDocument.AddWebhook('ping').SetPathItemReference('pingItem');
  LJSON := TOpenAPITestUtils.SerializeDocument(FDocument);

  Assert.IsTrue(LJSON.Contains('"webhooks"'));
  Assert.IsTrue(LJSON.Contains('"pathItems"'));
  Assert.IsTrue(LJSON.Contains('#/components/pathItems/pingItem'));
end;

procedure TTestOpenAPIDocument31.TestPathItemReferenceIsExclusiveOfOperations;
var
  LPathItem: TOpenAPIPathItem;
  LJSON: string;
begin
  // Path Item $ref is Reference Object semantics: even if operations are also
  // populated, only $ref should reach the JSON.
  LPathItem := FDocument.AddWebhook('ping');
  LPathItem.AddOperation(TOperationType.Get).Summary := 'Should not be serialized';
  LPathItem.SetPathItemReference('pingItem');

  LJSON := TOpenAPITestUtils.SerializeDocument(FDocument);

  Assert.IsTrue(LJSON.Contains('$ref'));
  Assert.IsFalse(LJSON.Contains('Should not be serialized'));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIDocument31);

end.
