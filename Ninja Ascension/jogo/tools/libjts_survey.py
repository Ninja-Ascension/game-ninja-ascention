# -*- coding: utf-8 -*-
"""Fase 0 sonda: inventario do libjts.so (recovered native library).

Read-only survey: ELF header, dynamic symbol table exports, and keyword
strings. Everything stays inside the workspace; the goal is a GO/NO-GO
verdict on reverse-engineering the packet crypto/serialization
(cc.DBytes / cc.deflateMemory native bindings) needed by a localhost
server. No original file is modified.
"""
import re, struct, sys, io

SO = r"E:\[code]\nk\01_conteudo_apk\lib\armeabi-v7a\libjts.so"
OUT = r"E:\[code]\nk\build\probe-writable\libjts_survey.txt"

buf = open(SO, "rb").read()
lines = []

def w(s):
    lines.append(s)

# --- ELF header (32-bit, little endian) ---
assert buf[:4] == b"\x7fELF", "not an ELF"
ei_class, ei_data = buf[4], buf[5]
w("ELF class: %s (%d)  data: %s (%d)" % ("32" if ei_class == 1 else "64", ei_class,
                                          "LE" if ei_data == 1 else "BE", ei_data))
e_type, e_machine, e_version, e_entry, e_phoff, e_shoff, e_flags, e_ehsize, \
    e_phentsize, e_phnum, e_shentsize, e_shnum, e_shstrndx = struct.unpack_from("<HHIIIIIHHHHHH", buf, 16)
w("type=%d machine=%d (40=ARM) entry=0x%x phoff=0x%x shoff=0x%x shentsize=%d shnum=%d shstrndx=%d"
  % (e_type, e_machine, e_entry, e_phoff, e_shoff, e_shentsize, e_shnum, e_shstrndx))

# --- section headers ---
sections = []
for i in range(e_shnum):
    off = e_shoff + i * e_shentsize
    name, stype, flags, addr, offset, size, link, info, align, entsize = struct.unpack_from("<10I", buf, off)
    sections.append(dict(name=name, type=stype, flags=flags, addr=addr,
                         offset=offset, size=size, link=link, entsize=entsize))
shstr = sections[e_shstrndx]
def secname(n):
    end = buf.index(b"\x00", shstr["offset"] + n)
    return buf[shstr["offset"] + n:end].decode("latin1")
for s in sections:
    s["sname"] = secname(s["name"])
w("\nSECTIONS (name, type, size):")
for s in sections:
    w("  %-22s type=%-2d size=%8d off=0x%06x" % (s["sname"], s["type"], s["size"], s["offset"]))

# --- dynamic symbols ---
def dynsyms(sec_sym, sec_str):
    out = []
    strtab = sec_str["offset"]
    n = sec_sym["size"] // sec_sym["entsize"]
    for i in range(n):
        off = sec_sym["offset"] + i * sec_sym["entsize"]
        st_name, st_value, st_size, st_info, st_other, st_shndx = struct.unpack_from("<IIIBBH", buf, off)
        if st_name == 0:
            continue
        end = buf.index(b"\x00", strtab + st_name)
        nm = buf[strtab + st_name:end].decode("latin1")
        bind = st_info >> 4
        typ = st_info & 0xF
        out.append((nm, st_value, st_size, bind, typ, st_shndx))
    return out

exports = {}
for sname in (".dynsym", ".symtab"):
    sec = next((s for s in sections if s["sname"] == sname), None)
    if not sec or sec["entsize"] == 0:
        if sname == ".symtab":
            w("\n.symtab: ABSENT (stripped)")
        continue
    strs = next(s for s in sections if s["sname"] == (".dynstr" if sname == ".dynsym" else ".strtab"))
    syms = dynsyms(sec, strs)
    defined = [x for x in syms if x[5] != 0]
    w("\n%s: %d symbols total, %d defined (with address+size%s)"
      % (sname, len(syms), len(defined), "" if sname == ".symtab" else " (exports+binds only)"))
    exports[sname] = defined

interesting = re.compile(r"(dbytes|deflate|inflate|blowfish|compress|crypt|aes|md5|sha|base64|"
                         r"jtsde|jtsen|packet|protocol|network|encrypt|decrypt|xor|"
                         r"card_body|serialize|deserial|luajit|tolua|key)", re.IGNORECASE)

report = io.StringIO()
for sname, defined in exports.items():
    hits = [x for x in defined if interesting.search(x[0])]
    w("\nKEYWORDS in %s (%d hits):" % (sname, len(hits)))
    for nm, val, size, bind, typ, shndx in hits:
        w("  0x%08x size=%-6d bind=%d type=%d sec=%d  %s" % (val, size, bind, typ, shndx, nm))
    report.write("\n[%s hits=%d]\n" % (sname, len(hits)))

# --- keyword strings body ---
w("\nSTRINGS (>=6 chars) matching keywords:")
strs = re.findall(rb"[\x20-\x7e]{6,}", buf)
seen = set()
kw_strings = re.compile(r"(dbytes|deflate|inflate|blowfish|crypt|encrypt|decrypt|"
                        r"packet|network|protocol|neprotocol|jts|luabyte|datas:|"
                        r"xtea|rc4|xxtea)", re.IGNORECASE)
count = 0
for s in strs:
    try:
        t = s.decode("latin1")
    except Exception:
        continue
    if kw_strings.search(t) and t not in seen:
        seen.add(t)
        count += 1
        if count <= 200:
            w("  " + t[:160])
w("... total keyword strings: %d (list truncated at 200)" % count)

# JAVA bridge surface: JNI exports reveal what the Java side calls natively
w("\nJAVA_* / JNI EXPORTS (surface of native functions reachable from the old app):")
for nm, val, size, bind, typ, shndx in exports.get(".dynsym", []):
    if "Java_" in nm or "JNI_" in nm:
        w("  0x%08x size=%-6d  %s" % (val, size, nm))

open(OUT, "w", encoding="utf-8", errors="replace").write("\n".join(lines))
print("survey written:", OUT)
print("sections=%d dynsym_defined=%d symtab=%s keyword_strings=%d"
      % (len(sections), len(exports.get(".dynsym", [])),
         "present" if ".symtab" in exports else "stripped", count))
