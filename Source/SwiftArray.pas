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
  SwiftMutatorDispose = procedure(par0: ^SwiftMutatorData; par1: Boolean);


  [SwiftFixedLayout]
  SwiftArray<T> = public record
  assembly
    fArray: IntPtr;

    property Data: ^Void read ^Void(fArray);
    property &Type: ^SwiftTypeRecord read ^SwiftTypeRecord(fType);

    method get_Item(i: IntPtr): T;
    begin
      SwiftArrayGet(IntPtr(@result), i, IntPtr(fArray), fSubType);
    end;

    method set_Item(i: IntPtr; aVal: T);
    begin
      var lStore: SwiftMutatorData;
      var lData := SwiftArrayModify(@lStore, i, fType, IntPtr(@fArray));

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
      fType :=  IntPtr(InternalCalls.GetSwiftTypeInfo<SwiftArray<T>>());
    end;

  public
    constructor(aFromArray: ^Void; aTakeOwnership: Boolean := true);
    begin
      if not aTakeOwnership then
        aFromArray := ^Void(SwiftStrong.swift_bridgeObjectRetain(IntPtr(aFromArray)));
      fArray := IntPtr(aFromArray);
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
        fArrayProtocolDescriptorForBidirectionalCollection := swift_getWitnessTable(GetProtocolDescriptorForBidirectionalCollection,  IntPtr(InternalCalls.GetSwiftTypeInfo<T>), nil);
      if fArrayProtocolDescriptorForRangeReplaceableCollection = 0 then
        fArrayProtocolDescriptorForRangeReplaceableCollection := swift_getWitnessTable(GetProtocolDescriptorForRangeReplaceableCollection,  IntPtr(InternalCalls.GetSwiftTypeInfo<T>), nil);
      SwiftArrayRemoveLast(^IntPtr(@result), fType, fArrayProtocolDescriptorForBidirectionalCollection, fArrayProtocolDescriptorForRangeReplaceableCollection, IntPtr(@fArray));
    end;


    method removeFirst: T;
    begin
      if fArrayProtocolDescriptorForRangeReplaceableCollection = 0 then
        fArrayProtocolDescriptorForRangeReplaceableCollection := swift_getWitnessTable(GetProtocolDescriptorForRangeReplaceableCollection,  IntPtr(InternalCalls.GetSwiftTypeInfo<T>), nil);
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
  method SwiftAllocateArray(aType: ^Void): IntPtr; external; public;

  [DelayLoadDllImport('libswiftCore.dylib', '$sSayxSicig'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayGet([SRet] aValue: IntPtr; aIndex: IntPtr; aSelf: IntPtr; aType: IntPtr); external; public;

  [DelayLoadDllImport('libswiftCore.dylib', '$sSayxSiciM'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayModify(aStorage: ^SwiftMutatorData; aIndex: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: IntPtr): SwiftMutatorResult; external; public;

  [DelayLoadDllImport('libswiftCore.dylib', '$sSaMa'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayType(aCode: IntPtr; aSubType: IntPtr): SwiftMetadataResponse; external; public;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSmsSKRzrlE10removeLast7ElementSTQzyF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveLast([SRet]aResult: ^IntPtr; aType: IntPtr; aWTBidir, aWTRange: IntPtr;[SwiftSelf] aSelf: IntPtr); external; public;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSmsE11removeFirst7ElementQzyF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveFirst([SRet]aResult: ^IntPtr; aType: IntPtr; aWT: IntPtr;[SwiftSelf] aSelf: IntPtr); external; public;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSa6remove2atxSi_tF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayRemoveAt([SRet]aRest: ^IntPtr; aIndex: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: IntPtr); external; public;


  [DelayLoadDllImport('libswiftCore.dylib', '$sSa6appendyyxnF'), CallingConvention(CallingConvention.Swift)]
  method SwiftArrayAppend(aValue: IntPtr; aType: IntPtr; [SwiftSelf] aSelf: IntPtr); external; public;


end.