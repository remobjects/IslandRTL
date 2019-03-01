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

    //property CallStack: List<String> read new List<String>(callstackSymbols);
  end;

  CocoaException = public class(IslandException)
  private

    var fException: NSException;

  public

    constructor (aException: NSException);
    begin
      inherited constructor(aException.reason);
      fException := aException;
    end;

    property InnerException: NSException read fException;

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