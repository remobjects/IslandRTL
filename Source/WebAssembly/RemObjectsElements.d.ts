/// <reference path="webassembly.es6.d.ts" />
export declare function __elements_debug_setglobal(id: string, value: any): void;
export declare function __elements_debug_getglobal(id: string): any;
export declare function __elements_debug_wasm_toHexString(orgByteArray: ArrayBuffer, start: number, len: number): string;
export declare function __elements_debug_wasm_fromHexString(orgByteArray: ArrayBuffer, start: number, val: string): void;
export declare module ElementsWebAssembly {
    function createHandle(o: any): number;
    function releaseHandle(handle: number): void;
    function WrapTask(ptr: number): Promise<any>;
    function getHandleValue(handle: number): any;
    function getAndReleaseHandleValue(handle: number): any;
    function readCharsFromMemory(offs: any, len: number): string;
    function readStringFromMemory(ptr: number): string;
    function AddReference(val: number): void;
    function ReleaseReference(val: number): void;
    function destroyDelegate(val: () => any): void;
    function fetchAndInstantiate(url: any, importObject: any, memorySize?: number, tableSize?: number): Promise<WebAssembly.ResultObject>;
}
