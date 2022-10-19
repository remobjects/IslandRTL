namespace RemObjects.Elements.System;

type
  ForeignExceptionImplementation = public class
  public
    constructor(aCode: UInt64; aHandler: Func<^Void, Exception>; aFree: Action<^Void>);
    begin
      Code := aCode;
      Handler := aHandler;
      Free := aFree;
    end;

    property Code: UInt64; readonly;
    property Handler: Func<^Void, Exception>; readonly;
    property Free: Action<^Void>; readonly;

    class method Register(aRecord: ForeignExceptionImplementation);
    begin
      locking fLock do begin
        fLookup[aRecord.Code] := aRecord;
      end;
    end;

    class var fLock: Monitor := new Monitor(); private;
    class var fLookup: Dictionary<UInt64, ForeignExceptionImplementation> := new Dictionary<UInt64, ForeignExceptionImplementation>; private;

    class method CanHandle(aCode: UInt64): Boolean;
    begin
      exit fLookup.ContainsKey(aCode);
    end;

    class method Handle(aCode: UInt64; aVal: ^Void): Exception;
    begin
      exit fLookup[aCode].Handler(aVal);
    end;

    class method Free(aCode: UInt64; aVal: ^Void);
    begin
      fLookup[aCode].Free:Invoke(aVal);
    end;
  end;

  Exception = public class(Object)
  private
    fMessage: not nullable String;
    fInnerException: nullable Exception;
    property DefaultExceptionMessage: not nullable String read $"An Exception of type '{typeOf(self).Name}' was thrown.";
  public
    constructor;
    begin
      fMessage := DefaultExceptionMessage;
    end;

    constructor(aMessage: not nullable String);
    begin
      fMessage := aMessage;
    end;

    constructor(aMessage: not nullable String; aException: not nullable Exception);
    begin
      fMessage := aMessage;
      fInnerException := aException;
    end;

    property ExceptionAddress: ^Void read assembly write;

    property Message: not nullable String read fMessage; virtual;
    property InnerException: nullable Exception read fInnerException; virtual;

    method ToString: String; override;
    begin
      result := self.GetType().Name+': '+Message;
      if assigned(fInnerException) then
        result := result+Environment.NewLine+Environment.NewLine+fInnerException.ToString;
    end;
  end;

  RuntimeException = public class(Exception)
  private
    fCode: Cardinal;
  public
    constructor(aCode: Cardinal);
    begin
      inherited constructor('Runtime Error: '+aCode.ToString);
      fCode := aCode;
    end;

    property Code: Cardinal read fCode;
  end;

  WindowsException = public class(Exception)
  private
    fCode: Cardinal;
  public
    constructor(aCode: Cardinal);
    begin
      inherited constructor('Windows Exception: '+aCode.ToString);
      fCode := aCode;
    end;

    property Code: Cardinal read fCode;
  end;

  AccessViolationException = public class(WindowsException)
  public
    constructor;
    begin
      inherited constructor($C0000005);
    end;
  end;

  AssertionException = public class(Exception)
  end;

  NotImplementedException = public class (Exception)
  public
    constructor;
    begin
      inherited constructor('Not implemented');
    end;

    constructor (aMessage: not nullable String);
    begin
      inherited constructor(aMessage);
    end;
  end;

  NotSupportedException = public class (Exception)
  public
    constructor;
    begin
      inherited constructor('Not supported');
    end;

    constructor (aMessage: not nullable String);
    begin
      inherited constructor(aMessage);
    end;
  end;

  NullReferenceException = public class (Exception)
  public
    constructor;
    begin
      inherited constructor('Member access on null reference');
    end;

    constructor(s: String);
    begin
      inherited constructor(if s = nil then 'Member access on null reference' else 'Null Reference Exception for expression: '+s);
    end;
  end;

  InvalidCastException = public class(Exception)
  private
  public
  end;

  AbstractMethodException = public class(Exception)
  public
    constructor;
    begin
      inherited constructor('Abstract method');
    end;
  end;

  DivideByZeroException = public class(Exception)
  public
    constructor;
    begin
      inherited constructor('Divide by zero');
    end;
  end;

  FormatException = public class(Exception)
  end;

  OverflowException = public class(Exception)
  end;

  ArgumentNullException = public class(Exception)
  end;

  ArgumentOutOfRangeException = public class(Exception)
  end;

  ArgumentException = public class(Exception)
  public
    constructor(aMessage: not nullable String); empty;

    constructor(aMessage: not nullable String; aException: not nullable Exception); empty;

    constructor(aMessage: not nullable String; aParamName: String);
    begin
      ParamName := aParamName;
    end;

    constructor(aMessage: not nullable String; aParamName: String; aException: not nullable Exception);
    begin
      constructor(aMessage, aException);
      ParamName := aParamName;
    end;

    property ParamName: nullable String; readonly;
  end;

  IndexOutOfRangeException = public class(Exception)
  end;

  InvalidStateException = public class(Exception)
  end;

  LibraryNotFoundException = public class(Exception)
  end;

  EntrypointNotFoundException = public class(Exception)
  end;

end.