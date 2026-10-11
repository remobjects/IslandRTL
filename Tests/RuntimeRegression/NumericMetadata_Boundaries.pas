// Regression guards: numerically equal signed zeros must have equal hashes;
// integer reflection must distinguish signed and unsigned types at either word size.
// Infinity, subnormal and ordinary values guard against flattening nonzero hashes.
namespace Island.Tests.Shared;
uses RemObjects.Elements.EUnit;
type
  NumericMetadata_Boundaries = public class(Test)
  public
    method SingleSignedZeroHash;
    begin
      var bits: UInt32 := $80000000;
      var negative := ^Single(@bits)^;
      var positive: Single := 0;
      Assert.IsTrue(negative.Equals(positive));
      Assert.AreEqual(positive.GetHashCode, negative.GetHashCode);
      Assert.AreEqual(Object(positive).GetHashCode, Object(negative).GetHashCode);
      Assert.AreEqual(EqualityComparer.GetHashCode(positive), EqualityComparer.GetHashCode(negative));
      for each value in [Single(1.5), Single(-1.5), Single.PositiveInfinity, Single.NegativeInfinity] do
        Assert.AreEqual(^Integer(@value)^, value.GetHashCode);
      bits := 1;
      var subnormal := ^Single(@bits)^;
      Assert.AreEqual(1, subnormal.GetHashCode);
    end;
    method DoubleSignedZeroHash;
    begin
      var bits: UInt64 := $8000000000000000;
      var negative := ^Double(@bits)^;
      var positive: Double := 0;
      Assert.IsTrue(negative.Equals(positive));
      Assert.AreEqual(positive.GetHashCode, negative.GetHashCode);
      Assert.AreEqual(Object(positive).GetHashCode, Object(negative).GetHashCode);
      Assert.AreEqual(EqualityComparer.GetHashCode(positive), EqualityComparer.GetHashCode(negative));
      for each value in [Double(1.5), Double(-1.5), Double.PositiveInfinity, Double.NegativeInfinity] do
        Assert.AreEqual(^Integer(@value)[0] xor ^Integer(@value)[1], value.GetHashCode);
      bits := 1;
      var subnormal := ^Double(@bits)^;
      Assert.AreEqual(1, subnormal.GetHashCode);
    end;
    method SignedIntegerTypes;
    begin
      for each value in [typeOf(SByte), typeOf(Int16), typeOf(Int32), typeOf(Int64), typeOf(NativeInt)] do begin
        Assert.IsTrue(value.IsSigned);
        Assert.IsTrue(value.IsInteger);
        Assert.IsTrue(value.IsIntegerOrFloat);
        Assert.IsFalse(value.IsFloat);
      end;
    end;
    method UnsignedIntegerTypes;
    begin
      for each value in [typeOf(Byte), typeOf(UInt16), typeOf(UInt32), typeOf(UInt64), typeOf(NativeUInt)] do begin
        Assert.IsFalse(value.IsSigned);
        Assert.IsTrue(value.IsInteger);
        Assert.IsTrue(value.IsIntegerOrFloat);
        Assert.IsFalse(value.IsFloat);
      end;
    end;
    method NonIntegerTypes;
    begin
      for each value in [typeOf(Single), typeOf(Double)] do begin
        Assert.IsFalse(value.IsInteger);
        Assert.IsTrue(value.IsIntegerOrFloat);
        Assert.IsTrue(value.IsFloat);
      end;
      for each value in [typeOf(Boolean), typeOf(Char), typeOf(String), typeOf(Object)] do begin
        Assert.IsFalse(value.IsSigned);
        Assert.IsFalse(value.IsInteger);
        Assert.IsFalse(value.IsIntegerOrFloat);
        Assert.IsFalse(value.IsFloat);
      end;
    end;
  end;
end.
