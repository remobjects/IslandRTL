# ARM64EC cookie runtime guard

Build `Cookie.elements` with `IslandReference` set to the freshly built ARM64EC
`Island.fx` and the matching ARM64EC compiler, SDK and GC. The regular Island
library must provide all transition and cookie symbols without extra libraries
or application linker options.

Run on Windows on ARM:

* No arguments: prints `PASS: loader cookie, initialization and valid check`, exit 0.
* `corrupt`: must fast-fail (0xC0000409, FAST_FAIL_STACK_COOKIE_CHECK_FAILURE = 2).
* `uninitialized`: must fast-fail (0xC0000409, FAST_FAIL_GS_COOKIE_INIT = 6).

A negative test returning 12 means the guard incorrectly returned to its caller.
A successful link alone does not validate loader initialization or fail-fast.
The test executes the real Island startup and GC before checking the cookie.

`run.ps1 -Executable <path-to-Arm64EcCookie.exe>` runs all three cases in
isolated child processes, with a 20-second timeout per case. It checks exit
codes; the fail-fast subcodes are also visible in the emitted assembly.

Validated on October 9, 2026 with the branch compiler and Windows ARM VM:
all three runtime cases passed. Both Island project variants built and the
unchanged Delphi consumer linked with the installed local references.
The Delphi consumer reached its first writeLn. During TObject construction,
Windows indirect-call checking faulted on target X11 = 0x26567, reached from
rtl370+0x1720. Delphi subsequently displayed a message box. This constructor
ABI issue remains open; it is not a successful end-to-end Delphi run.
