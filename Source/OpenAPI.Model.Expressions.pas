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
unit OpenAPI.Model.Expressions;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  OpenAPI.Model.JsonPointer,
  OpenAPI.Model.Reference;

type
  /// <summary>
  /// Base class for the Open API runtime expression.
  /// </summary>
  TRuntimeExpression = class abstract
  public const
    PREFIX = '$';
  protected
    FExpression: string;
    function GetExpression: string; virtual; abstract;
  public
    class function Build(const AExpression: string): TRuntimeExpression; virtual;

    function ToString: string; override;
    procedure FromString(const AValue: string);

    property Expression: string read GetExpression;
  end;

  TRuntimeExpressions = class(TObjectList<TRuntimeExpression>)
  end;

  TRuntimeExpressionMap = class(TObjectDictionary<string, TRuntimeExpression>)
  end;


  /// <summary>
  /// String literal with embedded expressions
  /// </summary>
  TCompositeExpression = class(TRuntimeExpression)
  private const
    REGEX_PATTERN = '@"{(?<exp>\$[^}]*)"';
  private
    FTemplate: string;
    FExpressionPattern: TRegEx;
    FContainedExpressions: TObjectList<TRuntimeExpression>;
  protected
    function GetExpression: string; override;
  public
    /// <summary>
    /// Create a composite expression from a string literal with an embedded expression
    /// </summary>
    /// <param name="AExpression"></param>
    constructor Create(const AExpression: string);
    destructor Destroy; override;

    /// <summary>
    /// Expressions embedded into string literal
    /// </summary>
    property ContainedExpressions: TObjectList<TRuntimeExpression> read FContainedExpressions write FContainedExpressions;
  end;

  /// <summary>
  /// Source expression.
  /// </summary>
  TSourceExpression = class(TRuntimeExpression)
  protected
    /// <summary>
    /// Gets the expression string.
    /// </summary>
    FValue: string;

    /// <summary>
    /// Initializes a new instance of the <see cref="TSourceExpression"/> class.
    /// </summary>
    /// <param name="AValue">The value string.</param>
    constructor Create(const AValue: string);
  public
    /// <summary>
    /// Build the source expression from input string.
    /// </summary>
    /// <param name="AExpression">The source expression.</param>
    /// <returns>The built source expression.</returns>
    class function Build(const AExpression: string): TSourceExpression; reintroduce;
  end;

  /// <summary>
  /// URL expression.
  /// </summary>
  TURLExpression = class sealed(TRuntimeExpression)
  public
    /// <summary>
    /// $url string.
    /// </summary>
    const URL = '$url';
  public
    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;
  end;

  /// <summary>
  /// Method expression.
  /// </summary>
  TMethodExpression = class sealed(TRuntimeExpression)
  public
    /// <summary>
    /// $method. string
    /// </summary>
    const METHOD = '$method';
  public
    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;
  end;

  /// <summary>
  /// StatusCode expression.
  /// </summary>
  TStatusCodeExpression = class sealed(TRuntimeExpression)
  public
    /// <summary>
    /// $statusCode. string
    /// </summary>
    const STATUSCODE = '$statusCode';
  public
    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;
  end;

  /// <summary>
  /// Request expression.
  /// </summary>
  TRequestExpression = class sealed(TRuntimeExpression)
  public
    /// <summary>
    /// $request. string
    /// </summary>
    const REQUEST = '$request.';
  private
    FSource: TSourceExpression;
    function GetSource: TSourceExpression;
  public
    /// <summary>
    /// Initializes a new instance of the <see cref="TRequestExpression"/> class.
    /// </summary>
    /// <param name="ASource">The source of the request.</param>
    constructor Create(ASource: TSourceExpression);

    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;

    /// <summary>
    /// The <see cref="TSourceExpression"/> expression.
    /// </summary>
    property Source: TSourceExpression read GetSource;
  end;

  TResponseExpression = class(TRuntimeExpression)
    /// <summary>
    /// $response. string
    /// </summary>
    public const RESPONSE = '$response.';
  private
    FSource: TSourceExpression;
  public
    /// <summary>
    /// Create a new instance of the <see cref="TResponseExpression"/> class.
    /// </summary>
    /// <param name="ASource">The source of the response.</param>
    constructor Create(ASource: TSourceExpression);

    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;
    //public override string Expression => Response + Source.Expression;

    /// <summary>
    /// The <see cref="TSourceExpression"/> expression.
    /// </summary>
    property Source: TSourceExpression read FSource;
  end;

  /// <summary>
  /// Body expression.
  /// </summary>
  TBodyExpression = class sealed(TSourceExpression)
  public
    /// <summary>
    /// body string
    /// </summary>
    const BODY = 'body';

    /// <summary>
    /// Prefix for a pointer
    /// </summary>
    const POINTER_PREFIX = '#';
  private
    function GetFragment: string;
  protected
    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;
  public
    /// <summary>
    /// Initializes a new instance of the <see cref="TBodyExpression"/> class.
    /// </summary>
    /// <param name="APointer">a JSON Pointer [RFC 6901](https://tools.ietf.org/html/rfc6901).</param>
    constructor Create(APointer: TJsonPointer);

    /// <summary>
    /// Gets the fragment string.
    /// </summary>
    property Fragment: string read GetFragment;
  end;

  /// <summary>
  /// Header expression, The token identifier in header is case-insensitive.
  /// </summary>
  THeaderExpression = class(TSourceExpression)
    /// <summary>
    /// header. string
    /// </summary>
    public const HEADER = 'header.';
  private
    function GetToken: string;
  protected
    /// <summary>
    /// Gets the expression string.
    /// </summary>
    function GetExpression: string; override;
  public
    /// <summary>
    /// Initializes a new instance of the <see cref="THeaderExpression"/> class.
    /// </summary>
    /// <param name="AToken">The token string, it's case-insensitive.</param>
    constructor Create(const AToken: string);
    {
        if (string.IsNullOrWhiteSpace(token))
            throw Error.ArgumentNullOrWhiteSpace(nameof(token));
    }

    /// <summary>
    /// Gets the expression string.
    /// </summary>
    //public override string Expression
        {
            return Header + Value;
        }

    /// <summary>
    /// Gets the token string.
    /// </summary>
    property Token: string read GetToken;
        {
            return Value;
        }
  end;

implementation

uses
  OpenAPI.Core.Exceptions;

{ TRuntimeExpression }

class function TRuntimeExpression.Build(const AExpression: string): TRuntimeExpression;
var
  LSubString: string;
  LSource: TSourceExpression;
begin
  if AExpression.IsEmpty then
    raise Exception.Create('Expression empty');

  if not AExpression.StartsWith(PREFIX) then
    Exit(TCompositeExpression.Create(AExpression));

  // $url
  if AExpression = TURLExpression.URL then
    Exit(TURLExpression.Create);

  // $method
  if AExpression = TMethodExpression.METHOD then
    Exit(TMethodExpression.Create);

  // $statusCode
  if AExpression = TStatusCodeExpression.STATUSCODE then
    Exit(TStatusCodeExpression.Create);

  // $request.
  if AExpression.StartsWith(TRequestExpression.REQUEST) then
  begin
    LSubString := AExpression.Substring(TRequestExpression.REQUEST.Length);
    LSource := TSourceExpression.Build(LSubString);
    Exit(TRequestExpression(LSource));
  end;

  // $response.
  if AExpression.StartsWith(TResponseExpression.RESPONSE) then
  begin
    LSubString := AExpression.Substring(TResponseExpression.RESPONSE.Length);
    LSource := TSourceExpression.Build(LSubString);
    Exit(TResponseExpression(LSource));
  end;

  raise EOpenAPIException.Create(Format('Runtime Expression Has Invalid Format: %s', [AExpression]));
end;

procedure TRuntimeExpression.FromString(const AValue: string);
begin
  FExpression := AValue;
end;

function TRuntimeExpression.ToString: string;
begin
  Result := Expression;
end;

{ TCompositeExpression }

constructor TCompositeExpression.Create(const AExpression: string);
var
  LValue: string;
  LMatch: TMatch;
  LMatches: TMatchCollection;
begin
  FContainedExpressions := TObjectList<TRuntimeExpression>.Create(True);

  FTemplate := AExpression;

  // Extract subexpressions and convert to RuntimeExpressions
  LMatches := FExpressionPattern.Matches(AExpression);

  for LMatch in LMatches do
  begin
    if LMatch.Success then
    begin
      LValue := LMatch.Groups['exp'].Value;
      FContainedExpressions.Add(TRuntimeExpression.Build(LValue));
    end;
  end;
end;

destructor TCompositeExpression.Destroy;
begin
  FContainedExpressions.Free;
  inherited;
end;

function TCompositeExpression.GetExpression: string;
begin
  Result := FTemplate;
end;

{ TSourceExpression }

class function TSourceExpression.Build(const AExpression: string): TSourceExpression;
var
  LSubString: string;
  LExpressions: TArray<string>;
begin
  { TODO -opaolo -c : to finish 31/03/2019 11:15:25 }
  if not string.IsNullOrWhiteSpace(AExpression) then
  begin
      LExpressions := AExpression.Split(['.']);
      if Length(LExpressions) = 2 then
      begin
          if AExpression.StartsWith(THeaderExpression.HEADER) then
              // header.
              Exit(THeaderExpression(LExpressions[1]));
          {
          if AExpression.StartsWith(TQueryExpression.QUERY) then
              // query.
              Exit(TQueryExpression(LExpressions[1]));

          if AExpression.StartsWith(TPathExpression.PATH) then
              // path.
              Exit(PathExpression(LExpressions[1]));
          }
      end;

      // body
      if AExpression.StartsWith(TBodyExpression.BODY) then
      begin
          LSubString := AExpression.Substring(Length(TBodyExpression.BODY));
          if string.IsNullOrEmpty(LSubString) then
            Exit(TBodyExpression.Create(nil));

          Exit(TBodyExpression.Create(TJsonPointer.Create(LSubString)));
      end;
  end;
  raise EOpenAPIException.Create('Source Expression invalid format');
end;

constructor TSourceExpression.Create(const AValue: string);
begin
  FValue := AValue;
end;

{ TURLExpression }

function TURLExpression.GetExpression: string;
begin
  Result := URL;
end;

{ TRequestExpression }

constructor TRequestExpression.Create(ASource: TSourceExpression);
begin
  Assert(ASource <> nil);
  FSource := ASource;
end;

function TRequestExpression.GetExpression: string;
begin
  Result := REQUEST + Source.Expression;
end;

function TRequestExpression.GetSource: TSourceExpression;
begin
  Result := FSource;
end;

{ TMethodExpression }

function TMethodExpression.GetExpression: string;
begin
  Result := METHOD;
end;

{ TStatusCodeExpression }

function TStatusCodeExpression.GetExpression: string;
begin
  Result := STATUSCODE;
end;

{ TBodyExpression }

constructor TBodyExpression.Create(APointer: TJsonPointer);
begin
//        : base(pointer?.ToString())
  if not Assigned(APointer) then
    raise EArgumentNilException.Create('JsonPointer is null');

  inherited Create(APointer.ToString);
end;

function TBodyExpression.GetExpression: string;
begin
  if string.IsNullOrWhiteSpace(FValue) then
    Exit(BODY);

  Result := BODY + POINTER_PREFIX + FValue;
end;

function TBodyExpression.GetFragment: string;
begin
  Result := FValue;
end;

{ TResponseExpression }

constructor TResponseExpression.Create(ASource: TSourceExpression);
begin
  FSource := ASource;
end;

function TResponseExpression.GetExpression: string;
begin
  Result := RESPONSE + Source.Expression;
end;

{ THeaderExpression }

constructor THeaderExpression.Create(const AToken: string);
begin
  if string.IsNullOrWhiteSpace(AToken) then
    raise Exception.Create('Argument null or whitespace');

  inherited Create(AToken);
end;

function THeaderExpression.GetExpression: string;
begin
  Result := HEADER + FValue;
end;

function THeaderExpression.GetToken: string;
begin
  Result := FValue;
end;

end.

