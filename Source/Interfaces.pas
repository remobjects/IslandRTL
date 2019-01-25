namespace RemObjects.Elements.System;

type
  {$IFDEF WINDOWS}
  IUnknown = public rtl.IUnknown;
  {$ELSE}
  [COM]
  IUnknown = public interface
    [CallingConvention(CallingConvention.Stdcall)]
    method QueryInterface(riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;
    [CallingConvention(CallingConvention.Stdcall)]
    method AddRef(): rtl.ULONG;
    [CallingConvention(CallingConvention.Stdcall)]
    method Release(): rtl.ULONG;
  end;
  {$ENDIF}

  ICOMInterface = public interface
    method QueryInterface(var riid: Guid; out ppvObject: ^Void): Boolean;
    method AddRef(): rtl.ULONG;
    method Release(): rtl.ULONG;
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
      var lPtr := ExternalCalls.malloc(sizeOf(ElementsCOMInterface));
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
      if 0 <> ^^rtl.__struct_IUnknownVtbl(aVal)^^.QueryInterface(aVal, ^rtl.GUID(@IElementsObject_UID), @lPtr) then exit nil;
      result := ICOMInterface(^ElementsCOMInterface(lPtr)^.Object);
      ^^rtl.__struct_IUnknownVtbl(lPtr)^^.Release(^rtl.IUnknown(@lPtr)^);
    end;

    method ObjectToCom(aVal: Object; aGuid: Guid): IUnknown;
    begin
      var lPVal := ICOMInterface(aVal);
      if lPVal = nil then exit;
      if not lPVal.QueryInterface(var aGuid, out ^^Void(@result)^) then
        ^^Void(@result)^ := nil;
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
  method IUnknown_VMTImpl_QueryInterface(aSelf: ^ElementsCOMInterface; riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;public;static;
  begin
    if ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).QueryInterface(var ^Guid(riid)^, out ppvObject^) then
      exit 0;
    exit $80004002;
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_AddRef(aSelf: ^ElementsCOMInterface): rtl.ULONG; public;static;
  begin
    ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).AddRef(); // Increase the internal count so that we keep around the gc handle
    exit InternalCalls.Increment(var ^ElementsCOMInterface(aSelf)^.fMyRC)+1; // returns the old value
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  method IUnknown_VMTImpl_Release(aSelf: ^ElementsCOMInterface): rtl.ULONG; public;static;
  begin
    ICOMInterface(^ElementsCOMInterface(aSelf)^.Object).Release();
    result := InternalCalls.Decrement(var ^ElementsCOMInterface(aSelf)^.fMyRC)-1;
    if result = 0 then
      ExternalCalls.free(aSelf);
  end;

type
  COMGC<T> = public lifetimestrategy (COMGC) T;
  COMGC = public record(ILifetimeStrategy<COMGC>)
  assembly
    fInst: IntPtr;
  public
    class method &New(aTTY: ^Void; aSize: NativeInt): ^Void;
    begin
      raise new Exception('Not supported');
    end;

    class method Init(var Dest: COMGC);
    begin
      Dest.fInst := nil;
    end;

    constructor Copy(var aValue: COMGC);
    begin
      fInst := aValue.fInst;
      if ^^rtl.__struct_IUnknownVtbl(fInst) <> nil then
        ^^rtl.__struct_IUnknownVtbl(fInst)^^.AddRef(^rtl.IUnknown(@fInst)^);
    end;

    class method Copy(var aDest, aSource: COMGC);
    begin
      var lInst := aSource.fInst;
      if ^^rtl.__struct_IUnknownVtbl(lInst) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lInst)^^.AddRef(^rtl.IUnknown(@lInst)^);
      aDest.fInst := lInst;
    end;

    class operator Assign(var aDest: COMGC; var aSource: COMGC);
    begin
      Assign(var aDest, var aSource);
    end;

    class method Assign(var aDest, aSource: COMGC);
    begin
      var lNew := aSource.fInst;
      var lOld := InternalCalls.Exchange(var aDest.fInst, lNew);
      if ^^rtl.__struct_IUnknownVtbl(lNew) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lNew)^^.AddRef(^rtl.IUnknown(@lNew)^);
      if ^^rtl.__struct_IUnknownVtbl(lOld) <> nil then
        ^^rtl.__struct_IUnknownVtbl(lOld)^^.Release(^rtl.IUnknown(@lOld)^);
    end;

    class method Release(var aDest: COMGC);
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