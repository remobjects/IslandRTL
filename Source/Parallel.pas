namespace RemObjects.Elements.System;
{$IFNDEF NOTHREADS}
type
  ParallelLoopState = public class
  private
    fStopped: Integer;
  public
    property IsStopped: Boolean read InternalCalls.VolatileRead(var fStopped) <> 0;
    method &Break;
    begin
      InternalCalls.VolatileWrite(var fStopped, 1);
    end;
  end;

  &Parallel = static public class
  private
    class method RunWorkers(aWork: Action; aState: ParallelLoopState; aLimit: Integer := Int32.MaxValue;
      aProduce: Action := nil; aFinishProduction: Action := nil);
    begin
      // A worker failure must not release shared loop state while other workers
      // still use it. Queue synchronous tasks, then join every task in finally;
      // Wait claims queued work inline so nested loops cannot exhaust the pool.
      // ForEach supplies a caller-thread producer. Its completion notification
      // must precede every join, including a failure while queueing workers,
      // so consumers never wait for a producer that has already unwound.
      var lCount := Environment.ProcessorCount;
      if lCount < 1 then lCount := 1;
      if lCount > aLimit then lCount := aLimit;
      var lTasks := new Task[lCount];
      try
        try
          for i := 0 to lCount - 1 do begin
            lTasks[i] := Task.RunSynchronous(-> begin
              try
                aWork();
              except
                on e: Exception do begin
                  aState.Break;
                  raise;
                end;
              end;
            end);
            ThreadPool.QueueUserWorkItem(aTask -> Task(aTask).Wait, lTasks[i]);
          end;
          if assigned(aProduce) then aProduce();
        except
          on e: Exception do begin
            aState.Break;
            raise;
          end;
        end;
      finally
        try
          if assigned(aFinishProduction) then aFinishProduction();
        finally
          // Wait runs unclaimed synchronous tasks on this thread. Nested loops
          // can therefore make progress even when all pool threads are busy.
          // Join every worker before returning or releasing shared state.
          for each lTask in lTasks do lTask:Wait;
        end;
      end;
      for each lTask in lTasks do
        if lTask.IsFaulted then raise lTask.Exception;
    end;

  public
    class method &For(fromInclusive: Integer; toExclusive: Integer; body: Action<Integer,ParallelLoopState>);
    begin
      if fromInclusive >= toExclusive then exit;
      &For(Int64(fromInclusive), Int64(toExclusive), (i, state) -> body(Integer(i), state));
    end;

    class method &For(fromInclusive: Int64; toExclusive: Int64; body: Action<Int64,ParallelLoopState>);
    begin
      if fromInclusive >= toExclusive then exit;
      var lState := new ParallelLoopState;
      var lNext := fromInclusive;
      var lLimit := Int32.MaxValue;
      // Same-sign endpoints can be subtracted without signed overflow.
      if (fromInclusive >= 0) or (toExclusive < 0) then
        if toExclusive - fromInclusive < lLimit then
          lLimit := Integer(toExclusive - fromInclusive);
      using lLock := new Monitor do
        RunWorkers(-> begin
          loop begin
            var lValue: Int64;
            locking lLock do begin
              if lState.IsStopped or (lNext >= toExclusive) then exit;
              lValue := lNext;
              inc(lNext);
            end;
            body(lValue, lState);
          end;
        end, lState, lLimit);
    end;

    class method ForEach<TSource>(source: IEnumerable<TSource>; body: Action<TSource,ParallelLoopState, Int64>);
    begin
      // Iterators can depend on caller thread-local state, while one Task per
      // element makes cheap bodies expensive. Keep enumeration on the caller
      // and share a bounded FIFO with a fixed set of consumers. When the FIFO
      // fills, the caller executes its oldest item instead of waiting for pool
      // capacity; this also makes nested loops progress with a saturated pool.
      var lState := new ParallelLoopState;
      // Keep at most one pending value per potential worker. Break can leave
      // these values plus in-flight bodies; it does not define an exact source
      // cutoff, but enumeration must never run arbitrarily far ahead.
      var lCapacity := Environment.ProcessorCount;
      if lCapacity < 1 then lCapacity := 1;
      // Reserve the transient incoming slot too: no growth copies may outlive
      // this loop in old buffers waiting for GC after the live FIFO is cleared.
      var lValues := new Queue<TSource>(lCapacity + 1);
      var lNextIndex: Int64 := 0;
      var lProductionFinished := false;
      using lLock := new Monitor do
        using lReady := new ConditionalVariable do
          using lEnumerator := source.GetEnumerator do begin
            var lFailed := false;
            try
              try
                RunWorkers(-> begin
                  loop begin
                    var lValue: TSource;
                    var lIndex: Int64;
                    locking lLock do begin
                      while (lValues.Count = 0) and not lProductionFinished and not lState.IsStopped do
                        lReady.Wait(lLock);
                      if lState.IsStopped or (lValues.Count = 0) then exit;
                      lValue := lValues.Dequeue;
                      lIndex := lNextIndex;
                      inc(lNextIndex);
                    end;
                    body(lValue, lState, lIndex);
                  end;
                end, lState, lCapacity - 1, -> begin
                  while not lState.IsStopped and lEnumerator.MoveNext do begin
                    var lIncoming := lEnumerator.Current;
                    var lValue: TSource;
                    var lIndex: Int64;
                    var lRunOnCaller := false;
                    locking lLock do begin
                      if lState.IsStopped then exit;
                      // Publish the incoming value before claiming an old one: a
                      // throwing copy must not silently discard a claimed body.
                      // At most one extra value is retained while holding the lock.
                      lValues.Enqueue(lIncoming);
                      if lValues.Count > lCapacity then begin
                        lValue := lValues.Dequeue;
                        lIndex := lNextIndex;
                        inc(lNextIndex);
                        lRunOnCaller := true;
                      end;
                      lReady.Signal;
                    end;
                    if lRunOnCaller then body(lValue, lState, lIndex);
                  end;
                  // Drain without waiting. With one CPU (or no free pool slots)
                  // the caller is the only available consumer.
                  loop begin
                    var lValue: TSource;
                    var lIndex: Int64;
                    locking lLock do begin
                      if lState.IsStopped or (lValues.Count = 0) then exit;
                      lValue := lValues.Dequeue;
                      lIndex := lNextIndex;
                      inc(lNextIndex);
                    end;
                    body(lValue, lState, lIndex);
                  end;
                end, -> begin
                  locking lLock do begin
                    lProductionFinished := true;
                    lReady.Broadcast;
                  end;
                end);
              except
                on e: Exception do begin
                  lFailed := true;
                  raise;
                end;
              end;
            finally
              // Workers are joined before releasing values skipped by Break or
              // failure. Queued Task callbacks may retain the empty FIFO longer.
              // A user cleanup hook can throw: preserve an existing body or
              // iterator failure, but report cleanup failure on normal exit.
              if lFailed then begin
                try lValues.Clear; except on e: Exception do begin end; end;
              end
              else lValues.Clear;
            end;
          end;
    end;
  end;
{$ENDIF}
end.