param([Parameter(Mandatory=$true)][string]$Executable)
$ErrorActionPreference = 'Stop'
$folder = Join-Path $env:TEMP 'Elements-Arm64EcRuntimeValidation'
New-Item -ItemType Directory -Force -Path $folder | Out-Null
Copy-Item -LiteralPath $Executable -Destination (Join-Path $folder 'Arm64EcCookie.exe') -Force
$exe = Join-Path $folder 'Arm64EcCookie.exe'
foreach ($test in @('valid', 'corrupt', 'uninitialized')) {
  $start = New-Object System.Diagnostics.ProcessStartInfo
  $start.FileName = $exe
  $start.WorkingDirectory = $folder
  $start.UseShellExecute = $false
  $start.RedirectStandardOutput = $true
  $start.RedirectStandardError = $true
  if ($test -ne 'valid') { $start.Arguments = $test }
  $child = [System.Diagnostics.Process]::Start($start)
  if (-not $child.WaitForExit(20000)) { $child.Kill(); throw "Cookie test timed out: $test" }
  $output = $child.StandardOutput.ReadToEnd()
  $err = $child.StandardError.ReadToEnd()
  Write-Output "$test : exit=$($child.ExitCode) stdout=$output stderr=$err"
  $expected = if ($test -eq 'valid') { 0 } else { -1073740791 }
  if ($child.ExitCode -ne $expected) { throw "Unexpected exit for $test" }
}
