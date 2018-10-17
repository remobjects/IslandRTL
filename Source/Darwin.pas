namespace RemObjects.Elements.System;

uses
  Foundation;

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
[assembly:DllImport('/usr/lib/system/libdyld.dylib', EntryPoint := '__tlv_bootstrap')]

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

  INSFastEnumeration<T> = public interface mapped to Foundation.INSFastEnumeration
    method countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^T) count(len: NSUInteger): NSUInteger; mapped to countByEnumeratingWithState(aState) objects(^id(stackbuf)) count(len);
  end;
end.