namespace RemObjects.Elements.System;
uses gc;
[assembly:AssemblyDefine('BOEHMGC')]
[assembly:AssemblyDefine('TRACINGGC')]
type
  GC = public static class 
  assembly
    class var fLock: Integer;

{$IFDEF POSIX}[LinkOnce, DllExport]{$ENDIF}
    [SkipDebug]
    method LocalGC; private;
    begin
      GC_init;
      GC_allow_register_threads();
      Utilities.fSharedMemory.collect := @GC_gcollect;
      Utilities.fSharedMemory.register := @GC_my_register_my_thread;
      Utilities.fSharedMemory.unregister := @GC_unregister_my_thread;
      Utilities.fSharedMemory.malloc := @GC_malloc;
      Utilities.fSharedMemory.setfinalizer := @SetFinalizer;
      Utilities.fSharedMemory.unsetfinalizer := @UnsetFinalizer;
    end;
    {$IFDEF WINDOWS}var fMapping: rtl.HANDLE;{$ENDIF}
    [SkipDebug]
    method LoadGC; assembly;
    begin
      Utilities.SpinLockEnter(var fLock);
      try
        if InternalCalls.CompareExchange(var Utilities.fLoaded, 1, 0 ) = 1 then begin
          exit;
        end;
        {$IFDEF WINDOWS}
        var FN: array[0..28] of Char;
        FN[0] := '_';
        FN[1] := '_';
        FN[2] := 'R';
        FN[3] := 'e';
        FN[4] := 'm';
        FN[5] := 'O';
        FN[6] := 'b';
        FN[7] := 'j';
        FN[8] := 'e';
        FN[9] := 'c';
        FN[10] := 't';
        FN[11] := 's';
        FN[12] := 'I';
        FN[13] := 's';
        FN[14] := 'l';
        FN[15] := 'a';
        FN[16] := 'n';
        FN[17] := 'd';
        FN[18] := '2'; // Version, increase when adding stuff or making the class layout incompatible
        var lID := rtl.GetCurrentProcessId;
        FN[19] := Char(Integer('a')+Integer((lID shr 0) and $f));
        FN[20] := Char(Integer('a')+Integer((lID shr 4) and $f));
        FN[21] := Char(Integer('a')+Integer((lID shr 8) and $f));
        FN[22] := Char(Integer('a')+Integer((lID shr 12) and $f));
        FN[23] := Char(Integer('a')+Integer((lID shr 16) and $f));
        FN[24] := Char(Integer('a')+Integer((lID shr 20) and $f));
        FN[25] := Char(Integer('a')+Integer((lID shr 24) and $f));
        FN[26] := Char(Integer('a')+Integer((lID shr 28) and $f));
        FN[27] := #0;

        fMapping := rtl.CreateFileMappingW( rtl.INVALID_HANDLE_VALUE, nil, rtl.PAGE_READWRITE, 0, 8, @FN[0]);

        if fMapping = nil then begin
          LocalGC;
          raise new Exception('Cannot create file mapping for memory sharing, this should not happen!');
        end;
        var lNew := rtl.GetLastError <> rtl.ERROR_ALREADY_EXISTS;
        var p: ^NativeInt := ^NativeInt(rtl.MapViewOfFile(fMapping, rtl.FILE_MAP_WRITE, 0, 0, 8));
        if p = nil then begin
          LocalGC;
          raise new Exception('Cannot create file mapping for memory sharing, this should not happen!');
        end;
        if lNew then begin
          LocalGC;
          InternalCalls.VolatileWrite(var p^, NativeInt(@Utilities.fSharedMemory));
        end else begin
          loop begin
            var lData: ^SharedMemory := ^SharedMemory(InternalCalls.VolatileRead(var p^));
            if lData = nil then Thread.Sleep(1) else begin
              Utilities.fSharedMemory := lData^;
              break;
            end;
          end;
        end;
        rtl.UnmapViewOfFile(p);
        if not lNew then begin
          rtl.CloseHandle(fMapping);
          fMapping := rtl.INVALID_HANDLE_VALUE;
        end;
        {$ELSE}
        LocalGC;
        {$ENDIF}
      finally
        Utilities.SpinLockExit(var fLock);
      end;
    end;

    method SetFinalizer(aVal: ^Void);
    begin
      GC_register_finalizer_no_order(aVal, @GC_finalizer, nil, nil, nil);
    end;

    method UnsetFinalizer(aVal: ^Void);
    begin
      GC_register_finalizer_no_order(aVal, nil, nil, nil, nil);
    end;

    method GC_my_register_my_thread: Integer;
    begin 
      var sb: __struct_GC_stack_base;
      GC_get_stack_base(@sb);
      exit GC_register_my_thread(@sb);
    end;

  public
    class method Collect(c: Integer);
    begin
      for i: Integer := 0 to c -1 do
        Utilities.fSharedMemory.collect;
    end;

    [SymbolName('registerthread')]
    method RegisterThread: Boolean;
    begin 
      exit Utilities.fSharedMemory.register() = GC_SUCCESS;
    end;

    [SymbolName('unregisterthread')]
    method UnregisterThread; 
    begin 
      Utilities.fSharedMemory.unregister;
    end;
  end;

end.