namespace RemObjects.Elements.System;

type
  SwiftType<T> = public record
  private
    fType: ^SwiftTypeRecord;
  public
    constructor(aType :^SwiftTypeRecord);
    begin
      fType := aType;
    end;

    property &Type: ^SwiftTypeRecord read fType;
  end;

  SwiftType = public SwiftType<SwiftAny>;

  [SwiftFixedLayout]
  SwiftAny = public record
  private
    fData: array[0..23] of Byte; // This is a guess; we need to target a 32bits target to know for sure.
    fType: ^SwiftTypeRecord;

  public
    property Data: ^Byte read @fData;
    property &Type: ^SwiftTypeRecord read fType;
    property UnboxedData: ^Byte read if fType = nil then nil else if 0 = (fType^.VWT^.flags and SwiftValueWitnessTable.IsNonInline) then ^Byte(swift_projectBox(^^SwiftRefcounted(@fData)^)) else @fData[0];
    // swift_projectBox
    constructor(aValue: ^Void;  aTakeOwnership: Boolean);
    begin
      if aTakeOwnership then begin
        fData := ^SwiftAny(aValue).fData;
        fType := ^SwiftAny(aValue).fType;
      end else begin
        SwiftAny.CopyAny(var self, var ^SwiftAny(aValue)^, false);
      end;
    end;

    constructor(aValue: ^Void; aInputType: ^SwiftTypeRecord; aTakeOwnership: Boolean);
    begin
      if aInputType = nil then exit;
      SwiftAllocateBoxIfNeeded(@fData, aValue, aInputType, aTakeOwnership);
    end;

    method Release;
    begin
      if fType = nil then exit;
      var lVWT := fType^.VWT;
      if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
        SwiftStrong.swift_release(IntPtr(^^SwiftRefcounted(@fData)^));
      end else begin
        lVWT^.destroy(IntPtr(@fData), fType);
      end;

      fType := nil;
    end;

    method &Set(aValue: ^Void; aInputType: ^SwiftTypeRecord; aTakeOwnership: Boolean);
    begin
      Release;
      if aInputType = nil then exit;
      SwiftAllocateBoxIfNeeded(@fData, aValue, aInputType, aTakeOwnership);
    end;

    class method CopyAny(var aDest, aSource: SwiftAny; aReleaseOld: Boolean);
    begin
      if (@aDest) = (@aSource) then exit; // don't copy to ourselves.
      if aSource.Type = nil then begin
        // Source is empty
        if aReleaseOld and (aDest.Type <> nil) then begin
          var lVWT := ^SwiftValueWitnessTable(@aDest.Type[-1]);
          if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
            SwiftStrong.swift_release(IntPtr(^^SwiftRefcounted(@aDest.fData)^));
          end else begin
            lVWT^.destroy(IntPtr(@aDest.fData), aDest.Type);
          end;

        end;

        aDest.fType := nil;
        exit;
      end;

      if aReleaseOld and (aDest.Type <> nil) then begin
        var lVWT := ^SwiftValueWitnessTable(@aDest.Type[-1]);
        if 0 = (lVWT^.flags and SwiftValueWitnessTable.IsNonInline) then begin
          SwiftStrong.swift_release(IntPtr(^^SwiftRefcounted(@aDest.fData)^));
        end else begin
          lVWT^.destroy(IntPtr(@aDest.fData), aDest.Type);
        end;
      end;
      aDest.fType := aSource.fType;
      var lVWT := ^SwiftValueWitnessTable(@aSource.Type[-1]);
      lVWT^.initializeBufferWithCopyOfBuffer(IntPtr(@aDest.fData), IntPtr(@aSource.fData), aSource.Type);
    end;


    constructor Copy(var aValue: SwiftAny);
    begin
      CopyAny(var Self, var aValue, false);
    end;

    class operator Assign(var aDest: SwiftAny; var aSource: SwiftAny);
    begin
      CopyAny(var aDest, var aSource, true);
    end;

    finalizer;
    begin
      Release;
    end;
  end;


end.