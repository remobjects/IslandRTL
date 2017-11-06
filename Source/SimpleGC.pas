namespace RemObjects.Elements.System;
[assembly:AssemblyDefine('SIMPLEGC')]
[assembly:AssemblyDefine('TRACINGGC')]
[assembly:AssemblyDefine('REFCOUNTINGGC')]
{$IFDEF WEBASSEMBLY}
[assembly:DefaultObjectLifetimeStrategy(typeOf(SimpleGC))]
{$ENDIF}


type
  {$IFNDEF WEBASSEMBLY}
  CheckListData = record 
  public 
    const FreeListSize = 1024;
    var 
    ThreadHandle: IntPtr;
    ThreadId: intPtr;
    StackTop: ^Void;
    DoneCount: Integer;
    Count: Integer; 
    Data: array[0..FreeListSize-1] of IntPtr;
  end;
  {$ENDIF}
  MyIntPtr = {$IFNDEF CPU64}Int32{$ELSE CPU64}Int64{$ENDIF};
  {$IFDEF WEBASSEMBLY}
  DefaultGC = SimpleGC;
  {$ENDIF}
  SimpleGC<T> = public lifetimestrategy(SimpleGC) T;
  SimpleGC = public record (ILifetimeStrategy<SimpleGC>)
  private 
    var fInst: IntPtr;
    class var fFinalizer: ^Void;
    class var fLoaded: Integer; assembly;
    {$IFDEF POSIX}[LinkOnce]{$ENDIF}
    class var fSharedMemory: SharedMemory; assembly;
    
{$IFNDEF WEBASSEMBLY}
    [ThreadLocal]
    class var fCheckList: ^CheckListData;
{$ENDIF}

{$IFNDEF WEBASSEMBLY}
      class var fGCWait: Manual<EventWaitHandle>;
      class var FGCWake: Manual<EventWaitHandle>;
      class var fThreads: Manual<GCList>;
{$ENDIF}
      class var FGCLoaded: Boolean;
      class var fRemoveList: Manual<GCList>;
      class var fGlobalFreeList: Manual<GCHashSet>;
      class var fLock: Integer;
      class var fRunNumber: Integer;
      class var fLastTopBitSet: Boolean;


    
{$IFNDEF WEBASSEMBLY}
    class method GCSpinLockEnter(var x: Integer);
    begin
      loop begin
        if InternalCalls.Exchange(var x, 1) = 0 then exit;
        // if the gc is busy, wait on the wait handle
        fGCWait.Wait;
     end;
    end;
{$ENDIF}      

    // we use the bit below to set if something is "on stack", during the marking phase; if fLastTopBitSet is set, then all items in fGlobalFreeList will have the bit set, \
    // and we have to reverse, unset it for the next run to mark an item as "on stack", this bit is stored inside the reference count.
    const
      Bit: UInt64 = {$IFDEF CPU64}1 shl 63{$ELSE}1 shl 31{$ENDIF};
      FinalizeBit: UInt64 = {$IFDEF CPU64}1 shl 62{$ELSE}1 shl 30{$ENDIF};
      Mask: UInt64 = Bit or FinalizeBit;
    


    [Conditional('DEBUGGC')]
    class method Debug(s: String);
    begin
      writeLn(s);
    end;
    [Conditional('DEBUGGC')]
    class method Debug(s: ^Void);
    begin
      writeLn('ptr');
      WebAssemblyCalls.ConsoleLog(Integer(s));
    end;
    [Conditional('DEBUGGC')]
    class method Debug(s: Integer);
    begin
      writeLn('Int');
      WebAssemblyCalls.ConsoleLog(s);
    end;

    {$IFDEF WINDOWS}

    
    
    class method SetupThread(aData: ^CheckListData);
    begin 
      {$IFDEF CPU64}
      fCheckList^.StackTop := ^Void(InternalCalls.ReadGS64(8)); // test this!
      {$ELSE}
      fCheckList^.StackTop := ^Void(InternalCalls.ReadFS32(4)); // this works
      {$ENDIF}
      
      var lTar: HANDLE;
      DuplicateHandle(GetCurrentProcess,
        GetCurrentThread,
        GetCurrentProcess,
        @lTar,
        0,
        false,
        DUPLICATE_SAME_ACCESS);
      fCheckList^.ThreadId := IntPtr(GetCurrentThreadId);
      fCheckList^.ThreadHandle := IntPtr(lTar);
      Debug('In SetupThread. Stack top: ');
      DEbug(IntPtr(fCheckList^.StackTop));
      Debug('In SetupThread. Stack curr: ');
      debug(IntPtr(@aData));
      Debug('In SetupThread. tid: ');
      Debug(fCheckList^.ThreadID);
      Debug('In SetupThread. th: ');
      Debug(fCheckList^.ThreadHandle);
      FlsAlloc(@FiberCallback);
    end;

    [CallingConvention(CallingConvention.Stdcall)]
    class method FiberCallback(arg: ^Void);
    begin 
      var lData := fCheckList;
      if lData = nil then exit;
      
      CloseHandle(HANDLE(lData^.ThreadHandle));

      UnregisterThread(lData);
    end;


    class method PauseAllThreads;
    begin 
      assert(fLock = 1);
      var lCurrent := IntPtr(GetCurrentThreadId);
      for i: Integer := 0 to fThreads.Count -1 do begin 
        var lThread := ^CheckListData(fThreads[i]);
        if lThread^.ThreadId = lCurrent then continue; // probably a good idea to not disable ourselves
        SuspendThread(HANDLE(lThread^.ThreadId));
      end;
    end;

    class method ResumeAllThreads;
    begin 
      assert(fLock = 1);
      var lCurrent := IntPtr(GetCurrentThreadId);
      for i: Integer := 0 to fThreads.Count -1 do begin 
        var lThread := ^CheckListData(fThreads[i]);
        if lThread^.ThreadId = lCurrent then continue; 
        ResumeThread(HANDLE(lThread^.ThreadId));
      end;
    end;

    class method CheckThread(aThread: ^ChecklistData);
    begin 
      if fCheckList = aThread then exit;
      var ctx: CONTEXT;
      ctx.ContextFlags := CONTEXT_ALL ;
      GetThreadContext(HANDLE(aThread^.ThreadHandle), @ctx);
      for i: Integer := 0 to sizeof(ctx) / sizeOf(^Void) -1 do begin
        var c := ^IntPtr(@ctx)[i];
        if fGlobalFreeList.Contains(c) then 
          SetBit(c);
      end;
      var lCurrentStackTop := ^IntPtr({$IFDEF CPU64}ctx.rsp{$ELSE}ctx.esp{$ENDIF});
      if fCheckList = aThread then lCurrentStackTop := ^IntPtr(@aThread);
      
      var lEnd := ^IntPtr(aThread^.StackTop);
      while lCurrentStackTop < lEnd do begin 
        var lCurrent := lCurrentStackTop^;
        if fGlobalFreeList.Contains(lCurrent) then 
          SetBit(lCurrent);
        inc(lCurrentStackTop)
      end;
    end;
    {$ELSEIF WEBASSEMBLY}
    [SymbolName('__stack_pointer')]
    class var StackPointer: ^IntPtr; external;
    [SymbolName('__stack_start')]
    class var StackTop: IntPtr; external;
    class method CheckThread;
    begin 
      var lCurrentStackTop := StackPointer;
      var lEnd := @StackTop;
      while lCurrentStackTop < lEnd do begin 
        var lCurrent := lCurrentStackTop^;
        if fGlobalFreeList.Contains(lCurrent) then 
          SetBit(lCurrent);
        inc(lCurrentStackTop)
      end;
    end;
    {$ELSE}
    {$ERROR Unsupported platform}
    {$ENDIF}

    class method UnregisterThread: Integer; public;
    begin 
      {$IFNDEF WEBASSEMBLY}
      UnregisterThread(fCheckList);
      {$ENDIF}
    end;

{$IFNDEF WEBASSEMBLY}
    class method UnregisterThread(aThread: ^CheckListData); 
    begin 
      GCSpinLockEnter(var fLock);
      // Add all known data to the freelist
      // we make it match the previous run, this way the bit will match and existing items in the list, if there are any.
      for i: Integer := 0 to aThread^.Count -1 do begin
        fGlobalFreeList.Add(aThread^.Data[i]);
        SetBit(aThread^.Data[i]);
      end;

      fThreads.Remove(IntPtr(aThread));
      Utilities.SpinLockExit(var fLock);
    end;
{$ENDIF}
    
    class method SetBit(aPtr: IntPtr); {$IFNDEF DEBUG}inline;{$ENDIF}
    begin 
      var lItem := @(^UIntPtr(aPtr)[-1]);
      if fLastTopBitSet then  
        lItem^ := lItem^ or Bit
      else 
        lItem^ := lItem^ and not Bit;
    end;

    class method IsSet(aRefCount: UIntPtr): Boolean; inline;
    begin 
      if fLastTopBitSet then 
        exit (aRefCount and Bit) <> 0;
      exit (aRefCount and Bit) = 0;
    end;

{$IFNDEF WEBASSEMBLY}
    class method GCLoop(dummy: Object);
    begin 
      RegisterThread;
      while true do begin 
        fGCWait.Reset;
        fGCWake.Wait(30000);


        DoGC;


        Thread.Sleep(100);
      end;

    end;
{$ENDIF}
    class method DoGC;
    begin 
      {$IFNDEF WEBASSEMBLY}
      Utilities.SpinLockEnter(var fLock);
      for j: Integer := 0 to fThreads.Count -1 do begin 
        var lThread := ^CheckListData(fThreads[j]);
        lThread^.DoneCount := lThread^.Count;
        for i: Integer := 0 to lThread^.DoneCount -1 do begin 
          Debug('Adding to global free list: ');
          Debug(lThread^.Data[i]);
          fGlobalFreeList.Add(lThread^.Data[i]);
          Debug('Checking ADD to global free list: ');
          DEbug(Integer(fGlobalFreeList.Contains(lThread^.Data[i])));
          SetBit(lThread^.Data[i]);
        end;
      end;
      PauseAllThreads;
      // Increase the run number
      {$ENDIF}
      inc(fRunNumber);
      // Do it again for the items before we locked
      {$IFNDEF WEBASSEMBLY}
      for j: Integer := 0 to fThreads.Count -1 do begin 
        var lThread := ^CheckListData(fThreads[j]);
        // this will be fairly rare.
        for i: Integer := lThread^.Count to lThread^.DoneCount -1 do begin
          fGlobalFreeList.Add(lThread^.Data[i]);
          SetBit(lThread^.Data[i]);
        end;
        lThread^.Count := 0;
      end;
      {$ENDIF}
      // at this point all pointers in fGlobalFreeList have the bit set to 'off' (for whatever the current meaning of off is)
      fLastTopBitSet := not fLastTopBitSet;
      // now we check all thread stacks & registers and mark those to 'on', so we know what items are still present on the stack.
      {$IFNDEF WEBASSEMBLY}
      for j: Integer := 0 to fThreads.Count -1 do 
        CheckThread(^CheckListData(fThreads[j]));
      {$ELSE}
      CheckThread;
      {$ENDIF}
      // threads can be resumed, now comes the cleanup
      {$IFNDEF WEBASSEMBLY}
      ResumeAllThreads;
      {$ENDIF}

      fGlobalFreeList.AddAllItemsToList(fRemoveList);

      for i: Integer := fRemoveList.Count -1 downto 0 do begin
        // TODO: cycles
        var el := fRemoveList[i];
        var lRC := ^UIntPtr(el)[-1];
        var lRealGC := lRC and not Mask;
        if lRealGC = 0 then begin 
          //for "On Stack" we keep them in the list so they are checked in the next cycle, these are objects on the stack only, 
          var lSet := IsSet(lRC);
          Debug('realgc = 0 for ');
          Debug(el);
          Debug(' and lset is ');
          Debug(if lSet then 1 else 0);
          if lSet then begin 
            Debug('Removing from remove-list, count: ');
            Debug(fRemoveList.Count);
            fRemoveList.RemoveAt(i);
            Debug('Removing from remove-list, NEW count: ');
            Debug(fRemoveList.Count);
          end else begin 
            //else we finalize this object (refcount = 0) and remove them from the list
            Debug('Removing from global free list, count: ');
            Debug(fGlobalFreeList.Count);
            fGlobalFreeList.Remove(el);
            if (lRC and FinalizeBit) = 0 then 
              fRemoveList.RemoveAt(i);
            Debug('Removing from global free list, NEW count: ');
            Debug(fGlobalFreeList.Count);
          end;
        end else begin 
          // these can be removed as they have a positive RC, meaning they're referenced somewhere globally; the reason we don't remove them right away is 
          // that when we have to deal with cycles we have to walk them.
          Debug('Removing from remove-list, count: ');
          Debug(fRemoveList.Count);
          Debug('Removing from global free list, count: ');
          Debug(fGlobalFreeList.Count);
          fGlobalFreeList.Remove(el);
          fRemoveList.RemoveAt(i);
          Debug('Removing from remove-list, NEW count: ');
          Debug(fRemoveList.Count);
          Debug('Removing from global free list, NEW count: ');
          Debug(fGlobalFreeList.Count);
        end;
      end;
      Debug('Elements kept in global list: ');
      Debug(fGlobalFreeList.Count);
      {$IFNDEF WEBASSEMBLY}
      Utilities.SpinLockExit(var fLock);
      fGCWait.Set;
      {$ENDIF}
      for i: Integer := fRemoveList.Count -1 downto 0 do begin 
        Debug('Finalizing object ');
        Debug(fRemoveList[i]);
        FinalizeObject(fRemoveList[i]);
      end;
      Debug('Done!');
      fRemoveList.Clear;
    end;

    class method InitGC;
    begin 
      if FGCLoaded then exit;
      FGCLoaded := true;
      {$IFNDEF WEBASSEMBLY}
      Utilities.SpinLockEnter(var fLock);
      fGCWait := new Manual<EventWaitHandle>(false, false);
      FGCWake := new Manual<EventWaitHandle>(true, false);
      fThreads := new Manual<GCList>;
      {$ENDIF}
      fGlobalFreeList := new Manual<GCHashSet>();
      fRemoveList := new Manual<GCList>();
      {$IFNDEF WEBASSEMBLY}
      new Manual<Thread>(@GCLoop).Start(nil);
      Utilities.SpinLockExit(var fLock);
      {$ENDIF}
    end;
    
    const FinalizerIndex = 4 + {$IFDEF I386}4{$ELSE}2{$ENDIF};

    class method FinalizeObject(aObj: IntPtr); 
    begin 
      try {$HIDE W58}
        InternalCalls.Cast<Object>(^Void(aObj)).Finalize;
        {$SHOW W58}
        free(^Void(aObj - sizeOf(IntPtr)));
      except 
      end;
    end;

    {$IFNDEF WEBASSEMBLY}
    class method AddToFreeList(aList: IntPtr);
    begin 
      var lRun := InternalCalls.VolatileRead(var fRunNumber, false);
      Debug('Add to free list ');
      DEbug(aList);
      var lList := fCheckList;
      if lList = nil then begin 
        RegisterThread;
        lList := fCheckList;
      end;
      var lCount := InternalCalls.VolatileRead(var lList^.Count, false);
      retry: ;
      if lCount >= lList^.FreeListSize then 
        GC(true);
      lList^.Data[lCount] := aList;
      InternalCalls.VolatileWrite(var lList^.Count, lCount + 1);
      // Edge case, if the run number increases while we're here it means there was a GC process *just* when tried this, since aList will certainly be on the stack, 
      // we can just re-add it for the next time
      var lNewRun := InternalCalls.VolatileRead(var fRunNumber);
      if lNewRun <> lRun then begin 
        lRun := lNewRun;
        lCount := 0;
        goto retry;
      end;
    end;
    {$ELSE}
    class method AddToFreeList(aList: IntPtr);
    begin 
      fGlobalFreeList.Add(aList);
      SetBit(aList);
    end;
    {$ENDIF}

  public 
    class method GC(&aWait: Boolean);
    begin 
      {$IFDEF WEBASSEMBLY}
      DoGC;
      {$ELSE}
      fGCWait.Reset;
      FGCWake.Set;
      if &aWait then
        fGCWait.Wait;
      {$ENDIF}
    end;

    class method &New(aTTY: ^Void; aSize: IntPtr): ^Void;
    begin 
      if fFinalizer = nil then begin
        fFinalizer := ^^Void(InternalCalls.GetTypeInfo<Object>())[Utilities.FinalizerIndex]; // keep in sync with compiler!
      end;
     
      {$IFDEF WEBASSEMBLY}
      if not FGCLoaded then InitGC;
      {$ELSE}
      if fCheckList = nil then RegisterThread;
      {$ENDIF}

      result := ^Void(malloc(aSize + sizeOf(^Void)));
      if result = nil then begin 
        GC(true);
        result := ^Void(malloc(aSize + sizeOf(^Void)));
        if result = nil then exit nil;
      end;
      ^UIntPtr(result)^ := 0;
      result := result + sizeOf(^Void);
      ^^Void(result)^ := aTTY;
      memset(^Byte(result) + sizeOf(^Void), 0, aSize - sizeOf(^Void));
      AddToFreeList(IntPtr(result)); // ensure the value gets scanned.
      
      if ^^Void(aTTY)[Utilities.FinalizerIndex] <> fFinalizer then begin
        SetFinalizer(result);
      end;
    end;

    class method RegisterThread: Integer;
    begin 
      if not FGCLoaded then InitGC;
    {$IFNDEF WEBASSEMBLY}
      var lList := fCheckList;
      if lList <> nil then exit;
      lList := ^CheckListData(malloc(sizeof(CheckListData)));
      fCheckList := lList;
      SetupThread(lList);
      lList^.Count := 0;
      GCSpinLockEnter(var fLock);
      fThreads.Add(IntPtr(lList));
      Utilities.SpinLockExit(var fLock);
    {$ENDIF}
    end;

    class method AddRef(o: ^IntPtr);
    begin 
      if o = nil then exit;
      {$IFNDEF WEBASSEMBLY}
      var lList := fCheckList;
      if lList= nil then begin 
        RegisterThread;
        lList := fCheckList;
      end;
      {$ELSE}
      if not FGCLoaded then InitGC;   
      {$ENDIF}
        
      var ptr := InternalCalls.Cast(o^);
      Debug('AddRef: ');
      Debug(IntPtr(ptr));
      if (^Void(o) < {$IFDEF WEBASSEMBLY}^Void(@StackTop){$ELSE}lList^.StackTop{$ENDIF}) and (^Void(o) >= ^Void(@o)) then exit; // on the stack, should be relatively rare
      dec(ptr, sizeOf(IntPtr));
      InternalCalls.Increment(var ^MyIntPtr(ptr)^);
    end;

    class method Release(o: ^IntPtr);
    begin 
      if o = nil then exit;
      {$IFNDEF WEBASSEMBLY}
      var lList := fCheckList;
      if lList= nil then begin 
        RegisterThread;
        lList := fCheckList;
      end;
      {$ELSE}
      if not FGCLoaded then InitGC;   
      {$ENDIF}
      
      var ptr := InternalCalls.Cast(o^);
      Debug('Release: ');
      Debug(IntPtr(ptr));
      if (^Void(o) < {$IFDEF WEBASSEMBLY}^Void(@StackTop){$ELSE}lList^.StackTop{$ENDIF}) and (^Void(o) >= ^Void(@o)) then exit; // on the stack, should be relatively rare
      dec(ptr, sizeOf(IntPtr));
      InternalCalls.Decrement(var ^MyIntPtr(ptr)^);
      AddToFreeList(IntPtr(InternalCalls.Cast(o^)));
    end;

    class method SetFinalizer(aPtr: ^Void);
    begin 
      if aPtr = nil then exit;
      var lItem := @(^UIntPtr(aPtr)[-1]);
      lItem^ := lItem^ or FinalizeBit;
    end;

    class method UnsetFinalizer(aPtr: ^Void);
    begin 
      if aPtr = nil then exit;
      var lItem := @(^UIntPtr(aPtr)[-1]);
      lItem^ := lItem^ and not FinalizeBit;
    end;
    
    class method Init(var Dest: SimpleGC);
    begin
      Dest.fInst := 0;
    end;
    
    [GCSkipIfOnStack]
    constructor Copy(var aValue: SimpleGC);
    begin
      fInst := aValue.fInst;
      AddRef(@fInst);
    end;
    
    class method Copy(var aDest: SimpleGC; var aSource: SimpleGC);
    begin
      aDest.fInst := aSource.fInst;
      AddRef(@aDest.fInst);
    end;
    
    [GCSkipIfOnStack]
    class operator Assign(var aDest: SimpleGC; var aSource: SimpleGC);
    begin
      Assign(var aDest, var aSource);
    end;
    
    class method Assign(var aDest: SimpleGC; var aSource: SimpleGC);
    begin
      if (@aDest) = (@aSource) then exit;
      {$IFNDEF WEBASSEMBLY}
      var lList := fCheckList;
      if lList= nil then begin 
        RegisterThread;
        lList := fCheckList;
      end;
      {$ELSE}
      var lList: Integer;
      if not FGCLoaded then InitGC;   
      {$ENDIF}  
      // value is on the stack, should be relatively rare
      if (^Void(@aDest.fInst) < {$IFDEF WEBASSEMBLY}^Void(@StackTop){$ELSE}lList^.StackTop{$ENDIF}) and (^Void(@aDest.fInst) >= ^Void(@lList)) then exit; 
      
      var lInst := aSource.fInst;
      var lOld := InternalCalls.Exchange(var aDest.fInst, lInst);
      if lOld = lInst then exit;
      if lInst <> 0 then begin 
        InternalCalls.Increment(var ^IntPtr(lInst)[-1]);
      end;
      if lOld <> 0  then begin 
        InternalCalls.Decrement(var ^IntPtr(lOld)[-1]);
        AddToFreeList(IntPtr(InternalCalls.Cast(lOld)));
      end;
    end;
    
    class method Release(var aDest: SimpleGC);
    begin 
      Release(@aDest.fInst);
      aDest.fInst := 0;
    end;
    
    [GCSkipIfOnStack]
    finalizer;
    begin
      Release(@fInst);
      fInst := 0;
    end;
  end;

  GCHashEntry = private record
  public
    HashCode: Integer;
    Next: Integer; // contains reference to next item with the same hashcode
    Item : IntPtr;
  end;

  GCHashSet = class
  private
    const EMPTYHASH: Integer = 0;
    const EMPTY_BUCKET: Integer = 0;
    const POSITIVE_INTEGER_MASK: UInt32 = $7FFFFFFF;
    const MIN_HASHSET_SIZE: Integer = 11;
    const DEFAULT_MAX_INDEX = 1;
  private
    fCount: Integer := 0;
    fMaxUsedIndex: Integer := DEFAULT_MAX_INDEX;
    fbucketTable: Manual<array of Integer>; 

    fFirstHole: Integer := EMPTY_BUCKET;
    fEntriesTable: Manual<array of GCHashEntry>;
    

    method DoAdd(hash: Integer; Item: IntPtr);
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


    method IndexOfItem(Hash: Integer; Item: IntPtr): Integer;
    begin
      var lIndex := CalcIndex(Hash);
      var k := fbucketTable[lIndex];
      while (k <> EMPTY_BUCKET) and (fEntriesTable[k].HashCode <> EMPTYHASH) do begin
        if (fEntriesTable[k].HashCode = Hash) and (fEntriesTable[k].Item = Item) then
          exit k
        else
          k := fEntriesTable[k].Next;
      end;
      exit -1;
    end;


    method CalcIndex(Hash: Integer): Integer; inline;
    begin
      var k := Hash and POSITIVE_INTEGER_MASK;
      exit k - (k/length(fEntriesTable))*length(fEntriesTable);
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
      var new_fbucketTable := new Manual<array of Integer>(aNewCapacity);
      
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
      var new_fEntriesTable := new Manual<array of GCHashEntry>(aNewCapacity);
      if fMaxUsedIndex > DEFAULT_MAX_INDEX then begin
        memmove(@new_fEntriesTable[0], @fEntriesTable[0], fMaxUsedIndex * sizeOf(GCHashEntry));
      end;
      Manual.FreeObject(^IntPtr(@fbucketTable)^);
      Manual.FreeObject(^IntPtr(@fEntriesTable)^);
      fbucketTable := new_fbucketTable;
      fEntriesTable := new_fEntriesTable;
    end;


  public
    constructor;
    begin
      DoResize(CalcNextCapacity(4096));
    end;

    method &Add(Item: IntPtr):Boolean;
    begin
      var hash := Integer(Item) or $80000000;
      if IndexOfItem(hash, Item) <> -1 then exit false;
      DoAdd(hash, Item);
      exit true;
    end;

    method Clear;
    begin
      //fbucketTable := new array of Integer(0);
      //fEntriesTable := new array of HashEntry<IntPtr>(0);
      fCount := 0;
      fMaxUsedIndex := DEFAULT_MAX_INDEX;
      fFirstHole := EMPTY_BUCKET;
      for i:Integer := 0 to length(fEntriesTable)-1 do begin
        fEntriesTable[i].Next := EMPTY_BUCKET;
      end;
    end;

    method Contains(Item: IntPtr): Boolean;
    begin
      var hash := Integer(Item) or $80000000;
      exit IndexOfItem(hash,Item) <> -1;
    end;

    method &Remove(Item: IntPtr): Boolean;
    begin
      var hash := Integer(Item) or $80000000;
      var idx := IndexOfItem(hash, Item);
      if idx <> -1 then DoRemove(hash, idx);
      exit idx <> -1;
    end;

    method AddAllItemsToList(aList: Manual<GCList>);
    begin 
      var k: Integer := 0;
      for i:Integer := 0 to fMaxUsedIndex-1 do begin
        if fEntriesTable[i].HashCode <> EMPTYHASH then begin
          aList.Add(fEntriesTable[i].Item);
          inc(k);
        end;
      end;
    end;


    property Count: Integer read fCount;
  end;

  GCList = class
  private
    fItems: Manual<array of IntPtr>;
    fCount: Integer := 0;
    class method CalcCapacity(aNewCapacity: Integer): Integer;
    begin
      var lDelta: Integer;
      if aNewCapacity > 64 then lDelta := aNewCapacity / 4
      else if aNewCapacity > 8 then lDelta := 16
      else lDelta := 4;
      exit aNewCapacity + lDelta;
    end;

  public
    property Count: Integer read fCount;
    property Item[i: Integer] : IntPtr read fItems[i]; default;

    method Add(anItem: IntPtr);
    begin
      if fCount = length(fItems) then Grow(length(fItems)+1);
      fItems[fCount] := anItem;
      inc(fCount);
    end;

    method Clear;
    begin
      fCount := 0;
    end;


    method Grow(aCapacity: Integer);
    begin
      aCapacity := CalcCapacity(aCapacity);
      var newarray := new Manual<array of IntPtr>(aCapacity);
      for i: Integer := 0 to fCount-1 do
        newarray[i] := fItems[i];
      Manual.FreeObject(^IntPtr(@fItems)^);
      fItems := newarray;
    end;

    method Remove(val: IntPtr);
    begin 
      for j: Integer := fCount -1 downto 0 do begin 
        if fItems[j] = val then RemoveAt(j);
      end;
    end;

    method RemoveAt(&Index: Integer);
    begin
      for i: Integer := &Index +1 to fCount -1 do 
        fItems[i-1] := fItems[i];
      dec(fCount);
    end;
  end;
  
  SimpleGCExt = public extension class(Utilities)
  public 
    class method Collect(c: Integer);
    begin
      SimpleGC.GC(c <> 0);
    end;
  end;

end.