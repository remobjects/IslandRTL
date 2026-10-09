// Positive compile guard: production EC catch, continuation and post-unwind assembly.
// This checks native emission and symbol references, not Windows exception execution.
namespace Arm64EcHelpers;
uses RemObjects.Elements.System;
{$IF ARM64 or ARM64EC}
// These internal funclets execute native AArch64 code on both Windows targets.
[InlineAsm("

        stp     x29, x30, [sp, #-16]!           // 16-byte Folded Spill
        sub     x29, x1, #32
        blr     x0

        ldp     x29, x30, [sp], #16             // 16-byte Folded Reload
        ret
", "", true, false), DisableInlining, DisableOptimizations]

method CallCatch64(aCall: NativeInt; aEBP: NativeInt): NativeInt; external;

[InlineAsm("
        stp     x29, x30, [sp, #-16]!
        // Island Windows ARM64 functions keep x29 32 bytes below the pre-allocation establisher.
        sub     x29, x1, #32
        adr     x4, catch_return
        str     x4, [x2]
        mov     x5, sp
        str     x5, [x3]
        blr     x0
catch_return:
        ldp     x29, x30, [sp], #16
        ret
", "", true, false), DisableInlining, DisableOptimizations]
method CallCatch64AfterUnwind(aCall: NativeInt; aEBP: NativeInt; var aReturnAddress: NativeInt; var aReturnStack: NativeInt): NativeInt; external;

[InlineAsm("
        mov     sp, x1
        br      x0
", "", true, false), Naked, DisableInlining, DisableOptimizations]
method ExitCatchFunclet(aReturnAddress: NativeInt; aReturnStack: NativeInt); external;
{$ELSEIF X86_64}
[InlineAsm("
pushq %rbp
movq %rdx, %rbp
subq $$32, %rsp
movq %rdx, 8(%rsp)
callq *%rcx
addq $$32, %rsp
popq %rbp
retq
", "", false, false), DisableInlining, DisableOptimizations]
method CallCatch64(aCall: NativeInt; aEBP: NativeInt): NativeInt; external;

[InlineAsm("
pushq %rbp
movq %rdx, %rbp
subq $$32, %rsp
movq %rdx, 8(%rsp)
leaq catch_return(%rip), %rax
movq %rax, (%r8)
movq %rsp, (%r9)
callq *%rcx
catch_return:
addq $$32, %rsp
popq %rbp
retq
", "", false, false), DisableInlining, DisableOptimizations]
method CallCatch64AfterUnwind(aCall: NativeInt; aEBP: NativeInt; var aReturnAddress: NativeInt; var aReturnStack: NativeInt): NativeInt; external;

[InlineAsm("
movq %rdx, %rsp
jmpq *%rcx
", "", false, false), Naked, DisableInlining, DisableOptimizations]
method ExitCatchFunclet(aReturnAddress: NativeInt; aReturnStack: NativeInt); external;
{$ELSEIF i386}
[DisableInlining]
method CallCatch32(aCall: NativeInt; aEBP: NativeInt): NativeInt;
begin
  exit InternalCalls.Asm("
movl $2, %ebp
calll *$1
", "=A,r,r,~{esi},~{ebx},~{edi}~{ebp},~{dirflag},~{fpsr},~{flags}", false, false, aCall, aEBP);
end;
{$ELSE}
  {$ERROR Unsupported Architecture}
{$ENDIF}

{$IF ARM64EC}
[InlineAsm("
        mov     sp, x1
        mov     x29, x2
        br      x0
", "", true, false), Naked, DisableInlining, DisableOptimizations]
method JumpToContinuation64(aAddress, aESP, aEBP: NativeInt); external;
{$ELSEIF ARM64}
[InlineAsm("
       stp     x29, x30, [sp, #-16]!           // 16-byte Folded Spill
        mov     x1, sp
        mov     x2, x29
        blr     x0

        ldp     x29, x30, [sp], #16             // 16-byte Folded Reload
        ret
", "", true, false), DisableInlining, DisableOptimizations]
method JumpToContinuation64(aAddress, aESP, aEBP: NativeInt); external;
{$ELSEIF X86_64}
[InlineAsm("
    movq %r8, %rbp
    movq %rdx, %rsp
    jmpq *%rcx
", "", false, false), DisableInlining, DisableOptimizations]
method JumpToContinuation64(aAddress, aESP, aEBP: NativeInt); external;
{$ELSEIF I386}
(*[InlineAsm("
    movl 12(%esp), %ebp
    movl 4(%esp), %eax
    movl 8(%esp), %esp
    jmpl *%eax
", "", false, false), DisableInlining, DisableOptimizations]*)
[DisableInlining, DisableOptimizations]
method JumpToContinuation32(aAddress, aESP, aEBP: NativeInt);
begin
  InternalCalls.VoidAsm("
    movl $2, %ebp
    movl $0, %eax
    movl $1, %esp
    jmpl *%eax
  ", "r,r,r,~{ebp},~{esp},~{esp},~{dirflag},~{fpsr},~{flags}", false, false, aAddress, aESP, aEBP);
end;
{$ELSE}
  {$ERROR Unsupported Architecture}
{$ENDIF}

{$IFDEF _WIN64}
{$IF X86_64}
[SymbolName('__elements_after_unwind_run_catch'), InlineAsm("
subq $$40, %rsp
callq __elements_run_catch_after_unwind
addq $$40, %rsp
testq %rax, %rax
jz deferred_raise
jmpq *%rax
deferred_raise:
subq $$40, %rsp
callq __elements_get_deferred_caller_context
addq $$40, %rsp
movq (%rax), %rsp
movq 8(%rax), %rbp
subq $$8, %rsp
movq 16(%rax), %rcx
movq %rcx, (%rsp)
leaq __elements_raise_deferred_exception(%rip), %rax
jmpq *%rax
", "", true, false), Naked, DisableInlining, DisableOptimizations]
method AfterUnwindRunCatch; external;

{$ELSEIF ARM64EC}
[SymbolName('__elements_after_unwind_run_catch'), InlineAsm("
bl ""#__elements_run_catch_after_unwind""
cbz x0, deferred_raise
br x0
deferred_raise:
bl ""#__elements_get_deferred_caller_context""
ldr x1, [x0]
ldr x29, [x0, #8]
ldr x30, [x0, #16]
mov sp, x1
b ""#__elements_raise_deferred_exception""
", "", true, false), Naked, DisableInlining, DisableOptimizations]
method AfterUnwindRunCatch; external;
{$ELSEIF ARM64}
[SymbolName('__elements_after_unwind_run_catch'), InlineAsm("
bl __elements_run_catch_after_unwind
cbz x0, deferred_raise
br x0
deferred_raise:
bl __elements_get_deferred_caller_context
ldr x1, [x0]
ldr x29, [x0, #8]
ldr x30, [x0, #16]
mov sp, x1
b __elements_raise_deferred_exception
", "", true, false), Naked, DisableInlining, DisableOptimizations]
method AfterUnwindRunCatch; external;
{$ENDIF}

{$ENDIF}
end.
