// Regression guard: Windows x64 catch and cleanup funclets must call methods
// with the ABI-required stack alignment, and repeated catches must restore RSP.
namespace RemObjects.Elements.Island.Tests;

uses RemObjects.Elements.EUnit;

{$IF WINDOWS AND X86_64}
type
  WindowsCatchAlignment = public class(Test)
  private

    [InlineAsm("
movq %rsp, %rax
andq $$15, %rax
retq
", "", true, false), Naked, DisableInlining, DisableOptimizations]
    class method EntryStackAlignment: NativeInt; external;

  public

    method CatchAndCleanupCallsAreAligned;
    begin
      for i := 0 to 31 do begin
        var lCatchAlignment: NativeInt := -1;
        var lCleanupAlignment: NativeInt := -1;
        var lCaught := false;
        try
          try
            raise new Exception('stack alignment');
          finally
            lCleanupAlignment := EntryStackAlignment;
          end;
        except
          on e: Exception do begin
            lCatchAlignment := EntryStackAlignment;
            lCaught := true;
          end;
        end;
        Assert.IsTrue(lCaught);
        // RSP is 16-byte aligned before CALL; the return address uses eight bytes.
        Assert.AreEqual(NativeInt(8), lCleanupAlignment);
        Assert.AreEqual(NativeInt(8), lCatchAlignment);
      end;
    end;

  end;
{$ENDIF}
end.
