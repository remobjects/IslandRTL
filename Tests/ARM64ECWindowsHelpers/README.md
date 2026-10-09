# ARM64EC Windows helper compile guard

`Helpers.pas` contains the production catch/continuation helper branches from
`Source/WindowsHelpers.pas`. Keep those excerpts synchronized when changing
the helpers. The purpose comment is in the compiled Oxygene source.

Build `Helpers.elements` with the ARM64EC compiler, setting `FixtureDir` to
matching declaration-only Island/rtl fixtures (or matching real references).
The fixture belongs only in the test, never the installed runtime.

Inspect the resulting COFF archive with `llvm-readobj --file-headers` and
`llvm-objdump -dr`. All objects must be ARM64EC. The post-unwind helper must
call the three `#__elements_*` native symbols. Continuation must restore SP
from X1, FP from X2, and branch through X0. Catch helpers must preserve FP/LR
and pass the generated funclet frame as for AArch64.

Validated October 9 with the branch compiler and existing Elements LLVM:
helper compilation passed and native instructions/relocations were inspected.
The full Island runtime passed source checking but crashed in LLVM frame
finalization for `#fopen`; LLVM 22.1.8 reproduces that separate backend failure.
These checks do not prove Windows exception unwinding at runtime.
