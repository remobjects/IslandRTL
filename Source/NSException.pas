namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

type
  NSException_Darwin = public extension class(NSException)
  public

    constructor(aMessage: String);
    begin
      var lClass := self.class.description; // Can't be inlined as self is set to nil during the init call.
      result := self.initWithName(lClass) reason(aMessage) userInfo(nil);
    end;

    property Message: String read description;

    property CallStack: ImmutableList<String> read new ImmutableList<String>(callstackSymbols.GetSequence().Cast<String>); // E48 There are no overloads that have 1 generic parameters // E48 There are no overloads that have 1 generic parameters
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

    property InnerException: NSException read private write;

  end;

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

  //SwiftException = public class(IslandException)
  //private

    //var fError: Swift.Error;

  //public

    //constructor (aError: Swift.Error);
    //begin
      //inherited constructor(aError.localizedDescription);
      //fError := aError;
    //end;

    //property InnerError: Swift.Error read fError;

  //end;

{$ENDIF}

end.