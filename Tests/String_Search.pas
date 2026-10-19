// Search regression guards: the public UTF-16 IndexOf overloads must find the
// first complete match from the requested offset, including NULs and surrogates.
// Plain character loops also guard vectorization at tails/protected pages; a raw
// pointer early-exit control must not inherit the String storage guarantee.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  String_Search = public class(Test)
  private

    [DisableInlining]
    class method FindFirst(aText: String; aChar: Char): Integer;
    begin
      for i := 0 to aText.Length - 1 do
        if aText[i] = aChar then exit i;
      exit -1;
    end;

    // Negative guard: a generic pointer/count is not a String storage proof.
    // An early match may make accesses after the first code unit unnecessary.
    [DisableInlining]
    class method FindPointer(aChars: ^Char; aCount: Integer; aChar: Char): Integer;
    begin
      for i := 0 to aCount - 1 do
        if aChars[i] = aChar then exit i;
      exit -1;
    end;

    [DisableInlining]
    class method CountChar(aText: String; aChar: Char): Integer;
    begin
      result := 0;
      for i := 0 to aText.Length - 1 do
        if aText[i] = aChar then inc(result);
    end;

  public

    // Plain loops must preserve the first matching UTF-16 code unit and count
    // every match, including NULs and surrogates around vector/tail boundaries.
    method BoundedCharacterLoops;
    begin
      for each lSize in [0, 1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 127, 128, 129] do begin
        var lChars := new Char[lSize];
        for i := 0 to lSize - 1 do lChars[i] := Char(i mod 5);
        if lSize > 0 then lChars[lSize - 1] := Char($d800);
        var lText := if lSize = 0 then '' else new String(lChars);
        for each lChar in [Char(0), Char(1), Char(4), Char($d800), Char($dfff)] do begin
          var lFirst := -1;
          var lCount := 0;
          for i := 0 to lSize - 1 do
            if lChars[i] = lChar then begin
              if lFirst = -1 then lFirst := i;
              inc(lCount);
            end;
          Assert.AreEqual(lFirst, FindFirst(lText, lChar));
          Assert.AreEqual(lCount, CountChar(lText, lChar));
        end;
      end;
    end;

    {$IF WINDOWS}
    // A valid, naturally aligned String image ends exactly at a protected page.
    // No terminator or allocation padding may be included in a vector load.
    method CharacterLoopsAtGuardPage;
    begin
      var lInfo: rtl.SYSTEM_INFO;
      rtl.GetSystemInfo(@lInfo);
      var lPage := NativeUInt(lInfo.dwPageSize);
      var lAllocation := ^Byte(rtl.VirtualAlloc(nil, lPage * 2, rtl.MEM_RESERVE or rtl.MEM_COMMIT, rtl.PAGE_READWRITE));
      Assert.IsTrue(lAllocation <> nil);
      try
        var lPrevious: rtl.DWORD;
        Assert.IsTrue(rtl.VirtualProtect(lAllocation + lPage, lPage, rtl.PAGE_NOACCESS, @lPrevious));
        var lOne := ^Char(lAllocation + lPage - sizeOf(Char));
        lOne^ := 'a';
        Assert.AreEqual(0, FindPointer(lOne, 64, 'a'));
        // These sizes keep the object header aligned on both 32- and 64-bit
        // Windows while leaving a partial UTF-16 vector at the page boundary.
        for each lSize in [2, 6, 10, 14, 18, 30, 34, 126, 130] do begin
          var lChars := new Char[lSize];
          for i := 0 to lSize - 2 do lChars[i] := 'a';
          lChars[lSize - 1] := Char($d800);
          var lSource := new String(lChars);
          var lBytes := sizeOf(Object) + sizeOf(Integer) + lSize * sizeOf(Char);
          var lBase := lAllocation + lPage - lBytes;
          memcpy(lBase, InternalCalls.Cast(lSource), lBytes);
          var lText := InternalCalls.Cast<String>(lBase);
          Assert.AreEqual(0, FindFirst(lText, 'a'));
          Assert.AreEqual(lSize - 1, FindFirst(lText, Char($d800)));
          Assert.AreEqual(-1, FindFirst(lText, 'z'));
          Assert.AreEqual(lSize - 1, CountChar(lText, 'a'));
          lText := nil;
        end;
      finally
        rtl.VirtualFree(lAllocation, 0, rtl.MEM_RELEASE);
      end;
    end;
    {$ENDIF}

    method MatchPositionsAndOffsets;
    begin
      for each lLength in [1, 2, 3, 7, 8, 9, 31, 32, 33] do begin
        var lNeedleChars := new Char[lLength];
        for i := 0 to lLength - 1 do
          lNeedleChars[i] := Char(Integer('a') + i mod 7);
        var lNeedle := new String(lNeedleChars);
        var lText := '!' + lNeedle + '!' + lNeedle + '!';
        Assert.AreEqual(1, lText.IndexOf(lNeedle));
        Assert.AreEqual(1, lText.IndexOf(lNeedle, 1));
        Assert.AreEqual(lLength + 2, lText.IndexOf(lNeedle, 2));
        Assert.AreEqual(-1, lText.IndexOf(lNeedle, lLength + 3));
        Assert.AreEqual(-1, lText.IndexOf(lNeedle, lText.Length));
        Assert.AreEqual(0, lNeedle.IndexOf(lNeedle));
        Assert.AreEqual(-1, lNeedle.IndexOf(lNeedle + '!'));
        Assert.AreEqual(-1, lText.IndexOf('?'));
      end;
      Assert.AreEqual(4, 'aaaaaaab'.IndexOf('aaab'));
      Assert.AreEqual(-1, 'aaaaaaaa'.IndexOf('aaab'));
      Assert.AreEqual(2, 'ababababac'.IndexOf('abababac'));
      Assert.AreEqual(3, 'prefix'.IndexOf('fix'));
    end;

    method Utf16CodeUnits;
    begin
      var lChars: array of Char := [Char(0), Char($d800), Char($dc00), Char(0), Char($dfff)];
      var lText := new String(lChars);
      Assert.AreEqual(0, lText.IndexOf(new String(@lChars[0], 1)));
      Assert.AreEqual(3, lText.IndexOf(new String(@lChars[0], 1), 1));
      Assert.AreEqual(1, lText.IndexOf(new String(@lChars[1], 2)));
      Assert.AreEqual(2, lText.IndexOf(new String(@lChars[2], 1)));
      Assert.AreEqual(3, lText.IndexOf(new String(@lChars[3], 2)));
    end;

    // Seeded UTF-16 strings exercise both search paths and low-byte hash
    // collisions. The independent oracle checks every candidate code unit.
    method SeededSearchAndBoundaries;
    begin
      var seed: UInt32 := 1234567;
      for trial := 0 to 1999 do begin
        seed := seed * 1664525 + 1013904223;
        var n := Integer(seed mod 193);
        seed := seed * 1664525 + 1013904223;
        var m := Integer(seed mod 40);
        var chars := new Char[n];
        var needle := new Char[m];
        for i := 0 to n - 1 do begin
          seed := seed * 1664525 + 1013904223;
          chars[i] := Char((seed shr 16) and $ff03);
        end;
        for i := 0 to m - 1 do begin
          seed := seed * 1664525 + 1013904223;
          needle[i] := Char((seed shr 16) and $ff03);
        end;
        if (m > 0) and (m <= n) and ((trial and 1) = 0) then begin
          var at := Integer(seed mod UInt32(n - m + 1));
          for i := 0 to m - 1 do chars[at + i] := needle[i];
        end;
        var text := if n = 0 then '' else new String(chars);
        var value := if m = 0 then '' else new String(needle);
        for each start in [0, n / 2, n, n + 1] do begin
          var expected := -1;
          if m = 0 then expected := 0
          else if m <= n then begin
            for i := start to n - m do begin
              var matches := true;
              for j := 0 to m - 1 do
                if chars[i + j] <> needle[j] then begin
                  matches := false;
                  break;
                end;
              if matches then begin expected := i; break; end;
            end;
          end;
          Assert.AreEqual(expected, text.IndexOf(value, start));
        end;
      end;
      for each n in [8, 9, 15, 16, 31, 32, 255, 256] do begin
        var chars := new Char[n];
        for i := 0 to n - 1 do chars[i] := 'a';
        var text := new String(chars);
        chars[n - 1] := 'b';
        var needle := new String(chars);
        Assert.AreEqual(-1, text.IndexOf(needle));
        Assert.AreEqual(n, (text + needle).IndexOf(needle));
        Assert.AreEqual(0, needle.IndexOf(needle));
      end;
      var failed := false;
      try 'abc'.IndexOf('a', -1); except on e: IndexOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      Assert.AreEqual(0, 'abc'.IndexOf('', -1));
      Assert.AreEqual(-1, 'abc'.IndexOf('abcd', -1));
    end;

  end;
end.
