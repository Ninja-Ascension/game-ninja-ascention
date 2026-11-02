-- ---------------------------
-- 世界玩法说明界面
-- ---------------------------
WorldMapPlayInfor = class("WorldMapPlayInforClass", Window)

local world_map_play_infor_window_open_terminal = {
    _name = "world_map_play_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("WorldMapPlayInforClass")
        if nil == _Window then
            fwin:open(WorldMapPlayInfor:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local world_map_play_infor_window_close_terminal = {
    _name = "world_map_play_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WorldMapPlayInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_map_play_infor_window_open_terminal)
state_machine.add(world_map_play_infor_window_close_terminal)
state_machine.init()

function WorldMapPlayInfor:ctor()
    self.super:ctor()
    self.roots = {}

    self._help_panel = nil

    local function init_world_map_play_infor_terminal()
        local world_map_play_infor_update_terminal = {
            _name = "world_map_play_infor_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_map_play_infor_change_page_terminal = {
            _name = "world_map_play_infor_change_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(world_map_play_infor_change_page_terminal)
        state_machine.add(world_map_play_infor_update_terminal)
        state_machine.init()
    end
    init_world_map_play_infor_terminal()
end

function WorldMapPlayInfor:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_world_play_effice = ccui.Helper:seekWidgetByName(root, "Panel_world_play_effice")
    local Image_legion_infor_1_0_0 = ccui.Helper:seekWidgetByName(root, "Image_legion_infor_1_0_0")
    local Text_world_infor_t_1 = ccui.Helper:seekWidgetByName(root, "Text_world_infor_t_1")
    local Text_world_infor_t_2 = ccui.Helper:seekWidgetByName(root, "Text_world_infor_t_2")
    local Text_world_infor_t_3 = ccui.Helper:seekWidgetByName(root, "Text_world_infor_t_3")
    Panel_world_play_effice:removeAllChildren(true)
    Text_world_infor_t_1:setString("")
    Text_world_infor_t_2:setString("")
    Text_world_infor_t_3:setString("")
    Image_legion_infor_1_0_0:setVisible(true)
    for k,v in pairs(self._buttons) do
        if page == k then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end

    if page == self._current_page then
        -- return
    end
    self._current_page = page

    local Panel_attack = ccui.Helper:seekWidgetByName(root, "Panel_attack")
    local Panel_world_lv = ccui.Helper:seekWidgetByName(root, "Panel_world_lv")
    if Panel_attack ~= nil then
        Panel_attack:setVisible(false)
    end
    if Panel_world_lv ~= nil then
        Panel_world_lv:setVisible(false)
    end

    if page <= 3 then
        if Panel_attack ~= nil then
            Panel_attack:setVisible(true)
        end

        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_world_play_infor)
        local armature = ccs.Armature:create("effect_world_play_infor")
        
        if page == 1 then
            Text_world_infor_t_1:setString(world_map_play_infor_tip[1])
            Text_world_infor_t_2:setString(world_map_play_infor_tip[2])
            Text_world_infor_t_3:setString(world_map_play_infor_tip[3])
            armature:getAnimation():playWithIndex(0)
        elseif page == 2 then
            Text_world_infor_t_1:setString(world_map_play_infor_tip[4])
            Text_world_infor_t_2:setString(world_map_play_infor_tip[5])
            Text_world_infor_t_3:setString(world_map_play_infor_tip[6])
            armature:getAnimation():playWithIndex(1)
        else
            Text_world_infor_t_1:setString(world_map_play_infor_tip[7])
            Text_world_infor_t_2:setString(world_map_play_infor_tip[8])
            Image_legion_infor_1_0_0:setVisible(false)
            armature:getAnimation():playWithIndex(2)
        end

        function blinkInCallback1(sender)
            checkPlayEffect(79)
        end

        function blinkInCallback2(sender)
            checkPlayEffect(7)
        end

        function blinkInCallback3(sender)
            checkPlayEffect(8)
        end

        function blinkInCallback4(sender)
            checkPlayEffect(25)
        end

        armature:getAnimation():setFrameEventCallFunc(
        function(bone,evt,originFrameIndex,currentFrameIndex)
            local tempArmature = bone:getArmature()
            if tempArmature:isVisible() == true then
                if evt == "gogogo" then
                    checkPlayEffect(42,1)
                elseif evt == "attack" then
                    if page == 3 then
                        checkPlayEffect(7)
                    else
                        for i=1,3 do
                            armature:runAction(cc.Sequence:create(
                            cc.DelayTime:create((i-1)/3),
                            cc.CallFunc:create(blinkInCallback2)
                            ))
                        end
                    end
                elseif evt == "boom" then
                    if page == 3 then
                        checkPlayEffect(8)
                    else
                        for i=1,3 do
                            armature:runAction(cc.Sequence:create(
                            cc.DelayTime:create((i-1)/3),
                            cc.CallFunc:create(blinkInCallback3)
                            ))
                        end
                    end
                elseif evt == "duang" then
                    for i=1,3 do
                        armature:runAction(cc.Sequence:create(
                        cc.DelayTime:create((i-1)/4),
                        cc.CallFunc:create(blinkInCallback1)
                        ))
                    end
                elseif evt == "res" then
                    if page == 1 then
                        for i=1,5 do
                            armature:runAction(cc.Sequence:create(
                            cc.DelayTime:create((i-1)/4),
                            cc.CallFunc:create(blinkInCallback4)
                            ))
                        end
                    else
                        checkPlayEffect(25)
                    end
                end
            end
        end)
        armature:setPosition(cc.p(Panel_world_play_effice:getContentSize().width / 2, Panel_world_play_effice:getContentSize().height / 2))
        armature:setTag(1000)
        Panel_world_play_effice:addChild(armature)
    elseif page == 4 then
        if Panel_world_lv ~= nil then
            Panel_world_lv:setVisible(true)
            if self._help_panel == nil then
                app.load("client.red_alert_time.big_map.WorldMapPlayInforHelp")
                self._help_panel = state_machine.excute("world_map_play_infor_help_open", 0, {Panel_world_lv})
            end
        end
    end
end

function WorldMapPlayInfor:onEnterTransitionFinish()

end

function WorldMapPlayInfor:onInit(params)
    local csbItem = csb.createNode(config_csb.world_map.world_map_play_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_lv_close"), nil, 
    {
        terminal_name = "world_map_play_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "world_map_play_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_world_attack"),
                    ccui.Helper:seekWidgetByName(root, "Button_world_attack_res"),
                    ccui.Helper:seekWidgetByName(root, "Button_world_attack_help"),
                    ccui.Helper:seekWidgetByName(root, "Button_world_lv")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "world_map_play_infor_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function WorldMapPlayInfor:init(params)
    -- self.city_id = params[1]
    self:onInit(params)
    return self
end

function WorldMapPlayInfor:onExit()
    state_machine.remove("world_map_play_infor_update")
    state_machine.remove("world_map_play_infor_change_page")
end
