@echo off
title Actualizando PokeRetro Server...
color 0A

echo ========================================
echo   ACTUALIZACION DE POKERETRO SERVER
echo ========================================
echo.

:: Cerrar el servidor si esta abierto
echo Cerrando el servidor...
taskkill /f /im "PO Dash World*" >nul 2>&1
timeout /t 3 /nobreak >nul

:: Ir a la carpeta del servidor
cd /d "C:\Users\Administrador\Desktop\PokeRetro Server"

:: Verificar si git esta instalado
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git no esta instalado. Instalando...
    winget install --id Git.Git -e --source winget
    echo Reinicia este archivo luego de instalar git.
    pause
    exit
)

:: Descargar cambios de GitHub
echo.
echo Descargando cambios de GitHub...
git fetch origin
git reset --hard origin/main
git pull origin main

echo.
echo ========================================
echo   ACTUALIZACION COMPLETADA!
echo ========================================
echo.

:: Reiniciar el servidor
echo Iniciando el servidor...
start "" "C:\Users\Administrador\Desktop\PokeRetro Server\PO Dash World [Advanced] - GUI.exe"

timeout /t 2 /nobreak >nul
echo Listo!
pause
