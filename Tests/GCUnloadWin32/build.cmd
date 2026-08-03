@echo off
setlocal

set "ROOT=%~dp0"
set "ISLAND_ROOT=%ROOT%..\.."
set "EBUILD=C:\Program Files (x86)\RemObjects Software\Elements\bin\EBuild.exe"
set "VCVARS=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvarsamd64_x86.bat"
set "CLANG=C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\Llvm\bin\clang.exe"
set "KERNEL32=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x86\kernel32.Lib"
set "RUNTIME_OUT=%ISLAND_ROOT%\_gc_unload\island-bin"
set "BIN=%ROOT%Bin\Windows\i386"

"%EBUILD%" "%ISLAND_ROOT%\Source\Island.Windows.elements" --configuration:Debug --setting:Architecture=i386 --output-folder:"%RUNTIME_OUT%"
if errorlevel 1 exit /b %errorlevel%

"%EBUILD%" "%ROOT%IslandGcUnloadPayload\IslandGcUnloadPayload.elements" --configuration:Debug --no-cache
if errorlevel 1 exit /b %errorlevel%

call "%VCVARS%" >nul
if errorlevel 1 exit /b %errorlevel%

"%CLANG%" -target i686-pc-windows-msvc -fuse-ld=link -O0 -g "%ROOT%NativeHost\NativeHost.c" -o "%BIN%\NativeHost.exe" "%KERNEL32%"
if errorlevel 1 exit /b %errorlevel%

echo Built Win32 unload repro in "%BIN%".
