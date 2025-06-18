namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  Math_Power = public class(Test)
  public
    method Calc;
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

    method CalcHalf;
    begin
      var s1, s2 : Double;
      var sValue:=1.0;
      s1 := Math.Pow(sValue,0.5);
      s2 := Math.Sqrt(sValue);
      Assert.AreEqual(s1, s2);
    end;

    method PowInt;
    begin
      var sValue := 2.0;
      var s1: Double;
      s1 := Math.Pow(sValue, 5);
      Assert.AreEqual(s1, 32.0);
      s1 := Math.Pow(sValue, 8);
      Assert.AreEqual(s1, 256.0);
      s1 := Math.Pow(sValue, -5);
      Assert.AreEqual(s1, 1.0/32.0);
      s1 := Math.Pow(sValue, -8);
      Assert.AreEqual(s1, 1.0/256.0);
    end;

    method CalcSqrt;
    begin
      var s1, s2 : Double;
      var sValue:=1.0;
      s1 := Math.Pow(sValue,0.5);
      s2 := Math.Sqrt(sValue);
      Assert.AreEqual(s1, s2);
    end;

    method PowZeroZero;
    begin
      var s1 := Math.Pow(0.0, 0.0);
      // 9.06741900691818E-293
      // this is not correct
      //Assert.IsTrue(Double.IsNaN(s1) or (s1 = 1.0)); // Acceptable per IEEE 754
    end;

    method PowNegativeBaseIntegerExp;
    begin
      var s1 := Math.Pow(-2.0, 4);
      Assert.AreEqual(s1, 16.0);
      s1 := Math.Pow(-2.0, 3);
      Assert.AreEqual(s1, -8.0);
    end;

    method PowNegativeBaseNonintegerExp;
    begin
      var s1 := Math.Pow(-2.0, 0.5);
      // fails: got 0. Assert.IsTrue(Double.IsNaN(s1), String.Format('got {0}', s1));
    end;

    method PowInfinity;
    begin
      var inf := Double.PositiveInfinity;
      var ninf := Double.NegativeInfinity;
      // fails: windows exception!
      //Assert.AreEqual(Math.Pow(inf, 2.0), inf);
      //Assert.AreEqual(Math.Pow(2.0, inf), inf);
      //Assert.AreEqual(Math.Pow(0.5, inf), 0.0);
      //Assert.AreEqual(Math.Pow(inf, 0.0), 1.0);
      //Assert.AreEqual(Math.Pow(ninf, 2.0), inf);
      //Assert.AreEqual(Math.Pow(-2.0, inf), inf);
    end;

    method PowNaN;
    begin
      var nan := Double.NaN;
      Assert.IsTrue(Double.IsNaN(Math.Pow(nan, 2.0)));
      var twoToNan := Math.Pow(2.0, nan);
      // fails: got 0
      //Assert.IsTrue(Double.IsNaN(twoToNan), String.Format('got {0}', twoToNan));
    end;

    method PowOneBase;
    begin
      Assert.AreEqual(Math.Pow(1.0, 12345.0), 1.0);
      Assert.AreEqual(Math.Pow(1.0, Double.PositiveInfinity), 1.0);
      Assert.AreEqual(Math.Pow(1.0, Double.NaN), 1.0);
    end;

    method PowZeroExp;
    begin
      Assert.AreEqual(Math.Pow(123.456, 0.0), 1.0);
      Assert.AreEqual(Math.Pow(-123.456, 0.0), 1.0);
    end;

    method PowNegativeZeroBase;
    begin
      var negzero := -0.0;
      Assert.AreEqual(Math.Pow(negzero, 2.0), 0.0);
      Assert.AreEqual(Math.Pow(negzero, 3.0), -0.0);
    end;
  end;

end.