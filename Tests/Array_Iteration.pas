// Positive loop guards and negative bounds guards: exposing array length must
// preserve foreach/indexed results, including empty buffers and invalid indices.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  Array_Iteration = public class(Test)
  private

    [DisableInlining]
    class method ReadAt(aValues: array of Integer; aIndex: Integer): Integer;
    begin
      exit aValues[aIndex];
    end;

    [DisableInlining]
    class method WriteAt(aValues: array of Integer; aIndex: Integer);
    begin
      aValues[aIndex] := 42;
    end;

    class method ExpectBounds(aValues: array of Integer; aIndex: Integer);
    begin
      var lRaised := false;
      try
        ReadAt(aValues, aIndex);
      except
        on E: IndexOutOfRangeException do
          lRaised := true;
      end;
      Assert.IsTrue(lRaised);
      lRaised := false;
      try
        WriteAt(aValues, aIndex);
      except
        on E: IndexOutOfRangeException do
          lRaised := true;
      end;
      Assert.IsTrue(lRaised);
    end;

  public

    method LengthsAndLoops;
    begin
      for each lLength in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33, 1024] do begin
        var lValues := new Integer[lLength];
        var lRows := new OptimizationRow[lLength];
        var lExpected: Int64 := 0;
        for i := 0 to lLength - 1 do begin
          lValues[i] := i * 7 - 3;
          lRows[i].Quantity := i mod 11 - 2;
          lRows[i].Price := i mod 97;
          lRows[i].Active := i mod 3 <> 0;
          if lRows[i].Active and (lRows[i].Quantity > 0) then
            lExpected := lExpected + lRows[i].Quantity * lRows[i].Price;
        end;
        Assert.AreEqual(lLength, lValues.Length);
        var lArray: &Array := lValues;
        Assert.AreEqual(lLength, lArray.Length);
        var lIndex := 0;
        for each lValue in lValues do begin
          Assert.AreEqual(lIndex * 7 - 3, lValue);
          inc(lIndex);
        end;
        Assert.AreEqual(lLength, lIndex);
        Assert.AreEqual(lExpected, Optimization_Workloads.InvoiceTotal(lRows));
        ExpectBounds(lValues, -1);
        ExpectBounds(lValues, low(Integer));
        ExpectBounds(lValues, lLength);
        ExpectBounds(lValues, high(Integer));
        for i := 0 to lLength - 1 do
          Assert.AreEqual(i * 7 - 3, ReadAt(lValues, i));
      end;
    end;

  end;
end.
