param(
    [switch]$Recreate
)

$ErrorActionPreference = "Stop"

Write-Host "[setup] Checking Python..." -ForegroundColor Cyan
$pythonVersion = & python --version 2>$null
if (-not $pythonVersion) {
    Write-Error "Python is not installed or not in PATH. Please install Python 3.9+ and retry."
}
Write-Host "[setup] Using $pythonVersion" -ForegroundColor Green

$repoRoot = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
$venvPath = Join-Path $repoRoot ".venv"

if ($Recreate -and (Test-Path $venvPath)) {
    Write-Host "[setup] Removing existing venv..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $venvPath
}

if (-not (Test-Path $venvPath)) {
    Write-Host "[setup] Creating virtual environment at $venvPath" -ForegroundColor Cyan
    & python -m venv "$venvPath"
}

$venvPython = Join-Path $venvPath "Scripts\python.exe"
Write-Host "[setup] Upgrading pip..." -ForegroundColor Cyan
& "$venvPython" -m pip install --upgrade pip

Write-Host "[setup] Installing core dependencies (CPU build)..." -ForegroundColor Cyan
& "$venvPython" -m pip install torch torchvision torchaudio --default-timeout=600

Write-Host "[setup] Installing project dependencies..." -ForegroundColor Cyan
& "$venvPython" -m pip install efficientnet-pytorch vit-pytorch mtcnn opencv-python numpy tqdm pyyaml pillow einops timm scikit-image scikit-learn pandas matplotlib requests

Write-Host "[setup] Environment ready. Activate with: `& $venvPath\Scripts\Activate.ps1`" -ForegroundColor Green