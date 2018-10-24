namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  String = public partial class
  private
  public

    //
    // Casts
    //

    class operator Implicit(aValue: nullable String): nullable Foundation.NSString;
    begin
      if assigned(aValue) then begin
        if not assigned(aValue.fCachedNSString) then
          aValue.fCachedNSString := new Foundation.NSString withCharacters(@aValue.fFirstChar) length(aValue.Length);
        result := aValue.fCachedNSString;
      end;
    end;

    class operator Implicit(aValue: nullable Foundation.NSString): nullable String;
    begin
      if assigned(aValue) then begin
        var lUsedLength: Foundation.NSUInteger;
        var lRemainingRange: Foundation.NSRange;
        var lLength := aValue.length;
        result := AllocString(lLength);
        if not aValue.getBytes(@result.fFirstChar) maxLength(lLength*2) usedLength(@lUsedLength) encoding(Foundation.NSStringEncoding.UTF16LittleEndianStringEncoding) options(0) range(Foundation.NSMakeRange(0, lLength) )remainingRange(@lRemainingRange) then
          raise new InvalidCastException("Could not convert NSString to String");
        result.fCachedNSString := aValue;
      end;
    end;

    class operator Implicit(aValue: nullable id): nullable String;
    begin
      var lWrappedNativeObject := CocoaWrappedIslandObject(aValue);
      result := coalesce(String(lWrappedNativeObject:Value), lWrappedNativeObject:Value:ToString, aValue:description);
    end;

    class operator Explicit(aValue: nullable String): nullable NSString;
    begin
      result := aValue;
    end;

    class operator Explicit(aValue: nullable NSString): nullable String;
    begin
      result := aValue;
    end;

    class operator Explicit(aValue: nullable id): nullable String;
    begin
      result := aValue;
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

  end;

{$ENDIF}
end.