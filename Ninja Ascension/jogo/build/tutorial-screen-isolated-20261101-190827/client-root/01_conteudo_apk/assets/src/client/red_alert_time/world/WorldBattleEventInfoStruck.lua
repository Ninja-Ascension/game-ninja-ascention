--------------------------------------------------------------------------------------------------------------
--  说明：来袭队列
--------------------------------------------------------------------------------------------------------------
WorldBattleEventInfoStruck = class("WorldBattleEventInfoStruckClass", Window)

--打开界面
local world_battle_event_info_struck_window_open_terminal = {
    _name = "world_battle_event_info_struck_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = WorldBattleEventInfoStruck:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_battle_event_info_struck_window_open_terminal)
state_machine.init()

function WorldBattleEventInfoStruck:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._last_struck_count = 0

    app.load("client.red_alert_time.props.PropsUse")
    app.load("client.red_alert_time.cells.props.props_use_cell")

    local function init_world_battle_event_info_struck_terminal()
        local world_battle_event_info_struck_show_terminal = {
            _name = "world_battle_event_info_struck_show",
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

        local world_battle_event_info_struck_hide_terminal = {
            _name = "world_battle_event_info_struck_hide",
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

        local world_battle_event_info_struck_update_terminal = {
            _name = "world_battle_event_info_struck_update",
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

        -- 保护罩购买
        local world_battle_event_info_struck_to_buy_terminal = {
            _name = "world_battle_event_info_struck_to_buy",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = {}
                info.id = 17
                local prop_ids_info = dms.string(dms["build_shop"], info.id, build_shop.prop_ids)
                local prop_data = zstring.split(prop_ids_info, ",")
                info.prop_ids = {
                    prop_data[1],
                    prop_data[2],
                    prop_data[3],
                }
                state_machine.excute("props_use_window_open",0,{info.id, info.prop_ids, 9})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_battle_event_info_struck_show_terminal)   
        state_machine.add(world_battle_event_info_struck_hide_terminal)
        state_machine.add(world_battle_event_info_struck_update_terminal)
        state_machine.add(world_battle_event_info_struck_to_buy_terminal)
        state_machine.init()
    end
    init_world_battle_event_info_struck_terminal()
end

function WorldBattleEventInfoStruck:onUpdateDraw()
    local root = self.roots[1]
    local ListView_attack_incoming = ccui.Helper:seekWidgetByName(root,"ListView_attack_incoming")
    ListView_attack_incoming:jumpToTop()

    local result = {}
    if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
        for i, v in pairs(_ED.world_map.target_event_info) do
            if tonumber(v._event_type) > 10 and tonumber(v._event_type) < 13 then
                table.insert(result, v)
            end
        end
    end
    
    local function sortFunction(a, b)
        return a._time < b._time
    end
    table.sort(result, sortFunction)

    local items = ListView_attack_incoming:getItems()
    for k,v in pairs(items) do
        state_machine.excute("world_battle_event_info_struck_cell_update_info", 0, {cell = v, index = k, _info = result[k]})
    end

    if #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("world_battle_event_info_struck_cell_create",0, {i,result[i]})
            ListView_attack_incoming:addChild(cell)
        end
    end

    ListView_attack_incoming:requestRefreshView()
    self._list_view = ListView_attack_incoming
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    -- 基地红屏动画
    if self._last_struck_count < #result then
        state_machine.excute("home_button_window_world_damage_time",0,{1})      
    end
    self._last_struck_count = #result
end

function WorldBattleEventInfoStruck:onUpdate( dt )
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

function WorldBattleEventInfoStruck:onInit(params)
    local csbItem = csb.createNode(config_csb.cells.world.world_battle_infor_window_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_base_defense"), nil, 
    {
       terminal_name = "formation_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        form_type = 1,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_open_base_protet"), nil, 
    {
        terminal_name = "world_battle_event_info_struck_to_buy",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_incoming_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_incoming_arrow_up")
    
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
    
    self:onUpdateDraw()
end

function WorldBattleEventInfoStruck:onEnterTransitionFinish()

end

function WorldBattleEventInfoStruck:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function WorldBattleEventInfoStruck:onExit()
    state_machine.remove("world_battle_event_info_struck_show")
    state_machine.remove("world_battle_event_info_struck_hide")
    state_machine.remove("world_battle_event_info_struck_update")
    state_machine.remove("world_battle_event_info_struck_to_buy")
end