namespace RemObjects.Elements.System;

interface

type
  IDisposable = public interface
    method Dispose;
  end;
  Monitor = public class(IDisposable)
  private
    {$IFDEF WINDOWS}
    fCS: rtl.CRITICAL_SECTION;
    {$ELSE}
    fcs: rtl.pthread_mutex_t;
    {$ENDIF}
  public
    constructor;
    method Wait;
    method Release;
    method Dispose;
  end;

  SingleLinkedList<T> = class
  where
    T is class;
  private
    fTail, fHead: SingleLinkedListNode<T>;
    fCount: Integer;
  public
    method AddLast(val: T);
    method RemoveFirst: T;
    property Count: Integer;
  end;

  SingleLinkedListNode<T> = class
  public
    Next: SingleLinkedListNode<T>;
    Value: T;
  end;

implementation

method SingleLinkedList<T>.AddLast(val: T);
begin
  inc(fCount);
  var lNode := new SingleLinkedListNode<T>;
  lNode.Value := val;
  if fTail <> nil then begin
    fTail.Next := lNode;
  end else
    fHead := lNode;
  fTail := lNode;
end;

method SingleLinkedList<T>.RemoveFirst: T;
begin
  if fHead = nil then exit nil;
  dec(fCount);
  result := fHead.Value;
  fHead := fHead.Next;
  if fHead = nil then
    fTail := nil;
end;

constructor Monitor;
begin
  {$IFDEF WINDOWS}
  rtl.InitializeCriticalSection(@fCS);
  {$ELSE}
  var attr: rtl.pthread_mutexattr_t;
  rtl.pthread_mutexattr_init(@attr);
  rtl.pthread_mutexattr_settype(@attr, rtl.PTHREAD_MUTEX_RECURSIVE);
  rtl.pthread_mutex_init(@fcs, @attr);
  {$ENDIF}
end;

method Monitor.Wait;
begin
  {$IFDEF WINDOWS}
  rtl.EnterCriticalSection(@fCS);
  {$ELSE}
  rtl.pthread_mutex_lock(@fcs);
  {$ENDIF}
end;

method Monitor.Release;
begin
  {$IFDEF WINDOWS}
  rtl.LeaveCriticalSection(@fCS);
  {$ELSE}
  rtl.pthread_mutex_unlock(@fcs);
  {$ENDIF}
end;

method Monitor.Dispose;
begin
  {$IFDEF WINDOWS}
  rtl.DeleteCriticalSection(@fCS);
  {$ELSE}
  rtl.pthread_mutex_destroy(@fcs);
  {$ENDIF}
end;

end.