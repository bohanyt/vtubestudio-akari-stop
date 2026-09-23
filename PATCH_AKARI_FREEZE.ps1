$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Akari Stop - Freeze Akari Watermark Movement" -ForegroundColor Cyan
Write-Host "============================================"
Write-Host "This keeps Akari visible and freezes only the watermark movement curves."
Write-Host ""

$path = Join-Path $PSScriptRoot "sharedassets0.assets"
$expectedOriginal = "9839b25cc8bcaa5d2b0db9f6abfaa3d1caabbefc91855f60f8c450acea29d792"
$expectedPatched  = "02c66838063ad592c67ca5d2520544d33afa515bb8d21cb508c59cc0694d9c46"

if (!(Test-Path -LiteralPath $path)) {
    throw "sharedassets0.assets not found next to this script. Put all patch files inside VTube Studio_Data."
}

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()

if ($hash -eq $expectedPatched) {
    Write-Host "Already patched. Nothing to do." -ForegroundColor Yellow
    exit 0
}

if ($hash -ne $expectedOriginal) {
    Write-Host ""
    Write-Host "REFUSING TO PATCH: file hash does not match the exact build inspected." -ForegroundColor Red
    Write-Host "Found:    $hash"
    Write-Host "Expected: $expectedOriginal"
    exit 10
}

$backup = "$path.akari-original"
if (!(Test-Path -LiteralPath $backup)) {
    Copy-Item -LiteralPath $path -Destination $backup
    Write-Host "Backup created: $backup" -ForegroundColor Green
} else {
    Write-Host "Backup already exists: $backup"
}

[byte[]]$bytes = [System.IO.File]::ReadAllBytes($path)

function Write-Float32LE {
    param(
        [byte[]]$Buffer,
        [int]$Offset,
        [single]$Value
    )
    [byte[]]$raw = [BitConverter]::GetBytes($Value)
    if (![BitConverter]::IsLittleEndian) {
        [Array]::Reverse($raw)
    }
    [Array]::Copy($raw, 0, $Buffer, $Offset, 4)
}

function Put-Curve-Key {
    param(
        [byte[]]$Buffer,
        [int]$Offset,
        [single]$Value
    )
    Write-Float32LE $Buffer ($Offset + 0)  ([single]0)
    Write-Float32LE $Buffer ($Offset + 4)  ([single]0)
    Write-Float32LE $Buffer ($Offset + 8)  ([single]0)
    Write-Float32LE $Buffer ($Offset + 12) $Value
}

[single]$fixedX = 0.09361285716295242

$xOffsets = @(
    0x168ef1c,
    0x168ef30,
    0x168ef9c,
    0x168efb0,
    0x168f07c,
    0x168f090,
    0x168f1ac,
    0x168f1c0
)

$extraMoveOffsets = @(
    0x168ef44,
    0x168efc4,
    0x168f024,
    0x168f0a4,
    0x168f0fc,
    0x168f154,
    0x168f1d4
)

foreach ($offset in $xOffsets) {
    Put-Curve-Key $bytes $offset $fixedX
}

foreach ($offset in $extraMoveOffsets) {
    Put-Curve-Key $bytes $offset ([single]0)
}

[System.IO.File]::WriteAllBytes($path, $bytes)

$newHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()

if ($newHash -ne $expectedPatched) {
    Write-Host ""
    Write-Host "POST-PATCH VERIFY FAILED. Restoring backup." -ForegroundColor Red
    Copy-Item -Force -LiteralPath $backup -Destination $path
    exit 11
}

Write-Host ""
Write-Host "PATCH PASS" -ForegroundColor Green
Write-Host "Akari remains present; the targeted movement curves are frozen."
Write-Host "Patched SHA256: $newHash"
Write-Host ""
Write-Host "Now start VTube Studio and watch Akari for at least 60 seconds."
