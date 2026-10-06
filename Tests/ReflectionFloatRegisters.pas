// Positive regression guard: ARM64 reflection must preserve every floating-point
// argument register, especially d6/d7, whose load offset previously overlapped d5.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

type
  ReflectionFloatRegisters = public class(Test)
  public
    [Used]
    class method Weighted(a,b,c,d,e,f,g,h: Double): Double;
    begin
      exit a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h;
    end;

    // Raw-bit guards detect conversion to Double, including NaN payloads and -0.
    [Used]
    class method SingleArgumentBits(a: Single): UInt32;
    begin
      exit ^UInt32(@a)^;
    end;

    [Used]
    class method SingleResultBits(a: UInt32): Single;
    begin
      exit ^Single(@a)^;
    end;

    [Used]
    class method TenSingles(a,b,c,d,e,f,g,h,i,j: Single): Single;
    begin
      exit a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h + 9*i + 10*j;
    end;

    [Used]
    class method TenDoubles(a,b,c,d,e,f,g,h,i,j: Double): Double;
    begin
      exit a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h + 9*i + 10*j;
    end;

    [Used]
    class method MixedStack(a,b,c,d,e,f,g,h: Int64; i,j,k,l,m,n,o,p: Single;
      q: Byte; r: Single; s: Int16; t: Double; u: Integer; v: Single; w: UInt64): Double;
    begin
      exit a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h +
        i + 2*j + 3*k + 4*l + 5*m + 6*n + 7*o + 8*p +
        9*q + 10*r + 11*s + 12*t + 13*u + 14*v + 15*w;
    end;

    [Used]
    class method MixedRegisters(a: Single; b: Double; c: Single; d: Double;
      e: Single; f: Double; g: Single; h: Double; i: Int64; j: Integer): Double;
    begin
      exit a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h + 9*i + 10*j;
    end;

    [Used]
    class method NinthSingleBits(a,b,c,d,e,f,g,h,i: Single): UInt32;
    begin
      exit ^UInt32(@i)^;
    end;

    [Used]
    method InstanceArguments(a,b,c,d,e,f,g: Integer; h: SByte; i: UInt16; j: Integer): Int64;
    begin
      // self consumes x0: h, i and j must be packed into the outgoing stack.
      exit a + 2*b + 3*c + 4*d + 5*e + 6*f + 7*g + 8*h + 9*i + 10*j;
    end;

    // Negative guard: one four-byte overflow argument still needs a 16-byte stack.
    method SingleStackBits;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      var lBits: array of UInt32 := [$80000000, $00000001, $3fa00000, $7fc12345];
      for each lExpected in lBits do begin
        var lValue := ^Single(@lExpected)^;
        Assert.AreEqual(UInt32(Invoke('NinthSingleBits', [Single(1), Single(2),
          Single(3), Single(4), Single(5), Single(6), Single(7), Single(8), lValue])), lExpected);
      end;
      {$ENDIF}
    end;

    // Negative guard: the hidden instance shifts integer arguments but not FP slots.
    method InstanceStackArguments;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      var lFound := false;
      for each lMethod in typeOf(ReflectionFloatRegisters).Methods do
        if lMethod.Name = 'InstanceArguments' then begin
          var lActual := Int64(lMethod.Invoke(self, [Integer(1), Integer(2), Integer(3),
            Integer(4), Integer(5), Integer(6), Integer(7), SByte(-8), UInt16(60000), Integer(-10)]));
          Assert.AreEqual(lActual, InstanceArguments(1,2,3,4,5,6,7,-8,60000,-10));
          lFound := true;
        end;
      Assert.IsTrue(lFound);
      {$ENDIF}
    end;

    class method Invoke(aName: String; aArgs: array of Object): Object;
    begin
      for each lMethod in typeOf(ReflectionFloatRegisters).Methods do
        if lMethod.Name = aName then
          exit lMethod.Invoke(nil, aArgs);
      raise new Exception('Missing reflection target: ' + aName);
    end;

    // Negative guards: Single registers contain 32-bit IEEE bits, not Doubles.
    method SingleArgumentAndResultBits;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      var lBits: array of UInt32 := [$00000000, $80000000, $00000001, $007fffff,
        $00800000, $3fa00000, $bf400000, $7f800000, $ff800000, $7fc12345];
      for each lExpected in lBits do begin
        var lValue := ^Single(@lExpected)^;
        Assert.AreEqual(UInt32(Invoke('SingleArgumentBits', [lValue])), lExpected);
        var lResult := Single(Invoke('SingleResultBits', [lExpected]));
        Assert.AreEqual(^UInt32(@lResult)^, lExpected);
      end;
      {$ENDIF}
    end;

    // Positive guard: s and d arguments share eight FP registers, independently of x.
    method MixedArgumentRegisters;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      Assert.AreEqual(Double(Invoke('MixedRegisters', [Single(1), Double(2),
        Single(3), Double(4), Single(5), Double(6), Single(7), Double(8),
        Int64(9), Integer(10)])), Double(385));
      {$ENDIF}
    end;

    // Negative guards: ninth and tenth FP arguments use their ABI stack slots.
    method FloatingPointStackArguments;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      Assert.AreEqual(Single(Invoke('TenSingles', [Single(1), Single(2), Single(3),
        Single(4), Single(5), Single(6), Single(7), Single(8), Single(9), Single(10)])), Single(385));
      Assert.AreEqual(Double(Invoke('TenDoubles', [Double(1), Double(2), Double(3),
        Double(4), Double(5), Double(6), Double(7), Double(8), Double(9), Double(10)])), Double(385));
      {$ENDIF}
    end;

    // Negative guard: packed Apple stack arguments retain natural alignment and order.
    method MixedStackArguments;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      var lExpected := MixedStack(1,2,3,4,5,6,7,8, 1,2,3,4,5,6,7,8,
        9, 10.5, -11, 12.25, -13, 14.5, 15);
      Assert.AreEqual(Double(Invoke('MixedStack', [Int64(1), Int64(2), Int64(3),
        Int64(4), Int64(5), Int64(6), Int64(7), Int64(8), Single(1), Single(2),
        Single(3), Single(4), Single(5), Single(6), Single(7), Single(8), Byte(9),
        Single(10.5), Int16(-11), Double(12.25), Integer(-13), Single(14.5), UInt64(15)])), lExpected);
      {$ENDIF}
    end;

    method EightDoubleArguments;
    begin
      {$IF ARM64 AND NOT WINDOWS}
      var lFound := false;
      for each lMethod in typeOf(ReflectionFloatRegisters).Methods do begin
        if lMethod.Name = 'Weighted' then begin
          var lResult := lMethod.Invoke(nil, [Double(1), Double(2), Double(3), Double(4),
            Double(5), Double(6), Double(7), Double(8)]);
          Assert.AreEqual(Double(lResult), Double(204));
          lFound := true;
        end;
      end;
      Assert.IsTrue(lFound);
      {$ENDIF}
    end;
  end;
end.
