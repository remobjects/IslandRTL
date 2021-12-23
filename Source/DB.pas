namespace RemObjects.Elements.System;

type
  ConnectionState = public enum (Closed, Open, Connecting);
  IsolationLevel = public enum (Default, ReadUncommited, ReadCommited, RepeatedRead, Serializable);
  DbConnection = public abstract class(IDisposable)
  private
  protected
    method OpenIfNeeded;
    begin
      if State = ConnectionState.Closed then
        Open;
    end;
  public
    property ConnectionString: String;
    property State: ConnectionState read protected write;

    method Dispose; abstract;
    method Open; abstract;
    method BeginTransaction(aLevel: IsolationLevel := IsolationLevel.Default): DbTransaction; abstract;
    method CreateCommand(): DbCommand; abstract;
    method CreateCommand(aTrans: DbTransaction; aCommand: String := nil; aArgNames: array of String := nil; aArgValues: array of Object := nil): DbCommand;
    begin
      result := CreateCommand;
      result.Command := aCommand;
      if length(aArgNames) <> length(aArgValues) then raise new ArgumentException('aArgNames and aArgValues should match in length!');
      for i: Integer := 0 to length(aArgNames) -1 do
        result.AddParameter(aArgNames[i], aArgValues[i]);
    end;


    class method CompatibleType(aType: &Type): Boolean; private;
    begin
      if aType = nil then exit false;
      case aType.Code of
        TypeCodes.Boolean,
        TypeCodes.Char,
      TypeCodes.SByte,
        TypeCodes.Byte,
        TypeCodes.Int16,
        TypeCodes.UInt16,
        TypeCodes.Int32,
        TypeCodes.UInt32,
        TypeCodes.Int64,
        TypeCodes.UInt64,
        TypeCodes.Single,
        TypeCodes.Double,
        TypeCodes.IntPtr,
        TypeCodes.UIntPtr,
        TypeCodes.String: exit true;
      end;
      if aType = typeOf(DateTime) then exit true;
      if aType = typeOf(array of Byte) then exit true;
      exit false;
    end;

    method Execute(aCommand: String; aArgs: Object := nil; aTransaction: DbTransaction := nil): Integer;
    begin
      OpenIfNeeded;
      using lResult := CreateCommand(aTransaction, aCommand) do begin
        if aArgs <> nil then begin
          for each el in aArgs.GetType().Properties.Where(a -> not a.IsStatic and assigned(a.ReadMethod) and CompatibleType(a.Type) and (a.Arguments.Count = 0)) do begin
            lResult.AddParameter(el.Name, el.GetValue(aArgs, nil));
          end;
        end;
        exit lResult.ExecuteNonQuery;
      end;
    end;


    method ExecuteAsync(aCommand: String; aArgs: Object := nil; aTransaction: DbTransaction := nil): Task<Integer>;
    begin
      OpenIfNeeded;
      using lResult := CreateCommand(aTransaction, aCommand) do begin
        if aArgs <> nil then begin
          for each el in aArgs.GetType().Properties.Where(a -> not a.IsStatic and assigned(a.ReadMethod) and CompatibleType(a.Type) and (a.Arguments.Count = 0)) do begin
            lResult.AddParameter(el.Name, el.GetValue(aArgs, nil));
          end;
        end;
        exit lResult.ExecuteNonQueryAsync;
      end;
    end;

    method Query<T>(aCommand: String; aArgs: Object := nil; aTransaction: DbTransaction := nil): sequence of T; iterator;
    begin
      OpenIfNeeded;
      using lResult := CreateCommand(aTransaction, aCommand) do begin
        if aArgs <> nil then begin
          for each el in aArgs.GetType().Properties.Where(a -> not a.IsStatic and assigned(a.ReadMethod) and CompatibleType(a.Type) and (a.Arguments.Count = 0)) do begin
            lResult.AddParameter(el.Name, el.GetValue(aArgs, nil));
          end;
        end;
        var lMapper := typeOf(T).Properties.Where(a -> not a.IsStatic and assigned(a.ReadMethod) and assigned(a.WriteMethod) and CompatibleType(a.Type) and (a.Arguments.Count = 0)).ToList();
        using lReader := lResult.ExecuteReader do begin
          var lMap := new Integer[lReader.FieldCount];
          for i: Integer := 0 to lReader.FieldCount -1 do begin
            lMap[i] := lMapper.FindIndex(a -> a.Name.ToLower = lReader.FieldName[i].ToLower);
          end;
          while lReader.Read do begin
            var lRes := new T;
            for i: Integer := 0 to lMap.Length -1 do begin
              if lMap[i] = -1 then continue;
              var lTar := lMapper[lMap[i]];
              var lVal := lReader[i];
              if (lTar.Type = typeOf(DateTime)) and (lVal is Int64)  then
                lVal := new DateTime(Int64(lVal));
              lTar.SetValue(lRes, nil, lVal);
            end;
            yield lRes;
          end;

        end;
      end;
    end;

  end;

  DbTransaction = public abstract class(IDisposable)
  public
    method Commit; abstract;
    method Rollback; abstract;
    method Dispose; abstract;
  end;

  DbParameter = public class
  public
    property Name: String;
    property Value: Object;
  end;

  DbCommand = public abstract class(IDisposable)
  public
    property Transaction: DbTransaction;
    property Command: String;
    property Parameters: List<DbParameter> := new List<DbParameter>; readonly;
    method Dispose; abstract;
    method AddParameter(aName: String; aValue: Object := nil);
    begin
      Parameters.Add(new DbParameter(Name := aName, Value := aValue));
    end;
    method Prepare; abstract;
    method ExecuteReader: DbDataReader; abstract;
    method ExecuteNonQuery: Integer; abstract;
    method ExecuteReaderAsync: Task<DbDataReader>; virtual;
    begin
      exit Task.Run(-> ExecuteReader);
    end;
    method ExecuteNonQueryAsync: Task<Integer>; virtual;
    begin
      exit Task.Run(-> ExecuteNonQuery);
    end;
  end;

  DbDataReader = public abstract class(IDisposable)
  public
    property FieldCount: Integer read; abstract;
    property FieldName[i: Integer]: String read; abstract;
    property Item[i: Integer]: Object read; abstract; default;
    method Dispose; abstract;
    method Read: Boolean; abstract;
    method ReadAsync: Task<Boolean>; virtual;
    begin
      exit Task.Run(-> Read);
    end;
  end;

  SqlQueryParameterFixer = public static class
  private
  public
    // replaces @XYZ by calling a Func<String, String>; only outside of strings.
    class method FixString(aString: String; aReplacer: Func<String, String>): String;
    begin
      var lSQ := new StringBuilder;
      var lQuoteChar := #0;
      var i := 0;
      while i < aString.Length do begin
        var callInc := true;

        case aString[i] of
          '@': if lQuoteChar <> #0 then lSQ.Append(aString[i]) else begin
            inc(i);
            var lStart := i;
            while i < aString.Length do begin
              if aString[i] in ['a'..'z', 'A'..'Z', '0'..'9', '_'] then begin
                inc(i);
              end else break;
            end;
            lSQ.Append(aReplacer(aString.Substring(lStart, i - lStart)));
            callInc := false;
          end;
          '"', '`', '''': begin
            if lQuoteChar = aString[i] then lQuoteChar := #0 else
              if lQuoteChar = #0 then lQuoteChar := aString[i];
            lSQ.Append(aString[i])
          end;
          else
            lSQ.Append(aString[i])
          end;
        if(callInc)then
        begin
          inc(i);
        end;
      end;

      exit lSQ.ToString;
    end;
  end;

end.