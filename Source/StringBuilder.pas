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
      for i: Integer := StartIndex to Count-Value_Length do begin
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
      memcpy(Dest, Source, NativeUInt(CharCount)*sizeOfChar);
    end;

    method IntMove(SourceIndex, DestIndex: Int32;  CharCount: Integer);
    begin
      if CharCount = 0 then exit;
      memmove(@fBuf[DestIndex], @fBuf[SourceIndex], NativeUInt(CharCount)*sizeOfChar);
    end;

    method CalcCapacity(aNewCapacity: Integer): Integer;
    begin
      if aNewCapacity > MaxCapacity then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      var lDelta: Integer;
      if aNewCapacity > 64 then lDelta := aNewCapacity / 4
      else if aNewCapacity > 8 then lDelta := 16
      else lDelta := 4;
      if lDelta > MaxCapacity - aNewCapacity then exit MaxCapacity;
      exit aNewCapacity + lDelta;
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
      if value > fLength then
        memset(@fBuf[fLength], 0, NativeUInt(value - fLength) * sizeOfChar);
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
      Grow(value);
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
           ((fLength = 0) or (memcmp(@fBuf[0], @sb.fBuf[0], NativeInt(fLength) * sizeOfChar) = 0));
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

    method Append(Value: String): not nullable StringBuilder;
    begin
      if not String.IsNullOrEmpty(Value) then
        exit Append(Value, 0, Value.Length)
      else
        exit self;
    end;
    [DisableInlining]
    method Append(Value: String; StartIndex, Count: Integer): not nullable StringBuilder;
    begin
      if String.IsNullOrEmpty(Value) and (StartIndex = 0) and (Count = 0) then exit self;
      if String.IsNullOrEmpty(Value) then RaiseError('Value is null') ;
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex > Value.Length) or (Count > Value.Length - StartIndex) then RaiseError('StartIndex + Count is greater than the length of value.');
      if (Count > MaxCapacity - self.Length) then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      var old_Length:=Length;
      if Count > fCapacity - fLength then Grow(CalcCapacity(fLength + Count));
      inc(fLength, Count);
      if Count > 0 then
        intCopy(Value.FirstChar + StartIndex, @fBuf[old_Length], Count);
      exit self;
    end;

    method Append(Value: Char; RepeatCount: Integer): not nullable StringBuilder;
    begin
      if (RepeatCount = 0) then exit self;
      if (RepeatCount < 0) then RaiseError('RepeatCount less than zero') ;
      if (RepeatCount > MaxCapacity - self.Length) then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      var old_Length := Length;
      if RepeatCount > fCapacity - fLength then Grow(CalcCapacity(fLength + RepeatCount));
      inc(fLength, RepeatCount);
      // Length has validated and reserved the complete destination range.
      var lDest := @fBuf[old_Length];
      for i: Integer := 0 to RepeatCount-1 do
        lDest[i] := Value;
      exit self;
    end;

    method Append(Value: Char): not nullable StringBuilder;
    begin
      if fLength = MaxCapacity then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
      if fLength = fCapacity then Grow(CalcCapacity(fLength + 1));
      inc(fLength);
      fBuf[fLength - 1] := Value;
      exit self;
    end;

    method AppendLine: not nullable StringBuilder;
    begin
      exit Append(Environment.NewLine);
    end;

    method AppendLine(Value: String): not nullable StringBuilder;
    begin
      Append(Value);
      exit Append(Environment.NewLine);
    end;

    method Append(o: Object): not nullable StringBuilder;
    begin
      exit Append(o:ToString);
    end;

    method Clear;
    begin
      Length := 0;
    end;

    method &Remove(StartIndex, Count: Integer): not nullable StringBuilder;
    begin
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex > Length) or (Count > Length - StartIndex) then RaiseError('StartIndex + Count is greater than the length');
      if Count = 0 then exit self;
      if StartIndex+Count < Length then
        IntMove(StartIndex+Count, StartIndex, Length-(StartIndex+Count));
      Length := Length - Count;
      exit self;
    end;

    method Replace(OldChar: Char; NewChar: Char; StartIndex: Integer; Count: Integer): not nullable StringBuilder;
    begin
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex > Length) or (Count > Length - StartIndex) then RaiseError('StartIndex + Count is greater than the length');
      for i: Integer := StartIndex to StartIndex + Count - 1 do
        if fBuf[i] = OldChar then fBuf[i] := NewChar;
      exit self;
    end;

    method Replace(OldValue: String; NewValue: String; StartIndex: Integer; Count: Integer): not nullable StringBuilder;
    begin
      if String.IsNullOrEmpty(OldValue) then RaiseError('OldValue is null') ;
      if OldValue.Length = 0 then RaiseError('The length of OldValue is zero.');
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex > Length) or (Count > Length - StartIndex) then RaiseError('StartIndex + Count is greater than the length');
      if String.IsNullOrEmpty(NewValue) then NewValue := '';
      var oldLen := OldValue.Length;
      var newLen := NewValue.Length;

      var rangeEnd := StartIndex + Count;
      var idx := intIndexOf(OldValue, StartIndex, rangeEnd);
      if idx = -1 then exit self;
      if oldLen >= newLen then begin
        // Compact in place; reads always remain ahead of writes.
        var readPos := idx;
        var writePos := idx;
        repeat
          var unchanged := idx - readPos;
          IntMove(readPos, writePos, unchanged);
          inc(writePos, unchanged);
          if newLen > 0 then intCopy(NewValue.FirstChar, @fBuf[writePos], newLen);
          inc(writePos, newLen);
          readPos := idx + oldLen;
          idx := intIndexOf(OldValue, readPos, rangeEnd);
        until idx = -1;
        IntMove(readPos, writePos, fLength - readPos);
        fLength := writePos + fLength - readPos;
      end
      else begin
        // Count first, then copy once into a single destination buffer. This
        // avoids temporary strings/character arrays and repeated tail shifts.
        var matches := 0;
        var next := idx;
        repeat
          inc(matches);
          next := intIndexOf(OldValue, next + oldLen, rangeEnd);
        until next = -1;
        var delta := newLen - oldLen;
        if matches > (MaxCapacity - fLength) / delta then RaiseError('Enlarging the value of this instance would exceed MaxCapacity');
        var newLength := fLength + matches * delta;
        if (matches = 1) and (newLength <= fCapacity) then begin
          // One edit needs at most one overlapping tail move. Reuse reserved
          // space instead of allocating and copying the unchanged prefix too.
          IntMove(idx + oldLen, idx + newLen, fLength - idx - oldLen);
          intCopy(NewValue.FirstChar, @fBuf[idx], newLen);
          fLength := newLength;
          exit self;
        end;
        var newCapacity := if newLength > fCapacity then CalcCapacity(newLength) else fCapacity;
        var newbuf := new Char[newCapacity];
        var readPos := 0;
        var writePos := 0;
        repeat
          var unchanged := idx - readPos;
          if unchanged > 0 then intCopy(@fBuf[readPos], @newbuf[writePos], unchanged);
          inc(writePos, unchanged);
          intCopy(NewValue.FirstChar, @newbuf[writePos], newLen);
          inc(writePos, newLen);
          readPos := idx + oldLen;
          idx := intIndexOf(OldValue, readPos, rangeEnd);
        until idx = -1;
        if readPos < fLength then intCopy(@fBuf[readPos], @newbuf[writePos], fLength - readPos);
        fBuf := newbuf;
        fLength := newLength;
        fCapacity := newCapacity;
      end;
      exit self;
    end;

    method Replace(OldChar: Char; NewChar: Char): not nullable StringBuilder;
    begin
      exit Replace(OldChar, NewChar, 0, Length);
    end;

    method Replace(OldValue: String; NewValue: String): not nullable StringBuilder;
    begin
      exit Replace(OldValue, NewValue, 0, Length);
    end;

    method ToString: not nullable String; override;
    begin
      if fLength = 0 then
        exit '';
      exit String.FromPChar(@fBuf[0], fLength) as not nullable;
    end;

    method ToString(StartIndex, Count: Integer): not nullable String;
    begin
      if (Count < 0) then RaiseError('Count less than zero') ;
      if (StartIndex < 0) then RaiseError('StartIndex less than zero') ;
      if (StartIndex > Length) or (Count > Length - StartIndex) then RaiseError('StartIndex + Count is greater than the length');
      if Count = 0 then exit '';
      exit String.FromPChar(@fBuf[StartIndex], Count) as not nullable;
    end;

    method Insert(Offset: Integer; Value: String): not nullable StringBuilder;
    begin
      if (Offset < 0) or (Offset > fLength) then RaiseError('Offset is outside the current text');
      if String.IsNullOrEmpty(Value) then exit self;
      if Value.Length > MaxCapacity - fLength then RaiseError('The current length of this StringBuilder object plus the length of value exceeds MaxCapacity.');
      var newLength := fLength + Value.Length;
      if newLength > fCapacity then Grow(CalcCapacity(newLength));
      IntMove(Offset, Offset + Value.Length, fLength - Offset);
      intCopy(Value.FirstChar, @fBuf[Offset], Value.Length);
      fLength := newLength;
      exit self;
    end;

    method EnsureCapacity(aCapacity: Integer): Integer;
    begin
      if (aCapacity < 0) then RaiseError('aCapacity less than zero') ;
      if (aCapacity > MaxCapacity) then RaiseError('Enlarging the value of this instance would exceed MaxCapacity.');
      if aCapacity > Capacity then Capacity := aCapacity;
      exit fCapacity;
    end;

    property Capacity: Integer read fCapacity write SetCapacity;
    property Length: Integer read fLength write SetLength;
    property Chars[&Index: Integer]: Char read GetChars write SetChars; default;
  end;

end.