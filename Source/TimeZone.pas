namespace RemObjects.Elements.System;

interface

{$IF DARWIN}
uses
  CoreFoundation;
{$ENDIF}

type
  TimeZone = public class
  private
    fID: String;
    fOffsetToUTC: Int64;
    class method EnumTimeZones: not nullable sequence of String;
    class method get_LocalTimeZone: not nullable TimeZone;
    class method get_UtcTimeZone: not nullable TimeZone;
    class method get_TimeZoneWithName(aName: String): nullable TimeZone;
    class method get_TimeZoneNames: not nullable sequence of String;
    {$IFDEF LINUX OR ANDROID}
    class method GetZoneNames(aZonesDir: String; aList: List<String>; aZone: String);
    const DefaultZonesDir = '/usr/share/zoneinfo';
    const DefaultVarName = 'TZ';
    {$ENDIF}
  protected
    constructor(aID: String; aOffsetToUTC: Integer);
  public
    class property Local: not nullable TimeZone read get_LocalTimeZone;
    class property Utc: not nullable TimeZone read get_UtcTimeZone;
    class property TimeZoneByName[aName: String]: nullable TimeZone read get_TimeZoneWithName;
    class property TimeZoneNames: not nullable sequence of String read get_TimeZoneNames;

    property Identifier: String read fID;
    property OffsetToUTC: Int64 read fOffsetToUTC;
  end;

implementation

class method TimeZone.get_LocalTimeZone: not nullable TimeZone;
begin
  {$IFDEF WINDOWS}
  var lZoneInfo: rtl.DYNAMIC_TIME_ZONE_INFORMATION;
  var lDayLight := (rtl.GetDynamicTimeZoneInformation(@lZoneInfo) = rtl.TIME_ZONE_ID_DAYLIGHT);
  var lOffset := if lDayLight then (lZoneInfo.DaylightBias +  lZoneInfo.Bias) else lZoneInfo.Bias;
  var lID := String.FromPChar(lZoneInfo.StandardName);
  result := new TimeZone(lID, lOffset);
  {$ELSEIF LINUX OR ANDROID}
  var lTime: rtl.time_t := rtl.time(nil);
  var lTimeZone: ^rtl.__struct_tm;
  lTimeZone := rtl.localtime(@lTime);
  result := new TimeZone(String.FromPAnsiChars(lTimeZone^.tm_zone), lTimeZone^.tm_gmtoff div 60);
  {$ELSEIF DARWIN}
  var lTimeZone := CFTimeZoneCopyDefault;
  var lName := CFTimeZoneGetName(lTimeZone);
  var lString: String := bridge<Foundation.NSString>(CFStringRef(lName));
  var lInterval := CFTimeZoneGetSecondsFromGMT(lTimeZone, CFAbsoluteTimeGetCurrent);
  result := new TimeZone(lString, Integer(Math.Round(lInterval div 60)));
  CFRelease(lTimeZone);
  {$ELSEIF WEBASSEMBLY}
  var lDate := WebAssembly.ReflectConstruct('Date', []);
  var lOffset: Integer := lDate.getTimezoneOffset();
  var lDateFormat := WebAssembly.ReflectConstruct("Intl.DateTimeFormat", ['default']);
  var usedOptions: String := lDateFormat.resolvedOptions().timeZone;
  result := new TimeZone(usedOptions, lOffset);
  {$ELSE}
  result := new TimeZone('', 0);
  {$ENDIF}
end;

class method TimeZone.get_UtcTimeZone: not nullable TimeZone;
begin
  result := new TimeZone('UTC', 0);
end;

constructor TimeZone(aID: String; aOffsetToUTC: Integer);
begin
  fID := aID;
  fOffsetToUTC := aOffsetToUTC;
end;

class method TimeZone.get_TimeZoneNames: not nullable sequence of String;
begin
  result := EnumTimeZones;
end;

{$IFDEF WEBASSEMBLY}[Warning("Not Implemented for WebAssembly")]{$ENDIF}
class method TimeZone.EnumTimeZones: not nullable sequence of String;
begin
  {$IFDEF WINDOWS}
  var lKey := 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones'.ToCharArray(true);
  var lNewKey: rtl.HKEY;
  var lSubKeys: rtl.DWORD;
  var lMaxLength: rtl.DWORD;

  var lList: not nullable List<String> := new List<String>;
  if rtl.RegOpenKeyEx(rtl.HKEY_LOCAL_MACHINE, @lKey[0], 0, rtl.KEY_QUERY_VALUE or rtl.KEY_ENUMERATE_SUB_KEYS or rtl.KEY_READ, @lNewKey) <> rtl.ERROR_SUCCESS then
    raise new Exception('Can not open TimeZone registry key');

  if rtl.RegQueryInfoKey(lNewKey, nil, nil, nil, @lSubKeys, @lMaxLength, nil, nil, nil, nil, nil, nil) <> rtl.ERROR_SUCCESS then
    raise new Exception('Can not get information from TimeZone registry key');
  var lSubName := new Char[(lMaxLength + 1) * 2];
  var lWritten: rtl.DWORD;
  for i: Integer := 0 to lSubKeys - 1 do begin
    lWritten := lMaxLength + 1;
    rtl.RegEnumKeyEx(lNewKey, i, @lSubName[0], @lWritten, nil, nil, nil, nil);
    lList.Add(new String(@lSubName[0], lWritten));
  end;
  result := lList;
  {$ELSEIF LINUX OR ANDROID}
  var lList: not nullable List<String> := new List<String>();
  GetZoneNames(DefaultZonesDir, lList, '');
  result := lList;
  {$ELSEIF DARWIN}
  var lAllTimeZones := CFTimeZoneCopyKnownNames;
  var lArray: NSArray := bridge<Foundation.NSArray>(CFArrayRef(lAllTimeZones));
  var lList: not nullable List<String> := new List<String>();
  for lString: NSString in lArray do
    lList.Add(lString);
  CFRelease(lAllTimeZones);
  result := lList;
  {$ELSE}
  result := new String[1];
  {$ENDIF}
end;

{$IFDEF LINUX OR ANDROID}
class method TimeZone.GetZoneNames(aZonesDir: String; aList: List<String>; aZone: String);
begin
  var lBytes := aZonesDir.ToAnsiChars(true);
  var lDir: ^rtl.DIR := rtl.opendir(@lBytes[0]);
  if lDir = nil then
    raise new Exception('Can not get TimeZones: ' + aZonesDir);

  var lContent: ^rtl.__struct_dirent;
  var lName: String;
  lContent := rtl.readdir(lDir);
  while lContent <> nil do begin
    if lContent^.d_type = rtl.DT_DIR then begin
      lName := String.FromPAnsiChars(lContent^.d_name);
      if (lName <> '.') and (lName <> '..') and (lName <> 'posix') and
        (lName <> 'SystemV') and (lName <> 'right') then GetZoneNames(aZonesDir + '/' + lName, aList, lName);
    end
    else begin
      lName := String.FromPAnsiChars(lContent^.d_name);
      if lName.IndexOf('.') < 0 then begin
        if aZone <> '' then aList.Add(aZone + '/' + lName)
        else aList.Add(lName);
      end;
    end;
    lContent := rtl.readdir(lDir);
  end;
  rtl.closedir(lDir);
end;
{$ENDIF}

{$IFDEF WEBASSEMBLY}[Warning("Not Implemented for WebAssembly")]{$ENDIF}
class method TimeZone.get_TimeZoneWithName(aName: String): nullable TimeZone;
begin
  {$IFDEF WINDOWS}
  var lKey := ('SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\' + aName).ToCharArray(true);
  var lNewKey: rtl.HKEY;

  if rtl.RegOpenKeyEx(rtl.HKEY_LOCAL_MACHINE, @lKey[0], 0, rtl.KEY_READ, @lNewKey) <> rtl.ERROR_SUCCESS then
    raise new Exception('Can not open TimeZone registry key');

  var lType: rtl.DWORD;
  var lBuffer: rtl.TIME_ZONE_INFORMATION;
  var lBufSize: rtl.DWORD := sizeOf(lBuffer);
  var lKeyChars := 'TZI'.ToCharArray(true);
  if rtl.RegGetValue(lNewKey, nil, @lKeyChars[0], rtl.RRF_RT_ANY, @lType, @lBuffer, @lBufSize) <> rtl.ERROR_SUCCESS then
    raise new Exception('Can not retrieve timezone info for ' + aName);
  var lDayLight := lBuffer.DaylightDate.wMonth <> 0;
  var lOffset := if lDayLight then (lBuffer.DaylightBias +  lBuffer.Bias) else lBuffer.Bias;
  result := new TimeZone(aName, lOffset);
  {$ELSEIF LINUX OR ANDROID}
  var lNameBytes := DefaultVarName.ToAnsiChars(true);
  var lValueBytes := aName.ToAnsiChars(true);
  var lOldValue := rtl.getenv(@lNameBytes[0]);
  try
    rtl.setenv(@lNameBytes[0], @lValueBytes[0], 1);
    var lTime: rtl.time_t := rtl.time(nil);
    var lTimeZone: ^rtl.__struct_tm;
    lTimeZone := rtl.localtime(@lTime);
    result := new TimeZone(aName, lTimeZone^.tm_gmtoff div 60);
  finally
    if lOldValue = nil then begin
      var lBytesNoValue := ''.ToAnsiChars(true);
      rtl.setenv(@lNameBytes[0], @lBytesNoValue[0], 1)
    end
    else
      rtl.setenv(@lNameBytes[0], lOldValue, 1);
  end;
  {$ELSEIF DARWIN}
  var lNew := CFTimeZoneCreateWithName(nil, aName, true);
  if lNew ≠ nil then begin
    var lNewInterval := CFTimeZoneGetSecondsFromGMT(lNew, CFAbsoluteTimeGetCurrent);
    result := new TimeZone(aName, Integer(Math.Round(lNewInterval div 60)));
    CFRelease(lNew);
  end
  else
    result := new TimeZone(' ' , 0);
  {$ELSE}
  result := new TimeZone(' ' , 0);
  {$ENDIF}
end;

end.