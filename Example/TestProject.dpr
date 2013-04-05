program TestProject;

{$APPTYPE CONSOLE}

uses
  Nullpobug.UnitTest in '..\Source\Nullpobug.UnitTest.pas'
  , MyUnit1Test in 'MyUnit1Test.pas'
  , MyUnit2Test in 'MyUnit2Test.pas'
  ;

begin
  ReportMemoryLeaksOnShutdown := True;
  Nullpobug.UnitTest.RunTest('TestProject.xml');
end.
