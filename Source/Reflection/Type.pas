namespace RemObjects.Elements.System;

type
  [Used]
  &Type = public class
  private

    method get_COMGuids: sequence of Guid; iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 15) and (lTy = ProtoReadType.length) then begin
          yield new Guid(ProtoReadBytes(var lPtr));
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Constants: sequence of ConstantInfo; iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 2) and (lTy = ProtoReadType.message) then begin
          yield new ConstantInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    class method get_AllTypes: sequence of &Type; iterator;
    begin
      if fTypes = nil then LoadTypes;
      for i: Integer := 0 to fTypes.Count -1 do begin
        if fTypes[i] = nil then continue;
        yield new &Type(fTypes[i]);
      end;
    end;
    {$IFDEF WINDOWS}

    class method LoadTypes;
    begin
      var lWork := @fStart;
      var lTypes := new ^IslandTypeInfo[(IntPtr(@fEnd) - IntPtr(@fStart)) / sizeOf(IntPtr) + 3];
      var n := 0;
      loop begin
        inc(lWork);
        if lWork = @fEnd then break;
        if lWork^ = nil then continue;
        lTypes[n] := lWork^;
        inc(n);
      end;
      lTypes[n] := @ComInterfaceRTTI; inc(n);
      lTypes[n] := @CocoaClassRTTI; inc(n);
      lTypes[n] := @SwiftClassRTTI; inc(n);
      SortTypes(lTypes);
    end;

    {$ELSEIF DARWIN}
    [&Weak, SymbolName('_mh_execute_header')]
    class var __mh_execute_header: {$IFDEF CPU64}rtl.__struct_mach_header_64{$ELSE}rtl.__struct_mach_header{$ENDIF} ; external;
    [&Weak, SymbolName('_mh_dylib_header')]
    class var _mh_dylib_header: {$IFDEF CPU64}rtl.__struct_mach_header_64{$ELSE}rtl.__struct_mach_header{$ENDIF} ; external;

    {$IFDEF DARWIN}public{$ENDIF}class method GetHDR: ^{$IFDEF CPU64}rtl.__struct_mach_header_64{$ELSE}rtl.__struct_mach_header{$ENDIF};
    begin
      var hdr := @__mh_execute_header;
      if hdr = nil then
        hdr := @_mh_dylib_header;
      exit hdr;
    end;

    class method LoadTypes;
    begin
      var lSize: {$IF __LP64__}UInt64{$ELSE}UInt32{$ENDIF};
      var hdr := GetHDR;
      var lStart := rtl.getsectiondata(hdr, "__DATA", "__ELRTTLRR", @lSize);
      var lWork := ^^IslandTypeInfo(lStart);
      var lEnd := ^^IslandTypeInfo(^Byte(lStart) + lSize);
      var lTypes := new ^IslandTypeInfo[lSize / sizeOf(IntPtr) + 3];
      var n := 0;
      loop begin
        if lWork^ <> nil then begin
          lTypes[n] := lWork^;
          inc(n);
        end;
        inc(lWork);
        if lWork >= lEnd then break;
      end;
      lTypes[n] := @ComInterfaceRTTI; inc(n);
      lTypes[n] := @CocoaClassRTTI; inc(n);
      lTypes[n] := @SwiftClassRTTI; inc(n);
      SortTypes(lTypes);
    end;

    {$ELSE}

    [SymbolName('__start_ELRTTLRR')]
    class var fStart: ^IslandTypeInfo; external;
    [SymbolName('__stop_ELRTTLRR')]
    class var fEnd: ^IslandTypeInfo;external;

    class method LoadTypes;
    begin
      var lEnd := @fEnd;
      var lWork := @fStart;
      var lTypes := new ^IslandTypeInfo[(IntPtr(lEnd) - IntPtr(lWork)) / sizeOf(IntPtr) + 1 + 3];
      var n := 0;
      loop begin
        if lWork^ <> nil then begin
          lTypes[n] := lWork^;
          inc(n);
        end;
        inc(lWork);
        if lWork >= lEnd then break;
      end;

      lTypes[n] := @ComInterfaceRTTI; inc(n);
      lTypes[n] := @CocoaClassRTTI; inc(n);
      lTypes[n] := @SwiftClassRTTI; inc(n);
      SortTypes(lTypes);
    end;
    {$ENDIF}

    class var fMethods: array of IslandMethodUIDInfo;
    class var fTypes: array of ^IslandTypeInfo;

    class method Sorter(a, b: IslandMethodUIDInfo): Integer;
    begin
      result := a.K1.CompareTo(b.K1);
      if result = 0 then
        result := a.K2.CompareTo(b.K2);
    end;

    class method Sorter(a, b: ^IslandTypeInfo): Integer;
    begin
      if a = b then exit 0;
      if a = nil then exit -1;
      if b = nil then exit 1;

      result := a^.Hash1.CompareTo(b^.Hash1);
      if result = 0 then
        result := a^.Hash2.CompareTo(b^.Hash2);
    end;

    class method SortTypes(aTypes: array of ^IslandTypeInfo);
    begin
      Array.Sort(aTypes, @Sorter);
      fTypes := aTypes;
    end;

    class method SortMethods(aMethods: array of IslandMethodUIDInfo);
    begin
      Array.Sort(aMethods, @Sorter);
      fMethods := aMethods;
    end;

    class method ResolveType(aType: ^Void): ^IslandTypeInfo; assembly;
    begin
      if fTypes = nil then LoadTypes;
      var z := ^IslandMethodUIDInfo(aType);
      z^.ToString;
      var n := Array.BinarySearch(fTypes, aType, (a, b) -> begin
        if a = nil then exit -1;
        result := a^.Hash1.CompareTo(^IslandMethodUIDInfo(b).K1);
        if result = 0 then
          result := a^.Hash2.CompareTo(^IslandMethodUIDInfo(b).K2);
      end);
      if n < 0 then exit 0;
      if n >= fTypes.Length then exit 0;
      exit fTypes[n];
    end;

    class method ResolveMethod(aMethod: ^Void): ^Void; assembly;
    begin
      if fMethods = nil then LoadMethods;
      var n := Array.BinarySearch(fMethods, aMethod, (a, b) -> begin
        result := a.K1.CompareTo(^IslandMethodUIDInfo(b).K1);
        if result = 0 then
          result := a.K2.CompareTo(^IslandMethodUIDInfo(b).K2);
      end);
      if n < 0 then exit 0;
      if n >= fMethods.Length then exit 0;
      exit ^Void(fMethods[n].Ptr);
    end;

    {$IFDEF WINDOWS}
    class method LoadMethods;
    begin
      var lWork := @fMStart;
      var n := 0;
      var lMethods := new IslandMethodUIDInfo[((IntPtr(@fMEnd) - IntPtr(@fMStart)) / sizeOf(IslandMethodUIDInfo))+1];
      loop begin
        inc(lWork);
        lMethods[n] := lWork^;
        if lWork >= @fMEnd then break;
        if lWork^.Ptr = 0 then continue;
        inc(n);
      end;
      SortMethods(lMethods);
    end;

    //{$ELSEIF WEBASSEMBLY}
    //class var fAllTypes: List<&Type>;
    /*class method LoadMethods;
    begin

      //SortMethods;
    end;*/

    {$ELSEIF DARWIN}

    class method LoadMethods;
    begin
      var lSize: {$IF __LP64__}UInt64{$ELSE}UInt32{$ENDIF};
      var hdr := GetHDR;
      var lStart := rtl.getsectiondata(hdr, "__DATA", "__ELRTMLRR", @lSize);
      var lWork := ^IslandMethodUIDInfo(lStart);
      var lEnd := ^IslandMethodUIDInfo(^Byte(lStart) + lSize);
      var n := 0;
      var lMethods := new IslandMethodUIDInfo[lSize / sizeOf(IslandMethodUIDInfo)+ 1];
      loop begin
        if lWork^.Ptr ≠ 0 then begin
          lMethods[n] := lWork^;
          inc(n);
        end;
        inc(lWork);
        if lWork >= lEnd then break;
      end;
      SortMethods(lMethods);
    end;

    {$ELSE}

    [SymbolName('__start_ELRTMLRR')]
    class var fStartM: IslandMethodUIDInfo; external;
    [SymbolName('__stop_ELRTMLRR')]
    class var fEndM: IslandMethodUIDInfo;external;

    [DisableInlining]
    class method GetMethodStart: ^IslandMethodUIDInfo; begin exit @fStartM; end;
    [DisableInlining]
    class method GetMethodsEnd: ^IslandMethodUIDInfo; begin exit @fEndM; end;

    class method LoadMethods;
    begin
      var lEnd := GetMethodsEnd;
      var lWork := GetMethodStart;
      var n := 0;
      var lMethods := new IslandMethodUIDInfo[((IntPtr(lEnd) - IntPtr(lWork)) / sizeOf(IslandMethodUIDInfo))+1];
      loop begin
        if lWork^.Ptr <> 0 then begin
          lMethods[n] := lWork^;
          inc(n);
        end;
        inc(lWork);
        if lWork > lEnd then break;
      end;
      SortMethods(lMethods);
    end;

    {$ENDIF}

    method get_Events: sequence of EventInfo;iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 5) and (lTy = ProtoReadType.message) then begin
          yield new EventInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Properties: sequence of PropertyInfo;iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 4) and (lTy = ProtoReadType.message) then begin
          yield new PropertyInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Fields: sequence of FieldInfo;iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 1) and (lTy = ProtoReadType.message) then begin
          yield new FieldInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Methods: sequence of MethodInfo;iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 3) and (lTy = ProtoReadType.message) then begin
          yield new MethodInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Members: sequence of MemberInfo;iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 1) and (lTy = ProtoReadType.message) then begin
          yield new FieldInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else  if (lKey = 2) and (lTy = ProtoReadType.message) then begin
          yield new ConstantInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else if (lKey = 3) and (lTy = ProtoReadType.message) then begin
          yield new MethodInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else if (lKey = 4) and (lTy = ProtoReadType.message) then begin
          yield new PropertyInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else if (lKey = 5) and (lTy = ProtoReadType.message) then begin
          yield new EventInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Attributes: sequence of CustomAttribute; iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 0) and (lTy = ProtoReadType.startgroup) then begin
          yield ReadAttribute(fValue, var lPtr)
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_NestedTypes: sequence of &Type; iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 6) and (lTy = ProtoReadType.varint) then begin
          yield new &Type(^IslandTypeInfo(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_GenericArguments: sequence of &Type; iterator;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 7) and (lTy = ProtoReadType.varint) then begin
          yield new &Type(^IslandTypeInfo(&Type.ResolveType(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    class method ReadAttribute(fValue: ^IslandTypeInfo; var lPtr: ^Byte): CustomAttribute; assembly;
    begin
      var lKey: Integer;
      var lTy: ProtoReadType;
      var lAtt := new List<CustomAttributeArgument>;
      var lType: &Type;
      var lCtor: ^Void;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 0) and (lTy = ProtoReadType.varint) then
          lType := new &Type(^IslandTypeInfo(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]))
        else if (lKey = 1) and (lTy = ProtoReadType.varint) then
          lCtor := fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
        else if (lKey = 3) and (lTy = ProtoReadType.startgroup) then begin
          lAtt.Add(ReadAttributeValue(var lPtr));
        end else ProtoSkipValue(var lPtr, lTy);
      end;
      exit new CustomAttribute(lType, lCtor, lAtt.ToArray);
    end;

    class method ReadAttributeValue(var lPtr: ^Byte): CustomAttributeArgument; assembly;
    begin
      var lName: String;
      var lKey: Integer;
      var lTy: ProtoReadType;
      var lList: List<Object>;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 0) and (lTy = ProtoReadType.length) then
          lName := ProtoReadString(var lPtr)
        else if (lKey = 1) and (lTy = ProtoReadType.varint) then
          result := new CustomAttributeArgument(lName, ProtoReadVarInt(var lPtr))
        else if (lKey = 2) and (lTy = ProtoReadType.b64) then
          result := new CustomAttributeArgument(lName, ProtoReadDouble(var lPtr))
        else if (lKey = 3) and (lTy = ProtoReadType.length) then
          result := new CustomAttributeArgument(lName, ProtoReadString(var lPtr))
        else if (lKey = 4) and (lTy = ProtoReadType.startgroup) then begin
          if lList = nil then lList := new List<Object>;
          lList.Add(ReadAttributeValue(var lPtr).Value);
        end
        else ProtoSkipValue(var lPtr, lTy)
      end;
      if lList <> nil then exit new CustomAttributeArgument(lName, lList.ToArray);
    end;

    method get_Interfaces: sequence of &Type; iterator;
    begin
      if fValue^.InterfaceType = nil then exit;
      for i: Integer := 0 to fValue^.InterfaceType^.HashTableSize -1 do begin
        var lHashEntry := (@fValue^.InterfaceType^.FirstEntry)[i];
        if lHashEntry <> nil then
          while lHashEntry^ <> nil do begin
            yield new &Type(lHashEntry^);
            inc(lHashEntry);
          end;
      end;
    end;

    method get_SubType: &Type;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit nil;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 13) and (lTy = ProtoReadType.varint) then
          exit new &Type(^IslandTypeInfo(&Type.ResolveType(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])))
        else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_SizeOfType: Integer;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 12) and (lTy = ProtoReadType.varint) then
          exit ProtoReadVarInt(var lPtr)
        else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_BoxedDataOffset: Integer;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit 0;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 14) and (lTy = ProtoReadType.varint) then
          exit ProtoReadVarInt(var lPtr)
        else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_DefFlags: TypeDefFlags;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit TypeDefFlags(0);
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 11) and (lTy = ProtoReadType.varint) then
          exit TypeDefFlags(ProtoReadVarInt(var lPtr))
        else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Code: TypeCodes;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      if lPtr = nil then exit TypeCodes.None;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 10) and (lTy = ProtoReadType.varint) then
          exit TypeCodes(ProtoReadVarInt(var lPtr))
        else
          ProtoSkipValue(var lPtr, lTy);
      end;
      exit TypeCodes(-1);
    end;

  assembly

    fValue: ^IslandTypeInfo;

  public

    constructor(aValue: ^IslandTypeInfo);
    begin
      fValue := aValue;
    end;

    class operator Equal(a, b: &Type): Boolean;
    begin
      if assigned(a) <> assigned(b) then exit false;
      if assigned(a) then
        exit (a.fValue = b.fValue);
      exit true;
    end;

    class operator NotEqual(a, b: &Type): Boolean;
    begin
      exit not (a = b);
    end;

    class property AllTypes: sequence of &Type read get_AllTypes;

    property RTTI: ^IslandTypeInfo read fValue;

    property &Name: String read begin
      if fValue = nil then
        exit nil;
      if IslandTypeFlags.Generic in fValue^.Ext^.Flags then begin
        var lSub := new &Type(fValue^.Ext^.SubType);
        if lSub = typeOf(Array<1>) then
          exit GenericArguments.First.Name+'[]';
        result := StripGenerics(lSub.Name);
        result := result + '<'+ String.Join(',', GenericArguments.Select(e -> e.Name)) + '>';
        exit;
      end;
      result := String.FromPAnsiChars(fValue^.Ext^.Name);
    end;

    class method StripGenerics(s: String): String; private;
    begin
      if s = nil then exit '';
      var lIndex := s.LastIndexOf('`');
      if lIndex >= 0 then
        exit s.Substring(0, lIndex);
      exit s;
    end;

    property &Flags: IslandTypeFlags read fValue^.Ext^.Flags;

    method Equals(other: Object): Boolean; override;
    begin
      exit (other is &Type) and (&Type(other).fValue = fValue);
    end;

    method GetHashCode: Integer; override;
    begin
      exit Integer({$ifdef cpu64}Int64(fValue) xor (Int64(fValue) shr 32) * 7{$else}fValue{$endif});
    end;

    method IsSubclassOf(aType: &Type): Boolean;
    begin
      if aType = nil then exit false;
      var b:^IslandTypeInfo := fValue;
      while b <> nil do begin
        if b = aType.fValue then exit true;
        b := b^.ParentType;
      end;
      exit false;
    end;

    property Code: TypeCodes read get_Code;
    property IsSigned: Boolean read Code in [TypeCodes.SByte, TypeCodes.Int16, TypeCodes.Int32, TypeCodes.Int64, TypeCodes.IntPtr, TypeCodes.UInt64];
    property IsInteger: Boolean read Code in [TypeCodes.SByte, TypeCodes.Int16, TypeCodes.Int32, TypeCodes.Int64, TypeCodes.Byte, TypeCodes.UInt16, TypeCodes.UInt32, TypeCodes.UInt64, TypeCodes.IntPtr, TypeCodes.UInt64];
    property IsIntegerOrFloat: Boolean read Code in [TypeCodes.SByte, TypeCodes.Int16, TypeCodes.Int32, TypeCodes.Int64, TypeCodes.Byte, TypeCodes.UInt16, TypeCodes.UInt32, TypeCodes.UInt64, TypeCodes.IntPtr, TypeCodes.UInt64, TypeCodes.Single, TypeCodes.Double];
    property IsFloat: Boolean read Code in [TypeCodes.Single, TypeCodes.Double];
    property IsEnum: Boolean read (&Flags and IslandTypeFlags.TypeKindMask) = IslandTypeFlags.EnumFlags;
    property IsDelegate: Boolean read (&Flags and IslandTypeFlags.TypeKindMask) = IslandTypeFlags.Delegate;
    property IsComInterface: Boolean read (IslandTypeFlags.TypeKindMask and fValue^.Ext^.Flags) = IslandTypeFlags.ComInterface;
    property IsCocoaClass: Boolean read (IslandTypeFlags.TypeKindMask and fValue^.Ext^.Flags) = IslandTypeFlags.CocoaClass;
    property IsSwiftClass: Boolean read (IslandTypeFlags.TypeKindMask and fValue^.Ext^.Flags) = IslandTypeFlags.SwiftClass;

    property ObjectModel: ObjectModel read -> begin
      var lFlags := fValue^.Ext^.Flags and IslandTypeFlags.TypeKindMask;
      case lFlags of
        IslandTypeFlags.CocoaClass: exit ObjectModel.Cocoa;
        IslandTypeFlags.SwiftClass: exit ObjectModel.Swift;
        IslandTypeFlags.ComInterface: exit ObjectModel.COM;
        else exit ObjectModel.Island;
      end;
    end;

    property DefFlags: TypeDefFlags read get_DefFlags;
    property SizeOfType: Integer read get_SizeOfType;
    property BoxedDataOffset: Integer read get_BoxedDataOffset;
    property SubType: &Type read get_SubType;

    method ToString: String; override;
    begin
      exit Name;
    end;

    class method TypeIsValueType(aType: ^IslandTypeInfo): Boolean;
    begin
      exit (aType^.Ext^.Flags and (IslandTypeFlags.TypeKindMask) in [IslandTypeFlags.Enum, IslandTypeFlags.EnumFlags, IslandTypeFlags.Struct, IslandTypeFlags.Pointer, IslandTypeFlags.Set]);
    end;

    property IsValueType: Boolean read TypeIsValueType(fValue);
    property BaseType: &Type read if fValue^.ParentType = nil then nil else new &Type(fValue^.ParentType);
    property Interfaces: sequence of &Type read get_Interfaces;
    property Attributes: sequence of CustomAttribute read get_Attributes;
    property NestedTypes: sequence of &Type read get_NestedTypes;
    property Members: sequence of MemberInfo read get_Members;
    property Methods: sequence of MethodInfo read get_Methods;
    property Fields: sequence of FieldInfo read get_Fields;
    property Constants: sequence of ConstantInfo read get_Constants;
    property Properties: sequence of PropertyInfo read get_Properties;
    property Events: sequence of EventInfo read get_Events;
    property GenericArguments: sequence of &Type read get_GenericArguments;
    property COMGuids: sequence of Guid read get_COMGuids;

    // Creates a new instance of this type and calls the default constructor, fails if none is present!
    method Instantiate<T>: Object; where T is ILifetimeStrategy<T>;
    begin
      var lCtor: MethodInfo := Methods.FirstOrDefault(a -> (MethodFlags.Constructor in a.Flags) and (not a.Arguments.Any) and (not a.IsStatic));
      if lCtor = nil then raise new Exception('No default constructor could be found on type '+Name);
      if IsValueType then begin
        var lRealCtor := VTCtorHelper(lCtor.Pointer);
        result := InternalCalls.Cast<Object>(T.New(fValue, SizeOfType + BoxedDataOffset - sizeOf(^Void)));
        if lRealCtor <> nil then begin
          lRealCtor(IntPtr(InternalCalls.Cast(result)) + BoxedDataOffset);
        end;
        exit;
      end;
      var lRealCtor := CtorHelper(lCtor.Pointer);
      if lRealCtor = nil then raise new Exception('No default constructor could be found!');
      result := InternalCalls.Cast<Object>(T.New(fValue, SizeOfType));
      lRealCtor(result);
    end;

    method Instantiate: Object; // Creates a new instance of this type and calls the default constructor, fails if none is present!
    begin
      exit Instantiate<DefaultGC>();
    end;

    method InstantiateArray(aSize: IntPtr): &Array;
    begin
      var lSub := new &Type(fValue^.Ext^.SubType);
      if (IslandTypeFlags.Generic not in fValue^.Ext^.Flags) or (lSub <> typeOf(Array<1>)) then
        raise new Exception('Can only call InstantiateArray on arrays');

      exit InternalCalls.Cast<&Array>(Utilities.NewArray(RTTI, if lSub.IsValueType then lSub.SizeOfType else sizeOf(^Void), aSize));
    end;

    method IsAssignableFrom(aOrg: &Type): Boolean;
    begin
      if aOrg = nil then exit false;
      if (self.Flags and IslandTypeFlags.TypeKindMask) = IslandTypeFlags.Interface then begin
        var b := aOrg;
        while b <> nil do begin
          if b = self then exit true;
          for each el in b.Interfaces do begin
            if IsAssignableFrom(el) then exit true;
          end;
          b := b.BaseType;
        end;
        var lAttrs := self.Attributes.Where(c->c.Type = typeOf(DynamicInterfaceAttribute)).ToList;
        for each lAttr in lAttrs do begin
          if (lAttr.Arguments[0].Value is String) and (String(lAttr.Arguments[0].Value) = aOrg.Name) then
            exit true;
        end;
        exit false;
      end else
        exit aOrg.IsSubclassOf(self);
    end;
  end;

end.