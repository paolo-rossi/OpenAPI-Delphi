unit OpenAPI.Model.Base;

interface

uses
  System.SysUtils, System.Classes,

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

end.
