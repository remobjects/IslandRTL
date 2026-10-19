// Compare collection equality/hashing with each type's own public behavior.
// Guard nil references, managed records, interfaces, scalar widths and custom
// comparisons before removing primitive boxing from the default comparer.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  EqualityValue = public class
  public
    property Value: Integer;
    method Equals(aOther: Object): Boolean; override;
    begin
      exit (aOther is EqualityValue) and (EqualityValue(aOther).Value = Value);
    end;
    method GetHashCode: Integer; override;
    begin
      exit Value;
    end;
  end;
  EqualityRecord = public record
  public
    Text: String;
    Number: Int64;
    method Equals(aOther: Object): Boolean; override;
    begin
      if not (aOther is EqualityRecord) then exit false;
      var r := EqualityRecord(aOther);
      exit (Text = r.Text) and (Number = r.Number);
    end;
    method GetHashCode: Integer; override;
    begin
      exit Text:GetHashCode xor Integer(Number);
    end;
  end;
  EqualityMarker = public interface
    property Value: Integer read;
  end;
  EqualityMarkerObject = public class(EqualityMarker)
  public
    property Value: Integer;
  end;
  Equality_Boundaries = public class(Test)
  private
    method Check<T>(a, b, c: T);
    begin
      Assert.IsTrue(RemObjects.Elements.System.EqualityComparer.Equals<T>(a, b));
      Assert.IsFalse(RemObjects.Elements.System.EqualityComparer.Equals<T>(a, c));
      Assert.AreEqual(a.GetHashCode, RemObjects.Elements.System.EqualityComparer.GetHashCode<T>(a));
      var s := new HashSet<T>;
      Assert.IsTrue(s.Add(a));
      Assert.IsFalse(s.Add(b));
      Assert.IsTrue(s.Add(c));
      Assert.AreEqual(2, s.Count);
      Assert.IsTrue(s.Contains(a));
      Assert.IsTrue(s.Remove(b));
      Assert.IsFalse(s.Contains(a));
      Assert.IsTrue(s.Contains(c));
    end;
  public
    method ScalarWidths;
    begin
      Check<Boolean>(true, true, false);
      Check<Byte>(255, 255, 0);
      Check<SByte>(-128, -128, 127);
      Check<Int16>(-32768, -32768, 32767);
      Check<UInt16>(65535, 65535, 0);
      Check<Char>(Char($ffff), Char($ffff), Char(0));
      Check<Int32>(Integer.MinValue, Integer.MinValue, Integer.MaxValue);
      Check<UInt32>(UInt32.MaxValue, UInt32.MaxValue, 0);
      Check<Int64>(Int64.MinValue, Int64.MinValue, Int64.MaxValue);
      Check<UInt64>(UInt64.MaxValue, UInt64.MaxValue, 0);
      Check<NativeInt>(-1, -1, 1);
      Check<NativeUInt>(NativeUInt.MaxValue, NativeUInt.MaxValue, 0);
      Check<Single>(1.25, 1.25, -1.25);
      Check<Double>(1.25, 1.25, -1.25);
    end;

    method ReferenceAndManagedValues;
    begin
      Check<String>('same', new String(['s', 'a', 'm', 'e']), 'other');
      Check<EqualityValue>(new EqualityValue(Value := 1), new EqualityValue(Value := 1), new EqualityValue(Value := 2));
      Check<EqualityRecord>(new EqualityRecord(Text := 'root', Number := 7), new EqualityRecord(Text := 'root', Number := 7), new EqualityRecord(Text := 'other', Number := 7));
      var a: EqualityMarker := new EqualityMarkerObject(Value := 7);
      var b: EqualityMarker := new EqualityMarkerObject(Value := 7);
      Assert.IsTrue(RemObjects.Elements.System.EqualityComparer.Equals<EqualityMarker>(a, a));
      Assert.IsFalse(RemObjects.Elements.System.EqualityComparer.Equals<EqualityMarker>(a, b));
    end;

    method NilReferences;
    begin
      Assert.IsTrue(RemObjects.Elements.System.EqualityComparer.Equals<String>(nil, nil));
      Assert.IsFalse(RemObjects.Elements.System.EqualityComparer.Equals<String>(nil, 'x'));
      Assert.IsFalse(RemObjects.Elements.System.EqualityComparer.Equals<String>('x', nil));
      Assert.AreEqual(0, RemObjects.Elements.System.EqualityComparer.GetHashCode<String>(nil));
    end;

    method ComparatorDefinesEquality;
    begin
      var values: sequence of String := ['one', 'ONE', 'two', 'TWO'];
      var distinct := values.Distinct((a, b) -> String.Compare(a.ToLower, b.ToLower)).ToArray;
      Assert.AreEqual(2, distinct.Length);
    end;
  end;
end.
