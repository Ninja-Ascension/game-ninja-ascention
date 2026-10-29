"""Controle simples da janela do Ninja Revolution: clique e tecla por posicao."""
import ctypes
import ctypes.wintypes as wintypes
import sys
import time

user32 = ctypes.windll.user32
user32.SetProcessDPIAware()


class RECT(ctypes.Structure):
    _fields_ = [('L', wintypes.LONG), ('T', wintypes.LONG), ('R', wintypes.LONG), ('B', wintypes.LONG)]


class POINT(ctypes.Structure):
    _fields_ = [('X', wintypes.LONG), ('Y', wintypes.LONG)]


def janela():
    h = user32.FindWindowW(None, 'Ninja Revolution - M1 resource probe')
    if not h:
        raise SystemExit('janela nao encontrada')
    return h


def foco(h):
    if user32.IsIconic(h):
        user32.ShowWindow(h, 9)
    user32.SetForegroundWindow(h)
    time.sleep(0.35)


def clicar(h, cx, cy, espera=1.2):
    foco(h)
    p = POINT(cx, cy)
    user32.ClientToScreen(h, ctypes.byref(p))
    user32.SetCursorPos(p.X, p.Y)
    time.sleep(0.12)
    user32.mouse_event(0x0002, 0, 0, 0, 0)
    time.sleep(0.07)
    user32.mouse_event(0x0004, 0, 0, 0, 0)
    time.sleep(espera)


def tecla(h, nome, espera=0.6):
    foco(h)
    vk = {'enter': 0x0D, 'space': 0x20, 'esc': 0x1B}.get(nome.lower())
    if vk is None:
        vk = ord(nome.upper())
    user32.keybd_event(vk, 0, 0, 0)
    time.sleep(0.05)
    user32.keybd_event(vk, 0, 2, 0)
    time.sleep(espera)


if __name__ == '__main__':
    acao = sys.argv[1] if len(sys.argv) > 1 else 'info'
    h = janela()
    if acao == 'info':
        r = RECT()
        user32.GetClientRect(h, ctypes.byref(r))
        p = POINT(0, 0)
        user32.ClientToScreen(h, ctypes.byref(p))
        print('hwnd', h, 'cliente', r.R - r.L, 'x', r.B - r.T, 'tela', p.X, p.Y)
    elif acao == 'click':
        clicar(h, int(sys.argv[2]), int(sys.argv[3]), float(sys.argv[4]) if len(sys.argv) > 4 else 1.2)
        print('clique', sys.argv[2], sys.argv[3])
    elif acao == 'key':
        tecla(h, sys.argv[2])
        print('tecla', sys.argv[2])
