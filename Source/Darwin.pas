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
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_copyWeak')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_destroyWeak')]
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
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_objc_ehtype_vtable')]
[assembly:DllImport('/usr/lib/system/libdyld.dylib', EntryPoint := '__tlv_bootstrap')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_NSConcreteGlobalBlock')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_NSConcreteStackBlock')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_Block_object_assign')]
[assembly:DllImport('/usr/lib/libobjc.A.dylib', EntryPoint := '_Block_object_dispose')]

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


  operator Implicit<T>(aIn: NSArray<T>): sequence of T; public;
  begin
    exit INSFastEnumeration<T>(aIn).GetSequence;
  end;

  operator Implicit<T>(aIn: NSMutableArray<T>): sequence of T; public;
  begin
    exit INSFastEnumeration<T>(aIn).GetSequence;
  end;

  extension method INSFastEnumeration<T>.GetSequence<T>: sequence of T; iterator;
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

  extension method INSFastEnumeration.GetSequence: sequence of id;
  begin
    exit INSFastEnumeration<id>(self).GetSequence;
  end;
type
  NSFastExtByte = public extension class(INSFastEnumeration<nullable not nullable Byte>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Byte(el);
    end;
  end;


  NSFastExtSByte = public extension class(INSFastEnumeration<nullable not nullable SByte>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield SByte(el);
    end;
  end;

  NSFastExtInt16 = public extension class(INSFastEnumeration<nullable not nullable Int16>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Int16(el);
    end;
  end;


  NSFastExtUInt16 = public extension class(INSFastEnumeration<nullable not nullable UInt16>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield UInt16(el);
    end;
  end;



  NSFastExtInt32 = public extension class(INSFastEnumeration<nullable not nullable Int32>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Int16(el);
    end;
  end;


  NSFastExtUInt32 = public extension class(INSFastEnumeration<nullable not nullable UInt32>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield UInt32(el);
    end;
  end;


  NSFastExtInt64 = public extension class(INSFastEnumeration<nullable not nullable Int64>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield Int64(el);
    end;
  end;


  NSFastExtUInt64 = public extension class(INSFastEnumeration<nullable not nullable UInt64>)
  public

    method GetSequence: sequence of Byte; iterator;
    begin
      for each el in self.GetSequence do
        yield UInt64(el);
    end;
  end;


extension method Foundation.INSFastEnumeration.ToNSArray: not nullable NSArray; public;
begin
  var lRes: not nullable NSMutableArray := new NSMutableArray;
  for each el in self do
    lRes.addObject(el);

  exit lRes;
end;

type IDBlock = public block(aItem: not nullable id): id;

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
begin
  exit self.GetSequence.Count;
end;

extension method INSFastEnumeration<T>.Count(aCond: not nullable block(aItem: not nullable T): Boolean): Integer; public;
begin
  exit self.GetSequence.Count(aCond);
end;

extension method INSFastEnumeration<T>.Where(aBlock: not nullable block(aItem: not nullable T): Boolean): sequence of T; public;
begin
  exit self.GetSequence.Where(aBlock);
end;


extension method INSFastEnumeration<T>.Select<T, K>(aBlock: not nullable block(aItem: not nullable T): K): sequence of K; public;
begin
  exit self.GetSequence.Select(aBlock);
end;


extension method INSFastEnumeration<T>.FirstOrDefault<T>(aBlock: not nullable block(aItem: not nullable T): Boolean): T; public;
begin
  exit self.GetSequence.FirstOrDefault(aBlock);
end;


extension method INSFastEnumeration<T>.FirstOrDefault<T>(): T; public;
begin
  exit self.GetSequence.FirstOrDefault();
end;
end.