namespace Island.Tests.Shared;

uses
  RemObjects.Elements.EUnit;

type
  TextConvert_Utf_conversion = public class(Test)
  private
    const ggg: String = 'русский текст';
    const ggg_UTF8: array of Byte =                       [$D1, $80, $D1, $83, $D1, $81, $D1, $81, $D0, $BA, $D0, $B8, $D0, $B9, $20, $D1, $82, $D0, $B5, $D0, $BA, $D1, $81, $D1, $82];
    const ggg_UTF8_BOM: array of Byte =    [$EF, $BB, $BF, $D1, $80, $D1, $83, $D1, $81, $D1, $81, $D0, $BA, $D0, $B8, $D0, $B9, $20, $D1, $82, $D0, $B5, $D0, $BA, $D1, $81, $D1, $82];
    const ggg_UTF16LE: array of Byte =               [$40, $04, $43, $04, $41, $04, $41, $04, $3A, $04, $38, $04, $39, $04, $20, $00, $42, $04, $35, $04, $3A, $04, $41, $04, $42, $04];
    const ggg_UTF16LE_BOM: array of Byte = [$FF, $FE, $40, $04, $43, $04, $41, $04, $41, $04, $3A, $04, $38, $04, $39, $04, $20, $00, $42, $04, $35, $04, $3A, $04, $41, $04, $42, $04];
    const ggg_UTF16BE: array of Byte =               [$04, $40, $04, $43, $04, $41, $04, $41, $04, $3A, $04, $38, $04, $39, $00, $20, $04, $42, $04, $35, $04, $3A, $04, $41, $04, $42];
    const ggg_UTF16BE_BOM: array of Byte = [$FE, $FF, $04, $40, $04, $43, $04, $41, $04, $41, $04, $3A, $04, $38, $04, $39, $00, $20, $04, $42, $04, $35, $04, $3A, $04, $41, $04, $42];
    const ggg_UTF32LE: array of Byte =                         [$40, $04, $00, $00, $43, $04, $00, $00, $41, $04, $00, $00, $41, $04, $00, $00, $3A, $04, $00, $00, $38, $04, $00, $00, $39, $04, $00, $00, $20, $00, $00, $00, $42, $04, $00, $00, $35, $04, $00, $00, $3A, $04, $00, $00, $41, $04, $00, $00, $42, $04, $00, $00];
    const ggg_UTF32LE_BOM: array of Byte = [$FF, $FE, $00, $00, $40, $04, $00, $00, $43, $04, $00, $00, $41, $04, $00, $00, $41, $04, $00, $00, $3A, $04, $00, $00, $38, $04, $00, $00, $39, $04, $00, $00, $20, $00, $00, $00, $42, $04, $00, $00, $35, $04, $00, $00, $3A, $04, $00, $00, $41, $04, $00, $00, $42, $04, $00, $00];
    const ggg_UTF32BE: array of Byte =                         [$00, $00, $04, $40, $00, $00, $04, $43, $00, $00, $04, $41, $00, $00, $04, $41, $00, $00, $04, $3A, $00, $00, $04, $38, $00, $00, $04, $39, $00, $00, $00, $20, $00, $00, $04, $42, $00, $00, $04, $35, $00, $00, $04, $3A, $00, $00, $04, $41, $00, $00, $04, $42];
    const ggg_UTF32BE_BOM: array of Byte = [$00, $00, $FE, $FF, $00, $00, $04, $40, $00, $00, $04, $43, $00, $00, $04, $41, $00, $00, $04, $41, $00, $00, $04, $3A, $00, $00, $04, $38, $00, $00, $04, $39, $00, $00, $00, $20, $00, $00, $04, $42, $00, $00, $04, $35, $00, $00, $04, $3A, $00, $00, $04, $41, $00, $00, $04, $42];
    class method ArraytoString(aValue: array of Byte):String;
    begin
      var str := new StringBuilder;
      for i:Integer:=0 to aValue.Length-1 do
        str.Append(aValue[i].ToString+',');
      exit str.ToString;
    end;
  public
    method test_UTF8ToString;
    begin
      var b := TextConvert.UTF8ToString(ggg_UTF8);
      Assert.AreEqual(b,ggg);
    end;

    method test_UTF8ToString_BOM;
    begin
      var b := TextConvert.UTF8ToString(ggg_UTF8_BOM);
      Assert.AreEqual(b,ggg);
    end;

    method test_StringToUTF8;
    begin
      var c := TextConvert.StringToUTF8(ggg);
      var a1 := ArraytoString(ggg_UTF8);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_StringToUTF8_BOM;
    begin
      var c := TextConvert.StringToUTF8(ggg,True);
      var a1 := ArraytoString(ggg_UTF8_BOM);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_UTF16LEToString;
    begin
      var b :=  TextConvert.UTF16LEToString(ggg_UTF16LE);
      Assert.AreEqual(b, ggg);
    end;

    method test_UTF16LEToString_BOM;
    begin
      var b :=  TextConvert.UTF16LEToString(ggg_UTF16LE_BOM);
      Assert.AreEqual(b, ggg);
    end;

    method test_StringToUTF16LE;
    begin
      var c := TextConvert.StringToUTF16LE(ggg);
      var a1 := ArraytoString(ggg_UTF16LE);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_StringToUTF16LE_BOM;
    begin
      var c := TextConvert.StringToUTF16LE(ggg,True);
      var a1 := ArraytoString(ggg_UTF16LE_BOM);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_UTF16BEToString;
    begin
      var b :=  TextConvert.UTF16BEToString(ggg_UTF16BE);
      Assert.AreEqual(b,ggg);
    end;

    method test_UTF16BEToString_BOM;
    begin
      var b :=  TextConvert.UTF16BEToString(ggg_UTF16BE_BOM);
      Assert.AreEqual(b,ggg);
    end;

    method test_StringToUTF16BE;
    begin
      var c := TextConvert.StringToUTF16BE(ggg);
      var a1 := ArraytoString(ggg_UTF16BE);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_StringToUTF16BE_BOM;
    begin
      var c := TextConvert.StringToUTF16BE(ggg,True);
      var a1 := ArraytoString(ggg_UTF16BE_BOM);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_UTF32LEToString;
    begin
      var b :=  TextConvert.UTF32LEToString(ggg_UTF32LE);
      Assert.AreEqual(b,ggg);
    end;

    method test_UTF32LEToString_BOM;
    begin
      var b :=  TextConvert.UTF32LEToString(ggg_UTF32LE_BOM);
      Assert.AreEqual(b, ggg);
    end;

    method test_StringToUTF32LE;
    begin
      var c := TextConvert.StringToUTF32LE(ggg);
      var a1 := ArraytoString(ggg_UTF32LE);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_StringToUTF32LE_BOM;
    begin
      var c := TextConvert.StringToUTF32LE(ggg, True);
      var a1 := ArraytoString(ggg_UTF32LE_BOM);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_UTF32BEToString;
    begin
      var b :=  TextConvert.UTF32BEToString(ggg_UTF32BE);
      Assert.AreEqual(b,ggg);
    end;

    method test_UTF32BEToString_BOM;
    begin
      var b :=  TextConvert.UTF32BEToString(ggg_UTF32BE_BOM);
      Assert.AreEqual(b,ggg);
    end;

    method test_StringToUTF32BE;
    begin
      var c := TextConvert.StringToUTF32BE(ggg);
      var a1 := ArraytoString(ggg_UTF32BE);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test_StringToUTF32BE_BOM;
    begin
      var c := TextConvert.StringToUTF32BE(ggg,True);
      var a1 := ArraytoString(ggg_UTF32BE_BOM);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);
    end;

    method test;
    begin
      var a: array of Byte  := [$F4, $8F, $BF, $BD];
      var b :=  TextConvert.UTF8ToString(a);
      var c := TextConvert.StringToUTF8(b);
      var a1 := ArraytoString(a);
      var c1 := ArraytoString(c);
      Assert.AreEqual(a1,c1);

      c := TextConvert.StringToUTF16BE(b);
      a1 := ArraytoString(c);//16be
      a := [$DB, $FF, $DF, $FD];
      c1 := ArraytoString(a);
      Assert.AreEqual(a1,c1);

      c := TextConvert.StringToUTF32BE(b);
      a1 := ArraytoString(c);//32be
      a := [$00, $10,$FF, $FD];
      c1 := ArraytoString(a);
      Assert.AreEqual(a1,c1);
    end;

  end;

end.