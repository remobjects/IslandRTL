// Elements: every platform and Wine CI entrypoint runs the full shared runtime
// suite and returns its failure status; compiling alone is not a runtime pass.
// Windows pool-guard children run only their selected check, before pool reuse.
namespace RemObjects.Elements.Island.Tests;

interface

uses
  RemObjects.Elements.EUnit;

implementation

begin
  var lRunSuite := true;
  {$IFDEF WINDOWS}
  {$IFNDEF NOTHREADS}
  var lPoolChild: String;
  for each lArgument in Environment.GetCommandLineArgs do
    if (lArgument = Island.Tests.Shared.Parallel_Boundaries.SaturationChildArgument) or
       (lArgument = Island.Tests.Shared.Parallel_Boundaries.CleanupPoolChildArgument) or
       (lArgument = Island.Tests.Shared.Parallel_Boundaries.IdlePoolChildArgument) then
      lPoolChild := lArgument;
  if assigned(lPoolChild) then begin
    lRunSuite := false;
    try
      var lGuard := new Island.Tests.Shared.Parallel_Boundaries;
      case lPoolChild of
        Island.Tests.Shared.Parallel_Boundaries.SaturationChildArgument: lGuard.RunSaturatedPoolGuard(5);
        Island.Tests.Shared.Parallel_Boundaries.CleanupPoolChildArgument: lGuard.RunCleanupPoolGuard(5);
        Island.Tests.Shared.Parallel_Boundaries.IdlePoolChildArgument: lGuard.RunIdlePoolGuard(5);
      end;
      writeLn('Isolated pool guard passed: '+lPoolChild);
      result := 0;
    except
      on e: Exception do begin
        writeLn('Isolated pool guard failed ('+lPoolChild+'): '+e.Message);
        result := 1;
      end;
    end;
  end;
  {$ENDIF}
  {$ENDIF}
  if lRunSuite then begin
    var lTests := Discovery.DiscoverTests();
    result := Runner.RunTests(lTests) withListener(Runner.DefaultListener).ExitCode;
  end;
end.