namespace RemObjects.Elements.System;

{$HIDE W46}
{$HIDE W37}

{.$DEFINE DEBUG_UTF8}

type

  {
  UTF8:
  00000000-0000007F   1   7    0xxxxxxx
  00000080-000007FF   2   11   110xxxxx 10xxxxxx
  00000800-0000FFFF   3   16   1110xxxx 10xxxxxx 10xxxxxx
  00010000-001FFFFF   4   21   11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
  00200000-03FFFFFF   5   26   111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
  04000000-7FFFFFFF   6   31   1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
  }

  [Obsolete("Use Encoding")]
  TextConvert = static public class
  private
    {$IFDEF DEBUG_UTF8}
    class method DebugLog(InputString: String; CurPos: Integer; Len: Integer; Decoded : Char);
    begin
      var s := 'pos = '+CurPos.ToString+'; '+Len+'ch input: '+InputString.Substring(CurPos,Len)+' ; output = '+Decoded;
      //writeLn(s);
    end;
    {$ENDIF}
    class method MalformedError;
    begin
      {$IFDEF DEBUG_UTF8}
      writeln('malformed String is detected');
      {$ELSE}
      raise new Exception('malformed String is detected');
      {$ENDIF}
    end;
    class method BadUTF8Error;
    begin
      {$IFDEF DEBUG_UTF8}
      writeLn('bad UTF8 String is detected');
      {$ELSE}
      raise new Exception('bad UTF8 String is detected');
      {$ENDIF}
    end;
    class method BadStringError;
    begin
      {$IFDEF DEBUG_UTF8}
      writeLn('bad String is detected');
      {$ELSE}
      raise new Exception('bad String is detected');
      {$ENDIF}
    end;
    class method BadArray;
    begin
      {$IFDEF DEBUG_UTF8}
      writeLn('bad array length is detected');
      {$ELSE}
      raise new Exception('bad array length is detected');
      {$ENDIF}
    end;
  assembly
    {$IFDEF POSIX_LIGHT AND NOT ANDROID}
    class var fUTF16ToCurrent, fCurrentToUtf16: rtl.iconv_t;
    {$ENDIF}
  public
    {$IFDEF POSIX and not ANDROID}
    class constructor;
    begin
      rtl.setlocale(rtl.LC_ALL, "");
      fUTF16ToCurrent := rtl.iconv_open("", "UTF-16LE");
      fCurrentToUtf16 := rtl.iconv_open("UTF-16LE", "");
    end;
    {$ENDIF}

    class method StringToUTF8(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if aValue = '' then exit new array of Byte(0);
      var len := aValue.Length;
      var arr:= new array of Byte(len*4 + iif(aGenerateBOM,3,0));
      var pos := 0;
      var pos1 := 0;
      // write BOM
      if aGenerateBOM then begin
        arr[0] := $EF;
        arr[1] := $BB;
        arr[2] := $BF;
        pos1 := 3;
      end;
      while pos < len do begin
        var code := UInt32(aValue[pos]);
        case code of
          0..$7F: begin  // 0xxxxxxx
            arr[pos1] := Byte(code);
            inc(pos1);
          end;
          $80..$7FF: begin  // 110xxxxx 10xxxxxx
            arr[pos1]   := $C0 or (code shr 6);
            arr[pos1+1] := $80 or (code and $3F);
            inc(pos1,2);
          end;
          $800..$FFFF: begin //1110xxxx 10xxxxxx 10xxxxxx
            if (($D800 <= code) and (code <= $DBFF)) then begin
              if pos+1>=len then MalformedError;
              var code1 := UInt32(aValue[pos+1]);
              if not (($DC00 <= code1) and (code1 <= $DFFF)) then MalformedError;
              //$10000..$1FFFFF,  11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
              code := $10000 + (code and $03FF) shl 10 + code1 and $03FF;
              arr[pos1]   := $F0 or (code shr 18);
              arr[pos1+1] := $80 or ((code shr 12) and $3F);
              arr[pos1+2] := $80 or ((code shr 6) and $3F);
              arr[pos1+3] := $80 or (code and $3F);
              inc(pos1,4);
              inc(pos);
            end
            else begin
              arr[pos1]   := $E0 or (code shr 12);
              arr[pos1+1] := $80 or ((code shr 6) and $3F);
              arr[pos1+2] := $80 or (code and $3F);
              inc(pos1,3);
            end;
          end;
        else
          BadStringError;
        end;
        inc(pos);
      end;
      var r := new array of Byte(pos1);
      memcpy(@r[0], @arr[0], pos1);
      exit r;
    end;

    class method StringToUTF16(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      exit StringToUTF16LE(aValue, aGenerateBOM);
    end;

    class method StringToUTF16BE(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if aValue = '' then exit new array of Byte(0);
      var len := aValue.Length;
      var arr := new array of Byte(len*2 + iif(aGenerateBOM, 2, 0));
      var pos: Integer := 0;
      if aGenerateBOM then begin
        arr[0] := $FE;
        arr[1] := $FF;
        inc(pos,2);
      end;
      for i: Integer := 0 to len-1 do begin
        var ch := UInt16(aValue[i]);
        arr[pos] := ch shr 8;
        arr[pos+1] := ch and $FF;
        inc(pos,2);
      end;
      exit arr;
    end;

    class method StringToUTF16LE(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if aValue = '' then exit new array of Byte(0);
      var len := aValue.Length;
      var arr := new array of Byte(len*2 + iif(aGenerateBOM, 2, 0));
      var pos: Integer := 0;
      if aGenerateBOM then begin
        arr[0] := $FF;
        arr[1] := $FE;
        inc(pos,2);
      end;
      for i: Integer := 0 to len-1 do begin
        var ch := UInt16(aValue[i]);
        arr[pos] := ch and $FF;
        arr[pos+1] := ch shr 8;
        inc(pos,2);
      end;
      exit arr;
    end;

    class method StringToUTF32(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      exit StringToUTF32LE(aValue,aGenerateBOM);
    end;

    class method StringToUTF32BE(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if aValue = '' then exit new array of Byte(0);
      var len := aValue.Length;
      var arr :=  new array of Byte(len*4+iif(aGenerateBOM, 4, 0));
      var pos: Integer := 0;
      var pos1:Integer := 0;
      if aGenerateBOM then begin
        arr[0]:= $00;
        arr[1]:= $00;
        arr[2]:= $FE;
        arr[3]:= $FF;
        inc(pos1,4);
      end;
      while pos < len do begin
        var code := UInt32(aValue[pos]);
        if (($D800 <= code) and (code <= $DBFF)) then begin
          if pos+1>=len then MalformedError;
          var code1 := UInt32(aValue[pos+1]);
          if not (($DC00 <= code1) and (code1 <= $DFFF)) then MalformedError;
          code := $10000 + (code and $03FF) shl 10 + code1 and $03FF;
          inc(pos);
        end;
        arr[pos1] := (code shr 24) and $FF;
        arr[pos1+1] := (code shr 16) and $FF;
        arr[pos1+2] := (code shr 8) and $FF;
        arr[pos1+3] := code and $FF;
        inc(pos1,4);
        inc(pos);
      end;
      var r := new array of Byte(pos1);
      memcpy(@r[0], @arr[0], pos1);
      exit r;
    end;

    class method StringToUTF32LE(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if aValue = '' then exit new array of Byte(0);
      var len := aValue.Length;
      var arr :=  new array of Byte(len*4+iif(aGenerateBOM, 4, 0));
      var pos: Integer := 0;
      var pos1:Integer := 0;
      if aGenerateBOM then begin
        arr[0]:= $FF;
        arr[1]:= $FE;
        arr[2]:= $00;
        arr[3]:= $00;
        inc(pos1,4);
      end;
      while pos < len do begin
        var code := UInt32(aValue[pos]);
        if (($D800 <= code) and (code <= $DBFF)) then begin
          if pos+1>=len then MalformedError;
          var code1 := UInt32(aValue[pos+1]);
          if not (($DC00 <= code1) and (code1 <= $DFFF)) then MalformedError;
          code := $10000 + (code and $03FF) shl 10 + code1 and $03FF;
          inc(pos);
        end;
        arr[pos1] := code and $FF;
        arr[pos1+1] := (code shr 8) and $FF;
        arr[pos1+2] := (code shr 16) and $FF;
        arr[pos1+3] := (code shr 24) and $FF;
        inc(pos1,4);
        inc(pos);
      end;
      var r := new array of Byte(pos1);
      memcpy(@r[0], @arr[0], pos1);
      exit r;
    end;

    class method UTF8ToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF8ToString(aValue, 0, length(aValue));
    end;

    class method UTF8ToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if len = 0 then exit '';
      var str:= new StringBuilder(len);
      var pos := aOffset;
      var last := len + aOffset;

      // skip BOM
      if len > pos+2 then
        if (aValue[pos] = $EF) and (aValue[pos+1] = $BB) and (aValue[pos+2] = $BF) then inc(pos, 3);

      while pos < last do begin
        var ch := aValue[pos];
        {$REGION 4 bytes Char}
        if ch and $F0 = $F0 then begin
          //   11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
          if pos+4 > last then BadUTF8Error;
          var code := (((((
                        UInt32(ch and $7) shl 6 +
                        (UInt32(aValue[pos+1]) and $3F)) shl 6)+
                        (UInt32(aValue[pos+2]) and $3F)) shl 6)+
                        (UInt32(aValue[pos+3]) and $3F));
          if (code < $10000) or (code>$1FFFFF) then MalformedError;
          {$IFDEF DEBUG_UTF8}
          DebugLog(aValue,pos,4,Char(code));
          {$ENDIF}
          var code1 := code - $10000;
          str.Append(Char($D800 or (code1 shr 10)));
          str.Append(Char($DC00 or (code1 and $3FF)));
          inc(pos,4);
        end
        {$ENDREGION}
        {$REGION 3 bytes Char}
        else if (ch and $E0) = $E0 then begin
          //1110xxxx 10xxxxxx 10xxxxxx
          if pos+3 > last then BadUTF8Error;
          var code := ((
                        UInt32(ch and $F) shl 6 +
                        (UInt32(aValue[pos+1]) and $3F)) shl 6)+
                        (UInt32(aValue[pos+2]) and $3F);
          if (code < $800) or (code > $FFFF) then MalformedError;
          {$IFDEF DEBUG_UTF8}
          DebugLog(aValue,pos,3,Char(code));
          {$ENDIF}
          str.Append(Char(code));
          inc(pos,3);
        end
        {$ENDREGION}
        {$REGION 2 bytes Char}
        else if (ch and $C0) = $C0 then begin
          // 110xxxxx 10xxxxxx
          if pos+2 > last then BadUTF8Error;
          var code :=
                      UInt32(ch and $1F) shl 6 +
                      (UInt32(aValue[pos+1]) and $3F);
          if (code < $80) or (code >$7FF) then MalformedError;
          {$IFDEF DEBUG_UTF8}
          DebugLog(aValue,pos,2,Char(code));
          {$ENDIF}
          str.Append(Char(code));
          inc(pos,2);
        end
        {$ENDREGION}
        {$REGION 1 Byte Char}
        else begin
          // 0xxxxxxx
          var code := ch;
          if (code < $0)  or (code > $7F) then MalformedError;
          {$IFDEF DEBUG_UTF8}
          DebugLog(aValue,pos,1,Char(code));
          {$ENDIF}
          str.Append(Char(code));
          inc(pos,1);
        end;
        {$ENDREGION}
      end;
      exit str.ToString;
    end;

    class method UTF16ToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF16ToString(aValue, 0, length(aValue));
    end;

    class method UTF16ToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String; inline;
    begin
      exit UTF16LEToString(aValue, aOffset, len);
    end;

    class method UTF16BEToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF16BEToString(aValue, 0, length(aValue));
    end;

    class method UTF16BEToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if len = 0 then exit '';
      var len2 := len/2;
      if len - len2*2 = 1 then BadArray;
      var str := new StringBuilder(len2);
      var start := aOffset;
      if len>1 then begin
        if (aValue[0] = $FE) and (aValue[1] = $FF) then
          inc(start,1);
      end;
      for i: Integer :=start to len2 - 1 do
        str.Append(Char(aValue[i*2] shl 8 + aValue[i*2+1]));
      exit str.ToString;
    end;

    class method UTF16LEToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF16LEToString(aValue, 0, length(aValue));
    end;

    class method UTF16LEToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if len = 0 then exit '';
      var len2 := len/2;
      if len - len2*2 = 1 then BadArray;
      var str := new StringBuilder(len2);
      var start := aOffset;
      if len>1 then begin
        if (aValue[0] = $FF) and (aValue[1] = $FE) then
          inc(start,1);
      end;
      for i: Integer := start to len2 - 1 do
        str.Append(Char(aValue[i*2] + aValue[i*2+1] shl 8));
      exit str.ToString;
    end;

    class method UTF32ToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF32ToString(aValue, 0, length(aValue));
    end;

    class method UTF32ToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String; inline;
    begin
      exit UTF32LEToString(aValue, aOffset, len);
    end;

    class method UTF32BEToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF32BEToString(aValue, 0, length(aValue));
    end;

    class method UTF32BEToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if len = 0 then exit '';
      if len - (len /4)*4 > 0 then BadArray;
      var str:= new StringBuilder;
      var idx := aOffset;
      // ignore BOM
      if len>3 then begin
        if (aValue[0]=$00) and
           (aValue[1]=$00) and
           (aValue[2]=$FE) and
           (aValue[3]=$FF) then inc(idx,4) ;
      end;
      while idx < len do begin
        var code:UInt32 :=  aValue[idx] shl 24 +
                            aValue[idx+1] shl 16 +
                            aValue[idx+2] shl 8 +
                            aValue[idx+3] ;
        if code < $10000 then begin
          //$0000-$FFFF
          str.Append(Char(code));
        end
        else if (code <=$10FFFF) then begin
          //00010000-001FFFFF
          var code1 := code - $10000;
          str.Append(Char($DC00 or (code1 and $3FF)));
          str.Append(Char($D800 or (code1 shr 10)));
        end
        else begin
          MalformedError;
        end;
        inc(idx, 4);
      end;
      exit str.ToString;
    end;

    class method UTF32LEToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := UTF32LEToString(aValue, 0, length(aValue));
    end;

    class method UTF32LEToString(aValue: array of Byte; aOffset: Integer; len: Integer): not nullable String;
    begin
      if aValue = nil then new ArgumentNullException('aValue is nil');
      if len = 0 then exit '';
      if len - (len/4)*4 > 0 then BadArray;
      var str:= new StringBuilder(len/2);
      var idx := aOffset;
      // ignore BOM
      if len>3 then begin
        if (aValue[0]=$FF) and
           (aValue[1]=$FE) and
           (aValue[2]=$00) and
           (aValue[3]=$00) then inc(idx,4) ;
      end;
      while idx < len do begin
        var code:UInt32 :=  aValue[idx] +
                            aValue[idx+1] shl 8 +
                            aValue[idx+2] shl 16 +
                            aValue[idx+3] shl 24;
        if code < $10000 then begin
          //$0000-$FFFF
          str.Append(Char(code));
        end
        else if (code <=$10FFFF) then begin
          //00010000-001FFFFF
          var code1 := code - $10000;
          str.Append(Char($D800 or (code1 shr 10)));
          str.Append(Char($DC00 or (code1 and $3FF)));
        end
        else begin
          MalformedError;
        end;
        inc(idx, 4);
      end;
      exit str.ToString;
    end;

    class method StringToASCII(aValue: String): not nullable array of Byte;
    begin
      {$IFDEF WINDOWS}
      var len := rtl.WideCharToMultiByte(rtl.CP_ACP, 0, aValue.FirstChar, aValue.Length, nil, 0, nil, nil);
      result := new Byte[len];
      rtl.WideCharToMultiByte(rtl.CP_ACP, 0, aValue.FirstChar, aValue.Length, rtl.LPSTR(@result[0]), len, nil, nil);
      {$ELSEIF ANDROID}
      var b := StringToUTF8(aValue, false);
      result := new Byte[b.Length];
      rtl.memcpy(@result[0], @b[0], b.Length);
      {$ELSEIF WebAssembly}
      var b := StringToUTF8(aValue, false);
      result := new Byte[b.Length];
      memcpy(@result[0], @b[0], b.Length);
      {$ELSE}
      var lNewData: ^AnsiChar := nil;
      var lNewLen: rtl.size_t := iconv_helper(TextConvert.fUTF16ToCurrent, ^AnsiChar(aValue.FirstChar), aValue.Length * 2, aValue.Length + 5, out lNewData);

      if lNewLen <> -1 then begin
        result := new Byte[lNewLen];
        rtl.memcpy(@result[0], lNewData, lNewLen);
        rtl.free(lNewData);
      end
      else begin
        result := new Byte[0];
      end;
      {$ENDIF}
    end;

    class method ASCIIToString(aValue: array of Byte): not nullable String; inline;
    begin
      result := ASCIIToString(aValue, 0, length(aValue));
    end;

    class method ASCIIToString(aValue: array of Byte; aOffset: Integer; aCount: Integer): not nullable String;
    begin
      if aValue = nil then exit "";
      if aCount = 0 then exit "";
      {$IFDEF WINDOWS}
      var len := rtl.MultiByteToWideChar(rtl.CP_ACP, 0, rtl.LPCCH(@aValue[aOffset]), aCount, nil, 0);
      result := String.AllocString(len);
      rtl.MultiByteToWideChar(rtl.CP_ACP, 0, rtl.LPCCH(@aValue[aOffset]), aCount, @result.fFirstChar, len);
      {$ELSEIF ANDROID or WebAssembly}
      exit TextConvert.UTF8ToString(aValue, aOffset, aCount);
      {$ELSE}
      var lNewData: ^AnsiChar := nil;
      var lNewLen: rtl.size_t := iconv_helper(TextConvert.fCurrentToUtf16, ^AnsiChar(@aValue[aOffset]), aCount, aCount * 2 + 5, out lNewData);
      // method iconv_helper(cd: rtl.iconv_t; inputdata: ^AnsiChar; inputdatalength: rtl.size_t;outputdata: ^^AnsiChar; outputdatalength: ^rtl.size_t; suggested_output_length: Integer): Integer;
      if lNewLen <> -1  then begin
        result := String.FromPChar(^Char(lNewData), lNewLen / 2);
        rtl.free(lNewData);
      end
      else begin
        result := "";
      end;
      {$ENDIF}
    end;

end;

end.