-- Materialize the original reward character before any card-click callback.
local M={}
function M.reveal(window)
    if window.__nr_opening_pending then return end
    local hero=window.hero_animation
    if not hero and window.ship and window.ship.ship_template_id and window.roots and window.roots[1]
        and __lua_project_id==__lua_project_l_naruto then
        local root=window.roots[1]
        local legacyPanel=ccui.Helper:seekWidgetByName(root,'Panel_danci')
        if legacyPanel then
            -- The legacy panel starts outside the viewport and normally gets
            -- moved by the missing card-display animation. Use a stationary
            -- non-interactive presentation layer for the initial reveal.
            local panel=ccui.Layout:create()
            local size=root:getContentSize()
            if size.width<=0 or size.height<=0 then size=window:getContentSize() end
            panel:setContentSize(size);panel:setTouchEnabled(false)
            root:addChild(panel,5)
            app.load('client.battle.fight.FightEnum')
            local evolution=smGetSkinEvoIdChange(window.ship)
            local form=dms.int(dms.ship_evo_mould,evolution,ship_evo_mould.form_id)
            hero=sp.spine_sprite(panel,form,spineAnimations[_enum_animation_frame_index.animation_standby+1],true,nil,nil,cc.p(0.5,0))
            hero:setPosition(cc.p(size.width*0.40,size.height*0.16))
            hero:setScale(1.8);hero:setScaleX(-1.8)
            window.hero_animation=hero
            window.__nr_initial_reward_hero=hero
        end
    end
    if not hero or tolua.isnull(hero) then return end
    if cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_WINDOWS then
        local root=window.roots[1]
        local panel=window.__nr_pc_reward_layer
        if not panel then
            panel=ccui.Layout:create();panel:setContentSize(root:getContentSize())
            panel:setTouchEnabled(false);root:addChild(panel,5)
            window.__nr_pc_reward_layer=panel
        end
        -- The original detail panel is animated outside the screen. Retain
        -- the real animated skeleton and move it to a visible presentation
        -- parent; keep the original sprite scale (1), not the port's 1.8.
        if hero:getParent()~=panel then
            hero:retain();hero:removeFromParent(false);panel:addChild(hero);hero:release()
        end
        local size=panel:getContentSize()
        hero:setPosition(cc.p(size.width*.40,size.height*.16))
        hero:setScale(1);hero:setScaleX(-1)
    end
    hero:setVisible(true);hero:setOpacity(255)
    local parent=hero:getParent()
    if parent then parent:setVisible(true);parent:setOpacity(255) end
    -- Sample the real skeleton immediately; do not wait for a tap to change
    -- its track and force its first world-transform/geometry update.
    if cc.nrSpineCommand then cc.nrSpineCommand(hero,'advance',0) end
    if window.mIndex==15 and cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_WINDOWS then
        local root=window.roots[1]
        local detail=ccui.Helper:seekWidgetByName(root,'Panel_23')
        local project=detail and detail:getChildByName('ProjectNode_1')
        local info=project and project:getChildByName('root')
        local accept=info and ccui.Helper:seekWidgetByName(info,'Button_ok')
        if accept then
            accept.__nr_accept_bound=true
            accept:setEnabled(true);accept:setTouchEnabled(true);accept:setBright(true)
            -- The old listener is installed only by the missing detail-frame
            -- callback. Close via the original terminal, without another draw.
            fwin:addTouchEventListener(accept,function(_,event)
                if event~=ccui.TouchEventType.ended or window.__nr_accepted then return end
                window.__nr_accepted=true
                state_machine.excute('hero_recruit_success_renturn_shop_page',0,{})
            end,nil,nil,0)
        end
    end
    local terminal=state_machine and state_machine._terminals.hero_recruit_success_crad_click_on
    if terminal and not terminal.__nr_initial_reveal then
        terminal.__nr_initial_reveal=true
        local invoke=terminal._invoke
        terminal._invoke=function(t,instance,...)
            local old=instance and instance.__nr_initial_reward_hero
            local result={invoke(t,instance,...)}
            if old and instance.hero_animation~=old then
                if not tolua.isnull(old) then old:removeFromParent(true) end
                instance.__nr_initial_reward_hero=nil
            end
            if cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_WINDOWS then M.reveal(instance) end
            return unpack(result)
        end
    end
end
function M.showTenSummary(window)
    if window.mIndex~=15 or window.__nr_ten_summary then return end
    local root=window.roots[1]
    local layer=ccui.Layout:create()
    layer:setTouchEnabled(false)
    layer:setContentSize(root:getContentSize())
    root:addChild(layer,20)
    window.__nr_ten_summary=layer
    app.load('client.cells.utils.resources_icon_cell')
    local size=root:getContentSize()
    for index,data in ipairs(window.recruitment_data) do
        local detail=ccui.Helper:seekWidgetByName(root,'Panel_show_hero_'..index)
        if detail then detail:setVisible(false) end
        local kind=tonumber(data.m_type)
        local mould=tonumber(data.random)
        if kind==6 then mould=tonumber(_ED.user_prop[tostring(data.random)].user_prop_template) end
        local cell=ResourcesIconCell:createCell()
        cell:init(kind,tonumber(data.number) or 1,mould,nil,nil,true,true,0)
        if cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_WINDOWS then
            local cellSize=cell:getContentSize()
            local stride=cellSize.width*1.25
            cell:setAnchorPoint(cc.p(.5,.5))
            cell:setPosition(cc.p(size.width*.5+((index-1)%5-2)*stride,size.height*(.65-math.floor((index-1)/5)*.28)))
        else
        cell:setPosition(cc.p(size.width*(.14+((index-1)%5)*.18),size.height*(.65-math.floor((index-1)/5)*.28)))
        end
        layer:addChild(cell)
    end
    local controls=ccui.Helper:seekWidgetByName(root,'Panel_15')
    controls:setVisible(true)
    controls:setLocalZOrder(30)
end
function M.installTen(class)
    if not class or class.__nr_ten_summary_installed then return end
    class.__nr_ten_summary_installed=true
    M.installOpening(class)
    local close=class.closePageEvent
    class.closePageEvent=function(self,...)
        local result={close(self,...)}
        M.showTenSummary(self)
        return unpack(result)
    end
end
function M.installOpening(class)
    if not class or class.__nr_opening_order or not class.playOpeningAnimation then return end
    class.__nr_opening_order=true
    local original=class.playOpeningAnimation
    class.playOpeningAnimation=function(self,panel,callback,...)
        if self.mIndex~=15 then return original(self,panel,callback,...) end
        self.__nr_opening_pending=true
        self.__nr_opening_finished=false
        self.__nr_creating_opening=true
        local done=false
        local function complete(animation)
            -- The legacy Spine adapter also invokes its movement callback
            -- synchronously from playWithIndex. That is START, not COMPLETE.
            if self.__nr_creating_opening or done or tolua.isnull(self) then return end
            done=true
            self.__nr_opening_pending=false
            self.__nr_opening_finished=true
            callback(animation)
            if class==rawget(_G,'HeroRecruitSuccess') then M.reveal(self) end
        end
        local result={original(self,panel,complete,...)}
        self.__nr_creating_opening=false
        self.__nr_opening_node=result[1]
        for _,child in ipairs(panel:getChildren()) do
            if child.__nrSpineHandlers then self.__nr_opening_node=child end
        end
        return unpack(result)
    end
end
function M.install(class)
    if not class or class.__nr_visible_reward then return end
    M.installOpening(class)
    class.__nr_visible_reward=true
    for _,name in ipairs({'ShowUI','onEnterTransitionFinish'}) do
        local original=class[name]
        if original then
            class[name]=function(self,...)
                local result={original(self,...)}
                M.reveal(self)
                return unpack(result)
            end
        end
    end
end
return M
