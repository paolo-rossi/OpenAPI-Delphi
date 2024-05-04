{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3.0 Generator                                                }
{  Copyright (c) 2018-2023 Paolo Rossi                                         }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
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
  private
    FFormat: NullString;
    FTitle: NullString;
    FType_: NullString;
    FDescription: NullString;
    FMaximum: NullDouble;
    FExclusiveMaximum: NullBoolean;
    FMinimum: NullDouble;
    FExclusiveMinimum: NullBoolean;
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
    FProperties: TOpenAPISchemaMap;
    FMaxProperties: NullInteger;
    FMinProperties: NullInteger;
    FAdditionalPropertiesAllowed: NullBoolean;
    FAdditionalProperties: TOpenAPISchema;
    FNullable: NullBoolean;
    FDefault_: TOpenAPIAny;
    FEnum: TOpenAPIEnum;
    FDiscriminator: TOpenAPIDiscriminator;
  private
    function GetNeonConfig: INeonConfiguration;
  public
    constructor Create;
    destructor Destroy; override;
  public
    function WithNeonConfig(AConfig: INeonConfiguration): TOpenAPISchema;

    function AddProperty(const AKeyName: string): TOpenAPISchema;
    function AddEnum(const AValue: TValue): TOpenAPIAny;

    procedure SetJSONObject(AJSON: TJSONObject; AOwned: Boolean = True);

    procedure SetJSONFromType(AType: TRttiType);
    procedure SetJSONFromClass(AClass: TClass);

    procedure SetSchemaReference(const AReference: string);
    function IsEmpty: Boolean;

    [NeonIgnore]
    property JSONObject: TJSONObject read FJSONObject write FJSONObject;
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

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property Maximum: NullDouble read FMaximum write FMaximum;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property ExclusiveMaximum: NullBoolean read FExclusiveMaximum write FExclusiveMaximum;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property Minimum: NullDouble read FMinimum write FMinimum;

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    property ExclusiveMinimum: NullBoolean read FExclusiveMinimum write FExclusiveMinimum;

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
    [NeonProperty('default')] [NeonInclude(IncludeIf.NotEmpty)]
    property Default_: TOpenAPIAny read FDefault_ write FDefault_;

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
    [NeonInclude(IncludeIf.NotNull)]
    [NeonProperty('not')]
    [NeonAutoCreate]
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
    [NeonInclude(IncludeIf.NotNull)]
    [NeonAutoCreate]
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
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// Property definitions MUST be a Schema Object and not a standard JSON Schema (inline or referenced).
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Properties: TOpenAPISchemaMap read FProperties write FProperties;

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
    [NeonInclude(IncludeIf.NotNull)]
    [NeonAutoCreate]
    property AdditionalProperties: TOpenAPISchema read FAdditionalProperties write FAdditionalProperties;

    /// <summary>
    /// Adds support for polymorphism. The discriminator is an object name that is used to differentiate
    /// between other schemas which may satisfy the payload description.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Discriminator: TOpenAPIDiscriminator read FDiscriminator write FDiscriminator;

    /// <summary>
    /// A free-form property to include an example of an instance for this schema.
    /// To represent examples that cannot be naturally represented in JSON or YAML,
    /// a string value can be used to contain the example with escaping where necessary.
    /// </summary>
    //property Example IOpenApiAny

    /// <summary>
    /// Follow JSON Schema definition: https://tools.ietf.org/html/draft-fge-json-schema-validation-00
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    //property Enum: TOpenAPIAny read FEnum write FEnum;
    property Enum: TOpenAPIEnum read FEnum write FEnum;

    /// <summary>
    /// Allows sending a null value for the defined schema. Default value is false.
    /// </summary>
    property Nullable: NullBoolean read FNullable write FNullable;

    /// <summary>
    /// Additional external documentation for this schema.
    /// </summary>
    //ExternalDocs: TOpenApiExternalDocs;
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

constructor TOpenAPISchema.Create;
begin
  inherited Create;

  FAllOf := CreateSubObject<TOpenAPISchemas>;
  FOneOf := CreateSubObject<TOpenAPISchemas>;
  FAnyOf := CreateSubObject<TOpenAPISchemas>;
  //FNot_ := CreateSubObject<TOpenAPISchema>;
  //FItems := CreateSubObject<TOpenAPISchema>;
  FProperties := CreateSubObject<TOpenAPISchemaMap>;
  FDiscriminator := CreateSubObject<TOpenAPIDiscriminator>;
  //FAdditionalProperties := CreateSubObject<TOpenAPISchema>;
  FDefault_ := CreateSubObject<TOpenAPIAny>;
  FEnum := CreateSubObject<TOpenAPIEnum>;
end;

destructor TOpenAPISchema.Destroy;
begin
  // You need to destroy these in case Neon creates them
  FNot_.Free;
  FItems.Free;
  FAdditionalProperties.Free;
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
  Result := not Assigned(FJSONObject) and FType_.IsNull and FTitle.IsNull and FFormat.IsNull and
    FAllOf.IsEmpty and FAnyOf.IsEmpty and FOneOf.IsEmpty and FProperties.IsEmpty and
    not IsReference();
end;

procedure TOpenAPISchema.SetJSONObject(AJSON: TJSONObject; AOwned: Boolean);
begin
  if Assigned(FJSONObject) and FJSONOwned then
    FJSONObject.Free;

  FJSONObject := AJSON;
  FJSONOwned := AOwned;
end;

procedure TOpenAPISchema.SetJSONFromClass(AClass: TClass);
begin
  SetJSONObject(TNeonSchemaGenerator.ClassToJSONSchema(AClass, GetNeonConfig));
end;

procedure TOpenAPISchema.SetJSONFromType(AType: TRttiType);
begin
  SetJSONObject(TNeonSchemaGenerator.TypeToJSONSchema(AType, GetNeonConfig));
end;

procedure TOpenAPISchema.SetSchemaReference(const AReference: string);
begin
  Reference.Ref := '#/components/schemas/' + AReference;
end;

function TOpenAPISchema.WithNeonConfig(AConfig: INeonConfiguration): TOpenAPISchema;
begin
  FNeonConfig := AConfig;
  Result := Self;
end;

end.
