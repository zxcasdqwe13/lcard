<#
.SYNOPSIS
    Build ADI_DSP/E440.BIO with the original 21xx DOS toolchain in DOSBox.

.DESCRIPTION
    DOSBox 0.74 cannot mount the VirtualBox shared folder that hosts the
    repository (F:), while the DOS toolchain needs a local path.  This script
    mirrors ADI_DSP to a local directory, runs the DOS build there, waits for a
    fresh E440.BIO and copies it back into the repository.  It is the Windows
    counterpart of tools/build_bios.sh.

.PARAMETER Repo
    Repository root (defaults to the parent directory of this script).

.PARAMETER WorkDir
    Local mirror directory that DOSBox can mount.  Must not contain spaces
    (DOSBox 0.74 mount limitation).  Default: %TEMP%\e440-build.

.PARAMETER DosBox
    Path to DOSBox.exe.  Auto-detected from PATH or Program Files when omitted.

.PARAMETER TimeoutSec
    Maximum time to wait for a fresh E440.BIO.

.PARAMETER KeepSymbols
    Run asm21/ld21/bin3pci manually instead of GoDsp.bat and keep e440.exe /
    e440.sym in the mirror for SIM2181.

.PARAMETER Clean
    Remove DOS intermediates from the mirror after a successful build.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\build_bios.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools\build_bios.ps1 -KeepSymbols
#>
[CmdletBinding()]
param(
    [string]$Repo = "",
    [string]$WorkDir = (Join-Path $env:TEMP "e440-build"),
    [string]$DosBox = "",
    [int]$TimeoutSec = 120,
    [switch]$KeepSymbols,
    [switch]$Clean
)

$ErrorActionPreference = "Stop"

if (-not $Repo) {
    if ($PSScriptRoot) {
        $Repo = Split-Path -Parent $PSScriptRoot
    } else {
        $Repo = (Get-Location).Path
    }
}
$repoPath = (Resolve-Path $Repo).Path
$src = Join-Path $repoPath "ADI_DSP"
$bat = Join-Path $src "GoDsp.bat"
$dsp = Join-Path $src "E440.DSP"
foreach ($required in @($bat, $dsp)) {
    if (-not (Test-Path -LiteralPath $required)) {
        throw "Required file not found: $required"
    }
}

if ($WorkDir -match '\s') {
    throw "WorkDir must not contain spaces: $WorkDir (DOSBox 0.74 mount limitation)"
}

if (-not $DosBox) {
    $command = Get-Command dosbox -ErrorAction SilentlyContinue
    if ($command) {
        $DosBox = $command.Source
    } else {
        $candidates = @(
            "C:\Program Files (x86)\DOSBox-0.74-3\DOSBox.exe",
            "C:\Program Files\DOSBox-0.74-3\DOSBox.exe",
            "C:\Program Files (x86)\DOSBox-0.74\DOSBox.exe",
            "C:\Program Files\DOSBox-0.74\DOSBox.exe"
        )
        foreach ($candidate in $candidates) {
            if (Test-Path -LiteralPath $candidate) {
                $DosBox = $candidate
                break
            }
        }
    }
}
if (-not $DosBox -or -not (Test-Path -LiteralPath $DosBox)) {
    throw "DOSBox.exe not found; pass -DosBox <path>"
}

$mirrorDsp = Join-Path $WorkDir "ADI_DSP"
if (Test-Path -LiteralPath $WorkDir) {
    Remove-Item -LiteralPath $WorkDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
& robocopy $src $mirrorDsp /E /NFL /NDL /NJH /NJS | Out-Null
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}

$bio = Join-Path $mirrorDsp "E440.BIO"
if (Test-Path -LiteralPath $bio) {
    Remove-Item -LiteralPath $bio -Force
}
$marker = Get-Date

$commands = @("mount c $WorkDir", "c:", "cd ADI_DSP")
if ($KeepSymbols) {
    # cmd.exe in DOSBox resolves only 8.3 batch names reliably, hence BLDDBG.BAT.
    $debugBat = @'
@ECHO OFF
Set ADII=C:\ADI_DSP\21XX\INCLUDE
Set ADIL=C:\ADI_DSP\21XX\LIB
Set ADIRTH=C:\ADI_DSP\LIB
Set ADI_DSP=C:\ADI_DSP
PATH=C:\ADI_DSP\21XX\BIN;
asm21 inttable -2181
asm21 e440 -2181
ld21 inttable e440 -a e440 -g -e e440 -l
bin3pci e440.exe
'@
    Set-Content -LiteralPath (Join-Path $mirrorDsp "BLDDBG.BAT") -Value $debugBat -Encoding ascii
    $commands += "BLDDBG.BAT"
} else {
    $commands += "GoDsp.bat"
}
$commands += "exit"

$existing = @(
    Get-Process DOSBox -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Id
)
$dosArgs = @()
foreach ($item in $commands) {
    $dosArgs += @("-c", $item)
}

Write-Host "Building E440.BIO in DOSBox..."
Write-Host "  source: $src"
Write-Host "  mirror: $mirrorDsp"
& $DosBox @dosArgs

$deadline = (Get-Date).AddSeconds($TimeoutSec)
$previous = ""
$stable = 0
$fresh = $false
while ((Get-Date) -lt $deadline) {
    if (Test-Path -LiteralPath $bio) {
        $item = Get-Item -LiteralPath $bio
        if ($item.LastWriteTime -gt $marker) {
            $current = "$($item.Length):$($item.LastWriteTime.Ticks)"
            if ($current -eq $previous) {
                $stable++
            } else {
                $stable = 0
                $previous = $current
            }
            if ($stable -ge 3) {
                $fresh = $true
                break
            }
        }
    }
    Start-Sleep -Milliseconds 250
}

Get-Process DOSBox -ErrorAction SilentlyContinue |
    Where-Object { $existing -notcontains $_.Id } |
    Stop-Process -Force -ErrorAction SilentlyContinue

if (-not $fresh) {
    throw "E440.BIO was not produced within $TimeoutSec s; run GoDsp.bat manually in DOSBox for details"
}

$target = Join-Path $src "E440.BIO"
Copy-Item -LiteralPath $bio -Destination $target -Force

if ($Clean) {
    $patterns = @("*.obj", "*.OBJ", "*.cde", "*.CDE", "*.int", "*.INT", "*.bak", "*.BAK")
    if (-not $KeepSymbols) {
        $patterns += @("*.sym", "*.SYM", "e440.exe", "inttable.exe")
    }
    foreach ($pattern in $patterns) {
        Get-ChildItem -LiteralPath $mirrorDsp -Filter $pattern -File -ErrorAction SilentlyContinue |
            Remove-Item -Force -ErrorAction SilentlyContinue
    }
}

$built = Get-Item -LiteralPath $target
$hash = (Get-FileHash -LiteralPath $target -Algorithm MD5).Hash
Write-Host ""
Write-Host "OK: $($built.FullName) ($($built.Length) bytes, md5 $hash)" -ForegroundColor Green
Write-Host "mirror: $mirrorDsp"
if ($KeepSymbols) {
    Write-Host "symbols: $mirrorDsp\e440.exe, $mirrorDsp\e440.sym"
    Write-Host "simulate:"
    Write-Host "  & `"$DosBox`" -c `"mount c $WorkDir`" -c `"c:`" -c `"cd ADI_DSP`" -c `"set PATH=C:\ADI_DSP\21XX\BIN;`" -c `"sim2181 e440`""
}
