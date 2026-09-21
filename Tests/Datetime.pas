// Positive guard: DateTime_ToString checks native standard formats and custom year/hour tokens,
// including percent escapes and the midnight/noon boundaries that failed through RTL2.
namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  DateTime_Tests = public class(Test)
  private
  public
    method DateTime_Ctor;
    begin
      var date := new DateTime(1899,12,30);
      var date2 := new DateTime(DateTime.DoubleDateOffset);
      Check.AreEqual(date.Ticks,date2.Ticks);

      Check.AreEqual(DateTime.ToOleDate(date), 0);
      Check.AreEqual(DateTime.FromOleDate(0), date);

      date := new DateTime(1,1,1);
      date2 := new DateTime(0);
      Check.AreEqual(date.Ticks,date2.Ticks);


      date := new DateTime(1601,1,1);
      date2 := new DateTime(DateTime.FileTimeOffset);
      Check.AreEqual(date.Ticks,date2.Ticks);

      date := new DateTime(1970,1,1);
      date2 := new DateTime(DateTime.UnixDateOffset);
      Check.AreEqual(date.Ticks,date2.Ticks);

      date := DateTime.Now;
      var d1 := DateTime.ToOleDate(date);
      var d2 := 1.0*date.AddDays( -date.DaysTo1899).Ticks / DateTime.TicksPerDay;
      Check.AreEqual(d1, d2);
      var d3 := DateTime.FromOleDate(1.0*date.AddDays(-date.DaysTo1899).Ticks / DateTime.TicksPerDay);

      // OLE dates are doubles, so sub-millisecond ticks are not guaranteed to round-trip exactly.
      Check.LessOrEquals(Math.Abs(date.Ticks - d3.Ticks), DateTime.TicksPerMillisecond);
    end;

    method DateTime_AddMonth_nonLeapYear;
    begin
      var date := new DateTime(2017,1,31);
      var date2 := new DateTime(2017,2,1);
      for i:Integer := 1 to 12-1 do begin
        var d3 := date.AddMonths(i);
        var d4 := date2.AddMonths(i);
        var d5 := d4.AddDays(-1);
        Check.AreEqual(d3, d5);
      end;
    end;

    method DateTime_AddMonth_LeapYear;
    begin
      var date := new DateTime(2016,1,31);
      var date2 := new DateTime(2016,2,1);
      for i:Integer := 1 to 12-1 do
        Check.AreEqual(date.AddMonths(i), date2.AddMonths(i).AddDays(-1));
    end;

    method DateTime_ToString;
    begin
      var lDate := new DateTime(2021, 6, 25, 10, 40, 33, 100);
      var lString := lDate.ToString('MM-dd-yyyy');
      Check.AreEqual(lString, '06-25-2021');

      lString := lDate.ToString('MM-dd-yyyy hh:mm:ss');
      Check.AreEqual(lString, '06-25-2021 10:40:33');

      lString := lDate.ToString('fff');
      Check.AreEqual(lString, '100');

      lString := lDate.ToString('ff');
      Check.AreEqual(lString, '10');

      lString := lDate.ToString('MM-dd-yyyy f');
      Check.AreEqual(lString, '06-25-2021 1');

      lString := lDate.ToString('s');
      Check.AreEqual(lString, '2021-06-25T10:40:33');

      Check.AreEqual(lDate.ToString('%s'), '33');
      Check.AreEqual(lDate.ToString('%d'), '25');
      Check.AreEqual(lDate.ToString('%M'), '6');
      Check.AreEqual(lDate.ToString('%m'), '40');
      Check.AreEqual(lDate.ToString('yy'), '21');
      var lEarlyYear := new DateTime(2006, 6, 25);
      Check.AreEqual(lEarlyYear.ToString('yy'), '06');
      Check.AreEqual(lEarlyYear.ToString('%y'), '6');
      Check.AreEqual(lEarlyYear.ToString('yyyy'), '2006');

      var lLocale := new Locale('en-US');
      var lMidnight := new DateTime(2026, 8, 9, 0, 4, 5);
      var lNoon := new DateTime(2026, 8, 9, 12, 4, 5);
      Check.AreEqual(lMidnight.ToString('hh:mmtt', lLocale), '12:04AM');
      Check.AreEqual(lMidnight.ToString('h t', lLocale), '12 A');
      Check.AreEqual(lNoon.ToString('hh:mmtt', lLocale), '12:04PM');
      Check.AreEqual(lNoon.ToString('h t', lLocale), '12 P');
    end;

    method DateTime_Parse;
    begin
      // US dates are month first.
      var lUSLocale := new Locale('en-US');
      var lDate := DateTime.TryParse('06/25/2021', lUSLocale);
      Check.IsNotNil(lDate);
      Check.AreEqual(lDate.Month, 6);
      Check.AreEqual(lDate.Day, 25);
      lDate := DateTime.TryParse('06/25/2021 12:58:30', lUSLocale);
      Check.IsNotNil(lDate);
      lDate := DateTime.TryParse('06/25/2021 12:58', lUSLocale);
      Check.IsNotNil(lDate);

      // Day-first dates are not valid US input.
      lDate := DateTime.TryParse('25/06/2021', lUSLocale);
      Check.IsNil(lDate);
      lDate := DateTime.TryParse('25/06/2021 12:58:30', lUSLocale);
      Check.IsNil(lDate);
      lDate := DateTime.TryParse('25/06/2021 12:58', lUSLocale);
      Check.IsNil(lDate);

      // They are valid with an explicit day-first format.
      lDate := DateTime.TryParse('25/06/2021', 'dd/MM/yyyy', lUSLocale);
      Check.IsNotNil(lDate);
      Check.AreEqual(lDate.Month, 6);
      Check.AreEqual(lDate.Day, 25);
      lDate := DateTime.TryParse('25/06/2021 12:58:30', 'dd/MM/yyyy hh:mm:ss', lUSLocale);
      Check.IsNotNil(lDate);
    end;
  end;
end.
