namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  CocoaObject = public Foundation.NSObject;
  CocoaString = public Foundation.NSString;
  CocoaException = public Foundation.NSException;

  RemObjects.Elements.System.Cocoa.Object = public CocoaObject;
  RemObjects.Elements.System.Cocoa.String = public CocoaString;
  RemObjects.Elements.System.Cocoa.Exception = public CocoaException;

  //
  // Island <-> Cocoa
  //

  [Island]
  IIslandGetCocoaWrapper = public interface
    method «$__CreateCocoaWrapper»: CocoaObject;
  end;

  [Cocoa]
  ICocoaGetIslandWrapper = public interface
    method «$__CreateIslandWrapper»: RemObjects.Elements.System.Object;
  end;

  [Cocoa]
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
      if aValue is String then exit CocoaString(String(aValue));
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
      if aValue is CocoaString then exit String(CocoaString(aValue));
      if aValue is CocoaWrappedIslandObject then exit CocoaWrappedIslandObject(aValue).Value;
      {$IF not WATCHOS and not TVOS}
      if aValue is CocoaWrappedSwiftObject then exit IslandWrappedSwiftObject.FromValue(CocoaWrappedSwiftObject(aValue).Value);
      {$ENDIF}
      if aValue is CocoaException then exit new IslandWrappedCocoaException(CocoaException(aValue));
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

  IslandWrappedCocoaException = public class(IslandException)
  public

    constructor (aException: CocoaException);
    begin
      inherited constructor(aException.reason);
      InnerException := aException;
    end;

    property Message: String read begin
      result := if length(InnerException.name) > 0 then
        InnerException.name+": "+InnerException.reason
      else
        InnerException.reason;
    end; override;

    method ToString: String; override;
    begin
      result := "(Wrapped) "+InnerException.class.description+': '+Message;
    end;

    property InnerException: CocoaException read private write; reintroduce;

  end;

  [Cocoa]
  CocoaWrappedIslandException = public class(CocoaException)
  public

    constructor (aException: IslandException);
    begin
      inherited constructor withName(aException.GetType.Name) reason(aException.Message) userInfo(nil);
      InnerException := aException;
    end;

    [ToString]
    method ToString: String; override;
    begin
      result := "(Wrapped) "+InnerException.GetType.Name+': '+Message;
    end;

    property InnerException: IslandException read private write;

  end;

{$ENDIF}

end.