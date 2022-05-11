namespace RemObjects.Elements.System;

[Assembly: RemObjects.Elements.System.LifetimeStrategyOverrideAttribute(typeOf(rtl.winrt.HSTRING), typeOf(HString_Helper))]

type
  [CallingConvention(CallingConvention.Stdcall)]
  DeleteStringSig = function(str: rtl.winrt.HSTRING): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  CreateStringSig = function(source: ^Char; len: UInt32; str: ^rtl.winrt.HSTRING): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  DuplicateStringSig = function(str: rtl.winrt.HSTRING; str2: ^rtl.winrt.HSTRING): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  GetStringBufferStringSig = function(str: rtl.winrt.HSTRING; len: ^UInt32): ^Char;
  HString_Helper = public record
  assembly
    fStr: rtl.winrt.HSTRING;
    class var fDeleteString: DeleteStringSig;
    class var fCreateString: CreateStringSig;
    class var fDuplicatestring: DuplicateStringSig;
    class var fGetStringBuffer: GetStringBufferStringSig;
  protected
  public
    class constructor;
    begin
      var lLibrary := rtl.LoadLibrary('api-ms-win-core-winrt-string-l1-1-0.dll');
      if lLibrary = nil then raise new Exception('HString requires Windows 8+');
      fDeleteString := DeleteStringSig(rtl.GetProcAddress(lLibrary, 'WindowsDeleteString'));
      fCreateString := CreateStringSig(rtl.GetProcAddress(lLibrary, 'WindowsCreateString'));
      fDuplicatestring := DuplicateStringSig(rtl.GetProcAddress(lLibrary, 'WindowsDuplicateString'));
      fGetStringBuffer := GetStringBufferStringSig(rtl.GetProcAddress(lLibrary, 'WindowsGetStringRawBuffer'));
    end;

    constructor;
    begin
      fStr := nil;
    end;

    constructor Copy(var aValue: HString_Helper);
    begin
      if aValue.fStr = nil then
        fStr := nil
      else
        fDuplicatestring(aValue.fStr, @fStr);
    end;


    class operator Assign(var aDest: HString_Helper; var aSource: HString_Helper);
    begin
      if (@aDest) = (@aSource) then exit;
      if aDest.fStr <> nil then
        fDeleteString(aDest.fStr);
      if aSource.fStr = nil then begin
        aDest.fStr := nil;
      end else
        fDuplicatestring(aSource.fStr, @aDest.fStr);
    end;

    finalizer;
    begin
      if fStr <> nil then
        fDeleteString(fStr);
      fStr := nil;
    end;
  end;

operator Implicit(s: rtl.winrt.HSTRING): String; public;
begin
  if s = nil then exit nil;
  var len: UInt32;
  exit String.FromPChar(HString_Helper.fGetStringBuffer(s, @len), len);
end;

operator Implicit(s: String): rtl.winrt.HSTRING; public;
begin
  var lFirst := @s.fFirstChar;
  var lLength := s.Length;
  var lResult: rtl.winrt.HSTRING;
  HString_Helper.fCreatestring(lFirst, lLength, @lResult);
  exit lResult;
end;

operator Implicit(s: ^rtl.WCHAR): rtl.winrt.HSTRING; public;
begin
  HString_Helper.fCreatestring(s, ExternalCalls.wcslen(s), @result);
end;

end.