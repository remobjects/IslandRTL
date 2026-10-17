namespace RemObjects.Elements.System;

{$IF NOT WEBASSEMBLY}

interface

type
  PlatformSocketHandle = {$IF WINDOWS}rtl.SOCKET{$ELSE}Integer{$ENDIF};

  SocketException = public class(Exception)
  public
    constructor(aOperation: String; aErrorCode: Integer);
    property ErrorCode: Integer; readonly;
  end;

  SocketAcceptInterruptedException = public class(Exception)
  public
    constructor;
  end;

  LingerOption = public class
  public
    constructor(aEnabled: Boolean; aLingerTime: Integer);
    property Enabled: Boolean;
    property LingerTime: Integer;
  end;

  AddressFamily = public enum(Unknown = -1, Unspecified = 0, Unix = 1, InterNetwork = 2, ImpLink = 3, Pup = 4, Chaos = 5, NS = 6,
    Ipx = 6, Iso = 7, Osi = 7, Ecma = 8, DataKit = 9, Ccitt = 10, Sna = 11, DecNet = 12, DataLink = 13, Lat = 14, HyperChannel = 15,
    AppleTalk = 16, NetBios = 17, VoiceView = 18, FireFox = 19, Banyan = 21, Atm = 22, InterNetworkV6 = 23, Cluster = 24,
    Ieee12844 = 25, Irda = 26, NetworkDesigners = 28, Max = 29);

  SocketType = public enum(Stream = 1, Dgram = 2, Raw = 3, Rdm = 4, Seqpacket = 5, Unknown = -1);

  ProtocolType = public enum(IP = 0, Icmp = 1, Igmp = 2, Ggp = 3, Tcp = 6, Pup = 12, Udp = 17, Idp = 22, IPv6 = 41, ND = 77,
    Raw = 255, Unspecified = 0, Ipx = 1000, Spx = 1256, SpxII = 1257, Unknown = -1, IPv4 = 4, IPv6RoutingHeader = 43,
    IPv6FragmentHeader = 44, IPSecEncapsulatingSecurityPayload = 50, IPSecAuthenticationHeader = 51, IcmpV6 = 58,
    IPv6NoNextHeader = 59, IPv6DestinationOptions = 60, IPv6HopByHopOptions = 0);

  SocketFlags = public enum(None = 0, OutOfBand = 1, Peek = 2, DontRoute = 4, MaxIOVectorLength = 16, Truncated = 256,
    ControlDataTruncated = 512, Broadcast = 1024, Multicast = 2048, &Partial = 32768);

  SocketShutdown = public enum(Receive = 0, Send = 1, Both = 2);

  SocketOptionLevel = public enum(Socket = 65535, IP = 0, IPv6 = 41, Tcp = 6, Udp = 17);

  SocketOptionName = public enum(Debug = 1, AcceptConnection = 2, ReuseAddress = 4, KeepAlive = 8, DontRoute = 16, Broadcast = 32,
    UseLoopback = 64, Linger = 128, OutOfBandInline = 256, DontLinger = -129, ExclusiveAddressUse = -5, SendBuffer = 4097,
    ReceiveBuffer = 4098, SendLowWater = 4099, ReceiveLowWater = 4100, SendTimeout = 4101, ReceiveTimeout = 4102, Error = 4103,
    &Type = 4104, MaxConnections = 2147483647, IPOptions = 1, HeaderIncluded = 2, TypeOfService = 3, IpTimeToLive = 4,
    MulticastInterface = 9, MulticastTimeToLive = 10, MulticastLoopback = 11, AddMembership = 12, DropMembership = 13,
    DontFragment = 14, AddSourceMembership = 15, DropSourceMembership = 16, BlockSource = 17, UnblockSource = 18,
    PacketInformation = 19, NoDelay = 1, BsdUrgent = 2, Expedited = 2, NoChecksum = 1, ChecksumCoverage = 20,
    HopLimit = 21, UpdateAcceptContext = 28683, UpdateConnectContext = 28688);

  EndPoint = public class
  public
    property AddressFamily: AddressFamily;
  end;

  IPEndPoint = public class(EndPoint)
  public
    Address: IPAddress;
    Port: Integer;

    constructor(anAddress: IPAddress; aPort: Int32);
  end;

  IPAddress = public class
  private
    fAddress: Int64;
    fFamily: AddressFamily;
    fNumbers := new UInt16[IPv6Length / 2];
    fScopeId: Int64;

    class method TryParseIPV4(ipString: String; out address: IPAddress): Boolean;
    class method TryParseIPV6(ipString: String; out address: IPAddress): Boolean;
    class method ParseIPV4(ip: String): IPAddress;
    class method ParseIPV6(ip: String): IPAddress;
  public
    const IPv4Length =  4;
    const IPv6Length = 16;

    constructor(anAddress: array of Byte; aScopeId: Int64);
    constructor(anAddress: array of Byte);
    constructor(newAddress: Int64);

    class method TryParse(ipString: String; out address: IPAddress): Boolean;
    class method Parse(ipString: String): IPAddress;
    method GetAddressBytes: array of Byte;

    property ScopeId: Int64 read fScopeId write fScopeId;
    property Address: Int64 read fAddress write fAddress;
    property AddressFamily: AddressFamily read fFamily write fFamily;
  end;

  IPHostEntry = public class
  public
    property AddressList: array of IPAddress;
    property Aliases: array of String;
    property HostName: String;
  end;

  Dns = public static class
  private assembly
    {$IF WINDOWS}
    class var Initialized: Boolean := false;
    method InitSockets;
    {$ENDIF}
    method InternalGetHostByAddress(address: IPAddress): IPHostEntry;
    method InternalGetHostByName(aHost: String): IPHostEntry;
  public
    method GetHostEntry(aHostOrAddress: String): IPHostEntry;
    method GetHostEntry(address: IPAddress): IPHostEntry;
    method GetHostName: String;
    method GetHostAddresses(aHostOrAddress: String): array of IPAddress;
  end;

  Socket = public class(IDisposable)
  private
    fHandle: PlatformSocketHandle;
    fIsClosing: Int32; volatile;
    fLocalEndPoint: EndPoint;
    fRemoteEndPoint: EndPoint;
    constructor(aHandle: PlatformSocketHandle);
    method GetLocalEndPoint: EndPoint;
    method GetRemoteEndPoint: EndPoint;
    class constructor;
    method InternalSetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: ^Void; aOptionValueLength: Int32): Boolean;
  public
    constructor(anAddressFamily: AddressFamily; aSocketType: SocketType; aProtocol: ProtocolType);

    method Accept: Socket;

    method Bind(aEndPoint: IPEndPoint);

    method Connect(aEndPoint: EndPoint);
    method Connect(aHostOrIPAddress: String; aPort: Integer);
    method Connect(aIP: IPAddress; aPort: Int32);
    method Disconnect;

    method Listen(aBackLog: Integer);

    method Receive(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
    method Receive(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
    method Receive(aBuffer: array of Byte): Integer;
    method Receive(aBuffer: Span<Byte>; aFlags: SocketFlags): Integer;

    method Send(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
    method Send(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
    method Send(aBuffer: array of Byte): Integer;
    method Send(aBuffer:ImmutableSpan<Byte>; aFlags: SocketFlags): Integer;

    method ReceiveFrom(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags; var remoteEP: EndPoint): Integer;
    method SendTo(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags; remoteEP: EndPoint): Integer;

    method Shutdown(aMode: SocketShutdown);
    method Close;
    method Dispose;

    method DataAvailable: Integer;

    method SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Int32);
    method SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Boolean);
    method SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Object);
    method SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: array of Byte);

    property AddressFamily: AddressFamily;
    property Handle: PlatformSocketHandle read fHandle;
    property Connected: Boolean;
    property ProtocolType: ProtocolType;
    property SocketType: SocketType;
    property LocalEndPoint: EndPoint read GetLocalEndPoint;
    property RemoteEndPoint: EndPoint read GetRemoteEndPoint;
  end;

  NetworkStream = public class(Stream)
  private
    fSocket: Socket;
  public
    constructor(aSocket: Socket);
    begin
      fSocket := aSocket;
    end;

    property CanRead: Boolean read true; override;
    property CanWrite: Boolean read true; override;
    property CanSeek: Boolean read false; override;

    method Close; override;
    begin
      if fSocket = nil then
        exit;
      try
        if fSocket.Connected then
          fSocket.Shutdown(SocketShutdown.Both);
      finally
        disposeAndNil(fSocket);
      end;
    end;

    method Seek(Offset: Int64; Origin: SeekOrigin): Int64; override;
    begin
      raise new NotSupportedException;
    end;

    method &Read(aSpan: Span<Byte>): Integer; override;
    begin
      result := fSocket.Receive(aSpan, SocketFlags.None);
    end;

    method &Write(aSpan: ImmutableSpan<Byte>): Integer; override;
    begin
      result := fSocket.Send(aSpan, SocketFlags.None);
    end;

    method Flush; override;
    begin
    end;

    method IsValid: Boolean; override;
    begin
      exit (fSocket <> nil) and (fSocket.Connected);
    end;

  end;

 implementation

{$IF WINDOWS}
const NativeAF_INET = 2;
const NativeAF_INET6 = 23;
const NativeAF_UNSPEC = 0;
{$ELSE}
const NativeAF_INET = rtl.AF_INET;
const NativeAF_INET6 = rtl.AF_INET6;
const NativeAF_UNSPEC = rtl.AF_UNSPEC;
{$ENDIF}

// Older Linux imports omit asm-generic/socket.h and asm-generic/ioctls.h.
// The supported Linux x86/x86_64 and ARM targets use this ABI.
{$IF LINUX AND NOT ANDROID}
const Native_SOL_SOCKET = 1;
const Native_SO_DEBUG = 1;
const Native_SO_REUSEADDR = 2;
const Native_SO_TYPE = 3;
const Native_SO_ERROR = 4;
const Native_SO_DONTROUTE = 5;
const Native_SO_BROADCAST = 6;
const Native_SO_SNDBUF = 7;
const Native_SO_RCVBUF = 8;
const Native_SO_KEEPALIVE = 9;
const Native_SO_OOBINLINE = 10;
const Native_SO_LINGER = 13;
const Native_SO_RCVLOWAT = 18;
const Native_SO_SNDLOWAT = 19;
const Native_SO_RCVTIMEO = 20;
const Native_SO_SNDTIMEO = 21;
const Native_SO_ACCEPTCONN = 30;
const Native_FIONREAD = 21531;
{$ELSE}
const Native_SOL_SOCKET = rtl.SOL_SOCKET;
const Native_SO_DEBUG = rtl.SO_DEBUG;
const Native_SO_REUSEADDR = rtl.SO_REUSEADDR;
const Native_SO_TYPE = rtl.SO_TYPE;
const Native_SO_ERROR = rtl.SO_ERROR;
const Native_SO_DONTROUTE = rtl.SO_DONTROUTE;
const Native_SO_BROADCAST = rtl.SO_BROADCAST;
const Native_SO_SNDBUF = rtl.SO_SNDBUF;
const Native_SO_RCVBUF = rtl.SO_RCVBUF;
const Native_SO_KEEPALIVE = rtl.SO_KEEPALIVE;
const Native_SO_OOBINLINE = rtl.SO_OOBINLINE;
const Native_SO_LINGER = rtl.SO_LINGER;
const Native_SO_RCVLOWAT = rtl.SO_RCVLOWAT;
const Native_SO_SNDLOWAT = rtl.SO_SNDLOWAT;
const Native_SO_RCVTIMEO = rtl.SO_RCVTIMEO;
const Native_SO_SNDTIMEO = rtl.SO_SNDTIMEO;
const Native_SO_ACCEPTCONN = rtl.SO_ACCEPTCONN;
const Native_FIONREAD = rtl.FIONREAD;
{$ENDIF}

method CopySocketBytes(aDestination, aSource: ^Void; aLength: Integer);
begin
  for i := 0 to aLength - 1 do
    ^Byte(aDestination)[i] := ^Byte(aSource)[i];
end;

constructor SocketException(aOperation: String; aErrorCode: Integer);
begin
  inherited constructor(String.Format('{0} failed (native error {1})', aOperation, aErrorCode));
  ErrorCode := aErrorCode;
end;

constructor SocketAcceptInterruptedException;
begin
  inherited constructor('Socket accept was interrupted because the listening socket was closed.');
end;

constructor LingerOption(aEnabled: Boolean; aLingerTime: Integer);
begin
  Enabled := aEnabled;
  LingerTime := aLingerTime;
end;

method LastSocketError: Integer;
begin
  {$IF WINDOWS}
  result := rtl.WSAGetLastError;
  {$ELSE}
  result := rtl.errno;
  {$ENDIF}
end;

method NativeAddressFamily(aFamily: AddressFamily): Integer;
begin
  case aFamily of
    AddressFamily.InterNetwork: exit NativeAF_INET;
    AddressFamily.InterNetworkV6: exit NativeAF_INET6;
    AddressFamily.Unspecified: exit NativeAF_UNSPEC;
    {$IF POSIX}AddressFamily.Unix: exit rtl.AF_UNIX;{$ENDIF}
    else raise new NotSupportedException('Unsupported address family');
  end;
end;

method NativeSocketFlags(aFlags: SocketFlags): Integer;
begin
  result := 0;
  if (Integer(aFlags) and not (Integer(SocketFlags.OutOfBand) or Integer(SocketFlags.Peek) or Integer(SocketFlags.DontRoute))) <> 0 then
    raise new NotSupportedException('Unsupported socket flags');
  if (Integer(aFlags) and Integer(SocketFlags.OutOfBand)) <> 0 then
    result := result or rtl.MSG_OOB;
  if (Integer(aFlags) and Integer(SocketFlags.Peek)) <> 0 then
    result := result or rtl.MSG_PEEK;
  if (Integer(aFlags) and Integer(SocketFlags.DontRoute)) <> 0 then
    result := result or rtl.MSG_DONTROUTE;
end;

method CheckSocketBuffer(aBuffer: array of Byte; aOffset, aSize: Integer);
begin
  if aBuffer = nil then
    raise new ArgumentNullException('aBuffer');
  if (aOffset < 0) or (aSize < 0) or (aOffset > length(aBuffer)) or (aSize > length(aBuffer) - aOffset) then
    raise new ArgumentOutOfRangeException('aOffset/aSize');
end;

 constructor IPEndPoint(anAddress: IPAddress; aPort: Int32);
 begin
   Address := anAddress;
   if (aPort < 0) or (aPort > 65535) then
     raise new ArgumentOutOfRangeException("aPort");
   Port := aPort;
   if anAddress <> nil then
     AddressFamily := anAddress.AddressFamily;
 end;

constructor IPAddress(anAddress: array of Byte; aScopeId: Int64);
begin
  if length(anAddress) <> IPv6Length then
    raise new ArgumentException("IPv6 addresses require 16 bytes");
  fFamily := AddressFamily.InterNetworkV6;
  for i: Integer := 0 to (IPv6Length / 2) - 1 do
    fNumbers[i] := UInt16(anAddress[i * 2] * 256 + anAddress[i * 2 + 1]);
  fScopeId := aScopeId;
end;

constructor IPAddress(anAddress: array of Byte);
begin
  if length(anAddress) = IPv4Length then begin
    fFamily := AddressFamily.InterNetwork;
    fAddress := ((anAddress[3] shl 24 or anAddress[2] shl 16 or anAddress[1] shl 8 or anAddress[0]) and $0FFFFFFFF);
  end
  else begin
    if length(anAddress) <> IPv6Length then
      raise new ArgumentException("IP addresses require 4 or 16 bytes");
    fFamily := AddressFamily.InterNetworkV6;
    for i: Integer := 0 to (IPv6Length / 2) - 1 do
      fNumbers[i] := UInt16(anAddress[i * 2] * 256 + anAddress[i * 2 + 1]);
  end;
end;

constructor IPAddress(newAddress: Int64);
begin
  fFamily := AddressFamily.InterNetwork;
  fAddress := newAddress;
end;

class method IPAddress.Parse(ipString: String): IPAddress;
begin
  var lAddress: IPAddress;
  if TryParse(ipString, out lAddress) then
    result := lAddress
  else
    raise new Exception(String.Format("'{0}' is not a valid IP address", ipString));
end;

method IPAddress.GetAddressBytes: array of Byte;
begin
  if AddressFamily = AddressFamily.InterNetworkV6 then begin
    result := new Byte[IPv6Length];

    var j := 0;
    for i: Integer := 0 to (IPv6Length / 2) - 1 do begin
      result[j] := Byte((fNumbers[i] shr 8) and $FF);
      inc(j);
      result[j] := Byte((fNumbers[i]) and $FF);
      inc(j);
    end;
  end
  else begin
    result := new Byte[IPv4Length];
    result[0] := Byte(Address);
    result[1] := Byte(Address shr 8);
    result[2] := Byte(Address shr 16);
    result[3] := Byte(Address shr 24);
  end;
end;

class method IPAddress.TryParseIPV4(ipString: String; out address: IPAddress): Boolean;
begin
  result := false;

  var lNumbers := ipString.Trim().Split('.');
  var lNumber: Int64;
  var lBytes := new Byte[IPv4Length];

  if lNumbers.Count = IPv4Length then begin
    for i: Integer := 0 to IPv4Length - 1 do
      if Convert.TryParseInt64(lNumbers[i], out lNumber, false) and (lNumber >= 0) and (lNumber <= 255) then
        lBytes[i] := lNumber
      else
        exit false;

    address := new IPAddress(lBytes);
    result := true;
  end;
end;

{$IF WINDOWS}
type
  sockaddr_in6 = record
  public
    sin6_family: rtl.USHORT;
    sin6_port: rtl.USHORT;
    sin6_flowinfo: rtl.ULONG;
    sin6_addr: rtl.IN6_ADDR;
    sin6_scope_id: rtl.ULONG;
  end;
{$ENDIF}

class method IPAddress.TryParseIPV6(ipString: String; out address: IPAddress): Boolean;
begin
  address := nil;
  var lString := ipString;
  if lString.StartsWith('[') and lString.EndsWith(']') then
    lString := lString.Substring(1, lString.Length - 2);
  var lBytes := new Byte[16];
  {$IF POSIX}
  var lHints: rtl.__struct_addrinfo;
  lHints.ai_family := NativeAF_INET6;
  lHints.ai_flags := rtl.AI_NUMERICHOST;
  var lAddrInfo: ^rtl.__struct_addrinfo;
  if rtl.getaddrinfo(@lString.ToAnsiChars(true)[0], nil, @lHints, @lAddrInfo) <> 0 then
    exit false;
  try
    var lSockAddr := ^rtl.__struct_sockaddr_in6(lAddrInfo^.ai_addr);
    CopySocketBytes(@lBytes[0], @lSockAddr^.sin6_addr, 16);
    address := new IPAddress(lBytes, lSockAddr^.sin6_scope_id);
  finally
    rtl.freeaddrinfo(lAddrInfo);
  end;
  {$ELSE}
  Dns.InitSockets;
  var lHints: rtl.ADDRINFOW;
  lHints.ai_family := NativeAF_INET6;
  lHints.ai_flags := 4 {WinSock AI_NUMERICHOST};
  var lAddrInfo: rtl.PADDRINFOW;
  if rtl.GetAddrInfoW(lString.ToLPCWSTR, nil, @lHints, @lAddrInfo) <> 0 then
    exit false;
  try
    var lSockAddr := ^sockaddr_in6(lAddrInfo^.ai_addr);
    CopySocketBytes(@lBytes[0], @lSockAddr^.sin6_addr, 16);
    address := new IPAddress(lBytes, lSockAddr^.sin6_scope_id);
  finally
    rtl.FreeAddrInfoW(lAddrInfo);
  end;
  {$ENDIF}
  result := true;
end;

class method IPAddress.TryParse(ipString: String; out address: IPAddress): Boolean;
begin
  address := nil;
  if length(ipString) = 0 then
    exit false;
  if ipString.Contains(':') then
    result := TryParseIPV6(ipString, out address)
  else
    result := TryParseIPV4(ipString, out address);
end;

class method IPAddress.ParseIPV4(ip: String): IPAddress;
begin
  var lResult: IPAddress;

  if TryParseIPV4(ip, out lResult) then
    result := lResult
  else
    raise new Exception(String.Format("Can not parse '{0}' as IPv4 address", ip));
end;

class method IPAddress.ParseIPV6(ip: String): IPAddress;
begin
  var lResult: IPAddress;

  if TryParseIPV6(ip, out lResult) then
    result := lResult
  else
    raise new Exception(String.Format("Can not parse '{0}' as IPv6 address", ip));
end;

{$IF WINDOWS}
method Dns.InitSockets;
begin
  if not Initialized then begin
    var lData: rtl.WSADATA;
    rtl.WSAStartup(rtl.WINSOCK_VERSION, @lData);
    Initialized := true;
  end;
end;
{$ENDIF}

method Dns.InternalGetHostByAddress(address: IPAddress): IPHostEntry;
begin
  var lEndPoint := new IPEndPoint(address, 0);
  var lHostName := '';
  {$IF WINDOWS}
  var lSockAddr4: rtl.SOCKADDR_IN;
  var lSockAddr6: sockaddr_in6;
  var lPointer: ^Void;
  var lSize: Integer;
  var lName := new Char[255];
  var lService := new Char[255];

  InitSockets;
  IPEndPointToNative(lEndPoint, out lSockAddr4, out lSockAddr6, out lPointer, out lSize);
  if rtl.getnameinfo(^rtl.SOCKADDR(lPointer), lSize, @lName[0], 255, @lService[0], 255, 0) = 0 then
    lHostName := String.FromPChar(@lName[0])
  {$ELSEIF POSIX}
  var lSockAddr4: rtl.__struct_sockaddr_in;
  var lSockAddr6: rtl.__struct_sockaddr_in6;
  var lPointer: ^Void;
  var lSize: Integer;
  var lName := new AnsiChar[255];
  var lService := new AnsiChar[255];
  IPEndPointToNative(lEndPoint, out lSockAddr4, out lSockAddr6, out lPointer, out lSize);
  if rtl.getnameinfo(^rtl.__struct_sockaddr(lPointer), lSize, @lName[0], 255, @lService[0], 255, 0) = 0 then
    lHostName := String.FromPAnsiChar(@lName[0])
  {$ENDIF}
  if lHostName <> '' then
    result := InternalGetHostByName(lHostName)
  else
    result := new IPHostEntry();
end;

method Dns.InternalGetHostByName(aHost: String): IPHostEntry;
begin
  result := new IPHostEntry;
  result.HostName := aHost;
  result.Aliases := [];
  var lIPList := new List<IPAddress>;
  {$IF WINDOWS}
  InitSockets;
  var lAddrInfo: rtl.PADDRINFOW;
  var lError := rtl.GetAddrInfoW(aHost.ToLPCWSTR, nil, nil, @lAddrInfo);
  {$ELSE}
  var lAddrInfo: ^rtl.__struct_addrinfo;
  var lError := rtl.getaddrinfo(@aHost.ToAnsiChars(true)[0], nil, nil, @lAddrInfo);
  {$ENDIF}
  if lError <> 0 then
    raise new SocketException('getaddrinfo', lError);
  try
    var lPtr := lAddrInfo;
    while lPtr <> nil do begin
      if (lPtr^.ai_family = NativeAF_INET) or (lPtr^.ai_family = NativeAF_INET6) then begin
        var lEndPoint := new IPEndPoint(nil, 0);
        IPNativeToEndPoint(lPtr^.ai_addr, var lEndPoint);
        lIPList.Add(lEndPoint.Address);
      end;
      {$IF WINDOWS}
      lPtr := rtl.PADDRINFOW(lPtr^.ai_next);
      {$ELSE}
      lPtr := ^rtl.__struct_addrinfo(lPtr^.ai_next);
      {$ENDIF}
    end;
  finally
    {$IF WINDOWS}
    rtl.FreeAddrInfoW(lAddrInfo);
    {$ELSE}
    rtl.freeaddrinfo(lAddrInfo);
    {$ENDIF}
  end;
  result.AddressList := lIPList.ToArray;
end;

method Dns.GetHostEntry(aHostOrAddress: String): IPHostEntry;
begin
  if (aHostOrAddress = nil) or (aHostOrAddress = '') then
    raise new ArgumentNullException('GetHostEntry argument is empty');

  var lAddress: IPAddress;
  if IPAddress.TryParse(aHostOrAddress, out lAddress) then
    result := InternalGetHostByAddress(lAddress)
  else
    result := InternalGetHostByName(aHostOrAddress);
end;

method Dns.GetHostEntry(address: IPAddress): IPHostEntry;
begin
  if address = nil then
    raise new ArgumentNullException('GetHostEntry argument is empty');

  result := InternalGetHostByAddress(address);
end;

method Dns.GetHostName: String;
begin
  {$IF WINDOWS}
  var lBuffer := new Char[255];
  var lSize: rtl.DWORD := 255;
  if rtl.GetComputerNameEx(rtl.COMPUTER_NAME_FORMAT.ComputerNamePhysicalDnsHostname, @lBuffer[0], @lSize) then
    result := new String(@lBuffer[0], lSize)
  else
    result := '';
  {$ELSEIF POSIX}
  var lBuffer := new AnsiChar[255];
  if rtl.gethostname(@lBuffer[0], 255) = 0 then
    result := String.FromPAnsiChar(@lBuffer[0])
  else
    result := '';
  {$ENDIF}
end;

method Dns.GetHostAddresses(aHostOrAddress: String): array of IPAddress;
begin
  if (aHostOrAddress = nil) or (aHostOrAddress = '') then
    raise new ArgumentNullException('GetHostAddresses argument is empty');

  var lAddress: IPAddress;
  if IPAddress.TryParse(aHostOrAddress, out lAddress) then
    result := [lAddress]
  else
    result := InternalGetHostByName(aHostOrAddress).AddressList;
end;

{$IF DARWIN OR ANDROID}
method NetworkPort(port: Integer): Integer;
begin
  result := rtl.uint16_t(((rtl.uint16_t(port) and $ff00) shr 8) or ((rtl.uint16_t(port) and $00ff) shl 8));
end;
{$ENDIF}

{$IF POSIX}
method IPEndPointToNative(endPoint: IPEndPoint; out lIPv4: rtl.__struct_sockaddr_in; out lIPv6: rtl.__struct_sockaddr_in6; out ipPointer: ^Void; out ipSize: Integer);
begin
  case endPoint.AddressFamily of
    AddressFamily.InterNetworkV6: begin
      lIPv6 := default;
      {$IF DARWIN}
      lIPv6.sin6_len := sizeOf(lIPv6);
      {$ENDIF}
      lIPv6.sin6_family := NativeAF_INET6;
      {$IF DARWIN OR ANDROID}
      lIPv6.sin6_port := NetworkPort(endPoint.Port);
      {$ELSE}
      lIPv6.sin6_port := rtl.htons(endPoint.Port);
      {$ENDIF}
      lIPv6.sin6_scope_id := endPoint.Address.ScopeId;
      var lBytes := endPoint.Address.GetAddressBytes();
      CopySocketBytes(@lIPv6.sin6_addr, @lBytes[0], 16);
      ipPointer := @lIPv6;
      ipSize := sizeOf(rtl.__struct_sockaddr_in6);
    end;

    else begin
      lIPv4 := default;
      {$IF DARWIN}
      lIPv4.sin_len := sizeOf(lIPv4);
      {$ENDIF}
      lIPv4.sin_family := NativeAF_INET;
      {$IF DARWIN OR ANDROID}
      lIPv4.sin_port := NetworkPort(endPoint.Port);
      {$ELSE}
      lIPv4.sin_port := rtl.htons(endPoint.Port);
      {$ENDIF}

      lIPv4.sin_addr.s_addr := endPoint.Address.Address;
      ipSize := sizeOf(rtl.__struct_sockaddr_in);
      ipPointer := @lIPv4;
    end;
  end;
end;
{$ELSE}
method IPEndPointToNative(endPoint: IPEndPoint; out lIPv4: rtl.SOCKADDR_IN; out lIPv6: sockaddr_in6; out ipPointer: ^Void; out ipSize: Integer);
begin
  case endPoint.AddressFamily of
    AddressFamily.InterNetworkV6: begin
      lIPv6 := default;
      lIPv6.sin6_family := NativeAF_INET6;
      lIPv6.sin6_port := rtl.htons(endPoint.Port);
      lIPv6.sin6_scope_id := endPoint.Address.ScopeId;
      var lBytes := endPoint.Address.GetAddressBytes();
      for i: Integer := 0 to 15 do
        lIPv6.sin6_addr.u.Byte[i] := lBytes[i];
      ipPointer := @lIPv6;
      ipSize := sizeOf(sockaddr_in6);
    end;

    else begin
      lIPv4 := default;
      lIPv4.sin_family := NativeAF_INET;
      lIPv4.sin_port := rtl.htons(endPoint.Port);
      lIPv4.sin_addr.S_un.S_addr := endPoint.Address.Address;
      ipSize := sizeOf(rtl.SOCKADDR_IN);
      ipPointer := @lIPv4;
    end;
  end;
end;
{$ENDIF}

method Socket.InternalSetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: ^Void; aOptionValueLength: Int32): Boolean;
begin
  {$IF WINDOWS}
  var lLevel := Integer(aOptionLevel);
  var lName := Integer(aOptionName);
  {$ELSE}
  var lLevel: Integer;
  var lName: Integer;
  case aOptionLevel of
    SocketOptionLevel.Socket: begin
      lLevel := Native_SOL_SOCKET;
      case aOptionName of
        SocketOptionName.Debug: lName := Native_SO_DEBUG;
        SocketOptionName.AcceptConnection: lName := Native_SO_ACCEPTCONN;
        SocketOptionName.ReuseAddress: lName := Native_SO_REUSEADDR;
        SocketOptionName.KeepAlive: lName := Native_SO_KEEPALIVE;
        SocketOptionName.DontRoute: lName := Native_SO_DONTROUTE;
        SocketOptionName.Broadcast: lName := Native_SO_BROADCAST;
        SocketOptionName.Linger: lName := Native_SO_LINGER;
        SocketOptionName.OutOfBandInline: lName := Native_SO_OOBINLINE;
        SocketOptionName.SendBuffer: lName := Native_SO_SNDBUF;
        SocketOptionName.ReceiveBuffer: lName := Native_SO_RCVBUF;
        SocketOptionName.SendLowWater: lName := Native_SO_SNDLOWAT;
        SocketOptionName.ReceiveLowWater: lName := Native_SO_RCVLOWAT;
        SocketOptionName.SendTimeout: lName := Native_SO_SNDTIMEO;
        SocketOptionName.ReceiveTimeout: lName := Native_SO_RCVTIMEO;
        SocketOptionName.Error: lName := Native_SO_ERROR;
        SocketOptionName.Type: lName := Native_SO_TYPE;
        else raise new NotSupportedException('Unsupported socket option');
      end;
    end;
    SocketOptionLevel.Tcp: begin
      lLevel := rtl.IPPROTO_TCP;
      if aOptionName <> SocketOptionName.NoDelay then
        raise new NotSupportedException('Unsupported TCP option');
      lName := rtl.TCP_NODELAY;
    end;
    SocketOptionLevel.IP: begin
      lLevel := rtl.IPPROTO_IP;
      case aOptionName of
        SocketOptionName.IPOptions: lName := rtl.IP_OPTIONS;
        SocketOptionName.HeaderIncluded: lName := rtl.IP_HDRINCL;
        SocketOptionName.TypeOfService: lName := rtl.IP_TOS;
        SocketOptionName.IpTimeToLive: lName := rtl.IP_TTL;
        SocketOptionName.MulticastInterface: lName := rtl.IP_MULTICAST_IF;
        SocketOptionName.MulticastTimeToLive: lName := rtl.IP_MULTICAST_TTL;
        SocketOptionName.MulticastLoopback: lName := rtl.IP_MULTICAST_LOOP;
        SocketOptionName.AddMembership: lName := rtl.IP_ADD_MEMBERSHIP;
        SocketOptionName.DropMembership: lName := rtl.IP_DROP_MEMBERSHIP;
        else raise new NotSupportedException('Unsupported IP option');
      end;
    end;
    SocketOptionLevel.IPv6: begin
      lLevel := rtl.IPPROTO_IPV6;
      case aOptionName of
        SocketOptionName.HopLimit: lName := rtl.IPV6_UNICAST_HOPS;
        SocketOptionName.MulticastInterface: lName := rtl.IPV6_MULTICAST_IF;
        SocketOptionName.MulticastTimeToLive: lName := rtl.IPV6_MULTICAST_HOPS;
        SocketOptionName.MulticastLoopback: lName := rtl.IPV6_MULTICAST_LOOP;
        SocketOptionName.AddMembership: lName := rtl.IPV6_JOIN_GROUP;
        SocketOptionName.DropMembership: lName := rtl.IPV6_LEAVE_GROUP;
        else raise new NotSupportedException('Unsupported IPv6 option');
      end;
    end;
    else raise new NotSupportedException('Unsupported socket option level');
  end;
  {$ENDIF}
  if rtl.setsockopt(fHandle, lLevel, lName, ^AnsiChar(aOptionValue), aOptionValueLength) <> 0 then
    raise new SocketException('setsockopt', LastSocketError);
  result := true;
end;

constructor Socket(aHandle: PlatformSocketHandle);
begin
  fHandle := aHandle;
  {$IF DARWIN}
  var lNoSigPipe: Integer := 1;
  if rtl.setsockopt(fHandle, Native_SOL_SOCKET, rtl.SO_NOSIGPIPE, ^AnsiChar(@lNoSigPipe), sizeOf(lNoSigPipe)) <> 0 then begin
    var lError := LastSocketError;
    rtl.close(fHandle);
    raise new SocketException('setsockopt(SO_NOSIGPIPE)', lError);
  end;
  {$ENDIF}
end;

class constructor Socket;
begin
  {$IF WINDOWS}
  Dns.InitSockets;
  {$ENDIF}
end;

constructor Socket(anAddressFamily: AddressFamily; aSocketType: SocketType; aProtocol: ProtocolType);
begin
  var lType: Integer;
  case aSocketType of
    SocketType.Stream: lType := rtl.SOCK_STREAM;
    SocketType.Dgram: lType := rtl.SOCK_DGRAM;
    SocketType.Raw: lType := rtl.SOCK_RAW;
    else raise new NotSupportedException('Unsupported socket type');
  end;
  AddressFamily := anAddressFamily;
  SocketType := aSocketType;
  ProtocolType := aProtocol;
  {$IF POSIX_LIGHT}
  fHandle := rtl.socket(rtl.int32_t(NativeAddressFamily(anAddressFamily)), rtl.int32_t(lType), rtl.int32_t(aProtocol));
  {$ELSEIF WINDOWS}
  fHandle := rtl.socket(rtl.INT(NativeAddressFamily(anAddressFamily)), rtl.INT(lType), rtl.INT(aProtocol));
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}

  if {$IF WINDOWS}fHandle = rtl.INVALID_SOCKET{$ELSE}fHandle < 0{$ENDIF} then
    raise new SocketException("socket", LastSocketError);
  {$IF DARWIN}
  var lNoSigPipe: Integer := 1;
  if rtl.setsockopt(fHandle, Native_SOL_SOCKET, rtl.SO_NOSIGPIPE, ^AnsiChar(@lNoSigPipe), sizeOf(lNoSigPipe)) <> 0 then begin
    var lError := LastSocketError;
    rtl.close(fHandle);
    raise new SocketException('setsockopt(SO_NOSIGPIPE)', lError);
  end;
  {$ENDIF}
end;

method Socket.Accept: Socket;
begin
  if fIsClosing <> 0 then
    raise new SocketAcceptInterruptedException;
  {$IF FUCHSIA}
  var lSocket: Integer;
  loop begin
    if fIsClosing <> 0 then
      raise new SocketAcceptInterruptedException;
    lSocket := rtl.accept(fHandle, nil, nil);
    if lSocket >= 0 then
      break;
    var lError := LastSocketError;
    if fIsClosing <> 0 then
      raise new SocketAcceptInterruptedException;
    if (lError <> rtl.EAGAIN) and (lError <> rtl.EINTR) then
      raise new SocketException('accept', lError);
    var lPoll: rtl.__struct_pollfd;
    lPoll.fd := fHandle;
    lPoll.events := rtl.POLLIN;
    // fdio shutdown/close does not interrupt a blocking accept on a listener.
    // Poll in bounded intervals so Close can always cancel the operation.
    if rtl.poll(@lPoll, 1, 50) < 0 then begin
      lError := LastSocketError;
      if fIsClosing <> 0 then
        raise new SocketAcceptInterruptedException;
      if lError <> rtl.EINTR then
        raise new SocketException('poll(accept)', lError);
    end;
  end;
  if fIsClosing <> 0 then begin
    rtl.close(lSocket);
    raise new SocketAcceptInterruptedException;
  end;
  {$ELSEIF POSIX AND (NOT (ANDROID OR DARWIN OR FUCHSIA))}
  var lSockAddr: rtl.__SOCKADDR_ARG;
  lSockAddr.__sockaddr__ := nil;
  var lSocket := rtl.accept(fHandle, lSockAddr, nil);

  {$ELSE}
  var lSocket := rtl.accept(fHandle, nil, nil);

  {$ENDIF}

  if {$IF WINDOWS}lSocket = rtl.INVALID_SOCKET{$ELSE}lSocket < 0{$ENDIF} then begin
    var lError := LastSocketError;
    if fIsClosing <> 0 then
      raise new SocketAcceptInterruptedException;
    raise new SocketException('accept', lError);
  end;
  result := new Socket(lSocket);
  result.AddressFamily := AddressFamily;
  result.SocketType := SocketType;
  result.ProtocolType := ProtocolType;
  result.Connected := true;
end;

method Socket.Bind(aEndPoint: IPEndPoint);
begin
  var lEndPoint := IPEndPoint(aEndPoint);
  if lEndPoint.Address = nil then
    lEndPoint := new IPEndPoint(IPAddress.Parse("0.0.0.0"), lEndPoint.Port);
  var lPointer: ^Void;
  var lSize: Integer;
  {$IF POSIX}
  var lIPv4: rtl.__struct_sockaddr_in;
  var lIPv6: rtl.__struct_sockaddr_in6;
  {$IF POSIX AND (NOT (ANDROID OR DARWIN OR FUCHSIA))}
  var lSockAddr: rtl.__CONST_SOCKADDR_ARG;
  {$ENDIF}
  {$ELSE}
  var lIPv4: rtl.SOCKADDR_IN;
  var lIPv6: sockaddr_in6;
  {$ENDIF}

  IPEndPointToNative(lEndPoint, out lIPv4, out lIPv6, out lPointer, out lSize);
  {$IF POSIX AND (NOT (ANDROID OR DARWIN OR FUCHSIA))}
  lSockAddr.__sockaddr__ := ^rtl.__struct_sockaddr(lPointer);
  lSockAddr.__sockaddr_in__ := ^rtl.__struct_sockaddr_in(lPointer);
  if rtl.bind(fHandle, lSockAddr, lSize) <> 0 then
    raise new SocketException("bind", LastSocketError);
  {$ELSEIF DARWIN OR ANDROID OR FUCHSIA}
  if rtl.bind(fHandle, ^rtl.__struct_sockaddr(lPointer), lSize) <> 0 then
    raise new SocketException("bind", LastSocketError);
  {$ELSEIF WINDOWS}
  if rtl.bind(fHandle, lPointer, lSize) <> 0 then
    raise new SocketException("bind", LastSocketError);
  {$ENDIF}
  fLocalEndPoint := nil;
end;

method Socket.Connect(aEndPoint: EndPoint);
begin
  var lEndPoint := IPEndPoint(aEndPoint);
  var lPointer: ^Void;
  var lSize: Integer;

  {$IF POSIX}
  var lIPv4: rtl.__struct_sockaddr_in;
  var lIPv6: rtl.__struct_sockaddr_in6;
  {$IF POSIX AND (NOT (ANDROID OR DARWIN OR FUCHSIA))}
  var lSockAddr: rtl.__CONST_SOCKADDR_ARG;
  {$ENDIF}
  {$ELSE}
  var lIPv4: rtl.SOCKADDR_IN;
  var lIPv6: sockaddr_in6;
  {$ENDIF}

  IPEndPointToNative(lEndPoint, out lIPv4, out lIPv6, out lPointer, out lSize);
  var lRes := 0;
  {$IF POSIX AND (NOT (ANDROID OR DARWIN OR FUCHSIA))}
  lSockAddr.__sockaddr__ := ^rtl.__struct_sockaddr(lPointer);
  lRes := rtl.connect(fHandle, lSockAddr, lSize);
  {$ELSEIF DARWIN OR ANDROID OR FUCHSIA}
  lRes := rtl.connect(fHandle, ^rtl.__struct_sockaddr(lPointer), lSize);
  {$ELSE}
  lRes := rtl.connect(fHandle, lPointer, lSize);
  {$ENDIF}
  if lRes <> 0 then
    raise new SocketException("connect", LastSocketError);

  fRemoteEndPoint := aEndPoint;
  fLocalEndPoint := nil;
  Connected := true;
end;

method Socket.Connect(aHostOrIPAddress: String; aPort: Integer);
begin
  var lHost := Dns.GetHostAddresses(aHostOrIPAddress);
  for each lAddress in lHost do begin
    Connect(new IPEndPoint(lAddress, aPort));
    if Connected then
      exit;
  end;
  //var lAddress := IPAddress.Parse(aHost);
  //Connect(new IPEndPoint(lAddress, aPort));
end;

method Socket.Connect(aIP: IPAddress; aPort: Int32);
begin
  var lEndPoint := new IPEndPoint(aIP, aPort);
  Connect(lEndPoint);
end;

method Socket.Disconnect;
begin
  Close;
end;

method Socket.Listen(aBackLog: Integer);
begin
  {$IF FUCHSIA}
  var lFlags := rtl.fcntl(fHandle, rtl.F_GETFL);
  if (lFlags < 0) or (rtl.fcntl(fHandle, rtl.F_SETFL, lFlags or rtl.O_NONBLOCK) < 0) then
    raise new SocketException('fcntl(O_NONBLOCK)', LastSocketError);
  {$ENDIF}
  if rtl.listen(fHandle, aBackLog) <> 0 then
    raise new SocketException("listen", LastSocketError);
end;


method Socket.Receive(aBuffer: Span<Byte>; aFlags: SocketFlags): Integer;
begin
  result := rtl.recv(fHandle, ^AnsiChar(aBuffer.Pointer), aBuffer.Length, NativeSocketFlags(aFlags));
  if result < 0 then
    raise new SocketException("recv", LastSocketError);
end;

method Socket.Receive(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  CheckSocketBuffer(aBuffer, aOffset, aSize);
  result := Receive(new Span<Byte>(aBuffer, aOffset, aSize), aFlags);
end;

method Socket.Receive(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  result := Receive(aBuffer, 0, aSize, aFlags);
end;

method Socket.Receive(aBuffer: array of Byte): Integer;
begin
  result := Receive(aBuffer, 0, length(aBuffer), SocketFlags.None);
end;

method Socket.Send(aBuffer:ImmutableSpan<Byte>; aFlags: SocketFlags): Integer;
begin
  var lFlags := NativeSocketFlags(aFlags);
  {$IF LINUX OR ANDROID OR FUCHSIA}
  lFlags := lFlags or rtl.MSG_NOSIGNAL;
  {$ENDIF}
  result := rtl.send(fHandle, ^AnsiChar(aBuffer.Pointer), aBuffer.Length, lFlags);
  if result < 0 then
    raise new SocketException("send", LastSocketError);
end;

method Socket.Send(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  CheckSocketBuffer(aBuffer, aOffset, aSize);
  result := Send(new ImmutableSpan<Byte>(aBuffer, aOffset, aSize), aFlags);
end;

method Socket.Send(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  result := Send(aBuffer, 0, aSize, aFlags);
end;

method Socket.Send(aBuffer: array of Byte): Integer;
begin
  result := Send(aBuffer, 0, length(aBuffer), SocketFlags.None);
end;

method IPNativeToEndPoint(aBuffer: ^Void; var aIPEndPoint: IPEndPoint);
begin
  {$IF WINDOWS}
  var lIPv4 := ^rtl.SOCKADDR_IN(aBuffer);
  var lIPv6 := ^sockaddr_in6(aBuffer);
  {$ELSE}
  var lIPv4 := ^rtl.__struct_sockaddr_in(aBuffer);
  var lIPv6 := ^rtl.__struct_sockaddr_in6(aBuffer);
  {$ENDIF}
  if Integer(lIPv4^.sin_family) = NativeAF_INET then begin
    aIPEndPoint.AddressFamily := AddressFamily.InterNetwork;
    var lBytes := new Byte[4];
    CopySocketBytes(@lBytes[0], @lIPv4^.sin_addr, 4);
    aIPEndPoint.Address := new IPAddress(lBytes);
    {$IF DARWIN OR ANDROID}
    aIPEndPoint.Port := NetworkPort(lIPv4^.sin_port);
    {$ELSE}
    aIPEndPoint.Port := rtl.ntohs(lIPv4^.sin_port);
    {$ENDIF}
  end
  else if Integer(lIPv6^.sin6_family) = NativeAF_INET6 then begin
    aIPEndPoint.AddressFamily := AddressFamily.InterNetworkV6;
    var lBytes := new Byte[16];
    CopySocketBytes(@lBytes[0], @lIPv6^.sin6_addr, 16);
    aIPEndPoint.Address := new IPAddress(lBytes, lIPv6^.sin6_scope_id);
    {$IF DARWIN OR ANDROID}
    aIPEndPoint.Port := NetworkPort(lIPv6^.sin6_port);
    {$ELSE}
    aIPEndPoint.Port := rtl.ntohs(lIPv6^.sin6_port);
    {$ENDIF}
  end
  else
    raise new NotSupportedException('Unsupported native address family');
end;

method Socket.ReceiveFrom(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags; var remoteEP: EndPoint): Integer;
begin
  CheckSocketBuffer(aBuffer, aOffset, aSize);
  if aSize = 0 then
    exit 0;
  var lEmpty: Byte;
  var lData: ^Byte := @lEmpty;
  if aSize > 0 then
    lData := @aBuffer[aOffset];
  var lEndPoint := new IPEndPoint(nil, 0);
  {$IF WINDOWS}
  var lAddr: sockaddr_in6;
  var lSize: Integer := sizeOf(lAddr);
  result := rtl.recvfrom(fHandle, ^AnsiChar(lData), aSize, NativeSocketFlags(aFlags), @lAddr, @lSize);
  {$ELSE}
  var lAddr: rtl.__struct_sockaddr_in6;
  var lSize: rtl.socklen_t := sizeOf(lAddr);
  {$IF LINUX AND NOT ANDROID}
  var lArg: rtl.__SOCKADDR_ARG;
  lArg.__sockaddr__ := ^rtl.__struct_sockaddr(@lAddr);
  result := rtl.recvfrom(fHandle, lData, aSize, NativeSocketFlags(aFlags), lArg, @lSize);
  {$ELSE}
  result := rtl.recvfrom(fHandle, lData, aSize, NativeSocketFlags(aFlags), ^rtl.__struct_sockaddr(@lAddr), @lSize);
  {$ENDIF}
  {$ENDIF}
  if result < 0 then
    raise new SocketException('recvfrom', LastSocketError);
  IPNativeToEndPoint(@lAddr, var lEndPoint);
  remoteEP := lEndPoint;
end;

method Socket.SendTo(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags; remoteEP: EndPoint): Integer;
begin
  CheckSocketBuffer(aBuffer, aOffset, aSize);
  var lEmpty: Byte;
  var lData: ^Byte := @lEmpty;
  if aSize > 0 then
    lData := @aBuffer[aOffset];
  var lEndPoint := IPEndPoint(remoteEP);
  var lPointer: ^Void;
  var lSize: Integer;
  {$IF POSIX}
  var lSockAddr4: rtl.__struct_sockaddr_in;
  var lSockAddr6: rtl.__struct_sockaddr_in6;
  IPEndPointToNative(lEndPoint, out lSockAddr4, out lSockAddr6, out lPointer, out lSize);
  {$IF ANDROID OR DARWIN OR FUCHSIA}
  result := rtl.sendto(fHandle, lData, aSize, NativeSocketFlags(aFlags), ^rtl.__struct_sockaddr(lPointer), lSize);
  {$ELSE}
  var lAddr: rtl.__CONST_SOCKADDR_ARG;
  if lEndPoint.AddressFamily = AddressFamily.InterNetworkV6 then
    lAddr.__sockaddr_in6__ := ^rtl.__struct_sockaddr_in6(lPointer)
  else
    lAddr.__sockaddr_in__ := ^rtl.__struct_sockaddr_in(lPointer);
  result := rtl.sendto(fHandle, lData, aSize, NativeSocketFlags(aFlags), lAddr, lSize);
  {$ENDIF}
  {$ELSEIF WINDOWS}
  var lSockAddr4: rtl.SOCKADDR_IN;
  var lSockAddr6: sockaddr_in6;
  IPEndPointToNative(lEndPoint, out lSockAddr4, out lSockAddr6, out lPointer, out lSize);
  result := rtl.sendto(fHandle, ^AnsiChar(lData), aSize, NativeSocketFlags(aFlags), lPointer, lSize);
  {$ENDIF}
  if result < 0 then
    raise new SocketException('sendto', LastSocketError);
end;

method Socket.DataAvailable: Integer;
begin
  {$IF POSIX}
  var lData: Integer := 0;
  if rtl.ioctl(fHandle, Native_FIONREAD, @lData) < 0 then
    raise new SocketException('ioctl(FIONREAD)', LastSocketError);
  {$ELSE}
  var lData: rtl.u_long := 0;
  if rtl.ioctlsocket(fHandle, Native_FIONREAD, @lData) <> 0 then
    raise new SocketException('ioctlsocket(FIONREAD)', LastSocketError);
  {$ENDIF}
  result := lData;
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Int32);
begin
  if (aOptionLevel = SocketOptionLevel.Socket) and (aOptionName = SocketOptionName.DontLinger) then begin
    SetSocketOption(aOptionLevel, SocketOptionName.Linger, new LingerOption(aOptionValue = 0, 0));
    exit;
  end;
  {$IF POSIX}
  if (aOptionLevel = SocketOptionLevel.Socket) and
     ((aOptionName = SocketOptionName.SendTimeout) or (aOptionName = SocketOptionName.ReceiveTimeout)) then begin
    if aOptionValue < 0 then
      raise new ArgumentOutOfRangeException('aOptionValue');
    var lTimeout: rtl.__struct_timeval;
    lTimeout.tv_sec := aOptionValue / 1000;
    lTimeout.tv_usec := (aOptionValue mod 1000) * 1000;
    InternalSetSocketOption(aOptionLevel, aOptionName, @lTimeout, sizeOf(lTimeout));
    exit;
  end;
  {$ENDIF}
  InternalSetSocketOption(aOptionLevel, aOptionName, @aOptionValue, sizeOf(aOptionValue));
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Boolean);
begin
  SetSocketOption(aOptionLevel, aOptionName, Int32(aOptionValue));
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Object);
begin
  if (aOptionLevel <> SocketOptionLevel.Socket) or (aOptionName <> SocketOptionName.Linger) or not (aOptionValue is LingerOption) then
    raise new NotSupportedException('Object socket options require a LingerOption');
  var lValue := LingerOption(aOptionValue);
  if (lValue.LingerTime < 0) or (lValue.LingerTime > 65535) then
    raise new ArgumentOutOfRangeException('LingerTime');
  var lLinger: {$IF WINDOWS}rtl.linger{$ELSE}rtl.__struct_linger{$ENDIF};
  lLinger.l_onoff := Int32(lValue.Enabled);
  lLinger.l_linger := lValue.LingerTime;
  InternalSetSocketOption(aOptionLevel, aOptionName, @lLinger, sizeOf(lLinger));
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: array of Byte);
begin
  if length(aOptionValue) = 0 then
    raise new ArgumentException('Socket option buffer is empty');
  InternalSetSocketOption(aOptionLevel, aOptionName, @aOptionValue[0], length(aOptionValue));
end;

method Socket.Shutdown(aMode: SocketShutdown);
begin
  if rtl.shutdown(fHandle, Integer(aMode)) <> 0 then
    raise new SocketException('shutdown', LastSocketError);
end;

method Socket.Close;
begin
  if InternalCalls.Exchange(var fIsClosing, 1) <> 0 then
    exit;
  var lHandle := fHandle;
  fHandle := {$IF WINDOWS}rtl.INVALID_SOCKET{$ELSE}-1{$ENDIF};
  Connected := false;
  // Closing a descriptor alone need not wake a concurrent blocking operation.
  rtl.shutdown(lHandle, Integer(SocketShutdown.Both));
  {$IF POSIX}
  var lResult := rtl.close(lHandle);
  {$ELSE}
  var lResult := rtl.closesocket(lHandle);
  {$ENDIF}
  if lResult <> 0 then
    raise new SocketException('close', LastSocketError);
end;

method Socket.Dispose;
begin
  Close;
end;

method Socket.GetRemoteEndPoint: EndPoint;
begin
  if fRemoteEndPoint = nil then begin
    var lEndPoint := new IPEndPoint(nil, 0);
    {$IF WINDOWS}
    var lAddr: sockaddr_in6;
    var lSize: Integer := sizeOf(lAddr);
    var lRes := rtl.getpeername(fHandle, @lAddr, @lSize);
    {$ELSE}
    var lAddr: rtl.__struct_sockaddr_in6;
    var lSize: rtl.socklen_t := sizeOf(lAddr);
    {$IF LINUX AND NOT ANDROID}
    var lArg: rtl.__SOCKADDR_ARG;
    lArg.__sockaddr__ := ^rtl.__struct_sockaddr(@lAddr);
    var lRes := rtl.getpeername(fHandle, lArg, @lSize);
    {$ELSE}
    var lRes := rtl.getpeername(fHandle, ^rtl.__struct_sockaddr(@lAddr), @lSize);
    {$ENDIF}
    {$ENDIF}
    if lRes < 0 then
      raise new SocketException('getpeername', LastSocketError);
    IPNativeToEndPoint(@lAddr, var lEndPoint);
    fRemoteEndPoint := lEndPoint;
  end;
  result := fRemoteEndPoint;
end;
method Socket.GetLocalEndPoint: EndPoint;
begin
  if fLocalEndPoint = nil then begin
    var lEndPoint := new IPEndPoint(nil, 0);
    {$IF WINDOWS}
    var lAddr: sockaddr_in6;
    var lSize: Integer := sizeOf(lAddr);
    var lRes := rtl.getsockname(fHandle, @lAddr, @lSize);
    {$ELSE}
    var lAddr: rtl.__struct_sockaddr_in6;
    var lSize: rtl.socklen_t := sizeOf(lAddr);
    {$IF LINUX AND NOT ANDROID}
    var lArg: rtl.__SOCKADDR_ARG;
    lArg.__sockaddr__ := ^rtl.__struct_sockaddr(@lAddr);
    var lRes := rtl.getsockname(fHandle, lArg, @lSize);
    {$ELSE}
    var lRes := rtl.getsockname(fHandle, ^rtl.__struct_sockaddr(@lAddr), @lSize);
    {$ENDIF}
    {$ENDIF}
    if lRes < 0 then
      raise new SocketException('getsockname', LastSocketError);
    IPNativeToEndPoint(@lAddr, var lEndPoint);
    fLocalEndPoint := lEndPoint;
  end;
  result := fLocalEndPoint;
end;
{$ENDIF}

end.