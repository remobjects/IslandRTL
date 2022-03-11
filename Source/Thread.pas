namespace RemObjects.Elements.System;

interface

{$IFNDEF NOTHREADS}

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


  ReadWriteLock = public class(IDisposable)
  private
  {$IFDEF WINDOWS}
    fLock: rtl.SRWLOCK;
  {$ELSE}
    fLock: rtl.pthread_rwlock_t;
  {$ENDIF}
  public
    constructor;
    begin
      {$IFDEF WINDOWS}
      rtl.InitializeSRWLock(@fLock);
      {$ELSE}
      rtl.pthread_rwlock_init(@fLock, nil);
      {$ENDIF}
    end;

    finalizer;
    begin
      {$IFDEF WINDOWS}
      {$ELSE}
      rtl.pthread_rwlock_destroy(@fLock);
      {$ENDIF}
    end;

    method Dispose;
    begin
      {$IFDEF WINDOWS}
      {$ELSE}
      rtl.pthread_rwlock_destroy(@fLock);
      {$ENDIF}
    end;

    method EnterReadLock;
    begin
      {$IFDEF WINDOWS}
      rtl.AcquireSRWLockShared(@fLock);
      {$ELSE}
      if rtl.pthread_rwlock_rdlock(@fLock) <> 0 then raise new ArgumentException('Unable to acquire read lock');
      {$ENDIF}
    end;

    method TryEnterReadLock: Boolean;
    begin
      {$IFDEF WINDOWS}
      exit rtl.TryAcquireSRWLockShared(@fLock) <> 0;
      {$ELSE}
      exit rtl.pthread_rwlock_tryrdlock(@fLock) = 0;
      {$ENDIF}
    end;

    method ExitReadLock;
    begin
      {$IFDEF WINDOWS}
      rtl.ReleaseSRWLockShared(@fLock);
      {$ELSE}
      if rtl.pthread_rwlock_unlock(@fLock) <> 0 then raise new ArgumentException('Unable to release read lock');
      {$ENDIF}
    end;

    method EnterWriteLock;
    begin
      {$IFDEF WINDOWS}
      rtl.AcquireSRWLockExclusive(@fLock);
      {$ELSE}
      if rtl.pthread_rwlock_wrlock(@fLock) <> 0 then raise new ArgumentException('Unable to acquire write lock');
      {$ENDIF}
    end;

    method TryEnterWriteLock: Boolean;
    begin
      {$IFDEF WINDOWS}
      exit rtl.TryAcquireSRWLockExclusive(@fLock) <> 0;
      {$ELSE}
      exit rtl.pthread_rwlock_trywrlock(@fLock) = 0;
      {$ENDIF}
    end;

    method ExitWriteLock;
    begin
      {$IFDEF WINDOWS}
      rtl.ReleaseSRWLockExclusive(@fLock);
      {$ELSE}
      if rtl.pthread_rwlock_unlock(@fLock) <> 0 then raise new ArgumentException('Unable to release write lock');
      {$ENDIF}
    end;

  end;

  ConditionalVariable = public class(IDisposable)
  private
  {$IFDEF WINDOWS}
    fCond: rtl.CONDITION_VARIABLE;
  {$ELSEIF POSIX_LIGHT}
    fCond: rtl.pthread_cond_t;
  {$ELSE}
  {$ERROR NOT IMPLEMENTED}
  {$ENDIF}
  public
    constructor;
    begin
      {$IFDEF WINDOWS}
      rtl.InitializeConditionVariable(@fCond);
      {$ELSEIF POSIX}
      rtl.pthread_cond_init(@fCond, nil);
      {$ENDIF}
    end;

    finalizer;
    begin
      {$IFDEF WINDOWS}
      {$ELSEIF POSIX}
      rtl.pthread_cond_destroy(@fCond);
      {$ENDIF}
    end;

    method Dispose;
    begin
      {$IFDEF WINDOWS}
      {$ELSEIF POSIX}
      rtl.pthread_cond_destroy(@fCond);
      {$ENDIF}
    end;

    method Signal;
    begin
      {$IFDEF WINDOWS}
      rtl.WakeConditionVariable(@fCond);
      {$ELSEIF POSIX}
      rtl.pthread_cond_signal(@fCond);
      {$ENDIF}
    end;

    method Broadcast;
    begin
      {$IFDEF WINDOWS}
      rtl.WakeAllConditionVariable(@fCond);
      {$ELSEIF POSIX}
      rtl.pthread_cond_broadcast(@fCond);
      {$ENDIF}
    end;

    method Wait(cs: Monitor);
    begin
      {$IFDEF WINDOWS}
      rtl.SleepConditionVariableCS(@fCond, @cs.fCS, rtl.INFINITE);
      {$ELSEIF POSIX}
      rtl.pthread_cond_wait(@fCond, @cs.fCS);
      {$ENDIF}
    end;

    method Wait(cs: Monitor; aTimeMS: Integer): Boolean;
    begin
      {$IFDEF WINDOWS}
      exit rtl.SleepConditionVariableCS(@fCond, @cs.fCS, aTimeMS);
      {$ELSEIF POSIX}
      var ts: rtl.__struct_timespec;
      rtl.clock_gettime({$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts);
      ts.tv_nsec := ts.tv_nsec + ((aTimeMS mod 1000)  *1000);
      ts.tv_sec := ts.tv_sec + (aTimeMS /1000);
      exit rtl.pthread_cond_timedwait(@fCond, @cs.fCS, @ts) = 0;
      {$ENDIF}
    end;
  end;

  {$IFDEF WINDOWS}

  WaitHandle = public abstract class(IDisposable)
  protected
    fHandle: rtl.HANDLE;
  public
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
  protected
    method DoWait(aTimeMS: Integer): Boolean; abstract;
    method DoWait; abstract;
    method DoDispose; abstract;
  public
    method Wait(aTimeMS: Integer): Boolean;
    method Wait;
    method Dispose;
  end;
  Mutex = public class(WaitHandle)
  private
    fMutex: rtl.pthread_mutex_t;
    fDisposed: Boolean;
  protected
    method DoWait(aTimeMS: Integer): Boolean; override;
    method DoWait; override;
    method DoDispose; override;
  public
    constructor(aInitialValue: Boolean);
    method Release;
    finalizer;
  end;

  EventWaitHandle = public class(WaitHandle)
  private
    fMutex: rtl.pthread_mutex_t;
    fCV: rtl.pthread_cond_t;
    fDisposed, fAutoReset, fValue: Boolean;
  protected
    method DoWait(aTimeMS: Integer): Boolean; override;
    method DoWait; override;
    method DoDispose; override;
  public
    constructor(aAutoReset: Boolean; aInitialValue: Boolean);
    method &Set;
    method Reset;
    finalizer;
  end;
  {$ENDIF}
  {$IFDEF WINDOWS}

method WindowsThreadProc(aParam: ^Void): rtl.DWORD;
{$ENDIF}
{$ENDIF}

implementation

{$IFNDEF NOTHREADS}

{$IFDEF FUCHSIA}[Warning("Thread.GetPriority is not implemented for Fuchsia, yet.")]{$ENDIF}
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
  {$ELSEIF FUCHSIA}
  raise new NotImplementedException("Thread.GetPriority is not implemented for Fuchsia, yet.");
  {$WARNING Thread.GetPriority is not implemented for Fuchsia, yet.}
  {$ELSEIF POSIX}
  var pol: Int32;
  var sched: rtl.__struct_sched_param;
  rtl. pthread_getschedparam(fthread, @pol, @sched);
  var pri := {$IFDEF DARWIN or ARM64 OR FUCHSIA}sched.sched_priority{$ELSE}sched.__sched_priority{$ENDIF};
  if pri < -1 then exit ThreadPriority.Lowest
  else if pri = -1 then exit ThreadPriority.BelowNormal
  else if pri =  0 then exit ThreadPriority.Normal
  else if pri =  1 then exit ThreadPriority.AboveNormal
  else if pri >  1 then exit ThreadPriority.Highest;
  {$ELSE}
  {$ERROR Unsupported platform}
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
  var lHandle := new GCHandle(NativeInt(aParam));
  var aThread:= lHandle.Target as Thread;
  lHandle.Dispose;
  try
    if not aThread.fTerminated then begin
      try
        Utilities.RegisterThread;
        aThread.Execute;
      except
        on E: Exception do
          aThread.fCallStack := E.Message;
      end;
      Utilities.UnregisterThread;

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
  var lHandle := new GCHandle(NativeInt(aParam));
  var aThread:= lHandle.Target as Thread;
  lHandle.Dispose;
  try
    if not aThread.fTerminated then begin
      try
        Utilities.RegisterThread;
        aThread.Execute;
      except
        on E: Exception do
          aThread.fCallStack := E.Message;
      end;
      Utilities.UnregisterThread;
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

    self.fThread := rtl.CreateThread(nil,0, lStart, ^Void(GCHandle.Allocate(self).Handle), 0, @fThreadID);
    if self.fThread = nil then RaiseError("Problem with creating thread");
    {$ELSE}
    rtl.pthread_create(@fthread, nil, @ThreadProc, ^Void(GCHandle.Allocate(self).Handle));
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
  {$IFDEF POSIX}
  rtl.usleep(aTimeout * 1000);
  {$ELSE}
  rtl.Sleep(aTimeout);
  {$ENDIF}
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

{$IFDEF DARWIN}[Warning("Thread.Name cannot be setbon Darwin")]{$ENDIF}
{$IFDEF FUCHSIA}[Warning("Thread.Name cannot be setbon Fuchsia")]{$ENDIF}
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
      {$IFDEF _WIN64}
      rtl.RaiseException( $406D1388, 0, sizeOf(lThreadNameInfo) / sizeOf(NativeUInt), ^UInt64(^Void(@lThreadNameInfo)));
      {$ELSE}
      rtl.RaiseException( $406D1388, 0, sizeOf(lThreadNameInfo) / sizeOf(NativeUInt), ^UInt32(^Void(@lThreadNameInfo)));
      {$ENDIF}
    except
    end;
    {$ELSE}
    {$IFNDEF DARWIN OR FUCHSIA}
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

method WaitHandle.Wait(aTimeMS: Integer): Boolean;
begin
  exit DoWait(aTimeMS);
end;

method WaitHandle.Wait;
begin
  DoWait;
end;

method WaitHandle.Dispose;
begin
  DoDispose;
end;

constructor Mutex(aInitialValue: Boolean);
begin
  rtl.pthread_mutex_init(@fMutex, nil);
  if aInitialValue then rtl.pthread_mutex_lock(@fMutex);
end;

method Mutex.Release;
begin
  rtl.pthread_mutex_unlock(@fMutex);
end;

method Mutex.DoWait(aTimeMS: Integer): Boolean;
begin
  var ts, ts2, tswait: rtl.__struct_timespec;
  rtl.clock_gettime({$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts);
  ts.tv_nsec := ts.tv_nsec + ((aTimeMS mod 1000)  *1000);
  ts.tv_sec := ts.tv_sec + (aTimeMS /1000);
  tswait.tv_nsec := 10000000;
  {$IFDEF DARWIN}
  loop begin
    if rtl.pthread_mutex_trylock(@fMutex) = 0 then exit true;
    rtl.nanosleep(@ts, @ts);
    rtl.clock_gettime(
    {$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts2);
    if (ts2.tv_sec > ts.tv_sec) or (ts2.tv_nsec > ts.tv_nsec) then exit false;
  end;
  {$ELSE}
  exit rtl.pthread_mutex_timedlock(@fMutex, @ts) = 0;
  {$ENDIF}
end;

method Mutex.DoWait;
begin
  rtl.pthread_mutex_lock(@fMutex);
end;

finalizer Mutex;
begin
  Dispose;
end;

method Mutex.DoDispose;
begin
  if not fDisposed then begin
    rtl.pthread_mutex_destroy(@fMutex);
    fDisposed := true;
  end;
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

method EventWaitHandle.DoWait(aTimeMS: Integer): Boolean;
begin
  var ts, ts2: rtl.__struct_timespec;
  rtl.clock_gettime({$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts);
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

    rtl.clock_gettime({$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts2);
    if (ts2.tv_sec > ts.tv_sec) or (ts2.tv_nsec > ts.tv_nsec) then break;
  end;
  rtl.pthread_mutex_unlock(@fMutex);
end;

method EventWaitHandle.DoWait;
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

method EventWaitHandle.DoDispose;
begin
  if not fDisposed then begin
    fDisposed := true;
    rtl.pthread_cond_destroy(@fCV);
    rtl.pthread_mutex_destroy(@fMutex);
  end;
end;

finalizer EventWaitHandle;
begin
  Dispose;
end;
{$ENDIF}
{$ENDIF}

end.