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
    fInst: ComObject;
  public
    method __QueryInterface(riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT; implements IUnknown.QueryInterface;
    begin
			exit IUnknown_VMTImpl_QueryInterface(fInst, riid, ppvObject);
    end;

    method __Release: rtl.ULONG; implements IUnknown.Release;
    begin
			exit IUnknown_VMTImpl_Release(fInst);
    end;

    method __AddRef: rtl.ULONG; implements IUnknown.AddRef;
    begin
      exit IUnknown_VMTImpl_AddRef(fInst);
    end;

    method __GetTypeInfoCount(pctinfo: ^rtl.UINT): rtl.HRESULT; implements IDispatch.GetTypeInfoCount;
		begin
			exit IDispatch_VMTImpl_GetTypeInfoCount(self.fInst, pctinfo);
		end;

    method __GetTypeInfo(iTInfo: rtl.UINT; lcid: rtl.LCID; ppTInfo: ^^rtl.ITypeInfo): rtl.HRESULT; implements IDispatch.GetTypeInfo;
		begin
		  exit IDispatch_VMTImpl_GetTypeInfo(self.fInst, iTInfo, lcid, ppTInfo);
		end;

    method __GetIDsOfNames(riid: ^rtl.GUID; rgszNames: ^^rtl.WCHAR; cNames: rtl.UINT; lcid: rtl.LCID; rgDispId: ^rtl.DISPID): rtl.HRESULT; implements IDispatch.GetIDsOfNames;
		begin
			exit IDispatch_VMTImpl_GetIDsOfNames(self.fInst, riid, rgszNames, cNames, lcid, rgDispId);
		end;

    method __Invoke(dispIdMember: rtl.DISPID; riid: ^rtl.GUID; lcid: rtl.LCID; wFlags: rtl.WORD; pDispParams: ^rtl.DISPPARAMS; pVarResult: ^rtl.VARIANT; pExcepInfo: ^rtl.EXCEPINFO; puArgErr: ^rtl.UINT): rtl.HRESULT; implements IDispatch.Invoke;
		begin
			exit IDispatch_VMTImpl_Invoke(self.fInst, dispIdMember, riid, lcid, wFlags, pDispParams, pVarResult, pExcepInfo, puArgErr);
		end;

    constructor(aIntf: ComObject);
    begin
      fInst := aIntf;
    end;

    constructor(var aCopyFrom: IDispatchPtr);
    begin
      fInst := aCopyFrom.fInst;
      if fInst <> nil then fInst^^.AddRef(fInst);
    end;

    finalizer;
    begin
      var lInst := fInst;
      fInst := nil;
      if lInst <> nil then lInst^^.Release(lInst);
    end;

    class operator Explicit(aVal: IDispatchPtr): ComObject;
    begin
      exit aval.fInst;
    end;

		class operator Explicit(aVal: IDispatch): IDispatchPtr;
    begin
      exit new IDispatchPtr(COMHelpers.ObjectToComObject(aVal, @RemObjects.Elements.System.IDispatch_VMT));
    end;

    class operator Explicit(aVal: IDispatchPtr): IDispatch;
    begin
      exit IDispatch(coalesce(COMHelpers.ComObjectToObject(aVal.fInst), Object(aVal)));
    end;

    class operator Equal(a,b: IDispatchPtr): Boolean;
    begin
      exit a.finst = b.finst;
    end;

    class operator NotEqual(a,b: IDispatchPtr): Boolean;
    begin
      exit a.finst <> b.finst;
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
