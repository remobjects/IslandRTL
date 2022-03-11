namespace RemObjects.Elements.System;
{$IFNDEF NOFILES}
type
  Folder = public class(BaseFile)
  private
  protected
    method Validate; override;
    begin
      if not Exists then raise new Exception('Folder not exists:'+fFullName);
    end;
  public
    class property Separator: Char read {$IFDEF WINDOWS}'\'{$ELSEIF POSIX_LIGHT}'/'{$ELSE}{$ERROR Unsupported platform}{$ENDIF} ;

    method CreateFile(FileName: String; FailIfExists: Boolean := false): File;
    begin
      var newname := Path.Combine(FullName,FileName);
      if FileUtils.FileExists(newname) then raise new Exception('file exists');
      exit new File(FileName);
    end;

    method CreateSubfolder(SubfolderName: String; FailIfExists: Boolean := false): Folder;
    begin
      var newName:= Path.Combine(FullName,SubfolderName);
      exit Folder.CreateFolder(newName,FailIfExists);
    end;

    method Delete;override;
    begin
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.RemoveDirectoryW(FullName.ToFileName()));
      {$ELSEIF POSIX_LIGHT}
      CheckForIOError(rtl.rmdir(FullName.ToFileName()));
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    class method Delete(aFolder: String);
    begin
      new Folder(aFolder).Delete;
    end;

    method Exists: Boolean;override;
    begin
      exit FileUtils.FolderExists(fFullName);
    end;

    class method Exists(aFolder: String): Boolean;
    begin
      exit FileUtils.FolderExists(aFolder);
    end;

    method Rename(NewName: String): Folder;
    begin
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.MoveFileW(FullName.ToFileName(), NewName.ToFileName()));
      {$ELSEIF POSIX_LIGHT}
      CheckForIOError(rtl.rename(FullName.ToFileName(), NewName.ToFileName()));
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method GetFile(FileName: String): File;
    begin
      var newname := Path.Combine(FullName,FileName);
      if FileUtils.FileExists(newname) then
        exit new File(newname)
      else
        exit nil;
    end;

    method GetFiles: not nullable ImmutableList<File>;
    begin
      var lResult := new List<File> as not nullable;
      {$IFDEF WINDOWS}
      var find: rtl.WIN32_FIND_DATAW;
      var hFind  := rtl.FindFirstFileW((FullName + '\*').ToFileName(),@find);
      if hFind = rtl.INVALID_HANDLE_VALUE then
        exit lResult;
      repeat
        if FileUtils.IsFile(find.dwFileAttributes) then
          lResult.Add(new File(Path.Combine(FullName,String.FromPChar(@find.cFileName[0]))));
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX_LIGHT}
      // code from http://pubs.opengroup.org/onlinepubs/9699919799/ was used as an example
      var dfd: Int32 := rtl.open(FullName.ToFileName(), rtl.O_RDONLY);
      var d: ^rtl.DIR := rtl.fdopendir(dfd);
      if d = nil then begin
        exit lResult;
      end;
      try
      var dp: ^rtl.__struct_dirent := rtl.readdir(d);
      while (dp <> nil) do begin
        var fn := String.FromPAnsiChars(@dp^.d_name[0]);
        var ffd: Int32 := rtl.openat(dfd, dp^.d_name, rtl.O_RDONLY);
        try
          if ffd = -1 then continue;
          try
            var statbuf: rtl.__struct_stat;
            if rtl.fstat(ffd,@statbuf) <> 0 then continue;
            if FileUtils.IsFile(statbuf.st_mode) then lResult.Add(new File(Path.Combine(FullName,fn)));
          finally
            rtl.close(ffd);
          end;
        finally
          dp:= rtl.readdir(d);
        end;
      end;
      finally
        rtl.closedir(d);
      end;
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
      result := lResult;
    end;

    method GetSubfolders: not nullable ImmutableList<Folder>;
    begin
      var lResult := new List<Folder> as not nullable;;
      {$IFDEF WINDOWS}
      var find: rtl.WIN32_FIND_DATAW;
      var hFind  := rtl.FindFirstFileW((FullName + '\*').ToFileName(),@find);
      if hFind = rtl.INVALID_HANDLE_VALUE then
        exit lResult;
      repeat
        if FileUtils.IsFolder(find.dwFileAttributes) then begin
          var fn := String.FromPChar(@find.cFileName[0]);
          // skip `.` and `..`
          if (fn='.') or (fn='..') then continue;
          lResult.Add(new Folder(Path.Combine(FullName,fn)));
        end;
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX_LIGHT}
      // code from http://pubs.opengroup.org/onlinepubs/9699919799/ was used as an example
      var dfd: Int32 := rtl.open(FullName.ToFileName(), rtl.O_RDONLY);
      var d: ^rtl.DIR := rtl.fdopendir(dfd);
      if d = nil then
        exit lResult;
      try
      var dp: ^rtl.__struct_dirent := rtl.readdir(d);
      while (dp <> nil) do begin
        var fn := String.FromPAnsiChars(@dp^.d_name[0]);
        // skip `.` and `..`
        try
          if (fn='.') or (fn='..') then continue;
          var ffd: Int32 := rtl.openat(dfd, dp^.d_name, rtl.O_RDONLY);
          if ffd = -1 then continue;
          try
            var statbuf: rtl.__struct_stat;
            if rtl.fstat(ffd,@statbuf) <> 0 then continue;
            if FileUtils.IsFolder(statbuf.st_mode) then lResult.Add(new Folder(Path.Combine(FullName,fn)));
          finally
            rtl.close(ffd);
          end;
        finally
          dp:= rtl.readdir(d);
        end;
      end;
      finally
        rtl.closedir(d);
      end;
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
      result := lResult;
    end;

    class method CreateFolder(FolderName: String; FailIfExists: Boolean := false): Folder;
    begin
      if FileUtils.FolderExists(FolderName) then begin
        if FailIfExists then
          raise new Exception('folder is exists')
        else
          exit new Folder(FolderName);
      end;
      var lparent := Path.GetParentDirectory(FolderName);
      if not String.IsNullOrEmpty(lparent) then CreateFolder(lparent, false);
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.CreateDirectoryW(FolderName.ToFileName(), nil));
      {$ELSEIF POSIX_LIGHT}
      var old_mask := rtl.umask(0);
      try
        CheckForIOError(rtl.mkdir(FolderName.ToFileName(),493 {755 octal}));
      finally
        rtl.umask(old_mask);
      end;
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

  end;
{$ENDIF}
end.