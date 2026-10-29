"""Original opening effect must finish before x1/x10 result revelation."""
import os,subprocess,sys
from pathlib import Path
root=Path(__file__).resolve().parents[1]
subprocess.run([sys.executable,str(root/'tools/test_normal_recruit.py')],cwd=root,check=True,capture_output=True)
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
for mode in ('single','ten'):
    env={k:v for k,v in os.environ.items() if not k.startswith('NR_PROBE_')}
    env.update(NR_ENABLE_TUTORIAL='0',NR_PROBE_NORMAL_RECRUIT='1',NR_PROBE_RECRUIT_UI='1',NR_PROBE_NO_DIALOG='1',NR_PROBE_TEST_MODE='host',NR_PROBE_BOOT_MAP='1',NR_PROBE_MENU_TEST='1')
    if mode=='single':env['NR_PROBE_RECRUIT_SINGLE_UI']='1'
    run=subprocess.run([str(exe)],cwd=exe.parent,env=env,capture_output=True,timeout=45)
    output=run.stdout.decode('utf8',errors='replace')
    (root/('build/recruit-animation-'+mode+'.log')).write_text(output,encoding='utf8')
    assert run.returncode==0 and 'NORMAL_RECRUIT_NATIVE_PASSED' in output,output[-3500:]
    assert not any(marker in output for marker in ('LUA ERROR:','Legacy Spine callback:','MENU_BOOT_PROBE_RESULT false')),output[-3500:]
    print('RECRUIT_ORIGINAL_ANIMATION_ORDER_PASSED',mode,flush=True)
