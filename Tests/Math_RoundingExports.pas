// Negative regression guards: Windows/Linux rounding exports must link and
// return rather than recurse through their own LLVM libcalls on x64-v1 and
// x86 SSE2 targets. In particular, Linux must provide the Single roundf export.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

{$IF not PUREPASCAL AND (WINDOWS OR (DARWIN AND MACOS) OR (LINUX AND (X86_64 OR ARM64)))}
type
  Math_RoundingExports = public class(Test)
  private

    [SymbolName('floor')]
    class method NativeFloorDouble(aValue: Double): Double; external;

    [SymbolName('ceil')]
    class method NativeCeilDouble(aValue: Double): Double; external;

    [SymbolName('trunc')]
    class method NativeTruncDouble(aValue: Double): Double; external;

    [SymbolName('roundeven')]
    class method NativeRoundEvenDouble(aValue: Double): Double; external;

    [SymbolName('round')]
    class method NativeRoundDouble(aValue: Double): Double; external;

    [DisableOptimizations, DisableInlining]
    class method CallDouble(aOperation: Integer; aValue: Double): Double;
    begin
      case aOperation of
        0: exit NativeFloorDouble(aValue);
        1: exit NativeCeilDouble(aValue);
        2: exit NativeTruncDouble(aValue);
        3: exit NativeRoundDouble(aValue);
        4: exit NativeRoundEvenDouble(aValue);
      end;
      exit Double(0);
    end;

    [SymbolName('floorf')]
    class method NativeFloorSingle(aValue: Single): Single; external;

    [SymbolName('ceilf')]
    class method NativeCeilSingle(aValue: Single): Single; external;

    [SymbolName('truncf')]
    class method NativeTruncSingle(aValue: Single): Single; external;

    [SymbolName('roundevenf')]
    class method NativeRoundEvenSingle(aValue: Single): Single; external;

    [SymbolName('roundf')]
    class method NativeRoundSingle(aValue: Single): Single; external;

    [DisableOptimizations, DisableInlining]
    class method CallSingle(aOperation: Integer; aValue: Single): Single;
    begin
      case aOperation of
        0: exit NativeFloorSingle(aValue);
        1: exit NativeCeilSingle(aValue);
        2: exit NativeTruncSingle(aValue);
        3: exit NativeRoundSingle(aValue);
        4: exit NativeRoundEvenSingle(aValue);
      end;
      exit Single(0);
    end;

  public

    // The public ties-even change must not change C round/roundf (operation 3).
    // Baseline x86 roundeven/f (operation 4) must terminate without libcall recursion.
    method DoubleExports;
    begin
      var lInput: array of Double := [Double(-2.0), Double(-1.5), Double(-0.5), Double(-0.25), Double(0.25), Double(0.5), Double(1.5), Double(2.0)];
      var lExpected: array of Double := [-2, -2, -1, -1, 0, 0, 1, 2,
        -2, -1, 0, 0, 1, 1, 2, 2,
        -2, -1, 0, 0, 0, 0, 1, 2,
        -2, -2, -1, 0, 0, 1, 2, 2,
        -2, -2, 0, 0, 0, 0, 2, 2];
      for lOperation := 0 to 4 do begin
        for i := 0 to length(lInput) - 1 do
          Assert.AreEqual(lExpected[lOperation * length(lInput) + i], CallDouble(lOperation, lInput[i]));
        for each lValue in [Double(-9223372036854775808.0), Double(9223372036854775808.0), Double.PositiveInfinity, Double.NegativeInfinity] do
          Assert.AreEqual(lValue, CallDouble(lOperation, lValue));
        var lNaN := CallDouble(lOperation, Double.NaN);
        Assert.IsTrue(lNaN <> lNaN);
        var lBits: UInt64 := $8000000000000000;
        var lZero := CallDouble(lOperation, ^Double(@lBits)^);
        Assert.AreEqual(lBits, ^UInt64(@lZero)^);
      end;
    end;

    method SingleRoundPrecisionBoundary;
    begin
      Assert.AreEqual(Single(8388608.0), CallSingle(3, Single(8388607.5)));
      Assert.AreEqual(Single(8388609.0), CallSingle(3, Single(8388609.0)));
      Assert.AreEqual(Single(-8388609.0), CallSingle(3, Single(-8388609.0)));
      var lTinyBits: UInt32 := $80000001;
      var lRounded := CallSingle(3, ^Single(@lTinyBits)^);
      Assert.AreEqual(UInt32($80000000), ^UInt32(@lRounded)^);
      lRounded := CallSingle(3, Single(-0.25));
      Assert.AreEqual(UInt32($80000000), ^UInt32(@lRounded)^);
    end;

    method SingleExports;
    begin
      var lInput: array of Single := [Single(-2.0), Single(-1.5), Single(-0.5), Single(-0.25), Single(0.25), Single(0.5), Single(1.5), Single(2.0)];
      var lExpected: array of Single := [-2, -2, -1, -1, 0, 0, 1, 2,
        -2, -1, 0, 0, 1, 1, 2, 2,
        -2, -1, 0, 0, 0, 0, 1, 2,
        -2, -2, -1, 0, 0, 1, 2, 2,
        -2, -2, 0, 0, 0, 0, 2, 2];
      for lOperation := 0 to 4 do begin
        for i := 0 to length(lInput) - 1 do
          Assert.AreEqual(lExpected[lOperation * length(lInput) + i], CallSingle(lOperation, lInput[i]));
        for each lValue in [Single(-9223372036854775808.0), Single(9223372036854775808.0), Single.PositiveInfinity, Single.NegativeInfinity] do
          Assert.AreEqual(lValue, CallSingle(lOperation, lValue));
        var lNaN := CallSingle(lOperation, Single.NaN);
        Assert.IsTrue(lNaN <> lNaN);
        var lBits: UInt32 := $80000000;
        var lZero := CallSingle(lOperation, ^Single(@lBits)^);
        Assert.AreEqual(lBits, ^UInt32(@lZero)^);
      end;
    end;

  end;
{$ENDIF}
end.
