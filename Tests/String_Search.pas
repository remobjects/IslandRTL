// Search regression guards: the public UTF-16 IndexOf overloads must find the
// first complete match from the requested offset, including NULs and surrogates.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  String_Search = public class(Test)
  public

    method MatchPositionsAndOffsets;
    begin
      for each lLength in [1, 2, 3, 7, 8, 9, 31, 32, 33] do begin
        var lNeedleChars := new Char[lLength];
        for i := 0 to lLength - 1 do
          lNeedleChars[i] := Char(Integer('a') + i mod 7);
        var lNeedle := new String(lNeedleChars);
        var lText := '!' + lNeedle + '!' + lNeedle + '!';
        Assert.AreEqual(1, lText.IndexOf(lNeedle));
        Assert.AreEqual(1, lText.IndexOf(lNeedle, 1));
        Assert.AreEqual(lLength + 2, lText.IndexOf(lNeedle, 2));
        Assert.AreEqual(-1, lText.IndexOf(lNeedle, lLength + 3));
        Assert.AreEqual(-1, lText.IndexOf(lNeedle, lText.Length));
        Assert.AreEqual(0, lNeedle.IndexOf(lNeedle));
        Assert.AreEqual(-1, lNeedle.IndexOf(lNeedle + '!'));
        Assert.AreEqual(-1, lText.IndexOf('?'));
      end;
      Assert.AreEqual(4, 'aaaaaaab'.IndexOf('aaab'));
      Assert.AreEqual(-1, 'aaaaaaaa'.IndexOf('aaab'));
      Assert.AreEqual(2, 'ababababac'.IndexOf('abababac'));
      Assert.AreEqual(3, 'prefix'.IndexOf('fix'));
    end;

    method Utf16CodeUnits;
    begin
      var lChars: array of Char := [Char(0), Char($d800), Char($dc00), Char(0), Char($dfff)];
      var lText := new String(lChars);
      Assert.AreEqual(0, lText.IndexOf(new String(@lChars[0], 1)));
      Assert.AreEqual(3, lText.IndexOf(new String(@lChars[0], 1), 1));
      Assert.AreEqual(1, lText.IndexOf(new String(@lChars[1], 2)));
      Assert.AreEqual(2, lText.IndexOf(new String(@lChars[2], 1)));
      Assert.AreEqual(3, lText.IndexOf(new String(@lChars[3], 2)));
    end;

  end;
end.
