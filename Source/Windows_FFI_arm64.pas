namespace RemObjects.Elements.System;
{$IFDEF ARM64}
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
      raise new NotImplementedException("FFI is not implemented yet for arm64.")
    end;

  end;
{$ENDIF}
end.