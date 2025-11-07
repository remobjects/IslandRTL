namespace RemObjects.Elements.System;

// SLEEF Vector Math Library Implementation for Island RTL
// =========================================================
//
// This file provides SLEEF-based implementations for Math class methods
// that enable LLVM auto-vectorization through the VecFuncs system.
//
// SLEEF library exports functions like Sleef_sind1_u10, NOT plain "sin".
// For LLVM auto-vectorization to work, we need:
//   1. Plain C names (sin, cos, etc.) as external declarations for the optimizer
//   2. Actual implementations that forward to SLEEF scalar functions
//
// This file provides:
//   - Internal SLEEF scalar function declarations (Sleef_sind1_u10, etc.)
//   - Math class method implementations that forward to SLEEF
//   - Export functions with plain C names for LLVM vectorization
//
// How LLVM auto-vectorization works:
// 1. User code calls Math.Sin(x) in a loop
// 2. Compiler generates call to symbol "sin"
// 3. LLVM optimizer sees call to "sin" and checks VecFuncs.def
// 4. VecFuncs.def maps "sin" -> "Sleef_sind2_u10advsimd" (vector SLEEF)
// 5. InjectTLIMappings attaches VFABI attribute to enable vectorization
// 6. Loop vectorizer replaces scalar calls with vector SLEEF calls
// 7. Linker resolves "sin" to sin_impl() (below), which calls Sleef_sind1_u10
// 8. Linker resolves "Sleef_sind2_u10advsimd" to sleef.lib (vector function)

// Check same conditions as Math.pas - must be kept in sync!
{$IF (WINDOWS OR (DARWIN AND NOT (IOS OR TVOS OR WATCHOS OR VISIONOS)) OR (LINUX AND NOT ANDROID)) AND (i386 OR x86_64 OR ARM64)}
  {$DEFINE USE_LLVM_MATH_VECTORLIB}
{$ENDIF}

{$IFDEF USE_LLVM_MATH_VECTORLIB}

interface

type
  Math = public partial class
  end;

implementation

type
  // Internal SLEEF scalar function declarations
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

// Export implementations - provide plain C names for debug builds
// When LLVM intrinsics (llvm.sin.f64, etc.) are lowered to plain C calls,
// these export functions are linked to provide the actual SLEEF implementations
// These are needed because sleef.lib only exports "Sleef_sind1_u10", not "sin"
// LLVM needs to see calls to "sin" to apply VecFuncs.def mappings

[Export, SymbolName('sin'), CallingConvention(CallingConvention.Cdecl)]
function sin_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_sind1_u10(x);
end;

[Export, SymbolName('cos'), CallingConvention(CallingConvention.Cdecl)]
function cos_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_cosd1_u10(x);
end;

[Export, SymbolName('tan'), CallingConvention(CallingConvention.Cdecl)]
function tan_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_tand1_u10(x);
end;

[Export, SymbolName('asin'), CallingConvention(CallingConvention.Cdecl)]
function asin_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_asind1_u10(x);
end;

[Export, SymbolName('acos'), CallingConvention(CallingConvention.Cdecl)]
function acos_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_acosd1_u10(x);
end;

[Export, SymbolName('atan'), CallingConvention(CallingConvention.Cdecl)]
function atan_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_atand1_u10(x);
end;

[Export, SymbolName('atan2'), CallingConvention(CallingConvention.Cdecl)]
function atan2_impl(y: Double; x: Double): Double;
begin
  exit SleefInternal.Sleef_atan2d1_u10(y, x);
end;

[Export, SymbolName('sinh'), CallingConvention(CallingConvention.Cdecl)]
function sinh_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_sinhd1_u10(x);
end;

[Export, SymbolName('cosh'), CallingConvention(CallingConvention.Cdecl)]
function cosh_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_coshd1_u10(x);
end;

[Export, SymbolName('tanh'), CallingConvention(CallingConvention.Cdecl)]
function tanh_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_tanhd1_u10(x);
end;

[Export, SymbolName('exp'), CallingConvention(CallingConvention.Cdecl)]
function exp_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_expd1_u10(x);
end;

[Export, SymbolName('exp2'), CallingConvention(CallingConvention.Cdecl)]
function exp2_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_exp2d1_u10(x);
end;

[Export, SymbolName('log'), CallingConvention(CallingConvention.Cdecl)]
function log_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_logd1_u10(x);
end;

[Export, SymbolName('log2'), CallingConvention(CallingConvention.Cdecl)]
function log2_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_log2d1_u10(x);
end;

[Export, SymbolName('log10'), CallingConvention(CallingConvention.Cdecl)]
function log10_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_log10d1_u10(x);
end;

[Export, SymbolName('pow'), CallingConvention(CallingConvention.Cdecl)]
function pow_impl(x: Double; y: Double): Double;
begin
  exit SleefInternal.Sleef_powd1_u10(x, y);
end;

[Export, SymbolName('sqrt'), CallingConvention(CallingConvention.Cdecl)]
function sqrt_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_sqrtd1_u05(x);
end;

[Export, SymbolName('ceil'), CallingConvention(CallingConvention.Cdecl)]
function ceil_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_ceild1(x);
end;

[Export, SymbolName('ceilf'), CallingConvention(CallingConvention.Cdecl)]
function ceilf_impl(x: Single): Single;
begin
  exit SleefInternal.Sleef_ceilf1(x);
end;

[Export, SymbolName('floor'), CallingConvention(CallingConvention.Cdecl)]
function floor_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_floord1(x);
end;

[Export, SymbolName('floorf'), CallingConvention(CallingConvention.Cdecl)]
function floorf_impl(x: Single): Single;
begin
  exit SleefInternal.Sleef_floorf1(x);
end;

[Export, SymbolName('trunc'), CallingConvention(CallingConvention.Cdecl)]
function trunc_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_truncd1(x);
end;

[Export, SymbolName('truncf'), CallingConvention(CallingConvention.Cdecl)]
function truncf_impl(x: Single): Single;
begin
  exit SleefInternal.Sleef_truncf1(x);
end;

[Export, SymbolName('round'), CallingConvention(CallingConvention.Cdecl)]
function round_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_roundd1(x);
end;

[Export, SymbolName('fabs'), CallingConvention(CallingConvention.Cdecl)]
function fabs_impl(x: Double): Double;
begin
  exit SleefInternal.Sleef_fabsd1(x);
end;

[Export, SymbolName('fmod'), CallingConvention(CallingConvention.Cdecl)]
function fmod_impl(x: Double; y: Double): Double;
begin
  exit SleefInternal.Sleef_fmodd1(x, y);
end;

[Export, SymbolName('fmodf'), CallingConvention(CallingConvention.Cdecl)]
function fmodf_impl(x: Single; y: Single): Single;
begin
  exit SleefInternal.Sleef_fmodf1(x, y);
end;

{$ENDIF}

end.
