namespace RemObjects.Elements.System;
uses
  Foundation;

type
  Int8_DarwinExtension = public extension class(Int8)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  UInt8_DarwinExtension = public extension class(UInt8)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  Int16_DarwinExtension = public extension class(Int16)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  UInt16_DarwinExtension = public extension class(UInt16)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  Int32_DarwinExtension = public extension class(Int32)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  UInt32_DarwinExtension = public extension class(UInt32)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  Int64_DarwinExtension = public extension class(Int64)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  UInt64_DarwinExtension = public extension class(UInt64)
  public
    {$INCLUDE DarwinNumbers.inc}
  end;

  //
  //
  //

  Boolean_DarwinExtension = public extension class(Boolean)
  public
    property charValue: Int8 read if self then 1 else 0;
    property shortValue: Int16 read if self then 1 else 0;
    property intValue: Int32 read if self then 1 else 0;
    property longValue: Int64 read if self then 1 else 0;
    property longLongValue: Int64 read if self then 1 else 0;

    property unsignedCharValue: UInt8 read if self then 1 else 0;
    property unsignedShortValue: UInt16 read if self then 1 else 0;
    property unsignedIntValue: Int32 read if self then 1 else 0;
    property unsignedLongValue: UInt64 read if self then 1 else 0;
    property unsignedLongLongValue: UInt64 read if self then 1 else 0;

    property integerValue: NSInteger read if self then 1 else 0;
    property unsignedIntegerValue: NSUInteger read if self then 1 else 0;

    property decimalValue: NSDecimal read (self as NSNumber).decimalValue;
    property doubleValue: Double read if self then 1 else 0;
    property floatValue: Single read if self then 1 else 0;

    property boolValue: Boolean read self;
    property stringValue: String read (self as NSNumber).stringValue;
    property objCType: ^AnsiChar read (self as NSNumber).objCType;

    method descriptionWithLocale(aLocale: NSLocale): String;
    begin
      result := (self as NSNumber).descriptionWithLocale(aLocale);
    end;

    method compare(aOther: NSNumber): NSComparisonResult;
    begin
      result := (self as NSNumber).compare(aOther);
    end;

    method isEqualToNumber(aOther: NSNumber): Boolean;
    begin
      result := (self as NSNumber).isEqualToNumber(aOther);
    end;
  end;

  Single_DarwinExtension = public extension class(Single)
  public
    property charValue: Int8 read self as Int8;
    property shortValue: Int16 read self as Int16;
    property intValue: Int32 read self as Int32;
    property longValue: Int64 read self as Int64;
    property longLongValue: Int64 read self as Int64;

    property unsignedCharValue: UInt8 read self as UInt8;
    property unsignedShortValue: UInt16 read self as UInt16;
    property unsignedIntValue: Int32 read self as UInt32;
    property unsignedLongValue: UInt64 read self as UInt64;
    property unsignedLongLongValue: UInt64 read self as UInt64;

    property integerValue: NSInteger read self as NSInteger;
    property unsignedIntegerValue: NSUInteger read self as NSUInteger;

    property decimalValue: NSDecimal read (self as NSNumber).decimalValue;
    property doubleValue: Double read self;
    property floatValue: Single read self;

    property boolValue: Boolean read self ≠ 0;
    property stringValue: String read (self as NSNumber).stringValue;
    property objCType: ^AnsiChar read (self as NSNumber).objCType;

    method descriptionWithLocale(aLocale: NSLocale): String;
    begin
      result := (self as NSNumber).descriptionWithLocale(aLocale);
    end;

    method compare(aOther: NSNumber): NSComparisonResult;
    begin
      result := (self as NSNumber).compare(aOther);
    end;

    method isEqualToNumber(aOther: NSNumber): Boolean;
    begin
      result := (self as NSNumber).isEqualToNumber(aOther);
    end;
  end;

  Double_DarwinExtension = public extension class(Double)
  public
    property charValue: Int8 read self as Int8;
    property shortValue: Int16 read self as Int16;
    property intValue: Int32 read self as Int32;
    property longValue: Int64 read self as Int64;
    property longLongValue: Int64 read self as Int64;

    property unsignedCharValue: UInt8 read self as UInt8;
    property unsignedShortValue: UInt16 read self as UInt16;
    property unsignedIntValue: Int32 read self as UInt32;
    property unsignedLongValue: UInt64 read self as UInt64;
    property unsignedLongLongValue: UInt64 read self as UInt64;

    property integerValue: NSInteger read self as NSInteger;
    property unsignedIntegerValue: NSUInteger read self as NSUInteger;

    property decimalValue: NSDecimal read (self as NSNumber).decimalValue;
    property doubleValue: Double read self;
    property floatValue: Single read self;

    property boolValue: Boolean read self ≠ 0;
    property stringValue: String read (self as NSNumber).stringValue;
    property objCType: ^AnsiChar read (self as NSNumber).objCType;

    method descriptionWithLocale(aLocale: NSLocale): String;
    begin
      result := (self as NSNumber).descriptionWithLocale(aLocale);
    end;

    method compare(aOther: NSNumber): NSComparisonResult;
    begin
      result := (self as NSNumber).compare(aOther);
    end;

    method isEqualToNumber(aOther: NSNumber): Boolean;
    begin
      result := (self as NSNumber).isEqualToNumber(aOther);
    end;
  end;

  __ElementsBoxedStructDestructor = public procedure (o: ^Void);

  __ElementsBoxedStruct = public class(NSObject) // We're explicitly NOT implementing INSCopying and INSCoding
  private
    fValue: ^Void;
    fDtor: __ElementsBoxedStructDestructor;
  public
    constructor (aValue: ^Void; aDtor: __ElementsBoxedStructDestructor);
    begin
      fValue := aValue;
      fDtor := aDtor;
    end;
 // Presume already "copied" & malloced
    finalizer;
    begin
      if fDtor <> nil then
        fDtor(fValue);
      free(fValue);
    end;

    method description: NSString; override;
    begin
      result := "<Boxed Struct Type>"
    end;

    class method boxedStructWithValue(aValue: ^Void; aDtor: __ElementsBoxedStructDestructor): __ElementsBoxedStruct;
    begin
      exit new __ElementsBoxedStruct(aValue, aDtor);
    end;

    class method valueForStruct(aStruct: Object; aDtor: __ElementsBoxedStructDestructor): ^Void;
    begin
      var lSelf := __ElementsBoxedStruct(aStruct);
      if lSelf.Dtor <> aDtor then
        raise new NSException withName('InvalidCastException') reason ('Destructor does not match for boxed struct') userInfo(nil);
      exit lSelf.fValue;
    end;

    //
    property Dtor: __ElementsBoxedStructDestructor read fDtor;
    property Value: ^Void read fValue;
    operator Equal(object1: __ElementsBoxedStruct; object2: id): Boolean;
    begin
      if not assigned(object1) then exit not assigned(object2);
      result := object1.isEqual(object2);
    end;

    operator Equal(object1: id; object2: __ElementsBoxedStruct): Boolean;
    begin
      if not assigned(object2) then exit not assigned(object1);
      result := object2.isEqual(object1);
    end;

    operator NotEqual(object1: __ElementsBoxedStruct; object2: id): Boolean;
    begin
      if not assigned(object1) then exit assigned(object2);
      result := not object1.isEqual(object2);
    end;

    operator NotEqual(object1: id; object2: __ElementsBoxedStruct): Boolean;
    begin
      if not assigned(object2) then exit assigned(object1);
      result := not object2.isEqual(object1);
    end;

    { INSObject }
    method isEqual(object: id): Boolean; override;
    begin
      if object is __ElementsBoxedStruct then begin
        if (object as __ElementsBoxedStruct).Value = Value then exit true; // exact same pointer? then thye must be equal
      end;
      result := false;
    end;

    method isEqualTo(object: id): Boolean; reintroduce;
    begin
      result := isEqual(object);
    end;

    { INSCopying }
    method copyWithZone(zone: ^NSZone): id;
    begin
      exit self;
    end;

    method mutableCopyWithZone(zone: ^NSZone): not nullable id;
    begin
      exit self;
    end;

    { INSCoding }
    method encodeWithCoder(aCoder: not nullable NSCoder);
    begin
      raise new Exception("Encoding/decoding is not supported for boxed structs.")
    end;

    method initWithCoder(aDecoder: not nullable NSCoder): nullable InstanceType;
    begin
      raise new Exception("Encoding/decoding is not supported for boxed structs.")
    end;

  end;

  __ElementsBoxedChar = public class(NSObject, INSCopying, INSCoding)
  private
    method stringValue: NSString;
    begin
      var char := charValue;
      result := NSString.stringWithCharacters(@char) length(1);
    end;

  public
    constructor withChar(aChar: Char);
    begin
      charValue := aChar;
    end;

    class method boxedCharWithChar(aChar: Char): __ElementsBoxedChar;
    begin
      exit new __ElementsBoxedChar withChar(aChar);
    end;

    method description: NSString; override;
    begin
      result := NSString.stringWithFormat("%c", charValue);
    end;

    property charValue: Char public read private write;
    property stringValue: NSString read stringValue;
    operator Implicit(aValue: __ElementsBoxedChar): NSNumber;
    begin
      result := NSNumber.numberWithUnsignedInt(aValue.charValue as Int16);
    end;

    operator Implicit(aValue: __ElementsBoxedChar): Char;
    begin
      result := aValue.charValue;
    end;

    operator Equal(object1: __ElementsBoxedChar; object2: id): Boolean;
    begin
      if not assigned(object1) then exit not assigned(object2);
      result := object1.isEqualTo(object2);
    end;

    operator Equal(object1: id; object2: __ElementsBoxedChar): Boolean;
    begin
      if not assigned(object2) then exit not assigned(object1);
      result := object2.isEqualTo(object1);
    end;

    operator NotEqual(object1: __ElementsBoxedChar; object2: id): Boolean;
    begin
      if not assigned(object1) then exit assigned(object2);
      result := not object1.isEqualTo(object2);
    end;

    operator NotEqual(object1: id; object2: __ElementsBoxedChar): Boolean;
    begin
      if not assigned(object2) then exit assigned(object1);
      result := not object2.isEqualTo(object1);
    end;

    { INSObject }
    method isEqual(object: id): Boolean; override;
    begin
      result := isEqualTo(object)
    end;

    method isEqualTo(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (charValue = (object as __ElementsBoxedChar).charValue)) or
                ((object is __ElementsBoxedAnsiChar) and (charValue = Char((object as __ElementsBoxedAnsiChar).ansiCharValue))) or
                ((object is NSString) and (stringValue = (object as NSString)));
    end;

    method isGreaterThan(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (charValue > (object as __ElementsBoxedChar).charValue)) or
                ((object is __ElementsBoxedAnsiChar) and (charValue > Char((object as __ElementsBoxedAnsiChar).ansiCharValue))) or
                ((object is NSString) and (stringValue > (object as NSString)));
    end;

    method isGreaterThanOrEqualTo(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (charValue >= (object as __ElementsBoxedChar).charValue)) or
                ((object is __ElementsBoxedAnsiChar) and (charValue >= Char((object as __ElementsBoxedAnsiChar).ansiCharValue))) or
                ((object is NSString) and (stringValue >= (object as NSString)));
    end;

    method isLessThan(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (charValue < (object as __ElementsBoxedChar).charValue)) or
                ((object is __ElementsBoxedAnsiChar) and (charValue < Char((object as __ElementsBoxedAnsiChar).ansiCharValue))) or
                ((object is NSString) and (stringValue < (object as NSString)));
    end;

    method isLessThanOrEqualTo(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (charValue <= (object as __ElementsBoxedChar).charValue)) or
                ((object is __ElementsBoxedAnsiChar) and (charValue <= Char((object as __ElementsBoxedAnsiChar).ansiCharValue))) or
                ((object is NSString) and (stringValue <= (object as NSString)));
    end;

    { INSCopying }
    method copyWithZone(zone: ^NSZone): id;
override;
    begin
      result := __ElementsBoxedChar.allocWithZone(zone).initWithChar(charValue) as not nullable;
    end;

    method mutableCopyWithZone(zone: ^NSZone): not nullable id;
    begin
      result := __ElementsBoxedChar.allocWithZone(zone).initWithChar(charValue) as not nullable;
    end;

    { INSCoding }
    method encodeWithCoder(aCoder: not nullable NSCoder);
override;
    begin
      var ch := charValue;
      aCoder.encodeBytes(@ch) length(2);
    end;

    method initWithCoder(aDecoder: not nullable NSCoder): nullable InstanceType;
override;
    begin
      var len: NSUInteger;
      var ch: ^Char := ^Char(aDecoder.decodeBytesWithReturnedLength(var len));
      charValue := ch^;
    end;

  end;

  __ElementsBoxedAnsiChar = public class(NSObject, INSCopying, INSCoding)
  private
    method stringValue: NSString;
    begin
      var char := Char(ansiCharValue);
      result := NSString.stringWithCharacters(@char) length(1);
    end;

  public
    constructor withAnsiChar(aAnsiChar: AnsiChar);
    begin
      ansiCharValue := aAnsiChar;
    end;

    class method boxedAnsiCharWithAnsiChar(aAnsiChar: AnsiChar): __ElementsBoxedAnsiChar;
    begin
      exit new __ElementsBoxedAnsiChar withAnsiChar(aAnsiChar);
    end;

    method description: NSString; override;
    begin
      result := NSString.stringWithFormat("%c", ansiCharValue);
    end;

    property ansiCharValue: AnsiChar public read private write;
    property stringValue: NSString read stringValue;
    operator Implicit(aValue: __ElementsBoxedAnsiChar): NSNumber;
    begin
      result := NSNumber.numberWithUnsignedChar(aValue.ansiCharValue as Byte);
    end;

    operator Implicit(aValue: __ElementsBoxedAnsiChar): AnsiChar;
    begin
      result := aValue.ansiCharValue;
    end;

    operator Equal(object1: __ElementsBoxedAnsiChar; object2: id): Boolean;
    begin
      if not assigned(object1) then exit not assigned(object2);
      result := object1.isEqualTo(object2);
    end;

    operator Equal(object1: id; object2: __ElementsBoxedAnsiChar): Boolean;
    begin
      if not assigned(object2) then exit not assigned(object1);
      result := object2.isEqualTo(object1);
    end;

    operator NotEqual(object1: __ElementsBoxedAnsiChar; object2: id): Boolean;
    begin
      if not assigned(object1) then exit assigned(object2);
      result := not object1.isEqualTo(object2);
    end;

    operator NotEqual(object1: id; object2: __ElementsBoxedAnsiChar): Boolean;
    begin
      if not assigned(object2) then exit assigned(object1);
      result := not object2.isEqualTo(object1);
    end;

    { INSObject }
    method isEqual(object: id): Boolean; override;
    begin
      result := isEqualTo(object)
    end;

    method isEqualTo(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedAnsiChar) and (ansiCharValue = (object as __ElementsBoxedAnsiChar).ansiCharValue)) or
                ((object is __ElementsBoxedChar) and (Char(ansiCharValue) = (object as __ElementsBoxedChar).charValue)) or
                ((object is NSString) and (stringValue = (object as NSString)));
    end;

    method isGreaterThan(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (ansiCharValue > (object as __ElementsBoxedAnsiChar).ansiCharValue)) or
                ((object is __ElementsBoxedChar) and (Char(ansiCharValue) > (object as __ElementsBoxedChar).charValue)) or
                ((object is NSString) and (stringValue > (object as NSString)));
    end;

    method isGreaterThanOrEqualTo(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (ansiCharValue >= (object as __ElementsBoxedAnsiChar).ansiCharValue)) or
                ((object is __ElementsBoxedChar) and (Char(ansiCharValue) >= (object as __ElementsBoxedChar).charValue)) or
                ((object is NSString) and (stringValue >= (object as NSString)));
    end;

    method isLessThan(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (ansiCharValue < (object as __ElementsBoxedAnsiChar).ansiCharValue)) or
                ((object is __ElementsBoxedChar) and (Char(ansiCharValue) < (object as __ElementsBoxedChar).charValue)) or
                ((object is NSString) and (stringValue < (object as NSString)));
    end;

    method isLessThanOrEqualTo(object: id): Boolean; reintroduce;
    begin
      result := ((object is __ElementsBoxedChar) and (ansiCharValue <= (object as __ElementsBoxedAnsiChar).ansiCharValue)) or
                ((object is __ElementsBoxedChar) and (Char(ansiCharValue) <= (object as __ElementsBoxedChar).charValue)) or
                ((object is NSString) and (stringValue <= (object as NSString)));
    end;

    { INSCopying }
    method copyWithZone(zone: ^NSZone): id;
override;
    begin
      result := __ElementsBoxedAnsiChar.allocWithZone(zone).initWithAnsiChar(ansiCharValue) as not nullable;
    end;

    method mutableCopyWithZone(zone: ^NSZone): not nullable id;
    begin
      result := __ElementsBoxedAnsiChar.allocWithZone(zone).initWithAnsiChar(ansiCharValue) as not nullable;
    end;

    { INSCoding }
    method encodeWithCoder(aCoder: not nullable NSCoder);
override;
    begin
      var ch := ansiCharValue;
      aCoder.encodeBytes(@ch) length(2);
    end;

    method initWithCoder(aDecoder: not nullable NSCoder): nullable InstanceType;
override;
    begin
      var len: NSUInteger;
      var ch: ^AnsiChar := ^AnsiChar(aDecoder.decodeBytesWithReturnedLength(var len));
      ansiCharValue := ch^;
    end;

  end;

end.