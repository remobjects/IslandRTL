namespace RemObjects.Elements.System;

interface

uses
  rtl;

type
  atexitfunc = public procedure();

  atexitrec = record
  public
    func: atexitfunc;
    next: ^atexitrec;
  end;
  UserEntryPointType =public method (args: array of String): Integer;
  {$IFNDEF DARWIN}
  dliteratecb = public function (info :^__struct_dl_phdr_info; size: size_t; data: ^Void): Integer; 
  {$ENDIF}
  {$IFDEF ARM and not DARWIN}rtl.__struct__Unwind_Exception = rtl.__struct__Unwind_Control_Block;{$ENDIF}
  ExternalCalls = public static class
  private
    class var atexitlist: ^atexitrec;
    {$IFDEF ANDROID}
//[SymbolName('__executable_start')]
//var __executable_start: ^Void; external;
    [SymbolName("dl_iterate_phdr"), &Weak]
    method dl_iterate_phdr(info: dliteratecb; data: ^Void): Integer; public;
    begin
      exit; (*
      var ehdr := @__executable_start;
      if ^Byte(ehdr)[0] <> $7f then exit;
      if ^Byte(ehdr)[1] <> 'E' then exit;
      if ^Byte(ehdr)[2] <> 'L' then exit;
      if ^Byte(ehdr)[3] <> 'F' then exit;

      var exe_info: __struct_dl_phdr_info;
      exe_info.dlpi_addr := 0;
      exe_info.dlpi_name := nil;
      ^IntPtr(@exe_info.dlpi_phdr)^ := (IntPtr(ehdr) + {$IFDEF CPU64}^Elf64_Ehdr(ehdr)^.e_phoff{$ELSE} ^Elf32_Ehdr(ehdr)^.e_phoff{$ENDIF});
      exe_info.dlpi_phnum := {$IFDEF CPU64}^Elf64_Ehdr(ehdr)^.e_phnum{$ELSE} ^Elf32_Ehdr(ehdr)^.e_phnum{$ENDIF};
      result := info(@exe_info, sizeof(exe_info), data);
      if result <> 0 then
        exit;
      {$IFNDEF ARM}
      var ehdr_vdso := getauxval(AT_SYSINFO_EHDR);
      if ehdr_vdso = 0 then begin
        exit;
      end;
      var vdso_info: __struct_dl_phdr_info;
      vdso_info.dlpi_addr := 0;
      vdso_info.dlpi_name := nil;
      ^IntPtr(@vdso_info.dlpi_phdr)^ := (IntPtr(ehdr_vdso) +  {$IFDEF CPU64}^Elf64_Ehdr(ehdr_vdso)^.e_phoff{$ELSE} ^Elf32_Ehdr(ehdr_vdso)^.e_phoff{$ENDIF});
      vdso_info.dlpi_phnum := {$IFDEF CPU64}^Elf64_Ehdr(ehdr_vdso)^.e_phnum{$ELSE} ^Elf32_Ehdr(ehdr_vdso)^.e_phnum{$ENDIF};
      __android_log_write(rtl.android_LogPriority.ANDROID_LOG_INFO, 'tag', 'in dl_iterate_phdr 5');
      for i: Integer := 0 to vdso_info.dlpi_phnum -1 do begin
        if vdso_info.dlpi_phdr[i].p_type = PT_LOAD then begin
          vdso_info.dlpi_addr := ehdr_vdso - vdso_info.dlpi_phdr[i].p_vaddr;
          break;
        end;
      end;
      result := info(@vdso_info, sizeof(vdso_info), data);
      {$ENDIF}*)
    end;
    {$ENDIF}
  public


    {$IFDEF ARM OR DARWIN OR LINUX}
    [SymbolName('_elements_posix_exception_handler')]
    method ExceptionHandler(aVersion: Integer; aState: rtl._Unwind_Action; aClass: UInt64; aEx: ^rtl.__struct__Unwind_Exception; aCtx: ^Void): rtl._Unwind_Reason_Code;
    begin
      exit IntExceptionHandler(aVersion, aState, aClass, aEx, aCtx);
    end;
    {$ELSE}
    [SymbolName('_elements_posix_exception_handler')]
    method ExceptionHandler(aState: rtl._Unwind_Action; aClass: UInt64; aEx: ^rtl.__struct__Unwind_Exception; aCtx: ^Void): rtl._Unwind_Reason_Code;
    begin
      exit IntExceptionHandler(1, aState, aClass, aEx, aCtx);
    end;
    {$ENDIF}

    method IntExceptionHandler(aVersion: Integer; aState: rtl._Unwind_Action; aClass: UInt64; aEx: ^rtl.__struct__Unwind_Exception; aCtx: ^Void): rtl._Unwind_Reason_Code;
    [SymbolName('ElementsRaiseException')]
    method RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);

    const ElementsExceptionCode: UInt64 = $E042881952454d4f;

    //{$IFNDEF xANDROID}
    [SymbolName('atexit')]
    //{$ENDIF}
    class method atexit(func: atexitfunc);
    [SymbolName('ElementsBeginCatch')]
    method ElementsBeginCatch(obj: ^Void): ^Void;

    [SymbolName('ElementsEndCatch')]
    method ElementsEndCatch;
    [SymbolName('ElementsGetExceptionForEHData')]
    method GetExceptionForEH(val: ^Void): ^Void;

    [SymbolName('ElementsRethrow')]
    method ElementsRethrow;

    //[SymbolName('__elements_entry_point'), &Weak]
    //method UserEntryPoint(args: array of String): Integer; external;

    {$IFDEF ARM}
    [Used, SymbolName('_GLOBAL_OFFSET_TABLE_')]
    class var _GLOBAL_OFFSET_TABLE_: Integer; private; external;
    {$ENDIF}
    {$IF NOT EMSCRIPTEN AND NOT ANDROID and not DARWIN}
    [SymbolName('_start'), Naked]
    method _start;
    [SymbolName('__libc_start_main', 'libc.so.6'), &weak]
    method libc_main(main: LibCEntryHelper; argc: Integer; argv: ^^Char; aInit: LibCEntryHelper; aFini: LibCFinalizerHelper); external;
    {$ENDIF}
    {$IFDEF DARWIN}
    [SymbolName('main')]
    method main(argc: Integer; argv: ^^AnsiChar; env: ^^AnsiChar): Integer;
    {$ENDIF}
    [SymbolName('__elements_init'), Used]
    method init(_nargs: Integer; _args: ^^AnsiChar; _envp: ^^AnsiChar): Integer;
    [SymbolName('__elements_fini'), Used]
    method fini;

    method Parselsda(aAction: rtl._Unwind_Action; aNative: Boolean; aEx: ^rtl.__struct__Unwind_Exception; aCtx: ^Void;
      out aTypeIndex: rtl.int64_t; out aLandingPadPointer: rtl.uintptr_t): Boolean;
    method DwarfEHReadPointer(var aData: ^Byte; aEncoding: DwarfEHEncodingType): rtl.uintptr_t;
    method DwarfEHReadPointer(var aData: ^Byte): rtl.uintptr_t;
    method DwarfEHReadULEB128(var aData: ^Byte): rtl.uintptr_t;
    method DwarfEHReadSLEB128(var aData: ^Byte): rtl.intptr_t;

    class var nargs: Integer;
    class var args: ^^AnsiChar;
    class var envp: ^^AnsiChar;
    {$IFNDEF DARWIN}
    [SymbolName('__init_array_start')] class var __init_array_start: Integer; external;
    [SymbolName('__init_array_end')] class var __init_array_end: Integer; external;
    {$ENDIF}

{$IF not ANDROID and not DARWIN}
    [SymbolName('stat64')]
    class method stat64(file: ^AnsiChar; var buf: rtl.__struct_stat64): Integer;
    begin
      exit rtl.__xstat64(0, file, var buf);
    end;
    [SymbolName('fstat64')]
    class method fstat64(fd: Integer; var buf: rtl.__struct_stat64): Integer;
    begin
      exit rtl.__fxstat64(0, fd, var buf);
    end;
    [SymbolName('lstat64')]
    class method lstat64(file: ^AnsiChar; var buf: rtl.__struct_stat64): Integer;
    begin
      exit rtl.__lxstat64(0, file, var buf);
    end;

{$ELSE}



    [SymbolName("__atomic_store_4")]
    class method __atomic_store_4(var mem: Int32; val: Int32);
    begin
      InternalCalls.VolatileWrite(var mem, val);
    end;

   [SymbolName("__atomic_fetch_add_4")]
   class method __atomic_fetch_add_4(var mem: Int32; val: Int32): Int32;
   begin
     exit InternalCalls.Add(var mem, val);
   end;


   [SymbolName("__atomic_compare_exchange_4")]
   class method __atomic_compare_exchange_4(var mem: Int32; exp: Int32; val: Int32): Int32;
   begin
     exit InternalCalls.CompareExchange(var mem, val, exp);
   end;


    [SymbolName("__atomic_store_8")]
    class method __atomic_store_8(var mem: Int64; val: Int64);
    begin
      InternalCalls.VolatileWrite(var mem, val);
    end;

   [SymbolName("__atomic_fetch_add_8")]
   class method __atomic_fetch_add_8(var mem: Int64; val: Int64): Int64;
   begin
     exit InternalCalls.Add(var mem, val);
   end;


   [SymbolName("__atomic_compare_exchange_8")]
   class method __atomic_compare_exchange_8(var mem: Int64; exp: Int64; val: Int64): Int64;
   begin
    exit InternalCalls.CompareExchange(var mem, val, exp);
   end;
   {$IFDEF LINUX AND not ANDROID}
   [SymbolNameAttribute('mknod')]
   class method mknod(path: ^AnsiChar; mode: mode_t; dev: dev_t): Integer;
   begin
     exit __xmknod (0, path, mode, @dev);
   end;
   {$ENDIF}

   {$IFNDEF DARWIN}
    [SymbolName('__stack_chk_fail')]
    method __stack_chk_fail(); external;
    {$IFNDEF i386}
    [SymbolName('__stack_chk_fail_local')]
    method __stack_chk_fail_local();
    begin
      __stack_chk_fail();
    end;
    {$ENDIF}
    {$ENDIF}
  {$ENDIF}
  end;

  DwarfEHEncodingType = public enum (
    DW_EH_PE_absptr = $00,
    DW_EH_PE_omit = $ff,
    DW_EH_PE_uleb128 = $01,
    DW_EH_PE_udata2 = $02,
    DW_EH_PE_udata4 = $03,
    DW_EH_PE_udata8 = $04,
    DW_EH_PE_sleb128 = $09,
    DW_EH_PE_sdata2 = $0A,
    DW_EH_PE_sdata4 = $0B,
    DW_EH_PE_sdata8 = $0C,
    DW_EH_PE_signed = $08,
    DW_EH_PE_pcrel = $10,
    DW_EH_PE_textrel = $20,
    DW_EH_PE_datarel = $30,
    DW_EH_PE_funcrel = $40,
    DW_EH_PE_aligned = $50,
    DW_EH_PE_indirect = $80) of Byte;

  LibCEntryHelper = public method (nargs: Integer; args: ^^AnsiChar; envp: ^^AnsiChar): Integer;
  LibCFinalizerHelper = public method();

  ElementsException = public record
  public
    handlerSwitchValue: Integer;
    landingPad: rtl.uintptr_t;

    Unwind: rtl.__struct__Unwind_Exception;
    Object: Object;
  end;

method CheckForLastError(aMessage: String := '');
method CheckForIOError(value: Integer);

method malloc(size: NativeInt): ^Void; inline;
begin
  exit rtl.malloc(size);
end;

method realloc(ptr: ^Void; size: NativeInt): ^Void;inline;
begin
  exit rtl.realloc(ptr, size);
end;

method free(v: ^Void);inline;
begin
   rtl.Free(v);
end;


[SymbolName('__elements_entry_point')]
method UserEntryPoint(aArgs: array of String): Integer; external;


[SymbolName({$IF EMSCRIPTEN OR ANDROID}'_start'{$ELSE}'__elements_entry_point_helper'{$ENDIF}), Used]
method Entrypoint(argc: Integer; argv: ^^AnsiChar; _envp: ^^AnsiChar): Integer;

implementation

method CheckForIOError(value: Integer);
begin
  if value = 0 then exit;
  CheckForLastError();
end;

method CheckForLastError(aMessage: String := '');
begin
  var code := rtl.errno;
  if code <> 0 then begin
    var mes := (if aMessage <> '' then  aMessage + ', ' else '')+'errno is '+code.ToString;
    raise new Exception(mes);
  end;
end;

method ExternalCalls.RaiseException(aRaiseAddress: ^Void; aRaiseFrame: ^Void; aRaiseObject: Object);
begin
  var lRecord := ^ElementsException(malloc(sizeOf(ElementsException))); // we use gc memory for this
  rtl.memset(lRecord, 0, sizeOf(ElementsException));
  var lExp := Exception(aRaiseObject);
  if lExp <> nil then begin
    lExp.ExceptionAddress := aRaiseAddress;
  end;

  ^UInt64(@lRecord^.Unwind.exception_class)^ := ElementsExceptionCode;
  lRecord^.Object := aRaiseObject;
  // No need to set anything, we use a GC so no cleanup needed
  rtl._Unwind_RaiseException(@lRecord^.Unwind);
  writeLn('Uncaught exception: '+aRaiseObject.ToString());
  rtl.exit(-1);
end;

method ExternalCalls. GetExceptionForEH(val: ^Void): ^Void;
begin
  exit InternalCalls.Cast(^ElementsException(val)^.Object);
end;

method ExternalCalls.IntExceptionHandler(aVersion: Integer; aState: rtl._Unwind_Action; aClass: UInt64; aEx: ^rtl.__struct__Unwind_Exception; aCtx: ^Void): rtl._Unwind_Reason_Code;
begin
  if (aVersion <> 1) or (aEx = nil) or (aCtx = nil) then exit {$IFNDEF ARM and not DARWIN}rtl._Unwind_Reason_Code._URC_FATAL_PHASE1_ERROR{$ELSE}rtl._Unwind_Reason_Code._URC_FAILURE{$ENDIF};
  var lMine := aClass = ElementsExceptionCode;
  {$IFDEF ARM and not DARWIN}
  if (aState  and rtl._Unwind_State._US_ACTION_MASK) <> rtl._Unwind_State._US_UNWIND_FRAME_STARTING then begin
     if rtl.__gnu_unwind_frame (aEx, aCtx) <> rtl._Unwind_Reason_Code._URC_OK  then
      exit rtl._Unwind_Reason_Code._URC_FAILURE;
    exit rtl._Unwind_Reason_Code._URC_CONTINUE_UNWIND;
  end;
  rtl._Unwind_SetGR (aCtx, UNWIND_POINTER_REG, rtl._Unwind_Word(aEx));
  {$ENDIF}
  var lTypeInfo: rtl.int64_t;
  var lLandingPad: rtl.uintptr_t;
  if 0 <> (aState and {$IFDEF EMSCRIPTEN OR x86_64}rtl._Unwind_Action._UA_SEARCH_PHASE{$ELSE}rtl._UA_SEARCH_PHASE{$ENDIF})  then begin
    if Parselsda(aState, lMine, aEx, aCtx, out lTypeInfo, out lLandingPad) then begin
      if lMine then begin
        var lRecord := ^ElementsException(aEx);
        lRecord := ^ElementsException(@^Byte(lRecord)[-Int32((^Byte(@lRecord^.Unwind) - ^Byte(lRecord)))]);

        lRecord^.handlerSwitchValue := lTypeInfo;
        lRecord^.landingPad := lLandingPad;
      end;
      exit rtl._Unwind_Reason_Code._URC_HANDLER_FOUND;
    end;
    {$IFDEF ARM and not DARWIN}
     if rtl.__gnu_unwind_frame (aEx, aCtx) <> rtl._Unwind_Reason_Code._URC_OK  then
      exit rtl._Unwind_Reason_Code._URC_FAILURE;
    {$ENDIF}
    exit rtl._Unwind_Reason_Code._URC_CONTINUE_UNWIND;
  end;

  if 0 <> (aState and {$IFDEF EMSCRIPTEN  OR x86_64}rtl._Unwind_Action._UA_CLEANUP_PHASE{$ELSE}rtl._UA_CLEANUP_PHASE{$ENDIF}) then begin
    // This is either unwinding OR catching
    if (0 = (aState and {$IFDEF EMSCRIPTEN OR x86_64}rtl._Unwind_Action._UA_HANDLER_FRAME{$ELSE}rtl._UA_HANDLER_FRAME{$ENDIF}))  then begin
      // finally, always parse
      if Parselsda(aState, lMine, aEx, aCtx, out lTypeInfo, out lLandingPad) then begin
        rtl._Unwind_SetGR(aCtx, 0, rtl.uintptr_t(aEx));
        rtl._Unwind_SetGR(aCtx, 1, rtl.uintptr_t(lTypeInfo));
        {$IFDEF ARM}
        rtl._Unwind_SetGR(aCtx, 15, lLandingPad or (rtl._Unwind_GetGR(aCtx, 15)and 1));
        {$ELSE}
        rtl._Unwind_SetIP(aCtx, lLandingPad);
        {$ENDIF}
        exit rtl._Unwind_Reason_Code._URC_INSTALL_CONTEXT;
      end;

      {$IFDEF ARM and not DARWIN}
       if rtl.__gnu_unwind_frame (aEx, aCtx) <> rtl._Unwind_Reason_Code._URC_OK  then
        exit rtl._Unwind_Reason_Code._URC_FAILURE;
      {$ENDIF}
      exit rtl._Unwind_Reason_Code._URC_CONTINUE_UNWIND;
    end;
    // exception
    if not lMine then begin
      if Parselsda(aState, lMine, aEx, aCtx, out lTypeInfo, out lLandingPad) then begin
        rtl._Unwind_SetGR(aCtx, 0, rtl.uintptr_t(aEx));
        rtl._Unwind_SetGR(aCtx, 1, rtl.uintptr_t(lTypeInfo));
        {$IFDEF ARM}
        rtl._Unwind_SetGR(aCtx, 15, lLandingPad or (rtl._Unwind_GetGR(aCtx, 15)and 1));
        {$ELSE}
        rtl._Unwind_SetIP(aCtx, lLandingPad);
        {$ENDIF}
        exit rtl._Unwind_Reason_Code._URC_INSTALL_CONTEXT;
      end;
      // we can't parse the LSDA table and the exception isn't ours, touble.
      exit {$IFNDEF ARM and not DARWIN}rtl._Unwind_Reason_Code._URC_FATAL_PHASE1_ERROR{$ELSE}rtl._Unwind_Reason_Code._URC_FAILURE{$ENDIF};
    end;
    var lRecord := ^ElementsException(aEx);
    lRecord := ^ElementsException(@^Byte(lRecord)[-Int32((^Byte(@lRecord^.Unwind) - ^Byte(lRecord)))]);
    rtl._Unwind_SetGR(aCtx, 0, rtl.uintptr_t(aEx));
    rtl._Unwind_SetGR(aCtx, 1, rtl.uintptr_t(lRecord^.handlerSwitchValue));
    {$IFDEF ARM}
    rtl._Unwind_SetGR(aCtx, 15, lLandingPad or (rtl._Unwind_GetGR(aCtx, 15)and 1));
    {$ELSE}
    rtl._Unwind_SetIP(aCtx, lRecord^.landingPad);
    {$ENDIF}
    free(lRecord);
    exit rtl._Unwind_Reason_Code._URC_INSTALL_CONTEXT;
  end;
  exit {$IFNDEF ARM and not DARWIN}rtl._Unwind_Reason_Code._URC_FATAL_PHASE1_ERROR{$ELSE}rtl._Unwind_Reason_Code._URC_FAILURE{$ENDIF};
end;

method ExternalCalls.ElementsBeginCatch(obj: ^Void): ^Void;
begin
  var lRecord := ^ElementsException(obj);
  lRecord := ^ElementsException(@^Byte(lRecord)[-Int32((^Byte(@lRecord^.Unwind) - ^Byte(lRecord)))]);
  if ^UInt64(@lRecord^.Unwind.exception_class)^ = ElementsExceptionCode then begin
    exit InternalCalls.Cast(lRecord^.Object);
  end;
  exit @lRecord^.Object;
end;

method ExternalCalls.ElementsEndCatch;
begin
  // Nothing to see here. but keep it around.
end;

method ExternalCalls.ElementsRethrow;
begin
  // FAIL
end;

{$IFDEF DARWIN}
method ExternalCalls.main(argc: Integer; argv: ^^AnsiChar; env: ^^AnsiChar): Integer;
begin
  exit Entrypoint(argc, argv, env);
end;
{$ENDIF}

{$IF NOT EMSCRIPTEN AND NOT ANDROID and not DARWIN}
method ExternalCalls._start;
begin
{$IFDEF ARM}
  InternalCalls.VoidAsm(
    "
  // r0 contains the rtld fini
  // sp contains: argc, argc (data), null, envp (data), null (rev order)
    mov     fp, #0
    mov     lr, #0

    pop     {r1}    // argc
    mov     r2, sp
    mov     r11, r0
    ldr     r4, .l4
.l4a: // we use GOT/PCREL to accomodate dylib compiling.
    add     r4, pc, r4
    ldr     r0, .l1
    ldr     r0, [r0, r4]
    ldr     r3, .l2
    ldr     r3, [r3, r4]
    ldr     r12, .l3
    ldr     r12, [r12, r4]

    push    {r2}
    push    {r11}
    push    {r12}
  // main: r0
  // argc: r1
  // argc: r2
  // fini: r3
  // stacktop: stackfini,
  /* __libc_start_main (main, argc, argv, init, fini, rtld_fini, stack_end) */
    bl     __libc_start_main
    bl abort
.l1:
    .long __elements_entry_point_helper(GOT)
.l2:
    .long __elements_init(GOT)
.l3:
    .long __elements_fini(GOT)
.l4:
    .long   _GLOBAL_OFFSET_TABLE_-(.l4a+8)

  ", "", false, false);
{$ELSE}
  InternalCalls.VoidAsm(
    "xor %ebp, %ebp
    movq %rdx, %r9
    popq %rsi
    movq %rsp, %rdx
    and $$0xfffffffffffffff0, %rsp
    pushq %rax
    pushq %rsp
    movq __elements_fini@GOTPCREL(%rip), %r8
    movq __elements_init@GOTPCREL(%rip), %rcx
    movq __elements_entry_point_helper@GOTPCREL(%rip), %rdi
    callq  __libc_start_main@PLT
    hlt
  ", "", false, false);
{$ENDIF}
end;
{$ENDIF}
{$HIDE W27}
method Entrypoint(argc: Integer; argv: ^^AnsiChar; _envp: ^^AnsiChar): Integer;
begin
  ExternalCalls.nargs := argc;
  ExternalCalls.args := argv;
  ExternalCalls.envp := _envp;
  Utilities.Initialize;
  var lArgs := new String[argc - 1];
  for i: Integer := 1 to argc - 1 do
    lArgs[i - 1] := String.FromPAnsiChars(argv[i]);
  exit UserEntryPoint(lArgs);
  {$IF NOT EMSCRIPTEN AND NOT ANDROID and not DARWIN}
  {$HIDE H14}
  ExternalCalls.libc_main(nil, 0, nil, nil, nil); // do not remove, this is there to ensure it's linked in.
  {$SHOW H14}
  {$ENDIF}
end;

method ExternalCalls.init(_nargs: Integer; _args: ^^AnsiChar; _envp: ^^AnsiChar): Integer;
begin
  ExternalCalls.nargs := _nargs;
  ExternalCalls.args := _args;
  ExternalCalls.envp := _envp;
  {$IFNDEF DARWIN}
  var n := (@__init_array_end) - (@__init_array_start);
  for i: Integer := 0 to (n) -1 do begin
    ^LibCEntryHelper(@__init_array_start)[i](nargs, args, envp);
  end;
  {$ENDIF}
  exit 0;
end;
{$SHOW W27}
method ExternalCalls.fini;
begin
  //_finilist;
   while atexitlist <> nil do begin
    atexitlist^.func();
    atexitlist := atexitlist^.next;
  end;

end;

method ExternalCalls.Parselsda(aAction: rtl._Unwind_Action; aNative: Boolean; aEx: ^rtl.__struct__Unwind_Exception; aCtx: ^Void;
      out aTypeIndex: rtl.int64_t; out aLandingPadPointer: rtl.uintptr_t): Boolean;
begin
  var lLSD := ^Byte(rtl._Unwind_GetLanguageSpecificData(aCtx));
  if lLSD = nil then exit false;
  {$IFDEF ARM}
  var lOffset := Integer ((^Byte(rtl._Unwind_GetGR(aCtx, 15) and not 1) - ^Byte(rtl._Unwind_GetRegionStart(aCtx)))-1 );
  {$ELSE}
  var lOffset := Integer ((^Byte(rtl._Unwind_GetIP(aCtx)) - ^Byte(rtl._Unwind_GetRegionStart(aCtx)))-1 );
  {$ENDIF}

  var lLandingPadStart := DwarfEHReadPointer(var lLSD);
  if lLandingPadStart = 0 then lLandingPadStart := uintptr_t(^Byte(rtl._Unwind_GetRegionStart(aCtx)));

  var lTypeEncoding := ^DwarfEHEncodingType(lLSD)^;
  inc(lLSD); // skip type info
  var lTypeInfoTable: ^Byte := if lTypeEncoding = DwarfEHEncodingType.DW_EH_PE_omit then nil else DwarfEHReadULEB128(var lLSD) + lLSD;

  var lCallsiteEncoding := ^DwarfEHEncodingType(lLSD)^;
  inc(lLSD);
  var lSizeOfCallsiteTable: UInt32 := uint32_t(DwarfEHReadULEB128(var lLSD));
  var lActionTable: ^uint8_t := lLSD + lSizeOfCallsiteTable;
  loop begin
    if lLSD >= lActionTable then exit false; // shouldn't  happen; out of range
    var lCallsiteEntryStart: uintptr_t := DwarfEHReadPointer(var lLSD, lCallsiteEncoding);
    var lCallsiteEntryLength: uintptr_t := DwarfEHReadPointer(var lLSD, lCallsiteEncoding);
    aLandingPadPointer := DwarfEHReadPointer(var lLSD, lCallsiteEncoding);
    var lCallsiteEntryActionTable: uintptr_t := DwarfEHReadULEB128(var lLSD);
    if (lOffset >= lCallsiteEntryStart) then begin
      if lOffset >= (lCallsiteEntryStart + lCallsiteEntryLength) then
        continue; // out of range, an error that shouldn't occur
      if aLandingPadPointer = 0 then
        exit false; // nothing to do here, empty LP

      aLandingPadPointer := lLandingPadStart + aLandingPadPointer;

      if lCallsiteEntryActionTable = 0 then begin
        // entry = 0; Cleanup
        if ((aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_CLEANUP_PHASE{$ELSE}_UA_CLEANUP_PHASE{$ENDIF}) <> 0) and not ((aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_HANDLER_FRAME{$ELSE}_UA_HANDLER_FRAME{$ENDIF}) <> 0) then begin
          aTypeIndex := 0;
          exit true;
        end;
        exit false;
      end;

      var lCurrentActionTable: ^uint8_t := lActionTable + lCallsiteEntryActionTable - 1;
      loop begin
        var lIndexInTypeInfoTable: Int64 := DwarfEHReadSLEB128(var lCurrentActionTable);
        if lIndexInTypeInfoTable = 0 then begin
          // cleanup pad
          if ((aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_CLEANUP_PHASE{$ELSE}_UA_CLEANUP_PHASE{$ENDIF}) <> 0) and not ((aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_HANDLER_FRAME{$ELSE}_UA_HANDLER_FRAME{$ENDIF}) <> 0) then begin
            aTypeIndex := lIndexInTypeInfoTable;
            exit true;
          end;
        end;
        if lIndexInTypeInfoTable > 0 then begin
          // this is a catch
          if lTypeInfoTable = nil then exit false; // shouldn't happen
          var lTypeReadOffset := @lTypeInfoTable[- lIndexInTypeInfoTable * case DwarfEHEncodingType(lTypeEncoding and $F) of
            DwarfEHEncodingType.DW_EH_PE_absptr: sizeOf(^Byte);
            DwarfEHEncodingType.DW_EH_PE_udata2, DwarfEHEncodingType.DW_EH_PE_sdata2: 2;
            DwarfEHEncodingType.DW_EH_PE_udata4, DwarfEHEncodingType.DW_EH_PE_sdata4: 4;
            DwarfEHEncodingType.DW_EH_PE_udata8, DwarfEHEncodingType.DW_EH_PE_sdata8: 8;
            else 1;
          end];
          var catchType := ^Void(DwarfEHReadPointer(var lTypeReadOffset, lTypeEncoding));
          if catchType = nil then begin
            // catch all
            if ((aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_SEARCH_PHASE{$ELSE}_UA_SEARCH_PHASE{$ENDIF}) <> 0) or ((aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_HANDLER_FRAME{$ELSE}_UA_HANDLER_FRAME{$ENDIF}) <>0) then begin
              aTypeIndex := lIndexInTypeInfoTable;
              exit true;
            end
            else begin
              // Unexpected but we exit continueing thee search
              exit false;
            end;
          end;

          if aNative then begin
            var exception_header := ^ElementsException(aEx);
            exception_header := ^ElementsException(@^Byte(exception_header)[-Int32((^Byte(@exception_header^.Unwind) - ^Byte(exception_header)))]);

            if Utilities.IsInstance(exception_header^.Object, catchType) <> nil then begin
              if 0 <> (aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_SEARCH_PHASE{$ELSE}_UA_SEARCH_PHASE{$ENDIF}) then begin
                aTypeIndex := lIndexInTypeInfoTable;
                exit true;
              end
              else begin
                if 0 = (aAction and {$IFDEF EMSCRIPTEN  OR x86_64}_Unwind_Action._UA_FORCE_UNWIND{$ELSE}_UA_FORCE_UNWIND{$ENDIF}) then begin
                  //call_terminate(native_exception, unwind_exception);
                  exit false;
                end;
              end;
            end;
          end;

        end;
        var temp: ^uint8_t := lCurrentActionTable;
        var actionOffset: Int64 := DwarfEHReadSLEB128(var temp);
        if actionOffset = 0 then begin
          exit false;
        end;
        lCurrentActionTable := lCurrentActionTable + actionOffset;
      end;
    end
  end;
end;

method ExternalCalls.DwarfEHReadPointer(var aData: ^Byte; aEncoding: DwarfEHEncodingType): rtl.uintptr_t;
begin
  var lStart := aData;
  case DwarfEHEncodingType(aEncoding and $f) of
    (DwarfEHEncodingType.DW_EH_PE_omit and $f): exit 0;
    DwarfEHEncodingType.DW_EH_PE_absptr: begin
      result := ^rtl.uintptr_t(aData)^;
      inc(aData, sizeOf(rtl.uintptr_t));
    end;
    DwarfEHEncodingType.DW_EH_PE_uleb128: result := DwarfEHReadULEB128(var aData);
    DwarfEHEncodingType.DW_EH_PE_sleb128: result := DwarfEHReadSLEB128(var aData);
    DwarfEHEncodingType.DW_EH_PE_sdata2,
    DwarfEHEncodingType.DW_EH_PE_udata2: begin
      result := ^rtl.uint16_t(aData)^;
    inc(aData, 2);
    end;
    DwarfEHEncodingType.DW_EH_PE_udata4,
    DwarfEHEncodingType.DW_EH_PE_sdata4: begin
      result := ^rtl.uint32_t(aData)^;
    inc(aData, 4);
    end;
    DwarfEHEncodingType.DW_EH_PE_udata8,
    DwarfEHEncodingType.DW_EH_PE_sdata8: begin
      result := ^rtl.uint64_t(aData)^;
    inc(aData, 8);
    end;
  else exit 0;
  end;
  if 0  <> (aEncoding and DwarfEHEncodingType.DW_EH_PE_pcrel) then
    result := result + rtl.uintptr_t(lStart);
  if 0 <> (aEncoding and DwarfEHEncodingType.DW_EH_PE_indirect) then
    result := ^uintptr_t(result)^;
end;

method ExternalCalls.DwarfEHReadPointer(var aData: ^Byte): rtl.uintptr_t;
begin
  var lEncoding: DwarfEHEncodingType := ^DwarfEHEncodingType(aData)^;
  inc(aData);
  exit DwarfEHReadPointer(var aData, lEncoding);
end;

method ExternalCalls.DwarfEHReadULEB128(var aData: ^Byte): rtl.uintptr_t;
begin
  var lShift := 0;
  loop begin
    var lData := aData^;
    inc(aData);
    result := result or (rtl.uintptr_t(lData and $7f) shl lShift);
    if (lData and $80) = 0 then break;
    lShift := lShift + 7;
  end;
end;

method ExternalCalls.DwarfEHReadSLEB128(var aData: ^Byte): rtl.intptr_t;
begin
  var lShift := 0;
  loop begin
    var lData := aData^;
    inc(aData);
    result := result or (rtl.uintptr_t(lData and $7f) shl lShift);
    lShift := lShift + 7;
    if (lData and $80) = 0 then break;
  end;
  if ((aData[-1] and $40) <> 0) and (lShift < sizeOf(intptr_t)) then
    result := result or - (intptr_t(1) shl lShift);
end;

method ExternalCalls.atexit(func: atexitfunc);
begin
  var rec := ^atexitrec(malloc(sizeOf(atexitrec)));
  // TODO: make atomic
  rec^.func := func;
  rec^.next := atexitlist;
  atexitlist := rec;
end;

end.