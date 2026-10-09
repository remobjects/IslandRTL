// Negative regression guards: signed Int64 division/remainder must normalize
// negative operands before unsigned long division, including MinValue. Exercise
// ordinary operators and the actual Windows helper exports separately; LLVM can
// replace subtraction of a positive quotient with division by a negative value.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;

type
  Integer_Division = public class(Test)
  private

    [DisableInlining]
    class method Divide(aLeft, aRight: Int64): Int64;
    begin
      exit aLeft div aRight;
    end;

    [DisableInlining]
    class method Remainder(aLeft, aRight: Int64): Int64;
    begin
      exit aLeft mod aRight;
    end;

    [DisableInlining]
    class method Discount(aValue: Int64): Int64;
    begin
      exit aValue - aValue div 10;
    end;

    {$IF WINDOWS}
    [SymbolName(#1'__alldiv'), CallingConvention(CallingConvention.Stdcall)]
    class method NativeDivide(aLeft, aRight: Int64): Int64; external;

    [SymbolName(#1'__allrem'), CallingConvention(CallingConvention.Stdcall)]
    class method NativeRemainder(aLeft, aRight: Int64): Int64; external;

    [DisableOptimizations, DisableInlining]
    class method HelperDivide(aLeft, aRight: Int64): Int64;
    begin
      exit NativeDivide(aLeft, aRight);
    end;

    [DisableOptimizations, DisableInlining]
    class method HelperRemainder(aLeft, aRight: Int64): Int64;
    begin
      exit NativeRemainder(aLeft, aRight);
    end;
    {$ENDIF}

    class method Check(aLeft, aRight, aQuotient, aRemainder: Int64);
    begin
      Assert.AreEqual(Divide(aLeft, aRight), aQuotient);
      Assert.AreEqual(Remainder(aLeft, aRight), aRemainder);
      {$IF WINDOWS}
      Assert.AreEqual(HelperDivide(aLeft, aRight), aQuotient);
      Assert.AreEqual(HelperRemainder(aLeft, aRight), aRemainder);
      {$ENDIF}
    end;

  public

    // A 32-bit oracle is independent of the 64-bit Windows helper under test.
    method SmallSignedOperands;
    begin
      for lLeft: Integer := -33 to 33 do
        for lRight: Integer := -13 to 13 do
          if lRight <> 0 then
            Check(lLeft, lRight, lLeft div lRight, lLeft mod lRight);
    end;

    // Cover both signs, high words, zero quotients and the unsigned magnitude
    // 2^63. MinValue / -1 and division by zero are outside this test's contract.
    method WideSignedOperands;
    begin
      Check(-257, -10, 25, -7);
      Check(-257, 10, -25, -7);
      Check(257, -10, -25, 7);
      Check(-1, 10, 0, -1);
      Check(Int64.MinValue, 1, Int64.MinValue, 0);
      Check(Int64.MinValue, 2, -4611686018427387904, 0);
      Check(Int64.MinValue, -2, 4611686018427387904, 0);
      Check(Int64.MinValue, 3, -3074457345618258602, -2);
      Check(Int64.MinValue, Int64.MinValue, 1, 0);
      Check(Int64.MaxValue, Int64.MinValue, 0, Int64.MaxValue);
      Check(-1, Int64.MinValue, 0, -1);
      Check(Int64.MinValue, Int64.MaxValue, -1, -1);
      Check(Int64.MaxValue, -4294967296, -2147483647, 4294967295);
      Check(-4294967297, 4294967296, -1, -1);
    end;

    // Protect the real arithmetic pattern which exposed negative helper divisors.
    method SubtractConstantQuotient;
    begin
      for i: Integer := -257 to 257 do
        Assert.AreEqual(Discount(i), Int64(i - i div 10));
    end;
  end;
end.
