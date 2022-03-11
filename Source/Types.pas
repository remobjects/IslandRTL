namespace RemObjects.Elements.System;

interface

type
  va_list = public record
  public
    {$IF WINDOWS}
    val: ^Void;
    {$ELSEIF AARCH64 and not DARWIN}
    __stack, __gr_top, __vr_top: ^Void;
    __gr_offs, __vr_offs: Integer;
    {$ELSEIF x86_64}
    gp_offset, fp_offset: Integer;
    overflow_arg_area: ^Void;
    reg_save_area: ^Void;
    {$ELSE}
    val: ^Void;
    {$ENDIF}
  end;
  ValueType = public abstract class
  end;

  DummyEnum = class(&Enum) public fValue: Integer; end;
  Dummy64Enum = class(&Enum) public fValue: Int64; end;

  &Enum = public abstract class(IComparable)
  public
    property EnumSize: Integer
      read self.GetType.SizeOfType;
    method GetHashCode: Integer; override;
    begin
      var lSelf := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(self));
      case EnumSize of
        1: exit ^Byte(@lSelf.fValue)^;
        2: exit ^Word(@lSelf.fValue)^;
        4: exit ^Int32(@lSelf.fValue)^;
        8: exit InternalCalls.Cast<Dummy64Enum>(InternalCalls.Cast(self)).fValue;
      end;
    end;

    method ToInt64: Int64;
    begin
      var lSelf := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(self));
      case EnumSize of
        1: exit ^Byte(@lSelf.fValue)^;
        2: exit ^Word(@lSelf.fValue)^;
        4: exit ^Int32(@lSelf.fValue)^;
        8: exit InternalCalls.Cast<Dummy64Enum>(InternalCalls.Cast(self)).fValue;
      end;
    end;

    method CompareTo(a: Object): Integer;
    begin
      if a is &Enum then
        exit CompareTo(&Enum(a));
      exit CompareTo(a);
    end;

    method CompareTo(a: &Enum): Integer;
    begin
      exit self.ToInt64.CompareTo(a.ToInt64);
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin
      if aOther = nil then exit false;
      if aOther.GetType <> GetType then exit false;

      case EnumSize of
        1: begin
            var lSelf := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(self));
            var lOther := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(aOther));
            exit ^Byte(@lSelf.fValue)^ = ^Byte(@lOther.fValue)^;
          end;
        2: begin
            var lSelf := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(self));
            var lOther := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(aOther));
            exit ^Int16(@lSelf.fValue)^ = ^Int16(@lOther.fValue)^;
          end;
        4: begin
            var lSelf := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(self));
            var lOther := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(aOther));
            exit ^Int32(@lSelf.fValue)^ = ^Int32(@lOther.fValue)^;
          end;
        8: begin
          var lSelf := InternalCalls.Cast<Dummy64Enum>(InternalCalls.Cast(self));
          var lOther := InternalCalls.Cast<Dummy64Enum>(InternalCalls.Cast(aOther));

            exit ^Int64(@lSelf.fValue)^ = ^Int64(@lOther.fValue)^;
          end;
      end;
    end;

    method ToString: String; override;
    begin
      var lSelf := InternalCalls.Cast<DummyEnum>(InternalCalls.Cast(self));
      var lValue: Int64 := 0;
      case EnumSize of
        1: lValue := ^Byte(@lSelf.fValue)^;
        2: lValue := ^Word(@lSelf.fValue)^;
        4: lValue := ^Int32(@lSelf.fValue)^;
        8: lValue := InternalCalls.Cast<Dummy64Enum>(InternalCalls.Cast(self)).fValue;
      end;
      result := self.GetType.Constants.FirstOrDefault(a -> a.IsStatic and (Convert.ToInt64(a.Value) = lValue)):Name;
      if result = nil then exit lValue.ToString();
    end;
  end;

  Void = public record
  public
    method ToString: String; override; empty; // not callable
    method GetHashCode: Integer; override; empty; // not callable
  end;

  Boolean = public record(IEquatable<Boolean>, IComparable, IComparable<Boolean>)
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;

    method &Equals(other: Boolean): Boolean;
    begin
      exit self = other;
    end;

    method CompareTo(a: Object): Integer;
    begin
      if a is Boolean then
        exit CompareTo(Boolean(a));
      exit CompareTo(a);
    end;

    method CompareTo(a: Boolean): Integer;
    begin
      if self = a then exit 0;
      if self then exit 1;
      exit -1;
    end;
  end;

  Char = public record(IEquatable<Char>, IComparable, IComparable<Char>)
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;
    class method IsWhiteSpace(aChar: Char): Boolean;
    class method IsNumber(aChar: Char): Boolean;
    method ToLower(aInvariant: Boolean := false): Char;
    method ToUpper(aInvariant: Boolean := false): Char;


    method &Equals(other: Char): Boolean;
    begin
      exit self = other;
    end;

    method CompareTo(a: Object): Integer;
    begin
      if a is Char then
        exit CompareTo(Char(a));
      exit CompareTo(a);
    end;

    method CompareTo(a: Char): Integer;
    begin
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
  end;

  AnsiChar = public record(IEquatable<AnsiChar>, IComparable, IComparable<AnsiChar>)
  public
    method ToString: String; override;
    method GetHashCode: Integer; override;
    method &Equals(obj: Object): Boolean; override;


    method &Equals(other: AnsiChar): Boolean;
    begin
      exit self = other;
    end;

    method CompareTo(a: Object): Integer;
    begin
      if a is AnsiChar then
        exit CompareTo(AnsiChar(a));
      exit CompareTo(a);
    end;

    method CompareTo(a: AnsiChar): Integer;
    begin
      if self < a then exit -1;
      if self > a then exit 1;
      exit 0;
    end;
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
  {$HINT Non-Invariant ToLower is not implemented, yet}
  {$IFDEF WINDOWS}
  var ch: Char := self;
  var temp: NativeInt := ord(ch);
  temp := NativeInt(rtl.CharLower(rtl.LPWSTR(temp)));
  result := chr(temp);
  {$ELSEIF POSIX_LIGHT}
  var b := Encoding.UTF32LE.GetBytes(self);
  var ch := b[0] + (Int32(b[1]) shl 8) + (Int32(b[2]) shl 16) + (Int32(b[3]) shl 24);
  var u := rtl.towlower(ch);
  b[0] := u and $ff;
  b[1] := (u shr 8) and $ff;
  b[2] := (u shr 16) and $ff;
  b[3] := (u shr 24) and $ff;
  result := Encoding.UTF32LE.GetString(b)[0];
  {$ELSE}
  var str := String.FromChar(Self).ToLower(aInvariant);
  if length(str) > 0 then exit str.Item[0];
  exit #0;
  {$ENDIF}
end;

method Char.ToUpper(aInvariant: Boolean := false): Char;
begin
  {$HINT Non-Invariant ToUpper is not implemented, yet}
  {$IFDEF WINDOWS}
  var ch: Char := self;
  var temp: NativeInt := ord(ch);
  temp := NativeInt(rtl.CharUpper(rtl.LPWSTR(temp)));
  result := chr(temp);
  {$ELSEIF POSIX_LIGHT}
  var b := Encoding.UTF32LE.GetBytes(self);
  var ch := b[0] + (Int32(b[1]) shl 8) + (Int32(b[2]) shl 16) + (Int32(b[3]) shl 24);
  var u := rtl.towupper(ch);
  b[0] := u and $ff;
  b[1] := (u shr 8) and $ff;
  b[2] := (u shr 16) and $ff;
  b[3] := (u shr 24) and $ff;
  result := Encoding.UTF32LE.GetString(b)[0];
  {$ELSE}
  var str := String.FromChar(Self).ToUpper(aInvariant);
  if length(str) > 0 then exit str.Item[0];
  exit #0;
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