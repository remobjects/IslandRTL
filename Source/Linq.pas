namespace RemObjects.Elements.System;

extension method ISequence<T>.Count(): Integer; public;
begin
  for each el in self do inc(result);
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
  for each el in self do
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
        KeySelector: Func<TSource, TKey>;
        ElementSelector: Func<TSource, TElement>;
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
  aOuterKeySelector: Func<TOuter, TKey>;
  aInnerKeySelector: Func<TInner, TKey>;
  aResultSelector: Func<TOuter, TInner, TResult>;
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
{$ENDIF}

end.