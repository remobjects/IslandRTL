namespace RemObjects.Elements.System;


type
  Guid = public record
  public
    Data1: UInt32;
    Data2: UInt16;
    Data3: UInt16;
    Data4_0: Byte;
    Data4_1: Byte;
    Data4_2: Byte;
    Data4_3: Byte;
    Data4_4: Byte;
    Data4_5: Byte;
    Data4_6: Byte;
    Data4_7: Byte;
  public

    constructor(Value: array of Byte);
    begin
      if Value = nil then new Exception('Value is nil');
      if Value.Length <> 16 then new Exception('Value should be 16 bytes long.');
      Data1 := UInt32(Value[3]) shl 24 + UInt32(Value[2]) shl 16 + UInt32(Value[1]) shl 8 + UInt32(Value[0]);
      Data2 := UInt16(Value[5]) shl 8 + UInt16(Value[4]);
      Data3 := UInt16(Value[7]) shl 8 + UInt16(Value[6]);
      Data4_0 := Value[8];
      Data4_1 := Value[9];
      Data4_2 := Value[10];
      Data4_3 := Value[11];
      Data4_4 := Value[12];
      Data4_5 := Value[13];
      Data4_6 := Value[14];
      Data4_7 := Value[15];
    end;

    constructor(Value: String);
    begin
      //0---------1---------2---------3-----
      //012345678901234567890123456789012345
      //xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
      if (Value.Length = 38) and (Value[0] = '{') and (Value[37] = '}') then Value := Value.Substring(1, 36);
      if not((Value.Length = 36) and (Value[8] = '-') and (Value[13] = '-') and (Value[18] = '-') and (Value[23] = '-')) then new Exception('Wrong guid');
      Data1 := Convert.HexStringToUInt64(Value.Substring(0,8));
      Data2 := Convert.HexStringToUInt64(Value.Substring(9,4));
      Data3 := Convert.HexStringToUInt64(Value.Substring(14,4));
      Data4_0 := Convert.HexStringToUInt64(Value.Substring(19,2));
      Data4_1 := Convert.HexStringToUInt64(Value.Substring(21,2));
      Data4_2 := Convert.HexStringToUInt64(Value.Substring(24,2));
      Data4_3 := Convert.HexStringToUInt64(Value.Substring(26,2));
      Data4_4 := Convert.HexStringToUInt64(Value.Substring(28,2));
      Data4_5 := Convert.HexStringToUInt64(Value.Substring(30,2));
      Data4_6 := Convert.HexStringToUInt64(Value.Substring(32,2));
      Data4_7 := Convert.HexStringToUInt64(Value.Substring(34,2));
    end;

    method ToString: String; override;
    begin
      exit
        Convert.UInt64ToHexString(Data1,8)+'-'+
        Convert.UInt64ToHexString(Data2,4)+'-'+
        Convert.UInt64ToHexString(Data3,4)+'-'+
        Convert.UInt64ToHexString(Data4_0,2)+
        Convert.UInt64ToHexString(Data4_1,2)+'-'+
        Convert.UInt64ToHexString(Data4_2,2)+
        Convert.UInt64ToHexString(Data4_3,2)+
        Convert.UInt64ToHexString(Data4_4,2)+
        Convert.UInt64ToHexString(Data4_5,2)+
        Convert.UInt64ToHexString(Data4_6,2)+
        Convert.UInt64ToHexString(Data4_7,2);
    end;

    method ToString(Format: String): String;
    begin
      if String.IsNullOrEmpty(Format) then exit ToString('D');
      case Format of
        'N': begin
          exit
            Convert.UInt64ToHexString(Data1,8)+
            Convert.UInt64ToHexString(Data2,4)+
            Convert.UInt64ToHexString(Data3,4)+
            Convert.UInt64ToHexString(Data4_0,2)+
            Convert.UInt64ToHexString(Data4_1,2)+
            Convert.UInt64ToHexString(Data4_2,2)+
            Convert.UInt64ToHexString(Data4_3,2)+
            Convert.UInt64ToHexString(Data4_4,2)+
            Convert.UInt64ToHexString(Data4_5,2)+
            Convert.UInt64ToHexString(Data4_6,2)+
            Convert.UInt64ToHexString(Data4_7,2);
        end;
        'D': begin
          exit
            Convert.UInt64ToHexString(Data1,8)+'-'+
            Convert.UInt64ToHexString(Data2,4)+'-'+
            Convert.UInt64ToHexString(Data3,4)+'-'+
            Convert.UInt64ToHexString(Data4_0,2)+
            Convert.UInt64ToHexString(Data4_1,2)+'-'+
            Convert.UInt64ToHexString(Data4_2,2)+
            Convert.UInt64ToHexString(Data4_3,2)+
            Convert.UInt64ToHexString(Data4_4,2)+
            Convert.UInt64ToHexString(Data4_5,2)+
            Convert.UInt64ToHexString(Data4_6,2)+
            Convert.UInt64ToHexString(Data4_7,2);
        end;
        'B': begin
          exit '{'+
            Convert.UInt64ToHexString(Data1,8)+'-'+
            Convert.UInt64ToHexString(Data2,4)+'-'+
            Convert.UInt64ToHexString(Data3,4)+'-'+
            Convert.UInt64ToHexString(Data4_0,2)+
            Convert.UInt64ToHexString(Data4_1,2)+'-'+
            Convert.UInt64ToHexString(Data4_2,2)+
            Convert.UInt64ToHexString(Data4_3,2)+
            Convert.UInt64ToHexString(Data4_4,2)+
            Convert.UInt64ToHexString(Data4_5,2)+
            Convert.UInt64ToHexString(Data4_6,2)+
            Convert.UInt64ToHexString(Data4_7,2)+
            '}';
        end;
        'P': begin
          exit '('+
            Convert.UInt64ToHexString(Data1,8)+'-'+
            Convert.UInt64ToHexString(Data2,4)+'-'+
            Convert.UInt64ToHexString(Data3,4)+'-'+
            Convert.UInt64ToHexString(Data4_0,2)+
            Convert.UInt64ToHexString(Data4_1,2)+'-'+
            Convert.UInt64ToHexString(Data4_2,2)+
            Convert.UInt64ToHexString(Data4_3,2)+
            Convert.UInt64ToHexString(Data4_4,2)+
            Convert.UInt64ToHexString(Data4_5,2)+
            Convert.UInt64ToHexString(Data4_6,2)+
            Convert.UInt64ToHexString(Data4_7,2)+
            ')';
        end;
        'X': begin
          exit '{'+
            '0x'+Convert.UInt64ToHexString(Data1,8)+','+
            '0x'+Convert.UInt64ToHexString(Data2,4)+','+
            '0x'+Convert.UInt64ToHexString(Data3,4)+','+
           '{0x'+Convert.UInt64ToHexString(Data4_0,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_1,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_2,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_3,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_4,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_5,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_6,2)+','+
            '0x'+Convert.UInt64ToHexString(Data4_7,2)+ '}}';
        end;
        else
          raise new Exception('Invalid format string.')
        end;
    end;


    method ToByteArray: array of Byte;
    begin
      result := new array of Byte(16);
      result[0] := (Data1 and $000000FF);
      result[1] := (Data1 and $0000FF00) shr 8;
      result[2] := (Data1 and $00FF0000) shr 16;
      result[3] := (Data1 and $FF000000) shr 24;
      result[4] := (Data2 and $00FF);
      result[5] := (Data2 and $FF00) shr 8;
      result[6] := (Data3 and $00FF);
      result[7] := (Data3 and $FF00) shr 8;
      result[8] := Data4_0;
      result[9] := Data4_1;
      result[10] := Data4_2;
      result[11] := Data4_3;
      result[12] := Data4_4;
      result[13] := Data4_5;
      result[14] := Data4_6;
      result[15] := Data4_7;
    end;

    class method &Empty: Guid;
    begin
      exit new Guid;
    end;

    class method NewGuid: Guid;
    begin
      {$IFDEF WINDOWS}
      var lg: rtl.GUID;
      if rtl.CoCreateGuid(@lg) = rtl.S_OK then begin
        var r := new Guid;
        r.Data1 := lg.Data1;
        r.Data2 := lg.Data2;
        r.Data3 := lg.Data3;
        r.Data4_0 := lg.Data4[0];
        r.Data4_1 := lg.Data4[1];
        r.Data4_2 := lg.Data4[2];
        r.Data4_3 := lg.Data4[3];
        r.Data4_4 := lg.Data4[4];
        r.Data4_5 := lg.Data4[5];
        r.Data4_6 := lg.Data4[6];
        r.Data4_7 := lg.Data4[7];
        exit r;
      end;
      {$ELSEIF Posix}
      var data := new Byte[16];
      Random.CryptoSafeRandom(data, 0, 16);
      data[6] := (data[6] and $0F) or 64; // version 4
      data[8] := data[8] or $80; // variant
      rtl.memcpy(@result, @data[0], 16);
      {$ELSEIF webassembly}
      var data := new Byte[16];
      WebAssemblyCalls.CryptoSafeRandom(@data[0], 16);
      data[6] := (data[6] and $0F) or 64; // version 4
      data[8] := data[8] or $80; // variant
      memcpy(@result, @data[0], 16);
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method Parse(Value: String): Guid;
    begin
      exit new Guid(Value);
    end;

    class method TryParse(Value: String; out aResult: Guid):Boolean;
    begin
      try
        aResult := new Guid(Value);
        exit true;
      except
        exit false;
      end;
    end;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is Guid) then
        exit self = Guid(obj)
      else if assigned(obj) and (obj is rtl.GUID) then
        exit self = rtl.Guid(obj)
      else
        exit False;
    end;

    class operator Equal(Value1, Value2: Guid): Boolean;
    begin
      exit (Value1.Data1 = Value2.Data1) and
           (Value1.Data2 = Value2.Data2) and
           (Value1.Data3 = Value2.Data3) and
           (Value1.Data4_0 = Value2.Data4_0) and
           (Value1.Data4_1 = Value2.Data4_1) and
           (Value1.Data4_2 = Value2.Data4_2) and
           (Value1.Data4_3 = Value2.Data4_3) and
           (Value1.Data4_4 = Value2.Data4_4) and
           (Value1.Data4_5 = Value2.Data4_5) and
           (Value1.Data4_6 = Value2.Data4_6) and
           (Value1.Data4_7 = Value2.Data4_7);
    end;

    class operator NotEqual(Value1, Value2: Guid): Boolean;
    begin
      exit not (Value1 = Value2);
    end;
    {$IFDEF WINDOWS}
    class operator Equal(Value1: rtl.GUID; Value2: Guid): Boolean;
    begin
      exit (Value1.Data1 = Value2.Data1) and
           (Value1.Data2 = Value2.Data2) and
           (Value1.Data3 = Value2.Data3) and
           (Value1.Data4[0] = Value2.Data4_0) and
           (Value1.Data4[1] = Value2.Data4_1) and
           (Value1.Data4[2] = Value2.Data4_2) and
           (Value1.Data4[3] = Value2.Data4_3) and
           (Value1.Data4[4] = Value2.Data4_4) and
           (Value1.Data4[5] = Value2.Data4_5) and
           (Value1.Data4[6] = Value2.Data4_6) and
           (Value1.Data4[7] = Value2.Data4_7);
    end;
    class operator Equal(Value2: Guid; Value1: rtl.GUID): Boolean;
    begin
      exit (Value1 = Value2);
    end;
    class operator NotEqual(Value1: rtl.GUID; Value2: Guid): Boolean;
    begin
      exit not (Value1 = Value2);
    end;
    class operator NotEqual(Value1: Guid; Value2: rtl.GUID): Boolean;
    begin
      exit not (Value2 = Value1);
    end;
    class operator Implicit(val: rtl.GUID): Guid;
    begin
      memcpy(@result, @val, 16);
    end;

    class operator Implicit(val: Guid): rtl.GUID;
    begin
      memcpy(@result, @val, 16);
    end;
    {$ENDIF}
  end;

end.