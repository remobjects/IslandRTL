// Negative Linux startup regression guard: every pointer-sized .init_array
// entry must run once, in priority order. Counting four-byte entries on a
// 64-bit target overreads the table before the test application reaches Main.
namespace RemObjects.Elements.Island.Tests;

{$IF LINUX}
uses RemObjects.Elements.EUnit;

type
  Linux_Startup = public class(Test)
  private
    class var fOrder: Integer;
    class var fCalls: Integer;

    [GlobalConstructor(201), Used]
    class method FirstInitializer;
    begin
      fOrder := fOrder * 10 + 1;
      inc(fCalls);
    end;

    [GlobalConstructor(202), Used]
    class method SecondInitializer;
    begin
      fOrder := fOrder * 10 + 2;
      inc(fCalls);
    end;

    [GlobalConstructor(203), Used]
    class method ThirdInitializer;
    begin
      fOrder := fOrder * 10 + 3;
      inc(fCalls);
    end;

  public
    method ConstructorsRunExactlyOnceInOrder;
    begin
      Assert.AreEqual(3, fCalls);
      Assert.AreEqual(123, fOrder);
    end;
  end;
{$ENDIF}

end.
