# Native socket regression tests

`SocketTests.elements` is an Oxygene executable for `Island.Fuchsia`,
`Island.Darwin.macOS`, `Island.Linux`, and `Island.Windows`. It exercises IPv4/IPv6
byte and scope preservation, numeric parsing, DNS, TCP/UDP, actual endpoint ports,
partial I/O and buffer offsets, availability, peek, socket options/timeouts,
empty datagrams, native errors, and cancellation of blocked accept/read operations.

Build IslandRTL first, then point the test at that exact build. For example, from
an Elements checkout with its normal SDKs installed:

```sh
RO_DIR=/Users/mh/Code/RemObjects
SOCKET_OUT=/tmp/island-socket-validation
mono "$RO_DIR/Elements/Bin/EBuild.exe" "$RO_DIR/IslandRTL/Source/Island.Fuchsia.elements" \
  --configuration:Debug --setting:Architecture=arm64 \
  --out:"$SOCKET_OUT/rtl" --intermediatebasefolder:"$SOCKET_OUT/rtl-obj"
mono "$RO_DIR/Elements/Bin/EBuild.exe" "$RO_DIR/IslandRTL/Tests/SocketTests.elements" \
  --targets:Island.Fuchsia --setting:Architecture=arm64 \
  --setting:SocketRTLReference="$SOCKET_OUT/rtl/Fuchsia/arm64/Island.fx" \
  --out:"$SOCKET_OUT/tests" --intermediatebasefolder:"$SOCKET_OUT/test-obj" \
  --setting:CreatePackage=False --nocache
```

For x86_64, use a separately built x86_64 Island library and architecture setting.
For macOS, build `Island.Darwin.macOS.elements` and select
`--targets:Island.Darwin.macOS`; its library path is `macOS/arm64/Island.fx`.
Verify the build log resolves `Island` to the intended library: EBuild can fall
back to installed references if a supplied hint path does not exist. Use
`--nocache` after changing reference overrides.

Fuchsia executables must be packaged with the matching IDK runtime libraries.
The generated manifest requests `fuchsia.posix.socket.Provider` and
`fuchsia.net.name.Lookup`; the parent realm must offer both. No Elements FIDL
bindings are used. Run in a private test repository/collection and capture logs
until `SOCKET TESTS PASSED` appears. Launch acknowledgement alone is insufficient.
Do not combine `ffx component run --connect-stdio` with the SDK's default stdio
forwarding: on the tested SDK/device combination it supplies duplicate PA_FD
handles and aborts in fdio before Main. Normal launch and `ffx log` work.

Fuchsia listener accept uses nonblocking accept and bounded polling because fdio
close/shutdown does not wake a blocking listener accept. This cancellation path
is tested repeatedly. Established sockets retain blocking I/O.

The tested Fuchsia fdio provider rejects SO_LINGER with EOPNOTSUPP. The suite
verifies that native failure rather than pretending the option succeeded.
Linux arm64 executables built against the available Ubuntu 26.04 SDK currently
require libgp-heap.so, libgp-sync.so, libgp-iotrace.so, and libgp-collector.so;
these are absent on the available Linux VM, so Linux runtime validation remains
separate from compilation.
