namespace RemObjects.Elements.System;

interface

type
  TaskObject = abstract class
  public
    constructor; empty;
    constructor(aState: Object);
    method Execute; abstract;
    property State: Object;
  end;

  TaskObject_Action = class(TaskObject) 
  private
    fIn: Action;
  public
    constructor (aIn: Action);
    method Execute; override;
  end;

  TaskObject_Action1 = class(TaskObject)
  private
    fIn: Action<Object>;
  public
    constructor (aIn: Action<Object>; aState: Object);
    method Execute; override;
  end;

  TaskObject_Action2 = class(TaskObject)
  private
    fIn: Action<Task,Object>;
    fTask: Task;
  public
    constructor (aIn: Action<Task,Object>; aTask: Task; aState: Object);
    method Execute; override;
  end;

  TaskObject_Func<T> = abstract class(TaskObject)
  public
    method Execute; override;
    method Execute2: T; abstract;
    property &Result: T;
  end;

  TaskObject_Func1<T> = class(TaskObject_Func<T>)
  private
    fIn: Func<T>;    
  public
    constructor(aIn: Func<T>);
    method Execute2: T; override;
  end;

  TaskObject_Func2<T> = class(TaskObject_Func<T>)
  private
    fIn: Func<Object, T>;
  public
    constructor(aIn: Func<Object,T>; aState: Object);
    method Execute2: T; override;
  end;

  TaskObject_Func3<T> = class(TaskObject_Func<T>)
  private
    fIn: Func<Task, Object, T>;
    fTask: Task;
  public
    constructor(aIn: Func<Task, Object, T>; aTask: Task; aState: Object);
    method Execute2: T; override;
  end;

  Task = public class
  private
    fException: Exception := nil;
    fIsFaulted: Boolean := False;
    fIsCompleted: Boolean := False;
    fTaskObject: TaskObject := nil;
    fStarted: Boolean := False;
    fContinueList: List<Task> := new List<Task>;
    class method Execute(aState: Object);
  unit
    constructor();empty;
    method Init(aTaskObject : TaskObject);
  public
    constructor(aIn: Action);
    constructor(aIn: Action<Object>; aState: Object);
    method ContinueWith(aAction: Action<Task>): Task;
    method ContinueWith(aAction: Action<Task,Object>; aState: Object): Task;
    method ContinueWith<T>(aAction: Func<Task, T>): Task1<T>;
    method ContinueWith<T>(aAction: Func<Task, Object, T>; aState: Object): Task1<T>;
    class method Run(aIn: Action): Task;    
    class method Run(aIn: Action<Task>): Task;
    class method Run<T>(aIn: Func<T>): Task1<T>;
    class method Run<T>(aIn: Func<Task1<T>,T>): Task1<T>;
    property Exception: Exception read fException;
    property AsyncState: Object read fTaskObject.State;
    property IsFaulted: Boolean read fIsFaulted;
    property IsCompleted: Boolean read fIsCompleted;
    //method &Await(aCompletion: IAwaitCompletion): Boolean; external;

    method Wait;
    method Wait(aTimeoutMSec: Integer): Boolean;
    method Start();
  end;

  WaitCallback = Action<Object>;

  PThreadPoolCallback = ^ThreadPoolCallback;
  ThreadPoolCallback = assembly class
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
  {$ELSE}
    class var fThreadPool: ManagedThreadPool;
  {$ENDIF}
    class method RaiseError(Value: String);
    class method SetMinThreads(Value: UInt32);
    class method SetMaxThreads(Value: UInt32);
  public
    constructor;
    class method QueueUserWorkItem(Callback: WaitCallback; State: Object);
    class property MinThreads: UInt32 read {$IFDEF WINDOWS}fMinThreads{$ELSE}fThreadPool.MinThreads{$ENDIF} write SetMinThreads;
    class property MaxThreads: UInt32 read {$IFDEF WINDOWS}fMaxThreads{$ELSE}fThreadPool.MaxThreads{$ENDIF} write SetMaxThreads;
  end;

  Task1<T> = public class(Task)
  private
    fTaskObject: TaskObject_Func<T>; 
  unit
    constructor();
    method Init2(aTaskObject : TaskObject_Func<T>);
  public
    constructor(aIn: Func<T>); 
    constructor(aIn: Func<Object, T>; aState: Object); 
    property &Result: T read fTaskObject.Result;
  end;

{
  IAwaitCompletion = public interface
    method moveNext(aState: Object);
  end;


  TaskCompletionSource<T> = public class
  private
    method get_Task: Task1<T>;external;
  public
    constructor(aState: Object := nil);external;

    method SetException(ex: Exception);external;
    method SetResult(val: T);external;

    property Task: Task1<T> read get_Task;
  end;
}

implementation

constructor TaskObject(aState: Object);
begin
  State := aState;
end;

constructor TaskObject_Action(aIn: Action);
begin
  inherited constructor(nil);
  fIn := aIn;
end;

method TaskObject_Action.Execute;
begin
  fIn();
end;

constructor TaskObject_Action1(aIn: Action<Object>; aState: Object);
begin
  inherited constructor(aState);
  fIn := aIn;  
end;

method TaskObject_Action1.Execute;
begin
  fIn(State);
end;

constructor TaskObject_Action2(aIn: Action<Task,Object>; aTask: Task; aState: Object);
begin
  inherited constructor(aState);
  fIn := aIn;
  fTask := aTask;
end;

method TaskObject_Action2.Execute;
begin
  fIn(fTask, State);
end;

method TaskObject_Func<T>.Execute;
begin
  &Result := Execute2();
end;

constructor TaskObject_Func1<T>(aIn: Func<T>);
begin
  inherited constructor;
  fIn := aIn;
end;

method TaskObject_Func1<T>.Execute2: T;
begin
  exit fIn();
end;

constructor TaskObject_Func2<T>(aIn: Func<Object,T>; aState: Object);
begin
  inherited constructor(aState);
  fIn := aIn;
end;

method TaskObject_Func2<T>.Execute2: T;
begin
  exit fIn(State);
end;

constructor TaskObject_Func3<T>(aIn: Func<Task,Object,T>; aTask: Task; aState: Object);
begin
  inherited constructor(aState);
  fIn := aIn;
  fTask := aTask;
end;

method TaskObject_Func3<T>.Execute2: T;
begin
  exit fIn(fTask, State);
end;


{$IFDEF WINDOWS}
method ThreadCallBack(Instance: rtl.PTP_CALLBACK_INSTANCE; &Param: rtl.PVOID; Work: rtl.PTP_WORK);
begin
  Instance := nil; 
  Work := nil;
  var obj :ThreadPoolCallback := PThreadPoolCallback(&Param)^;
  obj.fCallback(obj.fState);
  obj := nil;
end;
{$ENDIF}

constructor Task(aIn: Action<Object>; aState: Object);
begin
  Init(new TaskObject_Action1(aIn, aState));
end;

method Task.Start;
begin
  ThreadPool.QueueUserWorkItem(@Execute,Self);
end;

class method Task.Execute(aState: Object);
begin
  var lTask := aState as Task;
  if not lTask.fStarted then begin
    lTask.fStarted:= True;
//    fIsFaulted := False;
//    fException := nil;
//    fIsCompleted := False;
    try
      try
        lTask.fTaskObject.Execute();
      except
        on E: Exception do begin
          lTask.fIsFaulted := True;
          lTask.fException := E;
        end;
      end;
    finally
      lTask.fIsCompleted := True;
      for i: Integer := 0 to lTask.fContinueList.Count-1 do
        lTask.fContinueList[i].Start;
    end;
  end;
end;

class method Task.Run(aIn: Action): Task;
begin
  result := new Task(aIn);
  result.Start;
end;

constructor Task(aIn: Action);
begin
  Init(new TaskObject_Action(aIn));  
end;

class method Task.Run<T>(aIn: Func<T>): Task1<T>;
begin
  result := new Task1<T>(aIn);
  result.Start;
end;

method Task.Wait;
begin
  if not fStarted then 
    Start()
  else
    while not fIsCompleted do 
      rtl.Sleep(100);
end;

method Task.Wait(aTimeoutMSec: Integer): Boolean;
begin
  var dx := aTimeoutMSec;
  while dx > 0 do begin
    if fIsCompleted then break;
    rtl.Sleep(100);
    dec(dx, 100);
  end;
  exit fIsCompleted;
end;

method Task.ContinueWith(aAction: Action<Task,Object>; aState: Object := nil): Task;
begin
  Result := new Task();
  result.Init(new TaskObject_Action2(aAction, Self, aState));
  fContinueList.Add(Result);
end;

method Task.ContinueWith<T>(aAction: Func<Task,T>): Task1<T>;
begin
  Result := new Task1<T>(aAction, Self);
  fContinueList.Add(Result);
end;

method Task.Init(aTaskObject: TaskObject);
begin
  fTaskObject := aTaskObject;
end;

method Task.ContinueWith(aAction: Action<Task>): Task;
begin
  Result := new Task();
  result.Init(new TaskObject_Action1(aAction, Self));
  fContinueList.Add(Result);
end;

method Task.ContinueWith<T>(aAction: Func<Task,Object,T>; aState: Object): Task1<T>;
begin
  Result := new Task1<T>();
  result.Init2(new TaskObject_Func3<T>(aAction, Self, aState));
  fContinueList.Add(Result);
end;

class method Task.Run(aIn: Action<Task>): Task;
begin
  result := new Task();
  result.Init(new TaskObject_Action1(aIn, result));
  result.Start;
end;

class method Task.Run<T>(aIn: Func<Task1<T>,T>): Task1<T>;
begin
  result := new Task1<T>;
  result.Init2(new TaskObject_Func2<T>(aIn, result));
  result.Start;
end;

method Task1<T>.Init2(aTaskObject: TaskObject_Func<T>);
begin
  Init(aTaskObject);
  fTaskObject := aTaskObject;
end;

constructor Task1<T>(aIn: Func<T>);
begin
  Init2(new TaskObject_Func1<T>(aIn));
end;

constructor Task1<T>(aIn: Func<Object, T>; aState: Object := nil);
begin
  Init2(new TaskObject_Func2<T>(aIn, aState));
end;

constructor Task1<T>;
begin
  inherited constructor();
end;

constructor ThreadPoolCallback(aCallback: WaitCallback; State: Object);
begin
  fCallback := aCallback;
  fState := State;
end;


{$IFDEF WINDOWS}

class method ThreadPool.QueueUserWorkItem(Callback: WaitCallback; State: Object);
begin
  var lCallback:= new ThreadPoolCallback(Callback, State);
  var work := rtl.CreateThreadpoolWork(@ThreadCallBack, @lCallback, @pcbe);
  if work = nil then RaiseError('error at calling CreateThreadpoolWork'); 
  rtl.SubmitThreadpoolWork(work);
end;

constructor ThreadPool;
begin
  fThreadPool := rtl.CreateThreadpool(nil);
  if fThreadPool = nil then RaiseError('error at calling CreateThreadpool');
  fMinThreads := -1;
  MinThreads := 1;    // can be changed later manually by user
  fMaxThreads := -1;
  MaxThreads := 100;  // can be changed later manually by user  
  rtl.InitializeThreadpoolEnvironment(@pcbe);
  rtl.SetThreadpoolCallbackPool(@pcbe, fThreadPool);
end;

class method ThreadPool.SetMinThreads(Value: UInt32);
begin
  if fMinThreads <> Value then begin
    if not rtl.SetThreadpoolThreadMinimum(fThreadPool, Value) then
      RaiseError('error at calling SetThreadpoolThreadMinimum');
    fMinThreads := Value;
  end;
end;

class method ThreadPool.SetMaxThreads(Value: UInt32);
begin
  if fMaxThreads <> Value then begin
    rtl.SetThreadpoolThreadMaximum(fThreadPool, Value);
    fMaxThreads := Value;
  end;
end;

class method ThreadPool.RaiseError(Value: String);
begin
  CheckForLastError(Value);
end;

{$ELSE}
class method ThreadPool.QueueUserWorkItem(Callback: WaitCallback; State: Object);
begin
  fThreadPool.Queue(new ThreadPoolCallback(Callback, State));
end;

constructor ThreadPool;
begin
  fThreadPool := new ManagedThreadPool;
end;

class method ThreadPool.SetMinThreads(Value: UInt32);
begin
  fThreadPool.MinThreads := Value;
end;

class method ThreadPool.SetMaxThreads(Value: UInt32);
begin
  fThreadPool.MaxThreads := Value;
end;

class method ThreadPool.RaiseError(Value: String);
begin
  CheckForLastError(Value);
end;

{$ENDIF}

end.
