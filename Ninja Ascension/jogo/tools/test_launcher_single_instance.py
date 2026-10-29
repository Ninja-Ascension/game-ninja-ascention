"""Exercise the real launcher with an isolated, harmless stand-in game."""
import os,shutil,subprocess,tempfile,time
from pathlib import Path
root=Path(__file__).resolve().parents[1]
csc=Path('C:/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe')
with tempfile.TemporaryDirectory(prefix='launcher-single-',dir=root/'build',ignore_cleanup_errors=True) as folder:
    folder=Path(folder);game=folder/'dados/build/windows-probe-native/bin/NinjaResourceProbe/Debug'
    game.mkdir(parents=True)
    for name in ('res','src'):(folder/'dados/01_conteudo_apk/assets'/name).mkdir(parents=True)
    source=folder/'Stub.cs'
    source.write_text('using System;using System.IO;using System.Threading;class Stub{static void Main(){File.AppendAllText("starts.txt","1\\n");Thread.Sleep(4000);}}',encoding='utf8')
    subprocess.run([str(csc),'/nologo','/target:exe','/out:'+str(game/'NinjaResourceProbe.exe'),str(source)],check=True,capture_output=True)
    for name in ('NinjaAscension.exe','Ninja Revolution.exe'):shutil.copy2(root/'tools/launcher/NinjaAscension.exe',folder/name)
    env={k:v for k,v in os.environ.items() if not k.startswith('NR_')}
    first=subprocess.Popen([str(folder/'NinjaAscension.exe')],cwd=folder,env=env)
    marker=folder/'dados/starts.txt'
    try:
        for _ in range(100):
            if marker.exists():break
            if first.poll() is not None:raise AssertionError('Launcher exited before starting stub')
            time.sleep(.05)
        assert marker.exists(),'Stub not launched'
        others=[subprocess.Popen([str(folder/name)],cwd=folder,env=env) for name in ('NinjaAscension.exe','NinjaAscension.exe')]
        for process in others:assert process.wait(timeout=5)==0
        assert first.wait(timeout=10)==0
        assert marker.read_text()=='1\n','Game launched twice'
        assert not (folder/'Ninja Revolution.exe').exists(),'Old visible executable recreated'
        assert (folder/'Ninja Revolution.exe.legacy').exists(),'Legacy backup missing'
        print('LAUNCHER_SINGLE_INSTANCE_PASSED concurrent opens -> one game; old name removed; private files only')
    finally:
        if first.poll() is None:first.terminate();first.wait(timeout=5)
