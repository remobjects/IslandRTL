namespace RemObjects.Elements.System;

interface

type
  Process = public class
  private
    fWorkingDirectory: String;
    {$IF WINDOWS}
    fStartUpInfo: rtl.STARTUPINFO;
    fProcessInfo: rtl.PROCESS_INFORMATION;
    fOutputHandle: rtl.HANDLE;
    fOutputReadHandle: rtl.HANDLE;
    fErrorHandle: rtl.HANDLE;
    fErrorReadHandle: rtl.HANDLE;
    fWaitHandle: rtl.HANDLE;
    method StartAsync(completionHandler: block);
    method AsyncWaitHandler(TimerOrEnd: Boolean);
    {$ENDIF}
    method Prepare;
    method GetIsRunning: Boolean;
    method GetStandardOutput: String;
    method GetStandardError: String;
    method GetExitCode: Integer;
  public
    constructor;
    constructor(aCommand: String; aArguments: List<String>; aEnvironment: Dictionary<String, String>; aWorkingDirectory: String);
    class method Run(aCommand: not nullable String; aArguments: List<String> := nil; aEnvironment: nullable Dictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; out aStdOut: String; out aStdErr: String): Integer;
    class method RunAsync(aCommand: not nullable String; aArguments: List<String> := nil; aEnvironment: nullable Dictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; aStdOutCallback: block(aLine: String); aStdErrCallback: block(aLine: String) := nil; aFinishedCallback: block(aExitCode: Integer) := nil): Process;
    method WaitFor;
    method Start: Boolean;
    method Stop;
    property ExitCode: Integer read GetExitCode;
    property IsRunning: Boolean read GetIsRunning;
    property Command: String;
    property Arguments: List<String>;
    property Environment: Dictionary<String, String>;
    property WorkingDirectory: String read fWorkingDirectory;
    property StandardOutput: String read GetStandardOutput;
    property StandardError: String read GetStandardError;
    property RedirectOutput: Boolean := false;
  end;

implementation

constructor Process;
begin
  Arguments := new List<String>();
  Environment := new Dictionary<String, String>;
end;

constructor Process(aCommand: String; aArguments: List<String>; aEnvironment: Dictionary<String, String>; aWorkingDirectory: String);
begin
  Command := aCommand;
  Arguments := if aArguments ≠ nil then aArguments else new List<String>;
  Environment := if aEnvironment ≠ nil then aEnvironment else new Dictionary<String, String>;
  fWorkingDirectory := aWorkingDirectory;
end;

method Process.Prepare;
begin
  {$IF WINDOWS}
  fStartUpInfo.cb := sizeOf(fStartUpInfo);
  fStartUpInfo.lpReserved := nil;
  fStartUpInfo.lpTitle := nil;

  if RedirectOutput then begin
    var lSec: rtl.SECURITY_ATTRIBUTES;
    lSec.nLength := sizeOf(lSec);
    lSec.bInheritHandle := true;
    lSec.lpSecurityDescriptor := nil;
    rtl.CreatePipe(@fOutputReadHandle, @fOutputHandle, @lSec, 0);
    rtl.CreatePipe(@fErrorReadHandle, @fErrorHandle, @lSec, 0);
    fStartUpInfo.dwFlags := rtl.STARTF_USESTDHANDLES;
    fStartUpInfo.hStdInput := rtl.GetStdHandle(rtl.STD_INPUT_HANDLE);
    fStartUpInfo.hStdOutput := fOutputHandle;
    fStartUpInfo.hStdError := fErrorHandle;
  end
  else begin
    fOutputHandle := rtl.HANDLE(-1);
    fErrorHandle := rtl.HANDLE(-1);
  end;
  {$ENDIF}
end;

method Process.GetIsRunning: Boolean;
begin
  {$IF WINDOWS}
  result := rtl.WaitForSingleObject(fProcessInfo.hProcess, 0) = rtl.WAIT_TIMEOUT;
  {$ENDIF}
end;

method Process.GetStandardOutput: String;
begin
  {$IF WINDOWS}
  var lRes: Boolean;
  var lBytesRead: rtl.DWORD;
  var lBuffer := new AnsiChar[255];
  repeat
    lRes := rtl.ReadFile(fOutputHandle, lBuffer, 255, @lBytesRead, nil);
    if lBytesRead > 0 then
    begin
      lBuffer[lBytesRead] := #0;
      result := result + lBuffer;
    end;
  until not lRes or (lBytesRead = 0);
  {$ENDIF}
end;

method Process.GetStandardError: String;
begin
  {$IF WINDOWS}
  var lRes: Boolean;
  var lBytesRead: rtl.DWORD;
  var lBuffer := new AnsiChar[255];
  repeat
    lRes := rtl.ReadFile(fErrorHandle, lBuffer, 255, @lBytesRead, nil);
    if lBytesRead > 0 then
    begin
      lBuffer[lBytesRead] := #0;
      result := result + lBuffer;
    end;
  until not lRes or (lBytesRead = 0);
  {$ENDIF}
end;

method Process.GetExitCode: Integer;
begin
  {$IF WINDOWS}
  var lExitCode: rtl.DWORD;
  rtl.GetExitCodeProcess(fProcessInfo.hProcess, @lExitCode);
  result := lExitCode;
  {$ENDIF}
end;

class method Process.Run(aCommand: not nullable String; aArguments: List<String> := nil; aEnvironment: nullable Dictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; out aStdOut: String; out aStdErr: String): Integer;
begin
  var lProcess := new Process(aCommand, aArguments, aEnvironment, aWorkingDirectory);
  lProcess.RedirectOutput := True;
  lProcess.Prepare;
  lProcess.Start;
  lProcess.WaitFor;
  aStdOut := lProcess.StandardOutput;
  aStdErr := lProcess.StandardError;
end;

class method Process.RunAsync(aCommand: not nullable String; aArguments: List<String> := nil; aEnvironment: nullable Dictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; aStdOutCallback: block(aLine: String); aStdErrCallback: block(aLine: String) := nil; aFinishedCallback: block(aExitCode: Integer) := nil): Process;
begin
  var lProcess := new Process(aCommand, aArguments, aEnvironment, aWorkingDirectory);
  lProcess.RedirectOutput := True;
  lProcess.Prepare;
  {$IFDEF WINDOWS}

  {$ENDIF}
end;

method Process.WaitFor;
begin
  {$IF WINDOWS}
  rtl.WaitForSingleObject(fProcessInfo.hProcess, rtl.INFINITE);
  {$ENDIF}
end;

method Process.Start: Boolean;
begin
  {$IF WINDOWS}
  Prepare;
  var lCommand := Command.ToCharArray(true);
  var lArgsPointer: rtl.LPWSTR;

  if Arguments.Count > 0 then begin
    var lArguments := String.Join(' ', Arguments).ToCharArray(true);
    lArgsPointer := @lArguments[0];
  end
  else
    lArgsPointer := nil;

  var lWorkingDirPointer: rtl.LPWSTR;
  if WorkingDirectory ≠ '' then begin
    var lWorkDir := WorkingDirectory.ToCharArray(true);
    lWorkingDirPointer := @lWorkDir[0];
  end
  else
    lWorkingDirPointer := nil;

  result := rtl.CreateProcess(@lCommand[0], lArgsPointer, nil, nil, true, 0, nil, lWorkingDirPointer, @fStartUpInfo, @fProcessInfo);
  if RedirectOutput then begin
    rtl.CloseHandle(fOutputReadHandle);
    rtl.CloseHandle(fErrorReadHandle);
  end;
  {$ENDIF}
end;

method Process.Stop;
begin
  {$IF WINDOWS}
  rtl.TerminateProcess(fProcessInfo.hProcess, -1);
  {$ENDIF}
end;

{$IF WINDOWS}
method Process.StartAsync(completionHandler: block);
begin
  Start;
  rtl.RegisterWaitForSingleObject(@fWaitHandle, fProcessInfo.hProcess, (o, b)-> begin var lObject := InternalCalls.Cast<Process>(o); lObject.AsyncWaitHandler(Boolean(b)); end, InternalCalls.Cast(self), 100, 0);
end;

method Process.AsyncWaitHandler(TimerOrEnd: Boolean);
begin

end;
{$ENDIF}

end.