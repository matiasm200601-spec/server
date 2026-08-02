import os
import sys
import json
import hashlib
import threading
import subprocess
import urllib.request
import urllib.parse
import tkinter as tk
from PIL import Image, ImageTk, ImageDraw, ImageFont

GITHUB_USER   = "matiasm200601-spec"
GITHUB_REPO   = "server"
GITHUB_BRANCH = "main"
RAW_BASE      = f"https://raw.githubusercontent.com/{GITHUB_USER}/{GITHUB_REPO}/{GITHUB_BRANCH}"
MANIFEST_URL  = f"{RAW_BASE}/manifest.json"
SERVER_EXE    = "iniciar.exe"

WINDOW_W = 640
WINDOW_H = 480
COLOR_BG         = "#0d0d1a"
COLOR_BAR_FILL   = "#FFD700"
COLOR_BAR_EMPTY  = "#3a3000"
COLOR_BAR_BORDER = "#000000"
BAR_X      = 30
BAR_W      = WINDOW_W - 60
BAR_H      = 18
BAR_RADIUS = 9
BAR_BORDER = 2

try:
    import ctypes
    GWL_EXSTYLE      = -20
    WS_EX_APPWINDOW  = 0x00040000
    WS_EX_TOOLWINDOW = 0x00000080
    def set_taskbar_icon(win):
        hwnd  = ctypes.windll.user32.GetParent(win.winfo_id())
        style = ctypes.windll.user32.GetWindowLongW(hwnd, GWL_EXSTYLE)
        style = (style & ~WS_EX_TOOLWINDOW) | WS_EX_APPWINDOW
        ctypes.windll.user32.SetWindowLongW(hwnd, GWL_EXSTYLE, style)
        win.wm_withdraw()
        win.after(10, win.wm_deiconify)
except Exception:
    def set_taskbar_icon(win): pass

def get_server_dir():
    if getattr(sys, 'frozen', False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))

def get_asset(filename):
    if getattr(sys, 'frozen', False):
        ext = os.path.join(os.path.dirname(sys.executable), filename)
        if os.path.exists(ext): return ext
        bundle = os.path.join(sys._MEIPASS, filename)
        if os.path.exists(bundle): return bundle
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), filename)

def md5_file(path):
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

def get_cache_path():
    return os.path.join(get_server_dir(), ".server_update_cache.json")

def load_cache():
    try:
        with open(get_cache_path(), "r") as f:
            return json.load(f)
    except Exception:
        return {}

def save_cache(cache):
    try:
        with open(get_cache_path(), "w") as f:
            json.dump(cache, f)
    except Exception:
        pass

def needs_update(local_path, remote_md5, cache):
    if not os.path.exists(local_path):
        return True
    stat   = os.stat(local_path)
    cached = cache.get(local_path)
    if cached and cached.get("mtime") == stat.st_mtime and cached.get("size") == stat.st_size:
        return cached.get("md5") != remote_md5
    real_md5 = md5_file(local_path)
    cache[local_path] = {"md5": real_md5, "mtime": stat.st_mtime, "size": stat.st_size}
    return real_md5 != remote_md5

def download_file(url, dest_path):
    # Encodear espacios y caracteres especiales en la parte del path
    parts = url.split("/")
    encoded = parts[:7] + [urllib.parse.quote(p, safe="") for p in parts[7:]]
    url = "/".join(encoded)
    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    urllib.request.urlretrieve(url, dest_path)

def make_progress_bar(percent, w, h, radius, border, fill, empty, border_col):
    scale = 2
    sw, sh, sr, sb = w*scale, h*scale, radius*scale, border*scale
    img  = Image.new("RGBA", (sw, sh), (0,0,0,0))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle([0, 0, sw-1, sh-1], radius=sr,
                            fill=empty, outline=border_col, width=sb)
    fw = int((sw - sb*2) * percent / 100)
    if fw > 0:
        fw = max(fw, sr*2); fw = min(fw, sw - sb*2)
        draw.rounded_rectangle([sb, sb, sb+fw, sh-sb-1],
                                radius=max(sr-sb, 2), fill=fill)
    img = img.resize((w, h), Image.LANCZOS)
    return ImageTk.PhotoImage(img)


class ServerUpdater:
    def __init__(self, root):
        self.root          = root
        self._server_proc  = None
        self._btn_state    = "disabled"

        self.win = tk.Toplevel(root)
        self.win.title("PokeRetro Server")
        self.win.resizable(False, False)
        self.win.overrideredirect(True)

        icon_path = get_asset("perfil_icon.ico")
        if os.path.exists(icon_path):
            try: self.win.iconbitmap(icon_path)
            except Exception: pass

        sw = self.win.winfo_screenwidth()
        sh = self.win.winfo_screenheight()
        x  = (sw - WINDOW_W) // 2
        y  = (sh - WINDOW_H) // 2
        self.win.geometry(f"{WINDOW_W}x{WINDOW_H}+{x}+{y}")
        self.win.update_idletasks()
        set_taskbar_icon(self.win)

        self._drag_x = self._drag_y = 0

        self.canvas = tk.Canvas(self.win, width=WINDOW_W, height=WINDOW_H,
                                bg=COLOR_BG, highlightthickness=0, bd=0)
        self.canvas.place(x=0, y=0)

        # Fondo
        bg_path = get_asset("fondolauncher.png")
        if not os.path.exists(bg_path):
            bg_path = get_asset("fondolauncher.jpg")
        if os.path.exists(bg_path):
            try:
                img = Image.open(bg_path).resize((WINDOW_W, WINDOW_H), Image.LANCZOS)
                self._bg = ImageTk.PhotoImage(img)
                self.canvas.create_image(0, 0, anchor="nw", image=self._bg)
            except Exception:
                pass

        # Overlay inferior
        self.canvas.create_rectangle(0, WINDOW_H-250, WINDOW_W, WINDOW_H,
                                     fill="#000000", stipple="gray50", outline="")

        # Botones cerrar / minimizar
        self.canvas.create_oval(WINDOW_W-36, 8, WINDOW_W-12, 32,
                                fill="#e94560", outline="", tags="btn_close")
        self.canvas.create_text(WINDOW_W-24, 20, text="✕",
                                font=("Arial", 9, "bold"), fill="white", tags="btn_close")
        self.canvas.create_oval(WINDOW_W-68, 8, WINDOW_W-44, 32,
                                fill="#555555", outline="", tags="btn_min")
        self.canvas.create_text(WINDOW_W-56, 20, text="—",
                                font=("Arial", 9, "bold"), fill="white", tags="btn_min")

        self.canvas.tag_bind("btn_close", "<ButtonRelease-1>", lambda e: self._on_close())
        self.canvas.tag_bind("btn_min",   "<ButtonRelease-1>", lambda e: self.win.withdraw())
        for tag, on, off in [("btn_close","#c73652","#e94560"),
                              ("btn_min",  "#333333","#555555")]:
            self.canvas.tag_bind(tag, "<Enter>",
                lambda e, t=tag, c=on:  [self.canvas.itemconfig(i, fill=c)
                    for i in self.canvas.find_withtag(t) if self.canvas.type(i)=="oval"])
            self.canvas.tag_bind(tag, "<Leave>",
                lambda e, t=tag, c=off: [self.canvas.itemconfig(i, fill=c)
                    for i in self.canvas.find_withtag(t) if self.canvas.type(i)=="oval"])

        self.canvas.bind("<ButtonPress-1>", self._drag_start)
        self.canvas.bind("<B1-Motion>",      self._drag_motion)

        # Título
        font_path = get_asset("Pokemon Solid.ttf")
        try:
            font_title = ImageFont.truetype(font_path, 34)
        except Exception:
            font_title = ImageFont.load_default()

        title_img = Image.new("RGBA", (WINDOW_W, 58), (0,0,0,0))
        d = ImageDraw.Draw(title_img)
        bbox = d.textbbox((0,0), "PokeRetro Server", font=font_title)
        tw, th = bbox[2]-bbox[0], bbox[3]-bbox[1]
        tx, ty = (WINDOW_W-tw)//2, (58-th)//2
        bp = max(1, int(th*0.03))
        for dx in range(-bp, bp+1):
            for dy in range(-bp, bp+1):
                if dx==0 and dy==0: continue
                d.text((tx+dx, ty+dy), "PokeRetro Server", font=font_title, fill="#000000")
        d.text((tx, ty), "PokeRetro Server", font=font_title, fill="#FFD700")
        self._title_img = ImageTk.PhotoImage(title_img)
        self.canvas.create_image(WINDOW_W//2, 29, anchor="center", image=self._title_img)

        # Subtítulo
        self.canvas.create_text(WINDOW_W//2+1, 62, text="Actualizador",
                                anchor="center", font=("Arial", 10, "bold"), fill="#000000")
        self.canvas.create_text(WINDOW_W//2, 61, text="Actualizador",
                                anchor="center", font=("Arial", 10, "bold"), fill="#FFD700")

        # Log de estado
        self._log_id = self.canvas.create_text(
            BAR_X, WINDOW_H-148, text="Iniciando...",
            anchor="nw", font=("Arial", 8), fill="#aaaaaa", width=BAR_W)

        # Barra de progreso
        bar_y = WINDOW_H - 88
        self._bar_img = make_progress_bar(0, BAR_W, BAR_H, BAR_RADIUS, BAR_BORDER,
                                          COLOR_BAR_FILL, COLOR_BAR_EMPTY, COLOR_BAR_BORDER)
        self._bar_id  = self.canvas.create_image(BAR_X, bar_y, anchor="nw",
                                                  image=self._bar_img)

        for dxy in [(-1,0),(1,0),(0,-1),(0,1)]:
            self.canvas.create_text(BAR_X+dxy[0], bar_y-15+dxy[1], text="",
                                    anchor="w", font=("Arial", 8, "bold"),
                                    fill="#000000", tags="txt_l_sh")
            self.canvas.create_text(BAR_X+BAR_W+dxy[0], bar_y-15+dxy[1], text="",
                                    anchor="e", font=("Arial", 8, "bold"),
                                    fill="#000000", tags="txt_r_sh")
        self._txt_l = self.canvas.create_text(BAR_X, bar_y-15, text="",
                                              anchor="w", font=("Arial", 8, "bold"),
                                              fill="#FFD700")
        self._txt_r = self.canvas.create_text(BAR_X+BAR_W, bar_y-15, text="",
                                              anchor="e", font=("Arial", 8, "bold"),
                                              fill="#FFD700")

        # Botones en orden vertical
        btn_w, btn_h, btn_r = 240, 45, 22
        btn_x = WINDOW_W//2 - btn_w//2
        btn_spacing = 55
        btn_start_y = WINDOW_H - 200
        
        self._btn_update  = self._make_btn("ACTUALIZAR E INICIAR", btn_w, btn_h, btn_r, "#e94560", "#ffffff", font_path)
        self._btn_start   = self._make_btn("INICIAR SERVIDOR",     btn_w, btn_h, btn_r, "#1a6e1a", "#ffffff", font_path)
        self._btn_stop    = self._make_btn("DETENER SERVIDOR",     btn_w, btn_h, btn_r, "#8b0000", "#ffffff", font_path)
        self._btn_reload  = self._make_btn("RELOAD",               btn_w, btn_h, btn_r, "#ff8c00", "#ffffff", font_path)
        self._btn_off     = self._make_btn("VERIFICANDO...",       btn_w, btn_h, btn_r, "#555555", "#888888", font_path)

        # Botón principal (actualizar/iniciar/detener/reload)
        self._btn_lbl = tk.Label(self.win, image=self._btn_off,
                                  bg=COLOR_BG, cursor="arrow", bd=0)
        self._btn_lbl.place(x=btn_x, y=btn_start_y)
        self._btn_lbl.bind("<Enter>",           self._btn_enter)
        self._btn_lbl.bind("<Leave>",           self._btn_leave)
        self._btn_lbl.bind("<ButtonRelease-1>",  self._btn_click)

        # Botón RELOAD (segundo botón)
        self._btn_reload_img = self._make_btn("RELOAD", btn_w, btn_h, btn_r, "#ff8c00", "#ffffff", font_path)
        self._reload_lbl = tk.Label(self.win, image=self._btn_reload_img,
                                     bg=COLOR_BG, cursor="hand2", bd=0)
        self._reload_lbl.place(x=btn_x, y=btn_start_y + btn_spacing)
        self._reload_lbl.bind("<ButtonRelease-1>", self._reload_click)
        self._reload_lbl.place_forget()  # Oculto por defecto

        # Botón SALIR (tercer botón)
        self._btn_exit = self._make_btn("SALIR", btn_w, btn_h, btn_r, "#cc0000", "#ffffff", font_path)
        self._exit_lbl = tk.Label(self.win, image=self._btn_exit,
                                   bg=COLOR_BG, cursor="hand2", bd=0)
        self._exit_lbl.place(x=btn_x, y=btn_start_y + btn_spacing*2)
        self._exit_lbl.bind("<ButtonRelease-1>", lambda e: self._on_close())

        self.win.protocol("WM_DELETE_WINDOW", self._on_close)
        self.root.protocol("WM_DELETE_WINDOW", self._on_close)

        threading.Thread(target=self._check_updates, daemon=True).start()

    # ---- helpers de botón ----
    def _make_btn(self, text, w, h, r, bg, fg, font_path):
        scale = 2
        sw, sh, sr = w*scale, h*scale, r*scale
        img  = Image.new("RGBA", (sw, sh), (0,0,0,0))
        draw = ImageDraw.Draw(img)
        # Borde redondeado sin cuadrados
        draw.rounded_rectangle([0,0,sw-1,sh-1], radius=sr, fill=bg, outline=None)
        draw.rounded_rectangle([0,0,sw-1,sh-1], radius=sr, fill=None, outline="#000000", width=2*scale)
        try:
            font = ImageFont.truetype(font_path, 10*scale)
        except Exception:
            font = ImageFont.load_default()
        bbox = draw.textbbox((0,0), text, font=font)
        tw, th = bbox[2]-bbox[0], bbox[3]-bbox[1]
        tx, ty = (sw-tw)//2, (sh-th)//2
        bp = max(1, int(th*0.03))
        for dx in range(-bp, bp+1):
            for dy in range(-bp, bp+1):
                if dx==0 and dy==0: continue
                draw.text((tx+dx, ty+dy), text, font=font, fill="#000000")
        draw.text((tx, ty), text, font=font, fill=fg)
        img = img.resize((w, h), Image.LANCZOS)
        return ImageTk.PhotoImage(img)

    def _set_btn_state(self, state):
        def _u():
            self._btn_state = state
            imgs = {"update":  self._btn_update,
                    "start":   self._btn_start,
                    "running": self._btn_stop,
                    "reload":  self._btn_reload,
                    "disabled":self._btn_off}
            self._btn_lbl.config(
                image=imgs.get(state, self._btn_off),
                cursor="hand2" if state != "disabled" else "arrow")
            
            # Mostrar/ocultar botón RELOAD según estado
            if state == "reload":
                self._reload_lbl.place(x=WINDOW_W//2 - 120, y=WINDOW_H - 200 + 55)
            else:
                self._reload_lbl.place_forget()
        self.win.after(0, _u)

    def _btn_enter(self, e): pass
    def _btn_leave(self, e): pass

    def _btn_click(self, e):
        if self._btn_state == "update":
            self._set_btn_state("disabled")
            threading.Thread(target=self._apply_and_start, daemon=True).start()
        elif self._btn_state == "start":
            threading.Thread(target=self._start_server, daemon=True).start()
        elif self._btn_state == "running":
            self._stop_server()
        elif self._btn_state == "reload":
            # No hacer nada en el botón principal cuando está en estado reload
            pass
    
    def _reload_click(self, e):
        threading.Thread(target=self._reload_server, daemon=True).start()

    # ---- drag ----
    def _drag_start(self, event):
        if event.x > WINDOW_W-80 and event.y < 40: return
        self._drag_x = event.x; self._drag_y = event.y

    def _drag_motion(self, event):
        if event.x > WINDOW_W-80 and event.y < 40: return
        dx = event.x - self._drag_x; dy = event.y - self._drag_y
        self.win.geometry(f"+{self.win.winfo_x()+dx}+{self.win.winfo_y()+dy}")

    # ---- UI updates ----
    def _set_log(self, text):
        self.win.after(0, lambda: self.canvas.itemconfig(self._log_id, text=text))

    def _set_progress(self, percent, done=None, total=None):
        def _u():
            self._bar_img = make_progress_bar(
                percent, BAR_W, BAR_H, BAR_RADIUS, BAR_BORDER,
                COLOR_BAR_FILL, COLOR_BAR_EMPTY, COLOR_BAR_BORDER)
            self.canvas.itemconfig(self._bar_id, image=self._bar_img)
            if total and total > 0:
                l = f"Descargados: {done}/{total} ({percent:.0f}%)"
                r = f"Faltan: {total-done}"
            elif percent >= 100:
                l, r = "¡Actualizado! (100%)", ""
            else:
                l, r = f"{percent:.0f}%", ""
            for t in self.canvas.find_withtag("txt_l_sh"): self.canvas.itemconfig(t, text=l)
            for t in self.canvas.find_withtag("txt_r_sh"): self.canvas.itemconfig(t, text=r)
            self.canvas.itemconfig(self._txt_l, text=l)
            self.canvas.itemconfig(self._txt_r, text=r)
        self.win.after(0, _u)

    # ---- lógica principal ----
    def _check_updates(self):
        self._set_log("Conectando con GitHub...")
        self._set_progress(5)
        try:
            with urllib.request.urlopen(MANIFEST_URL, timeout=15) as r:
                manifest = json.loads(r.read().decode())
        except Exception as e:
            self._set_log(f"Sin conexión.\nInicia el servidor manualmente.")
            self._set_progress(0)
            self._set_btn_state("start")
            return

        files = manifest.get("files", {})
        if not files:
            self._set_log("Manifest vacío.")
            self._set_btn_state("start")
            return

        # Comparar MD5 de cada archivo local vs remoto
        cache      = load_cache()
        server_dir = get_server_dir()
        to_update  = []
        for rel_path, remote_md5 in files.items():
            local = os.path.join(server_dir, rel_path.replace("/", os.sep))
            if needs_update(local, remote_md5, cache):
                to_update.append(rel_path)
        save_cache(cache)

        total = len(to_update)
        if total == 0:
            self._set_log("✓ Servidor actualizado.\nPresiona INICIAR para arrancar.")
            self._set_progress(100)
            self._set_btn_state("start")
            return

        self._pending  = to_update
        self._manifest = files
        self._set_log(f"Hay {total} archivo(s) con cambios.\n"
                      f"Presiona ACTUALIZAR E INICIAR para aplicarlos.")
        self._set_progress(0)
        self._set_btn_state("update")

    def _apply_and_start(self):
        server_dir = get_server_dir()
        files      = getattr(self, '_manifest', {})
        to_update  = getattr(self, '_pending',  [])
        total      = len(to_update)
        cache      = load_cache()

        for i, rel_path in enumerate(to_update, 1):
            dest = os.path.join(server_dir, rel_path.replace("/", os.sep))
            url  = f"{RAW_BASE}/{rel_path}"
            self._set_log(f"Descargando ({i}/{total}):\n{rel_path}")
            try:
                download_file(url, dest)
                if os.path.exists(dest):
                    stat = os.stat(dest)
                    cache[dest] = {"md5": files[rel_path],
                                   "mtime": stat.st_mtime,
                                   "size":  stat.st_size}
            except Exception as ex:
                self._set_log(f"Error: {rel_path}\n{ex}")
            self._set_progress(int(i/total*90), i, total)

        save_cache(cache)
        self._set_progress(100, total, total)
        self._set_log("✓ Actualización completada.\nIniciando servidor...")
        import time; time.sleep(1)
        self._start_server()

    def _start_server(self):
        server_dir = get_server_dir()
        exe_path   = os.path.join(server_dir, SERVER_EXE)
        if not os.path.exists(exe_path):
            self._set_log(f"No encontrado: {SERVER_EXE}")
            self._set_btn_state("start")
            return
        try:
            self._server_proc = subprocess.Popen([exe_path], cwd=server_dir, 
                                                 stdin=subprocess.PIPE, 
                                                 stdout=subprocess.PIPE, 
                                                 stderr=subprocess.PIPE)
            self._set_log(f"✓ Servidor iniciado (PID {self._server_proc.pid})")
            self._set_btn_state("reload")
            threading.Thread(target=self._wait_server, daemon=True).start()
        except Exception as ex:
            self._set_log(f"Error al iniciar:\n{ex}")
            self._set_btn_state("start")

    def _wait_server(self):
        if self._server_proc:
            self._server_proc.wait()
        self._server_proc = None
        self._set_log("Servidor detenido.")
        self._set_btn_state("start")

    def _stop_server(self):
        if self._server_proc:
            try: self._server_proc.terminate()
            except Exception: pass
        self._set_btn_state("start")

    def _reload_server(self):
        if not self._server_proc:
            self._set_log("Servidor no está corriendo.")
            return
        self._set_log("Enviando comando /reload...")
        try:
            # Envía el comando /reload al proceso del servidor
            # Esto asume que el servidor acepta comandos por stdin
            if self._server_proc.poll() is None:  # Verifica que esté corriendo
                self._server_proc.stdin.write(b"/reload\n")
                self._server_proc.stdin.flush()
                self._set_log("✓ Comando /reload enviado.")
            else:
                self._set_log("Error: Servidor no responde.")
        except Exception as ex:
            self._set_log(f"Error al enviar /reload:\n{ex}")

    def _on_close(self):
        if self._server_proc:
            try: self._server_proc.terminate()
            except Exception: pass
        self.root.destroy()


if __name__ == "__main__":
    root = tk.Tk()
    root.withdraw()
    ServerUpdater(root)
    root.mainloop()
