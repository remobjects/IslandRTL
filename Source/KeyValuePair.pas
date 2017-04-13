namespace RemObjects.Elements.System;

interface

type
  KeyValuePair<T, U> = public class
  where T is Object, U is Object;
  public
    constructor(aKey: T; aValue: U);
    method &Equals(obj: Object): Boolean; override;
    method ToString: String; override;
    method GetHashCode: Integer;override;

    property Key: T read write; readonly;
    property Value: U read write; readonly;
  end;

implementation

constructor KeyValuePair<T,U>(aKey: T; aValue: U);
begin
  if aKey = nil then
    raise new Exception("Key should be specified");

  Key := aKey;
  Value := aValue;
end;

method KeyValuePair<T,U>.GetHashCode: Integer;
begin
  exit Key.GetHashCode + if Value = nil then 0 else Value.GetHashCode;
end;

method KeyValuePair<T,U>.ToString: String;
begin
  exit "Key: "+Key.ToString+" Value: "+ if Value = nil then "<nil>" else Value.ToString;
end;

method KeyValuePair<T,U>.Equals(obj: Object): Boolean;
begin
  if obj = nil then
    exit false;

  if not (obj is KeyValuePair<T,U>) then
    exit false;

  var Item := KeyValuePair<T, U>(obj);
  exit Key.Equals(Item.Key) and ( ((Value = nil) and (Item.Value = nil)) or ((Value <> nil) and Value.Equals(Item.Value)));
end;

end.