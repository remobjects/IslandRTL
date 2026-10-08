// Regression guards for Windows memory helpers: preserve unsigned ordering,
// arbitrary alignment, overlap semantics, return values and exact buffer bounds.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

{$IF WINDOWS}
type
  Memory_Comparison = public class(Test)
  public

    method OffsetsLengthsAndFirstMismatch;
    begin
      var lA := new Byte[288];
      var lB := new Byte[288];
      for lOffsetA := 0 to 15 do begin
        for lOffsetB := 0 to 15 do begin
          for each lLength in [0, 1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65, 127, 128, 129, 255, 256, 257] do begin
            for i := 0 to lLength - 1 do begin
              lA[lOffsetA + i] := Byte((i * 37 + 128) and 255);
              lB[lOffsetB + i] := lA[lOffsetA + i];
            end;
            var lLeft := @lA[lOffsetA];
            var lRight := @lB[lOffsetB];
            Assert.AreEqual(0, memcmp(lLeft, lRight, lLength));
            Assert.AreEqual(0, memcmp(lLeft, lLeft, lLength));
            for i := 0 to lLength - 1 do begin
              var lSaved := lB[lOffsetB + i];
              lB[lOffsetB + i] := lSaved xor Byte(128);
              var lExpected := if lA[lOffsetA + i] < lB[lOffsetB + i] then -1 else 1;
              Assert.AreEqual(lExpected, memcmp(lLeft, lRight, lLength));
              Assert.AreEqual(-lExpected, memcmp(lRight, lLeft, lLength));
              lB[lOffsetB + i] := lSaved;
            end;
          end;
        end;
      end;
    end;

    // A later, opposite mismatch must never override the first differing byte.
    method FirstDifferenceControlsOrdering;
    begin
      var lA := new Byte[64];
      var lB := new Byte[64];
      for i := 0 to 62 do begin
        lA[i] := 127;
        lB[i] := 128;
        lA[63] := 255;
        lB[63] := 0;
        Assert.AreEqual(-1, memcmp(@lA[0], @lB[0], 64));
        Assert.AreEqual(1, memcmp(@lB[0], @lA[0], 64));
        lA[i] := 0;
        lB[i] := 0;
      end;
    end;

    // Positive guards: copy every length around block/tail boundaries at all
    // 16-byte alignment offsets; preserve both source and destination canaries.
    method CopyAndFillOffsetsAndTails;
    begin
      var lSource := new Byte[320];
      var lDestination := new Byte[320];
      for lSourceOffset := 0 to 15 do begin
        for lDestinationOffset := 0 to 15 do begin
          for each lLength in [0, 1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65, 127, 128, 129, 255, 256, 257] do begin
            for i := 0 to 319 do begin
              lSource[i] := Byte((i * 37 + 19) and 255);
              lDestination[i] := 165;
            end;
            var lStart := 16 + lDestinationOffset;
            var lResult := memcpy(@lDestination[lStart], @lSource[16 + lSourceOffset], lLength);
            Assert.IsTrue(lResult = ^Void(@lDestination[lStart]));
            for i := 0 to 319 do begin
              Assert.AreEqual(Byte((i * 37 + 19) and 255), lSource[i]);
              var lExpected := if (i >= lStart) and (i < lStart + lLength) then lSource[16 + lSourceOffset + i - lStart] else Byte(165);
              Assert.AreEqual(lExpected, lDestination[i]);
            end;
            for each lValue in [0, 1, 127, 128, 255, 256, -1, -129] do begin
              lResult := memset(@lDestination[lStart], lValue, lLength);
              Assert.IsTrue(lResult = ^Void(@lDestination[lStart]));
              for i := 0 to 319 do begin
                var lExpected := if (i >= lStart) and (i < lStart + lLength) then Byte(lValue and 255) else Byte(165);
                Assert.AreEqual(lExpected, lDestination[i]);
              end;
            end;
          end;
        end;
      end;
    end;

    // Snapshot semantics: both overlap directions, same pointer, disjoint ranges,
    // and distances smaller than a wide load must match an independent byte copy.
    method OverlappingMoves;
    begin
      var lBuffer := new Byte[832];
      var lExpected := new Byte[832];
      var lOriginal := new Byte[832];
      for lOffset := 0 to 15 do begin
        for each lDistance in [-257, -33, -17, -16, -15, -8, -7, -2, -1, 0, 1, 2, 7, 8, 15, 16, 17, 33, 257] do begin
          for each lLength in [0, 1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65, 127, 128, 129, 255, 256, 257] do begin
            for i := 0 to 831 do begin
              lOriginal[i] := Byte((i * 29 + 7) and 255);
              lBuffer[i] := lOriginal[i];
              lExpected[i] := lOriginal[i];
            end;
            var lSource := 272 + lOffset;
            var lDestination := lSource + lDistance;
            for i := 0 to lLength - 1 do
              lExpected[lDestination + i] := lOriginal[lSource + i];
            var lResult := memmove(@lBuffer[lDestination], @lBuffer[lSource], lLength);
            Assert.IsTrue(lResult = ^Void(@lBuffer[lDestination]));
            for i := 0 to 831 do
              Assert.AreEqual(lExpected[i], lBuffer[i]);
          end;
        end;
      end;
    end;

    // A zero count must neither dereference an inaccessible pointer nor alter it.
    method ZeroLengthReturns;
    begin
      Assert.IsTrue(memcpy(nil, nil, 0) = nil);
      Assert.IsTrue(memmove(nil, nil, 0) = nil);
      Assert.IsTrue(memset(nil, 128, 0) = nil);
      Assert.AreEqual(0, memcmp(nil, nil, 0));
    end;

    // Inaccessible pages immediately after either range detect
    // full-block loads beyond the requested length, including zero-length input.
    method GuardPageBoundaries;
    begin
      var lInfo: rtl.SYSTEM_INFO;
      rtl.GetSystemInfo(@lInfo);
      var lPageSize := NativeInt(lInfo.dwPageSize);
      var lA := ^Byte(rtl.VirtualAlloc(nil, lPageSize * 3, rtl.MEM_RESERVE or rtl.MEM_COMMIT, rtl.PAGE_READWRITE));
      var lB := ^Byte(rtl.VirtualAlloc(nil, lPageSize * 3, rtl.MEM_RESERVE or rtl.MEM_COMMIT, rtl.PAGE_READWRITE));
      try
        Assert.IsTrue(assigned(lA) and assigned(lB));
        var lPrevious: rtl.DWORD;
        Assert.IsTrue(rtl.VirtualProtect(lA, lPageSize, rtl.PAGE_NOACCESS, @lPrevious));
        Assert.IsTrue(rtl.VirtualProtect(lB, lPageSize, rtl.PAGE_NOACCESS, @lPrevious));
        Assert.IsTrue(rtl.VirtualProtect(lA + lPageSize * 2, lPageSize, rtl.PAGE_NOACCESS, @lPrevious));
        Assert.IsTrue(rtl.VirtualProtect(lB + lPageSize * 2, lPageSize, rtl.PAGE_NOACCESS, @lPrevious));
        for each lAtEnd in [false, true] do
        for lLength := 0 to 257 do begin
          var lLeft := if lAtEnd then lA + lPageSize * 2 - lLength else lA + lPageSize;
          var lRight := if lAtEnd then lB + lPageSize * 2 - lLength else lB + lPageSize;
          for i := 0 to lLength - 1 do begin
            lLeft[i] := Byte((i * 29) and 255);
            lRight[i] := lLeft[i];
          end;
          Assert.AreEqual(0, memcmp(lLeft, lRight, lLength));
          Assert.IsTrue(memcpy(lRight, lLeft, lLength) = ^Void(lRight));
          Assert.IsTrue(memset(lRight, 511, lLength) = ^Void(lRight));
          for i := 0 to lLength - 1 do
            Assert.AreEqual(Byte(255), lRight[i]);
          Assert.IsTrue(memmove(lRight, lLeft, lLength) = ^Void(lRight));
          Assert.AreEqual(0, memcmp(lLeft, lRight, lLength));
          if lLength > 0 then begin
            lRight[lLength - 1] := lRight[lLength - 1] xor Byte(128);
            Assert.IsTrue(memcmp(lLeft, lRight, lLength) <> 0);
          end;
        end;
        // Both overlap directions touch a guard boundary. Keep an independent
        // snapshot so this also catches overwritten source bytes within a block.
        var lOriginal := new Byte[lPageSize];
        for each lAtEnd in [false, true] do
        for each lDistance in [1, 2, 7, 8, 15, 16, 17, 33] do
        for each lLength in [1, 7, 8, 15, 16, 17, 31, 32, 33, 127, 128, 129, 257] do
        for each lBackward in [false, true] do begin
          var lBase := if lAtEnd then lPageSize - lLength - lDistance else 0;
          var lSource := lBase + (if lBackward then 0 else lDistance);
          var lDestination := lBase + (if lBackward then lDistance else 0);
          var lData := lA + lPageSize;
          for i := 0 to lPageSize - 1 do begin
            lOriginal[i] := Byte((i * 29 + 7) and 255);
            lData[i] := lOriginal[i];
          end;
          Assert.IsTrue(memmove(lData + lDestination, lData + lSource, lLength) = ^Void(lData + lDestination));
          for i := 0 to lPageSize - 1 do begin
            var lExpected := if (i >= lDestination) and (i < lDestination + lLength) then lOriginal[lSource + i - lDestination] else lOriginal[i];
            Assert.AreEqual(lExpected, lData[i]);
          end;
        end;
      finally
        if assigned(lA) then
          rtl.VirtualFree(lA, 0, rtl.MEM_RELEASE);
        if assigned(lB) then
          rtl.VirtualFree(lB, 0, rtl.MEM_RELEASE);
      end;
    end;

  end;
{$ENDIF}
end.
