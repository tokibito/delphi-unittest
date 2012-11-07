unit Nullpobug.UnitTest;

interface

uses
  System.SysUtils;

type
  EAssertionError = class(Exception);

  TTestCase = class(TObject)
  public
    procedure setUp;
    procedure tearDown;
    procedure assertTrue(Value: Boolean);
    procedure assertFalse(Value: Boolean);
    procedure assertEquals(Value1, Value2: Integer); overload;
    procedure assertEquals(Value1, Value2: String); overload;
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
  if not (Value = True) then
    raise EAssertionError.Create(BoolToStr(Value, True) + ' != True')
end;

procedure TTestCase.assertFalse(Value: Boolean);
begin
  if not (Value = False) then
    raise EAssertionError.Create(BoolToStr(Value, True) + ' != False')
end;

procedure TTestCase.assertEquals(Value1, Value2: Integer);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.Create(IntToStr(Value1) + ' != ' + IntToStr(Value2));
end;

procedure TTestCase.assertEquals(Value1, Value2: String);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.Create('"' + Value1 + '" != "' + Value2 + '"');
end;

procedure runTest;
begin
end;

end.
