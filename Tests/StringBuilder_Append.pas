// Append regression guards: direct slice copies and repeated-character fills
// must preserve UTF-16 code units, boundaries, existing content, and rejection
// without mutation. Large indices/counts must be rejected before pointer access.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  StringBuilder_Append = public class(Test)
  private

    class method RejectSlice(aSource: String; aStart, aCount: Integer);
    begin
      var lBuilder := new RemObjects.Elements.System.StringBuilder('keep');
      var lCaught := false;
      try
        lBuilder.Append(aSource, aStart, aCount);
      except
        on e: Exception do
          lCaught := true;
      end;
      Assert.AreEqual(lCaught, true);
      Assert.AreEqual(lBuilder.ToString, 'keep');
    end;

  public

    method SlicesAndUtf16;
    begin
      var lChars: array of Char := [Char(0), Char($1234), Char($d800), Char($dc00), Char($dfff), Char($ffff), 'x'];
      var lSource := new String(lChars);
      for lStart := 0 to lChars.Length do
        for lCount := 0 to lChars.Length - lStart do begin
          var lBuilder := new RemObjects.Elements.System.StringBuilder('prefix');
          Assert.AreEqual(Object.ReferenceEquals(lBuilder.Append(lSource, lStart, lCount), lBuilder), true);
          Assert.AreEqual(lBuilder.Length, 6 + lCount);
          var lActual := lBuilder.ToString;
          Assert.AreEqual(lActual.Substring(0, 6), 'prefix');
          for i := 0 to lCount - 1 do
            Assert.AreEqual(lActual[6 + i], lChars[lStart + i]);
          // ToString owns its contents; later appends must not alter it.
          lBuilder.Append('!');
          Assert.AreEqual(lActual.Length, 6 + lCount);
        end;
    end;

    method RepeatedCharsAndGrowth;
    begin
      for each lChar in [Char(0), Char($1234), Char($d800), Char($dfff), Char($ffff), Char('x')] do
        for each lCount in [0, 1, 2, 7, 16, 17, 64, 65, 257] do begin
          var lBuilder := new RemObjects.Elements.System.StringBuilder('prefix');
          Assert.AreEqual(Object.ReferenceEquals(lBuilder.Append(lChar, lCount), lBuilder), true);
          Assert.AreEqual(lBuilder.Length, 6 + lCount);
          Assert.AreEqual(lBuilder.ToString.Substring(0, 6), 'prefix');
          for i := 6 to lBuilder.Length - 1 do
            Assert.AreEqual(lBuilder[i], lChar);
          lBuilder.Clear;
          lBuilder.Append(lChar, lCount);
          Assert.AreEqual(lBuilder.Length, lCount);
          for i := 0 to lCount - 1 do
            Assert.AreEqual(lBuilder[i], lChar);
        end;
    end;

    method EmptyAndRejectedSlices;
    begin
      var lBuilder := new RemObjects.Elements.System.StringBuilder('keep');
      lBuilder.Append(String(nil), 0, 0);
      lBuilder.Append('', 0, 0);
      lBuilder.Append('abc', 3, 0);
      Assert.AreEqual(lBuilder.ToString, 'keep');
      RejectSlice(nil, 0, 1);
      RejectSlice('', 1, 0);
      RejectSlice('abc', -1, 1);
      RejectSlice('abc', 0, -1);
      RejectSlice('abc', 4, 0);
      RejectSlice('abc', 2, 2);
      RejectSlice('abc', Int32.MaxValue, 1);
      RejectSlice('abc', 1, Int32.MaxValue);
    end;

    method RejectedRepeatDoesNotMutate;
    begin
      for each lCount in [-1, Int32.MaxValue] do begin
        var lBuilder := new RemObjects.Elements.System.StringBuilder('keep');
        var lCaught := false;
        try
          lBuilder.Append(Char('x'), lCount);
        except
          on e: Exception do
            lCaught := true;
        end;
        Assert.AreEqual(lCaught, true);
        Assert.AreEqual(lBuilder.ToString, 'keep');
      end;
    end;

  end;
end.
