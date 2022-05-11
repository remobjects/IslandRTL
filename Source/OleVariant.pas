namespace RemObjects.Elements.System;
[Assembly: RemObjects.Elements.System.LifetimeStrategyOverrideAttribute(typeOf(rtl.VARIANT), typeOf(Variant_Helper))]
type
  Variant = public rtl.VARIANT;
  VarType = public rtl.__enum_VARENUM;

  Variant_Helper = public record
  private
    fVar: rtl.VARIANT;
  public

    constructor;
    begin
      rtl.VariantInit(@fVar);
    end;

    constructor Copy(var aValue: Variant_Helper);
    begin
      rtl.VariantCopy(@fVar, @aValue.fVar);
    end;


    class operator Assign(var aDest: Variant_Helper; var aSource: Variant_Helper);
    begin
      if (@aDest) = (@aSource) then exit;
      rtl.VariantClear(@aDest.fVar);
      rtl.VariantCopy(@aDest.fVar, @aSource.fVar);
    end;

    finalizer;
    begin
      rtl.VariantClear(@fVar);
    end;
  end;

  operator &Add( aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarAdd(@aLeft, @aRight, @result);
  end;

  operator Divide(aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarDiv(@aLeft, @aRight, @result);
  end;

  operator Modulus(aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarMod(@aLeft, @aRight, @result);
  end;

  operator Multiply(aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarMul(@aLeft, @aRight, @result);
  end;

  operator Subtract( aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarSub(@aLeft, @aRight, @result);
  end;



  operator BitwiseAnd( aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarAnd(@aLeft, @aRight, @result);
  end;


  operator BitwiseOr (aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarOr(@aLeft, @aRight, @result);
  end;

  operator BitwiseXor( aLeft, aRight: Variant): Variant; public;
  begin
    rtl.VarXor(@aLeft, @aRight, @result);
  end;

  operator BitwiseNot(const var aLeft: Variant): Variant; public;
  begin
    rtl.Varnot(@aLeft, @result);
  end;


  operator Minus(var aLeft: Variant): Variant; public;
  begin
    rtl.VarNeg(@aLeft, @result);
  end;

  operator Equal(var aLeft, aRight: Variant): Boolean; public;
  begin
    var b := rtl.VarCmp(@aLeft, @aRight, rtl.LOCALE_USER_DEFAULT, 0);

    exit b = rtl.VARCMP_EQ;
  end;

  operator NotEqual(const var aLeft, aRight: Variant): Boolean; public;
  begin
    var b := rtl.VarCmp(@aLeft, @aRight, rtl.LOCALE_USER_DEFAULT, 0);

    exit b <> rtl.VARCMP_EQ;
  end;

  operator Less(const var aLeft, aRight: Variant): Boolean; public;
  begin
    var b := rtl.VarCmp(@aLeft, @aRight, rtl.LOCALE_USER_DEFAULT, 0);

    exit b = rtl.VARCMP_LT;
  end;
  operator LessOrEqual(const var aLeft, aRight: Variant): Boolean; public;
  begin
    var b := rtl.VarCmp(@aLeft, @aRight, rtl.LOCALE_USER_DEFAULT, 0);

    exit b in [rtl.VARCMP_LT, rtl.VARCMP_EQ];
  end;

  operator Greater(const var aLeft, aRight: Variant): Boolean; public;
  begin
    var b := rtl.VarCmp(@aLeft, @aRight, rtl.LOCALE_USER_DEFAULT, 0);

    exit b = rtl.VARCMP_GT;
  end;

  operator GreaterOrEqual(const var aLeft, aRight: Variant): Boolean; public;
  begin
    var b := rtl.VarCmp(@aLeft, @aRight, rtl.LOCALE_USER_DEFAULT, 0);

    exit b in [rtl.VARCMP_GT, rtl.VARCMP_EQ];
  end;

  method VarIsNull(const var aVar: Variant): Boolean; public;
  begin
    exit VarType(aVar.n1.n2.vt) = VarType.VT_NULL;
  end;

  method VarIsEmpty(const var aVar: Variant): Boolean; public;
  begin
    exit VarType(aVar.n1.n2.vt) = VarType.VT_NULL;
  end;

  method VarConvert(const var aLeft: Variant; aTarget: VarType): Variant; public;
  begin
    case rtl.VariantChangeType(@result, @aLeft, 0, Integer(aTarget)) of
      rtl.S_OK: ;
      else raise new ArgumentException('Cannot convert variant');
    end;
  end;


  operator implicit(const var aLeft: Variant): String; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then exit default(OleString);
    if VarType(aLeft.n1.n2.vt) <> VarType.VT_BSTR then
      exit String(VarConvert(aLeft, VarType.VT_BSTR));
    exit String.FromPChar(aLeft.n1.n2.n3.bstrVal);
  end;


  operator implicit(const var aLeft: Variant): Integer; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal;
      VarType.VT_R4: exit Integer(aLeft.n1.n2.n3.fltVal);
      VarType.VT_R8: exit Integer(aLeft.n1.n2.n3.dblVal);
    end;
    exit Integer(VarConvert(aLeft, VarType.VT_I4));
  end;


  operator implicit(const var aLeft: Variant): Int16; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal;
      VarType.VT_R4: exit Int16(aLeft.n1.n2.n3.fltVal);
      VarType.VT_R8: exit Int16(aLeft.n1.n2.n3.dblVal);
    end;
    exit Int16(VarConvert(aLeft, VarType.VT_I2));
  end;


  operator implicit(const var aLeft: Variant): Int64; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal;
      VarType.VT_R4: exit Int64(aLeft.n1.n2.n3.fltVal);
      VarType.VT_R8: exit Int64(aLeft.n1.n2.n3.dblVal);
    end;
    exit Int64(VarConvert(aLeft, VarType.VT_I8));
  end;

  operator implicit(const var aLeft: Variant): SByte; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal;
      VarType.VT_R4: exit SByte(aLeft.n1.n2.n3.fltVal);
      VarType.VT_R8: exit SByte(aLeft.n1.n2.n3.dblVal);
    end;
    exit SByte(VarConvert(aLeft, VarType.VT_I1));
  end;


  operator implicit(const var aLeft: Variant): Boolean; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal <> 0;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal <> 0;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal <> 0;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal <> 0;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal <> 0;
    end;
    exit Boolean(VarConvert(aLeft, VarType.VT_BOOL));
  end;


  operator implicit(const var aLeft: Variant): Single; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal;
      VarType.VT_R4: exit Single(aLeft.n1.n2.n3.fltVal);
      VarType.VT_R8: exit Single(aLeft.n1.n2.n3.dblVal);
    end;
    exit Single(VarConvert(aLeft, VarType.VT_R4));
  end;


  operator implicit(const var aLeft: Variant): Double; public;
  begin
    if aLeft.n1.n2.vt in [VarType.VT_NULL, VarType.VT_EMPTY] then raise new ArgumentException('Variant is null');
    case VarType(aLeft.n1.n2.vt) of
      VarType.VT_BOOL: exit aLeft.n1.n2.n3.boolVal;
      VarType.VT_I1: exit aLeft.n1.n2.n3.bVal;
      VarType.VT_I2: exit aLeft.n1.n2.n3.iVal;
      VarType.VT_INT, VarType.VT_I4: exit aLeft.n1.n2.n3.lVal;
      VarType.VT_I8: exit aLeft.n1.n2.n3.llVal;
      VarType.VT_R4: exit Double(aLeft.n1.n2.n3.fltVal);
      VarType.VT_R8: exit Double(aLeft.n1.n2.n3.dblVal);
    end;
    exit Double(VarConvert(aLeft, VarType.VT_R8));
  end;

  operator implicit(aVal: Integer): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_I4);
    result.n1.n2.n3.lVal := aVal;
  end;

  operator implicit(aVal: SByte): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_I1);
    result.n1.n2.n3.bVal := aVal;
  end;

  operator implicit(aVal: Int16): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_I2);
    result.n1.n2.n3.iVal := aVal;
  end;

  operator implicit(aVal: Int64): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_I8);
    result.n1.n2.n3.llVal := aVal;
  end;

  operator implicit(aVal: Boolean): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_BOOL);
    result.n1.n2.n3.boolVal := if aVal then 1 else 0;
  end;
  operator implicit(aVal: Single): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_R4);
    result.n1.n2.n3.fltVal := aVal;
  end;

  operator implicit(aVal: Double): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_R8);
    result.n1.n2.n3.dblVal := aVal;
  end;

  operator implicit(aVal: DateTime): Variant; public;
  begin
    result.n1.n2.vt := Integer(VarType.VT_DATE);
    result.n1.n2.n3.date := DateTime.ToOleDate(aVal);
  end;

  operator implicit(aVal: String): Variant; public;
  begin
    if aVal = nil then
      result.n1.n2.vt := Integer(VarType.VT_NULL)
    else begin
      result.n1.n2.vt := Integer(VarType.VT_BSTR);
      result.n1.n2.n3.bstrVal := rtl.SysAllocStringLen(aVal.FirstChar, aVal.Length);
    end;
  end;

  method ObjectToVar(o: Object): Variant; public;
  begin
    if o = nil then begin
      result.n1.n2.vt := Integer(VarType.VT_NULL);
      exit;
    end else
      case o.GetType().Code of
        TypeCodes.Boolean: exit Variant(Boolean(o));
        TypeCodes.Char: exit Variant(String(Char(o)));
        TypeCodes.SByte: exit Variant(SByte(o));
        TypeCodes.Byte: exit Variant(Integer(SByte(o)));
        TypeCodes.Int16: exit Variant(Int16(o));
        TypeCodes.UInt16: exit Variant(Integer(UInt16(o)));
        TypeCodes.Int32: exit Variant(Integer(o));
        TypeCodes.UInt32: exit Variant(Int64(UInt32(o)));
        TypeCodes.Int64: exit Variant(Int64(o));
        TypeCodes.UInt64: exit Variant(Int64(UInt64(o)));
        TypeCodes.Single: exit Variant(Double(Single(o)));
        TypeCodes.Double: exit Variant(Double(o));
        TypeCodes.String: exit Variant(String(o));
      else
        if o is DateTime then
          exit Variant(DateTime(o));
      end;
    raise new ArgumentException('Variant type not supported');
  end;

  method VarToObject(v: Variant): Object; public;
  begin
    case VarType(v.n1.n2.vt) of
      VarType.VT_NULL, VarType.VT_EMPTY: exit nil;
      VarType.VT_BOOL: exit Boolean(v.n1.n2.n3.boolVal);
      VarType.VT_BSTR: exit String.FromPChar(v.n1.n2.n3.bstrVal);
      VarType.VT_I1: exit v.n1.n2.n3.bVal;
      VarType.VT_I2: exit v.n1.n2.n3.iVal;
      VarType.VT_I4: exit v.n1.n2.n3.lVal;
      VarType.VT_I8: exit v.n1.n2.n3.llVal;
      VarType.VT_R4: exit v.n1.n2.n3.fltVal;
      VarType.VT_R8: exit v.n1.n2.n3.dblVal;
      VarType.VT_DATE: exit DateTime.FromOleDate(v.n1.n2.n3.date);
    else
       raise new ArgumentException('Variant type not supported');
    end;
  end;
end.