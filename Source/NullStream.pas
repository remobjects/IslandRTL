namespace RemObjects.Elements.System;

type
  NulStream = public class(Stream)
  protected

    method IsValid: Boolean; override;
    begin
      result := true;
    end;

  public
    constructor; empty;
    class property Instance: NulStream := new NulStream; lazy; readonly;

    property CanRead: Boolean read true; override;
    property CanSeek: Boolean read true; override;
    property CanWrite: Boolean read true; override;
    method Seek(Offset: Int64; Origin: SeekOrigin): Int64; override; empty;

    method &Read(aSpan: Span<Byte>): Int32; override;
    begin
      result := 0;
    end;

    method &Write(aSpan: ImmutableSpan<Byte>): Int32; override; empty;

    method ToArray: array of Byte;
    begin
      result := [];
    end;

    property Length: Int64 read 0; override;
    method SetLength(value: Int64); override; empty;
  end;

end.