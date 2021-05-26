namespace RemObjects.Elements.System;

{$IFDEF WINDOWS}

var
  [SymbolName('__elements_RTTIStart'), SectionName('ELRTTLRR$a'), StaticallyInitializedField]
  fStart: ^IslandTypeInfo := nil;  readonly;
  [SymbolName('__elements_RTTIEnd'), SectionName('ELRTTLRR$z'), StaticallyInitializedField]
  fEnd: ^IslandTypeInfo := nil; readonly;

  [SymbolName('__elements_RTTIMStart'), SectionName('ELRTMLRR$a'), StaticallyInitializedField]
  fMStart: IslandMethodUIDInfo := default(IslandMethodUIDInfo);  readonly;
  [SymbolName('__elements_RTTIMEnd'), SectionName('ELRTMLRR$z'), StaticallyInitializedField]
  fMEnd: IslandMethodUIDInfo := default(IslandMethodUIDInfo); readonly;
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

    method get_Type: &Type;
    begin
      var lPtr := fPtr;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while (lPtr < fEnd) and ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 5) and (lTy = ProtoReadType.varint) then begin
          exit new &Type(^IslandTypeInfo(&Type.ResolveType(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)])));
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;


  public
    property DeclaringType: &Type read new &Type(fValue);
    property Attributes: sequence of CustomAttribute read get_Attributes;
    property Access: MemberAccess read get_Access;
    property Name: String read get_Name;
    property &Type: &Type read get_Type;
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
        end else
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
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
        end else
        if (lKey = 3) and (lTy = ProtoReadType.varint) then begin
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
      {$IFNDEF cpu64}
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
        if Utilities.IsInstance(aInstance, lDeclaringType.fValue) = nil then raise new ArgumentException('Instance must be compatible with method declaring type');
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
      raise new NotImplementedException();
      {$ELSEIF POSIX}
        {$IFDEF cpu64 and not ARM}
        // only x64 is supported
        result := FFI.Call(Pointer, cc, var lParams, lModes, lTypes, &Type);
        {$ELSE}
        // ARMv6 wasn't supported yet
        raise new NotImplementedException();
        {$ENDIF}
      {$ELSEIF WEBASSEMBLY}
      result := WebAssembly.UnwrapCall(&Type, WebAssembly.InvokeMethod(Pointer, lParams));
      {$ELSE}{$ERROR}{$ENDIF}
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
  [Used]
  &Type = public class
   private
     method get_COMGuids: sequence of Guid; iterator;
     begin
       var lPtr := fValue^.Ext^.MemberInfoData;
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
    [&Weak, SymbolName('_mh_elements_execute_header')]
    class var __mh_elements_execute_header: {$IFDEF CPU64}rtl.__struct_mach_header_64{$ELSE}rtl.__struct_mach_header{$ENDIF} ; external;

    {$IFDEF DARWIN}public{$ENDIF}class method GetHDR: ^{$IFDEF CPU64}rtl.__struct_mach_header_64{$ELSE}rtl.__struct_mach_header{$ENDIF};
    begin
      var hdr := @__mh_elements_execute_header;
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
       var lKey: Integer;
       var lTy: ProtoReadType;
       while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
         if (lKey = 1) and (lTy = ProtoReadType.message) then begin
           yield new FieldInfo(fValue, lPtr);
           ProtoSkipValue(var lPtr, lTy);
         end else
         if (lKey = 2) and (lTy = ProtoReadType.message) then begin
           yield new ConstantInfo(fValue, lPtr);
           ProtoSkipValue(var lPtr, lTy);
         end else
         if (lKey = 3) and (lTy = ProtoReadType.message) then begin
           yield new MethodInfo(fValue, lPtr);
           ProtoSkipValue(var lPtr, lTy);
         end else
         if (lKey = 4) and (lTy = ProtoReadType.message) then begin
           yield new PropertyInfo(fValue, lPtr);
           ProtoSkipValue(var lPtr, lTy);
         end else
         if (lKey = 5) and (lTy = ProtoReadType.message) then begin
           yield new EventInfo(fValue, lPtr);
           ProtoSkipValue(var lPtr, lTy);
         end else
           ProtoSkipValue(var lPtr, lTy);
      end;
    end;

     method get_Attributes: sequence of CustomAttribute; iterator;
     begin
       var lPtr := fValue^.Ext^.MemberInfoData;
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
    property &Name: String read if fValue = nil then nil else String.FromPAnsiChars(fValue^.Ext^.Name);
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
      if (IslandTypeFlags.TypeKindMask and fValue^.Ext^.Flags) <> IslandTypeFlags.Array then raise new Exception('Can only call InstantiateArray on arrays');
      exit InternalCalls.Cast<&Array>(Utilities.NewArray(RTTI, if SubType.IsValueType then SubType.SizeOfType else sizeOf(^Void), aSize));
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

  CtorHelper = assembly procedure(aInst: Object);


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
  ComInterfaceRTTI: IslandTypeInfo := new IslandTypeInfo (
    Ext := @ComInterfaceExt,
    ParentType := nil,
    InterfaceType := nil,
    InterfaceVMT := nil,
    Hash1 := Int64($cbb97d02e4749c92),
    Hash2 := Int64($b48e4f27c4374719)
  ); public;
  [SymbolName("__cocoainterface_rtti"), Used, StaticallyInitializedField]
  CocoaClassRTTI: IslandTypeInfo := new IslandTypeInfo (
    Ext := @CococaClassExt,
    ParentType := nil,
    InterfaceType := nil,
    InterfaceVMT := nil,
    Hash1 := Int64($49987f1cfb738353),
    Hash2 := Int64($733406f403e14ced)
  ); public;
  [SymbolName("__swiftinterface_rtti"), Used, StaticallyInitializedField]
  SwiftClassRTTI: IslandTypeInfo := new IslandTypeInfo (
    Ext := @SwiftClasseExt,
    ParentType := nil,
    InterfaceType := nil,
    InterfaceVMT := nil,
    Hash1 := Int64($62eb5fa6785f90c9),
    Hash2 := Int64($3599d954c1778e2f)
  ); public;
  [StaticallyInitializedField]
  ComInterfaceExt: IslandExtTypeInfo := new IslandExtTypeInfo(
    &Flags := IslandTypeFlags.ComInterface,
    TypeSize := sizeOf(^Void)
  );assembly;
  [StaticallyInitializedField]
  CococaClassExt: IslandExtTypeInfo := new IslandExtTypeInfo(
    &Flags := IslandTypeFlags.CocoaClass,
    TypeSize := sizeOf(^Void)
  );assembly;
  [StaticallyInitializedField]
  SwiftClasseExt: IslandExtTypeInfo := new IslandExtTypeInfo(
    &Flags := IslandTypeFlags.SwiftClass,
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
    OpenGeneric = 64) of UInt64;

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