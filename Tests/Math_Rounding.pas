// Contract guards for native and PUREPASCAL math: Round uses nearest ties-even;
// Floor preserves negative integers, large values and signed zero. Both Single
// and Double cover exact ties, neighboring floats, special values and loop tails.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  Math_Rounding = public class(Test)
  private

    // Prevent constant folding from hiding a wrong runtime implementation.
    [DisableInlining, DisableOptimizations]
    class method RoundDouble(aValue: Double): Double;
    begin
      exit Math.Round(aValue);
    end;

    [DisableInlining, DisableOptimizations]
    class method RoundSingle(aValue: Single): Single;
    begin
      exit Math.Round(aValue);
    end;

  public

    // Positive contract guard: even and odd midpoints on both sides of zero.
    // This catches Linux selecting a different policy when enabling SLEEF.
    method RoundMidpoints;
    begin
      for i := -32 to 32 do begin
        var lValue := Double(i) + 0.5;
        var lExpected := Double(if (i and 1) = 0 then i else i + 1);
        Assert.AreEqual(lExpected, RoundDouble(lValue));
        Assert.AreEqual(Single(lExpected), RoundSingle(Single(lValue)));
      end;
    end;

    // Negative guard: adding 0.5 before rounding misclassifies adjacent floats.
    // Test both neighbors of every exactly represented small midpoint.
    method RoundMidpointNeighbors;
    begin
      for i := 0 to 31 do begin
        var lHalf := Double(i) + 0.5;
        var lBits := ^UInt64(@lHalf)^;
        var lBelowBits := lBits - 1;
        var lAboveBits := lBits + 1;
        Assert.AreEqual(Double(i), RoundDouble(^Double(@lBelowBits)^));
        Assert.AreEqual(Double(i + 1), RoundDouble(^Double(@lAboveBits)^));
        Assert.AreEqual(Double(-i), RoundDouble(-^Double(@lBelowBits)^));
        Assert.AreEqual(Double(-i - 1), RoundDouble(-^Double(@lAboveBits)^));
        var lSingleHalf := Single(lHalf);
        var lSingleBits := ^UInt32(@lSingleHalf)^;
        var lSingleBelow := lSingleBits - 1;
        var lSingleAbove := lSingleBits + 1;
        Assert.AreEqual(Single(i), RoundSingle(^Single(@lSingleBelow)^));
        Assert.AreEqual(Single(i + 1), RoundSingle(^Single(@lSingleAbove)^));
        Assert.AreEqual(Single(-i), RoundSingle(-^Single(@lSingleBelow)^));
        Assert.AreEqual(Single(-i - 1), RoundSingle(-^Single(@lSingleAbove)^));
      end;
    end;

    // Positive floating-result contract: preserve signed zero and nonfinite
    // values; already integral values near precision limits must not change.
    method RoundSpecialValues;
    begin
      for each lBits in [UInt64($8000000000000000), UInt64($8000000000000001),
        UInt64($bfe0000000000000)] do begin
        var lRounded := RoundDouble(^Double(@lBits)^);
        Assert.AreEqual(UInt64($8000000000000000), ^UInt64(@lRounded)^);
      end;
      for each lBits in [UInt32($80000000), UInt32($80000001), UInt32($bf000000)] do begin
        var lRounded := RoundSingle(^Single(@lBits)^);
        Assert.AreEqual(UInt32($80000000), ^UInt32(@lRounded)^);
      end;
      for each lValue in [Double.PositiveInfinity, Double.NegativeInfinity,
        4503599627370495.0, 4503599627370496.0, 4503599627370497.0,
        -4503599627370497.0, Double.MaxValue, -Double.MaxValue] do
        Assert.AreEqual(lValue, RoundDouble(lValue));
      for each lValue in [Single.PositiveInfinity, Single.NegativeInfinity,
        Single(8388607), Single(8388608), Single(8388609), Single(-8388609),
        Single.MaxValue, -Single.MaxValue] do
        Assert.AreEqual(lValue, RoundSingle(lValue));
      Assert.AreEqual(4503599627370496.0, RoundDouble(4503599627370495.5));
      Assert.AreEqual(-4503599627370496.0, RoundDouble(-4503599627370495.5));
      Assert.AreEqual(Single(8388608), RoundSingle(Single(8388607.5)));
      Assert.AreEqual(Single(-8388608), RoundSingle(Single(-8388607.5)));
      var lNaN := RoundDouble(Double.NaN);
      var lSingleNaN := RoundSingle(Single.NaN);
      Assert.IsTrue(lNaN <> lNaN);
      Assert.IsTrue(lSingleNaN <> lSingleNaN);
    end;

    // Positive optimizer guard: the same contract holds in a vectorizable loop,
    // including a scalar tail. Saved IR is checked for roundeven vector forms.
    method RoundArrays;
    begin
      var lInput := new Double[259];
      var lOutput := new Double[259];
      var lSingleInput := new Single[259];
      var lSingleOutput := new Single[259];
      for i := 0 to length(lInput) - 1 do begin
        lInput[i] := Double(i - 129) + 0.5;
        lSingleInput[i] := Single(lInput[i]);
      end;
      for i := 0 to length(lInput) - 1 do
        lOutput[i] := Math.Round(lInput[i]);
      for i := 0 to length(lSingleInput) - 1 do
        lSingleOutput[i] := Math.Round(lSingleInput[i]);
      for i := 0 to length(lInput) - 1 do begin
        var lLower := i - 129;
        var lExpected := Double(if (lLower and 1) = 0 then lLower else lLower + 1);
        Assert.AreEqual(lExpected, lOutput[i]);
        Assert.AreEqual(Single(lExpected), lSingleOutput[i]);
      end;
    end;

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
