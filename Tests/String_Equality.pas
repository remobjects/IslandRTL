// Negative regression guards: bounded UTF-16 equality must include embedded
// NULs/surrogates and the final character, while preserving nil/object behavior.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  String_Equality = public class(Test)
  public

    method LengthsAndMismatchPositions;
    begin
      var lEmptyChar := Char(0);
      for each lLength in [0, 1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 127, 128, 129, 1024] do begin
        var lChars := new Char[lLength];
        for i := 0 to lLength - 1 do
          lChars[i] := Char((i * 251) mod 65536);
        var lA := if lLength = 0 then new String(@lEmptyChar, 0) else new String(lChars);
        var lB := if lLength = 0 then new String(@lEmptyChar, 0) else new String(lChars);
        Assert.IsTrue(lA.Equals(lA));
        Assert.IsTrue(lA.Equals(lB));
        Assert.IsTrue(lA.Equals(Object(lB)));
        Assert.IsFalse(lA.Equals(Object(nil)));
        Assert.IsFalse(lA.Equals(new Object));
        Assert.IsFalse(lA.Equals(lB + 'x'));
        for i := 0 to lLength - 1 do begin
          var lSaved := lChars[i];
          lChars[i] := Char(Integer(lSaved) xor 1);
          var lChanged := new String(lChars);
          Assert.IsFalse(lA.Equals(lChanged));
          Assert.IsFalse(lChanged.Equals(lA));
          lChars[i] := lSaved;
        end;
      end;
    end;

    method CocoaBridge;
    begin
      {$IF DARWIN}
      var lText: String := 'bridge';
      var lWrapped := new IslandWrappedCocoaObject(CocoaString(lText));
      Assert.IsTrue(lText.Equals(Object(lWrapped)));
      Assert.IsFalse('different'.Equals(Object(lWrapped)));
      {$ENDIF}
    end;

    method EmbeddedZerosAndSurrogates;
    begin
      var lChars: array of Char := [Char(0), Char($d800), Char($dc00), Char(0), Char($dfff)];
      var lA := new String(lChars);
      Assert.IsTrue(lA.Equals(new String(lChars)));
      lChars[4] := Char($dffe);
      Assert.IsFalse(lA.Equals(new String(lChars)));
      Assert.IsFalse(lA.Equals(new String(@lChars[0], 3)));
    end;

  end;
end.
