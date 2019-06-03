unit OpenAPI.Interfaces;

interface

implementation

type
  IOpenAPIElement = interface
  ['{F7230DE3-B52E-4A2A-8A32-FF409E4ADD49}']
  end;

  IOpenAPICheckable = interface
  ['{0B22E054-370D-46AF-BB53-3A8827EE6907}']
    function CheckModel: Boolean;
  end;

end.
