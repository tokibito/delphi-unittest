unit Nullpobug.UnitTest;

interface

uses
  System.SysUtils
  , System.StrUtils
  , System.Generics.Collections
  , System.Rtti
  ;

type
  EAssertionError = class(Exception);

  TTestCase = class(TObject)
  public
    procedure SetUp; virtual;
    procedure TearDown; virtual;
    procedure AssertTrue(Value: Boolean);
    procedure AssertFalse(Value: Boolean);
    procedure AssertEquals(Value1, Value2: Integer); overload;
    procedure AssertEquals(Value1, Value2: String); overload;
    procedure Run;
  end;

  TTestCaseClass = class of TTestCase;

  TTestResultType = (rtOK, rtFail, rtError, rtSkip);

  TTestResult = class(TObject)
  private
    FResultType: TTestResultType;
    FError: Exception;
  public
    constructor Create;
    destructor Destroy; override;
    property ResultType: TTestResultType read FResultType write FResultType;
    property Error: Exception read FError write FError;
  end;

  TTestRunner = class(TObject)
  private
    FTestCaseList: TObjectList<TTestCase>;
    FTestResultList: TObjectList<TTestResult>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTestCase(TestCaseClass: TTestCaseClass);
    function Run(TestCase: TTestCase): TTestResult;
    procedure RunTests; virtual;
  end;

  TTextTestRunner = class(TTestRunner)
  public
    procedure WriteHeader;
    procedure WriteTestResult;
    procedure WriteFooter;
    procedure RunTests; override;
  end;

procedure RunTest;
procedure RegisterTest(TestCaseClass: TTestCaseClass);

var
  TestRunner: TTestRunner;

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
    raise EAssertionError.CreateFmt('%s != True', [BoolToStr(Value, True)])
end;

procedure TTestCase.AssertFalse(Value: Boolean);
begin
  if not (Value = False) then
    raise EAssertionError.CreateFmt('%s != False', [BoolToStr(Value, True)])
end;

procedure TTestCase.AssertEquals(Value1, Value2: Integer);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.CreateFmt('%d != %d', [Value1, Value2])
end;

procedure TTestCase.AssertEquals(Value1, Value2: String);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.CreateFmt('%s != %s', [Value1, Value2])
end;

procedure TTestCase.Run;
begin
end;

{ TestResult }
constructor TTestResult.Create;
begin
  FResultType := rtSkip;
  FError := nil;
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

function TTestRunner.Run(TestCase: TTestCase): TTestResult;
begin
  Result := TTestResult.Create;
  try
    TestCase.Run;
    Result.ResultType := rtOk;
  except
    on E: EAssertionError do
    begin
      Result.ResultType := rtFail;
      Result.Error := E;
    end;
    on E: Exception do
    begin
      Result.ResultType := rtError;
      Result.Error := E;
    end;
  end;
end;

procedure TTestRunner.RunTests;
var
  TestCase: TTestCase;
  TestResult: TTestResult;
begin
  for TestCase in FTestCaseList do
  begin
    TestResult := Run(TestCase);
    FTestResultList.Add(TestResult);
  end;
end;

{ TTextTestRunner }
procedure TTextTestRunner.WriteHeader;
begin
end;

procedure TTextTestRunner.WriteTestResult;
begin
end;

procedure TTextTestRunner.WriteFooter;
begin
  WriteLn(DupeString('-', 70));
  WriteLn('OK');
end;

procedure TTextTestRunner.RunTests;
begin
  inherited RunTests;
  WriteFooter;
end;

procedure RunTest;
begin
  TestRunner.RunTests;
end;

procedure RegisterTest(TestCaseClass: TTestCaseClass);
begin
  TestRunner.AddTestCase(TestCaseClass);
end;

initialization
  TestRunner := TTextTestRunner.Create;

finalization
  FreeAndNil(TestRunner);

end.
