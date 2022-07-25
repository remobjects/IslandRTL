namespace RemObjects.Elements.System;

{$IF DELPHI}

type
  DelphiObject = public /*Delphi.System.TObject*/Object;
  DelphiString = public /*Delphi.System.*/String;
  DelphiException = public /*Delphi.System.*/Exception;

  RemObjects.Elements.System.Delphi.Object = public DelphiObject;
  RemObjects.Elements.System.Delphi.String = public DelphiString;
  RemObjects.Elements.System.Delphi.Exception = public DelphiException;

  [Island]
  IIslandGetDelphiWrapper = public interface
    method «$__CreateDelphiWrapper»: DelphiObject;
  end;

  //[Delphi]
  IDelphiGetIslandWrapper = public interface
    method «$__CreateIslandWrapper»: RemObjects.Elements.System.Object;
  end;

  DelphiWrappedIslandObject = public class(DelphiObject)
  public
    constructor(aValue: IslandObject);
    begin
      Value := aValue;
    end;

    property Value: IslandObject; readonly;

    class method FromValue(aValue: IslandObject): DelphiObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IIslandGetDelphiWrapper then exit IIslandGetDelphiWrapper(aValue).«$__CreateDelphiWrapper»();
      if aValue is IslandWrappedDelphiObject then exit IslandWrappedDelphiObject(aValue).Value;
      if aValue is IslandWrappedDelphiException then exit IslandWrappedDelphiException(aValue).InnerException;
      if aValue is String then exit DelphiString(String(aValue));
      exit new DelphiWrappedIslandObject(aValue);
    end;

    //method description: DelphiString; override;
    //begin
      //result := Value.ToString() as DelphiString;
    //end;

    //method hash: NSUInteger; override;
    //begin
      //exit Value.GetHashCode;
    //end;

    //method isEqual(aOther: id): Boolean; override;
    //begin
      //result := Value.Equals(coalesce(DelphiWrappedIslandObject(aOther):Value,
                                      ////DelphiWrappedSwiftObject(aOther):Value,
                                      //aOther));
    //end;

    //method compareTo(aOther: DelphiObject): NSComparisonResult;
    //begin
      //if Value is not IComparable then
        //raise new Exception("Island Object does not implement IComparable");
      //case aOther type of
        //DelphiWrappedIslandObject: result := (Value as IComparable).CompareTo(DelphiWrappedIslandObject(aOther).Value) as NSComparisonResult;
        ////DelphiWrappedSwiftObject: result := (Value as IComparable).CompareTo(DelphiWrappedSwiftObject(aOther).Value) as NSComparisonResult;
        //else result := (Value as IComparable).CompareTo(aOther) as NSComparisonResult;
      //end;
    //end;
  end;

  IslandWrappedDelphiObject = public class(WrappedObject, IComparable, IEquatable)
  public

    constructor(aValue: DelphiObject);
    begin
      Value := aValue;
    end;


    property Value: DelphiObject; readonly;

    class method FromValue(aValue: DelphiObject): IslandObject;
    begin
      if aValue = nil then exit nil;
      if aValue is IDelphiGetIslandWrapper then exit IDelphiGetIslandWrapper(aValue).«$__CreateIslandWrapper»();
      if aValue is DelphiString then exit String(DelphiString(aValue));
      if aValue is DelphiWrappedIslandObject then exit DelphiWrappedIslandObject(aValue).Value;
      if aValue is DelphiException then exit new IslandWrappedDelphiException(DelphiException(aValue));
      result := new IslandWrappedDelphiObject(aValue);
    end;

    method ToString: IslandString; override;
    begin
      //result := Value.description as IslandString;
    end;

    method GetHashCode: Integer; override;
    begin
      //result := Value.hash;
    end;

    method &Equals(aOther: IslandObject): Boolean; override;
    begin
      //result := Value.isEqual(coalesce(IslandWrappedDelphiObject(aOther):Value,
                                       ////IslandWrappedSwiftObject(aOther):Value,
                                       //aOther));
    end;

    method CompareTo(aOther: IslandObject): Integer;
    begin
      //if not Value.respondsToSelector(selector(compareTo:)) then
        //raise new Exception("Delphi Object does not implement compareTo:");
      //case aOther type of
        //IslandWrappedDelphiObject: begin
            ////81175: Darwin: cannot call compareTo: after casting to id
            ////exit id(Value).compareTo(IslandWrappedDelphiObject(aOther).Value);
        //end;
        //else begin
            ////81175: Darwin: cannot call compareTo: after casting to id
            ////exit id(Value).compareTo(aOther);
        //end;
      //end;
    end;

  end;

  IslandWrappedDelphiException = public class(IslandException)
  public

    constructor (aException: DelphiException);
    begin
      inherited constructor(aException.Message);
      InnerException := aException;
    end;

    property Message: String read InnerException.Message; override;

    method ToString: String; override;
    begin
      result := "(Wrapped) "+InnerException.GetType.Name+': '+Message;
    end;

    property InnerException: DelphiException read private write; reintroduce;

  end;


  DelphiWrappedIslandException = public class(DelphiException)
  public

    constructor (aException: IslandException);
    begin
      inherited constructor(aException.Message);
      InnerException := aException;
    end;

    [ToString]
    method ToString: String; override;
    begin
      result := "(Wrapped) "+InnerException.GetType.Name+': '+Message;
    end;

    property InnerException: IslandException read private write; reintroduce;

  end;
{$ENDIF DELPHI}

end.