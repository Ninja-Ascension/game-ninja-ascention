"""Native tests using isolated profiles; never overwrites the user's saved layout."""
from pathlib import Path
import json, os, subprocess, sys, uuid
root=Path(__file__).resolve().parents[1]
out=root/'build'/('layout-tests-'+uuid.uuid4().hex)
out.mkdir(parents=True)
exe=root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/NinjaResourceProbe.exe'
store=root/'build/windows-probe-native/Debug/LayoutOverridesTests.exe'
results=[]
def run(name,args,env=None):
    try:
        p=subprocess.run([str(x) for x in args],cwd=exe.parent,env=env,capture_output=True,timeout=30)
        stdout=p.stdout.decode('utf8','replace');stderr=p.stderr.decode('utf8','replace')
        if name=='render-contract' and ('NATIVE_RENDER_CONTRACT_PASSED' not in stdout or 'NATIVE_SPINE_BRIDGE_PASSED' not in stdout or 'MENU_RESOURCE_LOADING_PASSED' not in stdout or 'ADDITIVE_EFFECT_CONTRACT_PASSED' not in stdout):
            p.returncode=2
        (out/(name+'.stdout.log')).write_text(stdout,encoding='utf8')
        (out/(name+'.stderr.log')).write_text(stderr,encoding='utf8')
        results.append({'test':name,'exit_code':p.returncode,'stdout':stdout,'stderr':stderr})
        print(name,'exit',p.returncode,flush=True)
        if p.returncode:print(stderr[-4000:],stdout[-1000:],flush=True)
        return p.returncode==0
    except subprocess.TimeoutExpired:
        results.append({'test':name,'error':'timeout 30 seconds'});print(name,'TIMEOUT',flush=True);return False
ok=run('store-contracts',[store,out/'store'])
env=os.environ.copy();env['NR_PROBE_NO_DIALOG']='1';env['NR_PROBE_LAYOUT_FILE']=str(out/'integration-layout.json');env['NR_PROBE_SHOT']=str(out)
env['NR_PROBE_TEST_MODE']='write'
write_ok=run('native-write-restore-reload',[exe],env);ok=write_ok and ok
if write_ok:
    env['NR_PROBE_TEST_MODE']='read';ok=run('native-restart-load',[exe],env) and ok
env=os.environ.copy();env['NR_PROBE_NO_DIALOG']='1';env['NR_PROBE_LAYOUT_FILE']=str(out/'battle-layout.json');env['NR_PROBE_SHOT']=str(out)
env['NR_PROBE_BATTLE_REPORT']='1'  # Etapa-3 slice 1: original simulator headless run in the same battle smoke
env['NR_PROBE_TEST_MODE']='battle';ok=run('battle-smoke',[exe],env) and ok
env=os.environ.copy();env['NR_PROBE_NO_DIALOG']='1';env['NR_PROBE_LAYOUT_FILE']=str(out/'bootmap-layout.json');env['NR_PROBE_SHOT']=str(out)
env['NR_PROBE_TEST_MODE']='battle';env['NR_PROBE_BOOT_MAP']='1'
run('boot-map-analysis',[exe],env)  # exploratory M2 probe: never folds into ok
env=os.environ.copy();env['NR_PROBE_NO_DIALOG']='1';env['NR_PROBE_LAYOUT_FILE']=str(out/'host-layout.json');env['NR_PROBE_SHOT']=str(out)
env['NR_PROBE_TEST_MODE']='host';env['NR_PROBE_BOOT_MAP']='1';env['NR_PROBE_LINT']='host_logo.lua'
run('logo-host',[exe],env)  # exploratory M2 milestone: never folds into ok
env['NR_PROBE_RENDER_TEST']='1'
ok=run('render-contract',[exe],env) and ok
(out/'results.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf8')
print('RESULTS:',out,flush=True)
sys.exit(0 if ok else 1)
