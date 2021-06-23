namespace RemObjects.Elements.System;

interface

type
  DateParserOption = public enum(UseCurrentForMissing) of Integer;
  DateParserOptions = public set of DateParserOption;

  DateParser = public class
  private
    class method GetNextStringToken(var aFormat: String): String;
    class method GetNextNumberToken(var aFormat: String; aMaxLength: Integer): String;
    class method GetNextNumberToken(var aFormat: String; var aNumber: Integer; aMaxLength: Integer): Boolean;
    class method GetNextNumberToken(var aFormat: String; var aNumber: Integer; aMin: Integer; aMax: Integer; aMaxLength: Integer): Boolean;
    class method GetNextSepOrStringToken(var aFormat: String): String;
    class method SkipToNextToken(var aFormat: String; var aDateTime: String): Boolean;
    class method SkipToken(aToken: String; var aFormat: String): Boolean;
    class method StandardToInternalPattern(aFormat: String; aLocale: Locale; var output: String): Boolean;
    class method CheckIfAny(aToken: String; aValues: array of String): Boolean;
    class method NormalizeChar(aChar: Char): Char;
    class method ParseSecondFraction(aFormat: String; var aDateTime: String; var aMilliseconds: Integer): Boolean;
    class method CheckAndSetDateTime(aYear, aMonth, aDay, aHour, aMin, aSecond, aMSec: Integer; aOptions: DateParserOptions := []): DateTime;
    class method InternalParse(aDateTime: String; aFormat: String; aLocale: Locale; out output: DateTime; aOptions: DateParserOptions): Boolean;
  public
    class method TryParse(aDateTime: String; out output: DateTime; aOptions: DateParserOptions := []): Boolean;
    class method TryParse(aDateTime: String; aLocale: Locale; out output: DateTime; aOptions: DateParserOptions := []): Boolean;
    class method TryParse(aDateTime: String; aFormat: String; out output: DateTime; aOptions: DateParserOptions := []): Boolean;
    class method TryParseISO8601(aDateTime: String; out output: DateTime): Boolean;
    class method TryParse(aDateTime: String; aFormat: String; aLocale: Locale; out output: DateTime; aOptions: DateParserOptions := []): Boolean;
  end;

  const MaxValue = 2147483647;

implementation

class method DateParser.NormalizeChar(aChar: Char): Char;
begin
  case aChar of
    'á', 'Á', 'à', 'À': result := 'a';
    'é', 'É', 'è', 'È': result := 'e';
    'í', 'Í', 'ì', 'Ì': result := 'i';
    'ó', 'Ó', 'ò', 'Ò': result := 'o';
    'ú', 'Ú', 'ù', 'Ù': result := 'u';
    else
      result := aChar;
  end;
end;

class method DateParser.GetNextStringToken(var aFormat: String): String;
begin
  if aFormat.Length = 0 then exit '';

  var lIndex := 0;
  var lChar := NormalizeChar(aFormat[lIndex]);
  var lFirstChar := lChar;
  while (lIndex < aFormat.Length) and (((lChar >= chr('a')) and (lChar <= chr('z'))) or ((lChar >= chr('A')) and (lChar <= chr('Z')))) and (lFirstChar = lChar) do begin
    inc(lIndex);
    if lIndex < aFormat.Length then
      lChar := NormalizeChar(aFormat[lIndex]);
  end;
  result := aFormat.Substring(0, lIndex);
  if lIndex < aFormat.Length then
    aFormat := aFormat.Substring(lIndex)
  else
    aFormat := '';
end;

class method DateParser.GetNextNumberToken(var aFormat: String; aMaxLength: Integer): String;
begin
  if aFormat.Length = 0 then exit '';

  var lIndex := 0;
  var lChar := aFormat[lIndex];
  while (lIndex < aFormat.Length) and (((lChar >= chr('0')) and (lChar <= chr('9')))) and (lIndex < aMaxLength) do begin
    inc(lIndex);
    if lIndex < aFormat.Length then
      lChar := aFormat[lIndex];
  end;
  result := aFormat.Substring(0, lIndex);
  if lIndex < aFormat.Length then
    aFormat := aFormat.Substring(lIndex)
  else
    aFormat := '';
end;

class method DateParser.GetNextNumberToken(var aFormat: String; var aNumber: Integer; aMaxLength: Integer): Boolean;
begin
  var lToken := GetNextNumberToken(var aFormat, aMaxLength);
  //var lNumber := Convert.TryToInt32(lToken);
  //result := assigned(lNumber);
  var lNumber: Int64;
  result := Convert.TryParseInt64(lToken, out lNumber, false);
  if result then
    aNumber := lNumber;
end;

class method DateParser.GetNextNumberToken(var aFormat: String; var aNumber: Integer; aMin: Integer; aMax: Integer; aMaxLength: Integer): Boolean;
begin
  result := GetNextNumberToken(var aFormat, var aNumber, aMaxLength) and (aNumber >= aMin) and (aNumber <= aMax);
end;

class method DateParser.GetNextSepOrStringToken(var aFormat: String): String;
begin
  if aFormat.Length = 0 then exit '';

  var lIndex := 0;
  var lChar := NormalizeChar(aFormat[lIndex]);
  case lChar of
    '"', '''': begin
      inc(lIndex);
      while (aFormat[lIndex] <> lChar) and (lIndex < aFormat.Length) do inc(lIndex);
      result := aFormat.Substring(1, lIndex - 1);
      aFormat := aFormat.Substring(lIndex);
    end

    else begin
      while (lIndex < aFormat.Length) and (not (lChar in ['a'..'z'])) and (not (lChar in ['A'..'Z']) and (not (lChar in ['0'..'9']))) do begin
        inc(lIndex);
        lChar := NormalizeChar(aFormat[lIndex]);
      end;
      if lIndex > 0 then begin
        result := aFormat.Substring(0, lIndex);
        aFormat := aFormat.Substring(lIndex);
      end
      else exit '';
    end;
  end;
end;

class method DateParser.SkipToNextToken(var aFormat: String; var aDateTime: String): Boolean;
begin
  var lToken := GetNextSepOrStringToken(var aFormat);
  while lToken.Length > 0 do begin
    if aDateTime.StartsWith(lToken) then
      aDateTime := aDateTime.Substring(lToken.Length)
    else
      exit false;
    lToken := GetNextSepOrStringToken(var aFormat);
  end;
  result := true;
end;

class method DateParser.SkipToken(aToken: String; var aFormat: string): Boolean;
begin
  if aFormat.StartsWith(aToken) then begin
    aFormat := aFormat.Substring(aToken.Length);
    exit true;
  end;
  exit false;
end;

class method DateParser.ParseSecondFraction(aFormat: string; var aDateTime: string; var aMilliseconds: Integer): Boolean;
begin
  var lTmp: Integer := 0;
  case aFormat of
    'f', 'F': begin // tenths of a second
      if not GetNextNumberToken(var aDateTime, var lTmp, 0, 9, 1) then
        exit false;
      aMilliseconds := lTmp * 100;
    end;

    'ff', 'FF': begin // hundredths of a second
      if not GetNextNumberToken(var aDateTime, var lTmp, 0, 99, 2) then
        exit false;
      aMilliseconds := lTmp * 10;
    end;

    'fff', 'FFF': begin // milliseconds
      if not GetNextNumberToken(var aDateTime, var aMilliseconds, 0, 999, 3) then
        exit false;
    end;

    'ffff', 'FFFF': begin // ten thousandths of a second
      if not GetNextNumberToken(var aDateTime, var lTmp, 0, 9999, 4) then
        exit false;
      aMilliseconds := Integer(Math.Round(lTmp / 10));
    end;

    'fffff', 'FFFFF': begin // hundred thousandths of a second
      if not GetNextNumberToken(var aDateTime, var lTmp, 0, 99999, 5) then
        exit false;
      aMilliseconds := Integer(Math.Round(lTmp / 100));
    end;

    'ffffff', 'FFFFFF': begin // millionths of a second
      if not GetNextNumberToken(var aDateTime, var lTmp, 0, 999999, 6) then
        exit false;
      aMilliseconds := Integer(Math.Round(lTmp / 1000));
    end;

    'fffffff', 'FFFFFFF': begin // ten millionths of a second
      if not GetNextNumberToken(var aDateTime, var lTmp, 0, 9999999, 7) then
        exit false;
      aMilliseconds := Integer(Math.Round(lTmp / 10000));
    end;
  end;
  exit true;
end;

class method DateParser.StandardToInternalPattern(aFormat: String; aLocale: Locale; var output: String): Boolean;
begin
  case aFormat of
    'd': output := aLocale.DateTimeFormat.ShortDatePattern; // Short date pattern
    'D': output := aLocale.DateTimeFormat.LongDatePattern; // Long date pattern
    'f': output:= aLocale.DateTimeFormat.LongDatePattern + ' ' + aLocale.DateTimeFormat.ShortTimePattern; // Full date/time pattern (short time)
    'F': output:= aLocale.DateTimeFormat.LongDatePattern + ' ' + aLocale.DateTimeFormat.LongTimePattern; // Full date/time pattern (long time)
    'g': output:= aLocale.DateTimeFormat.ShortDatePattern + ' ' + aLocale.DateTimeFormat.ShortTimePattern; // General date/time pattern (short time)
    'G': output:= aLocale.DateTimeFormat.ShortDatePattern + ' ' + aLocale.DateTimeFormat.LongTimePattern; // General date/time pattern (long time)
    't': output := aLocale.DateTimeFormat.ShortTimePattern; // Short time pattern
    'T': output := aLocale.DateTimeFormat.LongTimePattern; // Long time pattern
    'o', 'O': output := 'yyyy-MM-ddTHH:mm:ss.fffffffK'; // ISO 8601

    else
      exit false;
  end;

  result := true;
end;

class method DateParser.CheckIfAny(aToken: String; aValues: array of String): Boolean;
begin
  for i: Integer := 0 to aValues.Length - 1 do
    //if String.EqualsIgnoringCaseInvariant(aToken, aValues[i]) then
    if aToken.EqualsIgnoreCaseInvariant(aValues[i]) then
      exit true;

  exit false;
end;

class method DateParser.CheckAndSetDateTime(aYear, aMonth, aDay, aHour, aMin, aSecond, aMSec: Integer; aOptions: DateParserOptions): DateTime;
begin
  if aYear = 0 then
    aYear := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Year else 1;
  if aMonth = 0 then
    aMonth := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Month else 1;
  if aDay = 0 then
    aDay := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Day else 1;
  if aHour = -1 then
    aHour := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Hour else 0;
  if aMin = -1 then
    aMin := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Minute else 0;
  if aSecond = -1 then
    aSecond := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Second else 0;
  if aMSec = -1 then
    aMSec := if [DateParserOption.UseCurrentForMissing] in aOptions then DateTime.Today.Second else 0;

  result := new DateTime(aYear, aMonth, aDay, aHour, aMin, aSecond, aMSec);
end;

// "mm/dd/yyyy hh:nn:ss" --> "1/23/2018 4:55:23"
class method DateParser.InternalParse(aDateTime: String; aFormat: String; aLocale: Locale; out output: DateTime; aOptions: DateParserOptions): Boolean;
begin
  var lDay: Integer := 0;
  var lMonth: Integer := 0;
  var lYear: Integer := 0;
  var lHour: Integer := -1;
  var lMin: Integer := -1;
  var lSec: Integer := -1;
  var lMSec: Integer := -1;
  var lOffset: Integer := 0;
  var lOffsetMin: Integer := 0;
  var lTmp: String;
  var lFormat := aFormat.Trim;
  var lDateTime := aDateTime.Trim;
  if not SkipToNextToken(var lFormat, var lDateTime) then
    exit false;
  var lToken := GetNextStringToken(var lFormat);

  while lToken.Length > 0 do begin
    case lToken of
      'd': begin // day 1 --> 31
        if not GetNextNumberToken(var lDateTime, var lDay, 1, 31, 2) then
          exit false;
      end;

      'dd': begin // day 01 --> 31
        if not GetNextNumberToken(var lDateTime, var lDay, 1, 31, 2) then
          exit false;
      end;

      'ddd': begin // day, short name, Wed
        lTmp := GetNextStringToken(var lDateTime);
        if not CheckIfAny(lTmp, aLocale.DateTimeFormat.ShortDayNames) then
          exit false;
      end;

      'dddd': begin // day, long name, Wednesday
        lTmp := GetNextStringToken(var lDateTime);
        if not CheckIfAny(lTmp, aLocale.DateTimeFormat.LongDayNames) then
          exit false;
      end;

      'M': begin // month 1 --> 12
        if not GetNextNumberToken(var lDateTime, var lMonth, 1, 12, 2) then
          exit false;
      end;

      'MM': begin // month 01 --> 12
        if not GetNextNumberToken(var lDateTime, var lMonth, 1, 12, 2) then
          exit false;
      end;

      'MMM': begin // month, short name, Jun
        lTmp := GetNextStringToken(var lDateTime);
        if not CheckIfAny(lTmp, aLocale.DateTimeFormat.ShortMonthNames) then
          exit false;
      end;

      'MMMM': begin // month, long name, June
        lTmp := GetNextStringToken(var lDateTime);
        if not CheckIfAny(lTmp, aLocale.DateTimeFormat.LongMonthNames) then
          exit false;
      end;

      'y': begin // year, 0 --> 99
        if not GetNextNumberToken(var lDateTime, var lYear, 0, MaxValue, 2) then
          exit false;
      end;

      'yy': begin // year, 00 --> 99
        if not GetNextNumberToken(var lDateTime, var lYear, 0, MaxValue, 2) then
          exit false;
      end;

      'yyy': begin // year, 001 --> 900 , 1900 --> 2018, minimum three digits
        if not GetNextNumberToken(var lDateTime, var lYear, 0, MaxValue, 4) then
          exit false;
      end;

      'yyyy': begin // year, 0001 --> 2018 , four digits
        if not GetNextNumberToken(var lDateTime, var lYear, 0, MaxValue, 4) then
          exit false;
      end;

      'yyyyy': begin // year, 00001 --> 02018, five digits
        if not GetNextNumberToken(var lDateTime, var lYear, 0, MaxValue, 5) then
          exit false;
      end;

      'h': begin // hour, 1 --> 12
        if not GetNextNumberToken(var lDateTime, var lHour, 1, 12, 2) then
          exit false;
      end;

      'hh': begin // hour, 01 --> 12
        if not GetNextNumberToken(var lDateTime, var lHour, 1, 12, 2) then
          exit false;
      end;

      'H': begin // hour, 0 --> 23
        if not GetNextNumberToken(var lDateTime, var lHour, 0, 23, 2) then
          exit false;
      end;

      'HH': begin // hour, 00 --> 23
        if not GetNextNumberToken(var lDateTime, var lHour, 0, 23, 2) then
          exit false;
      end;

      'm': begin // minutes, 0 --> 59
        if not GetNextNumberToken(var lDateTime, var lMin, 0, 59, 2) then
          exit false;
      end;

      'mm': begin // minutes, 00 --> 59
        if not GetNextNumberToken(var lDateTime, var lMin, 0, 59, 2) then
          exit false;
      end;

      's': begin // seconds, 0 --> 59
        if not GetNextNumberToken(var lDateTime, var lSec, 0, 59, 2) then
          exit false;
      end;

      'ss': begin // seconds, 00 --> 59
        if not GetNextNumberToken(var lDateTime, var lSec, 0, 59, 2) then
          exit false;
      end;

      'f', 'ff', 'fff', 'ffff', 'fffff', 'ffffff', 'fffffff',
      'F', 'FF', 'FFF', 'FFFF', 'FFFFF', 'FFFFFF', 'FFFFFFF': begin
        if not ParseSecondFraction(lToken, var lDateTime, var lMSec) then
          exit false;
      end;

      't': begin // am/pm, first character only
        lTmp := GetNextSepOrStringToken(var lDateTime);
       end;

      'tt': begin // am/pm, full string
        lTmp := GetNextSepOrStringToken(var lDateTime);
      end;

      'T': begin // special case: separator for ISO 8601 strings
        lTmp := GetNextStringToken(var lDateTime);
        if lTmp ≠ 'T' then
          exit false;
      end;

      'K': begin // timezone info
        lTmp := GetNextStringToken(var lDateTime);
        if lTmp = 'Z' then
          lOffset := 0
        else begin
          lTmp := GetNextSepOrStringToken(var lDateTime);
          case lTmp of
            '+', '-': begin
              if not GetNextNumberToken(var lDateTime, var lOffset, 0, 23, 2) then
                exit false;
              if lTmp = '-' then
                lOffset := -lOffset;
              if (lDateTime ≠ '') and (SkipToken(":", var lDateTime)) then begin
                if not GetNextNumberToken(var lDateTime, var lOffsetMin, 0, 59, 2) then
                  exit false;
              end;
            end;

            '': lOffset := 0;
          end;
        end;
      end;

      'z', 'zz': begin // timezone, with no '0', -2
        lTmp := GetNextSepOrStringToken(var lDateTime);
        if (lTmp <> '+') and (lTmp <> '-') then exit false;
        if not GetNextNumberToken(var lDateTime, var lOffset, 0, 23, 2) then
          exit false;
        if lTmp = '-' then lOffset := -lOffset;
      end;

      'zzz': begin // timezone, with minutes, -02:00
        lTmp := GetNextSepOrStringToken(var lDateTime);
        if (lTmp <> '+') and (lTmp <> '-') then exit false;
        if not GetNextNumberToken(var lDateTime, var lOffset, 0, 23, 2) then
          exit false;
        if not SkipToken(":", var lDateTime) then
          exit false;
        if not GetNextNumberToken(var lDateTime, var lOffsetMin, 0, 59, 2) then
          exit false;
        if lTmp = '-' then lOffset := -lOffset;
      end;

      else begin // separators or literals
        lTmp := GetNextSepOrStringToken(var lFormat)
      end;
    end;

    if not SkipToNextToken(var lFormat, var lDateTime) then
      exit false;
    lToken := GetNextStringToken(var lFormat);
  end;
  output := CheckAndSetDateTime(lYear, lMonth, lDay, lHour, lMin, lSec, lMSec, aOptions);
  if lOffset ≠ 0 then
    output := output.AddHours(lOffset);
  result := true;
end;

class method DateParser.TryParse(aDateTime: String; out output: DateTime; aOptions: DateParserOptions): Boolean;
begin
  result := TryParse(aDateTime, Locale.Current, out  output, aOptions);
end;

class method DateParser.TryParse(aDateTime: String; aFormat: String; out output: DateTime; aOptions: DateParserOptions): Boolean;
begin
  if aFormat.Length = 1 then
    if not StandardToInternalPattern(aFormat, Locale.Current, var aFormat) then
      exit false;

  result := InternalParse(aDateTime, aFormat, Locale.Current, out output, aOptions);
end;

class method DateParser.TryParseISO8601(aDateTime: String; out output: DateTime): Boolean;
begin
  var lFormats := ['yyyy-MM-ddTHH:mm:ss.fffffffK', 'yyyy-MM-ddTHH:mm:ss.fffffffzzz', 'yyyy-MM-ddTHH:mm:ssK', 'yyyy-MM-ddTHH:mm:ss.fK'];
  for lFormat in lFormats do begin
    result := InternalParse(aDateTime, lFormat, Locale.Invariant, out output, []);
    if result then
      exit;
  end;
end;

class method DateParser.TryParse(aDateTime: String; aLocale: Locale; out output: DateTime; aOptions: DateParserOptions): Boolean;
begin
  // 1. string with a date and time component, including long and short patterns.
  // 2. only date component
  // 3. time with seconds
  // 4. time with no seconds
  var lFormats := new String[8];
  lFormats[0] := aLocale.DateTimeFormat.LongDatePattern + ' ' + aLocale.DateTimeFormat.LongTimePattern; // long date, long time
  lFormats[1] := aLocale.DateTimeFormat.LongDatePattern + ' ' + aLocale.DateTimeFormat.ShortTimePattern; // long date, short time
  lFormats[2] := aLocale.DateTimeFormat.ShortDatePattern + ' ' + aLocale.DateTimeFormat.LongTimePattern; // short date, long time
  lFormats[3] := aLocale.DateTimeFormat.ShortDatePattern + ' ' + aLocale.DateTimeFormat.ShortTimePattern; // short date, short time

  lFormats[4] := aLocale.DateTimeFormat.LongDatePattern; // long date
  lFormats[5] := aLocale.DateTimeFormat.ShortDatePattern; // short date
  lFormats[6] := aLocale.DateTimeFormat.LongTimePattern; // long time
  lFormats[7] := aLocale.DateTimeFormat.ShortTimePattern; // short time
  for each lFormat in lFormats do
    if InternalParse(aDateTime, lFormat, aLocale, out  output, aOptions) then
      exit true;

  result := false;
end;

class method DateParser.TryParse(aDateTime: String; aFormat: String; aLocale: Locale; out output: DateTime; aOptions: DateParserOptions): Boolean;
begin
  if aFormat.Length = 1 then
    if not StandardToInternalPattern(aFormat, aLocale, var aFormat) then
      exit false;

  result := InternalParse(aDateTime, aFormat, aLocale, out  output, aOptions);
end;

end.