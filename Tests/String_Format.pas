namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  String_Format = public class(Test)
  public

    method DoTest;
    begin
      var s := 'usage: %s server-name';
      var s1 := String.Format(s,['1']);
      Assert.AreEqual(s, s1);
    end;

  end;

end.