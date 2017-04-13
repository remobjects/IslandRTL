namespace RemObjects.Elements.System;

type
  Exception = public class(Object)
  private
    fMessage: String;
  public
    constructor(aMessage: String);
    begin
      fMessage := aMessage;
    end;

    property ExceptionAddress: ^Void read assembly write;

    property Message: String read fMessage; virtual;
    method ToString: String; override;
    begin
      exit self.GetType().Name+': '+Message;
    end;

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
  end;

  NotSupportedException = public class (Exception)
  public
    constructor;
    begin
      inherited constructor('Not supported');
    end;
  end;

  NullReferenceException = public class (Exception)
  public
    constructor;
    begin
      inherited constructor('Member access on null reference');
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
  end;

  IndexOutOfRangeException = public class(Exception)
  end;

end.