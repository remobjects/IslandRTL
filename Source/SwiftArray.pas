namespace RemObjects.Elements.System;
type

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


  SwiftMutatorResult = public record
    {$HIDE H8}
    fDispose: SwiftMutatorDispose;
    fData: IntPtr;
    {$SHOW H8}
  end;
  SwiftMutatorData = public array[0..31] of Byte;
  [CallingConvention(CallingConvention.Swift)]
  SwiftMutatorDispose = procedure(par0: ^SwiftMutatorData; par1: Boolean);


  [SwiftFixedLayout]
  SwiftArray<T> = public record
  assembly
    fArray: ^Void;

    property Data: ^Void read fArray;
    property &Type: ^SwiftTypeRecord read ^SwiftTypeRecord(fType);

    method get_Item(i: IntPtr): T;
    begin
      SwiftArrayGet(^Byte(@result), i, fArray, fSubType);
    end;

    method set_Item(i: IntPtr; aVal: T);
    begin
      var lStore: SwiftMutatorData;
      var lData := SwiftArrayModify(@lStore, i, fType, @fArray);

      ^^SwiftValueWitnessTable(fSubType)[-1].assignWithCopy(lData.fData, IntPtr(@aVal), ^SwiftTypeRecord(fSubType));

      lData.fDispose(@lStore, false);
    end;

    class var fSubType: IntPtr;
    class var fType: IntPtr;
    class var fArrayProtocolDescriptorForBidirectionalCollection: IntPtr;
    class var fArrayProtocolDescriptorForRangeReplaceableCollection: IntPtr;

    class constructor;
    begin
      fSubType := IntPtr(InternalCalls.GetSwiftTypeInfo<T>());
      var lMetadata := SwiftArrayType(0, fSubType);
      fType := lMetadata.fMetadata;
    end;

  public
    constructor(aFromArray: ^Void; aTakeOwnership: Boolean := true);
    begin
      if not aTakeOwnership then
        aFromArray := ^Void(SwiftStrong.swift_bridgeObjectRetain(IntPtr(aFromArray)));
      fArray := aFromArray;
    end;

    constructor();
    begin
      fArray := SwiftAllocateArray(^Void(fSubType));
    end;

    method append(aVal: T);
    begin
      SwiftArrayAppend(^Byte(@aVal), fType, @fArray);
    end;

    method removeAt(aIndex: IntPtr): T;
    begin
      SwiftArrayRemoveAt(^Byte(@result), aIndex, fType, @fArray);
    end;

    method removeLast: T;
    begin
      if fArrayProtocolDescriptorForBidirectionalCollection = 0 then
        fArrayProtocolDescriptorForBidirectionalCollection := swift_getWitnessTable(IntPtr(GetProtocolDescriptorForBidirectionalCollection),  IntPtr(InternalCalls.GetSwiftTypeInfo<T>), nil);
      if fArrayProtocolDescriptorForRangeReplaceableCollection = 0 then
        fArrayProtocolDescriptorForRangeReplaceableCollection := swift_getWitnessTable(IntPtr(GetProtocolDescriptorForRangeReplaceableCollection),  IntPtr(InternalCalls.GetSwiftTypeInfo<T>), nil);
      SwiftArrayRemoveLast(^Byte(@result), fType, fArrayProtocolDescriptorForBidirectionalCollection, fArrayProtocolDescriptorForRangeReplaceableCollection, @fArray);
    end;

    method removeFirst: T;
    begin
      if fArrayProtocolDescriptorForRangeReplaceableCollection = 0 then
        fArrayProtocolDescriptorForRangeReplaceableCollection := swift_getWitnessTable(IntPtr(GetProtocolDescriptorForRangeReplaceableCollection),  IntPtr(InternalCalls.GetSwiftTypeInfo<T>), nil);
      SwiftArrayRemoveFirst(^Byte(@result), fType, fArrayProtocolDescriptorForRangeReplaceableCollection, @fArray);
    end;

    property &Array: IntPtr read IntPtr(fArray);

    property Item[i: IntPtr]: T read get_Item write set_Item; default;

    constructor Copy(var aValue: SwiftArray<T>);
    begin
      fArray := ^Void(SwiftStrong.swift_bridgeObjectRetain(IntPtr(aValue.fArray)));
    end;

    class operator Assign(var aDest: SwiftArray<T>; var aSource: SwiftArray<T>);
    begin
      if (@aDest) = (@aSource) then exit;
      var lOld := aDest.fArray;
      aDest.fArray := ^Void(SwiftStrong.swift_bridgeObjectRetain(IntPtr(aSource.fArray)));
      SwiftStrong.swift_bridgeObjectRelease(IntPtr(lOld));
    end;

    finalizer;
    begin
      if fArray <> nil then
        SwiftStrong.swift_bridgeObjectRelease(IntPtr(fArray));
      fArray := nil;
    end;

  end;

  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sS2ayxGycfC'), CallingConvention(CallingConvention.Swift)]
  method SwiftAllocateArray(aType: ^Void): ^Void; external; public;

  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSayxSicig'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayGet([SRet] aValue: ^Byte; aIndex: IntPtr; aSelf: ^Void; aType: IntPtr); external; public;

  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSayxSiciM'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayModify(aStorage: ^SwiftMutatorData; aIndex: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: ^^Void): SwiftMutatorResult; external; public;

  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSaMa'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayType(aCode: IntPtr; aSubType: IntPtr): SwiftMetadataResponse; external; public;


  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSmsSKRzrlE10removeLast7ElementSTQzyF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveLast([SRet]aResult: ^Byte; aType: IntPtr; aWTBidir, aWTRange: IntPtr;[SwiftSelf] aSelf: ^^Void); external; public;


  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSmsE11removeFirst7ElementQzyF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveFirst([SRet]aResult: ^Byte; aType: IntPtr; aWT: IntPtr;[SwiftSelf] aSelf: ^^Void); external; public;


  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSa6remove2atxSi_tF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveAt([SRet]aRest: ^Byte; aIndex: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: ^^Void); external; public;


  [DelayLoadDllImport('/usr/lib/swift/libswiftCore.dylib', '$sSa6appendyyxnF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayAppend(aValue: ^Byte; aType: IntPtr; [SwiftSelf] aSelf: ^^Void); external; public;


end.
