// Regression guards: decode complete lines, retain buffer-boundary bytes,
// preserve whitespace and supplementary characters, and stop at EOF.
namespace ReadLineTests;

type
  Program = class
  public

    class method Main(aArgs: array of String): Int32;
    begin
      for i := 0 to 2 do begin
        var lLine := readLn;
        write(length(lLine));
        write(':');
        for j := 0 to length(lLine) - 1 do begin
          write(Int32(lLine[j]));
          write(' ');
        end;
        writeLn;
      end;
      result := 0;
    end;

  end;

end.
