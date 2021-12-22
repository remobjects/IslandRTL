namespace RemObjects.Elements.System;

interface

type
  SeekOrigin = public enum (&Begin, Current, &End);

  Stream = public abstract class(IDisposable)
  private
    method GetLength: Int64;
    method SetPosition(value: Int64);
    method GetPosition: Int64;
    method Dispose;
  protected
    method IsValid: Boolean; abstract;
  public
    property CanRead: Boolean read; abstract;
    property CanSeek: Boolean read; abstract;
    property CanWrite: Boolean read; abstract;
    method Seek(Offset: Int64; Origin: SeekOrigin): Int64; abstract;
    method Close; virtual; empty;
    method Flush; virtual; empty;
    method &Read(aSpan: Span<Byte>): Int32; abstract;
    method &Write(aSpan: ImmutableSpan<Byte>): Int32; abstract;
    method &Read(Buffer: array of Byte; Offset: Int32; Count: Int32): Int32;
    method &Write(Buffer: array of Byte; Offset: Int32; Count: Int32): Int32;

    method &Read(const buf: ^Void; Count: Int32): Int32;
    begin
      exit &Read(new Span<Byte>(^Byte(buf), Count));
    end;

    method &Write(const buf: ^Void; Count: Int32): Int32;
    begin
      exit &Write(new ImmutableSpan<Byte>(^Byte(buf), Count));
    end;

    method CopyTo(Destination: Stream);
    property Length: Int64 read GetLength; virtual;
    method SetLength(value: Int64); virtual;
    property Position: Int64 read GetPosition write SetPosition; virtual;
  end;

implementation

method Stream.GetLength: Int64;
begin
  if not CanSeek then raise new NotSupportedException();
  var pos := Seek(0, SeekOrigin.Current);
  var temp := Seek(0, SeekOrigin.End);
  Seek(pos, SeekOrigin.Begin);
  exit temp;
end;

method Stream.GetPosition: Int64;
begin
  exit Seek(0, SeekOrigin.Current);
end;

method Stream.SetPosition(value: Int64);
begin
  Seek(value, SeekOrigin.Begin);
end;

method Stream.SetLength(value: Int64);
begin
  raise new NotSupportedException;
end;

method Stream.Dispose;
begin
  Close;
end;

method Stream.CopyTo(Destination: Stream);
const
  bufsize = 4*1024; //4 kb
begin
  if Destination = nil then raise new Exception('Destination is null');
  if not self.CanRead then raise new NotSupportedException;
  if not Destination.CanWrite then raise new NotSupportedException;
  var buf: array [bufsize] of Byte := InternalCalls.Undefined<array [bufsize] of Byte>();
  loop begin
    var rest := &Read(new Span<Byte>(@buf[0], bufsize));
    if rest > 0 then rest := Destination.Write(new Span<Byte>(@buf[0], rest));
    if rest <> bufsize then break;
  end;
end;

method Stream.Read(Buffer: array of Byte; Offset: Int32; Count: Int32): Int32;
begin
  if not CanRead then raise new NotSupportedException;
  exit &Read(new Span<Byte>(Buffer, Offset, Count));
end;

method Stream.Write(Buffer: array of Byte; Offset: Int32; Count: Int32): Int32;
begin
  if not CanWrite then raise new NotSupportedException;
  exit Write(new ImmutableSpan<Byte>(Buffer, Offset, Count));
end;

end.