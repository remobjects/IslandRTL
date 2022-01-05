namespace RemObjects.Elements.System;

[assembly: NamespaceAlias('System', ['RemObjects.Elements.System'])]

type
  DebugExceptionCallback = public procedure (data: ^Void; ex: IntPtr);
  DebugInvokeCallback = public procedure (data: ^Void);

  Utilities = public static class
  public

    [SymbolName('__island_debug_invoke'), Used, DllExport]
    method DebugInvoke(data: ^Void; invk: DebugInvokeCallback; ex: DebugExceptionCallback);
    begin
      try
        invk(data)
      except
        on e: Exception do
          ex(data, IntPtr(InternalCalls.Cast(e)));
      end;
    end;

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
          exit InternalCalls.Cast(aInstance);
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

    [SymbolName('__newnullrefexceptionex'), SkipDebug]
    class method CreateNullReferenceExceptionEx(s: String): Exception;
    begin
      exit new NullReferenceException(s);
    end;

    const FinalizerIndex = 4 + {$IFDEF I386 OR WEBASSEMBLY}4{$ELSE}2{$ENDIF};

    [SymbolName('__newdelegate')]
    //[SkipDebug]
    class method NewDelegate(aTY: ^Void; aSelf: Object; aPtr: ^Void): &Delegate;
    begin
      result := InternalCalls.Cast<&Delegate>(DefaultGC.New(aTY, sizeOf(^Void) * 3));
      result.fSelf := aSelf;
      result.fPtr := aPtr;
    end;

    [SymbolName('__newarray')]
    //[SkipDebug]
    class method NewArray(aTY: ^Void; aElementSize, aElements: NativeInt): ^Void;
    begin
      result := DefaultGC.New(aTY, sizeOf(^Void) + sizeOf(NativeInt) + aElementSize * aElements);
      (@InternalCalls.Cast<&Array>(result).fLength)^ := aElements;
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

    [SymbolName('ElementsObjectToString'), Used , DllExport]
    class method GetObjectToString(aObj: Object): ^WideChar;
    begin
      if aObj = nil then exit nil;
      var s := aObj:ToString():ToCharArray(true);
      exit @s[0];
    end;

    {$IFDEF DARWIN}
    [SymbolName('CocoaObjectToString'), Used]
    class method GetCocoaObjectToString(aObj: Foundation.NSObject): ^WideChar;
    begin
      if aObj = nil then exit nil;
      var s: array of Char;
      if aObj is Foundation.NSString then s := String(Foundation.NSString(aObj)):ToCharArray(true)
      else s := String(aObj:debugDescription()):ToCharArray(true);
      exit @s[0];
    end;
    {$ENDIF}

    class method SpinLockEnter(var x: Integer);
    begin
    {$IFDEF NOTHREADS}
    InternalCalls.Exchange(var x, 1);
    {$ELSE}
     loop begin
       if InternalCalls.Exchange(var x, 1) = 0 then exit;
       if not Thread.Yield() then
         Thread.Sleep(1);
     end;
    {$ENDIF}
    end;

    class method SpinLockExit(var x: Integer);
    begin
      InternalCalls.VolatileWrite(var x, 0);
    end;

    [SkipDebug]
    class method SpinLockClassEnter(var x: NativeInt): Boolean;
    begin
      {$IFDEF NOTHREADS}
      exit InternalCalls.Exchange(var x, 1) = 0;
      {$ELSE}
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
      {$ENDIF}
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

    class var __fRegisterThread: LinkedListNode<Action>;
    class var __fUnregisterThread: LinkedListNode<Action>;

    method RegisterThreadHandlers(aRegister, aUnregister: Action);
    begin
      loop begin
        var lNew := new LinkedListNode<Action>(aRegister, __fRegisterThread);
        if InternalCalls.CompareExchange(var __fRegisterThread, lNew, lNew.Previous) = lNew.Previous then break;
      end;
      loop begin
        var lNew := new LinkedListNode<Action>(aUnregister, __fUnregisterThread);
        if InternalCalls.CompareExchange(var __fUnregisterThread, lNew, lNew.Previous) = lNew.Previous then break;
      end;
    end;

    [SymbolName('registerthread')]
    method RegisterThread;
    begin
      var lT := __fRegisterThread;
      while lT <> nil do begin
        lT.Value();
        lT := lT.Previous;
      end;
    end;

    [SymbolName('unregisterthread')]
    method UnregisterThread;
    begin
      var lT := __fUnregisterThread;
      while lT <> nil do begin
        lT.Value();
        lT := lT.Previous;
      end;
    end;

  end;

  // Intrinsics
  InternalCalls = public static class
  public
    {$IFDEF WINDOWS}
    // Read the FS register at offset N
    class method ReadFS8(off: NativeInt): Byte; external;
    class method ReadFS16(off: NativeInt): Word; external;
    class method ReadFS32(off: NativeInt): UInt32; external;
    class method ReadFS64(off: NativeInt): UInt64; external;
    // read the GS register at offset N
    class method ReadGS8(off: NativeInt): Byte; external;
    class method ReadGS16(off: NativeInt): Word; external;
    class method ReadGS32(off: NativeInt): UInt32; external;
    class method ReadGS64(off: NativeInt): UInt64; external;
    {$ENDIF}
    // Returns the raw typeinfo for T
    class method GetTypeInfo<T>(): ^Void; external;
    class method GetIslandTypeInfo<T>(): ^Void; external;
    {$IFDEF DARWIN}
    class method GetSwiftTypeInfo<T>(): ^Void; external;
    {$ENDIF}
    // Casts an object to ^Void and back. Doesn't do any error checking!
    class method Cast(o: Object): ^Void; external;
    class method Cast(o: Manual<Object>): ^Void; external;
    class method Cast<T>(o: ^Void): T; external;

    // Optimizer tool: Returns an undefined value of type T
    class method Undefined<T>: T; external;

    class method GuidOf<T>: Guid; external;

    // Low level; allocates stack space; **do not use in iterator/async methods**
    class method Alloca(aSize: Integer): ^Byte; external;

    // Inline asm
    class method VoidAsm(aAsm: String; aConstraints: String; aSideEffects, aAlign: Boolean; params aArgs: array of Object); external;
    class method Asm(aAsm: String; aConstraints: String; aSideEffects, aAlign: Boolean; params aArgs: array of Object): NativeInt; external;

    // Volatile read; if atomic it inserts an atomic (lock on x86) instruction.
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
    // Volatile write; if atomic it inserts an atomic (lock on x86) instruction.
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

    // Exchanges the value at address with value if it's compare, returns the old value.
    class method CompareExchange(var address: Int64; value, compare: Int64): Int64; external;
    class method CompareExchange(var address: Int32; value, compare: Int32): Int32; external;
    class method CompareExchange(var address: NativeInt; value, compare: NativeInt): NativeInt; external;
    class method CompareExchange(var address: UInt64; value, compare: UInt64): UInt64; external;
    class method CompareExchange(var address: UInt32; value, compare: UInt32): UInt32; external;
    class method CompareExchange(var address: NativeUInt; value, compare: NativeUInt): NativeUInt; external;
    class method CompareExchange<T>(var address: T; value, compare: T): T; external;

    // Exchanges the value at address with value, returns the old value.
    class method Exchange(var address: Int64; value: Int64): Int64; external;
    class method Exchange(var address: Int32; value: Int32): Int32; external;
    class method Exchange(var address: NativeInt; value: NativeInt): NativeInt; external;
    class method Exchange(var address: UInt64; value: UInt64): UInt64; external;
    class method Exchange(var address: UInt32; value: UInt32): UInt32; external;
    class method Exchange(var address: NativeUInt; value: NativeUInt): NativeUInt; external;
    class method Exchange<T>(var address: T; value: T): T; external;

    // Adds 1 to the value at address, returns the old one.
    class method Increment(var address: Int64): Int64; external;
    class method Increment(var address: Int32): Int32; external;
    class method Increment(var address: IntPtr): IntPtr; external;

    // Subtracts 1 to the value at address, returns the old one.
    class method Decrement(var address: Int64): Int64; external;
    class method Decrement(var address: Int32): Int32; external;
    class method Decrement(var address: IntPtr): IntPtr; external;

    // Adds value to the value at address, returns the old one.
    class method &Add(var address: Int32; value: Int32): Int32; external;
    class method &Add(var address: Int64; value: Int64): Int64; external;
    class method &Add(var address: NativeInt; value: NativeInt): NativeInt; external;
    class method &Add(var address: NativeUInt; value: NativeUInt): NativeUInt; external;

    class method &Or(var address: Int32; value: Int32): Int32; external;
    class method &Or(var address: Int64; value: Int64): Int64; external;
    class method &Or(var address: NativeInt; value: NativeInt): NativeInt; external;
    class method &Or(var address: NativeUInt; value: NativeUInt): NativeUInt; external;

    class method &And(var address: Int32; value: Int32): Int32; external;
    class method &And(var address: Int64; value: Int64): Int64; external;
    class method &And(var address: NativeInt; value: NativeInt): NativeInt; external;
    class method &And(var address: NativeUInt; value: NativeUInt): NativeUInt; external;

    class method &Xor(var address: Int32; value: Int32): Int32; external;
    class method &Xor(var address: Int64; value: Int64): Int64; external;
    class method &Xor(var address: NativeInt; value: NativeInt): NativeInt; external;
    class method &Xor(var address: NativeUInt; value: NativeUInt): NativeUInt; external;
  end;

method interlockedInc(var x: Integer; increment: Integer := 1): Integer;  inline; public;
begin
  exit InternalCalls.Add(var x, increment);
end;

method interlockedInc(var x: Int64; increment: Int64 := 1): Int64;  inline; public;
begin
  exit InternalCalls.Add(var x, increment);
end;

method interlockedInc(var x: IntPtr; increment: IntPtr := 1): IntPtr;  inline; public;
begin
  exit InternalCalls.Add(var x, increment);
end;

method interlockedDec(var x: Integer; increment: Integer := 1): Integer;  inline; public;
begin
  exit InternalCalls.Add(var x, - increment);
end;


method interlockedDec(var x: Int64; increment: Int64 := 1): Int64;  inline; public;
begin
  exit InternalCalls.Add(var x, - increment);
end;

method interlockedDec(var x: IntPtr; increment: IntPtr := 1): IntPtr;  inline; public;
begin
  exit InternalCalls.Add(var x, 0 - increment);
end;

method interlockedCompareExchange(var x: Integer; compareTo, newValue: Integer): Integer; inline; public;
begin
  exit InternalCalls.CompareExchange(var x, newValue, compareTo);
end;

method interlockedCompareExchange(var x: Integer; compareTo, newValue: Int64): Int64; inline; public;
begin
  exit InternalCalls.CompareExchange(var x, newValue, compareTo);
end;

method interlockedCompareExchange(var x: Integer; compareTo, newValue: IntPtr): IntPtr; inline; public;
begin
  exit InternalCalls.CompareExchange(var x, newValue, compareTo);
end;

{$G+}
method GC_finalizer(obj, d: ^Void); assembly;
begin
  {$HIDE W25}
  {$HIDE W58}
  InternalCalls.Cast<Object>(obj).Finalize;
  {$SHOW W25}
  {$SHOW W58}
end;

method memcpy(destination: ^Void; source: ^Void; num: NativeInt): ^Void; public;inline;
begin
  {$IFDEF WINDOWS OR WEBASSEMBLY}
  exit ExternalCalls.memcpy(destination, source, num);
  {$ELSE}
  exit rtl.memcpy(destination, source, num);
  {$ENDIF}
end;

method memcmp(a: ^Void; b: ^Void; num: NativeInt): Integer; public;inline;
begin
  {$IFDEF WINDOWS OR WEBASSEMBLY}
  exit ExternalCalls.memcmp(^Byte(a), ^Byte(b), num);
  {$ELSE}
  exit rtl.memcmp(a, b, num);
  {$ENDIF}
end;

method memmove(destination: ^Void; source: ^Void; num: NativeInt): ^Void; public;inline;
begin
  {$IFDEF WINDOWS OR WEBASSEMBLY}
  exit ExternalCalls.memmove(destination, source, num);
  {$ELSE}
  exit rtl.memmove(destination, source, num);
  {$ENDIF}
end;

method memset (ptr: ^Void; value: Integer; num: NativeInt): ^Void; public; inline;
begin
  {$IFDEF WINDOWS OR WEBASSEMBLY}
  exit ExternalCalls.memset(ptr, value, num);
  {$ELSE}
  exit rtl.memset(ptr, value, num);
  {$ENDIF}
end;

operator Pow(a, b: Double): Double; public;
begin
  exit Math.Pow(a,b);
end;

operator Pow(a, b: Int64): Int64; public;
begin
  result := 1;
  if b < 0 then exit 0;
  while b <> 0 do begin
    if (b and 1) <> 0 then result := result * a;
    a := a * a;
    b := b shr 1;
  end;
end;

operator Pow(a, b: Integer): Integer; public;
begin
  result := 1;
  if b < 0 then exit 0;
  while b <> 0 do begin
    if (b and 1) <> 0 then result := result * a;
    a := a * a;
    b := b shr 1;
  end;
end;

end.