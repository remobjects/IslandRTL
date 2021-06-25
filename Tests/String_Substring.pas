namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  String_SubString = public class(Test)
  public

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