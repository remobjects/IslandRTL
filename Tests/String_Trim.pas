namespace RemObjects.Elements.Island.Tests;

uses
  RemObjects.Elements.EUnit;

type
  String = public class(Test)
  private
  protected
  public
    method FirstTest;
    begin
      Assert.IsTrue(true);
    end;

  end;

end.