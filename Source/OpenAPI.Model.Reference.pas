{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Model.Reference;

interface

{$SCOPEDENUMS ON}

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,

  Neon.Core.Attributes;

type
  TOpenAPIReferenceTarget = (
    Schemas,
    Responses,
    Parameters,
    Examples,
    RequestBodies,
    Headers,
    SecuritySchemes,
    Links,
    Callbacks,
    PathItems
  );
  TOpenAPIReferenceTargetHelper = record helper for TOpenAPIReferenceTarget
    function ToString: string;
  end;

  /// <summary>
  /// A simple object to allow referencing other components in the specification, internally and externally.
  /// </summary>
  TOpenAPIReference = class
  private
    FId: string;
    FExternalResource: string;
    FTarget: TOpenAPIReferenceTarget;
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
    procedure SetReference(const AId: string; ATarget: TOpenAPIReferenceTarget);
    function GetFullReference: string;

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
    ///   <para>
    ///     The target in the components section for the Id. Can be:
    ///   </para>
    ///   <para>
    ///     Schemas, Responses, Parameters, Examples, RequestBodies,
    ///     Headers, SecuritySchemes, Links, Callbacks.
    ///   </para>
    /// </summary>
    [NeonIgnore]
    property Target: TOpenAPIReferenceTarget read FTarget write FTarget;

    /// <summary>
    /// External resource in the reference.
    /// It maybe:
    /// 1. a absolute/relative file path, for example:  ../commons/pet.json
    /// 2. a Url, for example: http://localhost/pet.json
    /// </summary>
    [NeonIgnore]
    property ExternalResource: string read FExternalResource write FExternalResource;
  end;

implementation

{ TOpenAPIReference }

function TOpenAPIReference.GetFullReference: string;
begin
  // Default is: #/components/schemas
  Result := Format('#/components/%s/%s', [FTarget.ToString, FId]);
end;

function TOpenAPIReference.IsExternal: Boolean;
begin
  Result := not FExternalResource.IsEmpty;
end;

function TOpenAPIReference.IsLocal: Boolean;
begin
  Result := FExternalResource.IsEmpty;
end;

procedure TOpenAPIReference.SetReference(const AId: string; ATarget: TOpenAPIReferenceTarget);
begin
  FId := AId;
  FTarget := ATarget;
end;

{ TOpenAPIReferenceTargetHelper }

function TOpenAPIReferenceTargetHelper.ToString: string;
begin
  case Self  of
    TOpenAPIReferenceTarget.Schemas:         Result := 'schemas';
    TOpenAPIReferenceTarget.Responses:       Result := 'responses';
    TOpenAPIReferenceTarget.Parameters:      Result := 'parameters';
    TOpenAPIReferenceTarget.Examples:        Result := 'examples';
    TOpenAPIReferenceTarget.RequestBodies:   Result := 'requestBodies';
    TOpenAPIReferenceTarget.Headers:         Result := 'headers';
    TOpenAPIReferenceTarget.SecuritySchemes: Result := 'securitySchemes';
    TOpenAPIReferenceTarget.Links:           Result := 'links';
    TOpenAPIReferenceTarget.Callbacks:       Result := 'callbacks';
    TOpenAPIReferenceTarget.PathItems:       Result := 'pathItems';
  end;
end;

end.
