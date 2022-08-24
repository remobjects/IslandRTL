namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  {$IF not WATCHOS and not TVOS}
  SwiftWrappedCocoaObject = public class(SwiftObject/*, Swift.CustomStringConvertible, Swift.Hashable, Swift.Equatable*/)
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

    property description: SwiftString read Value.description() as SwiftString;

    property hashValue: Integer read Value.hash;

    method isEqual(aOther: SwiftObject): Boolean;
    begin
      result := Value.isEqual(coalesce(SwiftWrappedCocoaObject(aOther):Value,
                                       SwiftWrappedIslandObject(aOther):Value));
                                       //aOther));
    end;

    method compareTo(aOther: SwiftObject): NSComparisonResult;
    begin
      if not Value.respondsToSelector(selector(compareTo:)) then
        raise new Exception("Cocoa Object does not implement compareTo:");

      //case aOther type of
        //SwiftWrappedCocoaObject: begin
            ////81175: Darwin: cannot call compareTo: after casting to id
            ////exit id(Value).compareTo(IslandWrappedSwiftObject(aOther).Value);
          //end;
        //SwiftWrappedIslandObject: begin
            ////81175: Darwin: cannot call compareTo: after casting to id
            ////exit id(Value).compareTo(IslandWrappedSwiftObject(aOther).Value);
          //end;
        //else begin
            ////81175: Darwin: cannot call compareTo: after casting to id
            ////exit id(Value).compareTo(IslandWrappedSwiftObject(aOther).Value);
          //end;
      //end;
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

    class method FromValue(aValue: SwiftObject): IslandObject;
    begin
      if aValue = nil then exit nil;
      if aValue is SwiftWrappedCocoaObject then exit SwiftWrappedCocoaObject(aValue).Value;
      if aValue is SwiftWrappedIslandObject then exit CocoaWrappedIslandObject.FromValue(SwiftWrappedIslandObject(aValue).Value);
      result := new CocoaWrappedSwiftObject(aValue);
    end;

    /*
    method description: SwiftString; override;
    begin
      result := Value.description() as SwiftString;
    end;
    */

    method hash: NSUInteger; override;
    begin
      //exit Value.hash;
    end;

    //method isEqual(aOther: CocoaObject): Boolean; override;
    //begin
      //result := Swift.Equatable(Value):isEqual(coalesce(CocoaWrappedSwiftObject(aOther):Value,
                                                        //CocoaWrappedIslandObject(aOther):Value,
                                                        //aOther));
    //end;

    //method compareTo(aOther: CocoaObject): NSComparisonResult; //override;
    //begin
      //if Value is not Swift.Comparable then
        //raise new Exception("Swift Object does not implement Comparable");

      //raise new Exception("Can not compare Swift objects yet.");
      ////case type aOther of
        ////CocoaWrappedSwiftObject: begin
            //////todo: need to figure out how this will work opn Swift objects
          ////end;
        ////CocoaWrappedIslandObject: begin
            //////todo: need to figure out how this will work opn Swift objects
        ////else begin
            //////todo: need to figure out how this will work opn Swift objects
          ////end;
      ////end;
    //end;

  end;
  {$ENDIF}

{$ENDIF}

end.