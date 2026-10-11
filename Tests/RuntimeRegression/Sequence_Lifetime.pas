// Regression guards: lazy Take must not read beyond its requested prefix;
// sequence comparison must release enumerators on every exit and compare nil safely.
// Contains uses equality, including objects which have no ordering interface.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  SequenceCounts = class public Opened, Read, Closed: Integer; end;
  EqualityOnlyValue = class
  public
    Value: Integer;
    method Equals(aOther: Object): Boolean; override;
    begin
      exit (aOther is EqualityOnlyValue) and (Value = EqualityOnlyValue(aOther).Value);
    end;
    method GetHashCode: Integer; override;
    begin
      exit Value;
    end;
  end;
  Sequence_Lifetime = public class(Test)
  private
    class method Source(aCounts: SequenceCounts; aLength: Integer; aOffset: Integer := 0; aThrowAt: Integer := -1): sequence of Integer; iterator;
    begin
      inc(aCounts.Opened);
      try
        for i := 0 to aLength - 1 do begin
          if i = aThrowAt then raise new Exception('source failure');
          inc(aCounts.Read);
          yield i + aOffset;
        end;
      finally
        inc(aCounts.Closed);
      end;
    end;
  public
    method TakeZeroDoesNotOpenSource;
    begin
      for each n in [0, -1, Integer.MinValue] do begin
        var c := new SequenceCounts;
        Assert.AreEqual(0, Source(c, 5).Take(n).Count);
        Assert.AreEqual(0, c.Opened);
        Assert.AreEqual(0, c.Read);
      end;
    end;
    method TakeStopsAtExactBoundary;
    begin
      var c := new SequenceCounts;
      var values := Source(c, 5, 0, 2).Take(2).ToArray;
      Assert.AreEqual(2, values.Length);
      Assert.AreEqual(0, values[0]);
      Assert.AreEqual(1, values[1]);
      Assert.AreEqual(2, c.Read);
      Assert.AreEqual(1, c.Closed);
      c := new SequenceCounts;
      Assert.AreEqual(2, Source(c, 2).Take(10).Count);
      Assert.AreEqual(1, c.Closed);
    end;
    method EqualSequencesAndDifferentLengths;
    begin
      for each length in [0, 1, 5, 6] do begin
        var a := new SequenceCounts;
        var b := new SequenceCounts;
        Assert.AreEqual(length = 5, Source(a, 5).EqualsTo(Source(b, length)));
        Assert.AreEqual(1, a.Closed);
        Assert.AreEqual(1, b.Closed);
      end;
    end;
    method ComparisonMismatchReleasesBoth;
    begin
      var a := new SequenceCounts;
      var b := new SequenceCounts;
      Assert.IsFalse(Source(a, 5).EqualsTo(Source(b, 5, 1)));
      Assert.AreEqual(1, a.Read);
      Assert.AreEqual(1, b.Read);
      Assert.AreEqual(1, a.Closed);
      Assert.AreEqual(1, b.Closed);
    end;
    method ComparisonFailureReleasesBoth;
    begin
      var a := new SequenceCounts;
      var b := new SequenceCounts;
      var failed := false;
      try
        Source(a, 5).EqualsTo(Source(b, 5, 0, 1));
      except
        on e: Exception do failed := true;
      end;
      Assert.IsTrue(failed);
      Assert.AreEqual(1, a.Closed);
      Assert.AreEqual(1, b.Closed);
    end;
    method EqualityWithoutOrderingAndNil;
    begin
      var a: sequence of EqualityOnlyValue := [new EqualityOnlyValue(Value := 7), nil];
      var b: sequence of EqualityOnlyValue := [new EqualityOnlyValue(Value := 7), nil];
      Assert.IsTrue(a.Contains(new EqualityOnlyValue(Value := 7)));
      Assert.IsFalse(a.Contains(new EqualityOnlyValue(Value := 8)));
      Assert.IsTrue(a.Contains(nil));
      Assert.IsTrue(a.EqualsTo(b));
      var c: sequence of EqualityOnlyValue := [new EqualityOnlyValue(Value := 7), new EqualityOnlyValue(Value := 0)];
      Assert.IsFalse(a.EqualsTo(c));
      Assert.IsFalse(c.EqualsTo(a));
    end;
  end;
end.
