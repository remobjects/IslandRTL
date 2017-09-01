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
  end;



end.