// Regression guards: handles root their objects across table growth and GC;
// disposal clears the owning record and invalid handles fail before indexing.
// Copies share a handle, so only the owning record disposes each allocation.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  HandlePayload = class
  public
    Value: Integer;
    Data: array of Integer;
  end;
  GCHandle_Boundaries = public class(Test)
  private
    [DisableInlining]
    method Prepare: array of GCHandle;
    begin
      result := new GCHandle[2050];
      for i := 0 to result.Length - 1 do
        result[i] := GCHandle.Allocate(new HandlePayload(Value := i, Data := [i, -i, i + 1]));
    end;
    [DisableInlining]
    method Pressure: Integer;
    begin
      for i := 0 to 511 do begin
        var bytes := new Byte[4096 + i];
        bytes[0] := Byte(i);
        inc(result, bytes[0]);
      end;
      BoehmGC.Collect(2);
    end;
  public
    method DisposeClearsHandleAndCanRepeat;
    begin
      var handle := GCHandle.Allocate(new Object);
      Assert.IsTrue(handle.HasValue);
      handle.Dispose;
      Assert.IsFalse(handle.HasValue);
      Assert.AreEqual(NativeInt(0), handle.Handle);
      handle.Dispose;
      var empty := default(GCHandle);
      empty.Dispose;
    end;

    method BorrowedCopiesShareTheOwnersRoot;
    begin
      // Copies borrow an existing root; the owner alone releases it. Do not
      // dereference stale copies after release: a later allocation may reuse it.
      var owner := GCHandle.Allocate(new HandlePayload(Value := 123));
      var borrowed := owner;
      var fromHandle := new GCHandle(owner.Handle);
      try
        Assert.IsTrue(Pressure > 0);
        Assert.AreEqual(owner.Handle, borrowed.Handle);
        Assert.AreEqual(123, (borrowed.Target as HandlePayload).Value);
        Assert.IsTrue(Object.ReferenceEquals(owner.Target, fromHandle.Target));
      finally
        borrowed := default(GCHandle);
        fromHandle := default(GCHandle);
        owner.Dispose;
      end;
      owner.Dispose;
      Assert.IsFalse(owner.HasValue);
    end;

    method InvalidHandlesAreRejected;
    begin
      for each value in [NativeInt(0), NativeInt(-1), NativeInt.MinValue, NativeInt.MaxValue] do begin
        var handle := new GCHandle(value);
        var rejected := false;
        try
          var target := handle.Target;
        except
          on e: RemObjects.Elements.System.ArgumentException do rejected := true;
        end;
        Assert.IsTrue(rejected);
        if value <> 0 then begin
          rejected := false;
          try handle.Dispose; except on e: RemObjects.Elements.System.ArgumentException do rejected := true; end;
          Assert.IsTrue(rejected);
        end;
      end;
    end;

    method ReleasedTargetIsRejected;
    begin
      var handle := GCHandle.Allocate(new Object);
      handle.Dispose;
      var rejected := false;
      try var target := handle.Target; except on e: RemObjects.Elements.System.ArgumentException do rejected := true; end;
      Assert.IsTrue(rejected);
    end;

    method HandlesKeepObjectsAcrossGrowthAndCollection;
    begin
      var handles := Prepare;
      try
        Assert.IsTrue(Pressure > 0);
        for i := 0 to handles.Length - 1 do begin
          var target := handles[i].Target as HandlePayload;
          Assert.AreEqual(i, target.Value);
          Assert.AreEqual(-i, target.Data[1]);
        end;
        for i := 0 to handles.Length - 1 step 2 do handles[i].Dispose;
        for i := 0 to handles.Length - 1 step 2 do
          handles[i] := GCHandle.Allocate(new HandlePayload(Value := i + 5000, Data := [i]));
        Assert.IsTrue(Pressure > 0);
        for i := 0 to handles.Length - 1 do
          Assert.AreEqual(i + (if (i and 1) = 0 then 5000 else 0), (handles[i].Target as HandlePayload).Value);
      finally
        for i := 0 to handles.Length - 1 do handles[i].Dispose;
      end;
    end;

    {$IFNDEF NOTHREADS}
    method ConcurrentAllocationAndLookup;
    begin
      var stable := GCHandle.Allocate(new HandlePayload(Value := 42));
      try
        Parallel.For(0, 8, (worker, state) -> begin
          for i := 0 to 255 do begin
            var handle := GCHandle.Allocate(new HandlePayload(Value := worker * 256 + i));
            try
              Assert.AreEqual(42, (stable.Target as HandlePayload).Value);
              Assert.AreEqual(worker * 256 + i, (handle.Target as HandlePayload).Value);
            finally
              handle.Dispose;
            end;
          end;
        end);
      finally
        stable.Dispose;
      end;
    end;
    {$ENDIF}

    method NilCannotBeAllocated;
    begin
      var rejected := false;
      try
        var handle := GCHandle.Allocate(nil);
      except
        on e: RemObjects.Elements.System.ArgumentException do rejected := true;
      end;
      Assert.IsTrue(rejected);
    end;
  end;
end.
