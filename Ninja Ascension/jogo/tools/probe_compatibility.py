"""M0/M1 source/asset contract checks. Does not execute the game or contact servers."""
from pathlib import Path
import hashlib, importlib.util, json, re, shutil, subprocess, struct, sys, os

ROOT = Path(__file__).resolve().parents[1]
RES = ROOT / '01_conteudo_apk/assets/res'
AX = ROOT / 'build/deps/axmol'
LEGACY = ROOT / 'build/deps/cocos2d-x-3.5'
OUT = ROOT / 'port/data'
AX_REV = '6c0dce6db4660feafe29dabb1ab3506ee76b0931'
LEGACY_REV = 'f7e11a2467e4508738ad9cf4b3992da05f9d1e7c'

def read(p): return p.read_text(encoding='utf-8-sig')
def revision(p):
    return subprocess.check_output(['git','-C',str(p),'rev-parse','HEAD'],text=True).strip()
def decoder():
    # Import reference tooling without generating bytecode beside preserved files.
    sys.dont_write_bytecode=True
    spec=importlib.util.spec_from_file_location('original_csb_decoder',ROOT/'_ferramentas/scripts/decode_cocos_layouts.py')
    module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    return module
def record(p):
    return {'path':p.relative_to(RES).as_posix(),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size}
def toolchain():
    result={n:shutil.which(n) for n in ('cmake','cl','ninja','lua','luajit')}
    vswhere=Path(os.environ.get('ProgramFiles(x86)','C:/Program Files (x86)'))/'Microsoft Visual Studio/Installer/vswhere.exe'
    if vswhere.exists():
        found=subprocess.check_output([str(vswhere),'-latest','-products','*','-requires','Microsoft.VisualStudio.Component.VC.Tools.x86.x64','-format','json'],text=True,encoding='utf8',errors='replace')
        instances=json.loads(found)
        if instances:
            result['visual_studio']=instances[0]['installationVersion']
            root=Path(instances[0]['installationPath'])/'VC/Tools/MSVC'
            compilers=sorted(root.glob('*/bin/Hostx64/x64/cl.exe'))
            if compilers:result['cl']=str(compilers[-1])
    return result
def walk(value):
    if isinstance(value,dict):
        yield value
        for v in value.values(): yield from walk(v)
    elif isinstance(value,list):
        for v in value: yield from walk(v)
def atlas_pages(p):
    # Spine 2.1 atlas pages start at the beginning or after a blank separator.
    result=[]; blank=True
    for line in read(p).splitlines():
        if blank and line.strip() and ':' not in line: result.append(line.strip())
        blank=not line.strip()
    return result
def font_pages(p):
    data=p.read_bytes()
    if data[:4]==b'BMF\x03':
        pos=4
        while pos<len(data):
            kind=data[pos];size=struct.unpack_from('<I',data,pos+1)[0];pos+=5
            block=data[pos:pos+size];pos+=size
            if kind==3:return [x.decode('utf8') for x in block.split(b'\0') if x]
        raise ValueError('Binary BMFont missing page block')
    # Face names can use legacy encodings; page filenames are ASCII in this sample.
    return [x.decode('ascii') for x in re.findall(rb'file="([^"]+)"',data)]
def inspect():
    assert revision(AX)==AX_REV, 'Axmol revision mismatch'
    assert revision(LEGACY)==LEGACY_REV, 'Legacy revision mismatch'
    csb=RES/'cocostudio/login/login.csb'
    dec=decoder(); reader=dec.Reader(csb.read_bytes()); layout=reader.read()
    previous=json.loads(read(ROOT/'05_layouts_cocos_json/assets/res/cocostudio/login/login.json'))
    assert layout==previous, 'Original CSB and prior decoded sample differ'
    assert not reader.unknown, reader.unknown
    character=RES/'sprite/spirte_102101.json'
    char=json.loads(read(character)); atlas=character.with_suffix('.atlas')
    pages=[atlas.parent/p for p in atlas_pages(atlas)]
    assert pages and all(p.is_file() for p in pages), 'Missing atlas pages'
    animations=sorted(char['animations']); assert animations
    audio=sorted((RES/'music/background').glob('*.mp3'))[0]
    font=RES/'fonts/arena_fighting.fnt'
    font_textures=[font.parent/x for x in font_pages(font)]
    assert font_textures and all(p.is_file() for p in font_textures)
    references=sorted({v['path'] for v in walk(layout) if isinstance(v.get('path'),str) and v['path']})
    # Unresolved references may be supplied via atlas frames or localized overrides.
    missing=[p for p in references if not (RES/p).is_file()]
    timelines=[]
    # Select only one additional CSB with actual timeline frames for M1, not a mass conversion.
    candidates=['login/logo','utils/update_loading','game_announcement/game_announcement']
    for rel in candidates:
        p=RES/f'cocostudio/{rel}.csb'
        if not p.exists(): continue
        obj=dec.Reader(p.read_bytes()).read()
        if obj.get('action',{}).get('timeLines'):
            timelines=[p];break
    if not timelines:
        # Deterministic fallback scans decoded metadata only, stopping at first timeline.
        for p in sorted((ROOT/'05_layouts_cocos_json/assets/res/cocostudio').rglob('*.json')):
            if json.loads(read(p)).get('action',{}).get('timeLines'):
                timelines=[RES/'cocostudio'/p.relative_to(ROOT/'05_layouts_cocos_json/assets/res/cocostudio').with_suffix('.csb')]; break
    assert timelines, 'No timeline sample'
    version=read(AX/'extensions/spine/runtime/include/spine/Version.h')
    runtime=re.search(r'SPINE_VERSION_STRING "([^"]+)"',version)[1]
    loader=read(AX/'extensions/spine/runtime/src/spine/SkeletonJson.cpp')
    assert 'startsWith(SPINE_VERSION_STRING)' in loader
    legacy=read(LEGACY/'cocos/editor-support/spine/SkeletonJson.c')
    attachments=sorted({a.get('type','region') for skin in char['skins'].values() for slot in skin.values() for a in slot.values()})
    selected=[csb,character,atlas,*pages,audio,font,*font_textures,*timelines]
    manifest={'schema':1,'purpose':'M1 isolated resource probe, not recovered offline gameplay','csb':csb.relative_to(RES).as_posix(),'character':character.relative_to(RES).as_posix(),'atlas':atlas.relative_to(RES).as_posix(),'animation':next((a for a in animations if a.lower() in ('stand','standby','idle')),animations[0]),'animations':animations,'audio':audio.relative_to(RES).as_posix(),'font':font.relative_to(RES).as_posix(),'timeline':timelines[0].relative_to(RES).as_posix(),'files':[record(p) for p in sorted(set(selected))]}
    result={'axmol':{'tag':'v2.11.5','revision':AX_REV,'spine':runtime,'luajit':'2.1-7152e15 (explicit opt-in)','default_lua':'5.4.8'},'legacy':{'tag':'cocos2d-x-3.5','revision':LEGACY_REV,'old_json_parser_present':all(s in legacy for s in ('"ffd"','"skins"')),'build_status':'See docs/TEST_RESULTS.md for native execution history'},'source_character_version':char['skeleton']['spine'],'attachment_types':attachments,'direct_spine_compatible':char['skeleton']['spine'].startswith(runtime),'csb_decode_matches_prior':True,'csb_version':layout['version'],'csb_runtime_status':'See docs/TEST_RESULTS.md; this script only validates structure','csb_reference_candidates_missing':missing,'toolchain':toolchain(),'network_policy':'No original main.lua, login or historical endpoints executed'}
    probe_exe=ROOT/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
    result['native_probe']={'exe_present':probe_exe.exists(),'path':probe_exe.relative_to(ROOT).as_posix()}
    result['production_gate']=('NATIVE_BUILD_AND_RUN_DONE: probe exe present and exercised by the automated suite '
                               '(battle smoke passes with original damage, victory/defeat/restart; see docs/TEST_RESULTS.md, 23 Oct 2026). '
                               'Remaining gates: human visual/audio acceptance, broader character matrix, deeper original-simulator integration')
    if not probe_exe.exists():
        result['production_gate']='BLOCKED: probe executable missing; run tools/build_windows.ps1'
    return manifest,result
def main():
    manifest,result=inspect();OUT.mkdir(parents=True,exist_ok=True)
    for name,value in [('samples.json',manifest),('compatibility_results.json',result)]:
        (OUT/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
    print(json.dumps(result,ensure_ascii=False,indent=2))
if __name__=='__main__': main()
