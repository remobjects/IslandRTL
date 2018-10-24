namespace RemObjects.Elements.System;

interface

type
  Process = public class
  private
    fWorkingDirectory: String;
    fFinishedBlock: block(aExitCode: Integer);
    fOutputDataBlock: block(aLine: String);
    fErrorDataBlock: block(aLine: String);
    {$IF WINDOWS}
    fStartUpInfo: rtl.STARTUPINFO;
    fProcessInfo: rtl.PROCESS_INFORMATION;
    fOutputHandle: rtl.HANDLE;
    fOutputReadHandle: rtl.HANDLE;
    fErrorHandle: rtl.HANDLE;
    fErrorReadHandle: rtl.HANDLE;
    fWaitHandle: rtl.HANDLE := rtl.HANDLE(-1);
    fLastIncompleteOutputLog: String := '';
    fLastIncompleteErrorLog: String := '';
    method StartAsync(aStdOutCallback: block(aLine: String); aErrorCallback: block(aLine: String); aFinishedCallback: block(ExitCode: Integer));
    method GetCurrentOutput(StdOutput: Boolean): String;
    class method WaitHandler(aObject: ^Void; TimerOrEnd: Byte); static;
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
    // for RunAsync
    property OnFinished: block(ExitCode: Integer) read fFinishedBlock;
    property OnOutputData: block(aLine: String) read fOutputDataBlock;
    property OnErrorData: block(aLine: String) read fErrorDataBlock;
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
  result := '';
  var lBuffer := new AnsiChar[256];

  repeat
    lRes := rtl.ReadFile(fOutputReadHandle, lBuffer, 255, @lBytesRead, nil);
    if lBytesRead > 0 then
    begin
      lBuffer[lBytesRead] := #0;
      result := result + String.FromPAnsiChars(@lBuffer[0]);
    end;
  until not lRes or (lBytesRead = 0);
  {$ENDIF}
end;

method Process.GetStandardError: String;
begin
  {$IF WINDOWS}
  var lRes: Boolean;
  var lBytesRead: rtl.DWORD;
  var lBuffer := new AnsiChar[256];
  result := '';

  repeat
    lRes := rtl.ReadFile(fErrorHandle, lBuffer, 255, @lBytesRead, nil);
    if lBytesRead > 0 then
    begin
      lBuffer[lBytesRead] := #0;
      result := result + String.FromPAnsiChars(@lBuffer[0]);
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
  lProcess.CleanUp;
end;

class method Process.RunAsync(aCommand: not nullable String; aArguments: List<String> := nil; aEnvironment: nullable Dictionary<String, String> := nil; aWorkingDirectory: nullable String := nil; aStdOutCallback: block(aLine: String); aStdErrCallback: block(aLine: String) := nil; aFinishedCallback: block(aExitCode: Integer) := nil): Process;
begin
  result := new Process(aCommand, aArguments, aEnvironment, aWorkingDirectory);
  result.RedirectOutput := True;
  result.Prepare;
  {$IFDEF WINDOWS}
  result.StartAsync(aStdOutCallback, aStdErrCallback, aFinishedCallback);
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

  fWaitHandle := rtl.HANDLE(-1);
  result := rtl.CreateProcess(@lCommand[0], lArgsPointer, nil, nil, true, 0, nil, lWorkingDirPointer, @fStartUpInfo, @fProcessInfo);
  {$ENDIF}
end;

method Process.Stop;
begin
  {$IF WINDOWS}
  rtl.TerminateProcess(fProcessInfo.hProcess, -1);
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
{$ENDIF}

end.