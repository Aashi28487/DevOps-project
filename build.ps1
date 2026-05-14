<#
.SYNOPSIS
    Builds the EduSphere Flask Application Docker Image and optionally applies k8s manifests.
    
.DESCRIPTION
    This script will:
    1. Build the Docker image aashi2801/flask-app:latest
    2. Apply the Kubernetes manifests located in k8s/manifests/ (if requested)
#>

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  EduSphere Build & Deploy Script" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

$imageName = "aashi2801/flask-app:latest"

# 1. Build the Docker Image
Write-Host ">>> Building Docker image: $imageName" -ForegroundColor Green
docker build -t $imageName .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "Docker build completed successfully." -ForegroundColor Green
Write-Host ""

# 2. Ask to Deploy to Kubernetes
$deploy = Read-Host "Do you want to deploy the manifests to Kubernetes? (Y/N)"

if ($deploy -match "^[Yy]$") {
    Write-Host ">>> Applying Kubernetes Manifests..." -ForegroundColor Green
    kubectl apply -f k8s/manifests/
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Kubernetes deployment failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Deployment applied successfully." -ForegroundColor Green
    Write-Host "You can check the status with: kubectl get pods,svc" -ForegroundColor Yellow
} else {
    Write-Host "Skipping Kubernetes deployment." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Cyan
