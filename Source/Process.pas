namespace RemObjects.Elements.System;

interface

type
  Process = public class
  private
    fWorkingDirectory: String;
    fFinishedBlock: block(aExitCode: Integer);
    fOutputDataBlock: block(aLine: String);
    fErrorDataBlock: block(aLine: String);
    fId: Integer := -1;
    {$IF WINDOWS}
    fStartUpInfo: rtl.STARTUPINFO;
    fProcessInfo: rtl.PROCESS_INFORMATION;
    fOutputHandle: rtl.HANDLE;
    fOutputReadHandle: rtl.HANDLE;
    fErrorHandle: rtl.HANDLE;
    fErrorReadHandle: rtl.HANDLE;
    fWaitHandle: rtl.HANDLE := rtl.HANDLE(-1);
    method StartAsync(aStdOutCallback: block(aLine: String); aErrorCallback: block(aLine: String); aFinishedCallback: block(ExitCode: Integer));
    method GetCurrentOutput(StdOutput: Boolean): String;
    class method WaitHandler(aObject: ^Void; TimerOrEnd: Byte); static;
    {$ELSEIF POSIX AND NOT IOS}
    fOutput: String := '';
    fErr: String := '';
    fProcessId: {$IF MACOS}rtl.pid_t{$ELSE}rtl.__pid_t{$ENDIF};
    fOutPipe: array[0..1] of Int32;
    fErrPipe: array[0..1] of Int32;
    method StartAsync(aStdOutCallback: block(aLine: String); aErrorCallback: block(aLine: String); aFinishedCallback: block(ExitCode: Integer));
    method WaitForAsync;
    {$ENDIF}
    {$IF WINDOWS OR (POSIX AND NOT IOS)}
    fLastIncompleteOutputLog: String := '';
    fLastIncompleteErrorLog: String := '';
    method ProcessStdOutData(rawString: String; aOutput: Boolean; callback: block(aLine: String));
    {$ENDIF}
    method Prepare;
    method GetIsRunning: Boolean;
    method GetStandardOutput: String;
    method GetStandardError: String;
    method GetExitCode: Integer;
    method CleanUp;
  public
    constructor;
    constructor(aCommand: String; aArguments: ImmutableList<String>; aEnvironment: ImmutableDictionary<String, String>; aWorkingDirectory: String);
    class method Run(aCommand: not nullable String; aArguments: ImmutableList<String> := nil; aEnvironment: nullable ImmutableDictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; out aStdOut: String; out aStdErr: String): Integer;
    class method RunAsync(aCommand: not nullable String; aArguments: ImmutableList<String> := nil; aEnvironment: nullable ImmutableDictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; aStdOutCallback: block(aLine: String); aStdErrCallback: block(aLine: String) := nil; aFinishedCallback: block(aExitCode: Integer) := nil): Process;
    class method CurrentProcessId: Integer;
    method WaitFor;
    method Start: Boolean;
    method Stop;
    property ExitCode: Integer read GetExitCode;
    property IsRunning: Boolean read GetIsRunning;
    property Command: String;
    property Arguments: ImmutableList<String>;
    property Environment: ImmutableDictionary<String, String>;
    property WorkingDirectory: String read fWorkingDirectory;
    property StandardOutput: String read GetStandardOutput;
    property StandardError: String read GetStandardError;
    property RedirectOutput: Boolean := false;
    property Id: Integer read fId;
    // for RunAsync
    property OnFinished: block(ExitCode: Integer) read fFinishedBlock;
    property OnOutputData: block(aLine: String) read fOutputDataBlock;
    property OnErrorData: block(aLine: String) read fErrorDataBlock;
  end;

implementation

constructor Process;
begin
  Arguments := new ImmutableList<String>();
  Environment := new ImmutableDictionary<String, String>;
end;

constructor Process(aCommand: String; aArguments: ImmutableList<String>; aEnvironment: ImmutableDictionary<String, String>; aWorkingDirectory: String);
begin
  Command := aCommand;
  Arguments := if aArguments ≠ nil then aArguments else new ImmutableList<String>;
  Environment := if aEnvironment ≠ nil then aEnvironment else new ImmutableDictionary<String, String>;
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
  {$ELSEIF POSIX AND NOT IOS}
  if RedirectOutput then begin
    if rtl.pipe(fOutPipe) = -1 then
      raise new Exception('Can not create handles to redirect output');
  end;
  {$ENDIF}
end;

method Process.GetIsRunning: Boolean;
begin
  {$IF WINDOWS}
  result := rtl.WaitForSingleObject(fProcessInfo.hProcess, 0) = rtl.WAIT_TIMEOUT;
  {$ELSEIF POSIX AND NOT IOS}
  result := rtl.kill(fProcessId, 0) = 0;
  {$ENDIF}
end;

method Process.GetStandardOutput: String;
begin
  {$IF WINDOWS}
  var lRes: Boolean;
  var lPipeRes: Boolean;
  var lBytesRead: rtl.DWORD;
  var lBytesTotal: rtl.DWORD;
  result := '';
  var lBuffer := new AnsiChar[256];

  repeat
    lPipeRes := rtl.PeekNamedPipe(fOutputReadHandle, nil, 0, nil, @lBytesTotal, nil);
    if (not lPipeRes) or (lBytesTotal = 0) then
      break;
    lRes := rtl.ReadFile(fOutputReadHandle, lBuffer, 255, @lBytesRead, nil);

    if lBytesRead > 0 then
    begin
      lBuffer[lBytesRead] := #0;
      result := result + String.FromPAnsiChars(@lBuffer[0]);
    end;
  until (not lRes) or (lBytesRead = 0);
  {$ELSEIF POSIX AND NOT IOS}
  if fOutput = '' then begin
    var lBuffer := new AnsiChar[1024];
    while(true) do begin
      var lCount := rtl.read(fOutPipe[0], @lBuffer[0], sizeOf(lBuffer));
      if lCount = 0 then
        break;
      if lCount > 0 then
        fOutput := fOutput + String.FromPAnsiChars(@lBuffer[0], lCount);
    end;
  end;
  result := fOutput;
  {$ENDIF}
end;

method Process.GetStandardError: String;
begin
  {$IF WINDOWS}
  var lRes: Boolean;
  var lPipeRes: Boolean;
  var lBytesRead: rtl.DWORD;
  var lBytesTotal: rtl.DWORD;
  var lBuffer := new AnsiChar[256];
  result := '';

  repeat
    lPipeRes := rtl.PeekNamedPipe(fErrorHandle, nil, 0, nil, @lBytesTotal, nil);
    if (not lPipeRes) or (lBytesTotal = 0) then
      break;
    lRes := rtl.ReadFile(fErrorHandle, lBuffer, 255, @lBytesRead, nil);

    if lBytesRead > 0 then
    begin
      lBuffer[lBytesRead] := #0;
      result := result + String.FromPAnsiChars(@lBuffer[0]);
    end;
  until not lRes or (lBytesRead = 0);
  {$ELSEIF POSIX AND NOT IOS}
  if fErr = '' then begin
    var lBuffer := new AnsiChar[1024];
    while(true) do begin
      var lCount := rtl.read(fErrPipe[0], @lBuffer[0], sizeOf(lBuffer));
      if lCount = 0 then
        break;
      if lCount > 0 then
        fErr := fErr + String.FromPAnsiChars(@lBuffer[0], lCount);
    end;
  end;
  result := fErr;
  {$ENDIF}
end;

method Process.GetExitCode: Integer;
begin
  {$IF WINDOWS}
  var lExitCode: rtl.DWORD;
  rtl.GetExitCodeProcess(fProcessInfo.hProcess, @lExitCode);
  result := lExitCode;
  {$ELSEIF POSIX AND NOT IOS}
  var lStatus: Int32;
  rtl.waitpid(fProcessId, @lStatus, rtl.WNOHANG);
  if (lStatus and $0177) = 0 then
    result := lStatus shr 8
  else
    result := 0;
  {$ENDIF}
end;

class method Process.Run(aCommand: not nullable String; aArguments: ImmutableList<String> := nil; aEnvironment: nullable ImmutableDictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; out aStdOut: String; out aStdErr: String): Integer;
begin
  var lProcess := new Process(aCommand, aArguments, aEnvironment, aWorkingDirectory);
  lProcess.RedirectOutput := True;
  lProcess.Prepare;
  lProcess.Start;
  lProcess.WaitFor;
  aStdOut := lProcess.StandardOutput;
  aStdErr := lProcess.StandardError;
  lProcess.CleanUp;
end;

class method Process.RunAsync(aCommand: not nullable String; aArguments: ImmutableList<String> := nil; aEnvironment: nullable ImmutableDictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; aStdOutCallback: block(aLine: String); aStdErrCallback: block(aLine: String) := nil; aFinishedCallback: block(aExitCode: Integer) := nil): Process;
begin
  result := new Process(aCommand, aArguments, aEnvironment, aWorkingDirectory);
  result.RedirectOutput := True;
  result.Prepare;
  {$IFDEF WINDOWS OR (POSIX AND NOT IOS)}
  result.StartAsync(aStdOutCallback, aStdErrCallback, aFinishedCallback);
  {$ENDIF}
end;

class method Process.CurrentProcessId: Integer;
begin
  {$IF WINDOWS}
  result := rtl.GetCurrentProcessId;
  {$ELSEIF POSIX AND NOT IOS}
  result := rtl.getpid();
  {$ENDIF}
end;

method Process.WaitFor;
begin
  {$IF WINDOWS}
  rtl.WaitForSingleObject(fProcessInfo.hProcess, rtl.INFINITE);
  {$ELSEIF POSIX AND NOT IOS}
  if RedirectOutput then begin
    GetStandardOutput;
    GetStandardError;
  end;

  var lStatus: Int32;
  rtl.waitpid(fProcessId, @lStatus, 0);
  {$ENDIF}
end;

method Process.Start: Boolean;
begin
  {$IF WINDOWS}
  Prepare;
  var lCommand := Command.ToCharArray(true);
  var lArgsPointer: rtl.LPWSTR;
  var lArguments: array of Char;

  if Arguments.Count > 0 then begin
    lArguments := (Command + ' ' + String.Join(' ', Arguments)).ToCharArray(true);
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

  fWaitHandle := rtl.HANDLE(-1);
  result := rtl.CreateProcess(@lCommand[0], lArgsPointer, nil, nil, true, 0, nil, lWorkingDirPointer, @fStartUpInfo, @fProcessInfo);
  if result then
    fId := fProcessInfo.dwProcessId;
  {$ELSEIF POSIX AND NOT IOS}
  Prepare;
  var lCommand := Command.ToAnsiChars(true);

  var lArgs := new ^AnsiChar[Arguments.Count + 2];
  lArgs[0] := @lCommand[0];
  for i: Integer := 0 to Arguments.Count - 1 do
    lArgs[i+1] := @Arguments[i].ToAnsiChars(true)[0];
  lArgs[Arguments.Count] := nil;

  var lEnvp := new ^AnsiChar[Environment.Count + 1];
  var i: Integer := 0;
  for each lItem in Environment do begin
    lEnvp[i] := @(lItem.Key + '=' + lItem.Value).ToAnsiChars(true)[0];
    inc(i);
  end;
  lEnvp[Arguments.Count] := nil;

  fProcessId := rtl.fork();
  if fProcessId = 0 then begin
    if RedirectOutput then begin
      rtl.dup2(fOutPipe[1], rtl.STDOUT_FILENO);
      rtl.close(fOutPipe[0]);
      rtl.dup2(fErrPipe[1], rtl.STDERR_FILENO);
      rtl.close(fErrPipe[0]);
    end;

    rtl.execve(lCommand, @lArgs[0], @lEnvp[0]);
    rtl.exit(rtl.EXIT_FAILURE);
  end
  else begin
    fId := fProcessId;
    if RedirectOutput then begin
      rtl.close(fOutPipe[1]);
      rtl.close(fErrPipe[1]);
    end;
  end;
  {$ENDIF}
end;

method Process.Stop;
begin
  {$IF WINDOWS}
  rtl.TerminateProcess(fProcessInfo.hProcess, -1);
  {$ELSEIF POSIX AND NOT IOS}
  rtl.kill(fProcessId, rtl.SIGKILL);
  {$ENDIF}
end;

method Process.CleanUp;
begin
  {$IF WINDOWS}
  if fWaitHandle ≠ rtl.HANDLE(-1) then
    rtl.UnregisterWait(fWaitHandle);
  rtl.CloseHandle(fProcessInfo.hProcess);
  rtl.CloseHandle(fProcessInfo.hThread);
  if RedirectOutput then begin
    rtl.CloseHandle(fOutputHandle);
    rtl.CloseHandle(fOutputReadHandle);
    rtl.CloseHandle(fErrorHandle);
    rtl.CloseHandle(fErrorReadHandle);
  end;
  {$ELSEIF POSIX AND NOT IOS}
  if RedirectOutput then begin
    rtl.close(fOutPipe[0]);
    rtl.close(fErrPipe[0]);
  end;
  {$ENDIF}
end;

{$IF WINDOWS}
method Process.StartAsync(aStdOutCallback: block(aLine: String); aErrorCallback: block(aLine: String); aFinishedCallback: block(ExitCode: Integer));
begin
  fFinishedBlock := aFinishedCallback;
  fOutputDataBlock := aStdOutCallback;
  fErrorDataBlock := aErrorCallback;
  Start;
  rtl.RegisterWaitForSingleObject(@fWaitHandle, fProcessInfo.hProcess, @WaitHandler, InternalCalls.Cast(self), 333, 0);
end;

method Process.GetCurrentOutput(StdOutput: Boolean): String;
begin
  var lHandle := if StdOutput then fOutputReadHandle else fErrorReadHandle;
  var lBytesRead: rtl.DWORD;
  var lBytesTotal: rtl.DWORD;
  result := '';

  rtl.PeekNamedPipe(lHandle, nil, 0, nil, @lBytesTotal, nil);
  if lBytesTotal > 0 then begin
    var lBuffer := new AnsiChar[lBytesTotal + 1];
    lBuffer[lBytesTotal] := #0;
    if rtl.ReadFile(fOutputReadHandle, lBuffer, lBytesTotal, @lBytesRead, nil) then
      result := result + String.FromPAnsiChars(@lBuffer[0]);
  end;
end;

[CallingConvention(CallingConvention.Stdcall)]
class method Process.WaitHandler(aObject: ^Void; TimerOrEnd: Byte);
begin
  var lProcess := InternalCalls.Cast<Process>(aObject);
  var lOutput := lProcess.GetCurrentOutput(true);
  lProcess.ProcessStdOutData(lOutput, true, lProcess.OnOutputData);

  lOutput := lProcess.GetCurrentOutput(false);
  lProcess.ProcessStdOutData(lOutput, false, lProcess.OnErrorData);

  if not Boolean(TimerOrEnd) then begin
    if lProcess.OnFinished ≠ nil then
      lProcess.OnFinished(lProcess.ExitCode);
    lProcess.CleanUp;
  end;
end;
{$ELSEIF POSIX AND NOT IOS}
method Process.StartAsync(aStdOutCallback: block(aLine: String); aErrorCallback: block(aLine: String); aFinishedCallback: block(ExitCode: Integer));
begin
  fFinishedBlock := aFinishedCallback;
  fOutputDataBlock := aStdOutCallback;
  fErrorDataBlock := aErrorCallback;
  Start;
  Task.Run(()-> begin WaitForAsync; fFinishedBlock(ExitCode); end);
end;

method Process.WaitForAsync;
begin
  if RedirectOutput then begin
    var lBuffer := new AnsiChar[1024];
    var lOutput: String := '';
    while(true) do begin
      var lCount := rtl.read(fOutPipe[0], @lBuffer[0], sizeOf(lBuffer));
      if lCount = 0 then
        break;
      if lCount > 0 then
        lOutput := lOutput + String.FromPAnsiChars(@lBuffer[0], lCount);

      ProcessStdOutData(lOutput, true, OnOutputData);
    end;

    while(true) do begin
      var lCount := rtl.read(fErrPipe[0], @lBuffer[0], sizeOf(lBuffer));
      if lCount = 0 then
        break;
      if lCount > 0 then
        lOutput := lOutput + String.FromPAnsiChars(@lBuffer[0], lCount);

      ProcessStdOutData(lOutput, false, OnErrorData);
    end;
  end;

  var lStatus: Int32;
  rtl.waitpid(fProcessId, @lStatus, 0);
end;
{$ENDIF}

{$IF WINDOWS OR (POSIX AND NOT IOS)}
method Process.ProcessStdOutData(rawString: String; aOutput: Boolean; callback: block(aLine: string));
begin
  var lString: String;
  if aOutput then begin
    lString := fLastIncompleteOutputLog + rawString;
    fLastIncompleteOutputLog := '';
  end
  else begin
    lString := fLastIncompleteErrorLog + rawString;
    fLastIncompleteErrorLog := '';
  end;

  var lLines := lString.Split(RemObjects.Elements.System.Environment.NewLine);
  for i: Int32 := 0 to lLines.Count - 1 do begin
    var s := lLines[i];
    if (i = lLines.Count - 1) and not s.EndsWith(RemObjects.Elements.System.Environment.NewLine) then begin
      if length(s) > 0 then begin
        if aOutput then
          fLastIncompleteOutputLog := s
        else
          fLastIncompleteErrorLog := s
      end
      else
        break;
    end;
    if callback ≠ nil then
      callback(s);
  end;
end;
{$ENDIF}

end.