namespace RemObjects.Elements.System;

interface

type
  FidlTransportException = public class(Exception)
  private
    fStatus: Int32;
  public
    constructor(aMessage: not nullable String; aStatus: Int32);
    property Status: Int32 read fStatus;
  end;

  FidlProtocolException = public class(Exception)
  end;

  FidlConnectionClosedException = public class(FidlTransportException)
  public
    constructor(aStatus: Int32);
  end;

  FidlDeadlineExceededException = public class(FidlTransportException)
  public
    constructor;
  end;

  FidlCallOptions = public record
  public
    class method WithDeadline(aDeadline: Int64): FidlCallOptions;
    class method WithTimeoutMilliseconds(aMilliseconds: Int64): FidlCallOptions;
    property Deadline: Int64 read write;
  end;

  FidlHandle = public class(IDisposable)
  private
    fHandle: rtl.zx_handle_t;
    fObjectType: UInt32;
    fRights: UInt32;
  assembly
    constructor(aHandle: rtl.zx_handle_t; aObjectType: UInt32 := 0; aRights: UInt32 := 0);
    method ReleaseHandle: rtl.zx_handle_t;
    property RawHandle: rtl.zx_handle_t read fHandle;
  public
    property IsValid: Boolean read fHandle <> default(rtl.zx_handle_t);
    property ObjectType: UInt32 read fObjectType;
    property Rights: UInt32 read fRights;

    method Dispose;
    finalizer;
  end;

  FidlChannelHandle = public class(FidlHandle)
  assembly
    constructor(aHandle: rtl.zx_handle_t);
  end;

  FidlChannelPair = public class
  private
    fClient: FidlChannelHandle;
    fServer: FidlChannelHandle;
  assembly
    constructor(aClient: not nullable FidlChannelHandle; aServer: not nullable FidlChannelHandle);
  public
    property Client: not nullable FidlChannelHandle read fClient as not nullable;
    property Server: not nullable FidlChannelHandle read fServer as not nullable;
  end;

  FidlClientEnd<T> = public class(FidlChannelHandle)
  assembly
    constructor(aHandle: rtl.zx_handle_t);
  end;

  FidlServerEnd<T> = public class(FidlChannelHandle)
  assembly
    constructor(aHandle: rtl.zx_handle_t);
  end;

  FidlOutgoingHandle = public class
  private
    fHandle: not nullable FidlHandle;
    fObjectType: UInt32;
    fRights: UInt32;
  public
    constructor(aHandle: not nullable FidlHandle; aObjectType: UInt32; aRights: UInt32);
    property Handle: not nullable FidlHandle read fHandle;
    property ObjectType: UInt32 read fObjectType;
    property Rights: UInt32 read fRights;
  end;

  FidlEncoder = public class
  private
    fBuffer: array of Byte;
    fPosition: Integer;

    method EnsureCapacity(aAdditionalBytes: Integer);
  public
    constructor(aCapacity: Integer := 64);

    method Align(aAlignment: Integer);
    method WriteBoolean(aValue: Boolean);
    method WriteByte(aValue: Byte);
    method WriteInt16(aValue: Int16);
    method WriteUInt16(aValue: UInt16);
    method WriteInt32(aValue: Int32);
    method WriteUInt32(aValue: UInt32);
    method WriteInt64(aValue: Int64);
    method WriteUInt64(aValue: UInt64);
    method WriteSingle(aValue: Single);
    method WriteDouble(aValue: Double);
    method WriteBytes(aValue: array of Byte);
    method WriteTransactionalHeader(aTransactionID: UInt32; aOrdinal: UInt64);

    property Position: Integer read fPosition;
    method ToArray: array of Byte;
  end;

  FidlDecoder = public class
  private
    fBuffer: not nullable array of Byte;
    fPosition: Integer;

    method EnsureAvailable(aByteCount: Integer);
  public
    constructor(aBuffer: not nullable array of Byte; aOffset: Integer := 0);

    method Align(aAlignment: Integer);
    method ReadBoolean: Boolean;
    method ReadByte: Byte;
    method ReadInt16: Int16;
    method ReadUInt16: UInt16;
    method ReadInt32: Int32;
    method ReadUInt32: UInt32;
    method ReadInt64: Int64;
    method ReadUInt64: UInt64;
    method ReadSingle: Single;
    method ReadDouble: Double;
    method ReadBytes(aCount: Integer): array of Byte;

    property Position: Integer read fPosition;
    property Remaining: Integer read length(fBuffer)-fPosition;
  end;

  FidlIncomingMessage = public class(IDisposable)
  private
    fBytes: not nullable array of Byte;
    fHandles: not nullable array of FidlHandle;
    fTransactionID: UInt32;
    fOrdinal: UInt64;
    fDisposed: Int32;
  assembly
    constructor(aBytes: not nullable array of Byte; aHandles: not nullable array of FidlHandle);
  public
    property Bytes: not nullable array of Byte read fBytes;
    property Handles: not nullable array of FidlHandle read fHandles;
    property TransactionID: UInt32 read fTransactionID;
    property Ordinal: UInt64 read fOrdinal;
    method BodyDecoder: not nullable FidlDecoder;
    method TakeHandle(aIndex: Integer): not nullable FidlHandle;
    method Dispose;
    finalizer;
  end;

  FidlConnection = public class(IDisposable)
  private
    fChannel: not nullable FidlChannelHandle;
    fDispatcherKey: UInt64;
    fLock: not nullable Monitor := new Monitor;
    fWriteLock: not nullable Monitor := new Monitor;
    fPending := new Dictionary<UInt32, TaskCompletionSource<FidlIncomingMessage>>;
    fDeadlines := new Dictionary<UInt32, Int64>;
    fExpiredTransactions := new HashSet<UInt32>;
    fExpiredTransactionOrder := new Queue<UInt32>;
    fNextTransactionID: UInt32;
    fDisposed: Int32;

    method AllocateTransactionID: UInt32;
    method CompleteResponse(aMessage: not nullable FidlIncomingMessage);
    method NextDeadline: Int64;
    method ExpireDeadlines(aNow: Int64);
    method Fail(aException: not nullable Exception);
    method Send(aTransactionID: UInt32;
                aOrdinal: UInt64;
                aPayload: nullable array of Byte;
                aHandles: nullable array of FidlOutgoingHandle): Int32;
  assembly
    constructor(aChannel: not nullable FidlChannelHandle);
    method HandlePacket;
    property Channel: not nullable FidlChannelHandle read fChannel;
    property DispatcherKey: UInt64 read fDispatcherKey write fDispatcherKey;
  public
    class method CreateChannelPair: not nullable FidlChannelPair;
    class method Connect(aProtocolName: not nullable String): not nullable FidlConnection;

    method CallAsync(aOrdinal: UInt64;
                     aPayload: nullable array of Byte := nil;
                     aHandles: nullable array of FidlOutgoingHandle := nil;
                     aOptions: FidlCallOptions := default(FidlCallOptions)): not nullable Task<FidlIncomingMessage>;
    method SendOneWay(aOrdinal: UInt64;
                      aPayload: nullable array of Byte := nil;
                      aHandles: nullable array of FidlOutgoingHandle := nil): not nullable Task;

    event EventReceived: Action<FidlIncomingMessage>;
    property IsDisposed: Boolean read fDisposed <> 0;

    method Dispose;
    finalizer;
  end;

  FidlUInt32Codec = assembly sealed class
  private
    class method CompleteCall(aTask: not nullable Task; aState: nullable Object);
    class method Decode(aTask: not nullable Task): UInt32;
  public
    class method CallAsync(aConnection: not nullable FidlConnection;
                           aOrdinal: UInt64;
                           aValue: UInt32;
                           aOptions: FidlCallOptions): not nullable Task<UInt32>;
  end;

  FidlStringCodec = assembly sealed class
  private
    class method CompleteCall(aTask: not nullable Task; aState: nullable Object);
    class method Decode(aTask: not nullable Task): not nullable String;
  public
    class method CallAsync(aConnection: not nullable FidlConnection;
                           aOrdinal: UInt64;
                           aValue: not nullable String;
                           aOptions: FidlCallOptions): not nullable Task<String>;
  end;

  FidlByteVectorCodec = assembly sealed class
  private
    class method CompleteCall(aTask: not nullable Task; aState: nullable Object);
    class method Decode(aTask: not nullable Task): not nullable array of Byte;
  public
    class method CallAsync(aConnection: not nullable FidlConnection;
                           aOrdinal: UInt64;
                           aValue: not nullable array of Byte;
                           aOptions: FidlCallOptions): not nullable Task<array of Byte>;
  end;

  FidlProtocolConnection<T> = public class(IDisposable)
  private
    fConnection: not nullable FidlConnection;

    class method DefaultProtocolName: not nullable String;
  assembly
    constructor(aConnection: not nullable FidlConnection);
  public
    class method Connect(aProtocolName: nullable String := nil): not nullable FidlProtocolConnection<T>;

    method CallAsync(aOrdinal: UInt64;
                     aPayload: nullable array of Byte := nil;
                     aHandles: nullable array of FidlOutgoingHandle := nil;
                     aOptions: FidlCallOptions := default(FidlCallOptions)): not nullable Task<FidlIncomingMessage>;
    method CallUInt32Async(aOrdinal: UInt64;
                           aValue: UInt32): not nullable Task<UInt32>;
    method CallUInt32Async(aOrdinal: UInt64;
                           aValue: UInt32;
                           aOptions: FidlCallOptions): not nullable Task<UInt32>;
    method CallStringAsync(aOrdinal: UInt64;
                           aValue: not nullable String): not nullable Task<String>;
    method CallStringAsync(aOrdinal: UInt64;
                           aValue: not nullable String;
                           aOptions: FidlCallOptions): not nullable Task<String>;
    method CallByteVectorAsync(aOrdinal: UInt64;
                               aValue: not nullable array of Byte): not nullable Task<array of Byte>;
    method CallByteVectorAsync(aOrdinal: UInt64;
                               aValue: not nullable array of Byte;
                               aOptions: FidlCallOptions): not nullable Task<array of Byte>;
    method SendOneWay(aOrdinal: UInt64;
                      aPayload: nullable array of Byte := nil;
                      aHandles: nullable array of FidlOutgoingHandle := nil): not nullable Task;

    property Transport: not nullable FidlConnection read fConnection;
    method Dispose;
    finalizer;
  end;

implementation

const
  FidlTransactionalHeaderSize = 16;
  FidlWireFormatMagic = 1;
  FidlEpitaphOrdinal: UInt64 = UInt64.MaxValue;
  FidlMaximumMessageBytes = 65536;
  FidlMaximumMessageHandles = 64;
  FidlMaximumExpiredTransactions = 1024;

type
  [Packed]
  FidlPortPacket = record
  public
    Key: UInt64;
    PacketType: UInt32;
    Status: Int32;
    Payload: array[0..31] of Byte;
  end;

  FidlDispatcher = class
  private
    fPort: not nullable FidlHandle;
    fThread: not nullable Thread;
    fLock: not nullable Monitor := new Monitor;
    fConnections := new Dictionary<UInt64, FidlConnection>;
    fNextKey: Int64;

    method Arm(aConnection: not nullable FidlConnection);
    method SnapshotConnections: not nullable List<FidlConnection>;
    method ThreadMain(aState: Object);
  public
    constructor;
    method RegisterConnection(aConnection: not nullable FidlConnection);
    method UnregisterConnection(aConnection: not nullable FidlConnection);
    method WakeForDeadline;

    class property Shared: not nullable FidlDispatcher read new FidlDispatcher; lazy;
  end;

constructor FidlTransportException(aMessage: not nullable String; aStatus: Int32);
begin
  inherited constructor(aMessage+$" (status {aStatus})");
  fStatus := aStatus;
end;

constructor FidlConnectionClosedException(aStatus: Int32);
begin
  inherited constructor("The FIDL connection was closed", aStatus);
end;

constructor FidlDeadlineExceededException;
begin
  inherited constructor("The FIDL call deadline was exceeded", Int32(rtl.ZX_ERR_TIMED_OUT));
end;

class method FidlCallOptions.WithDeadline(aDeadline: Int64): FidlCallOptions;
begin
  if aDeadline < 0 then
    raise new ArgumentOutOfRangeException("aDeadline");
  result.Deadline := aDeadline;
end;

class method FidlCallOptions.WithTimeoutMilliseconds(aMilliseconds: Int64): FidlCallOptions;
begin
  if aMilliseconds < 0 then
    raise new ArgumentOutOfRangeException("aMilliseconds");
  var lNow := Int64(rtl.zx_clock_get_monotonic);
  if aMilliseconds > (Int64.MaxValue-lNow) div 1000000 then
    result.Deadline := Int64.MaxValue
  else
    result.Deadline := lNow+aMilliseconds*1000000;
end;

constructor FidlHandle(aHandle: rtl.zx_handle_t; aObjectType: UInt32; aRights: UInt32);
begin
  fHandle := aHandle;
  fObjectType := aObjectType;
  fRights := aRights;
end;

method FidlHandle.ReleaseHandle: rtl.zx_handle_t;
begin
  result := fHandle;
  fHandle := default(rtl.zx_handle_t);
end;

method FidlHandle.Dispose;
begin
  var lHandle := ReleaseHandle;
  if lHandle <> default(rtl.zx_handle_t) then
    rtl.zx_handle_close(lHandle);
end;

finalizer FidlHandle;
begin
  Dispose;
end;

constructor FidlChannelHandle(aHandle: rtl.zx_handle_t);
begin
  inherited constructor(aHandle, UInt32(rtl.ZX_OBJ_TYPE_CHANNEL), UInt32(rtl.ZX_DEFAULT_CHANNEL_RIGHTS));
end;

constructor FidlChannelPair(aClient: not nullable FidlChannelHandle; aServer: not nullable FidlChannelHandle);
begin
  fClient := aClient;
  fServer := aServer;
end;

constructor FidlClientEnd<T>(aHandle: rtl.zx_handle_t);
begin
  inherited constructor(aHandle);
end;

constructor FidlServerEnd<T>(aHandle: rtl.zx_handle_t);
begin
  inherited constructor(aHandle);
end;

constructor FidlOutgoingHandle(aHandle: not nullable FidlHandle; aObjectType: UInt32; aRights: UInt32);
begin
  fHandle := aHandle;
  fObjectType := aObjectType;
  fRights := aRights;
end;

constructor FidlEncoder(aCapacity: Integer);
begin
  if aCapacity < 0 then
    raise new ArgumentOutOfRangeException("aCapacity");
  fBuffer := new Byte[if aCapacity > 16 then aCapacity else 16];
end;

method FidlEncoder.EnsureCapacity(aAdditionalBytes: Integer);
begin
  if aAdditionalBytes < 0 then
    raise new ArgumentOutOfRangeException("aAdditionalBytes");
  var lRequired := fPosition+aAdditionalBytes;
  if lRequired <= length(fBuffer) then
    exit;
  var lExpanded := length(fBuffer)*2;
  var lBuffer := new Byte[if lRequired > lExpanded then lRequired else lExpanded];
  if fPosition > 0 then
    &Array.Copy(fBuffer, 0, lBuffer, 0, fPosition);
  fBuffer := lBuffer;
end;

method FidlEncoder.Align(aAlignment: Integer);
begin
  if (aAlignment <= 0) or ((aAlignment and (aAlignment-1)) <> 0) then
    raise new ArgumentOutOfRangeException("aAlignment");
  var lAligned := (fPosition+aAlignment-1) and not (aAlignment-1);
  EnsureCapacity(lAligned-fPosition);
  while fPosition < lAligned do begin
    fBuffer[fPosition] := 0;
    inc(fPosition);
  end;
end;

method FidlEncoder.WriteBoolean(aValue: Boolean);
begin
  WriteByte(if aValue then 1 else 0);
end;

method FidlEncoder.WriteByte(aValue: Byte);
begin
  EnsureCapacity(1);
  fBuffer[fPosition] := aValue;
  inc(fPosition);
end;

method FidlEncoder.WriteInt16(aValue: Int16);
begin
  WriteUInt16(UInt16(aValue));
end;

method FidlEncoder.WriteUInt16(aValue: UInt16);
begin
  EnsureCapacity(2);
  fBuffer[fPosition] := Byte(aValue);
  fBuffer[fPosition+1] := Byte(aValue shr 8);
  inc(fPosition, 2);
end;

method FidlEncoder.WriteInt32(aValue: Int32);
begin
  WriteUInt32(UInt32(aValue));
end;

method FidlEncoder.WriteUInt32(aValue: UInt32);
begin
  EnsureCapacity(4);
  for i: Integer := 0 to 3 do
    fBuffer[fPosition+i] := Byte(aValue shr (i*8));
  inc(fPosition, 4);
end;

method FidlEncoder.WriteInt64(aValue: Int64);
begin
  WriteUInt64(UInt64(aValue));
end;

method FidlEncoder.WriteUInt64(aValue: UInt64);
begin
  EnsureCapacity(8);
  for i: Integer := 0 to 7 do
    fBuffer[fPosition+i] := Byte(aValue shr (i*8));
  inc(fPosition, 8);
end;

method FidlEncoder.WriteSingle(aValue: Single);
begin
  var lValue: UInt32;
  memcpy(@lValue, @aValue, sizeOf(lValue));
  WriteUInt32(lValue);
end;

method FidlEncoder.WriteDouble(aValue: Double);
begin
  var lValue: UInt64;
  memcpy(@lValue, @aValue, sizeOf(lValue));
  WriteUInt64(lValue);
end;

method FidlEncoder.WriteBytes(aValue: array of Byte);
begin
  if not assigned(aValue) or (length(aValue) = 0) then
    exit;
  EnsureCapacity(length(aValue));
  &Array.Copy(aValue, 0, fBuffer, fPosition, length(aValue));
  inc(fPosition, length(aValue));
end;

method FidlEncoder.WriteTransactionalHeader(aTransactionID: UInt32; aOrdinal: UInt64);
begin
  if fPosition <> 0 then
    raise new InvalidStateException("A FIDL transactional header must be the first encoded value.");
  if aOrdinal = 0 then
    raise new ArgumentOutOfRangeException("aOrdinal");
  WriteUInt32(aTransactionID);
  WriteByte(0);
  WriteByte(0);
  WriteByte(0);
  WriteByte(FidlWireFormatMagic);
  WriteUInt64(aOrdinal);
end;

method FidlEncoder.ToArray: array of Byte;
begin
  result := new Byte[fPosition];
  if fPosition > 0 then
    &Array.Copy(fBuffer, 0, result, 0, fPosition);
end;

constructor FidlDecoder(aBuffer: not nullable array of Byte; aOffset: Integer);
begin
  if (aOffset < 0) or (aOffset > length(aBuffer)) then
    raise new ArgumentOutOfRangeException("aOffset");
  fBuffer := aBuffer;
  fPosition := aOffset;
end;

method FidlDecoder.EnsureAvailable(aByteCount: Integer);
begin
  if (aByteCount < 0) or (aByteCount > Remaining) then
    raise new FidlProtocolException("The FIDL message ended before the expected value was decoded.");
end;

method FidlDecoder.Align(aAlignment: Integer);
begin
  if (aAlignment <= 0) or ((aAlignment and (aAlignment-1)) <> 0) then
    raise new ArgumentOutOfRangeException("aAlignment");
  var lAligned := (fPosition+aAlignment-1) and not (aAlignment-1);
  EnsureAvailable(lAligned-fPosition);
  while fPosition < lAligned do begin
    if fBuffer[fPosition] <> 0 then
      raise new FidlProtocolException("A FIDL message contains non-zero padding.");
    inc(fPosition);
  end;
end;

method FidlDecoder.ReadBoolean: Boolean;
begin
  var lValue := ReadByte;
  if lValue > 1 then
    raise new FidlProtocolException("A FIDL boolean has an invalid value.");
  result := lValue = 1;
end;

method FidlDecoder.ReadByte: Byte;
begin
  EnsureAvailable(1);
  result := fBuffer[fPosition];
  inc(fPosition);
end;

method FidlDecoder.ReadInt16: Int16;
begin
  result := Int16(ReadUInt16);
end;

method FidlDecoder.ReadUInt16: UInt16;
begin
  EnsureAvailable(2);
  result := UInt16(fBuffer[fPosition]) or (UInt16(fBuffer[fPosition+1]) shl 8);
  inc(fPosition, 2);
end;

method FidlDecoder.ReadInt32: Int32;
begin
  result := Int32(ReadUInt32);
end;

method FidlDecoder.ReadUInt32: UInt32;
begin
  EnsureAvailable(4);
  for i: Integer := 0 to 3 do
    result := result or (UInt32(fBuffer[fPosition+i]) shl (i*8));
  inc(fPosition, 4);
end;

method FidlDecoder.ReadInt64: Int64;
begin
  result := Int64(ReadUInt64);
end;

method FidlDecoder.ReadUInt64: UInt64;
begin
  EnsureAvailable(8);
  for i: Integer := 0 to 7 do
    result := result or (UInt64(fBuffer[fPosition+i]) shl (i*8));
  inc(fPosition, 8);
end;

method FidlDecoder.ReadSingle: Single;
begin
  var lValue := ReadUInt32;
  memcpy(@result, @lValue, sizeOf(result));
end;

method FidlDecoder.ReadDouble: Double;
begin
  var lValue := ReadUInt64;
  memcpy(@result, @lValue, sizeOf(result));
end;

method FidlDecoder.ReadBytes(aCount: Integer): array of Byte;
begin
  EnsureAvailable(aCount);
  result := new Byte[aCount];
  if aCount > 0 then
    &Array.Copy(fBuffer, fPosition, result, 0, aCount);
  inc(fPosition, aCount);
end;

constructor FidlIncomingMessage(aBytes: not nullable array of Byte; aHandles: not nullable array of FidlHandle);
begin
  if length(aBytes) < FidlTransactionalHeaderSize then
    raise new FidlProtocolException("A FIDL transactional message is shorter than its header.");
  fBytes := aBytes;
  fHandles := aHandles;
  var lDecoder := new FidlDecoder(aBytes);
  fTransactionID := lDecoder.ReadUInt32;
  lDecoder.ReadByte;
  lDecoder.ReadByte;
  lDecoder.ReadByte;
  if lDecoder.ReadByte <> FidlWireFormatMagic then
    raise new FidlProtocolException("A FIDL transactional message uses an unsupported wire-format magic value.");
  fOrdinal := lDecoder.ReadUInt64;
  if fOrdinal = 0 then
    raise new FidlProtocolException("A FIDL transactional message has ordinal zero.");
end;

method FidlIncomingMessage.BodyDecoder: not nullable FidlDecoder;
begin
  result := new FidlDecoder(fBytes, FidlTransactionalHeaderSize);
end;

method FidlIncomingMessage.TakeHandle(aIndex: Integer): not nullable FidlHandle;
begin
  if (aIndex < 0) or (aIndex >= length(fHandles)) then
    raise new ArgumentOutOfRangeException("aIndex");
  var lHandle := fHandles[aIndex];
  if not assigned(lHandle) then
    raise new InvalidStateException($"FIDL handle {aIndex} has already been taken.");
  fHandles[aIndex] := nil;
  result := lHandle as not nullable;
end;

method FidlIncomingMessage.Dispose;
begin
  if InternalCalls.Exchange(var fDisposed, 1) <> 0 then
    exit;
  for i: Integer := 0 to length(fHandles)-1 do
    if assigned(fHandles[i]) then begin
      fHandles[i].Dispose;
      fHandles[i] := nil;
    end;
end;

finalizer FidlIncomingMessage;
begin
  Dispose;
end;

constructor FidlDispatcher;
begin
  if sizeOf(FidlPortPacket) <> 48 then
    raise new InvalidStateException("The local Zircon port packet layout does not match the Fuchsia ABI.");
  var lPort: rtl.zx_handle_t;
  var lStatus := rtl.zx_port_create(0, @lPort);
  if lStatus <> rtl.ZX_OK then
    raise new FidlTransportException("Could not create the FIDL dispatcher port", Int32(lStatus));
  fPort := new FidlHandle(lPort);
  fThread := new Thread(@ThreadMain);
  fThread.Start(nil);
end;

method FidlDispatcher.Arm(aConnection: not nullable FidlConnection);
begin
  if aConnection.IsDisposed then
    exit;
  var lSignals := rtl.ZX_CHANNEL_READABLE or rtl.ZX_CHANNEL_PEER_CLOSED;
  var lStatus := rtl.zx_object_wait_async(aConnection.Channel.RawHandle,
                                          fPort.RawHandle,
                                          aConnection.DispatcherKey,
                                          lSignals,
                                          rtl.ZX_WAIT_ASYNC_ONCE);
  if lStatus <> rtl.ZX_OK then
    aConnection.Fail(new FidlTransportException("Could not arm the FIDL channel wait", Int32(lStatus)));
end;

method FidlDispatcher.SnapshotConnections: not nullable List<FidlConnection>;
begin
  result := new List<FidlConnection>;
  locking fLock do
    for each lConnection in fConnections.Values do
      result.Add(lConnection);
end;

method FidlDispatcher.RegisterConnection(aConnection: not nullable FidlConnection);
begin
  var lKey := UInt64(InternalCalls.Increment(var fNextKey)+1);
  if lKey = 0 then
    raise new InvalidStateException("The FIDL dispatcher exhausted its connection keys.");
  aConnection.DispatcherKey := lKey;
  locking fLock do
    fConnections.Add(lKey, aConnection);
  Arm(aConnection);
end;

method FidlDispatcher.UnregisterConnection(aConnection: not nullable FidlConnection);
begin
  if aConnection.DispatcherKey = 0 then
    exit;
  rtl.zx_port_cancel(fPort.RawHandle, aConnection.Channel.RawHandle, aConnection.DispatcherKey);
  locking fLock do
    fConnections.Remove(aConnection.DispatcherKey);
  aConnection.DispatcherKey := 0;
end;

method FidlDispatcher.WakeForDeadline;
begin
  var lPacket: FidlPortPacket;
  lPacket.Key := 0;
  lPacket.PacketType := UInt32(rtl.ZX_PKT_TYPE_USER);
  lPacket.Status := Int32(rtl.ZX_OK);
  var lStatus := rtl.zx_port_queue(fPort.RawHandle, @lPacket);
  if (lStatus <> rtl.ZX_OK) and (lStatus <> rtl.ZX_ERR_BAD_HANDLE) then
    raise new FidlTransportException("Could not wake the FIDL deadline dispatcher", Int32(lStatus));
end;

method FidlDispatcher.ThreadMain(aState: Object);
begin
  loop begin
    var lConnections := SnapshotConnections;
    var lDeadline := Int64.MaxValue;
    for each lConnection in lConnections do begin
      var lConnectionDeadline := lConnection.NextDeadline;
      if lConnectionDeadline < lDeadline then
        lDeadline := lConnectionDeadline;
    end;

    var lPacket: FidlPortPacket;
    var lStatus := rtl.zx_port_wait(fPort.RawHandle, rtl.zx_instant_mono_t(lDeadline), @lPacket);
    if (lStatus <> rtl.ZX_OK) and (lStatus <> rtl.ZX_ERR_TIMED_OUT) then
      continue;

    if lStatus = rtl.ZX_OK then begin
      var lConnection: FidlConnection;
      var lFound: Boolean;
      locking fLock do
        lFound := fConnections.TryGetValue(lPacket.Key, out lConnection);
      if lFound and assigned(lConnection) then begin
        lConnection.HandlePacket;
        Arm(lConnection);
      end;
    end;

    lConnections := SnapshotConnections;
    var lNow := Int64(rtl.zx_clock_get_monotonic);
    for each lConnection in lConnections do
      lConnection.ExpireDeadlines(lNow);
  end;
end;

constructor FidlConnection(aChannel: not nullable FidlChannelHandle);
begin
  fChannel := aChannel;
  FidlDispatcher.Shared.RegisterConnection(self);
end;

class method FidlConnection.CreateChannelPair: not nullable FidlChannelPair;
begin
  var lClient, lServer: rtl.zx_handle_t;
  var lStatus := rtl.zx_channel_create(0, @lClient, @lServer);
  if lStatus <> rtl.ZX_OK then
    raise new FidlTransportException("Could not create a FIDL channel pair", Int32(lStatus));
  result := new FidlChannelPair(new FidlChannelHandle(lClient), new FidlChannelHandle(lServer));
end;

class method FidlConnection.Connect(aProtocolName: not nullable String): not nullable FidlConnection;
begin
  if length(aProtocolName) = 0 then
    raise new ArgumentException("A FIDL protocol name is required.");
  var lPair := CreateChannelPair;
  var lPath := if aProtocolName.StartsWith("/", false) then aProtocolName else "/svc/"+aProtocolName;
  var lPathBytes := lPath.ToAnsiChars(true);
  var lServerHandle := lPair.Server.ReleaseHandle;
  var lStatus := rtl.fdio_service_connect(@lPathBytes[0], lServerHandle);
  if lStatus <> rtl.ZX_OK then begin
    lPair.Client.Dispose;
    raise new FidlTransportException($"Could not connect to FIDL service '{lPath}'", Int32(lStatus));
  end;
  result := new FidlConnection(lPair.Client);
end;

method FidlConnection.AllocateTransactionID: UInt32;
begin
  locking fLock do begin
    repeat
      inc(fNextTransactionID);
      fNextTransactionID := fNextTransactionID and $7fffffff;
      if fNextTransactionID = 0 then
        fNextTransactionID := 1;
    until not fPending.ContainsKey(fNextTransactionID) and not fExpiredTransactions.Contains(fNextTransactionID);
    result := fNextTransactionID;
  end;
end;

method FidlConnection.Send(aTransactionID: UInt32;
                           aOrdinal: UInt64;
                           aPayload: nullable array of Byte;
                           aHandles: nullable array of FidlOutgoingHandle): Int32;
begin
  locking fWriteLock do begin
    var lEncoder := new FidlEncoder(FidlTransactionalHeaderSize+length(aPayload));
    lEncoder.WriteTransactionalHeader(aTransactionID, aOrdinal);
    lEncoder.WriteBytes(aPayload);
    var lBytes := lEncoder.ToArray;

    var lDispositions: array of rtl.zx_handle_disposition_t;
    if length(aHandles) > 0 then begin
      lDispositions := new rtl.zx_handle_disposition_t[length(aHandles)];
      for i: Integer := 0 to length(aHandles)-1 do begin
        lDispositions[i].operation := rtl.ZX_HANDLE_OP_MOVE;
        lDispositions[i].handle := aHandles[i].Handle.ReleaseHandle;
        lDispositions[i].&type := rtl.zx_obj_type_t(aHandles[i].ObjectType);
        lDispositions[i].rights := rtl.zx_rights_t(aHandles[i].Rights);
        lDispositions[i].result := rtl.ZX_OK;
      end;
    end;

    var lBytesPointer := if length(lBytes) = 0 then nil else @lBytes[0];
    var lHandlesPointer := if length(lDispositions) = 0 then nil else @lDispositions[0];
    result := Int32(rtl.zx_channel_write_etc(fChannel.RawHandle,
                                             0,
                                             lBytesPointer,
                                             UInt32(length(lBytes)),
                                             lHandlesPointer,
                                             UInt32(length(lDispositions))));
  end;
end;

method FidlConnection.CallAsync(aOrdinal: UInt64;
                                aPayload: nullable array of Byte;
                                aHandles: nullable array of FidlOutgoingHandle;
                                aOptions: FidlCallOptions): not nullable Task<FidlIncomingMessage>;
begin
  if IsDisposed then begin
    var lClosed := new TaskCompletionSource<FidlIncomingMessage>;
    lClosed.SetException(new FidlConnectionClosedException(Int32(rtl.ZX_ERR_PEER_CLOSED)));
    exit lClosed.Task as not nullable;
  end;
  if aOptions.Deadline < 0 then
    raise new ArgumentOutOfRangeException("aOptions.Deadline");

  var lCompletion := new TaskCompletionSource<FidlIncomingMessage>;
  if (aOptions.Deadline > 0) and (aOptions.Deadline <= Int64(rtl.zx_clock_get_monotonic)) then begin
    lCompletion.SetException(new FidlDeadlineExceededException);
    exit lCompletion.Task as not nullable;
  end;

  var lTransactionID := AllocateTransactionID;
  var lAdded: Boolean;
  locking fLock do begin
    if fDisposed = 0 then begin
      fPending.Add(lTransactionID, lCompletion);
      if aOptions.Deadline > 0 then
        fDeadlines.Add(lTransactionID, aOptions.Deadline);
      lAdded := true;
    end;
  end;
  if not lAdded then begin
    lCompletion.SetException(new FidlConnectionClosedException(Int32(rtl.ZX_ERR_PEER_CLOSED)));
    exit lCompletion.Task as not nullable;
  end;

  if aOptions.Deadline > 0 then begin
    try
      FidlDispatcher.Shared.WakeForDeadline;
    except
      on E: Exception do begin
        var lRemoved: Boolean;
        locking fLock do begin
          lRemoved := fPending.Remove(lTransactionID);
          fDeadlines.Remove(lTransactionID);
        end;
        if lRemoved then
          lCompletion.SetException(E);
        exit lCompletion.Task as not nullable;
      end;
    end;
  end;

  var lStatus := Send(lTransactionID, aOrdinal, aPayload, aHandles);
  if lStatus <> rtl.ZX_OK then begin
    var lRemoved: Boolean;
    locking fLock do begin
      lRemoved := fPending.Remove(lTransactionID);
      fDeadlines.Remove(lTransactionID);
    end;
    if lRemoved then
      lCompletion.SetException(new FidlTransportException("Could not send the FIDL request", lStatus));
  end;
  result := lCompletion.Task as not nullable;
end;

method FidlConnection.SendOneWay(aOrdinal: UInt64;
                                 aPayload: nullable array of Byte;
                                 aHandles: nullable array of FidlOutgoingHandle): not nullable Task;
begin
  if IsDisposed then
    raise new FidlConnectionClosedException(Int32(rtl.ZX_ERR_PEER_CLOSED));
  var lStatus := Send(0, aOrdinal, aPayload, aHandles);
  if lStatus <> rtl.ZX_OK then
    raise new FidlTransportException("Could not send the one-way FIDL request", lStatus);
  result := Task.CompletedTask as not nullable;
end;

method FidlConnection.CompleteResponse(aMessage: not nullable FidlIncomingMessage);
begin
  var lCompletion: TaskCompletionSource<FidlIncomingMessage>;
  var lExpired: Boolean;
  locking fLock do begin
    if fPending.TryGetValue(aMessage.TransactionID, out lCompletion) then begin
      fPending.Remove(aMessage.TransactionID);
      fDeadlines.Remove(aMessage.TransactionID);
    end
    else
      lExpired := fExpiredTransactions.Remove(aMessage.TransactionID);
  end;
  if lExpired then begin
    aMessage.Dispose;
    exit;
  end;
  if not assigned(lCompletion) then begin
    aMessage.Dispose;
    Fail(new FidlProtocolException($"Received a FIDL response for unknown transaction {aMessage.TransactionID}."));
    exit;
  end;
  lCompletion.SetResult(aMessage);
end;

method FidlConnection.NextDeadline: Int64;
begin
  result := Int64.MaxValue;
  locking fLock do
    for each lDeadline in fDeadlines.Values do
      if lDeadline < result then
        result := lDeadline;
end;

method FidlConnection.ExpireDeadlines(aNow: Int64);
begin
  var lExpiredIDs := new List<UInt32>;
  var lCompletions := new List<TaskCompletionSource<FidlIncomingMessage>>;
  locking fLock do begin
    for each lPair in fDeadlines do
      if lPair.Value <= aNow then
        lExpiredIDs.Add(lPair.Key);

    for each lTransactionID in lExpiredIDs do begin
      var lCompletion: TaskCompletionSource<FidlIncomingMessage>;
      if fPending.TryGetValue(lTransactionID, out lCompletion) then begin
        fPending.Remove(lTransactionID);
        lCompletions.Add(lCompletion);
        fExpiredTransactions.Add(lTransactionID);
        fExpiredTransactionOrder.Enqueue(lTransactionID);
      end;
      fDeadlines.Remove(lTransactionID);
    end;

    while fExpiredTransactionOrder.Count > FidlMaximumExpiredTransactions do begin
      var lOldest := fExpiredTransactionOrder.Dequeue;
      fExpiredTransactions.Remove(lOldest);
    end;
  end;

  for each lCompletion in lCompletions do
    lCompletion.SetException(new FidlDeadlineExceededException);
end;

method FidlConnection.HandlePacket;
begin
  loop begin
    var lBytes := new Byte[FidlMaximumMessageBytes];
    var lHandleInfo := new rtl.zx_handle_info_t[FidlMaximumMessageHandles];
    var lActualBytes, lActualHandles: UInt32;
    var lStatus := rtl.zx_channel_read_etc(fChannel.RawHandle,
                                           0,
                                           @lBytes[0],
                                           @lHandleInfo[0],
                                           UInt32(length(lBytes)),
                                           UInt32(length(lHandleInfo)),
                                           @lActualBytes,
                                           @lActualHandles);
    if lStatus = rtl.ZX_ERR_SHOULD_WAIT then
      exit;
    if lStatus <> rtl.ZX_OK then begin
      Fail(new FidlConnectionClosedException(Int32(lStatus)));
      exit;
    end;

    var lMessageBytes := new Byte[Integer(lActualBytes)];
    if lActualBytes > 0 then
      &Array.Copy(lBytes, 0, lMessageBytes, 0, Integer(lActualBytes));
    var lHandles := new FidlHandle[Integer(lActualHandles)];
    for i: Integer := 0 to Integer(lActualHandles)-1 do
      lHandles[i] := new FidlHandle(lHandleInfo[i].handle,
                                    UInt32(lHandleInfo[i].&type),
                                    UInt32(lHandleInfo[i].rights));

    var lMessage: FidlIncomingMessage;
    try
      lMessage := new FidlIncomingMessage(lMessageBytes, lHandles);
      if (lMessage.TransactionID = 0) and (lMessage.Ordinal = FidlEpitaphOrdinal) then begin
        var lDecoder := lMessage.BodyDecoder;
        var lEpitaphStatus := lDecoder.ReadInt32;
        lMessage.Dispose;
        Fail(new FidlConnectionClosedException(lEpitaphStatus));
        exit;
      end;
      if lMessage.TransactionID = 0 then begin
        if assigned(EventReceived) then begin
          try
            try
              EventReceived(lMessage);
            except
            end;
          finally
            lMessage.Dispose;
          end;
        end
        else
          lMessage.Dispose;
      end
      else
        CompleteResponse(lMessage);
    except
      on E: Exception do begin
        if assigned(lMessage) then
          lMessage.Dispose
        else
          for each lHandle in lHandles do
            if assigned(lHandle) then
              lHandle.Dispose;
        Fail(E);
        exit;
      end;
    end;
  end;
end;

method FidlConnection.Fail(aException: not nullable Exception);
begin
  if InternalCalls.Exchange(var fDisposed, 1) <> 0 then
    exit;
  FidlDispatcher.Shared.UnregisterConnection(self);
  fChannel.Dispose;

  var lPending := new List<TaskCompletionSource<FidlIncomingMessage>>;
  locking fLock do begin
    for each lCompletion in fPending.Values do
      lPending.Add(lCompletion);
    fPending.Clear;
    fDeadlines.Clear;
    fExpiredTransactions.Clear;
    fExpiredTransactionOrder.Clear;
  end;
  for each lCompletion in lPending do
    lCompletion.SetException(aException);
end;

method FidlConnection.Dispose;
begin
  Fail(new FidlConnectionClosedException(Int32(rtl.ZX_ERR_CANCELED)));
end;

finalizer FidlConnection;
begin
  Dispose;
end;

constructor FidlProtocolConnection<T>(aConnection: not nullable FidlConnection);
begin
  fConnection := aConnection;
end;

class method FidlProtocolConnection<T>.DefaultProtocolName: not nullable String;
begin
  var lName := typeOf(T).FullName;
  var lSeparator := lName.LastIndexOf(".");
  if lSeparator < 1 then
    raise new FidlProtocolException($"Protocol type '{lName}' does not have a FIDL library namespace.");
  result := lName.Substring(0, lSeparator)+"/"+lName.Substring(lSeparator+1);
end;

class method FidlProtocolConnection<T>.Connect(aProtocolName: nullable String): not nullable FidlProtocolConnection<T>;
begin
  var lProtocolName := if length(aProtocolName) = 0 then DefaultProtocolName else aProtocolName;
  result := new FidlProtocolConnection<T>(FidlConnection.Connect(lProtocolName));
end;

method FidlProtocolConnection<T>.CallAsync(aOrdinal: UInt64;
                                           aPayload: nullable array of Byte;
                                           aHandles: nullable array of FidlOutgoingHandle;
                                           aOptions: FidlCallOptions): not nullable Task<FidlIncomingMessage>;
begin
  result := fConnection.CallAsync(aOrdinal, aPayload, aHandles, aOptions);
end;

method FidlProtocolConnection<T>.CallUInt32Async(aOrdinal: UInt64;
                                                 aValue: UInt32): not nullable Task<UInt32>;
begin
  result := CallUInt32Async(aOrdinal, aValue, default(FidlCallOptions));
end;

method FidlProtocolConnection<T>.CallUInt32Async(aOrdinal: UInt64;
                                                 aValue: UInt32;
                                                 aOptions: FidlCallOptions): not nullable Task<UInt32>;
begin
  result := FidlUInt32Codec.CallAsync(fConnection, aOrdinal, aValue, aOptions);
end;

class method FidlUInt32Codec.CallAsync(aConnection: not nullable FidlConnection;
                                       aOrdinal: UInt64;
                                       aValue: UInt32;
                                       aOptions: FidlCallOptions): not nullable Task<UInt32>;
begin
  var lEncoder := new FidlEncoder(8);
  lEncoder.WriteUInt32(aValue);
  lEncoder.Align(8);
  var lCompletion := new TaskCompletionSource<UInt32>;
  var lCall := aConnection.CallAsync(aOrdinal, lEncoder.ToArray, nil, aOptions);
  _ := lCall.ContinueWith(@CompleteCall, lCompletion);
  result := lCompletion.Task as not nullable;
end;

class method FidlUInt32Codec.CompleteCall(aTask: not nullable Task; aState: nullable Object);
begin
  var lCompletion := TaskCompletionSource<UInt32>(aState);
  try
    if aTask.IsFaulted then
      lCompletion.SetException(aTask.Exception)
    else
      lCompletion.SetResult(Decode(aTask));
  except
    on E: Exception do
      lCompletion.SetException(E);
  end;
end;

class method FidlUInt32Codec.Decode(aTask: not nullable Task): UInt32;
begin
  var lMessage := Task<FidlIncomingMessage>(aTask).Result;
  try
    var lDecoder := lMessage.BodyDecoder;
    result := lDecoder.ReadUInt32;
    lDecoder.Align(8);
    if lDecoder.Remaining <> 0 then
      raise new FidlProtocolException("A fixed UInt32 FIDL response contains trailing data.");
  finally
    lMessage.Dispose;
  end;
end;

method FidlProtocolConnection<T>.CallStringAsync(aOrdinal: UInt64;
                                                 aValue: not nullable String): not nullable Task<String>;
begin
  result := CallStringAsync(aOrdinal, aValue, default(FidlCallOptions));
end;

method FidlProtocolConnection<T>.CallStringAsync(aOrdinal: UInt64;
                                                 aValue: not nullable String;
                                                 aOptions: FidlCallOptions): not nullable Task<String>;
begin
  result := FidlStringCodec.CallAsync(fConnection, aOrdinal, aValue, aOptions);
end;

class method FidlStringCodec.CallAsync(aConnection: not nullable FidlConnection;
                                       aOrdinal: UInt64;
                                       aValue: not nullable String;
                                       aOptions: FidlCallOptions): not nullable Task<String>;
begin
  var lBytes := Encoding.UTF8.GetBytes(aValue, false);
  var lEncoder := new FidlEncoder(16+length(lBytes));
  lEncoder.WriteUInt64(UInt64(length(lBytes)));
  lEncoder.WriteUInt64(UInt64.MaxValue);
  lEncoder.WriteBytes(lBytes);
  lEncoder.Align(8);
  var lCompletion := new TaskCompletionSource<String>;
  var lCall := aConnection.CallAsync(aOrdinal, lEncoder.ToArray, nil, aOptions);
  _ := lCall.ContinueWith(@CompleteCall, lCompletion);
  result := lCompletion.Task as not nullable;
end;

class method FidlStringCodec.CompleteCall(aTask: not nullable Task; aState: nullable Object);
begin
  var lCompletion := TaskCompletionSource<String>(aState);
  try
    if aTask.IsFaulted then
      lCompletion.SetException(aTask.Exception)
    else
      lCompletion.SetResult(Decode(aTask));
  except
    on E: Exception do
      lCompletion.SetException(E);
  end;
end;

class method FidlStringCodec.Decode(aTask: not nullable Task): not nullable String;
begin
  var lMessage := Task<FidlIncomingMessage>(aTask).Result;
  try
    var lDecoder := lMessage.BodyDecoder;
    var lCount := lDecoder.ReadUInt64;
    if lDecoder.ReadUInt64 <> UInt64.MaxValue then
      raise new FidlProtocolException("A non-nullable FIDL string is absent.");
    if lCount > UInt64(Int32.MaxValue) then
      raise new FidlProtocolException("A FIDL string exceeds the supported size.");
    result := Encoding.UTF8.GetString(lDecoder.ReadBytes(Integer(lCount)));
    lDecoder.Align(8);
    if lDecoder.Remaining <> 0 then
      raise new FidlProtocolException("A FIDL string response contains trailing data.");
  finally
    lMessage.Dispose;
  end;
end;

method FidlProtocolConnection<T>.CallByteVectorAsync(aOrdinal: UInt64;
                                                     aValue: not nullable array of Byte): not nullable Task<array of Byte>;
begin
  result := CallByteVectorAsync(aOrdinal, aValue, default(FidlCallOptions));
end;

method FidlProtocolConnection<T>.CallByteVectorAsync(aOrdinal: UInt64;
                                                     aValue: not nullable array of Byte;
                                                     aOptions: FidlCallOptions): not nullable Task<array of Byte>;
begin
  result := FidlByteVectorCodec.CallAsync(fConnection, aOrdinal, aValue, aOptions);
end;

class method FidlByteVectorCodec.CallAsync(aConnection: not nullable FidlConnection;
                                           aOrdinal: UInt64;
                                           aValue: not nullable array of Byte;
                                           aOptions: FidlCallOptions): not nullable Task<array of Byte>;
begin
  var lEncoder := new FidlEncoder(16+length(aValue));
  lEncoder.WriteUInt64(UInt64(length(aValue)));
  lEncoder.WriteUInt64(UInt64.MaxValue);
  lEncoder.WriteBytes(aValue);
  lEncoder.Align(8);
  var lCompletion := new TaskCompletionSource<array of Byte>;
  var lCall := aConnection.CallAsync(aOrdinal, lEncoder.ToArray, nil, aOptions);
  _ := lCall.ContinueWith(@CompleteCall, lCompletion);
  result := lCompletion.Task as not nullable;
end;

class method FidlByteVectorCodec.CompleteCall(aTask: not nullable Task; aState: nullable Object);
begin
  var lCompletion := TaskCompletionSource<array of Byte>(aState);
  try
    if aTask.IsFaulted then
      lCompletion.SetException(aTask.Exception)
    else
      lCompletion.SetResult(Decode(aTask));
  except
    on E: Exception do
      lCompletion.SetException(E);
  end;
end;

class method FidlByteVectorCodec.Decode(aTask: not nullable Task): not nullable array of Byte;
begin
  var lMessage := Task<FidlIncomingMessage>(aTask).Result;
  try
    var lDecoder := lMessage.BodyDecoder;
    var lCount := lDecoder.ReadUInt64;
    if lDecoder.ReadUInt64 <> UInt64.MaxValue then
      raise new FidlProtocolException("A non-nullable FIDL byte vector is absent.");
    if lCount > UInt64(Int32.MaxValue) then
      raise new FidlProtocolException("A FIDL byte vector exceeds the supported size.");
    result := lDecoder.ReadBytes(Integer(lCount)) as not nullable;
    lDecoder.Align(8);
    if lDecoder.Remaining <> 0 then
      raise new FidlProtocolException("A FIDL byte-vector response contains trailing data.");
  finally
    lMessage.Dispose;
  end;
end;

method FidlProtocolConnection<T>.SendOneWay(aOrdinal: UInt64;
                                            aPayload: nullable array of Byte;
                                            aHandles: nullable array of FidlOutgoingHandle): not nullable Task;
begin
  result := fConnection.SendOneWay(aOrdinal, aPayload, aHandles);
end;

method FidlProtocolConnection<T>.Dispose;
begin
  fConnection.Dispose;
end;

finalizer FidlProtocolConnection<T>;
begin
  Dispose;
end;

end.
