namespace RemObjects.Elements.System;

type
  &Index = public record
  public

    constructor(aValue: Integer; aFromEnd: Boolean);
    require
      aValue ≥ 0;
    begin
      fIndex := if aFromEnd then (not aValue) else aValue;
    end;

    method GetOffset(aLength: Integer): Integer;
    begin
      result := if fIndex < 0 then aLength-(not fIndex) else fIndex;
    end;

    operator Implicit(aInteger: Int32): &Index;
    begin
      result := new &Index(aInteger, false);
    end;

    //operator Index(aIndexFromEnd: Integer): System.Index;
    //begin
      //result := new &Index(aIndexFromEnd, true);
    //end;

  private
    fIndex: Integer;
  end;

  Range = public record
  public

    constructor(aStart: System.Index; aEnd: System.Index);
    begin
      fStart := aStart;
      fEnd := aEnd;
    end;

    class method StartAt(aStart: System.Index): Range;
    begin
      result := new Range(aStart, new &Index(0, true));
    end;

    class method EndAt(aEnd: System.Index): Range;
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

  assembly
    fStart: &Index;
    fEnd: &Index;
  end;

end.