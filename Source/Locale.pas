namespace RemObjects.Elements.System;

interface

{$IF DARWIN}
uses
  CoreFoundation;

[assembly:DllImport(COREFOUNDATION_FRAMEWORK, EntryPoint := '_kCFLocaleCurrencySymbol')]
[assembly:DllImport(COREFOUNDATION_FRAMEWORK, EntryPoint := '_kCFLocaleDecimalSeparator')]
[assembly:DllImport(COREFOUNDATION_FRAMEWORK, EntryPoint := '_kCFDateFormatterPMSymbol')]
[assembly:DllImport(COREFOUNDATION_FRAMEWORK, EntryPoint := '_kCFDateFormatterAMSymbol')]
[assembly:DllImport(COREFOUNDATION_FRAMEWORK, EntryPoint := '_kCFLocaleGroupingSeparator')]
{$ENDIF}

{$IFDEF ANDROID}
  {$DEFINE ICU_LOCALE}
{$ENDIF}

type
  NumberFormatInfo = public class
  private
    fCurrency: String;
    fThousandsSeparator: Char;
    fDecimalSeparator: Char;
    fIsReadOnly: Boolean;
    method SetCurrency(value: String);
    method SetThousandsSeparator(value: Char);
    method SetDecimalSeparator(value: Char);
    method CheckReadOnly;
  public
    property DecimalSeparator: Char read fDecimalSeparator write SetDecimalSeparator;
    property ThousandsSeparator: Char read fThousandsSeparator write SetThousandsSeparator;
    property Currency: String read fCurrency write SetCurrency;
    property IsReadOnly: Boolean read fIsReadOnly;
    constructor(aDecimalSeparator: Char; aThousandsSeparator: Char; aCurrency: String; aIsReadOnly: Boolean := false);
  end;

  DateTimeFormatInfo = public class
  private
    fShortDayNames := new String[7];
    fLongDayNames := new String[7];
    fShortMonthNames := new String[12];
    fLongMonthNames := new String[12];
    fDateSeparator: String;
    fTimeSeparator: String;
    fAMString: String;
    fPMString: String;
    fShortDatePattern: String;
    fLongDatePattern: String;
    fShortTimePattern: String;
    fLongTimePattern: String;
    fIsReadOnly: Boolean;
    method SetShortDayNames(aValue: array of String);
    method SetLongDayNames(aValue: array of String);
    method SetShortMonthNames(aValue: array of String);
    method SetLongMonthNames(aValue: array of String);
    method SetDateSeparator(aValue: String);
    method SetTimeSeparator(aValue: String);
    method SetAMString(aValue: String);
    method SetPMString(aValue: String);
    method SetShortTimePattern(aValue: String);
    method SetLongTimePattern(aValue: String);
    method SetShortDatePattern(aValue: String);
    method SetLongDatePattern(aValue: String);
    method CheckReadOnly;
    {$IF WINDOWS}
    method GetStringFromLocale(aLocaleID: PlatformLocale; aLocaleItem: rtl.LCTYPE): String;
    {$ELSEIF LINUX AND NOT ANDROID}
    method GetStringFromLocale(aLocaleID: PlatformLocale; aLocaleItem: Integer): String;
    {$ELSEIF ICU_LOCALE}
    method GetDateTimePattern(aTimeStyle: UDateFormatStyle; aDateStyle: UDateFormatStyle; aLocaleID: PlatformLocale): String;
    {$ENDIF}
    {$IF LINUX OR ICU_LOCALE}
    method AdjustPattern(aPattern: String): String;
    {$ENDIF}
    {$IF LINUX OR ICU_LOCALE OR DARWIN}
    method GetDateSeparator(aShortDatePattern: String): String;
    method GetTimeSeparator(aShortTimePattern: String): String;
    {$ENDIF}
  public
    constructor(aLocale: PlatformLocale; aIsReadonly: Boolean := false);
    property ShortDayNames: array of String read fShortDayNames write SetShortDayNames;
    property LongDayNames: array of String read fLongDayNames write SetLongDayNames;
    property ShortMonthNames: array of String read fShortMonthNames write SetShortMonthNames;
    property LongMonthNames: array of String read fLongMonthNames write SetLongMonthNames;
    property DateSeparator: String read fDateSeparator write SetDateSeparator;
    property TimeSeparator: String read fTimeSeparator write SetTimeSeparator;
    property AMString: String read fAMString write SetAMString;
    property PMString: String read fPMString write SetPMString;
    property ShortTimePattern: String read fShortTimePattern write SetShortTimePattern;
    property LongTimePattern: String read fLongTimePattern write SetLongTimePattern;
    property ShortDatePattern: String read fShortDatePattern write SetShortDatePattern;
    property LongDatePattern: String read fLongDatePattern write SetLongDatePattern;
    property IsReadOnly: Boolean read fIsReadOnly;
  end;

  PlatformLocale = {$IF WINDOWS}rtl.LCID{$ELSEIF (LINUX OR FUCHSIA) AND NOT ANDROID}rtl.locale_t{$ELSEIF DARWIN}CoreFoundation.CFLocaleRef{$ELSEIF ICU_LOCALE OR WEBASSEMBLY}String{$ENDIF};

  Locale = public class
  private
    fNumberFormat: NumberFormatInfo;
    fDateTimeFormat: DateTimeFormatInfo;
    fLocaleID: PlatformLocale;
    class method GetInvariant: not nullable Locale;
    class method GetCurrent: not nullable Locale;
    method GetIdentifier: not nullable String;
    class var fCurrent: Locale;
    class var fInvariant: Locale;
  public
    constructor(aLocaleID: PlatformLocale; aIsReadOnly: Boolean := false);
    constructor(aLocale: String);
    class property Invariant: Locale read GetInvariant;
    class property Current: Locale read GetCurrent;
    property Identifier: not nullable String read GetIdentifier;
    property NumberFormat: NumberFormatInfo read fNumberFormat;
    property DateTimeFormat: DateTimeFormatInfo read fDateTimeFormat;
    property PlatformLocale: PlatformLocale read fLocaleID;
  end;

  {$IF WEBASSEMBLY}
  LocaleInfo = enum(DecimalSeparator = 0, ThousandsSepatator, Currency);
  {$ENDIF}

implementation

method DateTimeFormatInfo.SetShortDayNames(aValue: array of String);
begin
  CheckReadOnly;
  fShortDayNames := aValue;
end;

method DateTimeFormatInfo.SetLongDayNames(aValue: array of String);
begin
  CheckReadOnly;
  fLongDayNames := aValue;
end;

method DateTimeFormatInfo.SetShortMonthNames(aValue: array of String);
begin
  CheckReadOnly;
  fShortMonthNames := aValue;
end;

method DateTimeFormatInfo.SetLongMonthNames(aValue: array of String);
begin
  CheckReadOnly;
  fLongMonthNames := aValue;
end;

method DateTimeFormatInfo.SetDateSeparator(aValue: String);
begin
  CheckReadOnly;
  fDateSeparator := aValue;
end;

method DateTimeFormatInfo.SetTimeSeparator(aValue: String);
begin
  CheckReadOnly;
  fTimeSeparator := aValue;
end;

method DateTimeFormatInfo.SetAMString(aValue: String);
begin
  CheckReadOnly;
  fAMString := aValue;
end;

method DateTimeFormatInfo.SetPMString(aValue: String);
begin
  CheckReadOnly;
  fPMString := aValue;
end;

method DateTimeFormatInfo.SetShortTimePattern(aValue: String);
begin
  CheckReadOnly;
  fShortTimePattern := aValue;
end;

method DateTimeFormatInfo.SetLongTimePattern(aValue: String);
begin
  CheckReadOnly;
  fLongTimePattern := aValue;
end;

method DateTimeFormatInfo.SetShortDatePattern(aValue: String);
begin
  CheckReadOnly;
  fShortDatePattern := aValue;
end;

method DateTimeFormatInfo.SetLongDatePattern(aValue: String);
begin
  CheckReadOnly;
  fLongDatePattern := aValue;
end;

method DateTimeFormatInfo.CheckReadOnly;
begin
  if IsReadOnly then
    raise new Exception('Can not modify this DateTimeFormatInfo instance');
end;

constructor Locale(aLocaleID: PlatformLocale; aIsReadOnly: Boolean := false);
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
  lTemp := String.FromPChar(@lBuffer[0], lTotal).Substring(0, 1);
  if lTemp.Length > 0 then
  lThousandsSep := lTemp[0];
  {$ELSEIF LINUX AND NOT ANDROID}
  var lTemp := rtl.nl_langinfo_l({$IF FUCHSIA}rtl.THOUSEP{$ELSE}rtl.THOUSANDS_SEP{$ENDIF}, fLocaleID);
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
      lCurrency := lTempString.Substring(1);
  end;
  {$ELSEIF DARWIN}
  var lData := CFLocaleGetValue(aLocaleID, kCFLocaleDecimalSeparator);
  var lString: String := bridge<Foundation.NSString>(CFStringRef(lData));
  if lString.Length > 0 then
    lDecimalSep := lString[0];

  lData := CFLocaleGetValue(aLocaleID, kCFLocaleGroupingSeparator);
  lString := bridge<Foundation.NSString>(CFStringRef(lData));
  if lString.Length > 0 then
    lThousandsSep := lString[0];

  lData := CFLocaleGetValue(aLocaleID, kCFLocaleCurrencySymbol);
  lCurrency := bridge<Foundation.NSString>(CFStringRef(lData));
  {$ELSEIF ICU_LOCALE}
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
  var lHandle := WebAssemblyCalls.GetLocaleInfo(@aLocaleID.fFirstChar, aLocaleID.Length, Int32(LocaleInfo.DecimalSeparator));
  var lString := WebAssembly.GetStringFromHandle(lHandle, true);
  if lString.Length > 0 then
    lDecimalSep := lString[0];
  lHandle := WebAssemblyCalls.GetLocaleInfo(@aLocaleID.fFirstChar, aLocaleID.Length, Int32(LocaleInfo.ThousandsSepatator));
  lString := WebAssembly.GetStringFromHandle(lHandle, true);
  if lString.Length > 0 then
    lThousandsSep := lString[0];
  lHandle := WebAssemblyCalls.GetLocaleInfo(@aLocaleID.fFirstChar, aLocaleID.Length, Int32(LocaleInfo.Currency));
  lCurrency := WebAssembly.GetStringFromHandle(lHandle, true);
  {$ENDIF}
  fNumberFormat := new NumberFormatInfo(lDecimalSep, lThousandsSep, lCurrency, aIsReadOnly);
  fDateTimeFormat := new DateTimeFormatInfo(aLocaleID, aIsReadOnly);
end;

constructor Locale(aLocale: String);
begin
  {$IF WINDOWS}
  constructor(rtl.LocaleNameToLCID(aLocale.ToLPCWSTR, 0), false);
  {$ELSEIF LINUX AND NOT ANDROID}
  aLocale := aLocale.Replace('-', '_');
  var lName := aLocale.ToAnsiChars(true);
  var lLocale := rtl.newlocale(rtl.LC_ALL_MASK, @lName[0], nil);
  constructor(lLocale, false);
  {$ELSEIF DARWIN}
  var lLocale := CFLocaleCreate(nil, CFLocaleCreateCanonicalLanguageIdentifierFromString(nil, aLocale));
  constructor(lLocale, false);
  {$ELSEIF ICU_LOCALE OR WEBASSEMBLY}
  constructor(aLocale, false);
  {$ENDIF}
end;

method Locale.GetIdentifier: not nullable String;
begin
  {$IF WINDOWS}
  var lName := new Char[rtl.LOCALE_NAME_MAX_LENGTH];
  var lLength := rtl.LCIDToLocaleName(fLocaleID, @lName[0], rtl.LOCALE_NAME_MAX_LENGTH, 0);
  if lLength = 0 then
    raise new Exception("Error getting locale name");
  result := String.FromPChar(@lName[0], lLength) as not nullable;
  {$ELSEIF FUCHSIA}
  {$WARNING Not Implememnted for Fuchsia yet}
  raise new NotImplementedException;
  {$ELSEIF LINUX AND NOT ANDROID}
  var lName := rtl.nl_langinfo_l(rtl._NL_IDENTIFICATION_LANGUAGE, fLocaleID);
  if lName = nil then
    raise new Exception("Error getting locale name");
  result := String.FromPAnsiChars(lName) as not nullable;
  {$ELSEIF DARWIN}
  var lString := bridge<Foundation.NSString>(CFLocaleGetIdentifier(fLocaleID));
  result := lString as not nullable;
  {$ELSEIF ICU_LOCALE}
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
    fInvariant := new Locale(rtl.LOCALE_INVARIANT, true);
    {$ELSEIF LINUX AND NOT ANDROID}
    var lInvariant := 'en_US.utf8'.ToAnsiChars(true);
    var lHandle := rtl.newLocale(rtl.LC_ALL_MASK, @lInvariant[0], nil);
    if Integer(lHandle) = 0 then begin
      lInvariant := 'POSIX'.ToAnsiChars(true);
      lHandle := rtl.newLocale(rtl.LC_ALL_MASK, @lInvariant[0], nil);
    end;
    fInvariant := new Locale(lHandle, true);
    {$ELSEIF DARWIN}
    fInvariant := new Locale(CFLocaleGetSystem());
    {$ELSEIF ICU_LOCALE OR WEBASSEMBLY}
    fInvariant := new Locale('en-US', true);
    {$ENDIF}
  end;
  result := fInvariant as not nullable;
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
    fCurrent := new Locale(lLocale, true);
    {$ELSEIF DARWIN}
    fCurrent := new Locale(CFLocaleCopyCurrent());
    {$ELSEIF ICU_LOCALE}
    var lName: ^Char := ICUHelper.ULocGetDefault();
    var lDefaultName := String.FromPChar(lName);
    if lDefaultName = '' then begin
      lDefaultName := Environment.GetEnvironmentVariable('LANG');
      if lDefaultName = '' then
        lDefaultName := 'en_US'
      else
      lDefaultName := lDefaultName.Replace('.UTF-8', '');
    end;
    fCurrent := new Locale(lDefaultName, true);
    {$ELSEIF WEBASSEMBLY}
    var lHandle := WebAssemblyCalls.GetCurrentLocale;
    fCurrent := new Locale(WebAssembly.GetStringFromHandle(lHandle, true), true);
    {$ENDIF}
  end;
  result := fCurrent as not nullable;
end;

constructor NumberFormatInfo(aDecimalSeparator: Char; aThousandsSeparator: Char; aCurrency: String; aIsReadOnly: Boolean := false);
begin
  DecimalSeparator := aDecimalSeparator;
  ThousandsSeparator := aThousandsSeparator;
  Currency := aCurrency;
  fIsReadOnly := aIsReadOnly;
end;

constructor DateTimeFormatInfo(aLocale: PlatformLocale; aIsReadonly: Boolean := false);
begin
  fIsReadOnly := aIsReadonly;
  {$IF WINDOWS}
  for i: Integer := 0 to 6 do begin
    fShortDayNames[i] := GetStringFromLocale(aLocale, rtl.LOCALE_SABBREVDAYNAME1 + i);
    fLongDayNames[i] := GetStringFromLocale(aLocale, rtl.LOCALE_SDAYNAME1 + i);
  end;

  for i: Integer := 0 to 11 do begin
    fShortMonthNames[i] := GetStringFromLocale(aLocale, rtl.LOCALE_SABBREVMONTHNAME1 + i);
    fLongMonthNames[i] := GetStringFromLocale(aLocale, rtl.LOCALE_SMONTHNAME1 + i);
  end;

  fDateSeparator := GetStringFromLocale(aLocale, rtl.LOCALE_SDATE);
  fTimeSeparator := GetStringFromLocale(aLocale, rtl.LOCALE_STIME);
  fAMString := GetStringFromLocale(aLocale, rtl.LOCALE_S1159);
  fPMString := GetStringFromLocale(aLocale, rtl.LOCALE_S2359);
  fShortDatePattern := GetStringFromLocale(aLocale, rtl.LOCALE_SSHORTDATE);
  fLongDatePattern := GetStringFromLocale(aLocale, rtl.LOCALE_SLONGDATE);
  fShortTimePattern := GetStringFromLocale(aLocale, rtl.LOCALE_SSHORTTIME);
  fLongTimePattern := GetStringFromLocale(aLocale, rtl.LOCALE_STIMEFORMAT);
  {$ELSEIF LINUX AND NOT ANDROID}
  for i: Integer := 0 to 6 do begin
    fShortDayNames[i] := GetStringFromLocale(aLocale, rtl.ABDAY_1 + i);
    fLongDayNames[i] := GetStringFromLocale(aLocale, rtl.DAY_1 + i);
  end;

  for i: Integer := 0 to 11 do begin
    fShortMonthNames[i] := GetStringFromLocale(aLocale, rtl.ABMON_1 + i);
    fLongMonthNames[i] := GetStringFromLocale(aLocale, rtl.MON_1 + i);
  end;

  fAMString := GetStringFromLocale(aLocale, rtl.AM_STR);
  fPMString := GetStringFromLocale(aLocale, rtl.PM_STR);
  fShortDatePattern := AdjustPattern(GetStringFromLocale(aLocale, rtl.D_FMT));
  fLongDatePattern := AdjustPattern(GetStringFromLocale(aLocale, rtl.D_T_FMT));
  fShortTimePattern := AdjustPattern(GetStringFromLocale(aLocale, rtl.T_FMT));
  fLongTimePattern := AdjustPattern(GetStringFromLocale(aLocale, rtl.T_FMT_AMPM));
  fDateSeparator := GetDateSeparator(fShortDatePattern);
  fTimeSeparator := GetTimeSeparator(fShortTimePattern);
  {$ELSEIF DARWIN}
  var lFormatter := CFDateFormatterCreate(nil, aLocale, CFDateFormatterStyle.NoStyle, CFDateFormatterStyle.LongStyle);
  var lData := CFDateFormatterCopyProperty(lFormatter, kCFDateFormatterAMSymbol);
  fAMString := bridge<Foundation.NSString>(CFStringRef(lData));

  lData := CFDateFormatterCopyProperty(lFormatter, kCFDateFormatterPMSymbol);
  fPMString := bridge<Foundation.NSString>(CFStringRef(lData));
  fLongTimePattern := bridge<Foundation.NSString>(CFDateFormatterGetFormat(lFormatter));

  lFormatter := CFDateFormatterCreate(nil, aLocale, CFDateFormatterStyle.NoStyle, CFDateFormatterStyle.ShortStyle);
  fShortTimePattern := bridge<Foundation.NSString>(CFDateFormatterGetFormat(lFormatter));

  lFormatter := CFDateFormatterCreate(nil, aLocale, CFDateFormatterStyle.MediumStyle, CFDateFormatterStyle.NoStyle);
  fLongDatePattern := bridge<Foundation.NSString>(CFDateFormatterGetFormat(lFormatter));

  lFormatter := CFDateFormatterCreate(nil, aLocale, CFDateFormatterStyle.ShortStyle, CFDateFormatterStyle.NoStyle);
  fShortDatePattern := bridge<Foundation.NSString>(CFDateFormatterGetFormat(lFormatter));

  lFormatter := CFDateFormatterCreate(nil, aLocale, CFDateFormatterStyle.LongStyle, CFDateFormatterStyle.FullStyle);
  lData := CFDateFormatterCopyProperty(lFormatter, kCFDateFormatterWeekdaySymbols);
  var lData2 := CFDateFormatterCopyProperty(lFormatter, kCFDateFormatterShortWeekdaySymbols);
  var lArray: NSArray := bridge<Foundation.NSArray>(CFArrayRef(lData));
  var lArray2: NSArray := bridge<Foundation.NSArray>(CFArrayRef(lData2));
  for i: Integer := 0 to 6 do begin
    fShortDayNames[i] := lArray2[i] as NSString;
    fLongDayNames[i] := lArray[i] as NSString;
  end;

  lData := CFDateFormatterCopyProperty(lFormatter, kCFDateFormatterMonthSymbols);
  lData2 := CFDateFormatterCopyProperty(lFormatter, kCFDateFormatterShortMonthSymbols);
  lArray := bridge<Foundation.NSArray>(CFArrayRef(lData));
  lArray2 := bridge<Foundation.NSArray>(CFArrayRef(lData2));
  for i: Integer := 0 to 11 do begin
    fShortMonthNames[i] := lArray2[i] as NSString;
    fLongMonthNames[i] := lArray[i] as NSString;
  end;

  //fDateSeparator := GetDateSeparator(fShortDatePattern);
  //fTimeSeparator := GetTimeSeparator(fShortTimePattern);
  fDateSeparator := '/';
  fTimeSeparator := ':';
  {$ELSEIF ICU_LOCALE}
  var lErr: UErrorCode;
  var lData := ICUHelper.UDatOpen(UDateFormatStyle.UDAT_FULL, UDateFormatStyle.UDAT_FULL, aLocale, nil, 0, nil, 0, @lErr);
  var lBuffer := new Char[50];
  var lTotal := 0;

  for i: Integer := 1 to 7 do begin
    lTotal := ICUHelper.UDatGetSymbols(lData, UDateFormatSymbolType.UDAT_SHORT_WEEKDAYS, i, @lBuffer[0], lBuffer.Length, @lErr);
    fShortDayNames[i] := String.FromPChar(@lBuffer[0], lTotal)[0];

    lTotal := ICUHelper.UDatGetSymbols(lData, UDateFormatSymbolType.UDAT_WEEKDAYS, i, @lBuffer[0], lBuffer.Length, @lErr);
    fLongDayNames[i] := String.FromPChar(@lBuffer[0], lTotal)[0];
  end;

  for i: Integer := 0 to 11 do begin
    lTotal := ICUHelper.UDatGetSymbols(lData, UDateFormatSymbolType.UDAT_SHORT_MONTHS, i, @lBuffer[0], lBuffer.Length, @lErr);
    fShortMonthNames[i] := String.FromPChar(@lBuffer[0], lTotal)[0];

    lTotal := ICUHelper.UDatGetSymbols(lData, UDateFormatSymbolType.UDAT_MONTHS, i, @lBuffer[0], lBuffer.Length, @lErr);
    fLongMonthNames[i] := String.FromPChar(@lBuffer[0], lTotal)[0];
  end;

  lTotal := ICUHelper.UDatGetSymbols(lData, UDateFormatSymbolType.UDAT_AM_PMS, 0, @lBuffer[0], lBuffer.Length, @lErr);
  fAMString := String.FromPChar(@lBuffer[0], lTotal)[0];
  lTotal := ICUHelper.UDatGetSymbols(lData, UDateFormatSymbolType.UDAT_AM_PMS, 1, @lBuffer[0], lBuffer.Length, @lErr);
  fPMString := String.FromPChar(@lBuffer[0], lTotal)[0];

  fShortDatePattern := AdjustPattern(GetDateTimePattern(UDateFormatStyle.UDAT_NONE, UDateFormatStyle.UDAT_SHORT, aLocale));
  fLongDatePattern := AdjustPattern(GetDateTimePattern(UDateFormatStyle.UDAT_NONE, UDateFormatStyle.UDAT_LONG, aLocale));
  fShortTimePattern := AdjustPattern(GetDateTimePattern(UDateFormatStyle.UDAT_SHORT, UDateFormatStyle.UDAT_NONE, aLocale));
  fLongTimePattern := AdjustPattern(GetDateTimePattern(UDateFormatStyle.UDAT_MEDIUM, UDateFormatStyle.UDAT_NONE, aLocale));
  fDateSeparator := GetDateSeparator(fShortDatePattern);
  fTimeSeparator := GetTimeSeparator(fShortTimePattern);
  ICUHelper.UDatClose(lData);
  {$ENDIF}
end;

{$IF WINDOWS}
method DateTimeFormatInfo.GetStringFromLocale(aLocaleID: PlatformLocale; aLocaleItem: rtl.LCTYPE): String;
begin
  var lBuffer := new Char[50];
  var lTotal := rtl.GetLocaleInfo(aLocaleID, aLocaleItem, @lBuffer[0], lBuffer.Length);
  result := String.FromPChar(@lBuffer[0], lTotal - 1);
end;
{$ELSEIF LINUX AND NOT ANDROID}
method DateTimeFormatInfo.GetStringFromLocale(aLocaleID: PlatformLocale; aLocaleItem: Integer): String;
begin
  var lTemp := rtl.nl_langinfo_l(aLocaleItem, aLocaleID);
  if lTemp <> nil then
    result := String.FromPAnsiChars(lTemp)
  else
    result := '';
end;
{$ELSEIF ICU_LOCALE}
method DateTimeFormatInfo.GetDateTimePattern(aTimeStyle: UDateFormatStyle; aDateStyle: UDateFormatStyle; aLocaleID: PlatformLocale): String;
begin
  var lErr: UErrorCode;
  var lGMT := 'GMT'.ToAnsiChars(true);
  var lBuffer := new Char[100];
  var lData := ICUHelper.UDatOpen(aTimeStyle, aDateStyle, aLocaleID, @lGMT[0], length('GMT'), nil, 0, @lErr);
  var lTotal := ICUHelper.UDatToPattern(lData, 0, @lBuffer[0], lBuffer.Length, @lErr);
  result := String.FromPChar(@lBuffer[0], lTotal)[0];
  ICUHelper.UNumClose(lData);
end;
{$ENDIF}

{$IF LINUX OR ICU_LOCALE OR DARWIN}
method DateTimeFormatInfo.GetDateSeparator(aShortDatePattern: String): String;
begin
  var lDayPos := aShortDatePattern.IndexOf('dd');
  var lMonthPos := aShortDatePattern.IndexOf('MM');
  var lYearLength := 4;
  var lSeparator: String := '/';
  if (lDayPos >= 0) and (lMonthPos >= 0) then begin
    var lBeginPos := Math.Min(lDayPos, lMonthPos);
    var lEndPos := Math.Max(lDayPos, lMonthPos);
    lSeparator := aShortDatePattern.Substring(lBeginPos + 'dd'.Length, lEndPos - (lBeginPos + 'dd'.Length));
  end;

  if (lSeparator.IndexOf('dd') < 0) and (lSeparator.IndexOf('MM') < 0) and (lSeparator <> '/') then
    exit lSeparator;

  // search for standard chars if all fails...
  var lPos := aShortDatePattern.IndexOfAny(['/', '.', '\', '-']);
  if lPos >= 0 then
    lSeparator := aShortDatePattern[lPos];

  result := lSeparator;
end;

method DateTimeFormatInfo.GetTimeSeparator(aShortTimePattern: String): String;
begin
  var lHourPos := aShortTimePattern.IndexOf('HH');
  if lHourPos = -1 then
    lHourPos := aShortTimePattern.IndexOf('hh');
  var lMinPos := aShortTimePattern.IndexOf('mm');
  var lSeparator: String := ':';
  if (lHourPos >= 0) and (lMinPos >= 0) then begin
    var lBeginPos := Math.Min(lHourPos, lMinPos);
    var lEndPos := Math.Max(lHourPos, lMinPos);
    lSeparator := aShortTimePattern.Substring(lBeginPos + 'hh'.Length, lEndPos - (lBeginPos + 'hh'.Length));
  end;

  if (lSeparator.IndexOf('hh') < 0) and (lSeparator.IndexOf('HH') < 0) and (lSeparator.IndexOf('mm') < 0) and (lSeparator <> ':') then
    exit lSeparator;

  // search for standard chars if all fails...
  var lPos := aShortTimePattern.IndexOfAny([':', '.']);
  if lPos >= 0 then
    lSeparator := aShortTimePattern[lPos];

  result := lSeparator;
end;
{$ENDIF}

{$IF LINUX OR ICU_LOCALE}
method DateTimeFormatInfo.AdjustPattern(aPattern: String): String;
begin
  {$IF LINUX}
  var lToFind:    array of String := ['%a',    '%A',  '%b',   '%B', '%d', '%e', '%H', '%I', '%k', '%I', '%m', '%M', '%p', '%P', '%S', '%C', '%y', '%Y',   '%z',  '%Z'];
  var lToReplace: array of String := ['ddd', 'dddd', 'MMM', 'MMMM', 'dd', 'dd', 'HH', 'hh', 'h',  'hh', 'MM', 'mm', 'tt', 'tt', 'ss', 'yy', 'yy', 'yyyy', 'zzz', 'zzz'];
  {$ELSEIF ICU_LOCALE}
  var lToFind:    array of String := ['GGG', 'GG', 'G', 'y',    'EEEE', 'EEE', 'EE',  'E',   'a',  'ZZZ', 'ZZ',  'Z',  'zz',  'z'];
  var lToReplace: array of String := ['g',   'g',  'g', 'yyyy', 'dddd', 'ddd', 'ddd', 'ddd', 'tt', 'zzz', 'zzz', 'zz', 'zzz', 'zzz'];
  {$ENDIF}
  result := aPattern;
  for i: Integer := low(lToFind) to high(lToFind) do
    result := result.Replace(lToFind[i], lToReplace[i]);
end;
{$ENDIF}

method NumberFormatInfo.SetDecimalSeparator(value: Char);
begin
  CheckReadOnly;
  fDecimalSeparator := value;
end;

method NumberFormatInfo.SetThousandsSeparator(value: Char);
begin
  CheckReadOnly;
  fThousandsSeparator := value;
end;

method NumberFormatInfo.SetCurrency(value: String);
begin
  CheckReadOnly;
  fCurrency := value;
end;

method NumberFormatInfo.CheckReadOnly;
begin
  if IsReadOnly then
    raise new Exception('Can not modify this NumberFormatInfo instance');
end;

end.