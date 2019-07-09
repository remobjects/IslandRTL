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

end.