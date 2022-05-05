namespace RemObjects.Elements.System;

{$IFDEF WINDOWS}
var
  [SymbolName('__elements_RTTIStart'), SectionName('ELRTTLRR$a'), StaticallyInitializedField]
  fStart: ^IslandTypeInfo := nil;  readonly; assembly;
  [SymbolName('__elements_RTTIEnd'), SectionName('ELRTTLRR$z'), StaticallyInitializedField]
  fEnd: ^IslandTypeInfo := nil; readonly; assembly;

  [SymbolName('__elements_RTTIMStart'), SectionName('ELRTMLRR$a'), StaticallyInitializedField]
  fMStart: IslandMethodUIDInfo := default(IslandMethodUIDInfo);  readonly; assembly;
  [SymbolName('__elements_RTTIMEnd'), SectionName('ELRTMLRR$z'), StaticallyInitializedField]
  fMEnd: IslandMethodUIDInfo := default(IslandMethodUIDInfo); readonly; assembly;
{$ENDIF}

type
  [Packed]
  IslandMethodUIDInfo = public record
  public
    K1, K2: Int64;
    Ptr: IntPtr;
  end;

  CustomAttribute = public class
  private
    fArguments: array of CustomAttributeArgument;
    fConstructor: ^Void;
    fType: &Type;
  public

    constructor(aType: &Type; aCtor: ^Void; aArgs: array of CustomAttributeArgument);
    begin
      fType := aType;
      fConstructor := aCtor;
      fArguments := aArgs;
    end;

    property &Type: &Type read fType;
    property &Constructor: ^Void read fConstructor;
    property ArgumentCount: Integer read fArguments.Count;
    property Arguments[i: Integer]: CustomAttributeArgument read fArguments[i];
  end;

  CustomAttributeArgument = public class
  private
    fName: String;
    fValue: Object;
  public

    constructor(aName: String; aValue: Object);
    begin
      fName := aName;
      fValue := aValue;
    end;

    property Name: String read fName;
    property Value: Object read fValue;
  end;

  MemberInfo = public abstract class
  private

    method get_Name: String;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 2) and (lTy = ProtoReadType.length) then begin
          exit ProtoReadString(var lPtr)
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Access: MemberAccess;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 9) and (lTy = ProtoReadType.varint) then begin
          exit  MemberAccess(ProtoReadVarInt(var lPtr))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Attributes: sequence of CustomAttribute; iterator;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 0) and (lTy = ProtoReadType.startgroup) then begin
          yield &Type.ReadAttribute(fValue, var lPtr)
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

  assembly

    fValue: ^IslandTypeInfo;
    fPtr: ^Byte;
    fEnd: ^Byte;

    constructor(aValue: ^IslandTypeInfo; aPtr: ^Byte);
    begin
      fValue := aValue;
      fEnd := ProtoReadFixed32(var aPtr) + aPtr;
      fPtr := aPtr;
    end;

    method get_Type: nullable &Type;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 5) and (lTy = ProtoReadType.varint) then begin
          var lResolvedType := ^IslandTypeInfo(&Type.ResolveType(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]));
          if assigned(lResolvedType) then
            exit new &Type(lResolvedType)
          else
            exit nil;
        end
        else begin
          ProtoSkipValue(var lPtr, lTy);
        end;
      end;
    end;

  public
    property DeclaringType: &Type read new &Type(fValue);
    property Attributes: sequence of CustomAttribute read get_Attributes;
    property Access: MemberAccess read get_Access;
    property Name: String read get_Name;
    property &Type: nullable &Type read get_Type;
    property IsStatic: Boolean read; abstract;
  end;

  ArgumentMode = public enum(None, &Params, &Out, &Var);

  ArgumentInfo = public class
  private

    method get_Attributes: sequence of CustomAttribute; iterator;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 0) and (lTy = ProtoReadType.startgroup) then begin
          yield &Type.ReadAttribute(fValue, var lPtr)
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Mode: ArgumentMode;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          exit ArgumentMode(ProtoReadVarInt(var lPtr));
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Type: &Type;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 2) and (lTy = ProtoReadType.varint) then begin
          var lType := &Type.ResolveType(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]);
          if lType = nil then exit nil;
          exit new &Type(lType);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Name: String;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 1) and (lTy = ProtoReadType.length) then begin
          exit ProtoReadString(var lPtr)
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    fPtr: ^Byte;
    fValue: ^IslandTypeInfo;

  assembly

    constructor(aValue: ^IslandTypeInfo; aVal: ^Byte);
    begin
      fValue := aValue;
      fPtr := aVal;
    end;

  public

    property Name: String read get_Name;
    property &Type: &Type read get_Type;
    property Mode: ArgumentMode read get_Mode;
    property Attributes: sequence of CustomAttribute read get_Attributes;

  end;

  MemberAccess = public enum(
    &Private = 0,
    AssemblyAndProtected = 1,
    &Assembly = 2,
    &Protected = 3,
    AssemblyOrProtected = 4,
    &Public = 5,
    &Unit = 6,
    &UnitOrProtected = 7,
    &UnitAndProtected = 8);

  ConstantInfo = public class(MemberInfo)
  private
    method get_Value: Object;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 4) and (lTy = ProtoReadType.startgroup) then begin
          exit &Type.ReadAttributeValue(var lPtr).Value
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
  public
    property Value: Object read get_Value;
    property IsStatic: Boolean read true; override;
  end;

  FieldInfo = public class(MemberInfo)
  private
    method get_staticValuePointer: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 4) and (lTy = ProtoReadType.varint) then begin
          exit fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)];
        end else if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          if FieldFlags.Static not in FieldFlags(ProtoReadVarInt(var lPtr)) then raise new Exception('Field is not static!');
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_InstanceOffset: Integer;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 4) and (lTy = ProtoReadType.varint) then begin
          exit ProtoReadVarInt(var lPtr);
        end else if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          if FieldFlags.Static in FieldFlags(ProtoReadVarInt(var lPtr)) then raise new Exception('field is static!');
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Flags: FieldFlags;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          exit  FieldFlags(ProtoReadVarInt(var lPtr))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

  public

    property Flags: FieldFlags read get_Flags;
    property InstanceOffset: Integer read get_InstanceOffset; // only for instances
    property StaticValuePointer: ^Void read get_StaticValuePointer; // only for static
    property IsStatic: Boolean read FieldFlags.Static in &Flags; override;

    method GetValue(aInst: Object): Object;
    begin
      var lPtr: ^Void;
      if IsStatic then begin
        if aInst <> nil then raise new Exception('Cannot provide instance for static field');
        lPtr := StaticValuePointer;
      end else begin
        if aInst = nil then raise new Exception('Must provide instance for instance field');
        lPtr := InternalCalls.Cast(aInst);
        lPtr := ^Void(^Byte(lPtr) + InstanceOffset);
        if self.DeclaringType.IsValueType then
          lPtr := ^Void(^Byte(lPtr) + DeclaringType.BoxedDataOffset);
      end;
      if self.Type.IsValueType then begin
        var lRes := DefaultGC.New(&Type.RTTI, &Type.SizeOfType + &Type.BoxedDataOffset);
        memcpy(^Byte(lRes) +&Type.BoxedDataOffset, lPtr, &Type.SizeOfType);
        exit InternalCalls.Cast<Object>(lRes);
      end else
        exit ^Object(lPtr)^;
    end;

    method SetValue(aInst, aValue: Object);
    begin
      var lPtr: ^Void;
      if IsStatic then begin
        if aInst <> nil then raise new Exception('Cannot provide instance for static field');
        lPtr := StaticValuePointer;
      end else begin
        if aInst = nil then raise new Exception('Must provide instance for instance field');
        lPtr := InternalCalls.Cast(aInst);
        lPtr := ^Void(^Byte(lPtr) + InstanceOffset);
        if self.DeclaringType.IsValueType then
          lPtr := ^Void(^Byte(lPtr) + DeclaringType.BoxedDataOffset);
      end;
      if self.Type.IsValueType then begin
        if aValue = nil then raise new Exception('Value for struct cannot be null');
        memcpy(lPtr, ^Byte(InternalCalls.Cast(aValue)) + &Type.BoxedDataOffset, &Type.SizeOfType);
      end else
        ^Object(lPtr)^ := aValue;
    end;
  end;

  FieldFlags = public flags(&Static = 1, &Volatile = 2, &ReadOnly = 4);

  PropertyInfo = public class(MemberInfo)
  private
    method get_Arguments: sequence of ArgumentInfo; iterator;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 4) and (lTy = ProtoReadType.startgroup) then begin
          yield new ArgumentInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
    method get_WriteMethod: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 6) and (lTy = ProtoReadType.varint) then begin
          exit &Type.ResolveMethod(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
    method get_ReadMethod: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 7) and (lTy = ProtoReadType.varint) then begin
          exit  &Type.ResolveMethod(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Flags: PropertyFlags;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          exit  PropertyFlags(ProtoReadVarInt(var lPtr))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Read: MethodInfo;
    begin
      var lRM := ReadMethod;
      if lRM = nil then exit nil;
      exit DeclaringType.Methods.FirstOrDefault(a -> a.Pointer = lRM);
    end;

    method get_Write: MethodInfo;
    begin
      var lRM := WriteMethod;
      if lRM = nil then exit nil;
      exit DeclaringType.Methods.FirstOrDefault(a -> a.Pointer = lRM);
    end;

  public

    property Flags: PropertyFlags read get_Flags;
    property IsStatic: Boolean read PropertyFlags.Static in &Flags; override;
    property ReadMethod: ^Void read get_ReadMethod;
    property WriteMethod: ^Void read get_WriteMethod;
    property &Read: MethodInfo read get_Read;
    property &Write: MethodInfo read get_Write;
    property Arguments: sequence of ArgumentInfo read get_Arguments;

    method GetValue(aInst: Object; aArgs: array of Object): Object;
    begin
      if (length(aArgs) = 0) and (not IsStatic) and (Arguments.Count = 0) and (ReadMethod <> nil) then begin
        case &Type.Code of
          TypeCodes.Boolean: exit BooleanGetter(ReadMethod)(aInst);
          TypeCodes.Char: exit CharGetter(ReadMethod)(aInst);
          TypeCodes.SByte: exit SByteGetter(ReadMethod)(aInst);
          TypeCodes.Byte: exit ByteGetter(ReadMethod)(aInst);
          TypeCodes.Int16: exit Int16Getter(ReadMethod)(aInst);
          TypeCodes.UInt16: exit UInt16Getter(ReadMethod)(aInst);
          TypeCodes.Int32: exit Int32Getter(ReadMethod)(aInst);
          TypeCodes.UInt32: exit UInt32Getter(ReadMethod)(aInst);
          TypeCodes.Int64: exit Int64Getter(ReadMethod)(aInst);
          TypeCodes.UInt64: exit UInt64Getter(ReadMethod)(aInst);
          TypeCodes.Single: exit SingleGetter(ReadMethod)(aInst);
          TypeCodes.Double: exit DoubleGetter(ReadMethod)(aInst);
          TypeCodes.IntPtr: exit IntPtrGetter(ReadMethod)(aInst);
          TypeCodes.UIntPtr: exit UIntPtrGetter(ReadMethod)(aInst);
          TypeCodes.String: exit StringGetter(ReadMethod)(aInst);
        end;
        if &Type = typeOf(array of Byte) then
          exit ByteArrayGetter(ReadMethod)(aInst);
        if &Type = typeOf(DateTime) then
          exit DateTimeGetter(ReadMethod)(aInst);
      end;
      var lRead := &Read;
      if lRead = nil then raise new Exception('No read accessor for this property!');

      exit lRead.Invoke(aInst, aArgs);
    end;

    method SetValue(aInst: Object; aArgs: array of Object; aValue: Object);
    begin
      if (length(aArgs) = 0) and (not IsStatic) and (Arguments.Count = 0) and (WriteMethod <> nil) then begin
        case &Type.Code of
          TypeCodes.Boolean: begin BooleanSetter(WriteMethod)(aInst, Boolean(aValue)); exit end;
          TypeCodes.Char: begin  CharSetter(WriteMethod)(aInst, Char(aValue)); exit end;
          TypeCodes.SByte: begin  SByteSetter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.Byte: begin  ByteSetter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.Int16: begin  Int16Setter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.UInt16: begin  UInt16Setter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.Int32: begin  Int32Setter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.UInt32: begin  UInt32Setter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.Int64: begin  Int64Setter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.UInt64: begin  UInt64Setter(WriteMethod)(aInst, Convert.ToUInt64(aValue)); exit end;
          TypeCodes.Single: begin  SingleSetter(WriteMethod)(aInst, Convert.ToSingle(aValue)); exit end;
          TypeCodes.Double: begin  DoubleSetter(WriteMethod)(aInst, Convert.ToDouble(aValue)); exit end;
          TypeCodes.IntPtr: begin  IntPtrSetter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.UIntPtr: begin  UIntPtrSetter(WriteMethod)(aInst, Convert.ToInt64(aValue)); exit end;
          TypeCodes.String: begin  StringSetter(WriteMethod)(aInst, aValue:ToString); exit end;
        end;
        if &Type = typeOf(array of Byte) then begin
          ByteArraySetter(WriteMethod)(aInst, array of Byte(aValue));
          exit
        end;
        if &Type = typeOf(DateTime) then begin
          DateTimeSetter(WriteMethod)(aInst, DateTime(aValue));
          exit
        end;
      end;
      var lWrite := &Write;
      if lWrite = nil then raise new Exception('No write accessor for this property!');
      if (aArgs = nil) or (aArgs.Length = 0)then aArgs := [aValue] else begin
        var lArgs := new Object[aArgs.Length+1];
        Array.Copy(aArgs, lArgs, aArgs.Length);
        lArgs[lArgs.Length-1] := aValue;
        aArgs := lArgs;
      end;
      lWrite.Invoke(aInst, aArgs);
    end;
  end;


  PropertyFlags = public flags(
    &Static = 1,
    &Default = 2);

  EventInfo = public class(MemberInfo)
  private
    method get_Flags: EventFlags;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          exit  EventFlags(ProtoReadVarInt(var lPtr))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
    method get_AddMethod: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 6) and (lTy = ProtoReadType.varint) then begin
          exit &Type.ResolveMethod(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
    method get_RemoveMethod: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 7) and (lTy = ProtoReadType.varint) then begin
          exit  &Type.ResolveMethod(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
    method get_FireMethod: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 8) and (lTy = ProtoReadType.varint) then begin
          exit  &Type.ResolveMethod(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
  public
    property Flags: EventFlags read get_Flags;
    property IsStatic: Boolean read EventFlags.Static in &Flags; override;
    property AddMethod: ^Void read get_AddMethod;
    property RemoveMethod: ^Void read get_RemoveMethod;
    property FireMethod: ^Void read get_FireMethod;
  end;

  EventFlags = public flags(
    &Static = 1);

  MethodInfo = public class(MemberInfo)
  private
    method get_Arguments: sequence of ArgumentInfo; iterator;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 4) and (lTy = ProtoReadType.startgroup) then begin
          yield new ArgumentInfo(fValue, lPtr);
          ProtoSkipValue(var lPtr, lTy);
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;
    method get_Flags: MethodFlags;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
          exit  MethodFlags(ProtoReadVarInt(var lPtr))
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_Pointer: ^Void;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 6) and (lTy = ProtoReadType.varint) then begin
          exit  &Type.ResolveMethod(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;

    method get_VmtOffset: Integer;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 7) and (lTy = ProtoReadType.varint) then begin
          exit  ProtoReadVarInt(var lPtr)
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
      exit -1;
    end;

  public

    property Flags: MethodFlags read get_Flags;
    property IsStatic: Boolean read MethodFlags.Static in &Flags; override;
    property Arguments: sequence of ArgumentInfo read get_Arguments;
    property VmtOffset: Integer read get_VmtOffset;
    property Pointer: ^Void read get_Pointer;

    method Invoke(aInstance: Object; aArgs: array of Object): Object;
    begin
      var l_Arguments_Count := Arguments.Count;
      if length(aArgs) <> l_Arguments_Count then raise new ArgumentException('incorrect size of aArgs parameter');
      var cc: CallingConvention := CallingConvention.Default;
      {$IFNDEF CPU64}
      var lst := Attributes.Where(b->b.Type = typeOf(CallingConventionAttribute)).ToList;
      if lst.Count >0 then cc := CallingConvention(Int64(lst[0].Arguments[0].Value));
      {$ENDIF}
      var dx := if IsStatic then 0 else 1;

      var lParams := new array of Object(dx+l_Arguments_Count);
      var lModes := new array of ArgumentMode(dx+l_Arguments_Count);
      var lTypes := new array of &Type(dx+l_Arguments_Count);
      if dx = 1 then begin
        lParams[0] := aInstance;
        var lDeclaringType := DeclaringType;
        if Utilities.IsInstance(aInstance, lDeclaringType.fValue) = nil then
          raise new ArgumentException('Instance must be compatible with method declaring type');
        {$IFDEF WEBASSEMBLY}
        if DeclaringType.IsValueType then
          lParams[0] := ^IntPtr(@aInstance)^ + DeclaringType.BoxedDataOffset;
        {$ENDIF}
        if lDeclaringType.IsValueType then
          lModes[0] := ArgumentMode.Var
        else
          lModes[0] := ArgumentMode.None;
        lTypes[0] := typeOf(aInstance);
      end;
      for k in Arguments index i do begin
        lModes[i+dx]:= k.Mode;
        lTypes[i+dx]:= k.Type;
        lParams[i+dx]:= aArgs[i];
      end;
      {$IFDEF WINDOWS}
      result := FFI.Call(Pointer, cc, var lParams, lModes, lTypes, &Type);
      {$ELSEIF ANDROID}
      raise new NotImplementedException($"MethodInfo.Invoke is not implemented for Island/Android yet.");
      {$ELSEIF FUCHSIA}
      {$WARNING Not Implememnted for Fuchsia yet}
      raise new NotImplementedException($"MethodInfo.Invoke is not implemented for Island/Fuchsia yet.");
      {$ELSEIF POSIX}
        //{$IFDEF cpu64 and not ARM}
        {$IFDEF cpu64 OR (ARM AND CPU64)}
        // only x64 is supported
        result := FFI.Call(Pointer, cc, var lParams, lModes, lTypes, &Type);
        {$ELSE}
        // ARMv6 wasn't supported yet
        raise new NotImplementedException($"MethodInfo.Invoke is not implemented for Island/{Environment.SubMode} on {Environment.BinaryArchitecture} yet.");
        {$ENDIF}
      {$ELSEIF WEBASSEMBLY}
      result := WebAssembly.UnwrapCall(&Type, WebAssembly.InvokeMethod(Pointer, lParams, &Type));
      {$ELSE}
      {$ERROR Unsupported SubMode}
      {$ENDIF}
      for nil in Arguments index i do
        if lModes[i+dx] in [ArgumentMode.Var,ArgumentMode.Out] then
          aArgs[i]:=lParams[i+dx];
    end;
  end;

  MethodFlags = public flags(
    &Static = 1,
    &Constructor = 2,
    &Operator = 4,
    &Finalizer = 6,
    Abstract = 8,
    Override = 16,
    Virtual = 32,
    Final = 64,
    ExtensionMethod = 128,
    StaticExtension = 256);


  CtorHelper = assembly procedure(aInst: Object);

  VTCtorHelper = assembly procedure(aInst: IntPtr);

  TypeDefFlags = public flags (
    &Global = 1 shl 0,
    &Sealed = 1 shl 1,
    &Static = 1 shl 2,
    &Mapped = 1 shl 3,
    HasAnonymous = 1 shl 4,
    &Abstract = 1 shl 5,
    SoftInterface = 1 shl 6,
    &Extension = 1 shl 7,
    External = 1 shl 8,
    CompilerCategory = 1 shl 9,
    BlockHolder = 1 shl 10,
    JavaNested = 1 shl 11,
    SealedExternally = 1 shl 12
  );

  IslandExtTypeInfo = public record
  private
  public
    &Flags: IslandTypeFlags;
    Name: ^AnsiChar;
    SubType: ^IslandTypeInfo; // If Generic, this will be the "non generic" type, array it will be the sub type, etc
    MemberInfoData: ^Byte;
    MemberInfoList: ^^Void;
    GCInfo: ^Void; // this has 1 bit per sizeof(pointer) denoting if the value at this point IS a gc-able pointer.
    TypeSize: Integer;
  end;

  IslandTypeInfo = public record
  private
  public
    Ext: ^IslandExtTypeInfo;
    ParentType: ^IslandTypeInfo;
    InterfaceType: ^IslandInterfaceTable;
    InterfaceVMT: ^Void;
    Hash1: Int64;
    Hash2: Int64;
  end;

var
[SymbolName("__cominterface_rtti"), Used, StaticallyInitializedField]
ComInterfaceRTTI: IslandTypeInfo := new IslandTypeInfo(Ext := @ComInterfaceExt,
ParentType := nil,
InterfaceType := nil,
InterfaceVMT := nil,
Hash1 := Int64($cbb97d02e4749c92),
Hash2 := Int64($b48e4f27c4374719)
); public;
[SymbolName("__cocoainterface_rtti"), Used, StaticallyInitializedField]
CocoaClassRTTI: IslandTypeInfo := new IslandTypeInfo(Ext := @CococaClassExt,
ParentType := nil,
InterfaceType := nil,
InterfaceVMT := nil,
Hash1 := Int64($49987f1cfb738353),
Hash2 := Int64($733406f403e14ced)
); public;
[SymbolName("__swiftinterface_rtti"), Used, StaticallyInitializedField]
SwiftClassRTTI: IslandTypeInfo := new IslandTypeInfo(Ext := @SwiftClasseExt,
ParentType := nil,
InterfaceType := nil,
InterfaceVMT := nil,
Hash1 := Int64($62eb5fa6785f90c9),
Hash2 := Int64($3599d954c1778e2f)
); public;
[StaticallyInitializedField]
ComInterfaceExt: IslandExtTypeInfo := new IslandExtTypeInfo(&Flags := IslandTypeFlags.ComInterface,
TypeSize := sizeOf(^Void)
); assembly;
[StaticallyInitializedField]
CococaClassExt: IslandExtTypeInfo := new IslandExtTypeInfo(&Flags := IslandTypeFlags.CocoaClass,
TypeSize := sizeOf(^Void)
); assembly;
[StaticallyInitializedField]
SwiftClasseExt: IslandExtTypeInfo := new IslandExtTypeInfo(&Flags := IslandTypeFlags.SwiftClass,
TypeSize := sizeOf(^Void)
); assembly;


type
  IslandInterfaceTable = public record
  public
    HashTableSize: Cardinal;
    FirstEntry: ^^IslandTypeInfo; // ends with 0
  end;

  ObjectModel = public enum (Unknown, Island, Cocoa, Swift, COM);

  // Keep in sync with compiler.
  IslandTypeFlags = public flags (
    // First 3 bits reserved for type kind
    TypeKindMask  = (1 shl 0) or (1 shl 1) or (1 shl 2) or (1 shl 3),
    &Class = 0,
    &Enum = 1,
    EnumFlags = 2,
    &Delegate = 3,
    Struct = 4,
    &Interface = 5,
    &Extension = 6,
    &Array = 7,
    Pointer = 8,
    &Set = 9,
    ComInterface = 10,
    CocoaClass = 11,
    SwiftClass = 12,
    MemberInfoPresent = 16,
    Generic = 32,
    OpenGeneric = 64,
    Com = 129) of UInt64;

  ProtoReadType = assembly (varint = 0, b64 = 1, length = 2, message = 3, b32 = 5, startgroup = 4, endgroup = 6);

  TypeCodes = public enum(
    None = -1,
    Void = 0,
    Boolean = 1,
    Char = 2,
    SByte = 3,
    Byte = 4,
    Int16 = 5,
    UInt16 = 6,
    Int32 = 7,
    UInt32 = 8,
    Int64 = 9,
    UInt64 = 10,
    Single = 11,
    Double = 12,
    IntPtr = 15,
    UIntPtr = 16,
    String = 13,
    Object = 18,
    AnsiChar = 207
  );

  method ProtoReadHeader(var aSelf: ^Byte; out aKey: Integer; out aType: ProtoReadType): Boolean;assembly;
  begin
    var lData := ProtoReadVarInt(var aSelf);
    var lType := ProtoReadType(lData and $7);
    aType := lType;
    aKey := lData shr 3;
    exit aType <> ProtoReadType.endgroup;
  end;

  method ProtoReadVarInt(var aSelf: ^Byte): Int64;assembly;
  begin
    var lShift := 0;
    result := 0;
    loop begin
      var lData := aSelf^;
      inc(aSelf);
      result := result or (Int64(lData and $7f) shl lShift);
      lShift := lShift + 7;
      if 0 = (lData and $80) then break;
    end;
  end;

  method ProtoSkipValue(var aSelf: ^Byte; aType: ProtoReadType);assembly;
  begin
    case aType of
      ProtoReadType.b32: ProtoReadFixed32(var aSelf);
      ProtoReadType.b64: ProtoReadFixed64(var aSelf);
      ProtoReadType.message: aSelf := ProtoReadFixed32(var aSelf) + aSelf;
      ProtoReadType.endgroup: ;
      ProtoReadType.startgroup: begin
        var lCount := 1;
        loop begin
          var lRT := ProtoReadType(ProtoReadVarInt(var aSelf) and $7);
          if lRT = ProtoReadType.startgroup then
            inc(lCount)
          else
            if lRT = ProtoReadType.endgroup then begin
              dec(lCount);
              if lCount = 0 then break;
            end else
              ProtoSkipValue(var aSelf, lRT);
        end;
      end;
      ProtoReadType.length: aSelf := ProtoReadVarInt(var aSelf) + aSelf;
      else  ProtoReadVarInt(var aSelf);
    end;
  end;

  method ProtoReadDouble(var aSelf: ^Byte): Double;assembly;
  begin
    result := ^Double(aSelf)^;
    aSelf := aSelf + 8;
  end;

  method ProtoReadString(var aSelf: ^Byte): String;assembly;
  begin
    var lLen := ProtoReadVarInt(var aSelf);
    var lData := new Byte[lLen];
    Array.Copy(aSelf, lData, 0, lLen);
    result := Encoding.UTF8.GetString(lData);
    aSelf := aSelf + lLen;
  end;

  method ProtoReadBytes(var aSelf: ^Byte): array of Byte;assembly;
  begin
    var lLen := ProtoReadVarInt(var aSelf);
    result := new Byte[lLen];
    memcpy(@result[0], aSelf, lLen);
    aSelf := aSelf + lLen;
  end;

  method ProtoReadFixed32(var aSelf: ^Byte): Integer;assembly;
  begin
    result := ^Integer(aSelf)^;
    aSelf := aSelf + 4;
  end;

  method ProtoReadFixed64(var aSelf: ^Byte): Int64; assembly;
  begin
    result := ^Int64(aSelf)^;
    aSelf := aSelf + 8;
  end;

type
  BooleanSetter = procedure(aInst: Object; v: Boolean);
  CharSetter = procedure(aInst: Object; v: Char);
  SByteSetter = procedure(aInst: Object; v: SByte);
  ByteSetter = procedure(aInst: Object; v: Byte);
  Int16Setter = procedure(aInst: Object; v: Int16);
  UInt16Setter = procedure(aInst: Object; v: UInt16);
  Int32Setter = procedure(aInst: Object; v: Int32);
  UInt32Setter = procedure(aInst: Object; v: UInt32);
  Int64Setter = procedure(aInst: Object; v: Int64);
  UInt64Setter = procedure(aInst: Object; v: UInt64);
  IntPtrSetter = procedure(aInst: Object; v: IntPtr);
  UIntPtrSetter = procedure(aInst: Object; v: UIntPtr);
  SingleSetter = procedure(aInst: Object; v: Single);
  DoubleSetter = procedure(aInst: Object; v: Double);
  StringSetter = procedure(aInst: Object; v: String);
  ByteArraySetter = procedure(aInst: Object; v: array of Byte);
  DateTimeSetter = procedure(aInst: Object; v: DateTime);

  BooleanGetter = function(aInst: Object): Boolean;
  CharGetter = function(aInst: Object): Char;
  SByteGetter = function(aInst: Object): SByte;
  ByteGetter = function(aInst: Object): Byte;
  Int16Getter = function(aInst: Object): Int16;
  UInt16Getter = function(aInst: Object): UInt16;
  Int32Getter = function(aInst: Object): Int32;
  UInt32Getter = function(aInst: Object): UInt32;
  Int64Getter = function(aInst: Object): Int64;
  UInt64Getter = function(aInst: Object): UInt64;
  IntPtrGetter = function(aInst: Object): IntPtr;
  UIntPtrGetter = function(aInst: Object): UIntPtr;
  SingleGetter = function(aInst: Object): Single;
  DoubleGetter = function(aInst: Object): Double;
  StringGetter = function(aInst: Object): String;
  ByteArrayGetter = function(aInst: Object): array of Byte;
  DateTimeGetter = function(aInst: Object): DateTime;

end.