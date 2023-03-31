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
unit OpenAPI.Model.Classes;

interface

{$SCOPEDENUMS ON}

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.Rtti,

  Neon.Core.Types,
  Neon.Core.Nullables,
  Neon.Core.Attributes,
  Neon.Core.Persistence,

  OpenAPI.Core.Exceptions,
  OpenAPI.Core.Interfaces,
  OpenAPI.Model.Base,
  OpenAPI.Model.Any,
  OpenAPI.Model.Schema,
  OpenAPI.Model.Expressions,
  OpenAPI.Model.Reference;

type

{$REGION 'OpenAPI enum types'}
  [NeonEnumNames('matrix,label,form,simple,spaceDelimited,pipeDelimited,deepObject')]
  TParameterStyle = (
    /// <summary>
    /// Path-style parameters.
    /// </summary>
    Matrix,

    /// <summary>
    /// Label style parameters.
    /// </summary>
    Label_,

    /// <summary>
    /// Form style parameters.
    /// </summary>
    Form,

    /// <summary>
    /// Simple style parameters.
    /// </summary>
    Simple,

    /// <summary>
    /// Space separated array values.
    /// </summary>
    SpaceDelimited,

    /// <summary>
    /// Pipe separated array values.
    /// </summary>
    PipeDelimited,

    /// <summary>
    /// Provides a simple way of rendering nested objects using form parameters.
    /// </summary>
    DeepObject
  );

  [NeonEnumNames('apiKey,http,oauth2,openIdConnect')]
  TSecurityScheme = (
    /// <summary>
    /// Use API key
    /// </summary>
    ApiKey,

    /// <summary>
    /// Use basic or bearer token authorization header.
    /// </summary>
    Http,

    /// <summary>
    /// Use OAuth2
    /// </summary>
    OAuth2,

    /// <summary>
    /// Use OAuth2 with OpenId Connect Url to discover OAuth2 configuration value.
    /// </summary>
    OpenIdConnect
  );

  [NeonEnumNames('query,header,cookie')]
  TAPIKeyLocation = (
    /// <summary>
    /// APIKey as Query param
    /// </summary>
    Query,

    /// <summary>
    /// APIKey as Http Header
    /// </summary>
    Header,

    /// <summary>
    /// APIKey as Http Cookie
    /// </summary>
    Cookie
  );

  [NeonEnumNames('query,header,path,cookie')]
  TParameterLocation = (
    /// <summary>
    /// Parameters that are appended to the Url.
    /// </summary>
    Query,

    /// <summary>
    /// Custom headers that are expected as part of the request.
    /// </summary>
    Header,

    /// <summary>
    /// Used together with Path Templating,
    /// where the parameter value is actually part of the operation's Url
    /// </summary>
    Path,

    /// <summary>
    /// Used to pass a specific cookie value to the API.
    /// </summary>
    Cookie
  );

  [NeonEnumNames('get,put,post,delete,options,head,patch,trace')]
  TOperationType = (
    /// <summary>
    /// A definition of a GET operation on this path.
    /// </summary>
    Get,

    /// <summary>
    /// A definition of a PUT operation on this path.
    /// </summary>
    Put,

    /// <summary>
    /// A definition of a POST operation on this path.
    /// </summary>
    Post,

    /// <summary>
    /// A definition of a DELETE operation on this path.
    /// </summary>
    Delete,

    /// <summary>
    /// A definition of a OPTIONS operation on this path.
    /// </summary>
    Options,

    /// <summary>
    /// A definition of a HEAD operation on this path.
    /// </summary>
    Head,

    /// <summary>
    /// A definition of a PATCH operation on this path.
    /// </summary>
    Patch,

    /// <summary>
    /// A definition of a TRACE operation on this path.
    /// </summary>
    Trace
  );
  TOperationTypeHelper = record helper for TOperationType
  public
    function ToString: string;
    class function FromString(const AValue: string): TOperationType; static;
  end;

{$ENDREGION}
  
  /// <summary>
  ///   Contact information for the exposed API
  /// </summary>
  TOpenAPIContact = class(TOpenAPIExtensible)
  private
    FName: NullString;
    FUrl: NullString;
    FEmail: NullString;
  public
    /// <summary>
    /// The identifying name of the contact person/organization.
    /// </summary>
    property Name: NullString read FName write FName;

    /// <summary>
    /// The Url pointing to the contact information. MUST be in the format of a Url.
    /// </summary>
    property Url: NullString read FUrl write FUrl;

    /// <summary>
    /// The email address of the contact person/organization.
    /// MUST be in the format of an email address.
    /// </summary>
    property Email: NullString read FEmail write FEmail;
  end;

  /// <summary>
  ///   License information for the exposed API
  /// </summary>
  TOpenAPILicense = class(TOpenAPIExtensible)
  private
    FName: NullString;
    FUrl: NullString;
  public
    /// <summary>
    /// REQUIRED. The license name used for the API.
    /// </summary>
    property Name: NullString read FName write FName;

    /// <summary>
    /// The Url pointing to the contact information. MUST be in the format of a Url.
    /// </summary>
    property Url: NullString read FUrl write FUrl;
  end;

  /// <summary>
  /// ExternalDocs object
  /// </summary>
  TOpenAPIExternalDocumentation = class(TOpenAPIExtensible)
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

  TOpenAPIExamples = class;
  TOpenAPIMediaTypeMap = class;

  /// <summary>
  /// Parameter Object
  /// </summary>
  TOpenAPIParameter = class(TOpenAPIExtensible)
  private
    FAllowEmptyValue: NullBoolean;
    FDeprecated_: NullBoolean;
    FDescription: NullString;
    FIn_: string;
    FName: string;
    FRequired: NullBoolean;
    FStyle: Nullable<TParameterStyle>;
    FExplode: NullBoolean;
    FAllowReserved: NullBoolean;
    FSchema: TOpenAPISchema;
    FExamples: TOpenApiExamples;
    FContent: TOpenApiMediaTypeMap;
    FExample: TOpenAPIAny;
  public
    constructor Create; overload;
    constructor Create(const AName, ALocation: string); overload;

    function GetHash: string;
  public
    /// <summary>
    /// REQUIRED. The name of the parameter. Parameter names are case sensitive.
    /// If in is "path", the name field MUST correspond to the associated path segment from the path field in the Paths Object.
    /// If in is "header" and the name field is "Accept", "Content-Type" or "Authorization", the parameter definition SHALL be ignored.
    /// For all other cases, the name corresponds to the parameter name used by the in property.
    /// </summary>
    property Name: string read FName write FName;

    /// <summary>
    /// REQUIRED. The location of the parameter.
    /// Possible values are "query", "header", "path" or "cookie".
    /// </summary>
    [NeonProperty('in')]
    property In_: string read FIn_ write FIn_;

    /// <summary>
    /// A brief description of the parameter. This could contain examples of use.
    /// CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Determines whether this parameter is mandatory.
    /// If the parameter location is "path", this property is REQUIRED and its value MUST be true.
    /// Otherwise, the property MAY be included and its default value is false.
    /// </summary>
    property Required: NullBoolean read FRequired write FRequired;

    /// <summary>
    /// Specifies that a parameter is deprecated and SHOULD be transitioned out of usage.
    /// </summary>
    [NeonProperty('deprecated')]
    property Deprecated_: NullBoolean read FDeprecated_ write FDeprecated_;

    /// <summary>
    /// Sets the ability to pass empty-valued parameters.
    /// This is valid only for query parameters and allows sending a parameter with an empty value.
    /// Default value is false.
    /// If style is used, and if behavior is n/a (cannot be serialized),
    /// the value of allowEmptyValue SHALL be ignored.
    /// </summary>
    property AllowEmptyValue: NullBoolean read FAllowEmptyValue write FAllowEmptyValue;

    /// <summary>
    /// Describes how the parameter value will be serialized depending on the type of the parameter value.
    /// Default values (based on value of in): for query - form; for path - simple; for header - simple;
    /// for cookie - form.
    /// </summary>
    property Style: Nullable<TParameterStyle> read FStyle write FStyle;

    /// <summary>
    /// When this is true, parameter values of type array or object generate separate parameters
    /// for each value of the array or key-value pair of the map.
    /// For other types of parameters this property has no effect.
    /// When style is form, the default value is true.
    /// For all other styles, the default value is false.
    /// </summary>
    property Explode: NullBoolean read FExplode write FExplode;

    /// <summary>
    /// Determines whether the parameter value SHOULD allow reserved characters,
    /// as defined by RFC3986 :/?#[]@!$&amp;'()*+,;= to be included without percent-encoding.
    /// This property only applies to parameters with an in value of query.
    /// The default value is false.
    /// </summary>
    property AllowReserved: NullBoolean read FAllowReserved write FAllowReserved;

    /// <summary>
    /// The schema defining the type used for the parameter.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Schema: TOpenAPISchema read FSchema write FSchema;

    /// <summary>
    /// Examples of the media type. Each example SHOULD contain a value
    /// in the correct format as specified in the parameter encoding.
    /// The examples object is mutually exclusive of the example object.
    /// Furthermore, if referencing a schema which contains an example,
    /// the examples value SHALL override the example provided by the schema.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Examples: TOpenApiExamples read FExamples write FExamples;

    /// <summary>
    /// Example of the media type. The example SHOULD match the specified schema and encoding properties
    /// if present. The example object is mutually exclusive of the examples object.
    /// Furthermore, if referencing a schema which contains an example,
    /// the example value SHALL override the example provided by the schema.
    /// To represent examples of media types that cannot naturally be represented in JSON or YAML,
    /// a string value can contain the example with escaping where necessary.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Example: TOpenAPIAny read FExample write FExample;

    /// <summary>
    /// A map containing the representations for the parameter.
    /// The key is the media type and the value describes it.
    /// The map MUST only contain one entry.
    /// For more complex scenarios, the content property can define the media type and schema of the parameter.
    /// A parameter MUST contain either a schema property, or a content property, but not both.
    /// When example or examples are provided in conjunction with the schema object,
    /// the example MUST follow the prescribed serialization strategy for the parameter.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Content: TOpenApiMediaTypeMap read FContent write FContent;
  end;

  TOpenAPIParameters = class(TOpenAPIModelList<TOpenAPIParameter>)
  public
    function ParamExists(AParam: TOpenAPIParameter): Boolean; overload;
    function ParamExists(const AName, ALocation: string): Boolean; overload;
    function FindParam(const AName, ALocation: string): TOpenAPIParameter;
  end;

  /// <summary>
  /// Used only in Components
  /// </summary>
  TOpenAPIParameterMap = class(TOpenAPIModelMap<TOpenAPIParameter>);

  /// <summary>
  /// Example Object.
  /// </summary>
  TOpenAPIExample = class(TOpenAPIModelReference)
  private
    FSummary: NullString;
    FDescription: NullString;
    FExternalValue: NullString;
    FValue: TOpenAPIAny;
  public
    constructor Create;
  public
    /// <summary>
    /// Short description for the example.
    /// </summary>
    property Summary: NullString read FSummary write FSummary;

    /// <summary>
    /// Long description for the example.
    /// CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Embedded literal example. The value field and externalValue field are mutually
    /// exclusive. To represent examples of media types that cannot naturally represented
    /// in JSON or YAML, use a string value to contain the example, escaping where necessary.
    /// </summary>
    property Value: TOpenAPIAny read FValue write FValue;

    /// <summary>
    /// A Url that points to the literal example.
    /// This provides the capability to reference examples that cannot easily be
    /// included in JSON or YAML documents.
    /// The value field and externalValue field are mutually exclusive.
    /// </summary>
    property ExternalValue: NullString read FExternalValue write FExternalValue;
  end;

  TOpenAPIExamples = class(TOpenAPIModelList<TOpenAPIExample>);
  TOpenAPIExampleMap = class(TOpenAPIModelMap<TOpenAPIParameter>);

  TOpenAPIEncoding = class;
  TOpenAPIEncodingMap = class;

  /// <summary>
  /// MediaType Object.
  /// </summary>
  TOpenAPIMediaType = class(TOpenAPIExtensible)
  private
    FSchema: TOpenAPISchema;
    FExamples: TOpenAPIExampleMap;
    FEncoding: TOpenAPIEncodingMap;
    FExample: TOpenAPIAny;
  public
    constructor Create;
  public
    /// <summary>
    /// The schema defining the type used for the request body.
    /// </summary>
    property Schema: TOpenAPISchema read FSchema write FSchema;

    /// <summary>
    /// Example of the media type.
    /// The example object SHOULD be in the correct format as specified by the media type.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Example: TOpenAPIAny read FExample write FExample;

    /// <summary>
    /// Examples of the media type.
    /// Each example object SHOULD match the media type and specified schema if present.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Examples: TOpenAPIExampleMap read FExamples write FExamples;

    /// <summary>
    /// A map between a property name and its encoding information.
    /// The key, being the property name, MUST exist in the schema as a property.
    /// The encoding object SHALL only apply to requestBody objects
    /// when the media type is multipart or application/x-www-form-Urlencoded.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Encoding: TOpenAPIEncodingMap read FEncoding write FEncoding;
  end;

  TOpenAPIMediaTypeMap = class(TOpenAPIModelMap<TOpenAPIMediaType>);

  /// <summary>
  /// Header Object.
  /// </summary>
  TOpenAPIHeader = class(TOpenAPIModelReference)
  private
    FDescription: NullString;
    FRequired: NullBoolean;
    FDeprecated_: NullBoolean;
    FAllowEmptyValue: NullBoolean;
    FStyle: Nullable<TParameterStyle>;
    FExplode: NullBoolean;
    FAllowReserved: NullBoolean;
    FSchema: TOpenAPISchema;
    FExamples: TOpenAPIExampleMap;
    FContent: TOpenAPIMediaTypeMap;
    FExample: TOpenAPIAny;
  public
    constructor Create;
  public
    /// <summary>
    /// A brief description of the header.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Determines whether this header is mandatory.
    /// </summary>
    property Required: NullBoolean read FRequired write FRequired;

    /// <summary>
    /// Specifies that a header is deprecated and SHOULD be transitioned out of usage.
    /// </summary>
    [NeonProperty('deprecated')]
    property Deprecated_: NullBoolean read FDeprecated_ write FDeprecated_;

    /// <summary>
    /// Sets the ability to pass empty-valued headers.
    /// </summary>
    property AllowEmptyValue: NullBoolean read FAllowEmptyValue write FAllowEmptyValue;

    /// <summary>
    /// Describes how the header value will be serialized depending on the type of the header value.
    /// </summary>
    property Style: Nullable<TParameterStyle> read FStyle write FStyle;

    /// <summary>
    /// When this is true, header values of type array or object generate separate parameters
    /// for each value of the array or key-value pair of the map.
    /// </summary>
    property Explode: NullBoolean read FExplode write FExplode;

    /// <summary>
    /// Determines whether the header value SHOULD allow reserved characters, as defined by RFC3986.
    /// </summary>
    property AllowReserved: NullBoolean read FAllowReserved write FAllowReserved;

    /// <summary>
    /// The schema defining the type used for the header.
    /// </summary>
    property Schema: TOpenAPISchema read FSchema write FSchema;

    /// <summary>
    /// Example of the media type.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Example: TOpenAPIAny read FExample write FExample;

    /// <summary>
    /// Examples of the media type.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Examples: TOpenAPIExampleMap read FExamples write FExamples;

    /// <summary>
    /// A map containing the representations for the header.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Content: TOpenAPIMediaTypeMap read FContent write FContent;
  end;

  TOpenAPIHeaderMap = class(TOpenAPIModelMap<TOpenAPIHeader>);

  TOpenAPIEncoding = class(TOpenAPIExtensible)
  private
    FContentType: NullString;
    FHeaders: TOpenAPIHeaderMap;
    FStyle: Nullable<TParameterStyle>;
    FExplode: NullBoolean;
    FAllowReserved: NullBoolean;
  public
    constructor Create;
  public
    /// <summary>
    /// The Content-Type for encoding a specific property.
    /// The value can be a specific media type (e.g. application/json),
    /// a wildcard media type (e.g. image/*), or a comma-separated list of the two types.
    /// </summary>
    property ContentType: NullString read FContentType write FContentType;

    /// <summary>
    /// A map allowing additional information to be provided as headers.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Headers: TOpenAPIHeaderMap read FHeaders write FHeaders;

    /// <summary>
    /// Describes how a specific property value will be serialized depending on its type.
    /// </summary>
    property Style: Nullable<TParameterStyle> read FStyle write FStyle;

    /// <summary>
    /// When this is true, property values of type array or object generate separate parameters
    /// for each value of the array, or key-value-pair of the map. For other types of properties
    /// this property has no effect. When style is form, the default value is true.
    /// For all other styles, the default value is false.
    /// This property SHALL be ignored if the request body media type is not application/x-www-form-Urlencoded.
    /// </summary>
    property Explode: NullBoolean read FExplode write FExplode;

    /// <summary>
    /// Determines whether the parameter value SHOULD allow reserved characters,
    /// as defined by RFC3986 :/?#[]@!$&amp;'()*+,;= to be included without percent-encoding.
    /// The default value is false. This property SHALL be ignored
    /// if the request body media type is not application/x-www-form-Urlencoded.
    /// </summary>
    property AllowReserved: NullBoolean read FAllowReserved write FAllowReserved;
  end;
  
  TOpenAPIEncodingMap = class(TOpenAPIModelMap<TOpenAPIEncoding>);
  
  TOpenAPIExternalDocs = class(TOpenAPIExtensible)
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

  TOpenAPITag = class(TOpenAPIModelReference)
  private
    FName: NullString;
    FDescription: NullString;
    FExternalDocs: TOpenAPIExternalDocs;
  public
    constructor Create;
  public
    /// <summary>
    /// The name of the tag.
    /// </summary>
    property Name: NullString read FName write FName;

    /// <summary>
    /// A short description for the tag.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Additional external documentation for this tag.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property ExternalDocs: TOpenAPIExternalDocs read FExternalDocs write FExternalDocs;
  end;

  TOpenAPITags = class(TOpenAPIModelList<TOpenAPITag>);

  TOpenAPIRequestBody = class(TOpenAPIModelReference)
  private
    FDescription: NullString;
    FRequired: NullBoolean;
    FContent: TOpenAPIMediaTypeMap;
  public
    constructor Create;
    function AddMediaType(const AKeyName: string): TOpenAPIMediaType;
  public
    /// <summary>
    /// A brief description of the request body. This could contain examples of use.
    /// CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Determines if the request body is required in the request. Defaults to false.
    /// </summary>
    property Required: NullBoolean read FRequired write FRequired;

    /// <summary>
    /// REQUIRED. The content of the request body. The key is a media type or media type range and the value describes it.
    /// For requests that match multiple keys, only the most specific key is applicable. e.g. text/plain overrides text/*
    /// </summary>
    property Content: TOpenAPIMediaTypeMap read FContent write FContent;
  end;

  TOpenAPIRequestBodyMap = class(TOpenAPIModelMap<TOpenAPIRequestBody>);

  /// <summary>
  ///   An object representing a Server Variable for server Url template substitution
  /// </summary>
  TOpenAPIServerVariable = class(TOpenAPIExtensible)
  private
    FEnum: TArray<string>;
    FDefault_: string;
    FDescription: NullString;
  public
    /// <summary>
    /// An optional description for the server variable. CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// REQUIRED. The default value to use for substitution, and to send, if an alternate value is not supplied.
    /// Unlike the Schema Object's default, this value MUST be provided by the consumer.
    /// </summary>
    [NeonProperty('default')]
    property Default_: string read FDefault_ write FDefault_;

    /// <summary>
    /// An enumeration of string values to be used if the substitution options are from a limited set.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Enum: TArray<string> read FEnum write FEnum;
  end;

  TOpenAPIServerVariableMap = class(TOpenAPIModelMap<TOpenAPIServerVariable>);

  /// <summary>
  ///   An object representing a Server
  /// </summary>
  TOpenAPIServer = class(TOpenAPIExtensible)
  private
    FDescription: NullString;
    FVariables: TOpenAPIServerVariableMap;
    FUrl: string;
  public
    constructor Create; overload;
    constructor Create(const AURL, ADescription: string); overload;
  public
    /// <summary>
    /// An optional string describing the host designated by the Url. CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// REQUIRED. A Url to the target host. This Url supports Server Variables and MAY be relative,
    /// to indicate that the host location is relative to the location where the OpenAPI document is being served.
    /// Variable substitutions will be made when a variable is named in {brackets}.
    /// </summary>
    property Url: string read FUrl write FUrl;

    /// <summary>
    /// A map between a variable name and its value. The value is used for substitution in the server's Url template.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Variables: TOpenAPIServerVariableMap read FVariables write FVariables;
  end;

  TOpenAPIServers = class(TOpenAPIModelList<TOpenAPIServer>);
  TOpenAPIServerMap = class(TOpenAPIModelMap<TOpenAPIServer>);

  /// <summary>
  ///   Link Object. The Link Object represents a possible design-time link for
  ///   a response
  /// </summary>
  TOpenAPILink = class(TOpenAPIExtensible)
  private
    FOperationId: NullString;
    FOperationRef: NullString;
    FRequestBody: TRuntimeExpression;
    FParameters: TRuntimeExpressionMap;
    FDescription: NullString;
    FServer: TOpenAPIServer;
  public
    constructor Create;
  public
    /// <summary>
    /// A relative or absolute reference to an OAS operation.
    /// This field is mutually exclusive of the operationId field, and MUST point to an Operation Object.
    /// </summary>
    property OperationRef: NullString read FOperationRef write FOperationRef;

    /// <summary>
    /// The name of an existing, resolvable OAS operation, as defined with a unique operationId.
    /// This field is mutually exclusive of the operationRef field.
    /// </summary>
    property OperationId: NullString read FOperationId write FOperationId;

    /// <summary>
    /// A map representing parameters to pass to an operation as specified with operationId or identified via operationRef.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Parameters: TRuntimeExpressionMap read FParameters write FParameters;

    /// <summary>
    /// A literal value or {expression} to use as a request body when calling the target operation.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property RequestBody: TRuntimeExpression read FRequestBody write FRequestBody;

    /// <summary>
    /// A description of the link.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// A server object to be used by the target operation.
    /// </summary>
    property Server: TOpenAPIServer read FServer write FServer;
  end;

  TOpenAPILinkMap = class(TOpenAPIModelMap<TOpenAPILink>);

  /// <summary>
  /// Response object.
  /// </summary>
  TOpenAPIResponse = class(TOpenAPIModelReference)
  private
    FDescription: string;
    FLinks: TOpenAPILinkMap;
    FContent: TOpenAPIMediaTypeMap;
    FHeaders: TOpenAPIHeaderMap;
  public
    constructor Create;
  public
    function AddHeader(const AKeyName: string): TOpenAPIHeader;
    function AddMediaType(const AKeyName: string): TOpenAPIMediaType;
    function AddLink(const AKeyName: string): TOpenAPILink;
  public
    /// <summary>
    /// REQUIRED. A short description of the response.
    /// </summary>
    property Description: string read FDescription write FDescription;

    /// <summary>
    /// Maps a header name to its definition.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Headers: TOpenAPIHeaderMap read FHeaders write FHeaders;

    /// <summary>
    /// A map containing descriptions of potential response payloads.
    /// The key is a media type or media type range and the value describes it.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Content: TOpenAPIMediaTypeMap read FContent write FContent;

    /// <summary>
    /// A map of operations links that can be followed from the response.
    /// The key of the map is a short name for the link,
    /// following the naming constraints of the names for Component Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Links: TOpenAPILinkMap read FLinks write FLinks;
  end;

  TOpenAPIResponseMap = class(TOpenAPIModelExtensibleMap<TOpenAPIResponse>);

  TOpenAPIPathItem = class;

  TOpenAPICallback = class(TOpenAPIModelReference)
  private
    FPathItems: TObjectDictionary<TRuntimeExpression, TOpenAPIPathItem>;
  public
    constructor Create;
  public
    /// <summary>
    /// A Path Item Object used to define a callback request and expected responses.
    /// </summary>
    property PathItems: TObjectDictionary<TRuntimeExpression, TOpenAPIPathItem> read FPathItems write FPathItems;
  end;

  TOpenAPICallbackMap = class(TOpenAPIModelMap<TOpenAPICallback>);

  TOpenAPIOAuthFlow = class(TOpenAPIExtensible)
  private
    FAuthorizationUrl: string;
    FTokenUrl: string;
    FRefreshUrl: NullString;
    FScopes: TDictionary<string, string>;
  public
    constructor Create;
  public
    /// <summary>
    /// REQUIRED. The authorization Url to be used for this flow.
    /// Applies to implicit and authorizationCode OAuthFlow.
    /// </summary>
    property AuthorizationUrl: string read FAuthorizationUrl write FAuthorizationUrl;

    /// <summary>
    /// REQUIRED. The token Url to be used for this flow.
    /// Applies to password, clientCredentials, and authorizationCode OAuthFlow.
    /// </summary>
    property TokenUrl: string read FTokenUrl write FTokenUrl;

    /// <summary>
    /// The Url to be used for obtaining refresh tokens.
    /// </summary>
    property RefreshUrl: NullString read FRefreshUrl write FRefreshUrl;

    /// <summary>
    /// REQUIRED. A map between the scope name and a short description for it.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Scopes: TDictionary<string, string> read FScopes write FScopes;
  end;

  TOpenAPIOAuthFlows = class(TOpenAPIExtensible)
  private
    FImplicit: TOpenAPIOAuthFlow;
    FPassword: TOpenAPIOAuthFlow;
    FClientCredentials: TOpenAPIOAuthFlow;
    FAuthorizationCode: TOpenAPIOAuthFlow;
  public
    constructor Create;
  public
    /// <summary>
    /// Configuration for the OAuth Implicit flow
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Implicit: TOpenAPIOAuthFlow read FImplicit write FImplicit;

    /// <summary>
    /// Configuration for the OAuth Resource Owner Password flow.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Password: TOpenAPIOAuthFlow read FPassword write FPassword;

    /// <summary>
    /// Configuration for the OAuth Client Credentials flow.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property ClientCredentials: TOpenAPIOAuthFlow read FClientCredentials write FClientCredentials;

    /// <summary>
    /// Configuration for the OAuth Authorization Code flow.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property AuthorizationCode: TOpenAPIOAuthFlow read FAuthorizationCode write FAuthorizationCode;

    /// <summary>
    /// Specification Extensions.
    /// </summary>
  end;

  TOpenAPISecurityScheme = class(TOpenAPIModelReference)
  private
    FType_: Nullable<TSecurityScheme>;
    FDescription: NullString;
    FName: string;
    FIn_: Nullable<TAPIKeyLocation>;
    FScheme: string;
    FBearerFormat: NullString;
    FFlows: TOpenAPIOAuthFlows;
    FOpenIdConnectUrl: string;
  public
    constructor Create;
    function ShouldInclude(const AContext: TNeonIgnoreIfContext): Boolean;
  public
    /// <summary>
    /// REQUIRED. The type of the security scheme. Valid values are "apiKey", "http", "oauth2", "openIdConnect".
    /// </summary>
    [NeonProperty('type')]
    property Type_: Nullable<TSecurityScheme> read FType_ write FType_;

    /// <summary>
    /// A short description for security scheme. CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// REQUIRED. The name of the header, query or cookie parameter to be used.
    /// </summary>
    [NeonInclude(IncludeIf.CustomFunction)]
    property Name: string read FName write FName;

    /// <summary>
    /// REQUIRED. The location of the API key. Valid values are "query", "header" or "cookie".
    /// </summary>
    [NeonProperty('in')]
    [NeonInclude(IncludeIf.CustomFunction)]
    property In_: Nullable<TAPIKeyLocation> read FIn_ write FIn_;

    /// <summary>
    /// REQUIRED. The name of the HTTP Authorization scheme to be used
    /// in the Authorization header as defined in RFC7235.
    /// </summary>
    [NeonInclude(IncludeIf.CustomFunction)]
    property Scheme: string read FScheme write FScheme;

    /// <summary>
    /// A hint to the client to identify how the bearer token is formatted.
    /// Bearer tokens are usually generated by an authorization server,
    /// so this information is primarily for documentation purposes.
    /// </summary>
    [NeonInclude(IncludeIf.CustomFunction)]
    property BearerFormat: NullString read FBearerFormat write FBearerFormat;

    /// <summary>
    /// REQUIRED. An object containing configuration information for the flow types supported.
    /// </summary>
    [NeonInclude(IncludeIf.CustomFunction)]
    property Flows: TOpenAPIOAuthFlows read FFlows write FFlows;

    /// <summary>
    /// REQUIRED. OpenId Connect Url to discover OAuth2 configuration values.
    /// </summary>
    [NeonInclude(IncludeIf.CustomFunction)]
    property OpenIdConnectUrl: string read FOpenIdConnectUrl write FOpenIdConnectUrl;
  end;

  TOpenAPISecuritySchemeMap = class(TOpenAPIModelMap<TOpenAPISecurityScheme>);
  TOpenAPISecurityRequirement = class(TDictionary<string, TArray<string>>);

  TOpenAPISecurityRequirements = class(TOpenAPIModelList<TOpenAPISecurityRequirement>)
  public
    procedure AddSecurityRequirement(ASecuritySchemes: TOpenAPISecuritySchemeMap;
        ASchemeName: string; AParams: TArray<string>);
  end;

  /// <summary>
  ///   Operation Object
  /// </summary>
  TOpenAPIOperation = class(TOpenAPIExtensible)
  private
    FTags: TArray<string>;
    FSummary: NullString;
    FOperationId: NullString;
    FDescription: NullString;
    FExternalDocs: TOpenAPIExternalDocumentation;
    FParameters: TOpenAPIParameters;
    FRequestBody: TOpenAPIRequestBody;
    FCallbacks: TOpenAPICallbackMap;
    FSecurity: TOpenAPISecurityRequirements;
    FServers: TOpenAPIServers;
    FDeprecated_: NullBoolean;
    FResponses: TOpenAPIResponseMap;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure AddTag(const AName: string);
    function AddResponse(ACode: Integer): TOpenAPIResponse; overload;
    function AddResponse(const AName: string): TOpenAPIResponse; overload;
    function AddParameter(const AName, ALocation: string): TOpenAPIParameter;

    function SetRequestBody(const ADescription: string): TOpenAPIRequestBody;
  public
    /// <summary>
    /// A list of tags for API documentation control.
    /// Tags can be used for logical grouping of operations by resources or any other qualifier.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Tags: TArray<string> read FTags write FTags;

    /// <summary>
    /// A short summary of what the operation does.
    /// </summary>
    property Summary: NullString read FSummary write FSummary;

    /// <summary>
    /// A verbose explanation of the operation behavior.
    /// CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Additional external documentation for this operation.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property ExternalDocs: TOpenAPIExternalDocumentation read FExternalDocs write FExternalDocs;

    /// <summary>
    /// Unique string used to identify the operation. The id MUST be unique among all operations described in the API.
    /// Tools and libraries MAY use the operationId to uniquely identify an operation, therefore,
    /// it is RECOMMENDED to follow common programming naming conventions.
    /// </summary>
    property OperationId: NullString read FOperationId write FOperationId;

    /// <summary>
    /// A list of parameters that are applicable for this operation.
    /// If a parameter is already defined at the Path Item, the new definition will override it but can never remove it.
    /// The list MUST NOT include duplicated parameters. A unique parameter is defined by a combination of a name and location.
    /// The list can use the Reference Object to link to parameters that are defined at the OpenAPI Object's components/parameters.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Parameters: TOpenAPIParameters read FParameters write FParameters;

    /// <summary>
    /// The request body applicable for this operation.
    /// The requestBody is only supported in HTTP methods where the HTTP 1.1 specification RFC7231
    /// has explicitly defined semantics for request bodies.
    /// In other cases where the HTTP spec is vague, requestBody SHALL be ignored by consumers.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    [NeonAutoCreate]
    property RequestBody: TOpenAPIRequestBody read FRequestBody write FRequestBody;

    /// <summary>
    /// REQUIRED. The list of possible responses as they are returned from executing this operation.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Responses: TOpenAPIResponseMap read FResponses write FResponses;

    /// <summary>
    /// A map of possible out-of band callbacks related to the parent operation.
    /// The key is a unique identifier for the Callback Object.
    /// Each value in the map is a Callback Object that describes a request
    /// that may be initiated by the API provider and the expected responses.
    /// The key value used to identify the callback object is an expression, evaluated at runtime,
    /// that identifies a Url to use for the callback operation.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Callbacks: TOpenAPICallbackMap read FCallbacks write FCallbacks;

    /// <summary>
    /// Declares this operation to be deprecated. Consumers SHOULD refrain from usage of the declared operation.
    /// </summary>
    [NeonProperty('deprecated')]
    property Deprecated_: NullBoolean read FDeprecated_ write FDeprecated_;

    /// <summary>
    /// A declaration of which security mechanisms can be used for this operation.
    /// The list of values includes alternative security requirement objects that can be used.
    /// Only one of the security requirement objects need to be satisfied to authorize a request.
    /// This definition overrides any declared top-level security.
    /// To remove a top-level security declaration, an empty array can be used.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Security: TOpenAPISecurityRequirements read FSecurity write FSecurity;

    /// <summary>
    /// An alternative server array to service this operation.
    /// If an alternative server object is specified at the Path Item Object or Root level,
    /// it will be overridden by this value.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Servers: TOpenAPIServers read FServers write FServers;
  end;

  TOpenAPIOperationMap = class (TOpenAPIOwnedMap<TOperationType, TOpenAPIOperation>);

  /// <summary>
  /// The object provides metadata about the API
  /// </summary>
  TOpenAPIInfo = class(TOpenAPIExtensible)
  private
    FContact: TOpenAPIContact;
    FDescription: NullString;
    FLicense: TOpenAPILicense;
    FTermsOfService: NullString;
    FTitle: string;
    FVersion: string;
  public
    constructor Create;
  public
    /// <summary>
    /// REQUIRED. The title of the application.
    /// </summary>
    property Title: string read FTitle write FTitle;

    /// <summary>
    /// A short description of the application.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// A Url to the Terms of Service for the API. MUST be in the format of a Url.
    /// </summary>
    property TermsOfService: NullString read FTermsOfService write FTermsOfService;

    /// <summary>
    /// The contact information for the exposed API.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Contact: TOpenAPIContact read FContact write FContact;

    /// <summary>
    /// The license information for the exposed API.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property License: TOpenAPILicense read FLicense write FLicense;

    /// <summary>
    /// REQUIRED. The version of the OpenAPI document.
    /// </summary>
    property Version: string read FVersion write FVersion;
  end;

  /// <summary>
  /// Component Object.
  /// </summary>
  TOpenAPIComponents = class(TOpenAPIExtensible)
  private
    FSchemas: TOpenAPISchemaMap;
    FResponses: TOpenAPIResponseMap;
    FParameters: TOpenAPIParameterMap;
    FExamples: TOpenAPIExampleMap;
    FRequestBodies: TOpenAPIRequestBodyMap;
    FHeaders: TOpenAPIHeaderMap;
    FSecuritySchemes: TOpenAPISecuritySchemeMap;
    FLinks: TOpenAPILinkMap;
    FCallbacks: TOpenAPICallbackMap;
    function AddSecurityScheme(const AName, ADescription: string; AType: TSecurityScheme): TOpenAPISecurityScheme;
  public
    constructor Create;
  public
    function SchemaExists(const AKeyName: string): Boolean;
    function AddSchema(const AKeyName: string): TOpenAPISchema;
    function AddResponse(const AKeyName, ADescription: string): TOpenAPIResponse;
    function AddParameter(const AKeyName, AName, ALocation: string): TOpenAPIparameter;

    function AddSecurityHttp(const AKeyName, ADescription, AScheme, ABearerFormat: string): TOpenAPISecurityScheme;
    function AddSecurityApiKey(const AKeyName, ADescription, AHeaderName: string; ALocation: TAPIKeyLocation): TOpenAPISecurityScheme;
    function AddSecurityOpenID(const AKeyName, ADescription, AURL: string): TOpenAPISecurityScheme;
    function AddSecurityOAuth2(const AKeyName, ADescription: string; AFlow: TOpenAPIOAuthFlows): TOpenAPISecurityScheme;
  public
    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiSchema"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Schemas: TOpenAPISchemaMap read FSchemas write FSchemas;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiResponse"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Responses: TOpenAPIResponseMap read FResponses write FResponses;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiParameter"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Parameters: TOpenAPIParameterMap read FParameters write FParameters;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiExample"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Examples: TOpenAPIExampleMap read FExamples write FExamples;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiRequestBody"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property RequestBodies: TOpenAPIRequestBodyMap read FRequestBodies write FRequestBodies;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiHeader"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Headers: TOpenAPIHeaderMap read FHeaders write FHeaders;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiSecurityScheme"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property SecuritySchemes: TOpenAPISecuritySchemeMap read FSecuritySchemes write FSecuritySchemes;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiLink"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Links: TOpenAPILinkMap read FLinks write FLinks;

    /// <summary>
    /// An object to hold reusable <see cref="TOpenApiCallback"/> Objects.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Callbacks: TOpenAPICallbackMap read FCallbacks write FCallbacks;
  end;

  /// <summary>
  /// Path Item Object: to describe the operations available on a single path.
  /// </summary>
  TOpenAPIPathItem = class(TOpenAPIExtensible)
  private
    FSummary: NullString;
    FDescription: NullString;
    FServers: TOpenAPIServerMap;
    FParameters: TOpenAPIParameters;
    FGet: TOpenAPIOperation;
    FPut: TOpenAPIOperation;
    FHead: TOpenAPIOperation;
    FPatch: TOpenAPIOperation;
    FPost: TOpenAPIOperation;
    FTrace: TOpenAPIOperation;
    FDelete: TOpenAPIOperation;
    FOptions: TOpenAPIOperation;
  public
    constructor Create;
  public
    function AddOperation(const AType: TOperationType): TOpenAPIOperation;
    function AddServer(const AKeyName: string): TOpenAPIServer;
    function AddParameter(const AName, ALocation: string): TOpenAPIParameter;
  public
    /// <summary>
    /// An optional, string summary, intended to apply to all operations in this path.
    /// </summary>
    property Summary: NullString read FSummary write FSummary;

    /// <summary>
    /// An optional, string description, intended to apply to all operations in this path.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// Get Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Get: TOpenAPIOperation read FGet write FGet;

    /// <summary>
    /// Put Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Put: TOpenAPIOperation read FPut write FPut;

    /// <summary>
    /// Post Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Post: TOpenAPIOperation read FPost write FPost;

    /// <summary>
    /// Delete Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Delete: TOpenAPIOperation read FDelete write FDelete;

    /// <summary>
    /// Options Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Options: TOpenAPIOperation read FOptions write FOptions;

    /// <summary>
    /// Head Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Head: TOpenAPIOperation read FHead write FHead;

    /// <summary>
    /// Patch Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Patch: TOpenAPIOperation read FPatch write FPatch;

    /// <summary>
    /// Trace Operation
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Trace: TOpenAPIOperation read FTrace write FTrace;

    /// <summary>
    /// An alternative server array to service all operations in this path.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Servers: TOpenAPIServerMap read FServers write FServers;

    /// <summary>
    /// A list of parameters that are applicable for all the operations described under this path.
    /// These parameters can be overridden at the operation level, but cannot be removed there.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Parameters: TOpenAPIParameters read FParameters write FParameters;
  end;

  TOpenAPIPathMap = class(TOpenAPIModelExtensibleMap<TOpenAPIPathItem>);

  TOpenAPIVersion = (v303, v310);
  TOpenAPIVersionHelper = record helper for TOpenAPIVersion
  public
    function ToString: string;
  end;

  /// <summary>
  ///   A document (or set of documents) that defines or describes an API. An Openapi
  ///   definition uses and conforms to the Openapi Specification
  /// </summary>
  TOpenAPIDocument = class(TOpenAPIExtensible)
  private
    FInfo: TOpenAPIInfo;
    FOpenapi: string;
    FPaths: TOpenAPIPathMap;
    FServers: TOpenAPIServers;
    FComponents: TOpenAPIComponents;
    FSecurity: TOpenAPISecurityRequirements;
    FTags: TOpenAPITags;
    FExternalDocs: TOpenAPIExternalDocs;
  public
    constructor Create(AVersion: TOpenAPIVersion);
  public
    function AddServer(const AURL, ADescription: string): TOpenAPIServer;
    function AddPath(const AKeyName: string): TOpenAPIPathItem;
    function AddTag(const AName, ADescription: string): TOpenAPITag;
    procedure AddSecurity(ASchemeName: string; AParams: TArray<string>);
    procedure ReplaceInfo(AInfo: TOpenAPIInfo);
  public
    /// <summary>
    ///   REQUIRED. This string MUST be the semantic version number of the Openapi
    ///   Specification version that the Openapi document uses
    /// </summary>
    property Openapi: string read FOpenapi write FOpenapi;

    /// <summary>
    /// REQUIRED. Provides metadata about the API. The metadata MAY be used by tooling as required.
    /// </summary>
    property Info: TOpenAPIInfo read FInfo write FInfo;

    /// <summary>
    /// An array of Server Objects, which provide connectivity information to a target server.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Servers: TOpenAPIServers read FServers write FServers;

    /// <summary>
    /// REQUIRED. The available paths and operations for the API.
    /// </summary>
    property Paths: TOpenAPIPathMap read FPaths write FPaths;

    /// <summary>
    /// An element to hold various schemas for the specification.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Components: TOpenAPIComponents read FComponents write FComponents;

    /// <summary>
    /// A declaration of which security mechanisms can be used across the API.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Security: TOpenAPISecurityRequirements read FSecurity write FSecurity;

    /// <summary>
    /// A list of tags used by the specification with additional metadata.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property Tags: TOpenAPITags read FTags write FTags;

    /// <summary>
    /// Additional external documentation.
    /// </summary>
    [NeonInclude(IncludeIf.NotEmpty)]
    property ExternalDocs: TOpenAPIExternalDocs read FExternalDocs write FExternalDocs;
  end;


implementation

{ TOpenAPIServer }

constructor TOpenAPIServer.Create;
begin
  inherited Create;

  FVariables := CreateSubObject<TOpenAPIServerVariableMap>;
end;

constructor TOpenAPIServer.Create(const AURL, ADescription: string);
begin
  Create;

  FUrl := AURL;
  if not ADescription.IsEmpty then
    FDescription := ADescription;
end;

{ TOpenAPIResponse }

function TOpenAPIResponse.AddLink(const AKeyName: string): TOpenAPILink;
begin
  if not FLinks.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPILink.Create;
    FLinks.Add(AKeyName, Result);
  end;
end;

function TOpenAPIResponse.AddMediaType(const AKeyName: string): TOpenAPIMediaType;
begin
  if not FContent.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIMediaType.Create;
    FContent.Add(AKeyName, Result);
  end;
end;

constructor TOpenAPIResponse.Create;
begin
  inherited Create;

  FHeaders := CreateSubObject<TOpenAPIHeaderMap>;
  FContent := CreateSubObject<TOpenAPIMediaTypeMap>;
  FLinks := CreateSubObject<TOpenAPILinkMap>;
end;

function TOpenAPIResponse.AddHeader(const AKeyName: string): TOpenAPIHeader;
begin
  if not FHeaders.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIHeader.Create;
    FHeaders.Add(AKeyName, Result);
  end;
end;

{ TOpenAPIComponents }

function TOpenAPIComponents.AddParameter(const AKeyName, AName, ALocation: string): TOpenAPIparameter;
begin
  if not FParameters.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIParameter.Create;
    FParameters.Add(AKeyName, Result);
  end;
  Result.Name := AName;
  Result.In_ := ALocation;
end;

function TOpenAPIComponents.AddResponse(const AKeyName, ADescription: string): TOpenAPIResponse;
begin
  if not FResponses.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIResponse.Create;
    FResponses.Add(AKeyName, Result);
  end;
  Result.Description := ADescription;
end;

function TOpenAPIComponents.AddSchema(const AKeyName: string): TOpenAPISchema;
begin
  if not FSchemas.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenApiSchema.Create;
    FSchemas.Add(AKeyName, Result);
  end;
end;

function TOpenAPIComponents.AddSecurityApiKey(const AKeyName, ADescription,
  AHeaderName: string; ALocation: TAPIKeyLocation): TOpenAPISecurityScheme;
begin
  Result := AddSecurityScheme(AKeyName, ADescription, TSecurityScheme.ApiKey);
  Result.In_ := ALocation;
  Result.Name := AHeaderName;
end;

function TOpenAPIComponents.AddSecurityHttp(const AKeyName, ADescription,
  AScheme, ABearerFormat: string): TOpenAPISecurityScheme;
begin
  Result := AddSecurityScheme(AKeyName, ADescription, TSecurityScheme.Http);
  Result.Scheme := AScheme;
  Result.BearerFormat := ABearerFormat;
end;

function TOpenAPIComponents.AddSecurityOAuth2(const AKeyName,
  ADescription: string; AFlow: TOpenAPIOAuthFlows): TOpenAPISecurityScheme;
begin
  Result := AddSecurityScheme(AKeyName, ADescription, TSecurityScheme.OAuth2);
  Result.Flows := AFlow;
end;

function TOpenAPIComponents.AddSecurityOpenID(const AKeyName, ADescription,
  AURL: string): TOpenAPISecurityScheme;
begin
  Result := AddSecurityScheme(AKeyName, ADescription, TSecurityScheme.OpenIdConnect);
  Result.OpenIdConnectUrl := AURL;
end;

function TOpenAPIComponents.AddSecurityScheme(const AName, ADescription: string;
  AType: TSecurityScheme): TOpenAPISecurityScheme;
begin
  if not FSecuritySchemes.TryGetValue(AName, Result) then
  begin
    Result := TOpenAPISecurityScheme.Create;
    FSecuritySchemes.Add(AName, Result);
  end;
  Result.Type_ := AType;
  Result.Description := ADescription;
end;

constructor TOpenAPIComponents.Create;
begin
  inherited Create;

  FSchemas := CreateSubObject<TOpenAPISchemaMap>;
  FResponses := CreateSubObject<TOpenAPIResponseMap>;
  FParameters := CreateSubObject<TOpenAPIParameterMap>;
  FExamples := CreateSubObject<TOpenAPIExampleMap>;
  FRequestBodies := CreateSubObject<TOpenAPIRequestBodyMap>;
  FHeaders := CreateSubObject<TOpenAPIHeaderMap>;
  FSecuritySchemes := CreateSubObject<TOpenAPISecuritySchemeMap>;
  FLinks := CreateSubObject<TOpenAPILinkMap>;
  FCallbacks := CreateSubObject<TOpenAPICallbackMap>;
end;

function TOpenAPIComponents.SchemaExists(const AKeyName: string): Boolean;
var
  LSchema: TOpenAPISchema;
begin
  Result := FSchemas.TryGetValue(AKeyName, LSchema);
end;

{ TOpenAPILink }

constructor TOpenAPILink.Create;
begin
  inherited Create;

  //FRequestBody := CreateSubObject<TRuntimeExpression>;
  FParameters := CreateSubObject<TRuntimeExpressionMap>;
  FServer := CreateSubObject<TOpenAPIServer>;
end;

{ TOpenAPIDocument }

function TOpenAPIDocument.AddPath(const AKeyName: string): TOpenAPIPathItem;
begin
  if not AKeyName.StartsWith('/') then
    raise EOpenAPIException.Create('A path MUST begin with a forward slash "/"');

  if not FPaths.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIPathItem.Create;
    FPaths.Add(AKeyName, Result);
  end;
end;

procedure TOpenAPIDocument.AddSecurity(ASchemeName: string; AParams: TArray<string>);
var
  LScheme: TOpenAPISecurityScheme;
  LSecReq: TOpenAPISecurityRequirement;
begin
  if FComponents.SecuritySchemes.TryGetValue(ASchemeName, LScheme) then
  begin
    LSecReq := TOpenAPISecurityRequirement.Create();
    LSecreq.Add(ASchemeName, AParams);
    FSecurity.Add(LSecReq);
  end
  else
    raise EOpenAPIException.CreateFmt('The scheme [%s] does not exists in securityDefinitions', [ASchemeName]);
end;

function TOpenAPIDocument.AddServer(const AURL, ADescription: string): TOpenAPIServer;
begin
  Result := TOpenAPIServer.Create;
  Result.Url := AURL;
  if not ADescription.IsEmpty then
    Result.Description := ADescription;
  FServers.Add(Result);
end;

function TOpenAPIDocument.AddTag(const AName, ADescription: string): TOpenAPITag;
begin
  Result := TOpenAPITag.Create;
  Result.Name := AName;
  Result.Description := ADescription;

  FTags.Add(Result);
end;

constructor TOpenAPIDocument.Create(AVersion: TOpenAPIVersion);
begin
  inherited Create;

  FOpenapi := AVersion.ToString;

  FInfo := CreateSubObject<TOpenAPIInfo>;
  FPaths := CreateSubObject<TOpenAPIPathMap>;
  FServers := CreateSubObject<TOpenAPIServers>;
  FComponents := CreateSubObject<TOpenAPIComponents>;
  FSecurity := CreateSubObject<TOpenAPISecurityRequirements>;
  FTags := CreateSubObject<TOpenAPITags>;
  //FExternalDocs := CreateSubObject<TOpenAPIExternalDocs>;
end;

procedure TOpenAPIDocument.ReplaceInfo(AInfo: TOpenAPIInfo);
begin
  if Assigned(FInfo) then
    FInfo.Free;
  FInfo := AInfo;
end;

{ TOpenAPIInfo }

constructor TOpenAPIInfo.Create;
begin
  inherited Create;

  FContact := CreateSubObject<TOpenAPIContact>;
  FLicense := CreateSubObject<TOpenAPILicense>;
end;

{ TOpenAPIPathItem }

function TOpenAPIPathItem.AddOperation(const AType: TOperationType): TOpenAPIOperation;

  function GetOrCreate(var ASource: TOpenAPIOperation): TOpenAPIOperation;
  begin
    if not Assigned(ASource) then
      ASource := CreateSubObject<TOpenAPIOperation>;
    Result := ASource;
  end;
begin
  case AType of
    TOperationType.Get:       Result := GetOrCreate(FGet);
    TOperationType.Put:       Result := GetOrCreate(FPut);
    TOperationType.Post:      Result := GetOrCreate(FPost);
    TOperationType.Delete:    Result := GetOrCreate(FDelete);
    TOperationType.Options:   Result := GetOrCreate(FOptions);
    TOperationType.Head:      Result := GetOrCreate(FHead);
    TOperationType.Patch:     Result := GetOrCreate(FPatch);
    TOperationType.Trace:     Result := GetOrCreate(FTrace);
  else
    raise EOpenAPIException.CreateFmt('Operation Type [%s] not supported', [AType.ToString]);
  end;
end;

function TOpenAPIPathItem.AddParameter(const AName, ALocation: string): TOpenAPIParameter;
begin
  Result := FParameters.FindParam(AName, ALocation);

  if not Assigned(Result) then
  begin
    Result := TOpenAPIParameter.Create(AName, ALocation);
    FParameters.Add(Result);
  end;
end;

function TOpenAPIPathItem.AddServer(const AKeyName: string): TOpenAPIServer;
begin
  if not FServers.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIServer.Create;
    FServers.Add(AKeyName, Result);
  end;
end;

constructor TOpenAPIPathItem.Create;
begin
  inherited Create;

  FServers := CreateSubObject<TOpenAPIServerMap>;
  FParameters := CreateSubObject<TOpenAPIParameters>;
end;

{ TOpenAPIOperation }

function TOpenAPIOperation.AddParameter(const AName, ALocation: string): TOpenAPIParameter;
begin
  Result := FParameters.FindParam(AName, ALocation);

  if not Assigned(Result) then
  begin
    Result := TOpenAPIParameter.Create(AName, ALocation);
    FParameters.Add(Result);
  end;
end;

function TOpenAPIOperation.SetRequestBody(const ADescription: string): TOpenAPIRequestBody;
begin
  if not Assigned(FRequestBody) then
    FRequestBody := TOpenAPIRequestBody.Create;

  FRequestBody.Description := ADescription;
  FRequestBody.Required := True;

  Result := FRequestBody;
end;

function TOpenAPIOperation.AddResponse(const AName: string): TOpenAPIResponse;
begin
  if not FResponses.TryGetValue(AName, Result) then
  begin
    Result := TOpenAPIResponse.Create;
    FResponses.Add(AName, Result);
  end;
end;

function TOpenAPIOperation.AddResponse(ACode: Integer): TOpenAPIResponse;
begin
  Result := AddResponse(ACode.ToString);
end;

procedure TOpenAPIOperation.AddTag(const AName: string);
begin
  FTags := FTags + [AName];
end;

constructor TOpenAPIOperation.Create;
begin
  inherited Create;

  //FExternalDocs: CreateSubObject<TOpenAPIExternalDocumentation>;
  FParameters := CreateSubObject<TOpenAPIParameters>;
  //FRequestBody := CreateSubObject<TOpenAPIRequestBody>;
  FCallbacks := CreateSubObject<TOpenAPICallbackMap>;
  FSecurity := CreateSubObject<TOpenAPISecurityRequirements>;
  FServers := CreateSubObject<TOpenAPIServers>;
  FResponses := CreateSubObject<TOpenAPIResponseMap>;
end;

destructor TOpenAPIOperation.Destroy;
begin
  FRequestBody.Free;

  inherited;
end;

{ TOpenAPIRequestBody }

constructor TOpenAPIRequestBody.Create;
begin
  inherited Create;

  FContent := CreateSubObject<TOpenAPIMediaTypeMap>;
end;

function TOpenAPIRequestBody.AddMediaType(const AKeyName: string): TOpenAPIMediaType;
begin
  if not FContent.TryGetValue(AKeyName, Result) then
  begin
    Result := TOpenAPIMediaType.Create;
    FContent.Add(AKeyName, Result);
  end;
end;

{ TOpenAPITag }

constructor TOpenAPITag.Create;
begin
  inherited Create;

  //FExternalDocs: CreateSubObject<TOpenAPIExternalDocs>;
end;

{ TOpenAPIExample }

constructor TOpenAPIExample.Create;
begin
  inherited Create;

  FValue := CreateSubObject<TOpenAPIAny>;
end;

{ TOpenAPIMediaType }

constructor TOpenAPIMediaType.Create;
begin
  inherited Create;

  FSchema := CreateSubObject<TOpenAPISchema>;
  FExamples := CreateSubObject<TOpenAPIExampleMap>;
  FEncoding := CreateSubObject<TOpenAPIEncodingMap>;
  FExample := CreateSubObject<TOpenAPIAny>;
end;

{ TOpenAPIHeader }

constructor TOpenAPIHeader.Create;
begin
  inherited Create;

  FSchema := CreateSubObject<TOpenAPISchema>;
  FExamples := CreateSubObject<TOpenAPIExampleMap>;
  FContent := CreateSubObject<TOpenAPIMediaTypeMap>;
  FExample := CreateSubObject<TOpenAPIAny>;
end;

{ TOpenAPIEncoding }

constructor TOpenAPIEncoding.Create;
begin
  inherited Create;

  FHeaders := CreateSubObject<TOpenAPIHeaderMap>;
end;

{ TOpenAPIParameter }

constructor TOpenAPIParameter.Create;
begin
  inherited Create;

  FSchema := CreateSubObject<TOpenAPISchema>;
  FExamples := CreateSubObject<TOpenApiExamples>;
  FContent := CreateSubObject<TOpenApiMediaTypeMap>;
  FExample := CreateSubObject<TOpenAPIAny>;
end;

constructor TOpenAPIParameter.Create(const AName, ALocation: string);
begin
  Create;
  FName := AName;
  FIn_ := ALocation;
end;

function TOpenAPIParameter.GetHash: string;
begin
  Result := FName + '#' + FIn_;
end;

{ TOpenAPICallback }

constructor TOpenAPICallback.Create;
begin
  inherited Create;
end;

{ TOpenAPIOAuthFlow }

constructor TOpenAPIOAuthFlow.Create;
begin
  inherited Create;

  FScopes := CreateSubObject<TDictionary<string, string>>;
end;

{ TOpenAPIOAuthFlows }

constructor TOpenAPIOAuthFlows.Create;
begin
  inherited Create;

  FImplicit := CreateSubObject<TOpenAPIOAuthFlow>;
  FPassword := CreateSubObject<TOpenAPIOAuthFlow>;
  FClientCredentials := CreateSubObject<TOpenAPIOAuthFlow>;
  FAuthorizationCode := CreateSubObject<TOpenAPIOAuthFlow>;
end;

{ TOpenAPISecurityScheme }

constructor TOpenAPISecurityScheme.Create;
begin
  inherited Create;

  FFlows := CreateSubObject<TOpenAPIOAuthFlows>;
end;

function TOpenAPISecurityScheme.ShouldInclude(const AContext: TNeonIgnoreIfContext): Boolean;
begin
  Result := False;

  if SameText(AContext.MemberName, 'Name') then
  begin
    if (Type_ = TSecurityScheme.ApiKey) and (not Name.IsEmpty) then
      Result := True;
  end
  else if SameText(AContext.MemberName, 'In_') then
  begin
    if (Type_ = TSecurityScheme.ApiKey) then
      Result := True;
  end
  else if SameText(AContext.MemberName, 'Scheme') then
  begin
    if (Type_ = TSecurityScheme.Http) then
      Result := True;
  end
  else if SameText(AContext.MemberName, 'BearerFormat') then
  begin
    if (Type_ = TSecurityScheme.Http) and (BearerFormat <> '') then
      Result := True;
  end
  else if SameText(AContext.MemberName, 'Flows') then
  begin
    if (Type_ = TSecurityScheme.OAuth2) then
      Result := True;
  end
  else if SameText(AContext.MemberName, 'OpenIdConnectUrl') then
  begin
    if (Type_ = TSecurityScheme.OpenIdConnect) then
      Result := True;
  end
end;

{ TOperationTypeHelper }

class function TOperationTypeHelper.FromString(const AValue: string): TOperationType;
begin
  if SameText(AValue, 'get') then
    Result := TOperationType.Get
  else if SameText(AValue, 'put') then
    Result := TOperationType.Put
  else if SameText(AValue, 'post') then
    Result := TOperationType.Post
  else if SameText(AValue, 'delete') then
    Result := TOperationType.Delete
  else if SameText(AValue, 'options') then
    Result := TOperationType.Options
  else if SameText(AValue, 'head') then
    Result := TOperationType.Head
  else if SameText(AValue, 'patch') then
    Result := TOperationType.Patch
  else if SameText(AValue, 'trace') then
    Result := TOperationType.Trace
  else
    raise EOpenAPIException.CreateFmt('Operation [%s] not allowed', [AValue]);
end;

function TOperationTypeHelper.ToString: string;
begin
  case Self of
    TOperationType.Get:      Result := 'get';
    TOperationType.Put:      Result := 'put';
    TOperationType.Post:     Result := 'post';
    TOperationType.Delete:   Result := 'delete';
    TOperationType.Options:  Result := 'options';
    TOperationType.Head:     Result := 'head';
    TOperationType.Patch:    Result := 'patch';
    TOperationType.Trace:    Result := 'trace';
  end;
end;

procedure TOpenAPISecurityRequirements.AddSecurityRequirement(
    ASecuritySchemes: TOpenAPISecuritySchemeMap; ASchemeName: string; AParams:
    TArray<string>);
var
  LScheme: TOpenAPISecurityScheme;
  LSecReq: TOpenAPISecurityRequirement;
begin
  if ASecuritySchemes.TryGetValue(ASchemeName, LScheme) then
  begin
    LSecReq := TOpenAPISecurityRequirement.Create();
    LSecreq.Add(ASchemeName, AParams);
    Self.Add(LSecReq);
  end
  else
    raise EOpenAPIException.CreateFmt('The scheme [%s] does not exists in securityDefinitions', [ASchemeName]);
end;

{ TOpenAPIParameters }

function TOpenAPIParameters.ParamExists(AParam: TOpenAPIParameter): Boolean;
var
  LParam: TOpenAPIParameter;
begin
  Result := False;
  for LParam in Self do
    if LParam.GetHash = AParam.GetHash then
      Exit(True);
end;

function TOpenAPIParameters.FindParam(const AName, ALocation: string): TOpenAPIParameter;
var
  LParam: TOpenAPIParameter;
begin
  Result := nil;
  for LParam in Self do
    if (LParam.Name = AName) and (LParam.In_ = ALocation) then
      Exit(LParam);
end;

function TOpenAPIParameters.ParamExists(const AName, ALocation: string): Boolean;
var
  LParam: TOpenAPIParameter;
begin
  Result := False;
  for LParam in Self do
    if (LParam.Name = AName) and (LParam.In_ = ALocation) then
      Exit(True);
end;

{ TOpenAPIVersionHelper }

function TOpenAPIVersionHelper.ToString: string;
begin
  Result := '';
  case Self of
    TOpenAPIVersion.v303: Result := '3.0.3';
    TOpenAPIVersion.v310: Result := '3.1.0';
  end;
end;

end.
