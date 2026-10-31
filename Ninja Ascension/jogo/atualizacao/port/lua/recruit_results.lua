-- Normal Recruit presentation. Parser 166 owns draw order; parser 32/27 owns
-- non-character gains. Never infer a full ninja from a fragment stack size.
local M={serial=0}
local function log(w,event,...)
    print('RECRUIT_RESULT',w.__recruit_operation,event,...)
    if os.getenv('NR_RECRUIT_TRACE')~='1' and os.getenv('NR_PROBE_RECRUIT_RESULTS')~='1' and not event:find('missing_',1,true) then return end
    local file=io.open(cc.FileUtils:getInstance():getWritablePath()..'recruit-results.log','a')
    if file then
        local fields={tostring(w.__recruit_operation),event}
        for _,value in ipairs({...}) do fields[#fields+1]=tostring(value) end
        file:write(table.concat(fields,' '),'\n');file:close()
    end
end
function M.normalize(ed)
    local rows,index={},1
    for _,draw in ipairs(ed.random_Patch or {}) do
        local kind,id,count,bounty=13,tonumber(draw.random_patch_id),1,draw.bounty_hero_param_id
        if not id or id<=0 then
            local gain=(ed.new_reward_object or {})[index];index=index+1
            if gain then
                kind,id,count=tonumber(gain.m_type),tonumber(gain.mould_id),tonumber(gain.number)
                if kind==6 then
                    local prop=ed.user_prop[tostring(id)]
                    id=prop and tonumber(prop.user_prop_template) or id
                end
            else kind,id,count=0,-1,0 end
        end
        local fragment=false
        if kind==6 then
            local ok,value=pcall(dms.int,dms.prop_mould,id,prop_mould.use_of_ship)
            fragment=ok and (tonumber(value) or 0)>0
        end
        local duplicate
        if fragment and (tonumber(bounty) or 0)>0 then
            local original=zstring.split(dms.string(dms.bounty_hero_param,bounty,bounty_hero_param.rewards),',')
            if tonumber(original[1])==13 then duplicate=tonumber(original[2]) end
        end
        rows[#rows+1]={m_type=kind,id=id,number=count or 1,bounty=bounty,duplicate_hero=duplicate,
            category=kind==13 and 'ninja' or (fragment and 'fragment' or 'item')}
    end
    return rows
end
local function text(parent,value,size,x,y,width)
    local node=ccui.Text:create(tostring(value),'Arial',size)
    node:setPosition(cc.p(x,y))
    if width then node:ignoreContentAdaptWithSize(false);node:setContentSize(cc.size(width,70)) end
    parent:addChild(node);return node
end
local function bind(button,callback)
    button:setEnabled(true);button:setTouchEnabled(true)
    fwin:addTouchEventListener(button,function(_,event)
        if event==ccui.TouchEventType.ended then callback() end
    end,nil,nil,0)
end
local function alive(w,token)
    return not tolua.isnull(w) and w.__recruit_operation==token and w.__recruit_state~='FECHADO'
end
function M.summary(w)
    if not w.__recruit_grid_revealed then return M.revealGrid(w) end
    w.__recruit_state='RESUMO'
    w.__recruit_content:setVisible(true)
    w.__recruit_detail:setVisible(false);w.__recruit_detail:removeAllChildren(true)
    w.__recruit_grid:setVisible(true);w.__recruit_controls:setVisible(true)
    w.__recruit_next:setVisible(false)
    if w.__recruit_count==1 then
        local row=w.mIndex==1 and 1 or 2
        local cost=dms.int(dms.partner_bounty_param,row,w.mIndex==1 and partner_bounty_param.spend_silver or partner_bounty_param.spend_gold)
        local free=_ED.free_info and _ED.free_info[row]
        if free and (tonumber(free.surplus_free_number) or 0)>0 then
            local wait=(tonumber(free.next_free_time) or 0)/1000-(os.time()-(tonumber(free.free_start) or os.time()))
            if row==2 or wait<=0 then cost=0 end
        end
        ccui.Helper:seekWidgetByName(w.roots[1],'Label_36610'):setString(tostring(cost))
    end
    if w.mIndex==2 then
        local ticket=tonumber(dms.string(dms.shop_config,4,shop_config.param))
        local available=tonumber(getPropAllCountByMouldId(ticket)) or 0
        local free=_ED.free_info and _ED.free_info[2]
        local useFree=w.__recruit_count==1 and free and (tonumber(free.surplus_free_number) or 0)>0
        local currency=ccui.Helper:seekWidgetByName(w.roots[1],'Panel_consume_icon')
        if not useFree and available>=w.__recruit_count then
            ccui.Helper:seekWidgetByName(w.roots[1],'Label_36610'):setString(tostring(w.__recruit_count))
            local pic=dms.int(dms.prop_mould,ticket,prop_mould.pic_index)
            if currency then currency:setBackGroundImage(string.format('images/ui/props/props_%d.png',pic)) end
        elseif currency then currency:setBackGroundImage('images/ui/icon/zuanshi.png') end
    end
    log(w,'summary',#w.__recruit_rewards)
end
function M.revealGrid(w)
    local token=w.__recruit_operation
    w.__recruit_state='REVELANDO_GRADE'
    w.__recruit_content:setVisible(true)
    w.__recruit_detail:setVisible(false);w.__recruit_detail:removeAllChildren(true)
    w.__recruit_grid:setVisible(true);w.__recruit_controls:setVisible(false)
    w.__recruit_next:setVisible(false)
    local index=0
    local function nextCell()
        if not alive(w,token) or w.__recruit_state~='REVELANDO_GRADE' then return end
        index=index+1
        local slot=w.__recruit_slots[index]
        if not slot then
            w.__recruit_grid_revealed=true
            return M.summary(w)
        end
        slot:setVisible(true);slot:setRotation(0);slot:setOpacity(255);slot:setScale(.1)
        playEffect(formatMusicFile('effect',9988))
        -- Same entrance sequence as HeroRecruitReward (100x). Animate the
        -- private slot so the fitted resource icon retains its final scale.
        slot:runAction(cc.Sequence:create(cc.ScaleTo:create(.12,1.2),cc.ScaleTo:create(.02,1),cc.CallFunc:create(nextCell)))
    end
    nextCell()
end
function M.opening(w)
    local token=w.__recruit_operation
    w.__recruit_state='ABERTURA'
    w.__recruit_content:setVisible(false)
    local layer=ccui.Layout:create()
    layer:setContentSize(w.roots[1]:getContentSize())
    layer:setTouchEnabled(true);layer:setSwallowTouches(true)
    w:addChild(layer,100);w.__recruit_opening=layer
    local done=false
    local function complete()
        if done or not alive(w,token) then return end
        done=true
        -- Leave the armature callback before removing its owning node.
        w:runAction(cc.CallFunc:create(function()
            if not alive(w,token) then return end
            if w.__recruit_opening_actor then
                w.__recruit_opening_actor:getAnimation():setMovementEventCallFunc(function() end)
                w.__recruit_opening_actor=nil
            end
            layer:removeFromParent(true);w.__recruit_opening=nil
            w.__recruit_content:setVisible(true)
            w.__recruit_state='REVELANDO'
            log(w,'opening_complete')
            M.advance(w)
        end))
    end
    local ok,err=pcall(function()
        -- Naruto's seal is the original ExportJson armature. The similarly
        -- named Spine texture is a placeholder and must not replace it.
        loadEffect('sprite/sprite_fudan.ExportJson')
        local actor=ccs.Armature:create('sprite_fudan')
        w.__recruit_opening_actor=actor
        actor:setPosition(cc.p(layer:getContentSize().width/2,layer:getContentSize().height/2))
        layer:addChild(actor)
        actor:getAnimation():setMovementEventCallFunc(function(_,event)
            if event==1 or event==2 then complete() end
        end)
        playEffect(formatMusicFile('effect',9983))
        actor:getAnimation():playWithIndex(0,-1,0)
    end)
    if not ok then log(w,'missing_opening_resource','sprite/sprite_fudan.ExportJson',err);complete() end
end
function M.advance(w)
    if w.__recruit_state~='REVELANDO' or w.__recruit_advancing then return end
    w.__recruit_advancing=true
    local token=w.__recruit_operation
    w:runAction(cc.CallFunc:create(function()
        if not alive(w,token) or w.__recruit_state~='REVELANDO' then return end
        w.__recruit_advancing=false
        local index=(w.__recruit_index or 0)+1
        while w.__recruit_rewards[index] and w.__recruit_rewards[index].category~='ninja'
            and not w.__recruit_rewards[index].duplicate_hero do index=index+1 end
        w.__recruit_index=index
        local reward=w.__recruit_rewards[index]
        if not reward then M.summary(w);return end
        w.__recruit_content:setVisible(false)
        w.__recruit_controls:setVisible(false);w.__recruit_next:setVisible(false)
        local completed=false
        local function nextReward()
            if completed or not alive(w,token) or w.__recruit_index~=index then return end
            completed=true;w.__recruit_state='REVELANDO';M.advance(w)
        end
        local ok,err=xpcall(function()
            require('recruit_character_presentation').show(w,reward,nextReward)
        end,debug.traceback)
        if not ok then log(w,'missing_character_resource',reward.id,err);nextReward() end
        log(w,'reveal',index,reward.duplicate_hero or reward.id,reward.duplicate_hero and 'duplicate' or 'new')
    end))
end
function M.receive(w)
    M.serial=M.serial+1;w.__recruit_operation=M.serial
    w.__recruit_rewards=M.normalize(_ED)
    w.recruitment_data=w.__recruit_rewards
    log(w,'received',w.mIndex,w.__recruit_count,#(_ED.random_Patch or {}),#w.__recruit_rewards)
    local grid=w.__recruit_grid
    local panel=grid:getInnerContainer();panel:removeAllChildren(true)
    w.__recruit_slots={};w.__recruit_grid_revealed=false
    w.__recruit_grid:setVisible(false);w.__recruit_controls:setVisible(false)
    w.__recruit_detail:setVisible(false);w.__recruit_next:setVisible(false)
    local size=grid:getContentSize();local stride=size.width/5
    local rows=math.ceil(#w.__recruit_rewards/5)
    local height=math.max(size.height,rows*stride)
    grid:setInnerContainerSize(cc.size(size.width,height))
    for index,reward in ipairs(w.__recruit_rewards) do
        local slot=ccui.Layout:create();slot:setContentSize(cc.size(stride,stride));panel:addChild(slot)
        local single=#w.__recruit_rewards==1
        slot:setPosition(cc.p(single and (size.width-stride)/2 or ((index-1)%5)*stride,single and (height-stride)/2 or height-(math.floor((index-1)/5)+1)*stride))
        local x,y=slot:getPositionX(),slot:getPositionY()
        slot:setAnchorPoint(cc.p(.5,.5));slot:setPosition(cc.p(x+stride/2,y+stride/2))
        slot:setVisible(false);w.__recruit_slots[index]=slot
        local ok,err=pcall(function()
            local cell=ResourcesIconCell:createCell()
            cell:init(reward.m_type,reward.number,reward.id,nil,nil,true,true,0)
            cell:stopAllActions();cell:setRotation(0);cell:setOpacity(255)
            local cs=cell:getContentSize();local scale=math.min(1,stride*.8/math.max(cs.width,cs.height,1))
            cell:setScale(scale);cell:setAnchorPoint(cc.p(.5,.5));cell:setPosition(cc.p(stride*.5,stride*.5));slot:addChild(cell)
        end)
        if not ok then log(w,'missing_cell_resource',reward.id,tostring(err));text(slot,reward.category..' #'..reward.id..' x'..reward.number,16,stride/2,stride/2,stride) end
        log(w,'reward',index,reward.category,reward.m_type,reward.id,reward.number)
    end
    grid:jumpToTop()
    w.__recruit_index=0;w.__recruit_state='REVELANDO';w.__recruit_advancing=false
    M.opening(w)
end
function M.retry(w)
    if w.__recruit_state~='RESUMO' then return end
    w.__recruit_state='AGUARDANDO_RESPOSTA'
    local token=w.__recruit_operation
    M.serial=M.serial+1
    local request=w.__recruit_retry_request or (tostring(os.time())..':'..M.serial..':'..math.random(1,99999999))
    local command=w.__recruit_count==1 and protocol_command.ship_bounty or protocol_command.ship_batch_bounty
    command.param_list=tostring(w.mIndex)..'\r\n'..request
    _ED.new_prop_object={};_ED.new_reward_object={};_ED.random_Patch={}
    _ED.recruit_success_ship_id=nil;_ED.recruit_success_ship_ids='';_ED.prop_chest_store_recruiting=true
    log(w,'request',request,w.mIndex,w.__recruit_count)
    NetworkManager:register(command.code,nil,nil,nil,w,function(response)
        if not alive(w,token) then return end
        _ED.prop_chest_store_recruiting=false
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS>=0 then
            w.__recruit_retry_request=nil;M.receive(w)
        else
            w.__recruit_retry_request=not response.RESPONSE_SUCCESS and request or nil
            w.__recruit_state='RESUMO';log(w,'request_failed')
        end
    end,false,nil)
end
function M.accept(w)
    if w.__recruit_state~='RESUMO' then return end
    w.__recruit_state='FECHADO';w:stopAllActions();log(w,'accept')
    state_machine.excute(w.__recruit_terminal,0,{})
end
function M.open(w,count,terminal)
    if w.__recruit_operation then return end
    w.__recruit_count=count;w.__recruit_terminal=terminal
    app.load('client.cells.utils.resources_icon_cell')
    local node=csb.createNode('shop/recruit_settlement_shici_hundred.csb');w:addChild(node)
    w.__recruit_content=node
    local root=node:getChildByName('root');w.roots={root}
    local grid=ccui.Helper:seekWidgetByName(root,'ScrollView_41')
    w.__recruit_grid=grid
    w.__recruit_controls=ccui.Helper:seekWidgetByName(root,'Panel_15')
    local opening=ccui.Helper:seekWidgetByName(root,'Panel_zhaomu_open');if opening then opening:setVisible(false) end
    local prototype=ccui.Helper:seekWidgetByName(root,'Panel_head_icon');if prototype then prototype:setVisible(false) end
    local detail=ccui.Layout:create();detail:setContentSize(root:getContentSize());detail:setPosition(cc.p(0,0))
    w:addChild(detail,20);w.__recruit_detail=detail
    local nextButton=ccui.Layout:create()
    nextButton:setVisible(false);root:addChild(nextButton);w.__recruit_next=nextButton
    local again=ccui.Helper:seekWidgetByName(root,'Button_36550')
    local accept=ccui.Helper:seekWidgetByName(root,'Button_36551')
    bind(again,function() M.retry(w) end)
    bind(accept,function() M.accept(w) end)
    local row=count==1 and (w.mIndex==1 and 1 or 2) or (w.mIndex==1 and 9 or 4)
    local cost=dms.int(dms.partner_bounty_param,row,w.mIndex==1 and partner_bounty_param.spend_silver or partner_bounty_param.spend_gold)
    ccui.Helper:seekWidgetByName(root,'Label_36610'):setString(tostring(cost))
    local currency=ccui.Helper:seekWidgetByName(root,'Panel_consume_icon')
    if currency then currency:setBackGroundImage(w.mIndex==1 and 'images/ui/icon/jinbi.png' or 'images/ui/icon/zuanshi.png') end
    -- The modal itself consumes background touches, including while waiting.
    root:setTouchEnabled(true);root:setSwallowTouches(true)
    M.receive(w)
end
function M.install(class,count,terminal)
    if not class or class.__recruit_results then return end
    class.__recruit_results=true
    local enter,exit=class.onEnterTransitionFinish,class.onExit
    class.onEnterTransitionFinish=function(self,...)
        if (__lua_project_id==__lua_project_l_naruto) and (self.mIndex==1 or self.mIndex==2) then
            return M.open(self,count,terminal)
        end
        return enter(self,...)
    end
    class.onExit=function(self,...)
        if self.__recruit_operation then
            self.__recruit_state='FECHADO';self:stopAllActions()
            if self.__recruit_opening_actor and not tolua.isnull(self.__recruit_opening_actor) then
                self.__recruit_opening_actor:getAnimation():setMovementEventCallFunc(function() end)
            end
            for _,slot in ipairs(self.__recruit_slots or {}) do if not tolua.isnull(slot) then slot:stopAllActions() end end
            log(self,'exit')
        end
        if exit then return exit(self,...) end
    end
end
return M
