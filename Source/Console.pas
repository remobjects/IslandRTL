namespace RemObjects.Elements.System;

interface

type
  Console = public static class
  private
    {$IFDEF WINDOWS}
    class var fOutputHandle: rtl.HANDLE;
    class var fInputHandle: rtl.HANDLE;
    {$ENDIF}
  public
    class method &Write(s: String);
    class method &Write(s: Object);
    class method WriteLine(s: String);
    class method WriteLine(s: Object);
    class method WriteLine();
    class method &Write(); empty;
    class method ReadChar(): AnsiChar;
    class method ReadLine(): String;
    {$IFDEF ANDROID}
    class var AndroidLoggingTag: String := 'Island';
    {$ENDIF}
  end;

implementation

class method Console.Write(s: String);
begin
  if s = nil then exit;
  {$IFDEF WINDOWS}
  if fOutputHandle = nil then
    fOutputHandle := rtl.GetStdHandle(rtl.STD_OUTPUT_HANDLE);
  var c := s.ToAnsiChars;
  var lOff: Integer := 0;
  var l := length(c);
  while l > 0 do begin
    var lOut: rtl.DWORD;
    if not rtl.WriteFile(fOutputHandle, @c[lOff], l, @lOut, nil) then break;
    l := l - lOut;
    lOff := lOff + lOut;
  end;
  {$ELSEIF WebAssembly}
  WebAssemblyCalls.ConsoleLog(@s.fFirstChar, s.Length);
  {$ELSEIF ANDROID}
    WriteLine(s); // android doesn't have a separate write vs writeln.
  {$ELSE}
  var c := s.ToAnsiChars(true);
  rtl.printf("%s", @c[0]);
  {$ENDIF}
end;

class method Console.WriteLine(s: String);
begin
  if s = nil then s := '';
  {$IFDEF WEBASSEMBLY}
  WebAssemblyCalls.ConsoleLog(@s.fFirstChar, s.Length);
  {$ELSEIF WINDOWS}
  &Write(s + Environment.NewLine);
  {$ELSE}
  var c := s.ToAnsiChars(true);
  {$IFDEF ANDROID}
  var tag := AndroidLoggingTag.ToAnsiChars(true);
  rtl.__android_log_write(rtl.android_LogPriority.ANDROID_LOG_INFO, @tag[0], @c[0]);
  {$ELSE}
  rtl.puts(@c[0]);
  {$ENDIF}
  {$ENDIF}
end;

class method Console.WriteLine;
begin
  WriteLine('');
end;

class method Console.Write(s: Object);
begin
  if s ≠ nil then
    &Write(s.ToString);
end;

class method Console.WriteLine(s: Object);
begin
  if s ≠ nil then
    WriteLine(s.ToString)
  else
    WriteLine("");
end;

class method Console.ReadLine: String;
begin
  {$IFNDEF WEBASSEMBLY}
  var lBuffer := new AnsiChar[256];
  var lCount := 0;
  loop begin
    var ch := ReadChar();
    if ch = #0 then
      break; // ReadChar uses #0 for end of input.
    {$IFDEF WINDOWS}
    if ch = #13 then
      continue; // Consume the LF of a Windows line ending too.
    {$ENDIF}
    if ch = #10 then
      break;
    if lCount = length(lBuffer) then begin
      var lLarger := new AnsiChar[length(lBuffer) * 2];
      Array.Copy(lBuffer, lLarger, lCount);
      lBuffer := lLarger;
    end;
    lBuffer[lCount] := ch;
    inc(lCount);
  end;
  if lCount = 0 then
    exit '';
  // Preserve the platform encoding, but never decode a partial character.
  exit String.FromPAnsiChar(@lBuffer[0], lCount);
  {$ENDIF}
end;

class method Console.ReadChar: AnsiChar;
begin
  {$IFNDEF WEBASSEMBLY}
  var ch : array[0..0] of AnsiChar;
  ch[0] := #0;
  {$IFDEF WINDOWS}
  if fInputHandle = nil then begin
    fInputHandle := rtl.GetStdHandle(rtl.STD_INPUT_HANDLE);
  end;
  var cnt: rtl.DWORD := sizeOf(AnsiChar);
  var lin: rtl.DWORD := 0;
  var lres := rtl.ReadFile(fInputHandle, @ch[0], cnt, @lin, nil);
  if not lres then begin
    exit #0;
  end;
  exit ch[0];
  {$ELSE}
  var c := rtl.getchar();
  if c < 0 then exit #0;
  exit AnsiChar(c);
  {$ENDIF}
  {$ENDIF}
end;

end.