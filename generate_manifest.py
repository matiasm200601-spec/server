"""
generate_manifest.py  —  PokeRetro Dev
---------------------------------------
Ejecuta este script ANTES de hacer git push.
Genera manifest.json con el MD5 de cada archivo del cliente.

Uso: doble click en este archivo
"""

import os
import json
import hashlib

IGNORE_FILES = {
    "generate_manifest.py",
    "manifest.json",
    "launcher.py",
    "launcher_opengl.py",
    "launcher_dx9.py",
    "otclient.log",
    "pokmaster.log",
    "psfclient.log",
    "crashreport.log",
    "Thumbs.db",
    "OTClient OpenGL.exe",
    "OTClient DX9.exe",
    "PokePere Dx9.exe",
}

IGNORE_EXTENSIONS = {
    ".log", ".tmp", ".bak", ".pyc", ".spec",
}

IGNORE_DIRS = {
    ".git", "__pycache__", "build", "dist",
}

def md5_file(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

def generate(base_dir):
    files = {}
    for root, dirs, filenames in os.walk(base_dir):
        dirs[:] = [d for d in dirs if d not in IGNORE_DIRS]
        for fname in filenames:
            abs_path = os.path.join(root, fname)
            rel_path = os.path.relpath(abs_path, base_dir).replace("\\", "/")
            parts = rel_path.split("/")
            if parts[-1] in IGNORE_FILES:
                continue
            _, ext = os.path.splitext(parts[-1])
            if ext.lower() in IGNORE_EXTENSIONS:
                continue
            if any(p in IGNORE_DIRS for p in parts[:-1]):
                continue
            files[rel_path] = md5_file(abs_path)
            print(f"  + {rel_path}")

    out_path = os.path.join(base_dir, "manifest.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump({"files": files}, f, indent=2, ensure_ascii=False)

    print(f"\n✔  manifest.json generado con {len(files)} archivos.")
    print(f"   Ahora ejecuta: git add . && git commit -m 'update' && git push")

if __name__ == "__main__":
    base = os.path.dirname(os.path.abspath(__file__))
    print(f"Generando manifest desde: {base}\n")
    generate(base)
    input("\nPresiona Enter para cerrar...")
