unit MyUnit2Test;

interface

uses
  Nullpobug.UnitTest
  , MyUnit2
  ;

type
  TMyUnit2Test = class(TTestCase)
  private
    FPerson: TPerson;
  published
    procedure SetUp; override;
    procedure TearDown; override;
    procedure TestGetName;
    procedure TestIsNil;
  end;

implementation

procedure TMyUnit2Test.SetUp;
begin
  FPerson := TPerson.Create('Foo');
end;

procedure TMyUnit2Test.TearDown;
begin
  FPerson.Free;
end;

procedure TMyUnit2Test.TestGetName;
begin
  AssertEquals(FPerson.GetName, 'Foo');
end;

procedure TMyUnit2Test.TestIsNil;
begin
  AssertIsNil(nil);
end;

initialization
  RegisterTest(TMyUnit2Test);

end.
