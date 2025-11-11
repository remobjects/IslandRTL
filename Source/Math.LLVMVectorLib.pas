namespace RemObjects.Elements.System;

// SLEEF Vector Math Library Implementation for Island RTL
// =========================================================
//
// This file provides implementations for Math class methods that enable LLVM auto-vectorization.
// Simple functions use LLVM intrinsics; complex functions use the SLEEF library.
//
// Simple functions (floor, ceil, trunc, round, sqrt, fabs)
// These are single CPU instructions - we use LLVM intrinsics, not SLEEF.
// It is _slower_ to use sleef than a single instruction repeated multiple times.
//
// 1. User code calls Math.Floor(x) (in a loop or sequence, ie, anywhere vectorisation is clear)
// 2. Via llvm.floor.f64, the compiler generates a call to the LLVM intrinsic.
//    (this is inlined, occurs anyway but via 'inline')
// 3. LLVM recognizes llvm.floor.f64 as Intrinsic::floor
// 4. TargetTransformInfo knows this is cheap: ~1-2 (single instruction)
// 5. Loop vectorizer vectorizes to llvm.floor.v2f64 (vector intrinsic)
// 6. Code gen emits frintm.2d on ARM64 (or equivalent on x86_64)
//
// Complex functions (sin, cos, tan, asin, acos, atan, atan2, sinh, cosh, tanh, exp, log, pow, etc.)
// These need real algorithms - we use SLEEF for these.
//
// 1. User code calls Math.Sin(x) (in a loop or sequence, ie, anywhere vectorisation is clear)
// 2. Via SleefInternal.[sleef-name-for-sin], the compiler generates a call to Sleef_sind1_u10
//    (the SLEEF scalar function). (this is inlined, occurs anyway but via 'inline')
//    (inline hinting moves from 'maybe, likely' to 'should inline' - not guaranteed but should work)
// 3. The LLVM optimizer sees Sleef_sind1_u10 in loop and checks VecFuncs.def for mapping
// 4. VecFuncs.def maps Sleef_sind1_u10 → Sleef_sind2_u10advsimd (vector) or other wider vector funcs
//    (This should also occur if there is a reference to C-RTL name 'sin()' or llvm.sin.* intrinsic,
//    but this way we know for sure what will be emitted.)
//    (SleefInternal.sin and other methods have SymbolName attributes of sin (and other methods)
//    in order to generate a mapping between C RTL names so the vectoriser can recognise those too.)
// 5. Loop vectorizer replaces scalar calls with vector SLEEF calls
//
// C RTL symbol exports:
// We export C RTL names (sqrt, sin, cos, etc.) for two reasons:
// - SLEEF library has UNDEF references to sqrt/sqrtf that need resolving (circular dependency)
// - Any other code expecting C RTL names gets them
// Simple function exports (sqrt) forward to LLVM intrinsics; complex ones forward to SLEEF.
//
// - SleefInternal: External declarations for SLEEF scalar functions and LLVM intrinsics
// - Math class: Public API that forwards to SleefInternal
//
// Attributes [MemoryNone, NoExcept, WillReturn] are crtical for this to work correctly.
// Without them, the methods will remain scalar. LLVM can only vectorise methods that
// it knows do not modify memory (MemoryNone), do not throw (NoExcept); WillReturn
// may or may not affect it, but is safe for these methods, and does allow other optimisations.
// MemoryNone also allows speculative execution on the CPU since there's no need for memory
// gating -- the method's results are based only on the method's parameters.
// These are required because the methods live in sleef.lib, and so to LLVM they're opaque
// and could do anything. We need to tell it that they're safe to vectorise.
// (For intrinsics, LLVM already knows this, but the attributes don't hurt.)

// Check same conditions as Math.pas - must be kept in sync!
{$IF (WINDOWS OR (DARWIN AND NOT (IOS OR TVOS OR WATCHOS OR VISIONOS)) OR (LINUX AND NOT ANDROID)) AND (i386 OR x86_64 OR ARM64)}
  {$DEFINE USE_LLVM_MATH_VECTORLIB}
{$ENDIF}

{$IFDEF USE_LLVM_MATH_VECTORLIB}

interface

type
  Math = public partial class
  public
    // Transcendental functions - implemented via SLEEF
    // Attributes guide LLVM optimization without affecting function names
    [MemoryNone, NoExcept, WillReturn]
    class method Acos(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Asin(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Atan(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Atan2(x,y: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Ceiling(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Ceiling(d: Single): Single; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Cos(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Cosh(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Exp(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Exp2(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Floor(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Floor(d: Single): Single; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Log(a: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Log2(a: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Log10(a: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Pow(x, y: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Round(a: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Sin(x: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Sinh(x: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Sqrt(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Sqrt(d: Single): Single; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Tan(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Tanh(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Truncate(d: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Truncate(d: Single): Single; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method Abs(i: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method fmod(x, y: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method fmodf(x,y: Single): Single; inline;
  end;

implementation

type
  // Internal SLEEF scalar function declarations and LLVM intrinsics
  // SLEEF functions link to sleef.lib, intrinsics are recognized by LLVM optimizer
  SleefInternal = static class
  assembly  // assembly = internal visibility (accessible within same assembly)
    // ===== LLVM INTRINSICS for simple operations =====
    // These are NOT library calls - LLVM recognizes them and generates native instructions
    // E.g., llvm.floor.f64 → frintm instruction on ARM64 (cost ~1-2)
    [SymbolName('llvm.floor.f64')]
    class method llvm_floor_f64(d: Double): Double; external;
    [SymbolName('llvm.floor.f32')]
    class method llvm_floor_f32(d: Single): Single; external;

    [SymbolName('llvm.ceil.f64')]
    class method llvm_ceil_f64(d: Double): Double; external;
    [SymbolName('llvm.ceil.f32')]
    class method llvm_ceil_f32(d: Single): Single; external;

    [SymbolName('llvm.trunc.f64')]
    class method llvm_trunc_f64(d: Double): Double; external;
    [SymbolName('llvm.trunc.f32')]
    class method llvm_trunc_f32(d: Single): Single; external;

    [SymbolName('llvm.round.f64')]
    class method llvm_round_f64(d: Double): Double; external;

    [SymbolName('llvm.fabs.f64')]
    class method llvm_fabs_f64(d: Double): Double; external;

    [SymbolName('llvm.sqrt.f64')]
    class method llvm_sqrt_f64(d: Double): Double; external;
    [SymbolName('llvm.sqrt.f32')]
    class method llvm_sqrt_f32(d: Single): Single; external;

    // ===== C RTL symbol exports for SLEEF library dependencies =====
    // SLEEF library has UNDEF references that must be resolved
    // Simple functions forward to LLVM intrinsics; complex functions forward to SLEEF

    // Simple function C RTL exports (forward to LLVM intrinsics)
    [SymbolName('sqrt'), Used]
    class method sqrt(d: Double): Double; inline;
    [SymbolName('sqrtf'), Used]
    class method sqrtf(d: Single): Single; inline;
    [SymbolName('ceil'), Used]
    class method ceil(d: Double): Double; inline;
    [SymbolName('ceilf'), Used]
    class method ceilf(d: Single): Single; inline;
    [SymbolName('floor'), Used]
    class method floor(d: Double): Double; inline;
    [SymbolName('floorf'), Used]
    class method floorf(d: Single): Single; inline;
    [SymbolName('trunc'), Used]
    class method trunc(d: Double): Double; inline;
    [SymbolName('truncf'), Used]
    class method truncf(d: Single): Single; inline;
    [SymbolName('round'), Used]
    class method round(d: Double): Double; inline;
    [SymbolName('fabs'), Used]
    class method fabs(d: Double): Double; inline;

    // C RTL names for complex functions - these export SLEEF implementations
    [SymbolName('acos'), Used]
    class method acos(d: Double): Double; inline;
    [SymbolName('asin'), Used]
    class method asin(d: Double): Double; inline;
    [SymbolName('atan'), Used]
    class method atan(d: Double): Double; inline;
    [SymbolName('atan2'), Used]
    class method atan2(y, x: Double): Double; inline;
    [SymbolName('cos'), Used]
    class method cos(d: Double): Double; inline;
    [SymbolName('cosh'), Used]
    class method cosh(d: Double): Double; inline;
    [SymbolName('exp'), Used]
    class method exp(d: Double): Double; inline;
    [SymbolName('exp2'), Used]
    class method exp2(d: Double): Double; inline;
    [SymbolName('fmod'), Used]
    class method fmod(x, y: Double): Double; inline;
    [SymbolName('log'), Used]
    class method log(d: Double): Double; inline;
    [SymbolName('log2'), Used]
    class method log2(d: Double): Double; inline;
    [SymbolName('log10'), Used]
    class method log10(d: Double): Double; inline;
    [SymbolName('pow'), Used]
    class method pow(x, y: Double): Double; inline;
    [SymbolName('sin'), Used]
    class method sin(d: Double): Double; inline;
    [SymbolName('sinh'), Used]
    class method sinh(d: Double): Double; inline;
    [SymbolName('tan'), Used]
    class method tan(d: Double): Double; inline;
    [SymbolName('tanh'), Used]
    class method tanh(d: Double): Double; inline;

    // Trigonometric functions
    [SymbolName('Sleef_sind1_u10')]
    class method Sleef_sind1_u10(x: Double): Double; external;

    [SymbolName('Sleef_cosd1_u10')]
    class method Sleef_cosd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_tand1_u10')]
    class method Sleef_tand1_u10(x: Double): Double; external;

    [SymbolName('Sleef_asind1_u10')]
    class method Sleef_asind1_u10(x: Double): Double; external;

    [SymbolName('Sleef_acosd1_u10')]
    class method Sleef_acosd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_atand1_u10')]
    class method Sleef_atand1_u10(x: Double): Double; external;

    [SymbolName('Sleef_atan2d1_u10')]
    class method Sleef_atan2d1_u10(y: Double; x: Double): Double; external;

    // Hyperbolic functions
    [SymbolName('Sleef_sinhd1_u10')]
    class method Sleef_sinhd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_coshd1_u10')]
    class method Sleef_coshd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_tanhd1_u10')]
    class method Sleef_tanhd1_u10(x: Double): Double; external;

    // Exponential and logarithmic functions
    [SymbolName('Sleef_expd1_u10')]
    class method Sleef_expd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_exp2d1_u10')]
    class method Sleef_exp2d1_u10(x: Double): Double; external;

    [SymbolName('Sleef_exp10d1_u10')]
    class method Sleef_exp10d1_u10(x: Double): Double; external;

    [SymbolName('Sleef_logd1_u10')]
    class method Sleef_logd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_log2d1_u10')]
    class method Sleef_log2d1_u10(x: Double): Double; external;

    [SymbolName('Sleef_log10d1_u10')]
    class method Sleef_log10d1_u10(x: Double): Double; external;

    // Power and root functions
    [SymbolName('Sleef_powd1_u10')]
    class method Sleef_powd1_u10(x: Double; y: Double): Double; external;

    [SymbolName('Sleef_sqrtd1_u05')]
    class method Sleef_sqrtd1_u05(x: Double): Double; external;

    [SymbolName('Sleef_sqrtf1')]
    class method Sleef_sqrtf1(x: Single): Single; external;

    [SymbolName('Sleef_cbrtd1_u10')]
    class method Sleef_cbrtd1_u10(x: Double): Double; external;

    [SymbolName('Sleef_hypotd1_u05')]
    class method Sleef_hypotd1_u05(x: Double; y: Double): Double; external;

    // Rounding and manipulation
    [SymbolName('Sleef_ceild1')]
    class method Sleef_ceild1(x: Double): Double; external;

    [SymbolName('Sleef_ceilf1')]
    class method Sleef_ceilf1(x: Single): Single; external;

    [SymbolName('Sleef_floord1')]
    class method Sleef_floord1(x: Double): Double; external;

    [SymbolName('Sleef_floorf1')]
    class method Sleef_floorf1(x: Single): Single; external;

    [SymbolName('Sleef_truncd1')]
    class method Sleef_truncd1(x: Double): Double; external;

    [SymbolName('Sleef_truncf1')]
    class method Sleef_truncf1(x: Single): Single; external;

    [SymbolName('Sleef_roundd1')]
    class method Sleef_roundd1(x: Double): Double; external;

    [SymbolName('Sleef_fabsd1')]
    class method Sleef_fabsd1(x: Double): Double; external;

    // Other
    [SymbolName('Sleef_fmodd1')]
    class method Sleef_fmodd1(x: Double; y: Double): Double; external;

    [SymbolName('Sleef_fmodf1')]
    class method Sleef_fmodf1(x: Single; y: Single): Single; external;
  end;

// Math class implementations - forward to SLEEF functions
// These provide the public API that user code calls
// The compiler automatically inlines these trivial one-line wrappers

class method Math.Abs(i: Double): Double;
begin
  exit SleefInternal.llvm_fabs_f64(i);
end;

class method Math.Acos(d: Double): Double;
begin
  exit SleefInternal.Sleef_acosd1_u10(d);
end;

class method Math.Asin(d: Double): Double;
begin
  exit SleefInternal.Sleef_asind1_u10(d);
end;

class method Math.Atan(d: Double): Double;
begin
  exit SleefInternal.Sleef_atand1_u10(d);
end;

class method Math.Atan2(x, y: Double): Double;
begin
  exit SleefInternal.Sleef_atan2d1_u10(x, y);
end;

class method Math.Ceiling(d: Double): Double;
begin
  exit SleefInternal.llvm_ceil_f64(d);
end;

class method Math.Ceiling(d: Single): Single;
begin
  exit SleefInternal.llvm_ceil_f32(d);
end;

class method Math.Cos(d: Double): Double;
begin
  exit SleefInternal.Sleef_cosd1_u10(d);
end;

class method Math.Cosh(d: Double): Double;
begin
  exit SleefInternal.Sleef_coshd1_u10(d);
end;

class method Math.Exp(d: Double): Double;
begin
  exit SleefInternal.Sleef_expd1_u10(d);
end;

class method Math.Exp2(d: Double): Double;
begin
  exit SleefInternal.Sleef_exp2d1_u10(d);
end;

class method Math.Floor(d: Double): Double;
begin
  exit SleefInternal.llvm_floor_f64(d);
end;

class method Math.Floor(d: Single): Single;
begin
  exit SleefInternal.llvm_floor_f32(d);
end;

class method Math.fmod(x, y: Double): Double;
begin
  exit SleefInternal.Sleef_fmodd1(x, y);
end;

class method Math.fmodf(x, y: Single): Single;
begin
  exit SleefInternal.Sleef_fmodf1(x, y);
end;

class method Math.Log(a: Double): Double;
begin
  exit SleefInternal.Sleef_logd1_u10(a);
end;

class method Math.Log2(a: Double): Double;
begin
  exit SleefInternal.Sleef_log2d1_u10(a);
end;

class method Math.Log10(a: Double): Double;
begin
  exit SleefInternal.Sleef_log10d1_u10(a);
end;

class method Math.Pow(x, y: Double): Double;
begin
  exit SleefInternal.Sleef_powd1_u10(x, y);
end;

class method Math.Round(a: Double): Double;
begin
  exit SleefInternal.llvm_round_f64(a);
end;

class method Math.Sin(x: Double): Double;
begin
  exit SleefInternal.Sleef_sind1_u10(x);
end;

class method Math.Sinh(x: Double): Double;
begin
  exit SleefInternal.Sleef_sinhd1_u10(x);
end;

class method Math.Sqrt(d: Double): Double;
begin
  exit SleefInternal.llvm_sqrt_f64(d);
end;

class method Math.Sqrt(d: Single): Single;
begin
  exit SleefInternal.llvm_sqrt_f32(d);
end;

class method Math.Tan(d: Double): Double;
begin
  exit SleefInternal.Sleef_tand1_u10(d);
end;

class method Math.Tanh(d: Double): Double;
begin
  exit SleefInternal.Sleef_tanhd1_u10(d);
end;

class method Math.Truncate(d: Double): Double;
begin
  exit SleefInternal.llvm_trunc_f64(d);
end;

class method Math.Truncate(d: Single): Single;
begin
  exit SleefInternal.llvm_trunc_f32(d);
end;

// C RTL symbol exports - hidden in SleefInternal for LLVM vectorization
class method SleefInternal.acos(d: Double): Double;
begin
  exit Sleef_acosd1_u10(d);
end;

class method SleefInternal.asin(d: Double): Double;
begin
  exit Sleef_asind1_u10(d);
end;

class method SleefInternal.atan(d: Double): Double;
begin
  exit Sleef_atand1_u10(d);
end;

class method SleefInternal.atan2(y, x: Double): Double;
begin
  exit Sleef_atan2d1_u10(y, x);
end;

class method SleefInternal.ceil(d: Double): Double;
begin
  exit llvm_ceil_f64(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.ceilf(d: Single): Single;
begin
  exit llvm_ceil_f32(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.cos(d: Double): Double;
begin
  exit Sleef_cosd1_u10(d);
end;

class method SleefInternal.cosh(d: Double): Double;
begin
  exit Sleef_coshd1_u10(d);
end;

class method SleefInternal.exp(d: Double): Double;
begin
  exit Sleef_expd1_u10(d);
end;

class method SleefInternal.exp2(d: Double): Double;
begin
  exit Sleef_exp2d1_u10(d);
end;

class method SleefInternal.fabs(d: Double): Double;
begin
  exit llvm_fabs_f64(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.floor(d: Double): Double;
begin
  exit llvm_floor_f64(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.floorf(d: Single): Single;
begin
  exit llvm_floor_f32(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.fmod(x, y: Double): Double;
begin
  exit Sleef_fmodd1(x, y);
end;

class method SleefInternal.log(d: Double): Double;
begin
  exit Sleef_logd1_u10(d);
end;

class method SleefInternal.log2(d: Double): Double;
begin
  exit Sleef_log2d1_u10(d);
end;

class method SleefInternal.log10(d: Double): Double;
begin
  exit Sleef_log10d1_u10(d);
end;

class method SleefInternal.pow(x, y: Double): Double;
begin
  exit Sleef_powd1_u10(x, y);
end;

class method SleefInternal.round(d: Double): Double;
begin
  exit llvm_round_f64(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.sin(d: Double): Double;
begin
  exit Sleef_sind1_u10(d);
end;

class method SleefInternal.sinh(d: Double): Double;
begin
  exit Sleef_sinhd1_u10(d);
end;

class method SleefInternal.sqrt(d: Double): Double;
begin
  exit llvm_sqrt_f64(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.sqrtf(d: Single): Single;
begin
  exit llvm_sqrt_f32(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.tan(d: Double): Double;
begin
  exit Sleef_tand1_u10(d);
end;

class method SleefInternal.tanh(d: Double): Double;
begin
  exit Sleef_tanhd1_u10(d);
end;

class method SleefInternal.trunc(d: Double): Double;
begin
  exit llvm_trunc_f64(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

class method SleefInternal.truncf(d: Single): Single;
begin
  exit llvm_trunc_f32(d);  // Forward to LLVM intrinsic for SLEEF library dependency
end;

{$ENDIF}

end.