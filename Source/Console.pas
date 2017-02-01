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
{$ELSE}
  var c := s.ToAnsiChars(true);
  rtl.printf("%s", @c[0]);
 {$ENDIF}
end;

class method Console.WriteLine(s: String);
begin
  if s = nil then s := '';
  {$IFDEF WINDOWS}
  Write(s + Environment.NewLine);
  {$ELSE}
  var c := s.ToAnsiChars(true);
  rtl.puts(@c[0]);
 {$ENDIF}
end;

class method Console.WriteLine;
begin
  WriteLine('');
end;

class method Console.Write(s: Object);
begin
  if s = nil then s := '';
  &Write(s.ToString);
end;

class method Console.WriteLine(s: Object);
begin
  if s = nil then s := '';
  &WriteLine(s.ToString);
end;

class method Console.ReadLine: String;
begin
  var r: String := '';
  var bufsize := 255;
  var offset := 0;
  var buf: array[0..255] of AnsiChar;
  while true do begin
    var ch := ReadChar();
    if ch = #0 then break; // problem with Read
    if ch = #13 then break; //CR was detected
    buf[offset] := ch;
    inc(offset);
    if offset > bufsize then begin
      r := r + String.FromPAnsiChars(@buf[0], bufsize);
      offset := 0;
    end;
  end;
  if offset > 0 then
    r := r + String.FromPAnsiChars(@buf[0], offset);
  exit r;
end;

class method Console.ReadChar: AnsiChar;
begin
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
  {$ELSE}
  rtl.scanf("%c", @ch[0]);
 {$ENDIF}
  exit ch[0];
end;

end.