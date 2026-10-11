// Regression guards: timeouts use milliseconds, -1 waits for a signal, and
// signaling/broadcasting preserves the lock and shared-state handoff.
// Wait for every worker to release the lock before assertions and disposal.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
{$IFNDEF NOTHREADS}
type
  Thread_Condition = public class(Test)
  public
    method MillisecondTimeouts;
    begin
      using guard := new Monitor do
        using condition := new ConditionalVariable do
          locking guard do begin
            Assert.IsFalse(condition.Wait(guard, 0));
            for each delay in [200, 900, 1250] do begin
              var watch := new StopWatch;
              watch.Start;
              loop begin
                var remaining := delay - Integer(watch.ElapsedMilliseconds);
                if remaining <= 0 then break;
                if not condition.Wait(guard, remaining) then break;
                // POSIX permits spurious wakeups; keep waiting for the deadline.
              end;
              watch.Stop;
              Assert.IsTrue(watch.ElapsedMilliseconds >= delay - 30);
            end;
          end;
    end;

    method InfiniteTimeoutWaitsForSignal;
    begin
      using guard := new Monitor do
        using condition := new ConditionalVariable do begin
          var done := false;
          var observed := false;
          var signaled := false;
          var worker: Task;
          locking guard do begin
            worker := Task.Run(-> begin
              Thread.Sleep(5);
              locking guard do begin
                done := true;
                condition.Signal;
              end;
            end);
            repeat
              signaled := condition.Wait(guard, -1);
            until done or not signaled;
            observed := done;
          end;
          worker.Wait;
          Assert.IsTrue(signaled);
          Assert.IsTrue(observed);
          Assert.IsFalse(worker.IsFaulted);
        end;
    end;

    method BroadcastWakesAllWaiters;
    begin
      using guard := new Monitor do
        using condition := new ConditionalVariable do begin
          var ready := 0;
          var done := false;
          var finished := 0;
          var woke := 0;
          var workers := new Thread[3];
          // Blocking pool jobs can occupy every worker before the third starts.
          for i := 0 to workers.Length - 1 do begin
            workers[i] := new Thread(aData -> begin
              locking guard do begin
                inc(ready);
                while not done do
                  if not condition.Wait(guard, 5000) and not done then break;
                if done then inc(woke);
                inc(finished);
              end;
            end);
            workers[i].Start;
          end;
          var watch := new StopWatch;
          watch.Start;
          var allReady := false;
          repeat
            locking guard do allReady := ready = workers.Length;
            if not allReady then Thread.Sleep(1);
          until allReady or (watch.ElapsedMilliseconds >= 3000);
          locking guard do begin
            done := true;
            condition.Broadcast;
          end;
          loop begin
            var allFinished := false;
            locking guard do allFinished := finished = workers.Length;
            if allFinished then break;
            Thread.Sleep(1);
          end;
          Assert.IsTrue(allReady);
          Assert.AreEqual(workers.Length, woke);
        end;
    end;

    method InvalidTimeoutIsRejected;
    begin
      using guard := new Monitor do
        using condition := new ConditionalVariable do
          locking guard do begin
            var rejected := false;
            try
              condition.Wait(guard, -2);
            except
              on e: ArgumentOutOfRangeException do rejected := true;
            end;
            Assert.IsTrue(rejected);
          end;
    end;

    method RepeatedDispose;
    begin
      var condition := new ConditionalVariable;
      condition.Dispose;
      condition.Dispose;
    end;
  end;
{$ENDIF}
end.
