namespace RemObjects.Elements.System;
{$HIDE H7}
{$IFDEF cpu64}
type
  X64CallData = record
    _RDI,               //  0
    _RSI,               //  8
    _RDX,               // 16
    _RCX,               // 24
    _R8,                // 32
    _R9: NativeUInt;    // 40
    _XMM1,              // 48
    _XMM2,              // 56
    _XMM3,              // 64
    _XMM4,              // 72
    _XMM5,              // 80
    _XMM6,              // 88
    _XMM7: Double;      // 96
    SingleBits: Integer; //104
  end;




  FFI = public class
  private
    fStack: array of Byte;
    fCallData: X64CallData;
    fVarData: array of Object;
    fRegUsage: Byte;
    fRegUsageFloat: Byte;
    f_XMM0: Double;
    f_RAX: NativeUInt;

    [InlineAsm("
      // Registers:
      //    RDI: Address
      //    RSI: _RAX
      //    RDX: Registers
      //    RCX: aStack
      //    R8:  aItems
      //    R9:  XMM0
      //
      //    rbp-8    addr
      //    rbp-16   _rax
      //    rbp-24   _xmm0
      //    rbp-32   regs
      pushq %rbp          //push rbp
      movq %rsp, %rbp     //mov rbp,rsp

      pushq %rdi          //  push rdi  // address
      pushq %rsi          //  push rsi  // _rax
      pushq %r9           //  push r9   // xmm0
      pushq %rdx          //  push rdx

      movq %rdx, %rax     //mov rax, rdx
      jmp compareitems
  work:
      pushq (%rcx)        //push [rcx]

      decq %r8            //dec r8
      subq $$8,%rcx       //sub rcx,8
     
  compareitems:
      or %r8, %r8         //or r8, r8
      jnz work

                             // copy registers
                             // xmm0
      movq -24(%rbp), %rdx   //mov rdx,[rbp-24]

      btq $$0, 104(%rax)     //bt [rax+104], 0
      jnc skipxmm0
      cvtsd2ss (%rdx), %xmm0 //cvtsd2ss xmm0,[rdx]
      jmp skipxmm0re
  skipxmm0:
      movq (%rdx), %xmm0     //movq xmm0,[rdx]            // move quadword to xmm0 from _XMM0
  skipxmm0re:

                              // xmm1
      btq $$1, 104(%rax)     //bt [rax+104], 1
      jnc skipxmm1
      cvtsd2ss 48(%rax), %xmm1 //cvtsd2ss xmm1,[rax+48]
      jmp skipxmm1re
  skipxmm1:
      movq 48(%rax), %xmm1        //movq xmm1,[rax+48]         // move quadword to xmm1 from Registers._XMM1
  skipxmm1re:

                                  // xmm2
      btq $$2, 104(%rax)          //bt [rax+104], 2
      jnc skipxmm2
      cvtsd2ss 56(%rax), %xmm2    //cvtsd2ss xmm2,[rax+56]
      jmp skipxmm2re
  skipxmm2:
      movq 56(%rax), %xmm2        //movq xmm2,[rax+56]         // move quadword to xmm2 from Registers._XMM2
  skipxmm2re:

                                  // xmm3
      btq $$3, 104(%rax)          //bt [rax+104], 3
      jnc skipxmm3
      cvtsd2ss 64(%rax), %xmm3    //cvtsd2ss xmm3,[rax+64]
      jmp skipxmm3re
  skipxmm3:
      movq 64(%rax), %xmm3        //movq xmm3,[rax+64]         // move quadword to xmm3 from Registers._XMM3
  skipxmm3re:

                                  // xmm4
      btq $$4, 104(%rax)          //bt [rax+104], 4
      jnc skipxmm4
      cvtsd2ss 72(%rax), %xmm4    //cvtsd2ss xmm4,[rax+72]
      jmp skipxmm4re
  skipxmm4:
      movq 72(%rax), %xmm4        //movq xmm4,[rax+72]         // move quadword to xmm4 from Registers._XMM4
  skipxmm4re:

                                  // xmm5
      btq $$5, 104(%rax)          //bt [rax+104], 5
      jnc skipxmm5
      cvtsd2ss 80(%rax), %xmm5    //cvtsd2ss xmm5,[rax+80]
      jmp skipxmm5re
  skipxmm5:
      movq 80(%rax), %xmm5        //movq xmm5,[rax+80]         // move quadword to xmm5 from Registers._XMM5
  skipxmm5re:

                                  // xmm6
      btq $$6, 104(%rax)          //bt [rax+104], 6
      jnc skipxmm6
      cvtsd2ss 88(%rax), %xmm6    //cvtsd2ss xmm6,[rax+88]
      jmp skipxmm6re
  skipxmm6:
      movq 88(%rax), %xmm6        //movq xmm6,[rax+88]         // move quadword to xmm6 from Registers._XMM6
  skipxmm6re:

                                  // xmm7
      btq $$7, 104(%rax)          //bt [rax+104], 7
      jnc skipxmm7
      cvtsd2ss 96(%rax), %xmm7    //cvtsd2ss xmm7,[rax+96]
      jmp skipxmm7re
  skipxmm7:
      movq 96(%rax), %xmm7        //movq xmm7,[rax+96]         // move quadword to xmm7 from Registers._XMM7
  skipxmm7re:


      movq   (%rax), %rdi         //mov RDI, [rax]
      movq  8(%rax), %rsi         //mov RSI, [rax+ 8]
      movq 16(%rax), %rdx         //mov RDX, [rax+16]
      movq 24(%rax), %rcx         //mov RCX, [rax+24]
      movq 32(%rax), %r8          //mov R8,  [rax+32]
      movq 40(%rax), %r9          //mov R9,  [rax+40]

      mov -8(%rbp), %rax          //mov rax, [rbp-8]
      callq *%rax                 //call RAX

                                  // copy result back
      movq -16(%rbp), %rsi        //mov rsi, [rbp-16]          // _RAX parameter
      movq %rax, (%rsi)           //mov [rsi], RAX
      movq -24(%rbp), %rsi        //mov rsi, [rbp-24]          // _XMM0 parameter

                                  // xmm0 res
      movq -32(%rbp), %rax        //mov rax, [rbp-32]          // Registers parameter
      btq $$8, 104(%rax)         //bt [rax+104], 8            // if atype.basetype  <> btSingle
      jnc skipres               // then goto skipres else begin
      cvtss2sd %xmm0, %xmm1      //cvtss2sd xmm1,xmm0         // convert single to double  into xmm1
      movq %xmm1, (%rsi)         //movq [rsi],xmm1            // move quadword to _XMM0
      jmp skipresre             // end
  skipres:
      movq %xmm0, (%rsi)         //movq [rsi],xmm0            // move quadword to _XMM0
  skipresre:


      popq %rdx                  //pop rdx
      popq %r9                   //pop r9   // xmm0
      popq %rsi                  //pop rsi  // _rax
      popq %rdi                  //pop rdi  // address
      leave
      retq          //ret
    ", "", false, false), DisableInlining, DisableOptimizations]
    class method DoCall(Address: ^Void;out _RAX: NativeUInt;[InReg]var data: X64CallData; Stack: ^Void; Items: NativeInt;var _XMM0: Double); external;

    method PushBefore(aData: ^Void; aSize: Integer);
    begin
      var lStack := new array of Byte(length(fStack)+aSize);
      if length(fStack) > 0 then
        memcpy(@lStack[0], @fStack[0], length(fStack));
      if aData <> nil then
        memcpy(@lStack[length(fStack)], aData, aSize);
      fStack := lStack;
    end;

    procedure StoreReg(data: UInt64);
    begin
      case fRegUsage of
        0: begin inc(fRegUsage); fCallData._RDI:=data; end;
        1: begin inc(fRegUsage); fCallData._RSI:=data; end;
        2: begin inc(fRegUsage); fCallData._RDX:=data; end;
        3: begin inc(fRegUsage); fCallData._RCX:=data; end;
        4: begin inc(fRegUsage); fCallData._R8:=data; end;
        5: begin inc(fRegUsage); fCallData._R9:=data; end;
      else
        PushBefore(@data,8);
      end;
    end;

    procedure StoreRegDouble(data: Double);
    begin
      case fRegUsageFloat of
        0: begin inc(fRegUsageFloat); f_XMM0:=data; end;
        1: begin inc(fRegUsageFloat); fCallData._XMM1:=data; end;
        2: begin inc(fRegUsageFloat); fCallData._XMM2:=data; end;
        3: begin inc(fRegUsageFloat); fCallData._XMM3:=data; end;
        4: begin inc(fRegUsageFloat); fCallData._XMM4:=data; end;
        5: begin inc(fRegUsageFloat); fCallData._XMM5:=data; end;
        6: begin inc(fRegUsageFloat); fCallData._XMM6:=data; end;
        7: begin inc(fRegUsageFloat); fCallData._XMM7:=data; end;
      else
        PushBefore(@data,8);
      end;
    end;

    procedure StoreRegSingle(data: Single);
    begin
      case fRegUsageFloat of
        0: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 1;   f_XMM0:=data; end;
        1: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 2;   fCallData._XMM1:=data; end;
        2: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 4;   fCallData._XMM2:=data; end;
        3: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 8;   fCallData._XMM3:=data; end;
        4: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 16;  fCallData._XMM4:=data; end;
        5: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 32;  fCallData._XMM5:=data; end;
        6: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 64;  fCallData._XMM6:=data; end;
        7: begin inc(fRegUsageFloat); fCallData.SingleBits := fCallData.SingleBits or 128; fCallData._XMM7:=data; end;
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
        lInst.fRegUsageFloat := 0;
        if assigned(aResultType) and (TypeCodes(aResultType.Code) = (TypeCodes.Single)) then begin
          lInst.fCallData.SingleBits  := lInst.fCallData.SingleBits or 256;
        end;
        for I:Integer := 0 to length(aParams) - 1 do begin
          if (lInst.fVarData = nil) and (aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out]) then lInst.fVarData := new Object[length(aParams)];
          lInst.GetPtr64(I, aParams[I], aParameterFlags[I],  aParameterTypes[I]);
        end;
        var pp: ^Byte;
        if length(lInst.fStack) = 0 then pp := nil else pp := @lInst.fStack[length(lInst.fStack)-8];
        DoCall(aAddress,out  lInst.f_RAX,var lInst.fCallData, pp, length(lInst.fStack) div 8, var lInst.f_XMM0);
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
            TypeCodes.Boolean:  exit Boolean(lInst.f_RAX);
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
{$ENDIF cpu64}
end.
