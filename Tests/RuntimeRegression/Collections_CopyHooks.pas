// Negative ownership guards: raw byte copies must not bypass a record's copy
// or assignment hooks. Use observable counters without unmanaged memory, so a
// missing retain/release is reported as a test failure rather than a double free.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
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
  Collections_CopyHooks = public class(Test)
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
  end;
end.
