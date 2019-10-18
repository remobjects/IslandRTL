namespace RemObjects.Elements.System;

type
  ManagedThreadPool = class(IDisposable)
  private
    fWakeup: EventWaitHandle;
    fShutdown: Integer; volatile;
    fQueue: List<ThreadPoolCallback>;
    fLock: Monitor;
    fThreads: List<Thread>;
    fMaxThreads: Integer; volatile;
    fMinThreads: Integer; volatile;

    class var Spare: Object;

    method StartThread;
    begin
      var lThread := new Thread(@ThreadMain);
      if Spare = nil then Spare := new Object;
      lThread.Start(lThread);
      fThreads.Add(lThread);
    end;

    method ThreadMain(aParam: Object);
    begin
      loop begin
        if fShutdown = 1 then begin
          fThreads.Remove(Thread(aParam));
          break;
        end;
        var lItem: ThreadPoolCallback := nil;
        locking fLock do begin
          if fQueue.Count = 0 then begin
            if fThreads.Count > fMaxThreads then begin
              fThreads.Remove(Thread(aParam));
              break;
            end;
          end else begin
            lItem := fQueue[0];
            fQueue.RemoveAt(0);
          end;
        end;
        if lItem <> nil then begin
          lItem.fCallback(lItem.fState);
        end else
          fWakeup.Wait;
      end;
    end;

  public
    property MaxThreads: Integer read fMaxThreads write fMaxThreads;
    property MinThreads: Integer read fMinThreads write fMinThreads;

    constructor;
    begin
      fWakeup := new EventWaitHandle(true, false);
      fQueue := new List<ThreadPoolCallback>;
      fThreads := new List<Thread>;
      fLock := new Monitor;
      fMaxThreads := 5;
      fMinThreads := 2;
    end;

    method Queue(aCallback: ThreadPoolCallback);
    begin
      locking fLock do begin
        fQueue.Add(aCallback);
        if fThreads.Count = 0 then StartThread;
        if (fQueue.Count > 0) and (fThreads.Count < fMaxThreads) then StartThread;
      end;
      fWakeup.Set;
    end;

    method Dispose;
    begin
      fShutdown := 1;
      loop begin
        locking fLock do
          if fThreads.Count = 0 then break;
        fWakeup.Set;
        Thread.Sleep(1);
      end;
      fLock.Dispose;
      fWakeup.Dispose;
    end;
  end;

end.