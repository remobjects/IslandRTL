namespace RemObjects.Elements.System;

type
  Environment = public static class
  private
    class method GetUserName: String;
    begin
      exit GetEnvironmentVariable('USERNAME');
    end;

    class method GetOSName: String;
    begin
      {$IFDEF WINDOWS}
      exit 'Windows';
      {$ELSEIF POSIX}
      var str : rtl.__struct_utsname;
      if rtl.uname(@str) = 0 then exit String.FromPAnsiChars(str.sysname);
      CheckForLastError;
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    class method GetOSVersion: String;
    begin
      {$IFDEF WINDOWS}
      // from https://msdn.microsoft.com/en-us/library/ms724451%28v=VS.85%29.aspx
      // GetVersionEx may be altered or unavailable for releases after Windows 8.1. Instead, use the Version Helper functions
      // With the release of Windows 8.1, the behavior of the GetVersionEx API has changed in the value it will return for
      // the operating system version. The value returned by the GetVersionEx function now depends on how the application
      // is manifested.
      exit Registry.GetValue('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion','CurrentVersion','') as String;
      {$ELSEIF POSIX}
      var str : rtl.__struct_utsname;
      if rtl.uname(@str) = 0 then exit String.FromPAnsiChars(str.version);
      CheckForLastError;
      {$ELSE}{$ERROR}{$ENDIF}
    end;
  public
    property NewLine: String read {$IFDEF WINDOWS}#13#10{$ELSEIF POSIX}#10{$ELSE}{$ERROR}{$ENDIF};
    property UserName: String read GetUserName;
    property OSName: String read GetOSName;
    property OSVersion: String read GetOSVersion;
    property ApplicationContext: Object read write;

    method GetEnvironmentVariable(Name: String): String;
    begin
      {$IFDEF WINDOWS}
      var buf:= new array of Char(32768);
      var len := rtl.GetEnvironmentVariableW(Name.ToLPCWSTR,rtl.LPWSTR(@buf[0]),32767);
      if len = 0 then begin
        CheckForLastError;
      end;
      exit String.FromPChar(@buf[0],len);
      {$ELSEIF POSIX}
      var lName := Name.ToAnsiChars;
      exit String.FromPAnsiChars(rtl.getenv(@lName[0]));
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method CurrentDirectory: String;
    begin
      {$IFDEF WINDOWS}
      var len := rtl.MAX_PATH;
      var buf := new array of Char(len);
      var len1:= rtl.GetCurrentDirectoryW(len,@buf[0]);
      if len <> 0 then begin
        if len1 > len then begin
          var newbuf := new array of Char(len1+1);
          len1 := rtl.GetCurrentDirectoryW(len1+1,@newbuf[0]);
          exit String.FromPChar(@newbuf[0],len1);
        end
        else begin
          exit String.FromPChar(@buf[0],len1);
        end;
      end;
      CheckForLastError;
      {$ELSEIF ANDROID}
      var len := 1024;
      loop begin
        var buf := new AnsiChar[len];
        if rtl.getcwd(@buf[0], len) = nil then begin
          if rtl.errno = rtl.ERANGE then
            len := len  *2
          else
            exit nil;
        end else
          exit new String(@buf[0]);

      end;
      {$ELSEIF POSIX}
      var lCwd := rtl.get_current_dir_name();
      result := String.FromPAnsiChars(lCwd);
      rtl.free(lCwd);
      {$ELSE}{$ERROR}{$ENDIF}
    end;

    method UserHomeFolder: Folder;
    begin
      var fn: String;
      {$IFDEF WINDOWS}
      fn := Environment.GetEnvironmentVariable('USERPROFILE');
      {$ELSEIF POSIX}
      //var pw: ^rtl.__struct_passwd := rtl.getpwuid(rtl.getuid());
      fn := String.FromPAnsiChars(rtl.getpwuid(rtl.getuid())^.pw_dir);
      {$ELSE}{$ERROR}{$ENDIF}
      exit new Folder(fn);
    end;
  end;

end.