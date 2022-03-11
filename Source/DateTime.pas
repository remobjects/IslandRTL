namespace RemObjects.Elements.System;

type
  DateTimePart = enum (Year, Month, Day, Hour, Minute, Second, MilliSeconds, DayOfWeek);

  DateTime = public partial record(IComparable)
  private
    fTicks : Int64;
  private
    method TwoCharStr(aInt: Integer): String;inline;
    begin
      if aInt < 10 then
        exit '0'+aInt.ToString
      else
        exit aInt.ToString;
    end;

{
    const DaysPerMonth: array [Boolean, 1..12] of Integer =
    [[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
     [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]];
}
  private
    method CompareTo(a: Object): Integer; public;
    begin
      if a is DateTime then
        exit fTicks.CompareTo(DateTime(a).fTicks);
      exit -1;
    end;

    method GetDaysPerMonth(aLeapYear: Boolean; aMonth: Integer): Integer;
    begin
      // bug 75466 - can't use arrays
      // exit DaysPerMonth[aLeapYear, aMonth];
      case aMonth of
        1: exit 31;
        2: exit if aLeapYear then 29 else 28;
        3: exit 31;
        4: exit 30;
        5: exit 31;
        6: exit 30;
        7: exit 31;
        8: exit 31;
        9: exit 30;
        10: exit 31;
        11: exit 30;
        12: exit 31;
      end;
    end;

    method ParseTicks(Index: DateTimePart): Integer;
    begin
      case &Index of
        DateTimePart.Year,
        DateTimePart.Month,
        DateTimePart.Day: begin
          var ltotal := fTicks div TicksPerDay;
          var y := 1;
          var temp := ltotal div DaysPer400Years;
          y := y + temp*400;
          ltotal := ltotal - (temp * DaysPer400Years);
          temp := ltotal div DaysPer100Years;
          if temp = 4 then temp := 3; // 4*DaysPer100Years != DaysPer400Years
          y := y + temp*100;
          ltotal := ltotal - (temp * DaysPer100Years);
          temp := ltotal div DaysPer4Years;
          y := y + temp*4;
          ltotal := ltotal - (temp * DaysPer4Years);
          temp := ltotal div DaysPerYear;
          if temp = 4 then temp := 3;  // 4*DaysPerYear != DaysPer4Years
          y := y + temp; // = 400*x1 + 100*x2 + 4*x3 + 1*x4
          if &Index = DateTimePart.Year then exit y;
          ltotal := ltotal - (temp * DaysPerYear)+1; // day is started from 1, so 0 ticks is `1 Jan 0001`
          var lisleap := isLeapYear(y);
          for i: Integer := 1 to 12 do begin
            if ltotal <= GetDaysPerMonth(lisleap, i) then begin
              case &Index of
                DateTimePart.Month: exit i;
                DateTimePart.Day:   exit ltotal;
              end;
            end;
            ltotal := ltotal - GetDaysPerMonth(lisleap, i);
          end;
          // this point should be not reachable
          raise new Exception('something is wrong with decoding data')
        end;
        DateTimePart.DayOfWeek: exit (fTicks div TicksPerDay +1) mod 7;
        DateTimePart.Hour: exit (fTicks div TicksPerHour) mod 24;
        DateTimePart.Minute: exit (fTicks div TicksPerMinute) mod 60;
        DateTimePart.Second: exit (fTicks div TicksPerSecond) mod 60;
        DateTimePart.MilliSeconds: exit (fTicks div TicksPerMillisecond) mod 1000;
      end;
    end;

    method &Add(Value: Integer; scale: Integer): DateTime;
    begin
      var num: Int64 := Int64(Value) * Int64(scale);
      if (num <= -MaxMillis) or ( num >= MaxMillis) then raise new Exception('Argument Out Of Range');
      exit AddTicks(num * TicksPerMillisecond);
    end;

    class method GetUtcNow: DateTime;
    begin
      {$IFDEF WINDOWS}
      var temp: rtl.SYSTEMTIME;
      rtl.GetSystemTime(@temp);
      exit DateTime.FromSystemTime(temp);
      {$ELSEIF ANDROID or DARWIN}
      var ts: rtl.__struct_timespec;
      rtl.clock_gettime({$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts);
      exit new DateTime(UnixDateOffset + (ts.tv_sec * TicksPerSecond) + (ts.tv_nsec / 100000));
      {$ELSEIF POSIX_LIGHT}
      var ts: rtl.__struct_timespec;
      rtl.timespec_get(@ts, rtl.TIME_UTC);
      exit new DateTime(UnixDateOffset + Int64(ts.tv_sec * TicksPerSecond) + (ts.tv_nsec / 100000));
      {$ELSEIF WEBASSEMBLY}
      exit new DateTime(Int64(UnixDateOffset + (WebAssemblyCalls.GetUTCTime * TicksPerMillisecond)));
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;
    {$IFDEF POSIX_LIGHT}
    class var fLocalInitialized: Integer;
    {$ENDIF}
    class method GetNow: DateTime;
    begin
      {$IFDEF WINDOWS}
      var temp: rtl.SYSTEMTIME;
      rtl.GetLocalTime(@temp);
      exit DateTime.FromSystemTime(temp);
      {$ELSEIF ANDROID or DARWIN}
      var ts: rtl.__struct_timespec;
      rtl.clock_gettime({$IFDEF DARWIN}rtl.clockid_t._CLOCK_REALTIME{$ELSE}rtl.CLOCK_REALTIME{$ENDIF}, @ts);
      //exit new DateTime(UnixDateOffset + (ts.tv_sec * TicksPerSecond) + (ts.tv_nsec / 100000));
      exit FromUnixTimeUTC(ts);
      {$ELSEIF POSIX_LIGHT}
      var ts: rtl.__struct_timespec;
      rtl.timespec_get(@ts, rtl.TIME_UTC);
      exit FromUnixTimeUTC(ts);
      {$ELSEIF WEBASSEMBLY}
      exit new DateTime(Int64(UnixDateOffset + (WebAssemblyCalls.GetLocalTime * TicksPerMillisecond)));
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method GetDate: DateTime;
    begin
      exit new DateTime(fTicks -  fTicks mod TicksPerDay);
    end;


  public
    const MillisPerSecond     : Int32 = 1000;
    const MillisPerMinute     : Int32 = 60 * 1000;          // = 60000;
    const MillisPerHour       : Int32 = 60 * 60 *1000;      // = 3600000;
    const MillisPerDay        : Int32 = 24 * 60 * 60 *1000; // = 86400000;

    const TicksPerMillisecond : Int64 = 10000;
    const TicksPerSecond      : Int64 = TicksPerMillisecond * MillisPerSecond;  // = 10000000;
    const TicksPerMinute      : Int64 = TicksPerMillisecond * MillisPerMinute;  // = 600000000;
    const TicksPerHour        : Int64 = TicksPerMillisecond * MillisPerHour;    // = 36000000000;
    const TicksPerDay         : Int64 = TicksPerMillisecond * MillisPerDay;     // = 864000000000;
    const DaysTo1601          : Int32 = 584388;
    const DaysTo1899          : Int32 = 693593;
    const DaysTo1970          : Int32 = 719162;
    const DaysTo10000         : Int32 = 3652059;

    const DaysPerYear         : Int32 = 365;
    const DaysPer4Years       : Int32 = 1461;
    const DaysPer100Years     : Int32 = 36524;
    const DaysPer400Years     : Int32 = 146097;

    const FileTimeOffset      : Int64 = DaysTo1601 * TicksPerDay; // = 504911232000000000
    const DoubleDateOffset    : Int64 = DaysTo1899 * TicksPerDay; // = 599264352000000000
    const UnixDateOffset      : Int64 = DaysTo1970 * TicksPerDay; // = 621355968000000000
    const MaxMillis           : Int64 = DaysTo10000/10000 * TicksPerDay; // = 315537897600000; ticks per 1 year
    const MaxYear             : Int32 = 10000;

    {$IFDEF WINDOWS}
    class method FromFileTime(aFileTime: rtl.FILETIME): DateTime;
    begin
      var lFileTime: Int64 := Int64(aFileTime.dwHighDateTime) shl 32 + aFileTime.dwLowDateTime;
      if (lFileTime < 0) or (lFileTime > 2650467743999999999) then raise new Exception("Argument Out Of Range");
      var ticks := lFileTime + FileTimeOffset;
      exit new DateTime(ticks);
    end;

    class method FromSystemTime(aFileTime: rtl.SYSTEMTIME): DateTime;
    begin
      exit new DateTime(aFileTime.wYear, aFileTime.wMonth, aFileTime.wDay,
                        aFileTime.wHour, aFileTime.wMinute, aFileTime.wSecond, aFileTime.wMilliseconds);
    end;

    class method ToSystemTime(aDateTime: DateTime): rtl.SYSTEMTIME;
    begin
      result.wYear := aDateTime.Year;
      result.wMonth := aDateTime.Month;
      result.wDay := aDateTime.Day;
      result.wHour := aDateTime.Hour;
      result.wMinute := aDateTime.Minute;
      result.wSecond := aDateTime.Second;
      result.wMilliseconds := aDateTime.Milliseconds;
      result.wDayOfWeek := aDateTime.DayOfWeek;
    end;

    method ToSystemTime: rtl.SYSTEMTIME;
    begin
      exit ToSystemTime(self);
    end;
    {$ELSEIF POSIX_LIGHT}
    class method FromUnixTimeUTC(aStruct: rtl.__struct_timespec): DateTime;
    begin
      if InternalCalls.Exchange(var fLocalInitialized, 1) = 0 then
        rtl.tzset();
      var tom: rtl.__struct_tm;
      rtl.localtime_r(@aStruct.tv_sec, @tom);
      exit new DateTime(DateTime.UnixDateOffset + (aStruct.tv_sec+tom.tm_gmtoff) * DateTime.TicksPerSecond + aStruct.tv_nsec / 100 );
    end;

    class method FromUnixTime(aStruct: rtl.__struct_timespec): DateTime;
    begin
      exit new DateTime(DateTime.UnixDateOffset + aStruct.tv_sec * DateTime.TicksPerSecond + aStruct.tv_nsec / 100);
    end;
    {$ENDIF}

    class method FromOleDate(aDate: Double): DateTime;
    begin
      exit new DateTime(DoubleDateOffset + Int64(Math.Round(aDate * TicksPerDay)));
    end;

    class method ToOleDate(aDate: DateTime): Double;
    begin
      exit (Double(aDate.Ticks - DoubleDateOffset)  / TicksPerDay);
    end;

    constructor;
    begin
      fTicks := 0;
    end;

    constructor(aTicks: Int64);
    begin
      fTicks := aTicks;
    end;

    constructor(aYear, aMonth, aDay: Integer);
    begin
      constructor(aYear, aMonth, aDay, 0, 0, 0);
    end;

    constructor(aYear, aMonth, aDay, anHour, aMinute: Integer);
    begin
      constructor(aYear, aMonth, aDay, anHour, aMinute, 0);
    end;

    constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond: Integer);
    begin
      constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond, 0);
    end;

    constructor(aYear, aMonth, aDay, anHour, aMinute, aSecond, aMillisecond: Integer);
    begin
      if (aYear < 1) or (aYear > MaxYear) then raise new Exception("invalid year");
      if (aMonth < 1) or (aMonth >12) then raise new Exception("invalid month");
      var lisleap := isLeapYear(aYear);
      if (aDay < 1) or (aDay > GetDaysPerMonth(lisleap, aMonth)) then raise new Exception("invalid day");
      if (anHour < 0) or (anHour > 23) then raise new Exception("invalid hour");
      if (aMinute < 0) or (aMinute > 59) then raise new Exception("invalid minute");
      if (aSecond < 0) or (aSecond > 59) then raise new Exception("invalid second");
      if (aMillisecond < 0) or (aMillisecond > 999) then raise new Exception("invalid millisecond");

      var lDays := aDay;
      for i: Integer := 0 to aMonth -1 do lDays := lDays + GetDaysPerMonth(lisleap, i);
      var lYear := aYear-1;
      fTicks := Int64((lYear*365 + lYear div 4 - lYear div 100 + lYear div 400 + lDays-1)*TicksPerDay +
                 anHour*TicksPerHour + aMinute*TicksPerMinute + aSecond*TicksPerSecond + aMillisecond*TicksPerMillisecond);
    end;

    method AddDays(Value: Integer): DateTime;
    begin
      exit new DateTime(fTicks + Value * TicksPerDay);
    end;

    method AddHours(Value: Integer): DateTime;
    begin
      exit new DateTime(fTicks + Value * TicksPerHour);
    end;

    method AddMinutes(Value: Integer): DateTime;
    begin
      exit new DateTime(fTicks + Value * TicksPerMinute);
    end;

    method AddMilliseconds(Value: Integer): DateTime;
    begin
      exit new DateTime(fTicks + Value * TicksPerMillisecond);
    end;

    method AddMonths(Value: Integer): DateTime;
    begin
      var lYear := Year + (Value div 12);
      var lMonth:= Month + (Value mod 12);

      if (lMonth < 1) then begin
        lYear := lYear - 1;
        lMonth := lMonth + 12;
      end
      else if lMonth > 12 then begin
        lYear := lYear + 1;
        lMonth := lMonth - 12;
      end;
      var lNewDay := GetDaysPerMonth(isLeapYear(lYear), lMonth);
      var lDay  := Day;
      if lDay > lNewDay then lDay := lNewDay;

      exit new DateTime(new DateTime(lYear, lMonth, lDay).Ticks + fTicks mod TicksPerDay);
    end;

    method AddSeconds(Value: Integer): DateTime;
    begin
      exit &Add(Value, MillisPerSecond);
    end;

    method AddYears(Value: Integer): DateTime;
    begin
      if (Value < -MaxYear) or (Value > MaxYear) then raise new Exception("Argument Out Of Range");
      exit AddMonths(Value * 12);
    end;

    method AddTicks(Value: Int64): DateTime;
    begin
      exit new DateTime(fTicks + Value);
    end;

    method CompareTo(Value: DateTime): Integer;
    begin
      result := fTicks - Value.Ticks;
    end;

    method ToString(aTimeZone: TimeZone): String;
    begin
      exit ToString(Locale.Current.DateTimeFormat.LongDatePattern + ' ' + Locale.Current.DateTimeFormat.LongTimePattern, Locale.Current, aTimeZone);
    end;

    method ToString(Format: String; aTimeZone: TimeZone := nil): String;
    begin
      exit ToString(Format, Locale.Current, aTimeZone);
    end;

    method ToString(Format: String; Culture: String; aTimeZone: TimeZone := nil): String;
    begin
      exit ToString(Format, if String.IsNullOrEmpty(Culture) then Locale.Current else new Locale(Culture), aTimeZone);
    end;

    method ToString(Format: String; aLocale: Locale := nil; aTimeZone: TimeZone := nil): String;
    begin
      exit InternalToString(Format, aLocale, aTimeZone);
    end;

    method ToShortDateString(aTimeZone: TimeZone := nil): String;
    begin
      {$IFDEF WINDOWS OR POSIX_LIGHT}
      exit ToString(Locale.Current.DateTimeFormat.ShortDatePattern, aTimeZone);
      {$ELSEIF WEBASSEMBLY}
      exit String.Format('{0}-{1}-{2}',[Year.ToString,TwoCharStr(Month),TwoCharStr(Day)]);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method ToShortTimeString(aTimeZone: TimeZone := nil): String;
    begin
      {$IFDEF WINDOWS OR POSIX_LIGHT}
      exit ToString(Locale.Current.DateTimeFormat.ShortTimePattern, aTimeZone);
      {$ELSEIF WEBASSEMBLY}
      exit String.Format('{0}:{1}:{2}',[TwoCharStr(Hour),TwoCharStr(Minute), TwoCharStr(Second)]);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method ToShortPrettyDateString(aTimeZone: TimeZone := nil): String;
    begin
      {$IFDEF WINDOWS OR POSIX_LIGHT}
      exit ToString(Locale.Current.DateTimeFormat.ShortDatePattern);
      {$ELSEIF WEBASSEMBLY}
      exit String.Format('{0}-{1}-{2}',[Year.ToString,TwoCharStr(Month),TwoCharStr(Day)]);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method ToLongPrettyDateString(aTimeZone: TimeZone := nil): String;
    begin
      {$IFDEF WINDOWS OR POSIX_LIGHT}
      result := ToString(Locale.Current.DateTimeFormat.LongDatePattern, aTimeZone);
      {$ELSEIF WEBASSEMBLY}
      exit String.Format('{0}-{1}-{2}',[Year.ToString, TwoCharStr(Month) ,TwoCharStr(Day)]);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method ToString: String; override;
    begin
      {$IFDEF WINDOWS OR POSIX_LIGHT}
      exit ToString(Locale.Current.DateTimeFormat.ShortDatePattern + ' ' + Locale.Current.DateTimeFormat.LongTimePattern);
      {$ELSEIF WEBASSEMBLY}
      exit String.Format('{0}-{1}-{2} {3}:{4}:{5}',[Year.ToString, TwoCharStr(Month), TwoCharStr(Day), TwoCharStr(Hour), TwoCharStr(Minute), TwoCharStr(Second)]);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    class method TryParse(aDateTime: String; aOptions: DateParserOptions := []): nullable DateTime;
    begin
      if DateParser.TryParse(aDateTime, out var lResult, aOptions) then
      result := lResult;
    end;

    class method TryParse(aDateTime: String; aLocale: Locale; aOptions: DateParserOptions := []): nullable DateTime;
    begin
      if DateParser.TryParse(aDateTime, aLocale, out var lResult, aOptions) then
      result := lResult;
    end;

    class method TryParse(aDateTime: String; aFormat: String; aOptions: DateParserOptions := []): nullable DateTime;
    begin
      if DateParser.TryParse(aDateTime, aFormat, out var lResult, aOptions) then
      result := lResult;
    end;

    class method TryParseISO8601(aDateTime: String): nullable DateTime;
    begin
      if DateParser.TryParseISO8601(aDateTime, out var lResult) then
      result := lResult;
    end;

    class method TryParse(aDateTime: String; aFormat: String; aLocale: Locale; aOptions: DateParserOptions := []): nullable DateTime;
    begin
      if DateParser.TryParse(aDateTime, aFormat, aLocale, out var lResult, aOptions) then
      result := lResult;
    end;

    method &Equals(obj: Object): Boolean; override;
    begin
      if assigned(obj) and (obj is DateTime) then
        exit self = DateTime(obj)
      else
        exit False;
    end;

    property Year: Integer read ParseTicks(DateTimePart.Year);
    property Month: Integer read ParseTicks(DateTimePart.Month);
    property Day: Integer read ParseTicks(DateTimePart.Day);
    property DayOfWeek: Integer read ParseTicks(DateTimePart.DayOfWeek);
    property Hour: Integer read ParseTicks(DateTimePart.Hour);
    property Minute: Integer read ParseTicks(DateTimePart.Minute);
    property Second: Integer read ParseTicks(DateTimePart.Second);
    property Milliseconds: Integer read ParseTicks(DateTimePart.MilliSeconds);

    property Date: DateTime read GetDate;

    class property Today: DateTime read Now.Date;
    class property Now: DateTime read GetNow;
    class property UtcNow: DateTime read GetUtcNow;

    //property TimeSince: TimeSpan read (UtcNow-self);
    //class method TimeSince(aOtherDateTime: DateTime): TimeSpan;

    property Ticks: Int64 read fTicks;

    class method isLeapYear(Value: Integer): Boolean;
    begin
      exit ((Value mod 400 = 0) or (Value mod 100 <> 0)) and (Value mod 4 = 0);
    end;

    class operator Equal(Value1, Value2: DateTime): Boolean;
    begin
      exit (Value1.fTicks = Value2.fTicks);
    end;

    {$IF DARWIN}
    operator Implicit(aDateTime: Foundation.NSDate): DateTime;
    begin
      result := new DateTime(Int64((aDateTime.timeIntervalSince1970*10000000)+621355968000000000));
    end;

    operator Implicit(aDateTime: DateTime): Foundation.NSDate;
    begin
      result := new Foundation.NSDate withTimeIntervalSince1970((aDateTime.fTicks-621355968000000000)/10000000.0);
    end;

    operator Explicit(aDateTime: Foundation.NSDate): DateTime; // code duped for efficiency
    begin
      result := new DateTime(Int64((aDateTime.timeIntervalSince1970*10000000)+621355968000000000));
    end;

    operator Explicit(aDateTime: DateTime): Foundation.NSDate; // code duped for efficiency
    begin
      result := new Foundation.NSDate withTimeIntervalSince1970((aDateTime.fTicks-621355968000000000)/10000000.0);
    end;
    {$ENDIF}

  end;


end.