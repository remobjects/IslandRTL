/// <reference path="webassembly.es6.d.ts" />
export declare module ElementsWebAssembly {
    function createHandle(o: any): number;
    function releaseHandle(handle: number): void;
    function getHandleValue(handle: number): any;
    function getAndReleaseHandleValue(handle: number): any;
    function readCharsFromMemory(offs: any, len: number): string;
    function readStringFromMemory(ptr: number): string;
    function AddReference(val: number): void;
    function ReleaseReference(val: number): void;
    function destroyDelegate(val: () => any): void;
    function fetchAndInstantiate(url: any, importObject: any, memorySize?: number, tableSize?: number): Promise<WebAssembly.ResultObject>;
}
