namespace RemObjects.Elements.System;
{$IFDEF _WIN64}
{$HIDE H7}
type
  X64CallData = record
    _RCX,                  // 0
    _RDX,                  // 8
    _R8,                   // 16
    _R9: NativeUInt;          // 24
    _XMM1,                 // 32
    _XMM2,                 // 40
    _XMM3: Double;         // 48
    Stack: ^Void;          // 56
    Items: NativeInt;         // 64
    SingleBits: Integer;   // 72
  end;

  FFI = public class
  private
    fStack: array of Byte;
    fCallData: X64CallData;
    fVarData: array of Object;
    fRegUsage: Byte;
    f_XMM0: Double;
    f_RAX: NativeUInt;

    [InlineAsm("
      // Registers:
      // RCX: Address
      // RDX: *_RAX
      // R8:  * _XMM0
      // R9: _REGISTERS
      pushq %rbp          //push rbp
      movq %rsp, %rbp     //mov rbp,rsp


      pushq %rcx           //push rcx  // address         ;rbp -8
      pushq %rdx           //push rdx  // @_rax           ;rbp -16
      pushq %r8            //push r8   // @_xmm0          ;rbp -24
      pushq %r9            //push r9   // _registers      ;rbp -32

      movq -32(%rbp), %rax //mov rax, [rbp-32] //registers

      movq  64(%rax), %rcx //mov rcx, [rax+64] // items/count
      movq  56(%rax), %rdx //mov rdx, [rax+56] // stack
          jmp compareitems
        work:
      pushq (%rdx)          //push [rdx]
      decq %rcx             //dec rcx
      subq $$8,%rdx         //sub rdx,8
        compareitems:
      or %rcx, %rcx         //or rcx, rcx
          jnz work

          // copy registers
      movq  72(%rax), %rcx  //mov rcx, [rax+72] // single bits

      btq $$1, %rcx         //bt rcx, 1
          jnc g1
      cvtsd2ss 32(%rax),%xmm1 //cvtsd2ss xmm1, [rax+32]
          jmp g1e
          g1:
      movsd 32(%rax),%xmm1    //movsd xmm1, [rax+32]
          g1e:

      btq $$2, %rcx           //bt rcx, 2
          jnc g2
      cvtsd2ss 40(%rax), %xmm2  //cvtsd2ss xmm2, [rax+40]
          jmp g2e
          g2:
      movsd 40(%rax),%xmm2     //movsd xmm2, [rax+40]
          g2e:

      btq $$3, %rcx    //bt rcx, 3
          jnc g3
      cvtsd2ss  48(%rax), %xmm3 //cvtsd2ss xmm3, [rax+48]
          jmp g3e
          g3:
      movsd 48(%rax),%xmm3    //movsd xmm3, [rax+48]
          g3e:
          // rbp-16: address of xmm0
      btq $$0, %rcx    //bt rcx, 0
          jnc g0
      movq  -24(%rbp),%rdx    //mov rdx, [rbp -24]
      cvtsd2ss (%rdx),%xmm0    //cvtsd2ss xmm0, [rdx]
          jmp g0e
          g0:
      movq -24(%rbp),%rdx    //mov rdx, [rbp -24]
      movsd   (%rdx),%xmm0    //movsd xmm0, [rdx]
          g0e:

          // other registers
      movq   (%rax), %rcx     //mov rcx, [rax]
      movq  8(%rax), %rdx     //mov rdx, [rax+8]
      movq 16(%rax), %r8      //mov r8, [rax+16]
      movq 24(%rax), %r9      //mov r9, [rax+24]

      movq -8(%rbp), %rax     //mov RAX, [rbp-8]

                              // weird thing on windows, it needs 32 bytes in the CALLEE side to do whatever in
      subq  $$32, %rsp        //sub RSP, 32
      callq *%rax             //call RAX
      addq  $$32, %rsp        //add RSP, 32 // undo the damage done earlier

          // copy result back
      movq  -16(%rbp), %rdx    //mov RDX, [rbp-16]
      movq %rax,(%rdx)         //mov [RDX], RAX
      movq -32(%rbp),%rax      //mov rax, [rbp-32] //registers

      btq $$8, 72(%rax)        //bt [rax+72], 8                 // if atype.basetype  <> btSingle
          jnc g5                        //
      cvtss2sd %xmm0,%xmm1     //cvtss2sd xmm1,xmm0             // convert single to double  into xmm1
      movq -24(%rbp), %rdx     //mov rdx,[rbp-24]               // @_xmm0  ;rbp -24
      movsd %xmm1, (%rdx)      //movsd qword ptr [rdx], xmm1    // save  xmm1 to param _xmm0
          jmp g5e                       // exit if atype.basetype  = btSingle

          g5:                           //else if atype.basetype  = btSingle
      movq -24(%rbp), %rdx     //mov rdx,[rbp-24]             // @_xmm0  ;rbp -24
      movsd %xmm0, (%rdx)      //movsd qword ptr [rdx], xmm0  // save  xmm1 to param _xmm0

      g5e:
   leave//   popq %rbp     //leave
      retq          //ret
    ", "", false, false), DisableInlining, DisableOptimizations]
    class method DoCall(Address: ^Void;out _RAX: NativeUInt;var _XMM0: Double;[InReg]var data: X64CallData); external;

    method PushBefore(aData: ^Void; aSize: Integer);
    begin
      var lStack := new array of Byte(length(fStack)+aSize);
      if length(fStack) > 0 then
        ExternalCalls.memcpy(@lStack[0], @fStack[0], length(fStack));
      if aData <> nil then
        ExternalCalls.memcpy(@lStack[length(fStack)], aData, aSize);
      fStack := lStack;
    end;

    procedure StoreReg(data: UInt64);
    begin
      case fRegUsage of
        0: begin inc(fRegUsage); fCallData._RCX:=data; end;
        1: begin inc(fRegUsage); fCallData._RDX:=data; end;
        2: begin inc(fRegUsage); fCallData._R8:=data; end;
        3: begin inc(fRegUsage); fCallData._R9:=data; end;
      else
        PushBefore(@data,8);
      end;
    end;

    procedure StoreRegDouble(data: Double);
    begin
      case fRegUsage of
        0: begin inc(fRegUsage); f_XMM0:=data; end;
        1: begin inc(fRegUsage); fCallData._XMM1:=data; end;
        2: begin inc(fRegUsage); fCallData._XMM2:=data; end;
        3: begin inc(fRegUsage); fCallData._XMM3:=data; end;
      else
        PushBefore(@data,8);
      end;
    end;

    procedure StoreRegSingle(data: Single);
    begin
      case fRegUsage of
        0: begin inc(fRegUsage); fCallData.SingleBits := fCallData.SingleBits or 1; f_XMM0:=data; end;
        1: begin inc(fRegUsage); fCallData.SingleBits := fCallData.SingleBits or 2; fCallData._XMM1:=data; end;
        2: begin inc(fRegUsage); fCallData.SingleBits := fCallData.SingleBits or 4; fCallData._XMM2:=data; end;
        3: begin inc(fRegUsage); fCallData.SingleBits := fCallData.SingleBits or 8; fCallData._XMM3:=data; end;
      else
        var temp: Double := Double(data);
        PushBefore(@temp,8);
      end;
    end;

    method GetPtr64(aParamIndex: Integer; aParam: Object; aParamMode: ArgumentMode;aParamType: &Type);
    begin
      if aParamMode in [ArgumentMode.Out, ArgumentMode.Var] then begin
        //StoreReg(NativeUInt(@aParam));
        if aParamType.IsValueType then begin
          var lAlloc := Utilities.NewInstance(aParamType.RTTI, aParamType.SizeOfType + sizeOf(^Void)); // header
          ExternalCalls.memcpy(@(^^Void(lAlloc)[1]),@(^^Void(InternalCalls.Cast(aParam))[1]), aParamType.SizeOfType);
          StoreReg(UInt64(@(^^Void(lAlloc)[1])));
          fVarData[aParamIndex] := InternalCalls.Cast<Object>(lAlloc);
        end else begin
          fVarData[aParamIndex] := aParam;
          StoreReg(UInt64(@fVarData[aParamIndex]));
        end;
      end
      else case aParamType.Code of
          TypeCodes.Void: assert(false);
          TypeCodes.Boolean:  StoreReg(UInt64(Boolean(aParam)));
          TypeCodes.AnsiChar: StoreReg(UInt64(AnsiChar(aParam)));
          TypeCodes.Char:     StoreReg(UInt64(Char(aParam)));
          TypeCodes.SByte:    StoreReg(UInt64(SByte(aParam)));
          TypeCodes.Byte:     StoreReg(UInt64(Byte(aParam)));
          TypeCodes.Int16:    StoreReg(UInt64(Int16(aParam)));
          TypeCodes.UInt16:   StoreReg(UInt64(UInt16(aParam)));
          TypeCodes.Int32:    StoreReg(UInt64(Int32(aParam)));
          TypeCodes.UInt32:   StoreReg(UInt64(UInt32(aParam)));
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
        lInst.f_XMM0 := 0;
        lInst.f_RAX := 0;
        lInst.fRegUsage :=0;
        if assigned(aResultType) and (TypeCodes(aResultType.Code) = (TypeCodes.Single)) then begin
          lInst.fCallData.SingleBits  := lInst.fCallData.SingleBits or 256;
        end;
        for I:Integer := 0 to length(aParams) - 1 do begin
          if (lInst.fVarData = nil) and (aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out]) then lInst.fVarData := new Object[length(aParams)];
          lInst.GetPtr64(I, aParams[I], aParameterFlags[I],  aParameterTypes[I]);
        end;
        if (length(lInst.fStack) mod 16) <> 0 then
          lInst.PushBefore(nil, 16 - (length(lInst.fStack) mod 16));
        var pp: ^Byte;
        if lInst.fStack = nil then pp := nil else pp := @lInst.fStack[length(lInst.fStack)-8];
        lInst.fCallData.Stack := pp;
        lInst.fCallData.Items := length(lInst.fStack) div 8;
        DoCall(aAddress,out  lInst.f_RAX,var lInst.f_XMM0,var lInst.fCallData);
        if lInst.fVarData <> nil then begin
          for I: Integer := 0 to length(aParams) - 1 do begin
            if aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out] then begin
              aParams[I] := lInst.fVarData[I];
            end
          end;
        end;

        if assigned(aResultType) then begin
          case (aResultType.Code) of
            TypeCodes.Single:   exit Single(lInst.f_XMM0);
            TypeCodes.Double:   exit Double(lInst.f_XMM0);
            TypeCodes.Byte:     exit Byte(lInst.f_RAX);
            TypeCodes.SByte:    exit SByte(lInst.f_RAX);
            TypeCodes.AnsiChar: exit AnsiChar(lInst.f_RAX);
            TypeCodes.Int16:    exit Int16(lInst.f_RAX);
            TypeCodes.UInt16:   exit UInt16(lInst.f_RAX);
            TypeCodes.Char:     exit Char(lInst.f_RAX);
            TypeCodes.Int32:    exit Int32(lInst.f_RAX);
            TypeCodes.UInt32:   exit UInt32(lInst.f_RAX);
            TypeCodes.IntPtr:   exit NativeInt(lInst.f_RAX);
            TypeCodes.UIntPtr:  exit NativeUInt(lInst.f_RAX);
            TypeCodes.Int64:    exit Int64(lInst.f_RAX);
            TypeCodes.UInt64:   exit UInt64(lInst.f_RAX);
          else
            exit InternalCalls.Cast<Object>(^Void(lInst.f_RAX));
          end;
        end;
      end;
  end;

{$ENDIF}
end.
