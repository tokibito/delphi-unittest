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
    procedure TestSub;
    procedure TestAddFail;
    procedure TestSkip;
  end;

implementation

procedure TMyUnit1Test.TestAdd;
begin
  AssertEquals(Add(10, 20), 30);
end;

procedure TMyUnit1Test.TestSub;
begin
  AssertEquals(Sub(40, 20), 20);
end;

procedure TMyUnit1Test.TestAddFail;
begin
  // Fail Test
  AssertEquals(Add(10, 20), 40);
end;

procedure TMyUnit1Test.TestSkip;
begin
  raise ESkipTest.Create('This is Skipped.');
end;

initialization
  RegisterTest(TMyUnit1Test);

end.
