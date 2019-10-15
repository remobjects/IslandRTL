namespace RemObjects.Elements.System;

type
  BitConverter = public static class
  private 
    method CheckTypeCode(Code: TypeCodes);
    begin
      if Code in [TypeCodes.Boolean..TypeCodes.UIntPtr] then exit;
      raise new Exception('only simple integer/float types and Char/Boolean are supported');
    end;
  public
    class var IsLittleEndian: Boolean;

    class method GetBytes<T>(value: T): array of Byte;
    begin
      CheckTypeCode(typeOf(T).Code);
      var y := sizeOf(T);
      var x:= new array of Byte(y);
      if (IsLittleEndian) then begin
        for i:Integer := 0 to y-1 do
          x[i]:= ^Byte(@value)[y-1-i];
      end
      else begin
        for i:Integer := 0 to y-1 do
          x[i]:= ^Byte(@value)[i];
      end;
      exit x;
    end;
    class method ToValue<T>(value: array of Byte): T;
    begin
      CheckTypeCode(typeOf(T).Code);
      If (sizeOf(T)<>value.Length) then raise new Exception("Invalid array length");
      if IsLittleEndian then begin
        for i:Integer := 0 to value.Length-1 do
          ^Byte(@result)[i] := value[value.Length-1-i];
        end else begin
      for i:Integer := 0 to value.Length-1 do
        ^Byte(@result)[i] := value[i];
      end;
    end;
    class method DoubleToInt64Bits(value: Double): Int64;
    begin
      If (typeOf(value)<>typeOf(Double)) then raise new Exception("Invalid value type");
      if IsLittleEndian then begin
        for i:Integer :=0 to 7 do
          ^Byte(@result)[i] := ^Byte(@value)[7-i];
      end
      else begin
        for i:Integer :=0 to 7 do
          ^Byte(@result)[i] := ^Byte(@value)[i];
      end;
    end;
    class method Int64BitsToDouble(value: Int64): Double;
    begin
      If (typeOf(value)<>typeOf(Int64)) then raise new Exception("Invalid value type");
      if IsLittleEndian then begin
      for i:Integer :=0 to 7 do
        ^Byte(@result)[i] := ^Byte(@value)[7-i];
        end
      else begin
        for i:Integer :=0 to 7 do
          ^Byte(@result)[i] := ^Byte(@value)[i];
      end;
    end;
    class method ToString(value: array of Byte; startIndex: Integer :=0; length: Integer:=(-1)): String;
    begin
      var z:String:='0123456789ABCDEF';
      var l:=iif(length=-1, value.Length, (length+startIndex));
      var s:StringBuilder:=new StringBuilder();
      if IsLittleEndian then begin
        for i:Integer := l-1 downto startIndex do begin
          s.Append(z[value[i] shr 4]);
          s.Append(z[value[i] and $0F]);
          if (i<>startIndex) then s.Append('-');
        end;
      end
      else begin
        for i:Integer := startIndex to l-1 do begin
          s.Append(z[value[i] shr 4]);  //10001111b  shr 4 => 00001000b
          s.Append(z[value[i] and $0F]);//10001001b  and 00001111b => 00001001b
          if (i<>l-1) then s.Append('-');
        end;
      end;
      result := s.ToString();
    end;
  end;
end.