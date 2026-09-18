// Positive guard: an initially signaled manual event returns immediately from both wait overloads.
// Positive guard: auto-reset consumes exactly one stored signal, including zero-timeout polls.
// Positive guard: manual-reset preserves a signal until Reset is called.
// Negative regression guard: an unsignaled timed wait must return false instead of blocking indefinitely.
// Positive guard: a delayed signal succeeds within a multi-second timed wait, including its fractional second.
// Positive guard: an untimed wait wakes when another thread signals it.
// Positive guard: the -1 timeout retains infinite-wait behavior.
namespace RemObjects.Elements.Island.Tests;

uses
  RemObjects.Elements.EUnit;

type
  EventWaitHandleTests = public class(Test)
  public

    method InitiallySignaledManualEventReturns;
    begin
      using lEvent := new EventWaitHandle(false, true) do begin
        Assert.IsTrue(lEvent.Wait(1));
        lEvent.Wait;
        Assert.IsTrue(lEvent.Wait(0));
      end;
    end;

    method AutoResetConsumesStoredSignal;
    begin
      using lEvent := new EventWaitHandle(true, true) do begin
        Assert.IsTrue(lEvent.Wait(0));
        Assert.IsFalse(lEvent.Wait(0));
        lEvent.Set;
        lEvent.Wait;
        Assert.IsFalse(lEvent.Wait(0));
      end;
    end;

    method ManualResetPreservesSignal;
    begin
      using lEvent := new EventWaitHandle(false, false) do begin
        lEvent.Set;
        Assert.IsTrue(lEvent.Wait(0));
        Assert.IsTrue(lEvent.Wait(0));
        lEvent.Reset;
        Assert.IsFalse(lEvent.Wait(0));
      end;
    end;

    method UnsignaledWaitExpires;
    begin
      using lEvent := new EventWaitHandle(true, false) do
        Assert.IsFalse(lEvent.Wait(20));
    end;

    method DelayedSignalReleasesTimedWait;
    begin
      using lEvent := new EventWaitHandle(true, false) do begin
        var lThread := new Thread(aData -> begin
          Thread.Sleep(1100);
          lEvent.Set;
        end);
        lThread.Start;
        Assert.IsTrue(lEvent.Wait(1500));
      end;
    end;

    method DelayedSignalReleasesUntimedWait;
    begin
      using lEvent := new EventWaitHandle(true, false) do begin
        var lThread := new Thread(aData -> begin
          Thread.Sleep(20);
          lEvent.Set;
        end);
        lThread.Start;
        lEvent.Wait;
        Assert.IsFalse(lEvent.Wait(0));
      end;
    end;

    method InfiniteTimeoutAcceptsSignal;
    begin
      using lEvent := new EventWaitHandle(true, false) do begin
        var lThread := new Thread(aData -> begin
          Thread.Sleep(20);
          lEvent.Set;
        end);
        lThread.Start;
        Assert.IsTrue(lEvent.Wait(-1));
      end;
    end;

  end;

end.
