"""Build the Android APK from the original APK + the PC client content.

- assets/src and assets/res come from jogo/01_conteudo_apk/assets (same
  scripts/resources as the PC client), main.lua boots src/port_mobile.lua;
- port/lua -> assets/src/port/lua, port/gameplay.json -> assets/src/port/;
- app.config points to the VPS (port/resources/servidor.txt.vps);
- app label and density-specific launcher icons use NinjaAscension/logogame.jpg;
- package ID, engine libraries and signing key stay unchanged; zipalign + apksigner.
Usage: python tools/montar_apk.py   (output: distribuicao/NinjaAscension.apk)
"""
import json, os, re, subprocess, sys, zipfile
import game_branding
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT.parent / 'NinjaRevolution-1.1.1-32bits.apk'
ASSETS = ROOT / '01_conteudo_apk' / 'assets'
TOOLS = ROOT / 'build' / 'ferramentas' / 'android' / 'android-14'
KEYSTORE = ROOT / 'build' / 'android-assinatura.jks'
OUT_DIR = ROOT.parent / 'distribuicao'
UNSIGNED = ROOT / 'build' / 'apk-sem-assinatura.apk'
ALIGNED = ROOT / 'build' / 'apk-alinhado.apk'
FINAL = OUT_DIR / 'NinjaAscension.apk'
STORE_PASS = 'ninjarevolution'


def main_lua():
    text = (ASSETS / 'src' / 'main.lua').read_text(encoding='utf-8')
    hook = '    _app.create()\n'
    if hook not in text.replace('\r\n', '\n'):
        raise SystemExit('main.lua: ponto de entrada nao encontrado')
    text = text.replace('\r\n', '\n')
    diagnostic = (ROOT / 'port/android/startup_diagnostic.lua').read_text(encoding='utf-8')
    text = diagnostic + '\n' + text
    text = text.replace('require "cocos.init"', 'local initOK, initError = xpcall(function() require "cocos.init" end, __nr_android_boot.report)\nif not initOK then return end', 1)
    text = text.replace('function __G__TRACKBACK__(msg)', 'function __G__TRACKBACK__(msg)\n    __nr_android_boot.report(msg)', 1)
    text = text.replace('    local _app = require("frameworks.app")', '    __nr_android_boot.stage="frameworks.app"\n    local _app = require("frameworks.app")', 1)
    text = text.replace(hook, '    __nr_android_boot.stage="app.create"\n' + hook + '    __nr_android_boot.stage="port_mobile"\n    require("port_mobile")\n', 1)
    text = text.replace('    app.load("client.launch")', '    __nr_android_boot.stage="client.launch"\n    app.load("client.launch")', 1)
    return text.replace('\n', '\r\n').encode('utf-8')


def gameplay_lua():
    text = (ROOT / 'port/gameplay.json').read_text(encoding='utf-8')
    json.loads(text)  # Reject invalid configuration before packaging.
    delimiter = '='
    while ']' + delimiter + ']' in text:
        delimiter += '='
    return ('return [' + delimiter + '[' + text + ']' + delimiter + ']\n').encode('utf-8')


def app_config():
    url = (ROOT / 'port' / 'resources' / 'servidor.txt.vps').read_text(encoding='utf-8').strip()
    text = (ASSETS / 'res' / 'configs' / 'app.config').read_text(encoding='utf-8')
    text = re.sub(r'("url(?:ForAnnounce)?"\s*:\s*")[^"]*(")', lambda m: m.group(1) + url + m.group(2), text)
    return text.encode('utf-8')


def build():
    game_branding.prepare()
    if not BASE.exists():
        raise SystemExit('APK original ausente: %s' % BASE)
    special = {'assets/src/main.lua': main_lua(), 'assets/res/configs/app.config': app_config()}
    with zipfile.ZipFile(BASE) as src, zipfile.ZipFile(UNSIGNED, 'w') as out:
        for info in src.infolist():
            name = info.filename
            if name.startswith('META-INF/') or name.startswith('assets/src/') or name.startswith('assets/res/'):
                continue
            out.writestr(info, game_branding.android_resource(name,src.read(name)), compress_type=info.compress_type)
        # 64-bit engine: the 64-bit APK of the same version has the same Java
        # code and the same 32-bit libjts.so, so its arm64 libjts.so drops in.
        # Phones pick arm64-v8a or armeabi-v7a automatically.
        apk64 = ROOT.parent / 'origem_apk' / 'NinjaRevolution64-1.1.1-64bits.apk'
        if apk64.exists():
            with zipfile.ZipFile(apk64) as z64:
                info64 = z64.getinfo('lib/arm64-v8a/libjts.so')
                out.writestr(info64, z64.read(info64), compress_type=info64.compress_type)
                print('motor 64 bits incluido')
        count = 0
        for folder in ('src', 'res'):
            for path in sorted((ASSETS / folder).rglob('*')):
                if path.is_file():
                    name = 'assets/' + path.relative_to(ASSETS).as_posix()
                    data = special.get(name)
                    out.writestr(name, data if data is not None else path.read_bytes(), compress_type=zipfile.ZIP_DEFLATED)
                    count += 1
        for path in sorted((ROOT / 'port' / 'lua').glob('*.lua')):
            out.writestr('assets/src/port/lua/' + path.name, path.read_bytes(), compress_type=zipfile.ZIP_DEFLATED); count += 1
        out.writestr('assets/src/port/gameplay.json', (ROOT / 'port' / 'gameplay.json').read_bytes(), compress_type=zipfile.ZIP_DEFLATED)
        out.writestr('assets/src/nr_gameplay_config.lua', gameplay_lua(), compress_type=zipfile.ZIP_DEFLATED)
        # What the APK carries, keyed like the server update list, so the
        # in-game updater (port_mobile.lua) only downloads what changed.
        import hashlib
        versions = {}
        for path in (ASSETS / 'src').rglob('*.lua'):
            versions['01_conteudo_apk/assets/' + path.relative_to(ASSETS).as_posix()] = hashlib.sha256(path.read_bytes()).hexdigest()
        for path in (ROOT / 'port' / 'lua').glob('*.lua'):
            versions['port/lua/' + path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
        versions['port/gameplay.json'] = hashlib.sha256((ROOT / 'port' / 'gameplay.json').read_bytes()).hexdigest()
        out.writestr('assets/src/nr_versions.json', json.dumps(versions, separators=(',', ':')), compress_type=zipfile.ZIP_DEFLATED)
        out.writestr('assets/src/port_mobile.lua', (ROOT / 'port' / 'android' / 'port_mobile.lua').read_bytes(), compress_type=zipfile.ZIP_DEFLATED)
    print('arquivos do jogo:', count)
    subprocess.run([str(TOOLS / 'zipalign.exe'), '-f', '-p', '4', str(UNSIGNED), str(ALIGNED)], check=True)
    if not KEYSTORE.exists():
        subprocess.run(['keytool', '-genkeypair', '-keystore', str(KEYSTORE), '-alias', 'ninjarevolution', '-keyalg', 'RSA',
                        '-keysize', '2048', '-validity', '10000', '-storepass', STORE_PASS, '-keypass', STORE_PASS,
                        '-dname', 'CN=Ninja Revolution, O=Ninja Ascension, C=BR'], check=True)
    OUT_DIR.mkdir(exist_ok=True)
    subprocess.run(['java', '-jar', str(TOOLS / 'lib' / 'apksigner.jar'), 'sign', '--ks', str(KEYSTORE), '--ks-pass',
                    'pass:' + STORE_PASS, '--out', str(FINAL), str(ALIGNED)], check=True)
    subprocess.run(['java', '-jar', str(TOOLS / 'lib' / 'apksigner.jar'), 'verify', '--print-certs', str(FINAL)], check=True)
    UNSIGNED.unlink(); ALIGNED.unlink()
    print('APK:', FINAL, round(FINAL.stat().st_size / 1e6), 'MB')


if __name__ == '__main__':
    build()
