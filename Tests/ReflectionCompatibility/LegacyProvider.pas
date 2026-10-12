// Negative compatibility fixture: build this provider with a compiler predating
// ReflectionValueCopyMetadataTag, then invoke it using the current runtime.
// The consumer must reject record copying before calling the target; it must not
// silently byte-copy an unknown ownership contract from an older provider FX.
namespace Island.Tests.ReflectionCompatibility;

type
  LegacyReflectionRecord = public record
  public
    Value: Int64;
    constructor Copy(var aSource: LegacyReflectionRecord);
    begin
      Value := aSource.Value;
    end;
  end;

  LegacyReflectionProvider = public static class
  public
    class var TargetCalls: Integer;
    class method CreateValue: Object;
    begin
      var lValue: LegacyReflectionRecord;
      lValue.Value := 73;
      exit lValue;
    end;
    [Used]
    class method Update(var aValue: LegacyReflectionRecord);
    begin
      inc(TargetCalls);
      aValue.Value := aValue.Value + 1;
    end;
  end;
end.
