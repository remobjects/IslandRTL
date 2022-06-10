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

    class method GetBits<T>(value: T): array of Byte;
    begin
      //(120, 86, 52, 18) -> 0x12345678 -> 10010001101000101011001111000b
      CheckTypeCode(typeOf(T).Code);
      var y := sizeOf(T);
      var x:= new array of Byte(y*8);
      if (IsLittleEndian) then begin
        for i:Integer := 0 to y-1 do begin
          x[8*i+7]:= ^Byte(@value)[y-1-i] and 1;
          x[8*i+6]:= (^Byte(@value)[y-1-i] and (1 shl 1)) shr 1;
          x[8*i+5]:= (^Byte(@value)[y-1-i] and (1 shl 2)) shr 2;
          x[8*i+4]:= (^Byte(@value)[y-1-i] and (1 shl 3)) shr 3;
          x[8*i+3]:= (^Byte(@value)[y-1-i] and (1 shl 4)) shr 4;
          x[8*i+2]:= (^Byte(@value)[y-1-i] and (1 shl 5)) shr 5;
          x[8*i+1]:= (^Byte(@value)[y-1-i] and (1 shl 6)) shr 6;
          x[8*i]:= (^Byte(@value)[y-1-i] and (1 shl 7)) shr 7; 
        end;
      end
      else begin
        for i:Integer := 0 to y-1 do begin
          x[8*i+7]:= ^Byte(@value)[i] and 1;
          x[8*i+6]:= (^Byte(@value)[i] and (1 shl 1)) shr 1;
          x[8*i+5]:= (^Byte(@value)[i] and (1 shl 2)) shr 2;
          x[8*i+4]:= (^Byte(@value)[i] and (1 shl 3)) shr 3;
          x[8*i+3]:= (^Byte(@value)[i] and (1 shl 4)) shr 4;
          x[8*i+2]:= (^Byte(@value)[i] and (1 shl 5)) shr 5;
          x[8*i+1]:= (^Byte(@value)[i] and (1 shl 6)) shr 6;
          x[8*i]:= (^Byte(@value)[i] and (1 shl 7)) shr 7;
        end;
      end;
      exit x;
    end;


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