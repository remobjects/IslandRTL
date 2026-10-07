// Regression guards for Windows ARM64 MethodInfo.Invoke: execute real methods
// through the runtime bridge, including records, references and exception unwind.
namespace Island.Tests.Shared;

uses RemObjects.Elements.EUnit;

{$IF WINDOWS AND ARM64}
type
  ReflectionPair = public record
  public
    A, B: Int64;
  end;

  ReflectionTriple = public record
  public
    A, B, C: Int64;
  end;

  ReflectionFloats = public record
  public
    A, B: Single;
  end;

  ReflectionWindowsARM64 = public class(Test)
  private
    class method Invoke(aName: String; aArgs: array of Object): Object;
    begin
      for each lMethod in typeOf(ReflectionWindowsARM64).Methods do
        if lMethod.Name = aName then
          exit lMethod.Invoke(nil, aArgs);
      raise new Exception('Missing reflection target: ' + aName);
    end;

  public

    [Used]
    class method Echo(aValue: String): String;
    begin
      exit aValue;
    end;

    [Used]
    class method Update(var aNumber: Int64; out aValue: Double; var aText: String);
    begin
      aNumber := aNumber + 7;
      aValue := 1.25;
      aText := aText + '!';
    end;

    [Used]
    class method Fail(aUnused: Integer);
    begin
      raise new Exception('reflection target exception');
    end;

    [Used]
    class method Pair(aValue: ReflectionPair): ReflectionPair;
    begin
      result.A := aValue.B + 3;
      result.B := aValue.A - 4;
    end;

    [Used]
    class method Triple(aValue: ReflectionTriple): ReflectionTriple;
    begin
      result.A := aValue.C + 5;
      result.B := aValue.A - 6;
      result.C := aValue.B + 7;
    end;

    [Used]
    class method Floats(aValue: ReflectionFloats): ReflectionFloats;
    begin
      result.A := aValue.B + 0.25;
      result.B := aValue.A - 0.5;
    end;

    [Used]
    class method FloatsOnStack(a,b,c,d,e,f,g,h: Double; i: ReflectionFloats): Double;
    begin
      exit a + b + c + d + e + f + g + h + i.A * 2 + i.B * 3;
    end;

    [Used]
    class method FloatsAtRegisterBoundary(a,b,c,d,e,f,g: Double; h: ReflectionFloats): Double;
    begin
      exit a + b + c + d + e + f + g + h.A * 2 + h.B * 3;
    end;

    [Used]
    class method PairAtRegisterBoundary(a,b,c,d,e,f,g: Int64; h: ReflectionPair): Int64;
    begin
      exit a + b + c + d + e + f + g + h.A * 2 + h.B * 3;
    end;

    // Positive guards: flattened record arguments must preserve both fields
    // when their scalar arguments straddle the last register and first stack slot.
    method RecordRegisterBoundaries;
    begin
      var lFloats: ReflectionFloats;
      lFloats.A := 1.5;
      lFloats.B := 2.25;
      Assert.AreEqual(Double(Invoke('FloatsAtRegisterBoundary', [Double(1), Double(2),
        Double(3), Double(4), Double(5), Double(6), Double(7), lFloats])), Double(37.75));
      var lPair: ReflectionPair;
      lPair.A := 100;
      lPair.B := 200;
      Assert.AreEqual(Int64(Invoke('PairAtRegisterBoundary', [Int64(1), Int64(2),
        Int64(3), Int64(4), Int64(5), Int64(6), Int64(7), lPair])), Int64(828));
    end;

    // Positive guard: references are passed unchanged, including nil; void
    // methods copy var/out values back into the supplied argument array.
    method ReferencesAndVarOut;
    begin
      Assert.AreEqual(String(Invoke('Echo', ['hello'])), 'hello');
      Assert.IsTrue(Invoke('Echo', [nil]) = nil);
      var lArgs: array of Object := [Int64(100), nil, 'text'];
      Assert.IsTrue(Invoke('Update', lArgs) = nil);
      Assert.AreEqual(Int64(lArgs[0]), Int64(107));
      Assert.AreEqual(Double(lArgs[1]), Double(1.25));
      Assert.AreEqual(String(lArgs[2]), 'text!');
    end;

    // Negative guard: reject incompatible boxes before reading their payload as
    // another type or passing an invalid reference to the reflected method.
    method IncompatibleArguments;
    begin
      var lCaught := false;
      try
        Invoke('Echo', [Integer(1)]);
      except
        on e: RemObjects.Elements.System.ArgumentException do
          lCaught := true;
      end;
      Assert.IsTrue(lCaught);
      lCaught := false;
      try
        Invoke('Pair', [Integer(1)]);
      except
        on e: RemObjects.Elements.System.ArgumentException do
          lCaught := true;
      end;
      Assert.IsTrue(lCaught);
    end;

    // Negative guard: an exception must unwind across the assembly call,
    // reach the caller's handler, and leave the stack usable for another call.
    method ExceptionsCrossInvoke;
    begin
      var lCaught := false;
      try
        Invoke('Fail', [Integer(0)]);
      except
        on e: Exception do begin
          Assert.AreEqual(e.Message, 'reflection target exception');
          lCaught := true;
        end;
      end;
      Assert.IsTrue(lCaught);
      Assert.AreEqual(String(Invoke('Echo', ['after catch'])), 'after catch');
    end;

    // Positive guards: two-register records, indirect large records, and HFAs
    // must use their distinct argument and return locations.
    method RecordArgumentsAndResults;
    begin
      var lPair: ReflectionPair;
      lPair.A := 100;
      lPair.B := 200;
      var lPairResult := ReflectionPair(Invoke('Pair', [lPair]));
      Assert.AreEqual(lPairResult.A, Int64(203));
      Assert.AreEqual(lPairResult.B, Int64(96));
      var lTriple: ReflectionTriple;
      lTriple.A := 100;
      lTriple.B := 200;
      lTriple.C := 300;
      var lTripleResult := ReflectionTriple(Invoke('Triple', [lTriple]));
      Assert.AreEqual(lTripleResult.A, Int64(305));
      Assert.AreEqual(lTripleResult.B, Int64(94));
      Assert.AreEqual(lTripleResult.C, Int64(207));
      var lFloats: ReflectionFloats;
      lFloats.A := 1.5;
      lFloats.B := 2.25;
      var lFloatsResult := ReflectionFloats(Invoke('Floats', [lFloats]));
      Assert.AreEqual(lFloatsResult.A, Single(2.5));
      Assert.AreEqual(lFloatsResult.B, Single(1));
      Assert.AreEqual(Double(Invoke('FloatsOnStack', [Double(1), Double(2),
        Double(3), Double(4), Double(5), Double(6), Double(7), Double(8), lFloats])), Double(45.75));
    end;

  end;
{$ENDIF}
end.
