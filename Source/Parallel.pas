namespace RemObjects.Elements.System;
{$IFNDEF NOTHREADS}
type
  ParallelLoopState = public class
  private
  public
    property IsStopped: Boolean read private write;
    method &Break;
    begin
      IsStopped := True;
    end;
  end;


  &Parallel = static public class
  public
    class method &For(fromInclusive: Integer; toExclusive: Integer; body: Action<Integer,ParallelLoopState>);
    begin
      var list := new List<Integer>;
      for i: Integer :=  fromInclusive to toExclusive - 1 do
        list.Add(i);
      ForEach<Integer>(list,body);      
    end;


    class method &For(fromInclusive: Int64; toExclusive: Int64; body: Action<Int64,ParallelLoopState>);
    begin
      var list := new List<Int64>;
      for i: Integer :=  fromInclusive to toExclusive - 1 do
        list.Add(i);
      ForEach<Int64>(list,body);      
    end;

    class method ForEach<TSource>(source: IEnumerable<TSource>; body: Action<TSource,ParallelLoopState>);
    begin
      var lthreadcnt := Environment.ProcessorCount;
      var lcurrTasks: Integer := 0;
      var levent := new EventWaitHandle(true, false);
      var ls:= new ParallelLoopState();
      for m in source do begin
        while InternalCalls.Add(var lcurrTasks, 0) >= lthreadcnt do begin
          if ls.IsStopped then Break;
          levent.Wait;
        end;
        if ls.IsStopped then Break;
        InternalCalls.Add(var lcurrTasks, 1);
        new Task(->
          begin
            body(m, ls);
            InternalCalls.Add(var lcurrTasks, -1);
            levent.Set;
          end).Start;
      end;
      while InternalCalls.Add(var lcurrTasks, 0) > 0 do levent.Wait;
    end;
  end;

{$ENDIF}
end.