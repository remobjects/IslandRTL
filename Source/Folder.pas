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
      CheckForIOError(rtl.RemoveDirectoryW(fFullPath.ToFileName));
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.Delete}
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method Rename(NewName: String): Folder;
    begin
      {$IFDEF WINDOWS}
      CheckForIOError(rtl.MoveFileW(fFullPath.ToFileName, NewName.ToFileName));
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.Rename}
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
      var hFind  := rtl.FindFirstFileW((fFullPath + '\*').ToFileName,@find);
      if hfind = rtl.INVALID_HANDLE_VALUE then exit;
      repeat
        if find.dwFileAttributes and rtl.FILE_ATTRIBUTE_DIRECTORY <> rtl.FILE_ATTRIBUTE_DIRECTORY then
          result.Add(new File(Path.Combine(fFullPath,String.FromChars(@find.cFileName[0]))));
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.GetFiles}
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method GetSubfolders: not nullable List<Folder>;
    begin
      result := new List<Folder>;
      {$IFDEF WINDOWS}
      var find: rtl.WIN32_FIND_DATAW;
      var hFind  := rtl.FindFirstFileW((fFullPath + '\*').ToFileName,@find);
      if hfind = rtl.INVALID_HANDLE_VALUE then exit;
      repeat
        if find.dwFileAttributes and rtl.FILE_ATTRIBUTE_DIRECTORY = rtl.FILE_ATTRIBUTE_DIRECTORY then
          result.Add(new Folder(Path.Combine(fFullPath,String.FromChars(@find.cFileName[0]))));
      until (not rtl.FindNextFileW(hFind, @find));
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.GetSubFolders}
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
      CheckForIOError(rtl.CreateDirectoryW(FolderName.ToFileName, nil));
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.CreateFolder}
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method Exists(FolderName: String): Boolean;
    begin
      {$IFDEF WINDOWS}
      var attr := rtl.GetFileAttributesW(FolderName.ToFileName);
      if attr = rtl.INVALID_FILE_ATTRIBUTES then exit false;
      exit (attr and rtl.FILE_ATTRIBUTE_DIRECTORY) = rtl.FILE_ATTRIBUTE_DIRECTORY;
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.Exists}
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method UserHomeFolder: Folder;
    begin
      var fn: string;
      {$IFDEF WINDOWS}
      fn := Environment.GetEnvironmentVariable('USERPROFILE');
      {$ELSEIF POSIX}
      {$HINT Posix: implement Folder.UserHomeFolder}
      {$ELSE}{$ERROR}{$ENDIF}
      exit new Folder(fn);
    end;

    property &Extension: not nullable String read Path.GetExtension(FullPath);
  end;

end.
