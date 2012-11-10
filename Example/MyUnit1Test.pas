unit MyUnit1Test;

interface

uses
  Nullpobug.UnitTest
  , System.SysUtils
  , MyUnit1
  ;

type
  TMyUnit1Test = class(TTestCase)
  published
    procedure TestAdd;
    procedure TestSub;
    {$IFNDEF NOFAIL}
    procedure TestAddFail;
    {$ENDIF}
    procedure TestSkip;
    procedure TestSlow;
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

{$IFNDEF NOFAIL}
procedure TMyUnit1Test.TestAddFail;
begin
  // Fail Test
  AssertEquals(Add(10, 20), 40);
end;
{$ENDIF}

procedure TMyUnit1Test.TestSkip;
begin
  raise ESkipTest.Create('This is Skipped.');
end;

procedure TMyUnit1Test.TestSlow;
begin
  Sleep(500);
end;

initialization
  RegisterTest(TMyUnit1Test);

end.
