"""Captura a janela do Ninja Revolution em PNG para validação visual local."""
import ctypes
import ctypes.wintypes as wintypes
import sys
from pathlib import Path

user32 = ctypes.windll.user32
gdi32 = ctypes.windll.gdi32
user32.SetProcessDPIAware()

TITULO = 'Ninja Revolution - M1 resource probe'
saida = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(r'N:\build\probe-writable\tela.png')

hwnd = user32.FindWindowW(None, TITULO)
if not hwnd:
    todos = []
    @ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
    def _cb(h, l):
        n = user32.GetWindowTextLengthW(h)
        if n:
            b = ctypes.create_unicode_buffer(n + 1)
            user32.GetWindowTextW(h, b, n + 1)
            todos.append(b.value)
        return True
    user32.EnumWindows(_cb, 0)
    raise SystemExit('Janela nao encontrada. Titulos: ' + repr(todos))

if user32.IsIconic(hwnd):
    user32.ShowWindow(hwnd, 9)
    user32.SetForegroundWindow(hwnd)

rect = wintypes.RECT()
user32.GetClientRect(hwnd, ctypes.byref(rect))
largura, altura = rect.right - rect.left, rect.bottom - rect.top
print('cliente', largura, 'x', altura)

hdc = user32.GetDC(hwnd)
mem = gdi32.CreateCompatibleDC(hdc)
bmp = gdi32.CreateCompatibleBitmap(hdc, largura, altura)
gdi32.SelectObject(mem, bmp)
gdi32.BitBlt(mem, 0, 0, largura, altura, hdc, 0, 0, 0x00CC0020)


class BITMAPINFOHEADER(ctypes.Structure):
    _fields_ = [('biSize', wintypes.DWORD), ('biWidth', wintypes.LONG),
                ('biHeight', wintypes.LONG), ('biPlanes', wintypes.WORD),
                ('biBitCount', wintypes.WORD), ('biCompression', wintypes.DWORD),
                ('biSizeImage', wintypes.DWORD), ('biXPelsPerMeter', wintypes.LONG),
                ('biYPelsPerMeter', wintypes.LONG), ('biClrUsed', wintypes.DWORD),
                ('biClrImportant', wintypes.DWORD)]


bi = BITMAPINFOHEADER()
bi.biSize = ctypes.sizeof(BITMAPINFOHEADER)
bi.biWidth = largura
bi.biHeight = -altura
bi.biPlanes = 1
bi.biBitCount = 32
bi.biCompression = 0
tamanho = largura * altura * 4
buf = ctypes.create_string_buffer(tamanho)
gdi32.GetDIBits(mem, bmp, 0, altura, buf, ctypes.byref(bi), 0)

try:
    from PIL import Image
except ImportError:
    raise SystemExit('Pillow ausente')

img = Image.frombuffer('RGBA', (largura, altura), buf, 'raw', 'BGRA', 0, 1)
img = img.convert('RGB')
saida.parent.mkdir(parents=True, exist_ok=True)
img.save(saida)
gdi32.DeleteObject(bmp)
gdi32.DeleteDC(mem)
user32.ReleaseDC(hwnd, hdc)
print('salvo', saida)
