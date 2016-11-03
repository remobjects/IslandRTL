namespace RemObjects.Elements.System;

type
  FileUtils = assembly static class
  private
  protected
  public
    class method isFolder(Attr: {$IFDEF WINDOWS}rtl.DWORD{$ELSEIF POSIX}rtl.__mode_t{$ELSE}{$ERROR}{$ENDIF}): Boolean; inline;
    begin
      {$IFDEF WINDOWS}
      if Attr = rtl.INVALID_FILE_ATTRIBUTES then exit false;
      exit (Attr and rtl.FILE_ATTRIBUTE_DIRECTORY) = rtl.FILE_ATTRIBUTE_DIRECTORY;
      {$ELSEIF POSIX}
      exit (Attr and rtl.S_IFMT) = rtl.S_IFDIR;	
      {$ELSE}{$ERROR}{$ENDIF}
    end;
    class method isFile(Attr: {$IFDEF WINDOWS}rtl.DWORD{$ELSEIF POSIX}rtl.__mode_t{$ELSE}{$ERROR}{$ENDIF}): Boolean; inline;
    begin
      {$IFDEF WINDOWS}
      if Attr = rtl.INVALID_FILE_ATTRIBUTES then exit false;
      exit (Attr and rtl.FILE_ATTRIBUTE_DIRECTORY) <> rtl.FILE_ATTRIBUTE_DIRECTORY;
      {$ELSEIF POSIX}
      exit (Attr and rtl.S_IFMT) = rtl.S_IFREG;
      {$ELSE}{$ERROR}{$ENDIF}
    end;
  end;

{$IFDEF WINDOWS}
extension method String.ToLPCWSTR: rtl.LPCWSTR;
begin
  if String.IsNullOrEmpty(self) then exit nil;
  var arr := ToCharArray(true);
  exit rtl.LPCWSTR(@arr[0]);
end;

extension method String.ToFileName: rtl.LPCWSTR; assembly;
begin
  if String.IsNullOrEmpty(self) then exit nil;
  exit ((if not self.StartsWith('\\?\') then '\\?\' else '')+self).ToLPCWSTR();
end;
{$ENDIF}

{$IFDEF POSIX}
extension method String.ToFileName: ^AnsiChar;assembly;
begin
  exit self.ToAnsiChars(True);
end;
{$ENDIF}

end.
