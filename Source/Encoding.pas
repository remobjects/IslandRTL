namespace RemObjects.Elements.System;

type
  Encoding = public class
  private
  protected
  public

    constructor(aName: not nullable String);
    begin
      Name := aName;
    end;

    property Name: not nullable String; readonly;

    method GetBytes(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      case Name of
        "UTF8": result := TextConvert.StringToUTF8(aValue, aGenerateBOM);
        "UTF16": result := TextConvert.StringToUTF16(aValue, aGenerateBOM);
        "UTF16LE": result := TextConvert.StringToUTF16LE(aValue, aGenerateBOM);
        "UTF16BE": result := TextConvert.StringToUTF16BE(aValue, aGenerateBOM);
        "UTF32": result := TextConvert.StringToUTF32(aValue, aGenerateBOM);
        "UTF32LE": result := TextConvert.StringToUTF32LE(aValue, aGenerateBOM);
        "UTF32BE": result := TextConvert.StringToUTF32BE(aValue, aGenerateBOM);
        else raise new Exception($"Unknown encoding {Name}");
      end;
    end;

    method GetString(aValue: array of Byte; aGenerateBOM: Boolean := False): not nullable String;
    begin
      case Name of
        "UTF8": result := TextConvert.UTF8ToString(aValue);
        "UTF16": result := TextConvert.UTF16ToString(aValue);
        "UTF16LE": result := TextConvert.UTF16LEToString(aValue);
        "UTF16BE": result := TextConvert.UTF16BEToString(aValue);
        "UTF32": result := TextConvert.UTF32ToString(aValue);
        "UTF32LE": result := TextConvert.UTF32LEToString(aValue);
        "UTF32BE": result := TextConvert.UTF32BEToString(aValue);
        else raise new Exception($"Unknown encoding {Name}");
      end;
    end;

    property UTF8: Encoding := new Encoding("UTF8"); lazy; static;
    property UTF16: Encoding := new Encoding("UTF16"); lazy; static;
    property UTF16LE: Encoding := new Encoding("UTF16LE"); lazy; static;
    property UTF16BE: Encoding := new Encoding("UTF16BE"); lazy; static;
    property UTF32: Encoding := new Encoding("UTF32"); lazy; static;
    property UTF32LE: Encoding := new Encoding("UTF32LE"); lazy; static;
    property UTF32BE: Encoding := new Encoding("UTF32BE"); lazy; static;
  end;

end.