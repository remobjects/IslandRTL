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
    method &Read(const buf: ^Void; Count: Int32): Int32; override;
    method &Write(const buf: ^Void; Count: Int32): Int32; override;
    method ToArray: array of Byte;
    method WriteTo(Destination: Stream);
    method LoadFromFile(FileName: String);
    method SaveToFile(FileName: String);

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
  if value < fLength then raise new Exception('Capacity cannot be less than the current length of the stream.');
  var temp := new array of Byte(value);
  if fLength >0 then
    {$IFDEF WINDOWS}ExternalCalls.{$ELSE}rtl.{$ENDIF}memcpy(@temp[0], @fbuf[0], fLength);
  fbuf := temp;
  fCapacity := value;
end;

method MemoryStream.SetLength(value: Int64);
begin
  var curpos := Position;
  fLength := value;
  CheckCapacity(value);
  if curpos > fLength then Seek(0, SeekOrigin.End);
end;

method MemoryStream.Seek(Offset: Int64; Origin: SeekOrigin): Int64;
begin
  case Origin of
    SeekOrigin.Begin: fPosition := Offset;
    SeekOrigin.Current: fPosition :=fPosition + Offset;
    SeekOrigin.End: fPosition := fLength + Offset;
  end;
  exit fPosition;
end;

method MemoryStream.Read(buf: ^Void; Count: Int32): Int32;
begin
  if not CanRead then raise new NotSupportedException;
  if buf = nil then raise new Exception("argument is null");
  if Count = 0 then exit 0;
  var lres := fLength - fPosition;
  if lres <= 0 then exit 0;
  if lres > Count then lres := Count;
  {$IFDEF WINDOWS}ExternalCalls.{$ELSE}rtl.{$ENDIF}memcpy(buf, @fbuf[fPosition], lres);
  fPosition := fPosition + lres;
  exit lres;
end;

method MemoryStream.Write(buf: ^Void; Count: Int32): Int32;
begin
  if not CanWrite then raise new NotSupportedException;
  if buf = nil then raise new Exception("argument is null");
  if Count = 0 then exit 0;
  CheckCapacity(fPosition+Count);
  {$IFDEF WINDOWS}ExternalCalls.{$ELSE}rtl.{$ENDIF}memcpy(@fbuf[fPosition], buf, Count);
  fPosition := fPosition+Count;
  if fPosition > fLength then fLength := fPosition;
  exit Count;
end;

method MemoryStream.ToArray: array of Byte;
begin
  result := new array of Byte(fLength);
  {$IFDEF WINDOWS}ExternalCalls.{$ELSE}rtl.{$ENDIF}memcpy(@result[0], @fbuf[0], fLength);
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
  Destination.Write(@fbuf[0],fLength);
end;

method MemoryStream.LoadFromFile(FileName: String);
begin
  var fs := new FileStream(FileName, FileMode.Open,FileAccess.Read, FileShare.Read);
  SetLength(0);
  self.Capacity := fs.Length;
  fs.Position := 0;
  fLength := fs.Read(@fbuf[0], fs.Length);
  fs.Close;
end;

method MemoryStream.SaveToFile(FileName: String);
begin
  var fs := new FileStream(FileName, FileMode.Create,FileAccess.Write, FileShare.None);
  SetLength(fLength);
  fs.Position := 0;
  fs.Write(@fbuf[0],fLength);
  fs.Close;
end;

end.