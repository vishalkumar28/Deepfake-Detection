$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path

function Ensure-Dir($path) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

$effDir = Join-Path $repoRoot "efficient-vit\pretrained_models"
$crossDir = Join-Path $repoRoot "cross-efficient-vit\pretrained_models"
Ensure-Dir $effDir
Ensure-Dir $crossDir

Write-Host "[weights] Downloading Efficient ViT weights..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "http://datino.isti.cnr.it/efficientvit_deepfake/efficient_vit.pth" -OutFile (Join-Path $effDir "efficient_vit.pth")

Write-Host "[weights] Downloading Cross Efficient ViT weights..." -ForegroundColor Cyan
Invoke-WebRequest -Uri "http://datino.isti.cnr.it/efficientvit_deepfake/cross_efficient_vit.pth" -OutFile (Join-Path $crossDir "cross_efficient_vit.pth")

Write-Host "[weights] Completed." -ForegroundColor Green