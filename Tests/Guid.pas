namespace Elements.RTL2.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  Guid_ToString = public class(Test)
  public
    method Test;
    begin
      var g := new Guid('12345678-9ABC-DEF0-1234-567890ABCDEF');
      Assert.AreEqual(g.ToString(nil),'12345678-9abc-def0-1234-567890abcdef');
      Assert.AreEqual(g.ToString(''),'12345678-9abc-def0-1234-567890abcdef');
      Assert.AreEqual(g.ToString('D'),'12345678-9abc-def0-1234-567890abcdef');
      Assert.AreEqual(g.ToString('N'),'123456789abcdef01234567890abcdef');
      Assert.AreEqual(g.ToString('B'),'{12345678-9abc-def0-1234-567890abcdef}');
      Assert.AreEqual(g.ToString('P'),'(12345678-9abc-def0-1234-567890abcdef)');
      Assert.AreEqual(g.ToString('X'),'{0x12345678,0x9abc,0xdef0,{0x12,0x34,0x56,0x78,0x90,0xab,0xcd,0xef}}');
    end;
  end;

end.