namespace RemObjects.Elements.System;

interface

type
  StackEnumerator<T> = public class(IEnumerator<T>)
  private
    fItems: array of T;
    fCurrentIndex: Integer := 0;
    method GetCurrent: T;
    property NonGenCurrent: Object read GetCurrent; implements IEnumerator.Current;
  public
    constructor (aStack: Stack<T>);
    method MoveNext: Boolean;
    method Dispose;
    property Current: T read GetCurrent;
  end;

  Stack<T> = public class(IEnumerable<T>)
  private
    fItems: array of T;
    fTop: Integer := -1;
    method GetNonGenericEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    method IsEqual(Item1: T; Item2: T): Boolean;
    method Init;
    method CalcCapacity(aNewCapacity: Integer): Integer;
    method Grow(aCapacity: Integer);
    method IsEmpty: Boolean; inline;
  public
    constructor;
    method GetEnumerator: IEnumerator<T>;

    method Contains(aItem: T): Boolean;
    method Peek: T;
    method Clear;
    method Pop: T;
    method Push(aItem: T);

    method ToArray: array of T;
    property Count: Integer read fTop - 1;
  end;


implementation

method Stack<T>.GetNonGenericEnumerator: IEnumerator;
begin
  result := GetEnumerator;
end;

method Stack<T>.IsEqual(Item1: T; Item2: T): Boolean;
begin
  if (Item1 = nil) and (Item2 = nil) then exit true;
  if (Item1 = nil) or (Item2 = nil) then exit false;
  exit Item1.Equals(Item2);
end;

method Stack<T>.Init;
begin
  fItems := new array of T(4);
  fTop := -1;
end;

constructor Stack<T>;
begin
  Init;
end;

method Stack<T>.GetEnumerator: IEnumerator<T>;
begin
  result := new StackEnumerator<T>(self);
end;

method Stack<T>.Contains(aItem: T): Boolean;
begin
  for i: Integer := 0 to fTop do
  if IsEqual(fItems[i], aItem) then
    exit true;

  result := false;
end;

method Stack<T>.Peek: T;
begin
  if IsEmpty then
    raise new Exception('Stack is empty');

  result := fItems[fTop];
end;

method Stack<T>.Clear;
begin
  Init;
end;

method Stack<T>.Pop: T;
begin
  if IsEmpty then
    raise new Exception('Stack is empty');

  result := fItems[fTop];
  fItems[fTop] := nil;
  dec(fTop);
end;

method Stack<T>.Push(aItem: T);
begin
  if fTop + 1 >= length(fItems) then
    Grow(fTop + 1);
  inc(fTop);
  fItems[fTop] := aItem;
end;

method Stack<T>.ToArray: array of T;
begin
  result := new array of T(fTop + 1);
  for i: Integer := 0 to fTop do
    result[i] := fItems[fTop - i];
end;

method Stack<T>.CalcCapacity(aNewCapacity: Integer): Integer;
begin
  var lDelta: Integer;
  if aNewCapacity > 64 then lDelta := aNewCapacity / 4
  else if aNewCapacity > 8 then lDelta := 16
  else lDelta := 4;
  result := aNewCapacity + lDelta;
end;

method Stack<T>.Grow(aCapacity: Integer);
begin
  var lNewCapacity := CalcCapacity(aCapacity);
  var lArray := new array of T(lNewCapacity);

  for i: Integer := 0 to fTop do
    lArray[i] := fItems[i];

  fItems := lArray;
end;

method Stack<T>.IsEmpty: Boolean;
begin
  result := fTop = -1;
end;

method StackEnumerator<T>.GetCurrent: T;
begin
  result := fItems[fCurrentIndex];
end;

constructor StackEnumerator<T>(aStack: Stack<T>);
begin
  fItems := aStack.ToArray;
end;

method StackEnumerator<T>.MoveNext: Boolean;
begin
  result := fCurrentIndex < length(fItems);
  inc(fCurrentIndex);
end;

method StackEnumerator<T>.Dispose;
begin

end;

end.