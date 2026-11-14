{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Maps;

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
  ///   The owning maps (TOpenAPIModelMap): value ownership, and (Delphi 12+, where they're
  ///   TOrderedDictionary) insertion order when written
  /// </summary>
  [TestFixture]
  [Category('maps')]
  TTestOpenAPIMaps = class(TObject)
  private
    FDocument: TOpenAPIDocument;
    FErrors: TStringList;
    function Config: INeonConfiguration;
    class function KeysOf(AValue: TJSONValue): string; static;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestRemoveFreesValue;

    [Test]
    procedure TestReplaceFreesOldValue;

    [Test]
    procedure TestClearFreesValues;

    [Test]
    procedure TestExtractDoesNotFreeValue;

{$IF RTLVersion >= 36}
    [Test]
    procedure TestReadOrderIsKept;

    [Test]
    procedure TestAddOrderIsKept;

    [Test]
    procedure TestOrderAfterRemove;
{$ENDIF}
  end;

implementation

{ TTestOpenAPIMaps }

procedure TTestOpenAPIMaps.Setup;
begin
  FDocument := TOpenAPITestUtils.NewDocument;
  FErrors := TStringList.Create;
end;

procedure TTestOpenAPIMaps.TearDown;
begin
  FErrors.Free;
  FDocument.Free;
end;

function TTestOpenAPIMaps.Config: INeonConfiguration;
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

class function TTestOpenAPIMaps.KeysOf(AValue: TJSONValue): string;
var
  LPair: TJSONPair;
begin
  Result := '';
  if not (AValue is TJSONObject) then
    Exit('<not an object>');
  for LPair in TJSONObject(AValue) do
  begin
    if Result <> '' then
      Result := Result + ',';
    Result := Result + LPair.JsonString.Value;
  end;
end;

procedure TTestOpenAPIMaps.TestRemoveFreesValue;
begin
  // A value that isn't freed is reported as a leak by the test run
  FDocument.Components.AddSchema('A').Type_ := 'string';
  FDocument.Components.Schemas.Remove('A');
  Assert.AreEqual(0, FDocument.Components.Schemas.Count);
end;

procedure TTestOpenAPIMaps.TestReplaceFreesOldValue;
var
  LSchema: TOpenAPISchema;
begin
  FDocument.Components.AddSchema('A').Type_ := 'string';
  LSchema := TOpenAPISchema.Create;
  LSchema.Type_ := 'integer';
  FDocument.Components.Schemas.AddOrSetValue('A', LSchema);

  Assert.AreEqual(1, FDocument.Components.Schemas.Count);
  Assert.AreEqual('integer', FDocument.Components.Schemas['A'].Type_.Value);
end;

procedure TTestOpenAPIMaps.TestClearFreesValues;
begin
  FDocument.Components.AddSchema('A');
  FDocument.Components.AddSchema('B');
  FDocument.Components.Schemas.Clear;
  Assert.AreEqual(0, FDocument.Components.Schemas.Count);

  // Still usable after Clear
  FDocument.Components.AddSchema('C');
  Assert.AreEqual(1, FDocument.Components.Schemas.Count);
end;

procedure TTestOpenAPIMaps.TestExtractDoesNotFreeValue;
var
  LSchema: TOpenAPISchema;
begin
  FDocument.Components.AddSchema('A').Type_ := 'string';
  LSchema := FDocument.Components.Schemas.ExtractPair('A').Value;
  try
    Assert.AreEqual(0, FDocument.Components.Schemas.Count);
    Assert.AreEqual('string', LSchema.Type_.Value);
  finally
    LSchema.Free;
  end;
end;

{$IF RTLVersion >= 36}
procedure TTestOpenAPIMaps.TestReadOrderIsKept;
const
  DocJSON =
    '{"openapi":"3.1.1","info":{"title":"t","version":"1"},"paths":{' +
    '"/zeta":{"get":{"responses":{"404":{"description":"no"},"200":{"description":"ok"},"default":{"description":"e"}}}},' +
    '"/alpha":{"get":{"responses":{"200":{"description":"ok"}}}},' +
    '"/mid":{"get":{"responses":{"200":{"description":"ok"}}}}},' +
    '"components":{"schemas":{"Zebra":{"type":"object","properties":{"z":{"type":"string"},"a":{"type":"string"},"m":{"type":"string"}}},' +
    '"Apple":{"type":"string"},"Mango":{"type":"string"}}}}';
var
  LIn: TJSONValue;
  LOut: TJSONObject;
begin
  LIn := TJSONObject.ParseJSONValue(DocJSON);
  try
    TNeon.JSONToObject(FDocument, LIn, Config);
  finally
    LIn.Free;
  end;

  LOut := TNeon.ObjectToJSON(FDocument, Config) as TJSONObject;
  try
    Assert.AreEqual('', FErrors.Text, 'Neon logged errors');
    Assert.AreEqual('/zeta,/alpha,/mid', KeysOf(LOut.Values['paths']));
    Assert.AreEqual('404,200,default', KeysOf(LOut.FindValue('paths./zeta.get.responses')));
    Assert.AreEqual('Zebra,Apple,Mango', KeysOf(LOut.FindValue('components.schemas')));
    Assert.AreEqual('z,a,m', KeysOf(LOut.FindValue('components.schemas.Zebra.properties')));
  finally
    LOut.Free;
  end;
end;

procedure TTestOpenAPIMaps.TestAddOrderIsKept;
var
  LOut: TJSONObject;
begin
  FDocument.Info.Title := 't';
  FDocument.Info.Version := '1';
  FDocument.AddPath('/users').AddOperation(TOperationType.Get).AddResponse(200).Description := 'ok';
  FDocument.AddPath('/accounts').AddOperation(TOperationType.Get).AddResponse(200).Description := 'ok';
  FDocument.AddPath('/orders').AddOperation(TOperationType.Get).AddResponse(200).Description := 'ok';
  FDocument.Components.AddSchema('User').Type_ := 'object';
  FDocument.Components.AddSchema('Account').Type_ := 'object';

  LOut := TNeon.ObjectToJSON(FDocument, Config) as TJSONObject;
  try
    Assert.AreEqual('/users,/accounts,/orders', KeysOf(LOut.Values['paths']));
    Assert.AreEqual('User,Account', KeysOf(LOut.FindValue('components.schemas')));
  finally
    LOut.Free;
  end;
end;

procedure TTestOpenAPIMaps.TestOrderAfterRemove;
var
  LOut: TJSONObject;
begin
  FDocument.Components.AddSchema('C').Type_ := 'string';
  FDocument.Components.AddSchema('A').Type_ := 'string';
  FDocument.Components.AddSchema('B').Type_ := 'string';
  FDocument.Components.Schemas.Remove('A');
  FDocument.Components.AddSchema('A').Type_ := 'string';

  LOut := TNeon.ObjectToJSON(FDocument, Config) as TJSONObject;
  try
    Assert.AreEqual('C,B,A', KeysOf(LOut.FindValue('components.schemas')));
  finally
    LOut.Free;
  end;
end;
{$ENDIF}

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIMaps);

end.
