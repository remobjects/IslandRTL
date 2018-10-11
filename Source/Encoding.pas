namespace RemObjects.Elements.System;

{$HIDE W37}

type
  Encoding = public class
  private

    constructor(aName: not nullable String);
    begin
      Name := aName;
    end;

  public

    property Name: not nullable String; readonly;

    method GetBytes(aValue: String; aGenerateBOM: Boolean := False): not nullable array of Byte;
    begin
      case Name of
        "UTF-8": result := TextConvert.StringToUTF8(aValue, aGenerateBOM);
        "UTF-16": result := TextConvert.StringToUTF16(aValue, aGenerateBOM);
        "UTF-16LE": result := TextConvert.StringToUTF16LE(aValue, aGenerateBOM);
        "UTF-16BE": result := TextConvert.StringToUTF16BE(aValue, aGenerateBOM);
        "UTF-32": result := TextConvert.StringToUTF32(aValue, aGenerateBOM);
        "UTF-32LE": result := TextConvert.StringToUTF32LE(aValue, aGenerateBOM);
        "UTF-32BE": result := TextConvert.StringToUTF32BE(aValue, aGenerateBOM);
        "ASCII": result := TextConvert.StringToASCII(aValue);
        else raise new Exception($"Unknown encoding {Name}");
      end;
    end;

    method GetString(aValue: array of Byte; aGenerateBOM: Boolean := False): not nullable String;
    begin
      case Name of
        "UTF-8": result := TextConvert.UTF8ToString(aValue);
        "UTF-16": result := TextConvert.UTF16ToString(aValue);
        "UTF-16LE": result := TextConvert.UTF16LEToString(aValue);
        "UTF-16BE": result := TextConvert.UTF16BEToString(aValue);
        "UTF-32": result := TextConvert.UTF32ToString(aValue);
        "UTF-32LE": result := TextConvert.UTF32LEToString(aValue);
        "UTF-32BE": result := TextConvert.UTF32BEToString(aValue);
        "ASCII": result := TextConvert.ASCIIToString(aValue);
        else raise new Exception($"Unknown encoding {Name}");
      end;
    end;

    method GetString(aValue: array of Byte; aOffset: Int64; aCount: Int64; aGenerateBOM: Boolean := False): not nullable String;
    begin
      case Name of
        "UTF-8": result := TextConvert.UTF8ToString(aValue, aOffset, aCount);
        "UTF-16": result := TextConvert.UTF16ToString(aValue, aOffset, aCount);
        "UTF-16LE": result := TextConvert.UTF16LEToString(aValue, aOffset, aCount);
        "UTF-16BE": result := TextConvert.UTF16BEToString(aValue, aOffset, aCount);
        "UTF-32": result := TextConvert.UTF32ToString(aValue, aOffset, aCount);
        "UTF-32LE": result := TextConvert.UTF32LEToString(aValue, aOffset, aCount);
        "UTF-32BE": result := TextConvert.UTF32BEToString(aValue, aOffset, aCount);
        "ASCII": result := TextConvert.ASCIIToString(aValue, aOffset, aCount);
        else raise new Exception($"Unknown encoding {Name}");
      end;
    end;

    property UTF8: Encoding := new Encoding("UTF-8"); lazy; static;
    property UTF16: Encoding := new Encoding("UTF-16"); lazy; static;
    property UTF16LE: Encoding := new Encoding("UTF-16LE"); lazy; static;
    property UTF16BE: Encoding := new Encoding("UTF-16BE"); lazy; static;
    property UTF32: Encoding := new Encoding("UTF-32"); lazy; static;
    property UTF32LE: Encoding := new Encoding("UTF-32LE"); lazy; static;
    property UTF32BE: Encoding := new Encoding("UTF-32BE"); lazy; static;
    property ASCII: Encoding := new Encoding("ASCII"); lazy; static;
  end;

end.