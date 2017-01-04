namespace RemObjects.Elements.System;

type 
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
      GCHandles.Free(fHandle);
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
      since pointers can't have bit 0 set, if they have it set it's a "free" slot, the value contains the signed index of the next free slot shifted 1, or -1 for "eof"

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
          fFirstFree := lFirstFree shr 1;
          fSlots[result] := aValue;
          inc(result);
          exit;
        end;
      end;
    end;

    [SymbolName('__elements_gchandle_get')]
    class method Get(aValue: NativeInt): Object;
    begin
      if aValue = 0 then raise new ArgumentException('Invalid GC Handle'); // not valid
      dec(aValue);
      if aValue >= length(fSlots) then raise new ArgumentException('Invalid GC Handle');
      // we shouldn't need a lock as the value can't *update* underneath us
      result := fSlots[aValue];
      if (NativeInt(InternalCalls.Cast(result)) = 0) or ((NativeInt(InternalCalls.Cast(result)) and 1) <> 0) then raise new ArgumentException('Invalid GC Handle'); // not valid
    end;

    [SymbolName('__elements_gchandle_free')]
    class method Free(aValue: NativeInt);
    begin 
      if aValue = 0 then raise new ArgumentException('Invalid GC Handle'); // not valid
      dec(aValue);
      if aValue >= length(fSlots) then raise new ArgumentException('Invalid GC Handle');
      locking fLock do begin 
        var lValue := fSlots[aValue];
        if (NativeInt(InternalCalls.Cast(lValue)) = 0) or ((NativeInt(InternalCalls.Cast(lValue)) and 1) <> 0) then raise new ArgumentException('Invalid GC Handle');
        fSlots[aValue] := InternalCalls.Cast<Object>(^Void((fFirstFree shl 1) or 1));
        fFirstFree := aValue;
      end;
    end;
  end;

end.
