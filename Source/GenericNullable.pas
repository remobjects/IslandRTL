namespace RemObjects.Elements.System;


type
  [TransparentType]
  GenericNullable<T> = public record
  private
    method get_Value: T;
    begin
      if fHasValue then exit fValue;
      raise new NullReferenceException('Nullable value is nil');
    end;
    fValue: T;
    fHasValue: Boolean;
  public
    constructor(aValue: T);
    begin
      fHasValue := aValue <> nil;
      fValue := aValue;
    end;
    property HasValue: Boolean read fHasValue;
    property Value: T read get_Value;

    method GetValueOrDefault: T;
    begin
      if fHasValue then
        exit fValue
      else
        exit &default(T);
    end;

    method GetValueOrDefault(aDefault: T): T;
    begin
      if fHasValue then
        exit fValue
      else
        exit aDefault;
    end;

    class operator IsNil(aVal: GenericNullable<T>): Boolean;
    begin
      exit not aVal.fHasValue;
    end;

    class operator Box(aVal: GenericNullable<T>): Object;
    begin
      if aVal.fHasValue then
        exit aVal.fValue;
      exit nil;
    end;

    class operator Unbox(aVal: Object): GenericNullable<T>;
    begin
      if aVal = nil then
        exit default(GenericNullable<T>);
      exit new GenericNullable<T>(aVal as T);
    end;

    class operator implicit(aVal: GenericNullable<T>): T;
    begin
      exit aVal.Value;
    end;

    class operator implicit(aVal: T): GenericNullable<T>;
    begin
      if aVal = nil then
        exit default(GenericNullable<T>);
      exit new GenericNullable<T>(aVal as T);
    end;
  end;

end.