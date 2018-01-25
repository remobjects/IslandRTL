namespace RemObjects.Elements.System;

type
  DynamicGetFlags = public flags (None = 0, FollowedByCall = 1, CaseSensitive = 2, CallDefault = 4, NilSafe = 8, NilOnBindingFailure = 16) of Integer;
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

    method FindBestMatch(aItems: DynamicMethodGroup; aArgs: array of Object): &MethodInfo;
    begin
      for i: Integer := 0 to aItems.Count -1 do begin
        var lMeth := aItems[i];
        var lPars := lMeth.Arguments.ToArray;
        if length(lPars) <> length(aArgs) then continue;
        for j: Integer := 0 to lPars.Length -1 do begin
          if aArgs[j] = nil then begin
            if lPars[j].Type.IsValueType then begin
              lPars := nil;
              break;
            end;
          end else 
          if not lPars[j].Type.isAssignableFrom(aArgs[j].GetType)  then begin
            lPars := nil;
            break;
          end;
        end;
        if lPars <> nil then exit lMeth;
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
      
      if length(aArgs) = 0 then begin
        for each el in lCL.Fields do begin
          if (not lStatic or el.IsStatic)
           and if DynamicGetFlags.CaseSensitive in DynamicGetFlags(aGetFlags) then el.Name = aName else el.Name.EqualsIgnoreCase(aName) then begin
             exit el.GetValue(aInstance);
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
      
      if DynamicGetFlags.NilOnBindingFailure in DynamicGetFlags(aGetFlags) then exit nil;
      raise new DynamicInvokeException('No element with this name: '+aName);
    end;

    method SetMember(aInstance: Object; aName: String; aGetFlags: Integer; aArgs: array of Object);
    begin
      if aInstance = nil then begin
        if DynamicGetFlags.NilSafe in DynamicGetFlags(aGetFlags) then exit ;
        raise new NullReferenceException;
      end;
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
      
      if DynamicGetFlags.NilOnBindingFailure in DynamicGetFlags(aGetFlags) then exit;
      raise new DynamicInvokeException('No element with this name: '+aName);
    end;

    method Invoke(aInstance: Object; aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    begin
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
      if aInstance is &Type then
        raise new DynamicInvokeException('Cannot invoke class');
      var lGroup := DynamicMethodGroup(aInstance);
      if lGroup = nil then
        lGroup := GetMember(aInstance, 'Invoke', Integer(DynamicGetFlags.FollowedByCall), nil) as DynamicMethodGroup;
      if lGroup = nil then
        raise new DynamicInvokeException('No overload with these parameters');
      var lMethod: &MethodInfo := FindBestMatch(lGroup, aArgs);
      if lMethod = nil then
        raise new DynamicInvokeException('No overload with these parameters');
      exit lMethod.invoke(if lGroup.Inst is &Type then nil else lGroup.Inst, aArgs);
    end;
  end;

  IDynamicObject = public interface 
    method GetMember(aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    method SetMember(aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
    method Invoke(aName: String; aGetFlags: Integer; aArgs: array of Object): Object;
  end;

  DynamicMethodGroup = public class
  private
    fItems: List<&MethodInfo>;
    fInst: Object;
  public
    constructor(aInst: Object; aItems: List<&MethodInfo>);
    begin
      fItems := aItems;
      fInst := aInst;
    end;
    property Inst: Object read fInst;
    property Count: Integer read fItems.Count;
    property Item[i: Integer]: &MethodInfo read fItems[i]; default;
  end;

end.