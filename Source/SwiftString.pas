namespace RemObjects.Elements.System;

type
  //[Swift]
  [SwiftFixedLayout]
  UTF16View nested in SwiftString = public record
  public
  {$HIDE H8}
    // same as string, it's a wrapper.
    _countAndFlagsBits: UInt64;
    _object: ^Void;
  {$SHOW H8}

    class method DestroyUTF16View(aView: ^UTF16View);
    begin
      SwiftStrong.swift_bridgeObjectRelease(IntPtr(aView^._object));
    end;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5countSivg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16Count(aVal1: UInt64; aVal2: ^Void): IntPtr; external;

    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV10startIndexSS0D0Vvg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16FirstIndex(aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5index5afterSS5IndexVAF_tF'), CallingConvention(CallingConvention.Swift)]
    class method UTF16NextIndex(aPrev: Int64; aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewVys6UInt16VSS5IndexVcig'), CallingConvention(CallingConvention.Swift)]
    class method UTF16GetChar(aIndex: Int64; aVal1: UInt64; aVal2: ^Void): Char; external;
  end;

  //[Swift]
  [SwiftFixedLayout]
  UnicodeScalarView nested in SwiftString = public record
  public
  {$HIDE H8}
    // same as string, it's a wrapper.
    _countAndFlagsBits: UInt64;
    _object: ^Void;
  {$SHOW H8}
  end;

  [SwiftFixedLayout]
  UTF32View nested in SwiftString= public record
  public
  {$HIDE H8}
    // same as string, it's a wrapper.
    _countAndFlagsBits: UInt64;
    _object: ^Void;
  {$SHOW H8}

    class method DestroyUTF16View(aView: ^UTF16View);
    begin
      SwiftStrong.swift_bridgeObjectRelease(IntPtr(aView^._object));
    end;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5countSivg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16Count(aVal1: UInt64; aVal2: ^Void): IntPtr; external;

    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV10startIndexSS0D0Vvg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16FirstIndex(aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5index5afterSS5IndexVAF_tF'), CallingConvention(CallingConvention.Swift)]
    class method UTF16NextIndex(aPrev: Int64; aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewVys6UInt16VSS5IndexVcig'), CallingConvention(CallingConvention.Swift)]
    class method UTF16GetChar(aIndex: Int64; aVal1: UInt64; aVal2: ^Void): Char; external;
  end;

  [SwiftFixedLayout]
  UTF8View nested in SwiftString = public record
  public
  {$HIDE H8}
    // same as string, it's a wrapper.
    _countAndFlagsBits: UInt64;
    _object: ^Void;
  {$SHOW H8}

    class method DestroyUTF16View(aView: ^UTF16View);
    begin
      SwiftStrong.swift_bridgeObjectRelease(IntPtr(aView^._object));
    end;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5countSivg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16Count(aVal1: UInt64; aVal2: ^Void): IntPtr; external;

    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV10startIndexSS0D0Vvg'), CallingConvention(CallingConvention.Swift)]
    class method UTF16FirstIndex(aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewV5index5afterSS5IndexVAF_tF'), CallingConvention(CallingConvention.Swift)]
    class method UTF16NextIndex(aPrev: Int64; aVal1: UInt64; aVal2: ^Void): Int64; external;
    [DelayLoadDllImport('libswiftCore.dylib', '$sSS9UTF16ViewVys6UInt16VSS5IndexVcig'), CallingConvention(CallingConvention.Swift)]
    class method UTF16GetChar(aIndex: Int64; aVal1: UInt64; aVal2: ^Void): Char; external;
  end;

  [SwiftFixedLayout]
  SwiftString = public record
  private
    _countAndFlagsBits: UInt64;
    _object: ^Void;

    class var fTypeInfo: IntPtr := Process.GetCachedProcAddress('libswiftCore.dylib', '$sSSN');
    class property VWT: ^SwiftValueWitnessTable read ^^SwiftValueWitnessTable(fTypeInfo)[-1];

    [DelayLoadDllImport('/usr/lib/swift/libswiftFoundation.dylib', '$sSS10FoundationE14utf16CodeUnits5countSSSPys6UInt16VG_SitcfC'), CallingConvention(CallingConvention.Swift)]
    class method StringFromUTF16(aVal: ^Char; aLength: IntPtr): UTF16View; external;

    [DelayLoadDllImport('libswiftCore.dylib', '$sSS5utf16SS9UTF16ViewVvg'), CallingConvention(CallingConvention.Swift)]
    class method __UTF16View(aVal: UInt64; aVal2: ^Void): UTF16View; external;

    property Data: ^Void read @_countAndFlagsBits;
    property &Type: ^SwiftTypeRecord read ^SwiftTypeRecord(fTypeInfo);

  public
    finalizer;
    begin
      VWT^.destroy(IntPtr(@self), ^SwiftTypeRecord(fTypeInfo));
    end;

    constructor(aVal: ^Void; aCopy: Boolean);
    begin
      if aCopy then begin
        VWT^.initializeWithCopy(IntPtr(@self), IntPtr(aVal), ^SwiftTypeRecord(fTypeInfo));
      end else begin
        self._countAndFlagsBits := ^SwiftString(aVal)^._countAndFlagsBits;
        self._object := ^SwiftString(aVal)^._object;
      end;
    end;

    constructor Copy(var aValue: SwiftString);
    begin
      VWT^.initializeWithCopy(IntPtr(@self), IntPtr(@aValue), ^SwiftTypeRecord(fTypeInfo));
    end;

    class operator Assign(var aDest: SwiftString; var aSource: SwiftString);
    begin
      VWT^.assignWithCopy(IntPtr(@aDest), IntPtr(@aSource), ^SwiftTypeRecord(fTypeInfo));
    end;

    constructor(aValue: String);
    begin
      if aValue <> nil then begin
        var lWork := StringFromUTF16(aValue.FirstChar, aValue.Length);
        _countAndFlagsBits := lWork._countAndFlagsBits;
        _object := lWork._object;
      end;
    end;

    method ToString: String; override;
    begin
      var lView := __UTF16View(_countAndFlagsBits, _object);
      var lCount := UTF16View.UTF16Count(lView._countAndFlagsBits, lView._object);
      var lVal := new Char[lCount];
      if lVal.Length = 0 then exit nil;
      var lFirst := UTF16View.UTF16FirstIndex(lView._countAndFlagsBits, lView._object);
      lVal[0] := UTF16View.UTF16GetChar(lFirst, lView._countAndFlagsBits, lView._object);
      for i: Integer := 1 to lCount -1 do begin
        lFirst := UTF16View.UTF16NextIndex(lFirst, lView._countAndFlagsBits, lView._object);
        lVal[i] := UTF16View.UTF16GetChar(lFirst, lView._countAndFlagsBits, lView._object);
      end;

      UTF16View.DestroyUTF16View(@lView);
      exit String.FromCharArray(lVal);
    end;

    class operator implicit(aVal: String): SwiftString;
    begin
      exit new SwiftString(aVal);
    end;

    class operator implicit(aVal: SwiftString): String;
    begin
      exit aVal.ToString;
    end;

    class operator implicit(aVal: CocoaString): SwiftString;
    begin
      exit new SwiftString(aVal);
    end;

    class operator implicit(aVal: SwiftString): CocoaString;
    begin
      exit aVal.ToString;
    end;

  end;

end.