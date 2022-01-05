namespace RemObjects.Elements.System;

type
  CopyMode = (Start, &End);

  StringBuilder = public class
  private
    const sizeOfChar = 2;
  private
    fBuf: array of Char;
    fCapacity: Integer;
    fLength: Integer;

    method intIndexOf(OldValue: String; StartIndex: Integer; Count: Integer): Integer;
    begin
      var Value_Length := OldValue.Length;
      if Value_Length > Count-StartIndex then exit -1;
      for i: Integer := StartIndex to Count-Value_Length-1 do begin
        var lfound:= true;
        for j: Integer :=0 to Value_Length-1 do begin
          lfound:=lfound and (fBuf[i+j] = OldValue.Item[j]);
          if not lfound then break;
        end;
        if lfound then exit i;
      end;
      exit -1;
    end;

    method intCopy(Source: ^Char; Dest: ^Char; CharCount: Int32);
    begin
      if CharCount = 0 then exit;
      memcpy(Dest, Source, CharCount*sizeOfChar);
    end;

    method IntMove(SourceIndex, DestIndex: Int32;  CharCount: Integer);
    begin
      if CharCount = 0 then exit;
      memmove(@fBuf[DestIndex], @fBuf[SourceIndex], CharCount*sizeOfChar);
    end;

    method CalcCapacity(aNewCapacity: Integer): Integer;
    begin
      if aNewCapacity > MaxCapacity then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      var lDelta: Integer;
      if aNewCapacity > 64 then lDelta := aNewCapacity / 4
      else if aNewCapacity > 8 then lDelta := 16
      else lDelta := 4;
      var r := aNewCapacity + lDelta;
      exit if r > MaxCapacity then MaxCapacity else r;
    end;

    [DisableInlining]
    method Grow(Value: Integer);
    begin
      var newbuf:= new array of Char(Value);
      fCapacity := Value;
      if fLength > 0 then
        intCopy(@fBuf[0], @newbuf[0], fLength);
      fBuf := newbuf;
    end;

    [DisableInlining]
    method SetLength(value: Integer);
    begin
      if (value < 0) or (value > MaxCapacity) then raise Utilities.CreateIndexOutOfRangeException(value, MaxCapacity);
      if value > fCapacity then begin
        Grow(CalcCapacity(value));
      end;
      fLength := value;
    end;

    method SetChars(&Index: Integer; value: Char);
    begin
      if (&Index<0) or (&Index ≥ fLength) then raise Utilities.CreateIndexOutOfRangeException(&Index, fLength-1);
      fBuf[&Index] := value;
    end;

    method GetChars(&Index: Integer): Char;
    begin
      if (&Index<0) or (&Index ≥ fLength) then raise Utilities.CreateIndexOutOfRangeException(&Index, fLength-1);
      exit fBuf[&Index];
    end;

    method SetCapacity(value: Integer);
    begin
      if value = fCapacity then exit;
      if (value < fLength) or (value > MaxCapacity) then raise Utilities.CreateIndexOutOfRangeException(value, MaxCapacity);
      Grow(fCapacity);
    end;

    method RaiseError(aMessage: String);
    begin
      raise new Exception(aMessage);
    end;

  protected
  public
    const MaxCapacity: Integer = Integer.MaxValue;

    method &Equals(obj: Object): Boolean; override;
    begin
      exit (obj is StringBuilder) and &Equals(obj as StringBuilder);
    end;

    method &Equals(sb: StringBuilder): Boolean;
    begin
      exit (sb <> nil) and
           (Capacity = sb.Capacity) and
           (Length = sb.Length) and
           (ToString = sb.ToString);
    end;

    constructor;
    begin
      constructor(16);
    end;

    constructor(aCapacity: Integer);
    begin
      Capacity := aCapacity;
      fLength := 0;
    end;

    constructor(Data: String);
    begin
      constructor;
      Append(Data);
    end;

    method Append(Value: String): StringBuilder;
    begin
      if not String.IsNullOrEmpty(Value) then
        exit Append(Value, 0, Value.Length)
      else
        exit self;
    end;
    [DisableInlining]
    method Append(Value: String; StartIndex, Count: Integer): StringBuilder;
    begin
      if String.IsNullOrEmpty(Value) and (StartIndex = 0) and (Count = 0) then exit self;
      if String.IsNullOrEmpty(Value) then RaiseError('Value is null') ;
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex + Count > Value.Length) then RaiseError('StartIndex + Count is greater than the length of value.');
      if (StartIndex + Count + self.Length > MaxCapacity) then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      var old_Length:=Length;
      Length := Length + Count;
      var c := Value.ToCharArray;
      if Count > 0 then
        intCopy(@c[StartIndex], @fBuf[old_Length], Count);
      exit self;
    end;

    method Append(Value: Char; RepeatCount: Integer): StringBuilder;
    begin
      if (RepeatCount = 0) then exit self;
      if (RepeatCount < 0) then RaiseError('RepeatCount less than zero') ;
      if (RepeatCount + self.Length > MaxCapacity) then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      var arr := new array of Char(RepeatCount);
      for i: Integer := 0 to RepeatCount-1 do
        arr[i] := Value;
      exit Append(String.FromPChar(@arr[0],RepeatCount));
    end;

    method Append(Value: Char): StringBuilder;
    begin
      Length := Length + 1;
      fBuf[fLength - 1] := Value;
      exit self;
    end;

    method AppendLine: StringBuilder;
    begin
      exit Append(Environment.NewLine);
    end;

    method AppendLine(Value: String): StringBuilder;
    begin
      exit Append(Value+Environment.NewLine);
    end;

    method Append(o: Object): StringBuilder;
    begin
      exit Append(o:ToString);
    end;

    method Clear;
    begin
      Length := 0;
    end;

    method &Remove(StartIndex, Count: Integer): StringBuilder;
    begin
      if Count = 0 then exit self;
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex + Count > Length) then RaiseError('StartIndex + Count is greater than the length');
      if StartIndex+Count < Length then
        intCopy(@fBuf[StartIndex+Count], @fBuf[StartIndex], Length-(StartIndex+Count));
      Length := Length - Count;
      exit self;
    end;

    method Replace(OldChar: Char; NewChar: Char; StartIndex: Integer; Count: Integer): StringBuilder;
    begin
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex + Count > Length) then RaiseError('StartIndex + Count is greater than the length');
      for i: Integer := 0 to fLength - 1 do
        if fBuf[i] = OldChar then fBuf[i] := NewChar;
      exit self;
    end;

    method Replace(OldValue: String; NewValue: String; StartIndex: Integer; Count: Integer): StringBuilder;
    begin
      if String.IsNullOrEmpty(OldValue) then RaiseError('OldValue is null') ;
      if OldValue.Length = 0 then RaiseError('The length of OldValue is zero.');
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex + Count > Length) then RaiseError('StartIndex + Count is greater than the length');
      if String.IsNullOrEmpty(NewValue) then NewValue := '';
      var oldLen := OldValue.Length;
      var newLen := NewValue.Length;

      var idx := intIndexOf(OldValue, StartIndex, StartIndex+Count);
      if idx = -1 then exit self; // OldValue isn't found
      var old_idx := idx;
      var curpos := idx;

      if oldLen >= newLen then begin
        var NewBuf := NewValue.ToCharArray;
        repeat
          var delta := idx - old_idx;
          if delta > 0 then begin
            IntMove(old_idx, curpos, delta); // move the non-changed text
            inc(curpos, delta);
          end;
          intCopy(@NewBuf[0], @fBuf[curpos], newLen);
          inc(curpos, newLen);
          old_idx := idx + oldLen;
          idx := intIndexOf(OldValue, old_idx, StartIndex+Count);
        until idx = -1;
        IntMove(old_idx, curpos, Length-old_idx); // move the rest of non-changed text
        inc(curpos, Length-old_idx);
        Length := curpos;
      end
      else begin
        var tempStr := String.FromPChar(@fBuf[StartIndex],Count).Replace(OldValue,NewValue);
        if fLength - (StartIndex+ Count)+ tempStr.Length > MaxCapacity then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
        var newbuflen := tempStr.Length+fLength -Count;
        var tempstrbuf := tempStr.ToCharArray;
        if newbuflen >= fCapacity then begin
          // new buf is required
          var newCapacity:= CalcCapacity(newbuflen);
          var newbuf:= new array of Char(newCapacity);
          intCopy(@fBuf[0],@newbuf[0], StartIndex);
          intCopy(@tempstrbuf[0],@fBuf[StartIndex],tempstrbuf.Length);
          intCopy(@fBuf[StartIndex+Count],@newbuf[0], Length-(StartIndex+Count));
          fBuf := newbuf;
          fLength := newbuflen;
          fCapacity :=newCapacity;
        end
        else begin
          // old buf can be used
          IntMove(StartIndex+Count, StartIndex+tempstrbuf.Length,fLength-(StartIndex+Count));// move the rest into proper place
          intCopy(@tempstrbuf[0],@fBuf[StartIndex],tempstrbuf.Length);
          fLength := newbuflen;
        end;
      end;
      exit self;
    end;

    method Replace(OldChar: Char; NewChar: Char): StringBuilder;
    begin
      exit Replace(OldChar, NewChar, 0, Length);
    end;

    method Replace(OldValue: String; NewValue: String): StringBuilder;
    begin
      exit Replace(OldValue, NewValue, 0, Length);
    end;

    method ToString: String; override;
    begin
      if fLength = 0 then
        exit '';
      exit String.FromPChar(@fBuf[0], fLength);
    end;

    method ToString(StartIndex, Count: Integer): String;
    begin
      if Count = 0 then exit '';
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex + Count > Length) then RaiseError('StartIndex + Count is greater than the length');
      exit String.FromPChar(@fBuf[StartIndex], Count);
    end;

    method Insert(Offset: Integer; Value: String): StringBuilder;
    begin
      if (Offset < 0) then RaiseError('Offset less than zero') ;
      if (Offset + Value.Length > MaxCapacity) then RaiseError('The current length of this StringBuilder object plus the length of value exceeds MaxCapacity.');
      var newLength := fLength+Value.Length;
      if newLength > fCapacity then Grow(CalcCapacity(newLength));
      IntMove(Offset, Offset + Value.Length, Length - Offset);
      var c := Value.ToCharArray;
      intCopy(@c[0],  @fBuf[Offset], Value.Length);
      Length := newLength;
      exit self;
    end;

    method EnsureCapacity(aCapacity: Integer): Integer;
    begin
      if (aCapacity < 0) then RaiseError('aCapacity less than zero') ;
      if (aCapacity > MaxCapacity) then RaiseError('Enlarging the value of this instance would exceed MaxCapacity.');
      if aCapacity > Capacity then Capacity := fCapacity;
      exit fCapacity;
    end;

    property Capacity: Integer read fCapacity write SetCapacity;
    property Length: Integer read fLength write SetLength;
    property Chars[&Index: Integer]: Char read GetChars write SetChars; default;
  end;

end.