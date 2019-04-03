namespace RemObjects.Elements.System;

type
  Currency = public record 
  private
    fValue: Int64;

    const Delta = 10000;
  public
    constructor(aValue: Int64);
    begin 
      fValue := aValue;
    end;

    property Value: Int64 read fValue;

    class operator implicit(i: Integer): Currency;
    begin 
      exit new Currency(fValue := i * Delta);
    end;

    class operator implicit(i: Int64): Currency;
    begin 
      exit new Currency(fValue := i * Delta);
    end;

    class operator implicit(i: Single): Currency;
    begin 
      exit new Currency(fValue := Int64(i * Delta));
    end;

    class operator implicit(i: Double): Currency;
    begin 
      exit new Currency(fValue := Int64(i * Delta));
    end;

    class operator Explicit(i: Currency): Integer;
    begin 
      exit i.fValue / Delta;
    end;
    class operator Explicit(i: Currency): Int64;
    begin 
      exit i.fValue  / Delta;
    end;

    class operator Explicit(i: Currency): Double;
    begin 
      exit Double(i.fValue) / Delta;
    end;

    class operator Explicit(i: Currency): Single;
    begin 
      exit Double(i.fValue) / Delta;
    end;

    class operator &Add(a, b: Currency): Currency;
    begin 
      exit new Currency(a.fValue + b.fValue);
    end;

    class operator Subtract(a, b: Currency): Currency;
    begin 
      exit new Currency(a.fValue - b.fValue);
    end;

    class operator Divide(a: Currency; b: Int64): Currency;
    begin 
      exit new Currency(a.fValue / b);
    end;
    
    class operator Divide(a: Currency; b: Double): Currency;
    begin 
      exit new Currency(Int64(a.fValue / b));
    end;

    class operator Multiply(a: Currency; b: Int64): Currency;
    begin 
      exit new Currency(a.fValue * b);
    end;
    
    class operator Multiply(a: Currency; b: Double): Currency;
    begin 
      exit new Currency(Int64(a.fValue * b));
    end;

    class operator Plus(a: Currency): Currency;
    begin 
      exit a;
    end;

    class operator Minus(a: Currency): Currency;
    begin 
      exit new Currency(-a.fValue);
    end;

    class operator Less(a, b: Currency): Boolean;
    begin 
      exit a.fValue < b.fValue;
    end;

    class operator Greater(a, b: Currency): Boolean;
    begin 
      exit a.fValue > b.fValue;
    end;

    class operator LessOrEqual(a, b: Currency): Boolean;
    begin 
      exit a.fValue <= b.fValue;
    end;

    class operator GreaterOrEqual(a, b: Currency): Boolean;
    begin 
      exit a.fValue >= b.fValue;
    end;

    class operator Equal(a, b: Currency): Boolean;
    begin 
      exit a.fValue = b.fValue;
    end;

    class operator NotEqual(a, b: Currency): Boolean;
    begin 
      exit a.fValue <> b.fValue;
    end;

    method GetHashCode: Integer; override;
    begin 
      exit fValue.GetHashCode;
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin 
      exit (aOther is Currency) and (Currency(aOther).fValue = fValue);
    end;

    method ToString: String; override;
    begin 
      exit ToString(Locale.Invariant);
    end;

    method ToString(aLocale: Locale): String;
    begin
      if self = 0 then exit '0';
      var lBuffer: array[0..50] of Char;
      var i := 50;
      var isNeg := self < 0;
      var n1: UInt64 := if isNeg then -fValue else fValue;

      while (n1 <> 0) or (i >= 45) do begin
        lBuffer[i] := Char(ord('0') + (n1 mod 10));
        dec(i);
        if i = 46 then begin lBuffer[i] := '.'; dec(i); end;
        n1 :=n1 /10;
      end;

      if isNeg then begin
        lBuffer[i] := '-';
        dec(i);
      end;
      exit String.FromPChar(@lBuffer[i+1], 50 -i);
    end;
  end;

end.