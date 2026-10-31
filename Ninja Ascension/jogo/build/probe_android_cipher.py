import re,struct
from pathlib import Path
h=Path('jogo/port/native/protocol/blowfish_tables.h').read_text();v=[int(x,16) for x in re.findall(r'0x[0-9a-fA-F]+',h)]
p=v[:18];s=v[18:];MASK=0xffffffff
assert len(s)==1024
def f(x):return (((s[x>>24]+s[256+(x>>16&255)]) ^s[512+(x>>8&255)])+s[768+(x&255)])&MASK
def enc(l,r):
 for i in range(0,16,2):
  l^=p[i];r^=f(l);r^=p[i+1];l^=f(r)
 return r^p[17],l^p[16]
def dec(l,r):
 for i in range(16,0,-2):
  l^=p[i+1];r^=f(l);r^=p[i];l^=f(r)
 return r^p[1],l^p[0]
k=b'K(7a!ykjTD&DAp0!';j=0
for i in range(18):
 a=0
 for _ in range(4):a=(a<<8)|k[j];j=(j+1)%len(k)
 p[i]^=a
l=r=0
for i in range(0,18,2):l,r=enc(l,r);p[i:i+2]=l,r
for i in range(0,1024,2):l,r=enc(l,r);s[i:i+2]=l,r
b=bytes.fromhex('9c887caab8a5e872')
for endian in ['<','>']:
 for data in [b,b[4:]+b[:4]]:
  out=struct.pack(endian+'II',*dec(*struct.unpack(endian+'II',data)));print(endian,out.hex())
