# Script PowerShell para subir cambios del servidor a GitHub
# Uso: Doble clic o .\GUARDAR CAMBIOS.ps1

param(
    [string]$mensaje = ""
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   GUARDAR CAMBIOS EN GITHUB - PokeRetro Server" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "[1/5] Regenerando manifest..." -ForegroundColor Yellow
    & "C:\Users\PC\AppData\Local\Programs\Python\Python314\python.exe" generar_manifest.py
    
    Write-Host ""
    Write-Host "[2/5] Verificando cambios..." -ForegroundColor Yellow
    git status
    
    Write-Host ""
    Write-Host "[3/5] Agregando archivos..." -ForegroundColor Yellow
    git add -A
    
    Write-Host ""
    Write-Host "[4/5] Creando commit..." -ForegroundColor Yellow
    
    if ($mensaje -eq "") {
        $mensaje = Read-Host "Describe los cambios realizados"
        if ($mensaje -eq "") {
            $mensaje = "Actualizacion del servidor"
        }
    }
    
    git commit -m $mensaje
    
    Write-Host ""
    Write-Host "[5/5] Subiendo a GitHub..." -ForegroundColor Yellow
    git push origin main
    
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "   CAMBIOS GUARDADOS EN GITHUB!" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
catch {
    Write-Host ""
    Write-Host "ERROR: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Presiona cualquier tecla para continuar..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}