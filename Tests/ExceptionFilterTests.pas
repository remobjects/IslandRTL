// Positive guard: a rejected where filter must propagate to an outer handler instead of looping in the unwinder.
// Positive guard: an incompatible interface catch must propagate the original exception.
// Positive guard: propagation through an enclosing finally block must run that block exactly once.
namespace RemObjects.Elements.Island.Tests;

uses
  RemObjects.Elements.EUnit;

type
  ITransient = interface
    property Retryable: Boolean read;
  end;

  ExceptionFilterTests = public class(Test)
  private
    // Parameters keep these throwing helpers out of EUnit test discovery.
    [DisableInlining]
    method RaiseWithNonMatchingWhereFilter(aMessage: String);
    begin
      try
        raise new Exception(aMessage);
      except
        on E: Exception where E.Message.Contains('network') do
          Assert.Fail('A non-matching where filter must not enter its handler.');
      end;
    end;

    [DisableInlining]
    method RaiseWithNonMatchingInterfaceType(aMessage: String);
    begin
      try
        raise new Exception(aMessage);
      except
        on E: ITransient do
          Assert.Fail('An incompatible interface catch must not enter its handler.');
      end;
    end;

    [DisableInlining]
    method RaiseWithNonMatchingFilterAndFinally(var aFinallyCount: Integer);
    begin
      try
        try
          raise new Exception('disk full');
        except
          on E: Exception where E.Message.Contains('network') do
            Assert.Fail('A non-matching filter must not enter its handler.');
        end;
      finally
        inc(aFinallyCount);
      end;
    end;

  public
    method RejectedFilterRunsFinallyBeforeOuterHandler;
    begin
      var lFinallyCount := 0;
      var lCaught: Exception := nil;
      try
        RaiseWithNonMatchingFilterAndFinally(var lFinallyCount);
      except
        on E: Exception do lCaught := E;
      end;
      Assert.IsTrue(assigned(lCaught), 'The outer handler must receive the filtered exception.');
      Assert.AreEqual('disk full', lCaught.Message);
      Assert.AreEqual(1, lFinallyCount);
    end;

    method NonMatchingWhereFilterReachesOuterHandler;
    begin
      var lCaught: Exception := nil;
      try
        RaiseWithNonMatchingWhereFilter('disk full');
      except
        on E: Exception do
          lCaught := E;
      end;

      Assert.IsTrue(assigned(lCaught), 'The outer handler must receive the filtered exception.');
      Assert.AreEqual('disk full', lCaught.Message);
    end;

    method NonMatchingInterfaceTypeReachesOuterHandler;
    begin
      var lCaught: Exception := nil;
      try
        RaiseWithNonMatchingInterfaceType('plain');
      except
        on E: Exception do
          lCaught := E;
      end;

      Assert.IsTrue(assigned(lCaught), 'The outer handler must receive the incompatible exception.');
      Assert.AreEqual('plain', lCaught.Message);
    end;
  end;

end.
