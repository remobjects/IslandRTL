namespace RemObjects.Elements.System;

interface


type
  ObjectPool<T> = public class
  private
    fLock: Integer;
    fLeft: Integer;
    fSpare: array of T;
    fCreator: Func<T>;
    fCleanup: Action<T>;
  public
    constructor(aCapacity: Integer; aCreator: Func<T>; aCleanup: Action<T>);
    method Acquire: T;
    method Release(aVal: T);
  end;

implementation

constructor ObjectPool<T>(aCapacity: Integer; aCreator: Func<T>; aCleanup: Action<T>);
begin
  fLeft := aCapacity;
  fSpare := new T[aCapacity];
  fCreator := aCreator;
  fCleanup := aCleanup;
end;

method ObjectPool<T>.Acquire: T;
begin
  Utilities.SpinLockEnter(var fLock);
  try
    if fLeft > 0 then begin
      result := fSpare[fLeft];
      dec(fLeft);
    end;
  finally
    Utilities.SpinLockExit(var fLock);
  end;
  if result = nil then
    result := fCreator();
end;

method ObjectPool<T>.Release(aVal: T);
begin
  fCleanup(aVal);
  Utilities.SpinLockEnter(var fLock);
  try
    if fLeft < length(fSpare) then begin
      fSpare[fLeft] := aVal;
      inc(fLeft);
    end;
  finally
    Utilities.SpinLockExit(var fLock);
  end;
end;

end.
