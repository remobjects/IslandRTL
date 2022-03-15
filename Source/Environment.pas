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
      {$ELSEIF FUCHSIA}
      exit 'Fuchsia';
      {$ELSEIF DARWIN}
        {$IF OSX OR UIKITFORMAC}
        exit "macOS";
        {$ELSEIF IOS}
        exit "iOS";
        {$ELSEIF WATCHOS}
        exit "watchOS";
        {$ELSEIF TVOS}
        exit "tvOS";
        {$ELSE}
          {$ERROR Unsupported Apple platform}
        {$ENDIF}
      {$ELSEIF ANDROID}
      exit 'Android';
      {$ELSEIF POSIX}
      var str : rtl.__struct_utsname;
      if rtl.uname(@str) = 0 then exit String.FromPAnsiChars(str.sysname);
      CheckForLastError;
      {$ELSEIF WEBASSEMBLY}
      exit 'WebAssembly';
      {$ELSE}
      {$ERROR Unsupported SubMode}
      {$ENDIF}
    end;

    class method GetSubMode: String;
    begin
      {$IFDEF WINDOWS}
      exit 'Windows';
      {$ELSEIF FUCHSIA}
      exit 'Fuchsia';
      {$ELSEIF DARWIN}
      exit 'Darwin';
      {$ELSEIF LINUX}
      exit 'Linux';
      {$ELSEIF DARWIN}
      exit 'Android';
      {$ELSEIF WEBASSEMBLY}
      exit 'WebAssembly';
      {$ELSE}
      {$ERROR Unsupported SubMode}
      {$ENDIF}
    end;

    class method GetBinaryArchitecture: String;
    begin
      {$IFDEF WINDOWS}
      result := {$IF i386}"i386"{$ELSEIF x86_64}"x86_64"{$ELSEIF ARM64}"arm64"{$ELSE}{$ERROR Unsupported achitecture}{$ENDIF};
      {$ELSEIF FUCHSIA}
      result := {$IF __x86_64__}"x64"{$ELSEIF __aarch64__}"arm64"{$ELSE}{$ERROR Unsupported achitecture}{$ENDIF};
      {$ELSEIF ANDROID}
      result := {$IF arm64_v8a}"arm64-v8a"{$ELSEIF armeabi}"armeabi"{$ELSEIF armeabi_v7a}"armeabi-v7a"{$ELSEIF i386}"x86"{$ELSEIF __x86_64__}"x86_64"{$ELSE}{$ERROR Unsupported achitecture}{$ENDIF}
      {$ELSEIF LINUX}
      result := {$IF x86_64}"x86_64"{$ELSEIF aarch64}"arm64"{$ELSEIF armv7}"armv7"{$ELSEIF armv6}"armv6"{$ELSE}{$ERROR Unsupported achitecture}{$ENDIF};
      {$ELSEIF WEBASSEMBLY}
      result := "wasm32";
      {$ELSEIF DARWIN}
        {$IF OSX OR UIKITFORMAC OR SIMULATOR}
        result := {$IF __arm64__}"arm64"{$ELSE}"x86_64"{$ENDIF};
        {$ELSEIF IOS}
        result := "arm64";
        {$ELSEIF WATCHOS}
        result := {$IF __arm64_32__}"arm64_32"{$ELSE}"armv7k"{$ENDIF};
        {$ELSEIF TVOS}
        result := "arm64";
        {$ELSE}
          {$ERROR Unsupported Apple platform}
        {$ENDIF}
      {$ELSE}
      {$ERROR Unsupported SubMode}
      {$ENDIF}
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
      {$ELSEIF POSIX_LIGHT}
      var str : rtl.__struct_utsname;
      if rtl.uname(@str) = 0 then exit String.FromPAnsiChars(str.version);
      CheckForLastError;
      {$ELSEIF WEBASSEMBLY}
      var lHandle := WebAssemblyCalls.GetOSName;
      exit WebAssembly.GetStringFromHandle(lHandle, true);
      {$ELSE}
      {$ERROR Unsupported SubMode}
      {$ENDIF}
    end;

  public
    property NewLine: String read {$IFDEF WINDOWS}#13#10{$ELSEIF POSIX_LIGHT OR WEBASSEMBLY}#10{$ELSE}{$ERROR Unsupported platform}{$ENDIF};
    property UserName: String read GetUserName;
    property OSName: String read GetOSName;
    property OSVersion: String read GetOSVersion;

    property SubMode: String read GetSubMode;
    property BinaryArchitecture: String read GetBinaryArchitecture;
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
        {$ELSEIF POSIX_LIGHT}
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
      {$ELSEIF POSIX_LIGHT}
      var lName := Name.ToAnsiChars(true);
      if Value ≠ nil then begin
        var lValue := Value.ToAnsiChars(true);
        exit rtl.setenv(@lName[0], @lValue[0], 1) = 0;
      end
      else
        exit rtl.unsetenv(@lName[0]) = 0;
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method GetEnvironmentVariables: ImmutableDictionary<String, String>;
    begin
      var lResult := new Dictionary<String,String>();
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
            lResult.Add(lKey, lValue);
          end;
        end;
        inc(lStrings);
      end;
      rtl.FreeEnvironmentStrings(lEnvp);
      {$ELSEIF POSIX_LIGHT}
      var lStrings := ExternalCalls.envp;
      var i: Integer := 0;
      while lStrings[i] ≠ nil do begin
        var lVar := String.FromPAnsiChars(lStrings[i]);
        var lPos := lVar.LastIndexOf('=');
        if lPos >= 0 then begin
          var lKey := lVar.Substring(0, lPos);
          var lValue := lVar.Substring(lPos + 1);
          lResult.Add(lKey, lValue);
        end;
        inc(i);
      end;
      {$ELSEIF WEBASSEMBLY}
      // return empty, for compatibility
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
      result := lResult;
    end;

    {$IFNDEF NOFILES}
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
      {$ELSEIF POSIX_LIGHT}
      var lCwd := rtl.get_current_dir_name();
      result := String.FromPAnsiChars(lCwd);
      rtl.free(lCwd);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    method UserHomeFolder: Folder;
    begin
      var fn: String;
      {$IFDEF WINDOWS}
      fn := Environment.GetEnvironmentVariable('USERPROFILE');
      {$ELSEIF POSIX_LIGHT}
      //var pw: ^rtl.__struct_passwd := rtl.getpwuid(rtl.getuid());
      fn := String.FromPAnsiChars(rtl.getpwuid(rtl.getuid())^.pw_dir);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
      exit new Folder(fn);
    end;

    method TempFolder: Folder;
    begin
      var lString: String;
      {$IF WINDOWS}
      var lBuf := new Char[rtl.MAX_PATH + 1];
      var lLen := rtl.GetTempPath(rtl.MAX_PATH, @lBuf[0]);
      lString := if lLen <> 0 then new String(@lBuf[0], lLen) else '';
      {$ELSEIF DARWIN}
      var lTemp := Foundation.NSTemporaryDirectory();
      lString := if lTemp = nil then '/tmp' else String(lTemp);
      {$ELSEIF POSIX_LIGHT}
      lString := 'TMPDIR';
      var lTmp := rtl.getenv(lString.ToAnsiChars);
      var lDir: String := '';
      if lTmp <> nil then
        lDir := RemObjects.Elements.System.String.FromPAnsiChars(lTmp);
      lString := if lDir <> '' then lDir else rtl.P_tmpdir;
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
      result := new Folder(lString);
    end;
    {$ENDIF}

    method ProcessorCount:Integer;
    begin
      {$IFDEF WINDOWS}
      var si: rtl.SYSTEM_INFO;
      rtl.GetSystemInfo(@si);
      exit si.dwNumberOfProcessors;
      {$ELSEIF POSIX_LIGHT}
      exit rtl.sysconf(rtl._SC_NPROCESSORS_ONLN);
      {$ELSEIF WEBASSEMBLY}
      exit 0;
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    {$IF WEBASSEMBLY}[Warning("Environment.Exit is not supported on WebAssembly")]{$ENDIF}
    method &Exit(aCode: Integer);
    begin
      {$IFDEF WINDOWS}
      ExternalCalls.exit(aCode);
      {$ELSEIF POSIX_LIGHT}
      rtl.exit(aCode);
      {$ELSEIF WEBASSEMBLY}
      // no-op
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    {$IF WEBASSEMBLY}[Warning("Environment.GetCommandLine is not supported on WebAssembly")]{$ENDIF}
    method GetCommandLine: String;
    begin
      {$IFDEF WINDOWS}
      var buf := rtl.GetCommandLine;
      if ExternalCalls.wcslen(buf) > 0 then
        result := String.FromPChar(@buf[0])
      else
        result := '';
      {$ELSEIF POSIX_LIGHT}
      result := '';
      for i: Integer := 0 to ExternalCalls.nargs - 1 do
        if i = 0 then
          result := String.FromPAnsiChars(ExternalCalls.args[i])
        else
          result := result + ' ' + String.FromPAnsiChars(ExternalCalls.args[i])
      {$ELSEIF WEBASSEMBLY}
      exit "";
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;

    {$IF WEBASSEMBLY}[Warning("Environment.GetCommandLineArgs is not supported on WebAssembly")]{$ENDIF}
    method GetCommandLineArgs: array of String;
    begin
      {$IFDEF WINDOWS}
      var lCount: Int32;
      var lArgs := rtl.CommandLineToArgvW(rtl.GetCommandLineW(), @lCount);
      result := new String[lCount - 1];
      for i: Integer := 1 to lCount - 1 do
        result[i - 1] := String.FromPChar(lArgs[i]);
      {$ELSEIF POSIX_LIGHT}
      result := new String[ExternalCalls.nargs - 1];
      for i: Integer := 1 to ExternalCalls.nargs - 1 do
        result[i - 1] := String.FromPAnsiChars(ExternalCalls.args[i]);
      {$ELSEIF WEBASSEMBLY}
      // return empty, for compatibility
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;
  end;

end.