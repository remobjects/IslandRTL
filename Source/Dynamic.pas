namespace RemObjects.Elements.System;

type
  DynamicGetFlags = public flags (None = 0, FollowedByCall = 1, CaseSensitive = 2, CallDefault = 4, NilSafe = 8, NilOnBindingFailure = 16) of Integer;
  DynamicBinaryOperator = public enum (
    None,
    &Add,
    Sub,
    Mul,
    IntDiv,
    &Div,
    &Mod,
    &Shl,
    &Shr,
    &UShr,
    &And,
    &Or,
    &Xor,
    GreaterEqual,
    LessEqual,
    Greater,
    Less,
    Equal,
    NotEqual,
    &Implies = 25,
    extended = 28,
    Pow = 29,
    BoolOr =   10000,
    BoolAnd =  10001);
  DynamicUnaryOperator = public enum (
    &Not = 0,
    Neg = 1,
    Plus = 5,
    Increment = 6,
    Decrement = 7,
    DecrementPost = 13,
    ExtendedPrefix = 14,
    ExtendedPostfix = 15
  );
  DynamicInvokeException = public class(Exception) end;
  DynamicHelpers = public static class
  protected
    method TryApplyIndexer(aInstance: Object; aArgs: array of Object; aSet: Boolean := false): Object;
    begin
      if length(aArgs) = 0 then exit aInstance;
      with matching lInst :=  &Array(aInstance) do begin
        if aSet then begin
          if (length(aArgs) <> 2) then
            raise new DynamicInvokeException('Cannot access indexer with more than 1 parameter');
          lInst.Set(Convert.ToInt32(aArgs[0]), aArgs[1]);
          exit;
        end else begin
          if (length(aArgs) <> 1) then
            raise new DynamicInvokeException('Cannot access indexer with more than 1 parameter');
          exit lInst.Get(Convert.ToInt32(aArgs[0]));
        end;
      end;
      var lName := aInstance.GetType.Properties.FirstOrDefault(a -> PropertyFlags.Default in a.Flags):Name;
      if aSet then
        SetMember(aInstance, coalesce(lName, 'Item'), 0, aArgs)
      else
        exit GetMember(aInstance, coalesce(lName, 'Item'), 0, aArgs);
    end;

    class method HasImplicit(aType1: &Type; aType2: &Type): Boolean;
    begin
      var lImplicits := aType1.Methods.Where(m -> (MethodFlags.Operator in m.Flags) and (m.Name = 'op_Implicit'));
      for lImplicit in lImplicits do begin
        if lImplicit.Arguments.Count > 0 then begin
          var lArg := lImplicit.Arguments.First;
          if lArg.Type = aType2 then
            exit true;
        end;
      end;
      result := false;
    end;

    method FindBestMatch(aItems: DynamicMethodGroup; aArgs: array of Object): &MethodInfo;
    begin
      for i: Integer := 0 to aItems.Count -1 do begin
        var lMeth := aItems[i];
        var lPars := lMeth.Arguments.ToArray;
        if length(lPars) <> length(aArgs) then continue;
        for j: Integer := 0 to lPars.Length -1 do begin
          var lType := lPars[j].Type;
          if lType = nil then begin
            lPars := nil;
            break;
          end;
          if aArgs[j] = nil then begin
            if lPars[j].Type.IsValueType then begin
              lPars := nil;
              break;
            end;
          end else
          if not lPars[j].Type.IsAssignableFrom(aArgs[j].GetType)  then begin
            if lPars[j].Type.IsFloat and aArgs[j].GetType.IsIntegerOrFloat then begin
            end else if lPars[j].Type.IsInteger and aArgs[j].GetType.IsInteger then begin
            end else if lPars[j].Type.IsEnum and aArgs[j].GetType.IsInteger then begin
            end else if HasImplicit(lPars[j].Type, aArgs[j].GetType) then begin
            end else begin
              lPars := nil;
              break;
            end;
          end;
        end;
        if lPars <> nil then begin
          for j: Integer := 0 to lPars.Length -1 do begin
            if not lPars[j].Type.IsAssignableFrom(aArgs[j].GetType)  then begin
              case lPars[j].Type.Code of
                TypeCodes.SByte: aArgs[j] := Convert.ToSByte(aArgs[j]);
                TypeCodes.Byte: aArgs[j] := Convert.ToByte(aArgs[j]);
                TypeCodes.Int16: aArgs[j] := Convert.ToInt16(aArgs[j]);
                TypeCodes.UInt16: aArgs[j] := Convert.ToUInt16(aArgs[j]);
                TypeCodes.Int32: aArgs[j] := Convert.ToInt32(aArgs[j]);
                TypeCodes.UInt32: aArgs[j] := Convert.ToUInt32(aArgs[j]);
                TypeCodes.Int64: aArgs[j] := Convert.ToInt64(aArgs[j]);
                TypeCodes.UInt64: aArgs[j] := Convert.ToUInt64(aArgs[j]);
                TypeCodes.Single: aArgs[j] := Convert.ToSingle(aArgs[j]);
                TypeCodes.Double: aArgs[j] := Convert.ToDouble(aArgs[j]);
              end;
            end;
          end;
          exit lMeth;
        end;
      end;
      exit nil;
    end;
  public
    method GetMember(aInstance: Object; aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    begin
      if aInstance = nil then begin
        if DynamicGetFlags.NilSafe in DynamicGetFlags(aGetFlags) then exit nil;
        raise new NullReferenceException;
      end;
      var lDyn := IDynamicObject(aInstance);
      if lDyn <> nil then begin
        exit lDyn.GetMember(aName, aGetFlags, aArgs);
      end;

      if aName = nil then begin
        exit TryApplyIndexer(aInstance, aArgs);
      end;
      var lCL := &Type(aInstance);
      var lStatic := lCL <> nil;
      if not lStatic then lCL := aInstance.GetType;

      while lCL <> nil do begin
        if length(aArgs) = 0 then begin
          for each el in lCL.Fields do begin
            if (not lStatic or el.IsStatic)
             and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName) then begin
               exit el.GetValue(if el.IsStatic then nil else aInstance);
            end;
          end;
          if (DynamicGetFlags.CallDefault in DynamicGetFlags(aGetFlags)) and (DynamicGetFlags.FollowedByCall not in DynamicGetFlags(aGetFlags))  then
          for each el in lCL.Methods do begin
            if (not lStatic or el.IsStatic)
              and (el.Arguments.Count = 0)
              and (el.Type <> nil)
              and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName) then begin
               exit el.Invoke(aInstance, []);
            end;
          end;

          var lMethods := lCL.Methods.Where(el ->(not lStatic or el.IsStatic)
            and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName)).ToList;
          if lMethods.Count <> 0 then begin
            if length(aArgs) <> 0 then
              raise new DynamicInvokeException('Indexer parameters cannot be applied to method group');

            exit new DynamicMethodGroup(aInstance, lMethods);
          end;
        end;
        var lProps := lCL.Properties.Where(el ->(not lStatic or el.IsStatic)
            and (el.Arguments.Count = length(aArgs))
            and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName)).Select(a -> a.Read).Where(a -> a <> nil).ToList;
        if lProps.Count > 0 then begin
          var lMethod := FindBestMatch(new DynamicMethodGroup(aInstance, lProps), aArgs);
          if lMethod <> nil then begin
            exit lMethod.Invoke(aInstance, aArgs);
          end;
        end;
        var lEvents := lCL.Events.Where(el ->(not lStatic or el.IsStatic) and (el.Name = aName));
        if lEvents.Count = 1 then
          exit new DynamicEventInfo(aInstance, lEvents.First);

        lCL := if lCL.fValue^.ParentType <> nil then new &Type(lCL.fValue^.ParentType) else nil;
      end;

      if DynamicGetFlags.NilOnBindingFailure in DynamicGetFlags(aGetFlags) then exit nil;
      raise new DynamicInvokeException('No element with this name: '+aName);
    end;

    class method UnwrapValue(o: Object): Object;
    begin
      var lStr := IString(o);
      if lStr <> nil then
        exit lStr.ToString;
      exit o;
    end;

    method SetMember(aInstance: Object; aName: String; aGetFlags: Integer; aArgs: array of Object);
    begin
      if aInstance = nil then begin
        if DynamicGetFlags.NilSafe in DynamicGetFlags(aGetFlags) then exit ;
        raise new NullReferenceException;
      end;
      for i: Integer := 0 to aArgs.Length -1 do aArgs[i] := UnwrapValue(aArgs[i]);

      var lDyn := IDynamicObject(aInstance);
      if lDyn <> nil then begin
        lDyn.SetMember(aName, aGetFlags, aArgs);
        exit;
      end;

      if aName = nil then begin
        TryApplyIndexer(aInstance, aArgs);
        exit;
      end;
      var lCL := &Type(aInstance);
      var lStatic := lCL <> nil;
      if not lStatic then lCL := aInstance.GetType;
      if aArgs.Length = 0 then raise new Exception('No value provided for SetMember');

      while lCL <> nil do begin
        if length(aArgs) = 1 then begin
          for each el in lCL.Fields do begin
            if (not lStatic or el.IsStatic)
             and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName) then begin
              el.SetValue(aInstance, aArgs[0]);
              exit;
            end;
          end;
        end;
        var lProps := lCL.Properties.Where(el ->(not lStatic or el.IsStatic)
            and (el.Arguments.Count = length(aArgs)-1)
            and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName)).Select(a -> a.Write).Where(a -> a <> nil).ToList;
        if lProps.Count > 0 then begin
          var lMethod := FindBestMatch(new DynamicMethodGroup(aInstance, lProps), aArgs);
          if lMethod <> nil then begin
            lMethod.Invoke(aInstance, aArgs);
            exit;
          end;
        end;
        lCL := if lCL.fValue^.ParentType <> nil then new &Type(lCL.fValue^.ParentType) else nil;
      end;

      if DynamicGetFlags.NilOnBindingFailure in DynamicGetFlags(aGetFlags) then exit;
      raise new DynamicInvokeException('No element with this name: '+aName);
    end;

    method Invoke(aInstance: Object; aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    begin
      for i: Integer := 0 to aArgs.Length -1 do aArgs[i] := UnwrapValue(aArgs[i]);
      var lDyn := IDynamicObject(aInstance);
      if lDyn <> nil then exit lDyn.Invoke(aName, aGetFlags, aArgs);

      exit Invoke(GetMember(aInstance, aName, aGetFlags or Integer(DynamicGetFlags.FollowedByCall), nil), aGetFlags, aArgs);
    end;

    method Invoke(aInstance: Object;  aGetFlags: Integer; aArgs: array of Object): Object;
    begin
      if aInstance = nil then begin
        if DynamicGetFlags.NilSafe in DynamicGetFlags(aGetFlags) then exit nil;
        if DynamicGetFlags.NilOnBindingFailure in DynamicGetFlags(aGetFlags) then exit nil;
        raise new NullReferenceException;
      end;
      var lDyn := IDynamicObject(aInstance);
      if lDyn <> nil then exit lDyn.Invoke(nil, aGetFlags, aArgs);
      if aInstance is &Type then begin
        aInstance := new DynamicMethodGroup(nil, &Type(aInstance).Methods.Where(a -> MethodFlags.Constructor in a.Flags).ToList);
      end;
      var lEvent := DynamicEventInfo(aInstance);
      if lEvent ≠ nil then begin
        var lMeth := lEvent.ResolveEvent;
        if lMeth = nil then
          raise new DynamicInvokeException('No event found');
        exit lMeth.Invoke(if lEvent.Inst is &Type then nil else lEvent.Inst, aArgs);
      end;
      var lGroup := DynamicMethodGroup(aInstance);
      if lGroup = nil then
        lGroup := GetMember(aInstance, 'Invoke', Integer(DynamicGetFlags.FollowedByCall), nil) as DynamicMethodGroup;
      if lGroup = nil then
        raise new DynamicInvokeException('No overload with these parameters');
      var lMethod: &MethodInfo := FindBestMatch(lGroup, aArgs);
      if lMethod = nil then
        raise new DynamicInvokeException('No overload with these parameters');
      if MethodFlags.Constructor in lMethod.Flags then begin
        result := InternalCalls.Cast<Object>(DefaultGC.New(lMethod.DeclaringType.RTTI, lMethod.DeclaringType.SizeOfType));
        lMethod.Invoke(result, aArgs);
        exit;
      end;
      exit lMethod.Invoke(if lGroup.Inst is &Type then nil else lGroup.Inst, aArgs);
    end;

    method Binary(aLeft, aRight: Object; aOp: Integer): Object;
    begin
      var lVal := IDynamicObject(aLeft);
      if assigned(lVal) and lVal.Binary(aRight, true, DynamicBinaryOperator(aOp), out result) then exit;
      lVal := IDynamicObject(aRight);
      if assigned(lVal) and lVal.Binary(aLeft, false, DynamicBinaryOperator(aOp), out result) then exit;

      case DynamicBinaryOperator(aOp) of
        DynamicBinaryOperator.Add:
          begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) + Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) + Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) + Convert.ToDouble(aRight);
            if (lL.Code = TypeCodes.String) or (lR.Code = TypeCodes.String) then
              exit aLeft.ToString + aRight.ToString;
          end;
        DynamicBinaryOperator.Sub:
          begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) - Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) - Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) - Convert.ToDouble(aRight);
        end;

        DynamicBinaryOperator.Mul:
          begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) * Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) * Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) * Convert.ToDouble(aRight);
          end;

        DynamicBinaryOperator.IntDiv,
        DynamicBinaryOperator.Div:
          begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) / Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) / Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) / Convert.ToDouble(aRight);
          end;

        DynamicBinaryOperator.Mod:
        begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) mod Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) mod Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) mod Convert.ToDouble(aRight);
          end;

        DynamicBinaryOperator.Shl:
        begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) shl Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) shl Convert.ToUInt64(aRight);
          end;
        DynamicBinaryOperator.Shr:
        begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) shr Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) shr Convert.ToUInt64(aRight);
          end;
        DynamicBinaryOperator.And:
        begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if (lL.Code = TypeCodes.Boolean) and (lR.Code = TypeCodes.Boolean) then
              exit Boolean(aLeft) and Boolean(aRight);
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) and Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) and Convert.ToUInt64(aRight);
          end;
        DynamicBinaryOperator.Or:
        begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if (lL.Code = TypeCodes.Boolean) and (lR.Code = TypeCodes.Boolean) then
              exit Boolean(aLeft) or Boolean(aRight);
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) or Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) or Convert.ToUInt64(aRight);
          end;
        DynamicBinaryOperator.Xor:
        begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if (lL.Code = TypeCodes.Boolean) and (lR.Code = TypeCodes.Boolean) then
              exit Boolean(aLeft) xor Boolean(aRight);
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) xor Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) xor Convert.ToUInt64(aRight);
          end;
        DynamicBinaryOperator.Less: begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) < Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) < Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) < Convert.ToDouble(aRight);
            if (lL.Code = TypeCodes.String) or (lR.Code = TypeCodes.String) then
              exit aLeft.ToString < aRight.ToString;
        end;
        DynamicBinaryOperator.GreaterEqual: begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) >= Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) >= Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) >= Convert.ToDouble(aRight);
            if (lL.Code = TypeCodes.String) or (lR.Code = TypeCodes.String) then
              exit aLeft.ToString >= aRight.ToString;
        end;
        DynamicBinaryOperator.LessEqual: begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) <= Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) <= Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) <= Convert.ToDouble(aRight);
            if (lL.Code = TypeCodes.String) or (lR.Code = TypeCodes.String) then
              exit aLeft.ToString <= aRight.ToString;
        end;
        DynamicBinaryOperator.Greater: begin
            if (aLeft = nil) or (aRight = nil) then exit nil;
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) < Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) > Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) > Convert.ToDouble(aRight);
            if (lL.Code = TypeCodes.String) or (lR.Code = TypeCodes.String) then
              exit aLeft.ToString > aRight.ToString;
        end;
        DynamicBinaryOperator.Equal: begin
            if (aLeft = nil) or (aRight = nil) then exit (aLeft = nil) and (aRight = nil);
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) = Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) = Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) = Convert.ToDouble(aRight);
            if (lL.Code in [TypeCodes.Char, TypeCodes.String]) or (lR.Code in [TypeCodes.Char, TypeCodes.String]) then
              exit aLeft.ToString = aRight.ToString;
            if (lL.Code = TypeCodes.Boolean) or (lR.Code = TypeCodes.Boolean) then
              exit Boolean(aLeft) = Boolean(aRight);
            exit Object.ReferenceEquals(aLeft, aRight);
        end;
        DynamicBinaryOperator.NotEqual: begin
            if (aLeft = nil) or (aRight = nil) then exit not ((aLeft = nil) and (aRight = nil));
            var lL := aLeft.GetType;
            var lR := aRight.GetType;
            if lL.IsInteger and lR.IsInteger then
              if lL.IsSigned and lR.IsSigned then
                exit Convert.ToInt64(aLeft) <> Convert.ToInt64(aRight)
              else
                exit Convert.ToUInt64(aLeft) <> Convert.ToUInt64(aRight);
            if lL.IsIntegerOrFloat and lR.IsIntegerOrFloat then
              exit Convert.ToDouble(aLeft) <> Convert.ToDouble(aRight);
            if (lL.Code in [TypeCodes.Char, TypeCodes.String]) or (lR.Code in [TypeCodes.Char, TypeCodes.String]) then
              exit aLeft.ToString <> aRight.ToString;
            if (lL.Code = TypeCodes.Boolean) or (lR.Code = TypeCodes.Boolean) then
              exit Boolean(aLeft) <> Boolean(aRight);
          exit not Object.ReferenceEquals(aLeft, aRight);
        end;

      end;

      raise new Exception('Binary operator '+aOp+' not supported on these type');
    end;

    method Unary(aLeft: Object; aOp: Integer): Object;
    begin
      var lVal := IDynamicObject(aLeft);
      if assigned(lVal) and lVal.Unary(DynamicUnaryOperator(aOp), out result) then exit;
      case DynamicUnaryOperator(aOp) of
        DynamicUnaryOperator.Not: begin
          if aLeft = nil then exit nil;
          case TypeCodes(aLeft.GetType.Code) of
            TypeCodes.Boolean: exit not Boolean(aLeft);
            TypeCodes.SByte: exit not SByte(aLeft);
            TypeCodes.Byte: exit not Byte(aLeft);
            TypeCodes.Int16: exit not Int16(aLeft);
            TypeCodes.UInt16: exit not UInt16(aLeft);
            TypeCodes.Int32: exit not Int32(aLeft);
            TypeCodes.UInt32: exit not UInt32(aLeft);
            TypeCodes.Int64: exit not Int64(aLeft);
            TypeCodes.UInt64: exit not UInt64(aLeft);
            TypeCodes.IntPtr: exit not IntPtr(aLeft);
            TypeCodes.UIntPtr: exit not UIntPtr(aLeft);
          end;
        end;
        DynamicUnaryOperator.Neg: begin
          if aLeft = nil then exit nil;
          case TypeCodes(aLeft.GetType.Code) of
            TypeCodes.SByte: exit - SByte(aLeft);
            TypeCodes.Int16: exit - Int16(aLeft);
            TypeCodes.Int32: exit - Int32(aLeft);
            TypeCodes.Int64: exit - Int64(aLeft);
            TypeCodes.Single: exit - Single(aLeft);
            TypeCodes.Double: exit - Double(aLeft);
          end;
        end;
        DynamicUnaryOperator.Plus:
          exit aLeft;
      end;
      raise new Exception('Unary operator '+aOp+' not supported on this type');
    end;
  end;

  IDynamicObject = public interface
    method GetMember(aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    method SetMember(aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    method Invoke(aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    method Unary(aOp: DynamicUnaryOperator; out aResult: Object): Boolean;
    method Binary(aOther: Object; aSelfIsLeftSide: Boolean; aOp: DynamicBinaryOperator; out aResult: Object): Boolean;
    method IsType(aType: String): Boolean;
    begin
      exit false;
    end;
  end;

  DynamicMethodGroup = public class
  private
    fItems: ImmutableList<&MethodInfo>;
    fInst: Object;
  public
    constructor(aInst: Object; aItems: ImmutableList<&MethodInfo>);
    begin
      fItems := aItems;
      fInst := aInst;
    end;
    property Inst: Object read fInst;
    property Count: Integer read fItems.Count;
    property Item[i: Integer]: &MethodInfo read fItems[i]; default;
  end;

  DynamicEventInfo = public class
  private
    fEvent: EventInfo;
    fInst: Object;
  public
    constructor(aInst: Object; aEvent: EventInfo);
    begin
      fEvent := aEvent;
      fInst := aInst;
    end;

    method ResolveEvent: MethodInfo;
    begin
      var lRM := fEvent.FireMethod;
      if lRM = nil then exit nil;
      exit fEvent.DeclaringType.Methods.FirstOrDefault(a -> a.Pointer = lRM);
    end;
    property Inst: Object read fInst;
    property &Event: EventInfo read fEvent;
  end;

end.