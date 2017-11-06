///<reference path="webassembly.es6.d.ts" />
// __elements_debug_wasm_loaded; Keep this on line 3 for debugging purposes.
function __elements_debug_wasm_loaded(url: string, bytes: ArrayBuffer, data: WebAssembly.ResultObject, importObject: any, memory: WebAssembly.Memory) {
}

function __elements_create_handle(imp: any, o: any): number
{
    var h = ++imp.env.handlenr;
    imp.env.handletable[h] = o;
    return h;
}

function __elements_release_handle(imp: any, handle: number)
{
    delete imp.env.handletable[handle];
}

function __elements_get_string(imp: any, offs, len: number): String
{
    var arr = new Int16Array(imp.env.memory.buffer, offs, len);
    var s: String = "";
    for (var i: number = 0; i < len; i++)
      s+= String.fromCharCode(arr[i]);
    return s;
}

function defineElementsSystemFunctions(imp: any) {
    imp.__handlenr = 0;
    imp.__handletable = {};
    imp.env.__island_consolelogint = function(val: number) {
        console.log("Value: "+val);
    }

    imp.env.__island_to_lower = function (val: number, len: number, invar: boolean): number {
        if (invar)
        return __elements_create_handle(imp, __elements_get_string(imp, val, len).toLowerCase());
        return __elements_create_handle(imp, __elements_get_string(imp, val, len).toLocaleLowerCase());
    };
    imp.env.__island_to_upper = function (val: number, len: number, invar: boolean): number {
        if (invar)
        return __elements_create_handle(imp, __elements_get_string(imp, val, len).toUpperCase());
        return __elements_create_handle(imp, __elements_get_string(imp, val, len).toLocaleUpperCase());
    };
    imp.env.__island_get_string_length = function(val: number): number
    {
        return (imp.handletable[val] as String).length;
    };
    imp.env.__island_get_string_data = function(val, tar: number): number
    {
        var str = (imp.handletable[val] as String);
        var dest = new Int16Array(imp.env.memory.buffer, tar, str.length);
        for (var i: number = 0; i < str.length; i++)
          dest[i] = str.charCodeAt(i);
         
        return str.length;
    };
    
    imp.env.__island_consolelog = function(str, len: number) 
    {
        console.log(__elements_get_string(imp, str, len));
    }
    imp.env.__island_free_handle = function(handle: number)
    {
        __elements_release_handle(imp, handle);
    };
    imp.env.__island_get_os_name = function(): number {
        return __elements_create_handle(imp, navigator["oscpu"])
    };
    imp.env.__island_crypto_safe_random = function(target: number, len: number) 
    {
        var tmp = new Uint8Array(imp.env.memory.buffer, target, len);
        window.crypto.getRandomValues(tmp);
    };
    imp.env.__island_getutctime = function(): number { return Date.now(); }
    imp.env.__island_getlocaltime = function(): number { return Date.now(); }
}

function fetchAndInstantiate(url: string, importObject: any, memorySize: number = 16, tableSize: number = 1024): Promise<WebAssembly.ResultObject> {
    var bytedata: ArrayBuffer;
    return fetch(url).then(response =>
        response.arrayBuffer()
    ).then(bytes => {
        bytedata = bytes;
        defineElementsSystemFunctions(importObject);
        if (!importObject.env.memory)
        importObject.env.memory = new WebAssembly.Memory({
              initial: memorySize
          });
      if (!importObject.env.table) {
          importObject.env.table = new WebAssembly.Table({
              initial: tableSize,
              element:"anyfunc"
          });
      }
        return WebAssembly.instantiate(bytes, importObject);
    }
    ).then(results => {
        __elements_debug_wasm_loaded(url, bytedata, results, importObject, importObject.env.memory);
        return results;
    });
}

var __elements_debug_globals = []; // needed for debugging purposes.

function __elements_debug_setglobal(id: string, value: any)
{
    __elements_debug_globals[id] = value
}

function __elements_debug_getglobal(id: string)
{
    return __elements_debug_globals[id];
}

function __elements_debug_wasm_toHexString(orgByteArray: ArrayBuffer, start: number, len: number) {
    var byteArray = new Int8Array(orgByteArray);
    var s = "";
    var ch = "";
    if (!start) start = 0;
    if (!len) len = byteArray.length;
    for (var i: number = 0; i < len; i++) {
        if (i % 4096 == 4095) {
            s += ch;
            ch = "";
        }
        ch += ('0' + (byteArray[start + i] & 0xFF).toString(16)).slice(-2);
    }
    s += ch;
    return s;
}

function __elements_debug_wasm_fromHexString(orgByteArray: ArrayBuffer, start: number, val: string) {
    var byteArray = new Int8Array(orgByteArray);
    if (!start) start = 0;
    var len = val.length;
    for (var i: number = 0; i < len; i++) {
        var b = 0;
        switch (val.charAt(i)) {
            case '0': b |= 0x00; break;
            case '1': b |= 0x10; break;
            case '2': b |= 0x20; break;
            case '3': b |= 0x30; break;
            case '4': b |= 0x40; break;
            case '5': b |= 0x50; break;
            case '6': b |= 0x60; break;
            case '7': b |= 0x70; break;
            case '8': b |= 0x80; break;
            case '9': b |= 0x90; break;
            case 'a':
            case 'A': b |= 0xa0; break;
            case 'b':
            case 'B': b |= 0xb0; break;
            case 'c':
            case 'C': b |= 0xc0; break;
            case 'd':
            case 'D': b |= 0xd0; break;
            case 'e':
            case 'E': b |= 0xe0; break;
            case 'f':
            case 'F': b |= 0xf0; break;
        }
        i++;
        switch (val.charAt(i)) {
            case '0': b |= 0x0; break;
            case '1': b |= 0x1; break;
            case '2': b |= 0x2; break;
            case '3': b |= 0x3; break;
            case '4': b |= 0x4; break;
            case '5': b |= 0x5; break;
            case '6': b |= 0x6; break;
            case '7': b |= 0x7; break;
            case '8': b |= 0x8; break;
            case '9': b |= 0x9; break;
            case 'a':
            case 'A': b |= 0xa; break;
            case 'b':
            case 'B': b |= 0xb; break;
            case 'c':
            case 'C': b |= 0xc; break;
            case 'd':
            case 'D': b |= 0xd; break;
            case 'e':
            case 'E': b |= 0xe; break;
            case 'f':
            case 'F': b |= 0xf; break;
        }
        byteArray[start] = b;
        start++;
    }
}