local base=os.getenv('NR_GAME_ROOT'):gsub('\\','/')..'/build/legacy-recruit-native/'
for _,path in ipairs({'port/lua/recruit_results.lua','port/lua/battle_lifecycle.lua','port/lua/menu_boot_probe.lua','tools/probe_recruit_results.lua'}) do
    assert(loadfile(os.getenv('NR_GAME_ROOT')..'/'..path),'Lua syntax: '..path)
end
local files=cc.FileUtils:getInstance()
local case=os.getenv('NR_PROBE_LEGACY_RECRUIT_CASE') or 'gold'
local fixture=case=='gold-skip' and 'gold' or (case=='gold-single-modern' and 'gold-single-new' or case)
nrgate={login=true}
NetworkManager.register=function() return false end
dms.load('data/mould/talent_mould.txt');dms.load('data/mould/word_mould.txt')
dms.format('word_mould',2)
NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'-login.txt')})
_ED.new_reward_object={};_ED.new_prop_object={};_ED.recruit_success_ship_ids=''
_ED.prop_chest_store_recruiting=true
NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'.txt')})
if case=='ryo-hundred' then
    app.load('client.cells.utils.resources_icon_cell')
    app.load('client.shop.recruit.HeroRecruitReward')
    local window=HeroRecruitReward:new()
    local node=csb.createNode('shop/recruit_settlement_shici_hundred.csb')
    window:addChild(node);window.roots={node:getChildByName('root')};window.max_num=100
    fwin._scene:addChild(window,100)
    window:onUpdateDraw()
    for i=1,1200 do
        local manager=window:getActionManager()
        local function resume(node)
            manager:resumeTarget(node)
            for _,child in ipairs(node:getChildren()) do resume(child) end
        end
        resume(window);manager:update(1/60)
    end
    local scroll=ccui.Helper:seekWidgetByName(window.roots[1],'ScrollView_41')
    assert(scroll:getInnerContainer():getChildrenCount()==100,'100x cells missing')
    assert(ccui.Helper:seekWidgetByName(window.roots[1],'Panel_15'):isVisible())
    local report=assert(io.open(base..'trace.txt','w'));report:write('RYO_100_NATIVE_PASSED cells=100\n');report:close()
    return
end
local single=case:find('single')~=nil
local legacy=case~='gold-skip' and case~='gold-single-modern'
local className=legacy and (single and 'HeroRecruitLegacySuccess' or 'HeroRecruitLegacySuccessTen') or (single and 'HeroRecruitSuccess' or 'HeroRecruitSuccessTen')
app.load('client.shop.recruit.'..className)
local window=_G[className]:new()
window:setRanking(3,case:find('ryo') and 1 or 2,false)
fwin:open(window,fwin._ui)
window:onEnterTransitionFinish()
local count=#_ED.random_Patch
assert(#window.__recruit_rewards==count,'Response count mismatch')
local function tick()
    local manager=window:getActionManager();manager:resumeTarget(window);manager:update(1/60)
end
tick()
if os.getenv('NR_PROBE_RECRUIT_DETAIL')=='1' then
    assert(window.__recruit_state=='REVELANDO')
    local report=assert(io.open(base..'trace.txt','w'))
    report:write('RECRUIT_DETAIL_PASSED\n')
    for _,child in ipairs(window.__recruit_detail:getChildren()) do
        local b=child:getBoundingBox()
        report:write(child:getDescription(),' ',b.x,' ',b.y,' ',b.width,' ',b.height,'\n')
    end
    report:close();return
end
local reveals=0
while window.__recruit_state=='REVELANDO' do
    reveals=reveals+1;assert(reveals<=count,'Reveal repeated')
    assert(not window.__recruit_grid:isVisible(),'Grid overlaps ninja')
    assert(window.__recruit_detail:isVisible(),'Ninja detail missing')
    local hero=window.__recruit_detail.__recruit_hero
    assert(hero and not tolua.isnull(hero) and cc.nrSpineCommand(hero,'geometry')>0,'Actual ninja geometry missing')
    local index=window.__recruit_index
    for i=1,8 do require('recruit_results').advance(window) end
    tick()
    assert(window.__recruit_state=='RESUMO' or window.__recruit_index>index,'Reveal did not advance')
end
assert(window.__recruit_state=='RESUMO')
assert(not window.__recruit_detail:isVisible())
assert(window.__recruit_grid:isVisible())
local cells=window.__recruit_grid:getInnerContainer():getChildren()
assert(#cells==count,'Missing reward cells')
for _,slot in ipairs(cells) do assert(slot:getChildrenCount()>0,'Empty reward slot') end
for i=1,600 do tick() end
assert(window.__recruit_grid:isVisible(),'Summary vanished after ten seconds')
-- Retry must dispatch only once and preserve mode/count. Errors restore summary.
local calls,callback=0,nil
NetworkManager.register=function(_,code,a,b,c,node,done)
    calls=calls+1;callback=done
    assert(code==(single and protocol_command.ship_bounty.code or protocol_command.ship_batch_bounty.code))
end
local results=require('recruit_results')
for i=1,8 do results.retry(window) end
assert(calls==1 and window.__recruit_state=='AGUARDANDO_RESPOSTA')
local command=single and protocol_command.ship_bounty or protocol_command.ship_batch_bounty
local firstRequest=command.param_list
callback({RESPONSE_SUCCESS=false,PROTOCOL_STATUS=-1})
assert(window.__recruit_state=='RESUMO' and window.__recruit_grid:isVisible())
local stale=callback
results.retry(window)
assert(calls==2 and command.param_list==firstRequest,'Transport retry changed receipt ID')
NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'-login.txt')})
_ED.new_reward_object={};_ED.prop_chest_store_recruiting=true
NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'.txt')})
local before=window.__recruit_operation
callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
local after=window.__recruit_operation
assert(after~=before and #window.__recruit_rewards==count,'Successful retry lost result')
callback({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(window.__recruit_operation==after,'Duplicate completion advanced operation')
results.summary(window)
window.__recruit_state='FECHADO'
stale({RESPONSE_SUCCESS=true,PROTOCOL_STATUS=0})
assert(window.__recruit_state=='FECHADO','Stale completion revived window')
window.__recruit_state='RESUMO'
-- Real fwin close and repeated reopening without drawing or granting again.
for cycle=1,3 do
    window:retain()
    results.accept(window);results.accept(window)
    assert(window.__recruit_state=='FECHADO' and not window:getParent(),'Accept did not close actual fwin window')
    window:release()
    NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'-login.txt')})
    _ED.new_reward_object={};_ED.prop_chest_store_recruiting=true
    NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'.txt')})
    window=_G[className]:new();window:setRanking(3,case:find('ryo') and 1 or 2,false)
    fwin:open(window,fwin._ui);window:onEnterTransitionFinish()
    assert(#window.__recruit_rewards==count,'Reopen lost rewards')
    results.summary(window)
end
local report=assert(io.open(base..'trace.txt','w'))
report:write('RECRUIT_RESULTS_PASSED ',case,' cells=',count,' reveals=',reveals,' persistent=10s\n');report:close()
print('RECRUIT_RESULTS_PASSED',case,count,reveals)
