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

  // These counters model ownership without freeing native memory: a missed
  // semantic copy fails an assertion instead of causing an actual double free.
  ReflectionCopyState = public static class
  public
    class var Copies, TargetCalls: Integer;
    class var FailCopy: Boolean;
    class var TargetFailure: Exception;
  end;

  ReflectionOwnedRecord = public record
  public
    A, B, C: Int64;
    constructor Copy(var aSource: ReflectionOwnedRecord);
    begin
      if ReflectionCopyState.FailCopy then
        raise new Exception('reflection copy failed');
      inc(ReflectionCopyState.Copies);
      A := aSource.A;
      B := aSource.B;
      C := aSource.C;
    end;
    finalizer;
    begin
      // Empty intentionally: copying is observable, but no native resource is
      // freed when testing the broken runtime's duplicate ownership.
    end;
  end;

  ReflectionCopyOnlyRecord = public record
  public
    Value: Int64;
    constructor Copy(var aSource: ReflectionCopyOnlyRecord);
    begin
      inc(ReflectionCopyState.Copies);
      Value := aSource.Value;
    end;
  end;

  ReflectionCopyFloats = public record
  public
    A, B: Single;
    constructor Copy(var aSource: ReflectionCopyFloats);
    begin
      inc(ReflectionCopyState.Copies);
      A := aSource.A;
      B := aSource.B;
    end;
  end;

  ReflectionAssignOnlyRecord = public record
  public
    Value: Int64;
    class operator Assign(var aDestination: ReflectionAssignOnlyRecord; var aSource: ReflectionAssignOnlyRecord);
    begin
      inc(ReflectionCopyState.Copies);
      aDestination.Value := aSource.Value;
    end;
  end;

  // Real heap allocations make partial-copy cleanup observable. The audit list
  // roots only these tokens, never their owning record boxes. Count duplicate
  // releases without freeing twice so the regression reports a useful failure.
  ReflectionAllocation = public class
  public
    Pointer: ^Void;
    Releases: Integer;
    constructor;
    begin
      Pointer := rtl.HeapAlloc(rtl.GetProcessHeap, 0, 16);
      if Pointer = nil then
        raise new Exception('test allocation failed');
    end;
    method Release;
    begin
      inc(Releases);
      if Releases = 1 then
        rtl.HeapFree(rtl.GetProcessHeap, 0, Pointer);
    end;
  end;

  ReflectionPartialCopyState = public static class
  public
    class var Allocations: List<ReflectionAllocation>;
    class var FailCopy: Boolean;
    class var Failure: String;
    class var TargetCalls: Integer;
    class method Acquire: ReflectionAllocation;
    begin
      result := new ReflectionAllocation;
      Allocations.Add(result);
    end;
  end;

  ReflectionPartialRecord = public record
  public
    Resource: ReflectionAllocation;
    constructor Copy(var aSource: ReflectionPartialRecord);
    begin
      Resource := ReflectionPartialCopyState.Acquire;
      // Deliberately throw after acquiring ownership, not before copying begins.
      if ReflectionPartialCopyState.FailCopy then
        raise new Exception('partial reflection copy failed');
    end;
    finalizer;
    begin
      if assigned(Resource) then begin
        Resource.Release;
        Resource := nil;
      end;
    end;
  end;

  // Receiver mutation must affect the existing box, not a temporary value copy.
  // A string field and collection inside the method also exercise GC visibility.
  ReflectionMutableReceiver = public record
  public
    Value: Int64;
    Text: String;
    [Used]
    method Update(aFail: Boolean);
    begin
      Value := Value + 7;
      Text := Text + '!';
      BoehmGC.Collect(1);
      if aFail then
        raise new Exception('receiver changed before failure');
    end;
    [Used]
    method UpdateArgument(var aValue: Int64; aFail: Boolean);
    begin
      Value := Value + aValue;
      aValue := aValue + 1;
      if aFail then
        raise new Exception('receiver and argument failure');
    end;
  end;

  // Real owned resources make any hidden receiver copy observable without
  // relying on timing. The allocation tokens do not retain their owning boxes.
  ReflectionOwnedReceiver = public record
  public
    Resource: ReflectionAllocation;
    constructor Copy(var aSource: ReflectionOwnedReceiver);
    begin
      if assigned(aSource.Resource) then
        Resource := ReflectionPartialCopyState.Acquire;
    end;
    finalizer;
    begin
      if assigned(Resource) then begin
        Resource.Release;
        Resource := nil;
      end;
    end;
    [Used]
    method Touch(aFail: Boolean);
    begin
      BoehmGC.Collect(1);
      Assert.IsTrue(assigned(Resource));
      Assert.AreEqual(Resource.Releases, 0);
      if aFail then
        raise new Exception('owned receiver failure');
    end;
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
    class method UpdateOwned(var aValue: ReflectionOwnedRecord);
    begin
      inc(ReflectionCopyState.TargetCalls);
      aValue.A := aValue.A + 10;
    end;

    [Used]
    class method ReadOwned(aValue: ReflectionOwnedRecord): Int64;
    begin
      inc(ReflectionCopyState.TargetCalls);
      exit aValue.A + aValue.B + aValue.C;
    end;

    [Used]
    class method UpdateCopyOnly(var aValue: ReflectionCopyOnlyRecord);
    begin
      inc(ReflectionCopyState.TargetCalls);
      aValue.Value := aValue.Value + 1;
    end;

    [Used]
    class method UpdateAssignOnly(var aValue: ReflectionAssignOnlyRecord);
    begin
      aValue.Value := aValue.Value + 1;
    end;

    // A record with assignment but no copy constructor must use the compiler's
    // initialize-then-assign fallback, just as an ordinary value copy does.
    method AssignOnlyRecordArguments;
    begin
      var lValue: ReflectionAssignOnlyRecord;
      lValue.Value := 31;
      var lOriginal: Object := lValue;
      var lArgs: array of Object := [lOriginal];
      ReflectionCopyState.Copies := 0;
      Invoke('UpdateAssignOnly', lArgs);
      Assert.AreEqual(ReflectionCopyState.Copies, 1);
      Assert.AreEqual(ReflectionAssignOnlyRecord(lOriginal).Value, Int64(31));
      Assert.AreEqual(ReflectionAssignOnlyRecord(lArgs[0]).Value, Int64(32));
    end;

    [Used]
    class method UpdatePartial(var aValue: ReflectionPartialRecord);
    begin
      inc(ReflectionPartialCopyState.TargetCalls);
    end;

    [DisableInlining]
    class method PartialCopyWorker;
    begin
      try
        var lValue: ReflectionPartialRecord;
        lValue.Resource := ReflectionPartialCopyState.Acquire;
        var lOriginal: Object := lValue;
        var lArgs: array of Object := [lOriginal];
        ReflectionPartialCopyState.FailCopy := true;
        var lCaught := false;
        try
          Invoke('UpdatePartial', lArgs);
        except
          on e: Exception do
            lCaught := e.Message = 'partial reflection copy failed';
        end;
        Assert.IsTrue(lCaught);
        Assert.IsTrue(Object.ReferenceEquals(lOriginal, lArgs[0]));
      except
        on e: Exception do
          ReflectionPartialCopyState.Failure := e.Message;
      finally
        ReflectionPartialCopyState.FailCopy := false;
      end;
    end;

    // Negative cleanup guard: acquire a real resource before the reflected copy
    // throws, then require exactly one release for every acquired resource.
    // The worker's stack disappears before collection, avoiding conservative
    // retention of dead boxes by test locals on the collecting thread.
    method PartiallyAcquiredCopyResources;
    begin
      ReflectionPartialCopyState.Allocations := new List<ReflectionAllocation>;
      ReflectionPartialCopyState.Failure := nil;
      ReflectionPartialCopyState.TargetCalls := 0;
      var lWorker := new Thread(() -> PartialCopyWorker);
      lWorker.Start;
      var lHandle := rtl.OpenThread(rtl.SYNCHRONIZE, false, lWorker.ThreadID);
      Assert.IsTrue(lHandle <> nil);
      try
        Assert.AreEqual(rtl.WaitForSingleObject(lHandle, 10000), UInt32(rtl.WAIT_OBJECT_0));
      finally
        rtl.CloseHandle(lHandle);
      end;
      BoehmGC.Collect(3);
      Assert.IsTrue(ReflectionPartialCopyState.Failure = nil);
      Assert.AreEqual(ReflectionPartialCopyState.TargetCalls, 0);
      Assert.AreEqual(ReflectionPartialCopyState.Allocations.Count, 3);
      for each lAllocation in ReflectionPartialCopyState.Allocations do
        Assert.AreEqual(lAllocation.Releases, 1);
    end;

    [Used, DisableInlining]
    class method ReadCopyOnly(aValue: ReflectionCopyOnlyRecord): Int64;
    begin
      exit aValue.Value;
    end;

    [Used, DisableInlining]
    class method ReadCopyFloats(aValue: ReflectionCopyFloats): Single;
    begin
      exit aValue.A + aValue.B;
    end;

    // ABI-by-value scalar/HFA records must match an ordinary non-inlined call,
    // including whether the language requires a copy hook for a read-only value.
    // This guards the paths that marshal registers rather than an indirect box.
    method SmallByValueCopySemantics;
    begin
      var lValue: ReflectionCopyOnlyRecord;
      lValue.Value := 12;
      var lBox: Object := lValue;
      ReflectionCopyState.Copies := 0;
      var lExpected := ReadCopyOnly(lValue);
      var lCopies := ReflectionCopyState.Copies;
      ReflectionCopyState.Copies := 0;
      var lActual := Int64(Invoke('ReadCopyOnly', [lBox]));
      Assert.AreEqual(lActual, lExpected);
      Assert.AreEqual(ReflectionCopyState.Copies, lCopies);
      var lFloats: ReflectionCopyFloats;
      lFloats.A := 1.5;
      lFloats.B := 2.25;
      lBox := lFloats;
      ReflectionCopyState.Copies := 0;
      var lExpectedFloat := ReadCopyFloats(lFloats);
      lCopies := ReflectionCopyState.Copies;
      ReflectionCopyState.Copies := 0;
      var lActualFloat := Single(Invoke('ReadCopyFloats', [lBox]));
      Assert.AreEqual(lActualFloat, lExpectedFloat);
      Assert.AreEqual(ReflectionCopyState.Copies, lCopies);
    end;

    // Negative ownership guards: Invoke must create an independent managed
    // argument copy for both var and ABI-indirect (>16-byte) value arguments.
    method ManagedRecordArgumentCopies;
    begin
      var lValue: ReflectionOwnedRecord;
      lValue.A := 1;
      lValue.B := 2;
      lValue.C := 3;
      var lOriginal: Object := lValue;
      var lArgs: array of Object := [lOriginal];
      ReflectionCopyState.Copies := 0;
      ReflectionCopyState.TargetCalls := 0;
      Invoke('UpdateOwned', lArgs);
      Assert.AreEqual(ReflectionCopyState.Copies, 1);
      Assert.AreEqual(ReflectionCopyState.TargetCalls, 1);
      Assert.AreEqual(ReflectionOwnedRecord(lOriginal).A, Int64(1));
      Assert.AreEqual(ReflectionOwnedRecord(lArgs[0]).A, Int64(11));
    end;

    // ABI-indirect values (>16 bytes) need their own owned argument box even
    // when the target only reads them and therefore needs no local value copy.
    method LargeManagedRecordArguments;
    begin
      var lValue: ReflectionOwnedRecord;
      lValue.A := 1;
      lValue.B := 2;
      lValue.C := 3;
      var lOriginal: Object := lValue;
      var lArgs: array of Object := [lOriginal];
      ReflectionCopyState.Copies := 0;
      Assert.AreEqual(Int64(Invoke('ReadOwned', lArgs)), Int64(6));
      Assert.IsTrue(ReflectionCopyState.Copies >= 1);
      Assert.AreEqual(ReflectionOwnedRecord(lOriginal).A, Int64(1));
    end;

    // Copy hooks matter even without a finalizer. Testing only finalizable RTTI
    // would miss these records and silently bypass user-defined copy behavior.
    method CopyOnlyRecordArguments;
    begin
      var lValue: ReflectionCopyOnlyRecord;
      lValue.Value := 20;
      var lOriginal: Object := lValue;
      var lArgs: array of Object := [lOriginal];
      ReflectionCopyState.Copies := 0;
      Invoke('UpdateCopyOnly', lArgs);
      Assert.AreEqual(ReflectionCopyState.Copies, 1);
      Assert.AreEqual(ReflectionCopyOnlyRecord(lOriginal).Value, Int64(20));
      Assert.AreEqual(ReflectionCopyOnlyRecord(lArgs[0]).Value, Int64(21));
    end;

    // A failed copy must propagate before the target executes or var arguments
    // are published; the original box remains a valid owner after the failure.
    method ManagedRecordCopyExceptions;
    begin
      var lValue: ReflectionOwnedRecord;
      lValue.A := 17;
      var lOriginal: Object := lValue;
      var lArgs: array of Object := [lOriginal];
      ReflectionCopyState.TargetCalls := 0;
      ReflectionCopyState.FailCopy := true;
      var lCaught := false;
      try
        try
          Invoke('UpdateOwned', lArgs);
        except
          on e: Exception do begin
            lCaught := e.Message = 'reflection copy failed';
          end;
        end;
      finally
        ReflectionCopyState.FailCopy := false;
      end;
      Assert.IsTrue(lCaught);
      Assert.AreEqual(ReflectionCopyState.TargetCalls, 0);
      Assert.IsTrue(Object.ReferenceEquals(lOriginal, lArgs[0]));
      Assert.AreEqual(ReflectionOwnedRecord(lOriginal).A, Int64(17));
    end;

    [Used]
    class method UpdateThenFail(var aNumber: Int64; out aValue: Double; var aText: String);
    begin
      Update(var aNumber, out aValue, var aText);
      ReflectionCopyState.TargetFailure := new Exception('arguments changed before failure');
      raise ReflectionCopyState.TargetFailure;
    end;

    [Used]
    class method UpdateOwnedThenFail(var aValue: ReflectionOwnedRecord);
    begin
      aValue.A := aValue.A + 10;
      raise new Exception('owned argument changed before failure');
    end;

    // Positive contract guard: public Invoke publishes var/out copies only on
    // successful return, matching the existing Island wrapper and .NET oracle.
    // A target exception remains unwrapped and leaves the caller array unchanged.
    method VarOutChangesBeforeException;
    begin
      var lArgs: array of Object := [Int64(100), nil, 'text'];
      var lCaught := false;
      try
        Invoke('UpdateThenFail', lArgs);
      except
        on e: Exception do
          lCaught := Object.ReferenceEquals(e, ReflectionCopyState.TargetFailure) and
            (e.Message = 'arguments changed before failure');
      end;
      Assert.IsTrue(lCaught);
      Assert.AreEqual(Int64(lArgs[0]), Int64(100));
      Assert.IsTrue(lArgs[1] = nil);
      Assert.AreEqual(String(lArgs[2]), 'text');
    end;

    // Positive ownership guard: a target may mutate its private argument copy
    // before throwing, but the public array and another reference to its input
    // retain the original owning box when Invoke does not complete successfully.
    method ManagedVarChangesBeforeException;
    begin
      var lValue: ReflectionOwnedRecord;
      lValue.A := 17;
      var lOriginal: Object := lValue;
      var lArgs: array of Object := [lOriginal];
      var lCaught := false;
      try
        Invoke('UpdateOwnedThenFail', lArgs);
      except
        on e: Exception do
          lCaught := e.Message = 'owned argument changed before failure';
      end;
      Assert.IsTrue(lCaught);
      Assert.IsTrue(Object.ReferenceEquals(lOriginal, lArgs[0]));
      Assert.AreEqual(ReflectionOwnedRecord(lOriginal).A, Int64(17));
      Assert.AreEqual(ReflectionOwnedRecord(lArgs[0]).A, Int64(17));
    end;

    // Negative receiver regression: an instance method mutates its existing box
    // on success and before throwing. Ordinary source values remain independent.
    // This also distinguishes the receiver from public var argument copyback.
    method BoxedValueReceiverMutation;
    begin
      var lValue: ReflectionMutableReceiver;
      lValue.Value := 10;
      lValue.Text := 'receiver';
      var lBox: Object := lValue;
      var lInvoked := false;
      for each lMethod in typeOf(ReflectionMutableReceiver).Methods do
        if lMethod.Name = 'Update' then begin
          lMethod.Invoke(lBox, [false]);
          Assert.AreEqual(ReflectionMutableReceiver(lBox).Value, Int64(17));
          Assert.AreEqual(ReflectionMutableReceiver(lBox).Text, 'receiver!');
          var lCaught := false;
          try
            lMethod.Invoke(lBox, [true]);
          except
            on e: Exception do
              lCaught := e.Message = 'receiver changed before failure';
          end;
          Assert.IsTrue(lCaught);
          Assert.AreEqual(ReflectionMutableReceiver(lBox).Value, Int64(24));
          Assert.AreEqual(ReflectionMutableReceiver(lBox).Text, 'receiver!!');
          lInvoked := true;
          break;
        end;
      Assert.IsTrue(lInvoked);
      Assert.AreEqual(lValue.Value, Int64(10));
      Assert.AreEqual(lValue.Text, 'receiver');
    end;

    // Receiver identity and ordinary argument copyback are separate contracts:
    // mutation of self persists on throw, but its var argument is published only
    // after success. This catches incorrect slot offsets in the receiver path.
    method ReceiverAndVarArgument;
    begin
      var lValue: ReflectionMutableReceiver;
      lValue.Value := 10;
      var lBox: Object := lValue;
      var lInvoked := false;
      for each lMethod in typeOf(ReflectionMutableReceiver).Methods do
        if lMethod.Name = 'UpdateArgument' then begin
          var lArgs: array of Object := [Int64(5), false];
          lMethod.Invoke(lBox, lArgs);
          Assert.AreEqual(ReflectionMutableReceiver(lBox).Value, Int64(15));
          Assert.AreEqual(Int64(lArgs[0]), Int64(6));
          lArgs := [Int64(7), true];
          var lCaught := false;
          try
            lMethod.Invoke(lBox, lArgs);
          except
            on e: Exception do
              lCaught := e.Message = 'receiver and argument failure';
          end;
          Assert.IsTrue(lCaught);
          Assert.AreEqual(ReflectionMutableReceiver(lBox).Value, Int64(22));
          Assert.AreEqual(Int64(lArgs[0]), Int64(7));
          lInvoked := true;
          break;
        end;
      Assert.IsTrue(lInvoked);
      Assert.AreEqual(lValue.Value, Int64(10));
    end;

    [DisableInlining]
    class method OwnedReceiverWorker;
    begin
      try
        var lValue: ReflectionOwnedReceiver;
        lValue.Resource := ReflectionPartialCopyState.Acquire;
        var lBox: Object := lValue;
        Assert.AreEqual(ReflectionPartialCopyState.Allocations.Count, 2);
        var lInvoked := false;
        for each lMethod in typeOf(ReflectionOwnedReceiver).Methods do
          if lMethod.Name = 'Touch' then begin
            lMethod.Invoke(lBox, [false]);
            var lCaught := false;
            try
              lMethod.Invoke(lBox, [true]);
            except
              on e: Exception do
                lCaught := e.Message = 'owned receiver failure';
            end;
            Assert.IsTrue(lCaught);
            lInvoked := true;
            break;
          end;
        Assert.IsTrue(lInvoked);
        Assert.AreEqual(ReflectionPartialCopyState.Allocations.Count, 2);
      except
        on e: Exception do
          ReflectionPartialCopyState.Failure := e.Message;
      end;
    end;

    // Negative ownership/rooting guard: receiver calls run no copy hook, and GC
    // inside the method cannot release the borrowed box's real resource. After
    // the worker exits, both independent owners must release exactly once.
    method OwnedBoxedReceiverLifetime;
    begin
      ReflectionPartialCopyState.Allocations := new List<ReflectionAllocation>;
      ReflectionPartialCopyState.Failure := nil;
      var lWorker := new Thread(() -> OwnedReceiverWorker);
      lWorker.Start;
      var lHandle := rtl.OpenThread(rtl.SYNCHRONIZE, false, lWorker.ThreadID);
      Assert.IsTrue(lHandle <> nil);
      try
        Assert.AreEqual(rtl.WaitForSingleObject(lHandle, 10000), UInt32(rtl.WAIT_OBJECT_0));
      finally
        rtl.CloseHandle(lHandle);
      end;
      BoehmGC.Collect(3);
      if assigned(ReflectionPartialCopyState.Failure) then
        raise new Exception(ReflectionPartialCopyState.Failure);
      Assert.AreEqual(ReflectionPartialCopyState.Allocations.Count, 2);
      for each lAllocation in ReflectionPartialCopyState.Allocations do
        Assert.AreEqual(lAllocation.Releases, 1);
    end;

    [Used]
    class method ReadInteger(aValue: Int64): Int64;
    begin
      inc(ReflectionCopyState.TargetCalls);
      exit aValue;
    end;

    [Used]
    class method InitializeNilModes(var aNumber: Int64; out aValue: ReflectionPair; var aText: String);
    begin
      Assert.AreEqual(aNumber, Int64(0));
      Assert.IsTrue(aText = nil);
      aNumber := 9;
      aValue.A := 11;
      aValue.B := 13;
      aText := 'initialized';
    end;

    // Positive/negative compatibility guards: native reflection accepts nil
    // references, zero-initializes nil var/out storage, but rejects nil for an
    // ordinary value parameter before entering the target. This deliberately
    // records Island behavior rather than silently adopting .NET conversion.
    method NilArgumentModes;
    begin
      Assert.IsTrue(Invoke('Echo', [nil]) = nil);
      ReflectionCopyState.TargetCalls := 0;
      var lCaught := false;
      try
        Invoke('ReadInteger', [nil]);
      except
        on e: RemObjects.Elements.System.ArgumentException do
          lCaught := true;
      end;
      Assert.IsTrue(lCaught);
      Assert.AreEqual(ReflectionCopyState.TargetCalls, 0);
      var lArgs: array of Object := [nil, nil, nil];
      Invoke('InitializeNilModes', lArgs);
      Assert.AreEqual(Int64(lArgs[0]), Int64(9));
      Assert.AreEqual(ReflectionPair(lArgs[1]).A, Int64(11));
      Assert.AreEqual(ReflectionPair(lArgs[1]).B, Int64(13));
      Assert.AreEqual(String(lArgs[2]), 'initialized');
    end;

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
