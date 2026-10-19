// Negative ownership guards: raw byte copies must not bypass a record's copy
// or assignment hooks. Use observable counters without unmanaged memory, so a
// missing retain/release is reported as a test failure rather than a double free.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  QueueClearCounts = static class
  public
    class var FailCopy: Boolean;
    class var Copies, Cleanups: Integer;
  end;
  QueueClearValue = public record
  public
    Value: Integer;
    constructor Copy(var aSource: QueueClearValue);
    begin
      if aSource.Value <> 0 then begin
        inc(QueueClearCounts.Copies);
        if QueueClearCounts.FailCopy then raise new Exception('discard copied a live value');
      end;
      Value := aSource.Value;
    end;
    finalizer;
    begin
      if Value <> 0 then inc(QueueClearCounts.Cleanups);
      Value := 0;
    end;
  end;
  CopyHookCounts = public static class
  public
    class var Copies, Assignments, Cleanups: Integer;
    class method Reset;
    begin
      Copies := 0; Assignments := 0; Cleanups := 0;
    end;
  end;
  CopyHookValue = public record
  public
    Value: Integer;
    constructor Copy(var source: CopyHookValue);
    begin
      inc(CopyHookCounts.Copies);
      Value := source.Value;
    end;
    class operator Assign(var dest: CopyHookValue; var source: CopyHookValue);
    begin
      inc(CopyHookCounts.Assignments);
      dest.Value := source.Value;
    end;
    finalizer;
    begin
      inc(CopyHookCounts.Cleanups);
    end;
    method Equals(other: Object): Boolean; override;
    begin
      exit (other is CopyHookValue) and (CopyHookValue(other).Value = Value);
    end;
    method GetHashCode: Integer; override;
    begin
      exit Value;
    end;
  end;
  {$IFNDEF NOTHREADS}
  // Tokens remain rooted by the audit list, but do not point back to any owning
  // record/array/container. Real malloc storage distinguishes ownership cleanup
  // from merely keeping GC references alive. Count bad releases without a crash.
  ContainerResource = public class
  public
    Pointer: ^Void;
    Releases: Integer;
    constructor;
    begin
      Pointer := malloc(16);
      if Pointer = nil then raise new Exception('resource allocation failed');
    end;
    method Release;
    begin
      inc(Releases);
      if Releases = 1 then free(Pointer);
    end;
  end;
  ContainerCleanupMode = enum(LocalValue, UnreachableArray, UnreachableDictionary, ClearDictionary, RemoveDictionary);
  ContainerResourceAudit = static class
  public
    class var Tokens: List<ContainerResource>;
    class var Failure: String;
    class var Mode: ContainerCleanupMode;
    class method Acquire: ContainerResource;
    begin
      result := new ContainerResource;
      Tokens.Add(result);
    end;
  end;
  ContainerOwnedValue = public record
  public
    Resource: ContainerResource;
    constructor Copy(var aSource: ContainerOwnedValue);
    begin
      if aSource.Resource <> nil then Resource := ContainerResourceAudit.Acquire;
    end;
    class operator Assign(var aDest: ContainerOwnedValue; var aSource: ContainerOwnedValue);
    begin
      if (@aDest) = (@aSource) then exit;
      if aDest.Resource <> nil then aDest.Resource.Release;
      aDest.Resource := if aSource.Resource = nil then nil else ContainerResourceAudit.Acquire;
    end;
    finalizer;
    begin
      if Resource <> nil then begin
        Resource.Release;
        Resource := nil;
      end;
    end;
  end;
  {$ENDIF}
  Collections_CopyHooks = public class(Test)
  private
    {$IFNDEF NOTHREADS}
    [DisableInlining]
    class method ResourceWorker;
    begin
      try
        case ContainerResourceAudit.Mode of
          ContainerCleanupMode.LocalValue: begin
            var value: ContainerOwnedValue;
            value.Resource := ContainerResourceAudit.Acquire;
          end;
          ContainerCleanupMode.UnreachableArray: begin
            var values := new ContainerOwnedValue[3];
            for i := 0 to 2 do values[i].Resource := ContainerResourceAudit.Acquire;
          end;
          ContainerCleanupMode.UnreachableDictionary, ContainerCleanupMode.ClearDictionary, ContainerCleanupMode.RemoveDictionary: begin
            var values := new Dictionary<Integer, ContainerOwnedValue>;
            for i := 0 to 2 do begin
              var value: ContainerOwnedValue;
              value.Resource := ContainerResourceAudit.Acquire;
              values.Add(i, value);
            end;
            if ContainerResourceAudit.Mode = ContainerCleanupMode.ClearDictionary then values.Clear;
            if ContainerResourceAudit.Mode = ContainerCleanupMode.RemoveDictionary then
              for i := 0 to 2 do Assert.IsTrue(values.Remove(i));
          end;
        end;
      except
        on e: Exception do ContainerResourceAudit.Failure := e.Message;
      end;
    end;

    method CheckResourceCleanup(aMode: ContainerCleanupMode);
    begin
      // The worker unregisters its stack from the GC before IsAlive becomes
      // false. This avoids stale stack words retaining otherwise dead arrays.
      // Compare direct arrays and dictionaries with explicit Clear/Remove:
      // all acquired resources must be released once after ownership disappears.
      ContainerResourceAudit.Tokens := new List<ContainerResource>;
      ContainerResourceAudit.Failure := nil;
      ContainerResourceAudit.Mode := aMode;
      try
        var worker := new Thread(aState -> ResourceWorker);
        worker.Start;
        var waited := 0;
        while worker.IsAlive and (waited < 10000) do begin
          Thread.Sleep(1);
          inc(waited);
        end;
        Assert.IsFalse(worker.IsAlive);
        Assert.IsTrue(ContainerResourceAudit.Failure = nil);
        BoehmGC.Collect(3);
        Assert.IsTrue(ContainerResourceAudit.Tokens.Count > 0);
        for each token in ContainerResourceAudit.Tokens do Assert.AreEqual(1, token.Releases);
      finally
        // A failing regression must not leave real native allocations behind.
        for each token in ContainerResourceAudit.Tokens do
          if token.Releases = 0 then token.Release;
      end;
    end;
    {$ENDIF}
  public
    method ArrayCopyHonorsHooks;
    begin
      var a := new CopyHookValue[6];
      var b := new CopyHookValue[6];
      for i := 0 to 5 do a[i].Value := i + 1;
      CopyHookCounts.Reset;
      Array.Copy(a, b, 6);
      Assert.IsTrue(CopyHookCounts.Copies + CopyHookCounts.Assignments >= 6);
      for i := 0 to 5 do Assert.AreEqual(i + 1, b[i].Value);
    end;

    method OverlapAndPointerCopiesHonorHooks;
    begin
      var a := new CopyHookValue[6];
      for i := 0 to 5 do a[i].Value := i + 1;
      CopyHookCounts.Reset;
      Array.Copy(a, 0, a, 1, 5);
      Assert.IsTrue(CopyHookCounts.Copies + CopyHookCounts.Assignments >= 5);
      Assert.AreEqual(1, a[0].Value);
      for i := 1 to 5 do Assert.AreEqual(i, a[i].Value);
      CopyHookCounts.Reset;
      Array.Copy(@a[1], a, 0, 5);
      Assert.IsTrue(CopyHookCounts.Copies + CopyHookCounts.Assignments >= 5);
      for i := 0 to 4 do Assert.AreEqual(i + 1, a[i].Value);
    end;

    method QueueClearDiscardsWithoutCopying;
    begin
      // A wrapped ring exercises both sides of the buffer. A deliberately
      // throwing Copy of a live value detects unused Dequeue return copies.
      // Assigning default may still invoke Copy(default), as language semantics
      // require; nonthrowing finalizers count every live slot exactly once.
      var queue := new Queue<QueueClearValue>;
      for i := 1 to 4 do queue.Enqueue(new QueueClearValue(Value := i));
      queue.Dequeue; queue.Dequeue;
      queue.Enqueue(new QueueClearValue(Value := 5));
      queue.Enqueue(new QueueClearValue(Value := 6));
      QueueClearCounts.Copies := 0;
      QueueClearCounts.Cleanups := 0;
      QueueClearCounts.FailCopy := true;
      try
        queue.Clear;
        queue.Clear;
      finally
        QueueClearCounts.FailCopy := false;
      end;
      Assert.AreEqual(0, queue.Count);
      Assert.AreEqual(0, QueueClearCounts.Copies);
      Assert.AreEqual(4, QueueClearCounts.Cleanups);
      queue.Enqueue(new QueueClearValue(Value := 7));
      QueueClearCounts.Copies := 0;
      QueueClearCounts.Cleanups := 0;
      QueueClearCounts.FailCopy := true;
      try queue.Clear; finally QueueClearCounts.FailCopy := false; end;
      Assert.AreEqual(0, queue.Count);
      Assert.AreEqual(0, QueueClearCounts.Copies);
      Assert.AreEqual(1, QueueClearCounts.Cleanups);

      // A reserved buffer must not add growth copies while filling exactly to
      // capacity. Compare each enqueue with its first call, avoiding dependence
      // on a particular compiler's parameter-copy count.
      var reserved := new Queue<QueueClearValue>(17);
      var source := new QueueClearValue(Value := 1);
      QueueClearCounts.Copies := 0;
      reserved.Enqueue(source);
      var copiesPerEnqueue := QueueClearCounts.Copies;
      for i := 1 to 16 do begin
        QueueClearCounts.Copies := 0;
        reserved.Enqueue(source);
        Assert.AreEqual(copiesPerEnqueue, QueueClearCounts.Copies);
      end;
      QueueClearCounts.Cleanups := 0;
      reserved.Clear;
      Assert.AreEqual(17, QueueClearCounts.Cleanups);
    end;

    method DictionaryResizeAndClearHonorHooks;
    begin
      var d := new Dictionary<Integer, CopyHookValue>;
      for i := 0 to 8 do d.Add(i, new CopyHookValue(Value := i));
      CopyHookCounts.Reset;
      d.Add(9, new CopyHookValue(Value := 9));
      Assert.IsTrue(CopyHookCounts.Copies + CopyHookCounts.Assignments + CopyHookCounts.Cleanups >= 10);
      CopyHookCounts.Reset;
      d.Clear;
      Assert.IsTrue(CopyHookCounts.Assignments + CopyHookCounts.Cleanups >= 10);
      Assert.AreEqual(0, d.Count);
    end;

    method HashSetClearHonorsHooks;
    begin
      var s := new HashSet<CopyHookValue>;
      for i := 0 to 7 do s.Add(new CopyHookValue(Value := i));
      CopyHookCounts.Reset;
      s.Clear;
      Assert.IsTrue(CopyHookCounts.Assignments + CopyHookCounts.Cleanups >= 8);
      Assert.AreEqual(0, s.Count);
    end;
    method ArrayCopyOwnsOleStrings;
    begin
      // OleString owns an unmanaged BSTR (or malloc allocation on POSIX).
      // Mutating/replacing the source must not alter or invalidate a copy.
      var a := new OleString[4];
      a[0] := new OleString('alpha');
      a[1] := new OleString('bravo');
      a[2] := new OleString('charlie');
      a[3] := new OleString('delta');
      var b := new OleString[4];
      Array.Copy(a, b, 4);
      a[0].Item[0] := 'X';
      Assert.AreEqual('alpha', b[0].ToString);
      Array.Copy(a, 0, a, 1, 3);
      Assert.AreEqual('Xlpha', a[1].ToString);
      Assert.AreEqual('bravo', a[2].ToString);
      Assert.AreEqual('charlie', a[3].ToString);
      a[0] := default(OleString);
      Assert.AreEqual('Xlpha', a[1].ToString);
      Array.Copy(@a[1], a, 0, 3);
      Assert.AreEqual('bravo', a[1].ToString);
      Assert.AreEqual('charlie', a[2].ToString);
      Array.Clear(a, 0, 4);
      Assert.AreEqual('delta', b[3].ToString);
      Array.Clear(b, 0, 4);
    end;

    method DictionaryOwnsOleStringsThroughGrowthAndRemoval;
    begin
      var d := new Dictionary<Integer, OleString>;
      for i := 0 to 63 do d.Add(i, new OleString(i.ToString));
      BoehmGC.Collect(2);
      for i := 0 to 63 do Assert.AreEqual(i.ToString, d[i].ToString);
      var saved := d[17];
      d[17] := new OleString('replacement');
      Assert.AreEqual('17', saved.ToString);
      for i := 0 to 31 do Assert.IsTrue(d.Remove(i));
      for i := 64 to 127 do d.Add(i, new OleString(i.ToString));
      BoehmGC.Collect(2);
      for i := 32 to 127 do Assert.AreEqual(i.ToString, d[i].ToString);
      d.Clear;
      Assert.AreEqual('17', saved.ToString);
      d.Add(1, new OleString('reused'));
      Assert.AreEqual('reused', d[1].ToString);
      d.Clear;
    end;

    method EmptyAndSelfCopiesDoNotAssign;
    begin
      var a := new CopyHookValue[2];
      a[0].Value := 10;
      a[1].Value := 20;
      CopyHookCounts.Reset;
      Array.Copy(a, a, 2);
      Array.Copy(a, 2, a, 2, 0);
      Array.Copy(^CopyHookValue(nil), a, 2, 0);
      Assert.AreEqual(0, CopyHookCounts.Copies + CopyHookCounts.Assignments);
      Assert.AreEqual(10, a[0].Value);
      Assert.AreEqual(20, a[1].Value);
    end;
    method HashSetResizeHonorsHooks;
    begin
      var s := new HashSet<CopyHookValue>;
      for i := 0 to 8 do s.Add(new CopyHookValue(Value := i));
      CopyHookCounts.Reset;
      Assert.IsTrue(s.Add(new CopyHookValue(Value := 9)));
      Assert.IsTrue(CopyHookCounts.Copies + CopyHookCounts.Assignments >= 10);
      for i := 0 to 9 do Assert.IsTrue(s.Contains(new CopyHookValue(Value := i)));
      for i := 0 to 4 do Assert.IsTrue(s.Remove(new CopyHookValue(Value := i)));
      for i := 10 to 14 do Assert.IsTrue(s.Add(new CopyHookValue(Value := i)));
      CopyHookCounts.Reset;
      s.Clear;
      Assert.IsTrue(CopyHookCounts.Assignments + CopyHookCounts.Cleanups >= 10);
    end;

    method DictionaryCopiesOwnedKeysAndValues;
    begin
      var d := new Dictionary<CopyHookValue, CopyHookValue>;
      for i := 0 to 8 do d.Add(new CopyHookValue(Value := i), new CopyHookValue(Value := i + 100));
      CopyHookCounts.Reset;
      d.Add(new CopyHookValue(Value := 9), new CopyHookValue(Value := 109));
      Assert.IsTrue(CopyHookCounts.Copies + CopyHookCounts.Assignments >= 20);
      for i := 0 to 9 do Assert.AreEqual(i + 100, d[new CopyHookValue(Value := i)].Value);
      CopyHookCounts.Reset;
      d.Clear;
      Assert.IsTrue(CopyHookCounts.Assignments + CopyHookCounts.Cleanups >= 20);
    end;
    {$IFNDEF NOTHREADS}
    method LocalOwnedResourceIsReleased;
    begin
      CheckResourceCleanup(ContainerCleanupMode.LocalValue);
    end;
    method UnreachableManagedArrayReleasesResources;
    begin
      CheckResourceCleanup(ContainerCleanupMode.UnreachableArray);
    end;
    method UnreachableDictionaryReleasesResources;
    begin
      CheckResourceCleanup(ContainerCleanupMode.UnreachableDictionary);
    end;
    method DictionaryClearReleasesResources;
    begin
      CheckResourceCleanup(ContainerCleanupMode.ClearDictionary);
    end;
    method DictionaryRemoveReleasesResources;
    begin
      CheckResourceCleanup(ContainerCleanupMode.RemoveDictionary);
    end;
    {$ENDIF}
  end;
end.
