"""Exercise installation order, including callbacks registered inside original methods."""
from pathlib import Path
import ctypes, json
root=Path(__file__).resolve().parents[1]
script='package.path='+json.dumps((root/'port/lua/?.lua').as_posix())+"..';'..package.path\n"+r'''
local numbers=require('numeros_flutuantes')
local panel=require('painel_de_dano')
local function create(path)
 return {setFrameEventCallFunc=function(self,fn) self.callback=fn end}
end
csb={createTimeline=create}
local function check(module,method,path,emitted,expected)
 local action,seen
 local class={}
 class[method]=function(self)
  action=csb.createTimeline(path)
  action:setFrameEventCallFunc(function(frame) seen=frame:getEvent() end)
  if self.fail then error('original failure') end
  return 'preserved'
 end
 module.install(class)
 assert(class[method]({})=='preserved')
 assert(csb.createTimeline==create,'timeline factory leaked')
 local frame={getEvent=function() return emitted end}
 action.callback(frame)
 assert(seen==expected,'translation installed AFTER original callback registration')
 assert(frame:getEvent()==emitted,'frame mutation leaked')
 local ok,err=pcall(class[method],{fail=true})
 assert(not ok and tostring(err):find('original failure',1,true))
 assert(csb.createTimeline==create,'factory leaked after exception')
end
check(numbers,'drawAntNumber','battle/battle_combo.csb','close','over')
check(numbers,'drawAntNumber','battle/battle_combo_1.csb','close','over')
check(panel,'onEnterTransitionFinish','battle/injury_settlement.csb',
 'zongshanghai_move_xs_over','zongshanghai_move_over')
check(panel,'onEnterTransitionFinish','battle/injury_settlement_0.csb',
 'zongshanghai_move_xs_over','zongshanghai_move_over')
print('DAMAGE_HOOK_ORDER_PASSED both camps, original registration, return values, exception cleanup')
local wait=require('tutorial_tap_wait')
local tutorial=true
missionIsOver=function() return not tutorial end
local finishes,damage,turns=0,0,0
local team={hero={roleCamp=0},hurtTimes=0}
function team:updateMaster() self.hurtTimes=2 end
function team:teamFightEnd() finishes=finishes+1 end
function team:skeepTeamFight()
 for i=1,self.hurtTimes do damage=damage+1 end
 self.hurtTimes=0
 self:teamFightEnd()
end
wait.installTeam(team)
fwin={find=function() return team end}
local qte={qteToAutoNextAttackRole=function() turns=turns+1 end}
wait.installQTE(qte)
local resets=0
qte.totalHurtRoot={}
qte.updateDrawPowerSkillTotalDamage=function(self,value)
 assert(value==0);resets=resets+1
end
fwin.find=function(self,name)
 if name=='FightQTEControllerClass' then return qte end
 return team
end
team:updateMaster()
team:teamFightEnd();qte:qteToAutoNextAttackRole()
assert(finishes==0 and turns==0,'Tutorial advanced before TAP')
team:skeepTeamFight();qte:qteToAutoNextAttackRole()
assert(finishes==1 and damage==2 and turns==1,'TAP failed to release original flow')
assert(resets==1,'Total DMG was not cleared at skill completion')
tutorial=false
team:updateMaster();team:teamFightEnd()
assert(finishes==2,'Normal battle was forced to wait')
tutorial=true;team.hero.roleCamp=1
team:updateMaster();team:teamFightEnd()
assert(finishes==3,'Enemy skill was forced to wait')
_ED={user_info={user_grade='1',user_experience='0'},_scene_npc_id='1196'}
tutorial=false;team.hero.roleCamp=0
team:updateMaster();team:teamFightEnd()
assert(finishes==3,'Between-step tutorial state bypassed TAP')
local guardCalls=0
furyGuardTick=function() guardCalls=guardCalls+1 end
wait.installGuard();furyGuardTick()
assert(guardCalls==0,'Introduction watchdog forced automatic progress')
team:skeepTeamFight()
_ED._scene_npc_id=1200
furyGuardTick()
assert(guardCalls==1,'Unrelated watchdog changed')
print('TUTORIAL_TAP_WAIT_PASSED tutorial wait, original TAP, automatic selection, normal battles, enemies')
local visual=require('combat_visual_end')
local countBefore=resets
local role={cleanAttackData=function() assert(resets==countBefore);return 7 end}
visual.install(role,'cleanAttackData',false)
assert(role:cleanAttackData()==7 and resets==countBefore+1,'Attack end left Total DMG visible')
countBefore=resets
local controller={nextBattle=function() assert(resets==countBefore+1);return 'wave' end}
visual.install(controller,'nextBattle',true)
assert(controller:nextBattle()=='wave','Wave transition return changed')
print('TOTAL_DAMAGE_BOUNDARIES_PASSED attack completion and next wave')
local kept=false
cc={nrKeepAliveFrame=function(self) kept=true end}
fwin.registerNodeEvent=function(self,window) window:onUpdate() end
local lifetime=require('window_update_lifetime')
lifetime.install()
fwin:registerNodeEvent({onUpdate=function() assert(kept,'Window updated without frame retain') end})
print('WINDOW_LIFETIME_PASSED guard precedes original callback')
local pending
local cache={}
cc.TextureCache={addImageAsync=function(self,path,callback)
 assert(self==cache and path=='asset.png');pending=callback
end}
require('texture_async_compat').armar()
local owner,texture={},{}
local calls=0
cc.TextureCache.addImageAsync(cache,'asset.png',function(target,tex)
 assert(target==owner and tex==texture);calls=calls+1
end,owner,false,true)
assert(calls==0,'Legacy async callback ran synchronously')
pending(texture);assert(calls==1,'Legacy loader did not complete')
cc.TextureCache.addImageAsync(cache,'asset.png',function(tex) assert(tex==texture) end)
pending(texture)
print('TEXTURE_ASYNC_PASSED legacy target, delayed callback, native signature')
local menuPath=package.path:match('^(.-)/port/lua/%?%.lua')..'/01_conteudo_apk/assets/src/client/home/Menu.lua'
local file=assert(io.open(menuPath,'rb'));local source=file:read('*a');file:close()
local first=assert(source:find('function Menu:onUpdate(dt)',1,true))
local last=assert(source:find('function Menu:onExit',first+1,true))
Menu={}
assert(loadstring(source:sub(first,last-1),'@'..menuPath))()
__lua_project_id=27;__lua_project_l_naruto=27
zstring={tonumber=tonumber}
_ED={user_info={max_user_food='60',user_food='1'},time_add_or_sub=0,_next_energy_recover_time=''}
local realTime=os.time;os.time=function() return 1000 end
local function menuInstance() return {_is_onenter=true,_is_running_state=0,keepAcliveInterval=1000} end
assert(not pcall(Menu.onUpdate,menuInstance(),0.1),'Original invalid timer must reproduce error')
require('menu_energy_compat').install(Menu)
local polls=0
NetworkManager={register=function() polls=polls+1 end}
protocol_command={keep_alive={code=1}}
for _,clock in ipairs({'','invalid','2000000',2000000}) do
 _ED._next_energy_recover_time=clock
 local menu=menuInstance();Menu.onUpdate(menu,0.1)
 assert(menu._is_running_state==1,'Menu progression interrupted by timer')
end
assert(polls==0,'Unknown/future clock caused recovery polling')
_ED._next_energy_recover_time='900000';Menu.onUpdate(menuInstance(),0.1)
assert(polls==1,'Valid elapsed recovery timer ignored')
_ED._next_energy_recover_time=''
local menu=menuInstance();menu.keepAcliveInterval=0;Menu.onUpdate(menu,0.1)
assert(polls==2,'Normal heartbeat disabled')
os.time=realTime
print('MENU_ENERGY_PASSED original error, missing/invalid/numeric clocks, menu progression, heartbeat')
_ED={user_info={user_grade='1',user_experience='0'},_scene_npc_id=1196}
local battle,oldMenu={},{}
local closed,cleaned=0,0
fwin={_background={},_view={},_viewdialog={},_ui={}}
function fwin:find(name)
 if name=='FightSceneClass' then return battle end
 if name=='MenuClass' then return oldMenu end
end
function fwin:close(window) assert(window==oldMenu);closed=closed+1;oldMenu=nil end
function fwin:cleanView(layer) cleaned=cleaned+1;battle=nil end
cc.FileUtils={getInstance=function() return {getWritablePath=function()
 return menuPath:gsub('/01_conteudo_apk/.*$','/build/')
end} end}
local registered=false
app={load=function(name) assert(name=='client.home.Menu');registered=true end}
state_machine={find=function(name) if registered then return {} end end,excute=function(name,...)
 assert(registered,'Original menu module never loaded')
 assert(name=='menu_window_open_mission' and cleaned==4 and closed==1)
 oldMenu={}
 return 'original tutorial flow'
end}
require('intro_menu_transition').install()
assert(state_machine.excute('menu_window_open_mission',0,0)=='original tutorial flow')
assert(cleaned==4 and closed==1,'Arena/stale menu survived final transition')
assert(state_machine.excute('menu_window_open_mission',0,0)=='original tutorial flow')
assert(cleaned==4,'Transition cleanup repeated after leaving battle')
battle={};registered=false
app.load=function() end
local menuBefore=oldMenu
assert(not pcall(state_machine.excute,'menu_window_open_mission',0,0))
assert(cleaned==4 and oldMenu==menuBefore,'Missing menu command cleared the screen')
print('INTRO_MENU_TRANSITION_PASSED original event, battle cleanup, stale menu, no repeated cleanup')
local page={}
local deferred
local scheduler={scheduleScriptFunc=function(self,fn) deferred=fn;return 1 end,
 unscheduleScriptEntry=function(self,id) assert(id==1) end}
cc.Director={getInstance=function() return {getScheduler=function() return scheduler end} end}
ccui={PageView={},RichText={},Helper={seekWidgetByName=function(self,root,name) return root[name] end}}
local opened,entered=false,0
local baseEnter=function() end
LDuplicateWindow={super={onEnterTransitionFinish=baseEnter},onEnterTransitionFinish=baseEnter}
fwin={find=function(self,name) if opened then return {} end end}
state_machine={unlock=function() end,excute=function(name,...)
 if name=='lduplicate_window_manager' then opened=true
 elseif name=='lduplicate_window_pve_quick_entrance' then
  assert(LDuplicateWindow._pageViews==page);entered=entered+1
 end
end}
app={load=function() end}
require('pve_entry_ready').install()
assert(not LDuplicateWindow.__nr_pve_ready,'Partial class inherited method was patched too early')
LDuplicateWindow.onEnterTransitionFinish=function()
 LDuplicateWindow._pageViews=page;LDuplicateWindow._pageViewsElite=page;LDuplicateWindow._pageViewsEm=page
end
require('pve_entry_ready').install()
state_machine.excute('lduplicate_window_pve_quick_entrance',0,{_type=1,_sceneId=1})
assert(opened and entered==0,'PVE entry consumed uninitialized widgets')
LDuplicateWindow:onEnterTransitionFinish()
assert(entered==0 and deferred,'Chapter entry must wait until native transition traversal finishes')
deferred()
assert(entered==1,'PVE entry did not resume when ready')
local pages={{},{}}
local view=setmetatable({getItems=function() return pages end,getItem=function(self,i) return pages[i+1] end,
 getCurrentPageIndex=function() return 0 end,addTouchEventListener=function(self,fn) self.touch=fn end,
 getTouchBeganPosition=function() return {x=60} end,getTouchEndPosition=function() return {x=30} end,
 scrollToPage=function(self,i) self.destination=i end},{__index=ccui.PageView})
assert(view:getPages()==pages and view:getPage(0)==pages[1] and view:getCurPageIndex()==0)
view:setCustomScrollThreshold(20);view.touch(view,0);view.touch(view,2)
assert(view.destination==1,'Legacy swipe distance must select next page')
local widget={PageView_pve_map_pr2=page}
assert(ccui.Helper:seekWidgetByName(widget,'PageView_pve_map')==page)
assert(ccui.Helper.seekWidgetByName(widget,'PageView_pve_map')==page)
assert(ccui.Helper:seekWidgetByName(nil,nil)==nil)
print('PVE_ENTRY_READY_PASSED deferred entry, ready event, actual widget aliases, optional names')
_ED={active_activity={}}
local signCalls,starCalls=0,0
getEveryDaySignCenterAllTips=function() signCalls=signCalls+1;return true end
constellationRedotData=function() starCalls=starCalls+1 end
require('campaign_runtime').install()
require('campaign_runtime').install()
assert(getEveryDaySignCenterAllTips()==false)
constellationRedotData()
assert(signCalls==0 and starCalls==0)
_ED.active_activity[38]={};_ED.constellation_info={}
assert(getEveryDaySignCenterAllTips()==true);constellationRedotData()
assert(signCalls==1 and starCalls==1,'Optional services lost their original behavior')
print('CAMPAIGN_RUNTIME_PASSED missing online services and available original handlers')
local skip=require('tutorial_battle_skip')
local fight={_scene_id=1,_difficulty=1}
local pending,code,cleared,opened,cleaned=nil,nil,0,0,0
_ED={user_info={user_grade='2'},battleData={battle_init_type=0,objId='1'},
 _scene_npc_id=1,_fightModule={star=1}}
fwin={_background={},_view={},_viewdialog={},_ui={},
 find=function(self,name) if name=='FightClass' then return fight end end,
 cleanView=function() cleaned=cleaned+1 end}
clearMission=function() cleared=cleared+1 end
app={load=function(name) assert(name=='client.home.Menu') end}
state_machine={excute=function(name) assert(name=='menu_window_open_mission');opened=opened+1 end}
protocol_command={get_resource={code=91},battle_result_verify={code=284}}
NetworkManager={register=function(self,id,a,b,c,node,callback)
 assert(node==fight);code=id;pending=callback
end}
assert(skip.skip() and code==284 and not skip.skip(),'Duplicate skip submitted twice')
assert(protocol_command.battle_result_verify.param_list=='1\r\n1-1\r\n1\r\n1\r\n1\r\n0,0,0,0')
assert(cleared==0 and opened==0,'Left battle before server confirmation')
pending({RESPONSE_SUCCESS=false,PROTOCOL_STATUS=-1})
assert(not fight.__nr_skip_pending and opened==0,'Failure lost the battle')
assert(skip.skip());pending({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(opened==1 and cleared==1 and cleaned==4 and _ED._fightModule==nil)
fight={};_ED._fightModule={};_ED._scene_npc_id=1196;_ED.user_info.user_grade='1'
assert(skip.skip() and code==91 and protocol_command.get_resource.param_list=='8-0,1')
pending({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(opened==2 and cleared==2,'Intro skip did not return through original menu mission')
_ED._fightModule={};fight={};_ED._scene_npc_id=9
assert(not skip.skip(),'Skip leaked into unrelated mission')
_ED._scene_npc_id=1;_ED.user_info.user_grade='7'
assert(not skip.skip(),'Skip remained enabled beyond initial tutorial')
_ED.user_info.user_grade='2';_ED.battleData.battle_init_type=11
assert(not skip.skip(),'Skip enabled in PvP')
print('TUTORIAL_SKIP_PASSED intro, authenticated settlement payload, double click, failure retry, scope')
local nodes={}
local function panel()
 return {touch=true,setBackGroundColorOpacity=function(self,v) self.fill=v end,
 setBackGroundColorType=function(self,v) self.kind=v end,setOpacity=function(self,v) self.opacity=v end}
end
for _,name in ipairs({'Panel_3','Panel_4','Panel_5','Panel_6','Panel_7','Panel_black',
 'Image_1','Image_1_0','Image_1_0_0','Image_1_0_0_0','Image_1_0_0_0_0'}) do nodes[name]=panel() end
ccui.Helper.seekWidgetByName=function(self,root,name) return nodes[name] end
local guideClass={showWindow=function() nodes.Panel_4.fill=255 end}
require('tutorial_guide_visual').install(guideClass)
require('tutorial_guide_visual').install(guideClass)
local guide={roots={panel()}}
guideClass.showWindow(guide)
assert(nodes.Panel_4.fill==0 and nodes.Panel_4.touch==true)
assert(nodes.Image_1_0_0_0_0.opacity==0 and nodes.Panel_black.opacity==0)
guideClass.showWindow(guide)
assert(nodes.Panel_4.fill==0,'Reused guide restored its opaque fill')
print('TUTORIAL_GUIDE_PASSED background, all five corners, input preserved, guide reuse')
local loader={visible=true,isVisible=function(self)return self.visible end,getParent=function()return nil end}
fwin={find=function()return loader end}
tolua={isnull=function(node)return node.dead==true end}
local updates=0
local gateClass={showWindow=function(self)self.visible=true;return 'shown' end,
 onUpdate=function()updates=updates+1;return 'updated' end}
require('tutorial_loading_gate').install(gateClass)
require('tutorial_loading_gate').install(gateClass)
local dialog={isVisible=function(self)return self.visible end,setVisible=function(self,value)self.visible=value end}
assert(gateClass.showWindow(dialog)=='shown' and dialog.visible==false)
gateClass.onUpdate(dialog);gateClass.onUpdate(dialog)
assert(updates==0 and dialog.visible==false,'Dialogue advanced during loading')
loader.visible=false
assert(gateClass.onUpdate(dialog)=='updated' and dialog.visible==true and updates==1)
loader.visible=true
gateClass.onUpdate(dialog);assert(updates==1 and dialog.visible==false)
loader.dead=true
gateClass.onUpdate(dialog);assert(updates==2 and dialog.visible==true)
print('TUTORIAL_LOADING_GATE_PASSED deferred display, paused step, restored dialogue, destroyed loader')
local deferred,closed,opened={},0,0
app={load=function()end}
cc.FileUtils={getInstance=function()return {getWritablePath=function()return '' end} end}
fwin={addService=function(self,job)deferred[#deferred+1]=job.callback end,
 close=function(self,node)closed=closed+1 end,find=function()return nil end}
state_machine={excute=function(name)assert(name=='menu_window_open_mission');opened=opened+1 end}
_ED={user_info={user_id='52',user_grade='3',user_experience='0'}}
local checks=0
local loadingClass={checkLoginLoading=function()checks=checks+1 end,
 loadingActivity=function()end,loadingFormation=function()end}
require('battle_lifecycle').installLoading(loadingClass)
local nested={totalNum=8};local owner={LoginLoading=nested}
loadingClass.checkLoginLoading(nested,owner,false)
loadingClass.checkLoginLoading(nested,owner,false)
assert(checks==0 and #deferred==1 and owner._unload==true)
deferred[1]();assert(closed==1 and opened==1)
_ED.user_info.user_grade='1'
loadingClass.checkLoginLoading({totalNum=8},{},false)
assert(checks==1,'Fresh account flow was intercepted')
_ED.user_info.user_grade='3'
loadingClass.checkLoginLoading({totalNum=8},{},false)
assert(checks==2,'Ordinary battle was intercepted')
-- Regression: before the login reply is parsed _ED.user_info does not exist
-- (ProtocolParserCopy assigns it at :182 only). The loader polls every frame,
-- so indexing it raised "attempt to compare number with nil" in onUpdate and
-- the real account froze at 8%. These calls must stay harmless.
_ED.user_info=nil
local fresh={totalNum=8}
assert(pcall(loadingClass.checkLoginLoading,fresh,{LoginLoading=fresh},false),
 'Missing profile crashed the loading poll')
assert(checks==3 and #deferred==1,'Pre-login frames changed the route')
assert(fresh._unload==nil,'Pre-login frame retired the live loader')
_ED.user_info={user_id='',user_grade='',user_experience=''}  -- pre-login defaults
local blank={totalNum=8}
assert(pcall(loadingClass.checkLoginLoading,blank,{LoginLoading=blank},false))
assert(checks==4 and #deferred==1,'Empty identity treated as a restored account')
_ED.user_info={user_id='52',user_grade='3',user_experience='0'}
local restored={totalNum=8}
assert(pcall(loadingClass.checkLoginLoading,restored,{LoginLoading=restored},false))
assert(#deferred==2,'Restored account redirected only after login_init')
local saved=_ED;_ED=nil
assert(pcall(loadingClass.checkLoginLoading,{totalNum=8},{},false),'Missing _ED crashed the poll')
_ED=saved
_ED.user_info={user_id='52',user_grade='3',user_experience='0'}
loadingClass.checkLoginLoading({totalNum=8},nil,true)
assert(checks==6,'LoginLoading onUpdate without owner was intercepted')
print('SAVED_LOGIN_ROUTE_PASSED restored level, retire loader, original menu, one callback, fresh and normal battle preserved')
local lateCalls=0
local battleClass={onAddLoginLoading=function()end,onUpdate=function()lateCalls=lateCalls+1 end}
require('battle_lifecycle').installBattleLoader(battleClass)
local late={LoginLoading={totalNum=9},_unload=true,isBeginLoad=false}
_ED.user_info=nil
battleClass.onUpdate(late);assert(lateCalls==1)
_ED.user_info={user_id='56',user_grade='4',user_experience='0'}
battleClass.onUpdate(late);battleClass.onUpdate(late)
assert(lateCalls==1 and #deferred==3,'Late profile remained stuck at 9% or scheduled twice')
deferred[3]();assert(opened==2)
battleClass.onUpdate({isBeginLoad=false});assert(lateCalls==2)
print('LATE_PROFILE_RESUME_PASSED missing profile, paused 9 percent, single menu transition, normal battle preserved')
mission_id=1;mission_off=7;mission_progress=10
local lessons={};local fifth={{[1]='5',[10]='30506'}};local sixth={{[1]='6',[10]='30601'}}
dms={mission3=lessons,searchs=function(source,column,value)
 if column==mission_id and value==5 then return fifth end
 if value=='l5e0' then return sixth end
 return {{[1]='1',[10]='30101'}}
end}
local resume=require('tutorial_resume');resume.install()
_ED.user_info={user_id='56',new_user_teach_record={nr_local_resume={'nr_local_resume','56,5,30506'}}}
resume.restore()
assert(dms.searchs(lessons,mission_off,'l1e0')~=fifth,'Old lesson forced over a different natural trigger')
assert(dms.searchs(lessons,mission_off,'l5e0')==sixth,'Newer natural lesson was rewound')
_ED.user_info.user_id='55';resume.restore()
assert(dms.searchs(lessons,mission_off,'l1e0')~=fifth,'Checkpoint crossed accounts')
print('TUTORIAL_RESUME_PASSED original lesson reconstruction, no rewind, account isolation')
local hidden={isVisible=function()return false end,isEnabled=function()return true end}
local shown={isVisible=function()return true end,isEnabled=function()return true end}
local target=require('tutorial_synthesis_target')
local rows={{child1={heroInstance={},roots={hidden}},child2={prop=2,roots={shown}}}}
local index,side=target.find(rows,function(root)return root end)
assert(index==1 and side==2,'Guide targeted the owned Naruto instead of a synthesis button')
assert(target.find({{child1={prop=2,roots={hidden}}}},function(root)return root end)==nil)
print('TUTORIAL_SYNTHESIS_TARGET_PASSED owned card excluded, visible eligible target, hidden button excluded')
local plus={}
for i=1,6 do plus['Panel_234_add_'..i]={setVisible=function(self,value)self.visible=value end} end
require('formation_empty_slots').apply({roots={{}}},function(_,name)return plus[name]end,{'1','0','2','0','0','0'})
assert(plus.Panel_234_add_2.visible and plus.Panel_234_add_6.visible and not plus.Panel_234_add_1.visible)
require('formation_empty_slots').apply({roots={{}}},function(_,name)return plus[name]end,{'1','2','3','4','5','6'})
for _,button in pairs(plus) do assert(button.visible==false) end
print('FORMATION_PLUS_PASSED all empty positions visible, six filled positions hidden')
print('LOADER_MISSING_PROFILE_PASSED pre-login frames, empty identity, restored redirect, absent _ED, ownerless poll')
'''
lua=ctypes.CDLL(str(root/'build/windows-probe-native/bin/NinjaResourceProbe/Debug/lua51.dll'))
lua.luaL_newstate.restype=ctypes.c_void_p
for name,args in [('luaL_openlibs',[ctypes.c_void_p]),('luaL_loadstring',[ctypes.c_void_p,ctypes.c_char_p]),('lua_pcall',[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int]),('lua_close',[ctypes.c_void_p]),('lua_tolstring',[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p])]:
 getattr(lua,name).argtypes=args
lua.lua_tolstring.restype=ctypes.c_char_p
state=lua.luaL_newstate()
try:
 lua.luaL_openlibs(state)
 code=lua.luaL_loadstring(state,script.encode())
 if not code: code=lua.lua_pcall(state,0,0,0)
 if code: raise AssertionError(lua.lua_tolstring(state,-1,None).decode('utf8','replace'))
finally: lua.lua_close(state)
