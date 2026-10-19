// Negative compatibility guard: link an independently compiled old provider FX
// and library. A current consumer must receive the explicit recompile diagnostic,
// with unchanged argument identity and no target execution. This requires an old
// provider build; recompiling both sides with the new compiler is not this test.
namespace Island.Tests.ReflectionCompatibility;

type
  LegacyReflectionConsumer = public static class
  public
    class method Check;
    begin
      var lOriginal := LegacyReflectionProvider.CreateValue;
      var lArgs: array of Object := [lOriginal];
      LegacyReflectionProvider.TargetCalls := 0;
      var lRejected := false;
      for each lMethod in typeOf(LegacyReflectionProvider).Methods do
        if lMethod.Name = 'Update' then begin
          try
            lMethod.Invoke(nil, lArgs);
          except
            on e: NotSupportedException do
              lRejected := e.Message = 'Windows ARM64 reflection record arguments require copy metadata; recompile the declaring record';
          end;
          break;
        end;
      if not lRejected or (LegacyReflectionProvider.TargetCalls <> 0) or
         not Object.ReferenceEquals(lOriginal, lArgs[0]) then
        raise new Exception('old provider record metadata was not safely rejected');
    end;
  end;
end.
