<#
.SYNOPSIS
    Closed-loop IIR filter test for the E14-440 in the Windows VM.

.DESCRIPTION
    Uses the py -3 launcher because "python" in the VM is the Microsoft Store
    stub.  numpy is optional: without it filter-capture writes CSV and the
    pure-Python model still runs.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\run_filter_test.ps1
    powershell -ExecutionPolicy Bypass -File tools\run_filter_test.ps1 -StartDac
    powershell -ExecutionPolicy Bypass -File tools\run_filter_test.ps1 -ProcSwitch 2
#>
[CmdletBinding()]
param(
    [string]$Repo = "",
    [int]$RateKhz = 200,
    [int]$Channels = 2,
    [int]$Decimation = 10,
    [int]$Blocks = 2,
    [int]$BufferWords = 32768,
    [int]$TimeoutMs = 120000,
    [double]$InterKadrDelay = 0.01,
    [int]$ProcSwitch = 1,
    [int]$IirStep = 1,
    [int]$InputDelay = 2,
    [double]$MaxNrmse = 0.2,
    [switch]$KeepPolarity,
    [int]$InputChannel = -1,
    [int]$DacChannel = -1,
    [switch]$StartDac,
    [switch]$SkipQuickCheck
)

$ErrorActionPreference = "Stop"
if (-not $Repo) {
    if ($PSScriptRoot) {
        $Repo = Split-Path -Parent $PSScriptRoot
    } else {
        $Repo = (Get-Location).Path
    }
}
if ($ProcSwitch -notin @(1, 2)) {
    throw "This test supports ProcSwitch 1 or 2 (single-channel model)."
}

$repoPath = (Resolve-Path $Repo).Path
Set-Location $repoPath
$env:PYTHONPATH = Join-Path $repoPath "python\src"

$bios = Join-Path $repoPath "ADI_DSP\E440.BIO"
$dll = Join-Path $repoPath "MyCppLib\Lusbapi64.dll"
$coeffDir = Join-Path $repoPath "test_coeffs"
$fir = Join-Path $coeffDir "fir_zero.hex"
$iir = Join-Path $coeffDir "iir_first_order.hex"
$log = Join-Path $repoPath "filter_test_log.txt"
$capture = Join-Path $repoPath "filter_capture.npz"
$report = Join-Path $repoPath "filter_report.json"

foreach ($required in @($bios, $dll)) {
    if (-not (Test-Path $required)) {
        throw "Required file not found: $required"
    }
}

New-Item -ItemType Directory -Force -Path $coeffDir | Out-Null
if (-not (Test-Path $fir)) {
    (1..64 | ForEach-Object { "0000" }) | Set-Content -Encoding ascii $fir
}
if (-not (Test-Path $iir)) {
    $lines = @("C000", "0000") + @(1..6 | ForEach-Object { "0000" })
    $lines | Set-Content -Encoding ascii $iir
}

if ($ProcSwitch -eq 2) {
    if ($InputChannel -lt 0) { $InputChannel = 1 }
    if ($DacChannel -lt 0) { $DacChannel = 0 }
} else {
    if ($InputChannel -lt 0) { $InputChannel = 0 }
    if ($DacChannel -lt 0) { $DacChannel = 1 }
}

$script:Log = $log
"=== E440 filter test $(Get-Date -Format o) ===" | Tee-Object -FilePath $log
"repo=$repoPath" | Tee-Object -FilePath $log -Append
"proc_switch=$ProcSwitch input=$InputChannel dac=$DacChannel" |
    Tee-Object -FilePath $log -Append

function Invoke-Py {
    param([string[]]$Arguments)
    Write-Host ""
    Write-Host ">>> py -3 $($Arguments -join ' ')" -ForegroundColor Cyan
    $previous = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & py -3 @Arguments 2>&1
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
    }
    $output | Tee-Object -FilePath $script:Log -Append
    if ($code -ne 0) {
        throw "py -3 exited with code $code"
    }
}

Write-Host "=== Python ==="
try {
    Invoke-Py -Arguments @("-c", "import sys; print(sys.version)")
} catch {
    throw "py -3 is not available: $_"
}

$numpyOk = $false
try {
    & py -3 -c "import numpy; print('numpy', numpy.__version__)" 2>&1 | Out-Null
    $numpyOk = ($LASTEXITCODE -eq 0)
} catch {
    $numpyOk = $false
}
if ($numpyOk) {
    Write-Host "numpy: available" -ForegroundColor Green
} else {
    Write-Host "numpy: not installed; CSV fallback, spectrum is skipped" -ForegroundColor Yellow
}

Write-Host "=== Device ==="
Invoke-Py -Arguments @("-m", "e440", "info", "--bios", $bios, "--dll", $dll)

if (-not $SkipQuickCheck) {
    Write-Host "=== Quick ADC check (play the WAV now) ==="
    Write-Host "Check channel $InputChannel for noise and clipping." -ForegroundColor Yellow
    Invoke-Py -Arguments @(
        "-m", "e440", "acquire", "--no-filters",
        "--blocks", "$Blocks", "--buffer-words", "$BufferWords",
        "--channels", "$Channels", "--control-table", "128", "131",
        "--timeout-ms", "$TimeoutMs", "--inter-kadr-delay", "$InterKadrDelay",
        "--bios", $bios, "--dll", $dll,
        "--out", (Join-Path $repoPath "quick_check.npy")
    )
}

Write-Host "=== Filter capture ==="
$captureArgs = @(
    "-m", "e440", "filter-capture",
    "--blocks", "$Blocks", "--buffer-words", "$BufferWords",
    "--timeout-ms", "$TimeoutMs", "--channels", "$Channels",
    "--inter-kadr-delay", "$InterKadrDelay",
    "--rate", "$RateKhz", "--control-table", "128", "131",
    "--proc-switch", "$ProcSwitch", "--decimation", "$Decimation",
    "--ntaps", "32", "--n2taps", "2",
    "--fir-file", $fir, "--iir-file", $iir,
    "--bios", $bios, "--dll", $dll, "--out", $capture
)
if ($StartDac) {
    $captureArgs += "--start-dac"
}
Invoke-Py -Arguments $captureArgs

if (-not (Test-Path $capture)) {
    $capture = [System.IO.Path]::ChangeExtension($capture, ".csv")
}
if (-not (Test-Path $capture)) {
    throw "Capture file was not created: $capture"
}

Write-Host "=== Model comparison ==="
$testArgs = @(
    "-m", "e440", "filter-test",
    "--capture", $capture, "--channels", "$Channels",
    "--ntaps", "32", "--n2taps", "2", "--decimation", "$Decimation",
    "--input-channel", "$InputChannel", "--dac-channel", "$DacChannel",
    "--iir-step", "$IirStep", "--input-delay", "$InputDelay",
    "--max-nrmse", "$MaxNrmse",
    "--fir-file", $fir, "--iir-file", $iir,
    "--auto", "--out-json", $report
)
if (-not $KeepPolarity) {
    $testArgs += "--invert-output"
}
if ($capture -like "*.csv") {
    $testArgs += @("--rate-khz", "$RateKhz")
}
Invoke-Py -Arguments $testArgs

Write-Host ""
Write-Host "capture: $capture" -ForegroundColor Green
Write-Host "report:  $report" -ForegroundColor Green
Write-Host "log:     $log" -ForegroundColor Green
Write-Host ""
Write-Host "If the DAC channel was silent, rerun with -StartDac." -ForegroundColor Yellow
Write-Host "If noise is on ADC channel 1, rerun with -ProcSwitch 2." -ForegroundColor Yellow
