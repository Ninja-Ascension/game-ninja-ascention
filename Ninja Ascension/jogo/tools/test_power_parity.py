"""Parity with the unmodified Lua power formula, on temporary SQLite only."""
import os,sys,tempfile,json,ctypes
from pathlib import Path
root=Path(__file__).resolve().parents[1];sys.path.insert(0,str(root/'port/server'))
os.environ['NR_ENABLE_TUTORIAL']='0'
with tempfile.TemporaryDirectory(prefix='power-parity-',dir=root/'build') as folder:
 os.environ['NR_ACCOUNTS_DIR']=folder
 import local_server as server,hero_power_local as power,hero_stats_local as stats,recruitment_local as heroes,hero_development_local as dev,ranking_local as rank
 db=server.BANCO
 vectors=[]
 try:
  for name in ('power_a','power_b'):
   account=db.criar_conta(name,'Temporary123!')['id'];server._sessao_conexao['token']=db.abrir_sessao(account)
   server.resposta_login_init('1','')
   for stage in (0,1):
    for ship,mould in heroes.all_owned(db,account):
     if stage:
      state=dev.state(db,account,ship,mould);state['star']=min(7,state['star']+1);state['skills']=[10,5,1,1,1,1]
      with db._conn:
       db._conn.execute('INSERT OR REPLACE INTO local_ship_rank VALUES (?,?,0,100)',(account,ship))
       db._conn.execute('INSERT OR REPLACE INTO local_hero_development VALUES (?,?,?)',(account,ship,json.dumps(state)))
     e=stats.effective(db,account,ship,mould);d=dev.state(db,account,ship,mould);r=stats.data.tabela('ship_mould.txt')[str(mould)]
     row={k:r[i] for k,i in [('initial_critical',16),('initial_jink',18),('initial_critical_resist',17),('initial_retain',20),('initial_accuracy',19),('initial_retain_break',21),('leader',9),('force',10)]}
     ship_data=dict(ship_template_id=str(mould),ship_base_health=e['health'],ship_base_courage=e['courage'],ship_base_intellect=e['intellect'],skillLevel=','.join(map(str,d['skills'])),StarRating=d['star'])
     vectors.append(dict(row=row,ship=ship_data,expected=power.character(db,account,ship,mould)))
    owned=heroes.all_owned(db,account);slots=set(heroes._slots_locked(db,account))
    assert rank.power(db,account)==sum(power.character(db,account,s,m) for s,m in owned if str(s) in slots)
    actual=rank.ships(db,account)
    assert actual[0][0]==max(power.character(db,account,s,m) for s,m in owned)
    tokens=rank.strongest_tokens(db,account,1,100)
    assert int(tokens[4])==actual[0][0]
  fixture=Path(folder)/'vectors.json';fixture.write_text(json.dumps(vectors,separators=(',',':')))
  source=(root/'01_conteudo_apk/assets/src/client/loader/EnvironmentDatas.lua').read_text(encoding='utf8')
  a=source.index('function calPowerForNotOwn(');formula=source[a:source.index('function getShipByTalent(',a)]
  coeff,demands=power.config()
  lua_source=r'''
assert(loadfile(DECODER))()
local file=assert(io.open(FIXTURE,'r'));local vectors=json.decode(file:read('*a'));file:close()
local coefficients=COEFFICIENTS
local demandText=DEMANDS
zstring={split=function(text) local a={};for word in text:gmatch('[^,]+') do a[#a+1]=word end;return a end}
local active
ship_mould={};for _,name in ipairs({'initial_critical','initial_jink','initial_critical_resist','initial_retain','initial_accuracy','initial_retain_break','leader','force'}) do ship_mould[name]=name end
fight_config={attribute=1};ship_config={param=1}
dms={ship_mould={},fight_config={},ship_config={},element=function() return active end,atof=function(row,key) return tonumber(row[key]) end,float=function(_,id) return coefficients[id-11] end,string=function() return demandText end}
FORMULA
for _,vector in ipairs(vectors) do active=vector.row;assert(calPowerForNotOwn(vector.ship)==vector.expected,'server and original client formula differ') end
print('POWER_PARITY_PASSED '..#vectors..' original Lua formula vectors; ranking, strongest ninja and formation sum agree')
'''.replace('DECODER',json.dumps((root/'01_conteudo_apk/assets/src/cocos/cocos2d/json.lua').as_posix()),1).replace('FIXTURE',json.dumps(fixture.as_posix()),1).replace('COEFFICIENTS','{'+','.join(map(str,coeff))+'}',1).replace('DEMANDS',json.dumps(','.join(map(str,demands))),1).replace('FORMULA',formula,1)
  lua=ctypes.CDLL(str(root/'build/windows-release/bin/NinjaResourceProbe/Release/lua51.dll'))
  lua.luaL_newstate.restype=ctypes.c_void_p;lua.luaL_openlibs.argtypes=[ctypes.c_void_p];lua.luaL_loadstring.argtypes=[ctypes.c_void_p,ctypes.c_char_p];lua.lua_pcall.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int];lua.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];lua.lua_tolstring.restype=ctypes.c_char_p;lua.lua_close.argtypes=[ctypes.c_void_p]
  state=lua.luaL_newstate()
  try:
   lua.luaL_openlibs(state);status=lua.luaL_loadstring(state,lua_source.encode())
   if not status:status=lua.lua_pcall(state,0,0,0)
   if status:raise AssertionError(lua.lua_tolstring(state,-1,None).decode())
  finally:lua.lua_close(state)
 finally:db.fechar()
