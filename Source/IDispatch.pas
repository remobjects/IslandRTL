namespace RemObjects.Elements.System;

type
  [Guid('00020400-0000-0000-C000-000000000046')]
  IDispatch = public interface(IUnknown)
    [CallingConvention(CallingConvention.Stdcall)]
    method GetTypeInfoCount(pctinfo: ^rtl.UINT): rtl.HRESULT;
    [CallingConvention(CallingConvention.Stdcall)]
    method GetTypeInfo(iTInfo: rtl.UINT; lcid: rtl.LCID; ppTInfo: ^^rtl.ITypeInfo): rtl.HRESULT;
    [CallingConvention(CallingConvention.Stdcall)]
    method GetIDsOfNames(riid: ^rtl.GUID; rgszNames: ^^rtl.WCHAR; cNames: rtl.UINT; lcid: rtl.LCID; rgDispId: ^rtl.DISPID): rtl.HRESULT;
    [CallingConvention(CallingConvention.Stdcall)]
    method Invoke(dispIdMember: rtl.DISPID; riid: ^rtl.GUID; lcid: rtl.LCID; wFlags: rtl.WORD; pDispParams: ^rtl.DISPPARAMS; pVarResult: ^rtl.VARIANT; pExcepInfo: ^rtl.EXCEPINFO; puArgErr: ^rtl.UINT): rtl.HRESULT;
  end;

  [CallingConvention(CallingConvention.Stdcall)]
  IDispatch_VMT_GetTypeInfoCount = public method (aSelf: ComObject; pctinfo: ^rtl.UINT): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  IDispatch_VMT_GetTypeInfo = public method (aSelf: ComObject; iTInfo: rtl.UINT; lcid: rtl.LCID; ppTInfo: ^^rtl.ITypeInfo): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  IDispatch_VMT_GetIDsOfNames = public method (aSelf: ComObject; riid: ^rtl.GUID; rgszNames: ^^rtl.WCHAR; cNames: rtl.UINT; lcid: rtl.LCID; rgDispId: ^rtl.DISPID): rtl.HRESULT;
  [CallingConvention(CallingConvention.Stdcall)]
  IDispatch_VMT_Invoke = public method (aSelf: ComObject; dispIdMember: rtl.DISPID; riid: ^rtl.GUID; lcid: rtl.LCID; wFlags: rtl.WORD; pDispParams: ^rtl.DISPPARAMS; pVarResult: ^rtl.VARIANT; pExcepInfo: ^rtl.EXCEPINFO; puArgErr: ^rtl.UINT): rtl.HRESULT;

  IDispatch_VMTType = public record
  public
    QueryInterface: IUnknown_VMT_QueryInterface;
    AddRef: IUnknown_VMT_AddRef;
    Release: IUnknown_VMT_Release;
    GetTypeInfoCount: IDispatch_VMT_GetTypeInfoCount;
    GetTypeInfo: IDispatch_VMT_GetTypeInfo;
    GetIDsOfNames: IDispatch_VMT_GetIDsOfNames;
    Invoke: IDispatch_VMT_Invoke;
  end;

  IDispatchPtr = public record(IUnknown, IDispatch)
  private
    fInstance: ComObject;
  public
    method QueryInterface(riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT; implements IUnknown.QueryInterface;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.QueryInterface(fInstance, riid, ppvObject);
    end;

    method Release: rtl.ULONG; implements IUnknown.Release;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.Release(fInstance);
    end;

    method AddRef: rtl.ULONG; implements IUnknown.AddRef;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.AddRef(fInstance);
    end;

    method GetTypeInfoCount(pctinfo: ^rtl.UINT): rtl.HRESULT; implements IDispatch.GetTypeInfoCount;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.GetTypeInfoCount(self.fInstance, pctinfo);
    end;

    method GetTypeInfo(iTInfo: rtl.UINT; lcid: rtl.LCID; ppTInfo: ^^rtl.ITypeInfo): rtl.HRESULT; implements IDispatch.GetTypeInfo;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.GetTypeInfo(self.fInstance, iTInfo, lcid, ppTInfo);
    end;

    method GetIDsOfNames(riid: ^rtl.GUID; rgszNames: ^^rtl.WCHAR; cNames: rtl.UINT; lcid: rtl.LCID; rgDispId: ^rtl.DISPID): rtl.HRESULT; implements IDispatch.GetIDsOfNames;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.GetIDsOfNames(self.fInstance, riid, rgszNames, cNames, lcid, rgDispId);
    end;

    method Invoke(dispIdMember: rtl.DISPID; riid: ^rtl.GUID; lcid: rtl.LCID; wFlags: rtl.WORD; pDispParams: ^rtl.DISPPARAMS; pVarResult: ^rtl.VARIANT; pExcepInfo: ^rtl.EXCEPINFO; puArgErr: ^rtl.UINT): rtl.HRESULT; implements IDispatch.Invoke;
    begin
      exit ^^IDispatch_VMTType(fInstance)^^.Invoke(self.fInstance, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr);
    end;

    constructor(aIntf: ComObject);
    begin
      fInstance := aIntf;
    end;

    constructor(var aCopyFrom: IDispatchPtr);
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

    class operator Explicit(aVal: IDispatchPtr): ComObject;
    begin
      exit aVal.fInstance;
    end;

    class operator Explicit(aVal: IDispatch): IDispatchPtr;
    begin
      exit new IDispatchPtr(COMHelpers.ObjectToComObject(aVal, @RemObjects.Elements.System.IDispatch_VMT));
    end;

    class operator Explicit(aVal: IDispatchPtr): IDispatch;
    begin
      exit IDispatch(coalesce(COMHelpers.ComObjectToObject(aVal.fInstance), Object(aVal)));
    end;

    class operator Equal(a,b: IDispatchPtr): Boolean;
    begin
      exit a.fInstance = b.fInstance;
    end;

    class operator NotEqual(a,b: IDispatchPtr): Boolean;
    begin
      exit a.fInstance <> b.fInstance;
    end;
  end;

var IDispatch_UID: Guid := new RemObjects.Elements.System.Guid(Data1 := $00020400, Data2 := 0, Data3 := 0, Data4_0 := $C0, Data4_1 := 0, Data4_2 := 0,  Data4_3 := 0,  Data4_4 := 0,  Data4_5 := 0,  Data4_6 := 0,  Data4_7 := $46); public; readonly;
var IDispatch_VMT: IDispatch_VMTType := new IDispatch_VMTType(
                                                QueryInterface := @IUnknown_VMTImpl_QueryInterface,
                                                AddRef := @IUnknown_VMTImpl_AddRef,
                                                Release := @IUnknown_VMTImpl_Release,
                                                GetTypeInfoCount := @IDispatch_VMTImpl_GetTypeInfoCount,
                                                GetTypeInfo := @IDispatch_VMTImpl_GetTypeInfo,
                                                GetIDsOfNames := @IDispatch_VMTImpl_GetIDsOfNames,
                                                Invoke := @IDispatch_VMTImpl_Invoke); public; readonly;

// Bridge methods; These call
[CallingConvention(CallingConvention.Stdcall)]
method IDispatch_VMTImpl_GetTypeInfoCount(aSelf: ComObject; pctinfo: ^rtl.UINT): rtl.HRESULT; public;
begin
  exit IDispatch(^ElementsCOMInterface(aSelf)^.Object).GetTypeInfoCount(pctinfo);
end;
[CallingConvention(CallingConvention.Stdcall)]
method IDispatch_VMTImpl_GetTypeInfo(aSelf: ComObject; iTInfo: rtl.UINT; lcid: rtl.LCID; ppTInfo: ^^rtl.ITypeInfo): rtl.HRESULT; public;
begin
  exit IDispatch(^ElementsCOMInterface(aSelf)^.Object).GetTypeInfo(iTInfo, lcid, ppTInfo);
end;
[CallingConvention(CallingConvention.Stdcall)]
method IDispatch_VMTImpl_GetIDsOfNames(aSelf: ComObject; riid: ^rtl.GUID; rgszNames: ^^rtl.WCHAR; cNames: rtl.UINT; lcid: rtl.LCID; rgDispId: ^rtl.DISPID): rtl.HRESULT; public;
begin
  exit IDispatch(^ElementsCOMInterface(aSelf)^.Object).GetIDsOfNames(riid, rgszNames, cNames, lcid, rgDispId);
end;
[CallingConvention(CallingConvention.Stdcall)]
method IDispatch_VMTImpl_Invoke(aSelf: ComObject; dispIdMember: rtl.DISPID; riid: ^rtl.GUID; lcid: rtl.LCID; wFlags: rtl.WORD; pDispParams: ^rtl.DISPPARAMS; pVarResult: ^rtl.VARIANT; pExcepInfo: ^rtl.EXCEPINFO; puArgErr: ^rtl.UINT): rtl.HRESULT; public;
begin
  exit IDispatch(^ElementsCOMInterface(aSelf)^.Object).Invoke(dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr);
end;

end.