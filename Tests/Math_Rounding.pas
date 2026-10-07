// Negative regression guards for both native and PUREPASCAL math: Floor must
// preserve negative integers, large values and signed zero in both precisions.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  Math_Rounding = public class(Test)
  public

    // Negative guard: the Double fallback used to subtract one even when a
    // negative value was already integral; Single must not inherit that defect.
    method FloorValues;
    begin
      for each lValue in [-2147483648.0, -16777216.0, -2.0, -1.0, 0.0, 1.0, 2.0, 16777216.0, 2147483648.0] do begin
        Assert.AreEqual(Math.Floor(lValue), lValue);
        Assert.AreEqual(Math.Floor(Single(lValue)), Single(lValue));
      end;
      Assert.AreEqual(Math.Floor(-2.5), -3.0);
      Assert.AreEqual(Math.Floor(Single(-2.5)), Single(-3));
      Assert.AreEqual(Math.Floor(-0.25), -1.0);
      Assert.AreEqual(Math.Floor(Single(-0.25)), Single(-1));
      Assert.AreEqual(Math.Floor(2.5), 2.0);
      Assert.AreEqual(Math.Floor(Single(2.5)), Single(2));
      var lLarge: Double := 1.0e30;
      Assert.AreEqual(Math.Floor(lLarge), lLarge);
      Assert.AreEqual(Math.Floor(-lLarge), -lLarge);
      Assert.AreEqual(Math.Floor(Single(lLarge)), Single(lLarge));
      Assert.AreEqual(Math.Floor(Single(-lLarge)), Single(-lLarge));
    end;

    // Negative guard: returning a literal zero loses the sign of Floor(-0).
    // Infinite and NaN inputs must also avoid conversion through Integer.
    method FloorSpecialValues;
    begin
      var lDoubleBits: UInt64 := $8000000000000000;
      var lSingleBits: UInt32 := $80000000;
      var lDouble := Math.Floor(^Double(@lDoubleBits)^);
      var lSingle := Math.Floor(^Single(@lSingleBits)^);
      Assert.AreEqual(^UInt64(@lDouble)^, lDoubleBits);
      Assert.AreEqual(^UInt32(@lSingle)^, lSingleBits);
      Assert.AreEqual(Math.Floor(Double.PositiveInfinity), Double.PositiveInfinity);
      Assert.AreEqual(Math.Floor(Double.NegativeInfinity), Double.NegativeInfinity);
      Assert.AreEqual(Math.Floor(Single.PositiveInfinity), Single.PositiveInfinity);
      Assert.AreEqual(Math.Floor(Single.NegativeInfinity), Single.NegativeInfinity);
      lDouble := Math.Floor(Double.NaN);
      lSingle := Math.Floor(Single.NaN);
      Assert.IsTrue(lDouble <> lDouble);
      Assert.IsTrue(lSingle <> lSingle);
    end;

    // Positive guards for the Single overloads that reuse Double fallbacks.
    method SingleRounding;
    begin
      Assert.AreEqual(Math.Ceiling(Single(-2.5)), Single(-2));
      Assert.AreEqual(Math.Ceiling(Single(2.5)), Single(3));
      Assert.AreEqual(Math.Truncate(Single(-2.5)), Single(-2));
      Assert.AreEqual(Math.Truncate(Single(2.5)), Single(2));
      Assert.AreEqual(Math.fmodf(Single(-5.5), Single(2)), Single(-1.5));
      Assert.AreEqual(Math.fmodf(Single(5.5), Single(2)), Single(1.5));
    end;

  end;
end.
