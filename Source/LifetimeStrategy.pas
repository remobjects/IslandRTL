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
      try {$HIDE W58}
        InternalCalls.Cast<Object>(^Void(aObj)).Finalize;
        {$SHOW W58}
        free(^Void(aObj - sizeOf(IntPtr)));
      except 
      end;
    end;
    
  end;

end.