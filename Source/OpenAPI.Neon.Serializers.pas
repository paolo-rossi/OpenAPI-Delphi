{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
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

  /// <summary>
  ///   Serializer for the objects that can be a Reference Object (parameters, responses, headers,
  ///   examples, request bodies, links, callbacks, security schemes): when the reference is set
  ///   the object is written as {"$ref": "..."} alone, otherwise as a normal object. Schemas and
  ///   path items have their own (more derived, so preferred) serializers
  /// </summary>
  TOpenAPIModelReferenceSerializer = class(TCustomSerializer)
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
    class function NeedsInstance: Boolean; override;
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
  if AValue is TJSONNull then
    LNullValue := nil
  else
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
  if AValue is TJSONNull then
    LNullValue := nil
  else
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
  if AValue is TJSONNull then
    LNullValue := nil
  else
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
  if AValue is TJSONNull then
    LNullValue := nil
  else
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
  if AValue is TJSONNull then
    LNullValue := nil
  else
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
  if AValue is TJSONNull then
    LNullValue := nil
  else
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
      .RegisterSerializer(TOpenAPIModelReferenceSerializer)
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
  LText: string;
  LInt64: Int64;
begin
  Result := AData;
  LAny := AData.AsType<TOpenAPIAny>;
  if (LAny = nil) or (AValue = nil) then
    Exit;

  if AValue is TJSONString then
    LAny.ValueFrom<string>(TJSONString(AValue).Value)
  else if AValue is TJSONBool then
    LAny.ValueFrom<Boolean>(TJSONBool(AValue).AsBoolean)
  else if AValue is TJSONNumber then
  begin
    // Keep integers as integers (a Double loses precision past 2^53 and changes the type)
    LText := TJSONNumber(AValue).Value;
    if (LText.IndexOfAny(['.', 'e', 'E']) < 0) and TryStrToInt64(LText, LInt64) then
    begin
      if (LInt64 >= Low(Integer)) and (LInt64 <= High(Integer)) then
        LAny.ValueFrom<Integer>(LInt64)
      else
        LAny.ValueFrom<Int64>(LInt64);
    end
    else
      LAny.ValueFrom<Double>(TJSONNumber(AValue).AsDouble);
  end
  else
    // Objects, arrays and null are kept as JSON
    LAny.SetJSONValue(AValue.Clone as TJSONValue);
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

  // An unset value is omitted. A set one is always written, even 0, false, "" or null:
  // those are valid examples, defaults and consts
  if LValue.IsEmpty then
    Exit(nil);

  if Assigned(LValue.JSONValue) then
    Exit(LValue.JSONValue.Clone as TJSONValue);

  Result := AContext.WriteDataMember(LValue.Value);
end;

{ TOpenAPIReferenceSerializer }

class function TOpenAPIReferenceSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  Result := TypeInfoIs(AType);
end;

function TOpenAPIReferenceSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
    ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LRef: TOpenAPIReference;
  LRefValue: TJSONValue;
begin
  Result := AData;

  LRef := AData.AsType<TOpenAPIReference>;
  if LRef = nil then
    Exit;

  // A '$ref' member arrives as its string value. Also accept the whole Reference Object
  // ({"$ref": "..."}), so callers can pass the object that contains the '$ref' key
  LRefValue := AValue;
  if LRefValue is TJSONObject then
    LRefValue := TJSONObject(LRefValue).Values['$ref'];

  // Anything else (e.g. an explicit null) leaves the reference unset
  if LRefValue is TJSONString then
    LRef.SetFullReference(LRefValue.Value);
end;

class function TOpenAPIReferenceSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPIReference.ClassInfo;
end;

function TOpenAPIReferenceSerializer.Serialize(const AValue: TValue;
    ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LRef: TOpenAPIReference;
begin
  Result := nil;

  LRef := AValue.AsType<TOpenAPIReference>;
  if LRef = nil then
    Exit;

  if not LRef.IsEmpty then
    Exit(TJSONString.Create(LRef.GetFullReference))
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
  LTypeValue: TJSONValue;
  LTypeArray: TJSONArray;
  LTypes: TArray<string>;
  LIndex: Integer;
begin
  Result := AData;

  // Only a JSON object can describe a schema: anything else (e.g. an explicit null) leaves it
  // untouched. Neon calls this even with no target instance (see NeedsInstance), which happens for
  // an explicit null on a nil member: there's nothing to read into in that case either
  if not (AValue is TJSONObject) or (Result.AsObject = nil) then
    Exit;

  LSchema := Result.AsObject as TOpenAPISchema;
  LJSONSchema := AValue as TJSONObject;

  // The schema is in the document, even if it's {}: keep it when writing it back
  LSchema.Explicit := True;

  // JSON Schema 2020-12 allows keywords alongside $ref: the generic member reader reads them all,
  // '$ref' included (through the Reference member and TOpenAPIReferenceSerializer)
  LType := TRttiUtils.Context.GetType(TOpenAPISchema);
  AContext.ReadMembers(LType, LSchema, LJSONSchema);

  // 'type' (2020-12) can be a plain string or an array of strings. Type_/Types are
  // [NeonIgnore]d (mapping both to the same JSON key confuses the generic member reader
  // above), so read 'type' explicitly here instead.
  LTypeValue := LJSONSchema.Values['type'];
  if LTypeValue is TJSONString then
    LSchema.Type_ := LTypeValue.Value
  else if LTypeValue is TJSONArray then
  begin
    LTypeArray := TJSONArray(LTypeValue);
    SetLength(LTypes, LTypeArray.Count);
    for LIndex := 0 to LTypeArray.Count - 1 do
      LTypes[LIndex] := LTypeArray.Items[LIndex].Value;
    LSchema.Types := LTypes;
  end;
end;

class function TOpenAPISchemaSerializer.NeedsInstance: Boolean;
begin
  // Deserialize handles a nil target itself, so Neon doesn't need to skip (and log) it: a nil
  // schema member only arrives here for an explicit null, since NeonAutoCreate creates it otherwise
  Result := False;
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
  LTypeArray: TJSONArray;
  LTypeName: string;
  LKeep: Boolean;
begin
  LSchema := AValue.AsType<TOpenAPISchema>;

  if LSchema = nil then
    Exit(nil);

  // A schema that is a map value or a list item (components/schemas, properties, allOf, ...) is
  // always written: Neon would turn an omitted one into null, which is not a valid schema. Neon
  // passes the member's TNeonRttiMember for a member, and the type's TNeonRttiObject otherwise
  LKeep := LSchema.Explicit or not (ANeonObject is TNeonRttiMember);

  if LSchema.IsEmpty then
  begin
    if LKeep then
      Exit(TJSONObject.Create);
    Exit(nil);
  end;

  // JSON Schema 2020-12 allows $ref to appear alongside sibling keywords, so (unlike OAS 3.0)
  // there's no early-exit here: Reference is a normal NotEmpty member and serializes through
  // WriteMembers below via the registered TOpenAPIReferenceSerializer, together with everything else.

  if Assigned(LSchema.JSONObject) then
    Result := LSchema.JSONObject.Clone as TJSONObject
  else
  begin
    LType := TRttiUtils.Context.GetType(AValue.TypeInfo);
    Result := TJSONObject.Create;
    AContext.WriteMembers(LType, AValue.AsObject, Result);

    // Type_/Types are [NeonIgnore]d (see their declarations), so 'type' is written
    // explicitly here: as an array when Types is used, otherwise as a plain string.
    if Length(LSchema.Types) > 0 then
    begin
      LTypeArray := TJSONArray.Create;
      for LTypeName in LSchema.Types do
        LTypeArray.Add(LTypeName);
      (Result as TJSONObject).AddPair('type', LTypeArray);
    end
    else if not LSchema.Type_.IsNull then
      (Result as TJSONObject).AddPair('type', LSchema.Type_.Value);
  end;

  if not LKeep then
    case ANeonObject.NeonInclude.Value of
      IncludeIf.NotEmpty, IncludeIf.NotDefault:
      begin
        if (Result as TJSONObject).Count = 0 then
          FreeAndNil(Result);
      end;
    end;
end;

{ TOpenAPIModelReferenceSerializer }

class function TOpenAPIModelReferenceSerializer.CanHandle(AType: PTypeInfo): Boolean;
begin
  Result := TypeInfoIs(AType);
end;

function TOpenAPIModelReferenceSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
  ANeonObject: TNeonRttiObject; AContext: IDeserializerContext): TValue;
var
  LModel: TOpenAPIModelReference;
  LJSON: TJSONObject;
begin
  Result := AData;

  // Only a JSON object can describe the object: anything else (e.g. an explicit null) leaves it untouched
  if not (AValue is TJSONObject) then
    Exit;

  LModel := AData.AsObject as TOpenAPIModelReference;
  LJSON := TJSONObject(AValue);

  // A Reference Object: its siblings aren't part of the referencing object
  if LJSON.Values['$ref'] is TJSONString then
  begin
    LModel.Reference.SetFullReference(LJSON.Values['$ref'].Value);
    Exit;
  end;

  AContext.ReadMembers(TRttiUtils.Context.GetType(LModel.ClassType), LModel, LJSON);
end;

class function TOpenAPIModelReferenceSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPIModelReference.ClassInfo;
end;

function TOpenAPIModelReferenceSerializer.Serialize(const AValue: TValue;
  ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LModel: TOpenAPIModelReference;
begin
  LModel := AValue.AsType<TOpenAPIModelReference>;
  if LModel = nil then
    Exit(nil);

  Result := TJSONObject.Create;

  // A Reference Object is written alone: the members a referencing object must have
  // (e.g. a parameter's name and in) would otherwise be written next to it, empty
  if LModel.IsReference then
  begin
    TJSONObject(Result).AddPair('$ref', AContext.WriteDataMember(LModel.Reference, True));
    Exit;
  end;

  AContext.WriteMembers(TRttiUtils.Context.GetType(LModel.ClassType), LModel, Result);

  case ANeonObject.NeonInclude.Value of
    IncludeIf.NotEmpty, IncludeIf.NotDefault:
    begin
      if TJSONObject(Result).Count = 0 then
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
  LJSONOthers: TJSONObject;
  LOpType: TOperationType;
  LType: TRttiType;
  LJSONVal: TJSONValue;
begin
  Result := AData;

  // Only a JSON object can describe a path item: anything else (e.g. an explicit null) leaves it untouched
  if not (AValue is TJSONObject) then
    Exit;

  LPath := AData.AsObject as TOpenAPIPathItem;
  LJSONPath := AValue as TJSONObject;

  // Path Item $ref is Reference Object semantics (exclusive of siblings), not JSON Schema
  // vocabulary: read only the reference
  if LJSONPath.Values['$ref'] is TJSONString then
  begin
    LPath.Reference.SetFullReference(LJSONPath.Values['$ref'].Value);
    Exit;
  end;

  LType := TRttiUtils.Context.GetType(TOpenAPIOperation);

  // The operation members are nil until AddOperation creates them, so they're read here, and
  // the other members (summary, description, parameters, ...) are read from a copy without them
  LJSONOthers := LJSONPath.Clone as TJSONObject;
  try
    for LOpType := Low(TOperationType) to High(TOperationType) do
    begin
      LJSONVal := LJSONPath.Values[LOpType.ToString];
      if LJSONVal is TJSONObject then
      begin
        LOperation := LPath.AddOperation(LOpType);
        AContext.ReadMembers(LType, LOperation, TJSONObject(LJSONVal));
      end;
      LJSONOthers.RemovePair(LOpType.ToString).Free;
    end;

    LType := TRttiUtils.Context.GetType(TOpenAPIPathItem);
    AContext.ReadMembers(LType, LPath, LJSONOthers);
  finally
    LJSONOthers.Free;
  end;
end;

class function TOpenAPIPathItemSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TOpenAPIPathItem.ClassInfo;
end;

function TOpenAPIPathItemSerializer.Serialize(const AValue: TValue;
  ANeonObject: TNeonRttiObject; AContext: ISerializerContext): TJSONValue;
var
  LPath: TOpenAPIPathItem;
  LJSON: TJSONObject;
begin
  LPath := AValue.AsType<TOpenAPIPathItem>;

  if Assigned(LPath) and LPath.IsReference then
  begin
    LJSON := TJSONObject.Create;
    LJSON.AddPair('$ref', AContext.WriteDataMember(LPath.Reference, True));
    Exit(LJSON);
  end;

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
  ARegistry.RegisterSerializer(TOpenAPIModelReferenceSerializer);
  ARegistry.RegisterSerializer(TOpenAPISchemaSerializer);
  ARegistry.RegisterSerializer(TOpenAPIExtensionsSerializer);
end;

end.
