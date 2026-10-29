"""Reproduce the login ordering regression in native Lua using isolated data."""
from pathlib import Path
import os,subprocess,sys,tempfile
root=Path(__file__).resolve().parents[1]
subprocess.run([sys.executable,str(root/'tools/test_tutorial_campaign.py')],cwd=root,check=True,capture_output=True)
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
with tempfile.TemporaryDirectory(prefix='cold-login-',dir=root/'build') as folder:
    folder=Path(folder)
    response=(root/'build/campaign-test-login.txt').read_text(encoding='utf8')
    tokens=response.split(' ')
    scene=tokens.index('6020');npc=tokens.index('6022')
    assert npc==scene+5
    broken=tokens[:scene]+tokens[npc:]+tokens[scene:npc]
    (folder/'broken.txt').write_text(' '.join(broken),encoding='utf8')
    for name,path in [('broken',folder/'broken.txt'),('fixed',root/'build/campaign-test-login.txt')]:
        env=os.environ.copy()
        env.pop('NR_PROBE_CAMPAIGN_REPLY',None)
        env.update(NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',
                   NR_PROBE_MENU_TEST='1',NR_PROBE_LOGIN_REPLY=str(path),NR_PROBE_SHOT=str(folder),
                   NR_PROBE_LAYOUT_FILE=str(folder/'layout.json'))
        try:
            run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=30)
        except subprocess.TimeoutExpired as exc:
            (root/('build/cold-login-'+name+'-timeout.log')).write_bytes(exc.stdout or b'')
            raise
        output=run.stdout.decode('utf8',errors='replace')
        (root/('build/cold-login-'+name+'.log')).write_text(output,encoding='utf8')
        if name=='broken':
            assert 'MENU_BOOT_PROBE_RESULT false' in output and "in function 'pairs'" in output,output[-3000:]
        else:
            assert run.returncode==0 and 'COLD_LOGIN_NATIVE_PASSED' in output,output[-3000:]
            assert 'COLD_LOGIN_FORMULA_BEFORE nil' in output,'Fixture preloaded the missing dependency'
            assert 'PROFILE_FORMULAS_READY before protocol dispatch' in output
            assert 'MENU_BOOT_PROBE_RESULT true' in output and 'LUA ERROR:' not in output
        print('COLD_LOGIN',name,'expected result verified',flush=True)
print('COLD_LOGIN_REGRESSION_PASSED original failure reproduced; corrected full login parsed')
