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

  PlatformLocale = {$IF WINDOWS}rtl.LCID{$ELSEIF LINUX AND NOT ANDROID}rtl.locale_t{$ELSEIF ANDROID OR WEBASSEMBLY}String{$ENDIF};

  Locale = public class
  private
    fNumberFormat: NumberFormatInfo;
    fLocaleID: PlatformLocale;
    class method GetInvariant: not nullable Locale;
    class method GetCurrent: not nullable Locale;
    method GetIdentifier: not nullable String;
    class var fCurrent: Locale;
    class var fInvariant: Locale;
  protected
    constructor(aLocaleID: PlatformLocale);
  public
    class property Invariant: Locale read GetInvariant;
    class property Current: Locale read GetCurrent;
    property Identifier: not nullable String read GetIdentifier;
    property NumberFormat: NumberFormatInfo read fNumberFormat;
    property PlatformLocale: PlatformLocale read fLocaleID;
  end;

  {$IF WEBASSEMBLY}
  LocaleInfo = enum(DecimalSeparator = 0, ThousandsSepatator, Currency);
  {$ENDIF}

implementation

constructor Locale(aLocaleID: PlatformLocale);
begin
  fLocaleID := aLocaleID;
  var lCurrency: String := '';
  var lThousandsSep: Char := ',';
  var lDecimalSep: Char := '.';
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
  {$ELSEIF ANDROID}
  var lParseError: UParseError;
  var lStatus: UErrorCode;
  var lBuffer := new Char[30];
  var lTotal: Int32;
  var lFormatSettings := ICUHelper.UNumOpen(UNumberFormatStyle.UNUM_CURRENCY, nil, 0, @fLocaleID.ToAnsiChars(true)[0], @lParseError, @lStatus);  
  lTotal := ICUHelper.UNumGetSymbol(lFormatSettings, UNumberFormatSymbol.UNUM_DECIMAL_SEPARATOR_SYMBOL, @lBuffer[0], lBuffer.Length, @lStatus);
  lDecimalSep := String.FromPChar(@lBuffer[0], lTotal)[0];
  lTotal := ICUHelper.UNumGetSymbol(lFormatSettings, UNumberFormatSymbol.UNUM_GROUPING_SEPARATOR_SYMBOL, @lBuffer[0], lBuffer.Length, @lStatus);
  lThousandsSep := String.FromPChar(@lBuffer[0], lTotal)[0];
  lTotal := ICUHelper.UNumGetSymbol(lFormatSettings, UNumberFormatSymbol.UNUM_CURRENCY_SYMBOL, @lBuffer[0], lBuffer.Length, @lStatus);
  lCurrency := String.FromPChar(@lBuffer[0], lTotal);
  ICUHelper.UNumClose(lFormatSettings);
  {$ELSEIF WEBASSEMBLY}
  var lHandle := WebAssemblyCalls.GetLocaleInfo(aLocaleID, Int32(LocaleInfo.DecimalSeparator));
  var lString := WebAssembly.GetStringFromHandle(lHandle, true);
  if lString.Length > 0 then
    lDecimalSep := lString[0];
  lHandle := WebAssemblyCalls.GetLocaleInfo(aLocaleID, Int32(LocaleInfo.ThousandsSepatator));
  lString := WebAssembly.GetStringFromHandle(lHandle, true);
  if lString.Length > 0 then
    lThousandsSep := lString[0];
  lHandle := WebAssemblyCalls.GetLocaleInfo(aLocaleID, Int32(LocaleInfo.Currency));
  lCurrency := WebAssembly.GetStringFromHandle(lHandle, true);
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
  {$ELSEIF ANDROID}
  var lErr: UErrorCode;
  var lName := new Char[80];
  var lTotal := ICUHelper.ULocGetName(@fLocaleID.ToAnsiChars(true)[0], @lName[0], lName.Length, @lErr);
  result := String.FromPChar(@lName[0], lTotal) as not nullable;
  {$ELSEIF WEBASSEMBLY}
  result := fLocaleID as not nullable;
  {$ENDIF}
end;

class method Locale.GetInvariant: not nullable Locale;
begin
  if fInvariant = nil then begin
    {$IF WINDOWS}
    fInvariant := new Locale(rtl.LOCALE_INVARIANT);
    {$ELSEIF LINUX AND NOT ANDROID}
    var lInvariant := 'en_US.utf8'.ToAnsiChars(true);
    fInvariant := new Locale(rtl.newLocale(rtl.LC_ALL_MASK, @lInvariant[0], nil));
    {$ELSEIF ANDROID OR WEBASSEMBLY}
    fInvariant := new Locale('en_US');
    {$ENDIF}
  end;
  result := fInvariant;
end;

class method Locale.GetCurrent: not nullable Locale;
begin
  if fCurrent = nil then begin
    {$IF WINDOWS}
    fCurrent := new Locale(rtl.GetThreadLocale);
    {$ELSEIF LINUX AND NOT ANDROID}
    var lDefaultName := Environment.GetEnvironmentVariable('LANG');
    if lDefaultName = '' then
      raise new Exception('Can not get default locale');
    lDefaultName := lDefaultName.Replace('.UTF-8', '.utf8');
    var lName := lDefaultName.ToAnsiChars(true);
    var lLocale := rtl.newlocale(rtl.LC_ALL_MASK, @lName[0], nil);
    fCurrent := new Locale(lLocale);
    {$ELSEIF ANDROID}
    var lName: ^Char := ICUHelper.ULocGetDefault();
    var lDefaultName := String.FromPChar(lName);
    if lDefaultName = '' then begin
      lDefaultName := Environment.GetEnvironmentVariable('LANG');
      if lDefaultName = '' then
        lDefaultName := 'en_US'
      else
      lDefaultName := lDefaultName.Replace('.UTF-8', '');
    end;
    fCurrent := new Locale(lDefaultName);
    {$ELSEIF WEBASSEMBLY}
    fCurrent := new Locale(WebAssemblyCalls.GetCurrentLocale);
    {$ENDIF}
  end;
  result := fCurrent;
end;

constructor NumberFormatInfo(aDecimalSeparator: Char; aThousandsSeparator: Char; aCurrency: String);
begin
  DecimalSeparator := aDecimalSeparator;
  ThousandsSeparator := aThousandsSeparator;
  Currency := aCurrency;
end;

end.