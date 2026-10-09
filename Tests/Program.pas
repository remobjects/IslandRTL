// Elements: every platform and Wine CI entrypoint runs the full shared runtime
// suite and returns its failure status; compiling alone is not a runtime pass.
namespace RemObjects.Elements.Island.Tests;

interface

uses
  RemObjects.Elements.EUnit;

implementation

begin
  var lTests := Discovery.DiscoverTests();
  result := Runner.RunTests(lTests) withListener(Runner.DefaultListener).ExitCode;
end.