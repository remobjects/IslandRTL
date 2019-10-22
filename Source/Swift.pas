namespace RemObjects.Elements.System;

type
  SwiftStrong<T> = public lifetimestrategy (SwiftStrong) T;
  OnceCallback = public procedure(ctx: ^Void);
  SwiftInt = public IntPtr;
  SwiftStrong = public record(ILifetimeStrategy<SwiftStrong>)
  assembly
    fInst: IntPtr;
  public
    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_allocObject')]
    class method swift_allocObject(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;external;
    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_initStackObject')]
    class method swift_initStackObject(aMD: ^Void; aTarget: ^Void): ^Void;external;
    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_initStaticObject')]
    class method swift_initStaticObject(aMD: ^Void; aTarget: ^Void): ^Void;external;

    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_beginAccess')]
    class method swift_beginAccess(pointer: ^Void; buffer: ^Void; flags: UIntPtr; pc: ^Void);external;
    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_endAccess')]
    class method swift_endAccess(buffer: ^Void);external;

    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_once')]
    class method swift_once(once: ^Integer; cb: OnceCallback; ctx: ^Void);external;

    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_bridgeObjectRetain')]
    class method swift_bridgeObjectRetain(val: ^Void): ^Void; external;
    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_bridgeObjectRelease')]
    class method swift_bridgeObjectRelease(val: ^Void); external;

    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_retain')]
    class method swift_retain(val: IntPtr): IntPtr; external;
    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_release')]
    class method swift_release(val: IntPtr); external;

    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_deallocClassInstance')]
    class method swift_deallocClassInstance(val: ^Void; aAllocatedSize, aAllocatedAlignMask: IntPtr); external;

    [DllImport('libswiftCore.dylib', EntryPoint := 'swift_getInitializedObjCClass')]
    class method swift_getInitializedObjCClass(c: rtl.Class): rtl.Class; external;

    class method &New(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      exit swift_allocObject(aTTY, aSize, {$IFDEF CPU64}7{$ELSE}3{$ENDIF});
    end;

    class method Init(var Dest: SwiftStrong);
    begin
      Dest.fInst := 0;
    end;

    constructor Copy(var aValue: SwiftStrong);
    begin
      fInst := swift_retain(aValue.fInst);
    end;

    class method Copy(var aDest, aSource: SwiftStrong);
    begin
      aDest.fInst := swift_retain(aSource.fInst);
    end;

    class operator Assign(var aDest: SwiftStrong; var aSource: SwiftStrong);
    begin
      Assign(var aDest, var aSource);
    end;

    class method Assign(var aDest, aSource: SwiftStrong);
    begin
      if (@aDest) = (@aSource) then exit;
      var lNew := swift_retain(aSource.fInst);
      swift_release(aDest.fInst);
      aDest.fInst := lNew;
    end;


    class method Release(var aDest: SwiftStrong);
    begin
      var lVal := aDest.fInst;
      aDest.fInst := 0;
      swift_release(lVal);
    end;


    finalizer;
    begin
      Release(var self);
    end;
  end;

end.