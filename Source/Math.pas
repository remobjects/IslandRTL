namespace RemObjects.Elements.System;

interface

// Platform and architecture gating for SLEEF vector math library
// Must match compiler's ShouldUseVectorMathLib logic
//
// Two implementations available:
//   1. Math.LLVMVectorLib.pas - SLEEF-based (ENABLED for supported platforms)
//   2. Math.PurePascal.pas    - Pure Pascal fallback
// Supported: Windows (), macOS (ARM), Linux (non-Android) on i386, x86_64, ARM64
// You MUST keep this up to date with Elements' IslandOutput.pas, ShouldUseVectorMathLib()

// Check same conditions as Math.pas - must be kept in sync!
{$IF WINDOWS OR (DARWIN AND MACOS) OR ((LINUX AND NOT ANDROID) AND (i386 OR x86_64 OR ARM64))}
  {$DEFINE USE_LLVM_MATH_VECTORLIB}  // Uses SLEEF library with LLVM vectorization
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
    class method Max(a,b: Double): Double;
    class method Max(a,b: Integer): Integer;
    class method Max(a,b: Int64): Int64;
    class method Min(a,b: Double): Double;
    class method Min(a,b: Integer): Integer;
    class method Min(a,b: Int64): Int64;
    class method IEEERemainder(x, y: Double): Double;
    class method Sign(d: Double): Integer;

    // Math functions with SLEEF/LLVM implementations are declared in Math.LLVMVectorLib.pas
    // (or Math.PurePascal.pas for non-SLEEF platforms)

    // Integer overload of Pow has custom implementation (not external)
    class method Pow(x:Double; y: Integer): Double;

    const PI: Double = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582232;
    const E:  Double = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466391932;
  end;

implementation

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
  // from https://msdn.microsoft.com/en-us/library/system.math.ieeeremainder%28v=vs.110%29.aspx
  // IEEERemainder = dividend - (divisor * Math.Round(dividend / divisor))
  if y = 0 then exit Double.NaN;
  exit (x - y * Round(x / y));
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