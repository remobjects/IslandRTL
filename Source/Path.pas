namespace RemObjects.Elements.System;

interface

type
  Path = public static class
  public
    method ChangeExtension(FileName: not nullable String; NewExtension: nullable String): not nullable String;
    method Combine(BasePath: not nullable String; Path: not nullable String): not nullable String;
    method Combine(BasePath: not nullable String; Path1: not nullable String; Path2: not nullable String): not nullable String;
    method GetParentDirectory(FileName: not nullable String): nullable String;
    method GetExtension(FileName: not nullable String): not nullable String;
    method GetFileName(FileName: not nullable String): not nullable String;
    method GetFileNameWithoutExtension(FileName: not nullable String): not nullable String;

    property DirectorySeparatorChar: Char read {$IF NOFILES}'/'{$ELSE}Folder.Separator{$ENDIF}; inline;

    {$IFNDEF NOFILES}
    method GetFullPath(RelativePath: not nullable String): not nullable String;
    property ListSeparator: Char read {$IFDEF WINDOWS}';'{$ELSEIF POSIX_LIGHT}':'{$ELSE}{$ERROR Unsupported platform}{$ENDIF};
    {$ENDIF}

  end;

implementation

method Path.ChangeExtension(FileName: not nullable String; NewExtension: nullable String): not nullable String;
begin
  if length(NewExtension) = 0 then
    exit GetFileNameWithoutExtension(FileName);

  var lIndex := FileName.LastIndexOf(".");

  if lIndex <> -1 then
    FileName := FileName.Substring(0, lIndex);

  if NewExtension[0] = '.' then
    result := FileName + NewExtension
  else
    result := FileName + "." + NewExtension as not nullable;
end;

method Path.Combine(BasePath: not nullable String; Path: not nullable String): not nullable String;
begin
  if String.IsNullOrEmpty(BasePath) and String.IsNullOrEmpty(Path) then
    raise new Exception("Invalid arguments");

  if String.IsNullOrEmpty(BasePath) then
    exit Path;

  if String.IsNullOrEmpty(Path) then
    exit BasePath;

  var LastChar := BasePath[BasePath.Length - 1];

  if LastChar = DirectorySeparatorChar then
    result := BasePath + Path
  else
    result := BasePath + DirectorySeparatorChar + Path;
end;

method Path.Combine(BasePath: not nullable String; Path1: not nullable String; Path2: not nullable String): not nullable String;
begin
  exit Combine(Combine(BasePath, Path1), Path2);
end;

method Path.GetParentDirectory(FileName: not nullable String): nullable String;
begin
  if length(FileName) = 0 then
    raise new Exception("Invalid arguments");

  var LastChar := FileName[FileName.Length - 1];

  if LastChar = DirectorySeparatorChar then
    FileName := FileName.Substring(0, FileName.Length - 1);

  if (FileName = DirectorySeparatorChar) or ((length(FileName) = 2) and (FileName[1] = ':')) then
    exit nil; // root folder has no parent

  var lIndex := FileName.LastIndexOf(DirectorySeparatorChar);

  if FileName.StartsWith('\\') then begin

    if lIndex > 1 then
      result := FileName.Substring(0, lIndex)
    else
      result := nil; // network share has no parent folder

  end
  else begin

    if lIndex > -1 then
      result := FileName.Substring(0, lIndex)
    else
      result := FileName+DirectorySeparatorChar+'..' // "fake" parent folder by appending ..

  end;
end;

method Path.GetExtension(FileName: not nullable String): not nullable String;
begin
  FileName := GetFileName(FileName);
  var lIndex := FileName.LastIndexOf(".");

  if (lIndex <> -1) and (lIndex < FileName.Length - 1) then
    exit FileName.Substring(lIndex);

  exit "";
end;

method Path.GetFileName(FileName: not nullable String): not nullable String;
begin
  if FileName.Length = 0 then exit "";

  var LastChar: Char := FileName[FileName.Length - 1];

  if LastChar = DirectorySeparatorChar then
    FileName := FileName.Substring(0, FileName.Length - 1);

  var lIndex := FileName.LastIndexOf(DirectorySeparatorChar);

  if (lIndex <> -1) and (lIndex < FileName.Length - 1) then
    exit FileName.Substring(lIndex + 1);

  exit FileName;
end;

method Path.GetFileNameWithoutExtension(FileName: not nullable String): not nullable String;
begin
  FileName := GetFileName(FileName);
  var lIndex := FileName.LastIndexOf(".");

  if lIndex <> -1 then
    exit FileName.Substring(0, lIndex);

  exit FileName;
end;

{$IFNDEF NOFILES}
method Path.GetFullPath(RelativePath: not nullable String): not nullable String;
begin
  {$IFDEF WINDOWS}
  var lname := RelativePath.ToLPCWSTR;
  var len: rtl.DWORD := rtl.MAX_PATH;
  var buf:= new array of Char(len);
  len := rtl.GetFullPathNameW(lname,len,rtl.LPWSTR(@buf[0]), nil);
  CheckForIOError(len <> 0);
  if len <= rtl.MAX_PATH then begin
    if (len>4) and  (buf[0] = '\') and (buf[1] = '\') and (buf[2] = '?') and (buf[3] = '\') then
      exit String.FromPChar(@buf[4], len -4) as not nullable String
    else
      exit String.FromPChar(@buf[0],len) as not nullable String;
  end
  else begin
    var buf1 := new array of Char(len+1);
    len := rtl.GetFullPathNameW(lname,len,rtl.LPWSTR(@buf1[0]), nil);
    CheckForIOError(len <> 0);
    if (len>4) and (buf1[0] = '\') and (buf1[1] = '\') and (buf1[2] = '?') and (buf1[3] = '\') then
      exit String.FromPChar(@buf1[4], len-4)as not nullable String
    else
      exit String.FromPChar(@buf1[0],len) as not nullable String;
  end;
  {$ELSEIF DARWIN}
  exit (RelativePath as Foundation.NSString).stringByStandardizingPath as not nullable;
  {$ELSEIF POSIX_LIGHT}
  {$HINT POSIX: implement Path.GetFullPath}
  exit RelativePath;
  {$ELSE}
  {$ERROR Unsupported platform}
  {$ENDIF}
end;
{$ENDIF}

end.