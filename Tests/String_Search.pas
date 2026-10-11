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

    // Seeded UTF-16 strings exercise both search paths and low-byte hash
    // collisions. The independent oracle checks every candidate code unit.
    method SeededSearchAndBoundaries;
    begin
      var seed: UInt32 := 1234567;
      for trial := 0 to 1999 do begin
        seed := seed * 1664525 + 1013904223;
        var n := Integer(seed mod 193);
        seed := seed * 1664525 + 1013904223;
        var m := Integer(seed mod 40);
        var chars := new Char[n];
        var needle := new Char[m];
        for i := 0 to n - 1 do begin
          seed := seed * 1664525 + 1013904223;
          chars[i] := Char((seed shr 16) and $ff03);
        end;
        for i := 0 to m - 1 do begin
          seed := seed * 1664525 + 1013904223;
          needle[i] := Char((seed shr 16) and $ff03);
        end;
        if (m > 0) and (m <= n) and ((trial and 1) = 0) then begin
          var at := Integer(seed mod UInt32(n - m + 1));
          for i := 0 to m - 1 do chars[at + i] := needle[i];
        end;
        var text := if n = 0 then '' else new String(chars);
        var value := if m = 0 then '' else new String(needle);
        for each start in [0, n / 2, n, n + 1] do begin
          var expected := -1;
          if m = 0 then expected := 0
          else if m <= n then begin
            for i := start to n - m do begin
              var matches := true;
              for j := 0 to m - 1 do
                if chars[i + j] <> needle[j] then begin
                  matches := false;
                  break;
                end;
              if matches then begin expected := i; break; end;
            end;
          end;
          Assert.AreEqual(expected, text.IndexOf(value, start));
        end;
      end;
      for each n in [8, 9, 15, 16, 31, 32, 255, 256] do begin
        var chars := new Char[n];
        for i := 0 to n - 1 do chars[i] := 'a';
        var text := new String(chars);
        chars[n - 1] := 'b';
        var needle := new String(chars);
        Assert.AreEqual(-1, text.IndexOf(needle));
        Assert.AreEqual(n, (text + needle).IndexOf(needle));
        Assert.AreEqual(0, needle.IndexOf(needle));
      end;
      var failed := false;
      try 'abc'.IndexOf('a', -1); except on e: IndexOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      Assert.AreEqual(0, 'abc'.IndexOf('', -1));
      Assert.AreEqual(-1, 'abc'.IndexOf('abcd', -1));
    end;

  end;
end.
