namespace RemObjects.Elements.System;
{$IFDEF ARM64}
type
  WindowsARM64CallData = record
    X0, X1, X2, X3, X4, X5, X6, X7: UInt64;
    D0, D1, D2, D3, D4, D5, D6, D7: UInt64;
    IndirectResult: ^Void;
    Address: ^Void;
    ResultX0, ResultX1: UInt64;
    ResultD0, ResultD1, ResultD2, ResultD3: UInt64;
  end;

  // MethodInfo.Invoke supplies boxed arguments. Marshal their bits according to
  // the Windows ARM64 ABI, independently allocating integer and FP registers.
  FFI = public class
  private
    fData: WindowsARM64CallData;
    fStack: array of Byte := [];
    fIntegerRegister, fFloatRegister: Integer;
    fCopies: array of Object;

    [DisableInlining, DisableOptimizations]
    class method DoCall(var aData: WindowsARM64CallData; aStack: array of Byte);
    begin
      // Let LLVM allocate/probe the stack and emit Windows unwind information.
      // A naked hand-written frame would prevent exceptions crossing Invoke.
      var lAllocation := InternalCalls.Alloca(length(aStack) + 15);
      var lStack := ^Byte((NativeUInt(lAllocation) + 15) and not NativeUInt(15));
      if length(aStack) > 0 then
        memcpy(lStack, @aStack[0], length(aStack));
      InternalCalls.VoidAsm("
        mov x21, sp
        mov sp, x20
        ldr x16, [x19, #136]
        ldr x8, [x19, #128]
        ldp x0, x1, [x19]
        ldp x2, x3, [x19, #16]
        ldp x4, x5, [x19, #32]
        ldp x6, x7, [x19, #48]
        ldp d0, d1, [x19, #64]
        ldp d2, d3, [x19, #80]
        ldp d4, d5, [x19, #96]
        ldp d6, d7, [x19, #112]
        blr x16
        mov sp, x21
        stp x0, x1, [x19, #144]
        stp d0, d1, [x19, #160]
        stp d2, d3, [x19, #176]
      ", "{x19},{x20},~{x0},~{x1},~{x2},~{x3},~{x4},~{x5},~{x6},~{x7},~{x8},~{x9},~{x10},~{x11},~{x12},~{x13},~{x14},~{x15},~{x16},~{x17},~{x21},~{lr},~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31},~{cc},~{memory}", true, false, NativeUInt(@aData), NativeUInt(lStack));
    end;

    method Push(aData: ^Void; aSize: Integer);
    begin
      var lSize := (aSize + 7) and not 7;
      var lStack := new array of Byte(length(fStack) + lSize);
      if length(fStack) > 0 then
        memcpy(@lStack[0], @fStack[0], length(fStack));
      if aSize > 0 then
        memcpy(@lStack[length(fStack)], aData, aSize);
      fStack := lStack;
    end;

    method IntegerArgument(aBits: UInt64);
    begin
      if fIntegerRegister < 8 then begin
        ^UInt64(@fData.X0)[fIntegerRegister] := aBits;
        inc(fIntegerRegister);
      end
      else
        Push(@aBits, 8);
    end;

    method FloatArgument(aBits: UInt64);
    begin
      if fFloatRegister < 8 then begin
        ^UInt64(@fData.D0)[fFloatRegister] := aBits;
        inc(fFloatRegister);
      end
      else
        Push(@aBits, 8);
    end;

    class method DataPointer(aValue: Object; aType: &Type): ^Byte;
    begin
      exit ^Byte(InternalCalls.Cast(aValue)) + aType.BoxedDataOffset;
    end;

    class method NewValue(aType: &Type): Object;
    begin
      exit InternalCalls.Cast<Object>(DefaultGC.New(aType.RTTI,
        aType.SizeOfType + aType.BoxedDataOffset));
    end;

    // An HFA has one to four contiguous fields of the same floating-point type.
    // Check offsets and total size as well as types; padding is not an FP field.
    class method FloatAggregate(aType: &Type; out aCode: TypeCodes): Integer;
    begin
      aCode := TypeCodes.None;
      if not aType.IsValueType or aType.IsEnum then
        exit 0;
      var lBytes := 0;
      for each lField in aType.Fields do begin
        if lField.IsStatic then
          continue;
        if lField.InstanceOffset <> lBytes then
          exit 0;
        var lCode := lField.Type.Code;
        var lCount := 1;
        if lCode not in [TypeCodes.Single, TypeCodes.Double] then
          lCount := FloatAggregate(lField.Type, out lCode);
        if (lCount = 0) or ((aCode <> TypeCodes.None) and (aCode <> lCode)) then
          exit 0;
        aCode := lCode;
        inc(result, lCount);
        inc(lBytes, lField.Type.SizeOfType);
      end;
      if (result > 4) or (lBytes <> aType.SizeOfType) then
        exit 0;
    end;

    class method UniformFieldType(aType: &Type): &Type;
    begin
      if not aType.IsStruct or (aType.Code not in [TypeCodes.None, TypeCodes.Object]) then
        exit aType;
      for each lField in aType.Fields do begin
        if lField.IsStatic then
          continue;
        var lType := UniformFieldType(lField.Type);
        if not assigned(lType) then
          exit nil;
        if not assigned(result) then
          result := lType
        else if result <> lType then
          exit nil;
      end;
    end;

    method Argument(aIndex: Integer; aValue: Object; aMode: ArgumentMode; aType: &Type);
    begin
      if (aMode <> ArgumentMode.Out) and assigned(aValue) and
        (Utilities.IsInstance(aValue, aType.RTTI) = nil) then
        raise new ArgumentException('Argument is not compatible with its parameter type');
      if aMode in [ArgumentMode.Var, ArgumentMode.Out] then begin
        if aType.IsValueType then begin
          fCopies[aIndex] := NewValue(aType);
          if (aMode <> ArgumentMode.Out) and assigned(aValue) then
            memcpy(DataPointer(fCopies[aIndex], aType), DataPointer(aValue, aType), aType.SizeOfType);
          IntegerArgument(UInt64(DataPointer(fCopies[aIndex], aType)));
        end
        else begin
          if aMode <> ArgumentMode.Out then
            fCopies[aIndex] := aValue;
          IntegerArgument(UInt64(@fCopies[aIndex]));
        end;
        exit;
      end;
      if not aType.IsValueType then begin
        IntegerArgument(UInt64(InternalCalls.Cast(aValue)));
        exit;
      end;
      if not assigned(aValue) then
        raise new ArgumentException('A value argument cannot be nil');
      var lPointer := DataPointer(aValue, aType);
      var lSize := aType.SizeOfType;
      var lBits: UInt64 := 0;
      case aType.Code of
        TypeCodes.Single, TypeCodes.Double: begin
          memcpy(@lBits, lPointer, lSize);
          FloatArgument(lBits);
          exit;
        end;
      end;
      var lCode: TypeCodes;
      var lCount := FloatAggregate(aType, out lCode);
      if lCount > 0 then begin
        // Elements AARCH64ABI flattens HFA arguments into scalar parameters.
        // Each scalar independently takes an FP register or an eight-byte slot.
        var lElementSize := if lCode = TypeCodes.Single then 4 else 8;
        for i := 0 to lCount - 1 do begin
          lBits := 0;
          memcpy(@lBits, lPointer + i*lElementSize, lElementSize);
          FloatArgument(lBits);
        end;
        exit;
      end;
      if lSize > 16 then begin
        // Large value arguments are passed through a caller-owned copy.
        fCopies[aIndex] := NewValue(aType);
        memcpy(DataPointer(fCopies[aIndex], aType), lPointer, lSize);
        IntegerArgument(UInt64(DataPointer(fCopies[aIndex], aType)));
        exit;
      end;
      lCount := (lSize + 7) div 8;
      // Elements lowers a uniform small record into independent i64 parameters;
      // a mixed record remains one LLVM aggregate and cannot straddle the boundary.
      if (fIntegerRegister + lCount <= 8) or assigned(UniformFieldType(aType)) then begin
        for i := 0 to lCount - 1 do begin
          lBits := 0;
          memcpy(@lBits, lPointer + i*8, if lSize - i*8 < 8 then lSize - i*8 else 8);
          IntegerArgument(lBits);
        end;
      end
      else begin
        fIntegerRegister := 8;
        Push(lPointer, lSize);
      end;
    end;

  public

    class method Call(aAddress: ^Void; aCallingConv: CallingConvention;
      var aParams: array of Object; aParameterFlags: array of ArgumentMode;
      aParameterTypes: array of &Type; aResultType: &Type): Object;
    begin
      if aAddress = nil then
        raise new ArgumentException('Address');
      var lCall := new FFI;
      lCall.fData.Address := aAddress;
      lCall.fCopies := new array of Object(length(aParams));
      var lResultCode := TypeCodes.Void;
      var lResultCount := 0;
      var lResultSize := 0;
      if assigned(aResultType) and (aResultType.Code <> TypeCodes.Void) then begin
        lResultCode := aResultType.Code;
        if aResultType.IsValueType then begin
          result := NewValue(aResultType);
          lResultSize := aResultType.SizeOfType;
          lResultCount := FloatAggregate(aResultType, out lResultCode);
          if (lResultCount = 0) and (lResultSize > 16) then
            lCall.fData.IndirectResult := DataPointer(result, aResultType);
        end;
      end;
      for i := 0 to length(aParams) - 1 do
        lCall.Argument(i, aParams[i], aParameterFlags[i], aParameterTypes[i]);
      // Windows stack arguments use eight-byte slots; the total is 16-byte aligned.
      if length(lCall.fStack) mod 16 <> 0 then begin
        var lZero: UInt64 := 0;
        lCall.Push(@lZero, 8);
      end;
      try
        DoCall(var lCall.fData, lCall.fStack);
      finally
        for i := 0 to length(aParams) - 1 do
          if aParameterFlags[i] in [ArgumentMode.Var, ArgumentMode.Out] then
            aParams[i] := lCall.fCopies[i];
      end;
      if not assigned(aResultType) or (aResultType.Code = TypeCodes.Void) then
        exit;
      if not aResultType.IsValueType then
        exit InternalCalls.Cast<Object>(^Void(lCall.fData.ResultX0));
      var lDestination := DataPointer(result, aResultType);
      if aResultType.Code in [TypeCodes.Single, TypeCodes.Double] then
        memcpy(lDestination, @lCall.fData.ResultD0, lResultSize)
      else if lResultCount > 0 then begin
        var lElementSize := if lResultCode = TypeCodes.Single then 4 else 8;
        for i := 0 to lResultCount - 1 do
          memcpy(lDestination + i*lElementSize, @(^UInt64(@lCall.fData.ResultD0)[i]), lElementSize);
      end
      else if lResultSize <= 16 then
        memcpy(lDestination, @lCall.fData.ResultX0, lResultSize);
    end;

  end;
{$ENDIF}
end.