namespace RemObjects.Elements.WebAssembly;

property &Global: dynamic read RemObjects.Elements.System.WebAssembly.Global;

type
  [Obsolete("Please use RemObjects.Elements.WebAssembly.Browser instead")]
  RemObjects.Elements.WebAssembly.System.Browser = public RemObjects.Elements.WebAssembly.Browser;

  Browser = public static class
  public
    class method GetElementById(id: String): dynamic;//<RemObjects.Elements.WebAssembly.DOM.Element>;
    begin
      var lRes := WebAssemblyCalls.GetElementById(id);
      if lRes = 0 then exit nil;
      exit new EcmaScriptObject(lRes) as dynamic;//<RemObjects.Elements.WebAssembly.DOM.Element>;
    end;

    class method GetElementByName(id: String): dynamic;//<RemObjects.Elements.WebAssembly.DOM.Element>;
    begin
      var lRes := WebAssemblyCalls.GetElementByName(id);
      if lRes = 0 then exit nil;
      exit new EcmaScriptObject(lRes) as dynamic;//<RemObjects.Elements.WebAssembly.DOM.Element>;
    end;

    class method CreateElement(aName: String): dynamic;//<RemObjects.Elements.WebAssembly.DOM.Element>;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.CreateElement(aName)) as dynamic;//<RemObjects.Elements.WebAssembly.DOM.Element>;
    end;

    class method CreateTextNode(aName: String): dynamic;//<RemObjects.Elements.WebAssembly.DOM.Node>;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.CreateTextNode(aName)) as dynamic;//<RemObjects.Elements.WebAssembly.DOM.Node>;
    end;

    class method GetWindowObject: RemObjects.Elements.WebAssembly.DOM.Window;
    begin
      exit new EcmaScriptObject(WebAssemblyCalls.GetWindowObject) as RemObjects.Elements.WebAssembly.DOM.Window;
    end;

    class method AjaxRequest(url: String): String;
    begin
      exit WebAssembly.GetStringFromHandle(WebAssemblyCalls.AjaxRequest(@url.fFirstChar, url.Length));
    end;

    class method AjaxRequestBinary(url: String): array of Byte;
    begin
      var lArray := WebAssemblyCalls.AjaxRequestBinary(@url.fFirstChar, url.Length);
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

    // Auto-generated


    // Auto-generated end

  end;

end.