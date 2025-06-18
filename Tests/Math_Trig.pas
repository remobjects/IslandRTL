namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  Math_Trig = public class(Test)
  public
    method Sin_Normal;
    begin
      var sin0 := Math.Sin(0.0);
      Assert.AreEqual(sin0, 0.0, String.Format('expected 0.0, got {0}', sin0));
      var sin30 := Math.Sin(Math.PI/6);
      Assert.AreEqual(sin30, 0.5, 1e-15, String.Format('expected 0.5, got {0}', sin30));
      var sin45 := Math.Sin(Math.PI/4);
      Assert.AreEqual(sin45, 0.7071067811865476, 1e-15, String.Format('expected 0.7071067811865476, got {0}', sin45));
      var sin90 := Math.Sin(Math.PI/2);
      Assert.AreEqual(sin90, 1.0, 1e-15, String.Format('expected 1.0, got {0}', sin90));
      var sin180 := Math.Sin(Math.PI);
      Assert.AreEqual(sin180, 0.0, 1e-15, String.Format('expected 0.0, got {0}', sin180));
      var sin270 := Math.Sin(3*Math.PI/2);
      Assert.AreEqual(sin270, -1.0, 1e-15, String.Format('expected -1.0, got {0}', sin270));
    end;

    method Sin_EdgeCases;
    begin
      var sinNaN := Math.Sin(Double.NaN);
      Assert.IsTrue(Double.IsNaN(sinNaN), String.Format('expected NaN, got {0}', sinNaN));
      var sinPosInf := Math.Sin(Double.PositiveInfinity);
      Assert.IsTrue((sinPosInf = Double.NaN) or (sinPosInf = 0.0), String.Format('expected NaN or 0.0, got {0}', sinPosInf));
      var sinNegInf := Math.Sin(Double.NegativeInfinity);
      Assert.IsTrue((sinNegInf = Double.NaN) or (sinNegInf = 0.0), String.Format('expected NaN or 0.0, got {0}', sinNegInf));
    end;

    method Cos_Normal;
    begin
      var cos0 := Math.Cos(0.0);
      Assert.AreEqual(cos0, 1.0, String.Format('expected 1.0, got {0}', cos0));
      var cos30 := Math.Cos(Math.PI/6);
      Assert.AreEqual(cos30, 0.8660254037844386, 1e-15, String.Format('expected 0.8660254037844386, got {0}', cos30));
      var cos45 := Math.Cos(Math.PI/4);
      Assert.AreEqual(cos45, 0.7071067811865476, 1e-15, String.Format('expected 0.7071067811865476, got {0}', cos45));
      var cos90 := Math.Cos(Math.PI/2);
      Assert.AreEqual(cos90, 0.0, 1e-15, String.Format('expected 0.0, got {0}', cos90));
      var cos180 := Math.Cos(Math.PI);
      Assert.AreEqual(cos180, -1.0, 1e-15, String.Format('expected -1.0, got {0}', cos180));
      var cos270 := Math.Cos(3*Math.PI/2);
      Assert.AreEqual(cos270, 0.0, 1e-15, String.Format('expected 0.0, got {0}', cos270));
    end;

    method Cos_EdgeCases;
    begin
      var cosNaN := Math.Cos(Double.NaN);
      Assert.IsTrue(Double.IsNaN(cosNaN), String.Format('expected NaN, got {0}', cosNaN));
      var cosPosInf := Math.Cos(Double.PositiveInfinity);
      Assert.IsTrue((cosPosInf = Double.NaN) or (cosPosInf = 0.0), String.Format('expected NaN or 0.0, got {0}', cosPosInf));
      var cosNegInf := Math.Cos(Double.NegativeInfinity);
      Assert.IsTrue((cosNegInf = Double.NaN) or (cosNegInf = 0.0), String.Format('expected NaN or 0.0, got {0}', cosNegInf));
    end;

    method Tan_Normal;
    begin
      var tan0 := Math.Tan(0.0);
      Assert.AreEqual(tan0, 0.0, String.Format('expected 0.0, got {0}', tan0));
      var tan30 := Math.Tan(Math.PI/6);
      Assert.AreEqual(tan30, 0.5773502691896257, 1e-15, String.Format('expected 0.5773502691896257, got {0}', tan30));
      var tan45 := Math.Tan(Math.PI/4);
      Assert.AreEqual(tan45, 1.0, 1e-15, String.Format('expected 1.0, got {0}', tan45));
      var tan180 := Math.Tan(Math.PI);
      Assert.AreEqual(tan180, 0.0, 1e-15, String.Format('expected 0.0, got {0}', tan180));
      var tan90 := Math.Tan(Math.PI/2);
      Assert.IsTrue(Math.Abs(tan90) > 1e10, String.Format('expected large value, got {0}', tan90));
    end;

    method Tan_EdgeCases;
    begin
      var tanNaN := Math.Tan(Double.NaN);
      Assert.IsTrue(Double.IsNaN(tanNaN), String.Format('expected NaN, got {0}', tanNaN));
      var tanPosInf := Math.Tan(Double.PositiveInfinity);
      Assert.IsTrue((tanPosInf = Double.NaN) or (tanPosInf = 0.0), String.Format('expected NaN or 0.0, got {0}', tanPosInf));
      var tanNegInf := Math.Tan(Double.NegativeInfinity);
      Assert.IsTrue((tanNegInf = Double.NaN) or (tanNegInf = 0.0), String.Format('expected NaN or 0.0, got {0}', tanNegInf));
    end;
  end;

end.
