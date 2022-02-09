namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  CocoaObject = public Foundation.NSObject;
  CocoaString = public Foundation.NSString;
  CocoaException = public Foundation.NSException;
  SwiftException = public Foundation.NSException; // hack for now

  //[Swift]
  SwiftObject = public abstract class
  public
    constructor; empty;
  end;

  //[Swift]
  RemObjects.Elements.System.Swift.CustomStringConvertible = public interface // hack for now
    property description: SwiftString read;
  end;

  //[Swift]
  RemObjects.Elements.System.Swift.Equatable = public interface // hack for now
    method isEqual(aOther: SwiftObject): Boolean;
  end;

  //[Swift]
  RemObjects.Elements.System.Swift.Hashable = public interface(Swift.Equatable) // hack for now
    property hashValue: Integer read;
  end;

  RemObjects.Elements.System.Swift.Object = public SwiftObject;
  RemObjects.Elements.System.Swift.String = public SwiftString;
  RemObjects.Elements.System.Swift.Exception = public SwiftException;

  RemObjects.Elements.System.Cocoa.Object = public CocoaObject;
  RemObjects.Elements.System.Cocoa.String = public CocoaString;
  RemObjects.Elements.System.Cocoa.Exception = public CocoaException;

  //Swift.Error = public record // hack for now
  //public
    //property localizedDescription: String read;
  //end;

  //
  // Island <-> Cocoa
  //

  CocoaWrappedIslandObject = public class(CocoaObject)
  public
    constructor(aValue: IslandObject);
    begin
      Value := aValue;
    end;

    property Value: IslandObject; readonly;

    class method FromValue(aValue: IslandObject): CocoaObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IIslandGetCocoaWrapper then exit IIslandGetCocoaWrapper(aValue).«$__CreateCocoaWrapper»();
      if aValue is IslandWrappedCocoaObject then exit IslandWrappedCocoaObject(aValue).Value;
      {$IF not WATCHOS and not TVOS}
      if aValue is IslandWrappedSwiftObject then exit CocoaWrappedSwiftObject.FromValue(IslandWrappedSwiftObject(aValue).Value);
      {$ENDIF}
      if aValue is IslandWrappedCocoaException then exit IslandWrappedCocoaException(aValue).InnerException;
      if aValue is String then exit NSString(String(aValue));
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
                                      //CocoaWrappedSwiftObject(aOther):Value,
                                      aOther));
    end;

    method compareTo(aOther: CocoaObject): NSComparisonResult;
    begin
      if Value is not IComparable then
        raise new Exception("Island Object does not implement IComparable");
      case aOther type of
        CocoaWrappedIslandObject: result := (Value as IComparable).CompareTo(CocoaWrappedIslandObject(aOther).Value) as NSComparisonResult;
        //CocoaWrappedSwiftObject: result := (Value as IComparable).CompareTo(CocoaWrappedSwiftObject(aOther).Value) as NSComparisonResult;
        else result := (Value as IComparable).CompareTo(aOther) as NSComparisonResult;
      end;
    end;
  end;

  IslandWrappedCocoaObject = public class(WrappedObject, IComparable, IEquatable)
  public

    constructor(aValue: CocoaObject);
    begin
      Value := aValue;
    end;


    property Value: CocoaObject; readonly;

    class method FromValue(aValue: CocoaObject): IslandObject;
    begin
      if aValue = nil then exit nil;
      if aValue is ICocoaGetIslandWrapper then exit ICocoaGetIslandWrapper(aValue).«$__CreateIslandWrapper»();
      if aValue is NSString then exit String(NSString(aValue));
      if aValue is CocoaWrappedIslandObject then exit CocoaWrappedIslandObject(aValue).Value;
      {$IF not WATCHOS and not TVOS}
      if aValue is CocoaWrappedSwiftObject then exit IslandWrappedSwiftObject.FromValue(CocoaWrappedSwiftObject(aValue).Value);
      {$ENDIF}
      if aValue is NSException then exit new IslandWrappedCocoaException(NSException(aValue));
      result := new IslandWrappedCocoaObject(aValue);
    end;

    method ToString: IslandString; override;
    begin
      result := Value.description as IslandString;
    end;

    method GetHashCode: Integer; override;
    begin
      result := Value.hash;
    end;

    method &Equals(aOther: IslandObject): Boolean; override;
    begin
      result := Value.isEqual(coalesce(IslandWrappedCocoaObject(aOther):Value,
                                       //IslandWrappedSwiftObject(aOther):Value,
                                       aOther));
    end;

    method CompareTo(aOther: IslandObject): Integer;
    begin
      if not Value.respondsToSelector(selector(compareTo:)) then
        raise new Exception("Cocoa Object does not implement compareTo:");
      case aOther type of
        IslandWrappedCocoaObject: begin
            //81175: Darwin: cannot call compareTo: after casting to id
            //exit id(Value).compareTo(IslandWrappedCocoaObject(aOther).Value);
          end;
        else begin
            //81175: Darwin: cannot call compareTo: after casting to id
            //exit id(Value).compareTo(aOther);
          end;
      end;
    end;

  end;

{$IF not WATCHOS and not TVOS}
  //
  // Island <-> Swift
  //

  SwiftWrappedIslandObject = public class(SwiftObject/*, Swift.CustomStringConvertible, Swift.Hashable, Swift.Equatable*/)
  private

    constructor(aValue: IslandObject);
    begin
      Value := aValue;
    end;

  public

    property Value: IslandObject; readonly;

    class method FromValue(aValue: IslandObject): SwiftObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IslandWrappedSwiftObject then exit IslandWrappedSwiftObject(aValue).Value;
      if aValue is IslandWrappedCocoaObject then exit SwiftWrappedCocoaObject.FromValue(IslandWrappedCocoaObject(aValue).Value);
      exit new SwiftWrappedIslandObject(aValue);
    end;

    property description: SwiftString read Value.ToString() as SwiftString;
    property hashValue: Integer read Value.GetHashCode;

    //method isEqual(aOther: SwiftObject): Boolean;
    //begin
      //result := Value.Equals(coalesce(SwiftWrappedIslandObject(aOther):Value,
                                      //CocoaWrappedIslandObject(aOther):Value,
                                      //aOther));
    //end;

    //method compareTo(aOther: SwiftObject): NSComparisonResult; //override;
    //begin
      //if Value is not IComparable then
        //raise new Exception("Island Object does not implement IComparable");
      //case aOther type of
        //SwiftWrappedIslandObject: result := (Value as IComparable).CompareTo(SwiftWrappedIslandObject(aOther).Value) as NSComparisonResult;
        //SwiftWrappedCocoaObject: result := (Value as IComparable).CompareTo(SwiftWrappedCocoaObject(aOther).Value) as NSComparisonResult;
        //else result := (Value as IComparable).CompareTo(aOther) as NSComparisonResult;
      //end;
    //end;
  end;

  IslandWrappedSwiftObject = public class(WrappedObject/*, IComparable, IEquatable*/)
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
      if aValue is SwiftWrappedIslandObject then exit SwiftWrappedIslandObject(aValue).Value;
      if aValue is SwiftWrappedCocoaObject then exit IslandWrappedCocoaObject.FromValue(SwiftWrappedCocoaObject(aValue).Value);
      result := new IslandWrappedSwiftObject(aValue);
    end;

    method ToString: IslandString; override;
    begin
      //result := coalesce(Swift.CustomStringConvertible(Value):description, Value.GetMetaClass.ToString) as IslandString;
      result := coalesce(Swift.CustomStringConvertible(Value):description, Value.GetType.ToString) as IslandString;
    end;

    method GetHashCode: Integer; override;
    begin
      result := coalesce(Swift.Hashable(Value):hashValue, 0);
    end;

    //method &Equals(aOther: IslandObject): Boolean; override;
    //begin
      //result := Swift.Equatable(Value):isEqual(coalesce(IslandWrappedSwiftObject(aOther):Value,
                                                        //IslandWrappedCocoaObject(aOther):Value,
                                                        //aOther));
    //end;

    //method CompareTo(aOther: IslandObject): Integer;
    //begin
      //if Value is not Swift.Comparable then
        //raise new Exception("Swift Object does not implement Comparable");

      //raise new Exception("Can not compare Swift objects yet.");
      ////case type aOther of
        ////IslandWrappedSwiftObject: begin
            //////todo: need to figure out how this will work opn Swift objects
          ////end;
        ////IslandWrappedCocoaObject: begin
            //////todo: need to figure out how this will work opn Swift objects
        ////else begin
            //////todo: need to figure out how this will work opn Swift objects
          ////end;
      ////end;
    //end;

  end;

  //
  // Cocoa <-> Swift
  //

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