unit Nullpobug.UnitTest;

interface

uses
  System.SysUtils
  , System.Generics.Collections
  , System.Rtti
  ;

type
  EAssertionError = class(Exception);

  TTestCase = class(TObject)
  public
    procedure SetUp;
    procedure TearDown;
    procedure AssertTrue(Value: Boolean);
    procedure AssertFalse(Value: Boolean);
    procedure AssertEquals(Value1, Value2: Integer); overload;
    procedure AssertEquals(Value1, Value2: String); overload;
  end;

  TTestCaseClass = class of TTestCase;

  TTestResultType = (rtOK, rtFail, rtError, rtSkip);

  TTestResult = class(TObject)
  private
    FResultType: TTestResultType;
    FError: EAssertionError;
  public
    constructor Create(TestResultType: TTestResultType; Error: EAssertionError = nil);  // TODO: Error
    destructor Destroy; override;
    property ResultType: TTestResultType read FResultType;
  end;

  TTestRunner = class(TObject)
  private
    FTestCaseList: TObjectList<TTestCase>;
    FTestResultList: TObjectList<TTestResult>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTestCase(TestCaseClass: TTestCaseClass);
    procedure Run(TestCase: TTestCase);
    procedure RunTests;
  end;

procedure RunTest;
procedure RegisterTest;

implementation

{ TestCase }
procedure TTestCase.setUp;
begin
end;

procedure TTestCase.tearDown;
begin
end;

procedure TTestCase.AssertTrue(Value: Boolean);
begin
  if not (Value = True) then
    raise EAssertionError.Create(BoolToStr(Value, True) + ' != True')
end;

procedure TTestCase.AssertFalse(Value: Boolean);
begin
  if not (Value = False) then
    raise EAssertionError.Create(BoolToStr(Value, True) + ' != False')
end;

procedure TTestCase.AssertEquals(Value1, Value2: Integer);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.Create(IntToStr(Value1) + ' != ' + IntToStr(Value2));
end;

procedure TTestCase.AssertEquals(Value1, Value2: String);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.Create('"' + Value1 + '" != "' + Value2 + '"');
end;

{ TestResult }
constructor TTestResult.Create(TestResultType: TTestResultType; Error: EAssertionError = nil);
begin
  FResultType := TestResultType;
  FError := Error;
end;

destructor TTestResult.Destroy;
begin
  FError := nil;
  inherited Destroy;
end;

{ TestRunner }
constructor TTestRunner.Create;
begin
  FTestCaseList := TObjectList<TTestCase>.Create;
  FTestResultList := TObjectList<TTestResult>.Create;
end;

destructor TTestRunner.Destroy;
begin
  FreeAndNil(FTestCaseList);
  FreeAndNil(FTestResultList);
  inherited Destroy;
end;

procedure TTestRunner.AddTestCase(TestCaseClass: TTestCaseClass);
begin
  FTestCaseList.Add(TestCaseClass.Create);
end;

procedure TTestRunner.Run(TestCase: TTestCase);
begin
end;

procedure TTestRunner.RunTests;
var
  TestCase: TTestCase;
begin
  for TestCase in FTestCaseList do
    Run(TestCase);
end;

procedure RunTest;
begin
end;

procedure RegisterTest;
begin
end;

end.
