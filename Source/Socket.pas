namespace RemObjects.Elements.System;

{$IF NOT WEBASSEMBLY}

interface

type
  PlatformSocketHandle = Integer;

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
    constructor(aHandle: PlatformSocketHandle);
    class constructor;
    method InternalSetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: ^Void; aOptionValueLength: Int32);
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

    method Send(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
    method Send(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
    method Send(aBuffer: array of Byte): Integer;

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
    property LocalEndPoint: EndPoint;
    property RemoteEndPoint: EndPoint;
  end;

 implementation

 constructor IPEndPoint(anAddress: IPAddress; aPort: Int32);
 begin
   Address := anAddress;
   Port := aPort;
 end;

constructor IPAddress(anAddress: array of Byte; aScopeid: Int64);
begin
  fFamily := AddressFamily.InterNetworkV6;
  for i: Integer := 0 to (IPv6Length / 2) - 1 do
    fNumbers[i] := Byte(anAddress[i * 2] * 256 + anAddress[i * 2 + 1]);
  fScopeId := aScopeId;
end;

constructor IPAddress(anAddress: array of Byte);
begin
  if length(anAddress) = IPv4Length then begin
    fFamily := AddressFamily.InterNetwork;
    fAddress := ((anAddress[3] shl 24 or anAddress[2] shl 16 or anAddress[1] shl 8 or anAddress[0]) and $0FFFFFFFF);
  end
  else begin
    fFamily := AddressFamily.InterNetworkV6;
    for i: Integer := 0 to (IPv6Length / 2) - 1 do
      fNumbers[i] := Byte(anAddress[i * 2] * 256 + anAddress[i * 2 + 1]);
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
      if Convert.TryParseInt64(lNumbers[i], out lNumber, false) then
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
  var lString := ipString;
  var lBytes := new Byte[16];

  {$IF POSIX OR DARWIN}
  var lAddrInfo: ^rtl.__struct_addrinfo;
  var lSockAddr: ^rtl.__struct_sockaddr_in6;
  var lRes := 0;
  lRes := rtl.getaddrinfo(^AnsiChar(lString.FirstChar), nil, nil, @lAddrInfo);
  if lRes <> 0 then
    exit false;
  lSockAddr := ^rtl.__struct_sockaddr_in6(lAddrInfo^.ai_addr);
  {$ELSE}
  var lAddrInfo: rtl.PADDRINFOW;
  var lSockAddr: ^sockaddr_in6;

  if rtl.GetAddrInfo(lString.FirstChar, nil, nil, @lAddrInfo) <> 0 then
    exit false;

  lSockAddr := ^sockaddr_in6(lAddrInfo^.ai_addr);
  {$ENDIF}

  for i: Integer := 0  to IPv6Length - 1 do
    {$IF ANDROID}
    lBytes[i] := lSockAddr^.sin6_addr.in6_u.u6_addr8[i];
    {$ELSEIF DARWIN}
    lBytes[i] := lSockAddr^.sin6_addr.__u6_addr.__u6_addr8[i];
    {$ELSEIF POSIX}
    lBytes[i] := lSockAddr^.sin6_addr.__in6_u.__u6_addr8[i];
    {$ELSE}
    lBytes[i] := lSockAddr^.sin6_addr.u.Byte[i];
    {$ENDIF}

  address := new IPAddress(lBytes, lSockAddr^.sin6_scope_id);
  result := true;
end;

class method IPAddress.TryParse(ipString: String; out address: IPAddress): Boolean;
begin
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
    lHostName := String.FromPAnsiChars(@lName[0])
  {$ENDIF}
  if lHostName <> '' then
    result := InternalGetHostByName(lHostName)
  else
    result := new IPHostEntry();
end;

method Dns.InternalGetHostByName(aHost: String): IPHostEntry;
begin
  result := new IPHostEntry;
  var lIPList := new List<IPAddress>();
  var lBytes := new Byte[16];
  {$IF WINDOWS}
  var lAddrInfo: rtl.PADDRINFOW;
  var lSockAddr4: ^rtl.SOCKADDR_IN;
  var lSockAddr6: ^sockaddr_in6;
  var lPtr: rtl.PADDRINFOW := nil;

  InitSockets;
  if rtl.GetAddrInfo(aHost.FirstChar, nil, nil, @lAddrInfo) <> 0 then
    exit;

  result.HostName := String.FromPChar(lAddrInfo^.ai_canonname);
  lPtr := lAddrInfo;
  while lPtr <> nil do begin
    case lPtr^.ai_family of
      AddressFamily.InterNetwork: begin
        lSockAddr4 := ^rtl.SOCKADDR_IN(lPtr^.ai_addr);
        lIPList.Add(new IPAddress(lSockAddr4^.sin_addr.S_un.S_addr));
      end;

      AddressFamily.InterNetworkV6: begin
        lSockAddr6 := ^sockaddr_in6(lPtr^.ai_addr);
        for i: Integer := 0  to IPAddress.IPv6Length - 1 do
          lBytes[i] := lSockAddr6^.sin6_addr.u.Byte[i];

        lIPList.Add(new IPAddress(lBytes, lSockAddr6^.sin6_scope_id));
      end;
    end;
    lPtr := rtl.PADDRINFOW(lPtr^.ai_next);
  end;
  {$ELSEIF POSIX}
  var lAddrInfo: ^rtl.__struct_addrinfo;
  var lSockAddr4: ^rtl.__struct_sockaddr_in;
  var lSockAddr6: ^rtl.__struct_sockaddr_in6;
  var lPtr: ^rtl.__struct_addrinfo := nil;
  var lRes := 0;
  lRes := rtl.getaddrinfo(^AnsiChar(aHost.FirstChar), nil, nil, @lAddrInfo);
  if lRes <> 0 then
    exit;

  result.HostName := String.FromPAnsiChars(lAddrInfo^.ai_canonname);
  lPtr := lAddrInfo;
  while lPtr <> nil do begin
    case lPtr^.ai_family of
      AddressFamily.InterNetwork: begin
        lSockAddr4 := ^rtl.__struct_sockaddr_in(lPtr^.ai_addr);
        lIPList.Add(new IPAddress(lSockAddr4^.sin_addr.s_addr));
      end;

      AddressFamily.InterNetworkV6: begin
        lSockAddr6 := ^rtl.__struct_sockaddr_in6(lPtr^.ai_addr);
        for i: Integer := 0 to IPAddress.IPv6Length - 1 do
          {$IF ANDROID}
          lBytes[i] := lSockAddr6^.sin6_addr.in6_u.u6_addr8[i];
          {$ELSEIF DARWIN}
          lBytes[i] := lSockAddr6^.sin6_addr.__u6_addr.__u6_addr8[i];
          {$ELSE}
          lBytes[i] := lSockAddr6^.sin6_addr.__in6_u.__u6_addr8[i];
          {$ENDIF}

        lIPList.Add(new IPAddress(lBytes, lSockAddr6^.sin6_scope_id));
      end;
    end;
    lPtr := ^rtl.__struct_addrinfo(lPtr^.ai_next);
  end;
  {$ENDIF}
  result.AddressList := lIPList.ToArray();
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
    result := String.FromPAnsiChars(@lBuffer[0])
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
method htons(port: Integer): Integer;
begin
    result := rtl.__uint16_t(((rtl.__uint16_t(port) and $ff00) shr 8) or ((rtl.__uint16_t(port) and $00ff) shl 8));
end;
{$ENDIF}

{$IF POSIX OR DARWIN}
method IPEndPointToNative(endPoint: IPEndPoint; out lIPv4: rtl.__struct_sockaddr_in; out lIPv6: rtl.__struct_sockaddr_in6; out ipPointer: ^Void; out ipSize: Integer);
begin
  case endPoint.AddressFamily of
    AddressFamily.InterNetworkV6: begin
      lIPv6.sin6_family := AddressFamily.InterNetworkV6;
      {$IF DARWIN OR ANDROID}
      lIPv6.sin6_port := htons(endPoint.Port);
      {$ELSE}
      lIPv6.sin6_port := rtl.htons(endPoint.Port);
      {$ENDIF}
      lIPv6.sin6_scope_id := endPoint.Address.ScopeId;
      var lBytes := endPoint.Address.GetAddressBytes();
      for i: Integer := 0 to 15 do
        {$IF DARWIN}
        lIPv6.sin6_addr.__u6_addr.__u6_addr8[i] := lBytes[i];
        {$ELSEIF ANDROID}
        lIPv6.sin6_addr.in6_u.u6_addr8[i] := lBytes[i];
        {$ELSEIF POSIX}
        lIPv6.sin6_addr.__in6_u.__u6_addr8[i] := lBytes[i];
        {$ENDIF}
      ipPointer := @lIPv6;
      ipSize := sizeOf(rtl.__struct_sockaddr_in6);
    end;

    else begin
      lIPv4.sin_family := AddressFamily.InterNetwork;
      {$IF DARWIN OR ANDROID}
      lIPv4.sin_port := htons(endPoint.Port);
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
      lIPv6.sin6_family := AddressFamily.InterNetworkV6;
      lIPv6.sin6_port := rtl.htons(endPoint.Port);
      lIPv6.sin6_scope_id := endPoint.Address.ScopeId;
      var lBytes := endPoint.Address.GetAddressBytes();
      for i: Integer := 0 to 15 do
        lIPv6.sin6_addr.u.Byte[i] := lBytes[i];
      ipPointer := @lIPv6;
      ipSize := sizeOf(sockaddr_in6);
    end;

    else begin
      lIPv4.sin_family := AddressFamily.InterNetwork;
      lIPv4.sin_port := rtl.htons(endPoint.Port);
      lIPv4.sin_addr.S_un.S_addr := endPoint.Address.Address;
      ipSize := sizeOf(rtl.SOCKADDR_IN);
      ipPointer := @lIPv4;
    end;
  end;
end;
{$ENDIF}

method Socket.InternalSetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: ^Void; aOptionValueLength: Int32);
begin
  if rtl.setsockopt(fHandle, Integer(aOptionLevel), Integer(aOptionName), ^AnsiChar(aOptionValue), aOptionValueLength) <> 0 then
    raise new Exception("Can not change socket option");
end;

constructor Socket(aHandle: PlatformSocketHandle);
begin
  fHandle := aHandle;
end;

class constructor Socket;
begin
  {$IF WINDOWS}
  Dns.InitSockets;
  {$ENDIF}
end;

constructor Socket(anAddressFamily: AddressFamily; aSocketType: SocketType; aProtocol: ProtocolType);
begin
  AddressFamily := anAddressFamily;
  SocketType := aSocketType;
  ProtocolType := aProtocol;
  {$IF POSIX OR DARWIN}
  fHandle := rtl.socket(rtl.int32_t(anAddressFamily), rtl.int32_t(aSocketType), rtl.int32_t(aProtocol));
  {$ELSEIF ISLAND AND WINDOWS}
  fHandle := rtl.__Global.socket(rtl.INT(anAddressFamily), rtl.INT(aSocketType), rtl.INT(aProtocol));
  {$ELSE}
  {$ERROR}
  {$ENDIF}

  if fHandle < 0 then
    raise new Exception("Error creating socket");
end;

method Socket.Accept: Socket;
begin
  {$IF POSIX AND (NOT (ANDROID OR DARWIN))}
  var lSockAddr: rtl.__SOCKADDR_ARG;
  lSockAddr.__sockaddr__ := nil;
  var lSocket := rtl.accept(fHandle, lSockAddr, nil);
  if lSocket = -1 then
    raise new Exception("Error calling accept function");
  {$ELSE}
  var lSocket := rtl.accept(fHandle, nil, nil);
  if lSocket < 0 then
    raise new Exception("Error calling accept function");
  {$ENDIF}

  result := new Socket(lSocket);
  result.Connected := true;
end;

method Socket.Bind(aEndPoint: IPEndPoint);
begin
  var lEndPoint := IPEndPoint(aEndPoint);
  if lEndPoint.Address = nil then
    lEndPoint := new IPEndPoint(IPAddress.Parse("0.0.0.0"), lEndPoint.Port);
  var lPointer: ^Void;
  var lSize: Integer;
  {$IF POSIX OR DARWIN}
  var lIPv4: rtl.__struct_sockaddr_in;
  var lIPv6: rtl.__struct_sockaddr_in6;
  {$IF POSIX AND (NOT (ANDROID OR DARWIN))}
  var lSockAddr: rtl.__CONST_SOCKADDR_ARG;
  {$ENDIF}
  {$ELSE}
  var lIPv4: rtl.SOCKADDR_IN;
  var lIPv6: sockaddr_in6;
  {$ENDIF}

  IPEndPointToNative(lEndPoint, out lIPv4, out lIPv6, out lPointer, out lSize);
  {$IF POSIX AND (NOT (ANDROID OR DARWIN))}
  lSockAddr.__sockaddr__ := ^rtl.__struct_sockaddr(lPointer);
  lSockAddr.__sockaddr_in__ := ^rtl.__struct_sockaddr_in(lPointer);
  if rtl.__Global.bind(fHandle, lSockAddr, lSize) <> 0 then
    raise new Exception("Error calling bind function");
  {$ELSEIF DARWIN OR ANDROID}
  if rtl.bind(fHandle, ^rtl.__struct_sockaddr(lPointer), lSize) <> 0 then
    raise new Exception("Error calling bind function");
  {$ELSEIF WINDOWS}
  if rtl.bind(fHandle, lPointer, lSize) <> 0 then
    raise new Exception("Error calling bind function");
  {$ENDIF}
  LocalEndPoint := lEndPoint;
end;

method Socket.Connect(aEndPoint: EndPoint);
begin
  var lEndPoint := IPEndPoint(aEndPoint);
  var lPointer: ^Void;
  var lSize: Integer;

  {$IF POSIX OR DARWIN}
  var lIPv4: rtl.__struct_sockaddr_in;
  var lIPv6: rtl.__struct_sockaddr_in6;
  {$IF POSIX AND (NOT (ANDROID OR DARWIN))}
  var lSockAddr: rtl.__CONST_SOCKADDR_ARG;
  {$ENDIF}
  {$ELSE}
  var lIPv4: rtl.SOCKADDR_IN;
  var lIPv6: sockaddr_in6;
  {$ENDIF}

  IPEndPointToNative(lEndPoint, out lIPv4, out lIPv6, out lPointer, out lSize);
  var lRes := 0;
  {$IF POSIX AND (NOT (ANDROID OR DARWIN))}
  lSockAddr.__sockaddr__ := ^rtl.__struct_sockaddr(lPointer);
  lRes := rtl.connect(fHandle, lSockAddr, lSize);
  {$ELSEIF DARWIN OR ANDROID}
  lRes := rtl.connect(fHandle, ^rtl.__struct_sockaddr(lPointer), lSize);
  {$ELSE}
  lRes := rtl.connect(fHandle, lPointer, lSize);
  {$ENDIF}
  if lRes <> 0 then
    raise new Exception("Error connecting socket");

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
  if rtl.listen(fHandle, aBackLog) <> 0 then
    raise new Exception("Error calling to listen function");
end;

method Socket.Receive(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  var lPointer: ^Void;
  lPointer := @aBuffer[aOffset];
  result := rtl.recv(fHandle, ^AnsiChar(lPointer), aSize, Integer(aFlags));
end;

method Socket.Receive(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  result := Receive(aBuffer, 0, aSize, aFlags);
end;

method Socket.Receive(aBuffer: array of Byte): Integer;
begin
  result := Receive(aBuffer, 0, length(aBuffer), SocketFlags.None);
end;

method Socket.Send(aBuffer: array of Byte; aOffset: Integer; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  var lPointer: ^Void;
  lPointer := @aBuffer[aOffset];
  result := rtl.send(fHandle, ^AnsiChar(lPointer), aSize, Integer(aFlags));
end;

method Socket.Send(aBuffer: array of Byte; aSize: Integer; aFlags: SocketFlags): Integer;
begin
  result := Send(aBuffer, 0, aSize, aFlags);
end;

method Socket.Send(aBuffer: array of Byte): Integer;
begin
  result := Send(aBuffer, 0, length(aBuffer), SocketFlags.None);
end;

method Socket.DataAvailable: Integer;
begin
  var lData: rtl.u_long := 0;
  var lError := false;
  {$IF POSIX OR DARWIN}
  const FIONREAD: Int32 = 1074004095;
  lError := rtl.ioctl(fHandle, FIONREAD, @lData) < 0;
  {$ELSE}
  var lRes := 0;
  if rtl.ioctlsocket(fHandle, rtl.FIONREAD, @lData) <> 0 then
      lRes := rtl.WSAGetLastError();

  lError := (lRes <> 0) and (lRes <> rtl.WSAEOPNOTSUPP);
  {$ENDIF}
  if lError then
    lData := 0;

  result := lData;
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Int32);
begin
  var lValue: ^Void := @aOptionValue;
  InternalSetSocketOption(aOptionLevel, aOptionName, lValue, sizeOf(Int32));
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Boolean);
begin
  var lValue: ^Void := @aOptionValue;
  InternalSetSocketOption(aOptionLevel, aOptionName, lValue, sizeOf(Boolean));
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: Object);
begin
  var lValue: ^Void := @aOptionValue;
  InternalSetSocketOption(aOptionLevel, aOptionName, lValue, sizeOf(Object));
end;

method Socket.SetSocketOption(aOptionLevel: SocketOptionLevel; aOptionName: SocketOptionName; aOptionValue: array of Byte);
begin
  var lValue: ^Void := @aOptionValue[0];
  InternalSetSocketOption(aOptionLevel, aOptionName, lValue, length(aOptionValue));
end;

method Socket.Shutdown(aMode: SocketShutdown);
begin
  if rtl.shutdown(fHandle, Integer(aMode)) <> 0 then
    raise new Exception("Error closing socket");
end;

method Socket.Close;
begin
  {$IF POSIX OR DARWIN}
  if rtl.close(fHandle) <> 0 then
    raise new Exception("Error closing socket");
  {$ELSE}
  if rtl.closesocket(fHandle) <> 0 then
    raise new Exception("Error closing socket");
  {$ENDIF}

  Connected := false;
end;

method Socket.Dispose;
begin
  Close;
end;

{$ENDIF}

end.