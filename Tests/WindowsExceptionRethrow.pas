namespace RemObjects.Elements.Island.Tests;

uses
  RemObjects.Elements.EUnit;

type
  WindowsExceptionRethrow = public class(Test)
  private
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

  public
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
