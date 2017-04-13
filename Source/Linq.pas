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
  exit false;
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
  var lFound := true;
  for each el in self do begin
    if not lFound and not aBlock(el) then
      lFound := true;
    if lFound then
      yield el;
  end;
end;

extension method ISequence<T>.OrderBy<C>(aBlock: not nullable block(aItem: not nullable T): C): /*not nullable*/ ISequence<T>; public;  where C is IComparable<C>;
begin
  var lList := ToList();
  lList.Sort((a, b) -> aBlock(a).CompareTo(aBlock(b)));

  exit lList;
end;

extension method ISequence<T>.OrderByDescending<C>(aBlock: not nullable block(aItem: not nullable T): C): /*not nullable*/ ISequence<T>; public; where C is IComparable<C>;
begin
  var lList := ToList();
  lList.Sort((a, b) -> aBlock(b).CompareTo(aBlock(a)));

  exit lList;
end;

extension method ISequence<T>.Select<T, R>(aBlock: not nullable block(aItem: not nullable T): R): /*not nullable*/ ISequence<R>; public; iterator;
begin
  for each el in self do
    yield aBlock(el);
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

extension method ISequence<T>.FirstOrDefault: {nullable} T; public;
begin
  for each el in self do
    exit el;
end;

extension method ISequence<T>.FirstOrDefault(aBlock: not nullable block(aItem: not nullable T): Boolean): /*nullable*/ T; public;
begin
  for each el in self do
  if aBlock(el) then
    exit  el;
end;

extension method ISequence<T>.Any(): Boolean; public;
begin
  for each el in self do
    exit true;
  exit false;
end;

extension method ISequence<T>.ToArray(): array of T; public;
begin
  if self is array of T then exit self as array of T;
  if self is List<T> then exit (self as List<T>).ToArray();

  var lCount := Count;
  result := new array of T(lCount);
end;

extension method ISequence<T>.ToList(): List<T>; public;
begin
  if self is List<T> then exit self as List<T>;
  if self is array of T then exit new List<T>(self as array of T);

  result := new List<T>(self);
end;

end.