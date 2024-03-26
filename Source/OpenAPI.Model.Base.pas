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
unit OpenAPI.Model.Base;

interface

uses
  System.SysUtils, System.Classes, System.Rtti, System.Generics.Collections,
  System.JSON,

  Neon.Core.Types,
  Neon.Core.Nullables,
  Neon.Core.Attributes,
  OpenAPI.Core.Exceptions,
  OpenAPI.Model.Reference;

type
  /// <summary>
  /// Base class for OpenAPI model classes
  /// </summary>
  TOpenAPIModel = class
  protected
    FSubObjects: TObjectList<TObject>;
    function InternalCheckModel: Boolean; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateSubObject<T: class, constructor>: T;
    function AddSubObject<T: class>(Value: T): T;
    function RemoveSubObject<T: class>(const Value: T): Integer;
  public
    function CheckModel: Boolean; inline;
  end;

  /// <summary>
  ///   Class for <c>OpenAPI Extensions</c>. Extensions are custom properties
  ///   and they can be used to describe extra functionality that is not
  ///   covered by the standard <c>OpenAPI</c> Specification.
  /// </summary>
  TOpenAPIExtensions = class(TOpenAPIModel)
  private
    FValues: TJSONObject;
    procedure CheckName(const AName: string);
  public
    constructor Create;

    procedure Add(const AName: string; const AValue: NullString); overload;
    procedure Add(const AName: string; const AValue: NullDouble); overload;
    procedure Add(const AName: string; const AValue: NullInteger); overload;
    procedure Add(const AName: string; const AValue: NullBoolean); overload;
    procedure Add(const AName: string; const AValue: TJSONValue; AOWned: Boolean = True); overload;
  public
    [NeonUnwrapped] [NeonInclude(IncludeIf.NotEmpty)]
    property Values: TJSONObject read FValues write FValues;
  end;

  /// <summary>
  ///   Class for a property extension
  /// </summary>
  /// <remarks>
  ///   Deprecated, use TOpenAPIExtensions
  /// </remarks>
  TOpenAPIExtension = class(TObjectDictionary<string, TValue>)
  public
    constructor Create;
  end;

  /// <summary>
  ///   Base class for OpenAPI classes that are Extensible ( <c>OpenAPIInfo,
  ///   OpenAPIPaths, OpenAPIPathItem, OpenAPIOperation, OpenAPIParameter,
  ///   OpenAPIResponses, OpenAPITag, OpenAPISecurityScheme</c>)
  /// </summary>
  TOpenAPIExtensible = class(TOpenAPIModel)
  protected
    FExtensions: TOpenAPIExtensions;
  public
    constructor Create;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    [NeonUnwrapped] [NeonInclude(IncludeIf.NotEmpty)]
    property Extensions: TOpenAPIExtensions read FExtensions write FExtensions;
  end;

  /// <summary>
  ///   Class for the <c>Reference Object</c>
  /// </summary>
  TOpenAPIModelReference = class(TOpenAPIExtensible)
  protected
    FUnresolvedReference: NullBoolean;
    FReference: TOpenAPIReference;
  public
    constructor Create;

    function IsReference: Boolean;

    /// <summary>
    /// Indicates object is a placeholder reference to an actual object and does not contain valid data.
    /// </summary>
    [NeonIgnore]
    property UnresolvedReference: NullBoolean read FUnresolvedReference write FUnresolvedReference;

    /// <summary>
    /// Reference object.
    /// </summary>
    [NeonProperty('$ref')][NeonInclude(IncludeIf.NotEmpty)]
    property Reference: TOpenAPIReference read FReference write FReference;
  end;


  /// <summary>
  ///   Base class for the value-based lists
  /// </summary>
  TOpenAPIList<T> = class(TList<T>)
  public
    function IsEmpty: Boolean;
  end;

  /// <summary>
  ///   Base class for the OpenAPI lists
  /// </summary>
  TOpenAPIModelList<T: class> = class(TObjectList<T>)
  public
    constructor Create;
    function IsEmpty: Boolean;
  end;

  /// <summary>
  ///   Value-owned Map
  /// </summary>
  TOpenAPIOwnedMap<K, V> = class(TObjectDictionary<K, V>)
  public
    constructor Create;
  end;

  /// <summary>
  ///   Base class for the OpenAPI Maps
  /// </summary>
  TOpenAPIModelMap<T> = class(TOpenAPIOwnedMap<string, T>)
  public
    function IsEmpty: Boolean;
  end;

  /// <summary>
  ///   Base class for the OpenAPI maps extensible with the Extension
  ///   Specifications
  /// </summary>
  TOpenAPIModelExtensibleMap<T> = class(TOpenAPIModelMap<T>)
  private
    FExtensions: TOpenAPIExtensions;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// This object MAY be extended with Specification Extensions.
    /// </summary>
    [NeonUnwrapped] [NeonInclude(IncludeIf.NotEmpty)]
    property Extensions: TOpenAPIExtensions read FExtensions write FExtensions;
  end;

implementation

{ TOpenAPIModel }

function TOpenAPIModel.AddSubObject<T>(Value: T): T;
begin
  FSubObjects.Add(Value);
  Result := Value;
end;

function TOpenAPIModel.CheckModel: Boolean;
begin
  Result := InternalCheckModel;
end;

constructor TOpenAPIModel.Create;
begin
  FSubObjects := TObjectList<TObject>.Create(True);
end;

function TOpenAPIModel.CreateSubObject<T>: T;
begin
  Result := T.Create;
  FSubObjects.Add(Result);
end;

destructor TOpenAPIModel.Destroy;
begin
  FSubObjects.Free;
  inherited;
end;

function TOpenAPIModel.InternalCheckModel: Boolean;
begin
  Result := True;
end;

function TOpenAPIModel.RemoveSubObject<T>(const Value: T): Integer;
begin
  Result := FSubObjects.Remove(Value);
end;

{ TOpenAPIExtension }

constructor TOpenAPIExtension.Create;
begin
  inherited Create();
end;

procedure TOpenAPIExtensions.Add(const AName: string; const AValue: NullString);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Value);
end;

procedure TOpenAPIExtensions.Add(const AName: string; const AValue: NullDouble);
begin
  CheckName(AName);
  FValues.AddPair(AName, TJSONNumber.Create(AValue.Value));
end;

procedure TOpenAPIExtensions.Add(const AName: string; const AValue: NullInteger);
begin
  CheckName(AName);
  FValues.AddPair(AName, TJSONNumber.Create(AValue.Value));
end;

procedure TOpenAPIExtensions.Add(const AName: string; const AValue: NullBoolean);
begin
  CheckName(AName);
  FValues.AddPair(AName, TJSONBool.Create(AValue.Value));
end;

procedure TOpenAPIExtensions.CheckName(const AName: string);
begin
  if not AName.StartsWith('x-') then
    raise EOpenAPIException.Create('An extension must start with "x-"');
end;

constructor TOpenAPIExtensions.Create;
begin
  inherited Create;
  FValues := CreateSubObject<TJSONObject>;
end;

procedure TOpenAPIExtensions.Add(const AName: string; const AValue: TJSONValue; AOWned: Boolean);
begin
  CheckName(AName);
  if AOWned then
    FValues.AddPair(AName, AValue)
  else
    FValues.AddPair(AName, AValue.Clone as TJSONValue);
end;

{ TOpenAPIExtensible }

constructor TOpenAPIExtensible.Create;
begin
  inherited Create;
  FExtensions := CreateSubObject<TOpenAPIExtensions>;
end;

{ TOpenAPIModelReference }

constructor TOpenAPIModelReference.Create;
begin
  inherited Create;
  FReference := CreateSubObject<TOpenAPIReference>;
end;

function TOpenAPIModelReference.IsReference: Boolean;
begin
  Result := not FReference.Ref.IsEmpty;
end;

{ TOpenAPIModelExtensibleMap<T> }

constructor TOpenAPIModelExtensibleMap<T>.Create;
begin
  inherited Create;
  FExtensions := TOpenAPIExtensions.Create;
end;

destructor TOpenAPIModelExtensibleMap<T>.Destroy;
begin
  FExtensions.Free;
  inherited;
end;

{ TOpenAPIModelList<T> }

constructor TOpenAPIModelList<T>.Create;
begin
  inherited Create(True);
end;

function TOpenAPIModelList<T>.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TOpenAPIOwnedMap<K, V> }

constructor TOpenAPIOwnedMap<K, V>.Create;
begin
  inherited Create([doOwnsValues]);
end;

{ TOpenAPIModelMap<T> }

function TOpenAPIModelMap<T>.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

{ TOpenAPIList<T> }

function TOpenAPIList<T>.IsEmpty: Boolean;
begin
  Result := Count = 0;
end;

end.
