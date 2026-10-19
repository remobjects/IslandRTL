// Positive optimization guards: ordinary parsing, filtering, reductions, tree
// traversal and dispatch must retain their results with optimization enabled.
// No timings are asserted: generated IR is inspected separately for code quality.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  OptimizationRow = public record
  public
    Quantity: Integer;
    Price: Int64;
    Active: Boolean;
  end;

  OptimizationNode = public class
  public
    Value: Int64;
    Left, Right: OptimizationNode;
  end;

  OptimizationPrice = public class
  public
    method Apply(aValue: Int64): Int64; virtual;
    begin
      exit aValue;
    end;
  end;

  OptimizationDiscount = sealed class(OptimizationPrice)
  public
    method Apply(aValue: Int64): Int64; override;
    begin
      exit aValue - aValue div 10;
    end;
  end;

  Optimization_Workloads = public class(Test)
  public

    [DisableInlining]
    class method TailSum(aCount: Integer; aTotal: Int64): Int64;
    begin
      if aCount = 0 then
        exit aTotal;
      exit TailSum(aCount - 1, aTotal + aCount);
    end;

    [DisableInlining]
    class method TreeSum(aNode: OptimizationNode): Int64;
    begin
      if not assigned(aNode) then
        exit 0;
      exit aNode.Value + TreeSum(aNode.Left) + TreeSum(aNode.Right);
    end;

    [DisableInlining]
    class method InvoiceTotal(aRows: array of OptimizationRow): Int64;
    begin
      result := 0;
      for each lRow in aRows do
        if lRow.Active and (lRow.Quantity > 0) then
          result := result + lRow.Quantity * lRow.Price;
    end;

    [DisableInlining]
    class method ParseNumbers(aText: String): Int64;
    begin
      result := 0;
      var lValue: Int64 := 0;
      for i := 0 to aText.Length - 1 do begin
        var lChar := aText[i];
        if (lChar >= '0') and (lChar <= '9') then
          lValue := lValue * 10 + (Integer(lChar) - Integer('0'))
        else begin
          result := result + lValue;
          lValue := 0;
        end;
      end;
      result := result + lValue;
    end;

    [DisableInlining]
    class method TransformAndSum(aValues: array of Integer): Int64;
    begin
      result := 0;
      for i := 0 to aValues.Length - 1 do begin
        aValues[i] := aValues[i] * 3 + 7;
        result := result + aValues[i];
      end;
    end;

    [DisableInlining]
    class method Dispatch(aPrice: OptimizationPrice; aValue: Int64): Int64;
    begin
      exit aPrice.Apply(aValue);
    end;

    [DisableInlining]
    class method KnownDispatch(aValue: Int64): Int64;
    begin
      var lPrice: OptimizationPrice := new OptimizationDiscount;
      exit lPrice.Apply(aValue);
    end;

    method RecursionAndTrees;
    begin
      Assert.AreEqual(TailSum(257, 11), Int64(33164));
      Assert.AreEqual(TailSum(0, -3), Int64(-3));
      var lRoot := new OptimizationNode;
      lRoot.Value := 7;
      lRoot.Left := new OptimizationNode;
      lRoot.Left.Value := 11;
      lRoot.Right := new OptimizationNode;
      lRoot.Right.Value := -3;
      Assert.AreEqual(TreeSum(lRoot), Int64(15));
      Assert.AreEqual(TreeSum(nil), Int64(0));
      var lChain: OptimizationNode;
      for i := 1 to 128 do begin
        var lNode := new OptimizationNode;
        lNode.Value := i;
        lNode.Right := lChain;
        lChain := lNode;
      end;
      Assert.AreEqual(TreeSum(lChain), Int64(8256));
    end;

    method ParsingAndFiltering;
    begin
      Assert.AreEqual(ParseNumbers('12,345,0,6789'), Int64(7146));
      Assert.AreEqual(ParseNumbers(''), Int64(0));
      Assert.AreEqual(ParseNumbers(',1,,2,'), Int64(3));
      var lRows := new OptimizationRow[4];
      lRows[0].Quantity := 3;
      lRows[0].Price := 125;
      lRows[0].Active := true;
      lRows[1].Quantity := 100;
      lRows[1].Price := 999;
      lRows[1].Active := false;
      lRows[2].Quantity := -1;
      lRows[2].Price := 500;
      lRows[2].Active := true;
      lRows[3].Quantity := 2;
      lRows[3].Price := 250;
      lRows[3].Active := true;
      Assert.AreEqual(InvoiceTotal(lRows), Int64(875));
      Assert.AreEqual(InvoiceTotal(new OptimizationRow[0]), Int64(0));
    end;

    method ReductionsAndDispatch;
    begin
      for each lLength in [0, 1, 3, 4, 7, 16, 17, 257] do begin
        var lValues := new Integer[lLength];
        for i := 0 to lLength - 1 do
          lValues[i] := i - 10;
        Assert.AreEqual(TransformAndSum(lValues),
          Int64(3) * lLength * (lLength - 1) div 2 - Int64(23) * lLength);
        for i := 0 to lLength - 1 do
          Assert.AreEqual(lValues[i], 3 * i - 23);
      end;
      Assert.AreEqual(Dispatch(new OptimizationPrice, 123), Int64(123));
      Assert.AreEqual(Dispatch(new OptimizationDiscount, 123), Int64(111));
      Assert.AreEqual(KnownDispatch(123), Int64(111));
    end;

  end;
end.
