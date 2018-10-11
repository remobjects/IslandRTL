namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  IslandToCocoaBridge = public class(NSObject)
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
      if aValue is CocoaToIslandBridge then exit CocoaToIslandBridge(aValue).Value;
      exit new IslandToCocoaBridge(aValue);
    end;

    method description: NSString; //override;
    begin
      result := Value.ToString() as NSString;
    end;

    method hash: NSUInteger; //override;
    begin
      exit Value.GetHashCode;
    end;

    method isEqual(aOther: id): Boolean; //override;
    begin
      if aOther is IslandToCocoaBridge then
        result := Value.Equals(IslandToCocoaBridge(aOther).Value);
    end;

    method compareTo(aOther: NSObject): NSComparisonResult; //override;
    begin
      if aOther is IslandToCocoaBridge then
        exit (Value as IComparable).CompareTo(IslandToCocoaBridge(aOther).Value) as NSComparisonResult
      else
        result := NSComparisonResult.OrderedAscending /* -1, Cocoa before wrapped Island */
    end;
  end;

  CocoaToIslandBridge = public class(BridgedObject, IComparable, IEquatable)
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
      if aValue is IslandToCocoaBridge then exit IslandToCocoaBridge(aValue).Value;
      result := new CocoaToIslandBridge(aValue);
    end;

    method GetHashCode: Integer; override;
    begin
      result := Value.hash;
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin
      if aOther is CocoaToIslandBridge then
        result := Value.isEqual(CocoaToIslandBridge(aOther).Value);
    end;

    method CompareTo(aOther: Object): Integer;
    begin
      if aOther is CocoaToIslandBridge then begin
        //81174: Darwin: selector support
        //if not Value.respondsToSelector(selector(compareTo:)) then
          //raise new Exception("Object does not implement compareTo:");
        //81175: Darwin: cannot call compareTo: after casting to id
        //exit id(Value).compareTo(CocoaToIslandBridge(aOther).Value);
      end;
      exit -1; /* Island before wrapped Cocoa */
    end;

    method ToString: String; override;
    begin
      var s := Value.description as String;
    end;

  end;

{$ENDIF}

end.