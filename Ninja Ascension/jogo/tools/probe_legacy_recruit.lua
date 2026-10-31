-- Native UI regression, fed only by a temporary account's recorded responses.
local base=(os.getenv('NR_GAME_ROOT'):gsub('\\','/'))..'/build/legacy-recruit-native/'
local files=cc.FileUtils:getInstance()
local case=os.getenv('NR_PROBE_LEGACY_RECRUIT_CASE') or 'gold'
local fixture=case=='gold-skip' and 'gold' or case
nrgate={login=true}
NetworkManager.register=function() return false end
-- LoginLoading normally loads these before the user can enter Recruit.
dms.load('data/mould/talent_mould.txt')
dms.load('data/mould/word_mould.txt')
NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'-login.txt')})
_ED.new_reward_object={};_ED.new_prop_object={};_ED.recruit_success_ship_ids=''
_ED.prop_chest_store_recruiting=true
NetworkProtocol.parser_func({resouce=files:getStringFromFile(base..fixture..'.txt')})
app.load('client.shop.recruit.HeroRecruitSuccessTen')
-- Preserve server order so new Ninja, duplicate, item and next Ninja are covered.
RandFetch=function(target,count,total,source)
    for index=1,count do target[index]=source[index] end
end
local results=HeroRecruitSuccessTen:new()
results:setRanking(case=='ryo' and 3 or 4,case=='ryo' and 1 or 2,false)
results.bSpeedUp=case=='gold-skip'
local actions={}
local trace=assert(io.open(base..'trace.txt','w'))
local createTimeline=csb.createTimeline
csb.createTimeline=function(path,...)
    local action=createTimeline(path,...)
    if path=='shop/recruit_settlement_animation.csb' then
        action:retain();actions[#actions+1]=action
        local set=action.setFrameEventCallFunc
        action.setFrameEventCallFunc=function(self,callback)
            return set(self,function(frame)
                trace:write('event ',tostring(frame:getEvent()),' index ',results.heroIndex,'\n');trace:flush()
                local ok,err=xpcall(function() callback(frame) end,debug.traceback)
                if not ok then trace:write('ERROR ',err,'\n');trace:flush() end
                if frame:getEvent()=='Panel_card_icon_open' then
                    -- Same timeline transition used by tapping the revealed card.
                    self:play('open_hero_x_'..results.heroIndex,false)
                end
            end)
        end
    end
    return action
end
local detailIndex,detailTime,accepted=nil,0,{}
local showDetail=results.openNewShowActionSpecial
results.openNewShowActionSpecial=function(self,...)
    detailIndex=self.heroIndex;detailTime=0
    return showDetail(self,...)
end
results:onEnterTransitionFinish()
fwin._scene:addChild(results,100)
assert(#results.recruitment_data==10,'Expected ten actual Recruit results')
for index,data in ipairs(results.recruitment_data) do
    print('LEGACY_RECRUIT_RESULT',index,data.m_type,data.random,data.isSame,data.number)
end
local root=results.roots[1]
for tick=1,2400 do
    local manager=root:getActionManager()
    manager:resumeTarget(root)
    manager:update(1/60)
    for _,entry in pairs(results.hero_animations) do
        if entry.hero and not tolua.isnull(entry.hero) then cc.nrSpineCommand(entry.hero,'advance',1/60) end
    end
    if detailIndex and not accepted[detailIndex] then
        detailTime=detailTime+1/60
        if detailTime>1.5 then
            accepted[detailIndex]=true
            results:openNewShowActionSpecialOver()
        end
    end
end
csb.createTimeline=createTimeline
trace:write('actions ',#actions,' detail ',tostring(detailIndex),'\n')
for _,action in ipairs(actions) do trace:write('frame ',action:getCurrentFrame(),' end ',action:getEndFrame(),'\n') end
trace:close()
assert(results.heroIndex==10,'Reveal sequence did not reach reward ten: '..results.heroIndex)
assert(not results.bSpeedUp,'Tap acceleration leaked into the next rewards')
assert(ccui.Helper:seekWidgetByName(root,'Panel_15'):isVisible(),'Final result controls missing')
local overlays=0
for index=1,10 do
    local detail=ccui.Helper:seekWidgetByName(root,'Panel_show_hero_'..index)
    if detail:isVisible() and detail:getChildByName('ProjectNode_2'):isVisible() then overlays=overlays+1 end
    local icon=ccui.Helper:seekWidgetByName(root,'Panel_head_icon_'..index)
    assert(icon:getChildrenCount()>0,'Final reward icon missing: '..index)
    local node=icon
    while node do
        assert(node:isVisible(),'Final reward hidden by '..node:getName()..': '..index)
        if node==root then break end
        node=node:getParent()
    end
end
print('LEGACY_RECRUIT_FINAL_OVERLAYS',overlays)
assert(overlays==0,'Character detail remains over the final ten rewards')
print('LEGACY_RECRUIT_NATIVE_PASSED')
