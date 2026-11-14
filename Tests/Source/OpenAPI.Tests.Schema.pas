{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Schema;

interface

uses
  System.SysUtils, DUnitX.TestFramework,

  OpenAPI.Model.Schema,

  OpenAPI.Tests.Utils;

type
  /// <summary>
  ///   JSON Schema 2020-12 keyword coverage on TOpenAPISchema: type-as-array vs
  ///   single type, numeric exclusiveMinimum/Maximum, const, prefixItems,
  ///   patternProperties, and $ref-with-siblings.
  /// </summary>
  [TestFixture]
  [Category('schema')]
  TTestOpenAPISchema31 = class(TObject)
  private
    FSchema: TOpenAPISchema;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestFreshSchemaIsEmpty;

    [Test]
    procedure TestSingleTypeSerializesAsString;

    [Test]
    procedure TestTypesSerializesAsArray;

    [Test]
    procedure TestTypesTakesPrecedenceOverType_;

    [Test]
    procedure TestNoNullableKeywordIsEverEmitted;

    [Test]
    procedure TestExclusiveMinimumIsNumeric;

    [Test]
    procedure TestExclusiveMaximumIsNumeric;

    [Test]
    procedure TestConstKeyword;

    [Test]
    procedure TestPrefixItemsAndPatternPropertiesSerialize;

    [Test]
    procedure TestAddPatternPropertyIsIdempotentByKey;

    [Test]
    procedure TestAddPrefixItemAppendsEachCall;

    [Test]
    procedure TestRefAllowsSiblingKeywords;

    [Test]
    procedure TestRoundTripTypesArray;

    [Test]
    procedure TestRoundTripExclusiveMinimum;
  end;

implementation

procedure TTestOpenAPISchema31.Setup;
begin
  FSchema := TOpenAPISchema.Create;
end;

procedure TTestOpenAPISchema31.TearDown;
begin
  FSchema.Free;
end;

procedure TTestOpenAPISchema31.TestFreshSchemaIsEmpty;
begin
  Assert.IsTrue(FSchema.IsEmpty);
end;

procedure TTestOpenAPISchema31.TestSingleTypeSerializesAsString;
var
  LJSON: string;
begin
  FSchema.Type_ := 'string';
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('"string"'));
  Assert.IsFalse(LJSON.Contains('['));
end;

procedure TTestOpenAPISchema31.TestTypesSerializesAsArray;
var
  LJSON: string;
begin
  FSchema.Types := ['string', 'null'];
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('['));
  Assert.IsTrue(LJSON.Contains('"string"'));
  Assert.IsTrue(LJSON.Contains('"null"'));
end;

procedure TTestOpenAPISchema31.TestTypesTakesPrecedenceOverType_;
var
  LJSON: string;
begin
  // Both set: only one "type" key should ever reach the JSON.
  FSchema.Type_ := 'string';
  FSchema.Types := ['string', 'null'];
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.AreEqual(1, Length(LJSON.Split(['"type"'])) - 1);
end;

procedure TTestOpenAPISchema31.TestNoNullableKeywordIsEverEmitted;
var
  LJSON: string;
begin
  FSchema.Types := ['string', 'null'];
  FSchema.Title := 'Nickname';
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsFalse(LJSON.Contains('nullable'));
end;

procedure TTestOpenAPISchema31.TestExclusiveMinimumIsNumeric;
var
  LJSON: string;
begin
  FSchema.ExclusiveMinimum := 0.5;
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('exclusiveMinimum'));
  Assert.IsTrue(LJSON.Contains('0.5'));
  Assert.IsFalse(LJSON.Contains('true'));
  Assert.IsFalse(LJSON.Contains('false'));
end;

procedure TTestOpenAPISchema31.TestExclusiveMaximumIsNumeric;
var
  LJSON: string;
begin
  FSchema.ExclusiveMaximum := 100;
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('exclusiveMaximum'));
  Assert.IsTrue(LJSON.Contains('100'));
end;

procedure TTestOpenAPISchema31.TestConstKeyword;
var
  LJSON: string;
begin
  FSchema.Const_.ValueFrom<string>('pet');
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('"const"'));
  Assert.IsTrue(LJSON.Contains('"pet"'));
end;

procedure TTestOpenAPISchema31.TestPrefixItemsAndPatternPropertiesSerialize;
var
  LJSON: string;
begin
  FSchema.AddPrefixItem.Type_ := 'string';
  FSchema.AddPatternProperty('^x-').Type_ := 'string';
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('"prefixItems"'));
  Assert.IsTrue(LJSON.Contains('"patternProperties"'));
  Assert.IsTrue(LJSON.Contains('^x-'));
end;

procedure TTestOpenAPISchema31.TestAddPatternPropertyIsIdempotentByKey;
var
  LFirst, LSecond: TOpenAPISchema;
begin
  LFirst := FSchema.AddPatternProperty('^x-');
  LSecond := FSchema.AddPatternProperty('^x-');

  Assert.IsTrue(LFirst = LSecond);
  Assert.AreEqual(1, FSchema.PatternProperties.Count);
end;

procedure TTestOpenAPISchema31.TestAddPrefixItemAppendsEachCall;
begin
  FSchema.AddPrefixItem.Type_ := 'string';
  FSchema.AddPrefixItem.Type_ := 'integer';

  Assert.AreEqual(2, FSchema.PrefixItems.Count);
end;

procedure TTestOpenAPISchema31.TestRefAllowsSiblingKeywords;
var
  LJSON: string;
begin
  FSchema.Description := 'A sibling description next to $ref';
  FSchema.SetSchemaReference('Pet');
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  Assert.IsTrue(LJSON.Contains('$ref'));
  Assert.IsTrue(LJSON.Contains('sibling description'));
end;

procedure TTestOpenAPISchema31.TestRoundTripTypesArray;
var
  LJSON: string;
  LResult: TOpenAPISchema;
begin
  FSchema.Types := ['string', 'null'];
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  LResult := TOpenAPISchema.Create;
  try
    TOpenAPITestUtils.DeserializeIntoSchema(LJSON, LResult);

    Assert.AreEqual(2, Length(LResult.Types));
    Assert.AreEqual('string', LResult.Types[0]);
    Assert.AreEqual('null', LResult.Types[1]);
    Assert.IsTrue(LResult.Type_.IsNull);
  finally
    LResult.Free;
  end;
end;

procedure TTestOpenAPISchema31.TestRoundTripExclusiveMinimum;
var
  LJSON: string;
  LResult: TOpenAPISchema;
begin
  FSchema.ExclusiveMinimum := 0.5;
  LJSON := TOpenAPITestUtils.SerializeSchema(FSchema);

  LResult := TOpenAPISchema.Create;
  try
    TOpenAPITestUtils.DeserializeIntoSchema(LJSON, LResult);

    Assert.AreEqual(0.5, LResult.ExclusiveMinimum.Value, 0.0001);
  finally
    LResult.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPISchema31);

end.
