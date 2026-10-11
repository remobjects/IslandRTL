// Positive GC guards: populate each container with its own managed-record
// payloads in a separate frame, then collect after growth, moves and removals.
// Only the containers (or a span's backing-array root) retain those payloads.
// Do not assert collection timing: Boehm can conservatively retain dead values.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  ContainerRootValue = record
  public
    Name: String;
    Values: array of Integer;
    Ref: EqualityValue;
  end;
  ContainerRoots = class
  public
    Queue: Queue<ContainerRootValue>;
    Stack: Stack<ContainerRootValue>;
    List: List<ContainerRootValue>;
    Map: Dictionary<Integer, ContainerRootValue>;
    View: Span<ContainerRootValue>;
  end;
  Collections_GCRoots = public class(Test)
  private
    [DisableInlining]
    method Payload(seed: Integer): ContainerRootValue;
    begin
      exit new ContainerRootValue(Name := new String(Char(seed), 17),
        Values := [seed, seed + 1, -seed], Ref := new EqualityValue(Value := seed));
    end;

    [DisableInlining]
    method Prepare: ContainerRoots;
    begin
      result := new ContainerRoots(Queue := new Queue<ContainerRootValue>,
        Stack := new Stack<ContainerRootValue>, List := new List<ContainerRootValue>,
        Map := new Dictionary<Integer, ContainerRootValue>);
      for i := 0 to 127 do begin
        result.Queue.Enqueue(Payload(1000 + i));
        result.Stack.Push(Payload(2000 + i));
        result.List.Add(Payload(3000 + i));
        result.Map.Add(i, Payload(4000 + i));
      end;
      for i := 0 to 31 do begin
        result.Queue.Dequeue;
        result.Stack.Pop;
        result.Map.Remove(i * 2);
      end;
      for i := 128 to 255 do begin
        result.Queue.Enqueue(Payload(1000 + i));
        result.Map.Add(i, Payload(4000 + i));
      end;
      result.List.RemoveRange(17, 55);
      var lArray := new ContainerRootValue[64];
      for i := 0 to 63 do lArray[i] := Payload(5000 + i);
      result.View := new Span<ContainerRootValue>(lArray, 3, 57);
    end;

    [DisableInlining]
    method Pressure: Integer;
    begin
      for i := 0 to 511 do begin
        var bytes := new Byte[4096 + i];
        bytes[0] := Byte(i);
        inc(result, bytes[0]);
      end;
    end;

    method Check(value: ContainerRootValue; seed: Integer);
    begin
      Assert.AreEqual(17, value.Name.Length);
      Assert.AreEqual(Char(seed), value.Name[0]);
      Assert.AreEqual(seed, value.Values[0]);
      Assert.AreEqual(seed + 1, value.Values[1]);
      Assert.AreEqual(-seed, value.Values[2]);
      Assert.AreEqual(seed, value.Ref.Value);
    end;
  public
    method ManagedRecordsSurviveMovesAndCollection;
    begin
      var roots := Prepare;
      Assert.IsTrue(Pressure > 0);
      BoehmGC.Collect(2);
      for i := 32 to 255 do Check(roots.Queue.Dequeue, 1000 + i);
      for i := 95 downto 0 do Check(roots.Stack.Pop, 2000 + i);
      for i := 0 to roots.List.Count - 1 do Check(roots.List[i], 3000 + i + (if i < 17 then 0 else 55));
      for i := 0 to 255 do
        if (i >= 64) or ((i and 1) <> 0) then Check(roots.Map[i], 4000 + i);
      for i := 0 to 56 do Check(roots.View.Data[i], 5003 + i);
      roots.Queue.Clear;
      roots.Stack.Clear;
      roots.List.Clear;
      roots.Map.Clear;
      BoehmGC.Collect(2);
      for i := 0 to 56 do Check(roots.View.Data[i], 5003 + i);
    end;
  end;
end.
