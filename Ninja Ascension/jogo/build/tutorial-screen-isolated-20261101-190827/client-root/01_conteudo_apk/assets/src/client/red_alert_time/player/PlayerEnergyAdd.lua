--------------------------------------------------------------------------------------------------------------
--  说明：体力购买
--------------------------------------------------------------------------------------------------------------
PlayerEnergyAdd = class("PlayerEnergyAddClass", Window)

--打开界面
local player_energy_add_open_terminal = {
    _name = "player_energy_add_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("PlayerEnergyAddClass") == nil then
            fwin:open(PlayerEnergyAdd:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local player_energy_add_close_terminal = {
    _name = "player_energy_add_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerEnergyAddClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(player_energy_add_open_terminal)
state_machine.add(player_energy_add_close_terminal)
state_machine.init()
    
function PlayerEnergyAdd:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._select_num = 0
    self._max_select_num = 0
    self._need_gold = 0
    self._get_energy = 0

    self._text_time = 0
    self._reset_times = 0
    local function init_player_energy_add_terminal()

        local player_energy_add_num_add_terminal = {
            _name = "player_energy_add_num_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num + 1
                if select_num > instance._max_select_num then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_energy_add_num_mimus_terminal = {
            _name = "player_energy_add_num_mimus",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num - 1
                if select_num < 0 then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local player_energy_add_over_update_terminal = {
            _name = "player_energy_add_over_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Slider_num = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_buy_num")
                local select_num = math.ceil(tonumber(Slider_num:getPercent()) * instance._max_select_num / 100)
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --购买次数
        local player_energy_add_over_buy_number_terminal = {
            _name = "player_energy_add_over_buy_number",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseBuyResourceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            TipDlg.drawTextDailog(string.format(red_alert_time_str[4],response.node._get_energy))
                            state_machine.excute("player_energy_add_close",0,"")
                            state_machine.excute("player_infomation_update_info",0,"")
                            state_machine.excute("main_window_update_userinfo", 0, nil)
                            state_machine.excute("pve_raid_update_draw", 0, nil)
                            state_machine.excute("pve_map_update_energy", 0, nil)
                        end
                    end
                end
                -- 判断是否有购买次数
                if instance._max_select_num <= 0 then
                    TipDlg.drawTextDailog(red_alert_time_str[5])
                    state_machine.excute("player_energy_add_close",0,"")
                    return
                end
                -- 判断金币数量够不够
                if instance._need_gold > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_dialog_window_open",0,"")
                    state_machine.excute("player_energy_add_close",0,"")
                    return
                end
                protocol_command.basic_consumption.param_list = "".."59".."\r\n" .. instance._select_num
                NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil,instance, responseBuyResourceCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        state_machine.add(player_energy_add_over_update_terminal)
        state_machine.add(player_energy_add_over_buy_number_terminal)
        state_machine.add(player_energy_add_num_add_terminal)
        state_machine.add(player_energy_add_num_mimus_terminal)
        state_machine.init()
    end
    
    init_player_energy_add_terminal()
    
end

function PlayerEnergyAdd:onUpdateDraw()
    local root = self.roots[1]
    self._text_time = nil
    local Text_buy_time_next = ccui.Helper:seekWidgetByName(root, "Text_buy_time_next")
    if Text_buy_time_next ~= nil then
        local server_time = getCurrentGTM8Time()
        self._reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1
        Text_buy_time_next:setString(getRedAlertTimeActivityFormat(self._reset_times))
        self._text_time = Text_buy_time_next
    end
end

function PlayerEnergyAdd:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
    self:updateSliderInfo(percent)
end

function PlayerEnergyAdd:updateSliderInfo(percent)
    local root = self.roots[1]
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_buy_num")
    --选择的次数
    local Text_buy_time_n = ccui.Helper:seekWidgetByName(root, "Text_buy_time_n")
    local Text_buy_time_p_2 = ccui.Helper:seekWidgetByName(root, "Text_buy_time_p_2")
    Text_buy_time_p_2:setString(string.format(red_alert_time_str[3], self._max_select_num))

    local Panel_energ_add_icon = ccui.Helper:seekWidgetByName(root, "Panel_energ_add_icon")
    if Panel_energ_add_icon ~= nil then
        Panel_energ_add_icon:removeAllChildren(true)
        Panel_energ_add_icon:addChild(state_machine.excute("props_icon_create_cell",0,{6, 1, 12, 1, -1}))
    end
    --消耗的金币
    local Text_consume_buy_time_n = ccui.Helper:seekWidgetByName(root, "Text_consume_buy_time_n")
    local Text_buy_time_n_0 = ccui.Helper:seekWidgetByName(root, "Text_buy_time_n_0")
    self._current_silder = percent

    if self._max_select_num > 0 and self._select_num == 0 then
        self._select_num = 1
    end
    local pirates_config_str = dms.string(dms["shop_config"],4,shop_config.param)
    local pirates_config_tab = zstring.split(pirates_config_str,"|")
    local now_times = zstring.tonumber(_ED.food_ready_buy_times) + 1
    
    if __lua_project_id == __lua_project_pacific_rim then
        Text_buy_time_n:setString(self._select_num.."/"..dms.int(dms["base_consume"],59,base_consume.vip_0_value + tonumber(_ED.vip_grade)))
    else
        Text_buy_time_n:setString(self._select_num)
    end
    
    self._need_gold = 0
    self._get_energy = 0
    for i=_ED.food_ready_buy_times+1,_ED.food_ready_buy_times+self._select_num do
        if i >= #pirates_config_tab then
            local cost = zstring.split(pirates_config_tab[#pirates_config_tab],",")
            self._need_gold = self._need_gold + cost[2]
            self._get_energy = self._get_energy + cost[3]
        else
            local cost = zstring.split(pirates_config_tab[i],",")
            self._need_gold = self._need_gold + cost[2]
            self._get_energy = self._get_energy + cost[3]
        end
    end

    Text_consume_buy_time_n:setString(self._need_gold)
    Text_buy_time_n_0:setString(self._get_energy)
    Slider_num:setPercent(self._current_silder)
end

function PlayerEnergyAdd:onUpdate(dt)
    if self._reset_times > 0 and self._text_time ~= nil then
        self._reset_times = self._reset_times - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._reset_times))
        if self._reset_times <= 0 then
            self._reset_times = 0
            self:onUpdateDraw()
        end
    end
end

function PlayerEnergyAdd:init()
    
    self:onInit()
    return self
end

function PlayerEnergyAdd:onInit()
    local csbItem = csb.createNode(config_csb.player.player_energy_add_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    
    --确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_sure"), nil, 
    {
        terminal_name = "player_energy_add_over_buy_number", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    
    --取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_cancel"), nil, 
    {
        terminal_name = "player_energy_add_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_time_close"), nil, 
    {
        terminal_name = "player_energy_add_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "player_energy_add_close", 
        terminal_state = 0, 
    }, nil, 3)
    
    -- 增加
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_add"), nil, 
    {
        terminal_name = "player_energy_add_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 减少
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_minus"), nil, 
    {
        terminal_name = "player_energy_add_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    
    --计算最大值
    local max_count = dms.int(dms["base_consume"],59,base_consume.vip_0_value + tonumber(_ED.vip_grade))
    self._max_select_num = max_count - zstring.tonumber(_ED.food_ready_buy_times)
    
    -- local Slider_buy_num
    -- 滑动选择
    local Slider_num = ccui.Helper:seekWidgetByName(root, "Slider_buy_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("player_energy_add_over_update", 0, {sender:getPercent()})
        end
    end
    Slider_num:addEventListener(percentChangedEvent)
    
    
    self:setSelectNum(1)
    self:onUpdateDraw()
end

function PlayerEnergyAdd:onExit()
    state_machine.remove("player_energy_add_num_add")
    state_machine.remove("player_energy_add_num_mimus")
    state_machine.remove("player_energy_add_over_update")
    state_machine.remove("player_energy_add_over_buy_number")
end