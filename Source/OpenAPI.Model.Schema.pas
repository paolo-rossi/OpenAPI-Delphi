{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Model.Schema;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.JSON, System.Rtti, System.TypInfo,

  Neon.Core.Types,
  Neon.Core.Attributes,
  Neon.Core.Nullables,
  Neon.Core.Persistence,
  Neon.Core.Persistence.JSON.Schema,

  OpenAPI.Model.Any,
  OpenAPI.Model.Base,
  OpenAPI.Model.Reference;

type
  TOpenAPISchema = class;

  TOpenAPIDiscriminator = class
  private
    FPropertyName: NullString;
    FMapping: TDictionary<string, string>;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// REQUIRED. The name of the property in the payload that will hold the discriminator value.
    /// </summary>
    property PropertyName: NullString read FPropertyName write FPropertyName;

    /// <summary>
    /// An object to hold mappings between payload values and schema names or references.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Mapping: TDictionary<string, string> read FMapping write FMapping;
  end;

  /// <summary>
  /// ExternalDocs for Schemas
  /// </summary>
  TOpenAPISchemaExternalDoc = class(TOpenAPIExtensible)
  private
    FDescription: NullString;
    FUrl: string;
  public
    /// <summary>
    /// A short description of the target documentation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// REQUIRED. The Url for the target documentation. Value MUST be in the format of a Url.
    /// </summary>
    property Url: string read FUrl write FUrl;
  end;


  TOpenAPISchemaBase = class
  protected
    FType_: NullString;
    FTitle: NullString;
    FDescription: NullString;
    FFormat: NullString;
  public
    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// While relying on JSON Schema's defined formats,
    /// the OAS offers a few additional predefined formats.
    /// </summary>
    property Format: NullString read FFormat write FFormat;

    /// <summary>
    /// Follow JSON Schema definition. Short text providing information about the data.
    /// </summary>
    property Title: NullString read FTitle write FTitle;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Value MUST be a string. Multiple types via an array are not supported.
    /// </summary>
    [NeonProperty('type')]
    property Type_: NullString read FType_ write FType_;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;
  end;

  TOpenAPISchemas = class(TOpenAPIModelList<TOpenAPISchema>);
  TOpenAPISchemaMap = class(TOpenAPIModelMap<TOpenAPISchema>);

  TOpenAPIEnum = class(TOpenAPIModelList<TOpenAPIAny>);

  /// <summary>
  ///   JSON Schema Object: https://json-schema.org/
  /// </summary>
  TOpenAPISchema = class(TOpenAPIModelReference)
  private
    FNeonConfig: INeonConfiguration;
    FJSONObject: TJSONObject;
    FJSONOwned: Boolean;
    FExplicit: Boolean;
  private
    FFormat: NullString;
    FTitle: NullString;
    FType_: NullString;
    FDescription: NullString;
    FMaximum: NullDouble;
    FExclusiveMaximum: NullDouble;
    FMinimum: NullDouble;
    FExclusiveMinimum: NullDouble;
    FMaxLength: NullInteger;
    FMinLength: NullInteger;
    FPattern: NullString;
    FMultipleOf: NullDouble;
    FReadOnly_: NullBoolean;
    FWriteOnly_: NullBoolean;
    FAllOf: TOpenAPISchemas;
    FOneOf: TOpenAPISchemas;
    FAnyOf: TOpenAPISchemas;
    FNot_: TOpenAPISchema;
    FRequired: TArray<string>;
    FItems: TOpenAPISchema;
    FMaxItems: NullInteger;
    FMinItems: NullInteger;
    FUniqueItems: NullBoolean;
    FPrefixItems: TOpenAPISchemas;
    FContains: TOpenAPISchema;
    FMinContains: NullInteger;
    FMaxContains: NullInteger;
    FProperties: TOpenAPISchemaMap;
    FPatternProperties: TOpenAPISchemaMap;
    FPropertyNames: TOpenAPISchema;
    FMaxProperties: NullInteger;
    FMinProperties: NullInteger;
    FAdditionalPropertiesAllowed: NullBoolean;
    FAdditionalProperties: TOpenAPISchema;
    FTypes: TArray<string>;
    FConst_: TOpenAPIAny;
    FDefault_: TOpenAPIAny;
    FEnum: TOpenAPIEnum;
    FExamples: TOpenAPIEnum;
    FDiscriminator: TOpenAPIDiscriminator;
    FExternalDocs: TOpenAPISchemaExternalDoc;

    function GetNeonConfig: INeonConfiguration;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function WithNeonConfig(AConfig: INeonConfiguration): TOpenAPISchema;

    function AddProperty(const AKeyName: string): TOpenAPISchema;
    function AddEnum(const AValue: TValue): TOpenAPIAny;
    function AddPrefixItem: TOpenAPISchema;
    function AddPatternProperty(const APattern: string): TOpenAPISchema;

    procedure SetExternalDocs(const AURL, ADescription: string);

    procedure SetJSONObject(AJSON: TJSONObject; AOwned: Boolean = True);

    procedure SetJSONFromType(AType: TRttiType);
    procedure SetJSONFromClass(AClass: TClass);

    procedure SetSchemaReference(const AReference: string);
    function IsEmpty: Boolean;

    [NeonIgnore]
    property JSONObject: TJSONObject read FJSONObject write FJSONObject;

    /// <summary>
    ///   Marks the schema as present even when it has no keywords, so that a member schema
    ///   (e.g. a media type's "schema") is written as {} - the schema that accepts any value -
    ///   instead of being omitted. Set automatically when the schema is read from JSON.
    ///   Schemas inside maps and lists (e.g. components/schemas, properties, allOf) are
    ///   always written, as {} when empty, so they don't need it
    /// </summary>
    [NeonIgnore]
    property Explicit: Boolean read FExplicit write FExplicit;
  public
    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// While relying on JSON Schema's defined formats,
    /// the OAS offers a few additional predefined formats.
    /// </summary>
    property Format: NullString read FFormat write FFormat;

    /// <summary>
    /// Follow JSON Schema definition. Short text providing information about the data.
    /// </summary>
    property Title: NullString read FTitle write FTitle;

    /// <summary>
    /// JSON Schema 2020-12 "type" keyword, single-type form. Value MUST be a string.
    /// Mutually exclusive with <see cref="Types"/> (used for the multi-type/nullable form).
    /// Both are [NeonIgnore]d: mapping both to the same 'type' JSON key confuses Neon's generic
    /// deserializer (it tries to populate both from the same value), so TOpenAPISchemaSerializer
    /// reads/writes 'type' explicitly instead.
    /// </summary>
    [NeonIgnore]
    property Type_: NullString read FType_ write FType_;

    /// <summary>
    /// JSON Schema 2020-12 "type" keyword, multi-type form (e.g. ['string', 'null']).
    /// Mutually exclusive with <see cref="Type_"/>. See remarks on <see cref="Type_"/>.
    /// </summary>
    [NeonIgnore]
    property Types: TArray<string> read FTypes write FTypes;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property Maximum: NullDouble read FMaximum write FMaximum;

    /// <summary>
    /// JSON Schema 2020-12: numeric exclusive upper bound (replaces the OAS 3.0 boolean modifier).
    /// </summary>
    property ExclusiveMaximum: NullDouble read FExclusiveMaximum write FExclusiveMaximum;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property Minimum: NullDouble read FMinimum write FMinimum;

    /// <summary>
    /// JSON Schema 2020-12: numeric exclusive lower bound (replaces the OAS 3.0 boolean modifier).
    /// </summary>
    property ExclusiveMinimum: NullDouble read FExclusiveMinimum write FExclusiveMinimum;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MaxLength: NullInteger read FMaxLength write FMaxLength;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MinLength: NullInteger read FMinLength write FMinLength;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// This string SHOULD be a valid regular expression, according to the ECMA 262 regular expression dialect
    /// </summary>
    property Pattern: NullString read FPattern write FPattern;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MultipleOf: NullDouble read FMultipleOf write FMultipleOf;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// The default value represents what would be assumed by the consumer of the input as the value of the schema if one is not provided.
    /// Unlike JSON Schema, the value MUST conform to the defined type for the Schema Object defined at the same level.
    /// For example, if type is string, then default can be "foo" but cannot be 1.
    /// </summary>
    [NeonProperty('default'), NeonInclude(IncludeIf.NotEmpty)]
    property Default_: TOpenAPIAny read FDefault_ write FDefault_;

    /// <summary>
    /// JSON Schema 2020-12 "const" keyword: the instance must equal this value exactly.
    /// </summary>
    [NeonProperty('const'), NeonInclude(IncludeIf.NotEmpty)]
    property Const_: TOpenAPIAny read FConst_ write FConst_;

    /// <summary>
    /// Relevant only for Schema "properties" definitions. Declares the property as "read only".
    /// This means that it MAY be sent as part of a response but SHOULD NOT be sent as part of the request.
    /// If the property is marked as ReadOnly_ being true and is in the required list,
    /// the required will take effect on the response only.
    /// A property MUST NOT be marked as both ReadOnly_ and WriteOnly_ being true.
    /// Default value is false.
    /// </summary>
    [NeonProperty('readOnly')]
    property ReadOnly_: NullBoolean read FReadOnly_ write FReadOnly_;

    /// <summary>
    /// Relevant only for Schema "properties" definitions. Declares the property as "write only".
    /// Therefore, it MAY be sent as part of a request but SHOULD NOT be sent as part of the response.
    /// If the property is marked as WriteOnly_ being true and is in the required list,
    /// the required will take effect on the request only.
    /// A property MUST NOT be marked as both ReadOnly_ and WriteOnly_ being true.
    /// Default value is false.
    /// </summary>
    [NeonProperty('writeOnly')]
    property WriteOnly_: NullBoolean read FWriteOnly_ write FWriteOnly_;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property AllOf: TOpenAPISchemas read FAllOf write FAllOf;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property OneOf: TOpenAPISchemas read FOneOf write FOneOf;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property AnyOf: TOpenAPISchemas read FAnyOf write FAnyOf;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Inline or referenced schema MUST be of a Schema Object and not a standard JSON Schema.
    /// </summary>
    [NeonProperty('not'), NeonAutoCreate, NeonInclude(IncludeIf.NotNull)]
    property Not_: TOpenAPISchema read FNot_ write FNot_;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Required: TArray<string> read FRequired write FRequired;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Value MUST be an object and not an array. Inline or referenced schema MUST be of a Schema Object
    /// and not a standard JSON Schema. items MUST be present if the type is array.
    /// </summary>
    [NeonAutoCreate, NeonInclude(IncludeIf.NotNull)]
    property Items: TOpenAPISchema read FItems write FItems;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MaxItems: NullInteger read FMaxItems write FMaxItems;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MinItems: NullInteger read FMinItems write FMinItems;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property UniqueItems: NullBoolean read FUniqueItems write FUniqueItems;

    /// <summary>
    /// JSON Schema 2020-12 "prefixItems": tuple validation. Each entry validates the array item
    /// at the corresponding position; <see cref="Items"/> then applies to any remaining items.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property PrefixItems: TOpenAPISchemas read FPrefixItems write FPrefixItems;

    /// <summary>
    /// JSON Schema 2020-12 "contains": at least one array item must validate against this schema.
    /// </summary>
    [NeonAutoCreate, NeonInclude(IncludeIf.NotNull)]
    property Contains: TOpenAPISchema read FContains write FContains;

    /// <summary>
    /// JSON Schema 2020-12 "minContains".
    /// </summary>
    property MinContains: NullInteger read FMinContains write FMinContains;

    /// <summary>
    /// JSON Schema 2020-12 "maxContains".
    /// </summary>
    property MaxContains: NullInteger read FMaxContains write FMaxContains;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Property definitions MUST be a Schema Object and not a standard JSON Schema (inline or referenced).
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Properties: TOpenAPISchemaMap read FProperties write FProperties;

    /// <summary>
    /// JSON Schema 2020-12 "patternProperties": maps a regular expression to a schema; properties
    /// whose name matches the pattern must validate against the corresponding schema.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property PatternProperties: TOpenAPISchemaMap read FPatternProperties write FPatternProperties;

    /// <summary>
    /// JSON Schema 2020-12 "propertyNames": every property name must validate against this schema.
    /// </summary>
    [NeonAutoCreate, NeonInclude(IncludeIf.NotNull)]
    property PropertyNames: TOpenAPISchema read FPropertyNames write FPropertyNames;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MaxProperties: NullInteger read FMaxProperties write FMaxProperties;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property MinProperties: NullInteger read FMinProperties write FMinProperties;

    /// <summary>
    /// Indicates if the schema can contain properties other than those defined by the properties map.
    /// </summary>
    property AdditionalPropertiesAllowed: NullBoolean read FAdditionalPropertiesAllowed write FAdditionalPropertiesAllowed;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Value can be boolean or object. Inline or referenced schema
    /// MUST be of a Schema Object and not a standard JSON Schema.
    /// </summary>
    [NeonAutoCreate, NeonInclude(IncludeIf.NotNull)]
    property AdditionalProperties: TOpenAPISchema read FAdditionalProperties write FAdditionalProperties;

    /// <summary>
    /// Adds support for polymorphism. The discriminator is an object name that is used to differentiate
    /// between other schemas which may satisfy the payload description.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Discriminator: TOpenAPIDiscriminator read FDiscriminator write FDiscriminator;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Enum: TOpenAPIEnum read FEnum write FEnum;

    /// <summary>
    /// JSON Schema 2020-12 "examples" keyword (plural, array form).
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Examples: TOpenAPIEnum read FExamples write FExamples;

    /// <summary>
    /// Additional external documentation for this schema.
    /// </summary>
    /// <remarks>
    ///   This is an optional object. It's not created by the class
    /// </remarks>
    [NeonAutoCreate, NeonInclude(IncludeIf.NotEmpty)]
    property ExternalDocs: TOpenAPISchemaExternalDoc read FExternalDocs write FExternalDocs;
  end;

implementation

{ TOpenAPIDiscriminator }

constructor TOpenAPIDiscriminator.Create;
begin
  FMapping := TDictionary<string, string>.Create;
end;

destructor TOpenAPIDiscriminator.Destroy;
begin
  FMapping.Free;
  inherited;
end;

{ TOpenAPISchema }

function TOpenAPISchema.AddEnum(const AValue: TValue): TOpenAPIAny;
begin
  Result := TOpenAPIAny.Create;
  Result.Value := AValue;
  FEnum.Add(Result);
end;

function TOpenAPISchema.AddProperty(const AKeyName: string): TOpenAPISchema;
begin
  if not FProperties.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPISchema.Create;
    FProperties.Add(AKeyName, Result);
  end;
end;

function TOpenAPISchema.AddPrefixItem: TOpenAPISchema;
begin
  Result := TOpenAPISchema.Create;
  FPrefixItems.Add(Result);
end;

function TOpenAPISchema.AddPatternProperty(const APattern: string): TOpenAPISchema;
begin
  if not FPatternProperties.TryGetValue(APattern, Result) then
  begin
    Result := TOpenAPISchema.Create;
    FPatternProperties.Add(APattern, Result);
  end;
end;

constructor TOpenAPISchema.Create;
begin
  inherited Create;

  FAllOf := CreateSubObject<TOpenAPISchemas>;
  FOneOf := CreateSubObject<TOpenAPISchemas>;
  FAnyOf := CreateSubObject<TOpenAPISchemas>;
  FPrefixItems := CreateSubObject<TOpenAPISchemas>;
  FProperties := CreateSubObject<TOpenAPISchemaMap>;
  FPatternProperties := CreateSubObject<TOpenAPISchemaMap>;
  FDiscriminator := CreateSubObject<TOpenAPIDiscriminator>;
  FDefault_ := CreateSubObject<TOpenAPIAny>;
  FConst_ := CreateSubObject<TOpenAPIAny>;
  FEnum := CreateSubObject<TOpenAPIEnum>;
  FExamples := CreateSubObject<TOpenAPIEnum>;
  //FExternalDocs := CreateSubObject<TOpenAPISchemaExternalDoc>;
end;

destructor TOpenAPISchema.Destroy;
begin
  // You need to destroy these in case Neon creates them
  FNot_.Free;
  FItems.Free;
  FContains.Free;
  FPropertyNames.Free;
  FAdditionalProperties.Free;
  FExternalDocs.Free;

  if FJSONOwned then
    FJSONObject.Free;

  inherited;
end;

function TOpenAPISchema.GetNeonConfig: INeonConfiguration;
begin
  if not Assigned(FNeonConfig) then
    FNeonConfig := TNeonConfiguration.Camel;
  Result := FNeonConfig;
end;

function TOpenAPISchema.IsEmpty: Boolean;
begin
  Result := not Assigned(FJSONObject) and not IsReference and
    FType_.IsNull and (Length(FTypes) = 0) and FTitle.IsNull and FFormat.IsNull and FDescription.IsNull and
    FMaximum.IsNull and FExclusiveMaximum.IsNull and FMinimum.IsNull and FExclusiveMinimum.IsNull and
    FMaxLength.IsNull and FMinLength.IsNull and FPattern.IsNull and FMultipleOf.IsNull and
    FReadOnly_.IsNull and FWriteOnly_.IsNull and
    FAllOf.IsEmpty and FOneOf.IsEmpty and FAnyOf.IsEmpty and not Assigned(FNot_) and
    (Length(FRequired) = 0) and not Assigned(FItems) and FMaxItems.IsNull and FMinItems.IsNull and FUniqueItems.IsNull and
    FPrefixItems.IsEmpty and not Assigned(FContains) and FMinContains.IsNull and FMaxContains.IsNull and
    FProperties.IsEmpty and FPatternProperties.IsEmpty and not Assigned(FPropertyNames) and
    FMaxProperties.IsNull and FMinProperties.IsNull and
    FAdditionalPropertiesAllowed.IsNull and not Assigned(FAdditionalProperties) and
    FConst_.IsEmpty and FDefault_.IsEmpty and FEnum.IsEmpty and FExamples.IsEmpty and
    (FDiscriminator.Mapping.Count = 0) and FDiscriminator.PropertyName.IsNull and not Assigned(FExternalDocs);
end;

procedure TOpenAPISchema.SetJSONObject(AJSON: TJSONObject; AOwned: Boolean);
begin
  if Assigned(FJSONObject) and FJSONOwned then
    FJSONObject.Free;

  FJSONObject := AJSON;
  FJSONOwned := AOwned;
end;

procedure TOpenAPISchema.SetExternalDocs(const AURL, ADescription: string);
begin
  if not Assigned(FExternalDocs) then
    FExternalDocs := TOpenAPISchemaExternalDoc.Create;

  FExternalDocs.Url := AURL;
  FExternalDocs.Description := ADescription;
end;

procedure TOpenAPISchema.SetJSONFromClass(AClass: TClass);
begin
  SetJSONObject(TNeonSchemaGenerator.ClassToJSONSchema(AClass, TNeonSchemaConfiguration.Wrap(GetNeonConfig)));
end;

procedure TOpenAPISchema.SetJSONFromType(AType: TRttiType);
begin
  SetJSONObject(TNeonSchemaGenerator.TypeToJSONSchema(AType, TNeonSchemaConfiguration.Wrap(GetNeonConfig)));
end;

procedure TOpenAPISchema.SetSchemaReference(const AReference: string);
begin
  FReference.SetReference(AReference, TOpenAPIReferenceTarget.Schemas);
end;

function TOpenAPISchema.WithNeonConfig(AConfig: INeonConfiguration): TOpenAPISchema;
begin
  FNeonConfig := AConfig;
  Result := Self;
end;

end.
