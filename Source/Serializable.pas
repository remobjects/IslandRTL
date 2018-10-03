namespace RemObjects.Elements.System;

type
  ISerializable = public interface
    method Serialize(aSerializer: Serializer);
  end;

  IDeserializable = public interface
    method Deserialize(aDerializationType: DeserializerType; aDeserializer: Deserializer);
  end;

  [AttributeUsage(AttributeTargets.Property)]
  NotSerializable = public class(Attribute)
  end;

  Serializer = public abstract class
  public
    /// <summary>Select a property, this is generally used to set the next name of the thing to write</summary>
    method SelectProperty(aProperty: PropertyInfo); abstract;
    /// <summary>Write basic value like ints, strings</summary>
    method WriteValue(aValue: Object); abstract;
    /// <summary>Start a list</summary>
    method StartList(); abstract;
    /// <summary>End a list</summary>
    method EndList;  abstract;
    /// <summary>Start an object</summary>
    method StartObject(); abstract;
    /// <summary>End an object</summary>
    method EndObject; abstract;

    method Write(anObj: Object);
    begin
      if anObj = nil then exit;
      var lSer := ISerializable(anObj);
      if lSer <> nil then begin
        lSer.Serialize(self);
        exit;
      end;
      var lType := anObj.GetType;
      if lType.Code <> TypeCodes.None then begin
        // low level value (ints, strings, floats)
        WriteValue(anObj);
        exit;
      end;
      if lType.IsEnum then begin
        WriteValue(anObj);
        exit;
      end;

      StartObject();
      for each el in lType.Properties do begin
        if el.IsStatic then continue;
        if el.Attributes.Any(a -> a.Type = typeOf(NotSerializable)) then continue;
        if el.Arguments.Any then continue;
        if el.Access = MemberAccess.Private then continue;
        if el.ReadMethod = nil then continue;
        SelectProperty(el);
        if typeOf(IList).IsAssignableFrom(el.Type) then begin
          var lList := el.GetValue(anObj, []) as IList;
          if lList = nil then continue;
          StartList();
          for i: Integer := 0 to lList.Count -1 do
            Write(lList[i]);
          EndList;
          continue;
        end;
        if el.WriteMethod = nil then continue;
        Write(el.GetValue(anObj, []));
      end;
      EndObject;
    end;
  end;

  SerializationException = public class(Exception)
  end;

  DeserializerType = public enum (None, List, Object, Simple);

  Deserializer = public abstract class
  public
    /// <summary>Select a property, this is generally used to set the next name of the thing to read</summary>
    method SelectProperty(aProp: PropertyInfo; out aHint: &Type): DeserializerType; abstract;
    /// <summary>Read the current value as a simple value</summary>
    method ReadValue: Object; abstract;
    /// <summary>Returns true if this is the end of a list, and ends the list. False if there's more stuff to read</summary>
    method EndList; abstract;
    /// <summary>Ends an object</summary>
    method EndObject; abstract;
    /// <summary>Select a list element by index</summary>
    method SelectListElement(aIndex: Integer; out aHint: &Type): DeserializerType; abstract;

    method Read(aType: &Type; aDT: DeserializerType; aDest: Object): Object;
    begin
      if aDT = DeserializerType.None then exit nil;
      if aDT <> DeserializerType.Simple then
        result := coalesce(aDest, aType.Instantiate);
      if result is IDeserializable then begin
        IDeserializable(result).Deserialize(aDT, self);
        exit;
      end;

      if aType.IsEnum then begin
        aType := aType.Fields.FirstOrDefault(a -> not a.IsStatic).Type;
        if aType = nil then exit nil;
      end;
      if aType.Code <> TypeCodes.None then begin
        if aDT <> DeserializerType.Simple then raise new SerializationException('Simple serialization type expected');
        case aType.Code of
          TypeCodes.Boolean: exit Convert.ToInt32(ReadValue) <> 0;
          TypeCodes.AnsiChar: exit AnsiChar(Convert.ToInt32(ReadValue));
          TypeCodes.Byte: exit Convert.ToByte(ReadValue);
          TypeCodes.Char: exit Char(Convert.ToInt32(ReadValue));
          TypeCodes.Double: exit Convert.ToDouble(ReadValue);
          TypeCodes.Int16: exit Convert.ToInt16(ReadValue);
          TypeCodes.Int32: exit Convert.ToInt32(ReadValue);
          TypeCodes.Int64: exit Convert.ToInt64(ReadValue);
          TypeCodes.IntPtr: exit IntPtr(Convert.ToInt64(ReadValue));
          TypeCodes.UInt16: exit Convert.ToUInt16(ReadValue);
          TypeCodes.UInt32: exit Convert.ToUInt32(ReadValue);
          TypeCodes.UInt64: exit Convert.ToUInt64(ReadValue);
          TypeCodes.UIntPtr: exit IntPtr(Convert.ToUInt64(ReadValue));
          TypeCodes.SByte: exit Convert.ToSByte(ReadValue);
          TypeCodes.Single: exit Convert.ToSingle(ReadValue);
          TypeCodes.String: exit ReadValue:ToString;
        else
          raise new SerializationException('Invalid type code');
        end;
      end;

      if typeOf(IList).IsAssignableFrom(aType) then begin
        if aDT <> DeserializerType.List then raise new SerializationException('List serialization type expected');
        result := coalesce(aDest, aType.Instantiate());

        var lSubType := aType.GenericArguments.FirstOrDefault;
        var lIndex := 0;
        loop begin
          var lItem := SelectListElement(lIndex, out var lHint);
          if lItem = DeserializerType.None then break;
          var lVal: Object := Read(coalesce(lHint, lSubType), lItem, nil);
          IList(result).Add(lVal);
          inc(lIndex);
        end;
        EndList;
        exit;
      end;

      if aDT <> DeserializerType.Object then  raise new SerializationException('Object serialization type expected');

      for each el in aType.Properties do begin
        if el.IsStatic then continue;
        if el.Attributes.Any(a -> a.Type = typeOf(NotSerializable)) then continue;
        if el.Arguments.Any then continue;
        if el.Access = MemberAccess.Private then continue;
        if el.ReadMethod = nil then continue;
        var lHint: &Type;
        var lDT := SelectProperty(el, out lHint);
        if lDT = DeserializerType.None then continue;
        if (lDT <> DeserializerType.List) and (el.WriteMethod = nil) then continue;
        var lValue := Read(coalesce(lHint, el.Type), lDT, if (lDT = DeserializerType.List) and ((el.WriteMethod = nil) or (el.Write.Access = MemberAccess.Private)) then el.GetValue(result, []));
        if lValue = nil then continue;

        if (lDT =  DeserializerType.List) and ((el.WriteMethod = nil) or (el.Write.Access = MemberAccess.Private)) then  begin
          continue;
        end;
        el.SetValue(result, [], lValue);
      end;
      EndObject;
    end;
  end;

end.