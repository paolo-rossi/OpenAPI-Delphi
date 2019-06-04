{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3.0 Generator                                                }
{  Copyright (c) 2018-2019 Paolo Rossi                                         }
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
unit OpenAPI.Models;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,

  Neon.Core.Attributes,
  OpenAPI.Interfaces,
  OpenAPI.Nullables,
  OpenAPI.Schema,
  OpenAPI.Expressions,
  OpenAPI.Reference,
  OpenAPI.Serializer;

type
  /// <summary>
  /// Base class for OpenAPI model classes
  /// </summary>
  TOpenAPIModel = class
  protected
    function InternalCheckModel: Boolean; virtual;
  public
    function CheckModel: Boolean; inline;
  end;

{$REGION 'ENUM TYPES'}  
  [NeonEnumNames('matrix, label, form, simple, spaceDelimited, pipeDelimited, deepObject')]
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

  [NeonEnumNames('apiKey, http, oauth2, openIdConnect')]
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

  [NeonEnumNames('query, header, path, cookie')]
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

  [NeonEnumNames('get, put, post, delete, options, head, patch, trace')]
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
{$ENDREGION}
  
  /// <summary>
  ///   Contact information for the exposed API
  /// </summary>
  TOpenAPIContact = class(TOpenAPIModel)
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
  TOpenAPILicense = class(TOpenAPIModel)
  private
    FName: string;
    FUrl: NullString;
  public
    /// <summary>
    /// REQUIRED. The license name used for the API.
    /// </summary>
    property Name: string read FName write FName;

    /// <summary>
    /// The Url pointing to the contact information. MUST be in the format of a Url.
    /// </summary>
    property Url: NullString read FUrl write FUrl;
  end;

  /// <summary>
  /// ExternalDocs object
  /// </summary>
  TOpenAPIExternalDocumentation = class
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

  /// <summary>
  /// Parameter Object
  /// </summary>
  TOpenAPIParameter = class(TOpenAPIModel)
  private
    FAllowEmptyValue: NullBoolean;
    FDeprecated_: NullBoolean;
    FDescription: NullString;
    FIn_: string;
    FName: string;
    FRequired: NullBoolean;
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
  end;

  TOpenAPIParameters = class(TObjectList<TOpenAPIParameter>)
  end;

  TOpenAPIParameterMap = class(TObjectDictionary<string, TOpenAPIParameter>)
  public
    constructor Create;
  end;

  /// <summary>
  /// Example Object.
  /// </summary>
  TOpenAPIExample = class(TOpenAPIModel)
  private
    FSummary: NullString;
    FDescription: NullString;
    FExternalValue: NullString;
    FReference: TOpenAPIReference;
    FUnresolvedReference: NullBoolean;
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
    //property Value: IAny IOpenApiAny Value { get; set; }

    /// <summary>
    /// A Url that points to the literal example.
    /// This provides the capability to reference examples that cannot easily be
    /// included in JSON or YAML documents.
    /// The value field and externalValue field are mutually exclusive.
    /// </summary>
    property ExternalValue: NullString read FExternalValue write FExternalValue;

    /// <summary>
    /// Reference object.
    /// </summary>
    property Reference: TOpenAPIReference read FReference write FReference;

    /// <summary>
    /// Indicates object is a placeholder reference to an actual object and does not contain valid data.
    /// </summary>
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;
  end;

  TOpenAPIExamples = class(TObjectList<TOpenAPIExample>)
  end;
  
  TOpenAPIExampleMap = class(TObjectDictionary<string, TOpenAPIExample>)
  end;

  TOpenAPIEncoding = class;
  TOpenAPIEncodingMap = class;
  
  /// <summary>
  /// MediaType Object.
  /// </summary>
  TOpenAPIMediaType = class(TOpenAPIModel)
  private
    FSchema: TOpenAPISchema;
    FExamples: TOpenAPIExampleMap;
    FEncoding: TOpenAPIEncodingMap;
  public
    /// <summary>
    /// The schema defining the type used for the request body.
    /// </summary>
    property Schema: TOpenAPISchema read FSchema write FSchema;

    /// <summary>
    /// Example of the media type.
    /// The example object SHOULD be in the correct format as specified by the media type.
    /// </summary>
    //property Example: IOpenApiAny ;

    /// <summary>
    /// Examples of the media type.
    /// Each example object SHOULD match the media type and specified schema if present.
    /// </summary>
    property Examples: TOpenAPIExampleMap read FExamples write FExamples;

    /// <summary>
    /// A map between a property name and its encoding information.
    /// The key, being the property name, MUST exist in the schema as a property.
    /// The encoding object SHALL only apply to requestBody objects
    /// when the media type is multipart or application/x-www-form-Urlencoded.
    /// </summary>
    property Encoding: TOpenAPIEncodingMap read FEncoding write FEncoding;

    /// <summary>
    /// Serialize <see cref="OpenApiExternalDocs"/> to Open Api v3.0.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;
  end;

   
  TOpenAPIMediaTypes = class(TObjectList<TOpenAPIMediaType>)
  end;
  
  TOpenAPIMediaTypeMap = class(TObjectDictionary<string, TOpenAPIMediaType>)
  public
    constructor Create;
  end;

  /// <summary>
  /// Header Object.
  /// </summary>
  TOpenAPIHeader = class(TOpenAPIModel)
  private
    FUnresolvedReference: NullBoolean;
    FReference: TOpenAPIReference;
    FDescription: NullString;
    FRequired: NullBoolean;
    FDeprecated_: NullBoolean;
    FAllowEmptyValue: NullBoolean;
    FStyle: TParameterStyle;
    FExplode: NullBoolean;
    FAllowReserved: NullBoolean;
    FSchema: TOpenAPISchema;
    //FExample: TOpenAPIAny;
    FExamples: TOpenAPIExampleMap;
    FContent: TOpenAPIMediaTypeMap;
  public
    /// <summary>
    /// Indicates if object is populated with data or is just a reference to the data
    /// </summary>
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;

    /// <summary>
    /// Reference pointer.
    /// </summary>
    property Reference: TOpenAPIReference read FReference write FReference;

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
    property Style: TParameterStyle read FStyle write FStyle;

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
    [NeonInclude(Include.NotEmpty)]
    property Schema: TOpenAPISchema read FSchema write FSchema;

    /// <summary>
    /// Example of the media type.
    /// </summary>
    //property Example: TOpenAPIAny read FExample write FExample;

    /// <summary>
    /// Examples of the media type.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Examples: TOpenAPIExampleMap read FExamples write FExamples;

    /// <summary>
    /// A map containing the representations for the header.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Content: TOpenAPIMediaTypeMap read FContent write FContent;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //Extensions: TObjectDictionary<string, TOpenAPIExtension>;
  end;

  TOpenAPIHeaders = class(TObjectList<TOpenAPIHeader>)
  end;
  
  TOpenAPIHeaderMap = class(TObjectDictionary<string, TOpenAPIHeader>)
  public
    constructor Create;
  end;
  
  TOpenAPIEncoding = class(TOpenAPIModel)
  private
    FContentType: NullString;
    FHeaders: TOpenAPIHeaderMap;
    FStyle: TParameterStyle;
    FExplode: NullBoolean;
    FAllowReserved: NullBoolean;
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
    property Headers: TOpenAPIHeaderMap read FHeaders write FHeaders;

    /// <summary>
    /// Describes how a specific property value will be serialized depending on its type.
    /// </summary>
    property Style: TParameterStyle read FStyle write FStyle;

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

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;  
  end;
  
  TOpenAPIEncodings = class(TObjectList<TOpenAPIEncoding>)
  end;
  
  TOpenAPIEncodingMap = class(TObjectDictionary<string, TOpenAPIEncoding>)
  end;
  
  TOpenAPIExternalDocs = class(TOpenAPIModel)
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

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //Extensions: TObjectDictionary<string, TOpenAPIExtension>;
  end;

  TOpenAPITag = class(TOpenAPIModel)
  private
    FName: NullString;
    FDescription: NullString;
    FExternalDocs: TOpenAPIExternalDocs;
    FUnresolvedReference: NullBoolean;
    FReference: TOpenAPIReference;
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
    property ExternalDocs: TOpenAPIExternalDocs read FExternalDocs write FExternalDocs;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //Extensions: TObjectDictionary<string, TOpenAPIExtension>;

    /// <summary>
    /// Indicates if object is populated with data or is just a reference to the data
    /// </summary>
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;

    /// <summary>
    /// Reference.
    /// </summary>
    property Reference: TOpenAPIReference read FReference write FReference;
  end;

  TOpenAPITags = class(TObjectList<TOpenAPITag>)
  public
    constructor Create;
  end;

  TOpenAPIRequestBody = class(TOpenAPIModel)
  private
    FUnresolvedReference: NullBoolean;
    FReference: TOpenAPIReference;
    FDescription: NullString;
    FRequired: NullBoolean;
    FContent: TOpenAPIMediaTypeMap;
  public
    constructor Create;
    destructor Destroy; override;
  public
    /// <summary>
    /// Indicates if object is populated with data or is just a reference to the data
    /// </summary>
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;

    /// <summary>
    /// Reference object.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Reference: TOpenAPIReference read FReference write FReference;

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

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, TOpenAPIExtension>;
  end;

  /// <summary>
  ///   An object representing a Server Variable for server Url template substitution
  /// </summary>
  TOpenAPIServerVariable = class
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
    [NeonInclude(Include.NotEmpty)]
    property Enum: TArray<string> read FEnum write FEnum;
  end;

  TOpenAPIServerVariableMap = class(TObjectDictionary<string, TOpenAPIServerVariable>)
  end;

  /// <summary>
  ///   An object representing a Server
  /// </summary>
  TOpenAPIServer = class
  private
    FDescription: NullString;
    FVariables: TOpenAPIServerVariableMap;
    FUrl: string;
  public
    constructor Create; overload;
    constructor Create(const AURL, ADescription: string); overload;
    destructor Destroy; override;
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
    [NeonInclude(Include.NotEmpty)]
    property Variables: TOpenAPIServerVariableMap read FVariables write FVariables;
  end;

  TOpenAPIServers = class(TObjectList<TOpenAPIServer>)
  public
    constructor Create;
  end;

  TOpenAPIServerMap = class(TObjectDictionary<string, TOpenAPIServer>)
  public
    constructor Create;
  end;

  /// <summary>
  /// Link Object.
  /// </summary>
  TOpenAPILink = class(TOpenAPIModel)
  private
    FOperationId: NullString;
    FOperationRef: NullString;
    FRequestBody: TRuntimeExpression;
    FParameters: TRuntimeExpressionMap;
    FDescription: NullString;
    FServer: TOpenAPIServer;
  public
    constructor Create;
    destructor Destroy; override;
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
    [NeonInclude(Include.NotEmpty)]
    property Parameters: TRuntimeExpressionMap read FParameters write FParameters;

    /// <summary>
    /// A literal value or {expression} to use as a request body when calling the target operation.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
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

  TOpenAPILinks = class(TObjectList<TOpenAPILink>)
  end;

  TOpenAPILinkMap = class(TObjectDictionary<string, TOpenAPILink>)
  public
    constructor Create;
  end;

  /// <summary>
  /// Response object.
  /// </summary>
  TOpenAPIResponse = class(TOpenAPIModel)
  private
    FDescription: string;
    FLinks: TOpenAPILinkMap;
    FContent: TOpenAPIMediaTypeMap;
    FHeaders: TOpenAPIHeaderMap;
  public
    constructor Create;
    destructor Destroy; override;
  public
    /// <summary>
    /// REQUIRED. A short description of the response.
    /// </summary>
    property Description: string read FDescription write FDescription;

    /// <summary>
    /// Maps a header name to its definition.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Headers: TOpenAPIHeaderMap read FHeaders write FHeaders;

    /// <summary>
    /// A map containing descriptions of potential response payloads.
    /// The key is a media type or media type range and the value describes it.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Content: TOpenAPIMediaTypeMap read FContent write FContent;

    /// <summary>
    /// A map of operations links that can be followed from the response.
    /// The key of the map is a short name for the link,
    /// following the naming constraints of the names for Component Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Links: TOpenAPILinkMap read FLinks write FLinks;
  end;

  TOpenAPIResponseMap = class(TObjectDictionary<string, TOpenAPIResponse>)
  public
    constructor Create;
  end;

  TOpenAPIPathItem = class;

  TOpenAPICallback = class(TOpenAPIModel)
  private
    FPathItems: TObjectDictionary<TRuntimeExpression, TOpenAPIPathItem>;
    FUnresolvedReference: NullBoolean;
    FReference: TOpenAPIReference;
  public
    /// <summary>
    /// A Path Item Object used to define a callback request and expected responses.
    /// </summary>
    property PathItems: TObjectDictionary<TRuntimeExpression, TOpenAPIPathItem> read FPathItems write FPathItems;

    /// <summary>
    /// Indicates if object is populated with data or is just a reference to the data
    /// </summary>
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;

    /// <summary>
    /// Reference pointer.
    /// </summary>
    property Reference: TOpenAPIReference read FReference write FReference;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;
  end;

  TOpenAPICallbacks = class(TObjectList<TOpenAPICallback>)
  public
    constructor Create;
  end;

  TOpenAPICallbackMap = class(TObjectDictionary<string, TOpenAPICallback>)
  public
    constructor Create;
  end;

  TOpenAPIOAuthFlow = class(TOpenAPIModel)
  private
    FAuthorizationUrl: string;
    FTokenUrl: string;
    FRefreshUrl: NullString;
    FScopes: TDictionary<string, string>;
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
    property Scopes: TDictionary<string, string> read FScopes write FScopes;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;
  end;

  TOpenAPIOAuthFlows = class(TOpenAPIModel)
  private
    FImplicit: TOpenAPIOAuthFlow;
    FPassword: TOpenAPIOAuthFlow;
    FClientCredentials: TOpenAPIOAuthFlow;
    FAuthorizationCode: TOpenAPIOAuthFlow;
  public
    /// <summary>
    /// Configuration for the OAuth Implicit flow
    /// </summary>
    property Implicit: TOpenAPIOAuthFlow read FImplicit write FImplicit;

    /// <summary>
    /// Configuration for the OAuth Resource Owner Password flow.
    /// </summary>
    property Password: TOpenAPIOAuthFlow read FPassword write FPassword;

    /// <summary>
    /// Configuration for the OAuth Client Credentials flow.
    /// </summary>
    property ClientCredentials: TOpenAPIOAuthFlow read FClientCredentials write FClientCredentials;

    /// <summary>
    /// Configuration for the OAuth Authorization Code flow.
    /// </summary>
    property AuthorizationCode: TOpenAPIOAuthFlow read FAuthorizationCode write FAuthorizationCode;

    /// <summary>
    /// Specification Extensions.
    /// </summary>
  end;

  TOpenAPISecurityScheme = class(TOpenAPIModel)
  private
    FType_: TSecurityScheme;
    FDescription: NullString;
    FName: string;
    FIn_: TParameterLocation;
    FScheme: string;
    FBearerFormat: NullString;
    FFlows: TOpenAPIOAuthFlows;
    FOpenIdConnectUrl: string;
    FUnresolvedReference: NullBoolean;
    FReference: TOpenAPIReference;
  public
    /// <summary>
    /// REQUIRED. The type of the security scheme. Valid values are "apiKey", "http", "oauth2", "openIdConnect".
    /// </summary>
    [NeonProperty('type')]
    property Type_: TSecurityScheme read FType_ write FType_;

    /// <summary>
    /// A short description for security scheme. CommonMark syntax MAY be used for rich text representation.
    /// </summary>
    property Description: NullString read FDescription write FDescription;

    /// <summary>
    /// REQUIRED. The name of the header, query or cookie parameter to be used.
    /// </summary>
    property Name: string read FName write FName;

    /// <summary>
    /// REQUIRED. The location of the API key. Valid values are "query", "header" or "cookie".
    /// </summary>
    [NeonProperty('in')]
    property In_: TParameterLocation read FIn_ write FIn_;

    /// <summary>
    /// REQUIRED. The name of the HTTP Authorization scheme to be used
    /// in the Authorization header as defined in RFC7235.
    /// </summary>
    property Scheme: string read FScheme write FScheme;

    /// <summary>
    /// A hint to the client to identify how the bearer token is formatted.
    /// Bearer tokens are usually generated by an authorization server,
    /// so this information is primarily for documentation purposes.
    /// </summary>
    property BearerFormat: NullString read FBearerFormat write FBearerFormat;

    /// <summary>
    /// REQUIRED. An object containing configuration information for the flow types supported.
    /// </summary>
    property Flows: TOpenAPIOAuthFlows read FFlows write FFlows;

    /// <summary>
    /// REQUIRED. OpenId Connect Url to discover OAuth2 configuration values.
    /// </summary>
    property OpenIdConnectUrl: string read FOpenIdConnectUrl write FOpenIdConnectUrl;

    /// <summary>
    /// Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, TOpenAPIExtension>;

    /// <summary>
    /// Indicates if object is populated with data or is just a reference to the data
    /// </summary>
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;

    /// <summary>
    /// Reference object.
    /// </summary>
    property Reference: TOpenAPIReference read FReference write FReference;

  end;

  TOpenAPISecurityRequirement = class(TObjectDictionary<TOpenAPISecurityScheme, TList<string>>)

  end;

  TOpenAPISecurityRequirements = class(TObjectList<TOpenAPISecurityRequirement>)
  public
    constructor Create;
  end;

  /// <summary>
  ///   Operation Object
  /// </summary>
  TOpenAPIOperation = class(TOpenAPIModel)
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
    /// <summary>
    /// A list of tags for API documentation control.
    /// Tags can be used for logical grouping of operations by resources or any other qualifier.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
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
    [NeonInclude(Include.NotEmpty)]
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
    [NeonInclude(Include.NotEmpty)]
    property Parameters: TOpenAPIParameters read FParameters write FParameters;

    /// <summary>
    /// The request body applicable for this operation.
    /// The requestBody is only supported in HTTP methods where the HTTP 1.1 specification RFC7231
    /// has explicitly defined semantics for request bodies.
    /// In other cases where the HTTP spec is vague, requestBody SHALL be ignored by consumers.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property RequestBody: TOpenAPIRequestBody read FRequestBody write FRequestBody;

    /// <summary>
    /// REQUIRED. The list of possible responses as they are returned from executing this operation.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Responses: TOpenAPIResponseMap read FResponses write FResponses;

    /// <summary>
    /// A map of possible out-of band callbacks related to the parent operation.
    /// The key is a unique identifier for the Callback Object.
    /// Each value in the map is a Callback Object that describes a request
    /// that may be initiated by the API provider and the expected responses.
    /// The key value used to identify the callback object is an expression, evaluated at runtime,
    /// that identifies a Url to use for the callback operation.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
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
    [NeonInclude(Include.NotEmpty)]
    property Security: TOpenAPISecurityRequirements read FSecurity write FSecurity;

    /// <summary>
    /// An alternative server array to service this operation.
    /// If an alternative server object is specified at the Path Item Object or Root level,
    /// it will be overridden by this value.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Servers: TOpenAPIServers read FServers write FServers;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property TObjectDictionary<string, IOpenApiExtension> Extensions { get; set; } = new Dictionary<string, IOpenApiExtension>();
  end;

  TOpenAPIOperationMap = class (TObjectDictionary<TOperationType, TOpenAPIOperation>)
  public
    constructor Create;
  end;

  /// <summary>
  /// The object provides metadata about the API
  /// </summary>
  TOpenAPIInfo = class
  private
    FContact: TOpenAPIContact;
    FDescription: NullString;
    FLicense: TOpenAPILicense;
    FTermsOfService: NullString;
    FTitle: string;
    FVersion: string;
  public
    constructor Create;
    destructor Destroy; override;
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
    [NeonInclude(Include.NotEmpty)]
    property Contact: TOpenAPIContact read FContact write FContact;

    /// <summary>
    /// The license information for the exposed API.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property License: TOpenAPILicense read FLicense write FLicense;

    /// <summary>
    /// REQUIRED. The version of the OpenAPI document.
    /// </summary>
    property Version: string read FVersion write FVersion;
  end;

  /// <summary>
  /// Component Object.
  /// </summary>
  TOpenAPIComponents = class
  private
    FSchemas: TObjectDictionary<string, TOpenAPISchema>;
    FResponses: TObjectDictionary<string, TOpenAPIResponse>;
    FParameters: TOpenAPIParameterMap;
    FExamples: TObjectDictionary<string, TOpenAPIExample>;
    FRequestBodies: TObjectDictionary<string, TOpenAPIRequestBody>;
    FHeaders: TOpenAPIHeaderMap;
    FSecuritySchemes: TObjectDictionary<string, TOpenAPISecurityScheme>;
    FLinks: TOpenAPILinkMap;
    FCallbacks: TObjectDictionary<string, TOpenAPICallback>;
  public
    constructor Create;
    destructor Destroy; override;
  public
    /// <summary>
    /// An object to hold reusable <see cref="OpenApiSchema"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Schemas: TObjectDictionary<string, TOpenAPISchema> read FSchemas write FSchemas;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiResponse"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Responses: TObjectDictionary<string, TOpenAPIResponse> read FResponses write FResponses;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiParameter"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Parameters: TOpenAPIParameterMap read FParameters write FParameters;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiExample"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Examples: TObjectDictionary<string, TOpenAPIExample> read FExamples write FExamples;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiRequestBody"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property RequestBodies: TObjectDictionary<string, TOpenAPIRequestBody> read FRequestBodies write FRequestBodies;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiHeader"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Headers: TOpenAPIHeaderMap read FHeaders write FHeaders;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiSecurityScheme"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property SecuritySchemes: TObjectDictionary<string, TOpenAPISecurityScheme> read FSecuritySchemes write FSecuritySchemes;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiLink"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Links: TOpenAPILinkMap read FLinks write FLinks;

    /// <summary>
    /// An object to hold reusable <see cref="OpenApiCallback"/> Objects.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Callbacks: TObjectDictionary<string, TOpenAPICallback> read FCallbacks write FCallbacks;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;
  end;

  /// <summary>
  ///   An object representing a Server Variable for server Url template substitution
  /// </summary>
  TOpenAPIPathItem = class
  private
    FSummary: NullString;
    FDescription: NullString;
    FOperations: TOpenAPIOperationMap;
    FServers: TOpenAPIServerMap;
    FParameters: TOpenAPIParameterMap;
  public
    constructor Create;
    destructor Destroy; override;
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
    /// Gets the definition of operations on this path.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Operations: TOpenAPIOperationMap read FOperations write FOperations;

    /// <summary>
    /// An alternative server array to service all operations in this path.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Servers: TOpenAPIServerMap read FServers write FServers;

    /// <summary>
    /// A list of parameters that are applicable for all the operations described under this path.
    /// These parameters can be overridden at the operation level, but cannot be removed there.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Parameters: TOpenAPIParameterMap read FParameters write FParameters;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;
  end;

  TOpenAPIPathMap = class(TObjectDictionary<string, TOpenAPIPathItem>)
  public
    constructor Create;
  end;

  /// <summary>
  ///   A document (or set of documents) that defines or describes an API. An Openapi
  ///   definition uses and conforms to the Openapi Specification
  /// </summary>
  TOpenAPIDocument = class
  private
    FInfo: TOpenAPIInfo;
    FOpenapi: string;
    FPaths: TOpenAPIPathMap;
    FServers: TOpenAPIServers;
    FComponents: TOpenAPIComponents;
    FSecurityRequirements: TOpenAPISecurityRequirements;
    FTags: TObjectList<TOpenAPITag>;
    FExternalDocs: TOpenAPIExternalDocs;
  public
    constructor Create;
    destructor Destroy; override;
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
    [NeonInclude(Include.NotEmpty)]
    property Servers: TOpenAPIServers read FServers write FServers;

    /// <summary>
    /// REQUIRED. The available paths and operations for the API.
    /// </summary>
    property Paths: TOpenAPIPathMap read FPaths write FPaths;

    /// <summary>
    /// An element to hold various schemas for the specification.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Components: TOpenAPIComponents read FComponents write FComponents;

    /// <summary>
    /// A declaration of which security mechanisms can be used across the API.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property SecurityRequirements: TOpenAPISecurityRequirements read FSecurityRequirements write FSecurityRequirements;

    /// <summary>
    /// A list of tags used by the specification with additional metadata.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property Tags: TObjectList<TOpenAPITag> read FTags write FTags;

    /// <summary>
    /// Additional external documentation.
    /// </summary>
    [NeonInclude(Include.NotEmpty)]
    property ExternalDocs: TOpenAPIExternalDocs read FExternalDocs write FExternalDocs;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    //property Extensions: TObjectDictionary<string, IOpenApiExtension>;
  end;


implementation

{ TOpenAPIServer }

constructor TOpenAPIServer.Create;
begin
  FVariables := TOpenAPIServerVariableMap.Create([doOwnsValues]);
end;

constructor TOpenAPIServer.Create(const AURL, ADescription: string);
begin
  FUrl := AURL;
  if not ADescription.IsEmpty then
    FDescription := ADescription;
end;

destructor TOpenAPIServer.Destroy;
begin
  FVariables.Free;
  inherited;
end;

{ TOpenAPIResponse }

constructor TOpenAPIResponse.Create;
begin
  FHeaders := TOpenAPIHeaderMap.Create;
  FContent := TOpenAPIMediaTypeMap.Create;
  FLinks := TOpenAPILinkMap.Create;
end;

destructor TOpenAPIResponse.Destroy;
begin
  FLinks.Free;
  FContent.Free;
  FHeaders.Free;

  inherited;
end;

{ TOpenAPIComponents }

constructor TOpenAPIComponents.Create;
begin
  FSchemas := TObjectDictionary<string, TOpenAPISchema>.Create([doOwnsValues]);
  FResponses := TObjectDictionary<string, TOpenAPIResponse>.Create([doOwnsValues]);
end;

destructor TOpenAPIComponents.Destroy;
begin
  FResponses.Free;
  FSchemas.Free;

  inherited;
end;

{ TOpenAPILink }

constructor TOpenAPILink.Create;
begin
  { TODO -opaolo -c : Finire 28/03/2019 18:52:44 }
end;

destructor TOpenAPILink.Destroy;
begin
  { TODO -opaolo -c : Finire 28/03/2019 18:52:44 }

  inherited;
end;

{ TOpenAPIModel }

function TOpenAPIModel.CheckModel: Boolean;
begin
  Result := InternalCheckModel;
end;

function TOpenAPIModel.InternalCheckModel: Boolean;
begin
  Result := True;
end;

{ TOpenAPIParameterMap }

constructor TOpenAPIParameterMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIDocument }

constructor TOpenAPIDocument.Create;
begin
  FInfo := TOpenAPIInfo.Create;
  FPaths := TOpenAPIPathMap.Create;
  FServers := TOpenAPIServers.Create;
  FComponents := TOpenAPIComponents.Create;
  FSecurityRequirements := TOpenAPISecurityRequirements.Create;
  FTags := TOpenAPITags.Create;
  //FExternalDocs := TOpenAPIExternalDocs.Create;
end;

destructor TOpenAPIDocument.Destroy;
begin
  //FExternalDocs.Free;
  FTags.Free;
  FSecurityRequirements.Free;
  FComponents.Free;
  FServers.Free;
  FPaths.Free;
  FInfo.Free;

  inherited;
end;

{ TOpenAPIPathMap }

constructor TOpenAPIPathMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPISecurityRequirements }

constructor TOpenAPISecurityRequirements.Create;
begin
  inherited Create(True);
end;

{ TOpenAPITags }

constructor TOpenAPITags.Create;
begin
  inherited Create(True);
end;

{ TOpenAPIInfo }

constructor TOpenAPIInfo.Create;
begin
  FContact := TOpenAPIContact.Create;
  FLicense := TOpenAPILicense.Create;
end;

destructor TOpenAPIInfo.Destroy;
begin
  FLicense.Free;
  FContact.Free;

  inherited;
end;

{ TOpenAPIServers }

constructor TOpenAPIServers.Create;
begin
  inherited Create(True);
end;

{ TOpenAPICallbacks }

constructor TOpenAPICallbacks.Create;
begin
  inherited Create(True);
end;

{ TOpenAPICallbackMap }

constructor TOpenAPICallbackMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIResponseMap }

constructor TOpenAPIResponseMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIServerMap }

constructor TOpenAPIServerMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPILinkMap }

constructor TOpenAPILinkMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIHeaderMap }

constructor TOpenAPIHeaderMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIMediaTypeMap }

constructor TOpenAPIMediaTypeMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIPathItem }

constructor TOpenAPIPathItem.Create;
begin
  FOperations := TOpenAPIOperationMap.Create;
  FServers := TOpenAPIServerMap.Create;
  FParameters := TOpenAPIParameterMap.Create;
end;

destructor TOpenAPIPathItem.Destroy;
begin
  FParameters.Free;
  FServers.Free;
  FOperations.Free;
  inherited;
end;

{ TOpenAPIOperationMap }

constructor TOpenAPIOperationMap.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIOperation }

constructor TOpenAPIOperation.Create;
begin
  //FExternalDocs: TOpenAPIExternalDocumentation;
  FParameters := TOpenAPIParameters.Create;
  //FRequestBody := TOpenAPIRequestBody.Create;
  FCallbacks := TOpenAPICallbackMap.Create;
  FSecurity := TOpenAPISecurityRequirements.Create;
  FServers := TOpenAPIServers.Create;
  FResponses := TOpenAPIResponseMap.Create;
end;

destructor TOpenAPIOperation.Destroy;
begin
  FParameters.Free;
  FRequestBody.Free;
  FCallbacks.Free;
  FSecurity.Free;
  FServers.Free;
  FResponses.Free;
  inherited;
end;

{ TOpenAPIRequestBody }

constructor TOpenAPIRequestBody.Create;
begin
  FReference := TOpenAPIReference.Create;
  FContent := TOpenAPIMediaTypeMap.Create;
end;

destructor TOpenAPIRequestBody.Destroy;
begin
  FReference.Free;
  FContent.Free;
  inherited;
end;

end.
