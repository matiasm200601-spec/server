# =============================================
# Guardar cambios del servidor en GitHub
# =============================================
$serverPath = "C:\Users\PC\Desktop\PokeRetro Server"
$repoUrl    = "https://github.com/matiasm200601-spec/server"

Set-Location $serverPath

# Verificar si hay cambios
$status = git status --porcelain
if (-not $status) {
    Write-Host "No hay cambios nuevos para guardar." -ForegroundColor Yellow
    Start-Sleep -Seconds 2
    exit
}

# Mostrar archivos modificados
Write-Host ""
Write-Host "Archivos modificados:" -ForegroundColor Cyan
git status --short

# Pedir mensaje del commit
Write-Host ""
$msg = Read-Host "Descripcion de los cambios (Enter para usar 'update: cambios en servidor')"
if (-not $msg) { $msg = "update: cambios en servidor" }

# Subir a GitHub
git add -A
git commit -m $msg
git push origin main

Write-Host ""
Write-Host "Cambios guardados en GitHub correctamente!" -ForegroundColor Green
Start-Sleep -Seconds 3
