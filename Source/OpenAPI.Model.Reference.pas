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

  Neon.Core.Attributes,
  Neon.Core.Nullables;

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
    FRawReference: string;
    FSummary: NullString;
    FDescription: NullString;
    procedure SetId(const AValue: string);
    procedure SetExternalResource(const AValue: string);
    procedure SetTarget(const AValue: TOpenAPIReferenceTarget);
    class function TryParseComponent(const AFragment: string; out ATarget: TOpenAPIReferenceTarget; out AId: string): Boolean; static;
  public
    /// <summary>
    /// Gets a flag indicating whether this reference is an external reference.
    /// </summary>
    function IsExternal: Boolean;

    /// <summary>
    /// Gets a flag indicating whether this reference is a local reference.
    /// </summary>
    function IsLocal: Boolean;

    /// <summary>
    /// Gets a flag indicating whether no reference is set.
    /// </summary>
    function IsEmpty: Boolean;

  public
    procedure SetReference(const AId: string; ATarget: TOpenAPIReferenceTarget);

    /// <summary>
    ///   Sets the reference from a "$ref" string, as found in a document. A local
    ///   '#/components/&lt;target&gt;/&lt;id&gt;' reference fills Target and Id. An external
    ///   'file.json#/path' reference fills ExternalResource and Id (the path after '#/').
    ///   Any other reference (e.g. '#/$defs/Node', '#/paths/~1pets') is kept as written,
    ///   so GetFullReference gives it back unchanged.
    /// </summary>
    procedure SetFullReference(const AReference: string);

    function GetFullReference: string;

    /// <summary>
    /// The identifier of the reusable component of one particular ReferenceType.
    /// If ExternalResource is present, this is the path to the component after the '#/'.
    /// For example, if the reference is 'example.json#/path/to/component', the Id is 'path/to/component'.
    /// If ExternalResource is not present, this is the name of the component without the reference type name.
    /// For example, if the reference is '#/components/schemas/componentName', the Id is 'componentName'.
    /// </summary>
    [NeonIgnore] property Id: string read FId write SetId;

    /// <summary>
    ///   <para>
    ///     The target in the components section for the Id. Can be:
    ///   </para>
    ///   <para>
    ///     Schemas, Responses, Parameters, Examples, RequestBodies,
    ///     Headers, SecuritySchemes, Links, Callbacks.
    ///   </para>
    /// </summary>
    [NeonIgnore] property Target: TOpenAPIReferenceTarget read FTarget write SetTarget;

    /// <summary>
    /// External resource in the reference.
    /// It maybe:
    /// 1. a absolute/relative file path, for example:  ../commons/pet.json
    /// 2. a Url, for example: http://localhost/pet.json
    /// </summary>
    [NeonIgnore] property ExternalResource: string read FExternalResource write SetExternalResource;

    /// <summary>
    ///   OAS 3.1 Reference Object "summary": overrides the summary of the referenced component
    ///   (no effect if that component has no summary). Written next to "$ref" when set.
    ///   Not part of the reference itself: IsEmpty and SetFullReference ignore it
    /// </summary>
    [NeonIgnore] property Summary: NullString read FSummary write FSummary;

    /// <summary>
    ///   OAS 3.1 Reference Object "description": overrides the description of the referenced
    ///   component (no effect if that component has no description). Written next to "$ref"
    ///   when set. Not part of the reference itself: IsEmpty and SetFullReference ignore it
    /// </summary>
    [NeonIgnore] property Description: NullString read FDescription write FDescription;
  end;

implementation

{ TOpenAPIReference }

function TOpenAPIReference.GetFullReference: string;
begin
  if not FRawReference.IsEmpty then
    Exit(FRawReference);

  if IsExternal then
  begin
    Result := FExternalResource;
    if not FId.IsEmpty then
      Result := Result + '#/' + FId;
    Exit;
  end;

  // Default is: #/components/schemas
  Result := Format('#/components/%s/%s', [FTarget.ToString, FId]);
end;

function TOpenAPIReference.IsEmpty: Boolean;
begin
  Result := FId.IsEmpty and FExternalResource.IsEmpty and FRawReference.IsEmpty;
end;

function TOpenAPIReference.IsExternal: Boolean;
begin
  Result := not FExternalResource.IsEmpty;
end;

function TOpenAPIReference.IsLocal: Boolean;
begin
  Result := FExternalResource.IsEmpty;
end;

procedure TOpenAPIReference.SetExternalResource(const AValue: string);
begin
  FExternalResource := AValue;
  FRawReference := '';
end;

procedure TOpenAPIReference.SetFullReference(const AReference: string);
var
  LHashPos: Integer;
  LFragment: string;
  LTarget: TOpenAPIReferenceTarget;
  LId: string;
begin
  FId := '';
  FExternalResource := '';
  FTarget := TOpenAPIReferenceTarget.Schemas;
  FRawReference := '';

  if AReference.IsEmpty then
    Exit;

  LHashPos := AReference.IndexOf('#');
  if LHashPos < 0 then
  begin
    // Whole external document, no fragment
    FExternalResource := AReference;
    Exit;
  end;

  FExternalResource := AReference.Substring(0, LHashPos);
  LFragment := AReference.Substring(LHashPos + 1);

  if FExternalResource.IsEmpty and TryParseComponent(LFragment, LTarget, LId) then
  begin
    FId := LId;
    FTarget := LTarget;
    Exit;
  end;

  if LFragment.StartsWith('/') then
    FId := LFragment.Substring(1)
  else
    FId := LFragment;

  // Not a components reference, or not in a form GetFullReference rebuilds exactly: keep it as written
  if FExternalResource.IsEmpty or not LFragment.StartsWith('/') then
    FRawReference := AReference;
end;

procedure TOpenAPIReference.SetId(const AValue: string);
begin
  FId := AValue;
  FRawReference := '';
end;

procedure TOpenAPIReference.SetReference(const AId: string; ATarget: TOpenAPIReferenceTarget);
begin
  FId := AId;
  FTarget := ATarget;
  FRawReference := '';
end;

procedure TOpenAPIReference.SetTarget(const AValue: TOpenAPIReferenceTarget);
begin
  FTarget := AValue;
  FRawReference := '';
end;

class function TOpenAPIReference.TryParseComponent(const AFragment: string;
  out ATarget: TOpenAPIReferenceTarget; out AId: string): Boolean;
const
  ComponentsPrefix = '/components/';
var
  LRest: string;
  LSlashPos: Integer;
  LTargetName: string;
  LTarget: TOpenAPIReferenceTarget;
begin
  Result := False;
  if not AFragment.StartsWith(ComponentsPrefix) then
    Exit;

  LRest := AFragment.Substring(Length(ComponentsPrefix));
  LSlashPos := LRest.IndexOf('/');
  if LSlashPos <= 0 then
    Exit;

  LTargetName := LRest.Substring(0, LSlashPos);
  AId := LRest.Substring(LSlashPos + 1);

  // Component names can't contain '/' or JSON Pointer escapes ('~'): anything else points
  // inside a component (e.g. '#/components/schemas/Pet/properties/id') and is kept as written
  if AId.IsEmpty or (AId.IndexOfAny(['/', '~', '%']) >= 0) then
    Exit;

  for LTarget := Low(TOpenAPIReferenceTarget) to High(TOpenAPIReferenceTarget) do
    if LTarget.ToString = LTargetName then
    begin
      ATarget := LTarget;
      Exit(True);
    end;
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
