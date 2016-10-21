namespace RemObjects.Elements.System;

{.$DEFINE DEBUG_UTF8}
type

  {
  UTF8:
  00000000-0000007F   1   7   0xxxxxxx
  00000080-000007FF   2   11   110xxxxx 10xxxxxx
  00000800-0000FFFF   3   16   1110xxxx 10xxxxxx 10xxxxxx
  00010000-001FFFFF   4   21   11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
  00200000-03FFFFFF   5   26   111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
  04000000-7FFFFFFF   6   31   1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
  }
  
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
      writeln('malformed string is detected');
      {$ELSE}
      raise new Exception('malformed string is detected');
      {$ENDIF}
    end;
    class method BadUTF8Error;
    begin
      {$IFDEF DEBUG_UTF8}
      writeLn('bad UTF8 string is detected');
      {$ELSE}
      raise new Exception('bad UTF8 string is detected');
      {$ENDIF}
    end;
    class method BadStringError;
    begin
      {$IFDEF DEBUG_UTF8}
      writeLn('bad string is detected');
      {$ELSE}
      raise new Exception('bad string is detected');
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
  protected
  public
    class method StringToUTF8(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      if Value = '' then exit new array of Byte(0);
      var len := Value.Length;
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
        var code := UInt32(Value[pos]);
        case code of
          0..$7F: begin  // 0xxxxxxx
            arr[pos1] := byte(code);  
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
              var code1 := UInt32(Value[pos+1]);
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
      {$IFDEF WINDOWS}ExternalCalls.{$ELSEIF POSIX}rtl.{$ELSE}{$ERROR}{$ENDIF}memcpy(@r[0], @arr[0], pos1);
      exit r;
    end;

    class method StringToUTF16(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      exit StringToUTF16LE(Value, aGenerateBOM);
    end;

    class method StringToUTF16BE(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      if Value = '' then exit new array of Byte(0);
      var len := Value.Length;
      var arr := new array of Byte(len*2 + iif(aGenerateBOM, 2, 0));
      var pos: Integer := 0;
      if aGenerateBOM then begin
        arr[0] := $FE;
        arr[1] := $FF;
        inc(pos,2);
      end;
      for i: Integer := 0 to len-1 do begin
        var ch := UInt16(Value[i]);
        arr[pos] := ch shr 8;
        arr[pos+1] := ch and $FF;        
        inc(pos,2);
      end;
      exit arr;
    end;

    class method StringToUTF16LE(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      if Value = '' then exit new array of Byte(0);
      var len := Value.Length;
      var arr := new array of Byte(len*2 + iif(aGenerateBOM, 2, 0));
      var pos: Integer := 0;
      if aGenerateBOM then begin
        arr[0] := $FE;
        arr[1] := $FF;
        inc(pos,2);
      end;
      for i: Integer := 0 to len-1 do begin
        var ch := UInt16(Value[i]);
        arr[pos] := ch and $FF;
        arr[pos+1] := ch shr 8;
        inc(pos,2);
      end;
      exit arr;
    end;

    class method StringToUTF32(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      exit StringToUTF32LE(Value,aGenerateBOM);
    end;

    class method StringToUTF32BE(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      if Value = '' then exit new array of Byte(0);
      var len := Value.Length;
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
        var code := UInt32(Value[pos]);
        if (($D800 <= code) and (code <= $DBFF)) then begin
          if pos+1>=len then MalformedError;
          var code1 := UInt32(Value[pos+1]);
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
      {$IFDEF WINDOWS}ExternalCalls.{$ELSEIF POSIX}rtl.{$ELSE}{$ERROR}{$ENDIF}memcpy(@r[0], @arr[0], pos1);
      exit r;
    end;

    class method StringToUTF32LE(Value: String; aGenerateBOM: Boolean := False): array of Byte;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      if Value = '' then exit new array of Byte(0);
      var len := Value.Length;
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
        var code := UInt32(Value[pos]);
        if (($D800 <= code) and (code <= $DBFF)) then begin
          if pos+1>=len then MalformedError;
          var code1 := UInt32(Value[pos+1]);
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
      {$IFDEF WINDOWS}ExternalCalls.{$ELSEIF POSIX}rtl.{$ELSE}{$ERROR}{$ENDIF}memcpy(@r[0], @arr[0], pos1);
      exit r;
    end;

    class method UTF8ToString(Value: array of Byte): String;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      var len := length(Value);
      if len = 0 then exit '';
      var str:= new StringBuilder(len);      
      var pos:Integer := 0;      
      // skip BOM
      if len>2 then begin        
        if (Value[0] = $EF) and 
           (Value[1] = $BB) and 
           (Value[2] = $BF) then pos := 3; 
      end;
      while pos < len do begin
        var ch := Value[pos];
        {$REGION 4 bytes char}
        if ch and $F0 = $F0 then begin
          //   11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
          if pos+4 > len then BadUTF8Error;
          var code := (((((
                        UInt32(ch and $7) shl 6 + 
                        (UInt32(Value[pos+1]) and $3F)) shl 6)+
                        (UInt32(Value[pos+2]) and $3F)) shl 6)+
                        (UInt32(Value[pos+3]) and $3F));
          if (code < $10000) or (code>$1FFFFF) then MalformedError;
          {$IFDEF DEBUG_UTF8}          
          DebugLog(Value,pos,4,Char(code));
          {$ENDIF}
          var code1 := code - $10000;
          str.Append(Char($D800 or (code1 shr 10)));
          str.Append(Char($DC00 or (code1 and $3FF)));
          inc(pos,4);
        end
        {$ENDREGION}
        {$REGION 3 bytes char}
        else if (ch and $E0) = $E0 then begin
          //1110xxxx 10xxxxxx 10xxxxxx
          if pos+3 > len then BadUTF8Error;
          var code := ((
                        UInt32(ch and $F) shl 6 + 
                        (UInt32(Value[pos+1]) and $3F)) shl 6)+
                        (UInt32(Value[pos+2]) and $3F);
          if (code < $800) or (code > $FFFF) then MalformedError;
          {$IFDEF DEBUG_UTF8}          
          DebugLog(Value,pos,3,Char(code));
          {$ENDIF}
          str.Append(Char(code));
          inc(pos,3);
        end
        {$ENDREGION}      
        {$REGION 2 bytes char}
        else if (ch and $C0) = $C0 then begin
          // 110xxxxx 10xxxxxx
          if pos+2 > len then BadUTF8Error;
          var code := 
                      UInt32(ch and $1F) shl 6 + 
                      (UInt32(Value[pos+1]) and $3F);
          if (code < $80) or (code >$7FF) then MalformedError;
          {$IFDEF DEBUG_UTF8}          
          DebugLog(Value,pos,2,Char(code));
          {$ENDIF}
          str.Append(Char(code));
          inc(pos,2);
        end
        {$ENDREGION}      
        {$REGION 1 byte char}
        else if (ch or $7f) = $7f then begin
          // 0xxxxxxx
          var code := ch;                        
          if (code < $0)  or (code > $7F) then MalformedError;
          {$IFDEF DEBUG_UTF8}          
          DebugLog(Value,pos,1,Char(code));
          {$ENDIF}
          str.Append(Char(code));
          inc(pos,1);
        end
        {$ENDREGION}    
        else begin
          BadUTF8Error;
          inc(pos);
        end;        
      end;
      exit str.ToString;
    end;

    class method UTF16ToString(Value: array of Byte): String;
    begin
      exit UTF16LEToString(Value);
    end;

    class method UTF16BEToString(Value: array of Byte): String;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      var len := length(Value);
      if len = 0 then exit '';
      var len2 := len/2;
      if len - len2*2 = 1 then BadArray;
      var str := new StringBuilder(len2);
      var start :=0;
      if len>1 then begin
        if (Value[0] = $FE) and (Value[1] = $FF) then
          inc(start,2);
      end;
      for i: Integer :=start to len2 - 1 do
        str.Append(Char(Value[i*2] shl 8 + Value[i*2+1]));
      exit str.ToString;
    end;

    class method UTF16LEToString(Value: array of Byte): String;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      var len := length(Value);
      if len = 0 then exit '';
      var len2 := len/2;
      if len - len2*2 = 1 then BadArray;
      var str := new StringBuilder(len2);
      var start :=0;
      if len>1 then begin
        if (Value[0] = $FF) and (Value[1] = $FE) then
          inc(start,2);
      end;
      for i: Integer := start to len2 - 1 do
        str.Append(Char(Value[i*2] + Value[i*2+1] shl 8));
      exit str.ToString;
    end;

    class method UTF32ToString(Value: array of Byte): String;
    begin
      exit UTF32LEToString(Value);
    end;

    class method UTF32BEToString(Value: array of Byte): String;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      var len := length(Value);
      if len - (len /4)*4 > 0 then BadArray;
      var str:= new StringBuilder;
      var idx := 0;
      // ignore BOM
      if len>3 then begin
        if (Value[0]=$00) and 
           (Value[1]=$00) and 
           (Value[2]=$FE) and 
           (Value[3]=$FF) then inc(idx,4) ;
      end;
      while idx < len do begin
        var code:UInt32 :=  Value[idx] shl 24 +
                            Value[idx+1] shl 16 +
                            Value[idx+2] shl 8 +
                            Value[idx+3] ;
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

    class method UTF32LEToString(Value: array of Byte): String;
    begin
      if Value = nil then new ArgumentNullException('Value is nil');
      var len := length(Value);
      if len - (len /4)*4 > 0 then BadArray;
      var str:= new StringBuilder;
      var idx := 0;
      // ignore BOM
      if len>3 then begin
        if (Value[0]=$FF) and 
           (Value[1]=$FE) and 
           (Value[2]=$00) and 
           (Value[3]=$00) then inc(idx,4) ;
      end;
      while idx < len do begin
        var code:UInt32 :=  Value[idx] + 
                            Value[idx+1] shl 8 +
                            Value[idx+2] shl 16 +
                            Value[idx+3] shl 24;
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
  end;
  
end.
