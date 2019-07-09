    property charValue: Int8 read self;
    property shortValue: Int16 read self;
    property intValue: Int32 read self;
    property longValue: Int64 read self;
    property longLongValue: Int64 read self;

    property unsignedCharValue: UInt8 read self;
    property unsignedShortValue: UInt16 read self;
    property unsignedIntValue: Int32 read self;
    property unsignedLongValue: UInt64 read self;
    property unsignedLongLongValue: UInt64 read self;

    property integerValue: NSInteger read self;
    property unsignedIntegerValue: NSUInteger read self;

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