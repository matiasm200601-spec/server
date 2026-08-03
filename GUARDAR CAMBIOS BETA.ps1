# Script PowerShell para subir cambios del servidor a GitHub (Servidor Beta)
# Uso: Doble clic o .\GUARDAR CAMBIOS BETA.ps1

param(
    [string]$mensaje = ""
)

$ErrorActionPreference = "Continue"
Set-Location $PSScriptRoot

Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   GUARDAR CAMBIOS EN GITHUB - Servidor Beta" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "[1/7] Verificando configuración de Git..." -ForegroundColor Yellow
    
    # Configurar Git para evitar problemas de SSH
    $env:GIT_SSH_COMMAND = "ssh -o StrictHostKeyChecking=no"
    
    Write-Host "[2/7] Regenerando manifest..." -ForegroundColor Yellow
    
    # Verificar si Python existe
    $pythonPath = "C:\Users\PC\AppData\Local\Programs\Python\Python314\python.exe"
    if (-not (Test-Path $pythonPath)) {
        # Intentar con python en PATH
        $pythonPath = "python"
    }
    
    & $pythonPath generar_manifest.py
    
    Write-Host ""
    Write-Host "[3/7] Verificando cambios..." -ForegroundColor Yellow
    git status --short
    
    Write-Host ""
    Write-Host "[4/7] Agregando archivos..." -ForegroundColor Yellow
    git add -A
    
    Write-Host ""
    Write-Host "[5/7] Creando commit..." -ForegroundColor Yellow
    
    if ($mensaje -eq "") {
        $mensaje = Read-Host "Describe los cambios realizados (Enter para usar mensaje default)"
        if ($mensaje -eq "") {
            $mensaje = "Actualizacion del servidor beta - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        }
    }
    
    git commit -m "$mensaje"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "No hay cambios para hacer commit." -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "[6/7] Subiendo a repositorio principal (server)..." -ForegroundColor Yellow
    git push origin main
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: No se pudo subir al repositorio principal." -ForegroundColor Red
        Write-Host "Verifica tu conexión a internet y credenciales de GitHub." -ForegroundColor Red
    } else {
        Write-Host "✓ Subido a 'server' exitosamente!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "[7/7] Subiendo a repositorio beta (Server0.1)..." -ForegroundColor Yellow
    
    # Verificar si el remoto beta existe
    $remoteCheck = git remote 2>&1
    $remotoBeta = $remoteCheck | Select-String -Pattern "beta"
    
    if ($null -eq $remotoBeta) {
        Write-Host "Configurando remoto 'beta'..." -ForegroundColor Cyan
        git remote add beta https://github.com/matiasm200601-spec/Server0.1.git
    }
    
    # Subir a beta
    git push -u beta main --force
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: No se pudo subir al repositorio beta." -ForegroundColor Red
        Write-Host "Verifica que el repositorio Server0.1 exista en GitHub." -ForegroundColor Red
    } else {
        Write-Host "✓ Subido a 'Server0.1' exitosamente!" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "   PROCESO COMPLETADO!" -ForegroundColor Green
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
