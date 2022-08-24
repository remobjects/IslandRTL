namespace RemObjects.Elements.System;

{$IF DARWIN}

type
  SwiftException = public Foundation.NSException; // hack for now

  RemObjects.Elements.System.Swift.Object = public SwiftObject;
  RemObjects.Elements.System.Swift.String = public SwiftString;
  RemObjects.Elements.System.Swift.Exception = public SwiftException;

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


  //Swift.Error = public record // hack for now
  //public
    //property localizedDescription: String read;
  //end;

  {$IF not WATCHOS and not TVOS}
  //
  // Island <-> Swift
  //

  //[Swift]
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

  {$ENDIF}

{$ENDIF}

end.