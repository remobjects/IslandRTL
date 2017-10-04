namespace RemObjects.Elements.System;

interface

type
  Math = public class
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
    class method IntPow(x:Double; y: Integer): Double;
  public
    [SymbolName('fabs')]
    class method Abs(i: Double): Double;
    class method Abs(i: Int64): Int64;
    class method Abs(i: Integer): Integer;
    class method Max(a,b: Double): Double;
    class method Max(a,b: Integer): Integer;
    class method Max(a,b: Int64): Int64;
    class method Min(a,b: Double): Double;
    class method Min(a,b: Integer): Integer;
    class method Min(a,b: Int64): Int64;
    [SymbolName('fmod'), Used]
    class method fmod(x, y: Double): Double;
    class method IEEERemainder(x, y: Double): Double;
    [SymbolName('acos')]
    class method Acos(d: Double): Double;
    [SymbolName('asin')]
    class method Asin(d: Double): Double;
    [SymbolName('atan')]
    class method Atan(d: Double): Double;
    [SymbolName('atan2')]
    class method Atan2(x,y: Double): Double;
    [SymbolName('ceil')]
    class method Ceiling(d: Double): Double;
    [SymbolName('cos')]
    class method Cos(d: Double): Double;
    [SymbolName('cosh')]
    class method Cosh(d: Double): Double;
    [SymbolName('exp')]
    class method Exp(d: Double): Double;
    class method Exp2(d: Double):Double;
    [SymbolName('floor'), Used]
    class method Floor(d: Double): Double;
    [SymbolName('log')]
    class method Log(a: Double): Double;
    class method Log2(a: Double): Double;
    [SymbolName('log10')]
    class method Log10(a: Double): Double;
    class method Pow(x:Double; y: Integer): Double;
    [SymbolName('pow')]
    class method Pow(x, y: Double): Double;
    [SymbolName('round')]
    class method Round(a: Double): Int64;
    class method Sign(d: Double): Integer;
    [SymbolName('sin')]
    class method Sin(x: Double): Double;
    [SymbolName('sinh')]
    class method Sinh(x: Double): Double;
    [SymbolName('sqrt')]
    class method Sqrt(d: Double): Double;
    [SymbolName('tan')]
    class method Tan(d: Double): Double;
    [SymbolName('tanh')]
    class method Tanh(d:   Double): Double;
    [SymbolName('trunc'), Used]
    class method Truncate(d: Double): Double;

    const PI: Double = 3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582232;
    const E:  Double = 2.718281828459045235360287471352662497757247093699959574966967627724076630353547594571382178525166427427466391932;
  end;

implementation

class method Math.Abs(i: Double): Double;
begin
  exit if i < 0 then - i else i;
end;

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


class method Math.Pow(x: Double; y: Integer): Double;
begin  
  if y >= 0 then 
    exit IntPow(x, y)
  else
    exit 1.0 / IntPow(x, -y); 
end;

class method Math.Pow(x, y: Double): Double;
begin
  if (y.IsInt) then
    exit Pow(x, Integer(y))
  else
    exit Exp(y * Log(x));
end;

class method Math.Round(a: Double): Int64;
begin
  var p := a mod 1;
  if p = 0 then exit Int64(a);
  var p1 := Abs(p);
  if p1 < 0.5 then exit Int64(a - p);
  if p1 > 0.5 then exit Int64(a - p) + if a<0 then -1 else 1;
  //special case, p1 = 0.5
  //12.5 => 12 and 11.5 => 12
  //-12.5 => -12 and -11.5 => -12
  var d1 := a + if a<0 then -0.5 else 0.5;
  if d1 mod 2 <> 0 then begin
    exit Int64(d1) - if a<0 then -1 else 1
  end
  else
    exit Int64(d1);
end;

class method Math.Sin(x: Double): Double;
begin
  //result := x^1/1! - x^3/3! + x^5/5! - x^7/7! ...
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

class method Math.fmod(x: Double; y: Double): Double;
begin
  // from https://msdn.microsoft.com/en-us/library/system.math.ieeeremainder%28v=vs.110%29.aspx
  // Modulus = (Math.Abs(dividend) - (Math.Abs(divisor) *
  //           (Math.Floor(Math.Abs(dividend) / Math.Abs(divisor))))) *
  //           Math.Sign(dividend)
  exit (Abs(x) - (Abs(y) *  (Floor(Abs(x) / Abs(y))))) * Sign(x);
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

end.