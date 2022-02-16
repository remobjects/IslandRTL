namespace RemObjects.Elements.System;

{$IF DARWIN}

uses
  Foundation;

{$IF TARGET_OS_IPHONE OR TARGET_OS_TV OR TARGET_OS_WATCH}
const COREFOUNDATION_FRAMEWORK = "/System/Library/Frameworks/CoreFoundation.framework/CoreFoundation"; assembly;
{$ELSE}
const COREFOUNDATION_FRAMEWORK = "/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation"; assembly;
{$ENDIF}

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
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_copyWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_destroyWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSendSuper2')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSendSuper2_stret')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSend_fpret')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSend_stret')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_msgSend')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_destroyWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retainBlock')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retainAutoreleaseReturnValue')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_initWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_loadWeakRetained')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_retainAutorelease')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_autoreleaseReturnValue')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_autoreleasePoolPush')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_autoreleasePoolPop')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_ehtype_vtable')]
[assembly:DllImport('/usr/lib/system/libdyld.dylib', EntryPoint := '__tlv_bootstrap')]
[assembly:DllImport('/usr/lib/system/libsystem_blocks.dylib', EntryPoint := '__NSConcreteGlobalBlock')]
[assembly:DllImport('/usr/lib/system/libsystem_blocks.dylib', EntryPoint := '__NSConcreteStackBlock')]
[assembly:DllImport('/usr/lib/system/libsystem_blocks.dylib', EntryPoint := '__Block_object_assign')]
[assembly:DllImport('/usr/lib/system/libsystem_blocks.dylib', EntryPoint := '__Block_object_dispose')]

[assembly:DllImport(COREFOUNDATION_FRAMEWORK, EntryPoint := '___CFConstantStringClassReference')]

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

  [Island]
  IIslandGetCocoaWrapper = public interface
  method «$__CreateCocoaWrapper»: Foundation.NSObject;
  end;

  [Cocoa]
  ICocoaGetIslandWrapper = public interface
  method «$__CreateIslandWrapper»: RemObjects.Elements.System.Object;
  end;

  INSFastEnumeration<T> = public interface mapped to Foundation.INSFastEnumeration
    method countByEnumeratingWithState(aState: ^NSFastEnumerationState) objects(stackbuf: ^T) count(len: NSUInteger): NSUInteger; mapped to countByEnumeratingWithState(aState) objects(^id(stackbuf)) count(len);
  end;


  extension method INSFastEnumeration<T>.GetSequence<T>: sequence of T; iterator; public;
  where T is unconstrained;
  begin
    var lState: NSFastEnumerationState;
    var lDest: array[0..3] of T;
    loop begin
      var n := self.countByEnumeratingWithState(@lState) objects(@lDest) count(4);
      if n = 0 then break;
      for i: Integer := 0 to n -1 do begin
        yield(T(lState.itemsPtr[i]));
      end;
    end;
  end;

  extension method INSFastEnumeration.GetSequence: sequence of id; public; iterator;
  begin
    var lState: NSFastEnumerationState;
    var lDest: array[0..3] of id;
    loop begin
      var n := self.countByEnumeratingWithState(@lState) objects(@lDest) count(4);
      if n = 0 then break;
      for i: Integer := 0 to n -1 do begin
        yield(id(lState.itemsPtr[i]));
      end;
    end;
  end;

type
  NSFastExtByte = public extension class(INSFastEnumeration<not nullable NSNumber<Byte>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Byte(el);
    end;
  end;

  NSFastExtSByte = public extension class(INSFastEnumeration<not nullable NSNumber<SByte>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield SByte(el);
    end;
  end;

  NSFastExtInt16 = public extension class(INSFastEnumeration<not nullable NSNumber<Int16>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Int16(el);
    end;
  end;

  NSFastExtUInt16 = public extension class(INSFastEnumeration<not nullable NSNumber<UInt16>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield UInt16(el);
    end;
  end;

  NSFastExtInt32 = public extension class(INSFastEnumeration<not nullable NSNumber<Int32>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Int16(el);
    end;
  end;

  NSFastExtUInt32 = public extension class(INSFastEnumeration<not nullable NSNumber<UInt32>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield UInt32(el);
    end;
  end;

  NSFastExtInt64 = public extension class(INSFastEnumeration<not nullable NSNumber<Int64>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Int64(el);
    end;
  end;

  NSFastExtUInt64 = public extension class(INSFastEnumeration<not nullable NSNumber<UInt64>>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield UInt64(el);
    end;
  end;

[Obsolete("Use ToNSArray() instead")]
extension method Foundation.INSFastEnumeration.array: not nullable NSArray; public; inline;
begin
  result := self.ToNSArray;
end;

extension method Foundation.INSFastEnumeration.ToNSArray: not nullable NSArray; public;
begin
  var lRes: not nullable NSMutableArray := new NSMutableArray;
  for each el in self do
    lRes.addObject(el);

  exit lRes;
end;

extension method INSFastEnumeration.Cast<T>(): sequence of T; iterator;
begin
  for each el in self do
    yield el as T;
end;


extension method Foundation.INSFastEnumeration.dictionary(aKeyBlock: IDBlock; aValueBlock: IDBlock): not nullable NSDictionary; public;
begin
  var lArray := self.ToNSArray();
  result := new NSMutableDictionary withCapacity(lArray.count);
  for each i in lArray do
    NSMutableDictionary(result)[aKeyBlock(i)] := aValueBlock(i);
end;

extension method IEnumerable<T>.array<T>: not nullable NSArray<T>; public;
begin
  var lRes: not nullable NSMutableArray := new NSMutableArray;
  for each el in self do
    lRes.addObject(coalesce(el, NSNull.null));

  exit lRes;
end;

extension method INSFastEnumeration<T>.Count(): Integer; public;
where T is NSObject;
begin
  exit self.GetSequence<T>().Count;
end;

extension method INSFastEnumeration<T>.Count(aCond: not nullable block(aItem: not nullable T): Boolean): Integer; public;
where T is NSObject;
begin
  exit self.GetSequence<T>().Count(aCond);
end;

extension method INSFastEnumeration<T>.Where(aBlock: not nullable block(aItem: not nullable T): Boolean): sequence of T; public;
where T is NSObject;
begin
  exit self.GetSequence<T>().Where(aBlock);
end;

extension method INSFastEnumeration<T>.Select<T, K>(aBlock: not nullable block(aItem: not nullable T): K): sequence of K; public;
where T is NSObject;
begin
  exit self.GetSequence<T>().Select(aBlock);
end;

extension method INSFastEnumeration<T>.FirstOrDefault<T>(aBlock: not nullable block(aItem: not nullable T): Boolean): T; public;
where T is NSObject;
begin
  exit self.GetSequence<T>().FirstOrDefault(aBlock);
end;

extension method INSFastEnumeration<T>.FirstOrDefault<T>(): T; public;
where T is NSObject;
begin
  exit self.GetSequence<T>().FirstOrDefault();
end;

[SymbolName('__elements_ObjcClassInfoToString'), Used]
method __elements_ObjcClassInfoToString(clz: &Class): String;
begin
  var sb := new JsonSerializer();
  sb.StartObject;
  sb.SelectProperty(true, 'name');
  sb.WriteString(String.FromPAnsiChars(class_getName(clz)));

  var sz := class_getSuperclass(clz);
  if sz <> nil then begin
    sb.SelectProperty(false, 'base');
    sb.WriteString(String.FromPAnsiChars(class_getName(sz)));
  end;

  sb.SelectProperty(false, 'methods');
  sb.StartList;
  var methodCount: UInt32 := 0;
  var methods: ^&Method := class_copyMethodList(clz, @methodCount);
  for i: Integer := 0 to methodCount - 1 do begin
    var &method: &Method := methods[i];
    sb.StartListEntry(i = 0);
    sb.StartObject;
    sb.SelectProperty(true, 'selector');
    sb.WriteString(String.FromPAnsiChars(sel_getName(method_getName(&method))));
    sb.SelectProperty(false, 'signature');
    sb.WriteString(String.FromPAnsiChars(method_getTypeEncoding(&method)));
    sb.SelectProperty(false, 'implementation');
    var imp := method_getImplementation(&method);
    sb.WriteString(^IntPtr(@imp)^.ToString);

    sb.EndObject;
  end;
  rtl.free(methods);
  sb.EndList;

  begin
    sb.SelectProperty(false, 'properties');
    sb.StartList;
    //var methodCount: UInt32 := 0;
    var props: ^objc_property_t := class_copyPropertyList(clz, @methodCount);
    for i: Integer := 0 to methodCount - 1 do begin
      var &prop := props[i];
      sb.StartListEntry(i = 0);
      sb.StartObject;
      sb.SelectProperty(true, 'name');
      sb.WriteString(String.FromPAnsiChars(property_getName(&prop)));
      sb.SelectProperty(false, 'signature');
      sb.WriteString(String.FromPAnsiChars(property_getAttributes(&prop)));
      sb.EndObject;
    end;
    rtl.free(props);
    sb.EndList;
  end;

  begin
    sb.SelectProperty(false, 'fields');
    sb.StartList;
    //var methodCount: UInt32 := 0;
    var props: ^Ivar := class_copyIvarList(clz, @methodCount);
    for i: Integer := 0 to methodCount - 1 do begin
      var &prop := props[i];
      sb.StartListEntry(i = 0);
      sb.StartObject;
      sb.SelectProperty(true, 'name');
      sb.WriteString(String.FromPAnsiChars(ivar_getName(&prop)));
      sb.SelectProperty(false, 'type');
      sb.WriteString(String.FromPAnsiChars(ivar_getTypeEncoding(&prop)));
      sb.SelectProperty(false, 'offset');
      sb.WriteValue(ivar_getOffset(&prop));
      sb.EndObject;
    end;
    rtl.free(props);
    sb.EndList;
  end;

  /*begin
    sb.SelectProperty(false, 'protocols');
    sb.StartList;
    //var methodCount: UInt32 := 0;
    var props := class_copyProtocolList(clz, @methodCount);
    for i: Integer := 0 to methodCount - 1 do begin
      var &prop := props[i];
      sb.StartListEntry(i = 0);
      sb.WriteString(String.FromPAnsiChars(protocol_getName(&prop)));
    end;
    rtl.free(props);
    sb.EndList;
  end;*/

  clz := objc_getMetaClass(class_getName(clz));

  sb.SelectProperty(false, 'classMethods');
  sb.StartList;
  methodCount := 0;
  methods := class_copyMethodList(clz, @methodCount);
  for i: Integer := 0 to methodCount - 1 do begin
    var &method: &Method := methods[i];
    sb.StartListEntry(i = 0);
    sb.StartObject;
    sb.SelectProperty(true, 'selector');
    sb.WriteString(String.FromPAnsiChars(sel_getName(method_getName(&method))));
    sb.SelectProperty(false, 'signature');
    sb.WriteString(String.FromPAnsiChars(method_getTypeEncoding(&method)));
    sb.SelectProperty(false, 'implementation');
    var imp := method_getImplementation(&method);
    sb.WriteString(^IntPtr(@imp)^.ToString);
    sb.EndObject;
  end;
  rtl.free(methods);
  sb.EndList;

  begin
    sb.SelectProperty(false, 'classProperties');
    sb.StartList;
    //var methodCount: UInt32 := 0;
    var props: ^objc_property_t := class_copyPropertyList(clz, @methodCount);
    for i: Integer := 0 to methodCount - 1 do begin
      var &prop := props[i];
      sb.StartListEntry(i = 0);
      sb.StartObject;
      sb.SelectProperty(true, 'name');
      sb.WriteString(String.FromPAnsiChars(property_getName(&prop)));
      sb.SelectProperty(false, 'signature');
      sb.WriteString(String.FromPAnsiChars(property_getAttributes(&prop)));
      sb.EndObject;
    end;
    rtl.free(props);
    sb.EndList;
  end;

  sb.EndObject;

  exit sb.ToString;
end;

{$ENDIF}

end.