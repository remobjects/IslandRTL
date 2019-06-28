namespace RemObjects.Elements.System;

type
  UTF8String = public record 
  private 
    fData: array of Byte;


    class var fEmpty: UTF8String := new UTF8String(new Byte[0], 0, 0);
  public 
    class property Empty: UTF8String read fEmpty;
    // note: Presumes ownership of aData!
    constructor(aData: array of Byte; aStart: Integer; aLength: Integer); 
    begin 
      var lData := new Byte[aLength + 1];
      Array.Copy(aData, aStart, lData, 0, aLength);
      fData := lData;
    end;

    constructor(aData: array of Byte; aStart: Integer);
    begin 
      constructor(aData, aStart, aData.Length - aStart);
    end;

    constructor(aData: array of Byte);
    begin 
      constructor(aData, 0, aData.Length);
    end;


    property Length: Integer read fData.Length-1;
    property Item[idx: Integer]: Byte read fData[idx] write fData[idx];


    method Substring(aStart: Integer): UTF8String;
    begin 
      if aStart < 0 then raise new ArgumentException('aStart < 0');
      var lNewLength := Length - aStart;
      if lNewLength < 0 then exit UTF8String.Empty;

      exit new UTF8String(fData, aStart, lNewLength);
    end;

    method Substring(aStart, aLength: Integer): UTF8String;
    begin 
      if aStart < 0 then raise new ArgumentException('aStart < 0');
      var lNewLength := Math.Min(Length - aStart, aLength);
      if lNewLength < 0 then exit UTF8String.Empty;

      exit new UTF8String(fData, aStart, lNewLength);
    end;

    method ToString: String; override;
    begin 
      exit Encoding.UTF8.GetString(fData, 0, Length);
    end;

    method GetHashCode: Integer; override;
    begin 
      exit fData.Length;
    end;

    class operator Explicit(aVal: String): UTF8String;
    begin 
      exit new UTF8String(Encoding.UTF8.GetBytes(aVal, false));
    end;

    class operator Explicit(aVal: UTF8String): String;
    begin 
      exit aVal.ToString;
    end;

    class operator Implicit(aVal: UTF8String): ^Byte;
    begin 
      exit @aVal.fData[0]; // 0 terminated already.
    end;

    
    class operator Implicit(aVal: UTF8String): ^AnsiChar;
    begin 
      exit ^AnsiChar(@aVal.fData[0]); // 0 terminated already.
    end;

    class operator Implicit(aVal: UTF8String): Span<Byte>;
    begin 
      exit new Span<Byte>(aVal.fData, 0, aVal.Length);
    end;
  end;

end.