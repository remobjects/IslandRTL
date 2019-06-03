namespace RemObjects.Elements.System;
type
  OleString = public record
  private
    bstr: ^Char;
  protected
    class method AllocString(Value: String): ^Char;
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

    class method AllocString(aLength: Integer): ^Char;
    begin
        {$IFDEF WINDOWS}
        exit rtl.SysAllocStringLen(nil, aLength)
        {$ELSE}
        var lData: ^Byte := ^Byte(malloc(Value.Length * 2 + 4));
        ^Int32(lData)^ := aLength;
        lData := lData + 4;
        exit ^Char(lData);
        {$ENDIF}
    end;

    class method FreeString(Value : ^Char);
    begin
      if Value <> nil then begin
        {$IFDEF WINDOWS}
        rtl.SysFreeString(Value);
        {$ELSE}
        free(^Void(IntPtr(Value) - 4));
        {$ENDIF}
      end;
    end;

    class method DuplicateString(aSource: OleString; var aDest: OleString);
    begin 
      aDest.bstr := AllocString(aSource.Length);
      memcpy(aDest.bstr,  aSource.bstr, aSource.Length);
    end;
  public
    constructor(Value: String);
    begin
      bstr := AllocString(Value);
    end;

    
    constructor Copy(var aValue: OleString);
    begin
      if aValue.bstr = nil then
        bstr := nil
      else
        DuplicateString(aValue, var self);
    end;


    class operator Assign(var aDest: OleString; var aSource: OleString);
    begin
      if (@aDest) = (@aSource) then exit;
      if aDest.bstr <> nil then
        FreeString(aDest.bstr);
      if aSource.bstr = nil then begin
        aDest.bstr := nil;
      end else
        DuplicateString(aDest, var aSource);
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

    method get_Length: Integer;
    begin
      if self.bstr = nil then exit 0;
      {$IFDEF WINDOWS}
        exit rtl.SysStringByteLen(self.bstr);
      {$ELSE}
        exit ^Integer(bstr)[-1];
      {$ENDIF}
    end;
    property Item[I: Integer]: Char read bstr[I] write bstr[i];
    property Length: Integer read get_Length;
  end;

  String_OleStringSupport = public extension class(String)
  public
    class operator Implicit(Value: OleString): String;
    begin
      exit Value.ToString;
    end;
  end;

end.