namespace RemObjects.Elements.System;

type
  {$IFDEF WINDOWS}
  IUnknown = public rtl.IUnknown;
  {$ELSE}
  [COM, Guid("{00000000-0000-0000-C000-000000000046}")]
  rtl.IUnknown = public interface
    [CallingConvention(CallingConvention.Stdcall)]
    method QueryInterface(riid: rtl.GUID; ppvObject: ^^Void): Cardinal;
    [CallingConvention(CallingConvention.Stdcall)]
    method AddRef(): Cardinal;
    [CallingConvention(CallingConvention.Stdcall)]
    method Release(): Cardinal;
  end;
  IUnknown = public rtl.IUnknown;
  rtl.__struct_IUnknownVtbl = public record
  public
    QueryInterface: QueryInterfaceFunction;
    AddRef: AddRefFunction;
    Release: ReleaseFunction;
  end;
  [CallingConvention(CallingConvention.Stdcall)]
  QueryInterfaceFunction nested in rtl.__struct_IUnknownVtbl = public function (slf: rtl.IUnknown; riid: rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  AddRefFunction nested in rtl.__struct_IUnknownVtbl = public function(slf: rtl.IUnknown): Cardinal;
  [CallingConvention(CallingConvention.Stdcall)]
  ReleaseFunction nested in rtl.__struct_IUnknownVtbl = public function(slf: rtl.IUnknown): Cardinal;
  rtl.GUID = public Guid;
  rtl.HRESULT = public Cardinal;
  {$ENDIF}

  ULONG = public {$IFDEF WINDOWS}rtl.ULONG{$ELSE}Cardinal{$ENDIF};
  ICOMInterface = public interface
    {$IFDEF WINDOWS}
    method QueryInterface(var riid: Guid; out ppvObject: ^Void): Boolean;
    {$ELSE}
    method QueryInterface(riid: Guid; out ppvObject: ^Void): Boolean;
    {$ENDIF}
    method AddRef(): ULONG;
    method Release(): ULONG;
  end;

  IComDispose = public interface
    // triggered when refcount reaches zero.
    method ComDispose;
  end;

var IElementsObject_UID: Guid := new RemObjects.Elements.System.Guid(Data1 := $5b9e00e5, Data2 := $c1da, Data3 := $4f0d, Data4_0 := $8d, Data4_1 := $92, Data4_2 := $e0,  Data4_3 := $68,  Data4_4 := $42,  Data4_5 := $bd,  Data4_6 := $5d,  Data4_7 := $f5); public; readonly;

type
  ElementsCOMInterface = public record
  public
    VMT: ^Void;
    Object: Object;
    fMyRC: Integer;
  end;

  COMHelpers = public static class
  public
    method IntObjectToComObject(aVal: ICOMInterface; aForVMT: ^Void): ^Void;
    begin
      aVal.AddRef; // increases the ref count for the gc handle; also creates the handle if needed
      var lPtr := malloc(sizeOf(ElementsCOMInterface));
      ^ElementsCOMInterface(lPtr)^.fMyRC := 1;
      ^ElementsCOMInterface(lPtr)^.Object := aVal;
      ^ElementsCOMInterface(lPtr)^.VMT := aForVMT;
      ^^Void(@result)^ := lPtr;
    end;

    method ObjectToComObject(aVal: ICOMInterface; aForVMT: ^Void): IUnknown;
    begin
      var lTmp := IntObjectToComObject(aVal, aForVMT);
      ^^Void(@result)^ := lTmp;
    end;

    method ComObjectToObject(aVal: IUnknown): ICOMInterface;
    begin
      if aVal = nil then exit nil;
      var lPtr: ^Void;
      {$IFDEF WINDOWS}
      if 0 <> ^^^rtl.__struct_IUnknownVtbl(@aVal)^^.QueryInterface(aVal, ^rtl.GUID(@IElementsObject_UID), @lPtr) then exit nil;
      {$ELSE}
      if 0 <> ^^^rtl.__struct_IUnknownVtbl(@aVal)^^.QueryInterface(aVal, ^rtl.GUID(@IElementsObject_UID)^, @lPtr) then exit nil;
      {$ENDIF}
      result := ICOMInterface(^ElementsCOMInterface(lPtr)^.Object);
      ^^rtl.__struct_IUnknownVtbl(lPtr)^^.Release(^rtl.IUnknown(@lPtr)^);
    end;

    method ObjectToCom(aVal: Object; aGuid: Guid): IUnknown;
    begin
      var lPVal := ICOMInterface(aVal);
      if lPVal = nil then exit;
      {$IFDEF WINDOWS}
      if not lPVal.QueryInterface(var aGuid, out ^^Void(@result)^) then
        ^^Void(@result)^ := nil;
      {$ELSE}
      if not lPVal.QueryInterface(aGuid, out ^^Void(@result)^) then
        ^^Void(@result)^ := nil;
      {$ENDIF}
    end;
  end;

  method __elements_Default_AddRef(aObj: Object; var aRefCount: Integer; var aGCHandle: GCHandle): ULONG; public;
  begin
    result := InternalCalls.Increment(var aRefCount) + 1;
    if result = 1 then begin
      var lHandle := GCHandle.Allocate(aObj);
      if InternalCalls.CompareExchange(var ^NativeInt(@aGCHandle)^, ^NativeInt(@lHandle)^, 0) <> 0 then lHandle.Dispose;
    end;
  end;
  method __elements_Default_Release(aObj: Object; var aRefCount: Integer; var aGCHandle: GCHandle): ULONG; public;
  begin
    result := InternalCalls.Decrement(var aRefCount) - 1;
    if result = 0 then begin
      var lHandle := InternalCalls.Exchange(var ^NativeInt(@aGCHandle)^, 0);
      if lHandle <> 0 then
        ^GCHandle(@lHandle)^.Dispose;
      IComDispose(aObj):ComDispose;
    end;
  end;

  // Bridge methods; These call
  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_QueryInterface(aSelf: ^ElementsCOMInterface; riid: {$IFDEF WINDOWS}^rtl.GUID{$ELSE}rtl.GUID{$ENDIF}; ppvObject: ^^Void): rtl.HRESULT; public;static;
  begin
    {$IFDEF WINDOWS}
    var g := ^Guid(riid)^;
    if ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).QueryInterface(var g, out ppvObject^) then
      exit 0;
    {$ELSE}
    var g: Guid := riid;
    if ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).QueryInterface(g, out ppvObject^) then
      exit 0;
    {$ENDIF}
    exit $80004002;
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_AddRef(aSelf: ^ElementsCOMInterface): ULONG; public;static;
  begin
    ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).AddRef(); // Increase the internal count so that we keep around the gc handle
    exit InternalCalls.Increment(var ^ElementsCOMInterface(aSelf)^.fMyRC)+1; // returns the old value
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_Release(aSelf: ^ElementsCOMInterface): ULONG; public;static;
  begin
    ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).Release();
    result := InternalCalls.Decrement(var ^ElementsCOMInterface(aSelf)^.fMyRC)-1;
    if result = 0 then
      free(aSelf);
  end;

type
  COMRC<T> = public lifetimestrategy (COMRC) T;
  COMRC = public record(ILifetimeStrategy<COMRC>)
  assembly
    fInst: IntPtr;
  public
    class method &New(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      raise new Exception('Not supported');
    end;

    class method Init(var Dest: COMRC);
    begin
      Dest.fInst := nil;
    end;

    constructor Copy(var aValue: COMRC);
    begin
      fInst := aValue.fInst;
      if ^^rtl.__struct_IUnknownVtbl(fInst) <> nil then
        ^^rtl.__struct_IUnknownVtbl(fInst)^^.AddRef(^rtl.IUnknown(@fInst)^);
    end;

    class method Copy(var aDest, aSource: COMRC);
    begin
      var lInst := aSource.fInst;
      if ^^rtl.__struct_IUnknownVtbl(lInst) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lInst)^^.AddRef(^rtl.IUnknown(@lInst)^);
      aDest.fInst := lInst;
    end;

    class operator Assign(var aDest: COMRC; var aSource: COMRC);
    begin
      Assign(var aDest, var aSource);
    end;

    class method Assign(var aDest, aSource: COMRC);
    begin
      var lNew := aSource.fInst;
      var lOld := InternalCalls.Exchange(var aDest.fInst, lNew);
      if ^^rtl.__struct_IUnknownVtbl(lNew) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lNew)^^.AddRef(^rtl.IUnknown(@lNew)^);
      if ^^rtl.__struct_IUnknownVtbl(lOld) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lOld)^^.Release(^rtl.IUnknown(@lOld)^);
    end;

    class method Release(var aDest: COMRC);
    begin
      var lOld := InternalCalls.Exchange(var aDest.fInst, nil);
      if ^^rtl.__struct_IUnknownVtbl(lOld) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lOld)^^.Release(^rtl.IUnknown(@lOld)^);
    end;

    finalizer;
    begin
      Release(var self);
    end;
  end;


end.