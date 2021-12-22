namespace RemObjects.Elements.System;

interface


type
  &Set<T> = public sealed class(IEnumerable, IEnumerable<T>)
  private
    var fValue: array of Byte;
    method NGetEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    class method Converter(val: T): Integer;
    method PutRange(aStart: Integer; aEnd: Integer; aVal: Boolean);
    method Put(i: Integer; aVal: Boolean := true);
  public
    class const MaxSize: Integer = 1048576;
    method ClearRange(aStart: T; aEnd: T): &Set<T>;
    method ClearRange(aStart: Integer; aEnd: Integer): &Set<T>;
    method SetRange(aStart: T; aEnd: T): &Set<T>;
    method SetRange(aStart: Integer; aEnd: Integer): &Set<T>;
    method Clear(i: T): &Set<T>;
    method Clear(i: Integer): &Set<T>;
    method &Set(i: T): &Set<T>;
    method &Set(i: Integer): &Set<T>;
    method Get(i: T): Boolean;
    method Get(i: Integer): Boolean;
    method ToArray: array of Byte;
    method GetEnumerator: IEnumerator<T>;
    class method op_In(aValue: T; aData: &Set<T>): Boolean;
    class operator Implicit(aData: &Set<T>): array of T;
    class operator Implicit(aData: array of T): &Set<T>;
    class operator Multiply(a: &Set<T>; b: &Set<T>): &Set<T>;
    class operator LessOrEqual(a: &Set<T>; b: &Set<T>): Boolean;
    class operator NotEqual(a: &Set<T>; b: &Set<T>): Boolean;
    class operator GreaterOrEqual(a: &Set<T>; b: &Set<T>): Boolean;
    class operator Equal(a: &Set<T>; b: &Set<T>): Boolean;
    class operator Subtract(a: &Set<T>; b: &Set<T>): &Set<T>;
    class operator &Add(a: &Set<T>; b: &Set<T>): &Set<T>;
    class method FromData(params aData: array of T): &Set<T>;
    constructor(aData: array of Byte);
    constructor(aSize: Integer);
    constructor;
  end;

  SetFunc<T1, TResult> = assembly block(value: T1): TResult;

  SetIterator nested in &Set<T> = sealed class(IEnumerator, IEnumerator<T>)
  private
    var fIndex: Integer;
    var fOwner: &Set<T>;
  public
    property NGCurrent: Object read Current;
    property Current: T;
    property NCurrent: Object read Current; implements IEnumerator;
    method Dispose;
    method MoveNext: Boolean;
    method Reset;
    constructor(aValue: &Set<T>);
  end;

implementation

method &Set<T>.ClearRange(aStart: T; aEnd: T): &Set<T>;
begin
  exit ClearRange(Converter(aStart), Converter(aEnd));
end;

method &Set<T>.ClearRange(aStart: Integer; aEnd: Integer): &Set<T>;
begin
  if aStart > aEnd then begin
    exit self;
  end;
  var lSet: &Set<T>;
  if Object.ReferenceEquals(self, nil) then begin
    lSet := new &Set<T>(aEnd + 1);
  end
  else begin
    if aEnd / 8 >= length(fValue) then begin
      lSet := new &Set<T>(aEnd + 1);
      RemObjects.Elements.System.&Array.Copy(fValue, lSet.fValue, fValue.Length);
    end
    else begin
      lSet := new &Set<T>(fValue);
    end;
  end;
  var num: Integer := aStart;
  if num <= aEnd then begin
    var num2: Integer := aEnd + 1;
    repeat
      lSet.Put(num, false);
      inc(num);
    until not (num <> num2);
  end;
  exit lSet;
end;

method &Set<T>.SetRange(aStart: T; aEnd: T): &Set<T>;
begin
  exit SetRange(Converter(aStart), Converter(aEnd));
end;

method &Set<T>.SetRange(aStart: Integer; aEnd: Integer): &Set<T>;
begin
  if aStart > aEnd then begin
    exit self;
  end;
  var lSet: &Set<T>;
  if Object.ReferenceEquals(self, nil) then begin
    lSet := new &Set<T>(aEnd + 1);
  end
  else begin
    if aEnd / 8 >= length(fValue) then begin
      lSet := new &Set<T>(aEnd + 1);
      RemObjects.Elements.System.&Array.Copy(fValue, lSet.fValue, fValue.Length);
    end
    else begin
      lSet := new &Set<T>(fValue);
    end;
  end;
  var num: Integer := aStart;
  if num <= aEnd then begin
    var num2: Integer := aEnd + 1;
    repeat
      lSet.Put(num, true);
      inc(num);
    until not (num <> num2);
  end;
  exit lSet;
end;

method &Set<T>.Clear(i: T): &Set<T>;
begin
  exit Clear(Converter(i));
end;

method &Set<T>.Clear(i: Integer): &Set<T>;
begin
  var lSet: &Set<T>;
  if Object.ReferenceEquals(self, nil) then begin
    lSet := new &Set<T>(i + 1);
  end
  else begin
    if i/8 >= length(fValue) then begin
      lSet := new &Set<T>(i + 1);
      RemObjects.Elements.System.&Array.Copy(fValue, lSet.fValue, fValue.Length);
    end
    else begin
      lSet := new &Set<T>(fValue);
    end;
  end;
  lSet.Put(i, false);
  exit lSet;
end;

method &Set<T>.Set(i: T): &Set<T>;
begin
  exit &Set(Converter(i));
end;

method &Set<T>.Set(i: Integer): &Set<T>;
begin
  var lset: &Set<T>;
  if Object.ReferenceEquals(self, nil) then begin
    lset := new &Set<T>(i + 1);
  end
  else begin
    if i / 8 >= length(fValue) then begin
      lset := new &Set<T>(i + 1);
      RemObjects.Elements.System.&Array.Copy(fValue, lset.fValue, fValue.Length);
    end
    else begin
      lset := new &Set<T>(fValue);
    end;
  end;
  lset.Put(i, true);
  exit lset;
end;

method &Set<T>.Get(i: T): Boolean;
begin
  exit Get(Converter(i));
end;

method &Set<T>.Get(i: Integer): Boolean;
begin
  var lRes: Integer;
  if i < 0 then begin
    lRes := 1;
  end
  else begin
    lRes := (if i / 8 >= length(fValue) then (1) else (0));
  end;
  exit (lRes = 0) and ((UInt32(fValue[i / 8]) and (1 shl (i mod 8))) <> 0);
end;

method &Set<T>.ToArray: array of Byte;
begin
  if Object.ReferenceEquals(self, nil) then begin
    exit new Byte[0];
  end;
  var lArray: array of Byte := new Byte[fValue.Length];
  RemObjects.Elements.System.Array.Copy(fValue, lArray, lArray.Length);
  exit lArray;
end;

method &Set<T>.GetEnumerator: IEnumerator<T>;
begin
  exit new SetIterator(self);
end;

class method &Set<T>.op_In(aValue: T; aData: &Set<T>): Boolean;
begin
  exit aData.Get(Converter(aValue));
end;

class operator &Set<T>.Implicit(aData: &Set<T>): array of T;
begin
  if Object.ReferenceEquals(aData, nil) then begin
    exit new T[0];
  end;
  var list: List<T> := new List<T>();
  if assigned(aData) then begin
    var enumerator: IEnumerator<T> := aData.GetEnumerator();
    if assigned(enumerator) then begin
      try
        while enumerator.MoveNext() do begin
          var current: T := enumerator.Current;
          list.Add(current);
        end;
      finally
        enumerator.Dispose();
      end;
    end;
  end;
  exit list.ToArray();
end;

class operator &Set<T>.Implicit(aData: array of T): &Set<T>;
begin
  var num: Integer := -1;
  var num2: Integer := (if aData = nil then (0) else (aData.Length)) - 1;
  var num3: Integer := 0;
  if num3 <= num2 then begin
    inc(num2);
    repeat
      num := Math.Max(num, Converter(aData[num3]));
      inc(num3);
    until not (num3 <> num2);
  end;
  var lset: &Set<T> := new &Set<T>(num);
  num2 := (if aData = nil then (0) else (aData.Length)) - 1;
  num3 := 0;
  if num3 <= num2 then begin
    inc(num2);
    repeat
      lset.Put(Converter(aData[num3]), true);
      inc(num3);
    until not (num3 <> num2);
  end;
  exit lset;
end;

class operator &Set<T>.Multiply(a: &Set<T>; b: &Set<T>): &Set<T>;
begin
  if Object.ReferenceEquals(a, nil) and Object.ReferenceEquals(b, nil) then begin
    exit nil;
  end;
  if Object.ReferenceEquals(a, nil) then begin
  end;
  if Object.ReferenceEquals(b, nil) then begin
  end;
  var lset: &Set<T> := new &Set<T>(new Byte[Math.Max(a.fValue.Length, b.fValue.Length)]);
  var num: Integer := a.fValue.Length - 1;
  var num2: Integer := 0;
  if num2 <= num then begin
    inc(num);
    repeat
      lset.fValue[num2] := a.fValue[num2];
      inc(num2);
    until not (num2 <> num);
  end;
  num := b.fValue.Length - 1;
  num2 := 0;
  if num2 <= num then begin
    inc(num);
    repeat
      lset.fValue[num2] := lset.fValue[num2] and b.fValue[num2];
      inc(num2);
    until not (num2 <> num);
  end;
  exit lset;
end;

class operator &Set<T>.LessOrEqual(a: &Set<T>; b: &Set<T>): Boolean;
begin
  exit b >= a;
end;

class operator &Set<T>.NotEqual(a: &Set<T>; b: &Set<T>): Boolean;
begin
  exit not (a = b);
end;

class operator &Set<T>.GreaterOrEqual(a: &Set<T>; b: &Set<T>): Boolean;
begin
  if Object.ReferenceEquals(a, nil) and Object.ReferenceEquals(b, nil) then begin
    exit true;
  end;
  if Object.ReferenceEquals(a, nil) then begin
  end;
  if Object.ReferenceEquals(b, nil) then begin
  end;
  var num: Integer := a.fValue.Length - 1;
  var num2: Integer := 0;
  if num2 <= num then begin
    inc(num);
    while ((if num2 >= a.fValue.Length then (0) else (UInt32(a.fValue[num2]))) and (if num2 >= b.fValue.Length then (0) else (UInt32(b.fValue[num2])))) = (if num2 >= a.fValue.Length then (0) else (UInt32(a.fValue[num2]))) do begin
      inc(num2);
      if num2 = num then begin
        exit true;
      end;
    end;
    exit false;
  end;
  exit true;
end;

class operator &Set<T>.Equal(a: &Set<T>; b: &Set<T>): Boolean;
begin
  if Object.ReferenceEquals(a, nil) and Object.ReferenceEquals(b, nil) then begin
    exit true;
  end;
  var num: Integer;
  var num2: Integer;
  if Object.ReferenceEquals(a, nil) then begin
    num := b.fValue.Length - 1;
    num2 := 0;
    if num2 <= num then begin
      inc(num);
      loop begin
        var expr_3F: Integer := Integer(b.fValue[num2]);
        var expr_41: Integer := 0;
        if (expr_41 < 0) or (expr_3F <> expr_41) then begin
          break;
        end;
        inc(num2);
        if num2 = num then begin
          exit true;
        end;
      end;
      exit false;
    end;
    exit true;
  end;
  if Object.ReferenceEquals(b, nil) then begin
    num := a.fValue.Length - 1;
    num2 := 0;
    if num2 <= num then begin
      inc(num);
      loop begin
        var expr_85: Integer := Integer(a.fValue[num2]);
        var expr_87: Integer := 0;
        if (expr_87 < 0) or (expr_85 <> expr_87) then begin
          break;
        end;
        inc(num2);
        if num2 = num then begin
          exit true;
        end;
      end;
      exit false;
    end;
    exit true;
  end;

  num := Math.Max(length(a.fValue), length( b.fValue)) - 1;
  num2 := 0;
  if num2 <= num then begin
    inc(num);
    while (if num2 >= a.fValue.Length then (0) else (UInt32(a.fValue[num2]))) = (if num2 >= b.fValue.Length then (0) else (UInt32(b.fValue[num2]))) do begin
      inc(num2);
      if num2 = num then begin
        exit true;
      end;
    end;
    exit false;
  end;
  exit true;
end;

class operator &Set<T>.Subtract(a: &Set<T>; b: &Set<T>): &Set<T>;
begin
  if Object.ReferenceEquals(a, nil) then begin
    exit nil;
  end;
  if Object.ReferenceEquals(b, nil) then begin
    exit a;
  end;
  var lset: &Set<T> := new &Set<T>(new Byte[Math.Max(a.fValue.Length, b.fValue.Length)]);
  var num: Integer := a.fValue.Length - 1;
  var num2: Integer := 0;
  if num2 <= num then begin
    inc(num);
    repeat
      lset.fValue[num2] := a.fValue[num2];
      inc(num2);
    until not (num2 <> num);
  end;
  num := b.fValue.Length - 1;
  num2 := 0;
  if num2 <= num then begin
    inc(num);
    repeat
      lset.fValue[num2] := lset.fValue[num2] and not b.fValue[num2];
      inc(num2);
    until not(num2 <> num);
  end;
  exit lset;
end;

class operator &Set<T>.Add(a: &Set<T>; b: &Set<T>): &Set<T>;
begin
  if Object.ReferenceEquals(a, nil) and Object.ReferenceEquals(b, nil) then begin
    exit nil;
  end;
  if Object.ReferenceEquals(a, nil) then begin
    exit b;
  end;
  if Object.ReferenceEquals(b, nil) then begin
    exit a;
  end;
  var lset: &Set<T> := new &Set<T>(new Byte[Math.Max(a.fValue.Length, b.fValue.Length)]);
  var num: Integer := a.fValue.Length - 1;
  var num2: Integer := 0;
  if num2 <= num then begin
    inc(num);
    repeat
      lset.fValue[num2] := a.fValue[num2];
      inc(num2);
    until not (num2 <> num);
  end;
  num := b.fValue.Length - 1;
  num2 := 0;
  if num2 <= num then begin
    inc(num);
    repeat
      lset.fValue[num2] := lset.fValue[num2] or b.fValue[num2];
      inc(num2);
    until not (num2 <> num);
  end;
  exit lset;
end;

class method &Set<T>.FromData(params aData: array of T): &Set<T>;
begin
  exit aData;
end;

constructor &Set<T>(aData: array of Byte);
begin
  fValue := new Byte[length(aData)];
  if fValue.Length <> 0 then begin
    RemObjects.Elements.System.Array.Copy(aData, fValue, aData.Length);
  end;
end;

constructor &Set<T>(aSize: Integer);
begin
  if aSize > 1048576 then begin
    raise new IndexOutOfRangeException('aSize > 1048576');
  end;
  aSize := (aSize + 7) / 8;
  fValue := new Byte[aSize];
end;

constructor &Set<T>;
begin
  constructor(nil);
end;


method &Set<T>.NGetEnumerator: IEnumerator;
begin
  exit GetEnumerator();
end;

class method &Set<T>.Converter(val: T): Integer;
begin
  exit Convert.ToInt32(val);
end;


method &Set<T>.PutRange(aStart: Integer; aEnd: Integer; aVal: Boolean);
begin
  var num: Integer := aStart;
  if num <= aEnd then begin
    var num2: Integer := aEnd + 1;
    repeat
      if (num >= 0) and (num / 8 <  length(fValue)) then begin
        if aVal then begin
          fValue[num / 8] := Byte(UInt32(fValue[num / 8]) or (1 shl (num mod 8)));
        end
        else begin
          fValue[num / 8] := Byte(UInt32(fValue[num / 8]) and not 1 shl (num mod 8));
        end;
      end;
      inc(num);
    until not (num <> num2);
  end;
end;

method &Set<T>.Put(i: Integer; aVal: Boolean := true);
begin
  if (i >= 0) and (i / 8 <  length(fValue)) then begin
    if aVal then begin
      fValue[i / 8] := Byte(UInt32(fValue[i / 8]) or (1 shl (i mod 8)));
    end
    else begin
      fValue[i / 8] := Byte(UInt32(fValue[i / 8]) and not 1 shl (i mod 8));
    end;
  end;
end;

method &Set<T>.SetIterator.Dispose;
begin
end;

method &Set<T>.SetIterator.MoveNext: Boolean;
begin
  repeat
    if fIndex >= ((length(fOwner:fValue)) * 8) then begin
      exit false;
    end;
    inc(fIndex);
  until fOwner.Get(fIndex);
  exit true;
end;

method &Set<T>.SetIterator.Reset;
begin
  fIndex := -1;
end;

constructor &Set<T>.SetIterator(aValue: &Set<T>);
begin
  fOwner := aValue;
  Reset();
end;

end.