namespace RemObjects.Elements.System;

interface

method CreateWinrtInstance(aName: String): rtl.winrt.IInspectable; public;
method CreateWinrtFactory(aName: String; var aGUID: Guid): ^Void; public;

implementation

const
  winrtcore = 'api-ms-win-core-winrt-l1-1-0.dll';

[DelayLoadDllImport(winrtcore, 'RoActivateInstance'), CallingConvention(CallingConvention.Stdcall)]
method RoActivateInstance(activatableClassId: rtl.winrt.HSTRING; instance: ^rtl.winrt.IInspectable): rtl.HRESULT; external;

[DelayLoadDllImport(winrtcore, 'RoGetActivationFactory'), CallingConvention(CallingConvention.Stdcall)]
method RoGetActivationFactory(activatableClassId: rtl.winrt.HSTRING; iid: ^rtl.GUID; factory: ^^Void): rtl.HRESULT; external;

method CreateWinrtInstance(aName: String): rtl.winrt.IInspectable;
begin
  var lname: rtl.winrt.HSTRING := aName;
  var lresult := RoActivateInstance(lname, @result);
  if lresult <> rtl.S_OK then
    raise new Exception("error at calling RoActivateInstance, code: " + lresult.ToString);
end;

method CreateWinrtFactory(aName: String; var aGUID: Guid): ^Void;
begin
  var lname: rtl.winrt.HSTRING := aName;
  var lguid: rtl.GUID := aGUID;
  var lresult := RoGetActivationFactory(lname, @lguid, @result);
  if lresult <> rtl.S_OK then
    raise new Exception("error at calling RoGetActivationFactory, code: " + lresult.ToString);
end;

end.