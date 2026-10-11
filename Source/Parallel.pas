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
    class method RunWorkers(aWork: Action; aState: ParallelLoopState; aLimit: Integer := Int32.MaxValue);
    begin
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
        except
          on e: Exception do begin
            aState.Break;
            raise;
          end;
        end;
      finally
        // Wait runs unclaimed synchronous tasks on this thread. Nested loops
        // can therefore make progress even when all pool threads are busy.
        // Join every worker before returning or releasing shared state.
        for each lTask in lTasks do lTask:Wait;
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
      var lState := new ParallelLoopState;
      var lIndex: Int64 := 0;
      var lFinished := false;
      using lEnumerator := source.GetEnumerator do
        using lLock := new Monitor do
          RunWorkers(-> begin
            loop begin
              var lValue: TSource;
              var lValueIndex: Int64;
              locking lLock do begin
                if lState.IsStopped or lFinished then exit;
                try
                  if not lEnumerator.MoveNext then begin
                    lFinished := true;
                    exit;
                  end;
                  lValue := lEnumerator.Current;
                  lValueIndex := lIndex;
                  inc(lIndex);
                except
                  on e: Exception do begin
                    // Stop before another worker can touch a failed iterator.
                    lState.Break;
                    raise;
                  end;
                end;
              end;
              body(lValue, lState, lValueIndex);
            end;
          end, lState);
    end;
  end;
{$ENDIF}
end.