namespace RemObjects.Elements.System;

type
  ClassInstancing = public enum (Internal, SingleInstance, MultiInstance);
  ThreadingModel = public enum (Single, Apartment, Free, Both, Neutral);


  //[Com]
  //[Guid("9DE1C534-6AE1-11E0-84E1-18A905BCC53F")]
  //Windows.Foundation.TypedEventHandler<TSender, TResult> = public method(sender: TSender; &result: TResult);

  OleError = class(Exception)
  private
  public
    constructor(Message: String; Code: rtl.HRESULT);
    begin
      inherited constructor(Message);
      ErrorCode := Code;
    end;
    constructor(Code: rtl.HRESULT);
    begin
      constructor(String.Format('Ole error, code: {0}', [Code]), Code);
    end;
    property ErrorCode: rtl.HRESULT;
  end;

  InterfacedObject = public abstract class(IUnknown)
  protected
    GCHandle: GCHandle;
    ReferenceCount: Integer;
    method DefaultQueryInterface(var riid: Guid; out ppvObject: ^Void): Boolean; virtual; empty;
  public
    method QueryInterface(var riid: Guid; out ppvObject: ^Void): Boolean; virtual;
    begin
      exit DefaultQueryInterface(var riid, out ppvObject);
    end;

    method AddRef: rtl.ULONG; virtual;
    begin
      exit __elements_Default_AddRef(self, var ReferenceCount, var GCHandle);
    end;

    method Release: rtl.ULONG; virtual;
    begin
      exit __elements_Default_Release(self, var ReferenceCount, var GCHandle);
    end;
  end;

  ComObject = public abstract class(InterfacedObject, rtl.ISupportErrorInfo, IComDispose)
  private
    fCounted: Boolean;
  protected
    {$REGION rtl.ISupportErrorInfo}
    [CallingConvention(CallingConvention.Stdcall)]
    method InterfaceSupportsErrorInfo(riid: ^rtl.GUID): rtl.HRESULT;
    begin
      var Obj: IUnknown;
      var g: Guid := ^Guid(riid)^;
      if QueryInterface(var g, out ^^Void(@Obj)^) then begin
        Obj := nil;
        exit rtl.S_OK;
      end
      else begin
        exit rtl.S_FALSE;
      end;
    end;
    {$ENDREGION}
  public
    constructor;
    begin
      var lFactory := ComClassManager.GetFactoryFromClass(GetType);
      constructor (lFactory);
    end;

    constructor(aFactory: ComObjectFactory);
    begin
      Factory := aFactory;
      InternalCalls.Increment(var ReferenceCount);
      Factory.ComServer.CountObject(True);
      fCounted := true;
      Initialize;
      InternalCalls.Decrement(var ReferenceCount);
    end;

    method ComDispose;
    begin
      if fCounted then Factory:ComServer:CountObject(false);
      if ReferenceCount > 0 then rtl.CoDisconnectObject(self, 0);
    end;

    method Initialize; empty; virtual;
    method SafeCallException(ExceptObject: Object; ExceptAddr: ^Void): rtl.HRESULT;
    begin
      exit HandleSafeCallException(ExceptObject, ExceptAddr, Factory.ErrorIID, Factory.ProgID, Factory.ComServer.HelpFileName);
    end;
    property Factory: ComObjectFactory read;
  end;

  ComObjectFactory = public class(InterfacedObject, rtl.IClassFactory, rtl.IClassFactory2, IComDispose)
  private
    fComClass: &Type;
    fComServer: ComServerObject;
    fClassID: Guid;
    fName, fVersion, fDescription: String;
    fInstancing: ClassInstancing;
    fThreadingModel: ThreadingModel;
    fIsRegistered: UInt32;

    method getRegFlags: UInt32; inline;
    begin
      exit UInt32(iif(fInstancing = ClassInstancing.MultiInstance, rtl.REGCLS.REGCLS_MULTIPLEUSE, rtl.REGCLS.REGCLS_SINGLEUSE));
    end;
  assembly
    method RegisterClassObject;
    begin
      if fInstancing <> ClassInstancing.Internal then
        OleCheck(rtl.CoRegisterClassObject(^rtl.GUID(@fClassID), Self, rtl.DWORD(rtl.CLSCTX.CLSCTX_LOCAL_SERVER), getRegFlags, @fIsRegistered));
    end;

  protected
    {$REGION rtl.IClassFactory2}
    [CallingConvention(CallingConvention.Stdcall)]
    method CreateInstance(pUnkOuter: rtl.IUnknown; riid: ^rtl.GUID; ppvObject: ^^Void): rtl.HRESULT;
    begin
      var lcom: ComObject := CreateComObject;
      var temp: Guid := ^Guid(riid)^;
      exit if lcom:QueryInterface(var temp, out ppvObject^) then rtl.S_OK else rtl.E_FAIL;
    end;

    [CallingConvention(CallingConvention.Stdcall)]
    method LockServer(fLock: rtl.BOOL): rtl.HRESULT;
    begin
      var lResult := rtl.CoLockObjectExternal(Self, fLock, True);
      ComServer.CountObject(fLock);
      exit lResult;
    end;

    [CallingConvention(CallingConvention.Stdcall)]
    method GetLicInfo(pLicInfo: ^rtl.LICINFO): rtl.HRESULT;
    begin
      raise new NotImplementedException;
    end;

    [CallingConvention(CallingConvention.Stdcall)]
    method RequestLicKey(dwReserved: rtl.DWORD; pBstrKey: ^^rtl.WCHAR): rtl.HRESULT;
    begin
      raise new NotImplementedException;
    end;

    [CallingConvention(CallingConvention.Stdcall)]
    method CreateInstanceLic(pUnkOuter: rtl.IUnknown; pUnkReserved: rtl.IUnknown; riid: ^rtl.GUID; bstrKey: ^rtl.WCHAR; ppvObj: ^rtl.PVOID): rtl.HRESULT;
    begin
      raise new NotImplementedException;
    end;
    {$ENDREGION}
  public
    constructor (aComServer: ComServerObject; aComClass: &Type;
      const aClassID: Guid; const aName, aDescription: String;
      aInstancing: ClassInstancing; aThreadingModel: ThreadingModel = ThreadingModel.Single);
    begin
      constructor(aComServer, aComClass, aClassID, aName, '', aDescription, aInstancing, aThreadingModel);
    end;

    constructor(aComServer: ComServerObject; aComClass: &Type;
      const aClassID: Guid; const aName, aVersion, aDescription: String;
      aInstancing: ClassInstancing; aThreadingModel: ThreadingModel = ThreadingModel.Single);
    begin
      ReferenceCount := 1;
      fClassID := aClassID;
      fThreadingModel := aThreadingModel;
      fDescription := aDescription;
      fName := aName;
      fVersion := aVersion;
      fComServer := aComServer;
      fComClass := aComClass;
      fInstancing := aInstancing;
      ComClassManager.AddObjectFactory(self);
      fIsRegistered := Cardinal(-1);
    end;

    method ComDispose;
    begin
      ComClassManager.RemoveObjectFactory(self);
    end;

    method UpdateRegistry(Value: Boolean);
    begin
      if fInstancing = ClassInstancing.Internal then Exit;
      var srv_type := iif(ModuleIsLib, 'InprocServer32', 'LocalServer32');
      var lguid := fClassID.ToString('B').ToUpper;
      var basekey := 'HKEY_CLASSES_ROOT\CLSID\' + lguid;
      var basekeyProgID := 'HKEY_CLASSES_ROOT\' + ProgID;

      var tm := iif(fThreadingModel = ThreadingModel.Single, '', fThreadingModel.ToString);
      if Value then begin
        Registry.SetValue(basekey + '\' + srv_type, '', fComServer.ServerFileName);
        Registry.SetValue(basekey + '\' + srv_type, 'ThreadingModel', tm);
        Registry.SetValue(basekey, '', fDescription);
        if ClassName <> '' then begin
          if ClassVersion <> '' then begin
            Registry.SetValue(basekey + '\ProgID', '', ProgID + '.' + ClassVersion);
            Registry.SetValue(basekey + '\VersionIndependentProgID', '', ProgID);
          end
          else begin
            Registry.SetValue(basekey + '\ProgID', '', ProgID);
          end;

          Registry.SetValue(basekeyProgID, '', Description);
          Registry.SetValue(basekeyProgID + '\CLSID', '', lguid);
          if ClassVersion <> '' then begin
            Registry.SetValue(basekeyProgID + '\CurVer', '', ProgID + '.' + ClassVersion);
            Registry.SetValue(basekeyProgID + '.' + ClassVersion, '', Description);
            Registry.SetValue(basekeyProgID + '.' + ClassVersion + '\CLSID', '', lguid);
          end;
        end;
      end
      else begin
        Registry.DeleteExistedKey(basekey + '\' + srv_type);
        Registry.DeleteExistedKey(basekey + '\VersionIndependentProgID');
        if ClassName <> '' then begin
          Registry.DeleteExistedKey(basekey + '\ProgID');
          Registry.DeleteExistedKey(basekeyProgID + '\CLSID');
          if ClassVersion <> '' then begin
            Registry.DeleteExistedKey(basekeyProgID + '\CurVer');
            Registry.DeleteExistedKey(basekeyProgID + '.' + ClassVersion + '\CLSID');
            Registry.DeleteExistedKey(basekeyProgID + '.' + ClassVersion);
          end;
          Registry.DeleteExistedKey(basekeyProgID);
        end;
        Registry.DeleteExistedKey(basekey);
      end;
    end;

    function CreateComObject: ComObject; virtual;
    begin
      exit ComObject(fComClass.Instantiate);
    end;

    property ClassID: Guid read fClassID;
    property ClassName: String read fName;
    property ClassVersion: String read fVersion;
    property ComClass: &Type read fComClass;
    property ComServer: ComServerObject read fComServer;
    property Description: String read fDescription;
    property ProgID: String read (fComServer.ServerName + '.' + fName);
    property Instancing: ClassInstancing read fInstancing;
    property ThreadingModel: ThreadingModel read fThreadingModel;
    property ErrorIID: Guid;
  end;

  LastReleaseEvent = method(var shutdown: Boolean);

  ComServerObject = public class(IComDispose)
  private
    fTypeLib: rtl.ITypeLib := nil;
    fServerFileName: String;
    fCountObject: Integer := 0;
    fServerName: String;
    method GetServerName: String;
    begin
      if fServerName <> '' then
        exit fServerName
      else if fTypeLib <> nil then
        exit GetTypeLibName
      else
        exit GetModuleName;
    end;

    method GetTypeLibName: String;
    begin
      if fTypeLib <> nil then begin
        var p: ^Char;
        OleCheck(fTypeLib.GetDocumentation(-1, var p, nil, nil, nil));
        exit String.FromPChar(p);
      end;
    end;

    class method GetModuleFileName: String;
    begin
      var lres := new Char[2048];
      var len := rtl.GetModuleFileNameW(ExternalCalls.ModuleHandle, @lres[0], 2048);
      exit String.FromPChar(@lres[0], len);
    end;

    method GetModuleName: String;
    begin
      exit Path.GetFileNameWithoutExtension(GetModuleFileName);
    end;

    method Start;
    begin
      ComClassManager.ForEachFactory(Self, @RegisterObjectWith);
    end;

    method RegisterObjectWith(Factory: ComObjectFactory);
    begin
      Factory.RegisterClassObject;
    end;

    method CheckReleased;
    begin
      if not IsInprocServer then begin
        var lShutdown := false;
        try
          if assigned(OnLastRelease) then OnLastRelease(var lShutdown);
        finally
          if lShutdown then rtl.PostThreadMessage(ExternalCalls.MainThreadID, rtl.WM_QUIT, 0, 0);
        end;
      end;
    end;

  assembly
    method CountObject(Created: Boolean): Integer;
    begin
      if Created then begin
        interlockedInc(var fCountObject);
        exit fCountObject;
      end
      else begin
        interlockedDec(var fCountObject);
        if fCountObject = 0 then CheckReleased;
        exit fCountObject;
      end;
    end;

    method RegisterServerFactory(Factory: ComObjectFactory);
    begin
      Factory.UpdateRegistry(true);
    end;

    method UnregisterServerFactory(Factory: ComObjectFactory);
    begin
      Factory.UpdateRegistry(false);
    end;

  public
    constructor;
    begin
      fServerFileName := GetModuleFileName;
      var lr := rtl.LoadTypeLib(fServerFileName.ToLPCWSTR, @fTypeLib);
      if lr <> rtl.S_OK then
        fTypeLib := nil;
      if fTypeLib <> nil then begin
        var lname := new Char[2048];
        fTypeLib.GetDocumentation(-1, @@lname[0], nil, nil, nil);
        fServerName := String.FromPChar(@lname[0]);
      end
      else begin
        fServerName := Path.GetFileNameWithoutExtension(fServerFileName);
      end;
    end;

    method ComDispose;
    begin
      ComClassManager.ClearFactories(Self);
    end;

    method CanUnloadNow: Boolean;
    begin
      exit False;
    end;

    method RegisterServer;
    begin
      if fTypeLib <> nil then
        rtl.RegisterTypeLib(fTypeLib, fServerFileName.ToLPCWSTR, nil);
      ComClassManager.ForEachFactory(self, @RegisterServerFactory);
    end;

    method UnregisterServer;
    begin
      if fTypeLib <> nil then begin
        var ptla: ^rtl.TLIBATTR;
        var res := fTypeLib.GetLibAttr(var ptla);
        if res <> rtl.S_OK then new OleError(res);
        try
          rtl.UnRegisterTypeLib(var ptla^.guid, ptla^.wMajorVerNum, ptla^.wMinorVerNum, ptla^.lcid, ptla^.syskind);
        finally
          fTypeLib.ReleaseTLibAttr(ptla);
        end;
      end;
      ComClassManager.ForEachFactory(self, @UnregisterServerFactory);
    end;

    property IsInprocServer: Boolean read write := False;
    property ServerObjects: Integer read fCountObject;
    property ServerFileName: String read fServerFileName;
    property ServerName: String read GetServerName;
    property HelpFileName: String;
    event OnLastRelease: LastReleaseEvent;
  end;

  ComClassManager = public static class
  private
    fClassFactoryList: List<ComObjectFactory> := new List<ComObjectFactory>;
  public
    method GetFactoryFromClass(ComClass: &Type): ComObjectFactory;
    begin
      for i: Integer := 0 to fClassFactoryList.Count -1 do
        if fClassFactoryList[i].ComClass = ComClass then
          exit fClassFactoryList[i];
      exit nil;
    end;

    method GetFactoryFromClassID(clsid: Guid):ComObjectFactory;
    begin
      for i: Integer := 0 to fClassFactoryList.Count - 1 do
        if fClassFactoryList[i].ClassID = clsid then
          exit fClassFactoryList[i];
      exit nil;
    end;

    method ForEachFactory(aComServer: ComServerObject; anAction: Action<ComObjectFactory>);
    begin
      for i: Integer := 0 to fClassFactoryList.Count - 1 do
        if fClassFactoryList[i].ComServer = aComServer then
          anAction(fClassFactoryList[i]);
    end;

    method AddObjectFactory(Factory: ComObjectFactory);
    begin
      fClassFactoryList.Add(Factory);
    end;

    method RemoveObjectFactory(Factory: ComObjectFactory);
    begin
      fClassFactoryList.Remove(Factory);
    end;

    method ClearFactories(aComServer: ComServerObject);
    begin
      for i: Integer := fClassFactoryList.Count -1 downto 0 do
        if fClassFactoryList[i].ComServer = aComServer then
          fClassFactoryList.RemoveAt(i);
    end;
  end;

var
  ComServer: ComServerObject;

method CreateComObject(const clsid: Guid): IUnknown;
begin
  var res : IUnknown;
  var IID_IUnknown: rtl.GUID := new Guid('{00000000-0000-0000-C000-000000000046}');
  OleCheck(rtl.CoCreateInstance(^rtl.GUID(@clsid), nil,
                                rtl.DWORD(rtl.CLSCTX.CLSCTX_INPROC_SERVER or rtl.CLSCTX.CLSCTX_LOCAL_SERVER),
                                @IID_IUnknown,
                                ^rtl.LPVOID(@res)));
  exit res;
end;

function HandleSafeCallException(ExceptObject: Object; ExceptAddr: ^Void; const ErrorIID: Guid; const ProgID, HelpFileName: String): rtl.HRESULT;
begin
  Result := rtl.E_UNEXPECTED;
  var _CreateErrorInfo : rtl.ICreateErrorInfo;
  if rtl.CreateErrorInfo(@_CreateErrorInfo) and $80000000 = 0 then begin
    _CreateErrorInfo.SetGUID(^rtl.GUID(@ErrorIID));
    if ProgID <> '' then _CreateErrorInfo.SetSource(@(ProgID.ToCharArray(True)[0]));
    if HelpFileName <> '' then _CreateErrorInfo.SetHelpFile(@(HelpFileName.ToCharArray(True)[0]));
    if ExceptObject is Exception then begin
      _CreateErrorInfo.SetDescription(@(Exception(ExceptObject).Message.ToCharArray(True)[0]));
      //_CreateErrorInfo.SetHelpContext(Exception(ExceptObject).HelpContext);
      if (ExceptObject is OleError) and (OleError(ExceptObject).ErrorCode < 0) then
        Result := OleError(ExceptObject).ErrorCode;
    end;
    var ErrorInfo: rtl.IErrorInfo;
    var temp: rtl.GUID := new Guid('{1CF2B120-547D-101B-8E65-08002B2BD119}');
    if _CreateErrorInfo.QueryInterface(@temp, ^^Void(@ErrorInfo)) = rtl.S_OK then
      rtl.SetErrorInfo(0, ErrorInfo);
  end;
end;

method OleCheck(Code: rtl.HRESULT);
begin
  if Code <> rtl.S_OK then raise new OleError(Code);
end;

method DllGetClassObject(var clsid: Guid; var iid: Guid;out ppv: ^Void): rtl.HRESULT;
begin
  var l_factory := ComClassManager.GetFactoryFromClassID(clsid);
  if (l_factory <> nil) and l_factory.QueryInterface(var iid, out ppv) then
    exit rtl.S_OK
  else
    exit rtl.CLASS_E_CLASSNOTAVAILABLE;
end;

method DllCanUnloadNow: rtl.HRESULT;
begin
  if ComServer:CanUnloadNow then
    exit rtl.S_OK
  else
    exit rtl.S_FALSE;
end;

method DllRegisterServer: rtl.HRESULT;
begin
  try
    ComServer:RegisterServer;
    exit rtl.S_OK;
  except
    exit rtl.E_FAIL;
  end;
end;

method DllUnregisterServer: rtl.HRESULT;
begin
  try
    ComServer:UnregisterServer;
    exit rtl.S_OK;
  except
    exit rtl.E_FAIL;
  end;
end;

end.