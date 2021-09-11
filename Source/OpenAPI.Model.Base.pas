{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3.0 Generator                                                }
{  Copyright (c) 2018-2021 Paolo Rossi                                         }
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
  OpenAPI.Model.Reference;

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

function TOpenAPIModel.CheckModel: Boolean;
begin
  Result := InternalCheckModel;
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
