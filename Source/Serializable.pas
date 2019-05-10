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
    method SelectProperty(aFirst: Boolean; aProperty: PropertyInfo); abstract;
    /// <summary>Write basic value like ints, strings</summary>
    method WriteValue(aValue: Object); abstract;
    /// <summary>Start a list</summary>
    method StartList(); abstract;
    /// <summary>Starts a new list entry</summary>
    method StartListEntry(aFirst: Boolean); virtual; empty;
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
      var lFirst := true;
      for each el in lType.Properties do begin
        if el.IsStatic then continue;
        if el.Attributes.Any(a -> a.Type = typeOf(NotSerializable)) then continue;
        if el.Arguments.Any then continue;
        if el.Access = MemberAccess.Private then continue;
        if el.ReadMethod = nil then continue;
        SelectProperty(lFirst, el);
        lFirst := false;
        if typeOf(IList).IsAssignableFrom(el.Type) then begin
          var lList := el.GetValue(anObj, []) as IList;
          if lList = nil then continue;
          StartList();
          for i: Integer := 0 to lList.Count -1 do begin
            StartListEntry(i = 0);
            Write(lList[i]);
          end;
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
    /// <summary>
    /// Trigger start of Object
    /// </summary>
    method StartObject; virtual; empty;
    /// <summary>Trigger start of list</summary>
    method StartList; virtual; empty;
    /// <summary>Select a list element by index</summary>
    method SelectListElement(aIndex: Integer; out aHint: &Type): DeserializerType; abstract;

    method Read<T>(): T; 
    begin 
      var lType := typeOf(T);
      case lType.Code of
        TypeCodes.Boolean,
        TypeCodes.AnsiChar,
        TypeCodes.Byte,
        TypeCodes.Char,
        TypeCodes.Double,
        TypeCodes.Int16,
        TypeCodes.Int32,
        TypeCodes.Int64,
        TypeCodes.IntPtr,
        TypeCodes.UInt16,
        TypeCodes.UInt32,
        TypeCodes.UInt64,
        TypeCodes.UIntPtr,
        TypeCodes.SByte,
        TypeCodes.Single,
        TypeCodes.String: exit &Read(lType, DeserializerType.Simple, nil) as T;
      end;
      result := lType.Instantiate as T;
      if result is IDeserializable then begin
        IDeserializable(result).Deserialize(DeserializerType.None, self);
        exit;
      end;
      if result is IList then 
        exit &Read(lType, DeserializerType.List, result) as T;

      exit &Read(lType, DeserializerType.Object, result) as T;
    end;


    method Skip; virtual; protected;
    begin 
      raise new NotSupportedException;
    end;

    method ReadNext(out aName: String; out aType: DeserializerType); virtual; empty; protected;
    /// <summary>
    ///  If true, the reader provides info on what it's currently reading.
    /// </summary>
    property ReaderProvidesNameAndType: Boolean read false; virtual; protected;

    method Read(aType: &Type; aDT: DeserializerType; aDest: Object): Object;
    begin
      if aDT = DeserializerType.None then exit nil;
      if aDT <> DeserializerType.Simple then begin
        if aType.IsSubclassOf(typeOf(&Array)) then 
          aDest := coalesce(aDest, new List<Object>)
        else
          aDest := coalesce(aDest, aType.Instantiate);
        result := aDest;
      end;
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
        StartList;
        loop begin
          var lItem := SelectListElement(lIndex, out var lHint);
          if lItem = DeserializerType.None then break;
          var lVal: Object := Read(coalesce(lHint, lSubType), lItem, nil);
          IList(result).Add(lVal);
          inc(lIndex);
        end;
        EndList;
        if aType.IsSubclassOf(typeOf(&Array)) and (result is List<Object>) then begin 
          var lSub := aType.GenericArguments.FirstOrDefault;
          var lRes := InternalCalls.Cast<&Array>(Utilities.NewArray(aType.RTTI, if lSub.IsValueType then  lSub.SizeOfType else sizeOf(^Void), List<Object>(result).Count));
          for i: Integer := 0 to List<Object>(result).Count -1 do 
            lRes.&Set(i, List<Object>(result)[i]);

          exit lRes;
        end;
        exit;
      end;

      if aDT <> DeserializerType.Object then  raise new SerializationException('Object serialization type expected');

      StartObject;
      if ReaderProvidesNameAndType then begin 
        loop begin 
          ReadNext(out var lName, out var lType);
          if lType = DeserializerType.None then break;
          var el := aType.Properties.FirstOrDefault(a -> not a.IsStatic and (a.Name = lName) and (a.ReadMethod <> nil) and (a.Access <> MemberAccess.Private) and not a.Attributes.Any(b -> b.Type = typeOf(NotSerializable)));
          if el = nil then 
            &Skip
          else begin 
            if (lType <> DeserializerType.List) and (el.WriteMethod = nil) then continue;
            var lValue := Read(el.Type, lType, if (lType = DeserializerType.List) and ((el.WriteMethod = nil) or (el.Write.Access = MemberAccess.Private)) then el.GetValue(result, []));
            if lValue = nil then continue;

            if (lType =  DeserializerType.List) and ((el.WriteMethod = nil) or (el.Write.Access = MemberAccess.Private)) then  begin
              continue;
            end;
            el.SetValue(result, [], lValue);
          end;
        end;
      end else begin
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
      end;
      EndObject;
    end;
  end;


    JsonSerializer = public class(Serializer)
  private
    var fSB: StringBuilder := new StringBuilder;
  public
    method EndList; override;
    begin 
      fSB.Append(']');
    end;

    method EndObject; override;
    begin 
      fSB.Append('}');
    end;

    method StartObject; override;
    begin 
      fSB.Append('{');
    end;

    method StartList; override;
    begin 
      fSB.Append('[');
    end;

    method ToHexString(c:  Int64; len: Integer): String;
    begin 
      while len > 0 do begin 
        result := case c and $f of 
          0: '0';
          1: '1';
          2: '2';
          3: '3';
          4: '4';
          5: '5';
          6: '6';
          7: '7';
          8: '8';
          9: '9';
          10: 'a';
          11: 'b';
          12: 'c';
          13: 'd';
          14: 'e';
          15: 'f';
        end + result;
        c := c shr 4;
        dec(len);
      end;
    end;

    method WriteString(Value: String);
    begin 
      fSB.Append('"');
      for i: Int32 := 0 to Value.Length-1 do begin
        var c := Value[i];
        case c of
          '\': fSB.Append("\\");
          '"': fSB.Append('\"');
          #8: fSB.Append('\b');
          #9: fSB.Append('\t');
          #10: fSB.Append('\n');
          #12: fSB.Append('\f');
          #13: fSB.Append('\r');
          #32..#33,
          #35..#91,
          #93..#127: fSB.Append(c);
          else 
            fSB.Append('\u'+ToHexString(Int32(c), 4));
        end;
      end;
      fSB.Append('"');
    end;

    method StartListEntry(aFirst: Boolean); override;
    begin 
      if not aFirst then 
        fSB.Append(',');
    end;

    method SelectProperty(aFirst: Boolean;aProperty: PropertyInfo); override;
    begin
      if not aFirst then 
        fSB.Append(',');
      WriteString(aProperty.Name);
      fSB.Append(':');
    end;
    
    method SelectProperty(aFirst: Boolean;aProperty: String); 
    begin
      if not aFirst then 
        fSB.Append(',');
      WriteString(aProperty);
      fSB.Append(':');
    end;

    method WriteValue(aValue: Object); override;
    begin 
      if aValue = nil then fSB.Append('null')
      else if aValue is String then WriteString(String(aValue))
      else if aValue is Double then fSB.Append(Double(aValue).ToString(Locale.Invariant))
      else if aValue is Boolean then begin if Boolean(aValue) then fSB.Append('true') else fSB.Append('false') end
      else begin
        fSB.Append(Convert.ToInt64(aValue).ToString);
      end;
    end;

    method ToString: String; override;
    begin 
      exit fSB.ToString;
    end;
  end;

  JsonTokenKind = assembly enum(EOF, String, Number, Null, &True, &False, ArrayStart, ArrayEnd, ObjectStart, ObjectEnd, NameSeperator, ValueSeperator, Identifier, SyntaxError);

  JsonException = public class(Exception) 
  end;
  JsonDeserializer = public class(Deserializer)
  private
    fInput: String;
    fPos, fLength: Integer;
    fTokVal: String;
    fTok: JsonTokenKind;
    fAtElementStart: Boolean;

    class method DecodeString(s: String): String;
    begin
      var sb := new StringBuilder;
      var lPosition := 1;
      s := s +#0;
      while (s[lPosition] <> #0) and (s[lPosition] <> '"') do begin

        if s[lPosition] = '\' then begin
          inc(lPosition);

          case s[lPosition] of
            '\': sb.Append("\");
            '"': sb.Append("""");
            '/': sb.Append("/");
            'b': sb.Append(#8);
            'f': sb.Append(#12);
            'r': sb.Append(#13);
            'n': sb.Append(#10);
            't': sb.Append(#9);
            'u': if s.Length > lPosition+4 then begin
              var lHex := s[lPosition+1]+s[lPosition+2]+s[lPosition+3]+s[lPosition+4];
              var lValue := Convert.HexStringToUInt64(lHex);
              sb.Append(Char(lValue));
              lPosition := lPosition + 4;
            end;
          end;
        end
        else
          sb.Append(s[lPosition]);

        inc(lPosition);
      end;

      exit sb.ToString;
    end;
  public
    method ReadNext(out aName: String; out aType: DeserializerType); override;
    begin 
      if fTok = JsonTokenKind.ObjectEnd then begin 
        aName := nil;
        aType := DeserializerType.None;
        exit;
      end;
      if not fAtElementStart then begin 
        if fTok <> JsonTokenKind.ValueSeperator then 
          raise new JsonException(', expected');
        Next;
      end;
      if fTok = JsonTokenKind.Identifier then 
        aName := fTokVal
      else if fTok = JsonTokenKind.String then 
        aName := DecodeString(fTokVal)
      else 
        raise new JsonException('String or Identifier expected');
      Next;
      if fTok <> JsonTokenKind.NameSeperator then 
        raise new JsonException(': expected after property name');
      Next;
      case fTok of 
        JsonTokenKind.ObjectStart: aType := DeserializerType.Object;
        JsonTokenKind.ArrayStart: aType := DeserializerType.List;
        JsonTokenKind.False, JsonTokenKind.True, JsonTokenKind.Null, JsonTokenKind.Number, JsonTokenKind.String: aType := DeserializerType.Simple;
      else 
        raise new JsonException('Value expected');
      end;
    end;

    method StartObject; override;
    begin 
      Next;
      fAtElementStart := true;
    end;

    method StartList; override;
    begin 
      Next;
      fAtElementStart := true;
    end;

    method Next; assembly;
    begin 
      fAtElementStart := false;
      fPos := fPos + fLength;
      restart:;
      if fPos = length(fInput) then begin 
        fTok := JsonTokenKind.EOF;
        fLength := 0;
        exit;
      end;
      fTokVal := nil;
      case fInput[fPos] of 
        #9, #32: begin 
          fLength := 1;
          goto restart;
        end;
        '[': begin 
          fTok := JsonTokenKind.ArrayStart;
          fLength := 1;
        end;
        ']': begin 
          fTok := JsonTokenKind.ArrayEnd;
          fLength := 1;
        end;
        '{': begin 
          fTok := JsonTokenKind.ObjectStart;
          fLength := 1;
        end;
        '}': begin 
          fTok := JsonTokenKind.ObjectEnd;
          fLength := 1;
        end;
        ':': begin 
          fTok := JsonTokenKind.NameSeperator;
          fLength := 1;
        end;
        ',': begin 
          fTok := JsonTokenKind.ValueSeperator;
          fLength := 1;
        end;
        '.', '0'..'9': begin 
          var lPos := fPos + 1;
          var lGotDot := fInput[fPos] = '.';
          while lPos < fInput.Length do begin 
            if (fInput[lPos] in ['0'..'9']) then 
              inc (lPos)
            else if not lGotDot and (fInput[lPos] ='.') then begin 
              inc(lPos);
              lGotDot := true;
            end else break;
          end;
          fTok := JsonTokenKind.Number;
          fLength := lPos - fPos;
          fTokVal := fInput.SubString(fPos, fLength);
        end;
        'a'..'z', '_', 'A'..'Z': begin 
          var lPos := fPos + 1;
          while lPos < fInput.Length do begin 
            if (fInput[lPos] in ['a'..'z', '_', 'A'..'Z', '0'..'9']) then 
              inc (lPos)
            else break;
          end;
          fTok := JsonTokenKind.Identifier;
          fLength := lPos - fPos;
          fTokVal := fInput.SubString(fPos, fLength);
          if fTokVal = 'null' then fTok := JsonTokenKind. Null else 
            if fTokVal = 'true' then fTok := JsonTokenKind. True else 
              if fTokVal = 'false' then fTok := JsonTokenKind. &False;
        end;
        '"': begin 
          var lPos := fPos + 1;
          while lPos < fInput.Length do begin 
            if (lPos+1 < fInput.Length) and (fInput[lPos] = '\') and (fInput[lPos+1]='"') then 
              inc (lPos, 2)
            else if fInput[lPos] = '"' then begin 
              inc (lPos);
              break;
            end
            else
              inc (lPos);
          end;
          fTok := JsonTokenKind.String;
          fLength := lPos - fPos;
          fTokVal := fInput.SubString(fPos, fLength);          
        end;
        // JsonTokenKind = assembly enum(String, NullSyntaxError);
        else begin 
          fLength := 0;
          fTok := JsonTokenKind.SyntaxError;
        end;
      end;
    end;

    property ReaderProvidesNameAndType: Boolean read true; override; 
    constructor(aInput: String);
    begin 
      fInput := aInput;
      Next;
    end;

    method EndList; override;
    begin 
      if fTok <> JsonTokenKind.ArrayEnd then raise new JsonException('] expected');
      Next;
    end;

    method EndObject; override;
    begin 
      if fTok <> JsonTokenKind.ObjectEnd then raise new JsonException('} expected');
      Next;
    end;

    method SelectProperty(aProp: PropertyInfo; out aHint: &Type): DeserializerType; override;
    begin 
      raise new JsonException('Invalid state');
    end;

    method ReadValue(): Object; override;
    begin 
      case fTok of 
        JsonTokenKind.String: begin result := DecodeString(fTokVal); Next end;
        JsonTokenKind.Number: begin result := if fTokVal.Contains('.') then Double.Parse(fTokVal, Locale.Invariant) else Int64.Parse(fTokVal); Next end;
        JsonTokenKind.Null: begin result := nil; Next end;
        JsonTokenKind.True: begin result := true; Next end;
        JsonTokenKind.False: begin result := false; Next end;
        else raise new JsonException('Invalid token, value expected');
      end;
    end;

    method SelectListElement(aIndex: Int32; out aHint: &Type): DeserializerType; override;
    begin 
      if fTok = JsonTokenKind.ArrayEnd then exit DeserializerType.None;
      if not fAtElementStart then begin 
        if fTok <> JsonTokenKind.ValueSeperator then 
          raise new JsonException(', expected');
        Next;
      end;
      case fTok of 
        JsonTokenKind.False, JsonTokenKind.True, JsonTokenKind.Null,
        JsonTokenKind.Number, JsonTokenKind.String: exit DeserializerType.Simple;
        JsonTokenKind.ArrayStart: exit DeserializerType.List;
        JsonTokenKind.ObjectStart: exit DeserializerType.Object;
        else exit DeserializerType.None;
      end;
    end;
  end;


end.