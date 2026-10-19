// Negative regression guards: IEEE remainder rounds quotient ties to even,
// preserves signed zero, and remains correct when x/y overflows or is subnormal.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  Math_IEEERemainder = public class(Test)
  private

    class method FromBits(aBits: UInt64): Double;
    begin
      exit ^Double(@aBits)^;
    end;

    class method Check(aX, aY, aExpected: Double);
    begin
      var lActual := Math.IEEERemainder(aX, aY);
      Assert.AreEqual(^UInt64(@lActual)^, ^UInt64(@aExpected)^);
    end;

    {$IF DARWIN}
    [SymbolName('remainder')]
    class method NativeRemainder(aX, aY: Double): Double; external;

    [SymbolName('remainderf')]
    class method NativeRemainderSingle(aX, aY: Single): Single; external;

    [DisableInlining]
    class method ReferenceRemainderSingle(aX, aY: Single): Single;
    begin
      exit NativeRemainderSingle(aX, aY);
    end;

    // Keep the reference scalar even when the test loop is optimized.
    [DisableInlining]
    class method ReferenceRemainder(aX, aY: Double): Double;
    begin
      exit NativeRemainder(aX, aY);
    end;
    {$ENDIF}

  public

    method TiesAndSigns;
    begin
      Check(5, 2, 1);
      Check(7, 2, -1);
      Check(-5, 2, -1);
      Check(-7, -2, 1);
      Check(5, -2, 1);
      Check(3, 2, -1);
      Check(1, 2, 1);
      Check(6, 2, 0);
      Check(-6, 2, FromBits($8000000000000000));
      Check(FromBits($8000000000000000), 2, FromBits($8000000000000000));
      Assert.AreEqual(Math.IEEERemainder(Single(5), Single(2)), Single(1));
      Assert.AreEqual(Math.IEEERemainder(Single(7), Single(2)), Single(-1));
    end;

    method ExtremeExponents;
    begin
      var lTiny := FromBits(1);
      var lLargest := FromBits($7fefffffffffffff);
      Check(lLargest, lTiny, 0);
      Check(-lLargest, lTiny, FromBits($8000000000000000));
      Check(lLargest, 3 * lTiny, -lTiny);
      Check(5 * lTiny, 2 * lTiny, lTiny);
      Check(7 * lTiny, 2 * lTiny, -lTiny);
      Check(lTiny, lLargest, lTiny);
      Check(FromBits($0010000000000000), FromBits($000fffffffffffff), lTiny);
      var lSingleTinyBits: UInt32 := 1;
      var lSingleMaxBits: UInt32 := $7f7fffff;
      Assert.AreEqual(Math.IEEERemainder(^Single(@lSingleMaxBits)^,
        ^Single(@lSingleTinyBits)^), Single(0));
    end;

    method SpecialValues;
    begin
      var lInfinity := FromBits($7ff0000000000000);
      Check(5, lInfinity, 5);
      Check(-5, -lInfinity, -5);
      for each lPair in [0, 1, 2, 3] do begin
        var lValue := case lPair of
          0: Math.IEEERemainder(5.0, 0.0);
          1: Math.IEEERemainder(lInfinity, 2.0);
          2: Math.IEEERemainder(Double.NaN, 2.0);
          else Math.IEEERemainder(2.0, Double.NaN);
        end;
        Assert.IsTrue(lValue <> lValue);
      end;
    end;

    method CompareWithSystemRemainder;
    begin
      {$IF DARWIN}
      // Raw finite bit patterns exercise the entire exponent range, rather
      // than a narrow decimal interval. xorshift avoids overflow arithmetic.
      var lState: UInt64 := $123456789abcdef;
      for i := 0 to 19999 do begin
        lState := lState xor (lState shl 13);
        lState := lState xor (lState shr 7);
        lState := lState xor (lState shl 17);
        var lXBits := lState;
        if (lXBits and $7ff0000000000000) = $7ff0000000000000 then
          lXBits := lXBits xor $0010000000000000;
        var lX := FromBits(lXBits);
        lState := lState xor (lState shl 13);
        lState := lState xor (lState shr 7);
        lState := lState xor (lState shl 17);
        var lYBits := lState or 1;
        if (lYBits and $7ff0000000000000) = $7ff0000000000000 then
          lYBits := lYBits xor $0010000000000000;
        var lY := FromBits(lYBits);
        Check(lX, lY, ReferenceRemainder(lX, lY));
        var lSingleXBits := UInt32(lXBits and $ffffffff);
        var lSingleYBits := UInt32(lYBits and $ffffffff) or 1;
        if (lSingleXBits and $7f800000) = $7f800000 then
          lSingleXBits := lSingleXBits xor $00800000;
        if (lSingleYBits and $7f800000) = $7f800000 then
          lSingleYBits := lSingleYBits xor $00800000;
        var lSingleX := ^Single(@lSingleXBits)^;
        var lSingleY := ^Single(@lSingleYBits)^;
        var lActual := Math.IEEERemainder(lSingleX, lSingleY);
        var lExpected := ReferenceRemainderSingle(lSingleX, lSingleY);
        Assert.AreEqual(^UInt32(@lActual)^, ^UInt32(@lExpected)^);
      end;
      {$ENDIF}
    end;

  end;
end.
