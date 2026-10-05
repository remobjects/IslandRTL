// Bounds regression guards: optimized string indexing must retain exceptions
// outside the UTF-16 buffer, including empty strings and extreme indices.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  String_Indexing = public class(Test)
  private

    [DisableInlining]
    class method ReadAt(aText: String; aIndex: Integer): Char;
    begin
      exit aText[aIndex];
    end;

    class method ExpectBounds(aText: String; aIndex: Integer);
    begin
      var lRaised := false;
      try
        ReadAt(aText, aIndex);
      except
        on E: IndexOutOfRangeException do
          lRaised := true;
      end;
      Assert.IsTrue(lRaised);
    end;

    [DisableInlining]
    class method CountCharacter(aText: String; aChar: Char): Integer;
    begin
      result := 0;
      for i := 0 to aText.Length - 1 do
        if aText[i] = aChar then
          inc(result);
    end;

  public

    method ValidCharacters;
    begin
      for each lLength in [1, 2, 3, 7, 8, 9, 31, 32, 33, 1024] do begin
        var lChars := new Char[lLength];
        for i := 0 to lLength - 1 do
          lChars[i] := Char((i * 251) mod 65536);
        var lText := new String(lChars);
        for i := 0 to lText.Length - 1 do begin
          Assert.AreEqual(lChars[i], lText[i]);
          Assert.AreEqual(lChars[i], ReadAt(lText, i));
        end;
      end;
      var lSpecial: array of Char := [Char(0), Char($d800), Char($dc00), Char($dfff)];
      var lText := new String(lSpecial);
      for i := 0 to lText.Length - 1 do
        Assert.AreEqual(lSpecial[i], ReadAt(lText, i));
    end;

    method CharacterCounts;
    begin
      var lZero := Char(0);
      Assert.AreEqual(0, CountCharacter(new String(@lZero, 0), lZero));
      for each lLength in [1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 1024] do begin
        var lChars := new Char[lLength];
        var lZeros := 0;
        for i := 0 to lLength - 1 do begin
          lChars[i] := if i mod 7 = 0 then Char(0) else Char($d800);
          if i mod 7 = 0 then
            inc(lZeros);
        end;
        var lText := new String(lChars);
        Assert.AreEqual(lZeros, CountCharacter(lText, Char(0)));
        Assert.AreEqual(lLength - lZeros, CountCharacter(lText, Char($d800)));
        Assert.AreEqual(0, CountCharacter(lText, Char($dc00)));
      end;
    end;

    method InvalidIndices;
    begin
      var lZero := Char(0);
      var lEmpty := new String(@lZero, 0);
      for each lText in [lEmpty, 'a', 'abcdef'] do begin
        ExpectBounds(lText, -1);
        ExpectBounds(lText, low(Integer));
        ExpectBounds(lText, lText.Length);
        ExpectBounds(lText, high(Integer));
      end;
    end;

  end;
end.
