namespace RemObjects.Elements.System;

type
  MAllocFunc nested in SharedMemory = function(size: {$IFDEF WINDOWS}{$IFDEF i386}UInt32{$ELSE}UInt64{$ENDIF}{$ELSE}rtl.size_t{$ENDIF}): ^Void;
  CollectFunc nested in SharedMemory = procedure;
  UnregisterFunc nested in SharedMemory = function: Integer;
  SetFinalizerFunc nested in SharedMemory = procedure(val: ^Void; aFunc: gc.GC_finalization_proc);
  SharedMemory = record
  public
    malloc: MAllocFunc;
    setfinalizer: SetFinalizerFunc;
    collect: CollectFunc;
    register: UnregisterFunc;
    unregister: UnregisterFunc;
  end;
  Utilities = public static class
  private
    class var fFinalizer: ^Void;
    class var fLoaded: Integer;
    class var fLock: Integer;
    {$IFDEF POSIX}[LinkOnce]{$ENDIF}
    class var fSharedMemory: SharedMemory;
  public
    [SymbolName('__abstract')]
    class method AbstractCall;
    begin
      raise new AbstractMethodException;
    end;

    [SymbolName('__isinst'), SkipDebug]
    class method IsInstance(aInstance: Object; aType: ^Void): Object;
    begin
      if aInstance = nil then exit nil;
      if aType = nil then exit nil;
      var lTTY := ^^IslandTypeInfo(InternalCalls.Cast(aInstance))^;
      var lTypeHash1 := ^IslandTypeInfo(aType)^.Hash1;
      var lTypeHash2 := ^IslandTypeInfo(aType)^.Hash2;
      loop begin
        if SameType(lTTY, aType, lTypeHash1, lTypeHash2) then exit aInstance;
        lTTY := lTTY^.ParentType;
        if lTTY = nil then exit nil;
      end;
    end;

    [SkipDebug]
    class method SameString(aLeft, aRight: ^AnsiChar): Boolean; private;
    begin
      if (aLeft = nil) or (aRight = nil) then exit false;
      loop begin
        if aLeft^ <> aRight^ then exit false;
        if aLeft^ = #0 then exit true;
      end;
    end;

    class method SameType(aLeft, aRight: ^Void; aRightHash1, aRightHash2: Int64): Boolean; inline; private;
    begin // this is a fast way to check for type equivalence and support cross dll type matches.
      exit (aLeft = aRight) or (assigned(aLeft) and (^IslandTypeInfo(aLeft)^.Hash1 = aRightHash1)and (^IslandTypeInfo(aLeft)^.Hash2 = aRightHash2) and (SameString(^IslandTypeInfo(aLeft)^.Ext^.Name, ^IslandTypeInfo(aRight)^.Ext^.Name)));
    end;

    [SymbolName('__isintfinst'), SkipDebug]
    class method IsInterfaceInstance(aInstance: Object; aType: ^Void; aHashCode: Cardinal): ^Void;
    begin
      if aInstance =nil then exit nil;
      if aType = nil then exit nil;
      var lIntf := ^^IslandTypeInfo(InternalCalls.Cast(aInstance))^^.InterfaceType;
      if lIntf = nil then exit nil;
      var lIntfHash1 := ^IslandTypeInfo(aType)^.Hash1;
      var lIntfHash2 := ^IslandTypeInfo(aType)^.Hash2;
      aHashCode := aHashCode mod lIntf^.HashTableSize;
      var lHashEntry := (@lIntf^.FirstEntry)[aHashCode];
      if lHashEntry = nil then exit nil;
      repeat
        if SameType(lHashEntry^, aType, lIntfHash1, lIntfHash2) then
          exit aType;
        inc(lHashEntry);
      until lHashEntry^ = nil;
      exit nil;
    end;

    [SymbolName('__newindexoutofrange'), SkipDebug]
    class method CreateIndexOutOfRangeException(aIndex, aMax: NativeUInt): Exception;
    begin
      if aMax = 0 then
        exit new IndexOutOfRangeException('Array index '+aIndex+' is outside of the valid range (array is empty)')
      else
        exit new IndexOutOfRangeException('Array index '+aIndex+' is outside of the valid range (0..'+(aMax-1)+')');
    end;

    [SymbolName('__newinvalidcast'), SkipDebug]
    class method CreateInvalidCastException: Exception;
    begin
      exit new InvalidCastException('Invalid cast');
    end;

    [SymbolName('__newdividebyzero'), SkipDebug]
    class method CreateDivideByZeroException: Exception;
    begin
      exit new DivideByZeroException;
    end;

    [SymbolName('__newnullrefexception'), SkipDebug]
    class method CreateNullReferenceException: Exception;
    begin
      exit new NullReferenceException;
    end;
    {$IFDEF WINDOWS}var fMapping: rtl.HANDLE;{$ENDIF}
    [SkipDebug]
    method LoadGC; private;
    begin
      SpinLockEnter(var fLock);
      try
        if InternalCalls.CompareExchange(var fLoaded, 1, 0 ) = 1 then begin
          exit;
        end;
        {$IFDEF WINDOWS}
        var FN: array[0..28] of Char;
        FN[0] := '_';
        FN[1] := '_';
        FN[2] := 'R';
        FN[3] := 'e';
        FN[4] := 'm';
        FN[5] := 'O';
        FN[6] := 'b';
        FN[7] := 'j';
        FN[8] := 'e';
        FN[9] := 'c';
        FN[10] := 't';
        FN[11] := 's';
        FN[12] := 'I';
        FN[13] := 's';
        FN[14] := 'l';
        FN[15] := 'a';
        FN[16] := 'n';
        FN[17] := 'd';
        FN[18] := '1'; // Version, increase when adding stuff or making the class layout incompatible
        var lID := rtl.GetCurrentProcessId;
        FN[19] := Char(Integer('a')+Integer((lID shr 0) and $f));
        FN[20] := Char(Integer('a')+Integer((lID shr 4) and $f));
        FN[21] := Char(Integer('a')+Integer((lID shr 8) and $f));
        FN[22] := Char(Integer('a')+Integer((lID shr 12) and $f));
        FN[23] := Char(Integer('a')+Integer((lID shr 16) and $f));
        FN[24] := Char(Integer('a')+Integer((lID shr 20) and $f));
        FN[25] := Char(Integer('a')+Integer((lID shr 24) and $f));
        FN[26] := Char(Integer('a')+Integer((lID shr 28) and $f));
        FN[27] := #0;

        fMapping := rtl.CreateFileMappingW( rtl.INVALID_HANDLE_VALUE, nil, rtl.PAGE_READWRITE, 0, 8, @FN[0]);

        if fMapping = nil then begin
          LocalGC;
          raise new Exception('Cannot create file mapping for memory sharing, this should not happen!');
        end;
        var lNew := rtl.GetLastError <> rtl.ERROR_ALREADY_EXISTS;
        var p: ^NativeInt := ^NativeInt(rtl.MapViewOfFile(fMapping, rtl.FILE_MAP_WRITE, 0, 0, 8));
        if p = nil then begin
          LocalGC;
          raise new Exception('Cannot create file mapping for memory sharing, this should not happen!');
        end;
        if lNew then begin
          LocalGC;
          InternalCalls.VolatileWrite(var p^, NativeInt(@fSharedMemory));
        end else begin
          loop begin
            var lData: ^SharedMemory := ^SharedMemory(InternalCalls.VolatileRead(var p^));
            if lData = nil then Thread.Sleep(1) else begin
              fSharedMemory := lData^;
              break;
            end;
          end;
        end;
        rtl.UnmapViewOfFile(p);
        if not lNew then begin
          rtl.CloseHandle(fMapping);
          fMapping := rtl.INVALID_HANDLE_VALUE;
        end;
        {$ELSE}
        LocalGC;
        {$ENDIF}
      finally
        SpinLockExit(var fLock);
      end;
    end;

    method GC_my_register_my_thread: Integer;
    begin 
      var sb: gc.__struct_GC_stack_base;
      gc.GC_get_stack_base(@sb);
      exit gc.GC_register_my_thread(@sb);
    end;

    {$IFDEF POSIX}[LinkOnce, DllExport]{$ENDIF}
    [SkipDebug]
    method LocalGC; private;
    begin
      gc.GC_INIT;
      gc.GC_allow_register_threads();
      fSharedMemory.collect := @gc.GC_gcollect;
      fSharedMemory.register := @GC_my_register_my_thread;
      fSharedMemory.unregister := @gc.GC_unregister_my_thread;
      fSharedMemory.malloc := @gc.GC_malloc;
      fSharedMemory.setfinalizer := @SetFinalizer;
    end;
    [SymbolName('registerthread')]
    method RegisterThread: Boolean;
    begin 
      exit fSharedMemory.register() = gc.GC_SUCCESS;
    end;

    [SymbolName('unregisterthread')]
    method UnregisterThread; 
    begin 
      fSharedMemory.unregister;
    end;

    method SetFinalizer(aVal: ^Void; aProc: gc.GC_finalization_proc);
    begin
      gc.GC_register_finalizer_no_order(aVal, aProc, nil, nil, nil);
    end;
    const FinalizerIndex = 4 + {$IFDEF I386}4{$ELSE}2{$ENDIF};
    [SymbolName('__newinst')]
    //[SkipDebug]
    class method NewInstance(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      if fFinalizer = nil then begin
        fFinalizer := ^^Void(InternalCalls.GetTypeInfo<Object>())[FinalizerIndex]; // keep in sync with compiler!
      end;
      result := ^Void(-1);
      if fLoaded = 0 then LoadGC;
      result := fSharedMemory.malloc(aSize);
      ^^Void(result)^ := aTTY;
      memset(^Byte(result) + sizeOf(^Void), 0, aSize - sizeOf(^Void));
      if ^^Void(aTTY)[FinalizerIndex] <> fFinalizer then begin
        fSharedMemory.setfinalizer(result, @GC_finalizer);
      end;
    end;

    [SymbolName('__newarray')]
    //[SkipDebug]
    class method NewArray(aTY: ^Void; aElementSize, aElements: NativeInt): ^Void;
    begin
      result := NewInstance(aTY, sizeOf(^Void) + sizeOf(NativeInt) + aElementSize * aElements);
      (@InternalCalls.Cast<&Array>(result).fLength)^ := aElements;
    end;

    [SymbolName('__newdelegate')]
    //[SkipDebug]
    class method NewDelegate(aTY: ^Void; aSelf: Object; aPtr: ^Void): &Delegate;
    begin
      result := InternalCalls.Cast<&Delegate>(NewInstance(aTY, sizeOf(^Void) * 3));
      result.fSelf := aSelf;
      result.fPtr := aPtr;
    end;

    [SymbolName('__init')]
    class method Initialize;
    begin
    end;

    [SymbolName('llvm.returnaddress')]
    class method GetReturnAddress(aLevel: Integer): ^Void; external;

    // These two functions are used for the debug engine, to find out the type & "ToString" value of an object.
    [SymbolName('ElementsGetTypeName'), Used]
    class method GetObjectTypeName(aObj: Object): ^WideChar;
    begin
      if aObj = nil then exit nil;
      var s := aObj.GetType.Name.ToCharArray(true); // this will work as the GC is paused during debug.
      exit @s[0];
    end;

    [SymbolName('ElementsObjectToString'), Used]
    class method GetObjectToString(aObj: Object): ^WideChar;
    begin
      if aObj = nil then exit nil;
      var s := aObj:ToString():ToCharArray(true);
      exit @s[0];
    end;

    class method SuppressFinalize(o: Object);
    begin
      if o <> nil then
        fSharedMemory.setfinalizer(InternalCalls.Cast(o), nil);
    end;

    class method Collect(c: Integer);
    begin
      for i: Integer := 0 to c -1 do
        fSharedMemory.collect;
    end;

    class method SpinLockEnter(var x: Integer);
    begin
     loop begin
       if InternalCalls.Exchange(var x, 1) = 0 then exit;
       if not Thread.Yield() then
         Thread.Sleep(1);
     end;
    end;

    class method SpinLockExit(var x: Integer);
    begin
      InternalCalls.VolatileWrite(var x, 0);
    end;

    [SkipDebug]
    class method SpinLockClassEnter(var x: NativeInt): Boolean;
    begin
      var cid := Thread.CurrentThreadID;

      var lValue := InternalCalls.CompareExchange(var x, cid, NativeInt(0)); // returns old

      if lValue = NativeInt(0) then exit true; // value was zero, we should run.
      if lValue = cid then exit false; // same thread, but already running, don't go again.
      if lValue = NativeInt(Int64(-1)) then exit false; // it's done in the mean time, we should exit.

      // At this point it's NOT the same thread, and not done loading yet;
      repeat
        if not Thread.&Yield() then
          Thread.Sleep(1);

        lValue := InternalCalls.VolatileRead(var x); // returns old
      until lValue = NativeInt(Int64(-1));
      exit false;
    end;

    [SkipDebug]
    class method SpinLockClassExit(var x: NativeInt);
    begin
      InternalCalls.VolatileWrite(var x, NativeInt(Int64(-1)));
    end;

    method CalcHash(const buf: ^Void; len: Integer): Integer;
    begin
      var pb:= ^Byte(buf);
      var r: UInt32:= $811C9DC5;
      for i:Integer := 0 to len-1 do begin
        r := (r xor pb^) * $01000193;
        inc(pb);
      end;
      exit ^Integer(@r)^;
    end;
  end;

  // Intrinsics
  InternalCalls = public static class
  public
    class method GetTypeInfo<T>(): ^Void; external;
    class method Cast(o: Object): ^Void; external;
    class method Cast<T>(o: ^Void): T; external;
    class method Undefined<T>: T; external;
    class method VoidAsm(aAsm: String; aConstraints: String; aSideEffects, aAlign: Boolean; params aArgs: array of Object); external;
    class method Asm(aAsm: String; aConstraints: String; aSideEffects, aAlign: Boolean; params aArgs: array of Object): NativeInt; external;

    class method VolatileRead(var address: Byte; aAtomic: Boolean := true): Byte; external;
    class method VolatileRead(var address: Double; aAtomic: Boolean := true): Double; external;
    class method VolatileRead(var address: Int16; aAtomic: Boolean := true): Int16; external;
    class method VolatileRead(var address: Int32; aAtomic: Boolean := true): Int32; external;
    class method VolatileRead(var address: Int64; aAtomic: Boolean := true): Int64; external;
    class method VolatileRead(var address: NativeInt; aAtomic: Boolean := true): NativeInt; external;
    class method VolatileRead(var address: Object; aAtomic: Boolean := true): Object; external;
    class method VolatileRead(var address: SByte; aAtomic: Boolean := true): SByte; external;
    class method VolatileRead(var address: Single; aAtomic: Boolean := true): Single; external;
    class method VolatileRead(var address: UInt16; aAtomic: Boolean := true): UInt16; external;
    class method VolatileRead(var address: UInt32; aAtomic: Boolean := true): UInt32; external;
    class method VolatileRead(var address: UInt64; aAtomic: Boolean := true): UInt64; external;
    class method VolatileRead(var address: NativeUInt; aAtomic: Boolean := true): NativeUInt; external;
    class method VolatileWrite(var address: Byte; value: Byte; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: Double; value: Double; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: Int16; value: Int16; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: Int32; value: Int32; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: Int64; value: Int64; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: NativeInt; value: NativeInt; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: Object; value: Object; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: SByte; value: SByte; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: Single; value: Single; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: UInt16; value: UInt16; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: UInt32; value: UInt32; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: UInt64; value: UInt64; aAtomic: Boolean := true); external;
    class method VolatileWrite(var address: NativeUInt; value: NativeUInt; aAtomic: Boolean := true); external;

    class method CompareExchange(var address: Int64; value, compare: Int64): Int64; external;
    class method CompareExchange(var address: Int32; value, compare: Int32): Int32; external;
    class method CompareExchange(var address: NativeInt; value, compare: NativeInt): NativeInt; external;
    class method CompareExchange(var address: UInt64; value, compare: UInt64): UInt64; external;
    class method CompareExchange(var address: UInt32; value, compare: UInt32): UInt32; external;
    class method CompareExchange(var address: NativeUInt; value, compare: NativeUInt): NativeUInt; external;
    class method CompareExchange<T>(var address: T; value, compare: T): T; external;

    class method Exchange(var address: Int64; value: Int64): Int64; external;
    class method Exchange(var address: Int32; value: Int32): Int32; external;
    class method Exchange(var address: NativeInt; value: NativeInt): NativeInt; external;
    class method Exchange(var address: UInt64; value: UInt64): UInt64; external;
    class method Exchange(var address: UInt32; value: UInt32): UInt32; external;
    class method Exchange(var address: NativeUInt; value: NativeUInt): NativeUInt; external;
    class method Exchange<T>(var address: T; value: T): T; external;

    class method Increment(var address: Int64): Int64; external;
    class method Increment(var address: Int32): Int32; external;

    class method Decrement(var address: Int64): Int64; external;
    class method Decrement(var address: Int32): Int32; external;

    class method &Add(var address: Int32; value: Int32): Int32; external;
    class method &Add(var address: Int64; value: Int64): Int64; external;
  end;

{$G+}
method GC_finalizer(obj, d: ^Void); assembly;
begin
  {$HIDE W25}
  InternalCalls.Cast<Object>(obj).Finalize;
  {$SHOW W25}
end;

method memcpy(destination: ^Void; source: ^Void; num: NativeInt): ^Void; public;inline;
begin 
  {$IFDEF WINDOWS}
  exit ExternalCalls.memcpy(destination, source, num);
  {$ELSE}
  exit rtl.memcpy(destination, source, num);
  {$ENDIF}
end;


method memmove(destination: ^Void; source: ^Void; num: NativeInt): ^Void; public;inline;
begin 
  {$IFDEF WINDOWS}
  exit ExternalCalls.memmove(destination, source, num);
  {$ELSE}
  exit rtl.memmove(destination, source, num);
  {$ENDIF}
end;

method memset (ptr: ^Void; value: Integer; num: NativeInt): ^Void; public; inline;
begin 
  {$IFDEF WINDOWS}
  exit ExternalCalls.memset(ptr, value, num);
  {$ELSE}
  exit rtl.memset(ptr, value, num);
  {$ENDIF}
end;

end.