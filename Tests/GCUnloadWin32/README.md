# Island Win32 GC unload repro

`NativeHost.exe` loads an Island DLL, initializes its GC on a worker thread, then
unloads the DLL from the native main thread. The main thread has never entered
Island code.

With the original runtime, DLL detach collects on that unregistered main thread
and Boehm shows `Collecting from unknown thread`.

`build.cmd` builds the current Win32 Island runtime, the payload DLL, and the
native host. Run `Bin\Windows\i386\NativeHost.exe`; the fixed runtime prints:

```
Unloading Island DLL from the native main thread.
Unload completed.
```
