namespace RemObjects.Elements.System;

interface

type
  MemoryStream = public class(Stream)
  private
    fCapacity: Integer := 0;
    fLength: Int64 := 0;
    fPosition: Int64 := 0;
    fbuf : array of Byte;
    method SetCapacity(value: Int32);
    method CheckCapacity(value: Int32);
    method CalcCapacity(aNewCapacity: Int32): Int32;
  protected
    method IsValid: Boolean; override;
  public
    constructor; empty;
    constructor(aCapacity: Int32);

    property CanRead: Boolean read IsValid; override;
    property CanSeek: Boolean read IsValid; override;
    property CanWrite: Boolean read IsValid; override;
    method Seek(Offset: Int64; Origin: SeekOrigin): Int64; override;
    method &Read(aSpan: Span<Byte>): Int32; override;
    method &Write(aSpan: ImmutableSpan<Byte>): Int32; override;
    method ToArray: array of Byte;
    method WriteTo(Destination: Stream);
    {$IFNDEF NOFILES}
    method LoadFromFile(FileName: String);
    method SaveToFile(FileName: String);
    {$ENDIF}

    property Capacity: Int32 read fCapacity write SetCapacity;
    property Length: Int64 read fLength; override;
    method SetLength(value: Int64); override;
  end;

implementation

constructor MemoryStream(aCapacity: Int32);
begin
  Capacity := aCapacity;
end;

method MemoryStream.SetCapacity(value: Int32);
begin
  if (value < 0) or (value < fLength) then raise new Exception('Capacity cannot be less than the current length of the stream.');
  if value = fCapacity then exit;
  var temp := new array of Byte(value);
  if fLength >0 then
    memcpy(@temp[0], @fbuf[0], fLength);
  fbuf := temp;
  fCapacity := value;
end;

method MemoryStream.SetLength(value: Int64);
begin
  if (value < 0) or (value > Int32.MaxValue) then
    raise new ArgumentOutOfRangeException('MemoryStream length');
  var curpos := Position;
  CheckCapacity(Int32(value));
  // Shrink then grow must not reveal bytes from the old contents.
  if value > fLength then memset(@fbuf[fLength], 0, NativeInt(value - fLength));
  fLength := value;
  if curpos > fLength then Seek(0, SeekOrigin.End);
end;

method MemoryStream.Seek(Offset: Int64; Origin: SeekOrigin): Int64;
begin
  var base: Int64;
  case Origin of
    SeekOrigin.Begin: base := 0;
    SeekOrigin.Current: base := fPosition;
    SeekOrigin.End: base := fLength;
    else raise new ArgumentOutOfRangeException('Invalid seek origin');
  end;
  if (Offset < -base) or (Offset > Int64.MaxValue - base) then
    raise new ArgumentOutOfRangeException('MemoryStream position');
  fPosition := base + Offset;
  exit fPosition;
end;

method MemoryStream.Read(aSpan: Span<Byte>): Int32;
begin
  if not CanRead then raise new NotSupportedException;
  if aSpan.Length = 0 then exit 0;
  var lres := fLength - fPosition;
  if lres <= 0 then exit 0;
  if lres > aSpan.Length then lres := aSpan.Length;
  memcpy(aSpan.Pointer, @fbuf[fPosition], lres);
  fPosition := fPosition + lres;
  exit lres;
end;

method MemoryStream.Write(aSpan: ImmutableSpan<Byte>): Int32;
begin
  if not CanWrite then raise new NotSupportedException;
  if aSpan.Length = 0 then exit 0;
  if (fPosition > Int32.MaxValue) or (aSpan.Length > Int32.MaxValue - fPosition) then
    raise new ArgumentOutOfRangeException('MemoryStream write exceeds maximum length');
  CheckCapacity(Int32(fPosition + aSpan.Length));
  if fPosition > fLength then memset(@fbuf[fLength], 0, NativeInt(fPosition - fLength));
  memmove(@fbuf[fPosition], aSpan.Pointer, aSpan.Length);
  fPosition := fPosition + aSpan.Length;
  if fPosition > fLength then fLength := fPosition;
  exit aSpan.Length;
end;

method MemoryStream.ToArray: array of Byte;
begin
  result := new array of Byte(fLength);
  if fLength > 0 then
    memcpy(@result[0], @fbuf[0], fLength);
end;

method MemoryStream.CheckCapacity(value: Int32);
begin
  if fCapacity < value then
    SetCapacity(CalcCapacity(value));
end;

method MemoryStream.CalcCapacity(aNewCapacity: Int32): Int32;
begin
  var lDelta: Int32;
  if aNewCapacity > 64 then lDelta := aNewCapacity / 4
  else if aNewCapacity > 8 then lDelta := 16
  else lDelta := 4;
  if lDelta > Int32.MaxValue - aNewCapacity then exit aNewCapacity;
  exit aNewCapacity + lDelta;
end;

method MemoryStream.IsValid: Boolean;
begin
  exit true;
end;

method MemoryStream.WriteTo(Destination: Stream);
begin
  if Destination = nil then raise new Exception('Destination is null');
  if not Destination.CanWrite then raise new NotSupportedException;
  var written := 0;
  while written < fLength do begin
    var count := Destination.Write(new ImmutableSpan<Byte>(fbuf, written, Int32(fLength - written)));
    if (count <= 0) or (count > fLength - written) then raise new Exception('Invalid stream write count');
    inc(written, count);
  end;
end;

{$IFNDEF NOFILES}
method MemoryStream.LoadFromFile(FileName: String);
begin
  var fs := new FileStream(FileName, FileMode.Open,FileAccess.Read, FileShare.Read);
  try
    SetLength(0);
    var expected := fs.Length;
    if expected > Int32.MaxValue then raise new ArgumentOutOfRangeException('File exceeds MemoryStream maximum length');
    self.Capacity := Int32(expected);
    while fLength < expected do begin
      var count := fs.Read(new Span<Byte>(fbuf, Int32(fLength), Int32(expected - fLength)));
      if count = 0 then break;
      inc(fLength, count);
    end;
  finally
    fs.Close;
  end;
end;

method MemoryStream.SaveToFile(FileName: String);
begin
  var fs := new FileStream(FileName, FileMode.Create,FileAccess.Write, FileShare.None);
  try
    WriteTo(fs);
  finally
    fs.Close;
  end;
end;
{$ENDIF}
end.