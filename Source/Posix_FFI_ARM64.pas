namespace RemObjects.Elements.System;
{$HIDE H7}
{$IFDEF ARM64}
type
  ARM64CallData = record
    _X0,               //  0
    _X1,               //  8
    _X2,               // 16
    _X3,               // 24
    _X4,               // 32
    _X5,               // 40
    _X6,               // 48
    _X7: NativeUInt;   // 56
    _V0,               // 64
    _V1,               // 72
    _V2,              // 80
    _V3,              // 88
    _V4,              // 96
    _V5,              // 104
    _V6,              // 112
    _V7: UInt64;      // 120
  end;




  ARM64InvokeFrame = record
    Address: ^Void;
    IntegerResult: ^NativeUInt;
    FloatResult: ^UInt64;
    Registers: ^ARM64CallData;
  end;

  // MethodInfo.Invoke uses this bridge to call native Island methods. Copy each
  // value to the register or stack position expected by the target method;
  // numerical conversion here would change the arguments supplied by the caller.
  FFI = public class
  private
    fStack: array of Byte;
    fCallData: ARM64CallData;
    fVarData: array of Object;
    fRegUsage: Byte;
    fRegUsageFloat: Byte;
    f_V0: UInt64;
    f_X0: NativeUInt;

    // Keep the frame and its unwind information under LLVM control, as in
    // the Windows ARM64 bridge. The previous naked frame stopped exceptions
    // crossing reflection calls. Stack arguments retain their existing packing.
    [DisableInlining, DisableOptimizations]
    class method DoCall(Address: ^Void; out _RAX: NativeUInt; [InReg] var data: ARM64CallData; Stack: ^Void; Items: NativeInt; var _XMM0: UInt64);
    begin
      var lFrame: ARM64InvokeFrame;
      lFrame.Address := Address;
      lFrame.IntegerResult := @_RAX;
      lFrame.FloatResult := @_XMM0;
      lFrame.Registers := @data;
      var lBytes := Items * 8;
      var lAllocation := InternalCalls.Alloca(lBytes + 15);
      var lStack := ^Byte((NativeUInt(lAllocation) + 15) and not NativeUInt(15));
      if lBytes > 0 then
        memcpy(lStack, ^Byte(NativeUInt(Stack) - NativeUInt(lBytes) + 16), lBytes);
      InternalCalls.VoidAsm("
        mov x21, sp
        mov sp, x20
        ldr x16, [x19, #24]
        ldr x17, [x19]
        ldp x0, x1, [x16]
        ldp x2, x3, [x16, #16]
        ldp x4, x5, [x16, #32]
        ldp x6, x7, [x16, #48]
        ldp d0, d1, [x16, #64]
        ldp d2, d3, [x16, #80]
        ldp d4, d5, [x16, #96]
        ldp d6, d7, [x16, #112]
        blr x17
        mov sp, x21
        ldr x1, [x19, #8]
        str x0, [x1]
        ldr x1, [x19, #16]
        str d0, [x1]
      ", "{x19},{x20},~{x0},~{x1},~{x2},~{x3},~{x4},~{x5},~{x6},~{x7},~{x8},~{x9},~{x10},~{x11},~{x12},~{x13},~{x14},~{x15},~{x16},~{x17},~{x18},~{x21},~{lr},~{v0},~{v1},~{v2},~{v3},~{v4},~{v5},~{v6},~{v7},~{v16},~{v17},~{v18},~{v19},~{v20},~{v21},~{v22},~{v23},~{v24},~{v25},~{v26},~{v27},~{v28},~{v29},~{v30},~{v31},~{cc},~{memory}", true, false, NativeUInt(@lFrame), NativeUInt(lStack));
    end;

    method PushBefore(aData: ^Void; aSize: Integer);
    begin
      var lStack := new array of Byte(length(fStack)+aSize);
      if length(fStack) > 0 then
        memcpy(@lStack[0], @fStack[0], length(fStack));
      if aData <> nil then
        memcpy(@lStack[length(fStack)], aData, aSize);
      fStack := lStack;
    end;

    // Apple packs stack arguments at their natural size/alignment. Other AAPCS64
    // targets reserve eight-byte slots. Register slots always hold raw bits.
    method PushArgument(aData: ^Void; aSize: Integer);
    begin
      {$IF DARWIN}
      var lPadding := (aSize - (length(fStack) mod aSize)) mod aSize;
      if lPadding > 0 then
        PushBefore(nil, lPadding);
      PushBefore(aData, aSize);
      {$ELSE}
      PushBefore(aData, 8);
      {$ENDIF}
    end;

    procedure StoreReg(data: UInt64; aSize: Integer := 8);
    begin
      case fRegUsage of
        0: begin inc(fRegUsage); fCallData._X0:=data; end;
        1: begin inc(fRegUsage); fCallData._X1:=data; end;
        2: begin inc(fRegUsage); fCallData._X2:=data; end;
        3: begin inc(fRegUsage); fCallData._X3:=data; end;
        4: begin inc(fRegUsage); fCallData._X4:=data; end;
        5: begin inc(fRegUsage); fCallData._X5:=data; end;
        6: begin inc(fRegUsage); fCallData._X6:=data; end;
        7: begin inc(fRegUsage); fCallData._X7:=data; end;
      else
        PushArgument(@data, aSize);
      end;
    end;

    procedure StoreRegFloat(aBits: UInt64; aSize: Integer);
    begin
      if fRegUsageFloat < 8 then begin
        ^UInt64(@fCallData._V0)[fRegUsageFloat] := aBits;
        inc(fRegUsageFloat);
      end
      else
        PushArgument(@aBits, aSize);
    end;

    procedure StoreRegDouble(data: Double);
    begin
      StoreRegFloat(^UInt64(@data)^, 8);
    end;

    procedure StoreRegSingle(data: Single);
    begin
      // Loading dN also loads its low sN half. Do not numerically widen a Single:
      // that changes the low bits, NaN payloads and the register's interpretation.
      StoreRegFloat(UInt64(^UInt32(@data)^), 4);
    end;

    method GetPtr64(aParamIndex: Integer; aParam: Object; aParamMode: ArgumentMode;aParamType: &Type);
    begin
      if aParamMode in [ArgumentMode.Out, ArgumentMode.Var] then begin
        //StoreReg(NativeUInt(@aParam));
        if aParamType.IsValueType then begin
          var lAlloc := DefaultGC.New(aParamType.RTTI, aParamType.SizeOfType + sizeOf(^Void)); // header
          if aParamMode = ArgumentMode.Out then
            memset(@(^^Void(lAlloc)[1]), 0, aParamType.SizeOfType)
          else
            memcpy(@(^^Void(lAlloc)[1]),@(^^Void(InternalCalls.Cast(aParam))[1]), aParamType.SizeOfType);
          StoreReg(UInt64(@(^^Void(lAlloc)[1])));
          fVarData[aParamIndex] := InternalCalls.Cast<Object>(lAlloc);
        end else begin
          fVarData[aParamIndex] := aParam;
          StoreReg(UInt64(@fVarData[aParamIndex]));
        end;
      end
      else case aParamType.Code of
          TypeCodes.Void: assert(false);
          TypeCodes.Boolean:  StoreReg(UInt64(Boolean(aParam)), 1);
          TypeCodes.AnsiChar: StoreReg(UInt64(AnsiChar(aParam)), 1);
          TypeCodes.Char:     StoreReg(UInt64(Char(aParam)), 2);
          TypeCodes.SByte:    StoreReg(UInt64(SByte(aParam)), 1);
          TypeCodes.Byte:     StoreReg(UInt64(Byte(aParam)), 1);
          TypeCodes.Int16:    StoreReg(UInt64(Int16(aParam)), 2);
          TypeCodes.UInt16:   StoreReg(UInt64(UInt16(aParam)), 2);
          TypeCodes.Int32:    StoreReg(UInt64(Int32(aParam)), 4);
          TypeCodes.UInt32:   StoreReg(UInt64(UInt32(aParam)), 4);
          TypeCodes.Int64:    StoreReg(UInt64(Int64(aParam)));
          TypeCodes.UInt64:   StoreReg(UInt64(UInt64(aParam)));
          TypeCodes.Double:   StoreRegDouble(Double(aParam));
          TypeCodes.Single:   StoreRegSingle(Single(aParam));
          TypeCodes.IntPtr:   StoreReg(UInt64(NativeInt(aParam)));
          TypeCodes.UIntPtr:  StoreReg(UInt64(NativeUInt(aParam)));
        else
          StoreReg(UInt64(InternalCalls.Cast(aParam)));
    //        // records
    //        // https://msdn.microsoft.com/en-us/library/zthk2dkh.aspx :
    //        // Structs/unions of size 8, 16, 32, or 64 bits and __m64 are passed as if they were integers of the same size.
    //        // Structs/unions other than these sizes are passed as a pointer to memory allocated by the caller.
    //        case sizeOf(aParam) of
    //          1: StoreReg64(NativeUInt(Byte(aParam)));
    //          2: StoreReg64(NativeUInt(UInt16(aParam)));
    //          4: StoreReg64(NativeUInt(UInt32(aParam)));
    //          8: StoreReg64(NativeUInt(aParam));
    //        else
    //          // pointer
    //          StoreReg64(NativeUInt(@aParam));
    //        end;
    //      end;
        end;
    end;

    constructor; empty;
  public
    class method Call(
      aAddress: ^Void;
      aCallingConv: CallingConvention;
      var aParams: array of Object;
      aParameterFlags: array of ArgumentMode;
      aParameterTypes: array of &Type;
      aResultType: &Type): Object;
      begin
        if aAddress = nil then raise new ArgumentException('Address'); // need address
        var lInst := new FFI;
        lInst.fStack := [];
        lInst.f_V0 := 0;
        lInst.f_X0 := 0;
        lInst.fRegUsage :=0;
        lInst.fRegUsageFloat := 0;
        for I:Integer := 0 to length(aParams) - 1 do begin
          if (lInst.fVarData = nil) and (aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out]) then lInst.fVarData := new Object[length(aParams)];
          lInst.GetPtr64(I, aParams[I], aParameterFlags[I],  aParameterTypes[I]);
        end;
        var pp: ^Byte;
        if (length(lInst.fStack) > 0) and ((length(lInst.fStack) mod 16 ≠ 0)) then
          lInst.PushBefore(nil, 16 - (length(lInst.fStack) mod 16)); // align the whole outgoing stack
        if length(lInst.fStack) = 0 then pp := nil else pp := @lInst.fStack[length(lInst.fStack)-16]; // -16: move two 64bits data back, since in asm code we move in pairs
        DoCall(aAddress,out lInst.f_X0,var lInst.fCallData, pp, length(lInst.fStack) div 8, var lInst.f_V0);
        if lInst.fVarData <> nil then begin
          for I: Integer := 0 to length(aParams) - 1 do begin
            if aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out] then begin
              aParams[I] := lInst.fVarData[I];
            end
          end;
        end;

        if assigned(aResultType) then begin
          case (aResultType.Code) of
            TypeCodes.Single:   exit ^Single(@lInst.f_V0)^;
            TypeCodes.Double:   exit ^Double(@lInst.f_V0)^;
            TypeCodes.Byte:     exit Byte(lInst.f_X0);
            TypeCodes.Boolean:  exit Boolean(lInst.f_X0);
            TypeCodes.SByte:    exit SByte(lInst.f_X0);
            TypeCodes.AnsiChar: exit AnsiChar(lInst.f_X0);
            TypeCodes.Int16:    exit Int16(lInst.f_X0);
            TypeCodes.UInt16:   exit UInt16(lInst.f_X0);
            TypeCodes.Char:     exit Char(lInst.f_X0);
            TypeCodes.Int32:    exit Int32(lInst.f_X0);
            TypeCodes.UInt32:   exit UInt32(lInst.f_X0);
            TypeCodes.IntPtr:   exit NativeInt(lInst.f_X0);
            TypeCodes.UIntPtr:  exit NativeUInt(lInst.f_X0);
            TypeCodes.Int64:    exit Int64(lInst.f_X0);
            TypeCodes.UInt64:   exit UInt64(lInst.f_X0);
          else
            exit InternalCalls.Cast<Object>(^Void(lInst.f_X0));
          end;
        end;
      end;
  end;
{$ENDIF ARM64}
end.