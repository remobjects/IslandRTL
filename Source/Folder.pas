namespace RemObjects.Elements.System;

type
  Folder = public class
  private
    fFullPath: not nullable String;
  protected
  public
    constructor (aFullPath: not nullable String);
    begin
      fFullPath := aFullPath;
    end;

    class property Separator: Char read {$IFDEF WINDOWS}'\'{$ELSEIF POSIX}'/'{$ELSE}{$ERROR}{$ENDIF} ;
    property FullPath: not nullable String read fFullPath;
    property Name: not nullable String read Path.GetFileName(fFullPath);


    method CreateFile(FileName: String; FailIfExists: Boolean := false): File;
    begin
      var newname := Path.Combine(fFullPath,FileName);
      if File.Exists(newname) then raise new Exception('file exists');
      exit new File(Filename);
    end;

    method CreateSubfolder(SubfolderName: String; FailIfExists: Boolean := false): Folder;
    begin
      var newName:= Path.Combine(fFullPath,SubfolderName);
      exit Folder.CreateFolder(newName,FailIfExists);
    end;

    method Delete;
    begin
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.RemoveDirectoryW(fFullPath.ToFileName()));
      {$ELSEIF POSIX}
      CheckForIOError(rtl.rmdir(fFullPath.ToFileName()));
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method Rename(NewName: String): Folder;
    begin
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.MoveFileW(fFullPath.ToFileName(), NewName.ToFileName()));
      {$ELSEIF POSIX}
      CheckForIOError(rtl.rename(fFullPath.ToFileName(), NewName.ToFileName()));
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method GetFile(FileName: String): File;
    begin
      var newname := Path.Combine(fFullPath,FileName);
      if File.Exists(newname) then
        exit new File(newname)
      else
        exit nil;
    end;

    method GetFiles: not nullable List<File>;
    begin
      result := new List<File>;
      {$IFDEF WINDOWS}
      var find: rtl.WIN32_FIND_DATAW;
      var hFind  := rtl.FindFirstFileW((fFullPath + '\*').ToFileName(),@find);
      if hfind = rtl.INVALID_HANDLE_VALUE then exit;
      repeat
        if FileUtils.isFile(find.dwFileAttributes) then
          result.Add(new File(Path.Combine(fFullPath,String.FromPChar(@find.cFileName[0]))));
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX}
      // code from http://pubs.opengroup.org/onlinepubs/9699919799/ was used as an example
      var dfd: Int32 := rtl.open(fFullPath.ToFileName(), rtl.O_RDONLY);
      var d: ^rtl.DIR := rtl.fdopendir(dfd);     
      if d = nil then exit;
      try
      var dp: ^rtl.__struct_dirent := rtl.readdir(d);
      while (dp <> nil) do begin
        var fn := String.FromPAnsiChars(@dp^.d_name[0]);
        var ffd: Int32 := rtl.openat(dfd, dp^.d_name, rtl.O_RDONLY);
        if ffd = -1 then continue;
        try
          var statbuf: rtl.__struct_stat;
          if rtl.fstat(ffd,@statbuf) <> 0 then continue;
          if FileUtils.isFile(statbuf.st_mode) then result.Add(new File(Path.Combine(fFullPath,fn)));        
        finally
          rtl.close(ffd);
        end;
        dp:= rtl.readdir(d);
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
      var hFind  := rtl.FindFirstFileW((fFullPath + '\*').ToFileName(),@find);
      if hfind = rtl.INVALID_HANDLE_VALUE then exit;
      repeat
        if FileUtils.isFolder(find.dwFileAttributes) then begin
          var fn := String.FromPChar(@find.cFileName[0]);
          // skip `.` and `..`
          if (fn='.') or (fn='..') then continue;
          result.Add(new Folder(Path.Combine(fFullPath,fn)));
        end;
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX}
      // code from http://pubs.opengroup.org/onlinepubs/9699919799/ was used as an example
      var dfd: Int32 := rtl.open(fFullPath.ToFileName(), rtl.O_RDONLY);
      var d: ^rtl.DIR := rtl.fdopendir(dfd);     
      if d = nil then exit;
      try
      var dp: ^rtl.__struct_dirent := rtl.readdir(d);
      while (dp <> nil) do begin
        var fn := String.FromPAnsiChars(@dp^.d_name[0]);
        // skip `.` and `..`
        if (fn='.') or (fn='..') then continue;
        var ffd: Int32 := rtl.openat(dfd, dp^.d_name, rtl.O_RDONLY);
        if ffd = -1 then continue;
        try
          var statbuf: rtl.__struct_stat;
          if rtl.fstat(ffd,@statbuf) <> 0 then continue;
          if FileUtils.isFolder(statbuf.st_mode) then result.Add(new Folder(Path.Combine(fFullPath,fn)));        
        finally
          rtl.close(ffd);
        end;
      end;
      finally
        rtl.closedir(d);
      end;
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method CreateFolder(FolderName: String; FailIfExists: Boolean := false): Folder;
    begin
      if Exists(FolderName) then begin
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

    class method Exists(FolderName: String): Boolean;
    begin
      {$IFDEF WINDOWS}
      var attr := rtl.GetFileAttributesW(FolderName.ToFileName());
      exit FileUtils.isFolder(attr);
      {$ELSEIF POSIX}
      var sb: rtl.__struct_stat;
      CheckForIOError(rtl.stat(FolderName.ToFileName(),@sb));
      exit FileUtils.isFolder(sb.st_mode);
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method UserHomeFolder: Folder;
    begin
      var fn: string;
      {$IFDEF WINDOWS}
      fn := Environment.GetEnvironmentVariable('USERPROFILE');
      {$ELSEIF POSIX}
      var pw: ^rtl.__struct_passwd := rtl.getpwuid(rtl.getuid());
      fn := String.FromPAnsiChars(pw^.pw_dir);
      {$ELSE}{$ERROR}{$ENDIF}
      exit new Folder(fn);
    end;

    property &Extension: not nullable String read Path.GetExtension(FullPath);
  end;

end.
