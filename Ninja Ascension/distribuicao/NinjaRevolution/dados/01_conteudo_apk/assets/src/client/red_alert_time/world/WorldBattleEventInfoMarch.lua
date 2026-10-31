--------------------------------------------------------------------------------------------------------------
--  说明：行军队列
--------------------------------------------------------------------------------------------------------------
WorldBattleEventInfoMarch = class("WorldBattleEventInfoMarchClass", Window)

--打开界面
local world_battle_event_info_march_window_open_terminal = {
    _name = "world_battle_event_info_march_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = WorldBattleEventInfoMarch:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_battle_event_info_march_window_open_terminal)
state_machine.init()

function WorldBattleEventInfoMarch:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._last_open_count = 0

    local function init_world_battle_event_info_march_terminal()
        local world_battle_event_info_march_show_terminal = {
            _name = "world_battle_event_info_march_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local world_battle_event_info_march_hide_terminal = {
            _name = "world_battle_event_info_march_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新行军队列
        local world_battle_event_info_march_update_terminal = {
            _name = "world_battle_event_info_march_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                state_machine.excute("main_window_update_formation_count", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新开启状态
        local world_battle_event_info_march_update_state_terminal = {
            _name = "world_battle_event_info_march_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateOpenState()
                state_machine.excute("main_window_update_formation_count", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_battle_event_info_march_show_terminal)   
        state_machine.add(world_battle_event_info_march_hide_terminal)
        state_machine.add(world_battle_event_info_march_update_terminal)
        state_machine.add(world_battle_event_info_march_update_state_terminal)
        state_machine.init()
    end
    init_world_battle_event_info_march_terminal()
end

function WorldBattleEventInfoMarch:onUpdateOpenState()
    local root = self.roots[1]
    local current_open_count = dms.int(dms["base_consume"], 81, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
    if self._last_open_count < current_open_count then
        local items = self._list_view:getItems()
        for i = self._last_open_count + 1, current_open_count do
            local cell = items[i]
            if cell ~= nil then
                state_machine.excute("world_battle_event_info_march_cell_update_state", 0, {cell, 0})
            end
        end
    end
end

function WorldBattleEventInfoMarch:onUpdateDraw()
    local root = self.roots[1]
    local ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")

    local result = {}
    if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
        for i, v in pairs(_ED.world_map.target_event_info) do
            if (tonumber(v._event_type) < 10 or tonumber(v._event_type) >= 18) then
                table.insert(result, v)
            end
        end
    end

    self._last_match_count = #result
    
    local function sortFunction(a, b)
        return a._time < b._time
    end
    table.sort(result, sortFunction)

    local items = ListView_world_attack:getItems()
    for k,v in pairs(items) do
        state_machine.excute("world_battle_event_info_march_cell_update_info", 0, {cell = v, _info = result[k]})
    end

    ListView_world_attack:requestRefreshView()
    self._list_view = ListView_world_attack
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function WorldBattleEventInfoMarch:onUpdate( dt )
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        -- local items = self._list_view:getItems()
        -- if items[1] == nil then
        --     return
        -- end
        -- local itemSize = items[1]:getContentSize()
        -- for i, v in pairs(items) do
        --     local tempY = v:getPositionY() + posY
        --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
        --         v:unload()
        --     else
        --         v:reload()
        --     end
        -- end
    end
end

function WorldBattleEventInfoMarch:initMarchListview()
    local root = self.roots[1]
    local ListView_world_attack = ccui.Helper:seekWidgetByName(root,"ListView_world_attack")
    ListView_world_attack:removeAllItems()
    ListView_world_attack:jumpToTop()

    local open_vip = 0
    local playTheQueue = dms.element(dms["base_consume"], 81)
    for i = 1, 8 do
        for j = open_vip, 14 do
            local open_count = dms.atoi(playTheQueue, base_consume.vip_0_value + j)
            if open_count >= i then
                open_vip = j
                break
            end
        end
        local state = 0
        if open_vip > zstring.tonumber(_ED.vip_grade) then
            state = open_vip
        end
        local cell = state_machine.excute("world_battle_event_info_march_cell_create",0, {i, nil, state})
        ListView_world_attack:addChild(cell)
    end
    self._last_open_count = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))

    ListView_world_attack:requestRefreshView()
    self._list_view = ListView_world_attack
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function WorldBattleEventInfoMarch:onInit(params)
    local csbItem = csb.createNode(config_csb.cells.world.world_battle_infor_window_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_world_attack_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)
    
    self:initMarchListview()
    self:onUpdateDraw()
end

function WorldBattleEventInfoMarch:onEnterTransitionFinish()

end

function WorldBattleEventInfoMarch:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function WorldBattleEventInfoMarch:onExit()
    state_machine.remove("world_battle_event_info_march_show")
    state_machine.remove("world_battle_event_info_march_hide")
    state_machine.remove("world_battle_event_info_march_update")
    state_machine.remove("world_battle_event_info_march_update_state")
end