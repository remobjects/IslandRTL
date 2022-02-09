﻿namespace Island.Shared;

type
  ImmutableList_Island<T> = public extension class(ImmutableList<T>) where T is IslandObject;
  private
  end;

  ImmutableList_Cocoa<T> = public extension class(ImmutableList<T>) where T is CocoaObject;
  public

    {$IF DARWIN}
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
    {$ENDIF}

  end;

end.