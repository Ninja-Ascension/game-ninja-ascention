"""Refresh scripts in an existing APK without recompressing unchanged media."""
import copy,hashlib,os,shutil,struct,subprocess,zipfile
from pathlib import Path
import montar_apk as build


def refresh(source,target,replacements):
    with zipfile.ZipFile(source) as old,open(source,'rb') as raw,zipfile.ZipFile(target,'w') as new:
        entries=sorted(old.infolist(),key=lambda item:item.header_offset)
        end=old.start_dir
        if end>=24:
            raw.seek(end-24);footer=raw.read(24)
            if footer[8:]==b'APK Sig Block 42':end-=struct.unpack('<Q',footer[:8])[0]+8
        for index,entry in enumerate(entries):
            if entry.filename.startswith('META-INF/') or entry.filename in replacements:continue
            stop=entries[index+1].header_offset if index+1<len(entries) else end
            assert stop>entry.header_offset
            item=copy.copy(entry);item.header_offset=new.fp.tell()
            raw.seek(entry.header_offset);remaining=stop-entry.header_offset
            while remaining:
                block=raw.read(min(remaining,1024*1024))
                if not block:raise EOFError(entry.filename)
                new.fp.write(block);remaining-=len(block)
            new.filelist.append(item);new.NameToInfo[item.filename]=item;new.start_dir=new.fp.tell()
        for name,data in replacements.items():new.writestr(name,data,compress_type=zipfile.ZIP_DEFLATED)


def main(resources=()):
    source=build.FINAL
    replacements={'assets/src/main.lua':build.main_lua(),
                  'assets/src/nr_gameplay_config.lua':build.gameplay_lua(),
                  'assets/src/port_mobile.lua':(build.ROOT/'port/android/port_mobile.lua').read_bytes(),
                  'assets/src/port/gameplay.json':(build.ROOT/'port/gameplay.json').read_bytes()}
    for file in (build.ROOT/'port/lua').glob('*.lua'):replacements['assets/src/port/lua/'+file.name]=file.read_bytes()
    for relative in resources:
        file=(build.ASSETS/relative).resolve()
        name=file.relative_to(build.ASSETS.resolve()).as_posix()
        if not name.startswith('res/') or not file.is_file():raise ValueError('Invalid APK resource: '+relative)
        replacements['assets/'+name]=file.read_bytes()
    # Include all current client scripts, including existing gameplay fixes.
    for file in (build.ASSETS/'src').rglob('*.lua'):
        name='assets/'+file.relative_to(build.ASSETS).as_posix()
        if name not in replacements:replacements[name]=file.read_bytes()
    with zipfile.ZipFile(source) as apk:
        names=set(apk.namelist())
        replacements={name:data for name,data in replacements.items() if name not in names or apk.read(name)!=data}
    unsigned=build.ROOT/'build/apk-refresh-unsigned.apk';aligned=build.ROOT/'build/apk-refresh-aligned.apk';signed=build.ROOT/'build/apk-refresh-signed.apk'
    print('APK_REFRESH scripts_changed='+str(len(replacements)),flush=True)
    refresh(source,unsigned,replacements)
    subprocess.run([str(build.TOOLS/'zipalign.exe'),'-f','-p','4',str(unsigned),str(aligned)],check=True)
    subprocess.run(['java','-jar',str(build.TOOLS/'lib/apksigner.jar'),'sign','--ks',str(build.KEYSTORE),'--ks-pass','pass:'+build.STORE_PASS,'--out',str(signed),str(aligned)],check=True)
    subprocess.run(['java','-jar',str(build.TOOLS/'lib/apksigner.jar'),'verify',str(signed)],check=True)
    with zipfile.ZipFile(source) as before,zipfile.ZipFile(signed) as after:
        for name,data in replacements.items():assert after.read(name)==data,name
        for name in before.namelist():
            if name.startswith('lib/') or name in ('AndroidManifest.xml','resources.arsc'):
                assert before.read(name)==after.read(name),'Native/application resource changed: '+name
    backup=build.ROOT/'build/NinjaAscension-before-startup-fix.apk'
    if not backup.exists():shutil.copy2(source,backup)
    os.replace(signed,source)
    sidecar=Path(str(signed)+'.idsig')
    if sidecar.exists():os.replace(sidecar,Path(str(source)+'.idsig'))
    print('APK_REFRESH_VERIFIED '+str(source),flush=True)
    for file in (unsigned,aligned):file.unlink()


if __name__=='__main__':
    import argparse
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--resource',action='append',default=[],help='Resource relative to assets/, e.g. res/images/ui/bg/home_bg_1.png')
    main(parser.parse_args().resource)
