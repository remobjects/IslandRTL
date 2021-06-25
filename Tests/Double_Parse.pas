namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  Double_Parse = public class(Test)
  private
    fLocale : Locale;

    method doTest(aValue: Double);
    begin
      Assert.AreEqual(aValue.ToString(fLocale), Double.Parse(aValue.ToString(fLocale), fLocale).ToString(fLocale));

     // Check.AreEqual(aValue.ToString, Double.Parse(aValue.ToString).ToString);

    end;

    method doTest2(aStrValue: String;aValue: Double);
    begin
      Assert.AreEqual(aValue.ToString(Locale.Invariant), Double.Parse(aStrValue, Locale.Invariant).ToString(Locale.Invariant));
    end;

    method doTest3(aValue: Double);
    begin
      var res: Double;
      Assert.AreEqual(false, Double.TryParse(aValue.ToString(fLocale), fLocale, out res));
    end;

  public

    method SetupTest; override;
    begin
      //fLocale := new Locale(Locale.Invariant.PlatformLocale);
      fLocale := new Locale(Locale.Current.PlatformLocale);
    end;


    method TestStd;
    begin
      doTest(123456);
      doTest(-123456);
      doTest(123.456);
      doTest(-123.456E-10);
      doTest(123.456E+10);

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
    fLocale : Locale;
    method doTest(aValue: Single);
    begin
      Assert.AreEqual(aValue.ToString(fLocale), Single.Parse(aValue.ToString(fLocale), fLocale).ToString(fLocale));
    end;

    method doTest2(aStrValue: String;aValue: Single);
    begin
      Assert.AreEqual(aValue.ToString(Locale.Invariant), Single.Parse(aStrValue, Locale.Invariant).ToString(Locale.Invariant));
    end;

    method doTest3(aValue: Single);
    begin
      var res: Single;
      Assert.AreEqual(false, Single.TryParse(aValue.ToString(fLocale), fLocale, out res));
    end;

  public

    method SetupTest; override;
    begin
     // fLocale := new Locale(Locale.Invariant.PlatformLocale);
      fLocale := new Locale(Locale.Current.PlatformLocale);
    end;


    method TestStd;
    begin
      doTest(123456);
      doTest(-123456);
      doTest(123.456);
      doTest(-123.456E-10);
      doTest(123.456E+10);
      doTest(Single.MaxValue);
      doTest(Single.MinValue);
      doTest(Single.MaxValue);
      doTest(Single.MinValue);

      doTest2('+12345E-2',+12345E-2);
      doTest2('+12345E+2',+12345E+2);
      doTest2('-12345E2',-12345E2);
      doTest2(       '-123456789012345678.90123456789e1',
               Single(-123456789012345678.90123456789e1));


      doTest2(       '-12345678901234567890123456789.0',
               Single(-12345678901234567890123456789.0));
      doTest2(       '-12345678901234567890123456789E-2',
               Single(-12345678901234567890123456789E-2));
      doTest2(       '123456789012345678901234567890E9',
               Single(123456789012345678901234567890E9));

    end;


    method TestOverflow;
    begin
      doTest3(Single.PositiveInfinity);
      doTest3(Single.NegativeInfinity);
      doTest3(Single.NAN);
    end;

  end;


end.