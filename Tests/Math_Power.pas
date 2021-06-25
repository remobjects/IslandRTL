namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  Math_Power = public class(Test)
  public

    method calc;
    begin
      var s1,s2: Double;
      var sValue:=10.0;
      s1 :=sValue*sValue;
      s2 := Math.Pow(sValue,2);
      Assert.AreEqual(s1, s2);
      s1 := 1/(sValue*sValue);
      s2 := Math.Pow(sValue,-2);
      Assert.AreEqual(s1, s2);
      s1 := 1;
      s2 := Math.Pow(sValue,0);
      Assert.AreEqual(s1, s2);
    end;

  end;

end.