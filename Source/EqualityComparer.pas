namespace RemObjects.Elements.System;

type
  IEqualityComparer<T> = public interface
    method Equals(x: T; y: T): Boolean;
    method GetHashCode(obj: T):Integer;
  end;

  IEquatable = public interface
    method Equals(a: Object): Boolean;
    method GetHashCode: Integer;
  end;

  IEquatable<T> = public interface
    method Equals(other: T): Boolean;
    method GetHashCode: Integer;
  end;

  IComparable<T> = public interface
    method CompareTo(a: T): Integer;
  end;

  IComparable = public interface
    method CompareTo(a: Object): Integer;
  end;

  INumber = public interface(IComparable)
  end;

  IIntegerNumber = public interface(INumber)
  end;

  EqualityComparer = public static class
  public
    method Equals<T>(a, b: T): Boolean;
    begin
      exit DefaultEqualityComparer<T>.Instance.Equals(a, b);
    end;

    method GetHashCode<T>(a: T): Integer;
    begin
      exit DefaultEqualityComparer<T>.Instance.GetHashCode(a);
    end;
  end;

  DefaultEqualityComparer<T> = assembly class(IEqualityComparer<T>)
  private
    class method get_Instance: DefaultEqualityComparer<T>;
    begin
      if fInstance = nil then fInstance := new DefaultEqualityComparer<T>;
      exit fInstance;
    end;
  public

    method Equals(x: T; y: T): Boolean;
    begin
      exit x.Equals(y);
    end;

    method GetHashCode(obj: T):Integer;
    begin
      exit obj.GetHashCode;
    end;

    class var fInstance: DefaultEqualityComparer<T>; private;
    class property Instance: DefaultEqualityComparer<T> read get_Instance; public;
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


  ObjectReferenceComparer<T> = assembly class(IEqualityComparer<T>)
  private
    fComparator: block(a, b: T): Integer;
  public

    constructor();
    begin
    end;

    method Equals(x: T; y: T): Boolean;
    begin
      exit Object(x) = Object(y);
    end;

    method GetHashCode(obj: T):Integer;
    begin
      exit Integer(InternalCalls.Cast(Object(obj)));
    end;
  end;

end.