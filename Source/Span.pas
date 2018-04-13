namespace RemObjects.Elements.System;

type
  Span<T> = public record 
  private
    method set_Data(i: Integer; value: T);
    begin 
      if UInt32(i) <UInt32(fLength) then 
        fPointer[i] := value 
      else 
        raise new IndexOutOfRangeException('i out of range');  
    end;

    method get_Data(i: Integer): T;
    begin 
      if UInt32(i) <UInt32(fLength) then 
        exit fPointer[i] 
      else 
        raise new IndexOutOfRangeException('i out of range'); 
    end;

    fObject: Object;
    fPointer: ^T;
    fLength: Integer;
  public
    constructor; empty;

    constructor(aArray: array of T; aStart, aLength: Integer);
    begin
      if aArray = nil then raise new ArgumentNullException('aArray');
      if aLength < 0 then raise new ArgumentOutOfRangeException('aLength < 0');
      if (aStart < 0) or (Cardinal(aStart + aLength) >= Cardinal(aArray.Length)) then new ArgumentOutOfRangeException('aStart < 0 or aStart + Length >= aArray.Length');
      fObject := aArray;
      fPointer := @aArray[aStart]; 
      fLength := aLength;
    end;

    constructor(aPointer: ^T; aLength: Integer); 
    begin 
       fPointer := aPointer;
       fLength := aLength;
    end;

    class property Empty: Span<T> read default(Span<T>);

    property Empty: Boolean read fLength = 0;
    property Length: Integer read fLength;
    property Pointer: ^T read fPointer;
    property Data[i: Integer]: T read get_Data write set_Data;

    method Slice(aStart: Integer): Span<T>;
    begin 
      exit Slice(aStart, Length - aStart);
    end;

    method Slice(aStart, aLength: Integer): Span<T>; 
    begin 
      if (aStart < 0) or (aStart + aLength > Length) or (aLength < 0) then raise new ArgumentOutOfRangeException('Invalid start/length!');
      exit new Span<T>(fObject := fObject, fLength := aLength, fPointer := @fPointer[aStart]);
    end;

    class operator Implicit(aVal: array of T): Span<T>;
    begin 
      exit new Span<T>(aVal, 0, aVal.Length);
    end;

    class operator Implicit(aVal: Span<T>): ReadOnlySpan<T>;
    begin 
      exit new ReadOnlySpan<T>(fObject := aVal.fObject, fPointer := aVal.fPointer, fLength := aVal.fLength);
    end;
  end;

  ReadOnlySpan<T> = public ImmutableSpan<T>;
  ImmutableSpan<T> = public record 
  assembly
    method get_Data(i: Integer): T;
    begin 
      if UInt32(i) <UInt32(fLength) then 
        exit fPointer[i] 
      else 
        raise new IndexOutOfRangeException('i out of range'); 
    end;

    fObject: Object;
    fPointer: ^T;
    fLength: Integer;
  public
    constructor; empty;

    constructor(aArray: array of T; aStart, aLength: Integer);
    begin
      if aArray = nil then raise new ArgumentNullException('aArray');
      if aLength < 0 then raise new ArgumentOutOfRangeException('aLength < 0');
      if (aStart < 0) or (Cardinal(aStart + aLength) >= Cardinal(aArray.Length)) then new ArgumentOutOfRangeException('aStart < 0 or aStart + Length >= aArray.Length');
      fObject := aArray;
      fPointer := @aArray[aStart]; 
      fLength := aLength;
    end;

    constructor(aPointer: ^T; aLength: Integer); 
    begin 
       fPointer := aPointer;
       fLength := aLength;
    end;

    class property Empty: Span<T> read default(Span<T>);

    property Empty: Boolean read fLength = 0;
    property Length: Integer read fLength;
    property Pointer: ^T read fPointer;
    property Data[i: Integer]: T read get_Data;

    method Slice(aStart: Integer): ImmutableSpan<T>;
    begin 
      exit Slice(aStart, Length - aStart);
    end;

    method Slice(aStart, aLength: Integer): ImmutableSpan<T>; 
    begin 
      if (aStart < 0) or (aStart + aLength > Length) or (aLength < 0) then raise new ArgumentOutOfRangeException('Invalid start/length!');
      exit new ImmutableSpan<T>(fObject := fObject, fLength := aLength, fPointer := @fPointer[aStart]);
    end;

    class operator Implicit(aVal: array of T): ImmutableSpan<T>;
    begin 
      exit new ImmutableSpan<T>(aVal, 0, aVal.Length);
    end;
  end;

end.