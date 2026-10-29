"""Exact logo format conversion and Android string-pool branding, without package-ID changes."""
import io,struct
from pathlib import Path
from PIL import Image

NAME='NinjaAscension'
ROOT=Path(__file__).resolve().parents[1]
LOGO=ROOT.parent/'logogame.jpg'


def png(size):
    image=Image.open(LOGO).convert('RGB').resize((size,size),Image.Resampling.LANCZOS)
    output=io.BytesIO();image.save(output,format='PNG');return output.getvalue()


def prepare():
    target=ROOT/'port/resources/game-icon.png';target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(png(256))
    icon=ROOT/'port/native/NinjaAscension.ico'
    Image.open(LOGO).convert('RGB').save(icon,format='ICO',sizes=[(16,16),(24,24),(32,32),(48,48),(64,64),(128,128),(256,256)])
    return icon


def android_label(raw):
    """Replace a shorter string in the first/global string pool, preserving offsets."""
    result=bytearray(raw);root_header=struct.unpack_from('<H',raw,2)[0];position=root_header;changed=0
    while position+8<=len(raw):
        kind,header,size=struct.unpack_from('<HHI',raw,position)
        if size<8 or position+size>len(raw):raise ValueError('Invalid Android resource chunk')
        if kind==1:
            count,_,flags,start,_=struct.unpack_from('<5I',raw,position+8)
            for index in range(count):
                offset=struct.unpack_from('<I',raw,position+header+index*4)[0];begin=position+start+offset
                if flags&0x100:
                    chars=raw[begin];prefix=1 if chars<128 else 2
                    byte_length=raw[begin+prefix];prefix+=1
                    if byte_length>=128:
                        byte_length=((byte_length&127)<<8)|raw[begin+prefix];prefix+=1
                    old=raw[begin+prefix:begin+prefix+byte_length]
                    if old!=b'Ninja Revolution':continue
                    new=NAME.encode();payload=bytes([len(NAME),len(new)])+new+b'\0'
                    end=begin+prefix+byte_length+1
                else:
                    length=struct.unpack_from('<H',raw,begin)[0]
                    if length>=32768:continue
                    old=raw[begin+2:begin+2+length*2].decode('utf-16le')
                    if old!='Ninja Revolution':continue
                    payload=struct.pack('<H',len(NAME))+NAME.encode('utf-16le')+b'\0\0';end=begin+2+length*2+2
                if len(payload)>end-begin:raise ValueError('New branding does not fit')
                result[begin:end]=payload+b'\0'*(end-begin-len(payload));changed+=1
        position+=size
    return bytes(result),changed


def android_resource(name,raw):
    if name in ('resources.arsc','AndroidManifest.xml'):
        return android_label(raw)[0]
    if name.startswith('res/drawable') and name.endswith('/icon.png'):
        size=Image.open(io.BytesIO(raw)).size
        if size[0]!=size[1]:raise ValueError('Unexpected nonsquare Android icon')
        return png(size[0])
    return raw


if __name__=='__main__':print('BRANDING_READY '+str(prepare()))
