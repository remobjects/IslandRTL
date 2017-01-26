namespace RemObjects.Elements.System;

type
  Utilities = public static class
  private
    class var fFinalizer: ^Void;
    class var fLoaded: Integer;
  public
    [SymbolName('__abstract')]
    class method AbstractCall;
    begin
      raise new AbstractMethodException;
    end;

    [SymbolName('__isinst')]
    class method IsInstance(aInstance: Object; aType: ^Void): Object;
    begin
      if aInstance = nil then exit nil;
      var lTTY := ^^IslandTypeInfo(InternalCalls.Cast(aInstance))^;
      loop begin
        if lTTY = ^IslandTypeInfo(aType) then exit aInstance;
        lTTY := lTTY^.ParentType;
        if lTTY = nil then exit nil;
      end;
    end;

    [SymbolName('__isintfinst')]
    class method IsInterfaceInstance(aInstance: Object; aType: ^Void; aHashCode: Cardinal): ^Void;
    begin
      if aInstance =nil then exit nil;
      var lIntf := ^^IslandTypeInfo(InternalCalls.Cast(aInstance))^^.InterfaceType;
      if lIntf = nil then exit nil;
      aHashCode := aHashCode mod lIntf^.HashTableSize;
      var lHashEntry := (@lIntf^.FirstEntry)[aHashCode];
      if lHashEntry = nil then exit nil;
      repeat
        if lHashEntry^ = aType then
          exit aType;
        inc(lHashEntry);
      until lHashEntry^ = nil;
      exit nil;
    end;

    [SymbolName('__newinvalidcast')]
    class method CreateInvalidCastException: Exception;
    begin
      exit new InvalidCastException('Invalid cast');
    end;

    [SymbolName('__newdividebyzero')]
    class method CreateDivideByZeroException: Exception;
    begin
      exit new DivideByZeroException;
    end;

    [SymbolName('__newnullrefexception')]
    class method CreateNullReferenceException: Exception;
    begin
      exit new NullReferenceException;
    end;

    [SymbolName('__newinst')]
    class method NewInstance(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      if fFinalizer = nil then begin
        fFinalizer := ^^Void(InternalCalls.GetTypeInfo<Object>())[4];
      end;

      if fLoaded = 0 then
        if InternalCalls.CompareExchange(var fLoaded, 1, 0 ) <> 1 then begin
          gc.GC_INIT;
          result := ^Void(-1);
        end;

      result := gc.GC_malloc(aSize);
      ^^Void(result)^ := aTTY;
      {$IFDEF WINDOWS}ExternalCalls.{$ELSE}rtl.{$ENDIF}memset(^Byte(result) + sizeOf(^Void), 0, aSize - sizeOf(^Void));
      if ^^Void(aTTY)[4] <> fFinalizer then begin
        gc.GC_register_finalizer_no_order(result, @GC_finalizer, nil, nil, nil);
      end;
    end;

    [SymbolName('__newarray')]
    class method NewArray(aTY: ^Void; aElementSize, aElements: NativeInt): ^Void;
    begin
      result := NewInstance(aTY, sizeOf(^Void) + sizeOf(NativeInt) + aElementSize * aElements);
      (@InternalCalls.Cast<&Array>(result).fLength)^ := aElements;
    end;

    [SymbolName('__newdelegate')]
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

    class method SuppressFinalize(o: Object);
    begin
      if o <> nil then
        GC.GC_register_finalizer_no_order(InternalCalls.Cast(o), nil, nil, nil, nil);
    end;

    class method Collect(c: Integer);
    begin
      for i: Integer := 0 to c -1 do
        GC.GC_gcollect();
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

    class method VolatileRead(var address: Byte): Byte; external;
    class method VolatileRead(var address: Double): Double; external;
    class method VolatileRead(var address: Int16): Int16; external;
    class method VolatileRead(var address: Int32): Int32; external;
    class method VolatileRead(var address: Int64): Int64; external;
    class method VolatileRead(var address: NativeInt): NativeInt; external;
    class method VolatileRead(var address: Object): Object; external;
    class method VolatileRead(var address: SByte): SByte; external;
    class method VolatileRead(var address: Single): Single; external;
    class method VolatileRead(var address: UInt16): UInt16; external;
    class method VolatileRead(var address: UInt32): UInt32; external;
    class method VolatileRead(var address: UInt64): UInt64; external;
    class method VolatileRead(var address: NativeUInt): NativeUInt; external;
    class method VolatileWrite(var address: Byte; value: Byte); external;
    class method VolatileWrite(var address: Double; value: Double); external;
    class method VolatileWrite(var address: Int16; value: Int16); external;
    class method VolatileWrite(var address: Int32; value: Int32); external;
    class method VolatileWrite(var address: Int64; value: Int64); external;
    class method VolatileWrite(var address: NativeInt; value: NativeInt); external;
    class method VolatileWrite(var address: Object; value: Object); external;
    class method VolatileWrite(var address: SByte; value: SByte); external;
    class method VolatileWrite(var address: Single; value: Single); external;
    class method VolatileWrite(var address: UInt16; value: UInt16); external;
    class method VolatileWrite(var address: UInt32; value: UInt32); external;
    class method VolatileWrite(var address: UInt64; value: UInt64); external;
    class method VolatileWrite(var address: NativeUInt; value: NativeUInt); external;

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
  InternalCalls.Cast<Object>(obj).Finalize;
end;

end.
