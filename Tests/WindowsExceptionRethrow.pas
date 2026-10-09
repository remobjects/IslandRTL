// Elements: portable catch/rethrow and cleanup guards, run on Windows and POSIX.
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

    // Elements: after a cleanup handles an inner exception, its pending outer
    // handler still needs its own metadata for a deferred rethrow or replacement.
    [DisableInlining]
    method RaiseFromHandlerAfterLocalCleanup(aOriginal, aInner, aReplacement: Exception; var aInnerCaught, aHandlerCaught: Exception; var aCleanupCount: Integer);
    begin
      try
        try
          raise aOriginal;
        finally
          inc(aCleanupCount);
          try
            raise aInner;
          except
            on e: Exception do
              aInnerCaught := e;
          end;
          inc(aCleanupCount);
        end;
      except
        on e: Exception do begin
          aHandlerCaught := e;
          if aReplacement = nil then
            raise
          else
            raise aReplacement;
        end;
      end;
    end;

    // Elements: multiple exits from a catch must select distinct continuation
    // states, and every exit must run its enclosing cleanup exactly once.
    [DisableInlining]
    method CatchControlFlow(aReturnEarly: Boolean; var aCleanups: Integer): Integer;
    begin
      var lTotal := 0;
      for i := 0 to 3 do begin
        try
          raise new Exception('control flow');
        except
          on e: Exception do begin
            try
              if i = 0 then
                continue;
              if aReturnEarly then
                exit 17;
              if i = 2 then
                break;
              inc(lTotal, 100);
            finally
              inc(aCleanups);
              inc(lTotal);
            end;
          end;
        end;
      end;
      exit lTotal;
    end;

  public
    // Elements: a replacement from a handler must reach an enclosing handler
    // in this same method, rather than skip the entire frame.
    method ReplacementReachesSameMethodHandler;
    begin
      var lReplacement := new Exception('replacement');
      var lCaught: Exception := nil;
      var lCleanups := 0;
      try
        try
          raise new Exception('original');
        except
          on e: Exception do begin
            try
              raise lReplacement;
            finally
              inc(lCleanups);
            end;
          end;
        end;
      except
        on e: Exception do
          lCaught := e;
      end;
      Assert.IsTrue(lCaught = lReplacement);
      Assert.AreEqual(1, lCleanups);
    end;

    // Elements: calls made by a handler use its lexical enclosing handler too.
    method HelperThrowReachesSameMethodHandler;
    begin
      var lOriginal := new Exception('helper rethrow');
      var lCaught: Exception := nil;
      var lCleanups := 0;
      try
        try
          raise new Exception('enter catch');
        except
          on e: Exception do
            BareRethrowFromHandler(lOriginal, var lCleanups);
        end;
      except
        on e: Exception do
          lCaught := e;
      end;
      Assert.IsTrue(lCaught = lOriginal);
      Assert.AreEqual(1, lCleanups);
    end;

    // Elements: break, continue and return must survive the catchret boundary.
    method HandlerControlFlowRunsCleanupOnce;
    begin
      var lCleanups := 0;
      Assert.AreEqual(103, CatchControlFlow(false, var lCleanups));
      Assert.AreEqual(3, lCleanups);
      lCleanups := 0;
      Assert.AreEqual(17, CatchControlFlow(true, var lCleanups));
      Assert.AreEqual(2, lCleanups);
    end;

    // Elements: an unnamed Win32 handler still needs the original catch object.
    method UnnamedHandlerPreservesRethrow;
    begin
      var lOriginal := new Exception('unnamed rethrow');
      var lCaught: Exception := nil;
      try
        try
          raise lOriginal;
        except
          raise;
        end;
      except
        on e: Exception do
          lCaught := e;
      end;
      Assert.IsTrue(lCaught = lOriginal);
    end;

    // Elements: a catch inside an outlined finally must not replace the outer
    // catch object used by a bare raise after the cleanup returns.
    method FinallyPreservesEnclosingRethrow;
    begin
      var lOriginal := new Exception('outer catch');
      var lCaught: Exception := nil;
      var lCount := 0;
      try
        try
          raise lOriginal;
        except
          on e: Exception do begin
            try
              inc(lCount);
            finally
              try
                raise new Exception('inner catch');
              except
                on inner: Exception do
                  inc(lCount);
              end;
            end;
            raise;
          end;
        end;
      except
        on e: Exception do
          lCaught := e;
      end;
      Assert.IsTrue(lCaught = lOriginal);
      Assert.AreEqual(2, lCount);
    end;

    // Elements: a nested cleanup catch must preserve the outer handler's
    // original exception and metadata for a subsequent bare rethrow.
    method RethrowAfterLocallyHandledCleanup;
    begin
      var lOriginal := new Exception('original before locally handled cleanup');
      var lInner := new Exception('inner cleanup exception');
      var lInnerCaught: Exception := nil;
      var lHandlerCaught: Exception := nil;
      var lOuterCaught: Exception := nil;
      var lCleanupCount := 0;
      try
        RaiseFromHandlerAfterLocalCleanup(lOriginal, lInner, nil, var lInnerCaught, var lHandlerCaught, var lCleanupCount);
      except
        on e: Exception do
          lOuterCaught := e;
      end;
      Assert.IsTrue(lInnerCaught = lInner);
      Assert.IsTrue(lHandlerCaught = lOriginal);
      Assert.IsTrue(lOuterCaught = lOriginal);
      Assert.AreEqual(2, lCleanupCount);
    end;

    // Elements: restored outer-handler state must still permit a replacement
    // exception after the cleanup has handled its own nested exception.
    method ReplacementAfterLocallyHandledCleanup;
    begin
      var lOriginal := new Exception('original before locally handled cleanup');
      var lInner := new Exception('inner cleanup exception');
      var lReplacement := new Exception('replacement from outer handler');
      var lInnerCaught: Exception := nil;
      var lHandlerCaught: Exception := nil;
      var lOuterCaught: Exception := nil;
      var lCleanupCount := 0;
      try
        RaiseFromHandlerAfterLocalCleanup(lOriginal, lInner, lReplacement, var lInnerCaught, var lHandlerCaught, var lCleanupCount);
      except
        on e: Exception do
          lOuterCaught := e;
      end;
      Assert.IsTrue(lInnerCaught = lInner);
      Assert.IsTrue(lHandlerCaught = lOriginal);
      Assert.IsTrue(lOuterCaught = lReplacement);
      Assert.AreEqual(2, lCleanupCount);
    end;

    // Elements: a local handler in a normally entered finally must catch its
    // own exception without escaping or skipping the rest of the cleanup.
    method LocalHandlerInsideNormalCleanup;
    begin
      var lInner := new Exception('local normal cleanup');
      var lCaught: Exception := nil;
      var lCleanupCount := 0;
      try
        inc(lCleanupCount);
      finally
        try
          raise lInner;
        except
          on e: Exception do
            lCaught := e;
        end;
        inc(lCleanupCount);
      end;
      Assert.IsTrue(lCaught = lInner);
      Assert.AreEqual(2, lCleanupCount);
    end;

    // Elements: catching a nested exception in an unwinding finally must
    // preserve the original exception and resume its propagation exactly once.
    method LocalHandlerInsideUnwindingCleanup;
    begin
      var lOriginal := new Exception('original local cleanup');
      var lInner := new Exception('caught inside cleanup');
      var lInnerCaught: Exception := nil;
      var lOuterCaught: Exception := nil;
      var lCleanupCount := 0;
      try
        try
          raise lOriginal;
        finally
          inc(lCleanupCount);
          try
            raise lInner;
          except
            on e: Exception do
              lInnerCaught := e;
          end;
          inc(lCleanupCount);
        end;
      except
        on e: Exception do
          lOuterCaught := e;
      end;
      Assert.IsTrue(lInnerCaught = lInner);
      Assert.IsTrue(lOuterCaught = lOriginal);
      Assert.AreEqual(2, lCleanupCount);
    end;

    // Elements: cleanup must preserve the outer type selector as well as its
    // exception pointer when a different exception type is handled locally.
    method LocalCleanupPreservesTypedHandler;
    begin
      var lOriginal := new NotSupportedException('outer typed cleanup');
      var lInner := new NotImplementedException('inner typed cleanup');
      var lInnerCaught: Exception := nil;
      var lOuterCaught: Exception := nil;
      var lCleanupCount := 0;
      try
        try
          raise lOriginal;
        finally
          inc(lCleanupCount);
          try
            raise lInner;
          except
            on e: NotImplementedException do
              lInnerCaught := e;
          end;
          inc(lCleanupCount);
        end;
      except
        on e: NotImplementedException do
          Assert.Fail('Cleanup must not replace the pending exception or its type selector.');
        on e: NotSupportedException do
          lOuterCaught := e;
      end;
      Assert.IsTrue(lInnerCaught = lInner);
      Assert.IsTrue(lOuterCaught = lOriginal);
      Assert.AreEqual(2, lCleanupCount);
    end;

    // Elements: nested cleanup and a local handler must run before a finally
    // raises a replacement that reaches the caller's handler.
    method NestedCleanupHandlerThenReplacement;
    begin
      var lOriginal := new Exception('original nested cleanup');
      var lInner := new Exception('local nested cleanup');
      var lReplacement := new Exception('replacement after local handler');
      var lInnerCaught: Exception := nil;
      var lOuterCaught: Exception := nil;
      var lCleanupCount := 0;
      try
        try
          raise lOriginal;
        finally
          try
            try
              raise lInner;
            finally
              inc(lCleanupCount);
            end;
          except
            on e: Exception do
              lInnerCaught := e;
          end;
          inc(lCleanupCount);
          raise lReplacement;
        end;
      except
        on e: Exception do
          lOuterCaught := e;
      end;
      Assert.IsTrue(lInnerCaught = lInner);
      Assert.IsTrue(lOuterCaught = lReplacement);
      Assert.AreEqual(2, lCleanupCount);
    end;

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
