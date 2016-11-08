namespace RemObjects.Elements.System;

type
  Folder = public class(BaseFile)
  private
  protected
    method Validate; override;
    begin
      if not Exists then raise new Exception('Folder not exists:'+fFullName);
    end;
  public
    class property Separator: Char read {$IFDEF WINDOWS}'\'{$ELSEIF POSIX}'/'{$ELSE}{$ERROR}{$ENDIF} ;

    method CreateFile(FileName: String; FailIfExists: Boolean := false): File;
    begin
      var newname := Path.Combine(FullName,FileName);
      if FileUtils.isFileExists(newname) then raise new Exception('file exists');
      exit new File(Filename);
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
      {$ELSEIF POSIX}
      CheckForIOError(rtl.rmdir(FullName.ToFileName()));
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method Exists: Boolean;override;
    begin
      exit FileUtils.isFolderExists(fFullName);
    end;

    method Rename(NewName: String): Folder;
    begin
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.MoveFileW(FullName.ToFileName(), NewName.ToFileName()));
      {$ELSEIF POSIX}
      CheckForIOError(rtl.rename(FullName.ToFileName(), NewName.ToFileName()));
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method GetFile(FileName: String): File;
    begin
      var newname := Path.Combine(FullName,FileName);
      if FileUtils.isFileExists(newname) then
        exit new File(newname)
      else
        exit nil;
    end;

    method GetFiles: not nullable List<File>;
    begin
      result := new List<File>;
      {$IFDEF WINDOWS}
      var find: rtl.WIN32_FIND_DATAW;
      var hFind  := rtl.FindFirstFileW((FullName + '\*').ToFileName(),@find);
      if hfind = rtl.INVALID_HANDLE_VALUE then exit;
      repeat
        if FileUtils.isFile(find.dwFileAttributes) then
          result.Add(new File(Path.Combine(FullName,String.FromPChar(@find.cFileName[0]))));
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX}
      // code from http://pubs.opengroup.org/onlinepubs/9699919799/ was used as an example
      var dfd: Int32 := rtl.open(FullName.ToFileName(), rtl.O_RDONLY);
      var d: ^rtl.DIR := rtl.fdopendir(dfd);     
      if d = nil then begin
        exit;
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
            if FileUtils.isFile(statbuf.st_mode) then result.Add(new File(Path.Combine(FullName,fn)));        
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
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method GetSubfolders: not nullable List<Folder>;
    begin
      result := new List<Folder>;
      {$IFDEF WINDOWS}
      var find: rtl.WIN32_FIND_DATAW;
      var hFind  := rtl.FindFirstFileW((FullName + '\*').ToFileName(),@find);
      if hfind = rtl.INVALID_HANDLE_VALUE then exit;
      repeat
        if FileUtils.isFolder(find.dwFileAttributes) then begin
          var fn := String.FromPChar(@find.cFileName[0]);
          // skip `.` and `..`
          if (fn='.') or (fn='..') then continue;
          result.Add(new Folder(Path.Combine(FullName,fn)));
        end;
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX}
      // code from http://pubs.opengroup.org/onlinepubs/9699919799/ was used as an example
      var dfd: Int32 := rtl.open(FullName.ToFileName(), rtl.O_RDONLY);
      var d: ^rtl.DIR := rtl.fdopendir(dfd);     
      if d = nil then exit;
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
            if FileUtils.isFolder(statbuf.st_mode) then result.Add(new Folder(Path.Combine(FullName,fn)));        
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
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method CreateFolder(FolderName: String; FailIfExists: Boolean := false): Folder;
    begin
      if FileUtils.isFolderExists(FolderName) then begin
        if FailIfExists then
          raise new Exception('folder is exists')
        else
          exit new Folder(FolderName);
      end;
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.CreateDirectoryW(FolderName.ToFileName(), nil));
      {$ELSEIF POSIX}
      var old_mask := rtl.umask(0);
      try
        CheckForIOError(rtl.mkdir(FolderName.ToFileName(),493 {755 octal}));
      finally
        rtl.umask(old_mask);
      end;
      {$ELSE}{$ERROR}{$ENDIF}
    end;

  end;

end.
