namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  String_Trim = public class(Test)
  public

    method Whitespace;
    begin
      var sStart := #13#13'  '#13#13'   '#9#13#13#10#10#13'  ';
      var sMiddle := 'Testing 123 '#9#13#13#10#10#13'  '#9' Test56';
      var sEnd := #9#13#13#10#10#13'  '#9#13#13#10#10#13'    ';

      var s := sStart+sMiddle+sEnd;
      Assert.AreEqual(s.Trim(), sMiddle);
      Assert.AreEqual(s.TrimEnd(), sStart+sMiddle);
      Assert.AreEqual(s.TrimStart(), sMiddle+sEnd);

      var sNone := "foo "#13#10#9"  bar";
      Assert.AreEqual(sNone.Trim(), sNone);
      Assert.AreEqual(sNone.TrimEnd(), sNone);
      Assert.AreEqual(sNone.TrimStart(), sNone);
    end;

  end;

end.