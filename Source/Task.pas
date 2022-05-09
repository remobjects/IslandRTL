namespace RemObjects.Elements.System;

interface

type
  TaskState = public enum(&New, AwaitingStart, Started, Completed, Failed);
  TaskAction =  abstract class
  public
    method Run(aTask: Task); abstract;
  end;
  IReturningTask = public interface
    method GetValue: Object;
  end;


  TaskAction_Action = class(TaskAction)
  public
    property Action: Action; readonly;
     constructor(aAct: Action);
     begin
       Action := aAct;
     end;
     method Run(aTask: Task); override;
     begin
       Action();
    end;
  end;

  TaskAction_ActionObject = class(TaskAction)
  public
    property Action: Action<Object>; readonly;
    property Object: Object; readonly;
    constructor(aAct: Action<Object>; aObj: Object);
    begin
      Action := aAct;
      Object := aObj;
    end;
    method Run(aTask: Task); override;
    begin
      Action(Object);
    end;
  end;

  TaskAction_ActionTaskObject = class(TaskAction)
  public
    property Action: Action<Task, Object>; readonly;
    property Object: Object; readonly;
    property Prev: Task; readonly;
    constructor(aPrev: Task; aAct: Action<Task, Object>; aObj: Object);
    begin
      Prev := aPrev;
      Action := aAct;
      Object := aObj;
    end;
    method Run(aTask: Task); override;
    begin
      Action(Prev, Object);
    end;
  end;

  TaskAction_ActionTask = class(TaskAction)
  public
    property Action: Action<Task>; readonly;
    property Prev: Task; readonly;
    constructor(aPrev: Task; aAct: Action<Task>);
    begin
      Prev := aPrev;
      Action := aAct;
    end;
    method Run(aTask: Task); override;
    begin
      Action(Prev);
    end;
  end;

  TaskAction_ActionTaskObject<T> = class(TaskAction)
  public
    property Action: Func<Task, Object, T>; readonly;
    property Object: Object; readonly;
    property Prev: Task; readonly;
    constructor(aPrev: Task; aAct: Func<Task, Object, T>; aObj: Object);
    begin
      Prev := aPrev;
      Action := aAct;
      Object := aObj;
    end;
    method Run(aTask: Task); override;
    begin
      Task<T>(aTask).fResult := Action(Prev, Object);
    end;
  end;

  TaskAction_ActionTask<T> = class(TaskAction)
  public
    property Action: Func<Task, T>; readonly;
    property Prev: Task; readonly;
    constructor(aPrev: Task; aAct: Func<Task, T>);
    begin
      Prev := aPrev;
      Action := aAct;
    end;
    method Run(aTask: Task); override;
    begin
      Task<T>(aTask).fResult := Action(Prev);
    end;
  end;

  TaskCompletion = abstract class
  public
    method Complete(aOwner: Task); abstract;
    Next: TaskCompletion;
  end;

  TaskCompletionTask = class(TaskCompletion)
  public
     Action: Task;
     method Complete(aOwner: Task); override;
     begin
       Action.DoEnqueue;
     end;
  end;
{$IFNDEF NOTHREADS}
  TaskCompletionWaiter = class(TaskCompletion)
  public
     Monitor: EventWaitHandle;
     method Complete(aOwner: Task); override;
     begin
       Monitor:&Set;
     end;
  end;
{$ENDIF}

  TaskCompletionAwait = class(TaskCompletion)
  public
    &Await: IAwaitCompletion;
    SyncContext: SynchronizationContext;
    method Complete(aOwner: Task); override;
    begin
      if SyncContext <> nil then
        SyncContext.Invoke( -> &Await.moveNext(aOwner))
      else
        &Await.moveNext(aOwner);
    end;
  end;

   // TODO: some form of list of completions, anything waiting can create a lock, add itself to the list
  Task = public class
  assembly
    fState: TaskState;
    fLock: Integer;
    fCompletionList: TaskCompletion;
    fAction: TaskAction;
    fException: Exception;

    method get_Exception:  Exception;
    begin
      Wait;
      exit fException;
    end;

    method cb(aObj:  Object);
    begin
      DoRun;
    end;

    method DoEnqueue; virtual;
    begin
      ThreadPool.QueueUserWorkItem(@cb, nil);
    end;

    method DoRun; virtual;
    begin
      try
        fAction.Run(self);
      except
        on e: Exception do begin
          fException := e;
          Utilities.SpinLockEnter(var fLock);
          fState := TaskState.Failed;
          var lCompl := fCompletionList;
          fCompletionList := nil;
          Utilities.SpinLockExit(var fLock);
          while lCompl <> nil do begin
            lCompl.Complete(self);
            lCompl := lCompl.Next;
          end;
          exit;
        end;
      end;
      Utilities.SpinLockEnter(var fLock);
      fState := TaskState.Completed;
      var lCompl := fCompletionList;
      fCompletionList := nil;
      Utilities.SpinLockExit(var fLock);
      while lCompl <> nil do begin
        lCompl.Complete(self);
        lCompl := lCompl.Next;
      end;
    end;
    constructor();empty;
  public
    constructor(aIn: Action);
    begin
      fState := TaskState.New;
      fAction := new TaskAction_Action(aIn);
    end;

    constructor(aIn: Action<Object>; aState: Object);
    begin
      fState := TaskState.New;
      fAction := new TaskAction_ActionObject(aIn, aState);
    end;

    method ContinueWith(aAction: Action<Task>): Task;
    begin
      result := new Task(fState := TaskState.AwaitingStart, fAction := new TaskAction_ActionTask(self, aAction));
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        result.DoEnqueue;
        exit;
      end;

      var lCompl := new TaskCompletionTask(Action := Result);
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        result.DoEnqueue;
        exit;
      end;
      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);
    end;

    method ContinueWith(aAction: Action<Task,Object>; aState: Object): Task;
    begin
      result := new Task(fState := TaskState.AwaitingStart, fAction := new TaskAction_ActionTaskObject(self, aAction, aState));
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        result.DoEnqueue;
        exit;
      end;

      var lCompl := new TaskCompletionTask(Action := Result);
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        result.DoEnqueue;
        exit;
      end;
      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);
    end;


    method ContinueWith<T>(aAction: Func<Task, T>): Task<T>;
    begin
      result := new Task<T>(fState := TaskState.AwaitingStart, fAction := new TaskAction_ActionTask<T>(self, aAction));
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        result.DoEnqueue;
        exit;
      end;

      var lCompl := new TaskCompletionTask(Action := Result);
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        result.DoEnqueue;
        exit;
      end;
      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);
    end;

    method ContinueWith<T>(aAction: Func<Task, Object, T>; aState: Object): Task<T>;
    begin
      result := new Task<T>(fState := TaskState.AwaitingStart, fAction := new TaskAction_ActionTaskObject<T>(self, aAction, aState));
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        result.DoEnqueue;
        exit;
      end;

      var lCompl := new TaskCompletionTask(Action := Result);
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        result.DoEnqueue;
        exit;
      end;
      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);
    end;

    class method Run(aIn: Action): Task;
    begin
      result := new Task(aIn);
      result.Start;
    end;

    class method Run(aIn: Action<Object>; aValue: Object): Task;
    begin
      result := new Task(aIn, aValue);
      result.Start;
    end;

    class method Run<T>(aIn: Func<Object, T>; aValue: Object): Task<T>;
    begin
      result := new Task<T>(aIn, aValue);
      result.Start;
    end;


    class method Run<T>(aIn: Func<T>): Task<T>;
    begin
      result := new Task<T>(aIn);
      result.Start;
    end;



    class method RunSynchronous(aIn: Action): Task;
    begin
      result := new SynchronousTask(aIn);
      result.fState := TaskState.AwaitingStart;
    end;

    class method RunSynchronous(aIn: Action<Object>; aValue: Object): Task;
    begin
      result := new SynchronousTask(aIn, aValue);
      result.fState := TaskState.AwaitingStart;
    end;

    class method RunSynchronous<T>(aIn: Func<Object, T>; aValue: Object): Task<T>;
    begin
      result := new SynchronousTask<T>(aIn, aValue);
      result.fState := TaskState.AwaitingStart;
    end;


    class method RunSynchronous<T>(aIn: Func<T>): Task<T>;
    begin
      result := new SynchronousTask<T>(aIn);
      result.fState := TaskState.AwaitingStart;
    end;

    property Exception: Exception read get_Exception;
    property IsFaulted: Boolean read fState = TaskState.Failed;
    property IsCompleted: Boolean read fState = TaskState.Completed;
    property IsStarted: Boolean read fState = TaskState.Started;
    property State: TaskState read fState;


    method ConfigureAwait(aCaptureContext: Boolean): ConfiguredAwaitTask;
    begin
      exit new ConfiguredAwaitTask(self, aCaptureContext);
    end;

    method &Await(aCompletion: IAwaitCompletion): Boolean;
    begin
      exit IntAwait(aCompletion, true);
    end;

    method IntAwait(aCompletion: IAwaitCompletion; aCaptureSync: Boolean := true): Boolean; assembly;
    begin
      if fState in [TaskState.Failed, TaskState.Completed] then exit false;

      var lCompl := new TaskCompletionAwait(&Await := aCompletion);
      if aCaptureSync then
        lCompl.SyncContext := SynchronizationContext.Current;
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        exit false;
      end;


      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);

      exit true;
    end;

    method Wait; virtual;
    begin
      if fState in [TaskState.Failed, TaskState.Completed] then exit;
      {$IFDEF WEBASSEMBLY}
      raise new NotSupportedException("WebAssembly cannot do blocking waits");
      {$ELSE}
      var lCompl := new TaskCompletionWaiter(Monitor := new EventWaitHandle(true, false));
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        exit;
      end;
      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);

      lCompl.Monitor.Wait;
      var lMonitor := lCompl.Monitor;
      lCompl.Monitor := nil;

      lMonitor.Dispose;
      {$ENDIF}
    end;

    method Wait(aTimeoutMSec: Integer): Boolean; virtual;
    begin
      if fState in [TaskState.Failed, TaskState.Completed] then exit;
      {$IFDEF WEBASSEMBLY}
      raise new NotSupportedException("WebAssembly cannot do blocking waits");
      {$ELSE}
      var lCompl := new TaskCompletionWaiter(Monitor := new EventWaitHandle(true, false));
      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        exit;
      end;
      lCompl.Next := fCompletionList;
      fCompletionList := lCompl;
      Utilities.SpinLockExit(var fLock);

      lCompl.Monitor.Wait(aTimeoutMSec);
      var lMonitor := lCompl.Monitor;
      lCompl.Monitor := nil;
      result := fState in [TaskState.Failed, TaskState.Completed];
      if not result then Thread.Yield;
      lMonitor.Dispose;
      {$ENDIF}
    end;

    method Start();
    begin
      Utilities.SpinLockEnter(var fLock);
      var lState := fState;
      if lState = TaskState.New then fState := TaskState.Started;
      Utilities.SpinLockExit(var fLock);
      if lState <> TaskState.New then
        raise new InvalidStateException('Can only start tasks in "New" state');

      DoEnqueue;
    end;
  end;

  TaskAction_Action<T> = class(TaskAction)
  public
    property Action: Func<T>; readonly;
    constructor(aAct: Func<T>);
    begin
      Action := aAct;
    end;
    method Run(aTask: Task); override;
    begin
      Task<T>(aTask).fResult := Action();
    end;
  end;

  TaskAction_ActionObject<T> = class(TaskAction)
  public
    property Action: Func<Object, T>; readonly;
    property Object: Object; readonly;
    constructor(aAct: Func<Object, T>; aObj: Object);
    begin
      Action := aAct;
      Object := aObj;
    end;
    method Run(aTask: Task); override;
    begin
      Task<T>(aTask).fResult :=Action(Object);
    end;
  end;

  SynchronousTask = class(Task)
  public
    method DoEnqueue; override;
    begin
      // do nothing
    end;

    method Wait(aTimeoutMSec: Integer): Boolean; override;
    begin
      Wait;
      exit true;
    end;

    method Wait; override;
    begin
      if fState in [TaskState.Failed, TaskState.Completed] then exit;

      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        exit;
      end;
      if fState = TaskState.AwaitingStart then begin
        fState := TaskState.Started;
        Utilities.SpinLockExit(var fLock);
        DoRun;
        exit;
      end;
      Utilities.SpinLockExit(var fLock);
      inherited Wait;
    end;
  end;



  SynchronousTask<T> = class(Task<T>)
  public
    method DoEnqueue; override;
    begin
      // do nothing
    end;

    method Wait(aTimeoutMSec: Integer): Boolean; override;
    begin
      Wait;
      exit true;
    end;

    method Wait; override;
    begin
      if fState in [TaskState.Failed, TaskState.Completed] then exit;

      Utilities.SpinLockEnter(var fLock);
      if fState in [TaskState.Failed, TaskState.Completed] then begin
        Utilities.SpinLockExit(var fLock);
        exit;
      end;
      if fState = TaskState.AwaitingStart then begin
        fState := TaskState.Started;
        Utilities.SpinLockExit(var fLock);
        DoRun;
        exit;
      end;
      Utilities.SpinLockExit(var fLock);
      inherited Wait;
    end;
  end;

  Task<T> = public class(Task, IReturningTask)
  assembly
    fResult: T;

    method get_Result:  T;
    begin
      Wait;
      if State = TaskState.Failed then raise Exception;
      exit fResult;
    end;

    constructor;
    begin
    end;

    method GetValue: Object;
    begin
      exit &Result;
    end;

  public

    constructor(aIn: Func<T>);
    begin
      fState := TaskState.New;
      fAction := new TaskAction_Action<T>(aIn);
    end;

    constructor(aIn: Func<Object, T>; aState: Object := nil);
    begin
      fState := TaskState.New;
      fAction := new TaskAction_ActionObject<T>(aIn, aState);
    end;

    method ConfigureAwait(aCaptureContext: Boolean): ConfiguredAwaitTask<T>; reintroduce;
    begin
      exit new ConfiguredAwaitTask<T>(self, aCaptureContext);
    end;

    property &Result: T read get_Result;
  end;


  TaskCompletionSourceTask<T> = class(Task<T>)
  assembly
    method DoRun; override; empty;
  end;

  IAwaitCompletion = public interface
    method moveNext(aState: Object);
  end;

  TaskCompletionSource<T> = public class
  private
    fTask: Task<T>;
  public

    constructor(aState: Object := nil);
    begin
      fTask := new TaskCompletionSourceTask<T>();
      fTask.fState := TaskState.AwaitingStart;
    end;

    method SetException(ex: Exception);
    begin
      Utilities.SpinLockEnter(var fTask.fLock);
      if fTask.fState <> TaskState.AwaitingStart then begin
        Utilities.SpinLockExit(var fTask.fLock);
        raise new InvalidStateException('Cannot set result for already set task completion');
      end;
      fTask.fException := ex;
      fTask.fState := TaskState.Failed;
      var lCompl := fTask.fCompletionList;
      fTask.fCompletionList := nil;
      Utilities.SpinLockExit(var fTask.fLock);
      while lCompl <> nil do begin
        lCompl.Complete(fTask);
        lCompl := lCompl.Next;
      end;
    end;

    method SetResult(val: T);
    begin
      Utilities.SpinLockEnter(var fTask.fLock);
      if fTask.fState <> TaskState.AwaitingStart then begin
        Utilities.SpinLockExit(var fTask.fLock);
        raise new InvalidStateException('Cannot set result for already set task completion');
      end;
      fTask.fResult := val;
      fTask.fState := TaskState.Completed;
      var lCompl := fTask.fCompletionList;
      fTask.fCompletionList := nil;
      Utilities.SpinLockExit(var fTask.fLock);
      while lCompl <> nil do begin
        lCompl.Complete(fTask);
        lCompl := lCompl.Next;
      end;
    end;

    property Task: Task<T> read fTask;
  end;

  ConfiguredAwaitTask = public class
  private
    fTask: Task;
    fCaptureContext: Boolean;
  public
    constructor(aTask: Task; aCaptureContext: Boolean);
    begin
      fTask := aTask;
      fCaptureContext := aCaptureContext;
    end;

    method &Await(aCompletion: IAwaitCompletion): Boolean;
    begin
      exit fTask.IntAwait(aCompletion, fCaptureContext);
    end;
  end;

  ConfiguredAwaitTask<T> = public class
  private
    fTask: Task<T>;
    fCaptureContext: Boolean;
  public
    constructor(aTask: Task<T>; aCaptureContext: Boolean);
    begin
      fTask := aTask;
      fCaptureContext := aCaptureContext;
    end;

    method &Await(aCompletion: IAwaitCompletion): Boolean;
    begin
      exit fTask.IntAwait(aCompletion, fCaptureContext);
    end;

    property &Result: T read fTask.Result;
  end;

  WaitCallback = Action<Object>;


  PThreadPoolCallback = ^ThreadPoolCallback;
  ThreadPoolCallback = public class
  assembly
    fState: Object;
    fCallback: WaitCallback;
  public
    constructor (aCallback: WaitCallback; State: Object);
  end;

  ThreadPool = static public class
  private
  {$IFDEF WINDOWS}
    class var fThreadPool: rtl.PTP_POOL;
    class var pcbe: rtl.TP_CALLBACK_ENVIRON;
    class var fMinThreads: UInt32;
    class var fMaxThreads: UInt32;
  {$ELSEIF not WEBASSEMBLY}
    class var fThreadPool: ManagedThreadPool;
  {$ENDIF}
    class method RaiseError(Value: String);
    class method SetMinThreads(Value: UInt32);
    class method SetMaxThreads(Value: UInt32);
  public
    constructor;
    class method QueueUserWorkItem(Callback: WaitCallback; State: Object);
    class property MinThreads: UInt32 read {$IFDEF WINDOWS}fMinThreads{$ELSEIF WEBASSEMBLY}1{$ELSE}fThreadPool.MinThreads{$ENDIF} write SetMinThreads;
    class property MaxThreads: UInt32 read {$IFDEF WINDOWS}fMaxThreads{$ELSEIF WEBASSEMBLY}1{$ELSE}fThreadPool.MaxThreads{$ENDIF} write SetMaxThreads;
  end;

  SynchronizationContext = public abstract class
  private
    [ThreadLocal]
    class var fCurrent: SynchronizationContext;
  public
    method Invoke(a: Action); abstract;
    method InvokeAsync(a: Action); abstract;

    class property Current: SynchronizationContext read fCurrent write fCurrent;
  end;

implementation


{$IFDEF WINDOWS}
[CallingConvention(CallingConvention.Stdcall)]
method ThreadCallBack(Instance: rtl.PTP_CALLBACK_INSTANCE; &Param: rtl.PVOID; Work: rtl.PTP_WORK);
begin
  Utilities.RegisterThread;
  Instance := nil;
  Work := nil;
  var lHandle := new GCHandle(NativeInt(&Param));
  var obj := ThreadPoolCallback(lHandle.Target);
  GCHandles.Free(NativeInt(&Param));
  obj.fCallback(obj.fState);
  obj := nil;
  Utilities.UnregisterThread;
end;
{$ENDIF}


constructor ThreadPoolCallback(aCallback: WaitCallback; State: Object);
begin
  fCallback := aCallback;
  fState := State;
end;


class method ThreadPool.RaiseError(Value: String);
begin
  {$IFDEF WEBASSEMBLY}
  raise new ArgumentException(Value);
  {$ELSE}
  CheckForLastError(Value);
  {$ENDIF}
end;

class method ThreadPool.QueueUserWorkItem(Callback: WaitCallback; State: Object);
begin
{$IFDEF WINDOWS}
  var lCallback:= new ThreadPoolCallback(Callback, State);
  var work := rtl.CreateThreadpoolWork(@ThreadCallBack, ^Void(GCHandle.Allocate(lCallback).Handle), @pcbe);
  if work = nil then RaiseError('error at calling CreateThreadpoolWork');
  rtl.SubmitThreadpoolWork(work);
{$ELSEIF WEBASSEMBLY}
WebAssembly.SetTimeout(-> Callback(State), 0);
{$ELSE}
  fThreadPool.Queue(new ThreadPoolCallback(Callback, State));
{$ENDIF}
end;


class method ThreadPool.SetMinThreads(Value: UInt32);
begin
{$IFDEF WINDOWS}
  if fMinThreads <> Value then begin
    if not rtl.SetThreadpoolThreadMinimum(fThreadPool, Value) then
      RaiseError('error at calling SetThreadpoolThreadMinimum');
    fMinThreads := Value;
  end;
{$ELSEIF not WEBASSEMBLY}
  fThreadPool.MinThreads := Value;
{$ENDIF}
end;

class method ThreadPool.SetMaxThreads(Value: UInt32);
begin
  {$IFDEF WINDOWS}
  if fMaxThreads <> Value then begin
    rtl.SetThreadpoolThreadMaximum(fThreadPool, Value);
    fMaxThreads := Value;
  end;
  {$ELSEIF NOT WEBASSEMBLY}
  fThreadPool.MaxThreads := Value;
{$ENDIF}
end;

constructor ThreadPool;
begin
{$IFDEF WINDOWS}
  fThreadPool := rtl.CreateThreadpool(nil);
  if fThreadPool = nil then RaiseError('error at calling CreateThreadpool');
  fMinThreads := 0;
  MinThreads := 1;    // can be changed later manually by user
  fMaxThreads := 0;
  MaxThreads := 100;  // can be changed later manually by user
  rtl.InitializeThreadpoolEnvironment(@pcbe);
  rtl.SetThreadpoolCallbackPool(@pcbe, fThreadPool);
{$ELSEIF NOT WEBASSEMBLY}
  fThreadPool := new ManagedThreadPool;
{$ENDIF}
end;

end.