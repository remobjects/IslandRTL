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
    fTISObject: Boolean;
    fCode: TypeCodes;

    class method get_Instance: DefaultEqualityComparer<T>;
    begin
      if fInstance = nil then fInstance := new DefaultEqualityComparer<T>;
      exit fInstance;
    end;
  public
    constructor;
    begin
      var lType := typeOf(T);
      fTISObject := lType.IsSubclassOf(typeOf(Object));
      fCode := lType.Code;
    end;

    method Equals(x: T; y: T): Boolean;
    begin
      // Built-in scalars have fixed equality rules. Read only their own
      // storage, avoiding Object dispatch and two heap boxes per comparison.
      case fCode of
        TypeCodes.Boolean: exit ^Boolean(@x)^ = ^Boolean(@y)^;
        TypeCodes.Byte, TypeCodes.SByte, TypeCodes.AnsiChar: exit ^Byte(@x)^ = ^Byte(@y)^;
        TypeCodes.Char, TypeCodes.Int16, TypeCodes.UInt16: exit ^UInt16(@x)^ = ^UInt16(@y)^;
        TypeCodes.Int32, TypeCodes.UInt32: exit ^UInt32(@x)^ = ^UInt32(@y)^;
        TypeCodes.Int64, TypeCodes.UInt64: exit ^UInt64(@x)^ = ^UInt64(@y)^;
        TypeCodes.IntPtr, TypeCodes.UIntPtr: exit ^NativeUInt(@x)^ = ^NativeUInt(@y)^;
        TypeCodes.Single: exit ^Single(@x)^ = ^Single(@y)^;
        TypeCodes.Double: exit ^Double(@x)^ = ^Double(@y)^;
      end;
      if not assigned(x) then exit not assigned(y);
      if fTISObject then
        exit x.Equals(y)
      else
        exit ^^Void(@x)^ = ^^Void(@y)^;
    end;

    method GetHashCode(obj: T):Integer;
    begin
      // Call the same scalar hash implementation directly, without boxing.
      case fCode of
        TypeCodes.Boolean: exit (^Boolean(@obj)^).GetHashCode;
        TypeCodes.Char: exit (^Char(@obj)^).GetHashCode;
        TypeCodes.SByte: exit (^SByte(@obj)^).GetHashCode;
        TypeCodes.Byte: exit (^Byte(@obj)^).GetHashCode;
        TypeCodes.Int16: exit (^Int16(@obj)^).GetHashCode;
        TypeCodes.UInt16: exit (^UInt16(@obj)^).GetHashCode;
        TypeCodes.Int32: exit (^Int32(@obj)^).GetHashCode;
        TypeCodes.UInt32: exit (^UInt32(@obj)^).GetHashCode;
        TypeCodes.Int64: exit (^Int64(@obj)^).GetHashCode;
        TypeCodes.UInt64: exit (^UInt64(@obj)^).GetHashCode;
        TypeCodes.Single: exit (^Single(@obj)^).GetHashCode;
        TypeCodes.Double: exit (^Double(@obj)^).GetHashCode;
        TypeCodes.IntPtr: exit (^NativeInt(@obj)^).GetHashCode;
        TypeCodes.UIntPtr: exit (^NativeUInt(@obj)^).GetHashCode;
        TypeCodes.AnsiChar: exit (^AnsiChar(@obj)^).GetHashCode;
      end;
      if not assigned(obj) then exit 0;
      if fTISObject then
        exit obj.GetHashCode
      else
        exit Integer(^^Void(@obj)^);
    end;

    class var fInstance: DefaultEqualityComparer<T>; private;
    class property Instance: DefaultEqualityComparer<T> read get_Instance; public;
  end;

  EqualityComparer<T> = assembly class(IEqualityComparer<T>)
  private
    fComparator: block(a, b: T): Integer;
    fDefault: IEqualityComparer<T>;
  public

    constructor (aComparator: block(a, b: T): Integer := nil);
    begin
      fDefault := DefaultEqualityComparer<T>.Instance;
      fComparator := aComparator;
    end;

    method Equals(x: T; y: T): Boolean;
    begin
      if assigned(fComparator) then
        exit fComparator(x,y) = 0
      else
        exit fDefault.Equals(x, y);
    end;

    method GetHashCode(obj: T):Integer;
    begin
      // A comparison block supplies no compatible hash function. Equal values
      // must share a bucket even if their ordinary object hashes differ.
      if assigned(fComparator) then exit 0;
      exit fDefault.GetHashCode(obj);
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