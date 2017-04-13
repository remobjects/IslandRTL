namespace RemObjects.Elements.System;

type
  IEqualityComparer<T> = public interface
    method Equals(x: T; y: T): Boolean;
    method GetHashCode(obj: T):Integer;
  end;

  DefaultEqualityComparer<T> = assembly class(IEqualityComparer<T>)
  public

    method Equals(x: T; y: T): Boolean;
    begin
      exit x.Equals(y);
    end;

    method GetHashCode(obj: T):Integer;
    begin
      exit obj.GetHashCode;
    end;
  end;

  EqualityComparer<T> = assembly class(IEqualityComparer<T>)
  private
    fComparator: block(a, b: T): Integer;
  public

    constructor (aComparator: block(a, b: T): Integer := nil);
    begin
      fComparator := aComparator;
    end;

    method Equals(x: T; y: T): Boolean;
    begin
      if assigned(fComparator) then
        exit fComparator(x,y) = 0
      else
        exit x.Equals(y);
    end;

    method GetHashCode(obj: T):Integer;
    begin
      exit obj.GetHashCode;
    end;
  end;

end.