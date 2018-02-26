namespace RemObjects.Elements.System;

// ICU library is used by Android, Linux, MacOS and Windows 10 Creators Update+
{$IF ANDROID}
{$DEFINE USEICU}
{$ENDIF}

{$IF USEICU}

{$GLOBALS ON}

interface

const
  U_PARSE_CONTEXT_LEN = 16;

type
  // http://www.icu-project.org/apiref/icu4c/utypes_8h.html
  UErrorCode = public enum (
    U_USING_FALLBACK_WARNING = -128, U_ERROR_WARNING_START = -128, U_USING_DEFAULT_WARNING = -127, U_SAFECLONE_ALLOCATED_WARNING = -126, 
    U_STATE_OLD_WARNING = -125, U_STRING_NOT_TERMINATED_WARNING = -124, U_SORT_KEY_TOO_SHORT_WARNING = -123, U_AMBIGUOUS_ALIAS_WARNING = -122, 
    U_DIFFERENT_UCA_VERSION = -121, U_PLUGIN_CHANGED_LEVEL_WARNING = -120, U_ERROR_WARNING_LIMIT, U_ZERO_ERROR = 0, U_ILLEGAL_ARGUMENT_ERROR = 1,
    U_MISSING_RESOURCE_ERROR = 2, U_INVALID_FORMAT_ERROR = 3, U_FILE_ACCESS_ERROR = 4, U_INTERNAL_PROGRAM_ERROR = 5, U_MESSAGE_PARSE_ERROR = 6, 
    U_MEMORY_ALLOCATION_ERROR = 7, U_INDEX_OUTOFBOUNDS_ERROR = 8, U_PARSE_ERROR = 9, U_INVALID_CHAR_FOUND = 10, U_TRUNCATED_CHAR_FOUND = 11, 
    U_ILLEGAL_CHAR_FOUND = 12, U_INVALID_TABLE_FORMAT = 13, U_INVALID_TABLE_FILE = 14, U_BUFFER_OVERFLOW_ERROR = 15, U_UNSUPPORTED_ERROR = 16, 
    U_RESOURCE_TYPE_MISMATCH = 17, U_ILLEGAL_ESCAPE_SEQUENCE = 18, U_UNSUPPORTED_ESCAPE_SEQUENCE = 19, U_NO_SPACE_AVAILABLE = 20,
    U_CE_NOT_FOUND_ERROR = 21, U_PRIMARY_TOO_LONG_ERROR = 22, U_STATE_TOO_OLD_ERROR = 23, U_TOO_MANY_ALIASES_ERROR = 24, U_ENUM_OUT_OF_SYNC_ERROR = 25, 
    U_INVARIANT_CONVERSION_ERROR = 26, U_INVALID_STATE_ERROR = 27, U_COLLATOR_VERSION_MISMATCH = 28, U_USELESS_COLLATOR_ERROR = 29, 
    U_NO_WRITE_PERMISSION = 30, U_STANDARD_ERROR_LIMIT, U_BAD_VARIABLE_DEFINITION = $10000, U_PARSE_ERROR_START = $10000, U_MALFORMED_RULE, 
    U_MALFORMED_SET, U_MALFORMED_SYMBOL_REFERENCE, U_MALFORMED_UNICODE_ESCAPE, U_MALFORMED_VARIABLE_DEFINITION, U_MALFORMED_VARIABLE_REFERENCE, 
    U_MISMATCHED_SEGMENT_DELIMITERS, U_MISPLACED_ANCHOR_START, U_MISPLACED_CURSOR_OFFSET, U_MISPLACED_QUANTIFIER, U_MISSING_OPERATOR, 
    U_MISSING_SEGMENT_CLOSE, U_MULTIPLE_ANTE_CONTEXTS, U_MULTIPLE_CURSORS, U_MULTIPLE_POST_CONTEXTS, U_TRAILING_BACKSLASH, U_UNDEFINED_SEGMENT_REFERENCE, 
    U_UNDEFINED_VARIABLE, U_UNQUOTED_SPECIAL, U_UNTERMINATED_QUOTE, U_RULE_MASK_ERROR, U_MISPLACED_COMPOUND_FILTER, U_MULTIPLE_COMPOUND_FILTERS, 
    U_INVALID_RBT_SYNTAX, U_INVALID_PROPERTY_PATTERN, U_MALFORMED_PRAGMA, U_UNCLOSED_SEGMENT, U_ILLEGAL_CHAR_IN_SEGMENT, U_VARIABLE_RANGE_EXHAUSTED,
    U_VARIABLE_RANGE_OVERLAP, U_ILLEGAL_CHARACTER, U_INTERNAL_TRANSLITERATOR_ERROR, U_INVALID_ID, U_INVALID_FUNCTION, U_PARSE_ERROR_LIMIT, 
    U_UNEXPECTED_TOKEN = $10100, U_FMT_PARSE_ERROR_START = $10100, U_MULTIPLE_DECIMAL_SEPARATORS, U_MULTIPLE_DECIMAL_SEPERATORS = U_MULTIPLE_DECIMAL_SEPARATORS,
    U_MULTIPLE_EXPONENTIAL_SYMBOLS, U_MALFORMED_EXPONENTIAL_PATTERN, U_MULTIPLE_PERCENT_SYMBOLS, U_MULTIPLE_PERMILL_SYMBOLS, U_MULTIPLE_PAD_SPECIFIERS,
    U_PATTERN_SYNTAX_ERROR, U_ILLEGAL_PAD_POSITION, U_UNMATCHED_BRACES, U_UNSUPPORTED_PROPERTY, U_UNSUPPORTED_ATTRIBUTE, U_ARGUMENT_TYPE_MISMATCH, 
    U_DUPLICATE_KEYWORD, U_UNDEFINED_KEYWORD, U_DEFAULT_KEYWORD_MISSING, U_DECIMAL_NUMBER_SYNTAX_ERROR, U_FORMAT_INEXACT_ERROR, U_FMT_PARSE_ERROR_LIMIT, 
    U_BRK_INTERNAL_ERROR = $10200, U_BRK_ERROR_START = $10200, U_BRK_HEX_DIGITS_EXPECTED, U_BRK_SEMICOLON_EXPECTED, U_BRK_RULE_SYNTAX, U_BRK_UNCLOSED_SET,
    U_BRK_ASSIGN_ERROR, U_BRK_VARIABLE_REDFINITION, U_BRK_MISMATCHED_PAREN, U_BRK_NEW_LINE_IN_QUOTED_STRING, U_BRK_UNDEFINED_VARIABLE, U_BRK_INIT_ERROR, 
    U_BRK_RULE_EMPTY_SET, U_BRK_UNRECOGNIZED_OPTION, U_BRK_MALFORMED_RULE_TAG, U_BRK_ERROR_LIMIT, U_REGEX_INTERNAL_ERROR = $10300, U_REGEX_ERROR_START = $10300, 
    U_REGEX_RULE_SYNTAX, U_REGEX_INVALID_STATE, U_REGEX_BAD_ESCAPE_SEQUENCE, U_REGEX_PROPERTY_SYNTAX, U_REGEX_UNIMPLEMENTED, U_REGEX_MISMATCHED_PAREN, 
    U_REGEX_NUMBER_TOO_BIG, U_REGEX_BAD_INTERVAL, U_REGEX_MAX_LT_MIN, U_REGEX_INVALID_BACK_REF, U_REGEX_INVALID_FLAG, U_REGEX_LOOK_BEHIND_LIMIT,
    U_REGEX_SET_CONTAINS_STRING, U_REGEX_OCTAL_TOO_BIG, U_REGEX_MISSING_CLOSE_BRACKET, U_REGEX_INVALID_RANGE, U_REGEX_STACK_OVERFLOW, U_REGEX_TIME_OUT, 
    U_REGEX_STOPPED_BY_CALLER, U_REGEX_ERROR_LIMIT, U_IDNA_PROHIBITED_ERROR = $10400, U_IDNA_ERROR_START = $10400, U_IDNA_UNASSIGNED_ERROR, 
    U_IDNA_CHECK_BIDI_ERROR, U_IDNA_STD3_ASCII_RULES_ERROR, U_IDNA_ACE_PREFIX_ERROR, U_IDNA_VERIFICATION_ERROR, U_IDNA_LABEL_TOO_LONG_ERROR,
    U_IDNA_ZERO_LENGTH_LABEL_ERROR, U_IDNA_DOMAIN_NAME_TOO_LONG_ERROR, U_IDNA_ERROR_LIMIT, U_STRINGPREP_PROHIBITED_ERROR = U_IDNA_PROHIBITED_ERROR, 
    U_STRINGPREP_UNASSIGNED_ERROR = U_IDNA_UNASSIGNED_ERROR, U_STRINGPREP_CHECK_BIDI_ERROR = U_IDNA_CHECK_BIDI_ERROR, U_PLUGIN_ERROR_START = $10500, 
    U_PLUGIN_TOO_HIGH = $10500, U_PLUGIN_DIDNT_SET_LEVEL, U_PLUGIN_ERROR_LIMIT, U_ERROR_LIMIT = U_PLUGIN_ERROR_LIMIT
  );

  // http://icu-project.org/apiref/icu4c471/unum_8h.html
  UNumberFormatSymbol = public enum (
    UNUM_DECIMAL_SEPARATOR_SYMBOL = 0, UNUM_GROUPING_SEPARATOR_SYMBOL = 1, UNUM_PATTERN_SEPARATOR_SYMBOL = 2, UNUM_PERCENT_SYMBOL = 3, 
    UNUM_ZERO_DIGIT_SYMBOL = 4, UNUM_DIGIT_SYMBOL = 5, UNUM_MINUS_SIGN_SYMBOL = 6, UNUM_PLUS_SIGN_SYMBOL = 7, 
    UNUM_CURRENCY_SYMBOL = 8, UNUM_INTL_CURRENCY_SYMBOL = 9, UNUM_MONETARY_SEPARATOR_SYMBOL = 10, UNUM_EXPONENTIAL_SYMBOL = 11, 
    UNUM_PERMILL_SYMBOL = 12, UNUM_PAD_ESCAPE_SYMBOL = 13, UNUM_INFINITY_SYMBOL = 14, UNUM_NAN_SYMBOL = 15, 
    UNUM_SIGNIFICANT_DIGIT_SYMBOL = 16, UNUM_MONETARY_GROUPING_SEPARATOR_SYMBOL = 17, UNUM_ONE_DIGIT_SYMBOL = 18, UNUM_TWO_DIGIT_SYMBOL = 19, 
    UNUM_THREE_DIGIT_SYMBOL = 20, UNUM_FOUR_DIGIT_SYMBOL = 21, UNUM_FIVE_DIGIT_SYMBOL = 22, UNUM_SIX_DIGIT_SYMBOL = 23, 
    UNUM_SEVEN_DIGIT_SYMBOL = 24, UNUM_EIGHT_DIGIT_SYMBOL = 25, UNUM_NINE_DIGIT_SYMBOL = 26, UNUM_FORMAT_SYMBOL_COUNT = 27 
  );

  //http://icu-project.org/apiref/icu4c452/unum_8h.html#a4eb4d3ff13bd506e7078b2be4052266d
  UNumberFormatStyle = public enum (
    UNUM_PATTERN_DECIMAL, UNUM_DECIMAL, UNUM_CURRENCY, UNUM_PERCENT, UNUM_SCIENTIFIC, UNUM_SPELLOUT, UNUM_ORDINAL, UNUM_DURATION, 
    UNUM_NUMBERING_SYSTEM, UNUM_PATTERN_RULEBASED, UNUM_DEFAULT, UNUM_IGNORE
  );

  //http://icu-project.org/apiref/icu4c/udat_8h.html#a5eefb511a1a2cdc12bcbd06ed29880f4
  UDateFormatSymbolType = public enum (
    UDAT_ERAS, UDAT_MONTHS, UDAT_SHORT_MONTHS, UDAT_WEEKDAYS, UDAT_SHORT_WEEKDAYS, UDAT_AM_PMS, UDAT_LOCALIZED_CHARS, 
    UDAT_ERA_NAMES, UDAT_NARROW_MONTHS, UDAT_NARROW_WEEKDAYS, UDAT_STANDALONE_MONTHS, UDAT_STANDALONE_SHORT_MONTHS, 
    UDAT_STANDALONE_NARROW_MONTHS, UDAT_STANDALONE_WEEKDAYS, UDAT_STANDALONE_SHORT_WEEKDAYS, UDAT_STANDALONE_NARROW_WEEKDAYS, 
    UDAT_QUARTERS, UDAT_SHORT_QUARTERS, UDAT_STANDALONE_QUARTERS, UDAT_STANDALONE_SHORT_QUARTERS, UDAT_SHORTER_WEEKDAYS, 
    UDAT_STANDALONE_SHORTER_WEEKDAYS, UDAT_CYCLIC_YEARS_WIDE, UDAT_CYCLIC_YEARS_ABBREVIATED, UDAT_CYCLIC_YEARS_NARROW, 
    UDAT_ZODIAC_NAMES_WIDE, UDAT_ZODIAC_NAMES_ABBREVIATED, UDAT_ZODIAC_NAMES_NARROW
  );

  //http://icu-project.org/apiref/icu4c/udat_8h.html#adb4c5a95efb888d04d38db7b3efff0c5
  UDateFormatStyle = public enum (
    UDAT_FULL, UDAT_LONG, UDAT_MEDIUM, UDAT_SHORT, UDAT_DEFAULT, UDAT_RELATIVE, UDAT_NONE, UDAT_PATTERN, UDAT_IGNORE
  );

  UNumberFormat = ^Void;
  UDateFormat = ^Void;
  UBool = Byte;

  //http://icu-project.org/apiref/icu4c/structUParseError.html
  UParseError = public record
  public
    line: Int32; 
    offset: Int32;
    preContext: array[0..U_PARSE_CONTEXT_LEN - 1] of AnsiChar;
    postContext: array[0..U_PARSE_CONTEXT_LEN - 1] of AnsiChar;
  end;

  ICUHelper = public class
  private
    class const LibICU = 'libicuuc.so';
    class const Lib18n = 'libicui18n.so'; 

    class var fLibICU: ^Void;
    class var fLib18n: ^Void;
    class var fVersion: String;
    class constructor;
    finalizer;
    class method GetICUVersion: String;
    class method GetSymbol(aLib: ^Void; aSymbolName: String): ^Void;
    class method GetSymbols;
    {$IF LINUX AND NOT ANDROID}
    class method GetICUPath(var versionSuffix: String): String;
    {$ENDIF}
  public
    class var UNumGetSymbol: unum_getSymbol;
    class var UNumOpen: unum_open;
    class var UNumClose: unum_close;
    class var ULocGetDefault: uloc_getDefault;
    class var ULocGetName: uloc_getName;
    class var UStrToUpper: u_strToUpper;
    class var UStrToLower: u_strToLower;
    class var UDatGetSymbols: udat_getSymbols;
    class var UDatCountSymbols: udat_countSymbols;
    class var UDatOpen: udat_open;
    class var UDatToPattern: udat_toPattern;
    class var UDatClose: udat_close;
  end;

  unum_getSymbol = public function(fmt: ^Void; symbol: UNumberFormatSymbol; buffer: ^Void; bufferLength: Int32; status: ^UErrorCode): Int32;
  unum_open = public function(style: UNumberFormatStyle; pattern: ^Void; patternLength: Int32; locale: ^Void; parseErr: ^UParseError; status: ^UErrorCode): ^UNumberFormat;
  unum_close = public procedure(fmt: ^UNumberFormat);

  uloc_getDefault = public function: ^Char;
  uloc_getLanguage = public function(localeID: ^Void; language: ^Void; languageCapacity: Int32; err: ^UErrorCode): Int32;
  uloc_getCountry = public function(localeID: ^Void; country: ^Void; countryCapacity: Int32; err: ^UErrorCode): Int32;
  uloc_getName = public function(localeID: ^Void; name: ^Char; nameCapacity: Int32; err: ^UErrorCode): Int32;

  u_strToUpper = public function(dest: ^Void; destCapaciy: Int32; src: ^Void; srcLength: Int32; localeID: ^Void; err: ^UErrorCode): Int32;
  u_strToLower = public function(dest: ^Void; destCapaciy: Int32; src: ^Void; srcLength: Int32; localeID: ^Void; err: ^UErrorCode): Int32;

  udat_open = public function(timeStyle: UDateFormatStyle; dateStyle: UDateFormatStyle; locale: ^Void; tzID: ^Void; tzIDLength: Int32; 
    pattern: ^Void; patternLength: Int32; err: ^UErrorCode): ^UDateFormat;
  udat_getSymbols = public function(fmt: ^UDateFormat; &type: UDateFormatSymbolType; symbolIndex: Int32; &result: ^Void; resultLength: Int32; err: ^UErrorCode): Int32;
  udat_countSymbols = public function(fmt: ^UDateFormat; &type: UDateFormatSymbolType): Int32;
  udat_toPattern = public function(fmt: ^UDateFormat; localized: UBool; &result: ^Void; resultLength: Int32; err: ^UErrorCode): Int32;
  udat_close = public procedure(format: ^UDateFormat);

implementation

{$IF LINUX AND NOT ANDROID}
class method ICUHelper.GetICUPath(var versionSuffix: String): String;
begin
  var lICUPaths: array[0..2] of String := ['/usr/lib/x86_64-linux-gnu/', '/usr/lib/', '/lib/'];
  for lPath in lICUPaths do begin
    var lToTry := lPath + LibICU;
    for i: Integer := 25 to 99 do begin
      var lLib := lToTry + '.' + i.ToString;
      if FileUtils.FileExists(lLib) then begin
        versionSuffix := i.ToString;
        exit lPath;
      end;
    end;
  end;
  result := '';
end;
{$ENDIF}

class constructor ICUHelper;
begin
  {$IF ANDROID}
  var lLibPath := '/system/lib/' + LibICU;
  fLibICU := rtl.dlopen(@lLibPath.ToAnsiChars(true)[0], rtl.RTLD_LAZY);
  lLibPath := '/system/lib/' + Lib18n;
  fLib18n := rtl.dlopen(@lLibPath.ToAnsiChars(true)[0], rtl.RTLD_LAZY);
  {$ELSEIF LINUX AND NOT ANDROID}
  var lVersionSuffix: String;
  var lLibPath := GetICUPath(lVersionSuffix);
  if lLibPath <> '' then begin
    var lLib := lLibPath + LibICU + '.' + lVersionSuffix;
    fLibICU := rtl.dlopen(@lLib.ToAnsiChars(true)[0], rtl.RTLD_LAZY);
    lLib := lLibPath + Lib18n + '.' + lVersionSuffix;
    fLib18n := rtl.dlopen(@lLib.ToAnsiChars(true)[0], rtl.RTLD_LAZY);
  end;
  {$ENDIF}
  fVersion := GetICUVersion;
  GetSymbols;
end;

finalizer ICUHelper;
begin
  rtl.dlclose(fLibICU);
  rtl.dlclose(fLib18n);
end;

class method ICUHelper.GetICUVersion: String;
begin
  var lToFind := 'unum_getSymbol'.ToAnsiChars(true);
  if rtl.dlsym(fLib18n, @lToFind[0]) <> nil then result := ''
  else begin
    for i: Integer := 25 to 99 do begin
      lToFind := ('unum_getSymbol' + '_' + i.ToString).ToAnsiChars(true);
      if rtl.dlsym(fLib18n, @lToFind[0]) <> nil then exit '_' + i.ToString;
    end;
  end;
end;

class method ICUHelper.GetSymbol(aLib: ^Void; aSymbolName: String): ^Void;
begin
  var lToFind := (aSymbolName + fVersion).ToAnsiChars(true);
  result := rtl.dlsym(aLib, @lToFind[0]);
end;

class method ICUHelper.GetSymbols;
begin
  UNumGetSymbol := unum_getSymbol(GetSymbol(fLib18n, 'unum_getSymbol'));
  UNumOpen := unum_open(GetSymbol(fLib18n, 'unum_open'));
  UNumClose := unum_close(GetSymbol(fLib18n, 'unum_close'));
  ULocGetDefault := uloc_getDefault(GetSymbol(fLibICU, 'uloc_getDefault'));
  ULocGetName := uloc_getName(GetSymbol(fLibICU, 'uloc_getName'));
  UStrToUpper := u_strToUpper(GetSymbol(fLibICU, 'u_strToUpper'));
  UStrToLower := u_strToLower(GetSymbol(fLibICU, 'u_strToLower'));
  UDatGetSymbols := udat_getSymbols(GetSymbol(fLib18n, 'udat_getSymbols'));
  UDatCountSymbols := udat_countSymbols(GetSymbol(fLib18n, 'udat_countSymbols'));
  UDatOpen := udat_open(GetSymbol(fLib18n, 'udat_open'));
  UDatToPattern := udat_toPattern(GetSymbol(fLib18n, 'udat_toPattern'));
  UDatClose := udat_close(GetSymbol(fLib18n, 'udat_close'));
end;

{$ENDIF}

end.