namespace RemObjects.Elements.System;

  [assembly:AssemblyDefineAttribute('WebAssembly')]
  [assembly:AssemblyDefineAttribute('CPU32')]
  [assembly:AssemblyDefineAttribute('NOTHREADS')]

type
  WebAssemblyCalls = public static class
  public
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
    class method GrowMemory(aSize: Integer): ^Void; external;
  end;
  ExternalCalls = public static class 
  private
    [SymbolName('llvm.trap')]
    class method trap; external;
  public
    [SymbolName('ElementsRaiseException')]
    method RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);
    begin 
      // Not supported atm!
      trap;
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

    class method GetAndFreeString(handle: Int32): String;
    begin 
      result := String.AllocString(WebAssemblyCalls.GetStringLength(handle));
      WebAssemblyCalls.GetStringData(handle, @result.fFirstChar);
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