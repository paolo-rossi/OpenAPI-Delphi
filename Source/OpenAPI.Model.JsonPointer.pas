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
unit OpenAPI.Model.JsonPointer;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.NetEncoding;

type
  /// <summary>
  /// JSON pointer expression
  /// </summary>
  TJSONPointer = class
  private
    FTokens: TArray<string>;
  public
    /// <summary>
    /// Initializes the <see cref="TJSONPointer"/> class.
    /// </summary>
    /// <param name="APointer">Pointer as string.</param>
    constructor Create(APointer: string); overload;
    constructor Create(ATokens: TArray<string>); overload;

    /// <summary>
    /// Decode the string.
    /// </summary>
    function Decode(const AToken: string): string;

    /// <summary>
    /// Gets the parent pointer.
    /// </summary>
    function ParentPointer: TJsonPointer;

    /// <summary>
    /// Gets the string representation of this JSON pointer.
    /// </summary>
    function ToString: string; override;

    /// <summary>
    /// Tokens.
    /// </summary>
    property Tokens: TArray<string> read FTokens;
  end;

implementation

{ TJSONPointer }

constructor TJSONPointer.Create(APointer: string);
var
  LArr: TArray<string>;
  LIndex: Integer;
begin
  LArr := APointer.Split(['/']);

  FTokens := [];
  for LIndex := Low(LArr) to High(LArr) do
  begin
    if LIndex = Low(LArr) then
      Continue;
    FTokens := FTokens + [LArr[LIndex]];
  end;

  for LIndex := Low(FTokens) to High(FTokens) do
    FTokens[LIndex] := Decode(FTokens[LIndex]);
end;

constructor TJSONPointer.Create(ATokens: TArray<string>);
begin
  FTokens := ATokens;
end;

function TJSONPointer.Decode(const AToken: string): string;
begin
  Result := TNetEncoding.URL.Decode(AToken).Replace('~1', '/').Replace('~0', '~');
end;

function TJSONPointer.ParentPointer: TJsonPointer;
var
  LParent: TArray<string>;
  LIndex: Integer;
begin
  if Length(FTokens) = 0 then
    Result := nil
  else
  begin
    for LIndex := Low(FTokens) to High(FTokens) - 1 do
      LParent := LParent + [FTokens[LIndex]];

    Result := TJSONPointer.Create(LParent);
  end;
end;

function TJSONPointer.ToString: string;
begin
  Result := '/' + string.join('/', FTokens);
end;

end.

