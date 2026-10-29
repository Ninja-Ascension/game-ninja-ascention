# -*- coding: utf-8 -*-
"""Fase 0 sonda — disassembly cirurgico do protocolo nativo do libjts.so.

Targets: register_dbytes / register_blowfish (the Lua native binding
registration that defines what cc.DBytes/cc.CBlowFish expose), the DBytes
class methods, jts::Utils::ccDeflateMemory, and CBlowFish entry points.
Addresses come from the non-stripped .dynsym (GO evidence). Functions with
odd addresses are THUMB (Cortex-A9 armeabi-v7a). ARM instructions without
obfuscation; literal pools annotated with symbol names where they match.
"""
import re, struct
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM, CS_MODE_THUMB

SO = r"E:\[code]\nk\01_conteudo_apk\lib\armeabi-v7a\libjts.so"
OUT = r"E:\[code]\nk\build\probe-writable\libjts_disasm.txt"

buf = open(SO, "rb").read()
e_type, e_machine, e_version, e_entry, e_phoff, e_shoff, e_flags, e_ehsize, \
    e_phentsize, e_phnum, e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHIIIIIHHHHHH", buf, 16)
sections = []
for i in range(e_shnum):
    off = e_shoff + i * e_shentsize
    vals = struct.unpack_from("<10I", buf, off)
    sections.append(dict(name=vals[0], type=vals[1], addr=vals[3], offset=vals[4],
                         size=vals[5], entsize=vals[9]))
shstr = sections[e_shstrndx]
def cstr(base, n):
    end = buf.index(b"\x00", base + n)
    return buf[base + n:end].decode("latin1")
for s in sections:
    s["sname"] = cstr(shstr["offset"], s["name"])
text = next(s for s in sections if s["sname"] == ".text")

# dynsym full map
dynsym = next(s for s in sections if s["sname"] == ".dynsym")
dynstr = next(s for s in sections if s["sname"] == ".dynstr")
symmap = {}
targets = []
# Phase-1 targets: the exact lua_CFunction wrappers resolved from
# register_dbytes / register_blowfish (see survey output) — their bodies
# reveal what each native method does to the packet data.
phase1_addrs = {
    0x3aabbd, 0x3a2871, 0x3a4725, 0x3a27b9, 0x3a6e2d,   # DBytes new/getBytes/getSize/copy/release
    0x3aae05, 0x3a2ecd, 0x3a2d25, 0x3a2b95,             # CBlowFish new/setKey/Encrypt/Decrypt
}
n = dynsym["size"] // dynsym["entsize"]
for i in range(n):
    off = dynsym["offset"] + i * dynsym["entsize"]
    st_name, st_value, st_size, st_info, st_other, st_shndx = struct.unpack_from("<IIIBBH", buf, off)
    if st_name == 0 or st_shndx == 0:
        continue
    nm = cstr(dynstr["offset"], st_name)
    symmap[st_value & ~1] = nm
    if ((nm, st_value, st_size) and (
            nm.startswith("_ZN6DBytes") or nm.startswith("_Z15register_dbytes")
            or nm.startswith("_Z17register_blowfish")
            or "ccDeflateMemory" in nm
            or nm.startswith("_ZN9CBlowFish") and ("Encrypt" in nm or "Decrypt" in nm or "setKey" in nm))):
        targets.append((nm, st_value, st_size))
    elif st_value in phase1_addrs:
        targets.append((nm or "wrapper_0x%x" % (st_value & ~1), st_value, st_size))

# The lua_CFunction wrappers are internal (not exported): add them by the
# addresses resolved from the register_* pools so phase 1 can read them.
known_wrappers = [
    ("DBytes_new_wrapper",    0x3aabbd), ("DBytes_getBytes_wrapper", 0x3a2871),
    ("DBytes_getSize_wrapper", 0x3a4725), ("DBytes_copy_wrapper",     0x3a27b9),
    ("DBytes_release_wrapper", 0x3a6e2d), ("CBlowFish_new_wrapper",   0x3aae05),
    ("CBlowFish_setKey_wrapper", 0x3a2ecd), ("CBlowFish_Encrypt_wrapper", 0x3a2d25),
    ("CBlowFish_Decrypt_wrapper", 0x3a2b95),
]
have = {t[1] & ~1 for t in targets}
for nm, va in known_wrappers:
    if (va & ~1) not in have:
        targets.append((nm, va, 260))  # heuristic; capstone stops at padding

md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
md.detail = False

# readable-string helpers (NDK merged const strings INTO .text too)
readable = [s for s in sections if s["type"] == 1 and s["sname"] in
            (".rodata", ".dynstr", ".strtab", ".data", ".data.rel.ro",
             ".data.rel.ro.local", ".text") and s["size"] > 0]
def string_at(a):
    for s in readable:
        if s["addr"] <= a < s["addr"] + s["size"]:
            off = s["offset"] + (a - s["addr"])
            end = buf.find(b"\x00", off, off + 160)
            if end > off:
                raw = buf[off:end]
                if len(raw) >= 3 and all(0x20 <= b < 0x7f for b in raw):
                    return raw.decode("latin1")
    return None

def describe(v):
    if v is None:
        return None
    a = v & ~1
    sname = symmap.get(a)
    sref = string_at(a)
    if sref:
        return '"%s"' % sref[:64]
    if sname:
        return sname
    return None

lines = []
def addr2off(a):
    a &= ~1
    for s in sections:
        if s["type"] == 8 or s["size"] == 0:  # NOBITS has no file image
            continue
        if s["addr"] <= a < s["addr"] + s["size"]:
            return s["offset"] + (a - s["addr"])
    return None

def rnum(s):
    return int(s[1:]) if re.fullmatch(r"r\d+", s) else None

for nm, va, size in sorted(targets, key=lambda t: t[1]):
    thumb = (va & 1) == 1
    base = va & ~1
    foff = addr2off(va)
    lines.append("\n=== %s  addr=0x%08x thumb=%s size=%d ===" % (nm, base, thumb, size))
    if foff is None:
        lines.append("  (address outside mapped sections)")
        continue
    md.mode = CS_MODE_THUMB if thumb else CS_MODE_ARM
    code = buf[foff:foff + size]
    # mini register tracker: r -> ('w', word) literal | resolved value
    regs = {}
    for ins in md.disasm(code, base):
        mn, ops = ins.mnemonic, ins.op_str
        note = ""
        parts = [p.strip() for p in ops.replace("[pc]", "pc").split(",")]
        if mn.startswith("ldr") and "[pc" in ops:
            lit = ops.split("#")[-1].rstrip("]").strip()
            step = int(lit, 0) if lit else 0
            pool = ((ins.address + 4) & ~3) + step
            woff = addr2off(pool)
            if woff is not None:
                word = struct.unpack_from("<I", buf, woff)[0]
                dst = parts[0]
                rn = rnum(dst)
                if rn is not None:
                    regs[rn] = word
                note = "  ; pool 0x%08x = 0x%08x (%s)" % (pool, word,
                        describe(word) or ("delta" if word >= 0x80000000 else "?"))
        elif mn == "add" and "pc" in parts[-1] and len(parts) >= 2:
            rn = rnum(parts[0])
            if rn is not None and rn in regs:
                v = (ins.address + 4) + regs[rn]  # Thumb add pc: no alignment
                v &= 0xFFFFFFFF
                regs[rn] = v
                note = "  ; = 0x%08x (%s)" % (v, describe(v) or "?")
        elif mn == "mov" and len(parts) == 2:
            da, src = rnum(parts[0]), rnum(parts[1])
            if da is not None:
                regs[da] = regs.get(src) if src is not None else None
        elif mn.startswith("bl"):
            args = " | ".join(filter(None, (describe(regs.get(r)) for r in sorted(regs))))
            if args:
                note = "  ; args-> %s" % args
        lines.append("  0x%08x: %-10s %s%s" % (ins.address, mn, ops, note))

open(OUT, "w", encoding="utf-8", errors="replace").write("\n".join(lines))
print("targets disassembled: %d" % len(targets))
for nm, va, size in targets:
    print("  0x%08x size=%-5d %s" % (va, size, nm))
print("written:", OUT)
