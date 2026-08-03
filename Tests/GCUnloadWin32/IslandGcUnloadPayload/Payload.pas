namespace IslandGcUnloadPayload;

interface

uses
  RemObjects.Elements.System;

type
  PayloadObject = public class
  public
    property Value: Integer;
  end;

[DllExport, SymbolName('InitializeIslandOnWorker'), CallingConvention(CallingConvention.Stdcall)]
method InitializeIslandOnWorker: Integer; public;

implementation

method InitializeIslandOnWorker: Integer;
begin
  for i: Integer := 0 to 999 do begin
    var value := new PayloadObject(Value := i);
    if value.Value = -1 then
      raise new Exception('unreachable');
  end;
  result := 1;
end;

end.
