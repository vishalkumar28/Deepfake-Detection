# End-to-End Deepfake Detection (Windows)

This folder provides Windows-friendly scripts to set up and run the deepfake detection pipeline end-to-end using the cloned repository.

## Prerequisites
- Windows 10/11
- Python 3.9+ available on PATH (`python --version`)
- Sufficient disk space for datasets

## Steps

1. Setup Python environment and dependencies
   - Open PowerShell in the repo root (this folder is inside the repo).
   - Run:
     ```powershell
     ./end_to_end/setup.ps1
     ```

2. Download pre-trained weights (optional for evaluation)
   - Run:
     ```powershell
     ./end_to_end/download_weights.ps1
     ```

3. Prepare dataset (face detection and crop extraction)
   - Place your source videos under any folder, e.g. `D:\data\dfdc_videos`.
   - Run:
     ```powershell
     ./end_to_end/prepare_dataset.ps1 -InputVideos "D:\data\dfdc_videos" -OutputDataset "$(Resolve-Path .)\end_to_end\dataset" -Dataset "DFDC"
     ```
   - This will create a DFDC-like dataset structure under `end_to_end\dataset` with detected face crops.

4. Run evaluation on prepared dataset
   - Efficient ViT:
     ```powershell
     ./end_to_end/run_evaluation.ps1 -Model efficient-vit -Dataset DFDC -FramesPerVideo 30 -BatchSize 32
     ```
   - Cross Efficient ViT:
     ```powershell
     ./end_to_end/run_evaluation.ps1 -Model cross-efficient-vit -Dataset DFDC -FramesPerVideo 30 -BatchSize 32
     ```

## Notes
- If `download_weights.ps1` fails, you can manually download weights and place them into:
  - `efficient-vit\pretrained_models\efficient_vit.pth`
  - `cross-efficient-vit\pretrained_models\cross_efficient_vit.pth`
- The preprocessing scripts follow DFDC structure by default. Use `-Dataset FACEFORENSICS` if needed.
- For large datasets, increase `-Workers` to speed up preprocessing.

## Troubleshooting
- If Python isn’t found, install it from https://www.python.org/downloads/ and re-run `setup.ps1`.
- If Torch install fails due to CUDA, the script installs CPU builds by default. You can modify the install line in `setup.ps1` to match your CUDA version.