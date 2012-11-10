unit Nullpobug.UnitTest;

interface

uses
  System.SysUtils
  , System.StrUtils
  , System.Generics.Collections
  , System.Rtti
  , System.Diagnostics
  ;

type
  EAssertionError = class(Exception);
  ESkipTest = class(Exception);

  TTestResultType = (rtOK, rtFail, rtError, rtSkip);

  TTestResult = class(TObject)
  private
    FResultType: TTestResultType;
    FError: Exception;
    FTestMethodName: String;
    FTestCaseName: String;
    FTime: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    property ResultType: TTestResultType read FResultType write FResultType;
    property Error: Exception read FError write FError;
    property TestMethodName: String read FTestMethodName write FTestMethodName;
    property TestCaseName: String read FTestCaseName write FTestCaseName;
    property Time: Int64 read FTime write FTime;
  end;

  TOnRanTestMethod = procedure(TestResult: TTestResult) of object;

  TTestCase = class(TObject)
  private
    FOnRanTestMethod: TOnRanTestMethod;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetUp; virtual;
    procedure TearDown; virtual;
    procedure AssertTrue(Value: Boolean);
    procedure AssertFalse(Value: Boolean);
    procedure AssertEquals(Value1, Value2: Integer); overload;
    procedure AssertEquals(Value1, Value2: String); overload;
    procedure Run(TestResultList: TObjectList<TTestResult>);
    property OnRanTestMethod: TOnRanTestMethod read FOnRanTestMethod write FOnRanTestMethod;
  end;

  TTestCaseClass = class of TTestCase;

  TTestSuite = class(TObject)
  private
    FTestCaseList: TObjectList<TTestCase>;
    FOnRanTestMethod: TOnRanTestMethod;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTestCase(TestCaseClass: TTestCaseClass);
    procedure Run(TestCase: TTestCase; TestResultList: TObjectList<TTestResult>); virtual;
    procedure RunTests(TestResultList: TObjectList<TTestResult>); virtual;
    property OnRanTestMethod: TOnRanTestMethod read FOnRanTestMethod write FOnRanTestMethod;
  end;

  TTestRunner = class(TObject)
  private
    FTestSuiteList: TObjectList<TTestSuite>;
    FTestResultList: TObjectList<TTestResult>;
    FStopWatch: TStopWatch;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTestSuite(TestSuite: TTestSuite);
    procedure Run(TestSuite: TTestSuite); virtual;
    procedure RunTests; virtual;
    property TestResultList: TObjectList<TTestResult> read FTestResultList;
    property StopWatch: TStopWatch read FStopWatch;
  end;

  TTextTestRunner = class(TTestRunner)
  public
    procedure WriteHeader;
    procedure WriteTestResult(TestResult: TTestResult);
    procedure WriteFooter;
    procedure Run(TestSuite: TTestSuite); override;
    procedure RunTests; override;
  end;

procedure RunTest;
procedure RegisterTest(TestCaseClass: TTestCaseClass); overload;
procedure RegisterTest(TestSuite: TTestSuite); overload;

var
  TestRunner: TTestRunner;
  DefaultTestSuite: TTestSuite;

implementation

{ TestResult }
constructor TTestResult.Create;
begin
  FResultType := rtSkip;
  FError := nil;
  FTime := 0;
end;

destructor TTestResult.Destroy;
begin
  FError := nil;
  inherited Destroy;
end;

{ TestCase }
constructor TTestCase.Create;
begin
  FOnRanTestMethod := nil;
end;

destructor TTestCase.Destroy;
begin
  FOnRanTestMethod := nil;
end;

procedure TTestCase.SetUp;
begin
end;

procedure TTestCase.TearDown;
begin
end;

procedure TTestCase.AssertTrue(Value: Boolean);
begin
  if not (Value = True) then
    raise EAssertionError.CreateFmt('%s != True', [BoolToStr(Value, True)]);
end;

procedure TTestCase.AssertFalse(Value: Boolean);
begin
  if not (Value = False) then
    raise EAssertionError.CreateFmt('%s != False', [BoolToStr(Value, True)]);
end;

procedure TTestCase.AssertEquals(Value1, Value2: Integer);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.CreateFmt('%d != %d', [Value1, Value2]);
end;

procedure TTestCase.AssertEquals(Value1, Value2: String);
begin
  if not (Value1 = Value2) then
    raise EAssertionError.CreateFmt('%s != %s', [Value1, Value2]);
end;

procedure TTestCase.Run(TestResultList: TObjectList<TTestResult>);
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Method: TRttiMethod;
  TestResult: TTestResult;
  StopWatch: TStopWatch;
begin
  StopWatch := TStopWatch.Create;
  StopWatch.Start;
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(ClassType);
    for Method in RttiType.GetMethods do
    begin
      if LeftStr(Method.Name, 4) = 'Test' then
      begin
        TestResult := TTestResult.Create;
        TestResult.ResultType := rtOk;
        TestResult.TestMethodName := Method.Name;
        TestResult.TestCaseName := ToString;
        StopWatch.Reset;
        try
          try
            SetUp;
            Method.Invoke(Self, []);
          except
            on E: EAssertionError do
            begin
              TestResult.ResultType := rtFail;
              TestResult.Error := E;
            end;
            on E: ESkipTest do
            begin
              TestResult.ResultType := rtSkip;
              TestResult.Error := E;
            end;
            on E: Exception do
            begin
              TestResult.ResultType := rtError;
              TestResult.Error := E;
            end;
          end;
        finally
          TearDown;
        end;
        TestResult.Time := StopWatch.ElapsedMilliseconds;
        if Assigned(FOnRanTestMethod) then
          FOnRanTestMethod(TestResult);
        TestResultList.Add(TestResult);
      end;
    end;
  finally
    RttiContext.Free;
    FreeAndNil(StopWatch);
  end;
end;

{ TestSuite }
constructor TTestSuite.Create;
begin
  FOnRanTestMethod := nil;
  FTestCaseList := TObjectList<TTestCase>.Create;
end;

destructor TTestSuite.Destroy;
begin
  FOnRanTestMethod := nil;
  FreeAndNil(FTestCaseList);
end;

procedure TTestSuite.AddTestCase(TestCaseClass: TTestCaseClass);
begin
  FTestCaseList.Add(TestCaseClass.Create);
end;

procedure TTestSuite.Run(TestCase: TTestCase; TestResultList: TObjectList<TTestResult>);
begin
  TestCase.OnRanTestMethod := FOnRanTestMethod;
  TestCase.Run(TestResultList);
  TestCase.OnRanTestMethod := nil;
end;

procedure TTestSuite.RunTests(TestResultList: TObjectList<TTestResult>);
var
  TestCase: TTestCase;
begin
  for TestCase in FTestCaseList do
    Run(TestCase, TestResultList);
end;

{ TestRunner }
constructor TTestRunner.Create;
begin
  FTestSuiteList := TObjectList<TTestSuite>.Create;
  FTestResultList := TObjectList<TTestResult>.Create;
  FStopWatch := TStopWatch.Create;
  FStopWatch.Start;
end;

destructor TTestRunner.Destroy;
begin
  FreeAndNil(FStopWatch);
  FreeAndNil(FTestSuiteList);
  FreeAndNil(FTestResultList);
  inherited Destroy;
end;

procedure TTestRunner.AddTestSuite(TestSuite: TTestSuite);
begin
  FTestSuiteList.Add(TestSuite);
end;

procedure TTestRunner.Run(TestSuite: TTestSuite);
begin
  TestSuite.RunTests(TestResultList);
end;

procedure TTestRunner.RunTests;
var
  TestSuite: TTestSuite;
begin
  for TestSuite in FTestSuiteList do
    Run(TestSuite);
end;

{ TTextTestRunner }
procedure TTextTestRunner.WriteHeader;
begin
end;

procedure TTextTestRunner.WriteTestResult(TestResult: TTestResult);
var
  ResultMark: String;
begin
  case TestResult.ResultType of
    rtOK: ResultMark := '.';
    rtFail: ResultMark := 'F';
    rtError: ResultMark := 'E';
    rtSkip: ResultMark := 'S';
  else
    ResultMark := '?';
  end;
  Write(ResultMark);
end;

procedure TTextTestRunner.WriteFooter;
var
  Seconds: Single;
begin
  Seconds := StopWatch.ElapsedMilliseconds / 1000;
  WriteLn('');
  WriteLn(DupeString('-', 70));
  WriteLn(Format('Ran %d tests in %.3fs', [TestResultList.Count, Seconds]));
  WriteLn('');
  WriteLn('OK');
end;

procedure TTextTestRunner.Run(TestSuite: TTestSuite);
begin
  TestSuite.OnRanTestMethod := WriteTestResult;
  inherited Run(TestSuite);
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
  if DefaultTestSuite = nil then
  begin
    DefaultTestSuite := TTestSuite.Create;
    TestRunner.AddTestSuite(DefaultTestSuite);
  end;
  DefaultTestSuite.AddTestCase(TestCaseClass);
end;

procedure RegisterTest(TestSuite: TTestSuite);
begin
  TestRunner.AddTestSuite(TestSuite);
end;

initialization
  TestRunner := TTextTestRunner.Create;
  DefaultTestSuite := nil;

finalization
  DefaultTestSuite := nil;
  FreeAndNil(TestRunner);

end.
