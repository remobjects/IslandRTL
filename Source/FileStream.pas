namespace RemObjects.Elements.System;

interface

type
  IOException = public class(Exception)
  end;

  FileMode = public enum(CreateNew, Create, Open, OpenOrCreate, Truncate);
  FileAccess = public enum(&Read, &Write, ReadWrite);
  FileShare = public enum(None, &Read, &Write, ReadWrite, Delete);

  FileStream = class(Stream)
  private
    {$IFDEF WINDOWS}
    fHandle: rtl.HANDLE := rtl.INVALID_HANDLE_VALUE;
    {$ELSEIF POSIX}
    fHandle: ^rtl._IO_FILE;
    {$ENDIF}
    fAccess: FileAccess;
  protected
    method IsValid: Boolean; override;
  public
    constructor(FileName: String; Mode: FileMode; Access: FileAccess; Share: FileShare := FileShare.Read);
    finalizer;
    method CanRead: Boolean; override;
    method CanSeek: Boolean; override;
    method CanWrite: Boolean; override;
    method Seek(Offset: Int64; Origin: SeekOrigin): Int64; override;
    method Flush;
    method Close; override;
    method &Read(const buf: ^Void; Count: UInt32): UInt32; override;
    method &Write(const buf: ^Void; Count: UInt32): UInt32;override;
    method SetLength(value: Int64); override;
    property Name: String; readonly;
  end;

implementation

constructor FileStream(FileName: String; Mode: FileMode; Access: FileAccess; Share: FileShare := FileShare.Read);
begin
  Name := FileName;
  fAccess := Access;
  {$IFDEF WINDOWS}
  var lName: rtl.LPCWSTR := fileName.ToFileName();
  var laccess: UInt32 :=  case Access of
                            FileAccess.Read: rtl.GENERIC_READ;
                            FileAccess.Write: rtl.GENERIC_WRITE;
                            FileAccess.ReadWrite: rtl.GENERIC_READ and rtl.GENERIC_WRITE;
                          end;

  var lmode: UInt32 :=    case Mode of
                            FileMode.CreateNew: rtl.CREATE_NEW;
                            FileMode.Create: rtl.CREATE_ALWAYS;
                            FileMode.Open: rtl.OPEN_EXISTING;
                            FileMode.OpenOrCreate: rtl.OPEN_ALWAYS;
                            FileMode.Truncate: rtl.TRUNCATE_EXISTING;
                          end;

  var lShare: Uint32 := case Share of
                          FileShare.None: 0;
                          FileShare.Read: rtl.FILE_SHARE_READ;
                          FileShare.Write: rtl.FILE_SHARE_WRITE;
                          FileShare.ReadWrite: rtl.FILE_SHARE_READ or rtl.FILE_SHARE_WRITE;
                          FileShare.Delete: rtl.FILE_SHARE_DELETE;
                        end;
  fHandle := rtl.CreateFileW(lname, lAccess, lShare, nil, lmode, rtl.FILE_ATTRIBUTE_NORMAL, nil);
  CheckForIOError(fHandle <> rtl.INVALID_HANDLE_VALUE);
  {$ELSEIF POSIX}
  var s: AnsiChar := AnsiChar(case Mode of
                                FileMode.CreateNew: 'w';
                                FileMode.Create: 'w';
                                FileMode.Open: 'r';
                                FileMode.OpenOrCreate: 'a';
                                FileMode.Truncate: 'w';
                              end);

  fHandle := rtl.fopen64(FileName.ToFileName(),@s);
  if fHandle = nil then CheckForIOError(1);
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

finalizer FileStream;
begin
  Close;
end;

method FileStream.CanRead: Boolean;
begin
  exit (fAccess <> FileAccess.Write) and IsValid;
end;

method FileStream.CanSeek: Boolean;
begin
  exit IsValid;
end;

method FileStream.CanWrite: Boolean;
begin
  exit (fAccess <> FileAccess.Read) and IsValid;
end;

method FileStream.IsValid: Boolean;
begin
  {$IFDEF WINDOWS}
  exit fHandle <> rtl.INVALID_HANDLE_VALUE;
  {$ELSEIF POSIX}
  exit fHandle <> nil;
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

method FileStream.Seek(Offset: Int64; Origin: SeekOrigin): Int64;
begin
  if not CanSeek then raise new NotSupportedException();
  {$IFDEF WINDOWS}
  var lorigin: Uint32 :=  case Origin of
                            SeekOrigin.Begin: rtl.FILE_BEGIN;
                            SeekOrigin.Current: rtl.FILE_CURRENT;
                            SeekOrigin.End:  rtl.FILE_END;
                          end;

  var offset_lo: rtl.Long := offset and $FFFFFFFF;
  var offset_hi: rtl.Long := offset shr 32;

  var lresult := rtl.SetFilePointer(fHandle,offset_lo,@offset_hi,lorigin);
  if (lresult = rtl.INVALID_SET_FILE_POINTER) then begin
    if rtl.GetLastError <> 0 then
      CheckForIOError(True);
  end;
  exit lresult + offset shl 32;
  {$ELSEIF POSIX}
  var lorigin: Int32 :=  case Origin of
                          SeekOrigin.Begin: rtl.SEEK_SET;
                          SeekOrigin.Current: rtl.SEEK_CUR;
                          SeekOrigin.End:  rtl.SEEK_END;
                        end;
  CheckForIOError(rtl.fseeko64(fHandle,Offset,lorigin));
  var pos: rtl._G_fpos64_t;
  CheckForIOError(rtl.fgetpos64(fHandle,@pos));
  exit pos.__pos;
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

method FileStream.Close;
begin
  if IsValid then begin
    if CanWrite then Flush;
  {$IFDEF WINDOWS}
    rtl.CloseHandle(fHandle);
    fHandle := rtl.INVALID_HANDLE_VALUE;
  {$ELSEIF POSIX}
    CheckForIOError(rtl.fclose(fHandle));
    fHandle := nil;
  {$ELSE}
    {$ERROR}
  {$ENDIF}
  end;
end;

method FileStream.SetLength(value: Int64);
begin
  if not (CanWrite and CanSeek) then raise new NotSupportedException;
  Seek(value, SeekOrigin.Begin);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.SetEndOfFile(fHandle));
  {$ELSEIF POSIX}
  {$HINT POSIX FileStream.SetLength. it may not work correctly, because _IO_FILE could be no updated }
  var fd := rtl.fileno(fHandle);
  CheckForIOError(rtl.ftruncate64(fd, value));
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

method FileStream.Read(const buf: ^Void; Count: UInt32): UInt32;
begin
  if not CanRead then raise new NotSupportedException;
  if buf = nil then raise new Exception("argument is null");
  if Count = 0 then exit 0;
  {$IFDEF WINDOWS}
  var res: rtl.DWORD;
  CheckForIOError(rtl.ReadFile(fHandle,buf,Count,@res,nil));
  exit res;
  {$ELSEIF POSIX}
  exit rtl.fread(buf, 1, Count, fHandle);
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

method FileStream.Write(const buf: ^Void; Count: UInt32): UInt32;
begin
  if not CanWrite then raise new NotSupportedException;
  if buf = nil then raise new Exception("argument is null");
  if Count = 0 then exit 0;
  {$IFDEF WINDOWS}
  var res: rtl.DWORD;
  CheckForIOError(rtl.WriteFile(fHandle,buf,Count,@res,nil));
  exit res;
  {$ELSEIF POSIX}
  exit rtl.fwrite(buf, 1, Count, fHandle);
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

method FileStream.Flush;
begin
  if not CanWrite then raise new NotSupportedException;
  {$IFDEF WINDOWS}
  rtl.FlushFileBuffers(fHandle);
  {$ELSEIF POSIX}
  var fd := rtl.fileno(fHandle);
  CheckForIOError(rtl.fsync(fd));
  {$ELSE}
    {$ERROR}
  {$ENDIF}
end;

end.
