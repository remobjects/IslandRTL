namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;
{$ENDIF}
type
  String = public partial class
  private
  public
{$IF DARWIN}

    //
    // Casts
    //

    [DisableInlining]
    class operator Implicit(aValue: nullable String): nullable Foundation.NSString;
    begin
      if assigned(aValue) then begin
        if not assigned(aValue.fCachedNSString) then begin
          aValue.fCachedNSString := new Foundation.NSString withCharacters(@aValue.fFirstChar) length(aValue.Length);
        end;
        result := aValue.fCachedNSString;
      end;
    end;

    [DisableInlining]
    class operator Implicit(aValue: nullable Foundation.NSString): nullable String;
    begin
      if assigned(aValue) then begin
        //var lUsedLength: Foundation.NSUInteger;
        var lRemainingRange: Foundation.NSRange;
        lRemainingRange.location := 0;
        var lLength := aValue.length;
        lRemainingRange.length := lLength;
        //NSLog('got string %@', aValue);
        var lTmp := AllocString(lLength);
        aValue.getCharacters(@lTmp.fFirstChar) range(lRemainingRange);
        lTmp.fCachedNSString := aValue;
        result := lTmp;
      end;
    end;

    class operator Implicit(aValue: nullable id): nullable String;
    begin
      var lWrappedNativeObject := CocoaWrappedIslandObject(aValue);
      result := coalesce(String(lWrappedNativeObject:Value), lWrappedNativeObject:Value:ToString, String(aValue:description));
    end;

    //
    // Equality
    //

    class operator Equal(aValue1: String; aValue2: NSString): Boolean;
    begin
      if not assigned(aValue1) then
        result := not assigned(aValue2)
      else
        result := aValue1.Equals(String(aValue2));
    end;

    class operator Equal(aValue1: NSString; aValue2: String): Boolean;
    begin
      result := (aValue2 = aValue1);
    end;

    //
    // Inequality
    //

    class operator NotEqual(aValue1: String; aValue2: NSString): Boolean;
    begin
      if not assigned(aValue1) then
        result := assigned(aValue2)
      else
        result := not aValue1.Equals(String(aValue2));
    end;

    class operator NotEqual(aValue1: NSString; aValue2: String): Boolean;
    begin
      result := (aValue2 ≠ aValue1);
    end;

    //
    // Comparisons
    //

    class operator Greater(aValue1: String; aValue2: NSString): Boolean;
    begin
      result := aValue1 > String(aValue2);
    end;

    class operator Greater(aValue1: NSString; aValue2: String): Boolean;
    begin
      result := String(aValue2) > aValue1;
    end;

    class operator Less(aValue1: String; aValue2: NSString): Boolean;
    begin
        result := aValue1 < String(aValue2);
    end;

    class operator Less(aValue1: NSString; aValue2: String): Boolean;
    begin
      result := String(aValue2) < aValue1;
    end;

    class operator GreaterOrEqual(aValue1: String; aValue2: NSString): Boolean;
    begin
      result := aValue1 ≥ String(aValue2);
    end;

    class operator GreaterOrEqual(aValue1: NSString; aValue2: String): Boolean;
    begin
      result := String(aValue2) ≥ aValue1;
    end;

    class operator LessOrEqual(aValue1: String; aValue2: NSString): Boolean;
    begin
      result := aValue1 ≤ String(aValue2);
    end;

    class operator LessOrEqual(aValue1: NSString; aValue2: String): Boolean;
    begin
      result := String(aValue2) ≤ aValue1;
    end;

{$ENDIF}
  end;

end.