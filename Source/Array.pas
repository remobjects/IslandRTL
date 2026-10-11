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
      if (aCount < 0) or (aDestOffset < 0) or (aDestOffset > length(aDest)) or
         (aCount > length(aDest) - aDestOffset) then raise new ArgumentOutOfRangeException('Array.Copy ranges');
      if aCount = 0 then exit;
      if aSource = nil then raise new ArgumentOutOfRangeException('Array.Copy ranges');
      // Assign elements so managed records retain/release their resources.
      // Copy backwards when the destination overlaps later source elements.
      var lDest := @aDest[aDestOffset];
      if lDest = aSource then exit;
      if (UIntPtr(lDest) > UIntPtr(aSource)) and
         (UIntPtr(lDest) - UIntPtr(aSource) < UIntPtr(aCount) * UIntPtr(sizeOf(T))) then
        for i := aCount - 1 downto 0 do lDest[i] := aSource[i]
      else
        for i := 0 to aCount - 1 do lDest[i] := aSource[i];
    end;

    class method Copy<T>(aSource: array of T; aSourceOffset: Integer; aDest: Array of T; aDestOffset: Integer; aCount: Integer);
    begin
      // Validate without adding potentially overflowing offsets.
      if (aCount < 0) or (aSourceOffset < 0) or (aDestOffset < 0) or
         (aSourceOffset > length(aSource)) or (aDestOffset > length(aDest)) or
         (aCount > length(aSource) - aSourceOffset) or
         (aCount > length(aDest) - aDestOffset) then raise new ArgumentOutOfRangeException('Array.Copy ranges');
      if aCount = 0 then exit;
      &Copy(@aSource[aSourceOffset], aDest, aDestOffset, aCount);
    end;

    class method Copy<T>(aSource: array of T; aDest: Array of T; aCount: Integer);
    begin
      &Copy(aSource, 0, aDest, 0, aCount);
    end;
    class method Sort<T>(aVal: array of T; Comparison: Comparison<T>);
    begin
      Sort(aVal, 0, aVal.Length -1, Comparison);
    end;

    class method SubArray<T>(aSource: array of T; aStart, aCount: Integer): array of T;
    begin
      result := new array of T(aCount);
      Copy(aSource, aStart, result, 0, aCount);
    end;

    class method SubArray<T>(aSource: array of T; aRange: Range): array of T;
    begin
      var lLength := length(aSource);
      var lStart := aRange.fStart.GetOffset(lLength);
      var lEnd := aRange.fEnd.GetOffset(lLength);
      result := SubArray(aSource, lStart, lEnd-lStart);
    end;

    class method BinarySearch<T, V>(aVal: array of T; aInput: V; aComparer: Func<T, V, Integer>): Integer;
    begin
      var min := 0;
      var max := aVal.Length -1;
      while min <= max do begin
        var  middle := min + ((max - min) shr 1);

        result := aComparer(aVal[middle], aInput);
        if result = 0  then exit middle;
        if result < 0 then
          min := middle + 1
        else
          max := middle - 1;
      end;
      exit not min;
    end;

    class method Sort<T>(aVal: array of T; L, R: Integer; Comparison: Comparison<T>);
    begin
      var I, J: Integer;
      var P: T;
      var temp: T;
      if L >= R then exit;
      repeat
        I := L;
        J := R;
        P := aVal[L + ((R - L) shr 1)];
        repeat
          while Comparison(aVal[I], P) < 0 do inc(I);
          while Comparison(aVal[J], P) > 0 do dec(J);
          if I <= J then begin
            temp := aVal[I];
            aVal[I]:= aVal[J];
            aVal[J]:= temp;
            inc(I);
            dec(J);
          end;
        until I > J;
        if L < J then Sort(aVal, L, J, Comparison);
        L := I;
      until I >= R;
    end;

    method Get(i: Integer): Object; abstract;
    method &Set(i: Integer; v: Object); abstract;

    class method Clear<T>(aVal: array of T; Index, Length : Integer);
    begin
      if (Index < 0) or (Length < 0) or (Index > aVal.Length) or
         (Length > aVal.Length - Index) then raise new ArgumentOutOfRangeException('Array.Clear ranges');
      var L: Integer := Index + Length;
      for i: Integer := Index to L-1 do
        aVal[i] := &default(T);
    end;
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

    property Item[i: Integer]: T read (@fFirstItem)[i] write (@fFirstItem)[i];
    property Item[i: &Index]: T read (@fFirstItem)[i.GetOffset(Length)] write (@fFirstItem)[i.GetOffset(Length)];
    property Item[r: Range]: array of T read SubArray(r); default;

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

    method SubArray(aStart, aCount: Integer): array of T;
    begin
      result := SubArray(self, aStart, aCount);
    end;

    method SubArray(aRange: Range): array of T;
    begin
      var lStart := aRange.fStart.GetOffset(fLength);
      var lEnd := aRange.fEnd.GetOffset(fLength);
      result := SubArray(self, lStart, lEnd-lStart);
    end;

    method ToString: String; override;
    begin
      exit $"{Integer(InternalCalls.Cast(self)).ToString.PadStart(if defined("CPU64") then 16 else 8, '0')} Count: {Count}";
    end;

  end;

end.