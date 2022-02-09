namespace RemObjects.Elements.System;

type
  Predicate<T> = public delegate (Obj: T): Boolean;
  Comparison<T> = public delegate (x: T; y: T): Integer;

  ImmutableList<T> = public class(IEnumerable<T>, ICollection)
    where T is unconstrained;
  unit
    var fItems: array of T;
    var fCount: Integer := 0;

    method SetItem(&Index: Integer; Value: T);
    begin
      CheckCapacity(&Index);
      fItems[&Index] := Value;
    end;

    method GetItem(&Index: Integer): T;
    begin
      CheckIndex(&Index);
      exit fItems[&Index];
    end;

    method Grow(aCapacity: Integer);
    begin
      aCapacity := CalcCapacity(aCapacity);
      var newarray := new array of T(aCapacity);
      for i: Integer := 0 to fCount-1 do
        newarray[i] := fItems[i];
      fItems := newarray;
    end;

    method RaiseError(aMessage: String);
    begin
      raise new Exception(aMessage);
    end;

    method CheckIndex(&Index: Integer);
    begin
      if (&Index < 0) or (&Index >= Count) then RaiseError('Index was out of range.');
    end;

    method CheckCapacity(&Index: Integer);
    begin
      if (&Index < 0) or (&Index >= Capacity) then RaiseError('Index was out of range.');
    end;

    method IsEqual(Item1, Item2: T): Boolean;
    begin
      if not assigned(Item1) and not assigned(Item2) then exit true;
      if not assigned(Item1) or not assigned(Item2) then exit false;
      case modelOf(T) of
        "Island": exit (Item1 as IslandObject).Equals(Item2 as IslandObject);
        "Cocoa": {$IF DARWIN}exit (Item1 as CocoaObject).isEqual(Item2 as CocoaObject);{$ENDIF}
        "Swift": {$IF DARWIN}exit (Item1 as SwiftObject).Equals(Item2 as SwiftObject);{$ENDIF}
        "Delphi": raise new Exception($"This feature is not supported for Delphi Objects (yet)");
        "COM": raise new Exception($"This feature is not supported for COM Objects");
        "JNI": raise new Exception($"This feature is not supported for JNI Objects");
        else raise new Exception($"Unexpected object model {modelOf(T)}");
      end;
    end;

    method CalcCapacity(aNewCapacity: Integer): Integer;
    begin
      var lDelta: Integer;
      if aNewCapacity > 64 then lDelta := aNewCapacity / 4
      else if aNewCapacity > 8 then lDelta := 16
      else lDelta := 4;
      exit aNewCapacity + lDelta;
    end;

    method Clear; virtual; protected;
    begin
      for i: Integer := 0 to fCount -1 do
        fItems[i] := default(T);
      fCount := 0;
    end;

    method QuickSort(L,R: Integer;Comparison: Comparison<T>);
    begin
      var I, J: Integer;
      var P: T;
      var temp: T;
      if fCount < 2 then Exit;
      repeat
        I := L;
        J := R;
        P := fItems[(L + R) shr 1];
        repeat
          while Comparison(fItems[I], P) < 0 do inc(I);
          while Comparison(fItems[J], P) > 0 do dec(J);
          if I <= J then begin
            temp := fItems[I];
            fItems[I]:=fItems[J];
            fItems[J]:= temp;
            inc(I);
            dec(J);
          end;
        until I > J;
        if L < J then QuickSort(L, J, Comparison);
        L := I;
      until I >= R;
    end;

    method GetNonGenericEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit GetEnumerator;
    end;

    method PrivateAdd(anItem: T); assembly;
    begin
      if fCount = Capacity then Grow(Capacity+1);
      fItems[fCount] := T(anItem);
      inc(fCount);
    end;

  public

    constructor;
    begin
      Clear;
    end;

    constructor(aItems: ImmutableList<T>);
    begin
      if assigned(aItems) then begin
        var lLength := aItems.Count;
        if lLength > 0 then begin
          Grow(lLength);
          for i: Integer := 0 to lLength-1 do
            fItems[i] := aItems[i];
          fCount := lLength;
        end
        else begin
          Clear();
        end;
      end
      else begin
        Clear();
      end;
    end;

    constructor(params aArray: array of T);
    begin
      var lLength := length(aArray);
      if lLength > 0 then begin
        fCount := 0;
        Grow(lLength);
        for i: Integer := 0 to lLength-1 do
          fItems[i] := aArray[i];
        fCount := lLength;
      end
      else begin
        Clear();
      end;
    end;

    constructor(aSequence: ISequence<T>);
    begin
      if aSequence.Any then begin
        for each s in aSequence do
          PrivateAdd(s);
      end
      else begin
        Clear();
      end;
    end;

    constructor(aCapacity: Integer);
    begin
      fCount := 0;
      Grow(aCapacity);
    end;

    {$IF DARWIN}
    //constructor(aArray: Foundation.NSArray<T>);
    //begin
      //constructor(aArray.count);
      //for i: Integer := 0 to aArray.count-1 do
        //PrivateAdd(aArray[i]);
    //end;

    method ToNSArray: Foundation.NSArray<T>; inline;
    begin
      result := ToNSMutableArray();
    end;

    method ToNSMutableArray: Foundation.NSMutableArray<T>;
    begin
      var lResult := new Foundation.NSMutableArray<T> withCapacity(Count);
      for i: Integer := 0 to Count-1 do
        lResult.addObject(self[i]);
      result := lResult;
    end;

    //operator Explicit(aArray: Foundation.NSArray<T>): ImmutableList<T>;
    //begin
      //result := new ImmutableList<T>(aArray);
    //end;

    operator Explicit(aArray: ImmutableList<T>): Foundation.NSArray<T>;
    begin
      result := aArray:ToNSArray;
    end;

    operator Explicit(aArray: ImmutableList<T>): Foundation.NSMutableArray<T>;
    begin
      result := aArray:ToNSMutableArray;
    end;
    {$ENDIF}

    method GetEnumerator: IEnumerator<T>;
    begin
      exit new ListEnumerator<T>(Self);
    end;

    method Contains(anItem: T): Boolean;
    begin
      for i : Integer := 0 to fCount-1 do
        if IsEqual(Item[i], anItem) then exit true;
    end;

    method Exists(Match: Predicate<T>): Boolean;
    begin
      for i : Integer := 0 to fCount-1 do
        if Match(Item[i]) then exit true;
    end;

    method FindIndex(Match: Predicate<T>): Integer;
    begin
      for i : Integer := 0 to fCount-1 do
        if Match(Item[i]) then exit i;

      exit -1;
    end;

    method FindIndex(StartIndex: Integer; Match: Predicate<T>): Integer;
    begin
      exit FindIndex(StartIndex, fCount, Match);
    end;

    method FindIndex(StartIndex: Integer; aCount: Integer; Match: Predicate<T>): Integer;
    begin
      CheckIndex(StartIndex);
      for i : Integer := StartIndex to aCount-1 do
        if Match(Item[i]) then exit i;

      exit -1;
    end;

    method Find(Match: Predicate<T>): T;
    begin
      for i : Integer := 0 to fCount-1 do
        if Match(Item[i]) then exit Item[i];

      exit nil;
    end;

    method FindAll(Match: Predicate<T>): List<T>;
    begin
      result := new List<T>;
      for i : Integer := 0 to fCount-1 do
        if Match(Item[i]) then result.Add(Item[i]);
    end;

    method TrueForAll(Match: Predicate<T>): Boolean;
    begin
      for i : Integer := 0 to fCount-1 do
        if not Match(Item[i]) then exit false;

      exit true;
    end;

    method ForEach(Action: Action<T>);
    begin
      for i : Integer := 0 to fCount-1 do
        Action(Item[i]);
    end;

    method IndexOf(anItem: T): Integer;
    begin
      for i : Integer := 0 to fCount-1 do
        if IsEqual(Item[i], anItem) then exit i;

      exit -1;
    end;

    method LastIndexOf(anItem: T): Integer;
    begin
      for i : Integer := fCount-1 downto 0 do
        if IsEqual(Item[i], anItem) then exit i;

      exit -1;
    end;

    method ToArray: array of T;
    begin
      result := new array of T(fCount);
      CopyTo(result);
    end;

    method CopyTo(&array: array of T);
    begin
      if length(&array)< fCount then new ArgumentException('The number of elements in the source List<T> is greater than the number of elements that the destination array can contain.');
      CopyTo(0, &array, 0, fCount);
    end;

    method CopyTo(&array: array of T; arrayIndex: Integer);
    begin
      if arrayIndex <0 then new ArgumentOutOfRangeException('arrayIndex is less than 0.');
      if length(&array)< fCount+arrayIndex then new ArgumentException('The number of elements in the source List<T> is greater than the available space from arrayIndex to the end of the destination array.');
      CopyTo(0, &array, arrayIndex, fCount);
    end;

    {$HIDE W27}
    method CopyTo(&index: Integer; &array: array of T; arrayIndex: Integer; &count: Integer);
    begin
      if not assigned(&array) then new ArgumentNullException('array is nil.');
      if &index <0 then new ArgumentOutOfRangeException('index is less than 0.');
      if arrayIndex <0 then new ArgumentOutOfRangeException('arrayIndex is less than 0.');
      if &count <0 then new ArgumentOutOfRangeException('count is less than 0.');
      if &index >= fCount then new ArgumentException('index is equal to or greater than the Count of the source List<T>.');
      if &index+&count > fCount then new ArgumentException('index plus count is greater than the Count of the source List<T>.');
      if arrayIndex+&count > length(&array) then new ArgumentException('count is greater than the available space from arrayIndex to the end of the destination array.');

      for i:Integer := 0 to &count -1 do
        &array[arrayIndex+i] := fItems[&index+i];
    end;

    {$SHOW W27}

    property Capacity: Integer read length(fItems);

    property Count: Integer read fCount;
    property Item[i: Integer]: T read GetItem protected write SetItem; virtual; default;
    method ToString: String; override;
    begin
      exit $"{Integer(InternalCalls.Cast(self)).ToString.PadStart(if defined("CPU64") then 16 else 8, '0')} Count: {Count}";
    end;
  end;

  List<T> = public class(ImmutableList<T>, ICollection<T>, IList, IList<T>)
  private

    method set_IntItem(i: Integer; value: Object);
    begin
      SetItem(i, T(value));
    end;

    property IntItem[i: Integer]: Object read Item[i] write set_IntItem; implements IList.Item;

  public

    method &Add(val: Object);
    begin
      Add(T(val));
    end;

    method &Remove(val: Object): Boolean;
    begin
      exit Remove(T(val));
    end;

    method Contains(val: Object): Boolean;
    begin
      exit Contains(T(val));
    end;

    method &Add(anItem: T);
    begin
      if fCount = Capacity then Grow(Capacity+1);
      fItems[fCount] := anItem;
      inc(fCount);
    end;

    method AddRange(Items: ImmutableList<T>);
    begin
      if (Items <> nil) and (Items.Count > 0) then begin
        if fCount + Items.Count >= Capacity then begin
          Grow(fCount + Items.Count);
        end;
        for i: Integer := 0 to Items.Count-1 do begin
          fItems[fCount] := Items[i];
          inc(fCount);
        end;
      end;
    end;

    method AddRange(Items: array of T);
    begin
      if (length(Items)>0) then begin
        if fCount + length(Items) >= Capacity then begin
          Grow(fCount + Items.Count);
        end;
        for i: Integer := 0 to length(Items)-1 do begin
          fItems[fCount] := Items[i];
          inc(fCount);
        end;
      end;
    end;

    method Clear; override;
    begin
      inherited;
    end;

    method Insert(&Index: Integer; anItem: T);
    begin
      InsertRange(&Index, [anItem]);
    end;

    method InsertRange(&Index: Integer; Items: ImmutableList<T>);
    begin
      if Items = nil then RaiseError('Items must be assigned');
      InsertRange(&Index, Items.fItems);
    end;

    method InsertRange(&Index: Integer; Items: array of T);
    begin
      var it_len:= length(Items);
      if it_len = 0 then exit;
      if &Index <> fCount then CheckIndex(&Index);

      if fCount+it_len > Capacity then begin
        // insert into new array

        var newCapacity := fCount+it_len;
        var temp := new array of T(CalcCapacity(newCapacity));
        for i:Integer := 0  to &Index-1 do
          temp[i] := self[i];
        // insert new range
        for i:Integer := 0 to it_len-1 do
          temp[i + &Index] := Items[i];
        // copy old rest
        for i:Integer := &Index to fCount-1 do
          temp[i+it_len] := self[i];
        fItems := temp;
        fCount := newCapacity;
      end
      else begin
        // insert into existing array
        //move existing part
        for i:Integer := fCount-1 downto &Index do
          self[i+it_len] := self[i];

        // insert new range
        for i:Integer := 0 to it_len-1 do
          self[i+&Index] := Items[i];
        inc(fCount, it_len);
      end;
    end;


    method &Remove(anItem: T): Boolean;
    begin
      var i := IndexOf(anItem);
      if i = -1 then exit false;
      RemoveRange(i, 1);
      exit true;
    end;

    method RemoveAt(&Index: Integer);
    begin
      CheckIndex(&Index);
      RemoveRange(&Index,1);
    end;

    method RemoveRange(&Index: Integer; aCount: Integer);
    begin
      CheckIndex(&Index);
      if aCount = 0 then exit;
      if (aCount < 0) or (&Index + aCount > fCount) then RaiseError('aCount does not denote a valid range of elements');

      var newlength := fCount-aCount;
      memmove(@fItems[&Index], @fItems[&Index+aCount], (newlength-&Index) * sizeOf(T));
      memset(@fItems[newlength], 0, (fCount - newlength) * sizeOf(T));
      fCount := newlength;
    end;

    method Sort(Comparison: Comparison<T>);
    begin
      QuickSort(0, fCount-1, Comparison);
    end;

    property Item[i: Integer]: T read GetItem write SetItem; override; default;

  end;

  //
  //
  //

  ListEnumerator<T> = public class(IEnumerator<T>)
  private

    fList: ImmutableList<T>;
    fCurrentIndex: Integer;

    method GetCurrent: T;
    begin
      exit fList[fCurrentIndex];
    end;

    property NonGenCurrent: Object read GetCurrent; implements IEnumerator.Current;

  public
    constructor (aList: ImmutableList<T>);
    begin
      fList := aList;
      fCurrentIndex := -1;
    end;

    method MoveNext: Boolean;
    begin
      Result := fCurrentIndex < fList.Count-1;
      if Result then inc(fCurrentIndex);
    end;

    property Current: T read GetCurrent;

    method Dispose;
    begin
    end;

  end;

  LinkedListNode<T> = public class
  public
    constructor(aValue: T; aPrev: LinkedListNode<T>);
    begin
      Previous := aPrev;
      Value := aValue;
    end;
    property Value: T; readonly;
    property Previous: LinkedListNode<T>; readonly;
  end;

end.