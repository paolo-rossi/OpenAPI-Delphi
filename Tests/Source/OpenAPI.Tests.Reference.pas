{******************************************************************************}
{                                                                              }
{  Delphi OpenAPI 3 Generator                                                  }
{  Copyright (c) 2018 Paolo Rossi                                              }
{  https://github.com/paolo-rossi/delphi-openapi                               }
{                                                                              }
{  Licensed under the MIT license                                              }
{                                                                              }
{******************************************************************************}
unit OpenAPI.Tests.Reference;

interface

uses
  System.SysUtils, DUnitX.TestFramework,

  OpenAPI.Model.Reference;

type
  [TestFixture]
  [Category('reference')]
  TTestOpenAPIReference = class(TObject)
  private
    FReference: TOpenAPIReference;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestGetFullReferenceSchemas;

    [Test]
    procedure TestGetFullReferencePathItems;

    [Test]
    procedure TestIsLocalByDefault;

    [Test]
    procedure TestIsExternalWhenExternalResourceSet;

    [Test]
    procedure TestEveryTargetHasANonEmptyToString;
  end;

implementation

procedure TTestOpenAPIReference.Setup;
begin
  FReference := TOpenAPIReference.Create;
end;

procedure TTestOpenAPIReference.TearDown;
begin
  FReference.Free;
end;

procedure TTestOpenAPIReference.TestGetFullReferenceSchemas;
begin
  FReference.SetReference('Pet', TOpenAPIReferenceTarget.Schemas);
  Assert.AreEqual('#/components/schemas/Pet', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestGetFullReferencePathItems;
begin
  // Regression guard: components.pathItems ($ref target added for OAS 3.1)
  // must resolve to '#/components/pathItems/<id>', not fall through to the
  // default 'schemas' target.
  FReference.SetReference('PingItem', TOpenAPIReferenceTarget.PathItems);
  Assert.AreEqual('#/components/pathItems/PingItem', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestIsLocalByDefault;
begin
  Assert.IsTrue(FReference.IsLocal);
  Assert.IsFalse(FReference.IsExternal);
end;

procedure TTestOpenAPIReference.TestIsExternalWhenExternalResourceSet;
begin
  FReference.ExternalResource := '../commons/pet.json';
  Assert.IsTrue(FReference.IsExternal);
  Assert.IsFalse(FReference.IsLocal);
end;

procedure TTestOpenAPIReference.TestEveryTargetHasANonEmptyToString;
var
  LTarget: TOpenAPIReferenceTarget;
begin
  // Regression guard: every TOpenAPIReferenceTarget case must be handled by
  // TOpenAPIReferenceTargetHelper.ToString, otherwise GetFullReference silently
  // produces a malformed '#/components//<id>' reference.
  for LTarget := Low(TOpenAPIReferenceTarget) to High(TOpenAPIReferenceTarget) do
    Assert.IsFalse(LTarget.ToString.IsEmpty, 'Missing ToString case for ' + IntToStr(Ord(LTarget)));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIReference);

end.
