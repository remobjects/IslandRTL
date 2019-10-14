namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  BitConverterTest = public class(Test)
  private
  public
    method GetBytesUInt32;
    begin
      var x1 :UInt32 := $01020304;
      BitConverter.IsLittleEndian := false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0], 4);
      Assert.AreEqual(x2[1], 3);
      Assert.AreEqual(x2[2], 2);
      Assert.AreEqual(x2[3], 1);
      Assert.AreEqual(x1, BitConverter.ToValue<UInt32>(x2));
      
      BitConverter.IsLittleEndian := true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0], 1);
      Assert.AreEqual(x2[1], 2);
      Assert.AreEqual(x2[2], 3);
      Assert.AreEqual(x2[3], 4);
      Assert.AreEqual(x1, BitConverter.ToValue<UInt32>(x2));
    end;

    method GetBytesInt32;
    begin
      var x1 :Int32 := $01020304;
      BitConverter.IsLittleEndian := false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0], 4);
      Assert.AreEqual(x2[1], 3);
      Assert.AreEqual(x2[2], 2);
      Assert.AreEqual(x2[3], 1);
      Assert.AreEqual(x1, BitConverter.ToValue<Int32>(x2));
      
      BitConverter.IsLittleEndian := true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0], 1);
      Assert.AreEqual(x2[1], 2);
      Assert.AreEqual(x2[2], 3);
      Assert.AreEqual(x2[3], 4);
      Assert.AreEqual(x1, BitConverter.ToValue<Int32>(x2));
    end;

    method GetBytesInt16;
    begin
      var x1 :Int16 := $9563;
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 2);
      Assert.AreEqual(x2[0],$63);
      Assert.AreEqual(x2[1],$95);
      Assert.AreEqual(x1, BitConverter.ToValue<Int16>(x2));
      
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 2);
      Assert.AreEqual(x2[0],$95);
      Assert.AreEqual(x2[1],$63);
      Assert.AreEqual(x1, BitConverter.ToValue<Int16>(x2));
    end;

    method GetBytesUInt16;
    begin
      var x1 :UInt16 := $9563;
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 2);
      Assert.AreEqual(x2[0],$63);
      Assert.AreEqual(x2[1],$95);
      Assert.AreEqual(x1, BitConverter.ToValue<UInt16>(x2));
      
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 2);
      Assert.AreEqual(x2[0],$95);
      Assert.AreEqual(x2[1],$63);
      Assert.AreEqual(x1, BitConverter.ToValue<UInt16>(x2));
    end;

    method GetBytesInt64;
    begin
      var x1 :Int64 := $1234567887654321;
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[0],$21);
      Assert.AreEqual(x2[1],$43);
      Assert.AreEqual(x2[2],$65);
      Assert.AreEqual(x2[3],$87);
      Assert.AreEqual(x2[4],$78);
      Assert.AreEqual(x2[5],$56);
      Assert.AreEqual(x2[6],$34);
      Assert.AreEqual(x2[7],$12);
      Assert.AreEqual(x1, BitConverter.ToValue<Int64>(x2));
      
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[7],$21);
      Assert.AreEqual(x2[6],$43);
      Assert.AreEqual(x2[5],$65);
      Assert.AreEqual(x2[4],$87);
      Assert.AreEqual(x2[3],$78);
      Assert.AreEqual(x2[2],$56);
      Assert.AreEqual(x2[1],$34);
      Assert.AreEqual(x2[0],$12);
      Assert.AreEqual(x1, BitConverter.ToValue<Int64>(x2));
    end;
    
    method GetBytesUInt64;
    begin
      var x1 :UInt64 := $1234567887654321;
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[0],$21);
      Assert.AreEqual(x2[1],$43);
      Assert.AreEqual(x2[2],$65);
      Assert.AreEqual(x2[3],$87);
      Assert.AreEqual(x2[4],$78);
      Assert.AreEqual(x2[5],$56);
      Assert.AreEqual(x2[6],$34);
      Assert.AreEqual(x2[7],$12);
      Assert.AreEqual(x1, BitConverter.ToValue<UInt64>(x2));
      
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[7],$21);
      Assert.AreEqual(x2[6],$43);
      Assert.AreEqual(x2[5],$65);
      Assert.AreEqual(x2[4],$87);
      Assert.AreEqual(x2[3],$78);
      Assert.AreEqual(x2[2],$56);
      Assert.AreEqual(x2[1],$34);
      Assert.AreEqual(x2[0],$12);
      Assert.AreEqual(x1, BitConverter.ToValue<UInt64>(x2));
    end;
    
    method GetBytesBoolean;
    begin
      var x1 :Boolean := true;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 1);
      Assert.AreEqual(x2[0],1);
      Assert.AreEqual(x1, BitConverter.ToValue<Boolean>(x2));
    end;
    
    method GetBytesChar;
    begin
      var x1 : Char := 'B';
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 2);
      Assert.AreEqual(x2[0],66);
      Assert.AreEqual(x2[1],0);
      Assert.AreEqual(x1, BitConverter.ToValue<Char>(x2));

      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 2);
      Assert.AreEqual(x2[0],0);
      Assert.AreEqual(x2[1],66);
      Assert.AreEqual(x1, BitConverter.ToValue<Char>(x2));
    end;
    
    method GetBytesSByte;
    begin
      var x1 :SByte := $AB;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 1);
      Assert.AreEqual(x2[0],$AB);
      Assert.AreEqual(x1, BitConverter.ToValue<SByte>(x2));
    end;
    method GetBytesByte;
    begin
      var x1 :Byte := $AB;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 1);
      Assert.AreEqual(x2[0],$AB);
      Assert.AreEqual(x1, BitConverter.ToValue<Byte>(x2));
    end;
    method GetBytesSingle;
    begin
      var x1 :Single := 1234.421;
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0],121);
      Assert.AreEqual(x2[1],77);
      Assert.AreEqual(x2[2],154);
      Assert.AreEqual(x2[3],68);
      Assert.AreEqual(x1, BitConverter.ToValue<Single>(x2));
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[3],121);
      Assert.AreEqual(x2[2],77);
      Assert.AreEqual(x2[1],154);
      Assert.AreEqual(x2[0],68);
      Assert.AreEqual(x1, BitConverter.ToValue<Single>(x2));
    end;
    method GetBytesDouble;
    begin
      var x1 :Double := 1234.421;
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[0],119);
      Assert.AreEqual(x2[1],190);
      Assert.AreEqual(x2[2],159);
      Assert.AreEqual(x2[3],26);
      Assert.AreEqual(x2[4],175);
      Assert.AreEqual(x2[5],73);
      Assert.AreEqual(x2[6],147);
      Assert.AreEqual(x2[7],64);
      Assert.AreEqual(x1, BitConverter.ToValue<Double>(x2));
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[7],119);
      Assert.AreEqual(x2[6],190);
      Assert.AreEqual(x2[5],159);
      Assert.AreEqual(x2[4],26);
      Assert.AreEqual(x2[3],175);
      Assert.AreEqual(x2[2],73);
      Assert.AreEqual(x2[1],147);
      Assert.AreEqual(x2[0],64);
      Assert.AreEqual(x1, BitConverter.ToValue<Double>(x2));
    end;
    method GetBytesIntPtr;
    begin
      var x1 :IntPtr := {$IFDEF cpu64}$1234567887654321{$ELSE}$12345678{$ENDIF};
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      {$IFDEF cpu64}
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[0],$21);
      Assert.AreEqual(x2[1],$43);
      Assert.AreEqual(x2[2],$65);
      Assert.AreEqual(x2[3],$87);
      Assert.AreEqual(x2[4],$78);
      Assert.AreEqual(x2[5],$56);
      Assert.AreEqual(x2[6],$34);
      Assert.AreEqual(x2[7],$12);
        {$ELSE}
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0],$78);
      Assert.AreEqual(x2[1],$56);
      Assert.AreEqual(x2[2],$34);
      Assert.AreEqual(x2[3],$12);
        {$ENDIF}
      Assert.AreEqual(x1, BitConverter.ToValue<IntPtr>(x2));
      
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      {$IFDEF cpu64}
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[7],$21);
      Assert.AreEqual(x2[6],$43);
      Assert.AreEqual(x2[5],$65);
      Assert.AreEqual(x2[4],$87);
      Assert.AreEqual(x2[3],$78);
      Assert.AreEqual(x2[2],$56);
      Assert.AreEqual(x2[1],$34);
      Assert.AreEqual(x2[0],$12);
        {$ELSE}
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[3],$78);
      Assert.AreEqual(x2[2],$56);
      Assert.AreEqual(x2[1],$34);
      Assert.AreEqual(x2[0],$12);
        {$ENDIF}
      Assert.AreEqual(x1, BitConverter.ToValue<IntPtr>(x2));
    end;
    method GetBytesUIntPtr;
    begin
      var x1 :UIntPtr := {$IFDEF cpu64}$1234567887654321{$ELSE}$12345678{$ENDIF};
      BitConverter.IsLittleEndian :=false;
      var x2 := BitConverter.GetBytes(x1);
      {$IFDEF cpu64}
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[0],$21);
      Assert.AreEqual(x2[1],$43);
      Assert.AreEqual(x2[2],$65);
      Assert.AreEqual(x2[3],$87);
      Assert.AreEqual(x2[4],$78);
      Assert.AreEqual(x2[5],$56);
      Assert.AreEqual(x2[6],$34);
      Assert.AreEqual(x2[7],$12);
        {$ELSE}
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[0],$78);
      Assert.AreEqual(x2[1],$56);
      Assert.AreEqual(x2[2],$34);
      Assert.AreEqual(x2[3],$12);
        {$ENDIF}
      Assert.AreEqual(x1, BitConverter.ToValue<UIntPtr>(x2));
      
      BitConverter.IsLittleEndian :=true;
      x2 := BitConverter.GetBytes(x1);
      {$IFDEF cpu64}
      Assert.AreEqual(x2.Length, 8);
      Assert.AreEqual(x2[7],$21);
      Assert.AreEqual(x2[6],$43);
      Assert.AreEqual(x2[5],$65);
      Assert.AreEqual(x2[4],$87);
      Assert.AreEqual(x2[3],$78);
      Assert.AreEqual(x2[2],$56);
      Assert.AreEqual(x2[1],$34);
      Assert.AreEqual(x2[0],$12);
        {$ELSE}
      Assert.AreEqual(x2.Length, 4);
      Assert.AreEqual(x2[3],$78);
      Assert.AreEqual(x2[2],$56);
      Assert.AreEqual(x2[1],$34);
      Assert.AreEqual(x2[0],$12);
        {$ENDIF}
      Assert.AreEqual(x1, BitConverter.ToValue<UIntPtr>(x2));
    end;
    method Int64BitsToDouble;
    begin
      var x1 :Double := 1234.4321;
      BitConverter.IsLittleEndian:=false;
      var x2 := BitConverter.DoubleToInt64Bits(x1);
      Assert.AreEqual(x2, 4653143905236951656);
      Assert.AreEqual(x1, BitConverter.Int64BitsToDouble(x2));
    end;
    method ToStringTest;
    begin
      var x1: Int64 := $F1E2D3C4B5A69788;
      BitConverter.IsLittleEndian:=false;
      var x2 := BitConverter.GetBytes(x1);
      var x3 := BitConverter.ToString(x2, 0,8);
      Assert.AreEqual(x3, "88-97-A6-B5-C4-D3-E2-F1");
    end;
  end;
end.