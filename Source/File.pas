namespace RemObjects.Elements.System;

interface

type
  File = public class
  private
    fPath: not nullable String;
    method GetFileTime(aCreated: Boolean): DateTime;
  protected
  public
    constructor(aPath: not nullable String);
    begin
      fPath := aPath;
    end;

    method &Copy(NewFile: not nullable File);
    method &Copy(FullPathName: not nullable String): not nullable File;
    method &Copy(Destination: not nullable Folder; NewName: not nullable String): not nullable File;
    method Delete;
    method Exists: Boolean;
    method Move(NewFile: not nullable File);
    method Move(FullPathName: not nullable String): not nullable File;
    method Move(DestinationFolder: not nullable Folder; NewName: not nullable String): not nullable File;
    method Rename(NewName: not nullable String): not nullable File;

    class method Exists(FileName: not nullable String): Boolean;
    property FullPath: not nullable String read fPath;
    property Name: not nullable String read Path.GetFileName(fPath);
    property &Extension: not nullable String read Path.GetExtension(fPath);

    property DateCreated: DateTime read GetFileTime(true);
    property DateModified: DateTime read GetFileTime(false);

    method ReadBytes: array of Byte;
  end;

implementation

method File.Copy(NewFile: not nullable File);
begin
  if Newfile = nil then raise new Exception('NewFile is nil');
  if String.IsNullOrEmpty(Newfile.FullPath) then raise new Exception('NewFile.FullPath is nil or empty');
  &Copy(NewFile.FullPath);
end;

method File.Copy(FullPathName: not nullable String): not nullable File;
begin
  if String.IsNullOrEmpty(FullPathName) then raise new Exception('FullPathName should be specified');
  if not Exists then raise new Exception('File is not exist:'+FullPath);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.CopyFileW(FullPath.ToFileName(),FullPathName.ToFileName(),True));
  {$ELSEIF POSIX}
  var f2 := new FileStream(FullPathName,FileMode.CreateNew,FileAccess.Write,FileShare.None);
  var f1 := new FileStream(Self.FullPath,FileMode.Open,FileAccess.Read,FileShare.Read);
  try
    f1.CopyTo(f2);
  finally
    f1.Close;
    f2.Close;
  end;
  {$ELSE}{$ERROR}
  {$ENDIF}
  exit new File(FullPathName);
end;

method File.Copy(Destination: not nullable Folder; NewName: not nullable String): not nullable File;
begin
  if Destination = nil then raise new Exception('Destination is nil');
  if String.IsNullOrEmpty(NewName) then raise new Exception('NewName is empty');
  exit &Copy(Path.Combine(Destination.FullPath,NewName));
end;

method File.Delete;
begin
  if not Exists then raise new Exception('File is not found:'+FullPath);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.DeleteFileW(FullPath.ToFileName()));
  {$ELSEIF POSIX}
  CheckForIOError(rtl.remove(FullPath.ToFileName()));  
  {$ELSE}{$ERROR}
  {$ENDIF}
end;

method File.Exists: Boolean;
begin
  exit Exists(FullPath);
end;

method File.Move(NewFile: not nullable File);
begin
  if Newfile = nil then raise new Exception('NewFile is nil');
  if String.IsNullOrEmpty(Newfile.FullPath) then raise new Exception('NewFile.FullPath is nil or empty');
  Move(NewFile.FullPath);
end;

method File.Move(FullPathName: not nullable String): not nullable File;
begin
  if String.IsNullOrEmpty(FullPathName)then raise new Exception('FullPathName should be specified');
  if not Exists then raise new Exception('File is not exist:'+FullPath);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.MoveFileExW(Self.FullPath.ToFileName(),FullPathName.ToFileName(), rtl.MOVEFILE_REPLACE_EXISTING OR rtl.MOVEFILE_COPY_ALLOWED));
  {$ELSEIF POSIX}
  CheckForIOError(rtl.rename(Self.FullPath.ToFileName(),FullPathName.ToFileName()));
  {$ELSE}{$ERROR}
  {$ENDIF}
  fPath := FullPathName;
  exit self;
end;

method File.Move(DestinationFolder: not nullable Folder; NewName: not nullable String): not nullable File;
begin
  if DestinationFolder = nil then raise new Exception('DestinationFolder is nil');
  if String.IsNullOrEmpty(NewName) then raise new Exception('NewName is empty');
  exit Move(Path.Combine(DestinationFolder.FullPath, NewName));
end;

method File.Rename(NewName: not nullable String): not nullable File;
begin
  if String.IsNullOrEmpty(NewName)then raise new Exception('NewName should be specified');
  var newFullName: not nullable string := Path.Combine(Path.GetParentDirectory(FullPath), NewName);
  if not Exists then raise new Exception('File is not exist:'+FullPath);
  exit Move(newFullName);
end;

class method File.Exists(FileName: not nullable String): Boolean;
begin
  {$IFDEF WINDOWS}
  var attr := rtl.GetFileAttributesW(FileName.ToFileName());
  exit FileUtils.isFile(attr);
  {$ELSEIF POSIX}
  var sb: rtl.__struct_stat;
  CheckForIOError(rtl.stat(FileName.ToFileName(),@sb));
  exit FileUtils.isFile(sb.st_mode);
  {$ELSE}{$ERROR}
  {$ENDIF}
end;

method File.GetFileTime(aCreated: Boolean): DateTime;
begin
  if not Exists then raise new Exception('File is not found:'+FullPath);
  {$IFDEF WINDOWS}
  var handle := rtl.CreateFileW(FullPath.ToFileName(), rtl.GENERIC_READ, rtl.FILE_SHARE_READ, nil, rtl.OPEN_EXISTING, rtl.FILE_ATTRIBUTE_NORMAL, nil);
  CheckForIOError(handle <> rtl.INVALID_HANDLE_VALUE);
  try
    var created: rtl.FILETIME;
    var lastaccess: rtl.FILETIME;
    var lastwrite:rtl.FILETIME;
    CheckForIOError(rtl.GetFileTime(handle,@created,@lastaccess,@lastwrite));
    var ltime := if aCreated then created else lastwrite;
    exit DateTime.FromFileTime(ltime);
  finally
    rtl.CloseHandle(handle);
  end;
  {$ELSEIF POSIX}
  var sb: rtl.__struct_stat;
  CheckForIOError(rtl.stat(FullPath.ToFileName(),@sb));
  exit DateTime.FromUnixTime(sb.st_mtim); 
  {$ELSE}{$ERROR}
  {$ENDIF}
end;

method File.ReadBytes: array of Byte;
begin
  var stream := new MemoryStream;
  stream.LoadFromFile(FullPath);
  exit Stream.ToArray;
end;

end.
