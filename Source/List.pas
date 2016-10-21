namespace RemObjects.Elements.System;

interface

type
  Predicate<T> = public delegate (Obj: T): Boolean;
  Comparison<T> = public delegate (x: T; y: T): Integer;

  ListEnumerator<T> = class(IEnumerator<T>)
  private
    fList: List<T>;
    fCurrentIndex: Integer;
    method GetCurrent: T;
    property NonGenCurrent: Object read GetCurrent; implements IEnumerator.Current;
  public
    constructor (aList: List<T>);
    method MoveNext: Boolean;
    property Current: T read GetCurrent;
    method Dispose;
  end;

  List<T> = public class(IEnumerable<T>, ICollection<T>)
  private
    fItems: array of T;
    fCount: Integer := 0;
    method SetItem(&Index: Integer; Value: T);
    method GetItem(&Index: Integer): T;
    method Grow(aCapacity: Integer);
    method RaiseError(aMessage: string);
    method CheckIndex(&Index: Integer);
    method IsEqual(Item1, Item2: T): Boolean;
    method CalcCapacity(aNewCapacity: Integer): Integer;
    method QuickSort(L,R: Integer;Comparison: Comparison<T>);
    method GetNonGenericEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit GetEnumerator;
    end;
  public
    constructor;
    constructor(aItems: List<T>);
    constructor(aArray: array of T);
    constructor(aSequence: ISequence<T>);
    constructor(aCapacity: Integer);

    method GetEnumerator: IEnumerator<T>;
    method &Add(anItem: T);
    method AddRange(Items: List<T>);
    method AddRange(Items: array of T);
    method Clear;
    method Contains(anItem: T): Boolean;

    method Exists(Match: Predicate<T>): Boolean;
    method FindIndex(Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;

    method Find(Match: Predicate<T>): T;
    method FindAll(Match: Predicate<T>): List<T>;
    method TrueForAll(Match: Predicate<T>): Boolean;
    method ForEach(Action: Action<T>);

    method IndexOf(anItem: T): Integer;
    method Insert(&Index: Integer; anItem: T);
    method InsertRange(&Index: Integer; Items: List<T>);
    method InsertRange(&Index: Integer; Items: array of T);
    method LastIndexOf(anItem: T): Integer;

    method &Remove(anItem: T): Boolean;
    method RemoveAt(&Index: Integer);
    method RemoveRange(&Index: Integer; aCount: Integer);

    method Sort(Comparison: Comparison<T>);

    method ToArray: array of T;

    property Capacity: Integer read length(fItems);

    property Count: Integer read fCount;
    property Item[i: Integer]: T read GetItem write SetItem; default;
  end;


implementation

constructor ListEnumerator<T>(aList: List<T>);
begin
  fList := aList;
  fCurrentIndex := -1;
end;

method ListEnumerator<T>.MoveNext: Boolean;
begin
  Result := fCurrentIndex < Length(fList)-1;
  if Result then Inc(fCurrentIndex);
end;

method ListEnumerator<T>.GetCurrent: T;
begin
  exit fList[fCurrentIndex];
end;

method ListEnumerator<T>.Dispose;
begin
end;

method List<T>.SetItem(&Index: Integer; Value: T);
begin
  CheckIndex(&Index);
  fItems[&Index] := Value;
end;

method List<T>.GetItem(&Index: Integer): T;
begin
  CheckIndex(&Index);
  exit fItems[&Index];
end;

constructor List<T>;
begin
  Clear;
end;

constructor List<T>(aItems: List<T>);
begin
  if assigned(aItems) then begin
    var lLength := aItems.Count;
    if lLength > 0 then begin
      Grow(lLength);
      for i: Integer := 0 to lLength-1 do
        SetItem(i, aItems[i]);
    end
    else begin
      Clear();
    end;
  end
  else begin
    Clear();
  end;
end;

constructor List<T>(aArray: array of T);
begin
  var lLength := length(aArray);
  if lLength > 0 then begin
    fCount := 0;
    Grow(lLength);
    fCount := lLength;
    for i: Integer := 0 to lLength-1 do
      SetItem(i, aArray[i]);    
  end
  else begin
    Clear();
  end;
end;

constructor List<T>(aSequence: ISequence<T>);
begin
  var lLength := aSequence.Count; // ineffficient; looks the sequence twice :(
  if lLength > 0 then begin
    for each s in aSequence do 
      &Add(s);
  end
  else begin
    Clear();
  end;
end;

constructor List<T>(aCapacity: Integer);
begin
  fCount := 0;
  Grow(aCapacity);
end;

method List<T>.Add(anItem: T);
begin
  if fCount = Capacity then Grow(Capacity+1);
  inc(fCount);
  SetItem(fCount-1, anItem);
end;

method List<T>.AddRange(Items: List<T>);
begin
  if (Items <> nil) and (Items.Count > 0) then begin
    if fCount + Items.Count >= Capacity then begin
      Grow(fCount + Items.Count);
    end;
    for i: Integer := 0 to Items.Count-1 do begin
      SetItem(fCount, Items[i]);
      inc(fCount);
    end;
  end;
end;

method List<T>.AddRange(Items: array of T);
begin
  if (length(Items)>0) then begin
    if fCount + Length(Items) >= Capacity then begin
      Grow(fCount + Items.Count);
    end;
    for i: Integer := 0 to length(Items)-1 do begin
      SetItem(fCount, Items[i]);
      inc(fCount);
    end;
  end;
end;

method List<T>.Clear;
begin
  fCount := 0;
  fItems := new array of T(0);
end;

method List<T>.Contains(anItem: T): Boolean;
begin
  for i : Integer := 0 to fCount-1 do
    if IsEqual(Item[i], anItem) then exit true;

  exit false;
end;

method List<T>.Exists(Match: Predicate<T>): Boolean;
begin
  for i : Integer := 0 to fCount-1 do
    if Match(Item[i]) then exit true;

  exit false;
end;

method List<T>.FindIndex(Match: Predicate<T>): Integer;
begin
  for i : Integer := 0 to fCount-1 do
    if Match(Item[i]) then exit i;

  exit -1;
end;

method List<T>.FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
begin
  exit FindIndex(StartIndex, fCount, Match);
end;

method List<T>.FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;
begin
  CheckIndex(StartIndex);
  for i : Integer := StartIndex to aCount-1 do
    if Match(Item[i]) then exit i;

  exit -1;
end;

method List<T>.Find(Match: Predicate<T>): T;
begin
  for i : Integer := 0 to fCount-1 do
    if Match(Item[i]) then exit Item[i];

  exit nil;
end;

method List<T>.FindAll(Match: Predicate<T>): List<T>;
begin
  result := new List<T>;
  for i : Integer := 0 to fCount-1 do
    if Match(Item[i]) then result.Add(Item[i]);
end;

method List<T>.TrueForAll(Match: Predicate<T>): Boolean;
begin
  for i : Integer := 0 to fCount-1 do
    if not Match(Item[i]) then exit false;

  exit true;
end;

method List<T>.ForEach(Action: Action<T>);
begin
  for i : Integer := 0 to fCount-1 do
    Action(Item[i]);
end;

method List<T>.IndexOf(anItem: T): Integer;
begin
  for i : Integer := 0 to fCount-1 do
    if IsEqual(Item[i], anItem) then exit i;

  exit -1;
end;

method List<T>.Insert(&Index: Integer; anItem: T);
begin
  InsertRange(&Index, [anItem]);
end;

method List<T>.InsertRange(&Index: Integer; Items: List<T>);
begin
  if Items = nil then RaiseError('Items must be assigned');
  InsertRange(&Index, Items.fItems);
end;

method List<T>.InsertRange(&Index: Integer; Items: array of T);
begin
  var it_len:= length(Items);
  if it_len = 0 then exit;
  if &Index <> fCount then CheckIndex(&Index);

  if fCount+it_len > Capacity then begin
    // insert into new array

    var newCapacity := fCount+it_len;
    var temp := new array of T(CalcCapacity(newCapacity));
    for i:Integer := 0  to &Index-1 do
      temp[i] := self[i];
    // insert new range
    for i:Integer := &Index to it_len-1 do
      temp[i] := Items[i];
    // copy old rest
    for i:Integer := &Index to fcount-1 do
      temp[i+&Index] := self[i];
    fItems := temp;
    fCount := newCapacity;
  end
  else begin
    // insert into existing array
    //move existing part
    for i:Integer := fCount-1 downto &Index do
      self[i+it_len] := self[i];

    // insert new range
    for i:Integer := &Index to it_len-1 do
      self[i] := Items[i];
    inc(fCount, it_len);
end;
end;

method List<T>.LastIndexOf(anItem: T): Integer;
begin
  for i : Integer := fCount-1 downto 0 do
    if IsEqual(Item[i], anItem) then exit i;

  exit -1;
end;

method List<T>.Remove(anItem: T): Boolean;
begin
  var i := IndexOf(anItem);
  if i = -1 then exit false;
  RemoveRange(i, 1);
  exit true;
end;

method List<T>.RemoveAt(&Index: Integer);
begin
  CheckIndex(&Index);
  RemoveRange(&Index,1);
end;

method List<T>.RemoveRange(&Index: Integer; aCount: Integer);
begin
  CheckIndex(&Index);
  if aCount = 0 then exit;
  if (aCount < 0) or (&Index + aCount > fCount) then raiseError('aCount does not denote a valid range of elements');

  var newlength := fCount-aCount;
  {$IFDEF WINDOWS}ExternalCalls.{$ELSEIF POSIX}rtl.{$ELSE}{$ERROR}{$ENDIF}memmove(@fItems[&Index], @fItems[&Index+aCount], (newlength-&Index) * SizeOf(T));
  {$IFDEF WINDOWS}ExternalCalls.{$ELSEIF POSIX}rtl.{$ELSE}{$ERROR}{$ENDIF}memset(@fItems[newlength], 0, (fCount - newlength) * sizeOf(T));
  fCount := newlength;
end;

method List<T>.Sort(Comparison: Comparison<T>);
begin
  QuickSort(0, fCount-1, Comparison);
end;

method List<T>.ToArray: array of T;
begin
  result := new array of T(fCount);
  for i: Integer :=0 to fCount -1 do
    result[i] := self[i];
end;

method List<T>.Grow(aCapacity: Integer);
begin
  aCapacity := CalcCapacity(aCapacity);
  var newarray := new array of T(aCapacity);
  for i: Integer := 0 to fCount-1 do
    newarray[i] := fItems[i];
  fItems := newarray;
end;

method List<T>.RaiseError(aMessage: String);
begin
  raise new Exception(aMessage);
end;

method List<T>.CheckIndex(&Index: Integer);
begin
  if (&Index < 0) or (Index >= Count) then RaiseError('Index was out of range.');
end;

method List<T>.IsEqual(Item1: T; Item2: T): Boolean;
begin
  if (Item1 = nil) and (Item2 = nil) then exit true;
  if (Item1 = nil) or (Item2 = nil) then exit false;
  exit Item1.Equals(Item2);
end;

method List<T>.CalcCapacity(aNewCapacity: Integer): Integer;
begin
  var ldelta: integer;
  if aNewCapacity > 64 then ldelta := aNewCapacity / 4
  else if aNewCapacity > 8 then ldelta := 16
  else lDelta := 4;
  exit aNewCapacity + lDelta;
end;


method List<T>.QuickSort(L: Integer; R: Integer; Comparison: Comparison<T>);
begin
  var I, J: Integer;
  var P: T;
  var temp: T;
  if fCount < 2 then Exit;
  repeat
    I := L;
    J := R;
    P := fitems[(L + R) shr 1];
    repeat
      while Comparison(fitems[I], P) < 0 do Inc(I);
      while Comparison(fitems[j], P) > 0 do Dec(J);
      if I <= J then begin
        temp := fitems[I];
        fitems[I]:=fitems[J];
        fitems[J]:= temp;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, Comparison);
    L := I;
  until I >= R;
end;

method List<T>.GetEnumerator: IEnumerator<T>;
begin
  exit new ListEnumerator<T>(Self);
end;


end.
