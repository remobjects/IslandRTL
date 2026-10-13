// Regression guards for StringBuilder edits: preserve the text outside a range,
// include a match at its last position, and never reveal stale characters when
// Length grows. Small explicit results cover both buffer reuse and reallocation.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  StringBuilder_Edit = public class(Test)
  private
    method BuilderBuffer(aBuilder: StringBuilder): Object;
    begin
      // Check allocation behavior directly; unchanged Capacity alone does not
      // prove that Replace kept its already reserved character array.
      for each field in typeOf(StringBuilder).Fields do
        if field.Name = 'fBuf' then exit field.GetValue(aBuilder);
      raise new Exception('StringBuilder buffer missing');
    end;
  public
    method LengthGrowthClearsCharacters;
    begin
      var b := new StringBuilder('secret');
      b.Length := 2;
      b.Length := 6;
      Assert.AreEqual('se', b.ToString(0, 2));
      for i := 2 to 5 do Assert.AreEqual(Char(0), b[i]);
      b.Clear;
      b.Length := 20;
      for i := 0 to 19 do Assert.AreEqual(Char(0), b[i]);
    end;

    method CharacterReplaceHonorsRange;
    begin
      var b := new StringBuilder('aaaaa');
      b.Replace(Char('a'), Char('b'), 1, 3);
      Assert.AreEqual('abbba', b.ToString);
      b.Replace(Char('a'), Char('x'), 0, 0);
      Assert.AreEqual('abbba', b.ToString);
    end;

    method StringReplaceIncludesLastMatch;
    begin
      var b := new StringBuilder('abcabc');
      b.Replace('abc', 'x');
      Assert.AreEqual('xx', b.ToString);
      b := new StringBuilder('aababa!');
      b.Replace('aba', '', 1, 5);
      Assert.AreEqual('aba!', b.ToString);
      b := new StringBuilder('aaaaa');
      b.Replace('aa', 'b');
      Assert.AreEqual('bba', b.ToString);
      b.Replace('bba', nil);
      Assert.AreEqual('', b.ToString);
    end;

    method GrowingReplacePreservesPrefixAndSuffix;
    begin
      for each capacity in [8, 80] do begin
        var b := new StringBuilder(capacity);
        b.Append('!ab-ab?');
        b.Replace('ab', 'longer', 1, 5);
        Assert.AreEqual('!longer-longer?', b.ToString);
        b.Replace('?', 'tail');
        Assert.AreEqual('!longer-longertail', b.ToString);
      end;
    end;

    method SingleGrowingReplaceReusesReservedBuffer;
    begin
      // The replacement contains the needle: it must not be searched again.
      // Move an overlapping tail safely, including matches at either boundary.
      for each text in ['axyz', 'xyaz', 'xyza'] do begin
        var b := new StringBuilder(64);
        b.Append(text);
        var buffer := BuilderBuffer(b);
        b.Replace('a', 'aaaa');
        Assert.IsTrue(Object.ReferenceEquals(buffer, BuilderBuffer(b)));
        Assert.AreEqual(64, b.Capacity);
        Assert.AreEqual(text.Replace('a', 'aaaa'), b.ToString);
      end;
      var ranged := new StringBuilder(64);
      ranged.Append('a-a-a');
      var buffer := BuilderBuffer(ranged);
      ranged.Replace('a', 'long', 2, 1);
      Assert.AreEqual('a-long-a', ranged.ToString);
      Assert.IsTrue(Object.ReferenceEquals(buffer, BuilderBuffer(ranged)));
    end;

    method ReplacementMatchesSimpleModel;
    begin
      // Enumerate short binary texts and needles, including overlapping matches.
      // Build expected output left-to-right from the original range.
      for length := 0 to 7 do
        for bits := 0 to (1 shl length) - 1 do begin
          var chars := new Char[length];
          for i := 0 to length - 1 do chars[i] := if (bits and (1 shl i)) = 0 then 'a' else 'b';
          var text := if length = 0 then '' else new String(chars);
          for each oldValue in ['a', 'b', 'aa', 'ab', 'ba', 'aba'] do
            for each newValue in ['', 'x', 'long'] do
              for start := 0 to length do begin
                var count := length - start;
                var expected := text.Substring(0, start);
                var pos := start;
                while pos < start + count do begin
                  var match := oldValue.Length <= start + count - pos;
                  if match then
                    for j := 0 to oldValue.Length - 1 do
                      if text[pos + j] <> oldValue[j] then match := false;
                  if match then begin
                    expected := expected + newValue;
                    inc(pos, oldValue.Length);
                  end
                  else begin
                    expected := expected + text.Substring(pos, 1);
                    inc(pos);
                  end;
                end;
                var b := new StringBuilder(text);
                b.Replace(oldValue, newValue, start, count);
                Assert.AreEqual(expected, b.ToString);
              end;
        end;
    end;

    method InvalidEditsPreserveText;
    begin
      var b := new StringBuilder('keep');
      for test := 0 to 5 do begin
        var caught := false;
        try
          case test of
            0: b.Insert(5, 'x');
            1: b.Insert(-1, '');
            2: b.Remove(1, Integer.MaxValue);
            3: b.Replace(Char('k'), Char('x'), 1, Integer.MaxValue);
            4: b.Replace('k', 'x', -1, 0);
            5: b.ToString(5, 0);
          end;
        except on e: Exception do caught := true; end;
        Assert.IsTrue(caught);
        Assert.AreEqual('keep', b.ToString);
      end;
      b.Insert(4, nil);
      b.AppendLine(nil);
      Assert.AreEqual('keep' + Environment.NewLine, b.ToString);
    end;

    method InsertRemoveAndEmptyEdits;
    begin
      var b := new StringBuilder('abcdef');
      b.Remove(1, 3);
      Assert.AreEqual('aef', b.ToString);
      b.Insert(1, 'bcd');
      Assert.AreEqual('abcdef', b.ToString);
      b.Insert(6, '!');
      b.Insert(0, '<');
      b.Insert(0, '');
      Assert.AreEqual('<abcdef!', b.ToString);
      b.Remove(0, b.Length);
      b.Insert(0, 'x');
      Assert.AreEqual('x', b.ToString);
    end;
  end;
end.
