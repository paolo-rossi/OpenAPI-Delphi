{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Utils;

interface

uses
  System.SysUtils, System.JSON,

  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON,

  OpenAPI.Model.Classes,
  OpenAPI.Model.Schema,
  OpenAPI.Neon.Serializers;

type
  TOpenAPITestUtils = class
  public
    class function Config: INeonConfiguration;

    class function NewDocument: TOpenAPIDocument;

    class function SerializeDocument(ADocument: TOpenAPIDocument): string;
    class function SerializeSchema(ASchema: TOpenAPISchema): string;

    class procedure DeserializeIntoDocument(const AJSON: string; ADocument: TOpenAPIDocument);
    class procedure DeserializeIntoSchema(const AJSON: string; ASchema: TOpenAPISchema);
  end;

implementation

class function TOpenAPITestUtils.Config: INeonConfiguration;
begin
  Result := TOpenAPISerializer.GetNeonConfig;
end;

class function TOpenAPITestUtils.NewDocument: TOpenAPIDocument;
begin
  Result := TOpenAPIDocument.Create(TOpenAPIVersion.v311);
end;

class function TOpenAPITestUtils.SerializeDocument(ADocument: TOpenAPIDocument): string;
begin
  Result := TNeon.ObjectToJSONString(ADocument, Config);
end;

class function TOpenAPITestUtils.SerializeSchema(ASchema: TOpenAPISchema): string;
begin
  Result := TNeon.ObjectToJSONString(ASchema, Config);
end;

class procedure TOpenAPITestUtils.DeserializeIntoDocument(const AJSON: string; ADocument: TOpenAPIDocument);
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  try
    TNeon.JSONToObject(ADocument, LJSON, Config);
  finally
    LJSON.Free;
  end;
end;

class procedure TOpenAPITestUtils.DeserializeIntoSchema(const AJSON: string; ASchema: TOpenAPISchema);
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  try
    TNeon.JSONToObject(ASchema, LJSON, Config);
  finally
    LJSON.Free;
  end;
end;

end.
