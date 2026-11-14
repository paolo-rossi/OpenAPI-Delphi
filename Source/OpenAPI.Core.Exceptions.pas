{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Core.Exceptions;

interface

uses
  System.SysUtils, System.Classes;

type
  EOpenAPIException = class(Exception);
  EOpenAPISchemaException = class(EOpenAPIException);


implementation

end.
