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
      exit $"<{GetType().Name} {Integer(InternalCalls.Cast(self)).ToString.PadStart(if defined("CPU64") then 16 else 8, '0')}>";
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

  end;

end.