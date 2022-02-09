namespace RemObjects.Elements.System;

type
  SwiftStrong<T> = public lifetimestrategy (SwiftStrong) T;
  OnceCallback = public procedure(ctx: ^Void);
  SwiftInt = public IntPtr;
  SwiftIntPtrApi = public function(i: IntPtr): IntPtr;
  SwiftAllocApi = public function(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;
  SwiftInitApi = public function(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;
  SwiftBeginAccessApi = public procedure(pointer: ^Void; buffer: ^Void; flags: UIntPtr; pc: ^Void);
  extern_proc = public record
  public
  end;


  _SwiftDictionaryBodyStorage = public record
  public
     count: IntPtr;
     capacity: IntPtr;
    _scale: Byte;
    _reservedScale: Byte;
     extra: Int16;
     age: Int32;
     seed: IntPtr;
    rawKeys: ^Void;
    rawValues: ^Void;
  end;

  _SwiftSetBodyStorage = public record
  public
     count: IntPtr;
     capacity: IntPtr;
      scale: Byte;
      reservedScale: Byte;
     extra: Int16;
     age: Int32;
     seed: IntPtr;
    rawElements:^Void;
  end;

  _SwiftEmptyDictionarySingleton = public record
  public
    header: SwiftRefcounted;
    body: _SwiftDictionaryBodyStorage;
    metadata: UIntPtr;
  end;

  _SwiftEmptySetSingleton = public record
  public
    header: SwiftRefcounted;
    body: _SwiftSetBodyStorage;
    metadata: UIntPtr;
  end;

  SwiftTypeRecord = public record
  public
    //&Type: IntPtr;

    property VWT: ^SwiftValueWitnessTable read ^^SwiftValueWitnessTable(@self)[-1];
  end;

  SwiftRefcounted = public record
  public
    &Type: ^SwiftTypeRecord;
    RefCount: IntPtr;
  end;

  SwiftBlock = public record
  public
    &Self: SwiftRefcounted;
    Obj: Object;
  end;

  SwiftBlockPtr = public record
  public
    &Method: IntPtr;
    Obj: ^SwiftBlock;
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

  // swift protocol WITHOUT any AnyObject constraint
  SwiftProtocol = public record
  public
    Data: array[0..23] of Byte;
    &Type: ^SwiftTypeRecord;
    WitnessTable: ^^Byte;
  end;


  // This affects the marshalling logic
  [AttributeUsage(AttributeTargets.Struct or AttributeTargets.Class)]
  SwiftFixedLayoutAttribute = public class(Attribute)
  public
  end;

  // Swift protocol WITH an AnyObject constraint
  SwiftClassProtocol = public record
  public
    Instance: ^SwiftRefcounted;
    WitnessTable: ^^Byte;
  end;

  SwiftVWTinitializeBufferWithCopyOfBuffer = public function(dest, src: IntPtr; aSelf: ^SwiftTypeRecord): IntPtr;
  SwiftVWTdestroy = public procedure(obj: IntPtr; aSelf: ^SwiftTypeRecord);
  SwiftVWTgetEnumTagSinglePayload = public function(anEnum: IntPtr; emptyCases: UInt32): UInt32;
  SwiftVWTstoreEnumTagSinglePayload = public procedure(anEnum: IntPtr; whichCase, emptyCases: UInt32);
  SwiftVWTgetEnumTag = public function(obj: IntPtr; aSelf: ^SwiftTypeRecord): UInt32;
  SwiftVWTdestructiveProjectEnumData = public procedure(obj: IntPtr; aSelf: ^SwiftTypeRecord);
  SwiftVWTdestructiveInjectEnumTag = public procedure(obj: IntPtr; tag: UInt32; aSelf: ^SwiftTypeRecord);

  SwiftValueWitnessTable = public record
  public
    // Given an invalid buffer, initialize it as a copy of the
    // object in the source buffer.
    initializeBufferWithCopyOfBuffer: SwiftVWTinitializeBufferWithCopyOfBuffer;
    // Given a valid object of this type, destroy it, leaving it as an
    // invalid object.  This is useful when generically destroying
    // an object which has been allocated in-line, such as an array,
    // struct, or tuple element.
    destroy: SwiftVWTdestroy;
    // Given an invalid object of this type, initialize it as a copy of
    // the source object.  Returns the dest object.
    initializeWithCopy: SwiftVWTinitializeBufferWithCopyOfBuffer;
    // Given a valid object of this type, change it to be a copy of the
    // source object.  Returns the dest object.
    assignWithCopy: SwiftVWTinitializeBufferWithCopyOfBuffer; // 3
    // Given an invalid object of this type, initialize it by taking
    // the value of the source object.  The source object becomes
    // invalid.  Returns the dest object.
    initializeWithTake: SwiftVWTinitializeBufferWithCopyOfBuffer;
    // Given a valid object of this type, change it to be a copy of the
    // source object.  The source object becomes invalid.  Returns the
    // dest object.
    assignWithTake: SwiftVWTinitializeBufferWithCopyOfBuffer;
    // unsigned (*getEnumTagSinglePayload)(const T* enum, UINT_TYPE emptyCases)
    // Given an instance of valid single payload enum with a payload of this
    // witness table's type (e.g Optional<ThisType>) , get the tag of the enum.
    getEnumTagSinglePayload: SwiftVWTgetEnumTagSinglePayload;
    // Given uninitialized memory for an instance of a single payload enum with a
    // payload of this witness table's type (e.g Optional<ThisType>), store the
    // tag.
    storeEnumTagSinglePayload: SwiftVWTstoreEnumTagSinglePayload;
    // The required storage size of a single object of this type.
    size: IntPtr;
    // The required size per element of an array of this type. It is at least
    // one, even for zero-sized types, like the empty tuple.
    stride: IntPtr;
    // The ValueWitnessAlignmentMask bits represent the required
    // alignment of the first byte of an object of this type, expressed
    // as a mask of the low bits that must not be set in the pointer.
    // This representation can be easily converted to the 'alignof'
    // result by merely adding 1, but it is more directly useful for
    // performing dynamic structure layouts, and it grants an
    // additional bit of precision in a compact field without needing
    // to switch to an exponent representation.
    //
    // The ValueWitnessIsNonPOD bit is set if the type is not POD.
    //
    // The ValueWitnessIsNonInline bit is set if the type cannot be
    // represented in a fixed-size buffer or if it is not bitwise takable.
    //
    // The ExtraInhabitantsMask bits represent the number of "extra inhabitants"
    // of the bit representation of the value that do not form valid values of
    // the type.
    //
    // The Enum_HasSpareBits bit is set if the type's binary representation
    // has unused bits.
    //
    // The HasEnumWitnesses bit is set if the type is an enum type.
    &flags: Int32;
    // The number of extra inhabitants in the type.
    ExtraInhabitantCount: Int32;
    // The following are for ENUMS only:


    /// Given a valid object of this enum type, extracts the tag value indicating
    /// which case of the enum is inhabited. Returned values are in the range
    /// [0..NumElements-1].
    getenumTag: SwiftVWTgetEnumTag;
    ///   void (*destructiveProjectEnumData)(T *obj, M *self);
    /// Given a valid object of this enum type, destructively extracts the
    /// associated payload.
    destructiveProjectEnumData: SwiftVWTdestructiveProjectEnumData;
    /// Given an enum case tag and a valid object of case's payload type,
    /// destructively inserts the tag into the payload. The given tag value
    /// must be in the range [-ElementsWithPayload..ElementsWithNoPayload-1].
    destructiveInjectEnumTag: SwiftVWTdestructiveInjectEnumTag;

    // flags:
    const
      TagAlignmentMask =    $000000FF;
      IsNonPOD =            $00010000;
      IsNonInline =         $00020000;

      HasSpareBits =        $00080000;
      IsNonBitwiseTakable = $00100000;
      HasEnumWitnesses =    $00200000;
      Incomplete =          $00400000;
  end;

  SwiftStructStrong = public record
  public
    class method Initialize(aDest: ^Void; aType: ^SwiftTypeRecord);
    begin
      memset(aDest, 0, aType^.VWT^.size);
    end;

    class method Finalize(aDest: ^Void; aType: ^SwiftTypeRecord);
    begin
      aType^.VWT^.destroy(IntPtr(aDest), aType);
    end;

    class method Assign(aDest, aSource: ^Void; aType: ^SwiftTypeRecord);
    begin
      aType^.VWT^.assignWithCopy(IntPtr(aDest), IntPtr(aSource), aType);
    end;

    class method InitializeWith(aDest, aSource: ^Void; aType: ^SwiftTypeRecord);
    begin
      aType^.VWT^.initializeWithCopy(IntPtr(aDest), IntPtr(aSource), aType);
    end;
  end;

  SwiftStrong = public record(ILifetimeStrategy<SwiftStrong>)
  assembly
    fInst: IntPtr;
  public
    class method CopyProtocol(var aDest, aSource: SwiftProtocol; aReleaseOld: Boolean);
    begin
      if (@aDest) = (@aSource) then exit; // don't copy to ourselves.
      if aSource.WitnessTable = nil then begin
        // Source is empty
        if aReleaseOld and (aDest.Type <> nil) then begin
          var lVWT := ^SwiftValueWitnessTable(@aDest.Type[-1]);
          if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
            swift_release(IntPtr(^^SwiftRefcounted(@aDest.Data)^));
          end else begin
            lVWT^.destroy(IntPtr(@aDest.Data), aDest.Type);
          end;

        end;

        aDest.Type := nil;
        aDest.WitnessTable := nil;
        exit;
      end;

      if aReleaseOld and (aDest.Type <> nil) then begin
        var lVWT := ^SwiftValueWitnessTable(@aDest.Type[-1]);
        if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
          swift_release(IntPtr(^^SwiftRefcounted(@aDest.Data)^));
        end else begin
          lVWT^.destroy(IntPtr(@aDest.Data), aDest.Type);
        end;
      end;
      var lVWT := ^SwiftValueWitnessTable(@aSource.Type[-1]);
      lVWT^.initializeBufferWithCopyOfBuffer(IntPtr(@aDest.Data), IntPtr(@aSource.Data), aSource.Type);

      aDest.Type := aSource.Type;
      aDest.WitnessTable := aSource.WitnessTable;
    end;

    class method AdjustProtocolSelf(var aDest: SwiftProtocol): ^SwiftRefcounted;
    begin
      var lVWT := ^SwiftValueWitnessTable(@aDest.Type[-1]);
      if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
        // It's inline; so we can use the value at aDest
        exit ^SwiftRefcounted(@aDest.Data);
      end;
      var lAlign := lVWT^.flags and SwiftValueWitnessTable.TagAlignmentMask;
      exit ^SwiftRefcounted(@aDest.Data[(lAlign + 16) and (not lAlign)]);
    end;

    class method ReleaseProtocol(var aDest: SwiftProtocol);
    begin
      if (aDest.Type <> nil) then begin
        var lVWT := ^SwiftValueWitnessTable(@aDest.Type[-1]);
        if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
          swift_release(IntPtr(^^SwiftRefcounted(@aDest.Data)^));
        end else begin
          lVWT^.destroy(IntPtr(@aDest.Data), aDest.Type);
        end;
      end;
      aDest.Type := nil;
      aDest.WitnessTable := nil;
    end;

    class method CopyClassProtocol(var aDest, aSource: SwiftClassProtocol; aReleaseOld: Boolean);
    begin
      if (@aDest) = (@aSource) then exit;
      var lNew := swift_retain(IntPtr(aSource.Instance));
      if aReleaseOld then
        swift_release(IntPtr(aDest.Instance));
      aDest.Instance := ^SwiftRefcounted(lNew);
      aDest.WitnessTable := aSource.WitnessTable;
    end;

    class method ReleaseClassProtocol(var aDest: SwiftClassProtocol);
    begin
      var lOld := InternalCalls.Exchange(var aDest.Instance, nil);
      swift_release(IntPtr(lOld));
      aDest.WitnessTable := nil;
    end;


    [SymbolName("new_swift_block_delegate")]
    class method NewBlockDelegate(aPtr: ^Void; aData: Object; var Res: SwiftBlockPtr); // returns arp
    begin
      ForeignBoehmGC.AddRef(aData);
      Res.Method := IntPtr(aPtr);
      Res.Obj := ^SwiftBlock(swift_allocObject(^Void(@SwiftBlockData.Type), sizeOf(^Void) * 3, {$IFDEF CPU64}7{$ELSE}3{$ENDIF}));
      Res.Obj^.Obj := aData;
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
      swift_getObjectType := SwiftIntPtrApi(rtl.dlsym(lDLL, 'swift_getObjectType'));
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
    class var swift_getObjectType: SwiftIntPtrApi;


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
    SwiftStrong.swift_deallocClassInstance(Dest, sizeOf(^Void) * 3, {$IFDEF CPU64}7{$ELSE}3{$ENDIF});
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

type
  SwiftMetadataResponse = public record
  public
    {$HIDE H8}
    fMetadata: IntPtr;
    fNumber: IntPtr;
    {$SHOW H8}
  end;

  SwiftBoxResult = public record
  public
    rc: ^SwiftRefcounted;
    data: ^Void;
  end;

  method SwiftAllocateBoxIfNeeded(aTarget: ^Byte; aInput: ^Void; aInputType: ^SwiftTypeRecord; aTakeOwnership: Boolean); // Presumes the target is already freed if needed.
  begin
    var lVWT := aInputType^.VWT;
    var lTar: ^Void;
    if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
      // Store it inline;
      lTar := ^Void(aTarget);
    end else begin
      var lDest := swift_allocBox(aInputType);
      lTar := lDest.data;
      ^^SwiftRefcounted(aTarget)^ := lDest.rc;
    end;
    if aTakeOwnership then
      lVWT^.assignWithTake(IntPtr(lTar), IntPtr(aInput), aInputType)
    else
      lVWT^.assignWithCopy(IntPtr(lTar), IntPtr(aInput), aInputType);
  end;

  [DelayLoadDllImport('libswiftCore.dylib', 'swift_allocBox'), CallingConvention(CallingConvention.Swift)]
  method swift_allocBox(aType: ^SwiftTypeRecord): SwiftBoxResult; external;

  [DelayLoadDllImport('libswiftCore.dylib', 'swift_projectBox'), CallingConvention(CallingConvention.Swift)]
  method swift_projectBox(aInput: ^SwiftRefcounted): ^Void; external;

  [DelayLoadDllImport('libswiftCore.dylib', 'swift_getEnumCaseMultiPayload'), CallingConvention(CallingConvention.Swift)]
  method swift_getEnumCaseMultiPayload(aVal: ^Void; aTypeInfo: ^Void): Integer; external;

  [DelayLoadDllImport('libswiftCore.dylib', 'swift_storeEnumTagMultiPayload'), CallingConvention(CallingConvention.Swift)]
  method swift_storeEnumTagMultiPayload(aVal: ^Void; aTypeInfo: ^Void; aEnumVal: Integer); external;


  [DelayLoadDllImport('libswiftCore.dylib', 'swift_getWitnessTable')]
  method swift_getWitnessTable(aPD: IntPtr; aType: IntPtr; aVal: IntPtr): IntPtr; external; public;


  var ProtocolDescriptorForBidirectionalCollection: IntPtr; assembly;
  var ProtocolDescriptorForRangeReplaceableCollection: IntPtr; assembly;

  method GetProtocolDescriptorForBidirectionalCollection: IntPtr; assembly;
  begin
    result := ProtocolDescriptorForBidirectionalCollection;
    if result = 0 then begin
      ProtocolDescriptorForBidirectionalCollection := Process.GetCachedProcAddress('libswiftCore.dylib', '$sSayxGSKsMc');
      result := ProtocolDescriptorForBidirectionalCollection;
    end;
  end;

  method GetProtocolDescriptorForRangeReplaceableCollection: IntPtr; assembly;
  begin
    result := ProtocolDescriptorForRangeReplaceableCollection;
    if result = 0 then begin
      ProtocolDescriptorForRangeReplaceableCollection := Process.GetCachedProcAddress('libswiftCore.dylib', '$sSayxGSmsMc');
      result := ProtocolDescriptorForRangeReplaceableCollection;
    end;
  end;

// aliases for Swift importing.
type
  Contacts.CNError = public Integer;
  CloudKit.CKError = public Integer;
  //Swift.Int = public RemObjects.Oxygene.System.IntPtr;
  Builtin.UInt8 = public RemObjects.Oxygene.System.Byte;
  Builtin.Int8 = public RemObjects.Oxygene.System.SByte;
  Builtin.Word = public RemObjects.Oxygene.System.UInt16;
  Builtin.Int16 = public RemObjects.Oxygene.System.Int16;
  Builtin.UInt16 = public RemObjects.Oxygene.System.UInt16;
  Builtin.Int32 = public RemObjects.Oxygene.System.Int32;
  Builtin.UInt32 = public RemObjects.Oxygene.System.UInt32;
  Builtin.NativeObject = public RemObjects.Elements.System.SwiftObject;
  Builtin.AnyObject = public RemObjects.Elements.System.SwiftObject;
  SwiftShims.HeapObject = public RemObjects.Elements.System.SwiftObject;
  SwiftShims._SwiftNSFastEnumerationState = public Foundation.NSFastEnumerationState;
  SwiftShims._SwiftNSOperatingSystemVersion = public Foundation.NSOperatingSystemVersion;
  Builtin.RawPointer = public RemObjects.Oxygene.System.IntPtr;
  Builtin.Int64 = public RemObjects.Oxygene.System.Int64;
  Builtin.UInt64 = public RemObjects.Oxygene.System.UInt64;
  Swift.Int1 = public RemObjects.Oxygene.System.Boolean;
  Builtin.Int1 = public RemObjects.Oxygene.System.Boolean;
  Builtin.IntLiteral = public RemObjects.Oxygene.System.Int64;
  Swift.Double = public RemObjects.Oxygene.System.Double;
  Builtin.FPIEEE64 = public RemObjects.Oxygene.System.Double;
  Builtin.FPIEEE80 = public RemObjects.Oxygene.System.Double;
  Builtin.FPIEEE32 = public RemObjects.Oxygene.System.Single;
  //Swift.Bool = public RemObjects.Oxygene.System.Boolean;
  Swift.CodeUnit = public RemObjects.Oxygene.System.UInt16;
  SwiftShims._SwiftArrayBodyStorage = public RemObjects.Elements.System._SwiftArrayBodyStorage;
  Swift.extern_proc = public RemObjects.Elements.System.extern_proc;
  rtl.timeval = public rtl.__struct_timeval;
  rtl.sem_t = public RemObjects.Oxygene.System.Int32;
  Dispatch.DispatchGroup = public rtl.dispatch_group_t;
  Dispatch.DispatchQueue = public rtl.dispatch_queue_t;
  Dispatch.DispatchSemaphore = public rtl.dispatch_semaphore_t;
  Dispatch.DispatchIO = public rtl.dispatch_io_t;
  Dispatch.DispatchSource = public rtl.dispatch_source_t;
  Dispatch.DispatchSourceProtocol = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceMachSend = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceMachReceive = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceMemoryPressure = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceProcess = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceTimer = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceFileSystemObject = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceUserDataAdd = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceUserDataOr = public rtl.OS_dispatch_source;
  Dispatch.DispatchSourceUserDataReplace = public rtl.OS_dispatch_source;
  Dispatch.DispatchTime = public rtl.OS_dispatch_source;
  Dispatch.__DispatchData = public rtl.dispatch_data_t;
  ObjectiveC.NSObject = public Foundation.NSObject;
  ObjectiveC.NSObjectProtocol = public Foundation.INSObject;
  Swift.OSLogType  = public rtl.os_log_type_t;
  Swift.OSLog = public Foundation.NSObject; //
  Swift.OSSignpostType = public rtl.os_signpost_type_t;
  simd.simd_float2x2 = public rtl.simd_float2x2;
  simd.simd_float3x2 = public rtl.simd_float3x2;
  simd.simd_float4x2 = public rtl.simd_float4x2;

  simd.simd_float2x3 = public rtl.simd_float2x3;
  simd.simd_float3x3 = public rtl.simd_float3x3;
  simd.simd_float4x3 = public rtl.simd_float4x3;

  simd.simd_float2x4 = public rtl.simd_float2x4;
  simd.simd_float3x4 = public rtl.simd_float3x4;
  simd.simd_float4x4 = public rtl.simd_float4x4;

  simd.simd_double2x2 = public rtl.simd_double2x2;
  simd.simd_double3x2 = public rtl.simd_double3x2;
  simd.simd_double4x2 = public rtl.simd_double4x2;

  simd.simd_double2x3 = public rtl.simd_double2x3;
  simd.simd_double3x3 = public rtl.simd_double3x3;
  simd.simd_double4x3 = public rtl.simd_double4x3;

  simd.simd_double2x4 = public rtl.simd_double2x4;
  simd.simd_double3x4 = public rtl.simd_double3x4;
  simd.simd_double4x4 = public rtl.simd_double4x4;
  simd.simd_quatf = public rtl.simd_quatf;
  simd.simd_quatd = public rtl.simd_quatd;

end.