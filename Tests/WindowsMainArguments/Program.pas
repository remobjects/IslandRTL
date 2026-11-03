// Positive startup guard: Main receives every argument unchanged, including an empty vector.
// Negative bounds guards: optimized runtime and LTO must preserve catchable array errors
// and execute finally cleanup exactly once while unwinding into the catch.
namespace WindowsMainArguments;

type
  Program = class
  private

    [DisableInlining]
    class method ReadAt(aValues: array of String; aIndex: Integer): String;
    begin
      exit aValues[aIndex];
    end;

    class method CheckBounds(aValues: array of String; aIndex: Integer);
    begin
      var lCaught := false;
      var lCleanupCount := 0;
      try
        try
          ReadAt(aValues, aIndex);
        finally
          inc(lCleanupCount);
        end;
      except
        on e: IndexOutOfRangeException do
          lCaught := true;
      end;
      if not lCaught or (lCleanupCount <> 1) then
        raise new Exception('Missing array bounds exception or incorrect cleanup count');
    end;

  public

    class method Main(aArgs: array of String): Integer;
    begin
      writeLn('ENTER Main');
      if not assigned(aArgs) then
        raise new Exception('Nil startup argument array');
      var lOther := Environment.GetCommandLineArgs;
      if length(lOther) <> length(aArgs) then
        raise new Exception('Command-line count differs');
      writeLn('COUNT=' + length(aArgs).ToString);
      for i := 0 to length(aArgs) - 1 do begin
        if not assigned(aArgs[i]) or (aArgs[i] <> lOther[i]) then
          raise new Exception('Command-line value differs');
        // Decimal UTF-16 units keep the runner independent of console encodings.
        var lLine := 'ARG=' + i.ToString + ':' + length(aArgs[i]).ToString;
        for each lChar in aArgs[i] do
          lLine := lLine + ':' + Integer(lChar).ToString;
        writeLn(lLine);
      end;
      CheckBounds(aArgs, -1);
      CheckBounds(aArgs, length(aArgs));
      var lEmpty := new String[0];
      CheckBounds(lEmpty, 0);
      writeLn('PASS Windows Main arguments and bounds');
      result := 0;
    end;

  end;
end.
