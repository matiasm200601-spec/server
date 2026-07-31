"""
Ejecuta este script en tu PC para generar el manifest.json del servidor.
Luego sube todo con GUARDAR CAMBIOS.bat
"""
import os, hashlib, json, re

# Carpetas a EXCLUIR del manifest
EXCLUIR_DIRS  = {".git", "build_updater", "Backup", "data\\logs", "data\\world\\backup"}
EXCLUIR_FILES = {
    "generar_manifest.py", "server_updater.py", "manifest.json",
    "GUARDAR CAMBIOS.bat", "guardar_cambios.ps1", "ACTUALIZAR SERVIDOR.bat",
    ".launcher_cache.json", ".server_update_cache.json",
    "forgottenserver.s3db",
    "forgottenserver.before-account-reset-20260730.s3db",
    "tfs.exe", "lua5.1.dll", "libmysql.dll", "mysql.dll",
    "libxml2.dll", "libxml2-2.dll", "iconv.dll", "libiconv-2.dll",
    "sqlite3.dll", "zlib1.dll",
    "PO Dash World [Advanced] - GUI.exe",
    "Iniciar.exe",
    "sqlitestudio-2.1.4.exe",
    "PokeRetro Server Updater.exe",
    "README.md",
    "fondolauncher.jpg",
}
EXCLUIR_EXT  = {".s3db", ".db", ".log", ".ogg", ".exe", ".dll"}

# Excluir archivos con caracteres problemáticos para URLs
# (espacios, paréntesis, acentos, etc en rutas del servidor)
EXCLUIR_PATRONES = [
    r"data[/\\]world[/\\]exchange-",       # archivos temporales de exchange
    r"data[/\\]world[/\\].*-\d{4}-\d{2}",  # backups con fecha
    r"Pokemon Statistics",                   # carpeta con espacios problemáticos
    r"Pokémon",                              # caracteres especiales
]

def tiene_patron_problematico(rel_path):
    for patron in EXCLUIR_PATRONES:
        if re.search(patron, rel_path):
            return True
    return False

def md5(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

server_dir = os.path.dirname(os.path.abspath(__file__))
files = {}
excluidos = []

for root, dirs, filenames in os.walk(server_dir):
    dirs[:] = [d for d in dirs
               if d not in EXCLUIR_DIRS and not d.startswith(".")]
    for fname in filenames:
        if fname in EXCLUIR_FILES:
            continue
        _, ext = os.path.splitext(fname)
        if ext.lower() in EXCLUIR_EXT:
            continue
        full = os.path.join(root, fname)
        rel  = os.path.relpath(full, server_dir).replace("\\", "/")
        if tiene_patron_problematico(rel):
            excluidos.append(rel)
            continue
        files[rel] = md5(full)
        print(f"  + {rel}")

if excluidos:
    print(f"\n  (excluidos {len(excluidos)} archivos con rutas problemáticas)")

manifest = {"files": files}
out = os.path.join(server_dir, "manifest.json")
with open(out, "w") as f:
    json.dump(manifest, f, indent=2)

print(f"\n✓ manifest.json generado con {len(files)} archivos.")
print("Ahora ejecuta GUARDAR CAMBIOS.bat para subir a GitHub.")
