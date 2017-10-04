namespace Island.Tests.Shared;



uses
  RemObjects.Elements.EUnit;

type
  Math_Pow = public class(Test)

  public
    method calc;
    begin
      var s1, s2 : Double;
      var sValue:=1.0;
      s1 := Math.Pow(sValue,0.5);
      s2 := Math.Sqrt(sValue);
      Assert.AreEqual(s1, s2);

    end;

    method pow_int;
    begin
      var sValue := 2.0;
      var s1: double;
      s1 := Math.Pow(sValue, 5);
      Assert.AreEqual(s1, 32.0);
      s1 := Math.Pow(sValue, 8);
      Assert.AreEqual(s1, 256.0);
      s1 := Math.Pow(sValue, -5);
      Assert.AreEqual(s1, 1.0/32.0);
      s1 := Math.Pow(sValue, -8);
      Assert.AreEqual(s1, 1.0/256.0);
    end;

  end;

end.