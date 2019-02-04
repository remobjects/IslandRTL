namespace RemObjects.Elements.System;
type
  OleString = public record
  private
    bstr: ^Char;
  protected
    method AllocString(Value: String): ^Char;
    begin
      if assigned(Value) then begin
        {$IFDEF WINDOWS}
        exit rtl.SysAllocStringLen(Value.FirstChar, Value.Length)
        {$ELSE}
        var lData: ^Byte := ^Byte(malloc(Value.Length * 2 + 4));
        ^Int32(lData)^ := length(Value);
        lData := lData + 4;
        memcpy(lData, @Value.fFirstChar, length(Value) * 2);
        exit ^Char(lData);
        {$ENDIF}
      end else
        exit nil;
    end;

    method FreeString(Value : ^Char);
    begin
      if Value <> nil then begin
        {$IFDEF WINDOWS}
        rtl.SysFreeString(Value);
        {$ELSE}
        free(^Void(IntPtr(Value) - 4));
        {$ENDIF}
      end;
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
      else begin
        {$IFDEF WINDOWS}
        exit String.FromPChar(bstr,rtl.SysStringLen(bstr));
        {$ELSE}
        exit String.FromPChar(bstr, ^Integer(bstr)[-1]);
        {$ENDIF}
      end;
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