namespace RemObjects.Elements.System;

{$IFNDEF NOFILES}
type
  BaseFile = abstract public class
  private
    method GetFileTime(aMode: TimeModifier): DateTime;
    begin
      Validate;
      {$IFDEF WINDOWS}
      var handle := GetHandle;
      try
        var created: rtl.FILETIME;
        var lastaccess: rtl.FILETIME;
        var lastwrite:rtl.FILETIME;
        CheckForIOError(rtl.GetFileTime(handle,@created,@lastaccess,@lastwrite));
        exit DateTime.FromFileTime(
                                   case aMode of
                                     TimeModifier.Accessed: lastaccess;
                                     TimeModifier.Created: created;
                                      else lastwrite;
                                   end);
      finally
        rtl.CloseHandle(handle);
      end;
      {$ELSEIF ANDROID}
      var str := FileUtils.Get__struct_stat(FullName);
      exit DateTime.FromUnixTimeUTC(
                                   case aMode of
                                     TimeModifier.Accessed: new rtl.__struct_timespec(tv_sec := str^.st_atime, tv_nsec := str^.st_atime_nsec);
                                     TimeModifier.Created: new rtl.__struct_timespec(tv_sec := str^.st_ctime, tv_nsec := str^.st_ctime_nsec);
                                     else new rtl.__struct_timespec(tv_sec := str^.st_mtime, tv_nsec := str^.st_mtime_nsec);
                                   end);
      {$ELSEIF DARWIN}
      var str := FileUtils.Get__struct_stat(FullName);
      exit DateTime.FromUnixTimeUTC(
                                   case aMode of
                                     TimeModifier.Accessed: str^.st_atimespec;
                                     TimeModifier.Created: str^.st_ctimespec;
                                     else str^.st_mtimespec
                                   end);
      {$ELSEIF POSIX_LIGHT}
      var str := FileUtils.Get__struct_stat(FullName);
      exit DateTime.FromUnixTimeUTC(
                                   case aMode of
                                     TimeModifier.Accessed: str^.st_atim;
                                     TimeModifier.Created: str^.st_ctim;
                                     else str^.st_mtim;
                                   end);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;
  protected
    fFullName: not nullable String;
    {$IFDEF WINDOWS}
    method GetHandle: rtl.HANDLE;inline;
    begin
      result := rtl.CreateFileW(FullName.ToFileName(), rtl.GENERIC_READ, rtl.FILE_SHARE_READ, nil, rtl.OPEN_EXISTING, rtl.FILE_ATTRIBUTE_NORMAL, nil);
      CheckForIOError(result <> rtl.INVALID_HANDLE_VALUE);
    end;
    {$ENDIF}
    method Validate; abstract;
  public
    constructor(aFullName: not nullable String);
    begin
      fFullName := aFullName;
    end;

    method Delete; abstract;
    method Exists: Boolean;abstract;

    property &Extension: not nullable String read Path.GetExtension(fFullName);
    property FullName: not nullable String read fFullName;
    property Name: not nullable String read Path.GetFileName(fFullName);
    property DateCreated: DateTime read GetFileTime(TimeModifier.Created);
    property DateModified: DateTime read GetFileTime(TimeModifier.Updated);
    property DateAccessed: DateTime read GetFileTime(TimeModifier.Accessed);
  end;
  {$ENDIF}
end.