"""Native guide, original Draw x1 callback, reward animation and relogin."""
from pathlib import Path
import os,sys,subprocess,uuid
root=Path(__file__).resolve().parents[1]
subprocess.run([sys.executable,str(root/'tools/test_recruitment_local.py')],cwd=root,check=True,capture_output=True)
output=root/'build'/('recruit-native-'+uuid.uuid4().hex)
output.mkdir()
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
cases=[('guide','NR_PROBE_GUIDE_TEST',['TUTORIAL_GUIDE_NATIVE_PASSED']),
       ('draw','NR_PROBE_RECRUIT_TEST',['RECRUITMENT_NATIVE_PASSED','RECRUITMENT_FORMATION_NATIVE_PASSED','RECRUITMENT_CONFIRM_NATIVE_PASSED','RECRUIT_HERO_VISIBLE_NATIVE_PASSED']),
       ('restore','NR_PROBE_RECRUIT_RESTORE',['RECRUITMENT_RELOGIN_NATIVE_PASSED'])]
for name,flag,markers in cases:
    env=os.environ.copy()
    for key in ('NR_PROBE_GUIDE_TEST','NR_PROBE_RECRUIT_TEST','NR_PROBE_RECRUIT_RESTORE',
                'NR_PROBE_SKIP_UI','NR_PROBE_LOGIN_REPLY','NR_PROBE_CAMPAIGN_REPLY'):
        env.pop(key,None)
    env.update(NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',
               NR_PROBE_MENU_TEST='1',NR_PROBE_SHOT=str(output),
               NR_PROBE_LAYOUT_FILE=str(output/'layout.json'))
    env[flag]='1'
    run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=35)
    text=run.stdout.decode('utf8',errors='replace')
    (output/(name+'.log')).write_text(text,encoding='utf8')
    screenshot=output/'logo-host-shot.png'
    if screenshot.exists():screenshot.rename(output/(name+'.png'))
    assert run.returncode==0 and all(marker in text for marker in markers),text[-4000:]
    assert 'MENU_BOOT_PROBE_RESULT false' not in text and 'LUA ERROR:' not in text
    print('RECRUITMENT_NATIVE',name,'PASSED',flush=True)
print('RECRUITMENT_NATIVE_RESULTS',output,flush=True)
