namespace RemObjects.Elements.System;

interface

type
  FILEHANDLE = GCHandle;
  BeginThreadFunc = public procedure(aVal: ^Void);

  VersionResourceAttribute = public class(Attribute)
  public
    property Copyright: String;
    property Description: String;
    property FileVersion: String;
    property CompanyName: String;
    property ProductName: String;
    property LegalTrademarks: String;
    property Title: String;
    property Version: String;
  end;

  atexitfunc = public procedure();

  atexitrec = record
  public
    func: atexitfunc;
    next: ^atexitrec;
  end;

  ExternalCalls = public static class
  private

    class var atexitlist: ^atexitrec; assembly;
    class var processheap: rtl.HANDLE;
    class var fModuleHandle: rtl.HMODULE; assembly;
    class var fMainThreadID: rtl.DWORD; assembly;
    class method getModuleHandle: rtl.HMODULE;
    begin
      if fModuleHandle = nil then fModuleHandle := rtl.GetModuleHandleW(nil);
      exit fModuleHandle;
    end;

  public

    [SymbolName('_beginthread')]
    class method _beginthread( // NATIVE CODE
    start: BeginThreadFunc;
    stack: Integer;
    arg: ^Void): rtl.HANDLE;
    begin
      var lStart: Object := new Tuple<BeginThreadFunc, ^Void>(start, arg);
      exit rtl.CreateThread(nil, stack, method (lpThreadParameter: rtl.LPVOID): rtl.DWORD
        begin
          BoehmGC.RegisterThread();
          var lVal := Tuple<BeginThreadFunc, ^Void>(InternalCalls.Cast<Object>(lpThreadParameter));
          lVal.Item1(lVal.Item2);
        end, InternalCalls.Cast(lStart), 0, nil);
    end;

    {$IFDEF I386}
    [SymbolName(#1'__allmul'), CallingConvention(CallingConvention.Stdcall)]
    class method __allmul(aVal: rtl.ULONGLONG; aVal2: rtl.ULONGLONG): rtl.LONGLONG;
    begin
      exit aVal * aVal2;
    end;

    [SymbolName(#1'__allshl'), CallingConvention(CallingConvention.Stdcall), InlineAsmAttribute("
    pushl %ecx
    pushl %edx
    pushl %eax
    calll org__allshl
    ret", '', false, false)]
    class method _allshl(aVal: rtl.LONGLONG; aVal2: rtl.LONG): rtl.LONGLONG; external;

    [SymbolName(#1'__allshr'), CallingConvention(CallingConvention.Stdcall), InlineAsmAttribute("
    pushl %ecx
    pushl %edx
    pushl %eax
    calll org__allshr
    ret", '', false, false)]
    class method _allshr(aVal: rtl.LONGLONG; aVal2: rtl.LONG): rtl.LONGLONG; external;

    [SymbolName(#1'__aullshr'), CallingConvention(CallingConvention.Stdcall), InlineAsmAttribute("
    pushl %ecx
    pushl %edx
    pushl %eax
    calll org__aullshr
    ret", '', false, false)]
    class method _aullshr(aVal: rtl.ULONGLONG; aVal2: rtl.LONG): rtl.ULONGLONG; external;

    [SymbolName(#1'org__allshl'), CallingConvention(CallingConvention.Stdcall)]
    class method org_allshl(aVal: rtl.LONGLONG; aVal2: rtl.LONG): rtl.LONGLONG;
    begin
      exit aVal shl Byte(aVal2);
    end;

    [SymbolName(#1'org__allshr'), CallingConvention(CallingConvention.Stdcall)]
    class method org_allshr(aVal: rtl.LONGLONG; aVal2: rtl.LONG): rtl.LONGLONG;
    begin
      exit aVal shr Byte(aVal2);
    end;

    [SymbolName(#1'org__aullshr'), CallingConvention(CallingConvention.Stdcall)]
    class method org_aullshr(aVal: rtl.ULONGLONG; aVal2: rtl.LONG): rtl.ULONGLONG;
    begin
      exit aVal shr Byte(aVal2);
    end;
    {$ENDIF}

    [SymbolName('strstr')]
    class method strstr(str1, str2: ^AnsiChar): ^AnsiChar;
    begin
      if str1 = nil then exit nil;
      while str2 <> nil do begin
        if str2^ = str1^ then begin
          var lTmp1 := str2;
          var lTmp2 := str1;
          loop begin
            if lTmp1^ = #0 then exit str1;
            if lTmp2^ = #0 then exit nil;
            if lTmp2^ <> lTmp1^ then break;
            inc(lTmp1);
            inc(lTmp2);
          end;
        end;
        str1 := str1 + 1;
      end;
      exit nil;
    end;

    [SymbolName('__GSHandlerCheck')]
    class method _GSHandlerCheck;
    begin
      raise new NotSupportedException;
    end;

    [SymbolName('fclose')]
    class method fclose(afn: FILEHANDLE);
    begin
      afn.Dispose();
    end;

    [SymbolName('__stdio_common_vfprintf')]
    class method ___stdio_common_vfprintf(
    _Options: UInt64;
    _Stream: ^File;
    _Format: ^AnsiChar;
    _Locale: ^Void;
    _ArgList: ^Void): Integer;
    begin
      // empty.
    end;

    [SymbolName('__security_check_cookie'), Inlineasm('ret', '', false, false)]
    class method __security_check_cookie(_StackCookie: UIntPtr);  external;

    [SymbolName('__stdio_common_vsnprintf_s')]
    class method __stdio_common_vsnprintf_s( _Options: UInt64; _Buffer: ^AnsiChar; _BufferCount: IntPtr; _MaxCount: IntPtr; _Format: ^AnsiChar; _Locale: ^Void; _ArgList: ^Void): Integer;
    begin
      memcpy(_Buffer, _Format, Math.Min(ExternalCalls.strlen(_Format), Integer(_BufferCount)));
    end;

    [SymbolName('__acrt_iob_func')]
    class method __acrt_iob_func(a: Integer): FILEHANDLE;
    begin
      case a of
        0: exit GCHandle.Allocate(new FileStream(rtl.GetStdHandle(rtl.STD_INPUT_HANDLE), FileAccess.Read));
        1: exit GCHandle.Allocate(new FileStream(rtl.GetStdHandle(rtl.STD_OUTPUT_HANDLE), FileAccess.Write));
        2: exit GCHandle.Allocate(new FileStream(rtl.GetStdHandle(rtl.STD_ERROR_HANDLE), FileAccess.Write));
      end;
      exit &default(FILEHANDLE);
    end;

    [SymbolName('_time64')]
    class method _time64(aVal: ^Int64): Int64;
    begin
      result := (DateTime.UtcNow.Ticks - DateTime.Now.UnixDateOffset) / DateTime.TicksPerSecond;
      if aVal <> nil then
        aVal^ := result;
    end;

    [SymbolName('_gmtime64_s')]
    class method _gmtime64_s(tmdest: ^__struct_tm; aVal: ^Int64): Integer;
    begin
      var lValue := aVal^;
      var DT := new DateTime(lValue * DateTime.TicksPerSecond + DateTime.UnixDateOffset);

      tmdest^.tm_sec := DT.Second;
      tmdest^.tm_min := DT.Minute;
      tmdest^.tm_hour := DT.Hour;
      tmdest^.tm_mday := DT.Day;
      tmdest^.tm_wday := DT.DayOfWeek;
      tmdest^.tm_mon := DT.Month - 1;
      tmdest^.tm_year := DT.Year - 1900;
      var lD := (DT.Date.Ticks - new DateTime(DT.Year, 1,1).Ticks);
      tmdest^.tm_yday := lD / DateTime.TicksPerDay;
    end;

    [SymbolName('ferror')]
    class method ferror: Integer; empty;

    [SymbolName('fopen')]
    class method fopen(afn: ^AnsiChar; aMode: ^AnsiChar): FILEHANDLE;
    begin
      var lMode := FileMode.Open;
      var lAcc := FileAccess.ReadWrite;
      var lModeStr := String.FromPAnsiChars(aMode);
      if lModeStr.Contains('w') then begin
        lMode := FileMode.OpenOrCreate;
      end else begin
        lMode := FileMode.Open;
        lAcc := FileAccess.Read;
      end;

      try
        var lFN := new FileStream(String.FromPAnsiChars(afn), lMode, lAcc);
        if lModeStr.Contains('a') then
          lFN.Seek(0, SeekOrigin.End);
        exit GCHandle.Allocate(lFN);
      except
        exit default(GCHandle);
      end;
    end;

    [SymbolName('fwrite')]
    class method fwrite(aPtr: ^Byte; aSize: IntPtr; aCount: IntPtr; aFS: GCHandle): IntPtr;
    begin
      exit FileStream(aFS.Target).Write(aPtr, aSize * aCount);
    end;


    [SymbolName('fread')]
    class method fread(aPtr: ^Byte; aSize: IntPtr; aCount: IntPtr; aFS: GCHandle): IntPtr;
    begin
      exit FileStream(aFS.Target).Read(aPtr, aSize * aCount);
    end;

    [SymbolName('fgets')]
    class method fgets(aStr: ^Byte; aNum: Integer; aFS: GCHandle): ^Byte;
    begin
      dec(aNum);
      var lRes := FileStream(aFS.Target).Read(aStr, aNum);
      if lRes = 0 then exit nil;

      aStr[lRes] := 0;

      exit aStr;
    end;

    [SymbolName('fseek')]
    class method fseek(aFS: GCHandle; aOffset: IntPtr; aOrg: Integer): IntPtr;
    begin
      exit FileStream(aFS.Target).Seek(aOffset, if aOrg = rtl.SEEK_SET then SeekOrigin.Begin else if aOrg = rtl.SEEK_END then SeekOrigin.End else SeekOrigin.Current);
    end;


    [SymbolName('ftell')]
    class method ftell(aFS: GCHandle): IntPtr;
    begin
      exit FileStream(aFS.Target).Position;
    end;

    class var fRan: Random;

    [SymbolName('rand')]
    class method rand: Integer;
    begin
      if fRan = nil then fRan := new Random();
      exit fRan.Random();
    end;

    [SymbolName(#1'@__security_check_cookie@4'), CallingConvention(CallingConvention.Stdcall), Inlineasm('ret', '', false, false)]
    class method __security_check_cookie(v: Integer); external;

    [SymbolName('__report_rangecheckfailure')]
    method __report_rangecheckfailure();
    begin
      raise new Exception('Range check failure!');
    end;

    [SymbolName('calloc')]
    class method calloc(anum, asize: IntPtr): ^Void;
    begin
      result := malloc(anum * asize);
      memset(result, 0, anum * asize);
    end;

    [SymbolName('getenv')]
    class method getenv(name: ^AnsiChar): ^AnsiChar; empty;
    [SymbolName('atoi')]
    class method atoi(a: ^AnsiChar): Integer; empty; // used by GC but since getenv never returns a value, this will never hit
    [SymbolName('atol')]
    class method atol(a: ^AnsiChar): Integer; empty; // used by GC but since getenv never returns a value, this will never hit
    [SymbolName('strtoul')]
    class method strtoul(a: ^AnsiChar; endptr: ^^AnsiChar; abase: Integer): Cardinal; empty; // used by GC but since getenv never returns a value, this will never hit
    [SymbolName('_strtoui64')]
    class method _strtoui64(a: ^AnsiChar; endptr: ^^AnsiChar; abase: Integer): UInt64; empty; // used by GC but since getenv never returns a value, this will never hit
    [SymbolName('_errno')]
    class var _errno: Integer;
    [SymbolName('_fltused'), Used]
    class var _fltused: Integer;
    [SymbolName('_beginthreadex')]
    class method _beginthreadex( security: ^Void; stack_size: Int32; proc: rtl.PTHREAD_START_ROUTINE; arglist: ^Void; initflag: Cardinal; thrdaddr: rtl.LPDWORD): rtl.HANDLE;
    [SymbolName('_endthreadex')]
    class method _endthreadex(aval: Cardinal);
    [SymbolName('atexit')]
    class method atexit(func: atexitfunc);
    [SymbolName('exit')]
    class method &exit(ex: Integer);
    [SymbolName('memcpy')]
    class method memcpy(destination, source: ^Void; aNum: NativeInt): ^Void;
    [SymbolName('memmove'), Used]
    class method memmove(destination, source: ^Void; aNum: NativeInt): ^Void;
    [SymbolName('memset')]
    class method memset(ptr: ^Void; value: Integer; aNum: NativeInt): ^Void;
    [SymbolName('strlen')]
    class method strlen(c: ^AnsiChar): Integer;
    [SymbolName('wcslen')]
    class method wcslen(c: ^Char): Integer;

    {$IFDEF _WIN64}
    [SymbolName('__chkstk'), Naked, DisableOptimizations, DisableInliningAttribute, Used]
    {$ELSE}
    [SymbolName('_chkstk'), Naked, DisableOptimizations, DisableInliningAttribute, Used]
    {$ENDIF}
    class method _chkstk;

    // WARNING, malloc/free are NOT good functions to use, but libgc needs these to get started
    [SymbolName('malloc')]
    class method malloc(size: NativeInt): ^Void;
    [SymbolName('realloc')]
    class method realloc(ptr: ^Void; size: NativeInt): ^Void;
    [SymbolName('free')]
    class method free(v: ^Void);
    [SymbolName('_msize')]
    class method _msize(ptr: ^Void): NativeInt;
    //{$IFNDEF _WIN64}
    [SymbolName('_vsnprintf')]
    class method noop__vsnprintf; empty;
    //{$ELSE}
    [SymbolName('__stdio_common_vsprintf')]
    class method noop__vsnprintf2; empty;
    //{$ENDIF}
    // These call debugbreak; they're helpers for compiling stuff with DEBUG on
    [SymbolName('_wassert')]
    class method _wassert;
    [SymbolName('_CrtDbgReport')]
    class method _CrtDbgReport;

    class method highbit(i: UInt64): Integer;

    [SymbolName(#1'__aullrem'), CallingConvention(CallingConvention.Stdcall), Used]
    class method uint64remainder(dividend, divisor: UInt64): UInt64;
    [SymbolName(#1'__allrem'), CallingConvention(CallingConvention.Stdcall), Used]
    class method int64remainder(dividend, divisor: Int64): Int64;
    [SymbolName(#1'__aulldiv'), CallingConvention(CallingConvention.Stdcall), Used]
    class method uint64divide(dividend, divisor: UInt64): UInt64;
    [SymbolName(#1'__alldiv'), CallingConvention(CallingConvention.Stdcall), Used]
    class method int64divide(dividend, divisor: Int64): Int64;
    {$IFDEF ARM64}
    [SymbolName('__C_specific_handler')]
    class method __C_specific_handler; empty;
    [SymbolName('__stack_base__')]
    class var __stack_base__: IntPtr := 0;
    [SymbolName('_setjmpex'), Naked, DisableOptimizations, DisableInliningAttribute]
    class method setjmpex(var buf: rtl.jmp_buf);
    begin
      var p: rtl.CONTEXT;
      rtl.RtlCaptureContext(@p);
      memcpy(@buf, @p, Math.Min(sizeOf(rtl.CONTEXT), sizeOf(rtl.jmp_buf)));
    end;
    {$ELSEIF _WIN64}
    [SymbolName('_setjmp'), Naked, DisableOptimizations, DisableInliningAttribute]
    class method setjmp(var buf: rtl.jmp_buf);
    {$ELSEIF i386}
    [SymbolName('_setjmp3'), Naked, DisableOptimizations, DisableInliningAttribute]
    class method setjmp3(var buf: rtl.jmp_buf; var ctx: ^Void);
    {$ENDIF}

    {$IFDEF _WIN64}
    [SymbolName('_elements_exception_handler'), DisableInliningAttribute] // 32bits windows only!!
    method ExceptionHandler(arec: ^rtl.EXCEPTION_RECORD; EstablisherFrame: UInt64; context: rtl.PCONTEXT; dispatcher: rtl.PDISPATCHER_CONTEXT ): Integer;
    {$ELSEIF i386}
    [SymbolName('_elements_exception_handler'), CallingConvention(CallingConvention.Stdcall), DisableInliningAttribute] // 32bits windows only!!
    method ExceptionHandler([InReg]inmsvcinfo: ^MSVCExceptionInfo; arec: ^rtl.EXCEPTION_RECORD; aOrgregFrame: ^ElementsRegistrationFrame; context: rtl.PCONTEXT; dispatcher: ^Void): Integer;
    {$ELSE}
    {$ERROR Unsupported Architecture}
    {$ENDIF}

    [SymbolName('ElementsRaiseException'), DllExport]
    class method RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);

    class property ModuleHandle: rtl.HMODULE read fModuleHandle;
    class property MainThreadID: rtl.DWORD read fMainThreadID;

    const ElementsExceptionCode = $E0428819;

    [SymbolName('fmaxf')]
    class method fmaxf(x, y: Single): Single;
    begin
      exit if x > y then x else y;
    end;

    [SymbolName('strtod')]
    class method strtod(str: ^AnsiChar; aEndPtr: ^^AnsiChar): Double;
    begin
      Convert.TryParseDouble(String.FromPAnsiChars(str), out result, false);
    end;

    [SymbolName('strtol')]
    class method strtol(str: ^AnsiChar; aEndPtr: ^^AnsiChar; aBase: Integer): Integer;
    begin
      var lStr := String.FromPAnsiChars(str);
      if lStr.StartsWith('0x') then begin
        Convert.TryHexStringToUInt64(lStr.Substring(2), out var lVal);
        exit lVal;
      end else begin
        Convert.TryParseInt64(lStr, out var lVal, false);
        exit lVal;
      end;
    end;

    [SymbolName('toupper')]
    class method ToUpper(c: AnsiChar): AnsiChar;
    begin
      if c in ['a'..'z'] then
        c := AnsiChar((Integer(c) - Integer('a')) + Integer('A'));
      exit c;
    end;

    [SymbolName('tolower')]
    class method ToLower(c: AnsiChar): AnsiChar;
    begin
      if c in ['A'..'Z'] then
        c := AnsiChar((Integer(c) - Integer('A')) + Integer('a'));
      exit c;
    end;

    [SymbolName('frexp')]
    class method frexp(x: Double; e: ^Integer): Double;
    begin
      var lVal := ^Int64(@x)^;
      var exp := (lVal shr 52) and ($7ff);
      if exp = 0 then begin
        if x = 0 then begin
          e^ := 0;
          exit x;
        end;
        x := frexp(1.8446744073709552E+19 * x, e);
        e := e - 64;
        exit x;
      end;
      e^ := exp - $3fe;
      lVal := (lVal and $800fffffffffffff) or $3fe0000000000000;
      exit ^Double(@lVal)^;
    end;


    [SymbolName('fminf')]
    class method fminf(x, y: Single): Single;
    begin
      exit if x < y then x else y;
    end;

    [SymbolName('fmax')]
    class method fmax(x, y: Double): Double;
    begin
      exit if x > y then x else y;
    end;

    [SymbolName('fmin')]
    class method fmin(x, y: Double): Double;
    begin
      exit if x < y then x else y;
    end;

    [SymbolName('roundf')]
    class method roundf(x: Single): Single;
    begin
      exit Math.Round(x);
    end;

    [SymbolName('strcmp')]
    class method strcmp(a, b: ^AnsiChar): Integer;
    begin
      if (a = nil) and (b = nil) then exit 0;
      if (a = nil) or (b = nil) then exit if a = nil then 1 else -1;
      loop begin
        if a^ > b^ then exit 1;
        if a^ < b^ then exit -1;
        if a^ = #0 then exit 0;
        inc(a);
        inc(b);
      end;
    end;

    [SymbolName('strncmp')]
    class method strncmp(a, b: ^AnsiChar; num: NativeInt): Integer;
    begin
      if (a = nil) and (b = nil) then exit 0;
      if (a = nil) or (b = nil) then exit if a = nil then 1 else -1;
      if num = 0 then exit 0;
      loop begin
        if a^ > b^ then exit 1;
        if a^ < b^ then exit -1;
        if a^ = #0 then exit 0;
        inc(a);
        inc(b);
        dec(num);
        if num = 0 then exit 0;
      end;
    end;

    [SymbolName('memcmp')]
    class method memcmp(a, b: ^Byte; num: NativeInt): Integer;
    begin
      if (a = nil) and (b = nil) then exit 0;
      if (a = nil) or (b = nil) then exit if a = nil then 1 else -1;
      if num = 0 then exit 0;
      loop begin
        if a^ > b^ then exit 1;
        if a^ < b^ then exit -1;
        inc(a);
        inc(b);
        dec(num);
        if num = 0 then exit 0;
      end;
    end;

    [SymbolName('_localtime64_s')]
    class method _localtime64_s(var x: __struct_tm; aTime: Int64);
    begin
      var dt := new DateTime(DateTime.UnixDateOffset + (aTime * DateTime.TicksPerSecond));
      x.tm_sec := dt.Second;
      x.tm_min := dt.Minute;
      x.tm_hour := dt.Hour;
      x.tm_mday := dt.Day;
      x.tm_mon := dt.Month - 1;
      x.tm_year := dt.Year - 1900;
      x.tm_wday := Integer(dt.DayOfWeek);
      x.tm_yday := (dt.Ticks - new DateTime(dt.Year, 1, 1).Ticks) / DateTime.TicksPerDay +1;
    end;

    class var fRandom: Random; volatile;
    class var fRandomLock: Integer;

    [SymbolName('rand_s')]
    class method rand_s(out x: UInt32): Integer;
    begin
      Utilities.SpinLockEnter(var fRandomLock);
      var lRandom := fRandom;
      if lRandom = nil then begin
        lRandom := new Random;
        fRandom := lRandom;
      end;
      x := lRandom.Random();
      Utilities.SpinLockExit(var fRandomLock);
      exit 0;
    end;

    [SymbolName('system')]
    class method system(aVal: ^AnsiChar): Integer;
    begin
      var lCmd := String.FromPAnsiChars(aVal).Trim;
      var lArgs := new List<String>;
      while length(lCmd) > 0 do begin
        if lCmd[0] ='"' then begin
          var n := lCmd.IndexOf('"');
          lArgs.Add(lCmd.Substring(1, -1));
          lCmd := lCmd.Substring(n+1).Trim;
        end else begin
          var n := lCmd.IndexOf(' ');
          lArgs.Add(lCmd.Substring(0, n));
          lCmd := lCmd.Substring(n+1).Trim;
        end;
      end;
      lCmd := lArgs.FirstOrDefault;
      if lArgs.Count > 0 then lArgs.RemoveAt(0);
      exit Process.Run(lCmd, lArgs, out var lStdOut, out var lStdErr);
    end;
    [SymbolName('_getcwd')]
    class method _getcwd(aDest: ^AnsiChar; aLen: Integer): ^AnsiChar;
    begin
      var lDir := Environment.CurrentDirectory.ToAnsiChars;
      if length(lDir) +1 > aLen then exit nil;
      strncpy(aDest, @lDir[0], lDir.Length + 1);
      exit aDest;
    end;

    [SymbolName('_chdir')]
    class method _chdir(aDest: ^AnsiChar): Integer;
    begin
      exit Integer(rtl.SetCurrentDirectoryA(String.FromPAnsiChars(aDest)));
    end;

    [SymbolName('strpbrk')]
    class method strpbrk(str1, str2: ^AnsiChar): ^AnsiChar;
    begin
      while str1^ <> #0 do begin
        var lTest := str2;
        while lTest^ <> #0 do begin
          if lTest^ = str1^ then exit str1;
          inc(lTest);
        end;
      end;
      exit nil;
    end;

    [SymbolName('strncpy')]
    class method strncpy(aDest, aSrc: ^AnsiChar; n: Integer): ^AnsiChar;
    begin
      while (n > 0) and (aSrc^ <> #0) do begin
        aDest^ := aSrc^;
        aDest := aDest + 1;
        aSrc := aSrc + 1;
        dec(n);
      end;
      while n > 0 do begin
        aDest^ := #0;
        aDest  := aDest + 1;
        dec(n);
      end;
      result := aDest;
    end;

    [SymbolName('strchr')]
    class method strchr(str: ^AnsiChar; c: Integer): ^AnsiChar;
    begin
      while str^ <> #0 do begin
        if Integer(str^) = c then exit str;
      end;
      exit nil;
    end;

    [SymbolName('strrchr')]
    class method strrchr(str: ^AnsiChar; c: Integer): ^AnsiChar;
    begin
      var lHit: ^AnsiChar := nil;
      while str^ <> #0 do begin
        if Integer(str^) = c then lHit := str;
      end;
      exit lHit;
    end;

    [SymbolName('srand')]
    class method srand(val: UInt32);
    begin
      fRandom.Set(val);
    end;

    [SymbolName('_byteswap_ulong')]
    class method _byteswap_ulong(i: UInt32): UInt32;
    begin
      exit (i shl 24) or (i shr 24) or ((i shr 8) and $FF00) or ((i shl 8) and $FF0000);
    end;

    [SymbolName('_byteswap_ushort')]
    class method _byteswap_ushort(i: UInt16): UInt16;
    begin
      exit (i shl 8) or (i shr 8);
    end;

  end;

  {$G+}
  {$HIDE H7}{$HIDE H6}
  __struct_tm = public record
  public
    tm_sec,
    tm_min,
    tm_hour,
    tm_mday,
    tm_mon,
    tm_year,
    tm_wday,
    tm_yday,
    tm_isdst: Integer;
  end;
  {$SHOW H7}{$SHOW H6}

  DllMainType = public method (aModule: rtl.HMODULE; aReason: rtl.DWORD; aReserved: ^Void): Boolean;

  ThreadRec = public class
  public
    property Call: rtl.PTHREAD_START_ROUTINE;
    property Arg: ^Void;
  end;

  ElementsRegistrationFrame = public record
  public
    ESP: ^Void;
    Next: ^ElementsRegistrationFrame;
    Handler: ^Void;
    TryLevel: Cardinal;
  end;

  MSVCExceptionInfo = public record
  public
    MagicNumber: UInt32; // 429065506
    NumUnwindMap: Int32;
    UnwindMap: {$IFDEF _WIN64}Int32{$ELSE}^MSVCUnwindMap{$ENDIF}; // array
    NumTryBlocks: Int32;
    TryBlockMap: {$IFDEF _WIN64}Int32{$ELSE}^MSVCTryMap{$ENDIF};
    IPMapEntries: UInt32;
    IPMapEntry: {$IFDEF _WIN64}Int32{$ELSE}^MSVCIpToSate{$ENDIF};
    {$IFDEF win64}
    UnwindHelp: UInt32;
    ESTypeList: ^Void;
    EHFlags: Int32;
    {$ENDIF}
    // From LLVM
    //   uint32_t           IPMapEntries; // always 0 for x86
    //   IPToStateMapEntry *IPToStateMap; // always 0 for x86
    //   uint32_t           UnwindHelp;   // non-x86 only
    //   ESTypeList        *ESTypeList;
    //   int32_t            EHFlags;
    // }
    // EHFlags & 1 -> Synchronous exceptions only, no async exceptions.
    // EHFlags & 2 -> ???
    // EHFlags & 4 -> The function is noexcept(true), unwinding can't continue.
  end;

  MSVCIpToSate = public record
  public
    IP: UInt32;
    State: Integer;
  end;

  MSVCUnwindMap = public record
  public
    ToState: Int32;
    Cleanup: {$IFDEF _WIN64}Int32{$ELSE}MSVCCleanup{$ENDIF};
  end;

  MSVCTryMap = public record
  public
    TryLow,
    TryHigh,
    CatchHigh,
    NumCatches: Int32;
    HandlerType: {$IFDEF _WIN64}Int32{$ELSE}^MSVCHandlerType{$ENDIF};
  end;

  ElementsExceptionType = public record
  public
    &Type: ^Void;
    &Filter: ElementsFilter;
  end;

  ElementsFilter = public function(FP: ^Void): Boolean;

  MSVCHandlerType = public record
  public
    Adjectives: Int32; // from the exception record
    &Type: {$IFDEF _WIN64}Int32{$ELSE}^ElementsExceptionType{$ENDIF};
    CatchObjOffset: Int32;
    Handler: {$IFDEF _WIN64}Int32{$ELSE}MSVCCleanup{$ENDIF};
    {$IFDEF _WIN64}ParentFrameOffset: Int32;{$ENDIF}
  end;

  MSVCCleanup = public procedure();

  method HResultCheck(aVal: rtl.HRESULT); public;
  begin
    if aVal = rtl.S_OK then exit;
    raise new ArgumentException('HResult error: '+aVal);
  end;

  [SymbolName('__elements_entry_point'), &Weak]
  method UserEntryPoint(args: array of String): Integer; external;

  [SymbolName('__elements_dll_main'), &Weak]
  method DllMain(aModule: rtl.HMODULE; aReason: rtl.DWORD; aReserved: ^Void): Boolean; external;

// This is needed by anything msvc compiled; it's the offset in fs for the tls array
var
  [Used, StaticallyInitializedField]
  _dllmain: DllMainType := @DllMain; public;
  [SymbolName('_tls_index'), Used, StaticallyInitializedField]
  _tls_index: Cardinal; public;
  [SectionName('.tls'), SymbolName('_tls_start'), StaticallyInitializedField]
  _tls_start: NativeInt := 0; public;
  [SectionName('.tls$ZZZ'), SymbolName('_tls_end'), StaticallyInitializedField]
  _tls_end: NativeInt := 0; public;

  [SectionName(".CRT$XLA"), SymbolName('__xl_a'), StaticallyInitializedField]
  __xl_a: rtl.PIMAGE_TLS_CALLBACK := nil; public;
  [SectionName(".CRT$XLEL"), SymbolName('__elements_tls_callback'), Used(), StaticallyInitializedField]
  __elements_tls_callback: rtl.PIMAGE_TLS_CALLBACK := @elements_tls_callback; public;
  [SectionName(".CRT$XLZ"), SymbolName('__xl_z'), StaticallyInitializedField]
  __xl_z: rtl.PIMAGE_TLS_CALLBACK := nil; public;

  [SectionName('.rdata$T'), SymbolName('_tls_used'), Used, StaticallyInitializedField]
  _tls_used: {$IFDEF _WIN64}rtl.IMAGE_TLS_DIRECTORY64{$ELSE}rtl.IMAGE_TLS_DIRECTORY {$ENDIF}:=
    new {$IFDEF _WIN64}rtl.IMAGE_TLS_DIRECTORY64{$ELSE}rtl.IMAGE_TLS_DIRECTORY {$ENDIF}(
    StartAddressOfRawData := NativeUInt(@_tls_start),
    EndAddressOfRawData := NativeUInt (@_tls_end),
    AddressOfIndex := NativeUInt(@_tls_index),
    AddressOfCallBacks := NativeInt(^NativeInt(@__xl_a)+1 ),
    SizeOfZeroFill := 0
    ); readonly; public;

  {$IFDEF _WIN64}
  [Used, SymbolName('_load_config_used'), StaticallyInitializedField]
  _load_config_used: rtl.IMAGE_LOAD_CONFIG_DIRECTORY :=
    new rtl.IMAGE_LOAD_CONFIG_DIRECTORY(
    Size := sizeOf(rtl.IMAGE_LOAD_CONFIG_DIRECTORY),
    SecurityCookie := UIntPtr(^UIntPtr(@__security_cookie)),
    //GuardCFCheckFunctionPointer := UIntPtr(^UIntPtr(@__guard_check_icall_fptr)),
    //GuardCFDispatchFunctionPointer := UIntPtr(^UIntPtr(@__guard_dispatch_icall_fptr)),
    GuardCFFunctionTable := UIntPtr(^UIntPtr(@__guard_fids_table)),
    GuardCFFunctionCount := UIntPtr(^UIntPtr(@__guard_fids_count)),
    //GuardFlags := UIntPtr(^UIntPtr(@__guard_flags)),
    GuardAddressTakenIatEntryTable := UIntPtr(^UIntPtr(@__guard_iat_table)),
    GuardAddressTakenIatEntryCount := UIntPtr(^UIntPtr(@__guard_iat_count)),
    GuardLongJumpTargetTable := UIntPtr(^UIntPtr(@__guard_longjmp_table)),
    GuardLongJumpTargetCount := UIntPtr(^UIntPtr(@__guard_longjmp_count))
    ); readonly; public;
  {$ELSEIF i386}
  [Used, SymbolName('_load_config_used'), StaticallyInitializedField]
  _load_config_used: rtl.IMAGE_LOAD_CONFIG_DIRECTORY :=
    new rtl.IMAGE_LOAD_CONFIG_DIRECTORY(
    Size := sizeOf(rtl.IMAGE_LOAD_CONFIG_DIRECTORY),
    SecurityCookie := UIntPtr(^UIntPtr(@__security_cookie)),
    SEHandlerTable := UIntPtr(^UIntPtr(@__safe_se_handler_table)),
    SEHandlerCount := UIntPtr(^UIntPtr(@__safe_se_handler_count)),
    //GuardCFCheckFunctionPointer := UIntPtr(^UIntPtr(@__guard_check_icall_fptr)),
    GuardCFDispatchFunctionPointer := 0, // amd64: __guard_dispatch_icall_fptr
    GuardCFFunctionTable := UIntPtr(^UIntPtr(@__guard_fids_table)),
    GuardCFFunctionCount := UIntPtr(^UIntPtr(@__guard_fids_count)),
    //GuardFlags := UIntPtr(^UIntPtr(@__guard_flags)),
    GuardAddressTakenIatEntryTable := UIntPtr(^UIntPtr(@__guard_iat_table)),
    GuardAddressTakenIatEntryCount := UIntPtr(^UIntPtr(@__guard_iat_count)),
    GuardLongJumpTargetTable := UIntPtr(^UIntPtr(@__guard_longjmp_table)),
    GuardLongJumpTargetCount := UIntPtr(^UIntPtr(@__guard_longjmp_count))
    ); readonly; public;
  {$ELSE}
    {.$ERROR Unsupported Architecture}
  {$ENDIF}

  [SymbolName('__security_cookie'), StaticallyInitializedField] var __security_cookie: Integer := $12345678;
  //[SymbolName('__guard_check_icall_fptr')] var __guard_check_icall_fptr: Integer; external;
  {$IFDEF _WIN64}
  //[SymbolName('__guard_dispatch_icall_fptr')] var __guard_dispatch_icall_fptr: Integer; external;
  {$ELSE}
  [SymbolName('__safe_se_handler_table'), StaticallyInitializedField] var __safe_se_handler_table: Integer; external;
  [SymbolName('__safe_se_handler_count'), StaticallyInitializedField] var __safe_se_handler_count: Integer; external;
  {$ENDIF}

  [SymbolName('__guard_fids_table')] var __guard_fids_table: Integer; external;
  [SymbolName('__guard_fids_count')] var __guard_fids_count: Integer; external;
  //[SymbolName('__guard_flags')] var __guard_flags: Integer; external;
  [SymbolName('__guard_iat_table')] var __guard_iat_table: Integer; external;
  [SymbolName('__guard_iat_count')] var __guard_iat_count: Integer; external;
  [SymbolName('__guard_longjmp_table')] var __guard_longjmp_table: Integer; external;
  [SymbolName('__guard_longjmp_count')] var __guard_longjmp_count: Integer; external;
  [Used]var ModuleIsLib: Boolean := false;

[SymbolName('__elements_tls_callback_method'), Used, CallingConvention(CallingConvention.Stdcall)]
method elements_tls_callback(aHandle: ^Void; aReason: rtl.DWORD; aReserved: ^Void); public;
[SymbolName('main')]
method main: Integer;

[SymbolName('mainCRTStartup')]
method mainCRTStartup: Integer;

[SymbolName('WinMainCRTStartup')]
method WinMainCRTStartup: Integer;

[SymbolName('_DllMainCRTStartup'), CallingConvention(CallingConvention.Stdcall), DisableOptimizations, DisableInlining]
method DllMainCRTStartup(aModule: rtl.HMODULE; aReason: rtl.DWORD; aReserved: ^Void): Boolean;

method ElementsThreadHelper(aParam: ^Void): rtl.DWORD;

method CheckForIOError(value: Boolean);
method CheckForLastError(aMessage: String := '');

method malloc(size: NativeInt): ^Void; inline;
begin
  exit ExternalCalls.malloc(size);
end;

method realloc(ptr: ^Void; size: NativeInt): ^Void;inline;
begin
  exit ExternalCalls.realloc(ptr, size);
end;

method free(v: ^Void);inline;
begin
  ExternalCalls.free(v);
end;

implementation

method CheckForIOError(value: Boolean);
begin
  if value then Exit;
  CheckForLastError('');
end;

method CheckForLastError(aMessage: String := '');
begin
  var code := rtl.GetLastError;
  if code <> 0 then begin
    var mes := (if aMessage <> '' then  aMessage + ', ' else '')+'OS Error code is '+code.ToString;
    raise new Exception(mes);
  end;
end;

method elements_tls_callback(aHandle: ^Void; aReason: rtl.DWORD; aReserved: ^Void);
begin
  case aReason of
    rtl.DLL_PROCESS_ATTACH: ;
    rtl.DLL_THREAD_ATTACH:;
    rtl.DLL_THREAD_DETACH:;

  end;
end;


method ExternalCalls.&exit(ex: Integer);
begin
  while atexitlist <> nil do begin
    atexitlist^.func();
    atexitlist := atexitlist^.next;
  end;
  rtl.ExitProcess(ex);
end;

method ExternalCalls.memcpy(destination: ^Void; source: ^Void; aNum: NativeInt): ^Void;
begin
  result := destination;
  if aNum = 0 then exit;
  if source = nil then raise new Exception('source is null');
  if destination = nil then raise new Exception('destination is null');
  if aNum < 0 then raise new Exception('aNum less than zero');
  if destination = source then exit;

  // TODO: Optimize this
  while aNum >= 8 do begin
    ^Int64(destination)^ := ^Int64(source)^;
    destination := ^Void(^Byte(destination) + 8);
    source := ^Void(^Byte(source) + 8);
    dec(aNum, 8);
  end;
  if aNum >= 4 then begin
    ^Int32(destination)^ := ^Int32(source)^;
    destination := ^Void(^Byte(destination) + 4);
    source := ^Void(^Byte(source) + 4);
    dec(aNum, 4);
  end;
  if aNum >= 2 then begin
    ^Int16(destination)^ := ^Int16(source)^;
    destination := ^Void(^Byte(destination) + 2);
    source := ^Void(^Byte(source) + 2);
    dec(aNum, 2);
  end;
  if aNum >= 1 then begin
    ^Byte(destination)^ := ^Byte(source)^;
  end;
end;

method ExternalCalls.memset(ptr: ^Void; value: Integer; aNum: NativeInt): ^Void;
begin
  value := value and $FF;
  var vval: UInt64 := value or (value shl 8) or (value shl 16) or (value shl 24);
  vval := vval or (vval shl 32);
  // TODO: Optimize this
  while aNum >= 8 do begin
    ^Int64(ptr)^ := vval;
    ptr := ^Void(^Byte(ptr) + 8);
    dec(aNum, 8);
  end;
  if aNum >= 4 then begin
    ^Int32(ptr)^ := Int32(vval);
    ptr := ^Void(^Byte(ptr) + 4);
    dec(aNum, 4);
  end;
  if aNum >= 2 then begin
    ^Int16(ptr)^ := Int16(vval);
    ptr := ^Void(^Byte(ptr) + 2);
    dec(aNum, 2);
  end;
  if aNum >= 1 then begin
    ^Byte(ptr)^ := value;
  end;
end;

method ExternalCalls.memmove(destination: ^Void; source: ^Void; aNum: NativeInt): ^Void;
begin
  result := destination;
  if aNum = 0 then exit;
  if source = nil then raise new Exception('source is null');
  if destination = nil then raise new Exception('destination is null');
  if aNum < 0 then raise new Exception('aNum less than zero');
  if destination = source then exit;

  if (source < destination) and (^Void(^Byte(source)+aNum) >= destination) then begin
    // TODO: Optimize this
    while aNum >= 8 do begin
      dec(aNum, 8);
      ^Int64(^Byte(destination) + aNum)^ := ^Int64(^Byte(source) + aNum)^;
    end;
    if aNum >= 4 then begin
      dec(aNum, 4);
      ^Int32(^Byte(destination) + aNum)^ := ^Int32(^Byte(source) + aNum)^;
    end;
    if aNum >= 2 then begin
      dec(aNum, 2);
      ^Int16(^Byte(destination) + aNum)^ := ^Int16(^Byte(source) + aNum)^;
    end;
    if aNum >= 1 then begin
      ^Byte(destination)^ := ^Byte(source)^;
    end;
  end
  else begin
    exit memcpy(destination, source, aNum);
  end;
end;

method ExternalCalls.strlen(c: ^AnsiChar): Integer;
begin
  if c = nil then exit 0;
  result := 0;
  while Byte(c^) <> 0 do begin
    inc(c);
    inc(result);
  end;
end;

method ExternalCalls.atexit(func: atexitfunc);
begin
  var rec := ^atexitrec(malloc(sizeOf(atexitrec)));
  // TODO: make atomic
  rec^.func := func;
  rec^.next := atexitlist;
  atexitlist := rec;
end;

method ElementsThreadHelper(aParam: ^Void): rtl.DWORD;
begin
  var aThread:= InternalCalls.Cast<ThreadRec>(aParam);
  try
    result := aThread.Call(aThread.Arg);
  finally
    rtl.ExitThread(result);
  end;
end;


method ExternalCalls._beginthreadex(security: ^Void; stack_size: Int32; proc: rtl.PTHREAD_START_ROUTINE; arglist: ^Void; initflag: Cardinal; thrdaddr: rtl.LPDWORD): rtl.HANDLE;
begin
  var lRec := new ThreadRec;
  lRec.Call := proc;
  lRec.Arg := arglist;
  exit rtl.CreateThread(rtl.LPSECURITY_ATTRIBUTES(security), stack_size, @ElementsThreadHelper, InternalCalls.Cast(lRec), initflag, thrdaddr);
end;

method ExternalCalls._endthreadex(aval: Cardinal);
begin
  // TODO: cleanup TLS!
  rtl.ExitThread(aval);
end;

class method ExternalCalls.malloc(size: NativeInt): ^Void;
begin
  if processheap = nil then processheap := rtl.GetProcessHeap;

  exit rtl.HeapAlloc(processheap, 0, size);
end;

class method ExternalCalls.realloc(ptr: ^Void; size: NativeInt): ^Void;
begin
  if processheap = nil then processheap := rtl.GetProcessHeap;
  if ptr = nil then
    exit rtl.HeapAlloc(processheap, 0, size);
  exit rtl.HeapReAlloc(processheap, 0, ptr, size);
end;

class method ExternalCalls._msize(ptr: ^Void): NativeInt;
begin
  if processheap = nil then processheap := rtl.GetProcessHeap;

  exit rtl.HeapSize(processheap, 0, ptr);
end;


class method ExternalCalls.free(v: ^Void);
begin
  rtl.HeapFree(processheap, 0, v);
end;

class method ExternalCalls.highbit(i: UInt64): Integer;
begin
  if i >= (UInt64(1) shl 32) then  begin
    result := result + 32;
    i := i shr 32;
  end;
  var c := UInt32(i);
  if c >= UInt32(1 shl 16) then begin
    result := result + 16;
    c := c shr 16;
  end;
  if c >= UInt32(1 shl 8) then begin
    result := result + 8;
    c := c shr 8;
  end;
  if c >= UInt32(1 shl 4) then begin
    result := result + 4;
    c := c shr 4;
  end;
  if c >= UInt32(1 shl 2) then begin
    result := result + 2;
    c := c shr 2;
  end;
  if c >= UInt32(1 shl 1) then begin
    result := result + 1;
    c := c shr 1;
  end;
  if c <> 0 then begin
    inc(result);
  end;
end;

class method ExternalCalls.uint64remainder(dividend, divisor: UInt64): UInt64;
begin
  if divisor = dividend then exit 0;
  if divisor = 0 then begin
    {$HINT throw!}
    exit 0;
  end;
  if divisor > dividend then
    exit dividend;
  var rem: UInt64 := dividend;
  var q: UInt64 := 0;

  while rem >= divisor do begin
    var td := divisor;
    var shift := highbit(rem) - highbit(divisor);
    td := td shl shift;
    if (td > rem)  then begin
      dec(shift);
      td := td shr 1;
    end;
    rem := rem - td;

    q := q or (UInt64(1) shl shift);
  end;
  exit rem
end;

class method ExternalCalls.int64remainder(dividend, divisor: Int64): Int64;
begin
  if divisor = dividend then exit 0;
  if divisor = 0 then begin
    {$HINT throw!}
    exit 0;
  end;
  var rem: UInt64 := dividend;
  if rem < 0 then rem := -rem;
  if divisor < 0 then divisor := -divisor;

  if divisor > rem then
    exit rem;
  var q: UInt64 := 0;
  while rem >= divisor do begin
    var td := divisor;
    var shift := highbit(rem) - highbit(divisor);
    td := td shl shift;
    if (td > rem)  then begin
      dec(shift);
      td := td shr 1;
    end;
    rem := rem - td;

    q := q or (UInt64(1) shl shift);
  end;
  if dividend < 0 then
    exit -rem;
  exit rem;
end;

class method ExternalCalls.uint64divide(dividend, divisor: UInt64): UInt64;
begin
  if divisor = dividend then exit 1;
  if divisor = 0 then begin
    {$HINT throw!}
    exit 0;
  end;
  if divisor > dividend then
    exit 0;
  var rem: UInt64 := dividend;
  var q: UInt64 := 0;

  while rem >= divisor do begin
    var td := divisor;
    var shift := highbit(rem) - highbit(divisor);
    td := td shl shift;
    if (td > rem)  then begin
      dec(shift);
      td := td shr 1;
    end;
    rem := rem - td;

    q := q or (UInt64(1) shl shift);
  end;
  exit q;
end;

class method ExternalCalls.int64divide(dividend, divisor: Int64): Int64;
begin
  if divisor = dividend then exit 1;
  if divisor = 0 then begin
    {$HINT throw!}
    exit 0;
  end;
  var rem: UInt64 := dividend;
  var lneg := (dividend < 0) <> (divisor < 0);
  if rem < 0 then rem := -rem;
  if divisor < 0 then divisor := -divisor;

  if divisor > rem then
    exit 0;
  var q: UInt64 := 0;
  while rem >= divisor do begin
    var td := divisor;
    var shift := highbit(rem) - highbit(divisor);
    td := td shl shift;
    if (td > rem)  then begin
      dec(shift);
      td := td shr 1;
    end;
    rem := rem - td;

    q := q or (UInt64(1) shl shift);
  end;
  if lneg then
    exit -Int64(q);
  exit q;
end;
{$IFDEF ARM64}
{$ELSEIF _WIN64}
class method ExternalCalls.setjmp(var buf: rtl.jmp_buf); // Odds are this has some mistakes
begin
  {$IF ARM64}
  raise new NotImplementedException("setjmp is not implemented yet for arm64");
  {$ELSE}
  InternalCalls.VoidAsm(
    "
    //movl %rbp, (%rcx)  // What is frame?
    movq %rbx, +8(%rcx)
    movq %rsp, +16(%rcx)
    movq %rbp, +24(%rcx)
    movq %rsi, +32(%rcx)
    movq %rdi, +40(%rcx)
    movq %r12, +48(%rcx)
    movq %r13, +56(%rcx)
    movq %r14, +64(%rcx)
    movq %r15, +72(%rcx)
    // SPARE

    movups %xmm6, +96(%rcx)
    movups %xmm7, +112(%rcx)
    movups %xmm8, +128(%rcx)
    movups %xmm9, +144(%rcx)
    movups %xmm10, +160(%rcx)
    movups %xmm11, +176(%rcx)
    movups %xmm12, +192(%rcx)
    movups %xmm13, +208(%rcx)
    movups %xmm14, +224(%rcx)
    movups %xmm15, +240(%rcx)
    // there's also: EPI, Registration, TryLevel, Cookie, UnwindFunc, Unwinddata, but libgc doesn't need those.
    xor %rax,%rax", "", false, false);
    {$ENDIF}
end;
{$ELSEIF i386}
class method ExternalCalls.setjmp3(var buf: rtl.jmp_buf; var ctx: ^Void); // Odds are this has some mistakes
begin
  InternalCalls.VoidAsm(
    "
    movl +4(%esp), %ecx

    movl %ebx, (%ecx)
    movl %ebp, +4(%ecx)
    movl %edi, +8(%ecx)
    movl %esi, +12(%ecx)
    movl %esp, +16(%ecx)
    // there's also: EPI, Registration, TryLevel, Cookie, UnwindFunc, Unwinddata, but libgc doesn't need those.
    xor %eax,%eax", "", false, false);
end;
{$ELSE}
  {$ERROR Unsupported Architecture}
{$ENDIF}

class method ExternalCalls._chkstk;
begin
  {$IF ARM64}
    raise new NotImplementedException("_chkstk is not implemented yet for arm64");
  {$ELSEIF X86_64}
  // This version is dual licensed under the MIT and the University of Illinois Open Source Licenses. See LICENSE.TXT for details; from the llvm compiler-RT project.
  InternalCalls.VoidAsm(
  "
        push   %rcx
        push   %rax
        cmp    $$0x1000,%rax
        lea    24(%rsp),%rcx
        jb     done
  loop:
          sub    $$0x1000,%rcx
          test   %rcx,(%rcx)
          sub    $$0x1000,%rax
          cmp    $$0x1000,%rax
          ja     loop
  done:
          sub    %rax,%rcx
          test   %rcx,(%rcx)
          pop    %rax
          pop    %rcx
          ret
  ", "", false, false);
  {$ELSEIF I386}
  InternalCalls.VoidAsm(
  "
    push %ecx  // save EcX as the caller doesn't expect ANY changes to registers, except EAX which holds the nr of bytes
    leal 4(%esp), %ecx // top of the stack after returning from this function
    cmpl $$0x1000, %eax
    jb done // if below 4096, done
  loop:
    subl $$0x1000, %eax  // decrease the count by 4096
    subl $$0x1000, %ecx  // decrease (ie grow) the stack bt 4096
    testl %ecx, (%ecx) // touch it
    cmpl $$0x1000, %eax
    jae loop // if above or equal to 4096, loop
  done:
    xchg %eax, %ecx
    subl %ecx, %eax
    movl 4(%esp), %ecx // store the original top of stack in ecx
    movl %ecx, (%eax) // place it back at the top of the new stack
    movl (%esp), %ecx // restore ecx
    movl %eax, %esp
    ret
  ", "", false, false);
  {$ELSE}
    {$ERROR Unsupported Architecture}
  {$ENDIF}
end;

class method ExternalCalls._wassert;
begin
  rtl.DebugBreak;
end;

class method ExternalCalls._CrtDbgReport;
begin
  rtl.DebugBreak;
end;

method ExternalCalls.RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);
begin
  var lData: array[0..2] of NativeUInt;
  lData[1] := NativeUInt(if aRaiseAddress = nil then Utilities.GetReturnAddress(0) else aRaiseAddress);
  lData[2] := NativeUInt(aRaiseFrame);
  lData[0] := NativeUInt(InternalCalls.Cast(aRaiseObject));
  {$IFDEF _WIN64}
  rtl.RaiseException(ElementsExceptionCode, rtl.EXCEPTION_NONCONTINUABLE, 3, ^UInt64(@lData[0]));
  {$ELSE}
  rtl.RaiseException(ElementsExceptionCode, rtl.EXCEPTION_NONCONTINUABLE, 3, ^UInt32(@lData[0]));
  {$ENDIF}
end;

{$IF ARM64}
method CallCatch64(aCall: NativeInt; aEBP: NativeInt): NativeInt;
begin
  raise new NotImplementedException("CallCatch64 is not implemented yet for arm64");
end;
{$ELSEIF X86_64}
[InlineAsm("
pushq %rbp
movq %rdx, %rbp
subq $$32, %rsp
callq *%rcx
addq $$32, %rsp
popq %rbp
retq
", "", false, false), DisableInlining, DisableOptimizations]
method CallCatch64(aCall: NativeInt; aEBP: NativeInt): NativeInt; external;
{$ELSEIF i386}
[DisableInlining]
method CallCatch32(aCall: NativeInt; aEBP: NativeInt): NativeInt;
begin
  exit InternalCalls.Asm("
movl $2, %ebp
calll *$1
", "=A,r,r,~{esi},~{ebx},~{edi}~{ebp},~{dirflag},~{fpsr},~{flags}", false, false, aCall, aEBP);
end;
{$ELSE}
  {$ERROR Unsupported Architecture}
{$ENDIF}

{$IF I386}
[DisableInlining, DisableOptimizations, LinkOnce]
method MyRtlUnwind(TargetFrame: IntPtr; TargetIp: IntPtr; ExceptionRecord: IntPtr; ReturnValue: IntPtr);
begin
  InternalCalls.VoidAsm("
  movl $3, %eax
  pushl %eax
  movl $2, %eax
  pushl %eax
  movl $1, %eax
  pushl %eax
  movl $0, %eax
  pushl %eax
  calll  _RtlUnwind@16
  ", "m,m,m,m,~{ebp},~{esp},~{ebx},~{esi},~{edi},~{dirflag},~{fpsr},~{flags}", true, true, [TargetFrame, TargetIp, ExceptionRecord, ReturnValue]);
  if TargetFrame = 0 then // KEEP! This forces it to be linked in, without this call it disapears!
    rtl.RtlUnwind(^Void(TargetFrame), ^Void(TargetIp), rtl.PEXCEPTION_RECORD(ExceptionRecord), ^Void(ReturnValue));
  exit;
end;
{$ENDIF}

{$IF ARM64}
method JumpToContinuation64(aAddress, aESP, aEBP: NativeInt);
begin
  raise new NotImplementedException("JumpToContinuation64 is not implemented yet for arm64");
end;
{$ELSEIF X86_64}
[InlineAsm("
    movq %r8, %rbp
    movq %rdx, %rsp
    jmpq *%rcx
", "", false, false), DisableInlining, DisableOptimizations]
method JumpToContinuation64(aAddress, aESP, aEBP: NativeInt); external;
{$ELSEIF I386}
(*[InlineAsm("
    movl 12(%esp), %ebp
    movl 4(%esp), %eax
    movl 8(%esp), %esp
    jmpl *%eax
", "", false, false), DisableInlining, DisableOptimizations]*)
[DisableInlining, DisableOptimizations]
method JumpToContinuation32(aAddress, aESP, aEBP: NativeInt);
begin
  InternalCalls.VoidAsm("
    movl $2, %ebp
    movl $0, %eax
    movl $1, %esp
    jmpl *%eax
  ", "r,r,r,~{ebp},~{esp},~{esp},~{dirflag},~{fpsr},~{flags}", false, false, aAddress, aESP, aEBP);
end;
{$ELSE}
  {$ERROR Unsupported Architecture}
{$ENDIF}

{$IFDEF _WIN64}
method GetMapIndex(aIP: NativeUInt; dispatcher: rtl.PDISPATCHER_CONTEXT): Integer;
begin
  var msvcinfo := ^MSVCExceptionInfo(dispatcher^.ImageBase + ^Int32(dispatcher^.HandlerData)^);
  var lIP := aIP - dispatcher^.ImageBase;
  var lMap := ^MSVCIpToSate(dispatcher^.ImageBase + msvcinfo^.IPMapEntry);
  result := -1;
  for i: Integer := 0 to msvcinfo^.IPMapEntries -1 do begin
    if lIP > lMap[i].IP then
      result := lMap[i].State
    else
      break;
  end;

end;

type CatchHelper = method (pExcept: ^rtl.EXCEPTION_RECORD): NativeInt;
method IntCallCatch(pExcept: ^rtl.EXCEPTION_RECORD): NativeInt;
begin
  exit CallCatch64(pExcept^.ExceptionInformation[2], pExcept^.ExceptionInformation[1]);
end;

method CallCatch(aCatch: ^MSVCTryMap; aHandler: ^MSVCHandlerType; arec: ^rtl.EXCEPTION_RECORD; EstFrame: UInt64; context: rtl.PCONTEXT; dispatcher: rtl.PDISPATCHER_CONTEXT);
begin
  var eh := &default(rtl.EXCEPTION_RECORD);
  eh.ExceptionCode := rtl.STATUS_UNWIND_CONSOLIDATE;
  eh.ExceptionFlags := rtl.EXCEPTION_NONCONTINUABLE;
  eh.NumberParameters := 15;
  var ch : CatchHelper:= @IntCallCatch;
  eh.ExceptionInformation[0] := UInt64(^Void(ch));
  eh.ExceptionInformation[1] := EstFrame;
  eh.ExceptionInformation[2] := dispatcher^.ImageBase + aHandler^.Handler;
  eh.ExceptionInformation[3] := aCatch^.TryLow;
  rtl.RtlUnwindEx(rtl.PVOID(EstFrame), rtl.PVOID(dispatcher^.ControlPc),  @eh, nil, context, dispatcher^.HistoryTable);
end;


method ExternalCalls.ExceptionHandler(arec: ^rtl.EXCEPTION_RECORD; EstablisherFrame: UInt64; context: rtl.PCONTEXT; dispatcher: rtl.PDISPATCHER_CONTEXT ): Integer;
begin
  var msvcinfo := ^MSVCExceptionInfo(dispatcher^.ImageBase + ^Int32(dispatcher^.HandlerData)^);

  result := 1; // continue searching
  if msvcinfo^.MagicNumber <> 429065506 then exit;

  var index := GetMapIndex(dispatcher^.ControlPc, dispatcher);

  if 0 <> (arec^.ExceptionFlags and ( rtl.EXCEPTION_UNWINDING or rtl.EXCEPTION_EXIT_UNWIND)) then begin
    var lMap := ^MSVCUnwindMap(dispatcher^.ImageBase + msvcinfo^.UnwindMap);
    if arec^.ExceptionCode = rtl.STATUS_UNWIND_CONSOLIDATE then begin
      var lTargetState := arec^.ExceptionInformation[3];
      // special exception, we're unwinding to a specific stat
      while (index < msvcinfo^.NumUnwindMap) and (&index <> lTargetState) do begin
        if lMap[index].Cleanup <> 0 then CallCatch64(dispatcher^.ImageBase + lMap[index].Cleanup, dispatcher^.EstablisherFrame);
        index:= lMap[index].ToState;
      end;
      exit;
    end;
    // unwinding, call finally, this is generally when unwinding completely.
    while (index < msvcinfo^.NumUnwindMap)  do begin
      if lMap[index].Cleanup <> 0 then CallCatch64(dispatcher^.ImageBase + lMap[index].Cleanup, dispatcher^.EstablisherFrame);
      index:= lMap[index].ToState;
    end;
  end else begin
    // we're not unwinding, we're looking for an exception handler that takes it
    var exo: Exception;
    if msvcinfo^.NumTryBlocks <> 0 then begin
      if arec^.ExceptionCode = ElementsExceptionCode then begin
        exo := InternalCalls.Cast<Exception>(^^Void(@arec^.ExceptionInformation)[0]);
      end else if arec^.ExceptionCode = $C0000005 then
        exo := new AccessViolationException
      else
        exo := new WindowsException(arec^.ExceptionCode);
      exo.ExceptionAddress := arec^.ExceptionAddress;
    end;
    if (index <> $FFFFFFFF) then begin
      for i: Integer := 0 to msvcinfo^.NumTryBlocks -1 do begin
        var tb := @(^MSVCTryMap(dispatcher^.ImageBase + msvcinfo^.TryBlockMap)[i]);
        if (index >= tb^.TryLow) and (index <= tb^.TryHigh) then begin
          var ht := ^MSVCHandlerType(dispatcher^.ImageBase + tb^.HandlerType);
          var htt := ^ElementsExceptionType(dispatcher^.ImageBase + ht^.Type);
          if assigned(Utilities.IsInstance(exo, htt^.Type)) then begin
            // restore pointer; but we skip that for now.
            var lCatchOffset := ht^.CatchObjOffset;
            if (lCatchOffset <> 0) then
              ^Exception(EstablisherFrame + lCatchOffset)^ := exo;
            var cond := htt^.Filter;
            {$IF ARM64} // workaround for 85424: Oxygene: bad error for {IFDEF}
            if (cond = nil) or (cond(^Void(context^.Sp))) then begin
              result := 0;
              CallCatch(tb, ht, arec, EstablisherFrame, context, dispatcher);
            end;
            {$ELSE}
            if (cond = nil) or (cond(^Void(context^.Rsp))) then begin
              result := 0;
              CallCatch(tb, ht, arec, EstablisherFrame, context, dispatcher);
            end;
            {$ENDIF}
          end;
        end;
      end;
    end;
  end;
  result := 1;
end;
{$ELSEIF i386}
method ExternalCalls.ExceptionHandler(inmsvcinfo: ^MSVCExceptionInfo; arec: ^rtl.EXCEPTION_RECORD; aOrgregFrame: ^ElementsRegistrationFrame; context: rtl.PCONTEXT; dispatcher: ^Void): Integer;
begin
  var msvcinfo := inmsvcinfo;
  var regFrame := ^ElementsRegistrationFrame(@^NativeInt(aOrgregFrame)[-1]);

  var lBaseAddress := NativeInt(@regFrame^.TryLevel) + 4;
  var lESP := NativeInt(regFrame^.ESP);
  result := 1; // continue searching
  if msvcinfo^.MagicNumber <> 429065506 then exit;

  if 0 <> (arec^.ExceptionFlags and ( rtl.EXCEPTION_UNWINDING or rtl.EXCEPTION_EXIT_UNWIND)) then begin
    // unwinding, call finally
    while (regFrame^.TryLevel <> $FFFFFFFF) and (regFrame^.TryLevel < msvcinfo^.NumUnwindMap)  do begin
      if msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup <> nil then CallCatch32(NativeInt(^Void(msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup)), lBaseAddress);
      regFrame^.TryLevel := msvcinfo^.UnwindMap[regFrame^.TryLevel].ToState;
    end;
  end else begin
    // we're not unwinding, we're looking for an exception handler that takes it
    var exo: Exception;
    if msvcinfo^.NumTryBlocks <> 0 then begin
      if arec^.ExceptionCode = ElementsExceptionCode then begin
        exo := InternalCalls.Cast<Exception>(^^Void(@arec^.ExceptionInformation)[0]);
      end else if arec^.ExceptionCode = $C0000005 then
        exo := new AccessViolationException
      else
        exo := new WindowsException(arec^.ExceptionCode);
      exo.ExceptionAddress := arec^.ExceptionAddress;
    end;
    if (regFrame^.TryLevel <> $FFFFFFFF) then begin
      for i: Integer := 0 to msvcinfo^.NumTryBlocks -1 do begin
        var tb := @msvcinfo^.TryBlockMap[i];
        if (regFrame^.TryLevel >= tb^.TryLow) and (regFrame^.TryLevel <= tb^.TryHigh) then begin
          if assigned(Utilities.IsInstance(exo, tb^.HandlerType^.Type^.Type)) then begin
            // restore pointer; but we skip that for now.
            var lCatchOffset := tb^.HandlerType^.CatchObjOffset;
            if (lCatchOffset <> 0) then
              ^Exception(lBaseAddress + lCatchOffset)^ := exo;
            var cond := tb^.HandlerType^.Type^.Filter;
            if (cond = nil) or (cond(regFrame^.ESP)) then begin
              result := 0;
              MyRtlUnwind(IntPtr(aOrgregFrame), nil, IntPtr(arec), nil);
              // now unwind locally
              while (regFrame^.TryLevel <> $FFFFFFFF) and (regFrame^.TryLevel < tb^.CatchHigh) and (regFrame^.TryLevel >= tb^.TryLow) do begin
                if msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup <> nil then begin
                  CallCatch32(NativeInt(^Void(msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup)), lBaseAddress);
                end;
                regFrame^.TryLevel := msvcinfo^.UnwindMap[regFrame^.TryLevel].ToState;
              end;
              var lCont := CallCatch32(NativeInt(^Void(tb^.HandlerType^.Handler)), lBaseAddress);
              JumpToContinuation32(lCont, lESP, lBaseAddress);
            end;
          end;
        end;
      end;
    end;
  end;
end;
{$ELSE}
  {$ERROR Unsupported Architecture}
{$ENDIF}

method ExternalCalls.wcslen(c: ^Char): Integer;
begin
  if c = nil then exit 0;
  result := 0;
  while Byte(c^) <> 0 do begin
    inc(c);
    inc(result);
  end;
end;


method main: Integer;
begin
  Utilities.Initialize;
  var cnt: Int32;
  var args := rtl.CommandLineToArgvW(rtl.GetCommandLineW(), @cnt);
  var args_s := new String[cnt-1];
  for i: Integer := 1 to cnt-1 do
    args_s[i-1] := String.FromPChar(args[i]);
  try
    try
      result := UserEntryPoint(args_s);
    finally
      while ExternalCalls.atexitlist <> nil do begin
        ExternalCalls.atexitlist^.func();
        ExternalCalls.atexitlist := ExternalCalls.atexitlist^.next;
      end;
    end;
  except
    on E: RuntimeException do begin
      writeLn(E.Message);
      Environment.Exit(E.Code);
    end;
    on E: Exception do raise;
  end;
end;

method mainCRTStartup: Integer;
begin
  ExternalCalls.fModuleHandle := rtl.GetModuleHandle(nil);
  ExternalCalls.fMainThreadID := rtl.GetCurrentThreadId;
  var lMain := main;
  BoehmGC.UnloadGC;
  ExternalCalls.exit(lMain);
end;

method WinMainCRTStartup: Integer;
begin
  ExternalCalls.fModuleHandle := rtl.GetModuleHandle(nil);
  var lMain := main;
  BoehmGC.UnloadGC;
  ExternalCalls.exit(lMain);
end;

type
  VoidMethod = method;

method DllMainCRTStartup(aModule: rtl.HMODULE; aReason: rtl.DWORD; aReserved: ^Void): Boolean;
begin   
  var lMain: ^DllMainType := @_dllmain;
  ExternalCalls.fModuleHandle := aModule;
  ModuleIsLib := true;
  try
    if lMain^ = nil then exit true;
    exit lMain^(aModule, aReason, aReserved);
  finally
    if (aReason = rtl.DLL_PROCESS_DETACH) then begin
      while ExternalCalls.atexitlist <> nil do begin
        ExternalCalls.atexitlist^.func();
        ExternalCalls.atexitlist := ExternalCalls.atexitlist^.next;
      end;
      BoehmGC.UnloadGC;
    end;
  end;
end;

end.