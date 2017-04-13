namespace RemObjects.Elements.System;
type
  OleString = public record
  private
    bstr: ^Char;
  protected
    method AllocString(Value: String): ^Char;
    begin
      if assigned(Value) then
        exit rtl.SysAllocStringLen(Value.FirstChar, Value.Length)
      else
        exit nil;
    end;

    method FreeString(Value : ^Char);
    begin
      if Value <> nil then rtl.SysFreeString(Value);
    end;
  public
    constructor(Value: String);
    begin
      bstr := AllocString(Value);
    end;

    finalizer;
    begin
      FreeString(bstr);
    end;

    method ToString: String; override;
    begin
      if bstr = nil then
        exit nil
      else
        exit String.FromPChar(bstr,rtl.SysStringLen(bstr));
    end;

    method GetHashCode: Integer; override;
    begin
      exit ToString().GetHashCode;
    end;

    method &Equals(Value: OleString): Boolean;
    begin
      exit ToString = Value.ToString;
    end;

    class operator Implicit(Value: String): OleString;
    begin
      if assigned(Value) then
        exit new OleString(Value)
      else
        exit default(OleString);
    end;
  end;

  String_OleStringSupport = public extension class(String)
  public
    class operator Implicit(Value: OleString): String;
    begin
      exit Value.ToString;
    end;
  end;

end.