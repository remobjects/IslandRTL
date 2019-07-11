namespace RemObjects.Elements.System;

type

  MAllocFunc nested in SharedMemory = function(size: {$IFDEF WINDOWS}{$IFDEF i386}UInt32{$ELSE}UInt64{$ENDIF}{$ELSE}rtl.size_t{$ENDIF}): ^Void;
  CollectFunc nested in SharedMemory = procedure;
  UnregisterFunc nested in SharedMemory = function: Integer;
  SetFinalizerFunc nested in SharedMemory = procedure(val: ^Void);
  AddRefProc nested in SharedMemory = procedure(o: ^Object);

  ILifetimeStrategy<T> = public interface
    class method &New(aTTY: ^Void; aSize: NativeInt): ^Void;
    class method Assign(var aDest, aSource: T); 
    class method Copy(var aDest, aSource: T); 
    class method Init(var Dest: T);
    class method Release(var Dest: T);
  end;

  SharedMemory = record
  public
    malloc: MAllocFunc;
    setfinalizer: SetFinalizerFunc;
    unsetfinalizer: SetFinalizerFunc;
    collect: CollectFunc;
    register: UnregisterFunc;
    unregister: UnregisterFunc;
    addref, release: AddRefProc;
  end;  
  
  Manual<T> = public lifetimestrategy (Manual) T;
  Manual = public record(ILifetimeStrategy<Manual>)
  private 
    fValue: IntPtr;
  public
    class method &New(aTTY: ^Void; aSize: IntPtr): ^Void;
    begin 
      result := ^Void(malloc(aSize));
      ^^Void(result)^ := aTTY;
      memset(^Byte(result) + sizeOf(^Void), 0, aSize - sizeOf(^Void));
    end;
    class method Assign(var aDest, aSource: Manual); 
    begin
      aDest := aSource;
    end;
    
    class method Copy(var aDest, aSource: Manual); 
    begin
      aDest := aSource;
    end;

    class method Init(var Dest: Manual); empty;
    class method Release(var Dest: Manual); empty;
    
    class method FreeObject(aObj: IntPtr); 
    begin 
      if aObj = 0 then exit;
      try {$HIDE W58}
        InternalCalls.Cast<Object>(^Void(aObj)).Finalize;
        {$SHOW W58}
        free(^Void(aObj));
      except 
      end;
    end;
    
  end;
  
  RC<T> = public lifetimestrategy (RC) T;
  RC = public record(ILifetimeStrategy<RC>)
  private 
    fValue: IntPtr;
  public
    class method &New(aTTY: ^Void; aSize: IntPtr): ^Void;
    begin 
      result := ^Void(malloc(aSize + sizeOf(^Void)));
      ^UIntPtr(result)^ := 1;
      result := result + sizeOf(^Void);
      ^^Void(result)^ := aTTY;
      memset(^Byte(result) + sizeOf(^Void), 0, aSize - sizeOf(^Void));
    end;
    
    class method Copy(var aDest, aSource: RC); 
    begin
      var lSrc := aSource.fValue;
      if lSrc = 0 then exit;
      InternalCalls.Increment(var ^IntPtr(lSrc)[-1]);
      aDest.fValue := lSrc;
    end;
    
    constructor Copy(var aSource: RC);
    begin
      var lSrc := aSource.fValue;
      if lSrc = 0 then exit;
      InternalCalls.Increment(var ^IntPtr(lSrc)[-1]);
      fValue := lSrc;
    end;
    
    class operator Assign(var aDest: RC; var aSource: RC);
    begin
      Assign(var aDest, var aSource);
    end;
    
    class method Assign(var aDest, aSource: RC); 
    begin
      if (@aDest) = (@aSource) then exit;
      var lInst := aSource.fValue;
      var lOld := InternalCalls.Exchange(var aDest.fValue, lInst);
      if lOld = lInst then exit;
      if lInst <> 0 then begin 
        InternalCalls.Increment(var ^IntPtr(lInst)[-1]);
      end;
      if lOld <> 0  then begin 
        if InternalCalls.Decrement(var ^IntPtr(lOld)[-1]) = 1 then  
          FreeObject(lOld);
      end;
    end;
    
    finalizer;
    begin
      var lValue := InternalCalls.Exchange(var fValue, 0);
      if lValue = 0 then exit;
      var p := InternalCalls.Decrement(var ^IntPtr(lValue)[-1]);
      if p = 1 then 
        FreeObject(lValue);    
    end;

    class method Init(var Dest: RC); empty;
    
    class method Release(var Dest: RC); 
    begin 
      var lValue := InternalCalls.Exchange(var Dest.fValue, 0);
      if lValue = 0 then exit;
      var p := InternalCalls.Decrement(var ^IntPtr(lValue)[-1]);
      if p = 1 then 
        FreeObject(p);
    end;
    
    class method FreeObject(aObj: IntPtr); private;
    begin 
      if aObj = 0 then exit;
      try {$HIDE W58}
        InternalCalls.Cast<Object>(^Void(aObj)).Finalize;
        {$SHOW W58}
        free(^Void(aObj - sizeOf(IntPtr)));
      except 
      end;
    end;
    
  end;

end.