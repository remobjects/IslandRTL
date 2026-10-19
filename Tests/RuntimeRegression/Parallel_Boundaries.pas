// Negative regression guards: loop failures must reach the caller after all
// workers finish. Positive guards cover each index exactly once, Int64 limits,
// empty/reversed ranges, early stopping, iterator disposal and nested loops.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
{$IFNDEF NOTHREADS}
type
  // A real IEnumerator separates Current from MoveNext, unlike an iterator
  // method. Each entry point checks affinity; disposal must follow joined bodies
  // even when Current or Dispose itself fails.
  ParallelThreadBoundEnumerator = class(IEnumerable<Integer>, IEnumerator<Integer>)
  private
    fThread: ThreadID := Thread.CurrentThreadID;
    fValue: Integer := -1;
    method GetCurrent: Integer;
    begin
      Assert.IsTrue(Thread.CurrentThreadID = fThread);
      if FailCurrent then raise new Exception('current failure');
      exit fValue;
    end;
    property ObjectCurrent: Object read GetCurrent; implements IEnumerator.Current;
    method GetObjectEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit self;
    end;
  public
    FailCurrent, FailDispose, FailGetEnumerator, Disposed: Boolean;
    ActiveBodies: Integer;
    method GetEnumerator: IEnumerator<Integer>;
    begin
      Assert.IsTrue(Thread.CurrentThreadID = fThread);
      if FailGetEnumerator then raise new Exception('get enumerator failure');
      exit self;
    end;
    method MoveNext: Boolean;
    begin
      Assert.IsTrue(Thread.CurrentThreadID = fThread);
      inc(fValue);
      exit fValue < 129;
    end;
    property Current: Integer read GetCurrent;
    method Dispose;
    begin
      Assert.IsTrue(Thread.CurrentThreadID = fThread);
      Assert.AreEqual(0, ActiveBodies);
      Disposed := true;
      if FailDispose then raise new Exception('dispose failure');
    end;
  end;
  ParallelCleanupControl = public class
  public
    FailClear: Boolean;
  end;
  ParallelCleanupValue = public record
  public
    Control: ParallelCleanupControl;
    class operator Assign(var aDest: ParallelCleanupValue; var aSource: ParallelCleanupValue);
    begin
      if (aDest.Control <> nil) and (aSource.Control = nil) and aDest.Control.FailClear then
        raise new Exception('queue cleanup failure');
      aDest.Control := aSource.Control;
    end;
  end;
  ParallelCopyFailure = static class
  public
    class var Attempt, FailAt: Integer;
  end;
  ParallelValueLease = public class
  public
    Count: Integer;
  end;
  ParallelCopyValue = public record
  public
    Value: Integer;
    Lease: ParallelValueLease;
    constructor Copy(var aSource: ParallelCopyValue);
    begin
      Lease := aSource.Lease;
      if Lease <> nil then InternalCalls.Increment(var Lease.Count);
      var lAttempt := InternalCalls.Increment(var ParallelCopyFailure.Attempt) + 1;
      if lAttempt = ParallelCopyFailure.FailAt then raise new Exception('parallel copy failure');
      Value := aSource.Value;
    end;
    finalizer;
    begin
      if Lease <> nil then begin
        InternalCalls.Decrement(var Lease.Count);
        Lease := nil;
      end;
    end;
  end;
  // Do not cache an owned Current value in the enumerator. Generated iterator
  // objects retain that cache until GC even after Dispose, which would conflate
  // the source's own lifetime with the FIFO/body copies being checked here.
  ParallelCopySequence = class(IEnumerable<ParallelCopyValue>, IEnumerator<ParallelCopyValue>)
  private
    fValues: array of ParallelCopyValue;
    fIndex: Integer := -1;
    method GetCurrent: ParallelCopyValue;
    begin
      exit fValues[fIndex];
    end;
    property ObjectCurrent: Object read GetCurrent; implements IEnumerator.Current;
    method GetObjectEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    begin
      exit self;
    end;
  public
    constructor(aValues: array of ParallelCopyValue);
    begin
      fValues := aValues;
    end;
    method GetEnumerator: IEnumerator<ParallelCopyValue>;
    begin
      exit self;
    end;
    property Current: ParallelCopyValue read GetCurrent;
    method MoveNext: Boolean;
    begin
      inc(fIndex);
      exit fIndex < fValues.Length;
    end;
    method Dispose; empty;
  end;
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
    method ThreadBoundSequence(aThread: ThreadID): sequence of Integer; iterator;
    begin
      try
        for i := 0 to 128 do begin
          Assert.IsTrue(Thread.CurrentThreadID = aThread);
          yield i;
        end;
      finally
        Assert.IsTrue(Thread.CurrentThreadID = aThread);
        fDisposed := true;
      end;
    end;
    [DisableInlining]
    method MutateOwnedParameter(aValue: ParallelCopyValue);
    begin
      aValue.Value := 43;
    ensure
      // With assertions enabled, the contract must see the owned shadow's new
      // value, while the separately checked caller still retains its old value.
      aValue.Value = 43;
    end;

    [DisableInlining]
    method MutateTwoOwnedParameters(aFirst, aSecond: ParallelCopyValue);
    begin
      aFirst.Value := 43;
      aSecond.Value := 44;
    end;

    [DisableInlining]
    method ReadOwnedParameter(aValue: ParallelCopyValue): Integer;
    begin
      exit aValue.Value;
    end;

    [DisableInlining]
    method ReadConstOwnedParameter(const aValue: ParallelCopyValue): Integer;
    begin
      exit aValue.Value;
    end;

    [DisableInlining]
    method MutateBorrowedParameter(var aValue: ParallelCopyValue);
    begin
      aValue.Value := 45;
    end;

    method CheckOwnedParameterCopies(aDelegate: Boolean);
    begin
      // No scheduler or queue participates: this isolates native value-parameter
      // storage and a partial constructor failure from Parallel's own lifetime.
      var problems := '';
      for failAt := 0 to 4 do begin
        var values := new ParallelCopyValue[1];
        values[0].Value := 42;
        values[0].Lease := new ParallelValueLease(Count := 1);
        ParallelCopyFailure.Attempt := 0;
        ParallelCopyFailure.FailAt := failAt;
        try
          try
            if aDelegate then begin
              var body: Action<ParallelCopyValue> := value -> begin value.Value := 43; end;
              body(values[0]);
            end
            else MutateOwnedParameter(values[0]);
          except
            on e: Exception do Assert.AreEqual('parallel copy failure', e.Message);
          end;
          Assert.AreEqual(42, values[0].Value);
          if values[0].Lease.Count <> 1 then
            problems := problems + 'copy ' + failAt.ToString + ' count ' + values[0].Lease.Count.ToString + '; ';
        finally
          ParallelCopyFailure.FailAt := 0;
        end;
      end;
      if problems <> '' then raise new Exception(problems);
    end;

    method LanguageInnerLoop(aOuter: Integer; aSeen: array of Integer);
    begin
      for parallel j := 0 to 6 do inc(aSeen[aOuter * 7 + j]);
    end;
  public
    method NativeValueParameterCleansCopies;
    begin
      // Positive and injected-failure guards: a written by-value argument owns
      // its own copy, and destroys that exact storage on every exit.
      CheckOwnedParameterCopies(false);
    end;

    method DelegateValueParameterCleansCopies;
    begin
      // The same ownership contract applies to compiler-generated lambda
      // parameters. This catches cleanup aimed at an unrelated empty slot.
      CheckOwnedParameterCopies(true);
    end;

    method MultipleValueParametersCleanPartialConstruction;
    begin
      // A later parameter's failed Copy must release its partial ownership and
      // every earlier successful parameter, without changing either caller value.
      var problems := '';
      var failures := 0;
      for failAt := 0 to 8 do begin
        var values := new ParallelCopyValue[2];
        for i := 0 to 1 do begin
          values[i].Value := 42;
          values[i].Lease := new ParallelValueLease(Count := 1);
        end;
        ParallelCopyFailure.Attempt := 0;
        ParallelCopyFailure.FailAt := failAt;
        try
          try MutateTwoOwnedParameters(values[0], values[1]);
          except
            on e: Exception do begin
              Assert.AreEqual('parallel copy failure', e.Message);
              inc(failures);
            end;
          end;
          for i := 0 to 1 do begin
            Assert.AreEqual(42, values[i].Value);
            if values[i].Lease.Count <> 1 then
              problems := problems + 'copy ' + failAt.ToString + ' parameter ' + i.ToString + ' count ' + values[i].Lease.Count.ToString + '; ';
          end;
        finally
          ParallelCopyFailure.FailAt := 0;
        end;
      end;
      Assert.IsTrue(failures >= 2);
      if problems <> '' then raise new Exception(problems);
    end;

    method ReadOnlyConstAndVarParametersKeepOwnership;
    begin
      // Negative controls for the new owned shadow: reading never destroys the
      // caller value; const/var continue borrowing, and var still updates it.
      var values := new ParallelCopyValue[1];
      values[0].Value := 42;
      values[0].Lease := new ParallelValueLease(Count := 1);
      ParallelCopyFailure.FailAt := 0;
      Assert.AreEqual(42, ReadOwnedParameter(values[0]));
      Assert.AreEqual(1, values[0].Lease.Count);
      Assert.AreEqual(42, ReadConstOwnedParameter(values[0]));
      Assert.AreEqual(1, values[0].Lease.Count);
      MutateBorrowedParameter(var values[0]);
      Assert.AreEqual(45, values[0].Value);
      Assert.AreEqual(1, values[0].Lease.Count);
    end;

    method EnumeratorCurrentAndDisposeStayOnCaller;
    begin
      for mode := 0 to 3 do begin
        var source := new ParallelThreadBoundEnumerator;
        source.FailCurrent := mode = 1;
        source.FailDispose := mode = 2;
        source.FailGetEnumerator := mode = 3;
        var caught := false;
        try
          Parallel.ForEach<Integer>(source, (value, state, index) -> begin
            InternalCalls.Increment(var source.ActiveBodies);
            try
              Assert.AreEqual(value, Integer(index));
              Thread.Sleep(1);
            finally
              InternalCalls.Decrement(var source.ActiveBodies);
            end;
          end);
        except
          on e: Exception do begin
            Assert.AreEqual(if mode = 1 then 'current failure' else if mode = 2 then 'dispose failure' else 'get enumerator failure', e.Message);
            caught := true;
          end;
        end;
        Assert.AreEqual(mode <> 0, caught);
        Assert.AreEqual(mode <> 3, source.Disposed);
      end;
    end;

    method ThrowingValueCopiesPropagateAndJoin;
    begin
      // Inject at successive copy boundaries rather than depending on the
      // compiler's current copy count. Some positions are beyond the last copy
      // and must complete; every observed failure must reach the caller.
      var failures := 0;
      for failAt := 1 to 40 do begin
        var values := new ParallelCopyValue[1];
        values[0].Value := 42;
        values[0].Lease := new ParallelValueLease(Count := 1);
        ParallelCopyFailure.Attempt := 0;
        ParallelCopyFailure.FailAt := failAt;
        var count := 0;
        var active := 0;
        try
          Parallel.ForEach<ParallelCopyValue>(new ParallelCopySequence(values), (value, state, index) -> begin
            InternalCalls.Increment(var active);
            try
              Assert.AreEqual(42, value.Value);
              Assert.AreEqual(Int64(0), index);
              InternalCalls.Increment(var count);
            finally
              InternalCalls.Decrement(var active);
            end;
          end);
          Assert.AreEqual(1, count);
        except
          on e: Exception do begin
            Assert.AreEqual('parallel copy failure', e.Message);
            inc(failures);
          end;
        end;
        Assert.AreEqual(0, active);
        Assert.IsTrue(count <= 1);
        if values[0].Lease.Count <> 1 then raise new Exception('copy position ' + failAt.ToString + ', lease count ' + values[0].Lease.Count.ToString);
        ParallelCopyFailure.FailAt := 0;
      end;
      Assert.IsTrue(failures > 0);
    end;

    method BreakReleasesQueuedOwnedValues;
    begin
      // Every temporary copy owns a counted lease. After Break, only the input
      // array may still own values: discarded read-ahead must be cleared after
      // joining consumers, rather than retained by queued Task closures until GC.
      ParallelCopyFailure.FailAt := 0;
      var values := new ParallelCopyValue[129];
      for i := 0 to values.Length - 1 do begin
        values[i].Value := i;
        values[i].Lease := new ParallelValueLease(Count := 1);
      end;
      Parallel.ForEach<ParallelCopyValue>(new ParallelCopySequence(values), (value, state, index) -> begin
        Assert.AreEqual(value.Value, Integer(index));
        state.Break;
      end);
      for i := 0 to values.Length - 1 do
        if values[i].Lease.Count <> 1 then raise new Exception('break index ' + i.ToString + ', lease count ' + values[i].Lease.Count.ToString);
    end;

    method IdlePoolWakesEveryBlockingCallback;
    begin
      // Bound OS thread creation as well as task count; restore the caller's
      // pool setting even if a guard fails (Windows defaults to many workers).
      var originalLimit := ThreadPool.MaxThreads;
      ThreadPool.MaxThreads := 5;
      try
        // A reused pool must wake every worker in a burst even when callbacks
        // block. Repeating after idle time exposes coalesced auto-reset signals;
        // thread creation must not be what makes this positive guard succeed.
        var count := Integer(ThreadPool.MaxThreads);
        for pass := 0 to 1 do begin
          Thread.Sleep(20);
          var entered := 0;
          var finished := 0;
          var seen := new Integer[count];
          using releaseWorkers := new EventWaitHandle(false, false) do
            using allFinished := new EventWaitHandle(false, false) do begin
              for i := 0 to count - 1 do
                ThreadPool.QueueUserWorkItem(state -> begin
                  inc(seen[Integer(state)]);
                  InternalCalls.Increment(var entered);
                  releaseWorkers.Wait;
                  if InternalCalls.Increment(var finished) + 1 = count then allFinished.Set;
                end, i);
              var waited := 0;
              while (InternalCalls.VolatileRead(var entered) < count) and (waited < 10000) do begin
                Thread.Sleep(1); inc(waited);
              end;
              var allEntered := InternalCalls.VolatileRead(var entered) = count;
              releaseWorkers.Set;
              Assert.IsTrue(allFinished.Wait(10000));
              Assert.IsTrue(allEntered);
              for each value in seen do Assert.AreEqual(1, value);
            end;
        end;
      finally
        ThreadPool.MaxThreads := originalLimit;
      end;
    end;

    method OriginalFailureSurvivesQueueCleanupFailure;
    begin
      // Bound OS thread creation as well as task count; restore the caller's
      // pool setting even if a guard fails (Windows defaults to many workers).
      var originalLimit := ThreadPool.MaxThreads;
      ThreadPool.MaxThreads := 5;
      try
        // Occupy the pool so the caller deterministically executes the first body
        // with unread values still queued. Throwing Assign models cleanup failure;
        // an existing body error wins, while cleanup alone must still be reported.
        var entered := 0;
        var finished := 0;
        var workerCount := Integer(ThreadPool.MaxThreads);
        using releaseWorkers := new EventWaitHandle(false, false) do
          using allFinished := new EventWaitHandle(false, false) do begin
            for i := 0 to workerCount - 1 do
              ThreadPool.QueueUserWorkItem(state -> begin
                InternalCalls.Increment(var entered);
                releaseWorkers.Wait;
                if InternalCalls.Increment(var finished) + 1 = workerCount then allFinished.Set;
              end, nil);
            var waited := 0;
            while (InternalCalls.VolatileRead(var entered) < workerCount) and (waited < 10000) do begin
              Thread.Sleep(1); inc(waited);
            end;
            try
              Assert.AreEqual(workerCount, entered);
              for mode := 0 to 1 do begin
                var control := new ParallelCleanupControl;
                var values := new ParallelCleanupValue[Environment.ProcessorCount + 2];
                for i := 0 to values.Length - 1 do values[i].Control := control;
                var caught := false;
                try
                  Parallel.ForEach<ParallelCleanupValue>(values, (value, state, index) -> begin
                    control.FailClear := true;
                    if mode = 0 then raise new Exception('original body failure');
                    state.Break;
                  end);
                except
                  on e: Exception do begin
                    Assert.AreEqual(if mode = 0 then 'original body failure' else 'queue cleanup failure', e.Message);
                    caught := true;
                  end;
                end;
                control.FailClear := false;
                Assert.IsTrue(caught);
              end;
            finally
              releaseWorkers.Set;
              Assert.IsTrue(allFinished.Wait(10000));
            end;
          end;
      finally
        ThreadPool.MaxThreads := originalLimit;
      end;
    end;

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

    method BodyFailureDisposesEnumerator;
    begin
      fDisposed := false;
      fEnumerated := 0;
      var caught := false;
      try
        Parallel.ForEach<Integer>(CountedSequence,
          (value, state, index) -> begin raise new Exception('body failure'); end);
      except
        on e: Exception do begin
          Assert.AreEqual('body failure', e.Message);
          caught := true;
        end;
      end;
      Assert.IsTrue(caught);
      Assert.IsTrue(fDisposed);
      Assert.IsTrue(fEnumerated < 10000);
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
      // Each body stops immediately: at most the claimed worker items, bounded
      // pending FIFO and one producer item may have been read before Break.
      Assert.IsTrue(fEnumerated <= 2 * Environment.ProcessorCount + 1);
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

    method EnumerationStaysOnCallingThread;
    begin
      // Iterator code and its finally block may rely on caller thread-local
      // state. Only the body is allowed to move to a pool thread.
      fDisposed := false;
      var seen := new Integer[129];
      Parallel.ForEach<Integer>(ThreadBoundSequence(Thread.CurrentThreadID),
        (value, state, index) -> begin
          Assert.AreEqual(value, Integer(index));
          inc(seen[value]);
        end);
      Assert.IsTrue(fDisposed);
      for each value in seen do Assert.AreEqual(1, value);
      Parallel.ForEach<Integer>([42], (value, state, index) -> begin
        Assert.AreEqual(42, value);
        Assert.AreEqual(Int64(0), index);
      end);
    end;

    method SaturatedPoolMakesProgress;
    begin
      // Bound OS thread creation as well as task count; restore the caller's
      // pool setting even if a guard fails (Windows defaults to many workers).
      var originalLimit := ThreadPool.MaxThreads;
      ThreadPool.MaxThreads := 5;
      try
        // Every configured pool slot enters the barrier before any nested loop
        // begins; no spare worker can hide a deadlock. Run in a process with a
        // watchdog: a scheduler regression cannot safely cancel blocked workers.
        var lCount := Integer(ThreadPool.MaxThreads);
        if lCount < 1 then lCount := 1;
        var lEntered := 0;
        var lChecked := 0;
        var lDone := 0;
        var lFailed := 0;
        using lStart := new EventWaitHandle(false, false) do
          using lFinished := new EventWaitHandle(false, false) do begin
            for i := 0 to lCount - 1 do
              ThreadPool.QueueUserWorkItem(aState -> begin
                InternalCalls.Increment(var lEntered);
                lStart.Wait;
                try
                  var lSeen := 0;
                  Parallel.For(0, 3, (value, state) -> InternalCalls.Increment(var lSeen));
                  Parallel.ForEach<Integer>([1, 2, 3],
                    (value, state, index) -> InternalCalls.Increment(var lSeen));
                  // Exercise actual syntax lowering as well as the explicit API:
                  // for parallel and for each parallel must share these guarantees.
                  for parallel j := 0 to 2 do InternalCalls.Increment(var lSeen);
                  for each parallel value in [1, 2, 3] do InternalCalls.Increment(var lSeen);
                  // No consumer task can start while every pool callback is
                  // occupied here: this exception must come from the producer's
                  // own body path, and still join all deferred consumers.
                  var lCaught := false;
                  try
                    Parallel.ForEach<Integer>([1, 2, 3], (value, state, index) -> begin
                      raise new Exception('nested caller body failure');
                    end);
                  except
                    on e: Exception do begin
                      if e.Message <> 'nested caller body failure' then raise;
                      lCaught := true;
                    end;
                  end;
                  if not lCaught then InternalCalls.Increment(var lFailed);
                  var lProbe := new Parallel_Boundaries;
                  Parallel.ForEach<Integer>(lProbe.CountedSequence, (value, state, index) -> state.Break);
                  Assert.IsTrue(lProbe.fDisposed);
                  // With no available consumer, the producer reaches its first
                  // body after one FIFO plus the incoming item, then stops reading.
                  Assert.IsTrue(lProbe.fEnumerated <= Environment.ProcessorCount + 1);
                  if lSeen <> 12 then InternalCalls.Increment(var lFailed);
                except
                  on e: Exception do begin
                    writeLn('Saturated pool worker failed: ' + e.Message);
                    InternalCalls.Increment(var lFailed);
                  end;
                end;
                // Keep every pool slot occupied until all nested checks finish.
                // Otherwise a faster callback frees a consumer for a slower one,
                // invalidating the caller-only enumeration bound above.
                InternalCalls.Increment(var lChecked);
                while InternalCalls.VolatileRead(var lChecked) < lCount do
                  Thread.Sleep(1);
                // Notify the owner only after all callbacks leave that barrier;
                // it can then dispose the events without an active waiter.
                if InternalCalls.Increment(var lDone) + 1 = lCount then lFinished.Set;
              end, nil);
            var lWaited := 0;
            while (InternalCalls.VolatileRead(var lEntered) < lCount) and (lWaited < 10000) do begin
              Thread.Sleep(1);
              inc(lWaited);
            end;
            var lAllEntered := InternalCalls.VolatileRead(var lEntered) = lCount;
            lStart.Set;
            Assert.IsTrue(lFinished.Wait(10000));
            Assert.IsTrue(lAllEntered);
            Assert.AreEqual(0, lFailed);
          end;
      finally
        ThreadPool.MaxThreads := originalLimit;
      end;
    end;

    method LanguageParallelLoopsCompleteAndPreserveValues;
    begin
      // Test compiler syntax, including the inclusive integer-loop bound and
      // indexed enumeration, rather than assuming it lowers like direct calls.
      var seen := new Integer[35];
      for parallel i := 0 to 4 do LanguageInnerLoop(i, seen);
      for each value in seen do Assert.AreEqual(1, value);
      var values := new OleString[17];
      for i := 0 to values.Length - 1 do values[i] := new OleString(i.ToString);
      var paired := new Integer[values.Length];
      for each parallel value in values index i do begin
        if i = 0 then BoehmGC.Collect(2);
        Assert.AreEqual(i.ToString, value.ToString);
        inc(paired[i]);
      end;
      for each value in paired do Assert.AreEqual(1, value);
      fDisposed := false;
      for each parallel value in ThreadBoundSequence(Thread.CurrentThreadID) index i do
        Assert.AreEqual(value, Integer(i));
      Assert.IsTrue(fDisposed);
    end;

    method LanguageParallelFailuresAndBreak;
    begin
      var active := 0;
      var caught := false;
      try
        for parallel i := 0 to 31 do begin
          InternalCalls.Increment(var active);
          try
            if i = 1 then raise new Exception('language for failure');
            Thread.Sleep(1);
          finally
            InternalCalls.Decrement(var active);
          end;
        end;
      except
        on e: Exception do begin
          Assert.AreEqual('language for failure', e.Message);
          caught := true;
        end;
      end;
      Assert.IsTrue(caught);
      Assert.AreEqual(0, active);
      caught := false;
      fDisposed := false;
      try
        for each parallel value in CountedSequence do
          raise new Exception('language foreach failure');
      except
        on e: Exception do begin
          Assert.AreEqual('language foreach failure', e.Message);
          caught := true;
        end;
      end;
      Assert.IsTrue(caught);
      Assert.IsTrue(fDisposed);
      var count := 0;
      for parallel i := 0 to 9999 do begin
        InternalCalls.Increment(var count);
        break;
      end;
      Assert.IsTrue((count > 0) and (count < 10000));
      fDisposed := false;
      fEnumerated := 0;
      for each parallel value in CountedSequence do break;
      Assert.IsTrue(fDisposed);
      Assert.IsTrue((fEnumerated > 0) and (fEnumerated < 10000));
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
