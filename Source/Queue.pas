namespace RemObjects.Elements.System;

interface

type
  QueueEnumerator<T> = public class(IEnumerator<T>)
  private
    fArray: array of T;
    fCurrentIndex: Integer := -1;
    method GetCurrent: T;
    property NonGenCurrent: Object read GetCurrent; implements IEnumerator.Current;
  public
    constructor (aQueue: Queue<T>);
    method MoveNext: Boolean;
    method Dispose;
    property Current: T read GetCurrent;
  end;

  Queue<T> = public class(IEnumerable<T>)
  private
    fItems: array of T;
    fTail: Integer := 0;
    fHead: Integer := 0;
    fCount: Integer := 0;
    method Grow(aCapacity: Integer);
    method IsEmpty: Boolean; inline;
    method CalcCapacity(aNewCapacity: Integer): Integer;
    method Init;
    method GetNonGenericEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    method IsEqual(Item1: T; Item2: T): Boolean;
  public
    constructor;

    method GetEnumerator: IEnumerator<T>;
    method Contains(aItem: T): Boolean;
    method Clear;

    method Peek: T;
    method Enqueue(aItem: T);
    method Dequeue: T;
    method ToArray: array of T;

    property Count: Integer read fCount;
  end;

implementation

constructor Queue<T>;
begin
  Init;
end;

method Queue<T>.Init;
begin
  fItems := new array of T(4);
  fHead := 0;
  fTail := 0;
  fCount := 0;
end;

method Queue<T>.Contains(aItem: T): Boolean;
begin
  // Search the live ring directly; enumeration would allocate a snapshot.
  var lIndex := fTail;
  for i := 0 to fCount - 1 do begin
    if IsEqual(fItems[lIndex], aItem) then exit true;
    inc(lIndex);
    if lIndex = length(fItems) then lIndex := 0;
  end;
  exit false;
end;

method Queue<T>.Clear;
begin
  while fCount > 0 do Dequeue;
  fHead := 0;
  fTail := 0;
end;

method Queue<T>.Peek: T;
begin
  if IsEmpty then
    raise new Exception('Queue is empty');

  result := fItems[fTail];
end;

method Queue<T>.Enqueue(aItem: T);
begin
  if fCount = length(fItems) then Grow(fCount + 1);
  fItems[fHead] := aItem;
  inc(fHead);
  inc(fCount);
  if fHead = length(fItems) then fHead := 0;
end;

method Queue<T>.Dequeue: T;
begin
  if IsEmpty then
    raise new Exception('Queue is empty');

  result := fItems[fTail];
  fItems[fTail] := nil;
  inc(fTail);
  dec(fCount);
  if fTail = length(fItems) then
    fTail := 0;
end;

method Queue<T>.ToArray: array of T;
begin
  result := new array of T(fCount);
  var lIndex := fTail;
  for i := 0 to fCount - 1 do begin
    result[i] := fItems[lIndex];
    inc(lIndex);
    if lIndex = length(fItems) then lIndex := 0;
  end;
end;

method Queue<T>.CalcCapacity(aNewCapacity: Integer): Integer;
begin
  var lDelta: Integer;
  if aNewCapacity > 64 then lDelta := aNewCapacity / 4
  else if aNewCapacity > 8 then lDelta := 16
  else lDelta := 4;
  result := aNewCapacity + lDelta;
end;

method Queue<T>.Grow(aCapacity: Integer);
begin
  var lArray := new array of T(CalcCapacity(aCapacity));
  var lIndex := fTail;
  for i := 0 to fCount - 1 do begin
    lArray[i] := fItems[lIndex];
    inc(lIndex);
    if lIndex = length(fItems) then lIndex := 0;
  end;
  // The copied ring is now contiguous, starting at zero.
  fItems := lArray;
  fTail := 0;
  fHead := fCount;
end;

method Queue<T>.IsEmpty: Boolean;
begin
  result := fCount = 0;
end;

method Queue<T>.IsEqual(Item1: T; Item2: T): Boolean;
begin
  if (Item1 = nil) and (Item2 = nil) then exit true;
  if (Item1 = nil) or (Item2 = nil) then exit false;
  exit Item1.Equals(Item2);
end;

method Queue<T>.GetEnumerator: IEnumerator<T>;
begin
  result := new QueueEnumerator<T>(self);
end;

method Queue<T>.GetNonGenericEnumerator: IEnumerator;
begin
  result := GetEnumerator;
end;

method QueueEnumerator<T>.GetCurrent: T;
begin
  result := fArray[fCurrentIndex];
end;

constructor QueueEnumerator<T>(aQueue: Queue<T>);
begin
  fArray := aQueue.ToArray;
end;

method QueueEnumerator<T>.MoveNext: Boolean;
begin
  if fCurrentIndex < length(fArray) then inc(fCurrentIndex);
  result := fCurrentIndex < length(fArray);
end;

method QueueEnumerator<T>.Dispose;
begin

end;

end.