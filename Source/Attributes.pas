namespace RemObjects.Elements.System;


type
  Attribute = public class(Object)
  end;

  AttributeTargets = public flags (
    &Assembly = 1 shl 0,
    &Class = 1 shl 2,
    &Struct = 1 shl 3,
    &Enum = 1 shl 4,
    &Constructor = 1 shl 5,
    &Method = 1 shl 6,
    &Property = 1 shl 7,
    &Field = 1 shl 8,
    &Event = 1 shl 9,
    &Interface = 1 shl 10,
    &Parameter = 1 shl 11,
    &Delegate = 1 shl 12,
    &ReturnValue = 1 shl 13);

  [AttributeUsage(AttributeTargets.Class)]
  AttributeUsageAttribute = public class(Attribute)
  private
    fValidOn: AttributeTargets;
  public

    constructor (aTargets: AttributeTargets);
    begin
      fValidOn := aTargets;
    end;

    property ValidOn: AttributeTargets read fValidOn;
    property AllowMultiple: Boolean;
    property &Inherited: Boolean;
  end;

  CallingConvention = public enum (Default, FastCall, Stdcall, Cdecl, Swift);

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Delegate)]
  CallingConventionAttribute = public class(Attribute)
  private
    fCC: CallingConvention;
  public

    constructor(aCC: CallingConvention);
    begin
      fCC := aCC;
    end;

    property CC: CallingConvention read fCC;
  end;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Field)]
  SymbolNameAttribute = public class(Attribute)
  private
    fVersion: String;
    fName: String;
    fLibrary: String;
  protected
  public

    constructor(aName: String);
    begin
      fName := aName;
    end;

    constructor(aName, aLibrary: String);
    begin
      fName := aName;
      fLibrary := aLibrary;
    end;

    constructor(aName, aLibrary, aVersion: String);
    begin
      fName := aName;
      fLibrary := aLibrary;
      fVersion := aVersion;
    end;
    property ReferenceFromMain: Boolean;
    property Name: String read fName;
    property Library: String read fLibrary;
    property Version: String read fVersion;
  end;

  [AttributeUsage(AttributeTargets.Field)]
  ThreadLocalAttribute = public class(Attribute)
  public
    constructor; empty;
  end;

  [AttributeUsage(AttributeTargets.Field)]
  StaticAddressAttribute = public class(Attribute)
  public
    constructor(aAddress: NativeInt); empty;
  end;


  [AttributeUsage(AttributeTargets.Enum)]
  FlagsAttribute = public class(Attribute)
  public
    constructor; empty;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  NakedAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  SkipDebugAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  DisableInliningAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  DisableOptimizationsAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Class or AttributeTargets.Struct or
                  AttributeTargets.Enum or AttributeTargets.Constructor or
                  AttributeTargets.Method or AttributeTargets.Property or
                  AttributeTargets.Field or AttributeTargets.Event or
                  AttributeTargets.Interface or AttributeTargets.Delegate)]
  ObsoleteAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
    constructor(aMsg: String; aFail: Boolean := false);
    begin
      Message := aMsg;
      Fail := aFail;
    end;


    property Message: String; readonly;
    property Fail: Boolean; readonly;
  end;

  [AttributeUsage(AttributeTargets.Class or AttributeTargets.Method)]
  ConditionalAttribute = public class(Attribute)
  public
    constructor(aCond: String);
    begin
      Conditional := aCond;
    end;

    property Conditional: String; readonly;
  end;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Field or AttributeTargets.Class or AttributeTargets.Method or AttributeTargets.Interface)]
  UsedAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
    property Inherit: Boolean;
  end;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Field)]
  WeakAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Field)]
  LinkOnceAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  NoReturnAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Field)]
  AliasAttribute = public class(Attribute)
  private
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Field)]
  SectionNameAttribute = public class(Attribute)
  private
    fName: String;
  protected
  public
    constructor(aName: String);
    begin
      fName := aName;
    end;

    property Name: String read fName;
  end;

  ExportAttribute = public DllExportAttribute;
  ImportAttribute = public DllImportAttribute;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Assembly, AllowMultiple := true)]
  DllImportAttribute = public class(Attribute)
  private
    fDllName: String;
  public
    constructor(aDllName: String);
    begin
      fDllName := aDllName;
    end;

    property DllName: String read fDllName;
    property EntryPoint: String;
  end;

  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Field or AttributeTargets.Property or AttributeTargets.Event or AttributeTargets.Struct or AttributeTargets.Class or AttributeTargets.Enum or AttributeTargets.Delegate)]
  DllExportAttribute = public class(Attribute)
  private
    fName: String;
  public
    constructor; empty;
    constructor(aName: String);
    begin
      fName := aName;
    end;

    property Name: String read fName;
  end;

  [AttributeUsage(AttributeTargets.Parameter)]
  InRegAttribute = public class(Attribute)
  public
    constructor(); empty;
  end;


  [AttributeUsage(AttributeTargets.Parameter)]
  SwiftSelfAttribute = public class(Attribute)
  public
    constructor(); empty;
  end;


  [AttributeUsage(AttributeTargets.Parameter)]
  SRetAttribute = public class(Attribute)
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Interface or AttributeTargets.Class or AttributeTargets.Delegate or AttributeTargets.Enum or AttributeTargets.Struct, AllowMultiple := false)]
  GuidAttribute = public class(Attribute)
  private
    fGuid: Guid;
  public
    constructor(aGuid: String);
    begin
      fGuid := new Guid(aGuid);
    end;

    property &Guid: Guid read fGuid;
  end;
  // Inline asm method, or global assembly.
  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Assembly)]
  InlineAsmAttribute = public class(Attribute)
  public
    constructor(aAsm: String; aConstraints: String := ''; aSideEffects: Boolean := false; aAlign: Boolean := false);
    begin
      Asm := aAsm;
      Constraints := aConstraints;
      SideEffects := aSideEffects;
      Align := aAlign;
    end;
    property Asm: String; readonly;
    property Constraints: String; readonly;
    property SideEffects: Boolean; readonly;
    property Align: Boolean; readonly;
  end;

  [AttributeUsage(AttributeTargets.Struct)]
  UnionAttribute = public class(Attribute)
  end;

  [AttributeUsage(AttributeTargets.Struct)]
  PackedAttribute = public class(Attribute)
  end;

  [AttributeUsage(AttributeTargets.Method)]
  GlobalConstructorAttribute = public class(Attribute)
  public
    constructor(aPriority: Integer); empty;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  GlobalDestructorAttribute = public class(Attribute)
  public
    constructor(aPriority: Integer); empty;
  end;

  // When applied, when this fx is loaded the compiler defines that for the project that uses it
  [AttributeUsage(AttributeTargets.Assembly, AllowMultiple := true)]
  AssemblyDefineAttribute = public class(Attribute)
  public
    constructor(aDefine: String);
    begin
      Define := aDefine;
    end;
    property Define: String; readonly;
  end;

  [AttributeUsage(AttributeTargets.Assembly)]
  RemObjects.Elements.System.DefaultObjectLifetimeStrategyAttribute = public class(Attribute)
  public
    /// <summary>
    /// Sets the default lifetime strategy.
    /// </summary>
    /// <param name="aType">lifetime type</param>
    constructor(aType: &Type); empty;
    /// <summary>
    /// Sets the default lifetime strategy.
    /// </summary>
    /// <param name="aType">lifetime type</param>
    /// <param name="aForeign">The lifetime type used when a type is stored in a foreign class model</param>
    constructor(aType, aForeign: &Type); empty;
  end;


  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Constructor)]
  RemObjects.Elements.System.GCSkipIfOnStackAttribute = public class(Attribute)
  public
    constructor; empty;
  end;

  [AttributeUsage(AttributeTargets.Delegate)]
  FunctionPointerAttribute = public class(Attribute)
  end;

  [AttributeUsage(AttributeTargets.Delegate)]
  BlockPointerAttribute = public class(Attribute)
  end;

  [AttributeUsage(AttributeTargets.Assembly, AllowMultiple = true)]
  LifetimeStrategyOverrideAttribute = public class(Attribute)
  public
    constructor(aSource, aLifetimeType: &Type); empty;
  end;


  [AttributeUsage(AttributeTargets.Field)]
  StaticallyInitializedFieldAttribute = public class(Attribute)
  public
    constructor; empty;
  end;

  [AttributeUsage(AttributeTargets.Field)]
  BitPackingAttribute = public class(Attribute)
  public
    constructor(aBitPack: Integer); empty;
  end;


  [AttributeUsage(AttributeTargets.Method or AttributeTargets.Event or AttributeTargets.Property or AttributeTargets.Constructor)]
  PublishedAttribute = public class(Attribute)
  public
    constructor; empty;
  end;

  // Like DLL import but uses LoadLibrary/GetProcAddress.
  [AttributeUsage(AttributeTargets.Method)]
  DelayLoadDllImportAttribute = public class(Attribute)
  public
    constructor(aDllName: String; aEntryPoint: String := nil);
    begin
    end;
  end;

  [AttributeUsage(AttributeTargets.Interface)]
  DynamicInterfaceAttribute = public class(Attribute)
  public
    constructor(aType: &Type; aCheckType: String);
    begin
      &Type := aType;
      CheckType := aCheckType;
    end;

    constructor(aType: &Type);
    begin
      &Type := aType;
    end;

    property &Type: &Type; readonly;
    property CheckType: String; readonly;
  end;

  [AttributeUsage(AttributeTargets.Method)]
  WrapperAttribute = public class(Attribute)
  public
    constructor; empty;
  end;


end.