namespace RemObjects.Elements.System;

  [assembly:AssemblyDefineAttribute('WebAssembly')]
  [assembly:AssemblyDefineAttribute('CPU32')]
  [assembly:AssemblyDefineAttribute('NOTHREADS')]

type
  WebAssemblyCalls = public static class
  public
    [DllImport(''), SymbolName('__island_consolelogint')]
    class method ConsoleLog(val: Integer); external;

    [DllImport(''), SymbolName('__island_consolelog')]
    class method ConsoleLog(s: ^Char; len: Integer); external;

    [DllImport(''), SymbolName('__island_getutctime')]
    class method GetUTCTime: Double; external;

    [DllImport(''), SymbolName('__island_getlocaltime')]
    class method GetLocalTime: Double; external;

    [DllImport(''), SymbolName('__island_get_os_name')]
    class method GetOSName: Int32; external;

    [DllImport(''), SymbolName('__island_get_string_length')]
    class method GetStringLength(handle: Int32): Int32; external;

    [DllImport(''), SymbolName('__island_get_string_data')]
    class method GetStringData(handle: Int32; target: ^Char): Int32; external;

    [DllImport(''), SymbolName('__island_free_handle')]
    class method FreeHandle(handle: Int32); external;

    [DllImport(''), SymbolName('__island_crypto_safe_random')]
    class method CryptoSafeRandom(target: ^Byte; len: Integer); external;

    [DllImport(''), SymbolName('__island_to_lower')]
    class method ToLower(val: ^Char; data: Integer; aInvariant: Boolean): Integer; external;

    [DllImport(''), SymbolName('__island_to_upper')]
    class method Toupper(val: ^Char; data: Integer; aInvariant: Boolean): Integer; external;

    [DllImport(''), SymbolName('llvm.wasm.grow.memory')]
    class method GrowMemory(aSize: Integer): Integer; external;

    [DllImport(''), SymbolName('__island_eval')]
    class method Eval(aVal: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_get_typeof')]
    class method GetTypeOf(aHandle: IntPtr): WebassemblyType; external;

    [DllImport(''), SymbolName('__island_get_intvalue')]
    class method GetIntValue(aHandle: IntPtr): Int32; external;

    [DllImport(''), SymbolName('__island_get_doublevalue')]
    class method GetDoubleValue(aHandle: IntPtr): Double; external;

    [DllImport(''), SymbolName('__island_from_intvalue')]
    class method CreateInteger(aVal: Integer): IntPtr; external;

    [DllImport(''), SymbolName('__island_from_doublevalue')]
    class method CreateDouble(aVal: Double): IntPtr; external;

    [DllImport(''), SymbolName('__island_from_boolvalue')]
    class method CreateBoolean(aVal: Boolean): IntPtr; external;

    [DllImport(''), SymbolName('__island_from_stringvalue')]
    class method CreateString(aVal: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_from_funcvalue')]
    class method CreateFunc(aVal: WebAssemblyDelegate): IntPtr; external;

    [DllImport(''), SymbolName('__island_clone_handle')]
    class method CloneHandle(aHandle: IntPtr): IntPtr; external;

    [DllImport(''), SymbolName('__island_call')]
    class method Call(aSelf: IntPtr; aName: String; aArgs: ^IntPtr; aArgCount: IntPtr; aReleaseArgs: Boolean): IntPtr; external;

    [DllImport(''), SymbolName('__island_invoke')]
    class method Invoke(aPtr: IntPtr; aArgs: ^IntPtr; aArgCount: IntPtr): IntPtr; external;

    [DllImport(''), SymbolName('__island_get')]
    class method Get(aSelf: IntPtr; aName: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_getarray')]
    class method GetArray(aSelf: IntPtr; aIdx: Integer): IntPtr; external;

    [DllImport(''), SymbolName('__island_getarraylength')]
    class method ArrayLength(aSelf: IntPtr): Integer; external;

    [DllImport(''), SymbolName('__island_set')]
    class method &Set(aSelf: IntPtr; aName: String; aVal: IntPtr; aReleaseVal: Boolean): IntPtr; external;
    
    [DllImport(''), SymbolName('__island_setarray')]
    class method &Set(aSelf: IntPtr; aIdx: Integer; aVal: IntPtr; aReleaseVal: Boolean): IntPtr; external;

    [DllImport(''), SymbolName('__island_getElementById')]
    class method GetElementById(aId: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_getElementByName')]
    class method GetElementByName(aName: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_createElement')]
    class method CreateElement(aElement: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_createTextNode')]
    class method CreateTextNode(aVal: String): IntPtr; external;

    [DllImport(''), SymbolName('__island_createObject')]
    class method CreateObject: IntPtr; external;

    [DllImport(''), SymbolName('__island_createArray')]
    class method CreateArray: IntPtr; external;

    [DllImport(''), SymbolName('__island_setTimeout')]
    class method SetTimeout(del: WebAssemblyDelegate; aTimeout: Integer): IntPtr; external;

    [DllImport(''), SymbolName('__island_setInterval')]
    class method SetInterval(del: WebAssemblyDelegate; aTimeout: Integer): IntPtr; external;

    [DllImport(''), SymbolName('__island_ClearInterval')]
    class method ClearInterval(aHandle: IntPtr); external;

    [DllImport(''), SymbolName('__island_DefineValueProperty')]
    class method DefineValueProperty(aSelf: IntPtr; aName: String; aValue: IntPtr; aFlags: EcmaScriptPropertyFlags); external;

    [DllImport(''), SymbolName('__island_DefineGetterSetterProperty')]
    class method DefineGetterSetterProperty(aSelf: IntPtr; aName: String; aGetter, aSetter: WebAssemblyDelegate; aFlags: EcmaScriptPropertyFlags); external;

    [DllImport(''), SymbolName('__island_getLocaleInfo')]
    class method GetLocaleInfo(locale: String; info: Int32): String; external;

    [DllImport(''), SymbolName('__island_getCurrentLocale')]
    class method GetCurrentLocale: String; external;
  end;

  EcmaScriptPropertyFlags = public flags (
    Enumerable = 1, 
    Configurable = 2, 
    Writable = 4,
    All = 4 or 2 or 1);

  EcmaScriptObject = public class(IDisposable)
  private 
    fHandle: IntPtr;
    method get_Items(i: Integer): Object;
    begin 
      exit WebAssembly.GetObjectForHandle(WebAssemblyCalls.GetArray(fHandle, i));
    end;
    method get_Items(i: String): Object;
    begin 
      exit WebAssembly.GetObjectForHandle(WebAssemblyCalls.Get(fHandle, i));
    end;
    method set_Items(i: Integer; aVal: Object);
    begin 
      WebAssemblyCalls.Set(fHandle, i, WebAssembly.CreateHandle(aVal), true);
    end;
    method set_Items(i: String; aVal: Object);
    begin 
      WebAssemblyCalls.Set(fHandle, i, WebAssembly.CreateHandle(aVal), true);
    end;
  public 
    constructor(aValue: IntPtr);
    begin 
      if aValue = 0 then raise new ArgumentNullException('0 not allowed');
      fHandle := aValue;
    end;

    finalizer;
    begin 
      if fHandle <> 0 then 
        WebAssemblyCalls.FreeHandle(fHandle);
    end;

    property Handle: IntPtr read fHandle;

    method Release;
    begin 
      fHandle := 0;
    end;      

    method Dispose;
    begin 
      if fHandle <> 0 then begin
        WebAssemblyCalls.FreeHandle(fHandle);
        fHandle := 0;
      end;
    end;

    class operator implicit(val: EcmaScriptObject): IntPtr;
    begin 
      if val = nil then exit 0;
      result := val.Handle;
      val.Release;
    end;


    property Items[s: String]: Object read get_Items write set_Items; default;
    property Items[i: Integer]: Object read get_Items write set_Items; default;

    method DefineProperty(aName: String; aValue: Object; aFlags: EcmaScriptPropertyFlags := EcmaScriptPropertyFlags.All);
    begin 
      WebAssemblyCalls.DefineValueProperty(fHandle, aName, WebAssembly.CreateHandle(aValue), aFlags);
    end;

    method DefineProperty(aName: String; aGet: Func<Object>; aSet: Action<Object>; aFlags: EcmaScriptPropertyFlags := EcmaScriptPropertyFlags.All);
    begin 
      var lGet, lSet: WebAssemblyDelegate;
      if assigned(aGet) then 
        lGet := a -> begin 
          var lObj := EcmaScriptObject(a[1]);
          lObj['value'] := aGet();
          lObj.Dispose;
        end;
      if assigned(aSet) then 
        lSet := a -> begin 
          var lVal := a[1];
          aSet(lVal);
          EcmaScriptObject(lVal):Dispose;
        end;
      WebAssemblyCalls.DefineGetterSetterProperty(fHandle, aName, lGet, lSet, aFlags);
    end;

    method DefineProperty(aName: String; aGet: Func<EcmaScriptObject, Object>; aSet: Action<EcmaScriptObject, Object>; aFlags: EcmaScriptPropertyFlags := EcmaScriptPropertyFlags.All);
    begin 
      var lGet, lSet: WebAssemblyDelegate;
      if assigned(aGet) then 
        lGet := a -> begin 
          var lObj := EcmaScriptObject(a[1]);
          var lSelf := new EcmaScriptObject(WebAssemblyCalls.GetArray(a.Handle, 0)); // this shouldn't be unwrapped.
          lObj['value'] := aGet(lSelf);
          lSelf.Dispose;
          lObj.Dispose;
        end;
      if assigned(aSet) then 
        lSet := a -> begin 
          var lVal := a[1];
          var lSelf := new EcmaScriptObject(WebAssemblyCalls.GetArray(a.Handle, 0)); // this shouldn't be unwrapped.
          aSet(lSelf, lVal);
          lSelf.Dispose;
          EcmaScriptObject(lVal):Dispose;
        end;
      WebAssemblyCalls.DefineGetterSetterProperty(fHandle, aName, lGet, lSet, aFlags);
    end;

    method Call(aName: String; params args: array of Object): Object;
    begin 
      var lData := new IntPtr[length(args)];
      for i: Integer := 0 to length(args) -1 do
        lData[i] := WebAssembly.CreateHandle(args[i]);
      var c := WebAssemblyCalls.Call(fHandle, aName, @lData[0], lData.Length, true);
      exit WebAssembly.GetObjectForHandle(c);
    end;

    method Call(args: array of Object): Object;
    begin 
      exit Call(nil, args);
    end;

    property Count: Integer read WebAssemblyCalls.ArrayLength(fHandle);
  end;

  WebAssemblyDelegate = public delegate (args: EcmaScriptObject);

  WebAssembly = public static class 
  private 
    fProxies: Dictionary<IntPtr, EcmaScriptObject> := new Dictionary<IntPtr, EcmaScriptObject>;

    class method GetPtrFromObject(o: EcmaScriptObject): Object;
    begin 
      exit InternalCalls.Cast<Object>(^Void(Convert.ToInt32(o['__elements_handle'])));
    end;

    class method GetProxyFor(aType: &Type): EcmaScriptObject;
    begin 
      if fProxies.TryGetValue(IntPtr(aType.RTTI), out result) then begin 
        exit;
      end;
      if aType.IsValueType then raise new ArgumentException('Value types not supported!');
      var lBase: EcmaScriptObject := if (aType.BaseType = nil) or (aType.BaseType = typeOf(Object)) then nil else GetProxyFor(aType.BaseType);
      if lBase = nil then lBase := CreateObject else lBase := EcmaScriptObject(Object.Call('create', lBase));
      for each el in aType.Properties do begin
        if el.IsStatic then continue;
        if el.Arguments.Any then continue;
        var lGet: Func<EcmaScriptObject, Object>;
        var lSet: Action<EcmaScriptObject, Object>;
        var lRM := el.ReadMethod;
        var lWM := el.WriteMethod;

        if lRM <> nil then begin
          lGet := o -> WebAssembly.InvokeMethod(lRM, [GetPtrFromObject(o)]);
        end;
        if lWM <> nil then begin 
          lSet := (o, v) -> WebAssembly.InvokeMethod(lWM, [GetPtrFromObject(o), v]);
        end;
        if (lGet <> nil)  or (lSet <> nil) then 
          lBase.DefineProperty(el.Name, lGet, lSet);
      end;
      for each el in aType.Methods do begin 
        if MethodFlags.Constructor in el.Flags then continue;
        if MethodFlags.Finalizer in el.Flags then continue;
        if MethodFlags.Operator in el.Flags then continue;
        var lMeth := el;
        var lDel: WebAssemblyDelegate := method(args: EcmaScriptObject) begin 
          var lArr := new List<Object>;
          for each lArg in lMeth.Arguments index n do 
            lArr.Add(args[n]);
          args['result'] := lMeth.Invoke(args['this'], lArr.ToArray);
        end;
        lBase[el.Name] := lDel;
      end;
      fProxies.Add(IntPtr(aType.RTTI), lBase);
      exit lBase;
    end;
  public 
    property Global: EcmaScriptObject := new EcmaScriptObject(-1); lazy;
    property Object: EcmaScriptObject := EcmaScriptObject(&Global['Object']); lazy;

    class method CreateProxy(o: Object): EcmaScriptObject;
    begin 
      if o = nil then exit nil;
      if o is EcmaScriptObject then exit EcmaScriptObject(o);
      var ov: EcmaScriptObject := GetProxyFor(o.GetType);
      var ptr := IntPtr(InternalCalls.Cast(o));
      
      SimpleGC.ForceAddRef(ptr);
      result := EcmaScriptObject(Object.Call('create', new EcmaScriptObject(WebAssemblyCalls.CloneHandle(ov.Handle))));
      result['__elements_handle'] := ptr;
    end;
    
    [SymbolName('__island_wrap'), Used, DllExport]
    class method Wrap(o: IntPtr): IntPtr; 
    // o is a handle, if it points to an elements object it gets unwrapped and returned
    // if it's an external object it gets wrapped as EcmaScriptObject
    begin 
      if o = 0 then exit 0;
      if WebAssemblyCalls.GetTypeOf(o) = WebassemblyType.String then begin
        result := IntPtr(InternalCalls.Cast(GetStringFromHandle(o)));
        WebAssemblyCalls.FreeHandle(o);
        exit;
      end;
      var lEC := new EcmaScriptObject(o);
      if lEC['__elements_handle'] <> nil then begin
        result := Convert.ToInt32(lEC['__elements_handle']);
        lEC.Dispose;
        exit;
      end;
      // We don't add a reference because ecmascriptobject is on the stack and the 
      // gc can't run before the variable is gone.
      exit IntPtr(InternalCalls.Cast(lEC));
    end;

    [SymbolName('__island_unwrap'), Used, DllExport]
    class method Unwrap(o: IntPtr): IntPtr; 
    // o is a pointer, returns either a handle ot a proxy or the handle to an ecmascriptobject.
    begin 
      if o = 0 then exit 0;
      var lRes := InternalCalls.Cast<Object>(^Void(o));
      if lRes is String then begin 
        exit WebAssemblyCalls.CreateString(String(lRes));
      end;
      if lRes is not EcmaScriptObject then 
        lRes := CreateProxy(lRes);
      result := EcmaScriptObject(lRes).Handle;
      EcmaScriptObject(lRes).Release;
    end;
    
    class method ReleaseProxy(o: EcmaScriptObject);
    begin 
      if o = nil then exit;
      if o['__elements_handle'] = nil then exit;
      var lPtr := Convert.ToInt32(o['__elements_handle']);
      if lPtr = 0 then exit;
      SimpleGC.ForceRelease(lPtr);
    end;

    class method GetObjectForHandle(aHandle: IntPtr): Object; // Note; takes ownership (and frees if needed)
    begin 
      case WebAssemblyCalls.GetTypeOf(aHandle) of 
        WebassemblyType.Undefined, WebassemblyType.Null: exit nil;
        WebassemblyType.String: result := GetStringFromHandle(aHandle);
        WebassemblyType.Number: result := WebAssemblyCalls.GetDoubleValue(aHandle);
        WebassemblyType.Boolean: result := WebAssemblyCalls.GetIntValue(aHandle);
        else begin
          result := new EcmaScriptObject(aHandle);
          var val := EcmaScriptObject(result)['__elements_handle'];
          if (val <> nil) then begin
            EcmaScriptObject(result).Dispose;
            var lHandle := Convert.ToInt32(val);
            result := InternalCalls.Cast<Object>(^Void(lHandle));
            SimpleGC.ForceRelease(lHandle);
          end;

          exit;
        end;
      end;
       WebAssemblyCalls.FreeHandle(aHandle);
    end;

    class method InvokeMethod(aPtr: ^Void; params args: array of Object): Object;
    begin 
      var lData := new IntPtr[length(args)];
      for i: Integer := 0 to length(args) -1 do
        lData[i] := WebAssembly.CreateHandle(args[i]);
      var c := WebAssemblyCalls.Invoke(IntPtr(aPtr), @lData[0], lData.Length);
      exit WebAssembly.GetObjectForHandle(c);
    end;

    class method CreateHandle(aVal: Object): IntPtr;
    begin
      if aVal = nil then exit 0;
      if aVal is EcmaScriptObject then exit WebAssemblyCalls.CloneHandle(EcmaScriptObject(aVal).Handle);
      if aVal is Integer then exit WebAssemblyCalls.CreateInteger(aVal as Integer);
      if aVal is Boolean then exit WebAssemblyCalls.CreateBoolean(aVal as Boolean);
      if aVal is Double then exit WebAssemblyCalls.CreateDouble(aVal as Double);
      if aVal is Int64 then exit WebAssemblyCalls.CreateDouble(aVal as Int64);
      if aVal is String then exit WebAssemblyCalls.CreateString(aVal as String);
      if aVal is WebAssemblyDelegate then exit WebAssemblyCalls.CreateFunc(aVal as WebAssemblyDelegate);
      var lProxy := CreateProxy(aVal);
      result := lProxy.Handle;
      lProxy.Release;
    end;

    class method Eval(s: String): Object;
    begin 
      exit GetObjectForHandle(WebAssemblyCalls.Eval(s));
    end;

    class method GetStringFromHandle(handle: Int32; aFree: Boolean := false): String;
    begin 
      if handle = 0 then exit nil;
      result := String.AllocString(WebAssemblyCalls.GetStringLength(handle));
      WebAssemblyCalls.GetStringData(handle, @result.fFirstChar);
      if aFree then 
        WebAssemblyCalls.FreeHandle(handle);
    end;

    class method GetElementById(id: String): EcmaScriptObject;
    begin 
      var lRes := WebAssemblyCalls.GetElementById(id);
      if lRes = 0 then exit nil;
      exit new EcmaScriptObject(lRes);
    end;

    class method GetElementByName(id: String): EcmaScriptObject;
    begin 
      var lRes := WebAssemblyCalls.GetElementByName(id);
      if lRes = 0 then exit nil;
      exit new EcmaScriptObject(lRes);
    end;

    class method SetTimeout(aFN: WebAssemblyDelegate; aTimeOut: Integer): Integer;
    begin 
      exit WebAssemblyCalls.SetTimeout(aFN, aTimeOut);
    end;

    class method SetInterval(aFN: WebAssemblyDelegate; aTimeOut: Integer): Integer;
    begin 
      exit WebAssemblyCalls.SetInterval(aFN, aTimeOut);
    end;

    class method ClearInterval(aVal: Integer);
    begin 
      WebAssemblyCalls.ClearInterval(aVal);
    end;

    class method CreateElement(aName: String): EcmaScriptObject;
    begin 
      exit new EcmaScriptObject(WebAssemblyCalls.CreateElement(aName));
    end;

    class method CreateTextNode(aName: String): EcmaScriptObject;
    begin 
      exit new EcmaScriptObject(WebAssemblyCalls.CreateTextNode(aName));
    end;

    class method CreateObject: EcmaScriptObject;
    begin 
      exit new EcmaScriptObject(WebAssemblyCalls.CreateObject);
    end;

    class method CreateArray: EcmaScriptObject;
    begin 
      exit new EcmaScriptObject(WebAssemblyCalls.CreateArray);
    end;
  end;

  WebassemblyType = public enum (Null, Undefined, String, Number, &Function, Symbol, Object, Boolean);
  ExternalCalls = public static class 
  private
    [SymbolName('llvm.trap')]
    class method trap; external;
  public
    [SymbolName('ElementsRaiseException'), Used, DllExport]
    method RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);
    begin 
      // Not supported atm!
      trap;
    end;

    [SymbolName('__island_call_delegate'), Used, DllExport]
    method CallDelegate(inst: WebAssemblyDelegate; aArgs: IntPtr);
    begin 
      var lEC := new EcmaScriptObject(aArgs);
      inst(lEC);
      lEC.Release;
    end;

    [SymbolName('ElementsBeginCatch')]
    method ElementsBeginCatch(obj: ^Void): ^Void;empty;

    [SymbolName('ElementsEndCatch')]
    method ElementsEndCatch;empty;
    [SymbolName('ElementsGetExceptionForEHData')]
    method GetExceptionForEH(val: ^Void): ^Void;empty;

    [SymbolName('ElementsRethrow')]
    method ElementsRethrow; empty;

    [SymbolName('wcslen')]
    class method wcslen(c: ^Char): Integer;
    begin
      if c = nil then exit 0;
      result := 0;
      while Byte(c^) <> 0 do begin
        inc(c);
        inc(result);
      end;
    end;

    method strlen(c: ^AnsiChar): Integer;
    begin
      if c = nil then exit 0;
      result := 0;
      while Byte(c^) <> 0 do begin
        inc(c);
        inc(result);
      end;
    end;

    [SymbolName('memcpy')]    
    method memcpy(destination: ^Void; source: ^Void; aNum: NativeInt): ^Void;
    begin
      result := destination;
      if aNum = 0 then exit;
      if source = nil then raise new Exception('source is null');
      if destination = nil then raise new Exception('destination is null');
      if aNum < 0 then raise new Exception('aNum less than zero');
      if destination = source then exit;

      // TODO: Optimize this
      while aNum >= 8 do begin
        ^Int64(destination)^ := ^Int64(source)^;
        destination := ^Void(^Byte(destination) + 8);
        source := ^Void(^Byte(source) + 8);
        dec(aNum, 8);
      end;
      if aNum >= 4 then begin
        ^Int32(destination)^ := ^Int32(source)^;
        destination := ^Void(^Byte(destination) + 4);
        source := ^Void(^Byte(source) + 4);
        dec(aNum, 4);
      end;
      if aNum >= 2 then begin
        ^Int16(destination)^ := ^Int16(source)^;
        destination := ^Void(^Byte(destination) + 2);
        source := ^Void(^Byte(source) + 2);
        dec(aNum, 2);
      end;
      if aNum >= 1 then begin
        ^Byte(destination)^ := ^Byte(source)^;
      end;
    end;

    [SymbolName('memset')]
    method memset(ptr: ^Void; value: Integer; aNum: NativeInt): ^Void;
    begin
      value := value and $FF;
      var vval: UInt64 := value or (value shl 8) or (value shl 16) or (value shl 24);
      vval := vval or (vval shl 32);
      // TODO: Optimize this
      while aNum >= 8 do begin
        ^Int64(ptr)^ := 0;
        ptr := ^Void(^Byte(ptr) + 8);
        dec(aNum, 8);
      end;
      if aNum >= 4 then begin
        ^Int32(ptr)^ := 0;
        ptr := ^Void(^Byte(ptr) + 4);
        dec(aNum, 4);
      end;
      if aNum >= 2 then begin
        ^Int16(ptr)^ := 0;
        ptr := ^Void(^Byte(ptr) + 2);
        dec(aNum, 2);
      end;
      if aNum >= 1 then begin
        ^Byte(ptr)^ := 0;
      end;
    end;

    [SymbolName('memmove')]
    method memmove(destination: ^Void; source: ^Void; aNum: NativeInt): ^Void;
    begin
      result := destination;
      if aNum = 0 then exit;
      if source = nil then raise new Exception('source is null');
      if destination = nil then raise new Exception('destination is null');
      if aNum < 0 then raise new Exception('aNum less than zero');
      if destination = source then exit;

      if (source < destination) and (^Void(^Byte(source)+aNum) >= destination) then begin
        // TODO: Optimize this
        while aNum >= 8 do begin
          dec(aNum, 8);
          ^Int64(^Byte(destination) + aNum)^ := ^Int64(^Byte(source) + aNum)^;
        end;
        if aNum >= 4 then begin
          dec(aNum, 4);
          ^Int32(^Byte(destination) + aNum)^ := ^Int32(^Byte(source) + aNum)^;
        end;
        if aNum >= 2 then begin
          dec(aNum, 2);
          ^Int16(^Byte(destination) + aNum)^ := ^Int16(^Byte(source) + aNum)^;
        end;
        if aNum >= 1 then begin
          ^Byte(destination)^ := ^Byte(source)^;
        end;
      end
      else begin
        exit memcpy(destination, source, aNum);
      end;
    end;
  end;
  rtl.size_t = IntPtr;


end.