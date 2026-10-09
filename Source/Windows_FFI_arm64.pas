namespace RemObjects.Elements.System;
{$IF ARM64 or ARM64EC}
type
  FFI = public class
  public

    class method Call(
    aAddress: ^Void;
    aCallingConv: CallingConvention;
    var aParams: array of Object;
    aParameterFlags: array of ArgumentMode;
    aParameterTypes: array of &Type;
    aResultType: &Type): Object;
    begin
      raise new NotImplementedException("FFI is not implemented yet for this ARM64 target.")
    end;

  end;
{$ENDIF}
end.