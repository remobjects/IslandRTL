# Optimization workload coverage

`Optimization_Workloads.pas` contains ordinary application code with deterministic
EUnit assertions. It is included by `Island.Tests.Shared.projitems`, including the
macOS project run by the Elements Afterhours **Island RTL** module. Math remainder
and string equality regression tests use the same registration.

The workload helpers deliberately disable inlining so their generated code can
be inspected individually. Correctness tests do not assert elapsed time, SIMD
widths, instruction counts, or that a particular optimization must run on every
target. Build with optimization and `GenerateIRFile=True` to inspect them.

| Helper | Work | Optimization to inspect |
| --- | --- | --- |
| `TailSum` | Accumulating recursive sum | Self call replaced by a loop |
| `TreeSum` | Binary tree and a one-sided chain | One recursive branch becomes a loop; the other remains recursive |
| `InvoiceTotal` | Filter records and accumulate quantity times price | Length hoisting, bounds-check elimination, conditional reduction |
| `ParseNumbers` | Sum comma-separated decimal numbers | Bounds checks and character classification; digit accumulation has a real dependency |
| `TransformAndSum` | Modify an integer array and accumulate in Int64 | SIMD transform, widened reduction and safe scalar tail |
| `Dispatch` | Call either of two implementations through a base class | Retain dynamic dispatch unless the concrete target is proven |
| `KnownDispatch` | Allocate a known sealed implementation and call it | Resolve the virtual call when the method table is visible |

Use separate timed runs with setup outside the measured region to compare code
quality. Keep the input and result checks identical across compiler versions.
An EUnit pass alone establishes correctness, not that any optimization happened.
