namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  IslandObject = public Object;
  IslandString = public String;
  CocoaObject = public NSObject;
  CocoaString = public NSString;
  SwiftObject = public NSObject; // hack for now
  SwiftString = public NSString; // hack for now

  //
  // Island <-> Cocoa
  //

  CocoaWrappedIslandObject = public class(CocoaObject)
  private

    constructor(aValue: Object);
    begin
      Value := aValue;
    end;

  public

    property Value: Object; readonly;

    class method FromValue(aValue: Object): CocoaObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IslandWrappedCocoaObject then exit IslandWrappedCocoaObject(aValue).Value;
      if aValue is IslandWrappedSwiftObject then exit CocoaWrappedSwiftObject.FromValue(IslandWrappedSwiftObject(aValue).Value);
      exit new CocoaWrappedIslandObject(aValue);
    end;

    method description: CocoaString; override;
    begin
      result := Value.ToString() as CocoaString;
    end;

    method hash: NSUInteger; override;
    begin
      exit Value.GetHashCode;
    end;

    method isEqual(aOther: id): Boolean; override;
    begin
      result := Value.Equals(coalesce(CocoaWrappedIslandObject(aOther):Value,
                                      CocoaWrappedSwiftObject(aOther):Value,
                                      aOther));
    end;

    method compareTo(aOther: CocoaObject): NSComparisonResult;
    begin
      if aOther is CocoaWrappedIslandObject then
        result := (Value as IComparable).CompareTo(CocoaWrappedIslandObject(aOther).Value) as NSComparisonResult
      else if aOther is CocoaWrappedSwiftObject then
        result := (Value as IComparable).CompareTo(CocoaWrappedSwiftObject(aOther).Value) as NSComparisonResult
      else
        result := NSComparisonResult.OrderedAscending /* -1, Cocoa before wrapped Island */
    end;
  end;

  IslandWrappedCocoaObject = public class(WrappedObject, IComparable, IEquatable)
  private

    constructor(aValue: CocoaObject);
    begin
      Value := aValue;
    end;

  public

    property Value: CocoaObject; readonly;

    class method FromValue(aValue: CocoaObject): Object;
    begin
      if aValue = nil then exit nil;
      if aValue is CocoaWrappedIslandObject then exit CocoaWrappedIslandObject(aValue).Value;
      if aValue is CocoaWrappedSwiftObject then exit IslandWrappedSwiftObject(CocoaWrappedSwiftObject(aValue).Value);
      result := new IslandWrappedCocoaObject(aValue);
    end;

    method ToString: String; override;
    begin
      //result := Value.description as String;  // E0 Internal error: Unknown element 95
    end;

    method GetHashCode: Integer; override;
    begin
      //result := Value.hash; // E0 Internal error: Unknown element 95
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin
      result := Value.isEqual(coalesce(IslandWrappedCocoaObject(aOther):Value,
                                       IslandWrappedSwiftObject(aOther):Value,
                                       aOther));
    end;

    method CompareTo(aOther: Object): Integer;
    begin
      if not Value.respondsToSelector(selector(compareTo:)) then
        raise new Exception("Object does not implement compareTo:");
      case aOther type of
        IslandWrappedCocoaObject: begin
            //81175: Darwin: cannot call compareTo: after casting to id
            //exit id(Value).compareTo(IslandWrappedCocoaObject(aOther).Value);
          end;
        IslandWrappedSwiftObject: begin
            //81175: Darwin: cannot call compareTo: after casting to id
            //exit id(Value).compareTo(IslandWrappedSwiftObject(aOther).Value);
          end
        else begin
            //81175: Darwin: cannot call compareTo: after casting to id
            //exit id(Value).compareTo(aOther);
          end;
      end;
    end;

  end;

  /* == COMPARE IS FGOOD RTIL HERE */

  //
  // Island <-> Swift
  //

  SwiftWrappedIslandObject = public class(SwiftObject)
  private

    constructor(aValue: Object);
    begin
      Value := aValue;
    end;

  public

    property Value: Object; readonly;

    class method FromValue(aValue: Object): SwiftObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IslandWrappedSwiftObject then exit IslandWrappedSwiftObject(aValue).Value;
      if aValue is IslandWrappedCocoaObject then exit SwiftWrappedCocoaObject.FromValue(IslandWrappedCocoaObject(aValue).Value);
      exit new SwiftWrappedIslandObject(aValue);
    end;

    method description: CocoaString; override;
    begin
      result := Value.ToString() as CocoaString;
    end;

    method hash: NSUInteger; override;
    begin
      exit Value.GetHashCode;
    end;

    method isEqual(aOther: id): Boolean; override;
    begin
      result := Value.Equals(coalesce(SwiftWrappedIslandObject(aOther):Value,
                                      CocoaWrappedIslandObject(aOther):Value,
                                      aOther));
    end;

    method compareTo(aOther: SwiftObject): NSComparisonResult; //override;
    begin
      if aOther is SwiftWrappedIslandObject then
        result := (Value as IComparable).CompareTo(SwiftWrappedIslandObject(aOther).Value) as NSComparisonResult
      else if aOther is SwiftWrappedCocoaObject then
        result := (Value as IComparable).CompareTo(SwiftWrappedCocoaObject(aOther).Value) as NSComparisonResult
      else
        result := NSComparisonResult.OrderedAscending /* -1, Cocoa before wrapped Island */
    end;
  end;

  IslandWrappedSwiftObject = public class(WrappedObject, IComparable, IEquatable)
  private

    constructor(aValue: SwiftObject);
    begin
      Value := aValue;
    end;

  public

    property Value: SwiftObject; readonly;

    class method FromValue(aValue: SwiftObject): Object;
    begin
      if aValue = nil then exit nil;
      if aValue is SwiftWrappedIslandObject then exit SwiftWrappedIslandObject(aValue).Value;
      if aValue is SwiftWrappedCocoaObject then exit IslandWrappedCocoaObject.FromValue(SwiftWrappedCocoaObject(aValue).Value);
      result := new IslandWrappedSwiftObject(aValue);
    end;

    method ToString: String; override;
    begin
      //result := Value.description as String; // E0 Internal error: Unknown element 95
    end;

    method GetHashCode: Integer; override;
    begin
      //result := Value.hash; // E0 Internal error: Unknown element 95
    end;

    method &Equals(aOther: Object): Boolean; override;
    begin
      result := Value.isEqual(coalesce(IslandWrappedSwiftObject(aOther):Value,
                                       IslandWrappedCocoaObject(aOther):Value,
                                       aOther));
    end;

    method CompareTo(aOther: Object): Integer;
    begin
      //case type aOther of
        //IslandWrappedSwiftObject: begin
            ////todo: need to figure out how this will work opn Swift objects
            //raise new Exception("Can not compare Island to Swift objects yet/");
          //end;
        //IslandWrappedCocoaObject: begin
            //if not Value.respondsToSelector(selector(compareTo:)) then
              //raise new Exception("Object does not implement compareTo:");
            ////81175: Darwin: cannot call compareTo: after casting to id
            ////exit id(Value).compareTo(IslandWrappedCocoaObject(aOther).Value);
          //end;
        //else begin
          //exit -100; /* todo: find best value */
      //end;
    end;

  end;

  //
  // Cocoa <-> Swift
  //

  SwiftWrappedCocoaObject = public class(SwiftObject)
  private

    constructor(aValue: CocoaObject);
    begin
      Value := aValue;
    end;

  public

    property Value: CocoaObject; readonly;

    class method FromValue(aValue: CocoaObject): SwiftObject;
    begin
      if aValue = nil then exit nil;
      if aValue is CocoaWrappedSwiftObject then exit CocoaWrappedSwiftObject(aValue).Value;
      if aValue is CocoaWrappedIslandObject then exit SwiftWrappedCocoaObject.FromValue(CocoaWrappedIslandObject(aValue).Value);
      exit new SwiftWrappedCocoaObject(aValue);
    end;

    method description: SwiftString; override;
    begin
      //result := Value.description() as SwiftString; // E0 Internal error: Unknown element 95
    end;

    method hash: NSUInteger; override;
    begin
      //exit Value.hash; // E0 Internal error: Unknown element 95
    end;

    method isEqual(aOther: SwiftObject): Boolean; override;
    begin
      result := Value.isEqual(coalesce(SwiftWrappedCocoaObject(aOther):Value,
                                       SwiftWrappedIslandObject(aOther):Value,
                                       aOther));
    end;

    method compareTo(aOther: SwiftObject): NSComparisonResult; //override;
    begin
      //...
    end;
  end;

  CocoaWrappedSwiftObject = public class(CocoaObject)
  private

    constructor(aValue: SwiftObject);
    begin
      Value := aValue;
    end;

  public

    property Value: SwiftObject; readonly;

    class method FromValue(aValue: SwiftObject): Object;
    begin
      if aValue = nil then exit nil;
      if aValue is SwiftWrappedCocoaObject then exit SwiftWrappedCocoaObject(aValue).Value;
      if aValue is SwiftWrappedIslandObject then exit CocoaWrappedIslandObject.FromValue(SwiftWrappedIslandObject(aValue).Value);
      result := new CocoaWrappedSwiftObject(aValue);
    end;

    method description: SwiftString; override;
    begin
      //result := Value.description() as SwiftString; // E0 Internal error: Unknown element 95
    end;

    method hash: NSUInteger; override;
    begin
      //exit Value.hash; // E0 Internal error: Unknown element 95
    end;

    method isEqual(aOther: CocoaObject): Boolean; override;
    begin
      result := Value.isEqual(coalesce(CocoaWrappedSwiftObject(aOther):Value,
                                       CocoaWrappedIslandObject(aOther):Value,
                                       aOther));
    end;

    method compareTo(aOther: SwiftObject): NSComparisonResult; //override;
    begin
      //if aOther is CocoaWrappedIslandObject then
        //exit (Value as IComparable).CompareTo(CocoaWrappedIslandObject(aOther).Value) as NSComparisonResult
      //else
        //result := NSComparisonResult.OrderedAscending /* -1, Cocoa before wrapped Island */
    end;

  end;
{$ENDIF}

end.