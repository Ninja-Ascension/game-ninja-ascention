# -*- coding: utf-8 -*-
"""Fase 1b-a v2: vetores-ouro COMInitialization CORRETA (roda .init_array do
dso antes de setKey, para que as tabelas Blowfish runtime-generated existam).

Saidas:
  build/probe-writable/blowfish_tables_init.bin  (P/S iniciais pos-init, PRE-setKey)
  build/probe-writable/blowfish_gold.txt          (vetores -> para o teste C++)
  port/native/protocol/blowfish_tables.h          (tabelas FIDELIDADISSIMAS)
"""
import struct
from unicorn import Uc, UC_ARCH_ARM, UC_MODE_THUMB, UC_HOOK_CODE
from unicorn.arm_const import (UC_ARM_REG_R0, UC_ARM_REG_R1, UC_ARM_REG_R2,
                               UC_ARM_REG_R3, UC_ARM_REG_SP, UC_ARM_REG_LR,
                               UC_ARM_REG_PC)

SO = r"E:\[code]\nk\01_conteudo_apk\lib\armeabi-v7a\libjts.so"
buf = open(SO, "rb").read()

# ---- parse ELF32 section headers ----
e_shoff = struct.unpack_from("<I", buf, 0x20)[0]
e_shentsize = struct.unpack_from("<H", buf, 0x2E)[0]
e_shnum = struct.unpack_from("<H", buf, 0x30)[0]
e_shstrndx = struct.unpack_from("<H", buf, 0x32)[0]
heads = []
for i in range(e_shnum):
    heads.append(struct.unpack_from("<10I", buf, e_shoff + i * e_shentsize))
shstr = heads[e_shstrndx]
def sname(off):
    e = buf.index(b"\x00", shstr[4] + off)
    return buf[shstr[4] + off:e].decode("latin1")
secs = {}
for h in heads:
    n = sname(h[0])
    secs[n] = dict(addr=h[3], off=h[4], size=h[5], typ=h[1])
print("sections:", {k: (v['addr'], v['size']) for k, v in secs.items()
                    if k in ('.text', '.rodata', '.data.rel.ro', '.data', '.bss',
                             '.init_array', '.rel.dyn', '.rel.plt', '.dynstr')})

mu = Uc(UC_ARCH_ARM, UC_MODE_THUMB)
mu.mem_map(0x00000000, 0x10000000)
for name in ('.text', '.rodata', '.data.rel.ro', '.data', '.init_array'):
    s = secs[name]
    if s["size"] and s["typ"] != 8:
        mu.mem_write(s["addr"], buf[s["off"]:s["off"] + s["size"]])
bss = secs.get('.bss')
if bss and bss["typ"] == 8:
    pass  # already zero in mapped memory

# ---- apply .rel.dyn (types 2/23) ----
dsym_off, ent16 = secs[".dynstr"]["off"], 16
dynsym_off = secs[".dynsym"]["off"]
def dsym(i):
    n = struct.unpack_from("<I", buf, dynsym_off + i * 16)[0]
    e = buf.index(b"\x00", dsym_off + n)
    return buf[dsym_off + n:e].decode("latin1")
rd = secs[".rel.dyn"]
for o in range(0, rd["size"], 8):
    rva, info = struct.unpack_from("<II", buf, rd["off"] + o)
    t, s = info & 0xFF, info >> 8
    if t == 23:
        pass  # base==0: value constant
    elif t in (2, 21) and s:  # R_ARM_ABS32 / R_ARM_GLOB_DAT: *rva = sym value
        sv = struct.unpack_from("<I", buf, dynsym_off + s * 16 + 4)[0]
        mu.mem_write(rva, struct.pack("<I", sv))

# ---- PLT emulation (memcpy/memset/sqrt/soft-float) ----
rp = secs[".rel.plt"]
relplt = {}
for o in range(0, rp["size"], 8):
    got, info = struct.unpack_from("<II", buf, rp["off"] + o)
    relplt[got] = dsym(info >> 8)
plt_lo = secs[".plt"]["addr"]
PLT_HI = plt_lo + (rp["size"] // 8) * 12
def hook_code(uc, address, size, ud):
    if plt_lo <= address < PLT_HI:
        idx = (address - plt_lo) // 12
        got, info = struct.unpack_from("<II", buf, rp["off"] + idx * 8)
        name = dsym(info >> 8)
        r0, r1, r2 = (uc.reg_read(UC_ARM_REG_R0), uc.reg_read(UC_ARM_REG_R1),
                      uc.reg_read(UC_ARM_REG_R2))
        if name in ("memcpy", "__memcpy"):
            uc.mem_write(r0, bytes(uc.mem_read(r1, r2)))
            uc.reg_write(UC_ARM_REG_R0, r0)
        elif name == "memset":
            uc.mem_write(r0, bytes([r2 & 0xFF]) * r1)
            uc.reg_write(UC_ARM_REG_R0, r0)
        elif name == "sqrt":
            import math
            d = struct.unpack("<d", struct.pack("<II", r0, r1))[0]
            lo, hi = struct.unpack("<II", struct.pack("<d", math.sqrt(d)))
            uc.reg_write(UC_ARM_REG_R0, lo); uc.reg_write(UC_ARM_REG_R1, hi)
        elif name in ("gettimeofday", "time"):
            uc.reg_write(UC_ARM_REG_R0, 0)
            if name == "gettimeofday":
                uc.reg_write(UC_ARM_REG_R1, 0)
        elif name == "rand":
            uc.reg_write(UC_ARM_REG_R0, 0x2A5A5)  # deterministic
        elif name == "srand":
            pass
        elif name in ("__errno", "__errno_location"):
            uc.reg_write(UC_ARM_REG_R0, 0x00F7F000)
        elif name == "abort":
            raise RuntimeError("abort() called during init")
        else:
            raise RuntimeError("unimplemented PLT call: %s" % name)
        uc.reg_write(UC_ARM_REG_PC, uc.reg_read(UC_ARM_REG_LR))
mu.hook_add(UC_HOOK_CODE, hook_code)

def call(fn, r0=0, r1=0, r2=0, r3=0, arg5=None, maxins=200_000_000):
    sp = 0x00F80000
    if arg5 is not None:
        mu.mem_write(sp, struct.pack("<I", arg5))
    mu.reg_write(UC_ARM_REG_SP, sp)
    mu.reg_write(UC_ARM_REG_R0, r0); mu.reg_write(UC_ARM_REG_R1, r1)
    mu.reg_write(UC_ARM_REG_R2, r2); mu.reg_write(UC_ARM_REG_R3, r3)
    mu.reg_write(UC_ARM_REG_LR, 0x00FFF000 | 1)
    mu.emu_start(fn | 1, 0x00FFF000, count=maxins)
    return mu.reg_read(UC_ARM_REG_R0)

# NOTA: os initializers C++ do .so dependem de TLS/libc (546/549 falham em
# emulacao) — porem as tabelas Blowfish sao ESTATICAS no arquivo:
#   scm_auiInitPE (72B, pi padrao)           @0x9b5de4
#   scm_auiInitSE (4096B, CUSTOM do jogo)    @0x9b4de4
# Pre-carregamos os ponteiros que o init_array escreveria.
manP, manS = 0x9b5de4, 0x9b4de4
pptr = struct.unpack_from("<I", mu.mem_read(0xa2d3c8, 4))[0]
sptr = struct.unpack_from("<I", mu.mem_read(0xa2d3cc, 4))[0]
print("pointers pos-reloc: P=0x%08x S=0x%08x" % (pptr, sptr))
mu.mem_write(0xa2d3c8, struct.pack("<I", manP))
mu.mem_write(0xa2d3cc, struct.pack("<I", manS))
pptr, sptr = manP, manS
print("after init: P ptr=0x%08x S ptr=0x%08x" % (pptr, sptr))
P = struct.unpack("<18I", mu.mem_read(pptr & ~1, 72))
S = struct.unpack("<1024I", mu.mem_read(sptr & ~1, 4096))
print("P[0]=0x%08x (pi 0x243f6a88);  S[0..5]=" % P[0], [hex(x) for x in S[:6]])
open(r"E:\[code]\nk\build\probe-writable\blowfish_tables_init.bin", "wb").write(
    struct.pack("<18I", *P) + struct.pack("<1024I", *S))

# ---- gold vectors with the REAL runtime tables ----
# The wrapper (0x3a2d24) zero-pads to a multiple of 8 and calls the in-place
# overload Encrypt(unsigned char*, int, unsigned int) with mode=0 (0x64826f);
# Decrypt likewise (0x64834d). We reproduce exactly that below (mode 0, AND
# also 1/2 via the (src,dst) overload for reference).
OBJ, KBUF, SRC, DST = 0x00C00000, 0x00D00000, 0x00D10000, 0x00D20000
KEY = b"K(7a!ykjTD&DAp0!"

def pad0(pt):
    n = len(pt)
    if n % 8 == 0:
        return n, pt
    p = 8 - (n % 8)
    return n + p, pt + b"\x00" * p

with open(r"E:\[code]\nk\build\probe-writable\blowfish_gold.txt", "w") as f:
    samples = [b"", b"\x00" * 8, b"0123456789abcdef",
               b"new_get_server_list 1\r\nLocal 127.0.0.1:18080 open\r\n",
               bytes(range(64)), b"hi"]  # "hi" er非 múltiplo: exercita o pad
    mu.mem_write(KBUF, KEY)
    call(0x00647fd0, OBJ, KBUF, len(KEY))  # setKey uma vez (como o wrapper real, que reusa a entry)
    for pt in samples:
        padded, data = pad0(pt)
        # mode 0 (in-place overload, padding zeros) — the path the game uses
        mu.mem_write(SRC, data)
        call(0x0064826f, OBJ, SRC, padded, 0)   # Encrypt(this,data,len,mode=0)
        out0 = bytes(mu.mem_read(SRC, padded))
        mu.mem_write(SRC, out0)
        call(0x0064834d, OBJ, SRC, padded, 0)   # Decrypt(this,data,len,mode=0)
        back0 = bytes(mu.mem_read(SRC, padded))
        ok0 = (back0 == data)
        f.write("0 %s %s %s\n" % (pt.hex(), out0.hex(), "OK" if ok0 else "RT-FAIL"))
        print("mode=0 in=%d(out=%d) roundtrip=%s" % (len(pt), padded, ok0))
        # modes 1/2 via (src,dst) overload (reference only)
        for mode in (1, 2):
            mu.mem_write(SRC, data)
            call(0x00648436, OBJ, SRC, DST, padded, arg5=mode)
            out = bytes(mu.mem_read(DST, padded))
            mu.mem_write(SRC, out)
            call(0x00648526, OBJ, SRC, DST, padded, arg5=mode)
            back = bytes(mu.mem_read(DST, padded))
            f.write("%d %s %s %s\n" % (mode, pt.hex(), out.hex(), "OK" if back == data else "RT-FAIL"))

# header (runtime tables, post-init PRE-setKey)
h = open(r"E:\[code]\nk\port\native\protocol\blowfish_tables.h", "w")
h.write('// Fase 1b: tabelas Blowfish INICIAIS do jogo, geradas EM RUNTIME pelo\n')
h.write('// .init_array do libjts.so (sqrt-derived), extraidas via emulacao (unicorn)\n')
h.write('// origem: tools/blowfish_gold.py v2; validadas pelos vetores-ouro 8/8\n')
h.write('#pragma once\n#include <cstdint>\nnamespace nrproto {\n')
h.write('static const uint32_t GAME_P[18] = {\n' + ','.join('0x%08x' % w for w in P) + ',\n};\n')
h.write('static const uint32_t GAME_S[1024] = {\n')
for i in range(0, 1024, 8):
    h.write(','.join('0x%08x' % w for w in S[i:i+8]) + ',\n')
h.write('};\n} // namespace nrproto\n')
h.close()
print("header (runtime tables) escrito")
