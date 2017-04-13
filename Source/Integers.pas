namespace RemObjects.Elements.System;

interface

type
  SByte = public record
  private
    class method DoTryParse(s: String; out Value: SByte; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue : Int64;
      if not Convert.TryParseInt64(s,out sValue, aRaiseOverflowException) then exit False;
      if sValue >= 0 then begin
        if sValue > MaxValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end
      else begin
        if sValue < MinValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end;
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is SByte) then
        exit self = SByte(obj)
      else
        exit False;
    end;

    class method Parse(s: String): SByte;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: SByte):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: SByte = $80;
    const MaxValue: SByte = $7f;
  end;

  Byte = public record
  private
    class method DoTryParse(s: String; out Value: Byte; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue: UInt64;
      if not Convert.TryParseUInt64(s,out sValue, aRaiseOverflowException) then exit False;
      if sValue > MaxValue then
        if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is Byte) then
        exit self = Byte(obj)
      else
        exit False;
    end;

    class method Parse(s: String): Byte;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: Byte):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: Byte = $0;
    const MaxValue: Byte = $ff;
  end;

  Int16 = public record
  private
    class method DoTryParse(s: String; out Value: Int16; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue : Int64;
      if not Convert.TryParseInt64(s,out sValue, aRaiseOverflowException) then exit False;
      if sValue >= 0 then begin
        if sValue > MaxValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end
      else begin
        if sValue < MinValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end;
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is Int16) then
        exit self = Int16(obj)
      else
        exit False;
    end;

    class method Parse(s: String): Int16;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: Int16):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: Int16 = $8000;
    const MaxValue: Int16 = $7fff;
  end;

  UInt16 = public record
  private
    class method DoTryParse(s: String; out Value: UInt16; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue: UInt64;
      if not Convert.TryParseUInt64(s,out sValue, aRaiseOverflowException) then exit False;
      if sValue > MaxValue then
        if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is UInt16) then
        exit self = UInt16(obj)
      else
        exit False;
    end;

    class method Parse(s: String): UInt16;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: UInt16):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: UInt16 = $0;
    const MaxValue: UInt16 = $ffff;
  end;

  Int32 = public record
  private
    class method DoTryParse(s: String; out Value: Int32; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue : Int64;
      if not Convert.TryParseInt64(s,out sValue, aRaiseOverflowException) then exit False;
      if sValue >= 0 then begin
        if sValue > MaxValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end
      else begin
        if sValue < MinValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end;
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is Int32) then
        exit self = Int32(obj)
      else
        exit False;
    end;

    class method Parse(s: String): Int32;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: Int32):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: Int32 = $80000000;
    const MaxValue: Int32 = $7fffffff;
  end;

  UInt32 = public record
  private
    class method DoTryParse(s: String; out Value: UInt32; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue: UInt64;
      if not Convert.TryParseUInt64(s,out sValue, aRaiseOverflowException) then exit False;
      if sValue > MaxValue then
        if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is UInt32) then
        exit self = UInt32(obj)
      else
        exit False;
    end;

    class method Parse(s: String): UInt32;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: UInt32):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: UInt32 = 0;
    const MaxValue: UInt32 = $ffffffff;
  end;

  Int64 = public record
  private
    class method DoTryParse(s: String; out Value: Int64; aRaiseOverflowException: Boolean):Boolean;
    begin
      exit Convert.TryParseInt64(s,out Value, aRaiseOverflowException);
    end;

  public
    method ToString: String; override;
    method GetHashCode: Integer; override;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is Int64) then
        exit self = Int64(obj)
      else
        exit False;
    end;

    class method Parse(s: String): Int64;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: Int64):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: Int64 = $8000000000000000;
    const MaxValue: Int64 = $7fffffffffffffff;
  end;

  UInt64 = public record
  private
    class method DoTryParse(s: String; out Value: UInt64; aRaiseOverflowException: Boolean):Boolean;
    begin
      exit Convert.TryParseUInt64(s,out Value, aRaiseOverflowException);
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is UInt64) then
        exit self = UInt64(obj)
      else
        exit False;
    end;

    class method Parse(s: String): UInt64;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: UInt64):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: UInt64 = $0;
    const MaxValue: UInt64 = $ffffffffffffffff;
  end;

  NativeInt = public record
  private
    class method DoTryParse(s: String; out Value: NativeInt; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue : Int64;
      if not Convert.TryParseInt64(s,out sValue, aRaiseOverflowException) then exit False;
      {$IFNDEF cpu64}
      if sValue >= 0 then begin
        if sValue > MaxValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end
      else begin
        if sValue < MinValue then
          if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      end;
      {$ENDIF}
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is NativeInt) then
        exit self = NativeInt(obj)
      else
        exit False;
    end;

    class method Parse(s: String): NativeInt;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: NativeInt):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: NativeInt = {$IFDEF cpu64}$8000000000000000{$ELSE}$80000000{$ENDIF};
    const MaxValue: NativeInt = {$IFDEF cpu64}$7fffffffffffffff{$ELSE}$7fffffff{$ENDIF};
  end;

  NativeUInt = public record
  private
    class method DoTryParse(s: String; out Value: NativeUInt; aRaiseOverflowException: Boolean):Boolean;
    begin
      var sValue: UInt64;
      if not Convert.TryParseUInt64(s,out sValue, aRaiseOverflowException) then exit False;
      {$IFNDEF cpu64}
      if sValue > MaxValue then
        if aRaiseOverflowException then Convert.RaiseOverflowException else exit False;
      {$ENDIF}
      Value := sValue;
      exit True;
    end;
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is NativeUInt) then
        exit self = NativeUInt(obj)
      else
        exit False;
    end;

    class method Parse(s: String): NativeUInt;
    begin
      if not DoTryParse(s, out result, true) then Convert.RaiseFormatException;
    end;

    class method TryParse(s: String; out Value: NativeUInt):Boolean;
    begin
      exit DoTryParse(s, out Value, false);
    end;

    const MinValue: NativeInt = $0;
    const MaxValue: NativeInt = {$IFDEF cpu64}$ffffffffffffffff{$ELSE}$ffffffff{$ENDIF};
  end;

  IntPtr = public NativeInt;
  UIntPtr = public NativeUInt;


implementation

method SByte.GetHashCode: Integer;
begin
  exit self;
end;

method Byte.GetHashCode: Integer;
begin
  exit self;
end;

method Int16.GetHashCode: Integer;
begin
  exit self;
end;

method UInt16.GetHashCode: Integer;
begin
  exit self;
end;

method Int32.GetHashCode: Integer;
begin
  exit self;
end;

method UInt32.GetHashCode: Integer;
begin
  exit self;
end;

method Int64.GetHashCode: Integer;
begin
  exit Integer(Self xor (Self shr 32) * 7);
end;

method UInt64.GetHashCode: Integer;
begin
  exit Integer(Self xor (Self shr 32) * 7);
end;

method NativeInt.GetHashCode: Integer;
begin
  exit Integer({$ifdef cpu64}Self xor (Self shr 32) * 7{$else}Self{$endif});
end;

method NativeUInt.GetHashCode: Integer;
begin
  exit Integer({$ifdef cpu64}Self xor (Self shr 32) * 7{$else}Self{$endif});
end;

method Int64.ToString: String;
begin
  if self = 0 then exit '0';
  var lBuffer: array[0..50] of Char;
  var i := 50;
  var isNeg := self < 0;
  var n1: UInt64 := if isNeg then -self else self;

  while n1 <> 0 do begin
    lBuffer[i] := Char(ord('0') + (n1 mod 10));
    dec(i);
    n1 :=n1 /10;
  end;

  if isNeg then begin
    lBuffer[i] := '-';
    dec(i);
  end;
  exit String.FromPChar(@lBuffer[i+1], 50 -i);
end;

method UInt64.ToString: String;
begin
  if self = 0 then exit '0';
  var lBuffer: array[0..50] of Char;
  var i := 50;
  var n1: UInt64 := self;

  while n1 <> 0 do begin
    lBuffer[i] := Char(ord('0') + (n1 mod 10));
    dec(i);
    n1 :=n1 /10;
  end;
  exit String.FromPChar(@lBuffer[i+1], 50 -i);
end;

method Byte.ToString: String;
begin
  exit UInt64(self).ToString;
end;

method SByte.ToString: String;
begin
  exit Int64(self).ToString;
end;

method UInt16.ToString: String;
begin
  exit UInt64(self).ToString;
end;

method Int16.ToString: String;
begin
  exit Int64(self).ToString;
end;

method UInt32.ToString: String;
begin
  exit UInt64(self).ToString;
end;

method Int32.ToString: String;
begin
  exit Int64(self).ToString;
end;

method NativeUInt.ToString: String;
begin
  exit UInt64(self).ToString;
end;

method NativeInt.ToString: String;
begin
  exit Int64(self).ToString;
end;
end.