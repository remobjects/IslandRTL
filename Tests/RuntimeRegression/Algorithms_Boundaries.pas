// Negative regression guards for range safety, streaming short reads/writes,
// and sequence algorithms. Check results and side effects against small explicit
// expectations rather than another implementation of the same algorithm.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  ShortReadStream = class(MemoryStream)
  public
    method Read(aSpan: Span<Byte>): Integer; override;
    begin
      exit inherited Read(aSpan.Slice(0, if aSpan.Length > 3 then 3 else aSpan.Length));
    end;
  end;
  ShortWriteStream = class(MemoryStream)
  public
    method Write(aSpan: ImmutableSpan<Byte>): Integer; override;
    begin
      exit inherited Write(aSpan.Slice(0, if aSpan.Length > 2 then 2 else aSpan.Length));
    end;
  end;
  Algorithms_Boundaries = public class(Test)
  public
    method SpanInvalidRanges;
    begin
      var a := new Byte[4];
      var failed := false;
      try var s := new Span<Byte>(a, 3, 2); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      failed := false;
      try var s := new ImmutableSpan<Byte>(a, 3, 2); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      var span := new Span<Byte>(a, 0, 4);
      failed := false;
      try span.Slice(1, 2147483647); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      Assert.AreEqual(0, span.Slice(4, 0).Length);
      failed := false;
      try var s := new Span<Byte>(^Byte(nil), -1); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
    end;

    method StreamShrinkAndRegrow;
    begin
      var s := new MemoryStream;
      s.Write([Byte(1), Byte(2), Byte(3), Byte(4)], 0, 4);
      s.SetLength(1);
      s.SetLength(4);
      var a := s.ToArray;
      Assert.AreEqual(Byte(1), a[0]);
      for i := 1 to 3 do Assert.AreEqual(Byte(0), a[i]);
      s.SetLength(1);
      s.Position := 6;
      s.Write([Byte(9)], 0, 1);
      a := s.ToArray;
      Assert.AreEqual(7, a.Length);
      for i := 1 to 5 do Assert.AreEqual(Byte(0), a[i]);
      Assert.AreEqual(Byte(9), a[6]);
      var failed := false;
      try s.Position := -1; except on e: Exception do failed := true; end;
      Assert.IsTrue(failed);
      Assert.AreEqual(Int64(7), s.Position);
      failed := false;
      try s.SetLength(Int64(2147483648)); except on e: Exception do failed := true; end;
      Assert.IsTrue(failed);
      Assert.AreEqual(Int64(7), s.Length);
    end;

    method StreamCopyShortReadsAndWrites;
    begin
      var a := new Byte[37];
      for i := 0 to a.Length - 1 do a[i] := Byte(i);
      var source := new ShortReadStream;
      source.Write(a, 0, a.Length);
      source.Position := 0;
      var dest := new ShortWriteStream;
      source.CopyTo(dest);
      var copied := dest.ToArray;
      Assert.AreEqual(a.Length, copied.Length);
      for i := 0 to a.Length - 1 do Assert.AreEqual(a[i], copied[i]);
      source.Position := 0;
      source.CopyTo(NullStream.Instance);
      Assert.AreEqual(source.Length, source.Position);
      Assert.AreEqual(3, NullStream.Instance.Write(new Byte[3], 0, 3));
    end;

    method SequenceMinMaxAndSetOperations;
    begin
      var values: sequence of Integer := [3, 1, 2, 1, 3];
      Assert.IsTrue(values.Min = 1);
      Assert.IsTrue(values.Max = 3);
      Assert.IsTrue(values.Min(x -> -x) = -3);
      Assert.IsTrue(values.Max(x -> -x) = -1);
      var negatives: sequence of Integer := [-5, -2, -9];
      Assert.IsTrue(negatives.Max = -2);
      Assert.IsTrue(negatives.Min = -9);
      Assert.IsTrue(negatives.Min(x -> -x) = 2);
      Assert.IsTrue(negatives.Max(x -> -x) = 9);
      var empty: sequence of String := new String[0];
      Assert.IsTrue(empty.Min = nil);
      Assert.IsTrue(empty.Max = nil);
      var words: sequence of String := [nil, 'c', 'a', nil, 'b'];
      Assert.IsTrue(words.Min = 'a');
      Assert.IsTrue(words.Max = 'c');
      var other: sequence of Integer := [1, 3];
      Assert.AreEqual(2, values.Intersect(other).Count);
      Assert.AreEqual(1, values.Except(other).Count);
      var list := new List<Integer>;
      list.AddRange([3, 1, 2]);
      var seq: sequence of Integer := list;
      var sorted := seq.OrderBy(x -> x).ToArray;
      Assert.AreEqual(1, sorted[0]);
      Assert.AreEqual(3, list[0]);
    end;
  end;
end.
