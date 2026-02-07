namespace RemObjects.Elements.Island.Tests;

interface

uses
  RemObjects.Elements.EUnit;

implementation

begin
  var lTests := Discovery.DiscoverTests();
  result := Runner.RunTests(lTests) withListener(Runner.DefaultListener).ExitCode;
end.