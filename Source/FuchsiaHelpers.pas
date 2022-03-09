namespace RemObjects.Elements.System;

interface


method malloc(size: NativeInt): ^Void; inline;
begin
  exit rtl.malloc(size);
end;

method realloc(ptr: ^Void; size: NativeInt): ^Void;inline;
begin
  exit rtl.realloc(ptr, size);
end;

method free(v: ^Void);inline;
begin
  rtl.free(v);
end;

implementation

end.