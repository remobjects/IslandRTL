namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  ObjcBlock = public record 
  private
  public
    &Self: ^Void := @_NSConcreteStackBlock;
    &Flags: UInt32 := $C2000000;
    Reserved: UInt32 := 0;
    Ptr: ^Void;
    Descriptor: ^ObjcBlockDescriptor := @DefaultBlockDescriptor;
    MData: Object;
  end;
  ObjcBlockDescriptor = public record 
  public 
    Reserved: IntPtr;
    Size: IntPtr;
    Copy: BlockCopyFunc;
    Dispose: BlockDisposeFunc;
  end;
  BlockCopyFunc = public method(Dest, Source: ^ObjcBlock);
  BlockDisposeFunc = public method(Dest: ^ObjcBlock);


method DefaultBlockDestroy(Dest: ^ObjcBlock);
begin 
  ForeignBoehmGC.Release(Dest^.MData);
end;

method DefaultBlockCopy(Dest, Source: ^ObjcBlock);
begin 
  Dest^.MData := Source.MData;
  ForeignBoehmGC.AddRef(Dest^.MData);
end;


var 
  [StaticallyInitializedField]
  DefaultBlockDescriptor: ObjcBlockDescriptor := new ObjcBlockDescriptor(
    Reserved := 0,
    Size := sizeOf(ObjcBlock),
    Copy := @DefaultBlockCopy,
    Dispose := @DefaultBlockDestroy
  ); readonly;
  
  
type
  ObjcStrong<T> = public lifetimestrategy (ObjcStrong) T;
  ObjcStrong = public record(ILifetimeStrategy<ObjcStrong>)
  assembly
    fInst: IntPtr;
  public
    [SymbolName("new_block_delegate")]
    class method NewBlockDelegate(aPtr: ^Void; aData: Object): IntPtr; // returns arp
    begin
      var lTmp := new ObjcBlock;
      lTmp.Ptr := aPtr;
      lTmp.MData := aData;
      exit objc_retainBlock(IntPtr(@lTmp));
    end;

    [SymbolName('objc_retainBlock')]
    class method objc_retainBlock(aVal: IntPtr): IntPtr; external;

    [SymbolName('objc_retain')]
    class method objc_retain(aVal: IntPtr): IntPtr; external;

    [SymbolName('objc_release')]
    class method objc_release(aVal: IntPtr); external;

    [SymbolName('objc_storeStrong')]
    class method objc_storeStrong(var aDest: IntPtr; aSrc: IntPtr); external;

    [SymbolName('objc_retainAutoreleaseReturnValue')]
    class method objc_retainAutoreleaseReturnValue(aVal: IntPtr): IntPtr; external;

    [SymbolName('objc_retainAutoreleasedReturnValue')]
    class method objc_retainAutoreleasedReturnValue(aVal: IntPtr): IntPtr; external;

    [SymbolName('objc_autoreleaseReturnValue')]
    class method objc_autoreleaseReturnValue(aVal: IntPtr): IntPtr; external;

    class method &New(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      var lTmp: unretained NSObject;
      lTmp := ^RemObjects.Oxygene.System.Class(@aTTY)^.alloc;
      exit ^^Void(@lTmp)^;
    end;


    constructor Copy(var aValue: ObjcWeak);
    begin
      fInst := ObjcWeak.objc_loadWeakRetained(aValue.fInst);
    end;

    class method Init(var Dest: ObjcStrong);
    begin
      Dest.fInst := 0;
    end;

    constructor Copy(var aValue: ObjcStrong);
    begin
      fInst := objc_retain(aValue.fInst);
    end;

    class method Copy(var aDest, aSource: ObjcStrong);
    begin
      aDest.fInst := objc_retain(aSource.fInst);
    end;

    class operator Assign(var aDest: ObjcStrong; var aSource: ObjcStrong);
    begin
      Assign(var aDest, var aSource);
    end;

    class method Assign(var aDest, aSource: ObjcStrong);
    begin
      objc_storeStrong(var aDest.fInst, aSource.fInst);
    end;

    class method Assign(var aDest: ObjcStrong; var aSource: ObjcWeak);
    begin
      var lTmp := ObjcWeak.objc_loadWeakRetained(aSource.fInst);
      objc_storeStrong(var aDest.fInst, lTmp);
      objc_release(lTmp);
    end;

    class method Release(var aDest: ObjcStrong);
    begin
      objc_storeStrong(var aDest.fInst, 0);
    end;

    class method ReturnValue(aValue: ObjcStrong): ObjcStrong;
    begin
      result.fInst := objc_retainAutoreleaseReturnValue(aValue.fInst);
    end;

    class method GetReturnValue(aValue: ObjcStrong): ObjcStrong;
    begin
      result.fInst := objc_retainAutoreleasedReturnValue(aValue.fInst);
    end;

    finalizer;
    begin
      Release(var self);
    end;
  end;


  ObjcWeak<T> = public lifetimestrategy (ObjcWeak) T;
  ObjcWeak = public record(ILifetimeStrategy<ObjcWeak>)
  assembly
    fInst: IntPtr;
  public
    [SymbolName('objc_initWeak')]
    class method objc_initWeak(var aVal: IntPtr; aIntVal: IntPtr); external;
    [SymbolName('objc_destroyWeak')]
    class method objc_destroyWeak(var aVal: IntPtr); external;

    [SymbolName('objc_copyWeak')]
    class method objc_copyWeak(var aDest: IntPtr; var aSrc: IntPtr); external;

    [SymbolName('objc_storeWeak')]
    class method objc_storeWeak(var aDest: IntPtr; aSrc: IntPtr); external;

    [SymbolName('objc_loadWeakRetained')]
    class method objc_loadWeakRetained(aVal: IntPtr): IntPtr; external;

    [SymbolName('objc_retainAutoreleasedReturnValue')]
    class method objc_retainAutoreleasedReturnValue(aVal: IntPtr): IntPtr; external;

    class method &New(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      var lTmp: unretained NSObject;
      lTmp := ^RemObjects.Oxygene.System.Class(@aTTY)^.alloc;
      exit ^^Void(@lTmp)^;
    end;

    class method Init(var Dest: ObjcWeak);
    begin
      objc_initWeak(var Dest.fInst, nil);
    end;

    constructor Copy(var aValue: ObjcWeak);
    begin
      var lTmp := objc_loadWeakRetained(aValue.fInst);
      objc_initWeak(var fInst, lTmp);
      ObjcStrong.objc_release(lTmp);
    end;

    constructor Copy(var aValue: ObjcStrong);
    begin
      objc_initWeak(var fInst, aValue.fInst);
    end;

    class method Copy(var aDest, aSource: ObjcWeak);
    begin
      var lTmp := objc_loadWeakRetained(aSource.fInst);
      objc_initWeak(var aDest.fInst, lTmp);
      ObjcStrong.objc_release(lTmp);
    end;

    class operator Assign(var aDest: ObjcWeak; var aSource: ObjcWeak);
    begin
      Assign(var aDest, var aSource);
    end;

    class operator Assign(var aDest: ObjcWeak; var aSource: ObjcStrong);
    begin
      Assign(var aDest, var aSource);
    end;

    class method Assign(var aDest, aSource: ObjcWeak);
    begin
      var lTmp := objc_loadWeakRetained(aSource.fInst);
      objc_storeWeak(var aDest.fInst, lTmp);
      ObjcStrong.objc_release(lTmp);
    end;

    class method Assign(var aDest: ObjcWeak; var aSource: ObjcStrong);
    begin
      objc_storeWeak(var aDest.fInst, aSource.fInst);
    end;

    class method Release(var aDest: ObjcWeak);
    begin
      objc_destroyWeak(var aDest.fInst);
    end;

    finalizer;
    begin
      Release(var self);
    end;
  end;

{$ENDIF}

end.