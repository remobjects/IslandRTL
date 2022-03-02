namespace RemObjects.Elements.System;

type
  {$IF DARWIN}
  ImmutableList_Cocoa<T> = public extension class(ImmutableList<T>) where T is CocoaObject;
  public

    constructor(aArray: Foundation.NSArray<T>);
    begin
      constructor(aArray.count);
      for i: Integer := 0 to aArray.count-1 do
        PrivateAdd(aArray[i]);
    end;

    operator Explicit(aArray: Foundation.NSArray<T>): ImmutableList<T>;
    begin
      result := new ImmutableList<T>(aArray);
    end;

  end;

  List_Cocoa<T> = public extension class(List<T>) where T is CocoaObject;
  public

    constructor(aArray: Foundation.NSArray<T>);
    begin
      inherited constructor(aArray);
    end;

    operator Explicit(aArray: Foundation.NSMutableArray<T>): List<T>;
    begin
      result := new List<T>(aArray);
    end;

  end;
  {$ENDIF}

end.