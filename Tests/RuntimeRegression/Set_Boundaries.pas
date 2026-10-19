// Regression guards for Pascal bit sets. Exercise byte boundaries, unequal
// storage lengths, nil/empty operands, enumeration and source immutability.
// Membership must accept the nil empty-set representation in checked builds too.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  SetLetter = public enum(Zero = 0, Seven = 7, Eight = 8, Sixteen = 16);
  Set_Boundaries = public class(Test)
  public
    method HighestBitAndEnumeration;
    begin
      for each value in [0, 7, 8, 15, 16, 63, 64, 255] do begin
        var s := RemObjects.Elements.System.Set<Byte>.FromData(Byte(value));
        Assert.IsTrue(s.Get(value));
        var e := s.GetEnumerator;
        Assert.IsTrue(e.MoveNext);
        Assert.AreEqual(Byte(value), e.Current);
        Assert.IsFalse(e.MoveNext);
        e := s.GetEnumerator;
        Assert.IsTrue(e.MoveNext);
        Assert.AreEqual(Byte(value), e.Current);
        e.Dispose;
      end;
    end;

    method EnumValues;
    begin
      var s := RemObjects.Elements.System.Set<SetLetter>.FromData(SetLetter.Zero, SetLetter.Eight, SetLetter.Sixteen);
      var a: array of SetLetter := s;
      Assert.AreEqual(3, a.Length);
      Assert.AreEqual(SetLetter.Zero, a[0]);
      Assert.AreEqual(SetLetter.Eight, a[1]);
      Assert.AreEqual(SetLetter.Sixteen, a[2]);
    end;

    method UnequalLengthIntersection;
    begin
      var a := new RemObjects.Elements.System.Set<Byte>;
      a := a.SetRange(1, 2).Set(24);
      var b := new RemObjects.Elements.System.Set<Byte>;
      b := b.Set(2);
      var c := a * b;
      Assert.IsFalse(c.Get(1));
      Assert.IsTrue(c.Get(2));
      Assert.IsFalse(c.Get(24));
      Assert.IsTrue(c = b * a);
      Assert.IsTrue(a.Get(24));
    end;

    method OperationsMatchBitMasks;
    begin
      var seed: UInt32 := 13;
      for test := 0 to 511 do begin
        seed := seed * 1664525 + 1013904223;
        var maskA := seed;
        seed := seed * 1664525 + 1013904223;
        var maskB := seed;
        var a := new RemObjects.Elements.System.Set<Byte>;
        var b := new RemObjects.Elements.System.Set<Byte>;
        for i := 0 to 31 do begin
          if (maskA and (UInt32(1) shl i)) <> 0 then a := a.Set(i);
          if (maskB and (UInt32(1) shl i)) <> 0 then b := b.Set(i);
        end;
        var both := a * b;
        var either := a + b;
        var difference := a - b;
        for i := 0 to 39 do begin
          var bit := if i < 32 then UInt32(1) shl i else UInt32(0);
          Assert.AreEqual((maskA and maskB and bit) <> 0, both.Get(i));
          Assert.AreEqual(((maskA or maskB) and bit) <> 0, either.Get(i));
          Assert.AreEqual((maskA and not maskB and bit) <> 0, difference.Get(i));
        end;
        Assert.AreEqual((maskA and maskB) = maskB, a >= b);
        Assert.AreEqual((maskA and maskB) = maskA, a <= b);
      end;
    end;

    method SubsetAndEmpty;
    begin
      var a := new RemObjects.Elements.System.Set<Byte>;
      a := a.SetRange(1, 3).Set(24);
      var b := new RemObjects.Elements.System.Set<Byte>;
      b := b.Set(2);
      Assert.IsTrue(a >= b);
      Assert.IsTrue(b <= a);
      Assert.IsFalse(b >= a);
      var empty: RemObjects.Elements.System.Set<Byte> := nil;
      Assert.IsTrue(a >= empty);
      Assert.IsTrue(empty <= a);
      Assert.IsFalse(empty >= a);
      Assert.IsTrue(a * empty = empty);
      Assert.IsTrue(empty * a = empty);
      Assert.IsFalse(RemObjects.Elements.System.Set<Byte>.op_In(0, empty));
      Assert.IsTrue(RemObjects.Elements.System.Set<Byte>.op_In(2, a));
      Assert.IsFalse(RemObjects.Elements.System.Set<Byte>.op_In(0, a));
      var other := new RemObjects.Elements.System.Set<Byte>;
      Assert.IsTrue(other = empty);
    end;
  end;
end.
