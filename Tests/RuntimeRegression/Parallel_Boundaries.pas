// Negative regression guards: loop failures must reach the caller after all
// workers finish. Positive guards cover each index exactly once, Int64 limits,
// empty/reversed ranges, early stopping, iterator disposal and nested loops.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
{$IFNDEF NOTHREADS}
type
  Parallel_Boundaries = public class(Test)
  private
    var fDisposed: Boolean;
    var fEnumerated: Integer;
    method CountedSequence: sequence of Integer; iterator;
    begin
      try
        for i := 0 to 9999 do begin
          inc(fEnumerated);
          yield i;
        end;
      finally
        fDisposed := true;
      end;
    end;
    method FailingSequence: sequence of Integer; iterator;
    begin
      try
        yield 7;
        raise new Exception('enumerator failure');
      finally
        fDisposed := true;
      end;
    end;
  public
    method EveryIntegerIndexOnce;
    begin
      var values := new Integer[513];
      Parallel.For(-3, 510, (i, state) -> begin inc(values[i + 3]); end);
      for each value in values do Assert.AreEqual(1, value);
    end;

    method Int64EdgesAndEmptyRanges;
    begin
      var values := new Integer[4];
      Parallel.For(Int64.MaxValue - 4, Int64.MaxValue,
        (i, state) -> begin inc(values[Integer(i - (Int64.MaxValue - 4))]); end);
      Parallel.For(Int64.MinValue, Int64.MinValue + 4,
        (i, state) -> begin inc(values[Integer(i - Int64.MinValue)]); end);
      for each value in values do Assert.AreEqual(2, value);
      Parallel.For(Int32.MinValue, Int32.MinValue,
        (i, state) -> begin raise new Exception('empty Int32'); end);
      Parallel.For(Int64.MinValue, Int64.MinValue,
        (i, state) -> begin raise new Exception('empty Int64'); end);
      Parallel.For(5, 2, (i, state) -> begin raise new Exception('reversed range'); end);
    end;

    method ValuesAndIndicesStayPaired;
    begin
      var values := new String[129];
      for i := 0 to values.Length - 1 do values[i] := i.ToString;
      var seen := new Integer[values.Length];
      Parallel.ForEach<String>(values, (value, state, index) -> begin
        Assert.AreEqual(Integer(index).ToString, value);
        inc(seen[Integer(index)]);
      end);
      for each value in seen do Assert.AreEqual(1, value);
      Parallel.ForEach<Integer>(new Integer[0], (value, state, index) -> begin
        raise new Exception('empty sequence');
      end);
    end;

    method BodyFailureWaitsForWorkers;
    begin
      var active := 0;
      var caught := false;
      try
        Parallel.For(0, 128, (i, state) -> begin
          InternalCalls.Increment(var active);
          try
            if i = 1 then raise new Exception('body failure');
            Thread.Sleep(1);
          finally
            InternalCalls.Decrement(var active);
          end;
        end);
      except
        on e: Exception do begin
          Assert.AreEqual('body failure', e.Message);
          caught := true;
        end;
      end;
      Assert.IsTrue(caught);
      Assert.AreEqual(0, active);
    end;

    method OtherOverloadsPropagateFailures;
    begin
      var caught := false;
      try
        Parallel.For(Int64(0), Int64(7), (i, state) -> begin raise new Exception('Int64 failure'); end);
      except
        on e: Exception do begin Assert.AreEqual('Int64 failure', e.Message); caught := true; end;
      end;
      Assert.IsTrue(caught);
      caught := false;
      try
        Parallel.ForEach<Integer>([1, 2, 3], (value, state, index) -> begin raise new Exception('sequence failure'); end);
      except
        on e: Exception do begin Assert.AreEqual('sequence failure', e.Message); caught := true; end;
      end;
      Assert.IsTrue(caught);
    end;

    method EnumerationFailureDisposesSource;
    begin
      fDisposed := false;
      var caught := false;
      try
        Parallel.ForEach<Integer>(FailingSequence, (value, state, index) -> begin end);
      except
        on e: Exception do begin Assert.AreEqual('enumerator failure', e.Message); caught := true; end;
      end;
      Assert.IsTrue(caught);
      Assert.IsTrue(fDisposed);
    end;

    method BreakStopsNewWork;
    begin
      var count := 0;
      Parallel.For(0, 10000, (i, state) -> begin
        InternalCalls.Increment(var count);
        state.Break;
      end);
      Assert.IsTrue((count > 0) and (count < 10000));
    end;

    method EarlyBreakDisposesEnumerator;
    begin
      fDisposed := false;
      fEnumerated := 0;
      Parallel.ForEach<Integer>(CountedSequence, (value, state, index) -> state.Break);
      Assert.IsTrue(fDisposed);
      Assert.IsTrue((fEnumerated > 0) and (fEnumerated < 10000));
    end;

    method OwnedValuesSurviveWorkerCopiesAndGC;
    begin
      var values := new OleString[33];
      for i := 0 to values.Length - 1 do values[i] := new OleString('owned ' + i.ToString);
      var seen := new Integer[values.Length];
      Parallel.ForEach<OleString>(values, (value, state, index) -> begin
        if index = 0 then BoehmGC.Collect(2);
        Assert.AreEqual('owned ' + Integer(index).ToString, value.ToString);
        inc(seen[Integer(index)]);
      end);
      for i := 0 to values.Length - 1 do begin
        Assert.AreEqual(1, seen[i]);
        Assert.AreEqual('owned ' + i.ToString, values[i].ToString);
      end;
    end;

    method NestedLoopsMakeProgress;
    begin
      var seen := new Integer[88];
      var work := Task.Run(-> begin
        Parallel.For(0, 8, (i, outerState) -> begin
          Parallel.For(0, 11, (j, innerState) -> begin inc(seen[i * 11 + j]); end);
        end);
      end);
      Assert.IsTrue(work.Wait(10000));
      Assert.IsFalse(work.IsFaulted);
      for each value in seen do Assert.AreEqual(1, value);
    end;
  end;
{$ENDIF}
end.
