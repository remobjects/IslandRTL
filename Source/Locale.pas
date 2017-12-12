namespace RemObjects.Elements.System;

interface

type
  NumberFormatInfo = public class
  public
    property DecimalSeparator: Char;
    property DecimalDigits: Integer;
    //constructor(aDecimalSeparator: Char; aDecimalDigits: Integer);
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
end;

method Locale.GetIdentifier: not nullable String;
begin
  {$IF WINDOWS}
  var lName := new Char[rtl.LOCALE_NAME_MAX_LENGTH];
  var lLength := rtl.LCIDToLocaleName(fLCID, @lName[0], rtl.LOCALE_NAME_MAX_LENGTH, 0);
  if lLength = 0 then 
    raise new Exception("Error getting locale name");
  result := String.FromPChar(@lName[0], lLength) as not nullable;
  {$ELSEIF LINUX}
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
  {$ELSEIF LINUX}
  var lInvariant := 'en.UTF8'.ToAnsiChars(true);
  result := new Locale(rtl.newLocale(rtl.LC_ALL_MASK, @lInvariant[0], nil));
  {$ENDIF}
end;

class method Locale.GetCurrent: not nullable Locale;
begin
  {$IF WINDOWS}
  result := new Locale(rtl.GetThreadLocale);
  {$ELSEIF LINUX}
  var lDefaultName := Environment.GetEnvironmentVariable('LANG');
  if lDefaultName = '' then
    raise new Exception('Can not get default locale');
  var lName := lDefaultName.ToAnsiChars(true);
  var lLocale := rtl.newlocale(rtl.LC_ALL_MASK, @lName[0], nil);
  result := new Locale(lLocale);
  {$ENDIF}
end;

end.