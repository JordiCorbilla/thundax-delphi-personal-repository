program thundax.Refactoring_10;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  thundax.refactoring.example in '..\..\src\Refactoring\thundax.refactoring.example.pas',
  Testthundax.refactoring in 'Testthundax.refactoring.pas';

{$R *.RES}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := true;
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.

