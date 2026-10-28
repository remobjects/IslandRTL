// Positive null-reference binding and negative null-to-value-type dynamic-call guards.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  DynamicNullTarget = public class
  public
    [Used]
    method AcceptObject(aValue: Object): String;
    begin
      exit if aValue = nil then 'nil' else 'object';
    end;

    [Used]
    method AcceptInteger(aValue: Integer): Integer;
    begin
      exit aValue;
    end;
  end;

  DynamicNullArguments = public class(Test)
  public
    method ReferenceArgument;
    begin
      Assert.AreEqual('nil', String(DynamicHelpers.Invoke(new DynamicNullTarget, 'AcceptObject', 0, [nil])));
    end;

    method ValueArgumentRejected;
    begin
      var lRejected := false;
      try
        DynamicHelpers.Invoke(new DynamicNullTarget, 'AcceptInteger', 0, [nil]);
      except
        on e: DynamicInvokeException do lRejected := true;
      end;
      Assert.IsTrue(lRejected);
    end;
  end;

end.
