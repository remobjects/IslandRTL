namespace RemObjects.Elements.System;

type
  SwiftObject<T> = public record
  private
    fData: ^Void;
  public
    class property &Type: ^SwiftTypeRecord read InternalCalls.GetSwiftTypeInfo<T> as ^SwiftTypeRecord;
    property Data: ^Void read fData;

    constructor(aData: ^Void; aCopy: Boolean);
    begin
      if aCopy then begin
        fData := malloc(&Type^.VWT^.size);
        &Type^.VWT^.initializeWithCopy(IntPtr(fData), IntPtr(aData), &Type);
      end else begin
        fData := aData;
      end;
    end;

    constructor;
    begin
    end;

    method AllocateEmpty;
    begin
      if fData <> nil then begin
        &Type^.VWT^.destroy(IntPtr(fData), &Type);
        free(fData);
      end;
      var lSize := &Type^.VWT^.size;
      fData := malloc(lSize);
    end;

    class operator implicit(aInput: SwiftObject<T>): SwiftAny;
    begin
      if aInput.Type = nil then exit default(SwiftAny);
      exit new SwiftAny(aInput.fData, aInput.Type, false);
    end;

    class method FromAny<T>(const var aInput: SwiftAny): SwiftObject<T>;
    begin
      var aType := ^SwiftTypeRecord(InternalCalls.GetSwiftTypeInfo<T>());
      if (aInput.Type <> aType) then
        exit default(SwiftObject<T>);
      result.fData := malloc(aType^.VWT^.size);
      aType^.VWT^.initializeWithCopy(IntPtr(result.fData), IntPtr(aInput.UnboxedData), aType);
    end;

    method Clone: SwiftObject<T>;
    begin
      if fData = nil then exit default(SwiftObject<T>);
      var lRes: SwiftObject<T>;
      lRes.fData := malloc(&Type^.VWT^.size);
      &Type^.VWT^.initializeWithCopy(IntPtr(lRes.fData), IntPtr(fData), &Type);
      exit lRes;
    end;

    constructor Copy(var aOriginal: SwiftObject<T>);
    begin
      if aOriginal.Data <> nil then begin
        fData := malloc(&Type^.VWT^.size);
        &Type^.VWT^.initializeWithCopy(IntPtr(fData), IntPtr(aOriginal.fData), &Type);
      end;
    end;

    class operator Assign(var aDest: SwiftObject<T>; var aSource: SwiftObject<T>);
    begin
      if (@aDest) = (@aSource) then exit;
      if aDest.fData <> nil then begin
        &Type^.VWT^.destroy(IntPtr(aDest.fData), &Type);
        free(aDest.fData);
      end;
      aDest.fData := nil;
      if aSource.fData <> nil then begin
        aDest.fData := malloc(&Type^.VWT^.size);
        &Type^.VWT^.initializeWithCopy(IntPtr(aDest.fData), IntPtr(aSource.fData), &Type);
      end;
    end;

    finalizer;
    begin
      if fData <> nil then begin
        &Type^.VWT^.destroy(IntPtr(fData), &Type);
        free(fData);
      end;
    end;
  end;

end.