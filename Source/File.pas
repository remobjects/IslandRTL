namespace RemObjects.Elements.System;

interface

type
  File = public class(BaseFile)
  private
    method GetLength: Int64;
  protected
    method Validate; override;
  public
    method &Copy(NewFile: not nullable File);
    method &Copy(FullPathName: not nullable String): not nullable File;
    method &Copy(Destination: not nullable Folder; NewName: not nullable String): not nullable File;
    method Delete; override;
    method Exists: Boolean; override;
    method Move(NewFile: not nullable File);
    method Move(FullPathName: not nullable String): not nullable File;
    method Move(DestinationFolder: not nullable Folder; NewName: not nullable String): not nullable File;
    method Rename(NewName: not nullable String): not nullable File;

    property Length: Int64 read GetLength;
    method ReadBytes: array of Byte;
  end;

implementation

method File.Copy(NewFile: not nullable File);
begin
  if NewFile = nil then raise new Exception('NewFile is nil');
  if String.IsNullOrEmpty(NewFile.FullName) then raise new Exception('NewFile.FullName is nil or empty');
  &Copy(NewFile.FullName);
end;

method File.Copy(FullPathName: not nullable String): not nullable File;
begin
  if String.IsNullOrEmpty(FullPathName) then raise new Exception('FullPathName should be specified');
  if not Exists then raise new Exception('File is not exist:'+FullName);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.CopyFileW(FullName.ToFileName(),FullPathName.ToFileName(),True));
  {$ELSEIF POSIX}
  var f2 := new FileStream(FullPathName,FileMode.CreateNew,FileAccess.Write,FileShare.None);
  var f1 := new FileStream(Self.FullName,FileMode.Open,FileAccess.Read,FileShare.Read);
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
  exit &Copy(Path.Combine(Destination.FullName,NewName));
end;

method File.Delete;
begin
  if not Exists then raise new Exception('File is not found:'+FullName);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.DeleteFileW(FullName.ToFileName()));
  {$ELSEIF POSIX}
  CheckForIOError(rtl.remove(FullName.ToFileName()));
  {$ELSE}{$ERROR}
  {$ENDIF}
end;

method File.Move(NewFile: not nullable File);
begin
  if NewFile = nil then raise new Exception('NewFile is nil');
  if String.IsNullOrEmpty(NewFile.FullName) then raise new Exception('NewFile.FullName is nil or empty');
  Move(NewFile.FullName);
end;

method File.Move(FullPathName: not nullable String): not nullable File;
begin
  if String.IsNullOrEmpty(FullPathName)then raise new Exception('FullPathName should be specified');
  if not Exists then raise new Exception('File is not exist:'+FullName);
  {$IFDEF WINDOWS}
  CheckForIOError(rtl.MoveFileExW(Self.FullName.ToFileName(),FullPathName.ToFileName(), rtl.MOVEFILE_REPLACE_EXISTING OR rtl.MOVEFILE_COPY_ALLOWED));
  {$ELSEIF POSIX}
  CheckForIOError(rtl.rename(Self.FullName.ToFileName(),FullPathName.ToFileName()));
  {$ELSE}{$ERROR}
  {$ENDIF}
  fFullName := FullPathName;
  exit self;
end;

method File.Move(DestinationFolder: not nullable Folder; NewName: not nullable String): not nullable File;
begin
  if DestinationFolder = nil then raise new Exception('DestinationFolder is nil');
  if String.IsNullOrEmpty(NewName) then raise new Exception('NewName is empty');
  exit Move(Path.Combine(DestinationFolder.FullName, NewName));
end;

method File.Rename(NewName: not nullable String): not nullable File;
begin
  if String.IsNullOrEmpty(NewName)then raise new Exception('NewName should be specified');
  var newFullName: not nullable String := Path.Combine(Path.GetParentDirectory(FullName), NewName);
  if not Exists then raise new Exception('File is not exist:'+FullName);
  exit Move(newFullName);
end;

method File.ReadBytes: array of Byte;
begin
  var lStream := new MemoryStream;
  lStream.LoadFromFile(FullName);
  exit lStream.ToArray;
end;

method File.GetLength: Int64;
begin
  Validate;
  {$IFDEF WINDOWS}
  var handle := GetHandle;
  try
    var l: rtl.LARGE_INTEGER;
    CheckForIOError(rtl.GetFileSizeEx(handle,@l));
    exit l.QuadPart;
  finally
    rtl.CloseHandle(handle);
  end;
  {$ELSEIF POSIX}
  exit FileUtils.Get__struct_stat(FullName)^.st_size;
  {$ELSE}{$ERROR}{$ENDIF}
end;

method File.Exists: Boolean;
begin
  exit FileUtils.FileExists(fFullName)
end;

method File.Validate;
begin
  if not Exists then raise new Exception('File not exists:'+fFullName);
end;

end.