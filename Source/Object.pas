namespace RemObjects.Elements.System;

interface

type
  &Object = public class
  assembly
  public
    constructor; empty;
    [SymbolName('__default_finalize'), Warning('Do not call this method directly, it''s called by the finalizer')]
    method &Finalize; virtual; assembly or protected; empty; // DO NOT MOVE THIS!, IT HAS TO BE IN THE FIRST SLOT!
    method ToString: String; virtual;
    method GetHashCode: Integer; virtual;
    method GetType: &Type;
    method &Equals(obj: Object): Boolean; virtual;
    class method ReferenceEquals(a,b: Object): Boolean;
  end;

implementation

{ Object }

method Object.ToString: String;
begin
  exit '<'+GetHashCode.ToString()+'>';
end;

method Object.GetHashCode: Integer;
begin
  exit Integer(InternalCalls.Cast(self));
end;

class method Object.ReferenceEquals(a,b: Object): Boolean;
begin
  exit a = b;
end;

method Object.Equals(obj: Object): Boolean;
begin
  Object.ReferenceEquals(Self,obj);
end;

method Object.GetType: &Type;
begin
  result := new &Type(^^IslandTypeInfo(InternalCalls.Cast(self))^);
end;

end.