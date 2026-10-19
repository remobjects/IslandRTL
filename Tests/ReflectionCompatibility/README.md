# Old Windows ARM64 reflection provider

This is a two-toolchain compatibility fixture. `LegacyProvider.pas` must be built
as a Windows ARM64 static library with a compiler that predates the optional
reflection semantic-copy metadata adapter. Build `LegacyConsumer.pas` with the
current compiler, reference the old provider FX/library, and invoke
`LegacyReflectionConsumer.Check` using the current Island runtime.

The test expects the explicit recompilation diagnostic before the target runs,
keeps the original argument box unchanged, and does not accept a raw byte-copy
fallback. Building both files with the new compiler does **not** test old metadata.
Generated FX/library binaries are intentionally not checked in. The provider
contains a copy constructor so an unverified byte copy would skip real language
semantics; its test value owns no native resource, so a broken rejection cannot
cause an accidental double free.

The ordinary reflection contract groups remain in `ReflectionWindowsARM64.pas`
and run through the shared test project. Those cover success/exception behavior,
receiver mutation, nil arguments, semantic copies and actual resource cleanup.
