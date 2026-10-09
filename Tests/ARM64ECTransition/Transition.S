// Positive structural guard: exercise CHPE metadata extraction and loader-visible dispatch slots.
// This is a freestanding link fixture, not proof of executing an Island application on Windows.
#ifndef __arm64ec__
#error ARM64EC required
#endif
.text
.globl "#transition_test"
"#transition_test":
    mov w0, #0
    ret

.section .rdata,"dr"
.balign 8
.globl _load_config_used
_load_config_used:
    .long 320
    .zero 196
    .quad __chpe_metadata
    .zero 112
