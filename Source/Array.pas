namespace RemObjects.Elements.System;
{$HIDE H8}{$HIDE H6}{$HIDE H7}

type
  ArrayStruct = record
  public
    fRTTI: ^Void;
    fLength: NativeInt;
    fData: array[0..0] of IntPtr;
  end;
  &Array = public abstract class(IEnumerable)
  assembly
    // WARNING: Do not change without also changing the compiler! these are compiler created!
    fLength: NativeInt; readonly;

    constructor; empty;

    method GetNonGenericEnumerator: IEnumerator; abstract; implements IEnumerable.GetEnumerator;
  public
    property Length: Integer read fLength;

    class method Copy<T>(aSource: ^T; aDest: Array of T; aDestOffset: Integer; aCount: Integer);
    begin
      if aCount = 0 then exit;
      if (aSource = nil) or (aDestOffset < 0) or (aDestOffset + aCount > length(aDest)) then raise new ArgumentOutOfRangeException('Array.Copy ranges');
      memcpy(@aDest[aDestOffset], aSource, aCount * sizeOf(T));
    end;

    class method Copy<T>(aSource: array of T; aSourceOffset: Integer; aDest: Array of T; aDestOffset: Integer; aCount: Integer);
    begin
      if aCount = 0 then exit;
      if (aSourceOffset < 0) or (aDestOffset < 0) or (aSourceOffset + aCount > length(aSource)) or (aDestOffset + aCount > length(aDest)) then raise new ArgumentOutOfRangeException('Array.Copy ranges');
      memcpy(@aDest[aDestOffset], @aSource[aSourceOffset], aCount * sizeOf(T));
    end;

    class method Copy<T>(aSource: array of T; aDest: Array of T; aCount: Integer);
    begin
      &Copy(aSource, 0, aDest, 0, aCount);
    end;

    method Get(i: Integer): Object; abstract;
    method &Set(i: Integer; v: Object); abstract;
  end;

  &Array<T> = public class(&Array, IEnumerable<T>, IEnumerable, IList<T>, IList)
  assembly
    fFirstItem: T;

    constructor; empty;

    method GetNonGenericEnumerator: IEnumerator;  override;
    begin
      exit GetEnumerator;
    end;

    property Count: Integer read Length;
    method set_IntItem(aIndex: Integer; aVal: Object);
    begin
      Item[aIndex] := T(aVal);
    end;
    property IntItem[i: Integer]: Object read Item[i] write set_IntItem; implements IList.Item;

    method &Add(val: Object);
    begin
      raise new NotSupportedException;
    end;

    method &Add(val: T);
    begin
      raise new NotSupportedException;
    end;

    method &Remove(val: Object): Boolean;
    begin
      raise new NotSupportedException;
    end;

    method &Remove(val: T): Boolean;
    begin
      raise new NotSupportedException;
    end;

    method Clear;
    begin
      raise new NotSupportedException;
    end;

    method Contains(val: Object): Boolean;
    begin
      if val is T then
        exit Contains(T(val));
      exit false;
    end;

    method Contains(val: T): Boolean;
    begin
      for i: Integer := 0 to Length -1 do
        if EqualityComparer.Equals(Item[i], val) then exit true;
      exit false;
    end;
  public
    property Item[I: Integer]: T read (@fFirstItem)[I] write (@fFirstItem)[I];
    method Get(i: Integer): Object; override;
    begin
      exit Item[i];
    end;

    method &Set(i: Integer; v: Object); override;
    begin
      Item[i] := T(v);
    end;


    method GetEnumerator: IEnumerator<T>; iterator;
    begin
      for i: Integer := 0 to fLength -1 do
        yield (@fFirstItem)[i];
    end;
  end;

end.