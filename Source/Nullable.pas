namespace RemObjects.Elements.System;

interface

type
  &Nullable<T> = public record
  where
    T is record;
  private
    fHasValue: Boolean; readonly;
    fValue: T; readonly;
  public
    constructor; empty;
    constructor(aValue: T);
    property HasValue: Boolean read fHasValue;
    method GetValue: T;
    method GetValueOrDefault(aDefault: T): T;
    method GetValueOrDefault(): T;
  end;

implementation

constructor &Nullable<T>(aValue: T);
begin
  fHasValue := true;
  fValue := aValue;
end;

method &Nullable<T>.GetValue: T;
begin
  if not fHasValue then raise new NullReferenceException;
  exit fValue;
end;

method &Nullable<T>.GetValueOrDefault(aDefault: T): T;
begin
  if fHasValue then exit fValue;
  exit aDefault;
end;

method &Nullable<T>.GetValueOrDefault(): T;
begin
  if fHasValue then exit fValue;
  exit default(T);
end;

end.