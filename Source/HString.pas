namespace RemObjects.Elements.System;

[Assembly: RemObjects.Elements.System.LifetimeStrategyOverrideAttribute(typeOf(rtl.winrt.HSTRING), typeOf(HString_Helper))]

type
  HString_Helper = public record
  private
    fStr: rtl.winrt.HSTRING;
  protected
  public
    constructor;
    begin 
      fStr := nil;
    end;
    
    constructor Copy(var aValue: HString_Helper);
    begin 
      if aValue.fStr = nil then 
        fStr := nil 
      else 
        rtl.winrt.WindowsDuplicateString(aValue.fStr, @fStr);
    end;

    
    class operator Assign(var aDest: HString_Helper; var aSource: HString_Helper);
    begin
      if (@aDest) = (@aSource) then exit;
      if aDest.fStr <> nil then 
        rtl.winrt.WindowsDeleteString(aDest.fStr);
      if aSource.fStr = nil then begin 
        aDest.fStr := nil;
      end else 
        rtl.winrt.WindowsDuplicateString(aDest.fStr, @aSource.fStr);
    end;
    
    finalizer;
    begin 
      if fStr <> nil then 
        rtl.winrt.WindowsDeleteString(fStr);
      fStr := nil;
    end;
  end;
  
operator Implicit(s: rtl.winrt.HSTRING): String; public;
begin
  if s = nil then exit nil;
  var len: UInt32;
  exit String.FromPChar(rtl.winrt.WindowsGetStringRawBuffer(s, @len), len);
end;

operator Implicit(s: String): rtl.winrt.HSTRING; public;
begin
  rtl.winrt.WindowsCreateString(@s.fFirstChar, s.Length, @result);
end;

operator Implicit(s: ^Char): rtl.winrt.HSTRING; public;
begin
  rtl.winrt.WindowsCreateString(s, ExternalCalls.wcslen(s), @result);
end;
  
end.