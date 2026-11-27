// Negative regression guards require exceptions to cross MethodInfo.Invoke
// without terminating or skipping handlers. Positive controls preserve integer,
// floating-point and spilled stack arguments across the same native call bridge.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  ReflectionProbeException = public class(Exception);
  [Used]
  ReflectionUnwind = public class(Test)
  private
    class method Invoke(name: String; target: Object; args: array of Object): Object;
    begin
      for each member in typeOf(ReflectionUnwind).Methods do
        if member.Name = name then exit member.Invoke(target, args);
      raise new Exception('Missing reflection method: ' + name);
    end;
  public
    [Used]
    class method Fail; begin raise new ReflectionProbeException('static'); end;
    [Used]
    method FailInstance(a,b,c,d,e,f,g,h,i: Int64);
    begin
      if a+b+c+d+e+f+g+h+i <> 45 then raise new Exception('Incorrect stack arguments');
      raise new ReflectionProbeException('instance');
    end;
    [Used]
    class method Weighted(a,b,c,d,e,f,g,h,i: Double): Double;
    begin exit a+2*b+3*c+4*d+5*e+6*f+7*g+8*h+9*i; end;
    [Used]
    class method SingleIdentity(value: Single): Single; begin exit value; end;
    method ExceptionsCrossReflection;
    begin
      var caught := 0;
      for n: Integer := 0 to 2 do begin
        try Invoke('Fail', nil, []);
        except on e: ReflectionProbeException do begin Assert.AreEqual('static', e.Message); inc(caught); end; end;
        try Invoke('FailInstance', self, [Int64(1),Int64(2),Int64(3),Int64(4),Int64(5),Int64(6),Int64(7),Int64(8),Int64(9)]);
        except on e: ReflectionProbeException do begin Assert.AreEqual('instance', e.Message); inc(caught); end; end;
      end;
      Assert.AreEqual(6, caught);
      Assert.AreEqual(285.0, Double(Invoke('Weighted', nil, [1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0])));
      Assert.AreEqual(Single(1.25), Single(Invoke('SingleIdentity', nil, [Single(1.25)])));
    end;
  end;
end.
