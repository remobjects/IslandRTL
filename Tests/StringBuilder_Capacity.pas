// Capacity regression guards: constructors and reservations must honor requests,
// shrinking must preserve live UTF-16 content, and rejected requests must not
// mutate length, capacity, or text. These checks require only small allocations.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  StringBuilder_Capacity = public class(Test)
  public

    method ConstructorsHonorCapacity;
    begin
      var lDefault := new RemObjects.Elements.System.StringBuilder;
      Assert.AreEqual(lDefault.Capacity, 16);
      for each lCapacity in [0, 1, 8, 16, 65, 257] do begin
        var lBuilder := new RemObjects.Elements.System.StringBuilder(lCapacity);
        Assert.AreEqual(lBuilder.Capacity, lCapacity);
        Assert.AreEqual(lBuilder.Length, 0);
        lBuilder.Append(Char($1234), lCapacity);
        Assert.AreEqual(lBuilder.Capacity, lCapacity);
        Assert.AreEqual(lBuilder.Length, lCapacity);
        for i := 0 to lCapacity - 1 do
          Assert.AreEqual(lBuilder[i], Char($1234));
      end;
    end;

    method EnsureCapacityReservesWithoutShrinking;
    begin
      var lBuilder := new RemObjects.Elements.System.StringBuilder('prefix');
      Assert.AreEqual(lBuilder.EnsureCapacity(257), 257);
      Assert.AreEqual(lBuilder.Capacity, 257);
      Assert.AreEqual(lBuilder.Length, 6);
      Assert.AreEqual(lBuilder.ToString, 'prefix');
      Assert.AreEqual(lBuilder.EnsureCapacity(0), 257);
      Assert.AreEqual(lBuilder.EnsureCapacity(16), 257);
      Assert.AreEqual(lBuilder.EnsureCapacity(257), 257);
      lBuilder.Append(Char('x'), 251);
      Assert.AreEqual(lBuilder.Length, 257);
      Assert.AreEqual(lBuilder.Capacity, 257);
      Assert.AreEqual(lBuilder.ToString.Substring(0, 6), 'prefix');
      lBuilder.Clear;
      Assert.AreEqual(lBuilder.Capacity, 257);
      Assert.AreEqual(lBuilder.EnsureCapacity(258), 258);
      Assert.AreEqual(lBuilder.Length, 0);
    end;

    method GrowAndShrinkPreserveContent;
    begin
      var lChars: array of Char := [Char(0), Char($1234), Char($d800), Char($dc00), Char($dfff), Char($ffff), 'x'];
      var lText := new String(lChars);
      var lBuilder := new RemObjects.Elements.System.StringBuilder(lText);
      for each lCapacity in [65, 257, 7, 8, 7] do begin
        lBuilder.Capacity := lCapacity;
        Assert.AreEqual(lBuilder.Capacity, lCapacity);
        Assert.AreEqual(lBuilder.Length, lChars.Length);
        Assert.AreEqual(lBuilder.ToString, lText);
      end;
      lBuilder.Append('!');
      Assert.AreEqual(lBuilder.ToString, lText + '!');
      lBuilder.Clear;
      lBuilder.Capacity := 0;
      Assert.AreEqual(lBuilder.Capacity, 0);
      lBuilder.Append(lText);
      Assert.AreEqual(lBuilder.ToString, lText);
    end;

    method InvalidCapacityDoesNotMutate;
    begin
      var lBuilder := new RemObjects.Elements.System.StringBuilder('keep');
      var lOriginalCapacity := lBuilder.Capacity;
      for each lCapacity in [-1, 0, 3] do begin
        var lCaught := false;
        try
          lBuilder.Capacity := lCapacity;
        except
          on e: Exception do
            lCaught := true;
        end;
        Assert.AreEqual(lCaught, true);
        Assert.AreEqual(lBuilder.Capacity, lOriginalCapacity);
        Assert.AreEqual(lBuilder.ToString, 'keep');
      end;
      var lCaught := false;
      try
        lBuilder.EnsureCapacity(-1);
      except
        on e: Exception do
          lCaught := true;
      end;
      Assert.AreEqual(lCaught, true);
      Assert.AreEqual(lBuilder.Capacity, lOriginalCapacity);
      Assert.AreEqual(lBuilder.ToString, 'keep');
    end;

  end;
end.
