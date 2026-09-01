// Test Island String relational operators: lexicographic ordering for differing characters, prefixes, and equal values.
namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  String_Comparison = public class(Test)
  public

    method Greater;
    begin
      var lA: String := 'A';
      var lB: String := 'B';
      var lAA: String := 'AA';
      var lAZ: String := 'AZ';
      var lBA: String := 'BA';

      Assert.AreEqual(lB > lA, true);
      Assert.AreEqual(lBA > lAZ, true);
      Assert.AreEqual(lAA > lA, true);
      Assert.AreEqual(lA > lB, false);
      Assert.AreEqual(lA > lAA, false);
      Assert.AreEqual(lA > lA, false);
    end;

    method Less;
    begin
      var lA: String := 'A';
      var lB: String := 'B';
      var lAA: String := 'AA';
      var lAZ: String := 'AZ';
      var lBA: String := 'BA';

      Assert.AreEqual(lA < lB, true);
      Assert.AreEqual(lAZ < lBA, true);
      Assert.AreEqual(lA < lAA, true);
      Assert.AreEqual(lB < lA, false);
      Assert.AreEqual(lAA < lA, false);
      Assert.AreEqual(lA < lA, false);
    end;

    method GreaterOrEqual;
    begin
      var lA: String := 'A';
      var lB: String := 'B';
      var lAA: String := 'AA';
      var lAZ: String := 'AZ';
      var lBA: String := 'BA';

      Assert.AreEqual(lB >= lA, true);
      Assert.AreEqual(lBA >= lAZ, true);
      Assert.AreEqual(lAA >= lA, true);
      Assert.AreEqual(lA >= lB, false);
      Assert.AreEqual(lA >= lAA, false);
      Assert.AreEqual(lA >= lA, true);
    end;

    method LessOrEqual;
    begin
      var lA: String := 'A';
      var lB: String := 'B';
      var lAA: String := 'AA';
      var lAZ: String := 'AZ';
      var lBA: String := 'BA';

      Assert.AreEqual(lA <= lB, true);
      Assert.AreEqual(lAZ <= lBA, true);
      Assert.AreEqual(lA <= lAA, true);
      Assert.AreEqual(lB <= lA, false);
      Assert.AreEqual(lAA <= lA, false);
      Assert.AreEqual(lA <= lA, true);
    end;

    method LongerStrings;
    begin
      var lEarlier: String := 'elements-alpha-tail';
      var lLater: String := 'elements-beta-head';
      var lPrefix: String := 'elements';
      var lExtended: String := 'elements-compiler';
      var lEqual: String := 'elements-compiler';

      Assert.AreEqual(lEarlier < lLater, true);
      Assert.AreEqual(lEarlier <= lLater, true);
      Assert.AreEqual(lLater > lEarlier, true);
      Assert.AreEqual(lLater >= lEarlier, true);
      Assert.AreEqual(lPrefix < lExtended, true);
      Assert.AreEqual(lExtended > lPrefix, true);
      Assert.AreEqual(lExtended >= lEqual, true);
      Assert.AreEqual(lExtended <= lEqual, true);
    end;

    method MixedCase;
    begin
      var lUpperA: String := 'A';
      var lUpperZ: String := 'Z';
      var lLowerA: String := 'a';
      var lLowerZ: String := 'z';

      Assert.AreEqual(lUpperA < lLowerA, true);
      Assert.AreEqual(lUpperZ < lLowerA, true);
      Assert.AreEqual(lLowerA > lUpperA, true);
      Assert.AreEqual(lLowerA > lUpperZ, true);
      Assert.AreEqual(lUpperZ <= lLowerA, true);
      Assert.AreEqual(lLowerA >= lUpperZ, true);
      Assert.AreEqual(lLowerZ < lUpperA, false);
      Assert.AreEqual(lUpperA > lLowerZ, false);
    end;

  end;

end.