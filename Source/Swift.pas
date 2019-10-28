namespace RemObjects.Elements.System;

type
  SwiftStrong<T> = public lifetimestrategy (SwiftStrong) T;
  OnceCallback = public procedure(ctx: ^Void);
  SwiftInt = public IntPtr;
  SwiftIntPtrApi = public function(i: IntPtr): IntPtr;
  SwiftAllocApi = public function(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;
  SwiftInitApi = public function(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;
  SwiftBeginAccessApi = public procedure(pointer: ^Void; buffer: ^Void; flags: UIntPtr; pc: ^Void);

  SwiftType = public record
  public
    &Type: IntPtr;
  end;

  SwiftRefcounted = public record
  public
    &Type: ^SwiftType;
    RefCount: IntPtr;
  end;

  SwiftBlock = public record
  public
    &Self: SwiftRefcounted;
    Obj: Object;
  end;

  SwiftReflectionDeclarator = public record
  public
    a,
    b,
    c,
    d: Integer;
  end;

  SwiftDestructor = public procedure (aRef: ^SwiftRefcounted);

  SwiftReflectionMetadata = public record
  public
    Destructor: SwiftDestructor;
    Witness: ^^Byte;
    &Type: IntPtr;
    StartOfFirstField: Int32;
    Descriptor: ^SwiftReflectionDeclarator;
  end;

  SwiftStrong = public record(ILifetimeStrategy<SwiftStrong>)
  assembly
    fInst: IntPtr;
  public

    [SymbolName("new_swift_block_delegate")]
    class method NewBlockDelegate(aPtr: ^Void; aData: Object): IntPtr; // returns arp
    begin
      var lTmp := new ObjcBlock;
      result := IntPtr(swift_allocObject(^Void(@SwiftBlockData.Type), sizeOf(^Void) * 3, {$IFDEF CPU64}7{$ELSE}3{$ENDIF}));
      ForeignBoehmGC.Assign(var ^ForeignBoehmGC(@^SwiftBlock(result)^. Obj)^,
                            var ^ForeignBoehmGC(@aData)^);
    end;

    class constructor;
    begin


      var lDLL := rtl.dlopen('libswiftCore.dylib', 0);
      if lDLL = nil then raise new Exception('libswiftCore.dylib not present!');

      swift_getInitializedObjCClass := SwiftIntPtrApi(rtl.dlsym(lDLL, 'swift_getInitializedObjCClass'));
      swift_endAccess := SwiftIntPtrApi(rtl.dlsym(lDLL, 'swift_endAccess'));
      swift_bridgeObjectRetain := SwiftIntPtrApi(rtl.dlsym(lDLL, 'swift_bridgeObjectRetain'));
      swift_bridgeObjectRelease :=SwiftIntPtrApi( rtl.dlsym(lDLL, 'swift_bridgeObjectRelease'));
      swift_retain := SwiftIntPtrApi(rtl.dlsym(lDLL, 'swift_retain'));
      swift_release := SwiftIntPtrApi(rtl.dlsym(lDLL, 'swift_release'));
      swift_allocObject := SwiftAllocApi(rtl.dlsym(lDLL, 'swift_allocObject'));
      swift_deallocClassInstance := SwiftAllocApi(rtl.dlsym(lDLL, 'swift_deallocClassInstance'));
      swift_initStackObject := SwiftInitApi(rtl.dlsym(lDLL, 'swift_initStackObject'));
      swift_initStaticObject := SwiftInitApi(rtl.dlsym(lDLL, 'swift_initStaticObject'));
      swift_beginAccess := SwiftBeginAccessApi(rtl.dlsym(lDLL, 'swift_beginAccess'));
    end;

    class var swift_getInitializedObjCClass: SwiftIntPtrApi;
    class var swift_endAccess: SwiftIntPtrApi;
    class var swift_bridgeObjectRetain: SwiftIntPtrApi;
    class var swift_bridgeObjectRelease: SwiftIntPtrApi;
    class var swift_retain: SwiftIntPtrApi;
    class var swift_release: SwiftIntPtrApi;
    class var swift_allocObject: SwiftAllocApi;
    class var swift_deallocClassInstance: SwiftAllocApi;
    class var swift_initStackObject: SwiftInitApi;
    class var swift_initStaticObject: SwiftInitApi;
    class var swift_beginAccess: SwiftBeginAccessApi;


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


  method DefaultSwiftBlockDestroy(Dest: ^SwiftRefcounted);
  begin
    ForeignBoehmGC.Release(^SwiftBlock(Dest)^.Obj);
  end;

  [SymbolName('symbolic SPySiG'), LinkOnceAttribute, StaticallyInitializedFieldAttribute, SectionName('__TEXT,__swift5_typeref, regular, no_dead_strip')] // symbolic SPySiG
  var PtrToIntType: array[0..6] of AnsiChar := ['S','P','y','S','i','G',#0]; readonly;
  [SectionName('__TEXT,__swift5_capture, regular, no_dead_strip'), StaticallyInitializedFieldAttribute]
  var SwiftBlockDataRecl: SwiftReflectionDeclarator := new SwiftReflectionDeclarator(a := 1, d := Int64(@PtrToIntType) - Int64(@SwiftBlockDataRecl.d)); readonly;
  [StaticallyInitializedFieldAttribute]
  var SwiftBlockData: SwiftReflectionMetadata := new SwiftReflectionMetadata(
    Destructor := @DefaultSwiftBlockDestroy,
    Witness := nil,
    &Type := 1024,
    StartOfFirstField := {$IFDEF CPU64}16{$ELSE}8{$ENDIF},
    Descriptor:= @SwiftBlockDataRecl
  ); readonly;

end.