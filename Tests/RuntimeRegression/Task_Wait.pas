// Negative regression guards: completed and failed tasks are finished waits,
// timeouts must detach safely, and completion must not signal a disposed event.
// Exercise both wait overloads, repeated polls and several concurrent waiters.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
{$IFNDEF NOTHREADS}
type
  Task_Wait = public class(Test)
  public
    method CompletedTasksReturnTrue;
    begin
      Assert.IsTrue(Task.CompletedTask.Wait(0));
      Assert.IsTrue(Task.FromResult<Integer>(42).Wait(1));
      Task.CompletedTask.Wait;
      var source := new TaskCompletionSource<Integer>;
      source.SetResult(17);
      Assert.IsTrue(source.Task.Wait(0));
      Assert.AreEqual(17, source.Task.Result);
    end;

    method FailedTasksAreFinished;
    begin
      var source := new TaskCompletionSource<Integer>;
      var error := new Exception('expected');
      source.SetException(error);
      Assert.IsTrue(source.Task.Wait(0));
      source.Task.Wait;
      Assert.IsTrue(source.Task.IsFaulted);
      Assert.IsTrue(source.Task.Exception = error);
    end;

    method RepeatedTimeoutsThenCompletion;
    begin
      var source := new TaskCompletionSource<Integer>;
      for i := 0 to 1023 do Assert.IsFalse(source.Task.Wait(0));
      for i := 0 to 31 do Assert.IsFalse(source.Task.Wait(1));
      source.SetResult(27);
      Assert.IsTrue(source.Task.Wait(0));
      Assert.AreEqual(27, source.Task.Result);
    end;

    method TimeoutRacesWithCompletion;
    begin
      for i := 0 to 127 do begin
        var source := new TaskCompletionSource<Integer>;
        var worker := Task.Run(-> source.SetResult(31));
        source.Task.Wait(1);
        Assert.IsTrue(worker.Wait(5000));
        Assert.IsTrue(source.Task.Wait(1000));
        Assert.AreEqual(31, source.Task.Result);
      end;
    end;

    method SeveralWaitersSeeOneCompletion;
    begin
      var source := new TaskCompletionSource<Integer>;
      var waiters := new Task<Boolean>[4];
      for i := 0 to waiters.Length - 1 do
        waiters[i] := Task.Run<Boolean>(-> source.Task.Wait(5000));
      source.SetResult(9);
      for i := 0 to waiters.Length - 1 do begin
        Assert.IsTrue(waiters[i].Wait(5000));
        Assert.IsTrue(waiters[i].Result);
      end;
    end;

    method UntimedWaitAndSynchronousTask;
    begin
      var source := new TaskCompletionSource<Integer>;
      var worker := Task.Run(-> begin Thread.Sleep(5); source.SetResult(8); end);
      source.Task.Wait;
      Assert.IsTrue(worker.Wait(5000));
      Assert.AreEqual(8, source.Task.Result);
      var synchronous := Task.RunSynchronous<Integer>(-> 73);
      Assert.IsTrue(synchronous.Wait(0));
      Assert.AreEqual(73, synchronous.Result);
    end;
  end;
{$ENDIF}
end.
