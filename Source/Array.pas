namespace RemObjects.Elements.System;

type
  &Array = public abstract class(IEnumerable)
  assembly
    // WARNING: Do not change without also changing the compiler! these are compiler created!
    {$HIDE H8}
    fLength: NativeInt; readonly;
    {$SHOW H8}

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

  &Array<T> = public class(&Array, IEnumerable<T>, IEnumerable)
  assembly
    fFirstItem: T;

    constructor; empty;

    method GetNonGenericEnumerator: IEnumerator;  override;
    begin
      exit GetEnumerator;
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