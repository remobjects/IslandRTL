namespace RemObjects.Elements.System;

type
  HashEntry<T> = private record
  public
    HashCode: Integer; // current hashcode
    Next: Integer; // contains reference to next item with the same hashcode
    Item : T;
  end;

  HashSet<T> = public class
  private
    const EMPTYHASH: Integer = 0;
    const EMPTY_BUCKET: Integer = 0;
    const POSITIVE_INTEGER_MASK: UInt32 = $7FFFFFFF;
    const MIN_HASHSET_SIZE: Integer = 11;
    const DEFAULT_MAX_INDEX = 1;
  private
    fCount: Integer := 0;
    fMaxUsedIndex: Integer := DEFAULT_MAX_INDEX;
    fbucketTable: array of Integer; // contains "hash / fcapacity" and references to fTable

    fFirstHole: Integer := EMPTY_BUCKET;
    fEntriesTable: array of HashEntry<T>;
    fComparer : IEqualityComparer<T>;

    method GetItems: sequence of T; iterator;
    begin
      var i:=0;
      var idx := 0;
      while idx < fCount do begin
        if fEntriesTable[i].HashCode <> EMPTY_BUCKET then begin
          inc(idx);
          yield fEntriesTable[i].Item;
        end;
        inc(i);
      end;
    end;

    method DoAdd(hash: Integer; Item: T);
    begin
      var pos := EMPTY_BUCKET;
      if fFirstHole <> EMPTY_BUCKET then begin
        pos := fFirstHole;
        fFirstHole := fEntriesTable[fFirstHole].Next;
      end
      else begin
        if fCount = length(fEntriesTable) - 2 then DoResize(CalcNextCapacity(length(fEntriesTable)));
        pos := fMaxUsedIndex;
        inc(fMaxUsedIndex);
      end;
      fEntriesTable[pos].HashCode := hash;
      fEntriesTable[pos].Next := EMPTY_BUCKET;
      fEntriesTable[pos].Item := Item;

      var idx := CalcIndex(hash);
      if fbucketTable[idx] = EMPTY_BUCKET then
        fbucketTable[idx] := pos
      else begin
        idx := fbucketTable[idx];
        while fEntriesTable[idx].Next <> EMPTY_BUCKET do idx := fEntriesTable[idx].Next;
        fEntriesTable[idx].Next := pos;
      end;
      inc(fCount);
    end;

    method DoRemove(Hash, aIndex: Integer);
    begin
      var fbucketidx := CalcIndex(Hash);
      if fbucketTable[fbucketidx] = aIndex then begin
        // bucket table references to fEntriesTable entry
        fbucketTable[fbucketidx] := fEntriesTable[aIndex].Next;
      end
      else begin
        // idx is specifies index from "Next"
        var idx1 := fbucketTable[fbucketidx];
        while fEntriesTable[idx1].Next <> aIndex do idx1 := fEntriesTable[idx1].Next;
        fEntriesTable[idx1].Next := fEntriesTable[aIndex].Next;
      end;
      // clear "item"
      fEntriesTable[aIndex].HashCode := EMPTYHASH;
      fEntriesTable[aIndex].Next := fFirstHole;
      fEntriesTable[aIndex].Item := nil;
      fFirstHole := aIndex;
      dec(fCount);
    end;

    method CalcIndex(Hash: Integer): Integer;
    begin
      if length(fEntriesTable) = 0 then DoResize(CalcNextCapacity(0));
      var k := Hash and POSITIVE_INTEGER_MASK;
      exit k - (k/length(fEntriesTable))*length(fEntriesTable);
    end;

    method IndexOfItem(Hash: Integer; Item: T): Integer;
    begin
      var lIndex := CalcIndex(Hash);
      var k := fbucketTable[lIndex];
      while (k <> EMPTY_BUCKET) and (fEntriesTable[k].HashCode <> EMPTYHASH) do begin
        if (fEntriesTable[k].HashCode = Hash) and fComparer.Equals(fEntriesTable[k].Item,Item) then
          exit k
        else
          k := fEntriesTable[k].Next;
      end;
      exit -1;
    end;

    method CheckItemForNil(Item:T);
    begin
      if Item = nil then raise new ArgumentNullException("Item is nil");
    end;

    method CalcHashCode(Item:T): Integer;
    begin
      CheckItemForNil(Item);
      exit fComparer.GetHashCode(Item) or $80000000;
    end;

    method CalcNextCapacity(aCapacity: Integer): Integer;
    begin
      if aCapacity < MIN_HASHSET_SIZE then exit MIN_HASHSET_SIZE;
      if fCount = 0 then exit aCapacity;
      result := (aCapacity shl 1) + 1;
      if result > 50 then exit (result/100)*100 + 97
    end;

    method DoResize(aNewCapacity: Integer);
    begin
      if (aNewCapacity <= length(fEntriesTable)) and (fCount>0) then exit;
      var new_fbucketTable := new array of Integer(aNewCapacity);
{
      for i:Integer :=0 to length(new_fbucketTable)-1 do
        new_fbucketTable[i] := EMPTY_BUCKET;
}
      for i:Integer := 0 to length(fEntriesTable)-1 do begin
        fEntriesTable[i].Next := EMPTY_BUCKET;
      end;

      if fMaxUsedIndex > DEFAULT_MAX_INDEX then
        for i:Integer := 0 to fMaxUsedIndex-1 do begin
          var idx := CalcIndex(fEntriesTable[i].HashCode);

          if new_fbucketTable[idx] = EMPTY_BUCKET then begin
            new_fbucketTable[idx] := i;
            fEntriesTable[i].Next := EMPTY_BUCKET;
          end
          else begin
            idx := new_fbucketTable[idx];
            while (fEntriesTable[idx].Next <> EMPTY_BUCKET) do
              idx := fEntriesTable[idx].Next;
            fEntriesTable[idx].Next := i;
          end;
        end;
      var new_fEntriesTable := new array of HashEntry<T>(aNewCapacity);
      if fMaxUsedIndex > DEFAULT_MAX_INDEX then begin
        memmove(@new_fEntriesTable[0], @fEntriesTable[0], fMaxUsedIndex * sizeOf(HashEntry<T>));
      end;
      fbucketTable := new_fbucketTable;
      fEntriesTable := new_fEntriesTable;
    end;


  public
    constructor;
    begin
      constructor(MIN_HASHSET_SIZE);
    end;

    constructor(aComparer : IEqualityComparer<T>);
    begin
      fComparer := aComparer;
      constructor;
    end;

    constructor(aCapacity: Int32);
    begin
      if fComparer = nil then fComparer := new DefaultEqualityComparer<T>;
      if aCapacity < MIN_HASHSET_SIZE then aCapacity := MIN_HASHSET_SIZE;
      DoResize(CalcNextCapacity(aCapacity));
    end;

    constructor(aCapacity: Int32; aComparer : IEqualityComparer<T>);
    begin
      fComparer := aComparer;
      constructor(aCapacity);
    end;

    method GetSequence: sequence of T;
    begin
      var r := new array of T(fCount);
      var k: Integer := 0;
      for i:Integer := 0 to fMaxUsedIndex-1 do begin
        if fEntriesTable[i].HashCode <> EMPTYHASH then begin
          r[k]:= fEntriesTable[i].Item;
          inc(k);
        end;
      end;
      exit r;
    end;

    method &Add(Item: T):Boolean;
    begin
      var hash := CalcHashCode(Item);
      if IndexOfItem(hash, Item) <> -1 then exit false;
      DoAdd(hash, Item);
      exit true;
    end;

    method Clear;
    begin
      fbucketTable := new array of Integer(0);
      fEntriesTable := new array of HashEntry<T>(0);
      fCount := 0;
      fMaxUsedIndex := DEFAULT_MAX_INDEX;
      fFirstHole := EMPTY_BUCKET;
    end;

    method Contains(Item: T): Boolean;
    begin
      var hash := CalcHashCode(Item);
      exit IndexOfItem(hash,Item) <> -1;
    end;

    method &Remove(Item: T): Boolean;
    begin
      var hash := CalcHashCode(Item);
      var idx := IndexOfItem(hash, Item);
      if idx <> -1 then DoRemove(hash, idx);
      exit idx <> -1;
    end;

    method ForEach(Action: Action<T>);
    begin
      for i: Integer := 0 to fCount - 1 do
        Action(fEntriesTable[i].Item);
    end;

    property Items: sequence of T read GetItems;
    property Count: Integer read fCount;
    property Comparer: IEqualityComparer<T> read fComparer;
  end;


end.