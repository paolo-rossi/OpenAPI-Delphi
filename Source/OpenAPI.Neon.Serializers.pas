{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3.0 Generator                                                }
{  Copyright (c) 2018-2023 Paolo Rossi                                         }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the 'License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Neon.Serializers;

interface

uses
  System.SysUtils, System.Generics.Defaults, System.Rtti, System.TypInfo, System.JSON,

  Neon.Core.Attributes,
  Neon.Core.Persistence,
  Neon.Core.Types,
  Neon.Core.Nullables,
  Neon.Core.Serializers.RTL,

  OpenAPI.Model.Any,
  OpenAPI.Model.Base,
  OpenAPI.Model.Classes,
  OpenAPI.Model.Reference,
  OpenAPI.Model.Schema;

type
  TOpenAPISerializer = class
    class function GetNeonConfig: INeonConfiguration; static;
  end;

  TNullableStringSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableBooleanSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableIntegerSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableInt64Serializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableDoubleSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableTDateTimeSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TOpenAPIAnySerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TOpenAPIReferenceSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TOpenAPIPathItemSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TOpenAPIExtensionsSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  TOpenAPISchemaSerializer = class(TCustomSerializer)
  protected
    class function GetTargetInfo: PTypeInfo; override;
    class function CanHandle(AType: PTypeInfo): Boolean; override;
  public
    function Serialize(const AValue: TValue; ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue; override;
  end;

  procedure RegisterOpenAPISerializers(ARegistry: TNeonSerializerRegistry);

implementation

uses
  Neon.Core.Utils;

{ TNullableStringSerializer }

class function TNullableStringSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TNullableStringSerializer.Deserialize(AValue: TJSONValue; const AData:
    TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullString;
begin
  LNullValue := AValue.Value;
  Result := TValue.From<NullString>(LNullValue);
end;

class function TNullableStringSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullString);
end;

function TNullableStringSerializer.Serialize(const AValue: TValue; ANeonObject:
    TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullString;
begin
  Result := nil;
  LValue := AValue.AsType<NullString>;
  if LValue.HasValue then
    Result := TJSONString.Create(LValue.Value);
end;

{ TNullableBooleanSerializer }

class function TNullableBooleanSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TNullableBooleanSerializer.Deserialize(AValue: TJSONValue; const
    AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullBoolean;
begin
  LNullValue := (AValue as TJSONBool).AsBoolean;
  Result := TValue.From<NullBoolean>(LNullValue);
end;

class function TNullableBooleanSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullBoolean);
end;

function TNullableBooleanSerializer.Serialize(const AValue: TValue;
    ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullBoolean;
begin
  Result := nil;
  LValue := AValue.AsType<NullBoolean>;
  if LValue.HasValue then
    Result := TJSONBool.Create(LValue.Value);
end;

{ TNullableIntegerSerializer }

class function TNullableIntegerSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TNullableIntegerSerializer.Deserialize(AValue: TJSONValue; const
    AData: TValue; ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullInteger;
begin
  LNullValue := (AValue as TJSONNumber).AsInt;
  Result := TValue.From<NullInteger>(LNullValue);
end;

class function TNullableIntegerSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullInteger);
end;

function TNullableIntegerSerializer.Serialize(const AValue: TValue;
    ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullInteger;
begin
  Result := nil;
  LValue := AValue.AsType<NullInteger>;
  if LValue.HasValue then
    Result := TJSONNumber.Create(LValue.Value);
end;

{ TNullableInt64Serializer }

class function TNullableInt64Serializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TNullableInt64Serializer.Deserialize(AValue: TJSONValue; const AData: TValue;
    ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullInt64;
begin
  LNullValue := (AValue as TJSONNumber).AsInt64;
  Result := TValue.From<NullInt64>(LNullValue);
end;

class function TNullableInt64Serializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullInt64);
end;

function TNullableInt64Serializer.Serialize(const AValue: TValue; ANeonObject:
    TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullInt64;
begin
  Result := nil;
  LValue := AValue.AsType<NullInt64>;
  if LValue.HasValue then
    Result := TJSONNumber.Create(LValue.Value);
end;

{ TNullableDoubleSerializer }

class function TNullableDoubleSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TNullableDoubleSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
    ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullDouble;
begin
  LNullValue := (AValue as TJSONNumber).AsDouble;
  Result := TValue.From<NullDouble>(LNullValue);
end;

class function TNullableDoubleSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullDouble);
end;

function TNullableDoubleSerializer.Serialize(const AValue: TValue; ANeonObject:
    TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullDouble;
begin
  Result := nil;
  LValue := AValue.AsType<NullDouble>;
  if LValue.HasValue then
    Result := TJSONNumber.Create(LValue.Value);
end;

{ TNullableTDateTimeSerializer }

class function TNullableTDateTimeSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TNullableTDateTimeSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
    ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullDateTime;
begin
  LNullValue := TJSONUtils.JSONToDateTime(AValue.Value, AContext.GetConfiguration.GetUseUTCDate);
  Result := TValue.From<NullDateTime>(LNullValue);
end;

class function TNullableTDateTimeSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullDateTime);
end;

function TNullableTDateTimeSerializer.Serialize(const AValue: TValue;
    ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullDateTime;
begin
  Result := nil;
  LValue := AValue.AsType<NullDateTime>;
  if LValue.HasValue then
    Result := TJSONString.Create(TJSONUtils.DateTimeToJSON(LValue.Value, AContext.GetConfiguration.GetUseUTCDate));
end;

{ TOpenAPISerializer }

class function TOpenAPISerializer.GetNeonConfig: INeonConfiguration;
begin
  Result := TNeonConfiguration.Create;

  Result.SetMemberCase(TNeonCase.CamelCase)
    .SetPrettyPrint(True)
    .GetSerializers
      //Neon Serializers
      .RegisterSerializer(TJSONValueSerializer)
      //Neon Serializers
      .RegisterSerializer(TNullableStringSerializer)
      .RegisterSerializer(TNullableBooleanSerializer)
      .RegisterSerializer(TNullableIntegerSerializer)
      .RegisterSerializer(TNullableInt64Serializer)
      .RegisterSerializer(TNullableDoubleSerializer)
      .RegisterSerializer(TNullableTDateTimeSerializer)
      // OpenAPI Models
      .RegisterSerializer(TOpenAPIReferenceSerializer)
      .RegisterSerializer(TOpenAPISchemaSerializer)
      .RegisterSerializer(TOpenAPIAnySerializer)
      .RegisterSerializer(TOpenAPIPathItemSerializer)
      .RegisterSerializer(TOpenAPIExtensionsSerializer)
  ;
end;

{ TOpenAPIAnySerializer }

class function TOpenAPIAnySerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  if AType = GetTargetInfo then
    Result := True
  else
    Result := False;
end;

function TOpenAPIAnySerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
    ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LAny: TOpenAPIAny;
begin
  Result := AData;
  LAny := AData.AsObject as TOpenAPIAny;

  if AValue is TJSONNumber then
    LAny.ValueFrom<Double>((AValue as TJSONNumber).AsDouble)
  else if AValue is TJSONString then
    LAny.ValueFrom<string>((AValue as TJSONString).Value)
  else if AValue is TJSONBool then
    LAny.ValueFrom<Boolean>((AValue as TJSONBool).AsBoolean);
end;

class function TOpenAPIAnySerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(TOpenAPIAny);
end;

function TOpenAPIAnySerializer.Serialize(const AValue: TValue;
    ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LValue: TOpenAPIAny;
begin
  LValue := AValue.AsType<TOpenAPIAny>;
  if LValue = nil then
    Exit(nil);

  if LValue.Value.IsEmpty then
    Exit(nil);

  Result := AContext.WriteDataMember(LValue.Value);
  case ANeonObject.NeonInclude.Value of
    IncludeIf.NotEmpty, IncludeIf.NotDefault:
    begin
      if not TJSONUtils.IsNotDefault(Result) then
        FreeAndNil(Result);
    end;
  end;
end;

{ TOpenAPIReferenceSerializer }

class function TOpenAPIReferenceSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  Result := TypeInfoIs(AType);
end;

function TOpenAPIReferenceSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
    ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LType: TRttiType;
  LRef: TOpenAPIModelReference;
  LJSON: TJSONObject;
begin
  Result := AData;
  LRef := AData.AsObject as TOpenAPIModelReference;
  LJSON := AValue as TJSONObject;

  if Assigned(LJSON.Values['$ref']) then
  begin
    LType := TRttiUtils.Context.GetType(TOpenAPIReference);
    AContext.ReadDataMember(AValue, LType, LRef.Reference, False);
  end
  else
  begin
    LType := TRttiUtils.Context.GetType(AData.AsObject.ClassType);
    AContext.ReadDataMember(AValue, LType, AData, False);
  end;
end;

class function TOpenAPIReferenceSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPIModelReference.ClassInfo;
end;

function TOpenAPIReferenceSerializer.Serialize(const AValue: TValue;
    ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LRefObj: TOpenAPIModelReference;
  LType: TRttiType;
begin
  LRefObj := AValue.AsType<TOpenAPIModelReference>;
  if LRefObj = nil then
    Exit(nil);

  if Assigned(LRefObj.Reference) and not (LRefObj.Reference.Ref.IsEmpty) then
    Exit(TJSONString.Create(LRefObj.Reference.Ref))
  else
  begin
    LType := TRttiUtils.Context.GetType(AValue.TypeInfo);
    Result := TJSONObject.Create;
    AContext.WriteMembers(LType, AValue.AsObject, Result);
  end;

  case ANeonObject.NeonInclude.Value of
    IncludeIf.NotEmpty, IncludeIf.NotDefault:
    begin
      if (Result as TJSONObject).Count = 0 then
        FreeAndNil(Result);
    end;
  end;

end;

{ TOpenAPISchemaSerializer }

class function TOpenAPISchemaSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  Result := TypeInfoIs(AType);
end;

function TOpenAPISchemaSerializer.Deserialize(AValue: TJSONValue;
  const AData: TValue; ANeonObject: TNeonRttiObject;
  AContext: IDeserializerContext): TValue;
var
  LType: TRttiType;
  LSchema: TOpenAPISchema;
  LJSONSchema: TJSONObject;
begin
  Result := AData;

  LSchema := Result.AsObject as TOpenAPISchema;
  LJSONSchema := AValue as TJSONObject;

  if Assigned(LJSONSchema.Values['$ref']) then
  begin
    LType := TRttiUtils.Context.GetType(TOpenAPIReference);
    AContext.ReadDataMember(AValue, LType, LSchema.Reference, False);
  end
  else
  begin
    LType := TRttiUtils.Context.GetType(TOpenAPISchema);
    //AContext.ReadDataMember(AValue, LType, Result, True);
    AContext.ReadMembers(LType, LSchema, LJSONSchema);
  end;
end;

class function TOpenAPISchemaSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPISchema.ClassInfo;
end;

function TOpenAPISchemaSerializer.Serialize(const AValue: TValue;
  ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LSchema: TOpenAPISchema;
  LType: TRttiType;
begin
  LSchema := AValue.AsType<TOpenAPISchema>;

  if LSchema = nil then
    Exit(nil);

  if LSchema.IsEmpty then
    Exit(nil);

  // The Schema has a reference
  if LSchema.IsReference then
    Exit(AContext.WriteDataMember(LSchema.Reference, False));

  if Assigned(LSchema.JSONObject) then
    Result := LSchema.JSONObject.Clone as TJSONObject
  else
  begin
    LType := TRttiUtils.Context.GetType(AValue.TypeInfo);
    Result := TJSONObject.Create;
    AContext.WriteMembers(LType, AValue.AsObject, Result);
  end;

  case ANeonObject.NeonInclude.Value of
    IncludeIf.NotEmpty, IncludeIf.NotDefault:
    begin
      if (Result as TJSONObject).Count = 0 then
        FreeAndNil(Result);
    end;
  end;
end;

{ TOpenAPIPathItemSerializer }

class function TOpenAPIPathItemSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  Result := TypeInfoIs(AType);
end;

function TOpenAPIPathItemSerializer.Deserialize(AValue: TJSONValue;
  const AData: TValue; ANeonObject: TNeonRttiObject;
  AContext: IDeserializerContext): TValue;
var
  LPath: TOpenAPIPathItem;
  LOperation: TOpenAPIOperation;
  LJSONPath: TJSONObject;
  LOpType: TOperationType;
  LType: TRttiType;
  LJSONVal: TJSONValue;
begin
  Result := AData;
  LPath := AData.AsObject as TOpenAPIPathItem;
  LJSONPath := AValue as TJSONObject;
  LType := TRttiUtils.Context.GetType(TOpenAPIOperation);

  for LOpType := Low(TOperationType) to High(TOperationType) do
  begin
    LJSONVal := LJSONPath.Values[LOpType.ToString];
    if Assigned(LJSONVal) then
    begin
      LOperation := LPath.AddOperation(LOpType);
      AContext.ReadMembers(LType, LOperation, LJSONVal as TJSONObject);
    end;
  end;
end;

class function TOpenAPIPathItemSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPIPathItem.ClassInfo;
end;

function TOpenAPIPathItemSerializer.Serialize(const AValue: TValue;
  ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
begin
  Result := AContext.WriteDataMember(AValue, False);
end;

{ TOpenAPIExtensionsSerializer }

class function TOpenAPIExtensionsSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  Result := TypeInfoIs(AType);
end;

function TOpenAPIExtensionsSerializer.Deserialize(AValue: TJSONValue;
  const AData: TValue; ANeonObject: TNeonRttiObject;
  AContext: IDeserializerContext): TValue;
var
  LExt: TOpenAPIExtensions;
  LJSONValues: TJSONObject;
  LPair: TJSONPair;
begin
  Result := AData;
  LExt := AData.AsObject as TOpenAPIExtensions;
  LJSONValues := AValue as TJSONObject;

  for LPair in LJSONValues do
  begin
    if LPair.JsonString.Value.StartsWith('x-') then
      LExt.Values.AddPair(LPair.Clone as TJSONPair);
  end;
end;

class function TOpenAPIExtensionsSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPIExtensions.ClassInfo;
end;

function TOpenAPIExtensionsSerializer.Serialize(const AValue: TValue;
  ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LExt: TOpenAPIExtensions;
begin
  LExt := AValue.AsType<TOpenAPIExtensions>;

  if LExt = nil then
    Exit(nil);

  if LExt.Values.Count = 0 then
    Exit(nil);

  Result := AContext.WriteDataMember(LExt.Values, True);
end;

procedure RegisterOpenAPISerializers(ARegistry: TNeonSerializerRegistry);
begin
  //Neon Serializers
  ARegistry.RegisterSerializer(TJSONValueSerializer);
  //ARegistry.RegisterSerializer(TTValueSerializer);

  //Nullable Serializers
  ARegistry.RegisterSerializer(TNullableStringSerializer);
  ARegistry.RegisterSerializer(TNullableBooleanSerializer);
  ARegistry.RegisterSerializer(TNullableIntegerSerializer);
  ARegistry.RegisterSerializer(TNullableInt64Serializer);
  ARegistry.RegisterSerializer(TNullableDoubleSerializer);
  ARegistry.RegisterSerializer(TNullableTDateTimeSerializer);

  //OpenAPI Serializers
  ARegistry.RegisterSerializer(TOpenAPIAnySerializer);
  ARegistry.RegisterSerializer(TOpenAPIPathItemSerializer);
  ARegistry.RegisterSerializer(TOpenAPIReferenceSerializer);
  ARegistry.RegisterSerializer(TOpenAPISchemaSerializer);
  ARegistry.RegisterSerializer(TOpenAPIExtensionsSerializer);
end;

end.
