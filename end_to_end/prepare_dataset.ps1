param(
    [Parameter(Mandatory=$true)][string]$InputVideos,
    [Parameter(Mandatory=$true)][string]$OutputDataset,
    [ValidateSet("DFDC","FACEFORENSICS")][string]$Dataset = "DFDC",
    [int]$Workers = 8
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
$venvPython = Join-Path $repoRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    Write-Error "Virtual environment not found. Run end_to_end/setup.ps1 first."
}

$inputPath = Resolve-Path $InputVideos | Select-Object -ExpandProperty Path
$outputPath = Resolve-Path $OutputDataset -ErrorAction SilentlyContinue
if (-not $outputPath) {
    New-Item -ItemType Directory -Path $OutputDataset | Out-Null
    $outputPath = Resolve-Path $OutputDataset | Select-Object -ExpandProperty Path
}

Write-Host "[prep] Detecting faces in videos..." -ForegroundColor Cyan
& "$venvPython" "$repoRoot\preprocessing\detect_faces.py" --data_path "$inputPath" --dataset "$Dataset" --workers $Workers

Write-Host "[prep] Extracting crops to dataset..." -ForegroundColor Cyan
& "$venvPython" "$repoRoot\preprocessing\extract_crops.py" --data_path "$inputPath" --output_path "$outputPath" --dataset "$Dataset" --workers $Workers

Write-Host "[prep] Done. Dataset prepared at $outputPath" -ForegroundColor Green