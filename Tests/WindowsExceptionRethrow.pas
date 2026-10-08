// Negative regression guards: catch-body raises must preserve the exception,
// runtime register state, and exactly-once cleanup while reaching the caller.
namespace RemObjects.Elements.Island.Tests;

uses
  RemObjects.Elements.EUnit;

type
  WindowsExceptionRethrow = public class(Test)
  private
    [DisableInlining]
    method BareRethrowFromHandler(aOriginal: Exception; var aFinallyCount: Integer);
    begin
      try
        raise aOriginal;
      except
        on E: Exception do begin
          try
            raise;
          finally
            inc(aFinallyCount);
          end;
        end;
      end;
    end;

    [DisableInlining]
    method NewExceptionFromHandler(var aFinallyCount: Integer);
    begin
      try
        raise new Exception('original');
      except
        on E: Exception do begin
          try
            raise new Exception('replacement');
          finally
            inc(aFinallyCount);
          end;
        end;
      end;
    end;

    [DisableInlining]
    method RethrowAcrossIntermediateFrame(aOriginal: Exception; var aFinallyCount: Integer);
    begin
      try
        try
          raise aOriginal;
        except
          on E: Exception do
            raise;
        end;
      finally
        inc(aFinallyCount);
      end;
    end;

    [DisableInlining]
    method ReplaceExceptionDuringCleanup(var aFinallyCount: Integer);
    begin
      try
        raise new Exception('original');
      finally
        inc(aFinallyCount);
        raise new Exception('cleanup replacement');
      end;
    end;

    [DisableInlining]
    method FloatingPointAcrossRethrow(aA, aB, aC, aD, aE, aF, aG, aH: Double): Double;
    begin
      var lFinallyCount := 0;
      try
        BareRethrowFromHandler(new Exception('registers'), var lFinallyCount);
      except
        on E: Exception do begin
          Assert.AreEqual('registers', E.Message);
          Assert.AreEqual(1, lFinallyCount);
        end;
      end;
      exit aA + aB * 2 + aC * 3 + aD * 4 + aE * 5 + aF * 6 + aG * 7 + aH * 8;
    end;

  public
    // Positive guard: floating-point parent locals survive a deferred raise.
    method FloatingPointLocalsSurviveRethrow;
    begin
      for i := 1 to 16 do
        Assert.AreEqual(Double(36 * i + 168), FloatingPointAcrossRethrow(i, i + 1, i + 2, i + 3, i + 4, i + 5, i + 6, i + 7));
    end;

    // Negative guard: unwinding an exception raised inside a finally must cross
    // the runtime's cleanup-call frame and deliver the replacement exactly once.
    method ExceptionFromCleanupReachesOuterHandler;
    begin
      var lCaught: Exception;
      var lFinallyCount := 0;
      try
        ReplaceExceptionDuringCleanup(var lFinallyCount);
      except
        on e: Exception do
          lCaught := e;
      end;
      Assert.IsTrue(assigned(lCaught));
      Assert.AreEqual('cleanup replacement', lCaught.Message);
      Assert.AreEqual(1, lFinallyCount);
    end;

    method BareRethrowReachesOuterHandler;
    begin
      var lOriginal := new Exception('original');
      var lCaught: Exception := nil;
      var lFinallyCount := 0;

      try
        BareRethrowFromHandler(lOriginal, var lFinallyCount);
      except
        on E: Exception do
          lCaught := E;
      end;

      Assert.IsTrue(lCaught = lOriginal, 'Bare raise must preserve the original exception object.');
      Assert.AreEqual(1, lFinallyCount, 'The catch-body finally must run exactly once.');
    end;

    method NewExceptionFromHandlerReachesOuterHandler;
    begin
      var lCaught: Exception := nil;
      var lFinallyCount := 0;

      try
        NewExceptionFromHandler(var lFinallyCount);
      except
        on E: Exception do
          lCaught := E;
      end;

      Assert.IsTrue(assigned(lCaught), 'The outer handler must receive the replacement exception.');
      Assert.AreEqual('replacement', lCaught.Message);
      Assert.AreEqual(1, lFinallyCount, 'The catch-body finally must run exactly once.');
    end;

    method IntermediateFrameRunsFullCleanupChain;
    begin
      var lOriginal := new Exception('original');
      var lCaught: Exception := nil;
      var lFinallyCount := 0;

      try
        RethrowAcrossIntermediateFrame(lOriginal, var lFinallyCount);
      except
        on E: Exception do
          lCaught := E;
      end;

      Assert.IsTrue(lCaught = lOriginal, 'The caller must receive the rethrown exception.');
      Assert.AreEqual(1, lFinallyCount, 'An intermediate frame must run its full cleanup chain exactly once.');
    end;
  end;

end.
