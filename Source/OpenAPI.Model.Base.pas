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

  Neon.Core.Types,
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

  TOpenAPIExtension = class(TObjectDictionary<string, TValue>)
  public
    constructor Create;
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

end.
