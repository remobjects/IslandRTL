///<reference path="webassembly.es6.d.ts" />
// __elements_debug_wasm_loaded; Keep this on line 3 for debugging purposes
function __elements_debug_wasm_loaded(url: string, bytes: ArrayBuffer, data: WebAssembly.ResultObject, importObject: any, memory: WebAssembly.Memory) {
}

// Globals needed for debugging purposes

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


module ElementsWebAssembly {
    var inst: any;
    var result: WebAssembly.ResultObject;
    var mem: WebAssembly.Memory;
    var handlenr: number = 0;
    var firstfree: number = null;
    var handletable = { '-1': Function('return this')() };
    // Special handles: 0 = null; -1 = global

    export function createHandle(o: any): number
    {
        if (o == null) return 0;
        var h: number;
        if (firstfree != null) {
            h = firstfree;
            firstfree = handletable[firstfree];
            handletable[h] = o;
            return h;
        } 
         h = ++handlenr;
        handletable[h] = o;
        return h;
    }

    export function releaseHandle(handle: number)
    {
        if (!handle || handle == 0) return;
        var old = handletable[handle];
        handletable[handle] = firstfree;
        firstfree = handle;
        if (old && old['__elements_handle'])
            ReleaseReference(old['__elements_handle']);
    }

    export function getHandleValue(handle: number): any 
    {
        return handletable[handle];
    }

    export function readCharsFromMemory(offs, len: number): string
    {
        var arr = new Int16Array(mem.buffer, offs, len);
        var s: string = "";
        for (var i: number = 0; i < len; i++)
        s+= String.fromCharCode(arr[i]);
        return s;
    }

    export function readStringFromMemory(ptr: number): string
    {
        if (ptr == null) return null;
        var dv = new DataView(mem.buffer, ptr);
        var len = dv.getInt32(4, true);
        if (dv.getInt32(4, true) == 0) return ""; // zero length string
        var s: string = "";
        for (var i: number = 0; i < len; i++)
        s+= String.fromCharCode(dv.getUint16(8 + (i *2), true));
        return s;
    }

    export function AddReference(val: number)
    {
        result.instance.exports["__island_force_addref"](val);
    }

    export function ReleaseReference(val: number)
    {
        result.instance.exports["__island_force_release"](val);
    }

    function createDelegate(objectptr: number): () => any
    {
        AddReference(objectptr);
        return function () {
            (arguments as any).this = this;
            var h = createHandle(arguments);
            result.instance.exports["__island_call_delegate"](objectptr, h);
            releaseHandle(h);
            return (arguments as any).result;
        }
    }

    function defineElementsSystemFunctions(imp: any) {
        imp.env.__island_consolelogint = function(val: number) {
            console.log("Value: "+val);
        }

        imp.env.__island_to_lower = function (val: number, len: number, invar: boolean): number {
            if (invar)
            return createHandle(readCharsFromMemory(val, len).toLowerCase());
            return createHandle(readCharsFromMemory(val, len).toLocaleLowerCase());
        };

        imp.env.__island_to_upper = function (val: number, len: number, invar: boolean): number {
            if (invar)
            return createHandle(readCharsFromMemory(val, len).toUpperCase());
            return createHandle(readCharsFromMemory(val, len).toLocaleUpperCase());
        };

        imp.env.__island_get_string_length = function(val: number): number
        {
            return (handletable[val] as String).length;
        };

        imp.env.__island_get_string_data = function(val, tar: number): number
        {
            var str = (handletable[val] as String);
            var dest = new Int16Array(imp.env.memory.buffer, tar, str.length);
            for (var i: number = 0; i < str.length; i++)
            dest[i] = str.charCodeAt(i);
            
            return str.length;
        };
        
        imp.env.__island_consolelog = function(str, len: number) 
        {
            console.log(readCharsFromMemory(str, len));
        }
        imp.env.__island_free_handle = function(handle: number)
        {
            releaseHandle( handle);
        };
        imp.env.__island_get_os_name = function(): number {
            return createHandle(navigator["oscpu"])
        };
        imp.env.__island_crypto_safe_random = function(target: number, len: number) 
        {
            var tmp = new Uint8Array(imp.env.memory.buffer, target, len);
            window.crypto.getRandomValues(tmp);
        };
        imp.env.__island_getutctime = function(): number { return Date.now(); }
        imp.env.__island_getlocaltime = function(): number { return Date.now(); }
        imp.env.__island_eval = function(str: number): number {
            return eval(readStringFromMemory(str));
        };
        imp.env.__island_get_typeof = function(handle: number): number {
            var ht = handletable[handle];
            if (ht == null) return 0;
            switch (typeof ht) {
                case 'undefined': return 1;
                case 'string': return 2;
                case 'number': return 3;
                case 'function': return 4;
                case 'symbol': return 5;
                case 'object': return 6;
                case 'boolean': return 7;
                default:
                    return -1;
            }
        };
        imp.env.__island_get_intvalue = function(handle: number): number {
            return handletable[handle];
        };
        imp.env.__island_get_doublevalue = function(handle: number): number {
            return handletable[handle];
        };
        imp.env.__island_from_intvalue = function(val: number): number {
            return createHandle(val);
        };
        imp.env.__island_from_doublevalue = function(val: number): number {
            return createHandle(val);
        };
        imp.env.__island_from_boolvalue = function(val: number): number {
            return createHandle(val ? true : false);
        };
        imp.env.__island_from_funcvalue = function(val: number): number {
            return createHandle(createDelegate(val));
        };
        imp.env.__island_from_stringvalue = function(val: number): number {
            return createHandle(readStringFromMemory(val));
        };
        imp.env.__island_clone_handle = function(val: number): number {
            return createHandle(getHandleValue(val));
        };
        imp.env.__island_call = function(thisval, name, args, argcount: number, releaseArgs: boolean): number {
            var nargs = [];
            if (argcount > 0) {
                var data = new Int32Array(mem.buffer, args);
                for (var i = 0; i < argcount; i++) {
                    nargs[i] = handletable[data[i]];
                    if (releaseArgs)
                        releaseHandle(data[i]);
                }
            }
            var v = handletable[thisval];
            var org = v;
            if (name != null && name != 0)
                v = v[readStringFromMemory(name)];
            return createHandle((v as Function).apply(org, nargs));
        };
        imp.env.__island_set = function(thisval, name, value: number, releaseArgs: boolean) {
            var val = handletable[value];
            if (releaseArgs) releaseHandle(value);
            handletable[thisval][readStringFromMemory(name)] = val;
        };
        imp.env.__island_get = function(thisval, name: number) {
            return createHandle(handletable[thisval][readStringFromMemory(name)]);
        };
        imp.env.__island_getarraylength = function(thisval: number): number {
            return handletable[thisval].length;
        };
        imp.env.__island_getarray = function(thisval, idx: number) {
            return createHandle(handletable[thisval][idx]);
        };
        imp.env.__island_setarray = function(thisval, idx, value: number, releaseArgs: boolean) {
            var val = handletable[value];
            if (releaseArgs) releaseHandle(value);
            handletable[thisval][idx] = val;
        };
        imp.env.__island_getElementById = function(id: number): number {
            return createHandle(document.getElementById(readStringFromMemory(id)));
        };
        imp.env.__island_getElementByName = function(name: number): number {
            return createHandle(document.getElementsByName(readStringFromMemory(name)));
        };
        imp.env.__island_createElement = function(name: number): number {
            return createHandle(document.createElement(readStringFromMemory(name)));
        };
        imp.env.__island_createTextNode = function(name: number): number {
            return createHandle(document.createTextNode(readStringFromMemory(name)));
        };
        imp.env.__island_createObject = function(): number {
            var obj = {};
            return createHandle(obj);
        };        
        imp.env.__island_createArray = function(name: number): number {
            var obj = [];
            return createHandle(obj);
        };
        imp.env.__island_setTimeout = function(fn, timeout: number): number {
            return window.setTimeout(createDelegate(fn), timeout);
        };
        imp.env.__island_setInterval = function(fn, timeout: number): number {
            return window.setInterval(createDelegate(fn), timeout);
        };
        imp.env.__island_ClearInterval = function(handle: number) {
             window.clearInterval(handle);
        };
        imp.env.__island_DefineValueProperty = function (obj: number, name: number, value: number, flags: number) {
            Object.defineProperty(handletable[obj], readStringFromMemory(name),
                {
                    enumerable: (flags & 1) != 0,
                    configurable: (flags & 2) != 0,
                    writable: (flags & 4) != 0,
                    value: value == 0 ? null : handletable[value]
                });
        };
        imp.env.__island_DefineGetterSetterProperty = function (obj: number, name: number, getter: number, setter: number, flags: number) {
            var newgetter: () => any = undefined;
            var newsetter: (a: any) => void = undefined;

            if (getter != 0) {
                var originalgetter: any = createDelegate(getter);
                newgetter = function() {
                    var v = { value: null };
                    originalgetter(this, v);
                    return v.value;
                };
            }
            if (setter != 0) {
                var originalsetter: any = createDelegate(setter);
                newsetter = function(v) { return originalsetter(this, v) };
            }

            Object.defineProperty(handletable[obj], readStringFromMemory(name),
                {
                    enumerable: (flags & 1) != 0,
                    configurable: (flags & 2) != 0,
                    get: newgetter,
                    set: newsetter
                });
        };
        imp.env.__island_invoke = function (tableidx: number, args: number, argcount: number): number {
            var nargs = [];
            if (argcount > 0) {
                var data = new Int32Array(mem.buffer, args);
                for (var i = 0; i < argcount; i++) {
                    var val = handletable[data[i]];
                    releaseHandle(data[i]);
                    if (val instanceof Object && '__elements_handle' in val)
                        val = val.__elements_handle;
                    nargs[i] = val;
                }
            }
            var func = (imp.env.table as WebAssembly.Table).get(tableidx);
            return createHandle(func.apply(this, nargs));
        }
    }


    export function fetchAndInstantiate(url: string, importObject: any, memorySize: number = 64, tableSize: number = 4096): Promise<WebAssembly.ResultObject> {
        if (!importObject) importObject = {};
        if (!importObject.env) importObject.env = {};
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
            mem = importObject.env.memory;
            result = results;
            inst = importObject;
            return {
                module: results.module,
                instance: result.instance,
                import: importObject,
                exports: result.instance.exports
            }
        });
    }

}