namespace RemObjects.Elements.System;

{$IF NOT WEBASSEMBLY}

interface

type

  TPlatformSocketHandle = Integer;

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

  EndPoint = public class
  public
    property AddressFamily: AddressFamily;
  end;

  IPEndPoint = public class(EndPoint)
  public
    IPAddress: IPAddress;
    Port: Integer;
  end;

  IPAddress = public class

  end;

  Socket = public class(IDisposable)
  private
    fHandle: TPlatformSocketHandle;
    constructor(aHandle: TPlatformSocketHandle);

  public
    constructor(anAddressFamily: AddressFamily; aSocketType: SocketType; aProtocol: ProtocolType);

    method Accept: Socket;

    method Bind(aEndPoint: IPEndPoint);

    method Connect(aEndPoint: IPEndPoint);
    method Connect(aHost: String; aPort: Integer);
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

    property Connected: Boolean;
    property AddressFamily: AddressFamily;
    property ProtocolType: ProtocolType;
    property SocketType: SocketType;
    property LocalEndPoint: EndPoint;
    property RemoteEndPoint: EndPoint;
  end;

 implementation

constructor Socket(aHandle: TPlatformSocketHandle);
begin
  fHandle := aHandle;
end;

constructor Socket(anAddressFamily: AddressFamily; aSocketType: SocketType; aProtocol: ProtocolType);
begin
  AddressFamily := anAddressFamily;
  SocketType := aSocketType;
  ProtocolType := aProtocol;
  {$IF POSIX OR TOFFEE}
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

end;

method Socket.Connect(aEndPoint: IPEndPoint);
begin

end;

method Socket.Connect(aHost: String; aPort: Integer);
begin

end;

method Socket.Connect(aIP: IPAddress; aPort: Int32);
begin

end;

method Socket.Disconnect;
begin

end;

method Socket.Listen(aBackLog: Integer);
begin

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

end;

method Socket.Shutdown(aMode: SocketShutdown);
begin
  if rtl.shutdown(fHandle, Integer(aMode)) <> 0 then
    raise new Exception("Error closing socket");
end;

method Socket.Close;
begin
  {$IF POSIX OR TOFFEE}
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