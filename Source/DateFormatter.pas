namespace RemObjects.Elements.System;

type
  DateTime = public partial record
  private
    method TryToExpandFormat(aFormat: String; aLocale: Locale): String;
    begin
      case aFormat of
        'd': exit aLocale.DateTimeFormat.ShortDatePattern; // short date
        'D': exit aLocale.DateTimeFormat.LongDatePattern; // long date
        'f': exit aLocale.DateTimeFormat.LongDatePattern + ' ' + aLocale.DateTimeFormat.ShortTimePattern; // long date, short time
        'F': exit aLocale.DateTimeFormat.LongDatePattern + ' ' + aLocale.DateTimeFormat.LongTimePattern; // long date, long time
        'g': exit aLocale.DateTimeFormat.ShortDatePattern + ' ' + aLocale.DateTimeFormat.ShortTimePattern; // general date and time, short time
        'G': exit aLocale.DateTimeFormat.ShortDatePattern + ' ' + aLocale.DateTimeFormat.LongTimePattern; // general date and time, long time
        'M', 'm': exit "MMMM dd"; // month, day
        'O', 'o': exit "yyyy-MM-ddTHH:mm:ss.fffffffK";
        'R', 'r': exit "ddd, dd MMM yyyy HH':'mm':'ss 'GMT'"; //RFC 1123
        's': exit "yyyy-MM-dd'T'HH:mm:ss"; // sortable
        't': exit aLocale.DateTimeFormat.ShortTimePattern; // short time
        'T': exit aLocale.DateTimeFormat.LongTimePattern; // long time
        //'u': exit ""; // universal
        //'U': exit ""; // universal (long)
        'Y', 'y': exit "MMMM yyyy"; // month, year
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
          aOutput.Append(aLocale.DateTimeFormat.ShortMonthNames[Month - 1]);
        end;

        'MMMM': begin // month name
          aOutput.Append(aLocale.DateTimeFormat.LongMonthNames[Month - 1]);
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
  end;
end.