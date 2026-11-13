{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Security;

interface

uses
  System.SysUtils, System.Classes, System.JSON, DUnitX.TestFramework,

  Neon.Core.Types,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,

  OpenAPI.Model.Classes,

  OpenAPI.Tests.Utils;

type
  /// <summary>
  ///   "security" (Security Requirement Objects) on the document and on operations. An empty
  ///   array is meaningful: on an operation it removes the top-level security
  /// </summary>
  [TestFixture]
  [Category('security')]
  TTestOpenAPISecurity = class(TObject)
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
    procedure TestEmptyOperationSecurityIsKept;

    [Test]
    procedure TestMissingOperationSecurityIsNotAdded;

    [Test]
    procedure TestRequirementsRoundTrip;

    [Test]
    procedure TestEmptyDocumentSecurityIsKept;

    [Test]
    procedure TestExplicitEmptySecurityFromCode;

    [Test]
    procedure TestUnsetSecurityFromCodeIsOmitted;

    [Test]
    procedure TestNullSecurityIsIgnored;
  end;

implementation

const
  DocHeader = '{"openapi":"3.1.1","info":{"title":"t","version":"1"},';
  Components = '"components":{"securitySchemes":{"basicAuth":{"type":"http","scheme":"basic"},' +
    '"oauth":{"type":"oauth2","flows":{"clientCredentials":{"tokenUrl":"https://example.com/token","scopes":{}}}}}}';

{ TTestOpenAPISecurity }

procedure TTestOpenAPISecurity.Setup;
begin
  FDocument := TOpenAPITestUtils.NewDocument;
  FErrors := TStringList.Create;
end;

procedure TTestOpenAPISecurity.TearDown;
begin
  FErrors.Free;
  FDocument.Free;
end;

function TTestOpenAPISecurity.Config: INeonConfiguration;
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

procedure TTestOpenAPISecurity.Load(const AJSON: string);
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

function TTestOpenAPISecurity.Save: TJSONObject;
begin
  Result := TNeon.ObjectToJSON(FDocument, Config) as TJSONObject;
  Assert.AreEqual('', FErrors.Text, 'Neon logged errors while writing');
end;

procedure TTestOpenAPISecurity.TestEmptyOperationSecurityIsKept;
var
  LJSON: TJSONObject;
  LSecurity: TJSONValue;
begin
  Load(DocHeader + '"security":[{"basicAuth":[]}],' +
    '"paths":{"/time":{"get":{"security":[],"responses":{"200":{"description":"ok"}}}}},' + Components + '}');

  Assert.AreEqual(0, FDocument.Paths['/time'].Get.Security.Count);
  Assert.IsTrue(FDocument.Paths['/time'].Get.Security.Explicit);

  LJSON := Save;
  try
    LSecurity := LJSON.FindValue('paths./time.get.security');
    Assert.IsNotNull(LSecurity, 'The empty security array was dropped');
    Assert.AreEqual('[]', LSecurity.ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPISecurity.TestMissingOperationSecurityIsNotAdded;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"responses":{"200":{"description":"ok"}}}}}}');

  Assert.IsFalse(FDocument.Paths['/a'].Get.Security.Explicit);

  LJSON := Save;
  try
    Assert.IsNull(LJSON.FindValue('paths./a.get.security'));
    Assert.IsNull(LJSON.Values['security']);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPISecurity.TestRequirementsRoundTrip;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"security":[{"basicAuth":[]},{"oauth":["read","write"]}],' +
    '"paths":{"/a":{"get":{"security":[{"oauth":["read"]}],"responses":{"200":{"description":"ok"}}}}},' +
    Components + '}');

  Assert.AreEqual(2, FDocument.Security.Count);
  Assert.AreEqual(1, FDocument.Paths['/a'].Get.Security.Count);

  LJSON := Save;
  try
    Assert.AreEqual('[{"basicAuth":[]},{"oauth":["read","write"]}]', LJSON.Values['security'].ToJSON);
    Assert.AreEqual('[{"oauth":["read"]}]', LJSON.FindValue('paths./a.get.security').ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPISecurity.TestEmptyDocumentSecurityIsKept;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"security":[],"paths":{}}');

  LJSON := Save;
  try
    Assert.IsNotNull(LJSON.Values['security']);
    Assert.AreEqual('[]', LJSON.Values['security'].ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPISecurity.TestExplicitEmptySecurityFromCode;
var
  LOperation: TOpenAPIOperation;
  LJSON: TJSONObject;
begin
  FDocument.Info.Title := 't';
  FDocument.Info.Version := '1';
  LOperation := FDocument.AddPath('/public').AddOperation(TOperationType.Get);
  LOperation.AddResponse(200).Description := 'ok';
  LOperation.Security.Explicit := True;

  LJSON := Save;
  try
    Assert.AreEqual('[]', LJSON.FindValue('paths./public.get.security').ToJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPISecurity.TestUnsetSecurityFromCodeIsOmitted;
var
  LOperation: TOpenAPIOperation;
  LJSON: TJSONObject;
begin
  FDocument.Info.Title := 't';
  FDocument.Info.Version := '1';
  LOperation := FDocument.AddPath('/a').AddOperation(TOperationType.Get);
  LOperation.AddResponse(200).Description := 'ok';

  LJSON := Save;
  try
    Assert.IsNull(LJSON.FindValue('paths./a.get.security'));
    Assert.IsNull(LJSON.Values['security']);
  finally
    LJSON.Free;
  end;
end;

procedure TTestOpenAPISecurity.TestNullSecurityIsIgnored;
var
  LJSON: TJSONObject;
begin
  Load(DocHeader + '"paths":{"/a":{"get":{"security":null,"responses":{"200":{"description":"ok"}}}}}}');

  Assert.IsFalse(FDocument.Paths['/a'].Get.Security.Explicit);

  LJSON := Save;
  try
    Assert.IsNull(LJSON.FindValue('paths./a.get.security'));
  finally
    LJSON.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPISecurity);

end.
