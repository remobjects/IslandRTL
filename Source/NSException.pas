namespace RemObjects.Elements.System;

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

  CocoaException = public class(Exception)
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

end.