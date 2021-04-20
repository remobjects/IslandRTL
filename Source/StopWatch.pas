namespace RemObjects.Elements.System;

interface

type
  StopWatch = public class
  private
    fStartTicks : Int64;
    fEndTicks : Int64;
    fIsRunning : Boolean;
    method getElapsed( Milliseconds: Boolean) : Int64;
  protected
  public
    constructor;
    method Start;
    method Stop;
    method Reset;
    property ElapsedTicks: Int64 read getElapsed( false );
    property ElapsedMilliseconds: Int64 read getElapsed( true );
    property IsRunning: Boolean read fIsRunning;
  end;

implementation

constructor StopWatch;
begin
end;

method StopWatch.Start;
begin
  fIsRunning := true;
  fEndTicks := 0;
  fStartTicks := DateTime.UtcNow.Ticks;
end;

method StopWatch.Stop;
begin
  fEndTicks := DateTime.UtcNow.Ticks;
  fIsRunning := false;
end;

method StopWatch.Reset;
begin
  fStartTicks := 0;
  fEndTicks := 0;
  fIsRunning := false;
end;

method StopWatch.getElapsed(Milliseconds : Boolean): Int64;
begin
  if fIsRunning then
    result := DateTime.UtcNow.Ticks - fStartTicks
  else
    result := fEndTicks - fStartTicks;

  if Milliseconds and (result > 0) then
    result := result / 10 000;
end;

end.