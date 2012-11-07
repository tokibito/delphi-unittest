unit MyUnit1Test;

interface

uses
  Nullpobug.UnitTest
  , MyUnit1
  ;

type
  TMyUnit1Test = class(TTestCase)
  published
    procedure TestAdd;
  end;

implementation

procedure TMyUnit1Test.TestAdd;
begin
  AssertEquals(Add(10, 20), 30);
end;

initialization
  RegisterTest(TMyUnit1Test);

end.
