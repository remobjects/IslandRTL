namespace RemObjects.Elements.System;

type
	DateTimePart = enum (Year, Month, Day, Hour, Minute, Second, MilliSeconds, DayOfWeek);

	DateTime = public record
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
			{$ELSEIF POSIX}
			var ts: rtl.__struct_timespec;
			rtl.timespec_get(@ts, rtl.TIME_UTC);
			exit new DateTime(UnixDateOffset + Int64(ts.tv_sec * TicksPerSecond) + (ts.tv_nsec / 100000));
			{$ELSEIF WEBASSEMBLY}
			exit new DateTime(Int64(UnixDateOffset + (WebAssemblyCalls.GetUTCTime * TicksPerMillisecond)));
			{$ELSE}{$ERROR}
			{$ENDIF}
		end;
		{$IFDEF POSIX}
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
			{$ELSEIF POSIX}
			var ts: rtl.__struct_timespec;
			rtl.timespec_get(@ts, rtl.TIME_UTC);
			exit FromUnixTimeUTC(ts);
			{$ELSEIF WEBASSEMBLY}
			exit new DateTime(Int64(UnixDateOffset + (WebAssemblyCalls.GetLocalTime * TicksPerMillisecond)));
			{$ELSE}{$ERROR}
			{$ENDIF}
		end;

		method GetDate: DateTime;
		begin
			exit new DateTime(fTicks -  fTicks mod TicksPerDay);
		end;

		method TryToExpandFormat(aFormat: String; aLocale: Locale): String;
		begin
			case aFormat of
				'd': exit ""; // short date
				'D': exit ""; // long date
				'f': exit ""; // long date, short time
				'F': exit ""; // long date, long time
				'g': exit ""; // general date and time, short time
				'G': exit ""; // general date and time, long time
				'M', 'm': exit ""; // month, day
				'O', 'o': exit "";
				'R', 'r': exit ""; //RFC 1123
				's': exit ""; // sortable
				't': exit ""; // short time
				'T': exit ""; // long time
				'u': exit ""; // universal
				'U': exit ""; // universal (long)
				'Y', 'y': exit ""; // month, year

				//default: exit aFormat;
			end;
			exit aFormat;
		end;

		method GetNextFormatToken(var aFormat: String): String;
		begin
			result := '';
			if aFormat.Length > 0 then begin
				var lChar := aFormat[0];
				var lSize := 0;
				case lChar of
					':', '/': begin result := lChar; lSize := 1; end;

					'%', '\': begin
						if aFormat.Length > 1 then
							result := lChar + aFormat[1]
						else
							result := lChar;
						lSize := 2;
					end;

					'''', '"': begin
						var i := 1;
						while (i < aFormat.Length) do begin
							if aFormat[i] = lChar then begin
								lSize := i + 1;
								break;
							end;
							inc(i);
						end;
						if lSize = 0 then begin // no matching ' or " found
							lSize := 1;
							result := lChar;
						end
						else
							result := aFormat.Substring(0, i + 1);
					end;

					'd', 'f', 'F', 'g', 'h', 'H', 'K', 'm',
						'M', 's', 't', 'y', 'z': begin
						var lMax: Integer;
						case lChar of
							'K': lMax := 1;
							'f', 'F': lMax := 7;
							'g', 'h', 'H', 'm', 's', 't': lMax := 2;
							'z': lMax := 3;
							'd', 'M': lMax := 4;
							'y': lMax := 5;
						end;
						var i := 1;
						while (i < aFormat.Length) and (aFormat[i] = lChar) and (i < lMax) do
							inc(i);
						lSize := i;
						result := aFormat.Substring(0, i);
					end;

					else begin
						lSize := 1;
						result := lChar;
					end;
				end;
				if lSize < aFormat.Length then
					aFormat := aFormat.Substring(lSize)
				else
					aFormat := '';
			end;
		end;

		method ProcessToStringToken(aLocale: Locale; aTimeZone: TimeZone; aOutput: StringBuilder; aToken: String);
		begin
			case aToken of
				'd', 'dd': begin // month day, 1-31
					if aToken.Length = 1 then
						aOutput.Append(Day.ToString)
					else
						aOutput.Append(Day.ToString.PadStart(2, '0'));
				end;

				'ddd': begin // abbreviated dayweek
					aOutput.Append(aLocale.DateTimeFormat.ShortDayNames[DayOfWeek]);
				end;

				'dddd': begin // fullname dayweek
					aOutput.Append(aLocale.DateTimeFormat.LongDayNames[DayOfWeek]);
				end;

				'f', 'F', 'ff', 'FF', 'fff', 'FFF',
				'ffff', 'FFFF', 'fffff', 'FFFFF',
				'ffffff', 'FFFFFF', 'fffffff', 'FFFFFFF': begin
					var lZero := aToken[0] = 'f';
					var lValue := (fTicks div Int64(Math.Pow(10, (7 - aToken.Length)))) mod Int64(Math.Pow(10, aToken.Length));
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;


				{'f', 'F': begin // tenths of a second
					var lZero := aToken[0] = 'f';
					var lValue := (fTicks div 1000000) mod 10;
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;

				'ff', 'FF': begin // hundredths of a second
					var lZero := aToken[0] = 'f';
					var lValue := (fTicks div 100000) mod 100;
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;

				'fff', 'FFF': begin // thousandths of a second
					var lZero := aToken[0] = 'f';
					if (Milliseconds > 0) or lZero then
						aOutput.Append(Milliseconds.ToString.PadStart(aToken.Length, '0'));
				end;

				'ffff', 'FFFF': begin // ten thousandths of a second
					var lZero := aToken[0] = 'f';
					var lValue := (fTicks div 1000) mod 10000;
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;

				'fffff', 'FFFFF': begin // hundred thousandths of a second
					var lZero := aToken[0] = 'f';
					var lValue := (fTicks div 100) mod 100000;
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;

				'ffffff', 'FFFFFF': begin // millionths of a second
					var lZero := aToken[0] = 'f';
					var lValue := (fTicks div 10) mod 1000000;
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;

				'fffffff', 'FFFFFFF': begin // diezmillonésimas de segundo
					var lZero := aToken[0] = 'f';
					var lValue := fTicks mod 10000000;
					if (Milliseconds > 0) or lZero then
						aOutput.Append(lValue.ToString.PadStart(aToken.Length, '0'));
				end;}

				'g', 'gg': begin // era

				end;

				'h', 'hh': begin // hour, 1-12
					var lHour := if Hour > 12 then Hour - 12 else Hour;
					if aToken.Length = 1 then
						aOutput.Append(lHour.ToString)
					else
						aOutput.Append(lHour.ToString.PadStart(2, '0'));
				end;

				'H', 'HH': begin // hour, 1-23
					if aToken.Length = 1 then
						aOutput.Append(Hour.ToString)
					else
						aOutput.Append(Hour.ToString.PadStart(2, '0'));
				end;

				'K': begin // Timezone info
					aOutput.Append(aTimeZone.Identifier);
				end;

				'm', 'mm': begin // minute, 0-59
					if aToken.Length = 1 then
						aOutput.Append(Minute.ToString)
					else
						aOutput.Append(Minute.ToString.PadStart(2, '0'));
				end;

				'M', 'MM': begin // month, 1-12
					if aToken.Length = 1 then
						aOutput.Append(Month.ToString)
					else
						aOutput.Append(Month.ToString.PadStart(2, '0'));
				end;

				'MMM': begin // month name, abbreviated
					aOutput.Append(aLocale.DateTimeFormat.ShortMonthNames[Month]);
				end;

				'MMMM': begin // month name
					aOutput.Append(aLocale.DateTimeFormat.LongMonthNames[Month]);
				end;

				's', 'ss': begin // seconds, 0-59
					if aToken.Length = 1 then
						aOutput.Append(Second.ToString)
					else
						aOutput.Append(Second.ToString.PadStart(2, '0'));
				end;

				't': begin // first AM/PM character
					var lData := if Hour > 12 then aLocale.DateTimeFormat.PMString else aLocale.DateTimeFormat.AMString;
					if lData.Length > 0 then
						aOutput.Append(lData[0]);
				end;

				'tt': begin // AM/PM
					var lData := if Hour > 12 then aLocale.DateTimeFormat.PMString else aLocale.DateTimeFormat.AMString;
					if lData.Length > 0 then
						aOutput.Append(lData);
				end;

				'y', 'yy', 'yyy', 'yyyy', 'yyyyy': begin // year
					if aToken.Length = 1 then
						aOutput.Append(Year.ToString)
					else
						aOutput.Append(Year.ToString.PadStart(aToken.Length, '0'));
				end;

				'z', 'zz': begin // hours from UTC
					var lData := aTimeZone.OffsetToUTC div 60;
					if aToken.Length = 1 then
						aOutput.Append(lData.ToString)
					else
						aOutput.Append(lData.ToString.PadStart(aToken.Length, '0'));
				end;

				'zzz': begin // hours and minutes from UTC
					var lHours := aTimeZone.OffsetToUTC div 60;
					var lMinutes := aTimeZone.OffsetToUTC mod 60;
					aOutput.Append(lHours.ToString.PadStart(2, '0') + aLocale.DateTimeFormat.TimeSeparator + lMinutes.ToString.PadStart(2, '0'));
				end;

				':': begin // hour separator
					aOutput.Append(aLocale.DateTimeFormat.TimeSeparator);
				end;

				'/': begin // date separator
					aOutput.Append(aLocale.DateTimeFormat.DateSeparator);
				end;

				else begin
					case aToken[0] of
						'''', '"': begin
							if aToken.Length ≥ 2 then
								aOutput.Append(aToken.Substring(1, aToken.Length - 2))
							else
								aOutput.Append(aToken);
						end;

						'%': begin
							if aToken.Length = 2 then
								aOutput.Append(InternalToString(aToken[1], aLocale, aTimeZone))
							else
								aOutput.Append(aToken);
						end;

						'\': begin
							if aToken.Length = 2 then
								aOutput.Append(aToken[1]);
						end;

						else begin
							aOutput.Append(aToken);
						end;
					end;
				end;
			end;
		end;

		method InternalToString(Format: String; aLocale: Locale := nil; aTimeZone: TimeZone := nil): String;
		begin
			var lLocale := coalesce(aLocale, Locale.Current);
			var lTimeZone := coalesce(aTimeZone, TimeZone.Utc);
			AddMinutes(lTimeZone.OffsetToUTC);
			var lFormat := TryToExpandFormat(Format, lLocale);

			var lSb := new StringBuilder(lFormat.Length + (lFormat.Length / 2));
			var lToken := GetNextFormatToken(var lFormat);
			while lToken ≠ '' do begin
				ProcessToStringToken(lLocale, lTimeZone, lSb, lToken);
				lToken := GetNextFormatToken(var lFormat);
			end;
			exit lSb.ToString;
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
{$ELSEIF POSIX}
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
			Result := fTicks - Value.Ticks;
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
			exit ToString(Format, new Locale(Culture), aTimeZone);
		end;

		method ToString(Format: String; aLocale: Locale := nil; aTimeZone: TimeZone := nil): String;
		begin
			exit InternalToString(Format, aLocale, aTimeZone);
		end;

		method ToShortDateString(aTimeZone: TimeZone := nil): String;
		begin
			exit ToString(Locale.Current.DateTimeFormat.ShortDatePattern, aTimeZone);
		end;

		method ToShortTimeString(aTimeZone: TimeZone := nil): String;
		begin
			exit ToString(Locale.Current.DateTimeFormat.ShortTimePattern, aTimeZone);
		end;

		method ToShortPrettyDateString(aTimeZone: TimeZone := nil): String;
		begin
			{$IFDEF WINDOWS}
			var sysdate:= ToSystemTime;
			var local := new array of Char(rtl.LOCALE_NAME_MAX_LENGTH+1);
			var l1 := rtl.LPWSTR(@local[0]);
			rtl.GetUserDefaultLocaleName(l1,rtl.LOCALE_NAME_MAX_LENGTH);
			var k := rtl.GetDateFormatEx(l1,0,@sysdate,nil,nil,0, nil);
			if k = 0 then CheckForLastError;
			var buf:= new array of Char(k+1);
			var k1 := rtl.GetDateFormatEx(l1,0,@sysdate,nil,rtl.LPWSTR(@buf[0]),k, nil);
			exit String.FromPChar(@buf[0],k1).TrimEnd([#0]);
			{$ELSEIF POSIX or WEBASSEMBLY}
			exit String.Format('{0}-{1}-{2}',[Year.ToString,TwoCharStr(Month),TwoCharStr(Day)]);
			{$ELSE}{$ERROR}
			{$ENDIF}
		end;
		//method ToLongPrettyDateString(aTimeZone: TimeZone := nil): String;

		method ToString: String; override;
		begin
			{$IFDEF WINDOWS}
			var sysdate:= ToSystemTime;
			var local := new array of Char(rtl.LOCALE_NAME_MAX_LENGTH+1);
			var l1 := rtl.LPWSTR(@local[0]);
			rtl.GetUserDefaultLocaleName(l1,rtl.LOCALE_NAME_MAX_LENGTH);
			var k := rtl.GetDateFormatEx(l1,0,@sysdate,nil,nil,0, nil);
			if k = 0 then CheckForLastError;
			var buf:= new array of Char(k+1);
			var k1 := rtl.GetDateFormatEx(l1,0,@sysdate,nil,rtl.LPWSTR(@buf[0]),k+1, nil);
			var r := String.FromPChar(@buf[0],k1);

			k := rtl.GetTimeFormatEx(l1,0,@sysdate,nil,nil,0);
			var buf1:= new array of Char(k+1);
			k1 := rtl.GetTimeFormatEx(l1,0,@sysdate,nil,rtl.LPWSTR(@buf1[0]),k+1);
			exit r.TrimEnd+' ' + String.FromPChar(@buf1[0],k1).TrimEnd;
			{$ELSEIF POSIX or WEBASSEMBLY}
			exit String.Format('{0}-{1}-{2} {3}:{4}:{5}',[Year.ToString,TwoCharStr(Month),TwoCharStr(Day),TwoCharStr(Hour),TwoCharStr(Minute), TwoCharStr(Second)]);
			{$ELSE}{$ERROR}
			{$ENDIF}
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