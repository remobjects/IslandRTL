namespace RemObjects.Elements.System;

interface

type
  ValueType = public abstract class
  end;

  &Enum = public abstract class
  end;

  Void = public record
  public
    method ToString: String; override; empty; // not callable
    method GetHashCode: Integer; override; empty; // not callable
  end;

  Boolean = public record
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
  end;

  Char = public record
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    class method IsWhiteSpace(aChar: Char): Boolean;
    class method IsNumber(aChar: Char): Boolean;
    method ToLower(aInvariant: Boolean := false): Char;
    method ToUpper(aInvariant: Boolean := false): Char;
  end;

  AnsiChar = public record
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
  end;

  Debug = public static class
  public
    [Conditional('DEBUG')]
    class method Assert(aCheck: Boolean; aMessage: String; aFile: String := currentFileName(); aLine: Integer := currentLineNumber());
    begin
      if not aCheck then
        raise new AssertionException('Assertion failed: '+aMessage+' at '+aFile+'('+aLine+')');
    end;
    class method Throw(s: String);
    begin
      raise new Exception(s);
    end;
  end;

implementation

method Boolean.ToString: String;
begin
  exit if self then 'True' else 'False';
end;

method Boolean.GetHashCode: Integer;
begin
  exit if self then 1 else 0;
end;

method Boolean.&Equals(obj: Object): Boolean;
begin
  if assigned(obj) and (obj is Boolean) then
    exit self = Boolean(obj)
  else
    exit False;
end;

method Char.ToString: String;
begin
  exit String(self);
end;

method Char.GetHashCode: Integer;
begin
  exit Integer(self);
end;

method Char.&Equals(obj: Object): Boolean;
begin
  if assigned(obj) and (obj is Char) then
    exit self = Char(obj)
  else
    exit False;
end;

class method Char.IsWhiteSpace(aChar: Char): Boolean;
begin
  // from https://msdn.microsoft.com/en-us/library/system.Char.iswhitespace%28v=vs.110%29.aspx
  exit Word(aChar) in
        ($0020, $1680, $2000, $2001, $2002, $2003, $2004, $2005, $2006, $2007, $2008, $2009, $200A, $202F, $205F, $3000, //space separators
         $2028, //Line Separator
         $2029, //Paragraph Separator
         $0009, $000A, $000B, $000C, $000D,$0085,$00A0 // other special symbols
        );
end;

class method Char.IsNumber(aChar: Char): Boolean;
begin
  exit aChar in ['0'..'9'];
end;

method Char.ToLower(aInvariant: Boolean := false): Char;
begin
  {$IFDEF WINDOWS}
  //exit doLCMapString(aInvariant, LCMapStringTransformMode.Lower);
  {$ELSEIF POSIX}
  {$HINT Non-Invariant ToLower is not implemented for Linux, yet}
  var b := TextConvert.StringToUTF32LE(self);
  var ch := b[0] + (Int32(b[1]) shl 8) + (Int32(b[2]) shl 16) + (Int32(b[3]) shl 24);
  var u := rtl.towlower(ch);
  b[0] := u and $ff;
  b[1] := (u shr 8) and $ff;
  b[2] := (u shr 16) and $ff;
  b[3] := (u shr 25) and $ff;
  result := TextConvert.UTF32LEToString(b)[0];
  {$ELSE}
  {$ERROR Not Implemented}
  {$ENDIF}
end;

method Char.ToUpper(aInvariant: Boolean := false): Char;
begin
  {$IFDEF WINDOWS}
  //exit doLCMapString(aInvariant, LCMapStringTransformMode.Upper);
  {$ELSEIF POSIX}
  {$HINT Non-Invariant ToUpper is not implemented for Linux, yet}
  var b := TextConvert.StringToUTF32LE(self);
  var ch := b[0] + (Int32(b[1]) shl 8) + (Int32(b[2]) shl 16) + (Int32(b[3]) shl 24);
  var u := rtl.towupper(ch);
  b[0] := u and $ff;
  b[1] := (u shr 8) and $ff;
  b[2] := (u shr 16) and $ff;
  b[3] := (u shr 25) and $ff;
  result := TextConvert.UTF32LEToString(b)[0];
  {$ELSE}
  {$ERROR Not Implemented}
  {$ENDIF}
end;

method AnsiChar.ToString: String;
begin
  exit String(Char(self));
end;

method AnsiChar.GetHashCode: Integer;
begin
  exit Integer(self);
end;

method AnsiChar.&Equals(obj: Object): Boolean;
begin
  if assigned(obj) and (obj is AnsiChar) then
    exit self = AnsiChar(obj)
  else
    exit False;
end;

end.