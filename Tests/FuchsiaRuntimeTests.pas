namespace FuchsiaRuntimeTests;

type
  Program = class
  private
    class var fChecks: Integer;
    class method Check(aValue: Boolean; aMessage: String);
    begin
      if not aValue then raise new Exception('FAIL: '+aMessage);
      inc(fChecks);
      writeLn('PASS: '+aMessage);
    end;

    class method TestReflection;
    begin
      var lAdd := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'Add');
      var lValue := lAdd.Invoke(nil, [Int32(12), Int32(30)]);
      Check(Int32(lValue) = 42, 'reflection integer invocation');
      var lScale := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'Scale');
      Check(Double(lScale.Invoke(nil, [Double(2.5), Double(4.0)])) = 10.0, 'reflection floating-point invocation');
      var lSingle := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'ScaleSingle');
      Check(Single(lSingle.Invoke(nil, [Single(2.5), Single(4.0)])) = 10.0, 'reflection single invocation');
      var lSum := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'Sum');
      Check(Int64(lSum.Invoke(nil, [Int64(1), Int64(2), Int64(3), Int64(4), Int64(5), Int64(6), Int64(7), Int64(8), Int64(9), Int64(10)])) = 55, 'reflection stack arguments');
      var lSumFloat := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'SumFloat');
      Check(Double(lSumFloat.Invoke(nil, [Double(1), Double(2), Double(3), Double(4), Double(5), Double(6), Double(7), Double(8)])) = 36, 'reflection eight floating registers');
      var lIncrement := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'Increment');
      var lArgs: array of Object := [Int32(41)];
      lIncrement.Invoke(nil, lArgs);
      Check(Int32(lArgs[0]) = 42, 'reflection var argument');
      var lOutput := typeOf(Program).Methods.First(aMethod -> aMethod.Name = 'Output');
      lArgs := [nil];
      lOutput.Invoke(nil, lArgs);
      Check(Int32(lArgs[0]) = 42, 'reflection out argument');
    end;

    class method TestRTL2;
    begin
      Check(RemObjects.Elements.RTL.Locale.Invariant.NumberFormat.DecimalSeparator = '.', 'RTL2 invariant number format');
      Check(length(RemObjects.Elements.RTL.DateTime.UtcNow.ToString) > 0, 'RTL2 date formatting');
      Check(length(RemObjects.Elements.RTL.Guid.NewGuid.ToString) = 36, 'RTL2 UUID generation');
      {$IF FUCHSIA}
      Check(RemObjects.Elements.RTL.TimeZone.Local.Identifier = 'UTC', 'RTL2 libc local timezone');
      {$ENDIF}
      var lCaught := false;
      try
        raise new Exception('native exception probe');
      except
        on e: RemObjects.Elements.RTL.RTLException do raise new Exception('Incorrect RTLException match');
        on e: Exception do lCaught := true;
      end;
      Check(lCaught, 'native exception passes RTL2 exception catch safely');
      using lDone := new EventWaitHandle(false, false) do begin
        var lTimer := new RemObjects.Elements.RTL.Timer(RemObjects.Elements.RTL.Units.Milliseconds(25), false, aTimer -> lDone.Set);
        lTimer.Start;
        Check(lDone.Wait(3000), 'RTL2 timer callback');
        lTimer.Stop;
      end;
    end;

    class method TestLocale;
    begin
      Check(Locale.Invariant <> nil, 'invariant locale');
      Check(Locale.Current <> nil, 'current locale');
      {$IF FUCHSIA}
      Check(new Locale('C.UTF-8').Identifier = 'C.UTF-8', 'named locale preserves codeset');
      {$ENDIF}
      Check(Locale.Invariant.NumberFormat <> nil, 'number format');
      Check(Locale.Invariant.DateTimeFormat <> nil, 'date format');
      Check('AbC'.ToLower(true) = 'abc', 'invariant lowercase');
      Check('AbC'.ToUpper(false) = 'ABC', 'current uppercase');
      Check(length(DateTime.Now.ToString) > 0, 'date formatting');
    end;

    class method TestRandom;
    begin
      var lBytes := new Byte[66];
      Random.CryptoSafeRandom(lBytes, 1, 64);
      Check((lBytes[0] = 0) and (lBytes[65] = 0), 'random honors slice');
      var lDifferent := false;
      for i := 2 to 64 do lDifferent := lDifferent or (lBytes[i] <> lBytes[1]);
      Check(lDifferent, 'random fills buffer');
      Random.CryptoSafeRandom(lBytes, 66, 0);
      try
        Random.CryptoSafeRandom(lBytes, 0, -1);
        Check(false, 'negative random length');
      except
        on e: ArgumentOutOfRangeException do Check(true, 'negative random length rejected');
      end;
    end;

    class method TestThreadName;
    begin
      {$IF FUCHSIA}
      using lRelease := new EventWaitHandle(false, false) do
      using lDone := new EventWaitHandle(false, false) do begin
        var lThread := new Thread(-> begin
          lRelease.Wait;
          lDone.Set;
        end);
        lThread.Start;
        try
          lThread.Name := 'runtime-probe';
          Check(lThread.Name = 'runtime-probe', 'thread name round-trip');
        finally
          lRelease.Set;
          lDone.Wait;
        end;
      end;
      {$ENDIF}
    end;

    class method TestTimers;
    begin
      using lDone := new EventWaitHandle(false, false) do
      using lTimer := new Timer(25, false) do begin
        var lCount := 0;
        lTimer.Elapsed := aData -> begin
          inc(lCount);
          lDone.Set;
        end;
        lTimer.Enabled := true;
        Check(lDone.Wait(3000), 'one-shot timer fires');
        Thread.Sleep(75);
        lTimer.Stop;
        Check(lCount = 1, 'one-shot does not repeat');
        lTimer.Start;
        Thread.Sleep(75);
        lTimer.Stop;
        Check(lCount = 2, 'timer restarts');
      end;
      using lDone := new EventWaitHandle(false, false) do
      using lTimer := new Timer(20, true) do begin
        var lCount := 0;
        lTimer.Elapsed := aData -> begin
          inc(lCount);
          if lCount = 3 then begin
            lTimer.Stop;
            lDone.Set;
          end;
        end;
        lTimer.Start;
        Check(lDone.Wait(3000), 'repeating timer stops in callback');
        Thread.Sleep(75);
        Check(lCount = 3, 'no callbacks after stop');
      end;
      using lTimer := new Timer(200, true) do begin
        var lFired := false;
        lTimer.Elapsed := aData -> begin lFired := true; end;
        lTimer.Start;
        lTimer.Enabled := false;
        Thread.Sleep(250);
        Check(not lFired, 'cancel pending timer');
      end;
    end;

    class method TestFiles(aPath: String);
    begin
      using lFile := new FileStream(aPath, FileMode.Create, FileAccess.ReadWrite) do begin
        var lBytes: array of Byte := [1, 2, 3, 4];
        Check(lFile.Write(lBytes) = 4, 'file write');
        Check(lFile.Seek(1, SeekOrigin.Begin) = 1, 'file absolute seek');
        var lRead := new Byte[2];
        Check((lFile.Read(lRead) = 2) and (lRead[0] = 2) and (lRead[1] = 3), 'file read after seek');
        lFile.SetLength(2);
        Check(lFile.Seek(0, SeekOrigin.End) = 2, 'file truncate');
        lFile.SetLength(8);
        Check(lFile.Seek(0, SeekOrigin.End) = 8, 'file extend');
      end;
      using lFile := new FileStream(aPath, FileMode.Open, FileAccess.Read) do
        Check(lFile.Seek(0, SeekOrigin.End) = 8, 'read-only open preserves file');
      var lRejected := false;
      try
        using lFile := new FileStream(aPath, FileMode.CreateNew, FileAccess.Write) do begin end;
      except
        on e: Exception do lRejected := true;
      end;
      Check(lRejected, 'exclusive create rejects existing file');
    end;
  public
    class method Add(aFirst, aSecond: Int32): Int32;
    begin exit aFirst + aSecond; end;
    class method Scale(aValue, aFactor: Double): Double;
    begin exit aValue * aFactor; end;
    class method ScaleSingle(aValue, aFactor: Single): Single;
    begin exit aValue * aFactor; end;
    class method Sum(a, b, c, d, e, f, g, h, i, j: Int64): Int64;
    begin exit a+b+c+d+e+f+g+h+i+j; end;
    class method SumFloat(a, b, c, d, e, f, g, h: Double): Double;
    begin exit a+b+c+d+e+f+g+h; end;
    class method Increment(var aValue: Int32);
    begin inc(aValue); end;
    class method Output(out aValue: Int32);
    begin aValue := 42; end;
    class method Main(aArgs: array of String): Integer;
    begin
      try
        TestLocale;
        TestRTL2;
        TestRandom;
        TestReflection;
        TestTimers;
        TestThreadName;
        TestFiles(if length(aArgs) > 0 then aArgs[0] else '/data/runtime-test.bin');
        writeLn('PASS: runtime checks '+fChecks.ToString);
        exit 0;
      except
        on e: Exception do begin writeLn('FAILED: '+e.Message); exit 1; end;
      end;
    end;
  end;
end.
