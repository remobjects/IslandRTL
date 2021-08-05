namespace RemObjects.Elements.WebAssembly;

property &Global: dynamic read RemObjects.Elements.System.WebAssembly.Global;

method Eval(s: String): dynamic;
begin
  exit RemObjects.Elements.System.WebAssembly.Eval(s);
end;

type
  [Obsolete("Please use RemObjects.Elements.WebAssembly.Browser instead")]
  RemObjects.Elements.System.Browser = public RemObjects.Elements.WebAssembly.Browser;

  Browser = public static class
  public
    class method GetElementById(id: String): RemObjects.Elements.WebAssembly.DOM.Element;
    begin
      var lRes := WebAssemblyCalls.GetElementById(id);
      if lRes = 0 then exit nil;
      exit new EcmaScriptObject(lRes) as RemObjects.Elements.WebAssembly.DOM.Element;
    end;

    class method GetElementByName(id: String):RemObjects.Elements.WebAssembly.DOM.Element;
    begin
      var lRes := WebAssemblyCalls.GetElementByName(id);
      if lRes = 0 then exit nil;
      exit new EcmaScriptObject(lRes) as RemObjects.Elements.WebAssembly.DOM.Element;
    end;

    class method CreateElement(aName: String): RemObjects.Elements.WebAssembly.DOM.Element;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.CreateElement(aName)) as RemObjects.Elements.WebAssembly.DOM.Element;
    end;

    class method CreateTextNode(aName: String): RemObjects.Elements.WebAssembly.DOM.Node;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.CreateTextNode(aName)) as RemObjects.Elements.WebAssembly.DOM.Node;
    end;

    class method GetWindowObject: RemObjects.Elements.WebAssembly.DOM.Window;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.GetWindowObject) as RemObjects.Elements.WebAssembly.DOM.Window;
    end;

    class property Url: String read Browser.GetWindowObject().location.href;

    class method AjaxRequest(aUrl: String): String;
    begin
      exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.AjaxRequest(@aUrl.fFirstChar, aUrl.Length));
    end;

    class method AjaxRequestBinary(aUrl: String): array of Byte;
    begin
      var lArray := WebAssemblyCalls.AjaxRequestBinary(@aUrl.fFirstChar, aUrl.Length);
      var lTotal := WebAssemblyCalls.GetStringLength(lArray);
      result := new Byte[lTotal];
      WebAssemblyCalls.ResponseBinaryTextToArray(lArray, @result[0]);
    end;

    class method NewXMLHttpRequest: RemObjects.Elements.WebAssembly.DOM.XMLHttpRequest;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_XMLHttpRequest()) as RemObjects.Elements.WebAssembly.DOM.XMLHttpRequest;
    end;

    class method NewWebSocket(s: String): RemObjects.Elements.WebAssembly.DOM.WebSocket;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.New_WebSocket(s)) as RemObjects.Elements.WebAssembly.DOM.WebSocket;
    end;

  end;

end.