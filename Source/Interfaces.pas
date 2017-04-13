namespace RemObjects.Elements.System;

type
  [Guid("00000000-0000-0000-C000-000000000046")]
  IUnknown = public interface
    [CallingConvention(CallingConvention.Stdcall)]
    method QueryInterface(riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;
    [CallingConvention(CallingConvention.Stdcall)]
    method AddRef(): rtl.ULONG;
    [CallingConvention(CallingConvention.Stdcall)]
    method Release(): rtl.ULONG;
  end;
  [CallingConvention(CallingConvention.Stdcall)]
  IUnknown_VMT_QueryInterface = public method(aSelf: ComObject; riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  IUnknown_VMT_AddRef = public method(aSelf: ComObject): rtl.ULONG;
  [CallingConvention(CallingConvention.Stdcall)]
  IUnknown_VMT_Release = public method(aSelf: ComObject): rtl.ULONG;

  IUnknown_VMTType = public record
  public
    QueryInterface: IUnknown_VMT_QueryInterface;
    AddRef: IUnknown_VMT_AddRef;
    Release: IUnknown_VMT_Release;
  end;
  IUnknownPtr = public record(IUnknown)
  private
    fInstance: ComObject;
  public
    class operator Explicit(aVal: IUnknownPtr): ComObject;
    begin
      exit aVal.fInstance;
    end;
    class operator Explicit(aVal: IUnknown): IUnknownPtr;
    begin
      exit new IUnknownPtr(COMHelpers.ObjectToComObject(aVal, @IUnknown_VMT));
    end;

    class operator Explicit(aVal: IUnknownPtr): IUnknown;
    begin
      exit coalesce(COMHelpers.ComObjectToObject(aVal.fInstance), IUnknown(Object(aVal)));
    end;

    class operator Equal(a,b: IUnknownPtr): Boolean;
    begin
      exit a.fInstance = b.fInstance;
    end;

    class operator NotEqual(a,b: IUnknownPtr): Boolean;
    begin
      exit a.fInstance <> b.fInstance;
    end;

    method Release: rtl.ULONG;
    begin
      exit fInstance^^.Release(fInstance);
    end;
    method AddRef: rtl.ULONG;
    begin
      exit fInstance^^.AddRef(fInstance);
    end;
    method QueryInterface(riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;
    begin
      exit fInstance^^.QueryInterface(fInstance, riid, ppvObject);
    end;

    constructor(aIntf: ComObject);
    begin
      fInstance := aIntf;
    end;
    constructor(var aCopyFrom: IUnknownPtr);
    begin
      fInstance := aCopyFrom.fInstance;
      if fInstance <> nil then fInstance^^.AddRef(fInstance);
    end;
    finalizer;
    begin
      var lInst := fInstance;
      fInstance := nil;
      if lInst <> nil then lInst^^.Release(lInst);
    end;
  end;

var IUnknown_UID: Guid := new RemObjects.Elements.System.Guid(Data1 := 0, Data2 := 0, Data3 := 0, Data4_0 := 192, Data4_1 := 0, Data4_2 := 0,  Data4_3 := 0,  Data4_4 := 0,  Data4_5 := 0,  Data4_6 := 0,  Data4_7 := 70); public; readonly;
var IUnknown_VMT: IUnknown_VMTType := new IUnknown_VMTType(QueryInterface := @IUnknown_VMTImpl_QueryInterface, AddRef := @IUnknown_VMTImpl_AddRef, Release := @IUnknown_VMTImpl_Release); public; readonly;

var IElementsObject_UID: Guid := new RemObjects.Elements.System.Guid(Data1 := $5b9e00e5, Data2 := $c1da, Data3 := $4f0d, Data4_0 := $8d, Data4_1 := $92, Data4_2 := $e0,  Data4_3 := $68,  Data4_4 := $42,  Data4_5 := $bd,  Data4_6 := $5d,  Data4_7 := $f5); public; readonly;

type
  ElementsCOMInterface = public record
  public
    VMT: ^IUnknown_VMTType;
    Object: Object;
    fMyRC: Integer;
  end;

  ComObject = public ^^IUnknown_VMTType;

  COMHelpers = public static class
  public

    method ObjectToComObject(aVal: IUnknown; aForVMT: ^Void): ComObject;
    begin
      aVal.AddRef; // increases the ref count for the gc handle; also creates the handle if needed
      var lPtr := ExternalCalls.malloc(sizeOf(ElementsCOMInterface));
      ^ElementsCOMInterface(lPtr)^.fMyRC := 1;
      ^ElementsCOMInterface(lPtr)^.Object := aVal;
      ^ElementsCOMInterface(lPtr)^.VMT := ^IUnknown_VMTType(aForVMT);
      exit ComObject(lPtr);
    end;

    method ComObjectToObject(aVal: ComObject): IUnknown;
    begin
      if aVal = nil then exit nil;
      var lPtr: ^Void;
      if 0 = aVal^^.QueryInterface(aVal, ^rtl.GUID(@IElementsObject_UID), @lPtr) then exit nil;
      result := IUnknown(^ElementsCOMInterface(lPtr)^.Object);
      ^ElementsCOMInterface(lPtr)^. VMT^.Release(ComObject(lPtr));
    end;
  end;

  method __elements_Default_AddRef(aObj: Object; var aRefCount: Integer; var aGCHandle: GCHandle): rtl.ULONG;public;
  begin
    result := InternalCalls.Increment(var aRefCount) + 1;
    if result = 1 then begin
      var lHandle := GCHandle.Allocate(aObj);
      if InternalCalls.CompareExchange(var ^NativeInt(@aGCHandle)^, ^NativeInt(@lHandle)^, 0) <> 0 then lHandle.Dispose;
    end;
  end;
  method __elements_Default_Release(aObj: Object; var aRefCount: Integer; var aGCHandle: GCHandle): rtl.ULONG;public;
  begin
    result := InternalCalls.Decrement(var aRefCount) - 1;
    if result = 0 then begin
      var lHandle := InternalCalls.Exchange(var ^NativeInt(@aGCHandle)^, 0);
      if lHandle <> 0 then
        ^GCHandle(@lHandle)^.Dispose;
    end;
  end;
  // Bridge methods; These call
  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_QueryInterface(aSelf: ComObject; riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;public;static;
  begin
    exit IUnknown(^ElementsCOMInterface(aSelf)^.Object).QueryInterface(riid, ppvObject);
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_AddRef(aSelf: ComObject): rtl.ULONG; public;static;
  begin
    IUnknown(^ElementsCOMInterface(aSelf)^.Object).AddRef(); // Increase the internal count so that we keep around the gc handle
    exit InternalCalls.Increment(var ^ElementsCOMInterface(aSelf)^.fMyRC)+1; // returns the old value
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_Release(aSelf: ComObject): rtl.ULONG; public;static;
  begin
    IUnknown(^ElementsCOMInterface(aSelf)^.Object).Release();
    result := InternalCalls.Decrement(var ^ElementsCOMInterface(aSelf)^.fMyRC)-1;
    if result = 0 then
      ExternalCalls.free(aSelf);
  end;

end.