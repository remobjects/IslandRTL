namespace RemObjects.Elements.Island.Tests;

uses
  RemObjects.Elements.EUnit;

type
  ITransient = interface
    property Retryable: Boolean read;
  end;

  ExceptionFilterTests = public class(Test)
  private
    [DisableInlining]
    method RaiseWithNonMatchingWhereFilter;
    begin
      try
        raise new Exception('disk full');
      except
        on E: Exception where E.Message.Contains('network') do
          Assert.Fail('A non-matching where filter must not enter its handler.');
      end;
    end;

    [DisableInlining]
    method RaiseWithNonMatchingInterfaceType;
    begin
      try
        raise new Exception('plain');
      except
        on E: ITransient do
          Assert.Fail('An incompatible interface catch must not enter its handler.');
      end;
    end;

  public
    method NonMatchingWhereFilterReachesOuterHandler;
    begin
      var lCaught: Exception := nil;
      try
        RaiseWithNonMatchingWhereFilter;
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
        RaiseWithNonMatchingInterfaceType;
      except
        on E: Exception do
          lCaught := E;
      end;

      Assert.IsTrue(assigned(lCaught), 'The outer handler must receive the incompatible exception.');
      Assert.AreEqual('plain', lCaught.Message);
    end;
  end;

end.
