namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  CocoaWrappedIslandObject = public class(NSObject)
  private

    constructor(aValue: Object);
    begin
      Value := aValue;
    end;

  public

    property Value: Object; readonly;

    class method FromValue(aValue: Object): NSObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IslandWrappedCocoaObject then exit IslandWrappedCocoaObject(aValue).Value;
      exit new CocoaWrappedIslandObject(aValue);
    end;

    method description: NSString; override;
    begin
      result := Value.ToString() as NSString;
    end;

    method hash: NSUInteger; override;
    begin
      exit Value.GetHashCode;
    end;

    method isEqual(aOther: id): Boolean; override;
    begin
      if aOther is CocoaWrappedIslandObject then
        result := Value.Equals(CocoaWrappedIslandObject(aOther).Value);
    end;

    method compareTo(aOther: NSObject): NSComparisonResult; //override;
    begin
      if aOther is CocoaWrappedIslandObject then
        exit (Value as IComparable).CompareTo(CocoaWrappedIslandObject(aOther).Value) as NSComparisonResult
      else
        result := NSComparisonResult.OrderedAscending /* -1, Cocoa before wrapped Island */
    end;
  end;

  IslandWrappedCocoaObject = public class(WrappedObject, IComparable, IEquatable)
  private

    constructor(aValue: NSObject);
    begin
      Value := aValue;
    end;

  public

    property Value: NSObject; readonly;

    class method FromValue(aValue: NSObject): Object;
    begin
      if aValue = nil then exit nil;
      if aValue is CocoaWrappedIslandObject then exit CocoaWrappedIslandObject(aValue).Value;
      result := new IslandWrappedCocoaObject(aValue);
    end;

    method GetHashCode: Integer; override;
    begin
      result := Value.hash;
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin
      if aOther is IslandWrappedCocoaObject then
        result := Value.isEqual(IslandWrappedCocoaObject(aOther).Value);
    end;

    method CompareTo(aOther: Object): Integer;
    begin
      if aOther is IslandWrappedCocoaObject then begin
        //81174: Darwin: selector support
        //if not Value.respondsToSelector(selector(compareTo:)) then
          //raise new Exception("Object does not implement compareTo:");
        //81175: Darwin: cannot call compareTo: after casting to id
        //exit id(Value).compareTo(IslandWrappedCocoaObject(aOther).Value);
      end;
      exit -1; /* Island before wrapped Cocoa */
    end;

    method ToString: String; override;
    begin
      result := Value.description as String;
    end;

  end;

{$ENDIF}

end.