--------------------------------------------------------------------------------------------------------------
--  说明：城市繁荣度购买
--------------------------------------------------------------------------------------------------------------
LegionCityOccupyRecovery = class("LegionCityOccupyRecoveryClass", Window)

--打开界面
local legion_city_occupy_recovery_open_terminal = {
    _name = "legion_city_occupy_recovery_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LegionCityOccupyRecoveryClass") == nil then
            fwin:open(LegionCityOccupyRecovery:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_occupy_recovery_close_terminal = {
    _name = "legion_city_occupy_recovery_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityOccupyRecoveryClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_occupy_recovery_open_terminal)
state_machine.add(legion_city_occupy_recovery_close_terminal)
state_machine.init()

function LegionCityOccupyRecovery:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._city_id = 0
    self._info = nil

    local function init_legion_city_occupy_recovery_terminal()
        local legion_city_occupy_recovery_buy_terminal = {
            _name = "legion_city_occupy_recovery_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local cost = zstring.split(dms.string(dms["world_city_config"], 10, world_city_config.param), "|")
                local info = zstring.split(cost[index], ",")
                local prop_id = tonumber(info[3])
                local item_value = tonumber(info[4])
                if prop_id == 1 and item_value > tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(red_alert_time_str[52])
                    return
                elseif prop_id == 2 and item_value > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("recharge_tip_window_open", 0, "")
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[107])
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        state_machine.excute("legion_city_occupy_update_list_info", 0, "")
                        state_machine.excute("legion_city_occupy_infor_update_draw", 0, "")
                        state_machine.excute("main_window_update_resource", 0, "")
                        state_machine.excute("main_window_update_gold_info", 0, "")
                    end
                end
                protocol_command.world_city_boom_recover.param_list = ""..instance._info.city_id.."\r\n"..(index - 1)
                NetworkManager:register(protocol_command.world_city_boom_recover.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_occupy_recovery_buy_terminal) 
        state_machine.init()
    end
    
    init_legion_city_occupy_recovery_terminal()
end

function LegionCityOccupyRecovery:updateDraw()
    local root = self.roots[1]

    self._info = _ED.world_city_info.detail_info[""..self._city_id]

    local LoadingBar_city_occupy_recovery_boom = ccui.Helper:seekWidgetByName(root, "LoadingBar_city_occupy_recovery_boom")
    local Text_city_occupy_recovery_boom_n = ccui.Helper:seekWidgetByName(root, "Text_city_occupy_recovery_boom_n")
    local Text_legion_city_occupy_recovery_res_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_recovery_res_n")

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local max_boom = dms.atoi(city_data, world_city_mould.max_boom)

    local current_boom = tonumber(self._info.boom)
    local percent = (current_boom * 100) / max_boom
    LoadingBar_city_occupy_recovery_boom:setPercent(percent)
    Text_city_occupy_recovery_boom_n:setString(""..exChangeNumToString(current_boom).."/"..exChangeNumToString(max_boom))

    local max_count = dms.int(dms["world_city_config"], 11, world_city_config.param)
    local current_count = tonumber(_ED.world_city_info.my_info.buy_boom_times)
    current_count = math.min(max_count, math.max(0, current_count))
    Text_legion_city_occupy_recovery_res_n:setString(""..current_count.."/"..max_count)

    local cost = zstring.split(dms.string(dms["world_city_config"], 10, world_city_config.param), "|")
    for i = 1, 4 do
        local Panel_legion_city_occupy_recovery_list = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_occupy_recovery_list_"..i)
        local Button_recovery_list = Panel_legion_city_occupy_recovery_list:getChildByName("Button_recovery_list")
        local Text_recovery_boom_n = Panel_legion_city_occupy_recovery_list:getChildByName("Text_recovery_boom_n")
        local Text_recovery_consume_props_n = Panel_legion_city_occupy_recovery_list:getChildByName("Text_recovery_consume_props_n")

        local info = zstring.split(cost[i], ",")
        local prop_name = dms.string(dms["prop_mould"], info[3], prop_mould.prop_name)
        Text_recovery_boom_n:setString(string.format(world_city_tip_str[15], tonumber(info[1])))
        Text_recovery_consume_props_n:setString(string.format(world_city_tip_str[16], exChangeNumToString(info[4]), prop_name))

        if current_boom >= max_boom or (current_count <= 0 and i <= 3) then
            Button_recovery_list:setTouchEnabled(false)
            Button_recovery_list:setBright(false)
        else
            Button_recovery_list:setTouchEnabled(true)
            Button_recovery_list:setBright(true)
        end
    end
end

--初始化
function LegionCityOccupyRecovery:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_occupy_recovery)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_city_occupy_recovery_colse"), nil, 
    {
        terminal_name = "legion_city_occupy_recovery_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_occupy_recovery_close", 
        terminal_state = 0, 
    }, nil, 3)

    for i=1,4 do
        local Panel_legion_city_occupy_recovery_list = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_occupy_recovery_list_"..i)
        local Button_recovery_list = Panel_legion_city_occupy_recovery_list:getChildByName("Button_recovery_list")
        fwin:addTouchEventListener(Button_recovery_list, nil, 
        {
            terminal_name = "legion_city_occupy_recovery_buy", 
            terminal_state = 0, 
            touch_black = true,
            index = i,
        }, nil, 1)
    end

    self:updateDraw()
end

function LegionCityOccupyRecovery:onEnterTransitionFinish()

end

function LegionCityOccupyRecovery:init(param)
    self._city_id = param[1]
    self:onInit()
    return self
end

function LegionCityOccupyRecovery:onExit()
    state_machine.remove("legion_city_occupy_recovery_buy")
end