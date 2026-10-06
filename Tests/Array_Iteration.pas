// Positive loop guards and negative bounds guards: exposing array length must
// preserve foreach/indexed results, including empty buffers and invalid indices.
// Also guard source evaluation, mutation, iterator and matching-loop behavior.
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

    [DisableInlining]
    class method SumValues(aValues: array of Integer): Int64;
    begin
      result := 0;
      for each lValue in aValues do
        result := result + lValue;
    end;

    [DisableInlining]
    class method CountPositive(aValues: array of Integer): Integer;
    begin
      result := 0;
      for each lValue in aValues do
        if lValue > 0 then
          inc(result);
    end;

    class method DoubledValues(aValues: array of Integer): sequence of Integer; iterator;
    begin
      for each lValue in aValues do
        yield lValue * 2;
    end;

    class method SourceOnce(var aCalls: Integer): array of Integer;
    begin
      inc(aCalls);
      exit [2, 4, 6, 8];
    end;

  public

    method NilAndSourceEvaluation;
    begin
      var lValues: array of Integer := nil;
      var lCount := 0;
      for each lValue in lValues do
        inc(lCount);
      Assert.AreEqual(0, lCount);
      var lCalls := 0;
      var lSum := 0;
      for each lValue in SourceOnce(var lCalls) index i do
        lSum := lSum + lValue + i;
      Assert.AreEqual(1, lCalls);
      Assert.AreEqual(26, lSum);
      lValues := [2, 4, 6, 8];
      lSum := 0;
      for each lValue in lValues do begin
        lValues := nil;
        lSum := lSum + lValue;
      end;
      Assert.AreEqual(20, lSum);
    end;

    method MutationAndControlFlow;
    begin
      var lValues: array of Integer := [1, 2, 3, 4, 5];
      var lSum := 0;
      for each lValue in lValues index i do begin
        if i = 0 then
          lValues[1] := 20;
        if i = 2 then
          continue;
        if i = 4 then
          break;
        lSum := lSum + lValue;
      end;
      Assert.AreEqual(25, lSum);
      var lObjects: array of Object := [new OptimizationNode(Value := 3), nil, new OptimizationNode(Value := 7)];
      lSum := 0;
      var lCount := 0;
      for each lObject in lObjects do begin
        inc(lCount);
        if assigned(lObject) then
          lSum := lSum + Integer(OptimizationNode(lObject).Value);
      end;
      Assert.AreEqual(3, lCount);
      Assert.AreEqual(10, lSum);
    end;

    method ReferenceArrayLengths;
    begin
      var lStrings: array of String := ['a', 'bbb', nil, 'cc'];
      var lCount := 0;
      var lCharacters := 0;
      for each lString in lStrings do begin
        inc(lCount);
        if assigned(lString) then
          lCharacters := lCharacters + lString.Length;
      end;
      Assert.AreEqual(4, lCount);
      Assert.AreEqual(6, lCharacters);
      lStrings := new String[0];
      lCount := 0;
      for each lString in lStrings do
        inc(lCount);
      Assert.AreEqual(0, lCount);
      lStrings := nil;
      for each lString in lStrings do
        inc(lCount);
      Assert.AreEqual(0, lCount);
    end;

    method IteratorAndMatchingLoops;
    begin
      var lValues: array of Integer := [2, 4, 6];
      var lSum := 0;
      for each lValue in DoubledValues(lValues) do
        lSum := lSum + lValue;
      Assert.AreEqual(24, lSum);
      lValues := nil;
      var lCount := 0;
      for each lValue in DoubledValues(lValues) do
        inc(lCount);
      Assert.AreEqual(0, lCount);
      var lObjects: array of Object := [new OptimizationNode(Value := 3), nil, new Object, new OptimizationNode(Value := 7)];
      lSum := 0;
      for each matching lNode: OptimizationNode in lObjects do
        lSum := lSum + Integer(lNode.Value);
      Assert.AreEqual(10, lSum);
    end;

    method LengthsAndLoops;
    begin
      for each lLength in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33, 1024] do begin
        var lValues := new Integer[lLength];
        var lRows := new OptimizationRow[lLength];
        var lExpected: Int64 := 0;
        var lSum: Int64 := 0;
        var lPositive := 0;
        for i := 0 to lLength - 1 do begin
          lValues[i] := i * 7 - 3;
          lSum := lSum + lValues[i];
          if lValues[i] > 0 then
            inc(lPositive);
          lRows[i].Quantity := i mod 11 - 2;
          lRows[i].Price := i mod 97;
          lRows[i].Active := i mod 3 <> 0;
          if lRows[i].Active and (lRows[i].Quantity > 0) then
            lExpected := lExpected + lRows[i].Quantity * lRows[i].Price;
        end;
        Assert.AreEqual(lSum, SumValues(lValues));
        Assert.AreEqual(lPositive, CountPositive(lValues));
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
