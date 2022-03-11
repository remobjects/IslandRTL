namespace RemObjects.Elements.System;

type
  // based on http://lomont.org/Math/Papers/2008/Lomont_PRNG_2008.pdf; WELLRNG512 implementation
  Random = public class
  private
  {$IFDEF WINDOWS}
  class var fHandle: rtl.HCRYPTPROV;
  {$ELSEIF POSIX}
  class var fHandle: FileStream;
  class var fLock: Monitor;
  {$ENDIF}
  var
    state: array[0..15] of UInt32;
    index: Integer;
  public
    constructor();
    begin
      constructor(DateTime.Now.Ticks / DateTime.TicksPerMillisecond);
    end;

    constructor(aSeedData: Integer);
    begin
      state[0] := aSeedData;
      // This needs to be better but this at should work.
      for i: Integer := 1 to 15 do begin
        state[i] := state[i-1] xor ((i shl (24 + (i and 5))) xor (i shl 7) xor (i shl 6) xor (i shr 2));
      end;
    end;

    constructor(aSeedData: array[0..15] of UInt32);
    begin
      memcpy(@state, @aSeedData[0], 16 * 4);
    end;

    method &Set(aVal: Cardinal);
    begin
      state[0] := aVal;
      // This needs to be better but this at should work.
      for i: Integer := 1 to 15 do begin
        state[i] := state[i-1] xor ((i shl (24 + (i and 5))) xor (i shl 7) xor (i shl 6) xor (i shr 2));
      end;
    end;

    method Random: Cardinal;
    begin
      var a: Cardinal;
      var b: Cardinal;
      var c: Cardinal;
      var d: Cardinal;
      a := state[&index];
      c := state[(&index + 13) and 15];
      b := a xor c xor (a shl 16) xor (c shl 15);
      c := state[(&index + 9) and 15];
      c := c xor (c shr 11);
      a := b xor c;
      state[&index] := a;
      d := a xor ((a shl 5) and 3661901092);
      &index := (&index + 15) and 15;
      a := state[&index];
      state[&index] := a xor b xor d xor (a shl 2) xor (b shl 18) xor (c shl 28);
      exit state[&index];
    end;

    {$IFDEF FUCHSIA}[Warning("Random.CryptoSafeRandom is not implemented for Fuchsia, yet.")]{$ENDIF}
    class method CryptoSafeRandom(aDest: array of Byte; aStart, aLength: Integer);
    begin
      if (aStart < 0) or (aStart + aLength > length(aDest)) then raise new ArgumentOutOfRangeException('start/length out of dest range!');
      {$IFDEF WINDOWS}
      if fHandle = 0 then begin
        var lNew: rtl.HCRYPTPROV;
        if not rtl.CryptAcquireContext(@lNew, nil, nil, rtl.PROV_RSA_FULL, 0) then
          if not rtl.CryptAcquireContext(@lNew, nil, nil, rtl.PROV_RSA_FULL, rtl.CRYPT_NEWKEYSET) then raise new Exception('Cannot acquire crypto provider for random bits');
        if InternalCalls.CompareExchange(var fHandle, lNew, 0) <> 0 then begin
          rtl.CryptReleaseContext(lNew, 0);
        end;
      end;
      rtl.CryptGenRandom(fHandle, aLength, @aDest[aStart]);
      {$ELSEIF POSIX}
      if fHandle = nil then begin
        var lNew := new FileStream('/dev/urandom', FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
        if InternalCalls.CompareExchange(var fHandle, lNew, nil) <> nil then
          lNew.Close;
        var lNewMutex := new Monitor;
        if InternalCalls.CompareExchange(var fLock, lNewMutex, nil) <> nil then
          lNewMutex.Dispose;
      end;
      locking fLock do begin
        loop begin
          var lLength := fHandle.Read(new Span<Byte>(@aDest[aStart], aLength));
          if lLength = 0 then raise new Exception('Internal error: read returned 0 from random device!');
          aLength := aLength - lLength;
          aStart := aStart + lLength;
          if aLength <= 0 then break;
        end;
      end;
      {$ELSEIF FUCHSIA}
      raise new NotImplementedException("Random.CryptoSafeRandom is not implemented for Fuchsia, yet.");
      {$WARNING Not Implememnted for Fuchsia yet}
      {$ELSEIF WEBASSEMBLY}
      WebAssemblyCalls.CryptoSafeRandom(@aDest[aStart], aLength);
      {$ELSE}
      {$ERROR Unsupported platform}
      {$ENDIF}
    end;
  end;

end.