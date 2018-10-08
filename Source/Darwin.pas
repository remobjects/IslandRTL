namespace RemObjects.Elements.System;

[assembly:AssemblyDefineAttribute('DARWIN')]

// These are "required" dllimports; pretty much all projects use this.
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '__objc_empty_cache')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '__objc_empty_vtable')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_release')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retain')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_sync_enter')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_sync_exit')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retainAutoreleasedReturnValue')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_storeStrong')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_storeWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSendSuper2')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSendSuper2_stret')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSend_fpret')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSend_stret')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSend')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_destroyWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retainAutoreleaseReturnValue')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_initWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_loadWeakRetained')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retainAutorelease')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_autoreleaseReturnValue')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_autoreleasePoolPush')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_autoreleasePoolPop')]

[assembly:DllImport('/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation', EntryPoint := '___CFConstantStringClassReference')]

type
  [AttributeUsage(AttributeTargets.Method)]
  ReturnsNotRetainedAttribute = public class(Attribute)
  public
  end;

  [AttributeUsage(AttributeTargets.Method)]
  ReturnsRetainedAttribute = public class(Attribute)
  public
  end;

  IslandToCocoaBridge = public class(Foundation.NSObject)
  private
    constructor(aValue: Object);
    begin
      Value := aValue;
    end;
  public
    class method FromValue(aValue: Object): Foundation.NSObject;
    begin
      if aValue = nil then exit nil;
      if aValue is CocoaToIslandBridge then exit CocoaToIslandBridge(aValue).Value;
      exit new IslandToCocoaBridge(aValue);
    end;

    property Value: Object; readonly;

    method description: String;
    begin
      var lValue := Value.ToString.ToAnsiChars(true);

      exit Foundation.NSString.stringWithCString(lValue);
    end;

    method hash: Foundation.NSUInteger;
    begin
      exit Value.GetHashCode;
    end;

    method isEqual(aTar: id): Boolean;
    begin
      var lOther := IslandToCocoaBridge(aTar);
      if lOther = nil then exit false;

      exit lOther.Value.Equals(Value);
    end;
  end;

  CocoaToIslandBridge = public class
  private
    constructor(aValue: Foundation.NSObject);
    begin
      Value := aValue;
    end;
  public
    class method FromValue(aValue: Foundation.NSObject): Object;
    begin
      if aValue = nil then exit nil;
      if aValue is IslandToCocoaBridge then exit IslandToCocoaBridge(aValue).Value;
      exit new CocoaToIslandBridge(aValue);
    end;

    property Value: Foundation.NSObject; readonly;

    method GetHashCode: Integer; override;
    begin
      exit Value.hash;
    end;

    method &Equals(obj: Object): Boolean; override;
    begin
      var lOther := CocoaToIslandBridge(obj);
      if lOther = nil then exit false;
      exit lOther.Value.isEqual(Value);
    end;

    method ToString: String; override;
    begin
      var s := Value.Description;
      exit String.FromPAnsiChars(s.UTF8String);
    end;
  end;

  [AttributeUsage(AttributeTargets.Field or AttributeTargets.Property)]
  IBOutlet = public class(Attribute)

  end;
  [AttributeUsage(AttributeTargets.Method)]
  IBAction = public class(Attribute)
  public
    constructor; empty;
    constructor(aName: String); empty;
  end;

  [AttributeUsage(AttributeTargets.Class)]
  IBObject = public class(Attribute)

  end;

end.