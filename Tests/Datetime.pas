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
      Assert.AreEqual(date.Ticks,date2.Ticks);

      Assert.AreEqual(DateTime.ToOleDate(date), 0);
      Assert.AreEqual(DateTime.FromOleDate(0), date);

      date := new DateTime(1,1,1);
      date2 := new DateTime(0);
      Assert.AreEqual(date.Ticks,date2.Ticks);


      date := new DateTime(1601,1,1);
      date2 := new DateTime(DateTime.FileTimeOffset);
      Assert.AreEqual(date.Ticks,date2.Ticks);

      date := new DateTime(1970,1,1);
      date2 := new DateTime(DateTime.UnixDateOffset);
      Assert.AreEqual(date.Ticks,date2.Ticks);

      date := DateTime.Now;
      var d1 := DateTime.ToOleDate(date);
      var d2 := 1.0*date.AddDays( -date.DaysTo1899).Ticks / DateTime.TicksPerDay;
      Assert.AreEqual(d1, d2);
      var d3 := DateTime.FromOleDate(1.0*date.AddDays(-date.DaysTo1899).Ticks / DateTime.TicksPerDay);

      Assert.AreEqual(date, d3);
    end;

    method DateTime_AddMonth_nonLeapYear;
    begin
      var date := new DateTime(2017,1,31);
      var date2 := new DateTime(2017,2,1);
      for i:Integer := 1 to 12-1 do begin
        var d3 := date.AddMonths(i);
        var d4 := date2.AddMonths(i);
        var d5 := d4.AddDays(-1);
        Assert.AreEqual(d3, d5);
      end;
    end;

    method DateTime_AddMonth_LeapYear;
    begin
      var date := new DateTime(2016,1,31);
      var date2 := new DateTime(2016,2,1);
      for i:Integer := 1 to 12-1 do
        Assert.AreEqual(date.AddMonths(i), date2.AddMonths(i).AddDays(-1));
    end;

    method DateTime_ToString;
    begin
      var lDate := new DateTime(2021, 6, 25, 10, 40, 33, 100);
      var lString := lDate.ToString('MM-dd-yyyy');
      Assert.AreEqual(lString, '06-25-2021');

      lString := lDate.ToString('MM-dd-yyyy hh:mm:ss');
      Assert.AreEqual(lString, '06-25-2021 10:40:33');

      lString := lDate.ToString('fff');
      Assert.AreEqual(lString, '100');

      lString := lDate.ToString('ff');
      Assert.AreEqual(lString, '10');

      lString := lDate.ToString('MM-dd-yyyy f');
      Assert.AreEqual(lString, '06-25-2021 1');

      lString := lDate.ToString('s');
      Assert.AreEqual(lString, '2021-06-25T10:40:33');
    end;

    method DateTime_Parse;
    begin
      var lDate := DateTime.TryParse('25/06/2021');
      Assert.IsNotNil(lDate);
      lDate := DateTime.TryParse('25/06/2021 12:58:30');
      Assert.IsNotNil(lDate);
      lDate := DateTime.TryParse('25/06/2021 12:58');
      Assert.IsNotNil(lDate);

      lDate := DateTime.TryParse('25/06/2021 12:58:30', 'dd/MM/yyyy hh:mm:ss');
      Assert.IsNotNil(lDate);
    end;
  end;
end.