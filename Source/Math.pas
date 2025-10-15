namespace RemObjects.Elements.System;

interface

{.$DEFINE USE_OXYGENE_IMPLEMENTATIONS}
{$DEFINE USE_LLVM_IMPLEMENTATIONS}
{.$DEFINE USE_UCRT_IMPLEMENTATIONS}

{$IFNDEF USE_OXYGENE_IMPLEMENTATIONS}
  {$IFNDEF USE_UCRT_IMPLEMENTATIONS}
    {$IFNDEF USE_LLVM_IMPLEMENTATIONS}
      {$ERROR 'You must define one of: USE_OXYGENE_IMPLEMENTATIONS, USE_UCRT_IMPLEMENTATIONS, or USE_LLVM_IMPLEMENTATIONS'}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

//{$IFDEF USE_UCRT_IMPLEMENTATIONS}
//uses
  //Elements.RTL;
//{$ENDIF}

type
  {$IFDEF USE_UCRT_IMPLEMENTATIONS}
  TMathFunc = function(x: Double): Double;
  TMathFunc2 = function(x, y: Double): Double;
  {$ENDIF}

  Math = public class
  private
    {$IFDEF USE_UCRT_IMPLEMENTATIONS}
    class var UCRTHandle: rtl.HMODULE;
    class var UCRTAbs: TMathFunc;
    class var UCRTFmod: TMathFunc2;
    class var UCRTRemainder: TMathFunc2;
    class var UCRTAcos: TMathFunc;
    class var UCRTAsin: TMathFunc;
    class var UCRTAtan: TMathFunc;
    class var UCRTAtan2: TMathFunc2;
    class var UCRTCeil: TMathFunc;
    class var UCRTCos: TMathFunc;
    class var UCRTCosh: TMathFunc;
    class var UCRTExp: TMathFunc;
    class var UCRTExp2: TMathFunc;
    class var UCRTFloor: TMathFunc;
    class var UCRTLog: TMathFunc;
    class var UCRTLog2: TMathFunc;
    class var UCRTLog10: TMathFunc;
    class var UCRTPow: TMathFunc2;
    class var UCRTRound: TMathFunc;
    class var UCRTSin: TMathFunc;
    class var UCRTSinh: TMathFunc;
    class var UCRTSqrt: TMathFunc;
    class var UCRTTan: TMathFunc;
    class var UCRTTanh: TMathFunc;
    class var UCRTTrunc: TMathFunc;
    class method InitializeUCRT;
    class method FinalizeUCRT;
    {$ENDIF}
    {$IFDEF USE_OXYGENE_IMPLEMENTATIONS}
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
          1.00000000001008660,
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
    {$ENDIF USE_OXYGENE_IMPLEMENTATIONS}
    class method IntPow(x:Double; y: Integer): Double;
  public
    // These methods always have implementations here (eg are overrides pushing to Int64)
    class method Abs(i: Integer): Integer;
    class method Max(a,b: Integer): Integer;
    class method Min(a,b: Integer): Integer;
    class method Pow(x:Double; y: Integer): Double;
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    //class method fmodf(x,y: Single): Single;
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    //class method Floor(d: Single): Single;

    // Math functions with different implementations based on defines
    {$IFDEF USE_OXYGENE_IMPLEMENTATIONS}
    class method Abs(i: Double): Double;
    class method Abs(i: Int64): Int64;
    class method Max(a,b: Double): Double;
    class method Max(a,b: Int64): Int64;
    class method Min(a,b: Double): Double;
    class method Min(a,b: Int64): Int64;
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method fmod(x, y: Double): Double;
    class method IEEERemainder(x, y: Double): Double;
    class method Acos(d: Double): Double;
    class method Asin(d: Double): Double;
    class method Atan(d: Double): Double;
    class method Atan2(x,y: Double): Double;
    class method Ceiling(d: Double): Double;
    class method Ceiling(d: Single): Single;
    class method Cos(d: Double): Double;
    class method Cosh(d: Double): Double;
    class method Exp(d: Double): Double;
    class method Exp2(d: Double):Double;
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Floor(d: Double): Double;
    class method Log(a: Double): Double;
    class method Log2(a: Double): Double;
    class method Log10(a: Double): Double;
    class method Pow(x, y: Double): Double;
    class method Round(a: Double): Double;
    class method Sign(d: Double): Integer;
    class method Sin(x: Double): Double;
    class method Sinh(x: Double): Double;
    class method Sqrt(d: Double): Double;
    class method Tan(d: Double): Double;
    class method Tanh(d:   Double): Double;
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Truncate(d: Double): Double;
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Truncate(d: Single): Single;
    {$ENDIF}

    {$IFDEF USE_UCRT_IMPLEMENTATIONS}
    class method Abs(i: Double): Double;
    class method Abs(i: Int64): Int64;
    class method Max(a,b: Double): Double;
    class method Max(a,b: Int64): Int64;
    class method Min(a,b: Double): Double;
    class method Min(a,b: Int64): Int64;
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method fmod(x, y: Double): Double;
    class method IEEERemainder(x, y: Double): Double;
    class method Acos(d: Double): Double;
    class method Asin(d: Double): Double;
    class method Atan(d: Double): Double;
    class method Atan2(x,y: Double): Double;
    class method Ceiling(d: Double): Double;
    class method Ceiling(d: Single): Single;
    class method Cos(d: Double): Double;
    class method Cosh(d: Double): Double;
    class method Exp(d: Double): Double;
    class method Exp2(d: Double):Double;
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Floor(d: Double): Double;
    class method Log(a: Double): Double;
    class method Log2(a: Double): Double;
    class method Log10(a: Double): Double;
    class method Pow(x, y: Double): Double;
    class method Round(a: Double): Double;
    class method Sign(d: Double): Integer;
    class method Sin(x: Double): Double;
    class method Sinh(x: Double): Double;
    class method Sqrt(d: Double): Double;
    class method Tan(d: Double): Double;
    class method Tanh(d:   Double): Double;
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Truncate(d: Double): Double;
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Truncate(d: Single): Single;
    {$ENDIF}

    {$IFDEF USE_LLVM_IMPLEMENTATIONS}
    [SymbolName('llvm.fabs.f64')]
    class method Abs(i: Double): Double; external;
    class method Abs(i: Int64): Int64;
    [SymbolName('llvm.maxnum.f64')]
    class method Max(a,b: Double): Double; external;
    [SymbolName('llvm.smax.i64')]
    class method Max(a,b: Int64): Int64; external;
    [SymbolName('llvm.minnum.f64')]
    class method Min(a,b: Double): Double; external;
    [SymbolName('llvm.smin.i64')]
    class method Min(a,b: Int64): Int64; external;
    // Note: No direct LLVM intrinsic for fmod - falls back to libm
    [SymbolName('fmod')]
    //{$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method fmod(x, y: Double): Double; external;
    // IEEE remainder implemented inline
    class method IEEERemainder(x, y: Double): Double;
    [SymbolName('llvm.acos.f64')]
    class method Acos(d: Double): Double; external;
    [SymbolName('llvm.asin.f64')]
    class method Asin(d: Double): Double; external;
    [SymbolName('llvm.atan.f64')]
    class method Atan(d: Double): Double; external;
    [SymbolName('llvm.atan2.f64')]
    class method Atan2(x,y: Double): Double; external;
    [SymbolName('llvm.ceil.f64')]
    class method Ceiling(d: Double): Double; external;
    [SymbolName('llvm.ceil.f32')]
    class method Ceiling(d: Single): Single; external;
    [SymbolName('llvm.cos.f64')]
    class method Cos(d: Double): Double; external;
    [SymbolName('llvm.cosh.f64')]
    class method Cosh(d: Double): Double; external;
    [SymbolName('llvm.exp.f64')]
    class method Exp(d: Double): Double; external;
    [SymbolName('llvm.exp2.f64')]
    class method Exp2(d: Double):Double; external;
    [SymbolName('llvm.floor.f64'), Used]
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Floor(d: Double): Double; external;
    [SymbolName('llvm.log.f64')]
    class method Log(a: Double): Double; external;
    [SymbolName('llvm.log2.f64')]
    class method Log2(a: Double): Double; external;
    [SymbolName('llvm.log10.f64')]
    class method Log10(a: Double): Double; external;
    [SymbolName('llvm.pow.f64')]
    class method Pow(x, y: Double): Double; external;
    [SymbolName('llvm.round.f64')]
    class method Round(a: Double): Double; external;
    class method Sign(d: Double): Integer;
    [SymbolName('llvm.sin.f64')]
    class method Sin(x: Double): Double; external;
    [SymbolName('llvm.sinh.f64')]
    class method Sinh(x: Double): Double; external;
    [SymbolName('llvm.sqrt.f64')]
    class method Sqrt(d: Double): Double; external;
    [SymbolName('llvm.tan.f64')]
    class method Tan(d: Double): Double; external;
    [SymbolName('llvm.tanh.f64')]
    class method Tanh(d:   Double): Double; external;
    [SymbolName('llvm.trunc.f64')]
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Truncate(d: Double): Double; external;
    [SymbolName('llvm.trunc.f32'), Used]
    {$IFDEF WebAssembly}[DLLExport]{$ENDIF}
    class method Truncate(d: Single): Single; external;
    {$ENDIF}

    const PI: Double = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582232;
    const E:  Double = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466391932;

    {$IFDEF USE_UCRT_IMPLEMENTATIONS}
    type
      AutoCleanup = class
      public
        constructor;
        begin
          Math.InitializeUCRT;
        end;

        finalizer;
        begin
          Math.FinalizeUCRT;
        end;
      end;

    class var _ := new AutoCleanup; // triggers init + cleanup
    {$ENDIF USE_UCRT_IMPLEMENTATIONS}
  end;

  //{$IFDEF USE_UCRT_IMPLEMENTATIONS}
  //__Global = public partial static class
  //private
  //public
    //class constructor;
    //class finalizer;
  //end;
  //{$ENDIF USE_UCRT_IMPLEMENTATIONS}

implementation

{$IFDEF USE_UCRT_IMPLEMENTATIONS}
class method Math.InitializeUCRT;
begin
  Console.WriteLine('Initializing...');
  UCRTHandle := rtl.LoadLibrary('ucrtbase.dll');
  Console.WriteLine(String.Format('got ucrt handle: {0}', UInt64(UCRTHandle)));
  if UCRTHandle = nil then
    raise new Exception('Failed to load ucrtbase.dll');

  UCRTAbs := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'fabs'));
  //Console.WriteLine(String.Format('got abs ptr: {0}', UInt64(UCRTAbs)));
  UCRTFmod := TMathFunc2(rtl.GetProcAddress(UCRTHandle, 'fmod'));
  UCRTRemainder := TMathFunc2(rtl.GetProcAddress(UCRTHandle, 'remainder'));
  UCRTAcos := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'acos'));
  UCRTAsin := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'asin'));
  UCRTAtan := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'atan'));
  UCRTAtan2 := TMathFunc2(rtl.GetProcAddress(UCRTHandle, 'atan2'));
  UCRTCeil := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'ceil'));
  UCRTCos := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'cos'));
  UCRTCosh := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'cosh'));
  UCRTExp := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'exp'));
  UCRTExp2 := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'exp2'));
  UCRTFloor := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'floor'));
  UCRTLog := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'log'));
  UCRTLog2 := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'log2'));
  UCRTLog10 := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'log10'));
  UCRTPow := TMathFunc2(rtl.GetProcAddress(UCRTHandle, 'pow'));
  UCRTRound := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'round'));
  UCRTSin := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'sin'));
  UCRTSinh := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'sinh'));
  UCRTSqrt := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'sqrt'));
  UCRTTan := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'tan'));
  UCRTTanh := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'tanh'));
  UCRTTrunc := TMathFunc(rtl.GetProcAddress(UCRTHandle, 'trunc'));

  // Verify all function pointers were loaded successfully
  // !!! this is debug code, this can be cleaner!
  var TMathFuncPointers: array of ^Void := [
    ^Void(UCRTAbs), ^Void(UCRTFmod), ^Void(UCRTRemainder), ^Void(UCRTAcos), ^Void(UCRTAsin),
    ^Void(UCRTAtan), ^Void(UCRTAtan2), ^Void(UCRTCeil), ^Void(UCRTCos), ^Void(UCRTCosh),
    ^Void(UCRTExp), ^Void(UCRTExp2), ^Void(UCRTFloor), ^Void(UCRTLog), ^Void(UCRTLog2),
    ^Void(UCRTLog10), ^Void(UCRTPow), ^Void(UCRTRound), ^Void(UCRTSin), ^Void(UCRTSinh),
    ^Void(UCRTSqrt), ^Void(UCRTTan), ^Void(UCRTTanh), ^Void(UCRTTrunc)
  ];

  var FunctionNames: array of String := [
    'fabs', 'fmod', 'remainder', 'acos', 'asin', 'atan', 'atan2', 'ceil', 'cos', 'cosh',
    'exp', 'exp2', 'floor', 'log', 'log2', 'log10', 'pow', 'round', 'sin', 'sinh',
    'sqrt', 'tan', 'tanh', 'trunc'
  ];

  for i: Integer := 0 to length(TMathFuncPointers) - 1 do begin
    if TMathFuncPointers[i] = nil then
      raise new Exception(String.Format('Failed to load UCRT function: {0}', FunctionNames[i]));
  end;
end;

class method Math.FinalizeUCRT;
begin
  Console.WriteLine('Finalizing...');
  if UCRTHandle <> nil then begin
    Console.WriteLine('Freeing library...');
    rtl.FreeLibrary(UCRTHandle);
    UCRTHandle := nil;
    Console.WriteLine('Library freed.');
  end;
end;
{$ENDIF}

// The following methods always have implementations here

class method Math.Abs(i: Integer): Integer;
begin
  exit Abs(Int64(i));
end;

class method Math.Max(a,b: Integer): Integer;
begin
  exit Max(Int64(a), Int64(b));
end;

class method Math.Min(a,b: Integer): Integer;
begin
  exit Min(Int64(a), Int64(b));
end;

class method Math.Pow(x:Double; y: Integer): Double;
begin
  exit Pow(x, Double(y));
end;

//class method Math.fmodf(x,y: Single): Single;
//begin
  //exit fmod(Double(x), Double(y));
//end;

//class method Math.Floor(d: Single): Single;
//begin
  //exit Floor(Double(d));
//end;

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

{$IFDEF USE_OXYGENE_IMPLEMENTATIONS}

// The following methods have implementations only if not found via intrinsics or the system C runtime, eg UCRT, libm, etc

class method Math.Abs(i: Double): Double;
begin
  exit if i < 0 then - i else i;
end;

class method Math.Abs(i: Int64): Int64;
begin
  exit if i < 0 then - i else i;
end;

//class method Math.Abs(i: Integer): Integer;
//begin
  //exit if i < 0 then - i else i;
//end;

class method Math.Max(a,b: Double): Double;
begin
  exit if a < b then b else a;
end;

//class method Math.Max(a,b: Integer): Integer;
//begin
  //exit if a < b then b else a;
//end;

class method Math.Max(a,b: Int64): Int64;
begin
  exit if a < b then b else a;
end;

class method Math.Min(a,b: Double): Double;
begin
  exit if a > b then b else a;
end;

//class method Math.Min(a,b: Integer): Integer;
//begin
  //exit if a > b then b else a;
//end;

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

class method Math.Acos(d: Double): Double;
begin
  exit Atan2(Sqrt((1 + d) * (1 - d)), d);
end;

class method Math.Asin(d: Double): Double;
begin
  exit Atan2(d, Sqrt((1 + d) * (1 - d)));
end;

class method Math.Atan(d: Double): Double;
begin
  exit Atan2(d, 1.0);
end;

class method Math.Atan2(x,y: Double): Double;
begin
  //http://http.developer.nvidia.com/Cg/atan2.html
{
isn't very precise. "this" vs "standard math"
atan2(2,3)   =
  0,588004872422497 vs
  0,588002603547568
atan2(1.9,2) =
  0,759765540970373 vs
  0,759762754875771
atan2(2,0.5) =
  1,3258165931712   vs
  1,32581766366803
}
  var t0, t1, t3, t4: Double;

  t3 := Abs(y);
  t1 := Abs(x);
  t0 := Max(t3, t1);
  t1 := Min(t3, t1);
  t3 := 1.0 / t0;
  t3 := t1 * t3;

  t4 := t3 * t3;
  t0 :=         - 0.013480470;
  t0 := t0 * t4 + 0.057477314;
  t0 := t0 * t4 - 0.121239071;
  t0 := t0 * t4 + 0.195635925;
  t0 := t0 * t4 - 0.332994597;
  t0 := t0 * t4 + 0.999995630;
  t3 := t0 * t3;

  t3 := if (Abs(x) > Abs(y)) then 1.570796327 - t3 else t3;
  t3 := if (y < 0) then PI - t3 else t3;
  t3 := if (x < 0) then -t3 else t3;

  exit t3;
end;

class method Math.Ceiling(d: Double): Double;
begin
  var p := d mod 1;
  if p = 0 then exit d;
  if d < 0 then exit d-p else exit d-p+1;
end;

class method Math.Ceiling(d: Single): Single;
begin
  var p := d mod 1;
  if p = 0 then exit d;
  if d < 0 then exit d-p else exit d-p+1;
end;

class method Math.Cos(d: Double): Double;
begin
  exit Sin(PI/2 - d);
end;

class method Math.Cosh(d: Double): Double;
begin
  //http://http.developer.nvidia.com/Cg/cosh.html
  exit 0.5 * (Exp(d)+Exp(-d));
end;

class method Math.Exp2(d: Double): Double;
begin
  var pIEEE_754_raw := ^UInt64(@d)^;

  var signum := if (pIEEE_754_raw and Double.SignificantBitmask)=0 then 0 else 1;
  var tmp := pIEEE_754_raw and not Double.SignificantBitmask;
  var exponent: Integer := (tmp shr 52)-1023;
  var mantissa: UInt64 := Double.SignificantBitmask or (tmp shl 11);

  if exponent < -EXP2_MAX_ITERATIONS then exit 1;
  if exponent = -EXP2_MAX_ITERATIONS then exit (if signum = 0 then EXP2_LOOK_UP_TABLE[EXP2_MAX_ITERATIONS] else 1/EXP2_LOOK_UP_TABLE[EXP2_MAX_ITERATIONS]);
  if exponent > 9 then exit (if signum = 0 then Double.PositiveInfinity else 0 {????});

  var iterations: Integer := EXP2_MAX_ITERATIONS;
  var lIndex: Integer;
  var temp: Double;
  if exponent < 0 then begin
    var offset: Integer := Abs(exponent);
    iterations := iterations + exponent;
    lIndex := offset;
    temp := EXP2_LOOK_UP_TABLE[lIndex]
  end
  else begin
    lIndex := 0;
    temp := 1;
  end;

  for i: Integer := 1 to iterations do begin
    inc(lIndex);
    mantissa := mantissa shl 1;
    var test := mantissa and Double.SignificantBitmask;

    if test<>0 then temp := temp * EXP2_LOOK_UP_TABLE[lIndex];
  end;
  if exponent>=0 then result := 2*temp else result := temp;

  if signum=1 then result := 1 / result;
  if exponent > 0 then
    for i: Integer := 1 to exponent do
      result := result * result;
end;

class method Math.Exp(d: Double): Double;
begin
  // exit 2^(x/ln(2))
  exit Exp2(d/ln2);
end;

//class method Math.Floor(d: Single): Single;
//begin
  //var xi := Integer(d);
  //if d < xi then
    //exit xi -1;
  //exit xi;
//end;

class method Math.Floor(d: Double): Double;
begin
  if (d = 0.0) then exit 0.0;
  var res : Double := 0.0;

  var pIEEE_754_raw := ^UInt64(@d)^;

  var signum := if (pIEEE_754_raw and Double.SignificantBitmask)=0 then 0 else 1;
  var tmp := pIEEE_754_raw and not Double.SignificantBitmask;
  var exponent: Integer := (tmp shr 52)-1023;
  if exponent >= 52 then res := d
  else if exponent > -1 then begin
    var mantissa: UInt64 := Double.FractionBitmask and tmp;
    var denominator: UInt64 := UInt64(1) shl 52;
    var numerator : UInt64 := mantissa + denominator;

    if (exponent > 0) then
      denominator := denominator shr exponent
    else
      numerator := numerator shr (-exponent);
    var temp :UInt64:= 1;
    var temp1:UInt64 := denominator;

    if (numerator >= denominator) then begin
      while numerator > (temp1 shl 1) do begin
        temp := temp shl 1;
        temp1 := temp1 shl 1;
      end;
      while temp >0 do begin
        res := res + temp;
        numerator := numerator-temp1;
        while numerator < temp1 do begin
          temp := temp shr 1;
          temp1 := temp1 shr 1;
          if temp = 0 then break;
        end;
        if temp = 0 then break;
      end;
    end;
  end;
  if signum = 1 then res := -res -1;

 exit res;
end;

class method Math.Log(a: Double): Double;
begin
  exit Log2(a)*ln2;
end;

class method Math.Log2(a: Double): Double;
begin
  result := 0;
  if a < 0 then exit Double.NaN;
  if a = 0 then exit Double.NegativeInfinity;
  while a >= 2 do begin
    result:= result+1;
    a := a / 2;
  end;
  while a < 1 do begin
    result:= result-1;
    a := a*2
  end;
  if a = 1 then exit;
  var di: Double := 1.0;
  for i: Integer :=1 to EXP2_MAX_ITERATIONS do begin
    di := di /2;
    if a >= EXP2_LOOK_UP_TABLE[i] then begin
      result := result + di;
      a := a / EXP2_LOOK_UP_TABLE[i];
      if a = 1 then break;
    end;
  end;
end;

class method Math.Log10(a: Double): Double;
begin
  exit Log(a)/Log(10);
end;

//class method Math.Pow(x: Double; y: Integer): Double;
//begin
  //if y >= 0 then
    //exit IntPow(x, y)
  //else
    //exit 1.0 / IntPow(x, -y);
//end;

class method Math.Pow(x, y: Double): Double;
begin
  if (y.IsInt) then
    exit Pow(x, Integer(y))
  else
    exit Exp(y * Log(x));
end;

class method Math.Round(a: Double): Double;
begin
  var p := a mod 1;
  if p = 0 then exit Double(a);
  var p1 := Abs(p);
  if p1 < 0.5 then exit Double(a - p);
  if p1 > 0.5 then exit Double(a - p) + if a<0 then -1 else 1;
  //special case, p1 = 0.5
  //12.5 => 12 and 11.5 => 12
  //-12.5 => -12 and -11.5 => -12
  var d1 := a + if a<0 then -0.5 else 0.5;
  if d1 mod 2 <> 0 then begin
    exit Double(d1) - if a<0 then -1 else 1
  end
  else
    exit Double(d1);
end;

class method Math.Sin(x: Double): Double;
begin
  // result := x^1/1! - x^3/3! + x^5/5! - x^7/7! ...

  var x2: Double := - x*x;
  var r: Double := x;
  var it := 1;
  var delta := x;
  while it < SIN_ACCURACY_ITERATION do begin
    delta := delta*x2/(it+1)/(it+2);
    r := r + delta;
    inc(it,2);
  end;
  exit r;
end;

class method Math.Sinh(x: Double): Double;
begin
  //http://http.developer.nvidia.com/Cg/sinh.html
  exit 0.5 * (Exp(x)-Exp(-x));
end;

class method Math.Sqrt(d: Double): Double;
begin
  exit Exp2((0.5 * Log(d))/ln2); // Pow(d, 0.5) = Exp(0.5 * Log(d)) = Exp2((0.5 * Log(d))/ln2);
end;

class method Math.Tan(d: Double): Double;
begin
  exit Sin(d) / Cos(d);
end;

class method Math.Tanh(d: Double): Double;
begin
  // http://http.developer.nvidia.com/Cg/tanh.html
  var exp2x: Double := Exp(2*d);
  exit (exp2x - 1) / (exp2x + 1);
end;

class method Math.Truncate(d: Double): Double;
begin
  exit if d < 0 then -Floor(-d) else Floor(d);
end;

class method Math.Truncate(d: Single): Single;
begin
  exit if d < 0 then -Floor(-d) else Floor(d);
end;

class method Math.fmod(x: Double; y: Double): Double;
begin
  // from https://msdn.microsoft.com/en-us/library/system.math.ieeeremainder%28v=vs.110%29.aspx
  // Modulus = (Math.Abs(dividend) - (Math.Abs(divisor) *
  //           (Math.Floor(Math.Abs(dividend) / Math.Abs(divisor))))) *
  //           Math.Sign(dividend)
  exit (Abs(x) - (Abs(y) *  (Floor(Abs(x) / Abs(y))))) * Sign(x);
end;

//class method Math.fmodf(x,y: Single): Single;
//begin
  //exit Math.fmod(x, y);
//end;

{$ENDIF USE_OXYGENE_IMPLEMENTATIONS}

{$IFDEF USE_UCRT_IMPLEMENTATIONS}

// UCRT implementations - call function pointers

class method Math.Abs(i: Double): Double;
begin
  assert(assigned(UCRTAbs), 'UCRTAbs not assigned');
  exit UCRTAbs(i);
end;

class method Math.Abs(i: Int64): Int64;
begin
  exit if i < 0 then -i else i; // No abs function for Int64 in UCRT, use simple implementation
end;

class method Math.Max(a,b: Double): Double;
begin
  exit if a > b then a else b; // No max function in UCRT, use simple implementation
end;

class method Math.Max(a,b: Int64): Int64;
begin
  exit if a > b then a else b; // No max function in UCRT, use simple implementation
end;

class method Math.Min(a,b: Double): Double;
begin
  exit if a < b then a else b; // No min function in UCRT, use simple implementation
end;

class method Math.Min(a,b: Int64): Int64;
begin
  exit if a < b then a else b; // No min function in UCRT, use simple implementation
end;

class method Math.fmod(x, y: Double): Double;
begin
  assert(assigned(UCRTFmod), 'fmod not assigned');
  exit UCRTFmod(x, y);
end;

class method Math.IEEERemainder(x, y: Double): Double;
begin
  assert(assigned(UCRTRemainder), 'IEEERemainder not assigned');
  exit UCRTRemainder(x, y);
end;

class method Math.Acos(d: Double): Double;
begin
  assert(assigned(UCRTAcos), 'Acos not assigned');
  exit UCRTAcos(d);
end;

class method Math.Asin(d: Double): Double;
begin
  assert(assigned(UCRTAsin), 'Asin not assigned');
  exit UCRTAsin(d);
end;

class method Math.Atan(d: Double): Double;
begin
  assert(assigned(UCRTAtan), 'Atan not assigned');
  exit UCRTAtan(d);
end;

class method Math.Atan2(x,y: Double): Double;
begin
  assert(assigned(UCRTAtan2), 'Atan2 not assigned');
  exit UCRTAtan2(x, y);
end;

class method Math.Ceiling(d: Double): Double;
begin
  assert(assigned(UCRTCeil), 'Ceiling not assigned');
  exit UCRTCeil(d);
end;

class method Math.Ceiling(d: Single): Single;
begin
  exit Ceiling(Double(d)); // Use always-present Oxygene implementation
end;

class method Math.Cos(d: Double): Double;
begin
  assert(assigned(UCRTCos), 'Cos not assigned');
  exit UCRTCos(d);
end;

class method Math.Cosh(d: Double): Double;
begin
  assert(assigned(UCRTCosh), 'Cosh not assigned');
  exit UCRTCosh(d);
end;

class method Math.Exp(d: Double): Double;
begin
  assert(assigned(UCRTExp), 'Exp not assigned');
  exit UCRTExp(d);
end;

class method Math.Exp2(d: Double): Double;
begin
  assert(assigned(UCRTExp2), 'Exp2 not assigned');
  exit UCRTExp2(d);
end;

class method Math.Floor(d: Double): Double;
begin
  assert(assigned(UCRTFloor), 'Floor not assigned');
  exit UCRTFloor(d);
end;

class method Math.Log(a: Double): Double;
begin
  assert(assigned(UCRTLog), 'Log not assigned');
  exit UCRTLog(a);
end;

class method Math.Log2(a: Double): Double;
begin
  assert(assigned(UCRTLog2), 'Log2 not assigned');
  exit UCRTLog2(a);
end;

class method Math.Log10(a: Double): Double;
begin
  assert(assigned(UCRTLog10), 'Log10 not assigned');
  exit UCRTLog10(a);
end;

class method Math.Pow(x, y: Double): Double;
begin
  assert(assigned(UCRTPow), 'Pow not assigned');
  exit UCRTPow(x, y);
end;

class method Math.Round(a: Double): Double;
begin
  assert(assigned(UCRTRound), 'UCRTRound not assigned');
  exit UCRTRound(a);
end;

class method Math.Sign(d: Double): Integer;
begin
  if d = 0 then exit 0;
  if d < 0 then exit -1 else exit 1;
end;

class method Math.Sin(x: Double): Double;
begin
  assert(assigned(UCRTSin), 'Sin not assigned');
  exit UCRTSin(x);
end;

class method Math.Sinh(x: Double): Double;
begin
  assert(assigned(UCRTSinh), 'UCRTSinh not assigned');
  exit UCRTSinh(x);
end;

class method Math.Sqrt(d: Double): Double;
begin
  assert(assigned(UCRTSqrt), 'Sqrt not assigned');
  exit UCRTSqrt(d);
end;

class method Math.Tan(d: Double): Double;
begin
  assert(assigned(UCRTTan), 'Tan not assigned');
  exit UCRTTan(d);
end;

class method Math.Tanh(d: Double): Double;
begin
  assert(assigned(UCRTTanh), 'Tanh not assigned');
  exit UCRTTanh(d);
end;

class method Math.Truncate(d: Double): Double;
begin
  assert(assigned(UCRTTrunc), 'Truncate not assigned');
  exit UCRTTrunc(d);
end;

class method Math.Truncate(d: Single): Single;
begin
  exit Truncate(Double(d)); // Use always-present Oxygene implementation
end;

{$ENDIF USE_UCRT_IMPLEMENTATIONS}

{$IFDEF USE_LLVM_IMPLEMENTATIONS}

// LLVM implementations for methods that don't have direct intrinsic mapping

[SymbolName('llvm.abs.i64')]
method llvm_abs_i64(value: Int64; is_int_min_poison: Boolean): Int64; external;

class method Math.Abs(i: Int64): Int64;
begin
  exit llvm_abs_i64(i, false);
end;

class method Math.IEEERemainder(x, y: Double): Double;
begin
  // IEEE 754 remainder: x - n*y where n is the integer nearest to x/y
  // If x/y is exactly halfway between two integers, choose the even one
  var quotient := x / y;
  var n := Round(quotient);
  
  // Handle the halfway case - round to even
  if Abs(quotient - n) = 0.5 then begin
    if (Trunc(n) mod 2) <> 0 then
      n := n + if quotient > 0 then -1 else 1;
  end;
  
  exit x - n * y;
end;

class method Math.Sign(d: Double): Integer;
begin
  if d = 0 then exit 0;
  if d < 0 then exit -1 else exit 1;
end;

{$ENDIF USE_LLVM_IMPLEMENTATIONS}


//-> Task RemObjects.EBuild.Elements.ElementsLink started for performance-oxygene.
               //-> Task Link started for performance-oxygene, Island-Windows.
//D:                "C:\Program Files (x86)\RemObjects Software\Elements\Bin\win-arm64\lld.exe" -flavor link "@C:\Users\work\AppData\Local\RemObjects Software\EBuild\Obj\854B9DE6BD16D16A7A14F5335FE5AD801B92BD51\Release\Island-Windows\LinkerCommandline.txt"
//E:                undefined symbol: fmod
                  //> >>> referenced by performanceoxygene.output.lib(Program-ba5d98a337cb0d7c034cbeb041862f7b.o):(ms_t1c_performanceoxygene_d_Program1b_TestCeiling__Double__Scalar)
                  //> >>> referenced by performanceoxygene.output.lib(Program-ba5d98a337cb0d7c034cbeb041862f7b.o):(ms_t1c_performanceoxygene_d_Program1b_TestCeiling__Double__Scalar)
                  //> >>> referenced by performanceoxygene.output.lib(Program-ba5d98a337cb0d7c034cbeb041862f7b.o):(ms_t1c_performanceoxygene_d_Program1b_TestCeiling__Single__Scalar)
                  //> >>> referenced 9 more times
//E:                undefined symbol: floor
                  //> >>> referenced by /__windows_drive__c/ci/b/elements/937/source/rtl2/source/remobjects.elements.rtl/convert.pas:291
                  //> >>>               Elements.lib(Convert-05fc323a40b901913f55360bbae19e28.o):(ms_t25_RemObjects_d_Elements_d_RTL_d_Convert7_ToInt32nd)
                  //> >>> referenced by /__windows_drive__c/ci/b/elements/937/source/rtl2/source/remobjects.elements.rtl/convert.pas:742
                  //> >>>               Elements.lib(Convert-05fc323a40b901913f55360bbae19e28.o):(ms_t25_RemObjects_d_Elements_d_RTL_d_Convert7_ToInt64nd)
                  //> >>> referenced by /__windows_drive__c/ci/b/elements/937/source/rtl2/source/remobjects.elements.rtl/convert.pas:988
                  //> >>>               Elements.lib(Convert-05fc323a40b901913f55360bbae19e28.o):(ms_t25_RemObjects_d_Elements_d_RTL_d_Convert6_ToBytend)

[DLLExport]
[SymbolName('fmod')] // export with this name, unmangled
method fmod(a, b: Double): Double;
begin
  exit Math.fmod(a, b);
end;

[DLLExport]
[SymbolName('fmodf')] // export with this name, unmangled
method fmodf(a, b: Single): Single;
begin
  exit Math.fmod(a, b);
end;

[DLLExport]
[SymbolName('floor')] // export with this name, unmangled
method floor(x: Double): Double;
begin
  exit Math.Floor(x);
end;

//{$IFDEF USE_UCRT_IMPLEMENTATIONS}
//class constructor __Global;
//begin
  //writeLn('global init!');
  //Math.InitializeUCRT;
  ////rtl.atexit(@Math.FinalizeUCRT);
//end;

//class finalizer __Global;
//begin
  //writeLn('global final!');
  //Math.FinalizeUCRT;
//end;

//{$ENDIF USE_UCRT_IMPLEMENTATIONS}

end.