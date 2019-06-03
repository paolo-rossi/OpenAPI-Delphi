unit OpenAPI.Any;

interface

{$SCOPEDENUMS ON}

type
  /// <summary>
  /// Represents an Open API element.
  /// </summary>
  IOpenApiElement = interface
  ['{F7230DE3-B52E-4A2A-8A32-FF409E4ADD49}']
  end;

  /// <summary>
  /// Type of an <see cref="IOpenApiAny"/>
  /// </summary>
  TAnyType = (ValPrimitive, ValNull, ValArray, ValObject);

  /// <summary>
  /// Base interface for all the types that represent Open API Any.
  /// </summary>
  IOpenApiAny = interface(IOpenApiElement)
  ['{AB82F994-F48C-4D24-89A7-7EDC2854ED62}']
    /// <summary>
    /// Type of an <see cref="IOpenApiAny"/>.
    /// </summary>
   function GetAnyType: TAnyType;
   property AnyType: TAnyType read GetAnyType;

  end;

implementation

end.
