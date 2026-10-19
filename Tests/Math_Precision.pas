// Negative regression guard: scalar Pow must retain SLEEF's one-ULP accuracy.
// The scalar variants previously advertised unfused x*y+z as FMA and lost precision.
namespace RemObjects.Elements.Island.Tests;

uses RemObjects.Elements.EUnit;

type
  Math_Precision = public class(Test)
  private

    [DisableInlining, DisableOptimizations]
    class method ScalarPower(aBase, aExponent: Double): Double;
    begin
      exit Math.Pow(aBase, aExponent);
    end;

    {$IF WINDOWS}
    [SymbolName('Sleef_powd1_u10purec'), DisableInlining]
    class method BaselinePower(aBase, aExponent: Double): Double; external;
    {$ENDIF}

  public

    method DecimalPowers;
    begin
      var lExpected: array of Double := [1.0, 0.1, 0.01, 0.001, 0.0001,
        0.00001, 0.000001, 0.0000001, 0.00000001, 0.000000001,
        0.0000000001, 0.00000000001, 0.000000000001, 0.0000000000001,
        0.00000000000001, 0.000000000000001];
      for i := 0 to length(lExpected) - 1 do begin
        var lActual := ScalarPower(10.0, -i);
        var lDistance := BitConverter.DoubleToInt64Bits(lActual) - BitConverter.DoubleToInt64Bits(lExpected[i]);
        Assert.IsTrue((lDistance >= -1) and (lDistance <= 1), 'Pow(10, -' + i.ToString + ') must be within one ULP.');
        {$IF WINDOWS}
        // Exercise the no-FMA fallback even when this machine selects the FMA variant.
        lActual := BaselinePower(10.0, -i);
        lDistance := BitConverter.DoubleToInt64Bits(lActual) - BitConverter.DoubleToInt64Bits(lExpected[i]);
        Assert.IsTrue((lDistance >= -1) and (lDistance <= 1), 'Baseline Pow must be within one ULP.');
        {$ENDIF}
      end;
    end;

  end;

end.
