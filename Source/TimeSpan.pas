namespace RemObjects.Elements.System;

type
  TimeSpan = public record( IComparable, IComparable<TimeSpan>, IEquatable, IEquatable<TimeSpan>)
  private
    fValue: Int64;
  public
    constructor(aTotal: Int64);
    begin
      fValue := aTotal;
    end;

    property Ticks: Int64 read fValue;

    constructor(aHours, aMinutes, aSeconds: Int64);
    begin
      fValue := (aHours * 3600 + aMinutes * 60 + aSeconds) * DateTime.TicksPerSecond;
    end;

    constructor(aDays, aHours, aMinutes, aSeconds: Int64);
    begin
      fValue := (aDays * 86400 + aHours * 3600 + aMinutes * 60 + aSeconds) * DateTime.TicksPerSecond;
    end;

    constructor(aDays, aHours, aMinutes, aSeconds, aMsec: Int64);
    begin
      fValue := (aDays * 86400 + aHours * 3600 + aMinutes * 60 + aSeconds) * DateTime.TicksPerSecond + (aMsec * DateTime.TicksPerMillisecond);
    end;

    method &Equals(other: TimeSpan): Boolean;
    begin
      exit other.fValue = fValue;
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin
      exit (aOther is TimeSpan) and (TimeSpan(aOther).fValue = fValue);
    end;

    method CompareTo(a: TimeSpan): Integer;
    begin
      exit fValue.CompareTo(a.fValue);
    end;

    method GetHashCode: Integer; override;
    begin
      exit fValue.GetHashCode;
    end;

    method CompareTo(a: Object): Integer;
    begin
      if a is TimeSpan then
        exit CompareTo(TimeSpan(a));
      exit -1;
    end;

    const TicksPerMillisecond : Int64 = 10000;

    const MillisPerSecond     : Int32 = 1000;
    const MillisPerMinute     : Int32 = 60 * 1000;          // = 60000;
    const MillisPerHour       : Int32 = 60 * 60 *1000;      // = 3600000;
    const MillisPerDay        : Int32 = 24 * 60 * 60 *1000; // = 86400000;
    const TicksPerSecond      : Int64 = TicksPerMillisecond * MillisPerSecond;  // = 10000000;
    const TicksPerMinute      : Int64 = TicksPerMillisecond * MillisPerMinute;  // = 600000000;
    const TicksPerHour        : Int64 = TicksPerMillisecond * MillisPerHour;    // = 36000000000;
    const TicksPerDay         : Int64 = TicksPerMillisecond * MillisPerDay;     // = 864000000000;

    class var MinValue: TimeSpan := new TimeSpan(Int64.MinValue); readonly;
    class var MaxValue: TimeSpan := new TimeSpan(Int64.MaxValue); readonly;
    class var Zero: TimeSpan := new TimeSpan(0); readonly;

    property Days: Integer read fValue / (TicksPerDay);
    property Hours: Integer read (fValue / (TicksPerHour)) mod 60;
    property Minutes: Integer read (fValue / (TicksPerMinute)) mod 60;
    property Seconds: Integer read (fValue / (TicksPerSecond)) mod 60;
    property Milliseconds: Integer read (fValue / (TicksPerMillisecond)) mod 1000;

    property TotalDays: Double read Double(fValue) / (TicksPerDay);
    property TotalHours: Double read (Double(fValue) / (TicksPerHour));
    property TotalMinutes: Double read (Double(fValue) / (TicksPerMinute));
    property TotalSeconds: Double read (Double(fValue) / (TicksPerSecond));
    property TotalMilliseconds: Double read (Double(fValue) / (TicksPerMillisecond));

    class method FromDays(aValue: Double): TimeSpan;
    begin
      exit new TimeSpan(Int64(aValue * TicksPerDay));
    end;

    class method FromHours(aValue: Double): TimeSpan;
    begin
      exit new TimeSpan(Int64(aValue * TicksPerDay));
    end;

    class method FromMinutes(aValue: Double): TimeSpan;
    begin
      exit new TimeSpan(Int64(aValue * TicksPerMinute));
    end;

    class method FromSeconds(aValue: Double): TimeSpan;
    begin
      exit new TimeSpan(Int64(aValue * TicksPerSecond));
    end;

    class method FromMilliseconds(aValue: Double): TimeSpan;
    begin
      exit new TimeSpan(Int64(aValue * TicksPerMillisecond));
    end;

    class operator &Add(aLeft: DateTime; aRight: TimeSpan): DateTime;
    begin
      exit new DateTime(aLeft.Ticks + aRight.Ticks);
    end;

    class operator &Subtract(aLeft: DateTime; aRight: TimeSpan): DateTime;
    begin
      exit new DateTime(aLeft.Ticks - aRight.Ticks);
    end;

    class operator &Add(aLeft: TimeSpan; aRight: TimeSpan): TimeSpan;
    begin
      exit new TimeSpan(aLeft.Ticks + aRight.Ticks);
    end;

    class operator &Subtract(aLeft: TimeSpan; aRight: TimeSpan): TimeSpan;
    begin
      exit new TimeSpan(aLeft.Ticks - aRight.Ticks);
    end;

    class operator &Equal(aLeft: TimeSpan; aRight: TimeSpan): Boolean;
    begin
      exit aLeft.Ticks = aRight.Ticks;
    end;

    class operator &NotEqual(aLeft: TimeSpan; aRight: TimeSpan): Boolean;
    begin
      exit aLeft.Ticks <> aRight.Ticks;
    end;

    class operator &Greater(aLeft: TimeSpan; aRight: TimeSpan): Boolean;
    begin
      exit aLeft.Ticks > aRight.Ticks;
    end;

    class operator &GreaterOrEqual(aLeft: TimeSpan; aRight: TimeSpan): Boolean;
    begin
      exit aLeft.Ticks >= aRight.Ticks;
    end;

    class operator &Less(aLeft: TimeSpan; aRight: TimeSpan): Boolean;
    begin
      exit aLeft.Ticks < aRight.Ticks;
    end;
    class operator &LessOrEqual(aLeft: TimeSpan; aRight: TimeSpan): Boolean;
    begin
      exit aLeft.Ticks <= aRight.Ticks;
    end;

    method ToString: String; override;
    begin
      exit $"{Days}:{Hours}:{Minutes}:{Seconds}:{Milliseconds}";
    end;
  end;

end.