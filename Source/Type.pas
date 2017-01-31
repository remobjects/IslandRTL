namespace RemObjects.Elements.System;

interface

type
  &Type = public record
  assembly
    fValue: ^IslandTypeInfo;
  protected
  public
    constructor(aValue: ^IslandTypeInfo);
    property RTTI: ^IslandTypeInfo read fValue;
    property &Name: String read String.FromPAnsiChars(fValue^.Ext^.Name);
    property &Flags: IslandTypeFlags read fValue^.Ext^.Flags;
    method Equals(other: Object): Boolean; override;
    method GetHashCode: Integer; override;
  end;

  IslandExtTypeInfo = public record
  private
  public
    &Flags: IslandTypeFlags;
    Name: ^AnsiChar;
    SubType: ^IslandTypeInfo; // If Generic, this will be the "non generic" type
  end;

  IslandTypeInfo = public record
  private
  public
    Ext: ^IslandExtTypeInfo;
    ParentType: ^IslandTypeInfo;
    InterfaceType: ^IslandInterfaceTable;
    InterfaceVMT: ^Void;
    Hash1: Int64;
    Hash2: Int64;
  end;

  IslandInterfaceTable = public record
  public
    HashTableSize: Integer;
    FirstEntry: ^^IslandTypeInfo; // ends with 0
  end;

  // Keep in sync with compiler.
  IslandTypeFlags = public flags (
    // First 3 bits reserved for type kind
    TypeKindMask  = (1 shl 0) or (1 shl 1) or (1 shl 2) ,
    &Class = 0,
    &Enum = 1,
    EnumFlags = 2,
    &Delegate = 3,
    Struct = 4,
    &Interface = 5,
    &Extension = 6,
    &Array = 7,
    Pointer = 8,
    &Set = 9,
    MemberInfoPresent = 16,
    Generic = 32) of UInt64;

implementation

method &Type.Equals(other: Object): Boolean;
begin
  exit (other is &Type) and (&Type(other).fValue = fValue);
end;

method &Type.GetHashCode: Integer;
begin
  exit Integer({$ifdef cpu64}Int64(fValue) xor (Int64(fValue) shr 32) * 7{$else}fValue{$endif});
end;

constructor &Type(aValue: ^IslandTypeInfo);
begin
  fValue := aValue;
end;

end.
