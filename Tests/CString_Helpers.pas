// Regression guards for Windows C-string helpers: scans must advance, stop at
// the first NUL, find NUL itself where required, and preserve copy bounds/results.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;

{$IF WINDOWS}
type
  CString_Helpers = public class(Test)
  private

    // Bind our linked IslandRTL exports without importing their inline bodies.
    [SymbolName('strchr')]
    class method NativeFindFirst(aText: ^AnsiChar; aValue: Integer): ^AnsiChar; external;

    [SymbolName('strrchr')]
    class method NativeFindLast(aText: ^AnsiChar; aValue: Integer): ^AnsiChar; external;

    [SymbolName('strpbrk')]
    class method NativeFindAny(aText, aSet: ^AnsiChar): ^AnsiChar; external;

    [SymbolName('strncpy')]
    class method NativeCopy(aDestination, aSource: ^AnsiChar; aCount: Integer): ^AnsiChar; external;

    // Keep these calls out of LLVM's libc simplification so tests exercise the
    // exported implementation, including its actual return value.
    [DisableOptimizations, DisableInlining]
    class method FindFirst(aText: ^AnsiChar; aValue: Integer): ^AnsiChar;
    begin
      exit NativeFindFirst(aText, aValue);
    end;

    [DisableOptimizations, DisableInlining]
    class method FindLast(aText: ^AnsiChar; aValue: Integer): ^AnsiChar;
    begin
      exit NativeFindLast(aText, aValue);
    end;

    [DisableOptimizations, DisableInlining]
    class method FindAny(aText, aSet: ^AnsiChar): ^AnsiChar;
    begin
      exit NativeFindAny(aText, aSet);
    end;

    [DisableOptimizations, DisableInlining]
    class method Copy(aDestination, aSource: ^AnsiChar; aCount: Integer): ^AnsiChar;
    begin
      exit NativeCopy(aDestination, aSource, aCount);
    end;

  public

    // Positive/negative guards: every byte, repeated matches, missing bytes,
    // empty input, NUL searches and truncation of the int search argument.
    method FirstAndLastMatches;
    begin
      var lBuffer := new Byte[528];
      for lOffset := 0 to 15 do begin
        var lText := ^AnsiChar(@lBuffer[lOffset]);
        for i := 0 to 509 do
          lText[i] := AnsiChar(1 + i mod 255);
        lText[510] := #0;
        lText[511] := AnsiChar(42);
        for i := 1 to 255 do begin
          Assert.IsTrue(FindFirst(lText, i) = lText + i - 1);
          Assert.IsTrue(FindLast(lText, i) = lText + i - 1 + 255);
          Assert.IsTrue(FindFirst(lText, i + 256) = lText + i - 1);
          Assert.IsTrue(FindLast(lText, i - 256) = lText + i - 1 + 255);
        end;
        Assert.IsTrue(FindFirst(lText, 0) = lText + 510);
        Assert.IsTrue(FindLast(lText, 256) = lText + 510);
        lText[0] := AnsiChar(17);
        lText[1] := #0;
        Assert.IsTrue(FindFirst(lText, 42) = nil);
        Assert.IsTrue(FindLast(lText, 42) = nil);
        lText[0] := #0;
        Assert.IsTrue(FindFirst(lText, 0) = lText);
        Assert.IsTrue(FindLast(lText, 0) = lText);
        Assert.IsTrue(FindFirst(lText, 17) = nil);
        Assert.IsTrue(FindLast(lText, 17) = nil);
      end;
    end;

    // A nonmatching first byte must advance; set order cannot override text order.
    method AnyOfMatches;
    begin
      var lBuffer := new Byte[80];
      var lSetBuffer := new Byte[32];
      for lOffset := 0 to 15 do begin
        var lText := ^AnsiChar(@lBuffer[lOffset]);
        var lSet := ^AnsiChar(@lSetBuffer[lOffset]);
        for i := 0 to 63 do
          lText[i] := AnsiChar(1 + i);
        lText[64] := #0;
        lSet[0] := AnsiChar(60);
        lSet[1] := AnsiChar(42);
        lSet[2] := #0;
        Assert.IsTrue(FindAny(lText, lSet) = lText + 41);
        lSet[0] := AnsiChar(255);
        lSet[1] := #0;
        Assert.IsTrue(FindAny(lText, lSet) = nil);
        lText[63] := AnsiChar(255);
        Assert.IsTrue(FindAny(lText, lSet) = lText + 63);
        lSet[0] := #0;
        Assert.IsTrue(FindAny(lText, lSet) = nil);
        lText[0] := #0;
        Assert.IsTrue(FindAny(lText, lSet) = nil);
        lSet[0] := AnsiChar(1);
        lSet[1] := #0;
        Assert.IsTrue(FindAny(lText, lSet) = nil);
      end;
    end;

    // Truncated copies do not append NUL; shorter inputs pad exactly to count.
    // The returned pointer is the original destination even for zero count.
    method CopyBoundsPaddingAndReturn;
    begin
      var lSourceBuffer := new Byte[96];
      var lDestinationBuffer := new Byte[112];
      for lSourceOffset := 0 to 15 do
      for lDestinationOffset := 0 to 15 do
      for each lLength in [0, 1, 7, 8, 15, 16, 17, 31, 32, 33, 63] do
      for each lCount in [0, 1, 7, 8, 15, 16, 17, 31, 32, 33, 63, 64, 65] do begin
        var lSource := ^AnsiChar(@lSourceBuffer[lSourceOffset]);
        var lDestination := ^AnsiChar(@lDestinationBuffer[16 + lDestinationOffset]);
        for i := 0 to 95 do
          lSourceBuffer[i] := Byte(128 + i mod 127);
        lSource[lLength] := #0;
        for i := 0 to 111 do
          lDestinationBuffer[i] := 165;
        Assert.IsTrue(Copy(lDestination, lSource, lCount) = lDestination);
        for i := 0 to 111 do begin
          var j := i - 16 - lDestinationOffset;
          var lExpected := if (j < 0) or (j >= lCount) then Byte(165) else if j < lLength then Byte(lSource[j]) else Byte(0);
          Assert.AreEqual(lExpected, lDestinationBuffer[i]);
        end;
        for i := 0 to 95 do
          Assert.AreEqual(if i = lSourceOffset + lLength then Byte(0) else Byte(128 + i mod 127), lSourceBuffer[i]);
      end;
    end;

    // A NUL at the end of a readable page must stop every search and padded copy.
    method GuardPageBoundaries;
    begin
      var lInfo: rtl.SYSTEM_INFO;
      rtl.GetSystemInfo(@lInfo);
      var lPage := NativeInt(lInfo.dwPageSize);
      var lAllocation := ^Byte(rtl.VirtualAlloc(nil, lPage * 2, rtl.MEM_RESERVE or rtl.MEM_COMMIT, rtl.PAGE_READWRITE));
      try
        Assert.IsTrue(assigned(lAllocation));
        var lPrevious: rtl.DWORD;
        Assert.IsTrue(rtl.VirtualProtect(lAllocation + lPage, lPage, rtl.PAGE_NOACCESS, @lPrevious));
        var lOutput := new Byte[80];
        var lSetBytes := new Byte[2];
        var lSet := ^AnsiChar(@lSetBytes[0]);
        lSet[0] := AnsiChar(255);
        lSet[1] := #0;
        for lLength := 0 to 65 do begin
          var lText := ^AnsiChar(lAllocation + lPage - lLength - 1);
          for i := 0 to lLength - 1 do
            lText[i] := AnsiChar(128);
          lText[lLength] := #0;
          Assert.IsTrue(FindFirst(lText, 0) = lText + lLength);
          Assert.IsTrue(FindLast(lText, 0) = lText + lLength);
          Assert.IsTrue(FindFirst(lText, 255) = nil);
          Assert.IsTrue(FindLast(lText, 255) = nil);
          Assert.IsTrue(FindAny(lText, lSet) = nil);
          var lDestination := ^AnsiChar(@lOutput[0]);
          Assert.IsTrue(Copy(lDestination, lText, 80) = lDestination);
          for i := 0 to 79 do
            Assert.AreEqual(if i < lLength then Byte(128) else Byte(0), lOutput[i]);
        end;
        var lInaccessible := ^AnsiChar(lAllocation + lPage);
        Assert.IsTrue(Copy(lInaccessible, lInaccessible, 0) = lInaccessible);
        var lSource := ^AnsiChar(@lOutput[0]);
        for i := 0 to 79 do
          lSource[i] := AnsiChar(255);
        for lCount := 0 to 65 do begin
          var lDestination := ^AnsiChar(lAllocation + lPage - lCount);
          Assert.IsTrue(Copy(lDestination, lSource, lCount) = lDestination);
          for i := 0 to lCount - 1 do
            Assert.AreEqual(Byte(255), Byte(lDestination[i]));
        end;
      finally
        if assigned(lAllocation) then
          rtl.VirtualFree(lAllocation, 0, rtl.MEM_RELEASE);
      end;
    end;

  end;
{$ENDIF}
end.
