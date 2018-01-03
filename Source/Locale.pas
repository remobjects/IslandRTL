namespace RemObjects.Elements.System;

interface

type
  NumberFormatInfo = public class
  public
    property DecimalSeparator: Char;
    property ThousandsSeparator: Char;
    property Currency: String;
    constructor(aDecimalSeparator: Char; aThousandsSeparator: Char; aCurrency: String);
  end;

  PlatformLocale = {$IF WINDOWS}rtl.LCID{$ELSEIF LINUX}rtl.locale_t{$ENDIF};

  Locale = public class
  private
    fNumberFormat: NumberFormatInfo;
    fLocaleID: PlatformLocale;
    class method GetInvariant: not nullable Locale;
    class method GetCurrent: not nullable Locale;
    method GetIdentifier: not nullable String;
  protected
    constructor(aLocaleID: PlatformLocale);
  public
    class property Invariant: Locale read GetInvariant;
    class property Current: Locale read GetCurrent;
    property Identifier: not nullable String read GetIdentifier;
    property NumberFormat: NumberFormatInfo read fNumberFormat;
  end;

implementation

constructor Locale(aLocaleID: PlatformLocale);
begin
  fLocaleID := aLocaleID;
  var lCurrency: String := '';
  var lThousandsSep: Char := #0;
  var lDecimalSep: Char := #0;
  {$IF WINDOWS}
  var lBuffer := new Char[50];
  var lTotal := rtl.GetLocaleInfo(fLocaleID, rtl.LOCALE_SCURRENCY, @lBuffer[0], lBuffer.Length);
  lCurrency := String.FromPChar(@lBuffer[0], lTotal - 1);
  lTotal := rtl.GetLocaleInfo(fLocaleID, rtl.LOCALE_SDECIMAL, @lBuffer[0], lBuffer.Length);
  var lTemp := String.FromPChar(@lBuffer[0], lTotal - 1);
  if lTemp.Length > 0 then
     lDecimalSep := lTemp[0];
  lTotal := rtl.GetLocaleInfo(fLocaleID, rtl.LOCALE_STHOUSAND, @lBuffer[0], lBuffer.Length);
  lTemp := String.FromPChar(@lBuffer[0], lTotal).SubString(0, 1);
  if lTemp.Length > 0 then
  lThousandsSep := lTemp[0];  
  {$ELSEIF LINUX AND NOT ANDROID}
  var lTemp := rtl.nl_langinfo_l(rtl.THOUSANDS_SEP, fLocaleID);
  if lTemp <> nil then begin
    var lTempString := String.FromPAnsiChars(lTemp);
    if lTempString.Length > 0 then
      lThousandsSep := lTempString[0];
  end;
  lTemp := rtl.nl_langinfo_l(rtl.RADIXCHAR, fLocaleID);
  if lTemp <> nil then begin
    var lTempString := String.FromPAnsiChars(lTemp);
    if lTempString.Length > 0 then
      lDecimalSep := lTempString[0];
  end;
  lTemp := rtl.nl_langinfo_l(rtl.CRNCYSTR, fLocaleID);
  if lTemp <> nil then begin
    var lTempString := String.FromPAnsiChars(lTemp) as not nullable;
    if lTempString.Length > 1 then
      lCurrency := lTempString.SubString(1);
  end;
  {$ENDIF}
  fNumberFormat := new NumberFormatInfo(lDecimalSep, lThousandsSep, lCurrency);
end;

method Locale.GetIdentifier: not nullable String;
begin
  {$IF WINDOWS}
  var lName := new Char[rtl.LOCALE_NAME_MAX_LENGTH];
  var lLength := rtl.LCIDToLocaleName(fLocaleID, @lName[0], rtl.LOCALE_NAME_MAX_LENGTH, 0);
  if lLength = 0 then 
    raise new Exception("Error getting locale name");
  result := String.FromPChar(@lName[0], lLength) as not nullable;
  {$ELSEIF LINUX AND NOT ANDROID}
  var lName := rtl.nl_langinfo_l(rtl._NL_IDENTIFICATION_LANGUAGE, fLocaleID);
  if lName = nil then
    raise new Exception("Error getting locale name");
  result := String.FromPAnsiChars(lName) as not nullable;
  {$ENDIF}
end;

class method Locale.GetInvariant: not nullable Locale;
begin
  {$IF WINDOWS}
  result := new Locale(rtl.LOCALE_INVARIANT);
  {$ELSEIF LINUX AND NOT ANDROID}
  var lInvariant := 'en_US.utf8'.ToAnsiChars(true);
  result := new Locale(rtl.newLocale(rtl.LC_ALL_MASK, @lInvariant[0], nil));
  {$ENDIF}
end;

class method Locale.GetCurrent: not nullable Locale;
begin
  {$IF WINDOWS}
  result := new Locale(rtl.GetThreadLocale);
  {$ELSEIF LINUX AND NOT ANDROID}
  var lDefaultName := Environment.GetEnvironmentVariable('LANG');
  if lDefaultName = '' then
    raise new Exception('Can not get default locale');
  lDefaultName := lDefaultName.Replace('.UTF-8', '.utf8');
  var lName := lDefaultName.ToAnsiChars(true);
  var lLocale := rtl.newlocale(rtl.LC_ALL_MASK, @lName[0], nil);
  result := new Locale(lLocale);
  {$ENDIF}
end;

constructor NumberFormatInfo(aDecimalSeparator: Char; aThousandsSeparator: Char; aCurrency: String);
begin
  DecimalSeparator := aDecimalSeparator;
  ThousandsSeparator := aThousandsSeparator;
  Currency := aCurrency;
end;

end.