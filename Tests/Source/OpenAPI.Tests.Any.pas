{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Any;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Rtti, DUnitX.TestFramework,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,

  OpenAPI.Model.Any,
  OpenAPI.Model.Classes,
  OpenAPI.Model.Schema,

  OpenAPI.Tests.Utils;

type
  /// <summary>
  ///   "Any" values (TOpenAPIAny): example, value, default, const and enum items, read from and
  ///   written to JSON
  /// </summary>
  [TestFixture]
  [Category('any')]
  TTestOpenAPIAny = class(TObject)
  private
    FSchema: TOpenAPISchema;
    FErrors: TStringList;
    function Config: INeonConfiguration;
    procedure LoadSchema(const AJSON: string);
    function SaveSchema: TJSONObject;
    function RoundTripMember(const AMember, AJSONValue: string): string;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestNewAnyIsEmpty;

    [Test]
    procedure TestSetJSONValueReplacesScalar;

    [Test]
    procedure TestSetValueReplacesJSONValue;

    [Test]
    procedure TestClear;

    [Test]
    procedure TestString;

    [Test]
    procedure TestObject;

    [Test]
    procedure TestArray;

    [Test]
    procedure TestNull;

    [Test]
    procedure TestFalsyScalarsAreKept;

    [Test]
    procedure TestIntegerStaysInteger;

    [Test]
    procedure TestLargeIntegerKeepsPrecision;

    [Test]
    procedure TestFloat;

    [Test]
    procedure TestReadIntegerAsInteger;

    [Test]
    procedure TestDefaultObjectAndConstNull;

    [Test]
    procedure TestEnumWithMixedValues;

    [Test]
    procedure TestUnsetValueIsOmitted;

    [Test]
    procedure TestSchemaWithOnlyDefaultIsNotEmpty;

    [Test]
    procedure TestExampleObjectValueAndMediaTypeExample;

    [Test]
    procedure TestSchemaExampleIsNotSupported;
  end;

implementation

{ TTestOpenAPIAny }

procedure TTestOpenAPIAny.Setup;
begin
  FSchema := TOpenAPISchema.Create;
  FErrors := TStringList.Create;
end;

procedure TTestOpenAPIAny.TearDown;
begin
  FErrors.Free;
  FSchema.Free;
end;

function TTestOpenAPIAny.Config: INeonConfiguration;
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

procedure TTestOpenAPIAny.LoadSchema(const AJSON: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AJSON);
  Assert.IsNotNull(LJSON, 'Invalid test JSON');
  try
    TNeon.JSONToObject(FSchema, LJSON, Config);
  finally
    LJSON.Free;
  end;
  Assert.AreEqual('', FErrors.Text, 'Neon logged errors while reading');
end;

function TTestOpenAPIAny.SaveSchema: TJSONObject;
begin
  Result := TNeon.ObjectToJSON(FSchema, Config) as TJSONObject;
  Assert.AreEqual('', FErrors.Text, 'Neon logged errors while writing');
end;

function TTestOpenAPIAny.RoundTripMember(const AMember, AJSONValue: string): string;
var
  LJSON: TJSONObject;
  LValue: TJSONValue;
begin
  // Reads {"<member>": <value>} into a fresh schema and returns the member as written back
  FSchema.Free;
  FSchema := TOpenAPISchema.Create;
  LoadSchema('{"' + AMember + '":' + AJSONValue + '}');

  LJSON := SaveSchema;
  try
    LValue := LJSON.Values[AMember];
    if LValue = nil then
      Result := '<missing>'
    else
      Result := LValue.ToJSON;
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIAny.TestNewAnyIsEmpty;
begin
  Assert.IsTrue(FSchema.Default_.IsEmpty);
  Assert.IsNull(FSchema.Default_.JSONValue);
end;

procedure TTestOpenAPIAny.TestSetJSONValueReplacesScalar;
begin
  FSchema.Default_.ValueFrom<string>('x');
  FSchema.Default_.SetJSONValue(TJSONObject.Create);

  Assert.IsTrue(FSchema.Default_.Value.IsEmpty);
  Assert.IsNotNull(FSchema.Default_.JSONValue);
  Assert.IsFalse(FSchema.Default_.IsEmpty);
end;

procedure TTestOpenAPIAny.TestSetValueReplacesJSONValue;
begin
  FSchema.Default_.SetJSONValue(TJSONArray.Create);
  FSchema.Default_.ValueFrom<Integer>(1);

  // The JSON value is freed (a leak would fail the test run)
  Assert.IsNull(FSchema.Default_.JSONValue);
  Assert.AreEqual(1, FSchema.Default_.Value.AsInteger);
end;

procedure TTestOpenAPIAny.TestClear;
begin
  FSchema.Default_.SetJSONValue(TJSONObject.Create);
  FSchema.Default_.Clear;
  Assert.IsTrue(FSchema.Default_.IsEmpty);

  FSchema.Default_.ValueFrom<string>('x');
  FSchema.Default_.Clear;
  Assert.IsTrue(FSchema.Default_.IsEmpty);
end;

procedure TTestOpenAPIAny.TestString;
begin
  Assert.AreEqual('"1Password Extension"', RoundTripMember('default', '"1Password Extension"'));
  Assert.AreEqual('1Password Extension', FSchema.Default_.Value.AsString);
end;

procedure TTestOpenAPIAny.TestObject;
begin
  Assert.AreEqual('{"id":1,"tags":["a","b"],"owner":{"name":"x"}}',
    RoundTripMember('default', '{"id":1,"tags":["a","b"],"owner":{"name":"x"}}'));
  Assert.IsTrue(FSchema.Default_.JSONValue is TJSONObject);
end;

procedure TTestOpenAPIAny.TestArray;
begin
  Assert.AreEqual('[1,"two",{"three":3}]', RoundTripMember('default', '[1,"two",{"three":3}]'));
  Assert.IsTrue(FSchema.Default_.JSONValue is TJSONArray);
end;

procedure TTestOpenAPIAny.TestNull;
begin
  Assert.AreEqual('null', RoundTripMember('default', 'null'));
  Assert.IsTrue(FSchema.Default_.JSONValue is TJSONNull);
end;

procedure TTestOpenAPIAny.TestFalsyScalarsAreKept;
begin
  Assert.AreEqual('0', RoundTripMember('default', '0'));
  Assert.AreEqual('false', RoundTripMember('default', 'false'));
  Assert.AreEqual('""', RoundTripMember('default', '""'));
  Assert.AreEqual('0', RoundTripMember('default', '0'));
  Assert.AreEqual('false', RoundTripMember('const', 'false'));
end;

procedure TTestOpenAPIAny.TestIntegerStaysInteger;
begin
  Assert.AreEqual('42', RoundTripMember('default', '42'));
  Assert.AreEqual('-7', RoundTripMember('default', '-7'));
end;

procedure TTestOpenAPIAny.TestLargeIntegerKeepsPrecision;
begin
  // Past 2^53 a Double can't hold every integer
  Assert.AreEqual('9007199254740993', RoundTripMember('default', '9007199254740993'));
end;

procedure TTestOpenAPIAny.TestFloat;
begin
  Assert.AreEqual('1.5', RoundTripMember('default', '1.5'));
end;

procedure TTestOpenAPIAny.TestReadIntegerAsInteger;
begin
  RoundTripMember('default', '42');
  Assert.IsTrue(FSchema.Default_.Value.Kind = tkInteger, 'An integer should be read as Integer');

  RoundTripMember('default', '9007199254740993');
  Assert.IsTrue(FSchema.Default_.Value.Kind = tkInt64, 'A large integer should be read as Int64');

  RoundTripMember('default', '1.5');
  Assert.IsTrue(FSchema.Default_.Value.Kind = tkFloat);
end;

procedure TTestOpenAPIAny.TestDefaultObjectAndConstNull;
begin
  Assert.AreEqual('{"a":1}', RoundTripMember('default', '{"a":1}'));
  Assert.AreEqual('null', RoundTripMember('const', 'null'));
end;

procedure TTestOpenAPIAny.TestEnumWithMixedValues;
begin
  Assert.AreEqual('["a",1,true,null,{"b":2}]', RoundTripMember('enum', '["a",1,true,null,{"b":2}]'));
  Assert.AreEqual(5, FSchema.Enum.Count);
end;

procedure TTestOpenAPIAny.TestUnsetValueIsOmitted;
var
  LJSON: TJSONObject;
begin
  FSchema.Type_ := 'string';
  LJSON := SaveSchema;
  try
    Assert.IsNull(LJSON.Values['default']);
    Assert.IsNull(LJSON.Values['const']);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPIAny.TestSchemaWithOnlyDefaultIsNotEmpty;
begin
  FSchema.Default_.ValueFrom<string>('x');
  Assert.IsFalse(FSchema.IsEmpty);
end;

procedure TTestOpenAPIAny.TestExampleObjectValueAndMediaTypeExample;
var
  LDocument: TOpenAPIDocument;
  LIn: TJSONValue;
  LOut: TJSONObject;
  LMediaType: TJSONValue;
const
  DocJSON =
    '{"openapi":"3.1.1","info":{"title":"t","version":"1"},' +
    '"paths":{"/a":{"get":{"responses":{"200":{"description":"ok","content":{"application/json":{' +
    '"example":{"items":[]},' +
    '"examples":{"first":{"summary":"S","value":{"cursor":"abc"}}}}}}}}}},' +
    '"components":{"examples":{"Cursor":{"value":{"cursor":""}}}}}';
begin
  LDocument := TOpenAPITestUtils.NewDocument;
  try
    LIn := TJSONObject.ParseJSONValue(DocJSON);
    try
      TNeon.JSONToObject(LDocument, LIn, Config);
    finally
      LIn.Free;
    end;

    LOut := TNeon.ObjectToJSON(LDocument, Config) as TJSONObject;
    try
      Assert.AreEqual('', FErrors.Text, 'Neon logged errors');
      LMediaType := LOut.FindValue('paths./a.get.responses.200.content.application/json');
      Assert.IsNotNull(LMediaType);
      Assert.AreEqual('{"items":[]}', TJSONObject(LMediaType).Values['example'].ToJSON);
      Assert.AreEqual('{"cursor":"abc"}',
        TJSONObject(TJSONObject(TJSONObject(LMediaType).Values['examples']).Values['first']).Values['value'].ToJSON);
      Assert.AreEqual('{"cursor":""}', LOut.FindValue('components.examples.Cursor.value').ToJSON);
    finally
      LOut.Free;
    end;
  finally
    LDocument.Free;
  end;
end;

procedure TTestOpenAPIAny.TestSchemaExampleIsNotSupported;
begin
  // The Schema Object's "example" is deprecated (OAS 3.1 and 3.2) in favor of "examples":
  // the model doesn't have it, so it's ignored on read without errors
  Assert.AreEqual('<missing>', RoundTripMember('example', '"x"'));
  Assert.IsTrue(FSchema.IsEmpty);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIAny);

end.
