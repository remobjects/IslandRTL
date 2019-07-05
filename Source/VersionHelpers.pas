namespace RemObjects.Elements.System;

method __ElementsPlatformAndVersionAtLeast(aPlatformName: String; aMaj, aMin: Integer; aRev: Integer := 0): Boolean; public;
begin
  case aPlatformName:ToLower of
    'tvos': {$IFDEF TARGET_OS_TV}exit __ElementsPlatformVersionAtLeast(aMaj, aMin, aRev){$ENDIF};
    'watchos': {$IFDEF TARGET_OS_WATCH}exit __ElementsPlatformVersionAtLeast(aMaj, aMin, aRev){$ENDIF};
    'ios', 'iphoneos', 'ipados': {$IFDEF TARGET_OS_UIKITFORMAC}exit __ElementsUIKitForMacVersionAtLeast(aMaj, aMin, aRev){$ELSEIF TARGET_OS_IPHONE}exit __ElementsPlatformVersionAtLeast(aMaj, aMin, aRev){$ENDIF};
    'macos', 'mac os x', 'os x', 'mac os': {$IFDEF TARGET_OS_MAC OR TARGET_OS_UIKITFORMAC}exit __ElementsPlatformVersionAtLeast(aMaj, aMin, aRev){$ENDIF};
    'uikitformac', 'uikit for mac': {$IFDEF TARGET_OS_UIKITFORMAC}exit __ElementsUIKitForMacVersionAtLeast(aMaj, aMin, aRev){$ENDIF};

    'android', 'androidndk', 'android ndk': {$IFDEF ANDROID}exit __ElementsPlatformVersionAtLeast(aMaj, aMin, aRev){$ENDIF};
  end;
end;

method __ElementsPlatformVersionString: String; public;
begin
  __ElementsLoadPlatformVersion;
  result := $"{__ElementsPlatformVersion[1]}.{__ElementsPlatformVersion[2]},{__ElementsPlatformVersion[3]}";
end;


var __ElementsPlatformVersion: array[0..3] of Integer;
{$IFDEF TARGET_OS_UIKITFORMAC}
var __ElementsUIKitForMacVersion: array[0..3] of Integer;
{$ENDIF}

method __ElementsLoadPlatformVersion;
begin
  if __ElementsPlatformVersion[0] = 1 then
    exit;

  __ElementsPlatformVersion[0] := 1;
  {$IF DARWIN}
  var version := Foundation.NSProcessInfo.processInfo.operatingSystemVersion;
  __ElementsPlatformVersion[1] := version.majorVersion;
  __ElementsPlatformVersion[2] := version.minorVersion;
  __ElementsPlatformVersion[3] := version.patchVersion;

  if defined("TARGET_OS_UIKITFORMAC") and (__ElementsPlatformVersion[2] ≥ 15) then begin
    __ElementsUIKitForMacVersion[0] := 1;
    __ElementsUIKitForMacVersion[1] := __ElementsPlatformVersion[2]-2;
    __ElementsUIKitForMacVersion[2] := __ElementsPlatformVersion[3];
    __ElementsUIKitForMacVersion[3] := 0;
  end;

  // operatingSystemVersion is new in macOS 10.10 and iOS 8, but we don't support older versions in Island.
  {$ENDIF}
  {$IF ANDROID}
  if Process.Run("getprop", new List<String>("ro.build.version.sdk"), out var lStdOut, out var lStdErr) = 0 then begin
    if Int32.TryParse(lStdOut.Trim, out var lVersion) then begin
      __ElementsPlatformVersion[1] := lVersion;
      __ElementsPlatformVersion[2] := 0;
      __ElementsPlatformVersion[3] := 0;
    end;
  end;
  {$ENDIF}

end;

method __ElementsPlatformVersionAtLeast(aMaj, aMin: Integer; aRev: Integer := 0): Boolean;
begin
  __ElementsLoadPlatformVersion;
  if (aMaj > __ElementsPlatformVersion[1]) then exit false;
  if (aMaj = __ElementsPlatformVersion[1]) then begin
    if (aMin > __ElementsPlatformVersion[2]) then exit false;
    if (aMin = __ElementsPlatformVersion[2]) then begin
      if (aRev > __ElementsPlatformVersion[3]) then exit false;
    end;
  end;
  exit true;
end;

{$IFDEF TARGET_OS_UIKITFORMAC}
method __ElementsUIKitForMacVersionAtLeast(aMaj, aMin: Integer; aRev: Integer := 0): Boolean;
begin
  __ElementsLoadPlatformVersion;
  if (aMaj > __ElementsUIKitForMacVersion[1]) then exit false;
  if (aMaj = __ElementsUIKitForMacVersion[1]) then begin
    if (aMin > __ElementsUIKitForMacVersion[2]) then exit false;
    if (aMin = __ElementsUIKitForMacVersion[2]) then begin
      if (aRev > __ElementsUIKitForMacVersion[3]) then exit false;
    end;
  end;
  exit true;
end;
{$ENDIF}

end.