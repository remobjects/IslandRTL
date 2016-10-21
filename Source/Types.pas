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
    class method Throw(s: string);
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
  if Assigned(obj) and (obj is Boolean) then
    exit self = Boolean(obj)
  else
    exit False;
end;

method Char.ToString: String;
begin
  exit string(self);
end;

method Char.GetHashCode: Integer;
begin
  exit Integer(self);
end;

method Char.&Equals(obj: Object): Boolean;
begin
  if Assigned(obj) and (obj is Char) then
    exit self = Char(obj)
  else
    exit False;
end;

method AnsiChar.ToString: String;
begin
  exit string(char(self));
end;

method AnsiChar.GetHashCode: Integer;
begin
  exit Integer(self);
end;

method AnsiChar.&Equals(obj: Object): Boolean;
begin
  if Assigned(obj) and (obj is AnsiChar) then
    exit self = AnsiChar(obj)
  else
    exit False;
end;

end.