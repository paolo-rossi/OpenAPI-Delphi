unit OpenAPI.Serializer;

interface

uses
  System.SysUtils, System.Generics.Defaults, System.Rtti, System.TypInfo, System.JSON,

  Neon.Core.Attributes,
  Neon.Core.Persistence,
  Neon.Core.Types,
  Neon.Core.Serializers,

  OpenAPI.Nullables;

type
  TOpenAPISerializer = class
    class function GetNeonConfig: INeonConfiguration; static;
  end;

  TNullableStringSerializer = class(TCustomSerializer)
  public
    class function GetTargetInfo: PTypeInfo; override;
  public
    function Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableBooleanSerializer = class(TCustomSerializer)
  public
    class function GetTargetInfo: PTypeInfo; override;
  public
    function Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableIntegerSerializer = class(TCustomSerializer)
  public
    class function GetTargetInfo: PTypeInfo; override;
  public
    function Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableInt64Serializer = class(TCustomSerializer)
  public
    class function GetTargetInfo: PTypeInfo; override;
  public
    function Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableDoubleSerializer = class(TCustomSerializer)
  public
    class function GetTargetInfo: PTypeInfo; override;
  public
    function Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue; override;
  end;

  TNullableTDateTimeSerializer = class(TCustomSerializer)
  public
    class function GetTargetInfo: PTypeInfo; override;
  public
    function Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue; override;
    function Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue; override;
  end;


implementation

uses
  Neon.Core.Utils;

{ TNullableStringSerializer }

function TNullableStringSerializer.Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue;
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

function TNullableStringSerializer.Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullString;
begin
  Result := nil;
  LValue := AValue.AsType<NullString>;
  if LValue.HasValue then
    Result := TJSONString.Create(LValue.Value);
end;

{ TNullableBooleanSerializer }

function TNullableBooleanSerializer.Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue;
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

function TNullableBooleanSerializer.Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullBoolean;
begin
  Result := nil;
  LValue := AValue.AsType<NullBoolean>;
  if LValue.HasValue then
    Result := TJSONBool.Create(LValue.Value);
end;

{ TNullableIntegerSerializer }

function TNullableIntegerSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
  AContext: IDeserializerContext): TValue;
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
  AContext: ISerializerContext): TJSONValue;
var
  LValue: NullInteger;
begin
  Result := nil;
  LValue := AValue.AsType<NullInteger>;
  if LValue.HasValue then
    Result := TJSONNumber.Create(LValue.Value);
end;

{ TNullableInt64Serializer }

function TNullableInt64Serializer.Deserialize(AValue: TJSONValue; const AData: TValue;
  AContext: IDeserializerContext): TValue;
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

function TNullableInt64Serializer.Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullInt64;
begin
  Result := nil;
  LValue := AValue.AsType<NullInt64>;
  if LValue.HasValue then
    Result := TJSONNumber.Create(LValue.Value);
end;

{ TNullableDoubleSerializer }

function TNullableDoubleSerializer.Deserialize(AValue: TJSONValue; const AData: TValue;
  AContext: IDeserializerContext): TValue;
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

function TNullableDoubleSerializer.Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullDouble;
begin
  Result := nil;
  LValue := AValue.AsType<NullDouble>;
  if LValue.HasValue then
    Result := TJSONNumber.Create(LValue.Value);
end;

{ TNullableTDateTimeSerializer }

function TNullableTDateTimeSerializer.Deserialize(AValue: TJSONValue; const AData: TValue; AContext: IDeserializerContext): TValue;
var
  LNullValue: NullDateTime;
begin
  LNullValue := TJSONUtils.JSONToDate(AValue.Value, AContext.GetConfiguration.GetUseUTCDate);
  Result := TValue.From<NullDateTime>(LNullValue);
end;

class function TNullableTDateTimeSerializer.GetTargetInfo: PTypeInfo;
begin
  Result := TypeInfo(NullDateTime);
end;

function TNullableTDateTimeSerializer.Serialize(const AValue: TValue; AContext: ISerializerContext): TJSONValue;
var
  LValue: NullDateTime;
begin
  Result := nil;
  LValue := AValue.AsType<NullDateTime>;
  if LValue.HasValue then
    Result := TJSONString.Create(TJSONUtils.DateToJSON(LValue.Value, AContext.GetConfiguration.GetUseUTCDate));
end;

{ TOpenAPISerializer }

class function TOpenAPISerializer.GetNeonConfig: INeonConfiguration;
begin
  Result := TNeonConfiguration.Create;

  Result.SetMemberCase(TNeonCase.CamelCase)
    .SetPrettyPrint(True)
    .GetSerializers
      .RegisterSerializer(TNullableStringSerializer)
      .RegisterSerializer(TNullableBooleanSerializer)
      .RegisterSerializer(TNullableIntegerSerializer)
      .RegisterSerializer(TNullableInt64Serializer)
      .RegisterSerializer(TNullableDoubleSerializer)
      .RegisterSerializer(TNullableTDateTimeSerializer)
  ;
end;

end.
