namespace RemObjects.Elements.System;

interface

type
  Single = public record(INumber, IComparable, IComparable<Single>, IEquatable<Single>)
  private
    class method DoTryParse(s: String; aLocale: Locale; out Value: Single; aRaiseOverflowException: Boolean):Boolean;
    const SignificantBitmask: UInt32      = $80000000;
    const ExponentBitmask: UInt32         = $7F800000;
    const FractionBitmask: UInt32         = $007FFFFF;

    const UInt32_MinValue: UInt32         = $FF7FFFFF;
    const UInt32_MaxValue: UInt32         = $7F7FFFFF;
    const UInt32_PositiveInfinity: UInt32 = $7F800000;
    const UInt32_NegativeInfinity: UInt32 = $FF800000;
    const UInt32_NAN: UInt32              = $FFC00000;
  public
    method ToString: String; override;
    method ToString(aLocale: Locale): String;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    class method Parse(s: String): Single;
    class method TryParse(s: String; out Value: Single): Boolean; inline;
    class method TryParse(s: String; aLocale: Locale; out Value: Single): Boolean; inline;

    class method MinValue: Single;
    class method MaxValue: Single;
    class method PositiveInfinity: Single;
    class method NegativeInfinity: Single;
    class method NAN: Single;

    class method IsNaN(Value: Single): Boolean;
    class method IsInfinity(Value: Single): Boolean;
    class method IsPositiveInfinity(Value: Single): Boolean;
    class method IsNegativeInfinity(Value: Single): Boolean;

    method &Equals(other: Single): Boolean;
    begin 
      exit other = self;
    end;

    method CompareTo(a: Object): Object;
    begin 
      if a is Single then 
        exit CompareTo(Single(a));
      exit CompareTo(Convert.ToSingle(a));
    end;

    method CompareTo(a: Single): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      if self = a then exit 0;
      exit IsNaN(self).CompareTo(IsNaN(a));
    end;
  end;

  Double = public record(INumber, IComparable, IComparable<Double>, IEquatable<Double>)
  private
    class method DoTryParse(s: String; aLocale: Locale; out Value: Double; aRaiseOverflowException: Boolean): Boolean; inline;
  assembly
    const SignificantBitmask: UInt64      = $8000000000000000;
    const ExponentBitmask: UInt64         = $7FF0000000000000;
    const FractionBitmask: UInt64         = $000FFFFFFFFFFFFF;

    const UInt64_MinValue: UInt64         = $FFEFFFFFFFFFFFFF;
    const UInt64_MaxValue: UInt64         = $7FEFFFFFFFFFFFFF;
    const UInt64_PositiveInfinity: UInt64 = $7FF0000000000000;
    const UInt64_NegativeInfinity: UInt64 = $FFF0000000000000;
    const UInt64_NAN: UInt64              = $FFF8000000000000;
    method IsInt: Boolean;
    begin
      var pIEEE_754_raw := ^UInt64(@self)^;
      var tmp := pIEEE_754_raw and not Double.SignificantBitmask;
      var exponent: Int32 := (tmp shr 52)-1023;
      if exponent >= 0 then
        exit (tmp and (FractionBitmask shr exponent)) = 0
      else
        exit false;
    end;
  public
    method ToString: String; override;
    method ToString(aLocale: Locale): String;
    method ToString(aNumberOfDecimalDigits: UInt32): String; inline;
    method ToString(aNumberOfDecimalDigits: UInt32; aLocale: Locale): String; 
    class method Parse(s: String): Double;
    class method TryParse(s: String; out Value: Double): Boolean;
    class method TryParse(s: String; aLocale: Locale; out Value: Double): Boolean;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;

    class method MinValue: Double;
    class method MaxValue: Double;
    class method PositiveInfinity: Double;
    class method NegativeInfinity: Double;
    class method NaN: Double;

    class method IsNaN(Value: Double): Boolean;
    class method IsInfinity(Value: Double): Boolean;
    class method IsPositiveInfinity(Value: Double): Boolean;
    class method IsNegativeInfinity(Value: Double): Boolean;

    
    method &Equals(other: Double): Boolean;
    begin 
      exit other = self;
    end;

    method CompareTo(a: Object): Object;
    begin 
      if a is Double then 
        exit CompareTo(Double(a));
      exit CompareTo(Convert.ToDouble(a));
    end;

    method CompareTo(a: Double): Integer;
    begin 
      if self < a then exit -1;
      if self > a then exit 1;
      if self = a then exit 0;
      exit IsNaN(self).CompareTo(IsNaN(a));
    end;
  end;

  FloatToString = static private class
  private
    class const DecimalChar: Char = '.';
    class const maxpos = 1024;
    class method CalcLastDigit(var data: array[0..maxpos] of Byte; aStart, aCount: Integer);
  public
    class method Convert(aValue: Double; aPrecision: Integer): String; inline;
    class method Convert(aValue: Double; aPrecision: Integer; aLocale: Locale): String;
    class method ConvertToDecimal(aValue: Double; aNumberOfDecimalDigits: UInt32): String;
    class method ConvertToDecimal(aValue: Double; aNumberOfDecimalDigits: UInt32; aLocale: Locale): String;
  end;

implementation

method Double.ToString: String;
begin
  exit ToString(Locale.Current);
end;

method Double.ToString(aLocale: Locale): String;
begin
  exit FloatToString.Convert(self, 16, aLocale);
end;

method Double.GetHashCode: Integer;
begin
  exit ^Integer(@self)[0] xor ^Integer(@self)[1];
end;

class method Double.IsNaN(Value: Double): Boolean;
begin
  //7FF#############;
  var c := ^UInt64(@Value)^;
  exit (c and ExponentBitmask = ExponentBitmask) and (c and FractionBitmask <> 0);
end;

class method Double.IsInfinity(Value: Double): Boolean;
begin
  //$7FF0000000000000 or $FFF0000000000000 only
  var c := ^UInt64(@Value)^;
  exit (c = UInt64_PositiveInfinity) or (c = UInt64_NegativeInfinity);
end;

class method Double.IsPositiveInfinity(Value: Double): Boolean;
begin
  //$7FF0000000000000 only
  exit ^UInt64(@Value)^ = UInt64_PositiveInfinity;
end;

class method Double.IsNegativeInfinity(Value: Double): Boolean;
begin
  //$FFF0000000000000 only
  exit ^UInt64(@Value)^ = UInt64_NegativeInfinity;
end;

class method Double.MinValue: Double;
begin
  var k: UInt64 := UInt64_MinValue;
  exit ^Double(@k)^;
end;

class method Double.MaxValue: Double;
begin
  var k: UInt64 := UInt64_MaxValue;
  exit ^Double(@k)^;
end;

class method Double.PositiveInfinity: Double;
begin
  var k: UInt64 := UInt64_PositiveInfinity;
  exit ^Double(@k)^;
end;

class method Double.NegativeInfinity: Double;
begin
  var k: UInt64 := UInt64_NegativeInfinity;
  exit ^Double(@k)^;
end;

class method Double.NaN: Double;
begin
  var k: UInt64 := UInt64_NAN;
  exit ^Double(@k)^;
end;

method Double.&Equals(obj: Object): Boolean;
begin
  if assigned(obj) and (obj is Double) then
    exit self = Double(obj)
  else
    exit False;
end;

method Double.ToString(aNumberOfDecimalDigits: UInt32): String;
begin
  exit FloatToString.ConvertToDecimal(self, aNumberOfDecimalDigits, Locale.Current);
end;

method Double.ToString(aNumberOfDecimalDigits: UInt32; aLocale: Locale): String;
begin
  exit FloatToString.ConvertToDecimal(self, aNumberOfDecimalDigits, aLocale);
end;

class method Double.Parse(s: String): Double;
begin
  if not DoTryParse(s, Locale.Invariant, out result, true) then Convert.RaiseFormatException;
end;

class method Double.TryParse(s: String; out Value: Double): Boolean;
begin
  exit DoTryParse(s, Locale.Invariant, out Value, false);
end;

class method Double.TryParse(s: String; aLocale: Locale; out Value: Double): Boolean;
begin
  exit DoTryParse(s, aLocale, out Value, false);
end;

class method Double.DoTryParse(s: String; aLocale: Locale; out Value: Double; aRaiseOverflowException: Boolean): Boolean;
begin
  exit Convert.TryParseDouble(s, out Value, aRaiseOverflowException);
end;

method Single.ToString: String;
begin
  exit ToString(Locale.Current);  
end;

method Single.ToString(aLocale: Locale): String;
begin
  if Self = 0 then exit '0';
  if IsNaN(Self) then exit 'NaN';
  if IsNegativeInfinity(Self) then exit '-Infinity';
  if IsPositiveInfinity(Self) then exit 'Infinity';
  exit FloatToString.Convert(self, 8, aLocale);
end;

method Single.GetHashCode: Integer;
begin
  exit ^Integer(@self)[0];
end;

class method Single.IsNaN(Value: Single): Boolean;
begin
  //FFC#####
  var c := ^UInt32(@Value)^;
  exit (c and ExponentBitmask = ExponentBitmask) and (c and FractionBitmask <> 0);
end;

class method Single.IsInfinity(Value: Single): Boolean;
begin
  //$7F800000 or $FF800000 only
  var c := ^UInt32(@Value)^;
  exit (c = UInt32_PositiveInfinity) or (c = UInt32_NegativeInfinity);
end;

class method Single.IsPositiveInfinity(Value: Single): Boolean;
begin
  //$7F800000 only
  exit ^UInt32(@Value)^ = UInt32_PositiveInfinity;
end;

class method Single.IsNegativeInfinity(Value: Single): Boolean;
begin
  //$FF800000 only
  exit ^UInt32(@Value)^ = UInt32_NegativeInfinity;
end;

class method Single.MinValue: Single;
begin
  var k: UInt32 := UInt32_MinValue;
  exit ^Single(@k)^;
end;

class method Single.MaxValue: Single;
begin
  var k: UInt32 := UInt32_MaxValue;
  exit ^Single(@k)^;
end;

class method Single.PositiveInfinity: Single;
begin
  var k: UInt32 := UInt32_PositiveInfinity;
  exit ^Single(@k)^;
end;

class method Single.NegativeInfinity: Single;
begin
  var k: UInt32 := UInt32_NegativeInfinity;
  exit ^Single(@k)^;
end;

class method Single.NAN: Single;
begin
  var k: UInt32 := UInt32_NAN;
  exit ^Single(@k)^;
end;

method Single.&Equals(obj: Object): Boolean;
begin
  if assigned(obj) and (obj is Single) then
    exit self = Single(obj)
  else
    exit False;
end;

class method Single.Parse(s: String): Single;
begin
  if not DoTryParse(s, Locale.Invariant, out result, true) then Convert.RaiseFormatException;
end;

class method Single.TryParse(s: String; out Value: Single): Boolean;
begin
  exit DoTryParse(s, Locale.Invariant, out Value, false);
end;

class method Single.TryParse(s: String; aLocale: Locale; out Value: Single): Boolean;
begin
  exit DoTryParse(s, aLocale, out Value, false);
end;

class method Single.DoTryParse(s: String; aLocale: Locale; out Value: Single; aRaiseOverflowException: Boolean): Boolean;
begin
  var sValue : Double;
  if not Convert.TryParseDouble(s, aLocale, out sValue, aRaiseOverflowException) then exit False;
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

class method FloatToString.Convert(aValue: Double; aPrecision: Integer): String;
begin
  exit Convert(aValue, aPrecision, Locale.Current);
end;

class method FloatToString.Convert(aValue: Double; aPrecision: Integer; aLocale: Locale): String;
const
  digits: not nullable String = '0123456789';
begin
  if aValue = 0 then exit '0';
  if Double.IsNaN(aValue) then exit 'NaN';
  if Double.IsNegativeInfinity(aValue) then exit '-Infinity';
  if Double.IsPositiveInfinity(aValue) then exit 'Infinity';

  if aLocale = nil then aLocale := aLocale.Current;
  var data: array[0..maxpos] of Byte;
  var cur_position := 0;
  var exponent := 0;
  var is_positive_value:=True;
  var lValue := aValue;

  if lValue < 0 then begin
    is_positive_value:=False;
    lValue := Math.Abs(lValue);
  end;

  {$REGION process ####. }
  if lValue >= 1 then begin
    var buf: array[0..maxpos] of Byte;
    var pos1 := 0;

    var t_orig:= Math.Truncate(lValue);
    var t_calc := t_orig;
    t_calc := 0;
    var t_work := t_orig;
    var t_pos1:UInt64 := 1;
    while (t_calc <> t_orig) do begin
      var t1 := Int32(t_work mod 10);
      t_work := Math.Truncate(t_work div 10);
      if pos1 < maxpos then begin
        buf[pos1] := t1;
        inc(pos1);
      end;
      if (t_work = 0) then break;
      t_calc := t_calc + t1*t_pos1;
      t_pos1:= t_pos1*10;
      inc(exponent);
    end;
    for i:Integer := 0 to pos1-1 do
      data[cur_position+i]:= buf[pos1-i-1];
    inc(cur_position, pos1);
  end
  else begin
    dec(exponent);
  end;
  {$ENDREGION}

  {$REGION process .#### }
  var is_fraction_present:=false;
  var t_orig:= lValue mod 1;
  if (t_orig <> 0) and (cur_position < maxpos) then begin
    is_fraction_present:=true;
    var fl:= true;
    while t_orig <> 0 do begin
      t_orig:= t_orig*10;
      if Double.IsInfinity(t_orig) then break;
      var t1 := Int32(t_orig mod 10);
      if (t1 = 0) and fl and (exponent<0) then begin
        dec(exponent);
      end
      else begin
        fl := false;
        data[cur_position]:= t1;
        inc(cur_position);
      end;
      if cur_position >= maxpos then break;
    end;
  end;
  {$ENDREGION}
(*
  CalcLastDigit(var data, 0, aPrecision);
  if data[0] = 10 then begin
    var ldata : array[0..maxpos] of Byte;
    ldata[0] := 1;
    ldata[1] := 0;
    memcpy(@ldata[2], @data[1], maxpos-1);    
    data := ldata;
    inc(exponent);
    is_fraction_present := False;
  end;
*)
  var nexp := Math.Abs(exponent);

  var buf: array [0..22] of Char;
  var bufpos:= 0;
  if not is_positive_value then begin
    buf[bufpos] := '-';
    inc(bufpos);
  end;

  if (nexp > aPrecision) or (exponent < -4) then begin// => #.#####E+## | #.#####E-##
    buf[bufpos] := digits[data[0]];
    inc(bufpos);
    buf[bufpos] := aLocale.NumberFormat.DecimalSeparator;
    inc(bufpos);
    var st_cnt := aPrecision-1;
    CalcLastDigit(var data, 1, aPrecision-1);

    for i: Integer:= st_cnt-1 downto 2 do
      if data[i] = 0 then dec(st_cnt) else break;
    for i: Integer:=1 to st_cnt-1 do begin
      buf[bufpos] := digits[data[i]];
      inc(bufpos);
    end;
    {$REGION make E+###}
    buf[bufpos] := 'E';
    inc(bufpos);
    buf[bufpos] := iif(exponent>0,'+','-');
    inc(bufpos);
    if nexp > 100 then begin
      var t := Integer(nexp / 100);
      buf[bufpos] := digits[t];
      inc(bufpos);
      dec(nexp, 100*t);
    end;
    var t := Integer(nexp / 10);
    buf[bufpos] := digits[t];
    inc(bufpos);
    dec(nexp, 10*t);
    buf[bufpos] := digits[nexp];
    inc(bufpos);
    {$ENDREGION}
  end
  else if (exponent >= 0) and is_fraction_present then begin// => #####.#####
    var st_cnt := iif(cur_position>aPrecision-1, aPrecision-1, cur_position);
    CalcLastDigit(var data, nexp+1, st_cnt);
    if data[0] = 10 then begin
      var ldata : array[0..maxpos] of Byte;
      ldata[0] := 1;
      ldata[1] := 0;
      memcpy(@ldata[2], @data[1], maxpos-1);    
      data := ldata;
      inc(exponent);
      is_fraction_present := False;
    end;
    for i:Integer:=0 to exponent do begin
      buf[bufpos] := digits[data[i]];
      inc(bufpos);
    end;
    if is_fraction_present then begin
      var t_buf := bufpos;
      buf[bufpos] := aLocale.NumberFormat.DecimalSeparator;
      inc(bufpos);
      for i: Integer:= st_cnt-1 downto nexp+2 do
        if data[i] = 0 then dec(st_cnt) else break;
      for i:Integer:=nexp+1 to st_cnt-1 do begin
        buf[bufpos] := digits[data[i]];
        inc(bufpos);
      end;
      if (st_cnt-1 = t_buf) and (data[t_buf] = 0) then bufpos:= t_buf;
    end;
  end
  else if (exponent >= 0) and not is_fraction_present then begin// => #####
    CalcLastDigit(var data, 0, exponent+1);
    for i:Integer:=0 to exponent do begin
      buf[bufpos] := digits[data[i]];
      inc(bufpos);
    end;
  end
  else begin// => 0.##### - 0.000#####
    buf[bufpos] := '0';
    inc(bufpos);
    buf[bufpos] := aLocale.NumberFormat.DecimalSeparator;
    inc(bufpos);
    for i:Integer :=0 to nexp-2 do begin
      buf[bufpos] := '0';
      inc(bufpos);
    end;
    var st_cnt := iif(cur_position>aPrecision-1, aPrecision-1, cur_position);
    CalcLastDigit(var data, 0, st_cnt);
    for i: Integer:= st_cnt-1 downto 1 do
      if data[i] = 0 then dec(st_cnt) else break;
    for i:Integer:=0 to st_cnt-1 do begin
      buf[bufpos] := digits[data[i]];
      inc(bufpos);
    end;
  end;
  exit  String.FromPChar(buf,bufpos);
end;

class method FloatToString.CalcLastDigit(var data: array[0..maxpos] of Byte; aStart: Integer; aCount: Integer);
begin
  if (aCount < length(data)-1) then begin
    if data[aCount] > 5 then begin
      data[aCount-1] := data[aCount-1]+1;
      data[aCount] := 0;
    end
    else if data[aCount] = 5 then begin
      for i:Integer :=aCount to length(data)-1 do begin
        if data[i] = 0 then continue;
        data[aCount-1] := data[aCount-1]+1;
        data[aCount] := 0;
        break;
      end;
    end
    else begin
      // none
    end;
    for i:Integer := aCount-1 downto 1 do begin
      if data[i] = 10 then begin
        data[i] := 0;
        data[i-1] := data[i-1]+1;
      end
      else
        break;
    end;
  end;
end;

class method FloatToString.ConvertToDecimal(aValue: Double; aNumberOfDecimalDigits: UInt32): String;
begin
  exit ConvertToDecimal(aValue, aNumberOfDecimalDigits, Locale.Current);
end;

class method FloatToString.ConvertToDecimal(aValue: Double; aNumberOfDecimalDigits: UInt32; aLocale: Locale): String;
const
  digits: not nullable String = '0123456789';
begin
  if (aValue = 0) and (aNumberOfDecimalDigits = 0) then exit '0';

  if aLocale = nil then aLocale := Locale.Current;
  var data: array[0..maxpos + 1 {extra digits for rounding}] of Byte;
  var cur_position := 0;
  var exponent := 0;
  var is_positive_value:=True;
  var lValue := aValue;

  if lValue < 0 then begin
    is_positive_value:=False;
    lValue := Math.Abs(lValue);
  end;

  {$REGION process ####. }
  if lValue >= 1 then begin
    var buf: array[0..maxpos] of Byte;
    var pos1 := 0;

    var t_orig:= Math.Truncate(lValue);
    var t_calc := t_orig;
    t_calc := 0;
    var t_work := t_orig;
    var t_pos1:UInt64 := 1;
    while (t_calc <> t_orig) do begin
      var t1 := Int32(t_work mod 10);
      t_work := Math.Truncate(t_work div 10);
      if pos1 < maxpos then begin
        buf[pos1] := t1;
        inc(pos1);
      end;
      if (t_work = 0) then break;
      t_calc := t_calc + t1*t_pos1;
      t_pos1:= t_pos1*10;
      inc(exponent);
    end;
    for i:Integer := 0 to pos1-1 do
      data[cur_position+i]:= buf[pos1-i-1];
    inc(cur_position, pos1);
  end
  else begin
    dec(exponent);
    inc(cur_position);// extra 0 at beginning
  end;
  {$ENDREGION}

  {$REGION process .#### } 
  var t_orig:= lValue mod 1;
  if (t_orig <> 0) and (cur_position < maxpos) then begin
    var fl:= true;
    while t_orig <> 0 do begin
      t_orig:= t_orig*10;
      if Double.IsInfinity(t_orig) then break;
      var t1 := Int32(t_orig mod 10);
      if (t1 = 0) and fl and (exponent<0) then begin
        dec(exponent);
      end
      else begin
        fl := false;
        data[cur_position]:= t1;
        inc(cur_position);
      end;
      if cur_position >= maxpos then break;
    end;
  end;
  {$ENDREGION}

  var nexp := Math.Abs(exponent);
(*
  CalcLastDigit(var data, 0, aNumberOfDecimalDigits+nexp+2);
  if data[0] = 10 then begin
    var ldata : array[0..maxpos+1] of Byte;
    ldata[0] := 1;
    ldata[1] := 0;
    memcpy(@ldata[2], @data[1], maxpos-1);    
    data := ldata;
    inc(exp);    
    inc(nexp);
  end;
*)  
  var buf:= new array of Char(nexp + aNumberOfDecimalDigits + 2) ;
  var bufpos:= 0;
  if not is_positive_value then begin
    buf[bufpos] := '-';
    inc(bufpos);
  end;

  if exponent>=0 then begin  //####.#####
    CalcLastDigit(var data, 0, aNumberOfDecimalDigits+nexp+1);
    for i:Integer:=0 to exponent do begin
      buf[bufpos] := digits[data[i]];
      inc(bufpos);
    end;
    if aNumberOfDecimalDigits > 0 then begin
      buf[bufpos] := aLocale.NumberFormat.DecimalSeparator;
      inc(bufpos);
      var st_cnt := aNumberOfDecimalDigits + exponent + 1;
      for i:Integer:=nexp+1 to st_cnt-1 do begin
        buf[bufpos] := digits[data[i]];
        inc(bufpos);
      end;
    end;
  end
  // 0.######
  else if aNumberOfDecimalDigits = 0 then begin
    CalcLastDigit(var data, 0, 1);
    buf[bufpos] := digits[data[0]];
    inc(bufpos);
  end
  else begin  // 0.######
    CalcLastDigit(var data, 1, aNumberOfDecimalDigits+1);
    buf[bufpos] := '0';
    inc(bufpos);
    buf[bufpos] := aLocale.NumberFormat.DecimalSeparator;
    inc(bufpos);
    for i:Integer :=0 to nexp-2 do begin
      buf[bufpos] := '0';
      inc(bufpos);
    end;
    var st_cnt := aNumberOfDecimalDigits;
    for i:Integer:=0 to st_cnt-1 do begin
      buf[bufpos] := digits[data[i+1]];
      inc(bufpos);
    end;
  end;
  exit  String.FromPChar(@buf[0],bufpos);
end;


end.