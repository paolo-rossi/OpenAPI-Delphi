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

    [Test]
    procedure TestIsEmptyByDefault;

    [Test]
    procedure TestParseComponentsReference;

    [Test]
    procedure TestParseEveryComponentsTarget;

    [Test]
    procedure TestParseExternalReferenceWithPointer;

    [Test]
    procedure TestParseExternalReferenceWithoutFragment;

    [Test]
    procedure TestParseLocalNonComponentsReferenceIsKeptAsWritten;

    [Test]
    procedure TestParsePointerInsideComponentIsKeptAsWritten;

    [Test]
    procedure TestParseUnknownComponentsTargetIsKeptAsWritten;

    [Test]
    procedure TestParseAnchorIsKeptAsWritten;

    [Test]
    procedure TestParseEmptyStringClearsReference;

    [Test]
    procedure TestSetReferenceAfterParseDropsRawReference;

    [Test]
    procedure TestSetIdAfterParseDropsRawReference;
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

procedure TTestOpenAPIReference.TestIsEmptyByDefault;
begin
  Assert.IsTrue(FReference.IsEmpty);
end;

procedure TTestOpenAPIReference.TestParseComponentsReference;
begin
  FReference.SetFullReference('#/components/schemas/Pet');

  Assert.AreEqual('Pet', FReference.Id);
  Assert.IsTrue(FReference.Target = TOpenAPIReferenceTarget.Schemas);
  Assert.IsTrue(FReference.IsLocal);
  Assert.IsFalse(FReference.IsEmpty);
  Assert.AreEqual('#/components/schemas/Pet', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParseEveryComponentsTarget;
var
  LTarget: TOpenAPIReferenceTarget;
  LRef: string;
begin
  for LTarget := Low(TOpenAPIReferenceTarget) to High(TOpenAPIReferenceTarget) do
  begin
    LRef := '#/components/' + LTarget.ToString + '/Item';
    FReference.SetFullReference(LRef);

    Assert.IsTrue(FReference.Target = LTarget, 'Wrong target for ' + LRef);
    Assert.AreEqual('Item', FReference.Id, 'Wrong id for ' + LRef);
    Assert.AreEqual(LRef, FReference.GetFullReference);
  end;
end;

procedure TTestOpenAPIReference.TestParseExternalReferenceWithPointer;
begin
  FReference.SetFullReference('../commons/pet.json#/components/schemas/Pet');

  Assert.AreEqual('../commons/pet.json', FReference.ExternalResource);
  Assert.AreEqual('components/schemas/Pet', FReference.Id);
  Assert.IsTrue(FReference.IsExternal);
  Assert.AreEqual('../commons/pet.json#/components/schemas/Pet', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParseExternalReferenceWithoutFragment;
begin
  FReference.SetFullReference('http://localhost/pet.json');

  Assert.AreEqual('http://localhost/pet.json', FReference.ExternalResource);
  Assert.AreEqual('', FReference.Id);
  Assert.IsFalse(FReference.IsEmpty, 'A whole external document is still a reference');
  Assert.AreEqual('http://localhost/pet.json', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParseLocalNonComponentsReferenceIsKeptAsWritten;
begin
  FReference.SetFullReference('#/$defs/Node');
  Assert.IsTrue(FReference.IsLocal);
  Assert.AreEqual('#/$defs/Node', FReference.GetFullReference);

  FReference.SetFullReference('#/paths/~1pets/get');
  Assert.AreEqual('#/paths/~1pets/get', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParsePointerInsideComponentIsKeptAsWritten;
begin
  FReference.SetFullReference('#/components/schemas/Pet/properties/id');
  Assert.AreEqual('#/components/schemas/Pet/properties/id', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParseUnknownComponentsTargetIsKeptAsWritten;
begin
  FReference.SetFullReference('#/components/unknown/X');
  Assert.AreEqual('#/components/unknown/X', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParseAnchorIsKeptAsWritten;
begin
  FReference.SetFullReference('http://example.com/a.json#anchor');
  Assert.AreEqual('http://example.com/a.json', FReference.ExternalResource);
  Assert.AreEqual('http://example.com/a.json#anchor', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestParseEmptyStringClearsReference;
begin
  FReference.SetFullReference('#/$defs/Node');
  FReference.SetFullReference('');
  Assert.IsTrue(FReference.IsEmpty);
end;

procedure TTestOpenAPIReference.TestSetReferenceAfterParseDropsRawReference;
begin
  FReference.SetFullReference('#/$defs/Node');
  FReference.SetReference('Pet', TOpenAPIReferenceTarget.Schemas);
  Assert.AreEqual('#/components/schemas/Pet', FReference.GetFullReference);
end;

procedure TTestOpenAPIReference.TestSetIdAfterParseDropsRawReference;
begin
  FReference.SetFullReference('#/$defs/Node');
  FReference.Id := 'Pet';
  Assert.AreEqual('#/components/schemas/Pet', FReference.GetFullReference);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestOpenAPIReference);

end.
