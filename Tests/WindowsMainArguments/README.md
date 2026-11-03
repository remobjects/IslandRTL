# Windows startup arguments with an optimized runtime

Build `Source/Island.Windows.elements` in Release for the architecture under test,
then build `WindowsMainArguments.elements` with `IslandReference` pointing to
that freshly built `Island.fx`. The runtime itself must be optimized; optimizing
only this test executable does not exercise the original configuration.

On Windows run:

```
python verify.py path\to\WindowsMainArguments.exe
```

Run for i386, x86_64 and arm64ec, with the consumer's `EnableLTO` both False and
True. Use the same optimized fat runtime archive for both consumer configurations.
The runner checks the exact argument count and every UTF-16 code unit, independently
of the runtime's own command-line query, for no arguments, explicit empty arguments,
spaces, quotes, trailing backslashes, Unicode, many arguments and long arguments.
It also verifies normal return after catching negative and upper-bound array reads,
including reads from an empty array, and exactly one finally cleanup per throw.
Every run must print its success marker and
exit zero; reaching Main alone is insufficient.

This guards the suspected area of the March 2026 Windows Release optimization
workaround. Without the original reproducer it does not establish the historical
cause or identify which later compiler/runtime change fixed it.
