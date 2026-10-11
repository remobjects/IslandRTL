// Regression guards for foreign GC roots: lifetime operations must use the
// actual object identity, not freshly boxed copies of its numeric address.
// Check exact root counts, replacement, nil, self-assignment and heap fields.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  ForeignRootHolder = public class
  public
    Value: ForeignBoehmGC;
  end;

  ForeignGC_Lifetime = public class(Test)
  private
    method RootCount(aValue: Object): Integer;
    begin
      // Inspect the table to distinguish a balanced root from an integer box
      // that merely happens to keep an address visible to conservative scanning.
      for each field in typeOf(ForeignBoehmGC).Fields do
        if field.Name = 'fGC' then begin
          var roots := Dictionary<Object, Integer>(field.GetValue(nil));
          roots.TryGetValue(aValue, out result);
          exit;
        end;
      raise new Exception('foreign root table missing');
    end;
  public
    method CopyAssignmentAndRelease;
    begin
      var first := new Object;
      var second := new Object;
      var source, replacement, dest: ForeignBoehmGC;
      ForeignBoehmGC.Init(var source);
      ForeignBoehmGC.Init(var replacement);
      ForeignBoehmGC.Init(var dest);
      // ILifetimeStrategy storage is one object pointer. Set up two owned slots
      // explicitly so the test does not depend on stack-lifetime optimizations.
      ^Object(@source)^ := first;
      ^Object(@replacement)^ := second;
      ForeignBoehmGC.AddRef(first);
      ForeignBoehmGC.AddRef(second);
      try
        Assert.AreEqual(1, RootCount(first));
        ForeignBoehmGC.Copy(var dest, var source);
        Assert.AreEqual(2, RootCount(first));
        ForeignBoehmGC.Assign(var dest, var source);
        Assert.AreEqual(2, RootCount(first));
        ForeignBoehmGC.Assign(var dest, var dest);
        Assert.AreEqual(2, RootCount(first));
        ForeignBoehmGC.Assign(var dest, var replacement);
        Assert.AreEqual(1, RootCount(first));
        Assert.AreEqual(2, RootCount(second));
        ForeignBoehmGC.Release(var dest);
        Assert.AreEqual(1, RootCount(second));
        Assert.IsTrue(^Object(@dest)^ = nil);
        ForeignBoehmGC.Release(var dest);
        Assert.AreEqual(1, RootCount(second));
      finally
        ForeignBoehmGC.Release(var dest);
        ForeignBoehmGC.Release(var source);
        ForeignBoehmGC.Release(var replacement);
      end;
      Assert.AreEqual(0, RootCount(first));
      Assert.AreEqual(0, RootCount(second));
    end;

    method HeapFieldAndNil;
    begin
      var value := new Object;
      var source, empty: ForeignBoehmGC;
      ForeignBoehmGC.Init(var source);
      ForeignBoehmGC.Init(var empty);
      ^Object(@source)^ := value;
      ForeignBoehmGC.AddRef(value);
      var holder := new ForeignRootHolder;
      try
        holder.Value := source;
        Assert.AreEqual(2, RootCount(value));
        holder.Value := source;
        Assert.AreEqual(2, RootCount(value));
        holder.Value := empty;
        Assert.AreEqual(1, RootCount(value));
        ForeignBoehmGC.Copy(var holder.Value, var empty);
        Assert.AreEqual(1, RootCount(value));
        ForeignBoehmGC.Release(var empty);
      finally
        holder.Value := empty;
        ForeignBoehmGC.Release(var source);
      end;
      Assert.AreEqual(0, RootCount(value));
    end;
  end;
end.
