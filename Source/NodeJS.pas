namespace RemObjects.Elements.WebAssembly;

type
  [Obsolete("Please use RemObjects.Elements.WebAssembly.NodeJS instead")]
  RemObjects.Elements.System.Node = public RemObjects.Elements.WebAssembly.NodeJS;

  RemObjects.Elements.WebAssembly.NodeJS = public static class
  public
    class method &require(aModule: String): dynamic;
    begin
      exit WebAssembly.GetObjectForHandle(WebAssemblyCalls.Require(aModule));
    end;

    class method NewTextEncoder: dynamic;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_TextEncoder());
    end;

    class method NewTextDecoder: dynamic;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_TextDecoder(''));
    end;

    class method NewTextDecoder(aEncoding: String): dynamic;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_TextDecoder(aEncoding));
    end;

    class method NewURL(aInput: String): dynamic;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_URL(aInput, ''));
    end;

    class method NewURL(aInput: String; aBase: String): dynamic;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_URL(aInput, aBase));
    end;

    //class property __dirname: dynamic read WebAssembly.Global.__dirname;
    //class property __filename: dynamic read WebAssembly.Global.__filename;
    class property Buffer: dynamic read WebAssembly.Global.Buffer;
    class property console: dynamic read WebAssembly.Global.console;
    class property exports: dynamic read WebAssembly.Global.exports;
    class property &module: dynamic read WebAssembly.Global.module;
    class property process: dynamic read WebAssembly.Global.process;
    class property &global: dynamic read WebAssembly.Global.global;
  end;

end.