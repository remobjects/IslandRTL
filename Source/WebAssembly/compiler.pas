namespace;

uses System.IO, System.Linq, System.Diagnostics;
begin
  Process.Start('c:\windows\system32\cmd.exe', '/c tsc RemObjectsElements.ts -m UMD -d --lib es2016,dom').WaitForExit;
  var lFile := File.ReadAllLines("RemObjectsElements.js");
  var lNewFile := Enumerable.Concat(Enumerable.Concat(lFile.Take(8), ['    else { factory(function(name){return this;}, this); }']), lFile.Skip(8)).ToArray();
  File.WriteAllLines("RemObjectsElements.js", lNewFile);
end.
