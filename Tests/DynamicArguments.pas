// Positive reflection guards bind omitted defaults and reordered keywords.
// Negative guards reject unknown, duplicate and missing required arguments;
// the legacy overload remains positional and existing null rules still apply.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  DynamicArgumentTarget = public class
  public
    [Used]
    method Pair(first, second: String): String;
    begin exit first + '/' + second; end;
    [Used]
    method Optional(first: String; second: String := 'DEFAULT'): String;
    begin exit first + '/' + second; end;
  end;
  DynamicArguments = public class(Test)
  public
    method DefaultsAndKeywords;
    begin
      var target := new DynamicArgumentTarget;
      Assert.AreEqual('A/DEFAULT', String(DynamicHelpers.Invoke(target, 'Optional', 2, [String('A')], [''])));
      Assert.AreEqual('A/B', String(DynamicHelpers.Invoke(target, 'Pair', 2, [String('B'), String('A')], ['second', 'first'])));
      Assert.AreEqual('A/B', String(DynamicHelpers.Invoke(target, 'Pair', 2, [String('A'), String('B')])));
    end;
    method InvalidBindingsRejected;
    begin
      Reject([String('A'), String('B')], ['first', 'unknown']);
      Reject([String('A'), String('B')], ['', 'first']);
      Reject([String('B')], ['second']);
    end;
  private
    method Reject(args: array of Object; names: array of String);
    begin
      var rejected := false;
      try DynamicHelpers.Invoke(new DynamicArgumentTarget, 'Pair', 2, args, names);
      except on DynamicInvokeException do rejected := true; end;
      Assert.IsTrue(rejected);
    end;
  end;
end.
