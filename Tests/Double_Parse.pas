namespace Elements.RTL2.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  Double_Parse = public class(Test)
  private
    method doTest(aValue: Double);
    begin
      Assert.AreEqual(aValue.ToString, Double.Parse(aValue.ToString).ToString);
    end;

    method doTest2(aStrValue: String;aValue: Double);
    begin
      Assert.AreEqual(aValue.ToString, Double.Parse(aStrValue.ToString).ToString);
    end;

    method doTest3(aValue: Double);
    begin
      var res: double;
      Assert.AreEqual(false, Double.TryParse(aValue.ToString,out res));
    end;

  public
    method TestStd;
    begin
      dotest(123456);
      dotest(-123456);
      dotest(123.456);
      dotest(-123.456E-10);
      dotest(123.456E+10);
      doTest2('+12345E-2',+12345E-2);
      doTest2('+12345E+2',+12345E+2);
      doTest2('-12345E2',-12345E2);
      doTest2('-1234567890123456789012345678901234567890123456789012345678901234567890.123456789012345678901234567890E10',
               -1234567890123456789012345678901234567890123456789012345678901234567890.123456789012345678901234567890E10);
      doTest2('-1234567890123456789012345678901234567890123456789012345678901234567890.123456789012345678901234567890E-10',
               -1234567890123456789012345678901234567890123456789012345678901234567890.123456789012345678901234567890E-10);

      doTest2('-1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890.0',
               -1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890.0);
      doTest2('-1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890E-40',
               -1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890E-40);
      doTest2('1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890E40',
               1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890E40);
    end;

    method TestOverflow;
    begin
      doTest3(Double.MaxValue);
      doTest3(Double.MinValue);
      doTest3(Double.PositiveInfinity);
      doTest3(Double.NegativeInfinity);
      doTest3(Double.NaN);
    end;



  end;

  Single_Parse = public class(Test)
  private
    method doTest(aValue: Single);
    begin
      Assert.AreEqual(aValue.ToString, Single.Parse(aValue.ToString).ToString);
    end;

    method doTest2(aStrValue: String;aValue: Single);
    begin
      Assert.AreEqual(aValue.ToString, Single.Parse(aStrValue.ToString).ToString);
    end;

    method doTest3(aValue: Single);
    begin
      var res: Single;
      Assert.AreEqual(false, Single.TryParse(aValue.ToString,out res));
    end;

  public
    method TestStd;
    begin
      dotest(123456);
      dotest(-123456);
      dotest(123.456);
      dotest(-123.456E-10);
      dotest(123.456E+10);
      doTest2('+12345E-2',+12345E-2);
      doTest2('+12345E+2',+12345E+2);
      doTest2('-12345E2',-12345E2);
      doTest2(       '-123456789012345678.90123456789e1',
               single(-123456789012345678.90123456789e1));


      doTest2(       '-12345678901234567890123456789.0',
               single(-12345678901234567890123456789.0));
      doTest2(       '-12345678901234567890123456789E-2',
               single(-12345678901234567890123456789E-2));
      doTest2(       '123456789012345678901234567890E9',
               single(123456789012345678901234567890E9));

      doTest(Single.MaxValue);
      doTest(Single.MinValue);

    end;

    method TestOverflow;
    begin
      doTest3(Single.PositiveInfinity);
      doTest3(Single.NegativeInfinity);
      doTest3(Single.NaN);
    end;



  end;


end.