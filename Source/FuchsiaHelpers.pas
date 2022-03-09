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

    class var nargs: Integer;
    class var args: ^^AnsiChar;
    class var envp: ^^AnsiChar;
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

method CheckForIOError(value: Integer);
begin
  {$WARNING Not Implememnted for Fuchsia yet}
end;

method CheckForLastError(aMessage: String := '');
begin
  {$WARNING Not Implememnted for Fuchsia yet}
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
    {$IF NOT EMSCRIPTEN AND NOT ANDROID and not DARWIN}
    {$HIDE H14}
    {$WARNING Not Implememnted for Fuchsia yet}
    //ExternalCalls.libc_main(nil, 0, nil, nil, nil); // do not remove, this is there to ensure it's linked in.
    {$SHOW H14}
    {$ENDIF}
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