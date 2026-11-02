--------------------------------------------------------------------------------------------------------------
--  阵容选择
--------------------------------------------------------------------------------------------------------------
FormationChooseTroop = class("FormationChooseTroopClass", Window)

local formation_choose_troop_window_open_terminal = {
    _name = "formation_choose_troop_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FormationChooseTroopClass") == nil then
            fwin:open(FormationChooseTroop:new():init(params), fwin._ui)  
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local formation_choose_troop_window_close_terminal = {
    _name = "formation_choose_troop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationChooseTroopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_choose_troop_window_open_terminal)
state_machine.add(formation_choose_troop_window_close_terminal)
state_machine.init()

function FormationChooseTroop:ctor()
    self.super:ctor()
    self.roots = {}

    self._from_type = 0
    self._have_choose_formation = {}

    self._choose_formation_index = 0
    self._choose_ship = nil
    self._choose_ship_count = 0
    self._choose_ship_max_count = 0

    self._choose_cell = nil

    self._panel_input = nil
    
    app.load("client.red_alert_time.cells.formation.formation_choose_troop_cell")
    app.load("client.red_alert_time.cells.player.input_digital_window")
    app.load("client.red_alert_time.legion.LegionCityFormaitonChangeSure")
    local function init_formation_choose_troop_terminal()
        local formation_choose_troop_update_choose_info_terminal = {
            _name = "formation_choose_troop_update_choose_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateChooseShipInfo(params[1], params[2], params[3])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_choose_troop_update_select_info_terminal = {
            _name = "formation_choose_troop_update_select_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateSelectState(params[1])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

            local formation_choose_troop_choose_ok_terminal = {
                _name = "formation_choose_troop_choose_ok",
                _init = function (terminal) 
                    
                end,
                _inited = false,
                _instance = self,
                _state = 0,
                _invoke = function(terminal, instance, params) 
                    state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                    local change_info = {}
                    change_info.choose_formation_index = instance._choose_formation_index
                    change_info.choose_ship = instance._choose_ship
                    change_info.choose_ship_count = instance._choose_ship_count
                    if instance._from_type == 18 then
                        state_machine.excute("legion_city_formaiton_change_sure_window_open", 0, {instance._choose_ship, instance._choose_ship_count})
                    else
                        state_machine.excute("formation_defend_update_once_tank_info", 0, change_info)
                        state_machine.excute("formation_choose_troop_window_close", 0, nil)
                        if fwin:find("ArenaWindowClass")~= nil then
                            state_machine.excute("arena_troops_tab_update_once_tank_info", 0, change_info)
                        end
                    end
                    return true
                end,
                _terminal = nil,
                _terminals = nil
            }

        local formation_choose_troop_change_choose_count_terminal = {
            _name = "formation_choose_troop_change_choose_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                if instance._choose_cell == nil then
                    return
                end
                instance._choose_ship_count = instance._choose_ship_count + params._datas.add
                if instance._choose_ship_count < 1 then
                    instance._choose_ship_count = 1
                    return
                end

                if instance._choose_ship_count > instance._choose_ship_max_count then
                    instance._choose_ship_count = instance._choose_ship_max_count
                    return
                end
                local percent = math.floor(instance._choose_ship_count / instance._choose_ship_max_count * 100)
                instance:updateChooseShipCount(percent)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local formation_choose_troop_update_slider_terminal = {
            _name = "formation_choose_troop_update_slider",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                if instance._choose_cell == nil then
                    return
                end
                local percent = params[2]
                instance._choose_ship_count = math.ceil(tonumber(percent) * instance._choose_ship_max_count / 100)
                if instance._choose_ship_count < 1 then
                    instance._choose_ship_count = 1
                    percent = math.floor(instance._choose_ship_count / instance._choose_ship_max_count * 100)
                end
                if instance._choose_ship_count > instance._choose_ship_max_count then
                    instance._choose_ship_count = instance._choose_ship_max_count
                    percent = 100
                end
                instance:updateChooseShipCount(percent)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭键盘
        local formation_choose_troop_close_input_digital_terminal = {
            _name = "formation_choose_troop_close_input_digital",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._panel_input:removeAllChildren(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新上阵数量
        local formation_choose_troop_update_select_number_terminal = {
            _name = "formation_choose_troop_update_select_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._choose_ship_count = params[1]
                local percent = math.floor(instance._choose_ship_count / instance._choose_ship_max_count * 100)
                instance:updateChooseShipCount(percent)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 弹出键盘
        local formation_choose_troop_open_input_digital_terminal = {
            _name = "formation_choose_troop_open_input_digital",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("formation_choose_troop_close_input_digital", 0, "")
                local cell = InputDigitalWindow:createCell()
                cell:init(7, self._choose_ship_max_count)
                instance._panel_input:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(formation_choose_troop_update_choose_info_terminal)
        state_machine.add(formation_choose_troop_update_select_info_terminal)
        state_machine.add(formation_choose_troop_choose_ok_terminal)
        state_machine.add(formation_choose_troop_change_choose_count_terminal)
        state_machine.add(formation_choose_troop_update_slider_terminal)
        state_machine.add(formation_choose_troop_close_input_digital_terminal)
        state_machine.add(formation_choose_troop_update_select_number_terminal)
        state_machine.add(formation_choose_troop_open_input_digital_terminal)
        state_machine.init()
    end
    init_formation_choose_troop_terminal()
end

function FormationChooseTroop:updateChooseShipInfo( choose_cell, choose_ship, max_count )
    self._choose_cell = choose_cell
    self._choose_ship = choose_ship

    if self._from_type == 18 then
        local change_factor = dms.int(dms["world_city_config"], 35, world_city_config.param)
        local max_have_count = dms.int(dms["world_city_config"], 36, world_city_config.param)
        local max_choose_count = math.floor(max_have_count / change_factor)
        local current_change_count = math.ceil(zstring.tonumber(choose_ship.city_ship_count) / change_factor)
        max_count = math.min(max_count, max_choose_count - current_change_count)
    else
        -- 限制带兵数量
        if max_count > tonumber(_ED.user_info.soldier) then
            max_count = tonumber(_ED.user_info.soldier)
        end
    end

    self._choose_ship_count = max_count
    self._choose_ship_max_count = max_count
    local percent = math.floor(self._choose_ship_count / self._choose_ship_max_count * 100)
    self:updateChooseShipCount(percent)
end

function FormationChooseTroop:updateChooseShipCount( percent )
    local root = self.roots[1]
    local Text_choose_troops_have_n = ccui.Helper:seekWidgetByName(root,"Text_choose_troops_have_n")
    Text_choose_troops_have_n:setString(self._choose_ship_count)
    local Slider_choose_troops = ccui.Helper:seekWidgetByName(root, "Slider_choose_troops")
    Slider_choose_troops:setPercent(percent)
    self._choose_cell:updateChooseNum(self._choose_ship_count)
    if self._from_type == 18 then
        self:updateFormationChangeInfo()
    end
end

function FormationChooseTroop:updateSelectState( select_index )
    local root = self.roots[1]
    local ScrollView_choose_troops = ccui.Helper:seekWidgetByName(root,"ScrollView_choose_troops")
    for k,v in pairs(ScrollView_choose_troops:getChildren()) do
        if k == select_index then
            v._select = true
        else
            v._select = false
        end
        v:setSelectState()
    end
end

function FormationChooseTroop:updateFormationChangeInfo()
    local root = self.roots[1]
    local Panel_legion_city_formation_change = ccui.Helper:seekWidgetByName(root,"Panel_legion_city_formation_change")
    local Panel_legion_city_formation_change_full = ccui.Helper:seekWidgetByName(root,"Panel_legion_city_formation_change_full")
    local change_factor = dms.int(dms["world_city_config"], 35, world_city_config.param)
    local max_count = dms.int(dms["world_city_config"], 36, world_city_config.param)
    
    local have_count = zstring.tonumber(self._choose_ship.city_ship_count)
    if have_count > max_count - change_factor then
        Panel_legion_city_formation_change:setVisible(false)
        Panel_legion_city_formation_change_full:setVisible(true)
        
        local Text_city_formation_change_all_n = ccui.Helper:seekWidgetByName(root,"Text_city_formation_change_all_n")
        Text_city_formation_change_all_n:setString(have_count)
    else
        Panel_legion_city_formation_change:setVisible(true)
        Panel_legion_city_formation_change_full:setVisible(false)

        local Text_city_formation_change_n = ccui.Helper:seekWidgetByName(root,"Text_city_formation_change_n")
        Text_city_formation_change_n:setString(self._choose_ship_count * change_factor)
    end
end

function FormationChooseTroop:updateDraw()
    local root = self.roots[1]
    local ScrollView_choose_troops = ccui.Helper:seekWidgetByName(root,"ScrollView_choose_troops")
    ScrollView_choose_troops:removeAllChildren(true)

    local width = ScrollView_choose_troops:getContentSize().width
    local height = ScrollView_choose_troops:getContentSize().height
    local temp_cell = state_machine.excute("formation_choose_troop_cell_create",0,{0, nil})
    local size = temp_cell:getContentSize()

    local ship_list = {}
    for k, v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            local isNeedPush = true
            local count = zstring.tonumber(v.current_count)
            if self._from_type == 16 or self._from_type == 17 then
                count = zstring.tonumber(v.city_current_count)
            end 
            if self._from_type == 8 then
                count = count - zstring.tonumber(v.expedition_lose_count)
            elseif self._from_type == 14 then
                count = count + zstring.tonumber(v.union_fight_count)
            end
            if count > 0 then
                for k1,v1 in pairs(self._have_choose_formation) do
                    if v1.ship ~= nil then
                        if zstring.tonumber(v.ship_id) == zstring.tonumber(v1.ship.ship_id) then
                            count = count - zstring.tonumber(v1.choose_count)
                            if count <= 0 then
                                isNeedPush = false
                                break
                            end
                        end
                    end
                end
                if isNeedPush == true then
                    table.insert(ship_list, {v, count})
                end
            end
        end
    end

    if self._from_type == 18 then
        local order_types = {3, 1, 2, 4}        -- 按火箭、坦克、火炮、特种兵顺序排序
        local function sortTank(a, b)
            local order_a = dms.int(dms["ship_mould"], a[1].ship_template_id, ship_mould.base_mould_priority)
            local order_b = dms.int(dms["ship_mould"], b[1].ship_template_id, ship_mould.base_mould_priority)
            if a[1].ship_type > b[1].ship_type
                or (a[1].ship_type == b[1].ship_type and order_types[a[1].camp_preference] > order_types[b[1].camp_preference])
                or (a[1].ship_type == b[1].ship_type and order_types[a[1].camp_preference] == order_types[b[1].camp_preference] and order_a > order_b)
                then
                return true
            end 
            return false
        end
        table.sort(ship_list, sortTank)
    else
        local function sortTank(a, b)
            local order_a = dms.int(dms["ship_mould"], a[1].ship_template_id, ship_mould.base_mould_priority)
            local order_b = dms.int(dms["ship_mould"], b[1].ship_template_id, ship_mould.base_mould_priority)
            return order_a > order_b
        end
        table.sort(ship_list, sortTank)
    end

    local tank_count = #ship_list
    local scroll_height = math.ceil(tank_count / 4)

    if scroll_height*size.height > height then
        height = scroll_height*size.height
    end
    ScrollView_choose_troops:getInnerContainer():setContentSize(cc.size(width,height))
    
    for k,v in pairs(ship_list) do
        local row = math.floor((k - 1) % 4)
        local col = math.floor((k - 1) / 4)
        local cell = state_machine.excute("formation_choose_troop_cell_create", 0, {k, v[1], v[2]})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p(row*(width/4),height - col*size.height))
        ScrollView_choose_troops:addChild(cell)
    end
    self:updateSelectState(1)

    local Text_legion_city_formation_k = ccui.Helper:seekWidgetByName(root, "Text_legion_city_formation_k")
    if Text_legion_city_formation_k ~= nil then
        if #ship_list == 0 then
            Text_legion_city_formation_k:setVisible(true)
        else
            Text_legion_city_formation_k:setVisible(false)
        end
    end

    ScrollView_choose_troops:jumpToTop()
end

function FormationChooseTroop:onInit()
    local csbItem = nil
    if self._from_type == 18 then       -- 城市战部队兑换
        csbItem = csb.createNode(config_csb.legion.legion_city_formation_change)
    else
        csbItem = csb.createNode(config_csb.formation.formation_choose_troops)
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose_troops_close"), nil, 
    {
        terminal_name = "formation_choose_troop_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_formation_close"), nil, 
    {
        terminal_name = "formation_choose_troop_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_add"), nil, 
    {
        terminal_name = "formation_choose_troop_change_choose_count", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95,
        add = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_minus"), nil, 
    {
        terminal_name = "formation_choose_troop_change_choose_count", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95,
        add = -1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose_troops_sure"), nil, 
    {
        terminal_name = "formation_choose_troop_choose_ok", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose_troops_con"), nil, 
    {
        terminal_name = "formation_choose_troop_window_close", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_choose_troops_n"), nil, 
    {
        terminal_name = "formation_choose_troop_open_input_digital", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ScrollView_choose_troops"), nil, 
    {
        terminal_name = "formation_choose_troop_close_input_digital", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_bg"), nil, 
    {
        terminal_name = "formation_choose_troop_close_input_digital", 
        terminal_state = 0, 
    }, nil, 1)

    local Slider_choose_troops = ccui.Helper:seekWidgetByName(root, "Slider_choose_troops")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("formation_choose_troop_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_choose_troops._self = self
    Slider_choose_troops:addEventListener(percentChangedEvent)

    local Panel_num_input = ccui.Helper:seekWidgetByName(root, "Panel_num_input")
    self._panel_input = Panel_num_input

    self:updateDraw()
end

function FormationChooseTroop:onEnterTransitionFinish()
    
end

function FormationChooseTroop:init(params)
    self._choose_formation_index = params[1]
    self._have_choose_formation = params[2]
    self._from_type = params[3]
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function FormationChooseTroop:onExit()
    state_machine.remove("formation_choose_troop_update_choose_info")
    state_machine.remove("formation_choose_troop_update_select_info")
    state_machine.remove("formation_choose_troop_choose_ok")
    state_machine.remove("formation_choose_troop_change_choose_count")
    state_machine.remove("formation_choose_troop_update_slider")
    state_machine.remove("formation_choose_troop_close_input_digital")
    state_machine.remove("formation_choose_troop_update_select_number")
    state_machine.remove("formation_choose_troop_open_input_digital")
end