namespace RemObjects.Elements.System;

type
  SwiftStrong<T> = public lifetimestrategy (SwiftStrong) T;
  OnceCallback = public procedure(ctx: ^Void);
  SwiftInt = public IntPtr;
  SwiftIntPtrApi = public function(i: IntPtr): IntPtr;
  SwiftAllocApi = public function(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;
  SwiftInitApi = public function(aMD: ^Void; aRequiredSize, aRequiredAlignmentMask: IntPtr): ^Void;
  SwiftBeginAccessApi = public procedure(pointer: ^Void; buffer: ^Void; flags: UIntPtr; pc: ^Void);


   _SwiftArrayBodyStorage = public record
   public
     count: IntPtr;
    _capacityAndFlags: UIntPtr;
  end;

  _SwiftEmptyArrayStorage = public record
  public
    header: SwiftRefcounted;
    body: _SwiftArrayBodyStorage;
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
    &Type: ^SwiftType;
    WitnessTable: ^^Byte;
  end;

  // Swift protocol WITH an AnyObject constraint
  SwiftClassProtocol = public record
  public
    Instance: ^SwiftRefcounted;
    WitnessTable: ^^Byte;
  end;

  SwiftVWTinitializeBufferWithCopyOfBuffer = public function(dest, src: IntPtr; aSelf: ^SwiftType): IntPtr;
  SwiftVWTdestroy = public procedure(obj: IntPtr; aSelf: ^SwiftType);
  SwiftVWTgetEnumTagSinglePayload = public function(anEnum: IntPtr; emptyCases: UInt32): UInt32;
  SwiftVWTstoreEnumTagSinglePayload = public procedure(anEnum: IntPtr; whichCase, emptyCases: UInt32);
  SwiftVWTgetEnumTag = public function(obj: IntPtr; aSelf: ^SwiftValueWitnessTable): UInt32;
  SwiftVWTdestructiveProjectEnumData = public procedure(obj: IntPtr; aSelf: ^SwiftValueWitnessTable);
  SwiftVWTdestructiveInjectEnumTag = public procedure(obj: IntPtr; tag: UInt32; aSelf: ^SwiftValueWitnessTable);
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
  SwiftUTF16View = record
  public
  {$HIDE H8}
    // same as string, it's a wrapper.
    _countAndFlagsBits: UInt64;
    _object: ^Void;
  {$SHOW H8}

    class method DestroyUTF16View(aView: ^SwiftUTF16View);
    begin
      SwiftStrong.swift_bridgeObjectRelease(IntPtr(aView^._object));
    end;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5countSivg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16Count(aVal1: UInt64; aVal2: ^Void): IntPtr; external;

    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV10startIndexSS0D0Vvg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16FirstIndex(aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5index5afterSS5IndexVAF_tF'), CallingConvention(CallingConvention.Swift)]
    class method UTF16NextIndex(aPrev: Int64; aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewVys6UInt16VSS5IndexVcig'), CallingConvention(CallingConvention.Swift)]
    class method UTF16GetChar(aIndex: Int64; aVal1: UInt64; aVal2: ^Void): Char; external;
  end;

  SwiftString = public record
  private
    _countAndFlagsBits: UInt64;
    _object: ^Void;

    class var fTypeInfo: IntPtr := Process.GetCachedProcAddress('libswiftCore.dylib', '$sSSN');
    class property VWT: ^SwiftValueWitnessTable read ^^SwiftValueWitnessTable(fTypeInfo)[-1];

    [DelayLoadDllImport('libswiftFoundation.dylib', '$sSS10FoundationE14utf16CodeUnits5countSSSPys6UInt16VG_SitcfC'), CallingConvention(CallingConvention.Swift)]
    class method StringFromUTF16(aVal: ^Char; aLength: IntPtr): SwiftUTF16View; external;

    [DelayLoadDllImport('libswiftCore.dylib', '$sSS5utf16SS9UTF16ViewVvg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16View(aVal: UInt64; aVal2: ^Void): SwiftUTF16View; external;

  public
    finalizer;
    begin
      VWT^.destroy(IntPtr(@self), ^SwiftType(fTypeInfo));
    end;

    constructor Copy(var aValue: SwiftString);
    begin
      VWT^.initializeWithCopy(IntPtr(@self), IntPtr(@aValue), ^SwiftType(fTypeInfo));
    end;

    class operator Assign(var aDest: SwiftString; var aSource: SwiftString);
    begin
      VWT^.assignWithCopy(IntPtr(@aDest), IntPtr(@aSource), ^SwiftType(fTypeInfo));
    end;

    constructor(aValue: String);
    begin
      if aValue <> nil then begin
        var lWork := StringFromUTF16(aValue.FirstChar, aValue.Length);
        _countAndFlagsBits := lWork._countAndFlagsBits;
        _object := lWork._object;
      end;
    end;

    method ToString: String; override;
    begin
      var lView := UTF16View(_countAndFlagsBits, _object);
      var lCount := SwiftUTF16View.UTF16Count(lView._countAndFlagsBits, lView._object);
      var lVal := new Char[lCount];
      if lVal.Length = 0 then exit 0;
      var lFirst := SwiftUTF16View.UTF16FirstIndex(lView._countAndFlagsBits, lView._object);
      lVal[0] := SwiftUTF16View.UTF16GetChar(lFirst, lView._countAndFlagsBits, lView._object);
      for i: Integer := 1 to lCount -1 do begin
        lFirst := SwiftUTF16View.UTF16NextIndex(lFirst, lView._countAndFlagsBits, lView._object);
        lVal[i] := SwiftUTF16View.UTF16GetChar(lFirst, lView._countAndFlagsBits, lView._object);
      end;

      SwiftUTF16View.DestroyUTF16View(@lView);
      exit String.FromCharArray(lVal);
    end;

    class operator implicit(aVal: String): SwiftString;
    begin
      exit new SwiftString(aVal);
    end;

    class operator implicit(aVal: SwiftString): String;
    begin
      exit aVal.ToString;
    end;

    class operator implicit(aVal: CocoaString): SwiftString;
    begin
      exit new SwiftString(aVal);
    end;

    class operator implicit(aVal: SwiftString): CocoaString;
    begin
      exit aVal.ToString;
    end;

  end;

  SwiftMetadataResponse = public record
  public
    {$HIDE H8}
    fMetadata: IntPtr;
    fNumber: IntPtr;
    {$SHOW H8}
  end;

  SwiftMutatorResult = public record
    {$HIDE H8}
    fDispose: SwiftMutatorDispose;
    fData: IntPtr;
    {$SHOW H8}
  end;
  SwiftMutatorData = public array[0..31] of Byte;
  SwiftMutatorDispose = procedure(par0: ^SwiftMutatorData; par1: Boolean);

  SwiftArray<T> = public record
  assembly
    fArray: IntPtr;

    method get_Item(i: IntPtr): T;
    begin
      SwiftArrayGet(IntPtr(@result), i, IntPtr(fArray), fSubType);
    end;

    method set_Item(i: IntPtr; aVal: T);
    begin
      var lStore: SwiftMutatorData;
      var lData := SwiftArrayModify(@lStore, i, fType, IntPtr(@fArray));

      ^^SwiftValueWitnessTable(fSubType)[-1].assignWithCopy(lData.fData, IntPtr(@aVal), ^SwiftType(fSubType));

      lData.fDispose(@lStore, false);
    end;

    class var fSubType: IntPtr;
    class var fType: IntPtr;
    class var fArrayProtocolDescriptorForBidirectionalCollection: IntPtr;
    class var fArrayProtocolDescriptorForRangeReplaceableCollection: IntPtr;

    class constructor;
    begin
      fSubType := IntPtr(InternalCalls.GetSwiftTypeInfo<T>());
      fType := SwiftArrayType(0, fSubType).fMetadata;
    end;

  public
    constructor(aFromArray: IntPtr; aTakeOwnership: Boolean := true);
    begin
      if not aTakeOwnership then
        aFromArray := SwiftStrong.swift_bridgeObjectRetain(aFromArray);
      fArray := aFromArray;
    end;

    constructor();
    begin
      fArray := SwiftAllocateArray(^Void(fSubType));
    end;

    method append(aVal: T);
    begin
      SwiftArrayAppend(IntPtr(@aVal), fType, IntPtr(@fArray));
    end;

    method removeAt(aIndex: IntPtr): T;
    begin
      SwiftArrayRemoveAt(^IntPtr(@result), aIndex, fType, IntPtr(@fArray));
    end;

    method removeLast: T;
    begin
      if fArrayProtocolDescriptorForBidirectionalCollection = 0 then
        fArrayProtocolDescriptorForBidirectionalCollection := swift_getWitnessTable(GetProtocolDescriptorForBidirectionalCollection, SwiftArrayType(255, fSubType).fMetadata, nil);
      if fArrayProtocolDescriptorForRangeReplaceableCollection = 0 then
        fArrayProtocolDescriptorForRangeReplaceableCollection := swift_getWitnessTable(GetProtocolDescriptorForRangeReplaceableCollection, SwiftArrayType(255, fSubType).fMetadata, nil);
      SwiftArrayRemoveLast(^IntPtr(@result), fType, fArrayProtocolDescriptorForBidirectionalCollection, fArrayProtocolDescriptorForRangeReplaceableCollection, IntPtr(@fArray));
    end;


    method removeFirst: T;
    begin
      if fArrayProtocolDescriptorForRangeReplaceableCollection = 0 then
        fArrayProtocolDescriptorForRangeReplaceableCollection := swift_getWitnessTable(GetProtocolDescriptorForRangeReplaceableCollection, SwiftArrayType(255, fSubType).fMetadata, nil);
      SwiftArrayRemoveFirst(^IntPtr(@result), fType, fArrayProtocolDescriptorForRangeReplaceableCollection, IntPtr(@fArray));
    end;


    property &Array: IntPtr read fArray;

    property Item[i: IntPtr]: T read get_Item write set_Item; default;

    constructor Copy(var aValue: SwiftArray<T>);
    begin
      fArray := SwiftStrong.swift_bridgeObjectRetain(aValue.fArray);
    end;

    class operator Assign(var aDest: SwiftArray<T>; var aSource: SwiftArray<T>);
    begin
      var lOld := aDest.fArray;
      aDest.fArray := SwiftStrong.swift_bridgeObjectRelease(aSource.fArray);
      SwiftStrong.swift_bridgeObjectRelease(lOld);
    end;


    finalizer;
    begin
      if fArray <> 0 then
        SwiftStrong.swift_bridgeObjectRelease(fArray);
      fArray := 0;
    end;

  end;

  [DelayLoadDllImport('libswiftCore.dylib', '$sS2ayxGycfC'), CallingConvention(CallingConvention.Swift)]
  method SwiftAllocateArray(aType: ^Void): IntPtr; external; assembly;

  [DelayLoadDllImport('libswiftCore.dylib', '$sSayxSicig'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayGet([SRet] aValue: IntPtr; aIndex: IntPtr; aSelf: IntPtr; aType: IntPtr); external; assembly;

  [DelayLoadDllImport('libswiftCore.dylib', '$sSayxSiciM'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayModify(aStorage: ^SwiftMutatorData; aIndex: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: IntPtr): SwiftMutatorResult; external; assembly;

  [DelayLoadDllImport('libswiftCore.dylib', '$sSaMa'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayType(aCode: IntPtr; aSubType: IntPtr): SwiftMetadataResponse; external; assembly;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSmsSKRzrlE10removeLast7ElementSTQzyF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveLast([SRet]aResult: ^IntPtr; aType: IntPtr; aWTBidir, aWTRange: IntPtr;[SwiftSelf] aSelf: IntPtr); external; assembly;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSmsE11removeFirst7ElementQzyF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveFirst([SRet]aResult: ^IntPtr; aType: IntPtr; aWT: IntPtr;[SwiftSelf] aSelf: IntPtr); external; assembly;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSa6remove2atxSi_tF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveAt([SRet]aRest: ^IntPtr; aIndex: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: IntPtr); external; assembly;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSa6appendyyxnF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayAppend(aValue: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: IntPtr); external; assembly;

  [DelayLoadDllImport('libswiftCore.dylib', 'swift_getWitnessTable')]
  method swift_getWitnessTable(aPD: IntPtr; aType: IntPtr; aVal: IntPtr): IntPtr; external; assembly;


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

end.