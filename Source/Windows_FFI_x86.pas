namespace RemObjects.Elements.System;
{$HIDE H7}{$HIDE h8}
{$IFNDEF _WIN64}
type
  X86CallData = record
    Address: ^Void;
    StackData: ^Void;
    StackDataLength: Int32;
    StackDec: Int32;
    EAX, EDX: Int32;
    FloatReturn: Double;
  end;

type
  FFI = public class
  private
    fStack: array of Byte;
    fCallData: X86CallData;
    fVarData: array of Object;

    [CallingConvention(CallingConvention.Stdcall)]
    [InlineAsm("
    pushl %ebp
    movl %esp, %ebp
    pushl %eax
    movl 8(%eax), %ecx // ecx = stacklength
    jecxz endloop
    movl 4(%eax), %eax // eax = stackdata
  stackloop:
    movl (%eax), %edx
    pushl %edx
    subl $$4, %eax
    decl %ecx
    or %ecx,%ecx
    jnz stackloop
  endloop:
    movl -4(%ebp), %eax
    movl (%eax), %eax
    calll *%eax
    movl -4(%ebp), %ecx
    // first store EAX, EDX
    movl %eax, 16(%ecx)
    movl %edx, 20(%ecx)
    fstpl 24(%ecx)
    movl 12(%ecx), %eax
    shll $$2, %eax
    addl $$4, %eax
    addl %eax, %esp

    popl %ebp
    retl
    ", "", false, false), DisableInlining, DisableOptimizations]
    class method DoCall([InReg]var data: X86CallData); external;

    method PushBefore(aData: ^Void; aSize: Integer);
    begin
      var lStack := new array of Byte(length(fStack)+aSize);
      if length(fStack) > 0 then
        ExternalCalls.memcpy(@lStack[0], @fStack[0], length(fStack));
      ExternalCalls.memcpy(@lStack[length(fStack)], aData, aSize);
      fStack := lStack;
    end;

    method PushU32(i: UInt32);
    begin
      PushBefore(@i, 4);
    end;

    method PushU64(i: UInt64);
    begin
      PushBefore(@i, 8);
    end;

    method PushDouble(i: Double);
    begin
      PushBefore(@i, 8);
    end;

    method PushSingle(i: Single);
    begin
      PushBefore(@i, 4);
    end;

    method PushParameter(aVal: Object; aParamIndex: Integer; aParamType: &Type; aMode: ArgumentMode);
    begin
      if aMode in [ArgumentMode.Out, ArgumentMode.Var] then begin

        if aParamType.IsValueType then begin
          var lAlloc := Utilities.NewInstance(aParamType.RTTI, aParamType.SizeOfType + sizeOf(^Void)); // header
          ExternalCalls.memcpy(@(^^Void(lAlloc)[1]),@(^^Void(InternalCalls.Cast(aVal))[1]), aParamType.SizeOfType);
          PushU32(UInt32(@(^^Void(lAlloc)[1])));
          fVarData[aParamIndex] := InternalCalls.Cast<Object>(lAlloc);
        end else begin
          fVarData[aParamIndex] := aVal;
          PushU32(UInt32(@fVarData[aParamIndex]));
        end;
      end else begin
        case TypeCodes(aParamType.Code) of
          TypeCodes.Void: assert(false);
          TypeCodes.Boolean: PushU32(UInt32(Boolean(aVal)));
          TypeCodes.Char: PushU32(UInt32(Char(aVal)));
          TypeCodes.AnsiChar: PushU32(UInt32(AnsiChar(aVal)));
          TypeCodes.SByte: PushU32(UInt32(SByte(aVal)));
          TypeCodes.Byte: PushU32(UInt32(Byte(aVal)));
          TypeCodes.Int16: PushU32(UInt32(Int16(aVal)));
          TypeCodes.UInt16: PushU32(UInt32(UInt16(aVal)));
          TypeCodes.Int32: PushU32(UInt32(Int32(aVal)));
          TypeCodes.UInt32: PushU32(UInt32(UInt32(aVal)));
          TypeCodes.Int64: PushU64(UInt64(Int64(aVal)));
          TypeCodes.UInt64: PushU64(UInt64(UInt64(aVal)));
          TypeCodes.Single: PushSingle(Single(aVal));
          TypeCodes.Double: PushDouble(Double(aVal));
          TypeCodes.IntPtr: PushU32(NativeInt(aVal));
          TypeCodes.UIntPtr: PushU32(NativeUInt(aVal));
        else begin
          // TODO: add record support
            assert(not aParamType.IsValueType);
            PushU32(UInt32(InternalCalls.Cast(aVal)));
          end;
        end;
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
        for I: Integer := 0 to length(aParams) - 1 do begin
          if (lInst.fVarData = nil) and (aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out]) then lInst.fVarData := new Object[length(aParams)];
          lInst.PushParameter(aParams[I], I, aParameterTypes[I], aParameterFlags[I]);
        end;
        lInst.fCallData.StackData := @lInst.fStack[length(lInst.fStack)-4];
        lInst.fCallData.StackDataLength := length(lInst.fStack) / 4;
        lInst.fCallData.Address := aAddress;
        if aCallingConv in [CallingConvention.Cdecl, CallingConvention.Default] then
          lInst.fCallData.StackDec := lInst.fCallData.StackDataLength;
        DoCall(var lInst.fCallData);

        if lInst.fVarData <> nil then begin
          for I: Integer := 0 to length(aParams) - 1 do begin
            if aParameterFlags[I] in [ArgumentMode.Var, ArgumentMode.Out] then begin
              aParams[I] := lInst.fVarData[I];
            end
          end;
        end;

        if assigned(aResultType) then begin
          case aResultType.Code of
            TypeCodes.Single: exit Single(lInst.fCallData.FloatReturn);
            TypeCodes.Double: exit Double(lInst.fCallData.FloatReturn);
            TypeCodes.Char: exit Char(lInst.fCallData.EAX);
            TypeCodes.Boolean: exit Boolean(lInst.fCallData.EAX);
            TypeCodes.Byte: exit Byte(lInst.fCallData.EAX);
            TypeCodes.SByte: exit SByte(lInst.fCallData.EAX);
            TypeCodes.AnsiChar: exit AnsiChar(lInst.fCallData.EAX);
            TypeCodes.Int16: exit Int16(lInst.fCallData.EAX);
            TypeCodes.UInt16: exit UInt16(lInst.fCallData.EAX);
            TypeCodes.Int32: exit Int32(lInst.fCallData.EAX);
            TypeCodes.UInt32: exit UInt32(lInst.fCallData.EAX);
            TypeCodes.IntPtr: exit NativeInt(lInst.fCallData.EAX);
            TypeCodes.UIntPtr: exit NativeUInt(lInst.fCallData.EAX);
            TypeCodes.Int64: exit Int64(UInt64(lInst.fCallData.EAX) shl 32 or UInt64(lInst.fCallData.EDX));
            TypeCodes.UInt64:exit UInt64(lInst.fCallData.EAX) shl 32 or UInt64(lInst.fCallData.EDX);
          else
            exit InternalCalls.Cast<Object>(^Void(lInst.fCallData.EAX));
          end;
        end;
      end;
  end;

{$ENDIF}
end.