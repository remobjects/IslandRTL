namespace RemObjects.Elements.System;

type
  // A handle has one owner. Record copies and constructor(Handle) borrow the
  // same slot; they do not retain it. Only the owner calls Dispose, and borrowers
  // must stop using it first. Released slot numbers may be reused, so HasValue
  // describes this record, not the lifetime of a separately disposed copy.
  GCHandle = public record(IDisposable)
  private
    fHandle: NativeInt;
  public
    class method Allocate(aValue: Object): GCHandle;
    begin
      exit new GCHandle(GCHandles.Allocate(aValue));
    end;

    method Dispose;
    begin
      // Clear this owning record before releasing its shared handle slot.
      var lHandle := InternalCalls.Exchange(var fHandle, 0);
      if lHandle <> 0 then GCHandles.Free(lHandle);
    end;
    constructor(aHandle: NativeInt);
    begin
      fHandle := aHandle;
    end;
    property Target: Object read GCHandles.Get(fHandle);

    property HasValue: Boolean read fHandle <> 0;
    property Handle: NativeInt read fHandle;
  end;

  GCHandles = static class
  private
    class var fLock: Monitor := new Monitor;
    class var fSlots: array of Object;
    class var fFirstEmpty: Integer := 0;
    class var fFirstFree: Integer := -1;
    (*

      Handle is an NativeInt, 0 isn't valid, 1 is entry [0], 2 is entry[1] etc.
      Intially if fCount < lengtH(fSlots) we put it there, else we check the firstfree list, else we allocate a new array.
      since pointers can't have bit 0 set, if they have it set it's a "free" slot, the value contains (next free index + 1) shifted left 1, then bit 0 set; 1 ends the list

    *)
  public
    [SymbolName('__elements_gchandle_allocate')]
    class method Allocate(aValue: Object): NativeInt;
    begin
      if aValue = nil then raise new ArgumentException('Invalid object value');
      locking fLock do begin
        if (fFirstFree = -1) and (fFirstEmpty >= length(fSlots)) then begin
          var lNewArray := new Object[length(fSlots) + 1024];
          &Array.Copy(fSlots, lNewArray, length(fSlots));
          fSlots := lNewArray;
        end;
        if fFirstEmpty < length(fSlots) then begin
          fSlots[fFirstEmpty] := aValue;
          inc(fFirstEmpty);
          exit fFirstEmpty; // +1 value since gchandle 0 is reserved.
        end;
        if fFirstFree <> -1 then begin
          result := fFirstFree;
          var lFirstFree := NativeInt(InternalCalls.Cast(fSlots[result]));
          assert((lFirstFree and 1) <> 0);
          fFirstFree := (lFirstFree shr 1) - 1;
          fSlots[result] := aValue;
          inc(result);
          exit;
        end;
      end;
    end;

    [SymbolName('__elements_gchandle_get')]
    class method Get(aValue: NativeInt): Object;
    begin
      if aValue <= 0 then raise new ArgumentException('Invalid GC Handle');
      dec(aValue);
      // Pair reads with allocation/free, including publication of a grown table.
      locking fLock do begin
        if aValue >= length(fSlots) then raise new ArgumentException('Invalid GC Handle');
        result := fSlots[aValue];
        if (NativeInt(InternalCalls.Cast(result)) = 0) or ((NativeInt(InternalCalls.Cast(result)) and 1) <> 0) then raise new ArgumentException('Invalid GC Handle');
      end;
    end;

    [SymbolName('__elements_gchandle_free')]
    class method Free(aValue: NativeInt);
    begin
      if aValue <= 0 then raise new ArgumentException('Invalid GC Handle'); // not valid
      dec(aValue);
      if aValue >= length(fSlots) then raise new ArgumentException('Invalid GC Handle');
      locking fLock do begin
        var lValue := fSlots[aValue];
        if (NativeInt(InternalCalls.Cast(lValue)) = 0) or ((NativeInt(InternalCalls.Cast(lValue)) and 1) <> 0) then raise new ArgumentException('Invalid GC Handle');
        // Bias the index so the end marker is positive on either pointer width.
        // Casting a 32-bit -1 to a 64-bit pointer could lose its sign bits.
        fSlots[aValue] := InternalCalls.Cast<Object>(^Void((NativeInt(fFirstFree + 1) shl 1) or 1));
        fFirstFree := aValue;
      end;
    end;
  end;

end.