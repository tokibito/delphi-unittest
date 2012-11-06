program TestProject;

{$APPTYPE CONSOLE}

uses
  Nullpobug.UnitTest in '..\Nullpobug.UnitTest.pas'
  , MyUnit1Test in 'MyUnit1Test.pas'
  , MyUnit2Test in 'MyUnit2Test.pas'
  ;

begin
  Nullpobug.UnitTest.RunTest;
end.
