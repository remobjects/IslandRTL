namespace RemObjects.Elements.System;

interface

type
  SByte = public record(INumber, IIntegerNumber, IEquatable<SByte>, IComparable, IComparable<SByte>)
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


    
    method &Equals(other: SByte): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is SByte then 
        exit CompareTo(SByte(a));
      exit CompareTo(Convert.ToSByte(a));
    end;

    method CompareTo(a: SByte): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  Byte = public record(INumber, IIntegerNumber, IEquatable<Byte>, IComparable, IComparable<Byte>)
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


    
    method &Equals(other: Byte): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is Byte then 
        exit CompareTo(Byte(a));
      exit CompareTo(Convert.ToByte(a));
    end;

    method CompareTo(a: Byte): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  Int16 = public record(INumber, IIntegerNumber, IEquatable<Int16>, IComparable, IComparable<Int16>)
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


    
    method &Equals(other: Int16): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is Int16 then 
        exit CompareTo(Int16(a));
      exit CompareTo(Convert.ToInt16(a));
    end;

    method CompareTo(a: Int16): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  UInt16 = public record(INumber, IIntegerNumber, IEquatable<UInt16>, IComparable, IComparable<UInt16>)
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


    
    method &Equals(other: UInt16): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is UInt16 then 
        exit CompareTo(UInt16(a));
      exit CompareTo(Convert.ToUInt16(a));
    end;

    method CompareTo(a: UInt16): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  Int32 = public record(INumber, IIntegerNumber, IEquatable<Int32>, IComparable, IComparable<Int32>)
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

   
    method &Equals(other: Int32): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is Int32 then 
        exit CompareTo(Int32(a));
      exit CompareTo(Convert.ToInt32(a));
    end;

    method CompareTo(a: Int32): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  UInt32 = public record(INumber, IIntegerNumber, IEquatable<UInt32>, IComparable, IComparable<UInt32>)
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


    
    method &Equals(other: UInt32): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is UInt32 then 
        exit CompareTo(UInt32(a));
      exit CompareTo(Convert.ToUInt32(a));
    end;

    method CompareTo(a: UInt32): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  Int64 = public record(INumber, IIntegerNumber, IEquatable<Int64>, IComparable, IComparable<Int64>)
  private
    class method DoTryParse(s: String; out Value: Int64; aRaiseOverflowException: Boolean):Boolean; inline;
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


    
    method &Equals(other: Int64): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is Int64 then 
        exit CompareTo(Int64(a));
      exit CompareTo(Convert.ToInt64(a));
    end;

    method CompareTo(a: Int64): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  UInt64 = public record(INumber, IIntegerNumber, IEquatable<UInt64>, IComparable, IComparable<UInt64>)
  private
    class method DoTryParse(s: String; out Value: UInt64; aRaiseOverflowException: Boolean):Boolean;inline;
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


    
    method &Equals(other: UInt64): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is UInt64 then 
        exit CompareTo(UInt64(a));
      exit CompareTo(Convert.ToUInt64(a));
    end;

    method CompareTo(a: UInt64): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  NativeInt = public record(INumber, IIntegerNumber, IEquatable<NativeInt>, IComparable, IComparable<NativeInt>)
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
      {$IFDEF cpu64}
      if assigned(obj) and (obj is Int64) then
        exit self = Int64(obj);
      {$else}
      if assigned(obj) and (obj is Int32) then
        exit self = Int32(obj);
      {$ENDIF}
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


    
    method &Equals(other: NativeInt): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is NativeInt then 
        exit CompareTo(NativeInt(a));
      exit CompareTo(NativeInt(Convert.ToInt64(a)));
    end;

    method CompareTo(a: NativeInt): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  NativeUInt = public record(INumber, IIntegerNumber, IEquatable<NativeUInt>, IComparable, IComparable<NativeUInt>)
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
      {$IFDEF cpu64}
      if assigned(obj) and (obj is UInt64) then
        exit self = UInt64(obj);
      {$else}
      if assigned(obj) and (obj is UInt32) then
        exit self = UInt32(obj);
      {$ENDIF}
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

    const MinValue: NativeUInt = $0;
    const MaxValue: NativeUInt = {$IFDEF cpu64}$ffffffffffffffff{$ELSE}$ffffffff{$ENDIF};


    
    method &Equals(other: NativeUInt): Boolean;
    begin 
      exit self = other;
    end;
    
    method CompareTo(a: Object): Integer;
    begin 
      if a is NativeUInt then 
        exit CompareTo(NativeUInt(a));
      exit CompareTo(NativeUInt(Convert.ToUInt64(a)));
    end;

    method CompareTo(a: NativeUInt): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
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