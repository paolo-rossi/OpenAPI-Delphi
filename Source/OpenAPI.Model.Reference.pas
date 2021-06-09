{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3.0 Generator                                                }
{  Copyright (c) 2018-2019 Paolo Rossi                                         }
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
unit OpenAPI.Model.Reference;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,

  Neon.Core.Attributes;

type
  /// <summary>
  /// A simple object to allow referencing other components in the specification, internally and externally.
  /// </summary>
  TOpenAPIReference = class
  private
    FId: string;
    FRef: string;
    FRefType: string;
    FExternalResource: string;
  public
    /// <summary>
    /// Gets a flag indicating whether this reference is an external reference.
    /// </summary>
    function IsExternal: Boolean;

    /// <summary>
    /// Gets a flag indicating whether this reference is a local reference.
    /// </summary>
    function IsLocal: Boolean;
  public
    /// <summary>
    /// The identifier of the reusable component of one particular ReferenceType.
    /// If ExternalResource is present, this is the path to the component after the '#/'.
    /// For example, if the reference is 'example.json#/path/to/component', the Id is 'path/to/component'.
    /// If ExternalResource is not present, this is the name of the component without the reference type name.
    /// For example, if the reference is '#/components/schemas/componentName', the Id is 'componentName'.
    /// </summary>
    [NeonIgnore]
    property Id: string read FId write FId;

    /// <summary>
    /// The element type referenced.
    /// </summary>
    /// <remarks>This must be present if <see cref="ExternalResource"/> is not present.</remarks>
    [NeonIgnore]
    property RefType: string read FRefType write FRefType;

    /// <summary>
    /// External resource in the reference.
    /// It maybe:
    /// 1. a absolute/relative file path, for example:  ../commons/pet.json
    /// 2. a Url, for example: http://localhost/pet.json
    /// </summary>
    [NeonIgnore]
    property ExternalResource: string read FExternalResource write FExternalResource;

    [NeonProperty('$ref')][NeonInclude(IncludeIf.NotEmpty)]
    property Ref: string read FRef write FRef;
  end;

implementation

{ TOpenAPIReference }

function TOpenAPIReference.IsExternal: Boolean;
begin
  { TODO -opaolo -c : to finish 31/03/2019 18:47:51 }
  Result := not FExternalResource.IsEmpty;
end;

function TOpenAPIReference.IsLocal: Boolean;
begin
  { TODO -opaolo -c : to finish 31/03/2019 18:47:51 }
  Result := FExternalResource.IsEmpty;
end;

end.
