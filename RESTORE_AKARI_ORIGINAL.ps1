$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "Akari Stop - Restore Original Akari Asset" -ForegroundColor Cyan
Write-Host "=========================================="

$path = Join-Path $PSScriptRoot "sharedassets0.assets"
$backup = "$path.akari-original"
$expectedOriginal = "9839b25cc8bcaa5d2b0db9f6abfaa3d1caabbefc91855f60f8c450acea29d792"

if (!(Test-Path -LiteralPath $backup)) {
    throw "Backup not found: $backup"
}

Copy-Item -Force -LiteralPath $backup -Destination $path

$hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash.ToLowerInvariant()

if ($hash -eq $expectedOriginal) {
    Write-Host ""
    Write-Host "RESTORE PASS" -ForegroundColor Green
    Write-Host "Original sharedassets0.assets restored."
} else {
    Write-Host ""
    Write-Host "Restore completed, but hash differs from inspected original:" -ForegroundColor Yellow
    Write-Host $hash
}
