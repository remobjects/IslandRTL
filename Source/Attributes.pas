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
    {$HINT Handle `AttributeUsageAttribute.Inherited` in compiler}
    property &Inherited: Boolean;
  end;

  CallingConvention = public enum (Default, FastCall, Stdcall, Cdecl);

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

  [AttributeUsage(AttributeTargets.Method)]
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
  end;

  [AttributeUsage(AttributeTargets.Parameter)]
  InRegAttribute = public class(Attribute)
  public
    constructor(); empty;
  end;

  [AttributeUsage(AttributeTargets.Interface, AllowMultiple := false)]
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
  // Inline asm *METHOD*
  [AttributeUsage(AttributeTargets.Method)]
  InlineAsmAttribute = public class(Attribute)
  public
    constructor(aAsm: String; aConstraints: String; aSideEffects, aAlign: Boolean);
    begin
      Asm := aAsm;
      Constraints := aConstraints;
      SideEffects := aSideEffects;
      Align := aAlign;
    end;
    property Asm: String;readonly;
    property Constraints: String;readonly;
    property SideEffects: Boolean;readonly;
    property Align: Boolean; readonly;
  end;

  [AttributeUsage(AttributeTargets.Struct)]
  UnionAttribute = public class(Attribute)
  end;

  [AttributeUsage(AttributeTargets.Struct)]
  PackedAttribute = public class(Attribute)
  end;

end.