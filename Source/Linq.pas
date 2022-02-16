namespace RemObjects.Elements.System;
{$IFDEF DARWIN}
uses Foundation;
{$ENDIF}

extension method ISequence<T>.Count(): Integer; public;
begin
  for each in self do inc(result);
end;

extension method ISequence<T>.Count(aCondition: not nullable block(aItem: not nullable T): Boolean): Integer; public;
begin
  for each el in self do if aCondition(el) then inc(result);
end;

extension method ISequence<T>.Where(aBlock: not nullable block(aItem: not nullable T): Boolean): /*not nullable*/ ISequence<T>; public; iterator;
begin
  for each el in self do begin
    if aBlock(el) then
      yield el;
  end;
end;

extension method ISequence<T>.Any(aBlock: not nullable block(aItem: not nullable T): Boolean): Boolean; public;
begin
  for each el in self do
    if aBlock(el) then exit true;
end;

extension method ISequence<T>.Take(aCount: Integer): /*not nullable*/ ISequence<T>; public; iterator;
begin
  for each el in self index n do begin
    if n >= aCount then break;
    yield el;
  end;
end;

extension method ISequence<T>.Skip(aCount: Integer): /*not nullable*/ ISequence<T>; public; iterator;
begin
  for each el in self index n do begin
    if n < aCount then continue;
    yield el;
  end;
end;

extension method ISequence<T>.TakeWhile(aBlock: not nullable block(aItem: not nullable T): Boolean): /*not nullable*/ ISequence<T>; public; iterator;
begin
  for each el in self do begin
    if not aBlock(el) then break;
    yield el;
  end;
end;

extension method ISequence<T>.SkipWhile(aBlock: not nullable block(aItem: not nullable T): Boolean): /*not nullable*/ ISequence<T>; public; iterator;
begin
  var lFound := false;
  for each el in self do begin
    if not lFound and not aBlock(el) then
      lFound := true;
    if lFound then
      yield el;
  end;
end;

extension method ISequence<T>.OrderBy<C>(aBlock: not nullable block(aItem: not nullable T): C): /*not nullable*/ IOrderedSequence<T>; public;
begin
  exit new OrderedSequence<T>(self, (a, b) -> (aBlock(a) as IComparable).CompareTo(aBlock(b)));
end;

extension method ISequence<T>.OrderByDescending<C>(aBlock: not nullable block(aItem: not nullable T): C): /*not nullable*/ ISequence<T>; public;
begin
  exit new OrderedSequence<T>(self, (a, b) -> (aBlock(b) as IComparable).CompareTo(aBlock(a)));
end;

extension method IOrderedSequence<T>.ThenBy<C>(aBlock: not nullable block(aItem: not nullable T): C): /*not nullable*/ IOrderedSequence<T>; public;
begin
  var lOrg := self.Comparison;
  exit new OrderedSequence<T>(self.Original,
    (a, b) -> begin
      result := lOrg(a, b);
      if result = 0 then
        result := (aBlock(a) as IComparable).CompareTo(aBlock(b));
     end);
end;

extension method IOrderedSequence<T>.ThenByDescending<C>(aBlock: not nullable block(aItem: not nullable T): C): /*not nullable*/ IOrderedSequence<T>; public;
begin
  var lOrg := self.Comparison;
  exit new OrderedSequence<T>(self.Original,
    (a, b) -> begin
      result := lOrg(a, b);
      if result = 0 then
        result := (aBlock(b) as IComparable).CompareTo(aBlock(a));
     end);
end;

extension method ISequence<T>.Select<T, U>(aBlock: not nullable block(aItem: not nullable T): U): /*not nullable*/ ISequence<U>; public; iterator;
begin
  for each el in self do
    yield aBlock(el);
end;

extension method ISequence<T>.SelectMany<T, U>(aBlock: not nullable block(aItem: not nullable T): nullable sequence of U): /*not nullable*/ ISequence<U>; public; iterator;
begin
  for each el in self do begin
    for each subval in aBlock(el) do
      yield subval;
  end;
end;

extension method ISequence<T>.SelectMany<T, U, TRes>(aBlock: not nullable block(aItem: not nullable T): nullable sequence of U; aSelector: not nullable block(aOriginal: not nullable T; aNew: U): TRes): /*not nullable*/ ISequence<TRes>; public; iterator;
begin
  for each el in self do begin
    for each subval in aBlock(el) do
      yield aSelector(el, subval);
  end;
end;

extension method ISequence<T>.Cast<U>: /*not nullable*/ ISequence<U>; public; iterator;
begin
  for each el in self do
    yield el as U;
end;

extension method IEnumerable.Cast<U>: /*not nullable*/ ISequence<U>; public; iterator;
begin
  for each el in self do
    yield el as U;
end;

extension method IEnumerable.OfType<U>: /*not nullable*/ ISequence<U>; public; iterator;
begin
  for each el in self do
    if el is U then
      yield el as U;
end;

extension method ISequence<T>.Concat(aSecond: not nullable ISequence<T>): /*not nullable*/ ISequence<T>; public; iterator;
begin
  for each el in self do yield el;
  for each el in aSecond do yield el;
end;

extension method ISequence<T>.Reverse: /*not nullable*/ ISequence<T>; public; iterator;
begin
  var lList := self.ToList();
  for i: Integer := lList.Count -1 downto 0 do
    yield lList[i];
end;

extension method ISequence<T>.Distinct(aComparator: block(a, b: T): Integer := nil): /*not nullable*/ ISequence<T>; public; iterator;
begin
  var b: IEqualityComparer<T>;
  if assigned(aComparator) then
    b := new EqualityComparer<T>(aComparator)
  else
    b:= new DefaultEqualityComparer<T>;
  var list := new HashSet<T>(b);
  for each el in self do
    if list.Add(el) then yield el;
end;

extension method ISequence<T>.Intersect(aSecond: not nullable ISequence<T>; aComparator: block(a, b: T): Integer := nil): /*not nullable*/ ISequence<T>; public;iterator;
begin
  var b: IEqualityComparer<T>;
  if assigned(aComparator) then
    b := new EqualityComparer<T>(aComparator)
  else
    b:= new DefaultEqualityComparer<T>;
  var list := new HashSet<T>(b);
  for each el in aSecond do
    list.Add(el);
  for each el in self do
    if list.Contains(el) then yield el;
end;

extension method ISequence<T>.Except(aSecond: not nullable ISequence<T>; aComparator: block(a, b: T): Integer := nil): /*not nullable*/ ISequence<T>; public; iterator;
begin
  var b: IEqualityComparer<T>;
  if assigned(aComparator) then
    b := new EqualityComparer<T>(aComparator)
  else
    b:= new DefaultEqualityComparer<T>;
  var list := new HashSet<T>(b);
  for each el in aSecond do
    list.Add(el);
  for each el in self do
    if not list.Contains(el) then yield el;
end;

extension method ISequence<T>.First: T; public;
begin
  for each el in self do
    exit el;
  raise new Exception("Sequence is empty");
end;

extension method ISequence<T>.FirstOrDefault: nullable T; public;
begin
  for each el in self do
    exit el;
end;

extension method ISequence<T>.First(aBlock: not nullable block(aItem: not nullable T): Boolean): T; public;
begin
  for each el in self do
    if aBlock(el) then
      exit  el;
  raise new Exception("Sequence is empty");
end;

extension method ISequence<T>.FirstOrDefault(aBlock: not nullable block(aItem: not nullable T): Boolean): nullable T; public;
begin
  for each el in self do
    if aBlock(el) then
      exit  el;
end;

extension method ISequence<T>.Min: nullable T; public;
begin
  for each i in self do
    if not assigned(result) or (assigned(i) and ((result as IComparable).CompareTo(i) < 0)) then
      result := i;
end;

extension method ISequence<T>.Min<T,U>(aBlock: not nullable block(aItem: not nullable T): U): nullable U; public;
begin
  for each i in self do begin
    var i2 := aBlock(i);
    if not assigned(result) or (assigned(i2) and ((i2 as IComparable).CompareTo(i) < 0)) then
      result := i2;
  end;
end;

extension method ISequence<T>.Max: nullable T; public;
begin
  for each i in self do
    if not assigned(result) or (assigned(i) and ((result as IComparable).CompareTo(i) > 0)) then
      result := i;
end;

extension method ISequence<T>.Max<T,U>(aBlock: not nullable block(aItem: not nullable T): U): nullable U; public;
begin
  for each i in self do begin
    var i2 := aBlock(i);
    if not assigned(result) or (assigned(i2) and ((i2 as IComparable).CompareTo(i) > 0)) then
      result := i2;
  end;
end;

extension method ISequence<T>.Contains(aItem: T): Boolean; public;
begin
  for each el in self do begin
    if not assigned(el) then begin
      if not assigned(aItem) then
        exit true;
    end
    else if (el as IComparable).CompareTo(aItem) = 0 then
      exit true;
  end;
end;

extension method ISequence<T>.Any(): Boolean; public;
begin
  for each in self do
    exit true;
end;

extension method ISequence<T>.ToArray(): not nullable array of T; public;
begin
  if self is array of T then exit self as array of T;
  if self is List<T> then exit (self as List<T>).ToArray() as not nullable array of T;
  exit self.ToList().ToArray as not nullable;
end;

extension method ISequence<T>.ToImmutableList(): not nullable ImmutableList<T>; public;
begin
  if self is ImmutableList<T> then exit self as ImmutableList<T>;
  if self is array of T then exit new ImmutableList<T>(self as array of T);
  result := new ImmutableList<T>(self);
end;

extension method ISequence<T>.ToList(): not nullable List<T>; public;
begin
  if self is List<T> then exit self as List<T>;
  if self is array of T then exit new List<T>(self as array of T);
  result := new List<T>(self);
end;

type
  Enumerable<T> = class
  public
    class var Empty: array of T := new T[0];
  end;

  IOrderedSequence<T> = public interface(ISequence<T>)
    property Original: ISequence<T> read;
    property Comparison: Comparison<T> read;
  end;
  OrderedSequence<T> = class(ISequence<T>, IOrderedSequence<T>)
  public
    constructor(aSeq: ISequence<T>; aComp: Comparison<T>);
    begin
      Original := aSeq;
      Comparison := aComp;
    end;

    property Original: ISequence<T>; readonly;
    property Comparison: Comparison<T>; readonly;

    method GetEnumerator: IEnumerator<T>;
    begin
      var lSeq := Original.ToList;
      lSeq.Sort(Comparison);
      exit lSeq.GetEnumerator;
    end;


    method GetEnumerator2: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit GetEnumerator;
    end;
  end;

type

  IGroupingSequence<TKey, TElement> = public interface(ISequence<TElement>)
    property Key: TKey read;
  end;


  ILookup<TKey, TElement> = public interface(ISequence<IGroupingSequence<TKey, TElement>>)
    property Count : Integer read;
    method Contains(const key: TKey): Boolean;
    property Item[const key: TKey]: ISequence<TElement> read ; default;
  end;


  GroupingSequence<TKey, TElement> = class(IGroupingSequence<TKey,TElement>)
  private
    fKey: TKey;
    fElements: List<TElement>;
    property Key : TKey read fKey;

    method GetEnumerator: IEnumerator<TElement>;
    begin
      exit fElements.GetEnumerator;
    end;

    method GetEnumerator2: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit GetEnumerator;
    end;

  public

    constructor (const aKey: TKey);
    begin
      fKey := aKey;
      fElements := new List<TElement>;
    end;

    method AddElement(const item: TElement);
    begin
      fElements.Add(item);
    end;

  end;


  Lookup<TKey, TElement> = class(ILookup<TKey, TElement>)
  private
    fGroupings: List<IGroupingSequence<TKey,TElement>>;
    fGroupingKeys: Dictionary<TKey, GroupingSequence<TKey,TElement>>;

    method GetGrouping(const Key: TKey; DoCreate: Boolean): GroupingSequence<TKey, TElement>;
    begin
      var res : GroupingSequence<TKey,TElement>;
      if fGroupingKeys.TryGetValue(Key, out res) then exit res else

        if DoCreate then
        begin
          var grouping := new GroupingSequence<TKey,TElement>(Key);
          fGroupings.Add(grouping);
          fGroupingKeys.Add(Key, grouping);
          result := grouping;
        end
        else
          result := nil;
    end;

    method GetEnumerator: IEnumerator<IGroupingSequence<TKey,TElement>>;
    begin
      result := fGroupings.GetEnumerator;
    end;

    method GetEnumerator2: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit GetEnumerator;
    end;

    method Contains(key: TKey): Boolean;
    begin
      result := GetGrouping(key, false) <> nil;
    end;

      method Get_Item(key: TKey): ISequence<TElement>;
      begin
        result := GetGrouping(key, false);
        if result = nil then
          result := Enumerable<TElement>.Empty;
      end;

      property Count : Integer read fGroupings.Count;

    public
      constructor(aComparer: IEqualityComparer<TKey> := nil);
      begin
        fGroupings:= new List<IGroupingSequence<TKey,TElement>>;
        fGroupingKeys:= new Dictionary<TKey, GroupingSequence<TKey,TElement>>(aComparer);
      end;


      class method Create<TSource>(const source: ISequence<TSource>;
        KeySelector: method (item: TSource): TKey;
        ElementSelector: method (item: TSource): TElement;
        aComp: IEqualityComparer<TKey> := nil): Lookup<TKey, TElement>;
      begin
        var lResult := new Lookup<TKey, TElement>(aComp);

        for item in source do begin
          lResult.GetGrouping(KeySelector(item), True).AddElement(ElementSelector(item));
        end;

        exit lResult;
      end;

    end;

extension method ISequence<T>.ToDictionary<TKey, TValue>(
  aKeySelector: not nullable block (Item : T): TKey;
  aValueSelector: not nullable block (Item : T): TValue): not nullable Dictionary<TKey, TValue>; public;
begin
  result := new Dictionary<TKey, TValue>;
  for each el in self do
    result.Add(aKeySelector(el), aValueSelector(el));
end;


extension method ISequence<T>.ToDictionary<TKey, TValue>(
  aKeySelector: not nullable block (Item : T): TKey;
  aValueSelector: not nullable block (Item : T): TValue;
  aComparer: nullable IEqualityComparer<TKey>): not nullable Dictionary<TKey,TValue>; public;
begin
  result := new Dictionary<TKey, TValue>(aComparer);
  for each el in self do
    result.Add(aKeySelector(el), aValueSelector(el));
end;



extension method ISequence<T>.EqualsTo(const collection: ISequence<T>): Boolean; public;
begin
  var e1 := self.GetEnumerator;
  var e2 := collection.GetEnumerator;

  while e1.MoveNext do
    if not (e2.MoveNext and e1.Current.Equals(e2.Current)) then
      Exit False;
  Result := not e2.MoveNext;
end;


extension method ISequence<T>.GroupBy<TKey>(aKeySelector : not nullable block (Item: T): TKey;
  aComparer: IEqualityComparer<TKey> := nil): ISequence<IGroupingSequence<TKey, T>>; public;
begin
  result := Lookup<TKey,T>.Create<T>(self, aKeySelector, x -> x, aComparer);
end;

extension method ISequence<T>.GroupBy<TKey, TValue>(
  aKeySelector: not nullable block(Item : T): TKey;
  aValueSelector: not nullable block(Item : T): TValue;
  aComparer: IEqualityComparer<TKey> := nil
  ): ISequence<IGroupingSequence<TKey, TValue>>; public;
begin
  result := Lookup<TKey, TValue>.Create<T>(self, aKeySelector, aValueSelector, aComparer)
end;

extension method ISequence<T>.ToLookup<TKey>(aKeySelector : not nullable block (Item: T): TKey;
  aComparer: IEqualityComparer<TKey> := nil): ILookup<TKey, T>; public;
begin
  result := Lookup<TKey,T>.Create<T>(self, aKeySelector, x -> x, aComparer);
end;

extension method ISequence<T>.ToLookup<TKey, TValue>(
  aKeySelector: not nullable block(Item : T): TKey;
  aValueSelector: not nullable block(Item : T): TValue;
  aComparer: IEqualityComparer<TKey> := nil): ILookup<TKey, TValue>; public;
begin
  result := Lookup<TKey, TValue>.Create<T>(self, aKeySelector, aValueSelector, aComparer)
end;

extension method ISequence<TOuter>.Join<TOuter, TInner, TKey, TResult>(aInner: ISequence<TInner>;
  aOuterKeySelector: method (item: TOuter): TKey;
  aInnerKeySelector: method (item: TInner): TKey;
  aResultSelector: method (item: TOuter; item2: TInner): TResult;
  aComparer: IEqualityComparer<TKey> := nil): ISequence<TResult>; public; iterator;
begin
  if aComparer = nil then aComparer := DefaultEqualityComparer<TKey>.Instance;
  var lLookup := aInner.ToLookup(aInnerKeySelector, aComparer);
  for each el in self do begin
    for each item in lLookup[aOuterKeySelector(el)] do
      yield aResultSelector(el, item);
  end;
end;


{$IF DARWIN}
extension method ISequence<T>.ToNSMutableArray: not nullable Foundation.NSMutableArray<T>; public;
begin
  var lResult := new Foundation.NSMutableArray<T> as not nullable;
  for each i in self do
    lResult.addObject(i);
  result := lResult;
end;

extension method ISequence<T>.ToNSArray: not nullable Foundation.NSArray<T>;  public; inline;
begin
  result := ToNSMutableArray();
end;


type
  PredicateBlock = public block(aItem: not nullable id): Boolean;
  IDBlock = public block(aItem: not nullable id): id;
  ForSelector<T> = public delegate(aIndex: Integer): T;
  [Cocoa]
  INSGrouping<K,T> = public interface(RemObjects.Elements.System.INSFastEnumeration<T>)
    property Key: K read;
  end;

extension method Foundation.INSFastEnumeration.Where(aBlock: not nullable PredicateBlock): not nullable Foundation.INSFastEnumeration; public; iterator;
begin
  for each i in self do
    if aBlock(i) then yield i;
end;

extension method Foundation.INSFastEnumeration.Any(aBlock: not nullable PredicateBlock): Boolean;public;
begin
  for each i in self do
    if aBlock(i) then exit true;
end;

extension method Foundation.INSFastEnumeration.Take(aCount: NSInteger): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObjects: array[0..LOOP_SIZE-1] of id;

  var lCount := 0;
  while lCount < aCount do begin
    var lNext := if aCount-lCount < 16 then aCount-lCount else LOOP_SIZE; //MIN(aCount-lCount, 16);
    var lGot := Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(lObjects) count(lNext); //cast is workaround, remove;
    if lGot = 0 then break;
    if lGot > lNext then lGot := lNext;
    for i: NSInteger := 0 to lGot-1 do
      yield lState.itemsPtr[i];
    lCount := lCount+lGot;
  end;
end;

extension method Foundation.INSFastEnumeration.Skip(aCount: NSInteger): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObjects: array[0..LOOP_SIZE-1] of id;

  var lCount := 0;
  loop begin
    var lNext := LOOP_SIZE;
    var lGot := Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(lObjects) count(lNext); //cast is workaround, remove;
    if lGot = 0 then break;
    for i: NSInteger := 0 to lGot-1 do begin
      if lCount < aCount then
        inc(lCount)
      else
        yield lState.itemsPtr[i];
    end;
  end;
end;

extension method Foundation.INSFastEnumeration.TakeWhile(aBlock: not nullable PredicateBlock): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObjects: array[0..LOOP_SIZE] of id;

  loop begin
    var lGot := Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(lObjects) count(LOOP_SIZE); //cast is workaround, remove;
    if lGot = 0 then break;
    for i: NSInteger := 0 to lGot-1 do begin
      if not aBlock(lState.itemsPtr[i]) then exit;
      yield lState.itemsPtr[i];
    end;
  end;
end;

// Segmentation fault: 11: 65577: Toffee: Passing "array of id" to ^id parameter
extension method Foundation.INSFastEnumeration.SkipWhile(aBlock: not nullable PredicateBlock): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObjects: array[0..LOOP_SIZE-1] of id;

  var lFound := false;
  loop begin
    var lGot := Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(lObjects) count(LOOP_SIZE); //cast is workaround, remove;
    if lGot = 0 then break;
    for i: NSInteger := 0 to lGot-1 do begin
      if not lFound then
        if not aBlock(lState.itemsPtr[i]) then lFound := true;
      if lFound then
        yield lState.itemsPtr[i];
    end;
  end;
end;

//
// Order by
//

extension method Foundation.INSFastEnumeration.orderBy(aBlock: not nullable block(aItem: id): id) comparator(aComparator: NSComparator): not nullable Foundation.INSFastEnumeration;public;
begin
  result := self.ToNSArray().sortedArrayUsingComparator(aComparator) as not nullable;
end;

extension method Foundation.INSFastEnumeration.OrderBy(aBlock: not nullable IDBlock): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lOrdered := orderBy(aBlock) comparator( (a,b) -> begin
      var va := aBlock(a);
      var vb := aBlock(b);
      if va = nil then
        if vb = nil then exit NSComparisonResult.OrderedSame else exit NSComparisonResult.OrderedAscending;
      if vb = nil then exit NSComparisonResult.OrderedDescending;
      exit va.compare(vb)
    end);
  for each i in lOrdered do
    yield i;
end;

extension method Foundation.INSFastEnumeration.OrderByDescending(aBlock: not nullable IDBlock): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lOrdered := orderBy(aBlock) comparator( (a,b) -> begin
      var va := aBlock(a);
      var vb := aBlock(b);
      if va = nil then
        if vb = nil then exit NSComparisonResult.OrderedSame else exit NSComparisonResult.OrderedDescending;
        if vb = nil then exit NSComparisonResult.OrderedAscending;
      exit vb.compare(va)
    end);
  for each i in lOrdered do
    yield i;
end;

type
  [Cocoa]
  NSGrouping<K,T> = class(NSObject, INSGrouping<K,T>)
  private
    var fArray := new NSMutableArray; implements public RemObjects.Elements.System.INSFastEnumeration<T>;
  unit
    method addObject(aValue: T);
    begin
      fArray.addObject(aValue);
    end;
  public
    property Key: K read write;
  end;

extension method Foundation.INSFastEnumeration.GroupBy(aBlock: not nullable IDBlock): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lDictionary := new NSMutableDictionary;
  for each i in self do begin
    var lKey := aBlock(i);
    var lGrouping: NSGrouping<id,id> := lDictionary[lKey];
    if not assigned(lGrouping) then begin
      lGrouping := new NSGrouping<id,id>();
      lGrouping.Key := lKey;
      lDictionary[lKey] := lGrouping;
    end;
    lGrouping.addObject(i);
  end;
  for each g in lDictionary.allValues do
    yield g;
end;

//
// Select
//
extension method Foundation.INSFastEnumeration.Select(aBlock: not nullable IDBlock): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  for each i in self do
    yield aBlock(i);
end;

extension method Foundation.INSFastEnumeration.OfType<R>(): not nullable RemObjects.Elements.System.INSFastEnumeration<R>;public;iterator;
begin
  for each i in self do begin
    var i2 := R(i);
    if assigned(i2) then
      yield i2;
  end;
end;

//
//
//
extension method Foundation.INSFastEnumeration.Concat(aSecond: not nullable Foundation.INSFastEnumeration): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  for each i in self do
    yield i;
  if assigned(aSecond) then
    for each i in aSecond do
      yield i;
end;

extension method Foundation.INSFastEnumeration.Reverse: not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lArray := self.ToNSArray();
  for i: NSInteger := lArray.count-1 downto 0 do
    yield lArray[i];
end;

//
// Set Operators
//
extension method Foundation.INSFastEnumeration.Distinct(aComparator: NSComparator := nil): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lReturned := new NSMutableArray;
  for each i in self do
    if not lReturned.containsObject(i) then begin
      lReturned.addObject(i);
      yield i;
    end;
end;

extension method Foundation.INSFastEnumeration.Intersect(aSecond: not nullable Foundation.INSFastEnumeration; aComparator: NSComparator := nil): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lSecond := aSecond.ToNSArray();
  for each i in self do
    if lSecond.containsObject(i) then
      yield i;
end;

extension method Foundation.INSFastEnumeration.Except(aSecond: not nullable Foundation.INSFastEnumeration; aComparator: NSComparator := nil): not nullable Foundation.INSFastEnumeration;public;iterator;
begin
  var lFirst := self.Distinct().ToNSArray();
  var lSecond := aSecond.Distinct().ToNSArray();
  for each i in lFirst do
    if not lSecond.containsObject(i) then
      yield i;
  for each i in lSecond do
    if not lFirst.containsObject(i) then
      yield i;
end;


//
// Helpers
//


extension method Foundation.INSFastEnumeration.Contains(aItem: id): Boolean; public;
begin
  if self is NSArray then
    exit (self as NSArray).containsObject(aItem);
  for each i in self do begin
    if (i = nil) then begin
      if (aItem = nil) then exit true;
    end
    else begin
      if i.isEqual(aItem) then exit true;
    end;
  end;
end;

extension method Foundation.INSFastEnumeration.First(): nullable id; public;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObject: id;
  if Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(var lObject) count(1) ≥ 1 then //cast is workaround, remove;
    result := lState.itemsPtr[0]
  else
    raise new Exception("Sequence is empty.");
end;

extension method Foundation.INSFastEnumeration.First(aBlock: not nullable PredicateBlock): nullable id; public;
begin
  for each i in self do
    if aBlock(i) then
      exit i;
  raise new Exception("Sequence is empty.");
end;

extension method Foundation.INSFastEnumeration.FirstOrDefault(): nullable id; public;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObject: id;
  if Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(var lObject) count(1) ≥ 1 then //cast is workaround, remove;
    result := lState.itemsPtr[0];
end;

extension method Foundation.INSFastEnumeration.FirstOrDefault(aBlock: not nullable PredicateBlock): nullable id; public;
begin
  for each i in self do
    if aBlock(i) then
      exit i;
end;

extension method Foundation.INSFastEnumeration.Last(): nullable id; public;
begin
  if self is NSArray then begin
    result := (self as NSArray).lastObject;
  end
  else begin
    for each i in self do
      result := i;
  end;
  if not assigned(result) then
    raise new Exception("Sequence is empty.");
end;

extension method Foundation.INSFastEnumeration.Last(aBlock: not nullable PredicateBlock): nullable id; public;
begin
  for each i in self do
    if aBlock(i) then
      result := i;
  if not assigned(result) then
    raise new Exception("Sequence is empty.");
end;

extension method Foundation.INSFastEnumeration.LastOrDefault(): nullable id; public;
begin
  if self is NSArray then begin
    result := (self as NSArray).lastObject;
  end
  else begin
    for each i in self do
      result := i;
  end;
end;

extension method Foundation.INSFastEnumeration.LastOrDefault(aBlock: not nullable PredicateBlock): nullable id; public;
begin
  for each i in self do
    if aBlock(i) then
      result := i;
end;

extension method Foundation.INSFastEnumeration.Any(): Boolean; public;
begin
  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObject: id;
  result := Foundation.INSFastEnumeration(self).countByEnumeratingWithState(var lState) objects(var lObject) count(1) ≥ 1; //cast is workaround, remove;
end;

const LOOP_SIZE = 16;

extension method Foundation.INSFastEnumeration.Count: NSInteger; public;
begin
  if self is NSArray then exit (self as NSArray).count;
  if NSObject(self).respondsToSelector(selector(count)) then exit (self as id).count;

  var lState: NSFastEnumerationState := default(NSFastEnumerationState);
  var lObjects: array[0..LOOP_SIZE-1] of id;

  result := 0;
  loop begin
    var lGot := Foundation.INSFastEnumeration(self).countByEnumeratingWithState(@lState) objects(lObjects) count(LOOP_SIZE); //cast is workaround, remove;
    if lGot = 0 then break;
    result := result+lGot;
  end;
end;

extension method Foundation.INSFastEnumeration.Max: id; public;
begin
  for each i in self do
    if not assigned(result) or (result.compare(i) = NSComparisonResult.OrderedAscending) then
      result := i;
end;

extension method Foundation.INSFastEnumeration.Max(aBlock: not nullable IDBlock): id; public;
begin
  for each i in self do begin
    var i2 := aBlock(i);
    if not assigned(result) or (result.compare(i2) = NSComparisonResult.OrderedAscending) then
      result := i2;
  end;
end;

extension method Foundation.INSFastEnumeration.Min: id; public;
begin
  for each i in self do
    if not assigned(result) or (result.compare(i) = NSComparisonResult.OrderedDescending) then
      result := i;
end;

extension method Foundation.INSFastEnumeration.Min(aBlock: not nullable IDBlock): id; public;
begin
  for each i in self do begin
    var i2 := aBlock(i);
    if not assigned(result) or (result.compare(i2) = NSComparisonResult.OrderedDescending) then
      result := i2;
  end;
end;

//
// Generic versions
//


extension method RemObjects.Elements.System.INSFastEnumeration<T>.Any(aBlock: not nullable block(aItem: not nullable T): Boolean): Boolean; public;
begin
  exit Foundation.INSFastEnumeration(self).Any(PredicateBlock(aBlock));
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Take(aCount: NSInteger): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Take(aCount) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Skip(aCount: NSInteger): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Skip(aCount) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.TakeWhile(aBlock: not nullable block(aItem: not nullable T): Boolean): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).TakeWhile(PredicateBlock(aBlock)) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.SkipWhile(aBlock: not nullable block(aItem: not nullable T): Boolean): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).SkipWhile(PredicateBlock(aBlock)) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.OrderBy(aBlock: not nullable block(aItem: not nullable T): id): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).OrderBy(IDBlock(aBlock)) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.OrderByDescending(aBlock: not nullable block(aItem: not nullable T): id): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).OrderByDescending(IDBlock(aBlock)) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.OfType<R>(): not nullable RemObjects.Elements.System.INSFastEnumeration<R>; public;
begin
  exit Foundation.INSFastEnumeration(self).OfType<R>();
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Cast<R>(): not nullable RemObjects.Elements.System.INSFastEnumeration<R>; public; iterator;
begin
  for each el in self.GetSequence<T> do
    yield el as R;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Concat(aSecond: not nullable RemObjects.Elements.System.INSFastEnumeration<T>): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Concat(Foundation.INSFastEnumeration(aSecond)) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Reverse: not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Reverse as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Distinct(aComparator: NSComparator := nil): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Distinct(aComparator) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Intersect(aSecond: not nullable Foundation.INSFastEnumeration; aComparator: NSComparator := nil): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Intersect(aSecond, aComparator) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Except(aSecond: not nullable Foundation.INSFastEnumeration; aComparator: NSComparator := nil): not nullable RemObjects.Elements.System.INSFastEnumeration<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).Except(aSecond, aComparator) as not nullable RemObjects.Elements.System.INSFastEnumeration<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Contains(aItem: T): Boolean; public;
begin
  exit Foundation.INSFastEnumeration(self).Contains(aItem);
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.First: {nullable} T; public;
begin
  exit Foundation.INSFastEnumeration(self).First;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.First(aBlock: not nullable block(aItem: not nullable T): Boolean): {nullable} T; public;
begin
  exit Foundation.INSFastEnumeration(self).First(PredicateBlock(aBlock));
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Last: {nullable} T; public;
begin
  exit Foundation.INSFastEnumeration(self).Last;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Last(aBlock: not nullable block(aItem: not nullable T): Boolean): {nullable} T; public;
begin
  exit Foundation.INSFastEnumeration(self).Last(PredicateBlock(aBlock));
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.LastOrDefault: {nullable} T; public;
begin
  exit Foundation.INSFastEnumeration(self).LastOrDefault;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.LastOrDefault(aBlock: not nullable block(aItem: not nullable T): Boolean): {nullable} T; public;
begin
  exit Foundation.INSFastEnumeration(self).LastOrDefault(PredicateBlock(aBlock));
end;


extension method RemObjects.Elements.System.INSFastEnumeration<T>.Any(): Boolean; public;
begin
  exit Foundation.INSFastEnumeration(self).Any;
end;


extension method RemObjects.Elements.System.INSFastEnumeration<T>.Max: T; public;
begin
  result := Foundation.INSFastEnumeration(self).Max;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Max<T,R>(aBlock: not nullable block(aItem: not nullable T): R): R; public;
begin
  result := Foundation.INSFastEnumeration(self).Max(IDBlock(aBlock));
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Min: T; public;
begin
  result := Foundation.INSFastEnumeration(self).Min;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.Min<T,R>(aBlock: not nullable block(aItem: not nullable T): R): R; public;
begin
  result := Foundation.INSFastEnumeration(self).Min(IDBlock(aBlock));
end;

[Obsolete("Use ToNSArray() instead")]
extension method RemObjects.Elements.System.INSFastEnumeration<T>.array: not nullable NSArray<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).ToNSArray() as NSArray<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.ToNSArray: not nullable NSArray<T>; public;
begin
  exit Foundation.INSFastEnumeration(self).ToNSArray() as NSArray<T>;
end;

extension method RemObjects.Elements.System.INSFastEnumeration<T>.dictionary(aKeyBlock: block(aItem: id): id; aValueBlock: block(aItem: id): id): not nullable NSDictionary; public;
begin
  exit Foundation.INSFastEnumeration(self).dictionary(IDBlock(aKeyBlock), IDBlock(aValueBlock));
end;

//76496: Toffee: internal error and cant match complex generic extension method
extension method RemObjects.Elements.System.INSFastEnumeration<T>.dictionary<T,K,V>(aKeyBlock: block(aItem: T): K; aValueBlock: block(aItem: T): V): not nullable NSDictionary<K, V>; public;
begin
  exit Foundation.INSFastEnumeration(self).dictionary(IDBlock(aKeyBlock), IDBlock(aValueBlock));
end;


{$ENDIF}

end.