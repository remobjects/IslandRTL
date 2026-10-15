// Negative regression guard: Substring(Length) must return empty, while invalid indices still throw.
namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  String_SubString = public class(Test)
  public

    method SubstringAtEnd;
    begin
      var lValue: String := 'c';
      Assert.AreEqual(lValue.Substring(lValue.Length), '');
      lValue := 'abc';
      Assert.AreEqual(lValue.Substring(lValue.Length), '');
      Assert.AreEqual(lValue.Substring(1), 'bc');
      var lCaught := false;
      try
        lValue.Substring(-1);
      except
        on e: Exception do lCaught := true;
      end;
      Assert.IsTrue(lCaught);
      lCaught := false;
      try
        lValue.Substring(lValue.Length+1);
      except
        on e: Exception do lCaught := true;
      end;
      Assert.IsTrue(lCaught);
      lValue := '';
      Assert.AreEqual(lValue.Substring(0), '');
    end;

    method Substring;
    begin
      var sStart := '012345678901234';
      var l := sStart.Length;
      Assert.AreEqual(l, 15);
      // First Char
      var s := sStart.Substring(0,1);
      Assert.AreEqual(s, '0');

      // Last Char
      s := sStart.Substring(14,1);
      Assert.AreEqual(s, '4');

     //count 0 should be empty Char
      s := sStart.Substring(14,0);
      Assert.AreEqual(s, '');

    //count 0 should be empty Char and not crash
    // Net and Delphi will simply resturn a empty String
      s := sStart.Substring(15,0);
      Assert.AreEqual(s, '');

    end;

  end;

end.