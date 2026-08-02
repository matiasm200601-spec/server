# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['server_updater.py'],
    pathex=[],
    binaries=[],
    datas=[('fondolauncher.jpg', '.'), ('C:\\Users\\PC\\Desktop\\PokeRetro Launcher\\Dx9\\Pokemon Solid.ttf', '.')],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='PokeRetro Server Updater',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=['C:\\Users\\PC\\Desktop\\PokeRetro Launcher\\Dx9\\perfil_icon.ico'],
)
