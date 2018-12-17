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
      {$ELSEIF WEBASSEMBLY}
      exit 'WebAssembly';
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
      {$ELSEIF WEBASSEMBLY}
      var lHandle := WebAssemblyCalls.GetOSName;
      exit WebAssembly.GetStringFromHandle(lHandle, true);
      {$ELSE}{$ERROR}{$ENDIF}
    end;
  public
    property NewLine: String read {$IFDEF WINDOWS OR WEBASSEMBLY}#13#10{$ELSEIF POSIX}#10{$ELSE}{$ERROR}{$ENDIF};
    property UserName: String read GetUserName;
    property OSName: String read GetOSName;
    property OSVersion: String read GetOSVersion;
    property ApplicationContext: Object read write;

    method GetEnvironmentVariable(Name: String): String;
    begin
      if length(Name) > 0 then begin
        {$IFDEF WINDOWS}
        var buf:= new array of Char(32768);
        var len := rtl.GetEnvironmentVariableW(Name.ToLPCWSTR ,rtl.LPWSTR(@buf[0]), 32767);
        if len > 0 then
          result := String.FromPChar(@buf[0], len);
        {$ELSEIF WEBASSEMBLY}
        exit nil;
        {$ELSEIF POSIX}
        var lName := Name.ToAnsiChars;
        result := String.FromPAnsiChars(rtl.getenv(@lName[0]));
        {$ELSE}
        {$ERROR Unsupported platform}
        {$ENDIF}
      end;
    end;

    method SetEnvironmentVariable(Name: String; Value: String): Boolean;
    begin
      {$IFDEF WINDOWS}
        exit rtl.SetEnvironmentVariable(Name.ToLPCWSTR, Value.ToLPCWSTR);
      {$ELSEIF WEBASSEMBLY}
      exit false;
      {$ELSEIF POSIX}
      var lName := Name.ToAnsiChars(true);
      if Value ≠ nil then begin
        var lValue := Value.ToAnsiChars(true);
        exit rtl.setenv(@lName[0], @lValue[0], 1) = 0;
      end
      else
        exit rtl.unsetenv(@lName[0]) = 0;
      {$ENDIF}
    end;

    method GetEnvironmentVariables: Dictionary<String, String>;
    begin
      result := new Dictionary<String,String>();
      {$IFDEF WINDOWS}
      var lEnvp := rtl.GetEnvironmentStringsW;
      if lEnvp = nil then
        exit;
      var lStrings := lEnvp;
      while lStrings^ ≠ ''#0 do begin
        var lVar := lStrings;
        var lOneVar: String := '';
        while lVar^ ≠ #0 do begin
          lOneVar := lOneVar + lVar^;
          inc(lVar);
          inc(lStrings);
        end;
        if lOneVar ≠ '' then begin
          var lPos := lOneVar.LastIndexOf('=');
          if lPos >= 0 then begin
            var lKey := lOneVar.Substring(0, lPos);
            var lValue := lOneVar.Substring(lPos + 1);
            result.Add(lKey, lValue);
          end;
        end;
        inc(lStrings);
      end;
      rtl.FreeEnvironmentStrings(lEnvp);
      {$ELSEIF POSIX}
      var lStrings := ExternalCalls.envp;
      var i: Integer := 0;
      while lStrings[i] ≠ nil do begin
        var lVar := String.FromPAnsiChars(lStrings[i]);
        var lPos := lVar.LastIndexOf('=');
        if lPos >= 0 then begin
          var lKey := lVar.Substring(0, lPos);
          var lValue := lVar.Substring(lPos + 1);
          result.Add(lKey, lValue);
        end;
        inc(i);
      end;
      {$ENDIF}
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
      {$ELSEIF WEBASSEMBLY}
      exit nil;
      {$ELSEIF ANDROID or DARWIN}
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
    {$IFNDEF NOFILES}
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
    method TempFolder: Folder;
    begin
      var lString: String;
      {$IF WINDOWS}
      var lBuf := new Char[rtl.MAX_PATH + 1];
      var lLen := rtl.GetTempPath(rtl.MAX_PATH, @lBuf[0]);
      lString := if lLen <> 0 then new String(@lBuf[0], lLen) else '';
      {$ELSEIF POSIX AND NOT DARWIN}
      lString := 'TMPDIR';
      var lTmp := rtl.getenv(lString.ToAnsiChars);
      var lDir: String := '';
      if lTmp <> nil then
        lDir := RemObjects.Elements.System.String.FromPAnsiChars(lTmp);
      lString := if lDir <> '' then lDir else rtl.P_tmpdir;
      {$ELSEIF DARWIN}
      var lTemp := Foundation.NSTemporaryDirectory();
      lString := if lTemp = nil then '/tmp' else String(lTemp);
      {$ENDIF}
      result := new Folder(lString);
    end;
    {$endif}

    method ProcessorCount:Integer;
    begin
      {$IFDEF WINDOWS}
      var si: rtl.SYSTEM_INFO;
      rtl.GetSystemInfo(@si);
      exit si.dwNumberOfProcessors;
      {$ELSEIF POSIX}
      exit rtl.sysconf(rtl._SC_NPROCESSORS_ONLN);
      {$ENDIF}
    end;
  end;

end.