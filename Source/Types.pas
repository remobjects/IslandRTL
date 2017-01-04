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
    class method Assert(aFail: Boolean; aMessage: String; aFile: String := currentFilename(); aLine: Integer := currentLineNumber());
    begin
      if aFail then
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