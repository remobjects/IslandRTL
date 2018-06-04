namespace Elements.RTL2.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  DateTime_Tests = public class(Test)
  private
  public
    method DateTime_AddMonth_nonLeapYear;
    begin
      var date := new DateTime(2017,1,31);
      var date2 := new DateTime(2017,2,1);
      for i:Integer := 1 to 12-1 do begin
        var d3 := date.AddMonths(1);
        var d4 := date2.AddMonths(1);
        var d5 := d4.AddDays(-1);
        Assert.AreEqual(d3, d5);
      end;
    end;

    method DateTime_AddMonth_LeapYear;
    begin
      var date := new DateTime(2016,1,31);
      var date2 := new DateTime(2016,2,1);
      for i:Integer := 1 to 12-1 do 
        Assert.AreEqual(date.AddMonths(1), date2.AddMonths(1).AddDays(-1));
    end;
  end;
end.