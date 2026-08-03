# Script PowerShell para subir cambios del servidor a GitHub (Servidor Beta)
# Uso: Doble clic o .\GUARDAR CAMBIOS BETA.ps1

param(
    [string]$mensaje = ""
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   GUARDAR CAMBIOS EN GITHUB - Servidor Beta" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "[1/6] Regenerando manifest..." -ForegroundColor Yellow
    
    # Verificar si Python existe
    $pythonPath = "C:\Users\PC\AppData\Local\Programs\Python\Python314\python.exe"
    if (-not (Test-Path $pythonPath)) {
        # Intentar con python en PATH
        $pythonPath = "python"
    }
    
    & $pythonPath generar_manifest.py
    
    Write-Host ""
    Write-Host "[2/6] Verificando cambios..." -ForegroundColor Yellow
    git status
    
    Write-Host ""
    Write-Host "[3/6] Agregando archivos..." -ForegroundColor Yellow
    git add -A
    
    Write-Host ""
    Write-Host "[4/6] Creando commit..." -ForegroundColor Yellow
    
    if ($mensaje -eq "") {
        $mensaje = Read-Host "Describe los cambios realizados"
        if ($mensaje -eq "") {
            $mensaje = "Actualizacion del servidor beta"
        }
    }
    
    git commit -m $mensaje
    
    Write-Host ""
    Write-Host "[5/6] Subiendo a repositorio principal (server)..." -ForegroundColor Yellow
    git push origin main
    
    Write-Host ""
    Write-Host "[6/6] Subiendo a repositorio beta (Server0.1)..." -ForegroundColor Yellow
    
    # Verificar si el remoto beta existe
    $remotoBeta = git remote | Select-String -Pattern "beta"
    
    if ($null -eq $remotoBeta) {
        Write-Host "Configurando remoto 'beta'..." -ForegroundColor Cyan
        git remote add beta https://github.com/matiasm200601-spec/Server0.1.git
        git branch -M main
    }
    
    # Subir a beta
    git push -u beta main -f
    
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "   CAMBIOS GUARDADOS EN AMBOS REPOSITORIOS!" -ForegroundColor Green
    Write-Host "   - Server (principal)" -ForegroundColor Green
    Write-Host "   - Server0.1 (beta)" -ForegroundColor Green
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
