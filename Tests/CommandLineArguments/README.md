# Command-line startup arguments

Build the owning Island runtime, then build `CommandLineArguments.elements` with
`RuntimeLibrary` pointing at that build's `Island.fx`. Run with no arguments;
expect exit 0 and `Command-line argument guards passed`.

The program exercises the same `Environment.GetCommandLineArgs` conversion used
by native startup, including an empty vector, program-name exclusion, a trailing
nil sentinel, explicit empty values, missing vector/entries and invalid bytes.
It restores the original native vector after probing.

Also launch this executable with a raw invalid UTF-8 byte argument (for example
Python `subprocess.run([path_as_bytes, b"\xff"])`). Startup must exit nonzero with
`Could not decode command-line argument at index 1`, before the success marker.
Run against both Debug and Release runtime builds. The host locale must use UTF-8.
