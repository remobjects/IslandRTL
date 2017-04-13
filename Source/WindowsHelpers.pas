namespace RemObjects.Elements.System;

interface


type
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
    class var atexitlist: ^atexitrec;
    class var processheap: rtl.HANDLE;
    class var fModuleHandle: rtl.HMODULE;
    class method getModuleHandle: rtl.HMODULE;
    begin
      if fModuleHandle = nil then fModuleHandle := rtl.GetModuleHandleW(nil);
      exit fModuleHandle;
    end;
  public
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
    [SymbolName('_fltused')]
    class var _fltused: Integer;
    [SymbolName('_beginthreadex')]
    class method _beginthreadex(
       security: ^Void;
       stack_size: Int32;
       proc: rtl.PTHREAD_START_ROUTINE;
       arglist: ^Void;
       initflag: Cardinal;
       thrdaddr: rtl.LPDWORD): rtl.HANDLE;
    [SymbolName('_endthreadex')]
    class method _endthreadex(aval: Cardinal);
    [SymbolName('atexit')]
    class method atexit(func: atexitfunc);
    [SymbolName('exit')]
    class method &exit(ex: Integer);
    [SymbolName('memcpy')]
    class method memcpy(destination, source: ^Void; aNum: NativeInt): ^Void;
    [SymbolName('memmove')]
    class method memmove(destination, source: ^Void; aNum: NativeInt): ^Void;
    [SymbolName('memset')]
    class method memset(ptr: ^Void; value: Integer; aNum: NativeInt): ^Void;
    [SymbolName('strlen')]
    class method strlen(c: ^AnsiChar): Integer;
    [SymbolName('wcslen')]
    class method wcslen(c: ^Char): Integer;

    {$IFDEF _WIN64}
    [SymbolName('__chkstk'), Naked, DisableOptimizations, DisableInliningAttribute]
    {$ELSE}
    [SymbolName('_chkstk'), Naked, DisableOptimizations, DisableInliningAttribute]
    {$ENDIF}
    class method _chkstk;

    // WARNING, malloc/free are NOT good functions to use, but libgc needs these to get started
    [SymbolName('malloc')]
    class method malloc(size: Integer): ^Void;
    [SymbolName('free')]
    class method free(v: ^Void);
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
    {$IFDEF _WIN64}
    [SymbolName('_setjmp'), Naked, DisableOptimizations, DisableInliningAttribute]
    class method setjmp(var buf: rtl.jmp_buf);
    {$ELSE}
    [SymbolName('_setjmp3'), Naked, DisableOptimizations, DisableInliningAttribute]
    class method setjmp3(var buf: rtl.jmp_buf; var ctx: ^Void);
    {$ENDIF}

    [SymbolName('_elements_exception_handler'), CallingConvention(CallingConvention.Stdcall)] // 32bits windows only!!

    {$IFDEF _WIN64}
  method ExceptionHandler(arec: ^rtl.EXCEPTION_RECORD; EstablisherFrame: UInt64; context: rtl.PCONTEXT; dispatcher: rtl.PDISPATCHER_CONTEXT ): Integer;
    {$ELSE}
    method ExceptionHandler([InReg]msvcinfo: ^MSVCExceptionInfo; arec: ^rtl.EXCEPTION_RECORD; aOrgregFrame: ^ElementsRegistrationFrame;
      context: rtl.PCONTEXT; dispatcher: ^Void): Integer;
    {$ENDIF}
    [SymbolName('ElementsRaiseException')]
    class method RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);
    class method DefaultUserEntryPoint(args: array of String): Integer; empty;

    [SymbolName('main')]
    class method main: Integer;
    [SymbolName('mainCRTStartup')]
    class method mainCRTStartup: Integer;
    [SymbolName('_DllMainCRTStartup'), CallingConvention(CallingConvention.Stdcall)]
    class method DllMainCRTStartup(aModule: rtl.HMODULE; aReason: rtl.DWORD; aReserved: ^Void): Boolean;

    [SymbolName('__elements_dll_entry'), &Weak]
    class method DllEntry;  external;
    [SymbolName('__elements_dll_exit'), &Weak]
    class method DllExit;  external;

    class property ModuleHandle: rtl.HMODULE read fModuleHandle;


    const ElementsExceptionCode = $E0428819;
  end;
{$G+}
  UserEntryPointType =public method (args: array of String): Integer;
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



// This is needed by anything msvc compiled; it's the offset in fs for the tls array
var
  [Alias, SymbolName('__elements_entry_point'), &Weak]
  UserEntryPoint: UserEntryPointType := @ExternalCalls.DefaultUserEntryPoint;
  [SymbolName('_tls_array'), Alias]
  _tls_array: ^Int32 := ^Int32($2c);
  [SymbolName('_tls_index')]
  _tls_index: Cardinal := 0; public;
  [SectionName('.tls'), SymbolName('_tls_start')]
  _tls_start: NativeInt := 0;public;
  [SectionName('.tls$ZZZ'), SymbolName('_tls_end')]
  _tls_end: NativeInt := 0; public;

  [SectionName(".CRT$XLA"), SymbolName('__xl_a')]
  __xl_a: rtl.PIMAGE_TLS_CALLBACK := 0;public;
  [SectionName(".CRT$XLEL"), SymbolName('__elements_tls_callback'), Used()]
  __elements_tls_callback: rtl.PIMAGE_TLS_CALLBACK := @elements_tls_callback;public;
  [SectionName(".CRT$XLZ"), SymbolName('__xl_z')]
  __xl_z: rtl.PIMAGE_TLS_CALLBACK := 0;public;

  [SectionName('.rdata$T'), SymbolName('_tls_used'), Used]
  _tls_used: {$IFDEF _WIN64}rtl.IMAGE_TLS_DIRECTORY64{$ELSE}rtl.IMAGE_TLS_DIRECTORY {$ENDIF}:=
    new {$IFDEF _WIN64}rtl.IMAGE_TLS_DIRECTORY64{$ELSE}rtl.IMAGE_TLS_DIRECTORY {$ENDIF}(
      StartAddressOfRawData := NativeUInt(@_tls_start),
      EndAddressOfRawData := NativeUInt (@_tls_end),
      AddressOfIndex := NativeUInt(@_tls_index),
      AddressOfCallbacks := NativeInt(^NativeInt(@__xl_a)+1),
      SizeOfZeroFill := 0
    ); readonly;public;

[SymbolName('__elements_tls_callback_method'), Used{$IFNDEF _WIN64}, CallingConvention(CallingConvention.Stdcall){$ENDIF}]
method elements_tls_callback(aHandle: ^Void; aReason: rtl.DWORD; aReserved: ^Void);public;


method ElementsThreadHelper(aParam: ^Void): rtl.DWORD;


method CheckForIOError(value: Boolean);
method CheckForLastError(aMessage: String := '');
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
    ^Int64(ptr)^ := 0;
    ptr := ^Void(^Byte(ptr) + 8);
    dec(aNum, 8);
  end;
  if aNum >= 4 then begin
    ^Int32(ptr)^ := 0;
    ptr := ^Void(^Byte(ptr) + 4);
    dec(aNum, 4);
  end;
  if aNum >= 2 then begin
    ^Int16(ptr)^ := 0;
    ptr := ^Void(^Byte(ptr) + 2);
    dec(aNum, 2);
  end;
  if aNum >= 1 then begin
    ^Byte(ptr)^ := 0;
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
  var rec := ^atexitrec(gc.GC_malloc(sizeOf(atexitrec)));
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


method ExternalCalls._beginthreadex(security: ^Void; stack_size: Integer; proc: rtl.PTHREAD_START_ROUTINE; arglist: ^Void; initflag: Cardinal; thrdaddr: rtl.LPDWORD): rtl.HANDLE;
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

class method ExternalCalls.malloc(size: Integer): ^Void;
begin
  if processheap = nil then processheap := rtl.GetProcessHeap;

  exit rtl.HeapAlloc(processheap, 0, size);
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
    {$message hint throw!}
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
    {$message hint throw!}
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
    {$message hint throw!}
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
    {$message hint throw!}
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

{$IFDEF _WIN64}
class method ExternalCalls.setjmp(var buf: rtl.jmp_buf); // Odds are this has some mistakes
begin
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
end;
{$ENDIF}

{$IFNDEF _WIN64}
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
{$ENDIF}

{$IFNDEF _WIN64}
class method ExternalCalls._chkstk;
begin
  InternalCalls.voidasm(
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
end;
{$ELSE}
// This version is dual licensed under the MIT and the University of Illinois Open Source Licenses. See LICENSE.TXT for details; from the llvm compiler-RT project.
class method ExternalCalls._chkstk;
begin
  InternalCalls.voidasm(
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
end;
{$ENDIF}

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



{$IFDEF _WIN64}
[InlineAsm("
pushq %rbp
movq %rdx, %rbp
subq $$32, %rsp
callq *%rcx
addq $$32, %rsp
popq %rbp
retq
", "", false, false), DisableInlining, DisableOptimizations, LinkOnce]
{$ELSE}
[InlineAsm("
pushl %ebp
movl 8(%esp),%eax
movl 12(%esp), %ebp
calll *%eax
popl %ebp
retl
", "", false, false), DisableInlining, DisableOptimizations, LinkOnce]
{$ENDIF}
method CallCatch(aCall: NativeInt; aEBP: NativeInt): NativeInt; external;

{$IFDEF _WIN64}
[InlineAsm("
    movq %r8, %rbp
    movq %rdx, %rsp
    jmpq *%rcx
", "", false, false), DisableInlining, DisableOptimizations] {$ELSE}
[InlineAsm("
    movl 12(%esp), %ebp
    movl 4(%esp), %eax
    movl 8(%esp), %esp
    jmpl *%eax
", "", false, false), DisableInlining, DisableOptimizations]
{$ENDIF}
method JumpToContinuation(aAddress, aESP, aEBP: NativeInt); external;
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
  exit CallCatch(pExcept^.ExceptionInformation[2], pExcept^.ExceptionInformation[1]);
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
      if lMap[index].Cleanup <> 0 then CallCatch(dispatcher^.ImageBase + lMap[index].Cleanup, dispatcher^.EstablisherFrame);
        index:= lMap[index].ToState;
      end;
      exit;
    end;
    // unwinding, call finally, this is generally when unwinding completely.
    while (index < msvcinfo^.NumUnwindMap)  do begin
      if lMap[index].Cleanup <> 0 then CallCatch(dispatcher^.ImageBase + lMap[index].Cleanup, dispatcher^.EstablisherFrame);
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
            if (cond = nil) or (cond(^Void(context^.Rsp))) then begin
              result := 0;
              CallCatch(tb, ht, arec, EstablisherFrame, context, dispatcher);
            end;
          end;
        end;
      end;
    end;
  end;
  result := 1;
end;
{$ELSE}
 method ExternalCalls.ExceptionHandler(msvcinfo: ^MSVCExceptionInfo; arec: ^rtl.EXCEPTION_RECORD; aOrgregFrame: ^ElementsRegistrationFrame; context: rtl.PCONTEXT; dispatcher: ^Void): Integer;
begin
  var regFrame := ^ElementsRegistrationFrame(@^NativeInt(aOrgregFrame)[-1]);

  var lBaseAddress := NativeInt(@regFrame^.TryLevel) + 4;
  var lESP := NativeInt(regFrame^.ESP);
  result := 1; // continue searching
  if msvcinfo^.MagicNumber <> 429065506 then exit;

  if 0 <> (arec^.ExceptionFlags and ( rtl.EXCEPTION_UNWINDING or rtl.EXCEPTION_EXIT_UNWIND)) then begin
    // unwinding, call finally
    while (regFrame^.TryLevel <> $FFFFFFFF) and (regFrame^.TryLevel < msvcinfo^.NumUnwindMap)  do begin
      if msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup <> nil then CallCatch(NativeInt(^Void(msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup)), lBaseAddress);
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
              rtl.RtlUnwind(aOrgregFrame, nil, arec, nil);
              // no unwind locally
              while (regFrame^.TryLevel <> $FFFFFFFF) and (regFrame^.TryLevel < tb^.CatchHigh) and (regFrame^.TryLevel >= tb^.TryLow) do begin
                if msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup <> nil then CallCatch(NativeInt(^Void(msvcinfo^.UnwindMap[regFrame^.TryLevel].Cleanup)), lBaseAddress);
                regFrame^.TryLevel := msvcinfo^.UnwindMap[regFrame^.TryLevel].ToState;
              end;
              var lCont := CallCatch(NativeInt(^Void(tb^.HandlerType^.Handler)), lBaseAddress);
              JumpToContinuation(lCont, lESP, lBaseAddress);
            end;
          end;
        end;
      end;
    end;
  end;
end;
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


method ExternalCalls.main: Integer;
begin
  Utilities.Initialize;
  exit UserEntryPoint([]);
end;

method ExternalCalls.mainCRTStartup: Integer;
begin
  &exit(main);
end;

type
  VoidMethod = method;

method ExternalCalls.DllMainCRTStartup(aModule: rtl.HMODULE; aReason: rtl.DWORD; aReserved: ^Void): Boolean;
begin
  fModuleHandle := aModule;
  var m: VoidMethod;
  if aReason = rtl.DLL_PROCESS_ATTACH then begin
    m := @DllEntry;
    if assigned(m) then m();
  end;
  if aReason = rtl.DLL_PROCESS_ATTACH then
    m := @DllExit;
    if assigned(m) then m();
  exit true;
end;

end.