namespace Remobjects.Elements.System;

type
  &Index = public record(IEquatable<&Index>)
  public

    class property Start: &Index read new &Index(0);
    class property &End: &Index read new &Index(not 0);

    property Value: Integer read
      begin
        if fValue < 0 then begin
          exit not fValue;
        end
        else begin
          exit fValue;
        end;
      end;

    property IsFromEnd: Boolean read fValue < 0;

    constructor(aValue: Integer; aFromEnd: Boolean := false);
    begin
      if aValue < 0 then begin
        raise new ArgumentException("Index needs a non-negative number.");
      end;
      if aFromEnd then begin
        fValue := not aValue;
      end
      else begin
        fValue := aValue;
      end;
    end;

    class method FromStart(value: Integer): &Index;
    begin
      if value < 0 then begin
        raise new ArgumentException("Index needs a non-negative number.");
      end;
      exit new &Index(value);
    end;

    class method FromEnd(value: Integer): &Index;
    begin
      if value < 0 then begin
        raise new ArgumentException("Index needs a non-negative number.");
      end;
      exit new &Index(not value);
    end;

    method GetOffset(length: Integer): Integer;
    begin
      var offset: Integer := fValue;
      if IsFromEnd then begin
      //  offset = length - (~value)
      //  offset = length + (~(~value) + 1)
      //  offset = length + value + 1
        offset := offset + length + 1;
      end;
      exit offset;
    end;

    method &Equals(aValue: &Index): Boolean;
    begin
      exit (aValue is &Index) and (fValue = &Index(aValue).fValue);
    end;

    // public bool Equals(Index other) => _value == other._value; // JE10 Automatically generated generic type adapter method for "RemObjects.Oxygene.System.Boolean Equals(Index other)" clashes with existing "RemObjects.Oxygene.System.Boolean Equals(Object? value)"
    // public override int GetHashCode() => _value;

    class operator Implicit(value: Integer): &Index;
    begin
      exit FromStart(value);
    end;

    [ToString]
    method toString: String; override;
    begin
      if IsFromEnd then begin
        exit ToStringFromEnd();
      end;
      exit Int32(Value).toString;
    end;

  private

  // The following private constructors mainly created for perf reason to avoid the checks
    constructor(aValue: Integer);
    begin
      fValue := aValue;
    end;

    method ToStringFromEnd: String;
    begin
      exit #94 + Value.toString;
    end;

    var fValue: Integer;
  end;

  Range = public record(IEquatable<Range>)
  public

    constructor(aStart: &Index; aEnd: &Index);
    begin
      fStart := aStart;
      fEnd := aEnd;
    end;

    class method StartAt(aStart: &Index): Range;
    begin
      result := new Range(aStart, new &Index(0, true));
    end;

    class method EndAt(aEnd: &Index): Range;
    begin
      result := new Range(new &Index(0, false), aEnd);
    end;

    class property All: Range read new Range(new &Index(0, false), new &Index(0, true));

    //operator Range(aStart: &Index := 0; aEnd: &Index := ^0): Range;
    //begin
      //result := new Range(aStart, aEnd);
    //end;

    property Start: &Index read fStart;
    property &End: &Index read fEnd;

    method GetOffsets(aLength: Integer): not nullable &Tuple<Integer, Integer>;
    begin
      result := &Tuple.New(fStart.GetOffset(aLength), fEnd.GetOffset(aLength));
    end;

    method &Equals(aValue: Range): Boolean;
    begin
      exit (aValue is Range) and fStart.Equals(Range(aValue).fStart) and fEnd.Equals(Range(aValue).fEnd);
    end;

    [ToString]
    method ToString: String; override;
    begin
      result := fStart.ToString+".."+fEnd.ToString;
    end;

  assembly
    fStart: &Index;
    fEnd: &Index;
  end;

end.