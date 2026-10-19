// Negative regression guards for container growth, wraparound, enumeration,
// pooling and hash-table resizing. Reference values are independent of the
// container implementation; exercise empty/singleton and reuse after Clear.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  Collections_Boundaries = public class(Test)
  public
    method QueueInitialCapacityAndReuse;
    begin
      // Capacity reserves storage, not elements. Zero must grow normally; all
      // starting capacities preserve FIFO order through wrapping and reuse.
      for each capacity in [0, 1, 4, 17] do begin
        var queue := new Queue<Integer>(capacity);
        Assert.AreEqual(0, queue.Count);
        for i := 0 to 31 do queue.Enqueue(i);
        for i := 0 to 15 do Assert.AreEqual(i, queue.Dequeue);
        for i := 32 to 63 do queue.Enqueue(i);
        for i := 16 to 63 do Assert.AreEqual(i, queue.Dequeue);
        queue.Clear;
        queue.Enqueue(42);
        Assert.AreEqual(42, queue.Dequeue);
      end;
      var caught := false;
      try
        var queue := new Queue<Integer>(-1);
      except
        on e: ArgumentOutOfRangeException do caught := true;
      end;
      Assert.IsTrue(caught);
    end;

    method QueueEmptyAndWrap;
    begin
      var q := new Queue<Integer>;
      Assert.AreEqual(0, q.ToArray.Length);
      for i := 0 to 3 do q.Enqueue(i);
      Assert.AreEqual(0, q.Dequeue);
      Assert.AreEqual(1, q.Dequeue);
      for i := 4 to 100 do q.Enqueue(i);
      var a := q.ToArray;
      Assert.AreEqual(99, a.Length);
      for i := 0 to a.Length - 1 do Assert.AreEqual(i + 2, a[i]);
      for i := 2 to 100 do Assert.AreEqual(i, q.Dequeue);
      Assert.AreEqual(0, q.ToArray.Length);
      q.Clear;
      q.Enqueue(91);
      Assert.AreEqual(91, q.Peek);
      Assert.AreEqual(91, q.Dequeue);
    end;

    method QueueEnumeration;
    begin
      var q := new Queue<Integer>;
      q.Enqueue(7);
      q.Enqueue(8);
      var e := q.GetEnumerator;
      Assert.IsTrue(e.MoveNext);
      Assert.AreEqual(7, e.Current);
      Assert.IsTrue(e.MoveNext);
      Assert.AreEqual(8, e.Current);
      Assert.IsFalse(e.MoveNext);
      Assert.IsFalse(e.MoveNext);
      Assert.IsTrue(q.Contains(7));
    end;

    method StackEnumeration;
    begin
      var s := new Stack<Integer>;
      s.Push(7);
      s.Push(8);
      var e := s.GetEnumerator;
      Assert.IsTrue(e.MoveNext);
      Assert.AreEqual(8, e.Current);
      Assert.IsTrue(e.MoveNext);
      Assert.AreEqual(7, e.Current);
      Assert.IsFalse(e.MoveNext);
      Assert.IsFalse(e.MoveNext);
      Assert.AreEqual(8, s.Pop);
      Assert.AreEqual(7, s.Pop);
      s.Clear;
      Assert.AreEqual(0, s.ToArray.Length);
    end;

    method PoolFirstAcquireAndReuse;
    begin
      for each capacity in [0, 1, 4] do begin
        var created := 0;
        var cleaned := 0;
        var p := new ObjectPool<Object>(capacity,
          () -> begin inc(created); exit new Object; end,
          value -> begin Assert.IsTrue(assigned(value)); inc(cleaned); end);
        var a := p.Acquire;
        Assert.IsTrue(assigned(a));
        Assert.AreEqual(1, created);
        p.Release(a);
        Assert.AreEqual(1, cleaned);
        var b := p.Acquire;
        Assert.AreEqual(if capacity = 0 then 2 else 1, created);
        if capacity > 0 then Assert.IsTrue(Object.ReferenceEquals(a, b));
        var c := p.Acquire;
        Assert.IsFalse(Object.ReferenceEquals(b, c));
      end;
    end;

    method HashSetResizeAndHoles;
    begin
      var s := new HashSet<Integer>;
      for i := 1 to 300 do begin
        Assert.IsTrue(s.Add(i));
        for j := 1 to i do Assert.IsTrue(s.Contains(j));
      end;
      for i := 1 to 150 do Assert.IsTrue(s.Remove(i * 2));
      var total := 0;
      var count := 0;
      s.ForEach(value -> begin total := total + value; inc(count); end);
      Assert.AreEqual(150, count);
      Assert.AreEqual(22500, total);
      for i := 301 to 600 do Assert.IsTrue(s.Add(i));
      for i := 1 to 300 do Assert.AreEqual((i and 1) = 1, s.Contains(i));
      s.Clear;
      Assert.AreEqual(0, s.Count);
      count := 0;
      for each item in s.GetSequence do inc(count);
      Assert.AreEqual(0, count);
      Assert.IsTrue(s.Add(5));
      Assert.IsFalse(s.Add(5));
    end;

    method DictionaryClearAndNilValues;
    begin
      var d := new Dictionary<Integer, Object>;
      d.Add(1, nil);
      Assert.IsTrue(d.ContainsValue(nil));
      for i := 2 to 100 do d.Add(i, new Object);
      for i := 2 to 100 do Assert.IsTrue(d.ContainsKey(i));
      d.Clear;
      var count := 0;
      for each pair in d.GetSequence do inc(count);
      Assert.AreEqual(0, count);
      Assert.IsFalse(d.ContainsValue(nil));
      d.Add(2, new Object);
      Assert.AreEqual(1, d.Count);
    end;

    method ListRangesAndEmptySort;
    begin
      var a := new Integer[0];
      Array.Sort(a, (x, y) -> x - y);
      var l := new List<Integer>;
      l.AddRange([1, 2, 3, 4, 5]);
      Assert.AreEqual(3, l.FindIndex(2, 2, x -> x = 4));
      var small := new List<Integer>;
      small.Add(7);
      small.Add(8);
      l.InsertRange(1, small);
      Assert.AreEqual(7, l.Count);
      Assert.AreEqual(7, l[1]);
      Assert.AreEqual(8, l[2]);
      Assert.AreEqual(2, l[3]);
    end;
    method ArrayOverlapAndRejectedRanges;
    begin
      var a: array of Integer := [0, 1, 2, 3, 4, 5];
      Array.Copy(a, 0, a, 1, 5);
      for i := 1 to 5 do Assert.AreEqual(i - 1, a[i]);
      Array.Copy(a, 1, a, 0, 5);
      for i := 0 to 4 do Assert.AreEqual(i, a[i]);
      var failed := false;
      try Array.Copy(a, 0, a, 0, -1); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      failed := false;
      try Array.Copy(a, 1, a, 1, 2147483647); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
      Array.Copy(a, a.Length, a, a.Length, 0);
      failed := false;
      try Array.Clear(a, 1, 2147483647); except on e: ArgumentOutOfRangeException do failed := true; end;
      Assert.IsTrue(failed);
    end;

    method ListCopyAndSelfInsert;
    begin
      var l := new List<Integer>;
      l.AddRange([1, 2, 3]);
      l.InsertRange(1, l);
      var expected: array of Integer := [1, 1, 2, 3, 2, 3];
      Assert.AreEqual(expected.Length, l.Count);
      for i := 0 to expected.Length - 1 do Assert.AreEqual(expected[i], l[i]);
      var a: array of Integer := [91, 92];
      var failed := false;
      try l.CopyTo(a); except on e: RemObjects.Elements.System.ArgumentException do failed := true; end;
      Assert.IsTrue(failed);
      Assert.AreEqual(91, a[0]);
      Assert.AreEqual(92, a[1]);
      failed := false;
      try l[l.Count] := 99; except on e: Exception do failed := true; end;
      Assert.IsTrue(failed);
      l.RemoveRange(0, l.Count);
      l.RemoveRange(0, 0);
      l.CopyTo(0, a, a.Length, 0);
      Assert.AreEqual(0, l.Count);
      Assert.AreEqual(-1, l.FindIndex(0, 0, x -> true));
    end;

    method QueueRepeatedWrapAndManagedValues;
    begin
      var q := new Queue<String>;
      var next := 0;
      var removed := 0;
      for cycle := 0 to 99 do begin
        for i := 0 to 16 do begin q.Enqueue(next.ToString); inc(next); end;
        for i := 0 to 12 do begin Assert.AreEqual(removed.ToString, q.Dequeue); inc(removed); end;
        var copy := q.ToArray;
        Assert.AreEqual(next - removed, copy.Length);
        for i := 0 to copy.Length - 1 do Assert.AreEqual((removed + i).ToString, copy[i]);
      end;
      q.Enqueue(nil);
      Assert.IsTrue(q.Contains(nil));
      q.Clear;
      Assert.AreEqual(0, q.Count);
      Assert.IsFalse(q.Contains(nil));
      q.Enqueue('reused');
      Assert.AreEqual('reused', q.Dequeue);
    end;

  end;
end.
