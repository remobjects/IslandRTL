namespace Elements.RTL2.Tests.Shared;

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
  end;
end.