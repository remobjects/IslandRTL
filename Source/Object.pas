namespace RemObjects.Elements.System;

type
  &Object = public class
  assembly
  public
    constructor; empty;

    [SymbolName('__default_finalize'), Warning("Do not call this method directly, it will be called by the Finalizer")]
    method &Finalize; virtual; assembly or protected; empty; // DO NOT MOVE THIS!, IT HAS TO BE IN THE FIRST SLOT!

    method ToString: String; virtual;
    begin
      exit '<'+GetHashCode.ToString()+'>';
    end;

    method GetHashCode: Integer; virtual;
    begin
      exit Integer(InternalCalls.Cast(self));
    end;

    method GetType: &Type;
    begin
      result := new &Type(^^IslandTypeInfo(InternalCalls.Cast(self))^);
    end;

    method &Equals(aOther: Object): Boolean; virtual;
    begin
      exit Object.ReferenceEquals(Self, aOther);
    end;

    class method ReferenceEquals(a, b: Object): Boolean;
    begin
      exit a = b;
    end;

    {$IF DARWIN}
    class operator Implicit(aValue: nullable Object): nullable Foundation.NSObject;
    begin
      result := IslandToCocoaBridge.FromValue(aValue);
    end;

    class operator Explicit(aValue: nullable Object): nullable Foundation.NSObject;
    begin
      result := IslandToCocoaBridge.FromValue(aValue);
    end;

    class operator Implicit(aValue: nullable Foundation.NSObject): nullable Object;
    begin
      result := CocoaToIslandBridge.FromValue(aValue);
    end;

    class operator Explicit(aValue: nullable Foundation.NSObject): nullable Object;
    begin
      result := CocoaToIslandBridge.FromValue(aValue);
    end;
    {$ENDIF}
  end;

end.