-- Offline vertical slice. Original modules execute unchanged in an allowlisted
-- environment; this file supplies fixtures, turn sequencing and a small host API.
local files=cc.FileUtils:getInstance()
local env={assert=assert,error=error,ipairs=ipairs,pairs=pairs,next=next,
    tonumber=tonumber,tostring=tostring,type=type,select=select,unpack=unpack,
    setmetatable=setmetatable,string=string,math={},table={}}
for k,v in pairs(math) do env.math[k]=v end
for k,v in pairs(table) do env.table[k]=v end
env.table.nums=function(t) local n=0;for _ in pairs(t) do n=n+1 end;return n end
env._G=env
env.__lua_project_id=27;env.__lua_project_l_naruto=27
env._ED={user_info={},healthShiftValue=0}
-- Engine bridge for sandboxed ORIGINAL modules (read-only access to the
-- axmol API surface the report framework expects; cc.dms_load is the
-- probe's file-loading alias). os/io present as in the original boot.
env.cc=cc;env.os=os;env.io=io
-- Sandboxed require/package for Lua-5.1-era modules (e.g. the original json
-- codec calls require('math'). Frozen to standard libraries; any other name
-- errors loudly instead of silently resolving.
env.package={loaded={}}
env.module=module -- Lua 5.1 module() helper (uses env.package.loaded)
env.require=function(name)
    local std={math=env.math,string=env.string,table=env.table,os=env.os,io=env.io,coroutine=coroutine,debug=env.debug}
    if std[name] then return std[name] end
    error('sandbox require: module not allowed: '..tostring(name))
end
env.class=function(name,super)
    local c={__cname=name,super=super};c.__index=c
    if super then setmetatable(c,{__index=super}) end
    function c:new(...) local v=setmetatable({},c);if v.ctor then v:ctor(...) end;return v end
    return c
end
local allowed={
    ['client.battle.report.BattleObject']=true,
    ['client.battle.report.FightUtil']=true,
    ['client.battle.report.EquipmentMould']=true,
    ['client.battle.report.BattleSkill']=true,
    ['client.battle.report.RestrainUtil']=true,
    ['client.battle.report.RestrainObject']=true,
    ['frameworks.external.aeslua.aeslua']=true,
    -- Etapa-3 slice 1: modules required by client/battle/report/BattleReport.lua
    -- to run the ORIGINAL offline environment fight (explicit allowlist, per
    -- the roadmap rule: integrar funções recuperadas e documentar dependências).
    ['frameworks.external.utils.utils']=true,
    ['frameworks.support.debug']=true,
    ['frameworks.support.state_machine']=true,
    ['frameworks.external.utils.local_datas']=true,
    ['configs.data.data_path_config']=true,
    ['client.loader.LocalDatas']=true,
    ['client.loader.EnvironmentDatas']=true,
    ['client.battle.report.ConfigDB']=true,
    ['client.battle.report.IniUtil']=true,
    ['client.battle.report.EnvironmentShipModule']=true,
    ['client.battle.report.EnvironmentShip']=true,
    ['client.battle.report.FightObject']=true,
    ['client.battle.report.FightModule']=true,
    ['client.battle.report.TalentSkill']=true,
    ['client.battle.report.TalentUniteSkill']=true,
    ['client.battle.report.TalentAura']=true,
    ['client.battle.report.TalentConstant']=true,
    ['client.battle.report.TalentImmunity']=true,
    ['client.battle.report.TalentJudge']=true,
    ['client.battle.report.TalentJudgeResult']=true,
    ['client.battle.report.TalentMould']=true,
    ['client.battle.report.BattleCache']=true,
    ['client.battle.report.Npc']=true,
    ['client.battle.report.SkillMould']=true,
    ['client.battle.report.ShipMould']=true,
    ['client.battle.report.SkillInfluence']=true,
    ['client.battle.report.EnvironmentFormation']=true,
    ['client.battle.report.RestrainMould']=true,
    ['client.battle.report.RookieCache']=true,
    ['client.battle.report.ClassInit']=true,
    ['client.battle.report.FightBuff']=true,
    ['client.battle.report.Unit']=true,
    ['client.battle.report.Ship']=true,
    ['client.battle.report.FormulaUtil']=true,
    ['client.battle.report.FormationInfo']=true,
    ['client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsHandle']=true,
    ['client.battle.fight.FightEnum']=true,
    ['client.battle.report.BattleReport']=true,
}
local loaded={}
env.app={load=function(name)
    assert(allowed[name],"Offline module not allowed: "..tostring(name))
    if loaded[name] then return end
    loaded[name]=true
    local path=name:gsub('%.','/')..'.lua'
    local chunk=assert(loadstring(cc.dms_load(path),'@'..path))
    setfenv(chunk,env);chunk()
end}
env.app.load('frameworks.external.aeslua.aeslua')
env.app.load('client.battle.report.RestrainObject')
env.app.load('client.battle.report.BattleObject')
env.app.load('client.battle.report.EquipmentMould')
env.app.load('client.battle.report.BattleSkill')
local params={}
for line in cc.dms_load('data/configs/fight_config.txt'):gmatch('[^\r\n]+') do
    local id,value=line:match('^(%d+)\t[^\t]*\t[^\t]*\t([^\t]+)')
    if id then params[tonumber(id)]=value end
end
local f1,f2=assert(params[11]):match('^(%d+),(%d+)$')
env.FightModule={frA=assert(tonumber(params[6])),frB=assert(tonumber(params[7])),
    frC=assert(tonumber(params[8])),frD=assert(tonumber(params[9])),
    frE=assert(tonumber(params[10])),frF1=assert(tonumber(f1)),frF2=assert(tonumber(f2)),
    lvf=assert(tonumber(params[19]))}
-- Independent seeded generator. Does not alter Lua's global RNG or claim APK RNG parity.
local seed=20261023
env.math.random=function(lo,hi)
    seed=(seed*16807)%2147483647
    if not lo then return (seed-1)/2147483646 end
    if not hi then hi=lo;lo=1 end
    assert(lo<=hi);return lo+(seed%(hi-lo+1))
end
local function fighter(hp,attack,defence,tag)
    local v=env.BattleObject:new()
    v.healthMaxPoint=hp;v:setHealthPoint(hp)
    v.attack=attack;v.physicalDefence=defence;v.battleTag=tag;v.campPreference=1
    v.fightObject={attack=attack,physicalDefence=defence}
    return v
end
local hero,enemy,phase,turn,lastDamage,lastActor
local function reset()
    seed=20261023
    hero=fighter(500,135,25,0);enemy=fighter(450,75,35,1)
    phase='ready';turn=1;lastDamage=0;lastActor='none'
end
local influence={skillEffectMinValue=100,skillEffectMaxValue=100}
local function hit(a,b)
    local effects={}
    env.FightUtil.computeCommonDamage({skillProperty=0},influence,a,b,effects,nil,nil,nil,{})
    local damage=assert(effects[1])
    assert(damage==damage and damage>=0 and damage<1e9,'Invalid original damage result')
    b.healthPoint=math.max(0,b.healthPoint)
    b:setDead(b.healthPoint==0)
    return damage
end
local function snapshot()
    return {phase=phase,turn=turn,heroHp=hero.healthPoint,heroMax=hero.healthMaxPoint,
        enemyHp=enemy.healthPoint,enemyMax=enemy.healthMaxPoint,
        damage=lastDamage,actor=lastActor}
end
NRBattle={}
-- Etapa 4: the CURRENT ORIGINAL data pair shared by reportTest and roundSamples
-- (kept in one place so the playback always mirrors the simulated fight).
NRBattle.battleNpcId=1  -- npc row (its wave list defends) — npc 1 has TWO waves
NRBattle.battleEveNpc=3 -- environment_formation row that ATTACKS (2 ships)
function NRBattle.dispatch(action)
    if action=='restart' then reset()
    elseif action=='start' and phase=='ready' then phase='player'
    elseif action=='attack' and phase=='player' then
        lastDamage=hit(hero,enemy);lastActor='hero';phase='player_hit'
    elseif action=='guard' and phase=='player' then
        hero.isRetain=true;phase='guard';lastDamage=0;lastActor='none'
    elseif action=='advance' and (phase=='player_hit' or phase=='guard') then
        if enemy.healthPoint<=0 then phase='victory'
        else lastDamage=hit(enemy,hero);lastActor='enemy';phase='enemy_hit' end
    elseif action=='advance' and phase=='enemy_hit' then
        hero.isRetain=false
        if hero.healthPoint<=0 then phase='defeat' else phase='player';turn=turn+1 end
    elseif action~='snapshot' then error('Invalid battle action '..tostring(action)..' in '..phase) end
    return snapshot()
end
function NRBattle.selfTest()
    reset();assert(not pcall(NRBattle.dispatch,'attack'))
    NRBattle.dispatch('start')
    local first=NRBattle.dispatch('attack');assert(first.damage>=95 and first.damage<=105)
    assert(first.enemyHp==450-first.damage and first.heroHp==500)
    assert(not pcall(NRBattle.dispatch,'attack'),'Double action accepted')
    local function finish(action)
        local guard=0
        while phase~='victory' and phase~='defeat' do
            guard=guard+1;assert(guard<150,'Battle did not terminate')
            NRBattle.dispatch(phase=='player' and action or 'advance')
        end
    end
    finish('attack');assert(phase=='victory' and enemy.healthPoint==0 and hero.healthPoint>0)
    assert(not pcall(NRBattle.dispatch,'attack'),'Action accepted after result')
    reset();NRBattle.dispatch('start');assert(NRBattle.dispatch('attack').damage==first.damage,'Restart is nondeterministic')
    reset();NRBattle.dispatch('start');finish('guard');assert(phase=='defeat' and hero.healthPoint==0)
    assert(loaded['client.battle.report.FightUtil'] and loaded['client.battle.report.BattleObject'])
    assert(not pcall(env.app.load,'client.main'),'Allowlist did not reject unrelated module')
    reset();return true
end
-- The ORIGINAL json codec is a Lua-5.1 module() file; the original boot kept
-- it as an engine global, so load it once in the engine scope as well.
local loadOriginalJson=function()
    if type(json)=='table' and type(json.decode)=='function' then return end
    local src=files:getStringFromFile('cocos/cocos2d/json.lua')
    local chunk=assert(loadstring(src,'@cocos/cocos2d/json.lua'))
    chunk()
    assert(type(json)=='table' and type(json.decode)=='function','original json codec missing json.decode')
end
-- Etapa-3 slice 1 (gated by NR_PROBE_BATTLE_REPORT): run the ORIGINAL offline
-- fight driver (client/battle/report/BattleReport.initEnvironmentFight) inside
-- this sandbox. No simulation logic is reimplemented here: this wires only the
-- ORIGINAL framework utilities the report modules require, the ORIGINAL
-- column dictionary (client/loader/LocalDatas.lua) and the ORIGINAL data
-- files, then mirrors the original driver's public API sequence and asserts
-- deterministic output under the seeded generator. Failures error loudly.
NRBattle.reportTest=function()
    assert(not loaded['client.battle.report.BattleReport'],'BattleReport already loaded without its data prerequisites')
    env.app.load('frameworks.external.utils.utils')
    env.app.load('frameworks.support.debug')
    env.debug._isOpen=true -- harness logging for framework debug.log paths
    env.cclog=function(...) print('BATTLE_DEBUG',...) end
    env.app.debug=env.debug
    env.app.load('frameworks.support.state_machine')
    env.app.state_machine=env.state_machine
    assert(type(env.app.state_machine.add)=='function','state_machine missing in sandbox')
    env.app.load('frameworks.external.utils.local_datas')
    assert(type(env.dms.load)=='function','dms framework missing')
    -- The ORIGINAL json codec (cocos/cocos2d/json.lua) uses Lua-5.1 module(),
    -- which registers in the engine registry exactly like the original boot
    -- did; load it once in the engine scope and decode the ORIGINAL app config.
    loadOriginalJson()
    env.json=json -- bridge the ORIGINAL codec into the sandbox global scope
    -- OFFLINE CAPTURE of the ORIGINAL report frames: FightModule writes every
    -- round event in the historical protocol format and hands it to
    -- NetworkProtocol.parser_func (server path). Offline there is no server:
    -- the frames are captured verbatim for the presentation layer. Nothing in
    -- the simulator is altered — this is the adapting point between the
    -- ORIGINAL simulation and the offline player.
    local reportFrames={}
    NRBattle.reportFrames=reportFrames -- slice-2 access for the native side
    env.NetworkProtocol={sequence=0}
    env.NetworkProtocol.parser_func=function(data)
        env.NetworkProtocol.sequence=env.NetworkProtocol.sequence+1
        reportFrames[#reportFrames+1]=data and data.resouce or nil
    end
    local configBytes=files:getStringFromFile('configs/app.config')
    env.app.configJson=json.decode(configBytes)
    assert(type(env.app.configJson)=='table' and env.app.configJson.PayMould~=nil,'original configs/app.config parse failed')
    env.app.load('configs.data.data_path_config')
    env.app.load('client.loader.LocalDatas')
    env.app.load('client.loader.EnvironmentDatas')
    env.dms.load('data/configs/fight_config.txt')
    env.dms.load('data/configs/play_config.txt')
    -- Pre-load the ORIGINAL data list with existence checks: some files named
    -- by the original data_path_config were not part of the recovered APK;
    -- every miss is counted and reported (never silently skipped). BattleReport's
    -- own dms.load loop then becomes a no-op through dms caching.
    assert(type(env.localData_list)=='table' and #env.localData_list>0,'localData_list empty')
    local missing={}
    for _,path in ipairs(env.localData_list) do
        if files:isFileExist(path) then env.dms.load(path)
        else
            missing[#missing+1]=path
            -- Data absent from the recovered APK: register an EMPTY table so
            -- loads do not die here; any real column access fails loudly with
            -- a nil-index error at the exact usage point. Nothing is faked.
            if env.strippath then
                local fn=env.stripExtension(env.strippath(path))
                if env.dms[fn]==nil then env.dms[fn]={} end
            end
        end
    end
    print('BATTLE_REPORT_DATA missing',#missing,'of',#env.localData_list)
    for _,path in ipairs(missing) do print('BATTLE_REPORT_DATA_MISS',path) end
    env.app.load('client.battle.report.BattleReport')
    -- _fight_run_speed: animation-acceleration values consumed by the fight
    -- PRESENTATION enums (FightEnum._enum_action_time_speed). No recovered
    -- content defines them (no assignment in src/, none in the data files),
    -- so use a NEUTRAL 1x default and mark it as such: the SIMULATION never
    -- reads this table; the real UI layer must source it when recovered.
    env._fight_run_speed={1,1,1,1,1,1}
    env.app.load('client.battle.fight.FightEnum')
    assert(type(env.BattleReport)=='table' and type(env.FightModule)=='table' and type(env.ConfigDB.load)=='function','BattleReport load incomplete')
    -- ORIGINAL driver sequence: FightModule's PVE_ELIT branch builds BOTH
    -- sides from ORIGINAL environment_formation/environment_ship data (the
    -- player-formation branch needs account data _ED.formetion, out of offline
    -- scope). Attack uses the NPC's own first environment formation: a mirror
    -- match, deterministic under the seeded generator. This mirrors the
    -- original initEnvironmentFight driver (client/battle/report/BattleReport.lua).
    -- Etapa 4: NON-mirror ORIGINAL data via the shared NRBattle pair (see
    -- top): attack = environment_formation row, defender = that npc's waves.
    local function runOnce()
        seed=20261023 -- per-run baseline: both deterministic passes share the same draws
        local fightModule=env.FightModule:new()
        env._ED._fightModule=fightModule -- original pattern: Fight.lua:495-496
        local battleCache=env.BattleCache:new()
        env._ED.user_info.battleCache=battleCache
        local resultBuffer={}
        -- Etapa 4: NON-mirror ORIGINAL data, multi-seat on BOTH sides:
        -- attack = environment_formation row 3 (two ships), defender = npc 2's
        -- own wave list (formation row 4 with FOUR ships: 2x4 real battle).
        local npcObj=env.ConfigDB.load('npc',NRBattle.battleNpcId)
        local eveNpc=NRBattle.battleEveNpc
        fightModule:initBattleField(npcObj,1,env.FightModule.FIGHT_TYPE_PVE_ELIT,resultBuffer,eveNpc)
        fightModule:initFightOrder(env._ED.user_info,{}) -- original order setup (Fight.lua:509)
        -- Etapa 4 cut 5: the ORIGINAL multi-wave driver (jumpFight) finishes
        -- every wave and advances via initBattleInfo, exactly as production.
        fightModule:jumpFight(env._ED.user_info,resultBuffer)
        assert(fightModule.hasNextRound==false,'Original fight did not terminate (jumpFight)')
        return fightModule,resultBuffer
    end
    local fm1,buf1=runOnce()
    local fm2,buf2=runOnce()
    local framesA=env.NetworkProtocol.sequence
    local waves=tonumber(env._ED.user_info.battleCache.currentBattleCount) or 0
    assert(#buf1==#buf2 and fm1.fightResult==fm2.fightResult and fm1.roundCount==fm2.roundCount,
        'Original simulator nondeterministic under the seeded generator')
    return string.format('OK rounds=%s events=%s result=%s frames=%d waves=%d missing_data_files=%d',
        tostring(fm1.roundCount),tostring(#buf1),tostring(fm1.fightResult),framesA,waves,#missing)
end
-- Slice-2 digest: the captured frames use the ORIGINAL protocol layout
-- (seq \r\n cmdname \r\n result \r\n code \r\n payload \r\n). Summarize the
-- REAL cmdname/code histogram so the presentation mapping is driven by
-- evidence, never guessed. Read-only; no simulator behavior is touched.
function NRBattle.frameDigest()
    local hist={}
    for _,frame in ipairs(NRBattle.reportFrames or {}) do
        local seq,cmd,res,code=frame:match('^([^\r\n]*)\r\n([^\r\n]*)\r\n([^\r\n]*)\r\n([^\r\n]*)')
        if cmd then
            local key=cmd..' #'..tostring(code)
            hist[key]=(hist[key] or 0)+1
        end
    end
    local parts={}
    for key,count in pairs(hist) do parts[#parts+1]=key..'='..count end
    table.sort(parts)
    return 'frames='..#(NRBattle.reportFrames or {})..' cmds='..table.concat(parts,' ')
end
-- Always available: the original simulator experience ships with the probe
-- (the automation suite sets NR_PROBE_BATTLE_REPORT explicitly for its own
-- expectations, but a plain double-click launch now gets the same features).
NRBattle.reportTest=NRBattle.reportTest -- always on for plain launches (see note above)
NRBattle.frameDigest=NRBattle.frameDigest
-- Slice-2 samples: re-run the ORIGINAL fight deterministically and record the
-- REAL simulator object state after every rountdFight step (health/dead of
-- every seat on both camps). The recovered live client animated from exactly
-- this state (FightRoleController steps rountdFight); frames were only the
-- server log. CSV: round | step | camp0 hp/dead per seat | camp1 hp/dead per seat.
function NRBattle.roundSamples()
    seed=20261023 -- reproducible samples for the same original pair
    local fightModule=env.FightModule:new()
    env._ED._fightModule=fightModule -- original pattern (Fight.lua:495)
    env._ED.user_info.battleCache=env.BattleCache:new()
    local resultBuffer={}
    local npcObj=env.ConfigDB.load('npc',NRBattle.battleNpcId)
    local eveNpc=NRBattle.battleEveNpc
    fightModule:initBattleField(npcObj,1,env.FightModule.FIGHT_TYPE_PVE_ELIT,resultBuffer,eveNpc)
    fightModule:initFightOrder(env._ED.user_info,{})
    local function matrix(camp)
        local list=camp==0 and fightModule.attackObjects or fightModule.byAttackObjects
        local t={}
        for i=1,6 do
            local o=list[i]
            t[i]=(o==nil) and '' or (tostring(o.healthPoint)..(o.isDead and 'D' or 'A'))
        end
        return t
    end
    local rows={'round,wave,step,camp0,camp1'}
    local function append(round,step,wave)
        rows[#rows+1]=table.concat({tostring(round),tostring(wave),tostring(step),
            table.concat(matrix(0),'|'),table.concat(matrix(1),'|')},',')
    end
    append(fightModule.roundCount or 0,0,0) -- initial state before any step
    -- Mirror of the ORIGINAL multi-wave driver (FightModule:jumpFight, line
    -- 5590): rountdFight per step until the wave ends, initBattleInfo to load
    -- the next wave; sampling hooks inserted between the ORIGINAL calls.
    local step=0
    local waveCount=#env._ED.user_info.battleCache.byAttackerObjectsList
    assert(waveCount>=1,'npc has no defender waves')
    while tonumber(env._ED.user_info.battleCache.currentBattleCount)<waveCount do
        local wave=tonumber(env._ED.user_info.battleCache.currentBattleCount)+1
        while fightModule.hasNextRound==true do
            step=step+1
            fightModule:rountdFight(resultBuffer)
            append(fightModule.roundCount or 0,step,wave)
        end
        if tonumber(env._ED.user_info.battleCache.currentBattleCount)<waveCount then
            fightModule:initBattleInfo(env._ED.user_info.battleCache)
        end
    end
    assert(fightModule.hasNextRound==false,'Sample run did not terminate')
    return table.concat(rows,'\n')
end
NRBattle.roundSamples=NRBattle.roundSamples -- always on
-- Etapa 5 cut 2: per-step skill identity from the module's OWN action stamp.
-- Per action the simulator resets headBuffer/bodyBuffer (2741-2742), keeps the
-- attacker in self.currentObject (2728) and logs the fired skill id in
-- bodyBuffer[3] (3013) — for normal, small and anger skills alike. Each
-- BattleObject holds its real skill_mould rows (868/871); the name is read
-- straight from skill_mould.skill_name. No #39 synthesis involved.
-- CSV: step,camp,seat,event,skillId,name
function NRBattle.skillSamples()
    seed=20261023 -- same baseline as roundSamples: identical step sequence
    local fightModule=env.FightModule:new()
    env._ED._fightModule=fightModule
    env._ED.user_info.battleCache=env.BattleCache:new()
    local resultBuffer={}
    local npcObj=env.ConfigDB.load('npc',NRBattle.battleNpcId)
    local eveNpc=NRBattle.battleEveNpc
    fightModule:initBattleField(npcObj,1,env.FightModule.FIGHT_TYPE_PVE_ELIT,resultBuffer,eveNpc)
    fightModule:initFightOrder(env._ED.user_info,{})
    assert(env.dms['skill_mould']~=nil,'skill_mould data table is not loaded')
    local function skillName(id)
        assert(env.dms.element(env.dms['skill_mould'],id)~=nil,'skill_mould row missing: '..tostring(id))
        local nm=tostring(env.dms.string(env.dms['skill_mould'],id,env.skill_mould.skill_name) or '')
        nm=nm:gsub('[,\r\n]',' ')
        if nm=='' then nm='skill '..tostring(id) end
        return nm
    end
    local rows={'step,camp,seat,event,skillId,name'}
    local step=0
    local waveCount=#env._ED.user_info.battleCache.byAttackerObjectsList
    assert(waveCount>=1,'npc has no defender waves')
    while tonumber(env._ED.user_info.battleCache.currentBattleCount)<waveCount do
        while fightModule.hasNextRound==true do
            step=step+1
            fightModule:rountdFight(resultBuffer)
            -- Attacker: identity lookup among the module's own seats (exact
            -- camp/seat match with the playback pool).
            local actor=fightModule.currentObject
            if actor~=nil then
                local camp,seat
                for i=1,6 do
                    if fightModule.attackObjects[i]==actor then camp,seat=0,i break end
                    if fightModule.byAttackObjects[i]==actor then camp,seat=1,i break end
                end
                if seat~=nil then
                    local skillId=tonumber((fightModule.bodyBuffer or {})[3])
                    if skillId~=nil and skillId>0 then
                        local event='skill'
                        if actor.commonSkillMould and tonumber(actor.commonSkillMould.id)==skillId then event='normal' end
                        if actor.specialSkillMould and tonumber(actor.specialSkillMould.id)==skillId then event='power' end
                        if actor.normalSkillMould and tonumber(actor.normalSkillMould.id)==skillId then event='small' end
                        rows[#rows+1]=step..','..camp..','..seat..','..event..','..skillId..','..skillName(skillId)
                    end
                end
            end
        end
        if tonumber(env._ED.user_info.battleCache.currentBattleCount)<waveCount then
            fightModule:initBattleInfo(env._ED.user_info.battleCache)
        end
    end
    return table.concat(rows,'\n')
end
NRBattle.skillSamples=NRBattle.skillSamples -- always on
-- Etapa 4 cut 3: inventory of playable ORIGINAL pairs for the UI list. Reads
-- only real rows: npc (defender waves) x environment_formation (attacker).
function NRBattle.battlePairs(maxPairs)
    maxPairs=maxPairs or 24
    local rows={'npcId,eveId,eveSeats'}
    local function formationSeats(fid)
        if env.dms.element(env.dms['environment_formation'],fid)==nil then return -1 end
        local n=0
        for _,key in ipairs({'seat_one','seat_two','seat_three','seat_four','seat_five','seat_six'}) do
            local col=env.environment_formation[key]
            if col and env.dms.int(env.dms['environment_formation'],fid,col)>0 then n=n+1 end
        end
        return n
    end
    local added=0
    for npcId=1,20 do
        local okN,obj=pcall(function() return env.ConfigDB.load('npc',npcId) end)
        if not okN or obj==nil or (tonumber(obj.formationCount) or 0)<1 then break end
        for eve=1,40 do
            local seats=formationSeats(eve)
            if seats>0 then
                rows[#rows+1]=npcId..','..eve..','..seats
                added=added+1
                if added>=maxPairs then return table.concat(rows,'\n') end
            end
        end
    end
    assert(added>0,'No original battle pairs found in the recovered data')
    return table.concat(rows,'\n')
end
NRBattle.battlePairs=NRBattle.battlePairs -- always on
-- Select an ORIGINAL pair with fresh loud validation (no silent fallback).
function NRBattle.setPair(npcId,eveId)
    npcId=assert(tonumber(npcId),'npcId invalid');eveId=assert(tonumber(eveId),'eveId invalid')
    assert(env.dms.element(env.dms['environment_formation'],eveId)~=nil,'formation row missing: '..eveId)
    local obj=env.ConfigDB.load('npc',npcId)
    assert(tonumber(obj.formationCount)>=1,'npc has no wave list: '..npcId)
    assert(env.dms.element(env.dms['environment_formation'],obj:getEnvironmentFormation(1))~=nil,
        'npc wave-1 formation missing: '..npcId)
    NRBattle.battleNpcId=npcId;NRBattle.battleEveNpc=eveId
    NRBattle.reportFrames=nil -- cached frames belong to the previous pair
    return string.format('npc=%d eve=%d',npcId,eveId)
end
NRBattle.setPair=NRBattle.setPair -- always on
-- Etapa 5 cut 1: REAL per-seat identity for the playback overlay, derived from
-- the same formation rows the simulator consumed (wave-by-wave on the defender
-- side). Names resolve environment_ship -> ship_name -> word_mould col 3, the
-- original resolution chain; any missing row fails loudly (no placeholder).
function NRBattle.seatRoster(wave)
    wave=tonumber(wave) or 1
    assert(env.dms['word_mould']~=nil,'word_mould data table is not loaded')
    local npc=env.ConfigDB.load('npc',NRBattle.battleNpcId)
    assert(tonumber(npc.formationCount)>=wave,'wave beyond npc formationCount: '..wave)
    local defForm=tonumber(npc:getEnvironmentFormation(wave))
    assert(env.dms.element(env.dms['environment_formation'],defForm)~=nil,
        'wave formation row missing: '..defForm)
    local function seatsOf(formRow)
        local list={}
        for _,k in ipairs({'seat_one','seat_two','seat_three','seat_four','seat_five','seat_six'}) do
            local col=env.environment_formation[k]
            local ship=(col and env.dms.int(env.dms['environment_formation'],formRow,col)) or 0
            list[#list+1]=ship>0 and ship or nil
        end
        return list
    end
    local function nameOf(shipId)
        assert(env.dms.element(env.dms['environment_ship'],shipId)~=nil,
            'environment_ship row missing: '..shipId)
        local wordId=env.dms.int(env.dms['environment_ship'],shipId,env.environment_ship.ship_name)
        assert(env.dms.element(env.dms['word_mould'],wordId)~=nil,
            'word_mould row missing: '..wordId)
        local nm=env.dms.string(env.dms['word_mould'],wordId,3)
        nm=tostring(nm or ''):gsub('[,\r\n]',' ')
        assert(nm~='','empty name for word_mould row: '..wordId)
        return nm
    end
    local rows={'camp,seat,ship,name'}
    for i,ship in ipairs(seatsOf(tonumber(NRBattle.battleEveNpc))) do
        rows[#rows+1]='0,'..i..','..ship..','..nameOf(ship)
    end
    for i,ship in ipairs(seatsOf(defForm)) do
        rows[#rows+1]='1,'..i..','..ship..','..nameOf(ship)
    end
    return table.concat(rows,'\n')
end
NRBattle.seatRoster=NRBattle.seatRoster -- always on
reset()
-- Boot handshake: the engine maps a chunk's return number to executeScriptFile's
-- result and returns 0 both for success-without-return and for errors, so publish
-- an explicit 1 only after the battle snapshot really works.
assert(NRBattle.dispatch('snapshot').phase=='ready','Battle snapshot unavailable after boot')
-- Boot-map experiment (analysis only): with NR_PROBE_BOOT_MAP set, execute the
-- ORIGINAL boot chain in _G step by step (port/lua/boot_map.lua). Off by
-- default; every failure is recorded, never fatal for the probe.
if os.getenv and os.getenv('NR_PROBE_BOOT_MAP') then
    local ok,err=xpcall(function()
        local src=files:getStringFromFile('boot_map.lua')
        assert(src and #src>0,'boot_map.lua missing')
        local chunk=assert(loadstring(src,'@boot_map.lua'))
        chunk()
    end,debug.traceback)
    print('BOOT_MAP_FINISHED',ok,err)
end
-- Lint hook (analysis): with NR_PROBE_LINT=<file>, compile that file with the
-- engine's own LuaJIT and print the detailed parser message. Never fatal.
if os.getenv and os.getenv('NR_PROBE_LINT') then
    local name=os.getenv('NR_PROBE_LINT')
    local p=files:fullPathForFilename(name)
    local src=files:getStringFromFile(name)
    print('LINT_FILE',p,src and #src or 0)
    if src and #src>0 then
        local f,pp = loadstring(src,'@'..name)
        print('LINT_LOAD',f~=nil,pp)
    end
end
return 1
