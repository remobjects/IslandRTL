# ARM64EC transition support

`chpe.S` supplies the Windows-loader dispatch slots, CHPE metadata, and the
custom-convention `__icall_helper_arm64ec` adjustor needed by LLVM/LLD. These
are native ARM64EC objects. The zero-initialized slots are filled by the Windows
loader through the CHPE metadata; they are not placeholder implementations.
`WindowsHelpers.pas` points its ARM64EC load-config directory at this record.

The assembly is kept outside the Elements compiler because the adjustor uses
its own register contract, rather than an ordinary EC function signature and
compiler-generated entry/exit thunks.

Build with an LLVM tool directory containing clang, llvm-ar, and llvm-readobj:

```sh
python3 Source/Windows/ARM64EC/build.py --llvm-bin /path/to/llvm/bin --output /path/to/output
```

This creates `arm64ec-support.lib`. To fold it into an **already built EC**
Island library, add `--island-library /path/to/arm64ec/Island.lib`. The script
writes a merged `Island.lib` into the output directory and leaves the input
alone. Use that library with the matching EC `Island.fx`. The load-config
reference pulls the support object from the archive automatically. Ordinary
ARM64 and x64 Island archives are rejected; merging cannot convert an ABI.
This is an explicit post-build step, not yet wired into the release build.

Do not ship the standalone support archive and the merged archive together.
Do not replace an installed SDK/RTL with these outputs until end-to-end Windows
ARM64 execution has passed. The support library does not provide the GC,
Windows SDK declarations, IslandRTL exception helpers, or the LLVM return-thunk
fix. Those must also be built for the target.

Run the structural link checks with:

```sh
python3 Tests/ARM64ECTransition/test.py --llvm-bin /path/to/llvm/bin --lld /path/to/lld
```

These check EC object headers, archive extraction, load-config metadata,
adjustor unwind info, archive merging, and rejection of non-EC inputs. They do
not execute an application or validate exception/GC behavior on Windows.

## Upstream source

Public-domain mingw-w64 `mingw-w64-crt/crt/chpe.S`, revision
`2bcf06abc9ec5f8f73c743896b815a7a7654f9ae`:
https://github.com/mingw-w64/mingw-w64/blob/2bcf06abc9ec5f8f73c743896b815a7a7654f9ae/mingw-w64-crt/crt/chpe.S

The original notice and `DISCLAIMER.PD` are retained. Local change: compiling
for a non-EC target is an error instead of silently producing an empty object.
