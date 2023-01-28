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
  public
    function CheckModel: Boolean; inline;
  end;

  /// <summary>
  ///   Class for the <c>Reference Object</c>. The Reference Object is defined
  ///   by <see cref="https://datatracker.ietf.org/doc/html/draft-pbryan-zyp-json-ref-03">
  ///   JSON Reference</see> and follows the same structure, behavior and rules.
  /// </summary>
  TOpenAPIModelReference = class(TOpenAPIModel)
  protected
    FReference: TOpenAPIReference;
  public
    /// <summary>
    /// Reference object.
    /// </summary>
    [NeonProperty('$ref')][NeonInclude(IncludeIf.NotEmpty)]
    property Reference: TOpenAPIReference read FReference write FReference;
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

    procedure AddValue(const AName: string; const AValue: NullString); overload;
    procedure AddValue(const AName: string; const AValue: NullDouble); overload;
    procedure AddValue(const AName: string; const AValue: NullInteger); overload;
    procedure AddValue(const AName: string; const AValue: NullBoolean); overload;

    procedure AddObject(const AName: string; AValue: TJSONObject);
    procedure AddArray(const AName: string; AValue: TJSONArray);
  public
    property Values: TJSONObject read FValues write FValues;
  end;

  /// <summary>
  ///   Base class for OpenAPI classes that are Extensible ( <c>OpenAPIInfo,
  ///   OpenAPIPaths, OpenAPIPathItem, OpenAPIOperation, OpenAPIParameter,
  ///   OpenAPIResponses, OpenAPITag, OpenAPISecurityScheme</c>)
  /// </summary>
  TOpenAPIExtensible = class(TOpenAPIModel)
  private
    FExtensions: TOpenAPIExtensions;
  public
    constructor Create;

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

{ TOpenAPIExtension }

constructor TOpenAPIExtension.Create;
begin
  inherited Create();
end;

{ TOpenAPIExtensions }

procedure TOpenAPIExtensions.AddArray(const AName: string; AValue: TJSONArray);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Clone as TJSONValue);
end;

procedure TOpenAPIExtensions.AddObject(const AName: string; AValue: TJSONObject);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Clone as TJSONValue);
end;

procedure TOpenAPIExtensions.AddValue(const AName: string; const AValue: NullString);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Value);
end;

procedure TOpenAPIExtensions.AddValue(const AName: string; const AValue: NullDouble);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Value);
end;

procedure TOpenAPIExtensions.AddValue(const AName: string; const AValue: NullInteger);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Value);
end;

procedure TOpenAPIExtensions.AddValue(const AName: string; const AValue: NullBoolean);
begin
  CheckName(AName);
  FValues.AddPair(AName, AValue.Value);
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

{ TOpenAPIExtensible }

constructor TOpenAPIExtensible.Create;
begin
  inherited Create;
  FExtensions := CreateSubObject<TOpenAPIExtensions>;
end;

end.
