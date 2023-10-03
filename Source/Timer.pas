namespace RemObjects.Elements.System;

interface

{$GLOBALS ON}

type
  TimerElapsedBlock = public block (aData: Object);
  Timer = public class(IDisposable)
  private
    {$IF WINDOWS}
    fTimerQueue: rtl.HANDLE;
    fTimer: rtl.HANDLE := rtl.INVALID_HANDLE_VALUE;
    {$ELSEIF LINUX OR ANDROID}
    fTimer: rtl.timer_t;
    {$ELSEIF ISLAND AND DARWIN}
    fTimer: rtl.dispatch_source_t;
    {$ELSEIF WEBASSEMBLY}
    fTimer: IntPtr;
    {$ENDIF}
    fElapsed: TimerElapsedBlock;
    fEnabled: Boolean;
    fInterval: Integer;
    fRepeat: Boolean := true;
    method SetRepeat(value: Boolean);
    method SetInterval(value: Integer);
    method SetEnabled(value: Boolean);
    method Init;
    method CheckIfEnabled;
  public
    constructor;
    constructor(aInterval: Integer);
    constructor(aInterval: Integer; aRepeat: Boolean);
    method Start;
    method Stop;
    method Dispose;
    property Enabled: Boolean read fEnabled write SetEnabled;
    property Interval: Integer read fInterval write SetInterval;
    property &Repeat: Boolean read fRepeat write SetRepeat;
    property Elapsed: TimerElapsedBlock read fElapsed write fElapsed;
    property Data: Object;
  end;

implementation

{$IFDEF WINDOWS}
[CallingConvention(CallingConvention.Stdcall)]
procedure TimerCallback(lpParam: rtl.PVOID; TimerOrWaitFired: Byte);
begin
  var lTimer := InternalCalls.Cast<Timer>(lpParam);
  lTimer.Elapsed(lTimer.Data);
end;
{$ELSEIF LINUX OR ANDROID}
[CallingConvention(CallingConvention.Cdecl)]
procedure TimerCallback(aSigVal: rtl.sigval_t);
begin
  var lTimer := InternalCalls.Cast<Timer>(aSigVal.sival_ptr);
  lTimer.Elapsed(lTimer.Data);
end;
{$ENDIF}

method Timer.SetRepeat(value: Boolean);
begin
  CheckIfEnabled;
  fRepeat := value;
end;

method Timer.SetInterval(value: Integer);
begin
  CheckIfEnabled;
  fInterval := value;
end;

method Timer.SetEnabled(value: Boolean);
begin
  if value <> fEnabled then begin
    if fEnabled then Start
    else Stop;
  end;
end;

method Timer.Init;
begin
  {$IFDEF WINDOWS}
  fTimerQueue := rtl.CreateTimerQueue;
  {$ENDIF}
end;

constructor Timer;
begin
  Init;
end;

constructor Timer(aInterval: Integer);
begin
  Init;
  fInterval := aInterval;
end;

constructor Timer(aInterval: Integer; aRepeat: Boolean);
begin
  Init;
  fInterval := aInterval;
  fRepeat := aRepeat;
end;

method Timer.Start;
begin
  if fEnabled then exit;
  {$IFDEF WINDOWS}
  var lRepeat := fInterval;
  if not fRepeat then lRepeat := 0;
    if not rtl.CreateTimerQueueTimer(@fTimer, fTimerQueue, @TimerCallback, InternalCalls.Cast(self), fInterval, lRepeat, 0) then
    raise new Exception('Can not create new timer');
  {$ELSEIF FUCHSIA}
  {$WARNING Not Implememnted for Fuchsia yet}
  {$ELSEIF LINUX OR ANDROID}
  var lSigEv: rtl.sigevent_t;
  lSigEv.sigev_notify := rtl.SIGEV_THREAD;
  lSigEv.sigev_value.sival_ptr := InternalCalls.Cast(self);

  lSigEv._sigev_un._sigev_thread._function := @TimerCallback;
  lSigEv._sigev_un._sigev_thread._attribute := nil;
  rtl.timer_create(rtl.CLOCK_REALTIME, @lSigEv, @fTimer);

  var lInterval: rtl.__struct_itimerspec;
  lInterval.it_value.tv_sec := fInterval div 1000;
  lInterval.it_value.tv_nsec := (fInterval mod 1000) * 1000000;

  if fRepeat then begin
    lInterval.it_interval.tv_sec := fInterval div 1000;
    lInterval.it_interval.tv_nsec := (fInterval mod 1000) * 1000000;
  end;
  rtl.timer_settime(fTimer, 0, @lInterval, nil);
  {$ELSEIF ISLAND AND DARWIN}
  var lQueue := rtl.dispatch_get_global_queue(rtl.DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  fTimer := rtl.dispatch_source_create(rtl.DISPATCH_SOURCE_TYPE_TIMER, 0, 0, lQueue);
  var lRepeatInterval := if fRepeat then (fInterval * rtl.NSEC_PER_MSEC) else 0;
  rtl.dispatch_source_set_timer(fTimer, rtl.dispatch_time(rtl.DISPATCH_TIME_NOW, fInterval * rtl.NSEC_PER_MSEC), lRepeatInterval, 0);
  rtl.dispatch_source_set_event_handler(fTimer, ()->Elapsed(Data));
  rtl.dispatch_resume(fTimer);
  {$ELSEIF WEBASSEMBLY}
  if not fRepeat then
    fTimer := WebAssemblyCalls.SetTimeout(()->Elapsed(Data), fInterval)
  else
    fTimer := WebAssemblyCalls.SetInterval(()->Elapsed(Data), fInterval);
  {$ENDIF}
  fEnabled := true;
end;

method Timer.Stop;
begin
  if not fEnabled then exit;
  {$IFDEF WINDOWS}
  if not rtl.DeleteTimerQueueTimer(fTimerQueue, fTimer, rtl.INVALID_HANDLE_VALUE) then
    raise new Exception('Error cancelling timer');
  fTimer := rtl.INVALID_HANDLE_VALUE;
  {$ELSEIF LINUX OR ANDROID}
  rtl.timer_delete(fTimer);
  {$ELSEIF ISLAND AND DARWIN}
  rtl.dispatch_source_cancel(fTimer);
  {$ELSEIF WEBASSEMBLY}
  if not fRepeat then
    WebAssembly.Global.clearTimeout(fTimer)
  else
    WebAssemblyCalls.ClearInterval(fTimer);
  {$ENDIF}
  fEnabled := false;
end;

method Timer.Dispose;
begin
  {$IFDEF WINDOWS}
  rtl.DeleteTimerQueueEx(fTimerQueue, rtl.INVALID_HANDLE_VALUE);
  {$ELSEIF (LINUX OR ANDROID) OR (ISLAND AND DARWIN)}
  if fEnabled then Stop;
  {$ENDIF}
end;

method Timer.CheckIfEnabled;
begin
  if fEnabled then
    raise new Exception('Can not change properties in enabled timer');
end;

end.