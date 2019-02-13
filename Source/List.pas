namespace RemObjects.Elements.System;

interface

type
  Predicate<T> = public delegate (Obj: T): Boolean;
  Comparison<T> = public delegate (x: T; y: T): Integer;

  ListEnumerator<T> = public class(IEnumerator<T>)
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

  List<T> = public class(IEnumerable<T>, ICollection<T>, IList, IList<T>)
  private
    fItems: array of T;
    fCount: Integer := 0;
    method set_IntItem(i: Integer; value: Object);
    begin
      SetItem(i, T(value));
    end;

    method SetItem(&Index: Integer; Value: T);
    method GetItem(&Index: Integer): T;
    method Grow(aCapacity: Integer);
    method RaiseError(aMessage: String);
    method CheckIndex(&Index: Integer);
    method CheckCapacity(&Index: Integer);
    method IsEqual(Item1, Item2: T): Boolean;
    method CalcCapacity(aNewCapacity: Integer): Integer;
    method QuickSort(L,R: Integer;Comparison: Comparison<T>);
    method GetNonGenericEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit GetEnumerator;
    end;

    method &Add(val: Object);
    begin
      Add(T(val));
    end;

    method &Remove(val: Object): Boolean;
    begin
      exit Remove(T(val));
    end;

    method Contains(val: Object): Boolean;
    begin
      exit Contains(T(val));
    end;

    property IntItem[i: Integer]: Object read Item[i] write set_IntItem; implements IList.Item;
  public
    constructor;
    constructor(aItems: List<T>);
    constructor(aArray: array of T);
    constructor(aSequence: ISequence<T>);
    constructor(aCapacity: Integer);

    {$IF DARWIN}
    constructor(aArray: Foundation.NSArray<T>);
    begin
      constructor(aArray.count);
      for i: Integer := 0 to aArray.count-1 do
        &Add(aArray[i]);
    end;

    method ToNSArray: Foundation.NSArray<T>; inline;
    begin
      result := ToNSMutableArray();
    end;

    method ToNSMutableArray: Foundation.NSMutableArray<T>;
    begin
      var lResult := new Foundation.NSMutableArray<T> withCapacity(Count);
      for i: Integer := 0 to Count-1 do
        lResult.addObject(self[i]);
      result := lResult;
    end;
    {$ENDIF}

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
    method CopyTo(&array: array of T);
    method CopyTo(&array: array of T; arrayIndex: Integer);
    {$HIDE W27}
    method CopyTo(&index: Integer; &array: array of T; arrayIndex: Integer; &count: Integer);
    {$SHOW W27}

    property Capacity: Integer read length(fItems);

    property Count: Integer read fCount;
    property Item[i: Integer]: T read GetItem write SetItem; default;
  end;

  LinkedListNode<T> = public class
  public
    constructor(aValue: T; aPrev: LinkedListNode<T>);
    begin
      Previous := aPrev;
      Value := aValue;
    end;
    property Value: T; readonly;
    property Previous: LinkedListNode<T>; readonly;
  end;

implementation

constructor ListEnumerator<T>(aList: List<T>);
begin
  fList := aList;
  fCurrentIndex := -1;
end;

method ListEnumerator<T>.MoveNext: Boolean;
begin
  Result := fCurrentIndex < length(fList)-1;
  if Result then inc(fCurrentIndex);
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
  CheckCapacity(&Index);
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
        fItems[i] := aItems[i];
      fCount := lLength;
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
    for i: Integer := 0 to lLength-1 do
      fItems[i] := aArray[i];
    fCount := lLength;
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
  fItems[fCount] := anItem;
  inc(fCount);
end;

method List<T>.AddRange(Items: List<T>);
begin
  if (Items <> nil) and (Items.Count > 0) then begin
    if fCount + Items.Count >= Capacity then begin
      Grow(fCount + Items.Count);
    end;
    for i: Integer := 0 to Items.Count-1 do begin
      fItems[fCount] := Items[i];
      inc(fCount);
    end;
  end;
end;

method List<T>.AddRange(Items: array of T);
begin
  if (length(Items)>0) then begin
    if fCount + length(Items) >= Capacity then begin
      Grow(fCount + Items.Count);
    end;
    for i: Integer := 0 to length(Items)-1 do begin
      fItems[fCount] := Items[i];
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
    for i:Integer := 0 to it_len-1 do
      temp[i + &Index] := Items[i];
    // copy old rest
    for i:Integer := &Index to fCount-1 do
      temp[i+&Index+it_len] := self[i];
    fItems := temp;
    fCount := newCapacity;
  end
  else begin
    // insert into existing array
    //move existing part
    for i:Integer := fCount-1 downto &Index do
      self[i+it_len] := self[i];

    // insert new range
    for i:Integer := 0 to it_len-1 do
      self[i+&Index] := Items[i];
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
  if (aCount < 0) or (&Index + aCount > fCount) then RaiseError('aCount does not denote a valid range of elements');

  var newlength := fCount-aCount;
  memmove(@fItems[&Index], @fItems[&Index+aCount], (newlength-&Index) * sizeOf(T));
  memset(@fItems[newlength], 0, (fCount - newlength) * sizeOf(T));
  fCount := newlength;
end;

method List<T>.Sort(Comparison: Comparison<T>);
begin
  QuickSort(0, fCount-1, Comparison);
end;

method List<T>.ToArray: array of T;
begin
  result := new array of T(fCount);
  CopyTo(result);
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
  if (&Index < 0) or (&Index >= Count) then RaiseError('Index was out of range.');
end;

method List<T>.CheckCapacity(&Index: Integer);
begin
  if (&Index < 0) or (&Index >= Capacity) then RaiseError('Index was out of range.');
end;

method List<T>.IsEqual(Item1: T; Item2: T): Boolean;
begin
  if (Item1 = nil) and (Item2 = nil) then exit true;
  if (Item1 = nil) or (Item2 = nil) then exit false;
  exit Item1.Equals(Item2);
end;

method List<T>.CalcCapacity(aNewCapacity: Integer): Integer;
begin
  var lDelta: Integer;
  if aNewCapacity > 64 then lDelta := aNewCapacity / 4
  else if aNewCapacity > 8 then lDelta := 16
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
    P := fItems[(L + R) shr 1];
    repeat
      while Comparison(fItems[I], P) < 0 do inc(I);
      while Comparison(fItems[J], P) > 0 do dec(J);
      if I <= J then begin
        temp := fItems[I];
        fItems[I]:=fItems[J];
        fItems[J]:= temp;
        inc(I);
        dec(J);
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

method List<T>.CopyTo(&array: array of T);
begin
  if length(&array)< fCount then new ArgumentException('The number of elements in the source List<T> is greater than the number of elements that the destination array can contain.');
  CopyTo(0, &array, 0, fCount);
end;

method List<T>.CopyTo(&array: array of T; arrayIndex: Integer);
begin
  if arrayIndex <0 then new ArgumentOutOfRangeException('arrayIndex is less than 0.');
  if length(&array)< fCount+arrayIndex then new ArgumentException('The number of elements in the source List<T> is greater than the available space from arrayIndex to the end of the destination array.');
  CopyTo(0, &array, arrayIndex, fCount);
end;

method List<T>.CopyTo(&index: Integer; &array: array of T; arrayIndex: Integer; &count: Integer);
begin
  if not assigned(&array) then new ArgumentNullException('array is nil.');
  if &index <0 then new ArgumentOutOfRangeException('index is less than 0.');
  if arrayIndex <0 then new ArgumentOutOfRangeException('arrayIndex is less than 0.');
  if &count <0 then new ArgumentOutOfRangeException('count is less than 0.');
  if &index >= fCount then new ArgumentException('index is equal to or greater than the Count of the source List<T>.');
  if &index+&count > fCount then new ArgumentException('index plus count is greater than the Count of the source List<T>.');
  if arrayIndex+&count > length(&array) then new ArgumentException('count is greater than the available space from arrayIndex to the end of the destination array.');

  for i:Integer := 0 to &count -1 do
    &array[arrayIndex+i] := fItems[&index+i];
end;


end.