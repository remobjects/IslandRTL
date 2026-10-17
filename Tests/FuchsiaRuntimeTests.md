# Fuchsia runtime prerequisite tests

`FuchsiaRuntimeTests.elements` is an Oxygene executable covering native and RTL2
current/invariant locales, number/date formatting, UUID generation, secure
random slices and bounds, integer/single/double reflection invocation, register and stack arguments,
reflection var/out parameters, timers
(one-shot, repeat, stop, restart, cancellation and stopping from a callback),
and file creation, seeking, truncation, extension and read-only reopening.

Build IslandRTL and RTL2 for the same Fuchsia architecture first. Select
`--targets:Island.Fuchsia` and pass `--setting:SocketRTLReference=<Island.fx>`
and `--setting:RuntimeRTL2Reference=<Elements.fx>`. Use separate output and
intermediate folders and `--nocache` when changing references. Check resolved
paths in the build log. The tests use Elements, never VC#.

Package with the matching IDK libraries as described in SocketTests.md. Add
`{"storage":"data","path":"/data"}` to the generated CML's `use` list;
the laboratory collection offers this capability. The default file path is
`/data/runtime-test.bin`; a command-line argument can override it. Repeated
runs deliberately reuse the file. Require the final `PASS: runtime checks`
marker; component launch is not proof that the suite completed.

Locales use libc's C/POSIX locale data and process LC_ALL/LANG selection. These
changes do not integrate the unfinished Elements FIDL intl layer or provide an
ICU locale database. Local time-zone discovery exposes libc's UTC behavior.
Timers use registered Island threads and cancellation events; Stop waits for
an active callback except when that callback stops its own timer.

The ARM64 trampoline now preserves Single bit patterns, restores its stack
without forward branch fixups, loads all eight floating registers at their
correct offsets, and initializes out boxes without reading a null argument.
Fuchsia defines ARM64 without ARM, so both FFI units select explicitly on ARM64.
The suite covers scalar and reference-parameter calls; aggregate by-value ABI
shapes still require separate acceptance before use.

RTL2's Exception name is explicitly native on Island, preventing Foundation's
Exception alias from selecting a Cocoa base on Darwin. Rebuild RTL2 and its
consumers together; do not combine the updated base with old compiled consumers.

## Verified runs

On the arm64 VIM3, all 38 runtime checks passed. The matching macOS arm64 run
passed 35 checks (the named UTF-8 locale, UTC discovery and thread-name checks are
specific to Fuchsia). Native socket suites passed 69 checks on VIM3 and 67 on macOS;
InternetPack transport plus plain HTTP passed 29 checks on each.

These runs do not establish TLS, aggregate reflection ABI support, full system
internationalization, or x86_64 device behavior.
