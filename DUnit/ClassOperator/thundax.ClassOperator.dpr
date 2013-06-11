program thundax.ClassOperator;
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
  thundax.classOperator.example in '..\..\src\ClassOperator\thundax.classOperator.example.pas',
  Testthundax.ClassOperator in 'Testthundax.ClassOperator.pas',
  thundax.logging in '..\..\src\Logging\thundax.logging.pas';

{R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.

