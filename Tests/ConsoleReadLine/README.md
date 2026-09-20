# Native console line-reader regression

Run from the repository root with the Elements compiler installed:

```sh
ebuild_arm Source/Island.Darwin.macOS.elements --configuration:Debug --output-folder:/tmp/Island-readline-runtime
ebuild_arm Tests/ConsoleReadLine/ConsoleReadLine.elements --configuration:Debug --setting:RuntimeLibrary=/tmp/Island-readline-runtime/macOS/arm64/Island.fx --output-folder:/tmp/Island-readline-tests
python3 Tests/ConsoleReadLine/verify.py /tmp/Island-readline-tests/macOS/IslandReadLineTests
```

The executable calls the actual `readLn` mapping three times. Python supplies stdin and compares UTF-16 code units, avoiding dependence on stdout encoding. Each process has a timeout to detect EOF loops.

Coverage: empty input, empty and repeated lines, unterminated EOF, leading/trailing spaces, combining characters, CJK, emoji, 254–257 and 511–513 byte boundaries, and an 8 KiB line. Both runtime builds passed all 36 cases on macOS arm64. The previous Island library fails the `254/'é'` boundary case.

Newline and encoding policy remain platform-specific: this regression supplies LF. Island retains its existing platform decoder and ReadChar EOF contract; libToffee decodes complete UTF-8 lines and raises an exception for invalid UTF-8. Windows/Linux runtime execution is not covered by this macOS project.
