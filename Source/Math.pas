namespace RemObjects.Elements.System;

interface

// Platform and architecture gating for SLEEF vector math library
// Must match compiler's ShouldUseVectorMathLib logic
//
// Two implementations are available:
//   1. Math.LLVMVectorLib.pas - SLEEF-based (ENABLED for supported platforms)
//   2. Math.PurePascal.pas    - Pure Pascal fallback
//
// Supported: Windows (i386, x86_64, arm64), macOS/Linux (x86_64, arm64)
// NOT supported: 32-bit Linux, iOS, tvOS, watchOS, visionOS, Android, WebAssembly
// You MUST keep this up to date with Elements' IslandOutput.pas, ShouldUseVectorMathLib()

// Check same conditions as Math.pas - must be kept in sync!
{$IF WINDOWS OR (DARWIN AND MACOS) OR (LINUX AND (X86_64 OR ARM64))}
  {$IFNDEF PUREPASCAL}
    {$DEFINE USE_LLVM_MATH_VECTORLIB}  // Uses SLEEF library with LLVM vectorization
  {$ENDIF}
{$ENDIF}

type
  Math = public partial class
  private
    const SIN_ACCURACY_ITERATION = 21+1;
    const ln2 = 0.693147180559945309417232121458176568075500134360255254120680009493393621969694715605863326996418687542001481020570685733685520235758130557;
    {$REGION EXP2 lookup table}
    const EXP2_MAX_ITERATIONS=50;
    const EXP2_LOOK_UP_TABLE: array [0..EXP2_MAX_ITERATIONS] of Double =
         [2.00000000000000000,
          1.41421356237309515,
          1.18920711500272103,
          1.09050773266525769,
          1.04427378242741375,
          1.02189714865411663,
          1.01088928605170048,
          1.00542990111280273,
          1.00271127505020252,
          1.00135471989210822,
          1.00067713069306641,
          1.00033850805268232,
          1.00016923970530214,
          1.00008461627269440,
          1.00004230724139576,
          1.00002115339696473,
          1.00001057664254978,
          1.00000528830729185,
          1.00000264415015017,
          1.00000132207420123,
          1.00000066103688212,
          1.00000033051838644,
          1.00000016525917945,
          1.00000008262958628,
          1.00000004131479225,
          1.00000002065739602,
          1.00000001032869790,
          1.00000000516434895,
          1.00000000258217447,
          1.00000000129108724,
          1.00000000064554362,
          1.00000000032277181,
          1.00000000016138579,
          1.00000000008069301,
          1.00000000004034639,
          1.00000000002017320,
          1.00000001008660,
          1.00000000000504330,
          1.00000000000252176,
          1.00000000000126077,
          1.00000000000063038,
          1.00000000000031530,
          1.00000000000015765,
          1.00000000000007883,
          1.00000000000003930,
          1.00000000000001976,
          1.00000000000000977,
          1.00000000000000488,
          1.00000000000000244,
          1.00000000000000133,
          1.00000000000000067];
    {$ENDREGION}
    class method IntPow(x:Double; y: Integer): Double;
  public
    // Utility methods with implementations in this file
    class method Abs(i: Int64): Int64;
    class method Abs(i: Integer): Integer;
    class method Max(a,b: Double): Double; inline;
    class method Max(a,b: Single): Single; inline;
    class method Max(a,b: Integer): Integer;
    class method Max(a,b: Int64): Int64;
    class method Min(a,b: Double): Double; inline;
    class method Min(a,b: Single): Single; inline;
    class method Min(a,b: Integer): Integer;
    class method Min(a,b: Int64): Int64;
    class method IEEERemainder(x, y: Double): Double;
    class method IEEERemainder(x, y: Single): Single;
    class method Sign(d: Double): Integer;
    class method Sign(d: Single): Integer; inline;

    // Math functions with SLEEF/LLVM implementations are declared in Math.LLVMVectorLib.pas
    // (or Math.PurePascal.pas for non-SLEEF platforms)

    // Integer overload of Pow has custom implementation (not external)
    class method Pow(x:Double; y: Integer): Double;

    const PI: Double = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582232;
    const E:  Double = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466391932;
  end;

  // Software fallback shared by PUREPASCAL math and baseline x86 libcalls.
  // Keep C round's ties-away contract separate from public Math.Round's ties-even.
  MathRounding = assembly static class
  private
    // At 2^52 and above every finite Double is already an integer.
    const DoubleIntegralLimit: Double = 4503599627370496.0;
  assembly
    class method RoundToIntegral(aValue: Double; aTiesToEven: Boolean): Double;
  end;

implementation

class method MathRounding.RoundToIntegral(aValue: Double; aTiesToEven: Boolean): Double;
begin
  var lMagnitude := Math.Abs(aValue);
  // Preserve infinities, NaNs, large integers and the sign of an input zero.
  // The unordered comparison also avoids converting NaN to an integer below.
  if not (lMagnitude < DoubleIntegralLimit) or (aValue = 0) then
    exit aValue;

  var lIntegral := Math.Floor(lMagnitude);
  var lFraction := lMagnitude - lIntegral;
  // Subtract before testing the midpoint: adding 0.5 first can round a value
  // just below a midpoint up to it, or change an already integral large value.
  if (lFraction > 0.5) or ((lFraction = 0.5) and
     (not aTiesToEven or ((Int64(lIntegral) and 1) <> 0))) then
    lIntegral := lIntegral + 1;
  // Negating a zero result preserves -0 for negative fractions and -0.5 ties.
  exit if aValue < 0 then -lIntegral else lIntegral;
end;

// Simple utility methods - always use these implementations
class method Math.Abs(i: Int64): Int64;
begin
  exit if i < 0 then - i else i;
end;

class method Math.Abs(i: Integer): Integer;
begin
  exit if i < 0 then - i else i;
end;

class method Math.Max(a,b: Double): Double;
begin
  exit if a < b then b else a;
end;

// Reuse Double semantics; inlining exposes the comparison to the optimizer.
class method Math.Max(a,b: Single): Single;
begin
  exit Single(Max(Double(a), Double(b)));
end;

class method Math.Max(a,b: Integer): Integer;
begin
  exit if a < b then b else a;
end;

class method Math.Max(a,b: Int64): Int64;
begin
  exit if a < b then b else a;
end;

class method Math.Min(a,b: Double): Double;
begin
  exit if a > b then b else a;
end;

// Reuse Double semantics; inlining exposes the comparison to the optimizer.
class method Math.Min(a,b: Single): Single;
begin
  exit Single(Min(Double(a), Double(b)));
end;

class method Math.Min(a,b: Integer): Integer;
begin
  exit if a > b then b else a;
end;

class method Math.Min(a,b: Int64): Int64;
begin
  exit if a > b then b else a;
end;

class method Math.Sign(d: Double): Integer;
begin
  if d = 0 then exit 0;
  if d < 0 then exit -1 else exit 1;
end;

class method Math.IEEERemainder(x, y: Double): Double;
begin
  var lXBits := ^UInt64(@x)^;
  var lYBits := ^UInt64(@y)^ and $7fffffffffffffff;
  var lMagnitude := lXBits and $7fffffffffffffff;
  if (lMagnitude >= $7ff0000000000000) or (lYBits = 0) or
     (lYBits > $7ff0000000000000) then
    exit Double.NaN;
  if (lMagnitude = 0) or (lYBits = $7ff0000000000000) then
    exit x;

  // Work in exact significand units. Reducing modulo twice the divisor
  // retains quotient parity, so halfway cases choose the even quotient.
  // Unlike x - y * Round(x/y), this also handles overflowing quotients.
  var lXExponent := Integer(lMagnitude shr 52);
  var lYExponent := Integer(lYBits shr 52);
  var lX := lMagnitude and $000fffffffffffff;
  var lY := lYBits and $000fffffffffffff;
  if lXExponent = 0 then
    lXExponent := -1074
  else begin
    lX := lX or $0010000000000000;
    dec(lXExponent, 1075);
  end;
  if lYExponent = 0 then
    lYExponent := -1074
  else begin
    lY := lY or $0010000000000000;
    dec(lYExponent, 1075);
  end;

  var lExponent := lYExponent;
  if lXExponent < lYExponent then begin
    if lYExponent - lXExponent > 1 then
      exit x;
    lY := lY shl 1;
    lExponent := lXExponent;
  end
  else begin
    var lModulus := lY shl 1;
    lX := lX mod lModulus;
    for i := 1 to lXExponent - lYExponent do
      lX := (lX shl 1) mod lModulus;
  end;

  var lRemainder := Int64(lX);
  if (lX shl 1) >= 3 * lY then
    dec(lRemainder, Int64(lY shl 1))
  else if (lX shl 1) > lY then
    dec(lRemainder, Int64(lY));
  var lScaleBits: UInt64;
  if lExponent >= -1022 then
    lScaleBits := UInt64(lExponent + 1023) shl 52
  else
    lScaleBits := UInt64(1) shl (lExponent + 1074);
  result := Double(lRemainder) * ^Double(@lScaleBits)^;
  // Apply the dividend sign as bits so an exact zero keeps that sign too.
  ^UInt64(@result)^ := ^UInt64(@result)^ xor (lXBits and $8000000000000000);
end;

class method Math.Sign(d: Single): Integer;
begin
  exit Sign(Double(d));
end;

class method Math.IEEERemainder(x, y: Single): Single;
begin
  exit Single(IEEERemainder(Double(x), Double(y)));
end;

class method Math.IntPow(x: Double; y: Integer): Double;
begin
  if y = 0 then exit 1.0;
  if y = 1 then exit x;
  var fl := y mod 2 = 1;
  if fl then dec(y);
  var res: Double := x;
  while (y mod 2) = 0 do begin
    res := res*res;
    y := y shr 1;
  end;
  res := IntPow(res, y);
  if fl then res := res * x;
  exit res;
end;

class method Math.Pow(x:Double; y: Integer): Double;
begin
  if y < 0 then exit 1.0/IntPow(x, -y)
  else exit IntPow(x, y);
end;

end.