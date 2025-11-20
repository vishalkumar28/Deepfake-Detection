param(
    [ValidateSet("efficient-vit","cross-efficient-vit")][string]$Model = "efficient-vit",
    [ValidateSet("Deepfakes","Face2Face","FaceShifter","FaceSwap","NeuralTextures","DFDC")][string]$Dataset = "DFDC",
    [int]$FramesPerVideo = 30,
    [int]$BatchSize = 32,
    [int]$Workers = 10,
    [int]$MaxVideos = 0
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
$venvPython = Join-Path $repoRoot ".venv\Scripts\python.exe"
if (-not (Test-Path $venvPython)) {
    Write-Error "Virtual environment not found. Run end_to_end/setup.ps1 first."
}

switch ($Model) {
    "efficient-vit" {
        $modelPath = Join-Path $repoRoot "efficient-vit\pretrained_models\efficient_vit.pth"
        $configPath = Join-Path $repoRoot "efficient-vit\configs\architecture.yaml"
        $testScript = Join-Path $repoRoot "efficient-vit\test.py"
    }
    "cross-efficient-vit" {
        $modelPath = Join-Path $repoRoot "cross-efficient-vit\pretrained_models\cross_efficient_vit.pth"
        $configPath = Join-Path $repoRoot "cross-efficient-vit\configs\architecture.yaml"
        $testScript = Join-Path $repoRoot "cross-efficient-vit\test.py"
    }
}

if (-not (Test-Path $modelPath)) {
    Write-Error "Model weights not found at $modelPath. Run end_to_end/download_weights.ps1 first or place the file manually."
}

$args = @(
    "--model_path", "$modelPath",
    "--config", "$configPath",
    "--dataset", "$Dataset",
    "--frames_per_video", "$FramesPerVideo",
    "--batch_size", "$BatchSize",
    "--workers", "$Workers"
)
if ($MaxVideos -gt 0) { $args += @("--max_videos", "$MaxVideos") }

Write-Host "[eval] Running $Model on $Dataset" -ForegroundColor Cyan
& "$venvPython" "$testScript" @args