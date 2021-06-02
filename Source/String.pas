namespace RemObjects.Elements.System;

interface

type
  LCMapStringTransformMode = assembly enum (None, Upper, Lower);

  String = public partial class(Object,IEnumerable<Char>, IEnumerable, IComparable, IComparable<String>)
  assembly
    {$HIDE H6}
    // WARNING: Do not change the field structure w/o also changing the compiler! these are compiler created!
    {$IFDEF DARWIN}
    fCachedNSString: Foundation.NSString;
    {$ENDIF}
    fLength: Integer;
    fFirstChar: Char;
    {$SHOW H6}
    method get_Item(i: Integer): Char;
    constructor; empty; // not callable
    {$IFDEF WINDOWS}
    method doLCMapString(aInvariant: Boolean := false; aMode:LCMapStringTransformMode := LCMapStringTransformMode.None):String;
    method doLCMapString(aLocale: Locale; aMode:LCMapStringTransformMode := LCMapStringTransformMode.None): String;
    {$ENDIF}
    method TestChar(c: Char; Arr : array of Char): Boolean;
    class method PcharLen(c: ^Char): Integer;
    begin
      if c = nil then exit 0;
      result := 0;
      while Byte(c^) <> 0 do begin
        inc(c);
        inc(result);
      end;
    end;
    class method RaiseError(aMessage: String);
    method CheckIndex(aIndex: Integer);
    method GetNonGenericEnumerator: IEnumerator; implements IEnumerable.GetEnumerator;
    method GetEnumerator: IEnumerator<Char>;iterator;
  assembly
    class method AllocString(aLen: Integer): String;
  public
    //constructor(aArray: array of Char);
    //constructor(c: ^Char; aCharCount: Integer): String;
    class method FromCharArray(aArray: array of Char): String;
    class method FromPChar(c: ^Char; aCharCount: Integer): String;
    class method FromPChar(c: ^Char): String;
    class method FromPAnsiChars(c: ^AnsiChar; aCharCount: Integer): nullable String;
    class method FromPAnsiChars(c: ^AnsiChar): nullable String;
    class method FromRepeatedChar(c: Char; aCharCount: Integer): String;
    class method FromChar(c: Char): String;
    class method IsNullOrEmpty(value: String):Boolean;
    method ToAnsiChars(aNullTerminate: Boolean := false): array of AnsiChar;
    method ToCharArray(aNullTerminate: Boolean := false): array of Char; inline;
    method ToCharArray(StartIndex: Integer; aLength: Integer; aNullTerminate: Boolean := false): array of Char;
    property Length: Integer read fLength;
    property Item[i: Integer]: Char read get_Item; default;
    property FirstChar: ^Char read @fFirstChar;

    method CopyTo(SourceIndex: Integer; destination: array of Char; DestinationIndex: Integer; Count: Integer);
    method Insert(aIndex: Integer; aNewValue: String): not nullable String;
    method &Remove(StartIndex: Integer): String; inline;
    method &Remove(StartIndex: Integer; Count: Integer): String;
    method CompareTo(Value: String): Integer;
    method CompareToIgnoreCase(Value: String): Integer;
    method &Equals(aOther: String): Boolean;
    method &Equals(aOther: Object): Boolean; override;
    method EqualsIgnoreCase(aOther: String): Boolean;
    method EqualsIgnoreCaseInvariant(aOther: String): Boolean;
    class method &Join(Separator: String; Value: array of String): String;
    class method &Join(Separator: String; Value: IEnumerable<String>): String;
    class method &Join<T>(Separator: String; Value: IEnumerable<T>): String;
    class method &Join(Separator: String; Value: array of String; StartIndex: Integer; Count: Integer): String;
    class method &Join(Separator: String; Value: array of Object): String;
    method Contains(Value: String): Boolean;
    method IndexOf(Value: String): Integer;
    method IndexOf(Value: String; aStartFromIndex: Integer): Integer;
    method IndexOfAny(anyOf: array of Char): Integer;
    method LastIndexOf(Value: String): Integer;
    method LastIndexOf(Value: String; aStartFromIndex: Integer): Integer;
    method LastIndexOfAny(anyOf: array of Char): Integer;
    method Substring(StartIndex: Integer): not nullable String;
    method Substring(StartIndex: Integer; aLength: Integer): not nullable String;
    method Split(Separator: String; aRemoveEmptyEntries: Boolean := false; aMax: Integer := -1): array of String;
    method Replace(OldValue, NewValue: String): not nullable String;
    method PadStart(TotalWidth: Integer): String; inline;
    method PadStart(TotalWidth: Integer; PaddingChar: Char): String;
    method PadEnd(TotalWidth: Integer): String; inline;
    method PadEnd(TotalWidth: Integer; PaddingChar: Char): String;
    method ToLower(aInvariant: Boolean := false): String;
    method ToUpper(aInvariant: Boolean := false): String;
    method ToLowerInvariant: String;inline;
    method ToUpperInvariant: String;inline;
    method ToLower(aLocale: Locale): String;
    method ToUpper(aLocale: Locale): String;
    method Trim: String;
    method Trim(aChars: array of Char): String;
    method TrimStart: String;
    method TrimStart(aChars: array of Char): String;
    method TrimEnd: String;
    method TrimEnd(aChars: array of Char): String;
    method StartsWith(Value: String; aInvariant: Boolean := false): Boolean;
    method EndsWith(Value: String; aInvariant: Boolean := false): Boolean;
    class method Format(aFormat: not nullable String; params aArguments: not nullable array of Object): String;

    class method Compare(aLeft, aRight: String): Integer;
    class operator Add(aLeft, aRight: String): String;
    class operator Add(aLeft: String; aChar: Char): String;
    class operator Add(aLeft: Char; aRight: String): String;
    class operator Add(aLeft: String; aRight: Object): String;
    class operator Add(aLeft: Object; aRight: String): String;
    class operator Implicit(Value: Char): String;
    class operator Greater(Value1, Value2: String): Boolean;
    class operator Less(Value1, Value2: String): Boolean;
    class operator GreaterOrEqual(Value1, Value2: String): Boolean;
    class operator LessOrEqual(Value1, Value2: String): Boolean;
    class operator Equal(aValue1: String; aValue2: String): Boolean;
    class operator NotEqual(aValue1: String; aValue2: String): Boolean;

    method ToString: String; override;
    method GetHashCode: Integer; override;

    method CompareTo(a: Object): Integer;
    begin
      var lString := String(a);
      if lString = nil then exit -1;
      exit CompareTo(lString);
    end;
  end;

  String_Constructors = public extension class(String)
    constructor(aArray: array of Char);
    constructor(c: ^Char; aCharCount: Integer);
    constructor(c: ^Char);
    constructor(c: Char; aCharCount: Integer);
    constructor(c: Char);
    constructor(c: ^AnsiChar; aCharCount: Integer);
    constructor(c: ^AnsiChar);
  end;

  IString = public interface
    method ToString: String;
  end;

{$IFDEF POSIX AND NOT ANDROID}
method iconv_helper(cd: rtl.iconv_t; inputdata: ^AnsiChar; inputdatalength: rtl.size_t; suggestedlength: Integer; out aresult: ^AnsiChar): Integer; public;
{$ENDIF}

implementation

method String.GetNonGenericEnumerator: IEnumerator;
begin
  exit self.GetEnumerator;
end;

method String.GetEnumerator: IEnumerator<Char>;
begin
  for i: Integer := 0 to fLength -1 do
    yield (@fFirstChar)[i];
end;

class method String.FromPChar(c: ^Char; aCharCount: Integer): String;
begin
  if c = nil then exit nil;
  result := AllocString(aCharCount);
  memcpy(@result.fFirstChar, c, aCharCount * 2);
end;

{$IFDEF POSIX AND NOT ANDROID}
method iconv_helper(cd: rtl.iconv_t; inputdata: ^AnsiChar; inputdatalength: rtl.size_t; suggestedlength: Integer; out aresult: ^AnsiChar): Integer;
begin
  var outputdata := ^AnsiChar(rtl.malloc(suggestedlength));
  if outputdata = nil then begin
    exit -1;
  end;
  retry:;
  var inpos := inputdata;
  var left: rtl.size_t := inputdatalength;
  var outleft: rtl.size_t := suggestedlength;
  var outpos := outputdata;
  var count := rtl.iconv(cd, @inpos, @left, @outpos, @outleft);
  if (count = rtl.size_t(- 1)) and (rtl.errno = 7) then begin
    suggestedlength := suggestedlength + left + 8;
    outputdata := ^AnsiChar(rtl.realloc(outputdata, suggestedlength));
    goto retry;
  end;
  if (count = rtl.size_t(-1)) then begin
    rtl.free(outputdata);
    exit -1;
  end;
  aresult := outputdata;
  result := suggestedlength - outleft;
end;
{$ENDIF}

class method String.FromPAnsiChars(c: ^AnsiChar; aCharCount: Integer): nullable String;
begin
  if not assigned(c) then exit nil;
  {$IFDEF WINDOWS}
  var len := rtl.MultiByteToWideChar(rtl.CP_ACP, 0, c, aCharCount, nil, 0);
  result := AllocString(len);
  rtl.MultiByteToWideChar(rtl.CP_ACP, 0, c, aCharCount, @result.fFirstChar, len);
  {$ELSEIF ANDROID or WEBASSEMBLY}
  var b := new Byte[aCharCount];
  Array.Copy(^Byte(c), b, 0, aCharCount);
  exit Encoding.UTF8.GetString(b);
  {$ELSE}
  var lNewData: ^AnsiChar := nil;
  var lNewLen: rtl.size_t := iconv_helper(TextConvert.fCurrentToUtf16, c, aCharCount, aCharCount * 2 + 5, out lNewData);
  // method iconv_helper(cd: rtl.iconv_t; inputdata: ^AnsiChar; inputdatalength: rtl.size_t;outputdata: ^^AnsiChar; outputdatalength: ^rtl.size_t; suggested_output_length: Integer): Integer;
  if lNewLen <> -1  then begin
    result := String.FromPChar(^Char(lNewData), lNewLen / 2);
    rtl.free(lNewData);
  end;
  {$ENDIF}
end;

method String.ToAnsiChars(aNullTerminate: Boolean := false): array of AnsiChar;
begin
  {$IFDEF WINDOWS}
  var len := rtl.WideCharToMultiByte(rtl.CP_ACP, 0, @self.fFirstChar, Length, nil, 0, nil, nil);
  result := new AnsiChar[len+ if aNullTerminate then 1 else 0];
  if len <> 0 then
    rtl.WideCharToMultiByte(rtl.CP_ACP, 0, @self.fFirstChar, Length, rtl.LPSTR(@result[0]), len, nil, nil);
  {$ELSEIF ANDROID or WEBASSEMBLY}
  var b := Encoding.UTF8.GetBytes(self, false);
  result := new AnsiChar[b.Length + if aNullTerminate then 1 else 0];
  if b.Length <> 0 then
    memcpy(@result[0], @b[0], b.Length);
  {$ELSE}
  var lNewData: ^AnsiChar := nil;
  var lNewLen: rtl.size_t := iconv_helper(TextConvert.fUTF16ToCurrent, ^AnsiChar(@fFirstChar), Length * 2, Length + 5, out lNewData);

  if lNewLen <> rtl.size_t(-1)  then begin
    result := new AnsiChar[lNewLen+ if aNullTerminate then 1 else 0];
    if lNewLen <> 0 then
      rtl.memcpy(@result[0], lNewData, lNewLen);
    rtl.free(lNewData);
  end;
  {$ENDIF}
end;

method String.get_Item(i: Integer): Char;
begin
  CheckIndex(i);
  exit (@self.fFirstChar)[i];
end;

class operator String.Add(aLeft, aRight: String): String;
begin
  if (Object(aLeft) = nil) or (aLeft.Length = 0) then exit aRight;
  if (Object(aRight) = nil) or (aRight.Length = 0) then exit aLeft;
  result := AllocString(aLeft.Length + aRight.Length);
  memcpy(@result.fFirstChar, @aLeft.fFirstChar, aLeft.Length * 2);
  memcpy((@result.fFirstChar) + aLeft.Length, @aRight.fFirstChar, aRight.Length * 2);
end;

class operator String.Add(aLeft: String; aChar: Char): String;
begin
  if (Object(aLeft) = nil) or (aLeft.Length = 0) then exit aChar;
  result := AllocString(aLeft.Length + 1);
  memcpy(@result.fFirstChar, @aLeft.fFirstChar, aLeft.Length * 2);
  (@result.fFirstChar)[aLeft.Length] := aChar;
end;

class operator String.Add(aLeft: Char; aRight: String): String;
begin
  if (Object(aRight) = nil) or (aRight.Length = 0) then exit aLeft;
  result := AllocString(aRight.Length + 1);
  memcpy((@result.fFirstChar) + 1, @aRight.fFirstChar, aRight.Length * 2);
  (@result.fFirstChar)[0] := aLeft;
end;


class operator String.Add(aLeft: String; aRight: Object): String;
begin
  exit aLeft + (aRight:ToString);
end;

class operator String.Add(aLeft: Object; aRight: String): String;
begin
  exit (aLeft:ToString) + aRight;
end;

class operator String.Implicit(Value: Char): String;
begin
  result := AllocString(1);
  result.fFirstChar := Value;
end;

class method String.AllocString(aLen: Integer): String;
begin
  result := InternalCalls.Cast<String>(DefaultGC.New(InternalCalls.GetTypeInfo<String>(), (sizeOf(Object) + sizeOf(Integer) + if defined('DARWIN') then sizeOf(IntPtr) else 0) + 2 * aLen));
  result.fLength := aLen;
end;

method String.ToString: String;
begin
  exit self;
end;

method String.GetHashCode: Integer;
begin
  exit Utilities.CalcHash(@fFirstChar, fLength*2);
end;

method String.Trim: String;
begin
  if String.IsNullOrEmpty(self) then exit self;
  var lStart := 0;
  var len := self.Length;
  var lEnd := len-1;

  while (lStart ≤ lEnd) and Char.IsWhiteSpace(self[lStart]) do inc(lStart);
  if lStart > lEnd then exit '';

  while (lEnd ≥ lStart) and Char.IsWhiteSpace(self[lEnd]) do dec(lEnd);
  if lEnd < lStart then exit '';

  result := Substring(lStart, lEnd-lStart+1);
end;

method String.Trim(aChars: array of Char): String;
begin
  if String.IsNullOrEmpty(self) then exit self;
  var lStart := 0;
  var len := self.Length;
  var lEnd := len-1;

  while (lStart ≤ lEnd) and TestChar(self[lStart], aChars) do inc(lStart);
  if lStart > lEnd then exit '';

  while (lEnd ≥ lStart) and TestChar(self[lEnd], aChars) do dec(lEnd);
  if lEnd < lStart then exit '';

  result := Substring(lStart, lEnd-lStart+1);
end;

method String.TrimStart: String;
begin
  if String.IsNullOrEmpty(self) then exit self;
  var lStart := 0;
  var lEnd := self.Length-1;

  while (lStart ≤ lEnd) and Char.IsWhiteSpace(self[lStart]) do inc(lStart);
  if lStart > lEnd then exit '';

  result := Substring(lStart, lEnd-lStart+1);
end;

method String.TrimStart(aChars: array of Char): String;
begin
  if String.IsNullOrEmpty(self) then exit self;
  var lStart := 0;
  var lEnd := self.Length-1;

  while (lStart ≤ lEnd) and TestChar(self[lStart], aChars) do inc(lStart);
  if lStart > lEnd then exit '';

  result := Substring(lStart, lEnd-lStart+1);
end;

method String.TrimEnd: String;
begin
  if String.IsNullOrEmpty(self) then exit self;
  var len := self.Length;
  var lEnd := len-1;

  while (lEnd ≥ 0) and Char.IsWhiteSpace(self[lEnd]) do dec(lEnd);
  if lEnd < 0 then exit '';

  result := Substring(0, lEnd+1);
end;

method String.TrimEnd(aChars: array of Char): String;
begin
  if String.IsNullOrEmpty(self) then exit self;
  var len := self.Length;
  var lEnd := len-1;

  while (lEnd ≥ 0) and TestChar(self[lEnd], aChars) do dec(lEnd);
  if lEnd < 0 then exit '';

  result := Substring(0, lEnd+1);
end;

method String.Substring(StartIndex: Integer): not nullable String;
begin
  if StartIndex = 0 then exit self;
  CheckIndex(StartIndex);
  exit Substring(StartIndex, self.Length - StartIndex)
end;

method String.Substring(StartIndex: Integer; aLength: Integer): not nullable String;
begin
  if aLength = 0 then exit '';
  CheckIndex(StartIndex);
  if aLength > 1 then
    CheckIndex(StartIndex+aLength-1);
  if (StartIndex = 0) and (aLength = self.Length) then exit self;
  {$HIDE W46}
  exit String.FromPChar(@(@fFirstChar)[StartIndex], aLength);
  {$SHOW W46}
end;

//
// Equality
//

method String.&Equals(aOther: String): Boolean;
begin
  exit &Equals(Object(aOther));
end;

method String.Equals(aOther: Object): Boolean;
begin
  var lOther := String(aOther);
  if defined("DARWIN") and not assigned(lOther) then
    lOther := String(Foundation.NSString(IslandWrappedCocoaObject(aOther):Value));

  if assigned(lOther) then begin
    if self.Length <> lOther.Length then
      exit false;
    for i: Integer := 0 to self.Length-1 do
      if self[i] <> lOther[i] then
        exit false;
    exit true;
  end;
end;

method String.EqualsIgnoreCase(aOther: String): Boolean;
begin
  exit ToLower().Equals(aOther:ToLower());
end;

method String.EqualsIgnoreCaseInvariant(aOther: String): Boolean;
begin
  exit ToLowerInvariant().Equals(aOther:ToLowerInvariant());
end;

class operator String.Equal(aValue1: String; aValue2: String): Boolean;
begin
  if not assigned(aValue1) then
    result := not assigned(aValue2)
  else
    result := aValue1:&Equals(aValue2);
end;

class operator String.NotEqual(aValue1: String; aValue2: String): Boolean;
begin
  if not assigned(aValue1) then
    result := assigned(aValue2)
  else
    result := not aValue1.Equals(aValue2);
end;

class operator String.Greater(Value1, Value2: String): Boolean;
begin
  // Value1 > Value2 = true
  if (Object(Value1) = nil) then exit false;    // nil > ????
  if (Object(Value2) = nil) then exit true;     // not nil > nil
  var min_length := iif(Value1.Length > Value2.Length, Value2.Length, Value1.Length);

  for i: Integer := 0 to min_length-1 do
    if Value1.Item[i] <= Value2.Item[i] then exit false; //  a <= b

  exit Value1.Length > Value2.Length;  // xxxy > xxx
end;

class operator String.Less(Value1, Value2: String): Boolean;
begin
  // Value1 < Value2 = true
  if (Object(Value2) = nil) then exit false;    // ???? < nil
  if (Object(Value1) = nil) then exit true;     // nil < not nil
  var min_length := iif(Value1.Length > Value2.Length, Value2.Length, Value1.Length);

  for i: Integer :=0 to min_length-1 do
    if Value1.Item[i] >= Value2.Item[i] then exit false;  // b >= a

  exit Value1.Length < Value2.Length; // xxx < xxxy
end;

class operator String.GreaterOrEqual(Value1, Value2: String): Boolean;
begin
  // Value1 >= Value2 = true
  if (Object(Value2) = nil) then exit true;     // ???? >= nil
  if (Object(Value1) = nil) then exit false;    // nil >= ????
  var min_length := iif(Value1.Length > Value2.Length, Value2.Length, Value1.Length);

  for i: Integer :=0 to min_length-1 do
    if Value1.Item[i] < Value2.Item[i] then exit false; //  a <= b

  exit Value1.Length >= Value2.Length;  // xxxy > xxx
end;

class operator String.LessOrEqual(Value1, Value2: String): Boolean;
begin
  // Value1 <= Value2 = true
  if (Object(Value1) = nil) then exit true;     // nil <= ????
  if (Object(Value2) = nil) then exit false;    // ???? <= nil
  var min_length := iif(Value1.Length > Value2.Length, Value2.Length, Value1.Length);

  for i: Integer :=0 to min_length-1 do
    if Value1.Item[i] > Value2.Item[i] then exit false;  // b > a

  exit Value1.Length <= Value2.Length; // xxx <= xxxy
end;

//
//
//

method String.Contains(Value: String): Boolean;
begin
  exit self.IndexOf(Value) > -1;
end;

method String.IndexOf(Value: String; aStartFromIndex: Integer): Integer;
begin
  var Value_Length := Value.Length;
  if Value_Length > Self.Length then exit -1;
  if Value_Length = 0 then exit 0;

  for i: Integer := aStartFromIndex to Self.Length-Value_Length do begin
    var lfound:= true;
    for j: Integer :=0 to Value_Length-1 do begin
      lfound:=lfound and (self.Item[i+j] = Value.Item[j]);
      if not lfound then break;
    end;
    if lfound then exit i;
  end;

  exit -1;
end;

method String.LastIndexOf(Value: String): Integer;
begin
  result := LastIndexOf(Value, self.Length - 1);
end;

method String.LastIndexOf(Value: String; aStartFromIndex: Integer): Integer;
begin
  var Value_Length := Value.Length;
  if Value_Length > Self.Length then exit -1;
  if Value_Length = 0 then exit -1;

  for i: Integer := aStartFromIndex-Value_Length+1 downto 0 do begin
    var lfound:= true;
    for j: Integer := 0 to Value_Length-1 do begin
      lfound := lfound and (self.Item[i+j] = Value.Item[j]);
      if not lfound then break;
    end;
    if lfound then exit i;
  end;

  exit -1;
end;

method String.IndexOf(Value: String): Integer;
begin
  exit self.IndexOf(Value,0);
end;

method String.Replace(OldValue, NewValue: String): not nullable String;
begin
  result := self;
  var oldValue_Length := OldValue.Length;
  var newValue_Length := NewValue.Length;
  var lstart:=0;
  repeat
    lstart := result.IndexOf(OldValue, lstart);
    if lstart <> -1 then begin
      var lrest : not nullable String := '';
      if lstart+oldValue_Length < result.Length then lrest := result.Substring(lstart+oldValue_Length);
      result := result.Substring(0, lstart)+NewValue+lrest;
      inc(lstart, newValue_Length);
  end;
  until lstart = -1;
end;

method String.TestChar(c: Char; Arr : array of Char): Boolean;
begin
  for d: Char in Arr do
    if d = c then exit true;
  exit false;
end;

class method String.Compare(aLeft, aRight: String): Integer;
begin
  if (Object(aLeft) = nil) and (Object(aRight) = nil) then exit 0;
  if (Object(aLeft) = nil) then exit -1;
  if (Object(aRight) = nil) then exit 1;
  var min_length := iif(aLeft.Length > aRight.Length, aRight.Length, aLeft.Length);
  for i: Integer :=0 to min_length-1 do begin
    if aLeft.Item[i] > aRight.Item[i] then exit 1;
    if aLeft.Item[i] < aRight.Item[i] then exit -1;
  end;
  exit aLeft.Length - aRight.Length;
end;


method String.StartsWith(Value: String; aInvariant: Boolean := false): Boolean;
begin
  if Value.Length > self.Length then exit false;
  var s1 := iif(aInvariant, self.ToLowerInvariant, self);
  var s2 := iif(aInvariant, Value.ToLowerInvariant, Value);

  exit s1.IndexOf(s2,0) = 0;
end;

method String.EndsWith(Value: String; aInvariant: Boolean := false): Boolean;
begin
  if Value.Length > self.Length then exit false;

  var s1 := iif(aInvariant, self.ToLowerInvariant, self);
  var s2 := iif(aInvariant, Value.ToLowerInvariant, Value);

  var pos := self.Length-Value.Length;
  exit s1.IndexOf(s2, pos) = pos;
end;

method String.CopyTo(SourceIndex: Integer; destination: array of Char; DestinationIndex: Integer; Count: Integer);
begin
  memcpy(@destination[DestinationIndex], (@fFirstChar) + SourceIndex, Count * 2);
end;

method String.Insert(aIndex: Integer; aNewValue: String): not nullable String;
begin
  {$HIDE W46}
  result := AllocString(self.Length + aNewValue.Length);
  {$SHOW W46}
  memcpy(@result.fFirstChar, @fFirstChar, aIndex * 2);
  memcpy((@result.fFirstChar) + aIndex, @aNewValue.fFirstChar, aNewValue.Length * 2);
  memcpy((@result.fFirstChar) + aIndex + aNewValue.Length, (@fFirstChar) + aIndex, (self.Length - aIndex) * 2);
end;

method String.&Remove(StartIndex: Integer): String;
begin
  result := &Remove(StartIndex, Length - StartIndex);
end;

method String.&Remove(StartIndex: Integer; Count: Integer): String;
begin
  result := AllocString(self.Length - Count);
  memcpy(@result.fFirstChar, @fFirstChar, StartIndex * 2);
  memcpy((@result.fFirstChar) + StartIndex, (@fFirstChar) + StartIndex + Count, (self.Length - (StartIndex + Count)) * 2);
end;

method String.CompareTo(Value: String): Integer;
begin
  exit String.Compare(self,Value);
end;

method String.CompareToIgnoreCase(Value: String): Integer;
begin
  exit String.Compare(self:ToLower(), Value:ToLower());
end;

method String.Split(Separator: String; aRemoveEmptyEntries: Boolean := false; aMax: Integer := -1): array of String;
begin
  if (Separator = nil) or (Separator = '') or (aMax in [0, 1]) then begin
    result := new String[1];
    result[0] := self;
    exit result;
  end;
  var lRes := new List<String>;
  var lIdx := 0;
  while lIdx < Length do begin
    var lSplitIndex := IndexOf(Separator, lIdx);
    if lSplitIndex = -1 then break;
    if not aRemoveEmptyEntries or (lSplitIndex - lIdx > 0) then
      lRes.Add(Substring(lIdx, lSplitIndex - lIdx));
    lIdx := lSplitIndex + Separator.Length;
    if lRes.Count + 1 = aMax then break;
  end;
  if (Length - lIdx > 0) then
    lRes.Add(Substring(lIdx, Length - lIdx))
  else
    if not aRemoveEmptyEntries then
      lRes.Add('');

  exit lRes.ToArray;
end;

{$IFDEF WINDOWS}
method String.doLCMapString(aInvariant: Boolean := false; aMode:LCMapStringTransformMode := LCMapStringTransformMode.None):String;
const
  LANG_INVARIANT =  $007F;
  LOCALE_USER_DEFAULT = $0400;
  LCMAP_LOWERCASE = $00000100;
  LCMAP_UPPERCASE = $00000200;
begin
  if self.Length = 0 then exit self;

  var locale : UInt32 := iif(aInvariant, LANG_INVARIANT, LOCALE_USER_DEFAULT);
  var options: UInt32;
  if aMode = LCMapStringTransformMode.Lower then options := LCMAP_LOWERCASE
  else if aMode = LCMapStringTransformMode.Upper then options := LCMAP_UPPERCASE
  else aMode := 0;

  var buf := @self.fFirstChar;
  var lrequired_size := rtl.LCMapStringW(locale, options,buf, self.Length, nil, 0);
  if (lrequired_size = 0) and (rtl.GetLastError <> 0) then RaiseError('Problem with calling LCMapString (1st call)');
  result := AllocString(lrequired_size);
  lrequired_size := rtl.LCMapStringW(locale, options,@self.fFirstChar, self.Length, @result.fFirstChar, lrequired_size);
  if (lrequired_size = 0) and (rtl.GetLastError <> 0) then RaiseError('Problem with calling LCMapString (2nd call)');
end;

method String.doLCMapString(aLocale: Locale; aMode:LCMapStringTransformMode := LCMapStringTransformMode.None): String;
begin
  if self.Length = 0 then exit self;

  var options: UInt32;
  if aMode = LCMapStringTransformMode.Lower then options := rtl.LCMAP_LOWERCASE
  else if aMode = LCMapStringTransformMode.Upper then options := rtl.LCMAP_UPPERCASE
  else aMode := 0;


  var lrequired_size := self.Length * 2;
  var lBuffer := new Char[lrequired_size];
  lrequired_size := rtl.LCMapStringW(aLocale.PlatformLocale, options, @self.fFirstChar, self.Length, @lBuffer[0], lrequired_size);
  if (lrequired_size = 0) and (rtl.GetLastError <> 0) then RaiseError('Problem with calling LCMapString (2nd call)');
  result := String.FromPChar(@lBuffer[0], lrequired_size);
end;
{$ENDIF}

method String.PadStart(TotalWidth: Integer): String;
begin
  exit PadStart(TotalWidth, ' ');
end;

method String.PadStart(TotalWidth: Integer; PaddingChar: Char): String;
begin
  if TotalWidth < 0 then raise new ArgumentOutOfRangeException('TotalWidth is less than zero.');
  var lTotal := TotalWidth - self.Length;
  if lTotal < 1 then
    exit self
  else
    exit FromRepeatedChar(PaddingChar, lTotal) + self;
end;

method String.PadEnd(TotalWidth: Integer): String;
begin
  exit PadEnd(TotalWidth, ' ');
end;

method String.PadEnd(TotalWidth: Integer; PaddingChar: Char): String;
begin
  if TotalWidth < 0 then raise new ArgumentOutOfRangeException('TotalWidth is less than zero.');
  var lTotal := TotalWidth - self.Length;
  if lTotal < 1 then
    result := self
  else
    result := self + FromRepeatedChar(PaddingChar, lTotal);
end;

method String.ToLower(aInvariant: Boolean := false): String;
begin
  {$IF WEBASSEMBLY}
  exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.ToLower(@fFirstChar, Length, aInvariant), true);
  {$ELSE}
  exit ToLower(Locale.Invariant);
  {$ENDIF}
end;

method String.ToUpper(aInvariant: Boolean := false): String;
begin
  {$IF WEBASSEMBLY}
  exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.Toupper(@fFirstChar, Length, aInvariant), true);
  {$ELSE}
  exit ToUpper(Locale.Invariant);
  {$ENDIF}
end;

class method String.IsNullOrEmpty(value: String):Boolean;
begin
  Result := (Object(value) = nil) or (value.Length = 0);
end;

method String.ToCharArray(aNullTerminate: Boolean := false): array of Char;
begin
  result := ToCharArray(0, fLength, aNullTerminate);
end;

method String.ToCharArray(StartIndex: Integer; aLength: Integer; aNullTerminate: Boolean := false): array of Char;
begin
  var r := new array of Char(aLength + if aNullTerminate then 1 else 0);
  if r.Length <> 0 then
    memcpy(@r[0], (@fFirstChar) + StartIndex, aLength * 2);
  if aNullTerminate then r[aLength] := #0;
  exit r;
end;

class method String.RaiseError(aMessage: String);
begin
  raise new Exception(aMessage);
end;

method String.CheckIndex(aIndex: Integer);
begin
  if (aIndex < 0) or (aIndex >= fLength) then raise Utilities.CreateIndexOutOfRangeException(aIndex, fLength-1);
end;

class method String.FromPChar(c: ^Char): String;
begin
  exit FromPChar(c, PcharLen(c));
end;

class method String.FromChar(c: Char): String;
begin
  exit FromPChar(@c, 1);
end;

class method String.FromRepeatedChar(c: Char; aCharCount: Integer): String;
begin
  if aCharCount = 0 then exit '';
  result := AllocString(aCharCount);
  for i: Integer := 0 to aCharCount-1 do
    (@result.fFirstChar)[i] := c;
end;

class method String.FromPAnsiChars(c: ^AnsiChar): nullable String;
begin
  if not assigned(c) then exit nil;
  exit FromPAnsiChars(c, {$IFDEF WINDOWS OR WEBASSEMBLY}ExternalCalls.strlen(c){$ELSEIF POSIX}rtl.strlen(c){$ELSE}{$ERROR Not Implemented}{$ENDIF});
end;

class method String.Format(aFormat: not nullable String; params aArguments: not nullable array of Object): String;
begin
  var arg_count := aArguments.Length;
  var sb := new StringBuilder(aFormat.Length + aArguments.Length*8);
  var cur_pos := 0;
  var old_pos := 0;

  while cur_pos < aFormat.Length do begin
    case aFormat[cur_pos] of
      '{': begin
        sb.Append(aFormat, old_pos, cur_pos - old_pos);
        if (cur_pos < aFormat.Length-1) and (aFormat[cur_pos+1] = '{') then begin
          old_pos := cur_pos+1;
          inc(cur_pos,2);
          continue;
        end;
        // parses format specifier of form:
        //   {N,[\ +[-]M][:F]}

        inc(cur_pos);
        // N = argument number (non-negative Integer)
        var n: Integer := 0;
        var fl:= true;
        while cur_pos < aFormat.Length-1 do begin
          if (aFormat[cur_pos] >='0') and (aFormat[cur_pos] <='9') then begin
            fl:= false;
            n := n*10+ ord(aFormat[cur_pos])- ord('0');
            inc(cur_pos);
          end
          else begin
            if fl then RaiseError('format error');
            break;
          end;
        end;
        if n >= arg_count then raise new ArgumentOutOfRangeException('Index (zero based) must be greater than or equal to zero and less than the size of the argument list.');
        while (cur_pos < aFormat.Length-1) and (aFormat[cur_pos] = ' ') do begin
          inc(cur_pos);// skip spaces
        end;
        var sign := False;
        var width : Integer := 0;
        fl:= true;

        if aFormat[cur_pos] = ',' then begin
          inc(cur_pos);
          while (cur_pos < aFormat.Length-1) and (aFormat[cur_pos] = ' ') do begin
            inc(cur_pos);// skip spaces
          end;
          while (cur_pos < aFormat.Length-1) and (aFormat[cur_pos] = '-') do begin
            sign := True;
            inc(cur_pos);// skip any spaces
          end;
          while cur_pos < aFormat.Length-1 do begin
            if (aFormat[cur_pos] >='0') and (aFormat[cur_pos] <='9') then begin
              fl:= false;
              width:= width*10+ ord(aFormat[cur_pos])- ord('0');
              inc(cur_pos);
            end
            else begin
              if fl then RaiseError('format error');
              break;
            end;
          end;
          while (cur_pos < aFormat.Length-1) and (aFormat[cur_pos] = ' ') do begin
            inc(cur_pos);// skip spaces
          end;
        end
        else begin
          width := 0;
          sign := False;
        end;
        var sb1 := new StringBuilder;
        if aFormat[cur_pos] = ':' then begin
          inc(cur_pos);
          while true do begin
            case aFormat[cur_pos] of
              '{': begin
                    if (cur_pos < aFormat.Length-1) and (aFormat[cur_pos+1] = '{') then begin
                      inc(cur_pos); // '{{' case
                    end
                    else
                      RaiseError('format error');
                   end;
             '}': begin
                    if (cur_pos < aFormat.Length-1) and (aFormat[cur_pos+1] = '}') then begin
                      inc(cur_pos); //`}}` case
                    end
                    else begin
                      break;
                    end;
                  end;
            end;
            sb1.Append(aFormat[cur_pos]);
            inc(cur_pos);
          end;
          dec(cur_pos);
          {$HINT String.Format: custom format aren't supported yet}
          RaiseError('String.Format: custom format aren''t supported yet');
        end;
        if aFormat[cur_pos] <> '}' then RaiseError('format error');

        var arg_format := coalesce(aArguments[n]:ToString, "");
        var t := width - arg_format.Length;
        if not sign and (t > 0) then
          sb.Append(' ', t);
        sb.Append(arg_format);
        if sign and (t > 0) then
          sb.Append(' ', t);
        old_pos := cur_pos+1;
      end;
      '}': begin
        if (cur_pos < aFormat.Length-1) and (aFormat[cur_pos+1] = '}') then begin
          sb.Append(aFormat, old_pos, cur_pos - old_pos+1);
          old_pos := cur_pos+1;
          inc(cur_pos,2);
          continue;
        end
        else begin
          RaiseError('format error');
        end;
      end;
    end;
    inc(cur_pos);
  end;

  if sb.Length = 0 then exit aFormat;

  sb.Append(aFormat, old_pos, cur_pos - old_pos);
  result := sb.ToString;
end;

/*constructor String(aArray: array of Char);
begin
  constructor(if aArray = nil then nil else @aArray[0], if aArray = nil then nil else aArray.Length);
end;*/

class method String.FromCharArray(aArray: array of Char): String;
begin
  if aArray = nil then
    exit FromPChar(nil,0)
  else if aArray.Length = 0 then
    exit FromPChar(nil,0)
  else
    exit FromPChar(@aArray[0], aArray.Length);
end;

class method String.Join(Separator: String; Value: array of String): String;
begin
  if Value = nil then raise new ArgumentNullException('Value is nil.');
  exit String.Join(Separator, Value, 0, length(Value));
end;

class method String.Join(Separator: String; Value: array of String; StartIndex: Integer; Count: Integer): String;
begin
  if Value = nil then raise new ArgumentNullException('Value is nil.');
  if StartIndex < 0 then raise new ArgumentOutOfRangeException('StartIndex is less than 0.');
  if Count < 0 then raise new ArgumentOutOfRangeException('Count is less than 0.');
  if StartIndex + Count > length(Value) then raise new ArgumentOutOfRangeException('StartIndex plus Count is greater than the number of elements in Value.');
  if String.IsNullOrEmpty(Separator) then Separator := '';
  var str:= new StringBuilder;
  var len := length(Value);
  if len > StartIndex then str.Append(Value[StartIndex]);

  for i: Integer := StartIndex+1 to StartIndex+Count-1 do begin
    str.Append(Separator);
    str.Append(Value[i]);
  end;
  exit str.ToString;

end;

class method String.Join(Separator: String; Value: array of Object): String;
begin
  if Value = nil then raise new ArgumentNullException('Value is nil.');
  if String.IsNullOrEmpty(Separator) then Separator := '';
  var str:= new StringBuilder;
  var len := length(Value);
  if len >0 then str.Append(Value[0].ToString);

  for i: Integer := 1 to len-1 do begin
    str.Append(Separator);
    str.Append(Value[i].ToString);
  end;
  exit str.ToString;
end;

class method String.Join(Separator: String; Value: IEnumerable<String>): String;
begin
  if Value = nil then raise new ArgumentNullException('Value is nil.');
  if String.IsNullOrEmpty(Separator) then Separator := '';
  var str:= new StringBuilder;
  var lenum := Value.GetEnumerator;
  if lenum.MoveNext then str.Append(lenum.Current);

  while lenum.MoveNext do begin
    str.Append(Separator);
    str.Append(lenum.Current);
  end;
  exit str.ToString;
end;

class method String.Join<T>(Separator: String; Value: IEnumerable<T>): String;
begin
  if Value = nil then raise new ArgumentNullException('Value is nil.');
  if String.IsNullOrEmpty(Separator) then Separator := '';
  var str:= new StringBuilder;
  var lenum := Value.GetEnumerator;
  if lenum.MoveNext then str.Append(lenum.Current.ToString);

  while lenum.MoveNext do begin
    str.Append(Separator);
    str.Append(lenum.Current.ToString);
  end;
  exit str.ToString;
end;

method String.IndexOfAny(anyOf: array of Char): Integer;
begin
  if anyOf = nil then raise new ArgumentNullException('anyOf is null.');
  for i:Integer := 0 to fLength-1 do
    for j:Integer := 0 to anyOf.Length-1 do
      if (@fFirstChar)[i] = anyOf[j] then exit i;
  exit -1;
end;

method String.LastIndexOfAny(anyOf: array of Char): Integer;
begin
  if anyOf = nil then raise new ArgumentNullException('anyOf is null.');
  for i:Integer := fLength-1 downto 0 do
    for j:Integer := 0 to anyOf.Length-1 do
      if (@fFirstChar)[i] = anyOf[j] then exit i;
  exit -1;
end;

method String.ToLowerInvariant: String;
begin
  {$IF WEBASSEMBLY}
  exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.ToLower(@fFirstChar, Length, true), true);
  {$ELSE}
  exit ToLower(Locale.Invariant);
  {$ENDIF}
end;

method String.ToUpperInvariant: String;
begin
  {$IF WEBASSEMBLY}
  exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.Toupper(@fFirstChar, Length, true), true);
  {$ELSE}
  exit ToUpper(Locale.Invariant);
  {$ENDIF}
end;

method String.ToLower(aLocale: Locale): String;
begin
  {$IFDEF WINDOWS}
  exit doLCMapString(aLocale, LCMapStringTransformMode.Lower);
  {$ELSEIF WEBASSEMBLY}
  // JavaScript standard does not have lowerCase function with a locale as parameter yet
  exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.ToLower(@fFirstChar, Length, false), true);
  {$ELSEIF DARWIN}
  var lTmp := CoreFoundation.CFStringCreateMutable(nil, 0);
  CoreFoundation.CFStringAppendCharacters(lTmp, ^rtl.UniChar(@fFirstChar), Length);
  CoreFoundation.CFStringLowercase(lTmp, aLocale.PlatformLocale);
  var lTotal := CoreFoundation.CFStringGetLength(lTmp); // need to get converted string length, it can change
  result := String.AllocString(lTotal);
  CoreFoundation.CFStringGetCharacters(lTmp, CoreFoundation.CFRangeMake(0, lTotal), ^rtl.UniChar(@result.fFirstChar));
  {$ELSEIF POSIX AND NOT ANDROID}
  var b := Encoding.UTF32LE.GetBytes(self);
  for i: Int32 := 0 to RemObjects.Elements.System.length(b)-1 step 4 do begin
    var ch := b[i] + (Int32(b[i+1]) shl 8) + (Int32(b[i+2]) shl 16) + (Int32(b[i+3]) shl 24);
    var u := rtl.towlower_l(ch, aLocale.PlatformLocale);
    b[i] := u and $ff;
    b[i+1] := (u shr 8) and $ff;
    b[i+2] := (u shr 16) and $ff;
    b[i+3] := (u shr 24) and $ff;
  end;
  result := Encoding.UTF32LE.GetString(b);
  {$ELSEIF ANDROID}
  result := AllocString(self.Length);
  var lErr: UErrorCode;
  var lTotal := ICUHelper.UStrToLower(@result.fFirstChar, self.Length, @fFirstChar, self.Length, @aLocale.PlatformLocale.ToAnsiChars(true)[0], @lErr);
  if lErr <> UErrorCode.U_ZERO_ERROR then begin
    result := AllocString(lTotal);
    ICUHelper.UStrToLower(@result.fFirstChar, lTotal, @fFirstChar, self.Length, @aLocale.PlatformLocale.ToAnsiChars(true)[0], @lErr);
    if lErr <> UErrorCode.U_ZERO_ERROR then
      raise new Exception('Error calling u_strToLower');
  end;
  {$ENDIF}
end;

method String.ToUpper(aLocale: Locale): String;
begin
  {$IFDEF WINDOWS}
  exit doLCMapString(aLocale, LCMapStringTransformMode.Upper);
  {$ELSEIF WEBASSEMBLY}
  // JavaScript standard does not have upperCase function with a locale as parameter yet
  exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.Toupper(@fFirstChar, Length, false), true);
  {$ELSEIF DARWIN}
  var lTmp := CoreFoundation.CFStringCreateMutable(nil, 0);
  CoreFoundation.CFStringAppendCharacters(lTmp, ^rtl.UniChar(@fFirstChar), Length);
  CoreFoundation.CFStringUppercase(lTmp, aLocale.PlatformLocale);
  var lTotal := CoreFoundation.CFStringGetLength(lTmp);
  result := String.AllocString(lTotal);
  CoreFoundation.CFStringGetCharacters(lTmp, CoreFoundation.CFRangeMake(0, lTotal), ^rtl.UniChar(@result.fFirstChar));
  {$ELSEIF POSIX AND NOT ANDROID}
  var b := Encoding.UTF32LE.GetBytes(self);
  for i: Int32 := 0 to RemObjects.Elements.System.length(b)-1 step 4 do begin
    var ch := b[i] + (Int32(b[i+1]) shl 8) + (Int32(b[i+2]) shl 16) + (Int32(b[i+3]) shl 24);
    var u := rtl.towupper_l(ch, aLocale.PlatformLocale);
    b[i] := u and $ff;
    b[i+1] := (u shr 8) and $ff;
    b[i+2] := (u shr 16) and $ff;
    b[i+3] := (u shr 24) and $ff;
  end;
  result := Encoding.UTF32LE.GetString(b);
  {$ELSEIF ANDROID}
  result := AllocString(self.Length);
  var lErr: UErrorCode;
  var lTotal := ICUHelper.UStrToUpper(@result.fFirstChar, self.Length, @fFirstChar, self.Length, @aLocale.PlatformLocale.ToAnsiChars(true)[0], @lErr);
  if lErr <> UErrorCode.U_ZERO_ERROR then begin
    result := AllocString(lTotal);
    ICUHelper.UStrToUpper(@result.fFirstChar, lTotal, @fFirstChar, self.Length, @aLocale.PlatformLocale.ToAnsiChars(true)[0], @lErr);
    if lErr <> UErrorCode.U_ZERO_ERROR then
      raise new Exception('Error calling u_strToLower');
  end;
  {$ENDIF}
end;

{ String_Constructors }

constructor String_Constructors(aArray: array of Char);
begin
  result := String.FromCharArray(aArray);
end;

constructor String_Constructors(c: ^Char; aCharCount: Integer);
begin
  result := String.FromPChar(c, aCharCount);
end;

constructor String_Constructors(c: ^Char);
begin
  result := String.FromPChar(c);
end;

constructor String_Constructors(c: Char; aCharCount: Integer);
begin
  result := String.FromRepeatedChar(c, aCharCount);
end;

constructor String_Constructors(c: Char);
begin
  result := String.FromChar(c);
end;

constructor String_Constructors(c: ^AnsiChar; aCharCount: Integer);
begin
  result := coalesce(String.FromPAnsiChars(c, aCharCount), "");
end;

constructor String_Constructors(c: ^AnsiChar);
begin
  result := coalesce(String.FromPAnsiChars(c), "");
end;

end.