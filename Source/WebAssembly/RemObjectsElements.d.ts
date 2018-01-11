/// <reference path="webassembly.es6.d.ts" />
declare function __elements_debug_wasm_loaded(url: string, bytes: ArrayBuffer, data: WebAssembly.ResultObject, importObject: any, memory: WebAssembly.Memory): void;
declare var __elements_debug_globals: any[];
declare function __elements_debug_setglobal(id: string, value: any): void;
declare function __elements_debug_getglobal(id: string): any;
declare function __elements_debug_wasm_toHexString(orgByteArray: ArrayBuffer, start: number, len: number): string;
declare function __elements_debug_wasm_fromHexString(orgByteArray: ArrayBuffer, start: number, val: string): void;
declare module ElementsWebAssembly {
    function createHandle(o: any): number;
    function releaseHandle(handle: number): void;
    function getHandleValue(handle: number): any;
    function getAndReleaseHandleValue(handle: number): any;
    function readCharsFromMemory(offs: any, len: number): string;
    function readStringFromMemory(ptr: number): string;
    function AddReference(val: number): void;
    function ReleaseReference(val: number): void;
    function fetchAndInstantiate(url: string, importObject: any, memorySize?: number, tableSize?: number): Promise<WebAssembly.ResultObject>;
}
