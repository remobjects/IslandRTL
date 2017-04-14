namespace RemObjects.Elements.System;

type
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
          exit new &Type(^IslandTypeInfo(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]));
        end else
          ProtoSkipValue(var lPtr, lTy);
      end;
    end;


  public
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
          exit new &Type(^IslandTypeInfo(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]));
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
        if (lKey = 3) and (lTy = ProtoReadType.startgroup) then begin
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
    property InstanceOffset: Integer read get_InstanceOffset; // only for instances!
    property StaticValuePointer: ^Void read get_StaticValuePointer; // only for static
    property IsStatic: Boolean read FieldFlags.Static in &Flags; override;
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
          exit  fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
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
          exit  fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
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
  public
    property Flags: PropertyFlags read get_Flags;
    property IsStatic: Boolean read PropertyFlags.Static in &Flags; override;
    property ReadMethod: ^Void read get_ReadMethod;
    property WriteMethod: ^Void read get_WriteMethod;
    property Arguments: sequence of ArgumentInfo read get_Arguments;
  end;


  PropertyFlags = public flags(
    &Static = 1);

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
          exit  fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
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
        if (lKey = 6) and (lTy = ProtoReadType.varint) then begin
          exit  fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
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
        if (lKey = 6) and (lTy = ProtoReadType.varint) then begin
          exit  fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
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
          exit  fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]
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
      {$ELSEIF POSIX}
      raise new NotImplementedException();
      {$ELSE}{$ERROR}{$ENDIF}
      for k in Arguments index i do
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

  &Type = public class
   private
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
    {$IFDEF WINDOWS}
    [SymbolName('__elements_RTTIStart'), SectionName('ELRTTLRR$a')]
    class var fStart: ^IslandTypeInfo;
    [SymbolName('__elements_RTTIEnd'), SectionName('ELRTTLRR$z')]
    class var fEnd: ^IslandTypeInfo;

     class method get_AllTypes: sequence of &Type; iterator;
     begin
       var lWork := @fStart;
       loop begin
         inc(lWork);
         if lWork = @fEnd then break;
         if lWork^ = nil then continue;
         yield new &Type(lWork^);
       end;
     end;
    {$ELSE}
    [SymbolName('__start_ELRTTLRR')]
    class var fStart: ^IslandTypeInfo; external;
    [SymbolName('__stop_ELRTTLRR')]
    class var fEnd: ^IslandTypeInfo;external;

     class method get_AllTypes: sequence of &Type; iterator;
     begin
       var lWork := @fStart;
       loop begin
         if lWork^ <> nil then begin
           yield new &Type(lWork^);
         end;
         inc(lWork);
         if lWork > @fEnd then break;
       end;
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
          exit new &Type(^IslandTypeInfo(fValue^.Ext^.MemberInfoList[ProtoReadVarInt(var lPtr)]))
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
    method get_Code: Integer;
    begin
      var lPtr := fValue^.Ext^.MemberInfoData;
      var lKey: Integer;
      var lTy: ProtoReadType;
      while ProtoReadHeader(var lPtr, out lKey, out lTy) do begin
        if (lKey = 10) and (lTy = ProtoReadType.varint) then
          exit ProtoReadVarInt(var lPtr)
        else
          ProtoSkipValue(var lPtr, lTy);
      end;
      exit -1;
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
      exit false;
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
    property Code: Integer read get_Code;
    property DefFlags: TypeDefFlags read get_DefFlags;
    property SizeOfType: Integer read get_SizeOfType;
    property SubType: &Type read get_SubType;
    property IsValueType: Boolean read (fValue^.Ext^.Flags and (
      IslandTypeFlags.Enum or IslandTypeFlags.EnumFlags or IslandTypeFlags.Struct or IslandTypeFlags.Pointer or IslandTypeFlags.Set)) <> 0;
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

    method Instantiate: Object; // Creates a new instance of this type and calls the default constructor, fails if none is present!
    begin
      var lCtor: MethodInfo := Methods.FirstOrDefault(a -> (MethodFlags.Constructor in a.Flags) and not a.Arguments.Any);
      if lCtor = nil then raise new Exception('No default constructor could be found!');
      var lRealCtor := CtorHelper(lCtor.Pointer);
      if lRealCtor = nil then raise new Exception('No default constructor could be found!');
      result := InternalCalls.Cast<Object>(Utilities.NewInstance(fValue, SizeOfType));
      lRealCtor(result);
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

  IslandInterfaceTable = public record
  public
    HashTableSize: Integer;
    FirstEntry: ^^IslandTypeInfo; // ends with 0
  end;

  // Keep in sync with compiler.
  IslandTypeFlags = public flags (
    // First 3 bits reserved for type kind
    TypeKindMask  = (1 shl 0) or (1 shl 1) or (1 shl 2) ,
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
    MemberInfoPresent = 16,
    Generic = 32) of UInt64;

    ProtoReadType = assembly (varint = 0, b64 = 1, length = 2, message = 3, b32 = 5, startgroup = 4, endgroup = 6);

  TypeCodes = public flags(
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
  result := TextConvert.UTF8ToString(lData);
  aSelf := aSelf + lLen;
end;

method ProtoReadBytes(var aSelf: ^Byte): array of Byte;assembly;
begin
  var lLen := ProtoReadVarInt(var aSelf);
  result := new Byte[lLen];
  {$IFDEF POSIX}rtl.{$ELSE}ExternalCalls.{$ENDIF}memcpy(@result[0], aSelf, lLen);
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

end.