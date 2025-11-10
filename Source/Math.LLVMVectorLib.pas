namespace RemObjects.Elements.System;

// SLEEF Vector Math Library Implementation for Island RTL
// =========================================================
//
// This file provides SLEEF-based implementations for Math class methods
// that enable LLVM auto-vectorization through VecFuncs.def mappings.
//
// ARCHITECTURE:
// 1. User code calls Math.Sin(x) (in a loop or sequence, ie, anywhere vectorisation is clear)
// 2. Compiler generates call to Sleef_sind1_u10 (SLEEF scalar function) (this is inlined, occurs anyway but via 'inline')
// 3. LLVM optimizer checks VecFuncs.def for Sleef_sind1_u10 mapping
// 4. VecFuncs.def maps Sleef_sind1_u10 → Sleef_sind2_u10advsimd (vector) or other wider vector funcs
//    (This should also occur if there is a reference to C-RTL name 'sin()' or llvm.sin.* intrinsic,
//    but this way we know for sure what will be emitted.)
// 5. Loop vectorizer replaces scalar calls with vector SLEEF calls
//
// - SleefInternal: External declarations for SLEEF scalar functions
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
    // Utility functions with SLEEF implementations
    [MemoryNone, NoExcept, WillReturn]
    class method Abs(i: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method fmod(x, y: Double): Double; inline;
    [MemoryNone, NoExcept, WillReturn]
    class method fmodf(x,y: Single): Single; inline;
  end;

implementation

type
  // Internal SLEEF scalar function declarations
  // These link directly to the SLEEF library (sleef.lib)
  SleefInternal = static class
  assembly  // assembly = internal visibility (accessible within same assembly)
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
  exit SleefInternal.Sleef_fabsd1(i);
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
  exit SleefInternal.Sleef_ceild1(d);
end;

class method Math.Ceiling(d: Single): Single;
begin
  exit SleefInternal.Sleef_ceilf1(d);
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
  exit SleefInternal.Sleef_floord1(d);
end;

class method Math.Floor(d: Single): Single;
begin
  exit SleefInternal.Sleef_floorf1(d);
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
  exit SleefInternal.Sleef_roundd1(a);
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
  exit SleefInternal.Sleef_sqrtd1_u05(d);
end;

class method Math.Sqrt(d: Single): Single;
begin
  exit SleefInternal.Sleef_sqrtf1(d);
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
  exit SleefInternal.Sleef_truncd1(d);
end;

class method Math.Truncate(d: Single): Single;
begin
  exit SleefInternal.Sleef_truncf1(d);
end;

{$ENDIF}

end.