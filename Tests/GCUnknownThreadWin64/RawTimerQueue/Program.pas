namespace RawTimerQueue;

uses
  RemObjects.Elements.System;

type
  Payload = class
  public
    property Value: Integer;
  end;

[CallingConvention(CallingConvention.Stdcall)]
method RawTimerCallback(lpParam: rtl.PVOID; TimerOrWaitFired: Byte);
begin
  for i: Integer := 0 to 99 do begin
    var p := new Payload(Value := i);
    if p.Value = -1 then
      raise new Exception('unreachable');
  end;
  // The allocation above must register this raw Windows callback thread before collection.
  Utilities.Collect(1);
  rtl.SetEvent(rtl.HANDLE(lpParam));
end;

method Main(args: array of String): Integer;
begin
  var done := rtl.CreateEvent(nil, true, false, nil);
  if done = nil then
    raise new Exception('CreateEvent failed');

  var queue := rtl.CreateTimerQueue;
  if queue = nil then
    raise new Exception('CreateTimerQueue failed');

  var timer: rtl.HANDLE := rtl.INVALID_HANDLE_VALUE;
  if not rtl.CreateTimerQueueTimer(@timer, queue, @RawTimerCallback, done, 1, 0, 0) then
    raise new Exception('CreateTimerQueueTimer failed');

  var wait := rtl.WaitForSingleObject(done, 5000);
  rtl.DeleteTimerQueueTimer(queue, timer, rtl.INVALID_HANDLE_VALUE);
  rtl.CloseHandle(done);

  if wait <> rtl.WAIT_OBJECT_0 then
    raise new Exception('Timer callback did not finish');

  writeLn('ok');
  exit 0;
end;
end.

