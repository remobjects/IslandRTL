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