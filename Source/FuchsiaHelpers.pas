namespace RemObjects.Elements.System;

interface

type
  ExternalCalls = public static class
  private
  public
    //[SymbolName('__elements_init'), Used]
    //method init(_nargs: Integer; _args: ^^AnsiChar; _envp: ^^AnsiChar): Integer;
    //[SymbolName('__elements_fini'), Used, GlobalDestructor(0)]
    //method fini;

    [SymbolName('ElementsRaiseException')]
    method RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);

    class var nargs: Integer;
    class var args: ^^AnsiChar;
    class var envp: ^^AnsiChar;
  end;

  ElementsException = public record
  public
    //Unwind: rtl.__struct__Unwind_Exception;
    {$WARNING ElementsException is not implemented for Fuchsia, yet.}
    Object: Object;
  end;

[SymbolName('__elements_entry_point')]
method UserEntryPoint(aArgs: array of String): Integer; external;

method CheckForIOError(value: Integer);
method CheckForLastError(aMessage: String := '');

method malloc(size: NativeInt): ^Void; inline;
begin
  exit rtl.malloc(size);
end;

method realloc(ptr: ^Void; size: NativeInt): ^Void;inline;
begin
  exit rtl.realloc(ptr, size);
end;

method free(v: ^Void);inline;
begin
  rtl.free(v);
end;

implementation

method ExternalCalls.RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);
begin
  var lRecord := ^ElementsException(malloc(sizeOf(ElementsException))); // we use gc memory for this
  rtl.memset(lRecord, 0, sizeOf(ElementsException));
  var lExp := Exception(aRaiseObject);
  if lExp <> nil then
    lExp.ExceptionAddress := aRaiseAddress;

  {$WARNING Not Implememnted for Fuchsia yet}
  //^UInt64(@lRecord^.Unwind.exception_class)^ := ElementsExceptionCode;
  //lRecord^.Object := aRaiseObject;
  //// No need to set anything, we use a GC so no cleanup needed
  //rtl._Unwind_RaiseException(@lRecord^.Unwind);
  //writeLn('Uncaught exception: '+coalesce(aRaiseObject:ToString(), "(null)"));
  rtl.exit(-1);
end;

method CheckForIOError(value: Integer);
begin
  if value = 0 then exit;
  CheckForLastError();
end;

method CheckForLastError(aMessage: String := '');
begin
  var code := rtl.errno;
  if code <> 0 then begin
    var mes := (if aMessage <> '' then  aMessage + ', ' else '')+'errno is '+code.ToString;
    raise new Exception(mes);
  end;
end;

method Entrypoint(argc: Integer; argv: ^^AnsiChar; _envp: ^^AnsiChar): Integer;
begin
  ExternalCalls.nargs := argc;
  ExternalCalls.args := argv;
  ExternalCalls.envp := _envp;
  Utilities.Initialize;
  var lArgs := new String[argc - 1];
  for i: Integer := 1 to argc - 1 do
    lArgs[i - 1] := String.FromPAnsiChars(argv[i]);
  try
    exit UserEntryPoint(lArgs);
    {$HIDE H14}
    {$WARNING Not Implememnted for Fuchsia yet}
    //ExternalCalls.libc_main(nil, 0, nil, nil, nil); // do not remove, this is there to ensure it's linked in.
    {$SHOW H14}
  except
    on E: RuntimeException do begin
      writeLn(E.Message);
      Environment.Exit(E.Code);
    end;
    on E: Exception do begin
      writeLn('Uncaught exception: '+coalesce(E.ToString(), "(null)"));
      Environment.Exit(-1);
    end;
  end;
end;


end.