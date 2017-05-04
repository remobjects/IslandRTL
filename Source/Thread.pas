namespace RemObjects.Elements.System;

interface

type
  ParameterizedThreadStart = public delegate (obj: Object);

  PThread = ^Thread;
  Thread = public class
  private
    method set_Name(value: String);
    fName: String := '';
  assembly
    {$IFDEF WINDOWS}
    fThread: rtl.HANDLE := nil;
    fThreadID: rtl.DWORD;
    {$ELSE}
    fthread: rtl.pthread_t := &default(rtl.pthread_t);
    {$ENDIF}
    //fThreadID: NativeUInt;
    fStarted: Integer := 0;
    fTerminated: Boolean := False;
    fDone: Boolean := False;
    fCallback: ParameterizedThreadStart;
    fCallbackObject: Object := nil;
    fCallStack: String;
    method Execute;
    method RaiseError(aMessage: String);
    method GetPriority: ThreadPriority;
    method SetPriority(Value: ThreadPriority);
    method GetAlive: Boolean;
    //class method GetCurrentThread: Thread;external;//HANDLE WINAPI GetCurrentThread(Void); ???
  public
    method Start(parameter: Object := nil);
    method Abort;
    class method Sleep(aTimeout: Integer);
    class method &Yield: Boolean;
    class property CurrentThreadID: NativeUInt read {$IFDEF WINDOWS}rtl.GetCurrentThreadID{$ELSE}NativeUInt(rtl.pthread_self()){$ENDIF};

    property IsAlive: Boolean read GetAlive;
    property Name: String read fName write set_Name;
    property Priority: ThreadPriority read GetPriority write SetPriority;
    property CallStack: String read fCallStack;

  //  class property CurrentThread: Thread read GetCurrentThread;
  public
    constructor(aCallback: ParameterizedThreadStart);
    finalizer;
  end;

  ThreadState = public enum(
    Unstarted,
    Running,
    Waiting,
    Stopped
  );

  ThreadPriority = public enum(
    Lowest,
    BelowNormal,
    Normal,
    AboveNormal,
    Highest
  );

  {$IFDEF WINDOWS}
  WaitHandle = public abstract class(IDisposable)
  protected
    fHandle: rtl.HANDLE;
  protected
    constructor(aHandle: rtl.HANDLE);

    method Wait(aTimeMS: Integer): Boolean;
    method Wait;

    finalizer;
    method Dispose;
  end;

  EventWaitHandle = public class(WaitHandle)
  public
    constructor(aAutoReset: Boolean; aInitialValue: Boolean);
    method &Set;
    method Reset;
  end;

  Mutex = public class(WaitHandle)
  public
    constructor(aInitialValue: Boolean);

    method Release;
  end;
  {$ELSE}
  WaitHandle = public abstract class(IDisposable)
  private
  public
    method Wait(aTimeMS: Integer): Boolean; abstract;
    method Wait;abstract;
    method Dispose; abstract;
  end;
  Mutex = public class(WaitHandle)
  private
     fMutex: rtl.pthread_mutex_t;
  public
    constructor(aInitialValue: Boolean);
    method Release;
    method Wait(aTimeMS: Integer): Boolean; override;
    method Wait; override;
    finalizer;
    method Dispose; override;
  end;

  EventWaitHandle = public class(WaitHandle)
  private
    fMutex: rtl.pthread_mutex_t;
    fCV: rtl.pthread_cond_t;
    fValue: Boolean;
    fAutoReset: Boolean;
  public
    constructor(aAutoReset: Boolean; aInitialValue: Boolean);
    method &Set;
    method Reset;
    method Wait(aTimeMS: Integer): Boolean; override;
    method Wait; override;
    method Dispose; override;
    finalizer;
  end;
  {$ENDIF}
  {$IFDEF WINDOWS}

method WindowsThreadProc(aParam: ^Void): rtl.DWORD;
{$ENDIF}

implementation

method Thread.GetPriority: ThreadPriority;
begin
  {$IFDEF WINDOWS}
  var pri: Integer := rtl.GetThreadPriority(self.fThread);
  if pri = $7FFFFFFF then RaiseError("Can't get thread priority")
  else if pri < -1 then exit ThreadPriority.Lowest
  else if pri = -1 then exit ThreadPriority.BelowNormal
  else if pri =  0 then exit ThreadPriority.Normal
  else if pri =  1 then exit ThreadPriority.AboveNormal
  else if pri >  1 then exit ThreadPriority.Highest;
  {$ELSE}
  var pol: Int32;
  var sched: rtl.__struct_sched_param;
  rtl. pthread_getschedparam(fthread, @pol, @sched);
  var pri := {$IFDEF EMSCRIPTEN}sched.sched_priority{$ELSE}sched.__sched_priority{$ENDIF};
  if pri < -1 then exit ThreadPriority.Lowest
  else if pri = -1 then exit ThreadPriority.BelowNormal
  else if pri =  0 then exit ThreadPriority.Normal
  else if pri =  1 then exit ThreadPriority.AboveNormal
  else if pri >  1 then exit ThreadPriority.Highest;
  {$ENDIF}
end;

method Thread.SetPriority(Value: ThreadPriority);
begin
  {$IFDEF WINDOWS}
  var pri : Integer;
  case Value of
    ThreadPriority.Lowest:       pri := -2;
    ThreadPriority.BelowNormal:  pri := -1;
    ThreadPriority.Normal:       pri :=  0;
    ThreadPriority.AboveNormal:  pri :=  1;
    ThreadPriority.Highest:      pri :=  2;
  end;
  if not rtl.SetThreadPriority(self.fThread, pri)  then
    RaiseError("Can't set thread priority");
  {$ELSE}
  raise new NotImplementedException;
  {$ENDIF}
end;

{$IFDEF WINDOWS}
method WindowsThreadProc(aParam: ^Void): rtl.DWORD;
begin
  var aThread:= InternalCalls.Cast<Thread>(aParam);
  try
    if not aThread.fTerminated then begin
      try
        aThread.Execute;
      except
        on E: Exception do
          aThread.fCallStack := E.Message;
      end;
    end;
  finally
    aThread.fDone := True;
    result := 0;
    rtl.ExitThread(result);
  end;
end;
{$ELSE}
method ThreadProc(aParam: ^Void): ^Void;
begin
  var aThread:= InternalCalls.Cast<Thread>(aParam);
  try
    if not aThread.fTerminated then begin
      try
        aThread.Execute;
      except
        on E: Exception do
          aThread.fCallStack := E.Message;
      end;
    end;
  finally
    aThread.fDone := True;
  end;
end;
{$ENDIF}

constructor Thread(aCallback: ParameterizedThreadStart);
begin
  self.fCallback := aCallback;
  self.fCallStack := nil;
end;

method Thread.RaiseError(aMessage: String);
begin
  {$IFDEF WINDOWS}
  CheckForLastError(aMessage);
  {$ELSE}
  raise new Exception(aMessage);
  {$ENDIF}
end;

method Thread.Start(parameter: Object);
begin
  if InternalCalls.Exchange(var fStarted, 1) = 0 then begin
    fCallbackObject := parameter;
    {$IFDEF WINDOWS}
    var lStart: rtl.PTHREAD_START_ROUTINE := @WindowsThreadProc;

    self.fThread := rtl.CreateThread(nil,0, lStart, InternalCalls.Cast(self), 0, @fThreadID);
    if self.fThread = nil then RaiseError("Problem with creating thread");
    {$ELSE}
    rtl.pthread_create(@fthread, nil, @ThreadProc, InternalCalls.Cast(self));
    {$ENDIF}
  end;
end;

{$IF WINDOWS}
type
  ThreadNameInfo = record
    {$HIDE H7}
    FType: UInt32;     // must be 0x1000
    FName: ^Char;    // pointer to name (in user address space)
    FThreadID: UInt32; // thread ID (-1 indicates caller thread)
    FFlags: UInt32;    // reserved for future use, must be zero
    {$SHOW H7}
  end;
{$ENDIF}

method Thread.GetAlive: Boolean;
begin
  exit not fDone;
end;

method Thread.Execute;
begin
  fCallback(fCallbackObject);
end;

class method Thread.Sleep(aTimeout: Integer);
begin
  rtl.Sleep(aTimeout);
end;

method Thread.Abort;
begin
  // we have no possibility to abort execution of unmanaged code
  fTerminated := True;
end;

class method Thread.Yield: Boolean;
begin
  {$IFDEF WINDOWS}
  exit rtl.SwitchToThread;
  {$ELSE}
  exit Boolean(rtl.sched_yield);
  {$ENDIF}
end;

finalizer Thread;
begin
  {$IFDEF WINDOWS}
  if self.fThread <> nil then rtl.CloseHandle(fThread);
  {$ELSE}
  rtl.pthread_detach(fthread);
  {$ENDIF}
end;

method Thread.set_Name(value: String);
begin
  if not String.IsNullOrEmpty(Name) or (Name.Trim.Length <> 0) then begin
    {$IFDEF WINDOWS}
    var lThreadNameInfo: ThreadNameInfo;
    lThreadNameInfo.FType := $1000;
    lThreadNameInfo.FName := Name.ToLPCWSTR;
    lThreadNameInfo.FThreadID := fThreadID;
    lThreadNameInfo.FFlags := 0;
    try
      rtl.RaiseException( $406D1388, 0, sizeOf(lThreadNameInfo) / sizeOf(NativeUInt), {$IFDEF _WIN64}^UInt64{$ELSE}^UInt32{$ENDIF}(^Void(@lThreadNameInfo)));
    except
    end;
    {$ELSE}
    {$IFNDEF EMSCRIPTEN}
    rtl.pthread_setname_np(fthread, @Name.ToAnsiChars[0])
    {$ENDIF}
    {$ENDIF}
  end;
end;

{$IFDEF WINDOWS}
constructor WaitHandle(aHandle: rtl.HANDLE);
begin
  fHandle := aHandle;
end;

method WaitHandle.Wait(aTimeMS: Integer): Boolean;
begin
  exit rtl.WaitForSingleObject(fHandle, aTimeMS) = rtl.WAIT_OBJECT_0;
end;

method WaitHandle.Wait;
begin
  Wait(rtl.INFINITE);
end;

finalizer WaitHandle;
begin
  if fHandle <> nil then
  rtl.CloseHandle(fHandle);
end;

method WaitHandle.Dispose;
begin
  if fHandle <> nil then begin
    Utilities.SuppressFinalize(self);
    rtl.CloseHandle(fHandle);
    fHandle := nil;
  end;
end;

constructor EventWaitHandle(aAutoReset: Boolean; aInitialValue: Boolean);
begin
  inherited constructor(rtl.CreateEvent(nil, not aAutoReset, aInitialValue, nil));
end;

method EventWaitHandle.Set;
begin
  rtl.SetEvent(fHandle);
end;

method EventWaitHandle.Reset;
begin
 rtl.ResetEvent(fHandle);
end;

constructor Mutex(aInitialValue: Boolean);
begin
  inherited constructor(rtl.CreateMutex(nil, aInitialValue, nil));
end;

method Mutex.Release;
begin
  rtl.ReleaseMutex(fHandle);
end;
{$ELSE}
constructor Mutex(aInitialValue: Boolean);
begin
  rtl.pthread_mutex_init(@fMutex, nil);
  if aInitialValue then rtl.pthread_mutex_lock(@fMutex);
end;

method Mutex.Release;
begin
  rtl.pthread_mutex_unlock(@fMutex);
end;

method Mutex.Wait(aTimeMS: Integer): Boolean;
begin
  var ts: rtl.__struct_timespec;
  rtl.clock_gettime(rtl.CLOCK_REALTIME , @ts);
  ts.tv_nsec := ts.tv_nsec + ((aTimeMS mod 1000)  *1000);
  ts.tv_sec := ts.tv_sec + (aTimeMS /1000);
  exit rtl.pthread_mutex_timedlock(@fMutex, @ts) = 0;
end;

method Mutex.Wait;
begin
  rtl.pthread_mutex_lock(@fMutex);
end;

finalizer Mutex;
begin
  rtl.pthread_mutex_destroy(@fMutex);
end;

method Mutex.Dispose;
begin
  Utilities.SuppressFinalize(self);
  rtl.pthread_mutex_destroy(@fMutex);
end;

constructor EventWaitHandle(aAutoReset: Boolean; aInitialValue: Boolean);
begin
  rtl.pthread_mutex_init(@fMutex, nil);
  rtl.pthread_cond_init(@fCV, nil);
  fValue := aInitialValue;
  fAutoReset := aAutoReset;
end;

method EventWaitHandle.Set;
begin
  rtl.pthread_mutex_lock(@fMutex);
  fValue := true;
  if fAutoReset then
    rtl.pthread_cond_signal(@fCV)
  else
    rtl.pthread_cond_broadcast(@fCV);
  rtl.pthread_mutex_unlock(@fMutex);
end;

method EventWaitHandle.Reset;
begin
  rtl.pthread_mutex_lock(@fMutex);
  fValue := false;
  rtl.pthread_mutex_unlock(@fMutex);
end;

method EventWaitHandle.Wait(aTimeMS: Integer): Boolean;
begin
  var ts, ts2: rtl.__struct_timespec;
  rtl.clock_gettime(rtl.CLOCK_REALTIME , @ts);
  ts.tv_nsec := ts.tv_nsec + ((aTimeMS mod 1000)  *1000);
  ts.tv_sec := ts.tv_sec + (aTimeMS /1000);
  rtl.pthread_mutex_lock(@fMutex);
  loop begin
    rtl.pthread_cond_wait(@fCV, @fMutex);
    if fValue then begin
      result := true;
      if fAutoReset then fValue := false;
      break;
    end;

    rtl.clock_gettime(rtl.CLOCK_REALTIME , @ts2);
    if (ts2.tv_sec > ts.tv_sec) or (ts2.tv_nsec > ts.tv_nsec) then break;
  end;
  rtl.pthread_mutex_unlock(@fMutex);
end;

method EventWaitHandle.Wait;
begin
  rtl.pthread_mutex_lock(@fMutex);
  loop begin
    rtl.pthread_cond_wait(@fCV, @fMutex);
    if fValue then begin
      if fAutoReset then fValue := false;
      break;
    end;
  end;
  rtl.pthread_mutex_unlock(@fMutex);
end;

method EventWaitHandle.Dispose;
begin
  Utilities.SuppressFinalize(self);
  rtl.pthread_cond_destroy(@fCV);
  rtl.pthread_mutex_destroy(@fMutex);
end;

finalizer EventWaitHandle;
begin
  rtl.pthread_cond_destroy(@fCV);
  rtl.pthread_mutex_destroy(@fMutex);
end;
{$ENDIF}

end.