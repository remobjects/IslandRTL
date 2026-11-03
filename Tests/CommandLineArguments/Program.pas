// Native argument guards: omit argv[0]/sentinel, preserve empty strings, reject nil/undecodable entries.
// Restore the process vector after every probe; this executable runs the shared startup conversion.
namespace CommandLineArgumentsTests;

type
  Program = class
  private

    class method Reject(aCount: Integer; aArgs: ^^AnsiChar; aMessage: String);
    begin
      ExternalCalls.nargs := aCount;
      ExternalCalls.args := aArgs;
      var lRejected := false;
      try
        Environment.GetCommandLineArgs;
      except
        on e: Exception do begin
          if e.Message <> aMessage then
            raise new Exception('Unexpected failure: ' + e.Message);
          lRejected := true;
        end;
      end;
      if not lRejected then
        raise new Exception('Invalid argument vector was accepted');
    end;

  public

    class method Main: Int32;
    begin
      var lOriginalCount := ExternalCalls.nargs;
      var lOriginalArgs := ExternalCalls.args;
      try
        var lEmpty := new AnsiChar[1];
        var lText := 'two words'.ToAnsiChars(true);
        var lInvalid := new AnsiChar[2];
        lInvalid[0] := AnsiChar($FF);
        var lVector := new ^AnsiChar[4];
        lVector[0] := @lText[0];
        lVector[1] := @lEmpty[0];
        lVector[2] := @lText[0];
        // The trailing nil is outside argc and must not be interpreted as a value.
        ExternalCalls.nargs := 3;
        ExternalCalls.args := @lVector[0];
        var lValues := Environment.GetCommandLineArgs;
        if (length(lValues) <> 2) or not assigned(lValues[0]) or
          (lValues[0] <> '') or (lValues[1] <> 'two words') then
          raise new Exception('Argument values changed');
        ExternalCalls.nargs := 1;
        lValues := Environment.GetCommandLineArgs;
        if not assigned(lValues) or (length(lValues) <> 0) then
          raise new Exception('Expected non-null empty array');
        ExternalCalls.nargs := 0;
        ExternalCalls.args := nil;
        lValues := Environment.GetCommandLineArgs;
        if not assigned(lValues) or (length(lValues) <> 0) then
          raise new Exception('Empty native vector must produce an empty array');
        Reject(-1, nil, 'Invalid native command-line argument vector');
        Reject(2, nil, 'Invalid native command-line argument vector');
        lVector[1] := nil;
        Reject(2, @lVector[0], 'Null command-line argument at index 1');
        lVector[1] := @lInvalid[0];
        Reject(2, @lVector[0], 'Could not decode command-line argument at index 1');
      finally
        ExternalCalls.nargs := lOriginalCount;
        ExternalCalls.args := lOriginalArgs;
      end;
      writeLn('Command-line argument guards passed');
      result := 0;
    end;

  end;

end.
