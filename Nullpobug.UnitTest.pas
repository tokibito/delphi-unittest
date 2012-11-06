unit Nullpobug.UnitTest;

interface

uses
  System.SysUtils;

type
  EAssertionError = class(Exception);

  TTestCase = class(TObject)
  published
    procedure setUp;
    procedure tearDown;
    procedure assertTrue(Value: Boolean);
    procedure assertFalse(Value: Boolean);
  end;

procedure runTest;

implementation

procedure TTestCase.setUp;
begin
end;

procedure TTestCase.tearDown;
begin
end;

procedure TTestCase.assertTrue(Value: Boolean);
begin
  if not Value = True then
    raise EAssertionError.Create(BoolToStr(Value) + ' != True')
end;

procedure TTestCase.assertFalse(Value: Boolean);
begin
end;

procedure runTest;
begin
end;

end.
