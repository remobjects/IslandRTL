// Positive guard: Darwin Locale must bridge a literal Island string before passing it to CoreFoundation.
// Positive guard: dynamically built locale names must also support number and date formatting without crashing.
namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

{$IF DARWIN}
type
  LocaleTests = public class(Test)
  public
    method LiteralLocaleName;
    begin
      var lLocale := new Locale('en-US');
      Check.IsTrue(lLocale.NumberFormat.DecimalSeparator = '.');
      Check.AreEqual(lLocale.DateTimeFormat.LongMonthNames[7], 'August');
    end;

    method DynamicLocaleName;
    begin
      var lName := new String(['e', 'n', '-', 'U', 'S']);
      var lLocale := new Locale(lName);
      Check.IsTrue(lLocale.NumberFormat.DecimalSeparator = '.');
      Check.AreEqual(lLocale.DateTimeFormat.AMString, 'AM');
      var lDate := new DateTime(2026, 8, 9, 17, 4, 5);
      Check.AreEqual(lDate.ToString('yyyy-MM-dd', lLocale, TimeZone.Utc), '2026-08-09');
    end;
  end;
{$ENDIF}
end.
