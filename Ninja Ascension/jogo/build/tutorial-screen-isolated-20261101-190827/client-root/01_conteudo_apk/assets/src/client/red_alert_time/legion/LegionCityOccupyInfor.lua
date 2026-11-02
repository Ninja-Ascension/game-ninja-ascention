-- ------------------------------------------------------------------------------------------------------------
--  说明：城市属性
-- ------------------------------------------------------------------------------------------------------------
LegionCityOccupyInfor = class("LegionCityOccupyInforClass", Window)

--打开界面
local legion_city_occupy_infor_window_open_terminal = {
    _name = "legion_city_occupy_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local city_id = params[1]
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionCityOccupyInforClass") == nil then
                    local _win = LegionCityOccupyInfor:new()
                    _win:init(params)
                    fwin:open(_win,fwin._ui)
                end
                state_machine.excute("legion_city_occupy_update_list_info", 0, "")
            end
        end

        protocol_command.world_city_detail_get.param_list = ""..city_id
        NetworkManager:register(protocol_command.world_city_detail_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_occupy_infor_window_close_terminal = {
    _name = "legion_city_occupy_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityOccupyInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_occupy_infor_window_open_terminal)
state_machine.add(legion_city_occupy_infor_window_close_terminal)
state_machine.init()

function LegionCityOccupyInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

	self._mould_id = 0
    self._info = nil

    app.load("client.red_alert_time.legion.LegionCityOccupyRecovery")

     -- Initialize alert_home state machine.
    local function init_legion_city_occupy_infor_window_terminal()
        -- 繁荣度恢复
        local legion_city_occupy_infor_recovery_terminal = {
            _name = "legion_city_occupy_infor_recovery",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_city_occupy_recovery_open", 0, {instance._info.city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_occupy_infor_update_draw_terminal = {
            _name = "legion_city_occupy_infor_update_draw",
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

        state_machine.add(legion_city_occupy_infor_recovery_terminal)
        state_machine.add(legion_city_occupy_infor_update_draw_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_city_occupy_infor_window_terminal()
end

-- 显示信息
function LegionCityOccupyInfor:onUpdateDraw()
    local root = self.roots[1]

    self._info = _ED.world_city_info.detail_info[""..self._mould_id]
    -- 繁荣度
    local LoadingBar_city_occupy_boom = ccui.Helper:seekWidgetByName(root, "LoadingBar_city_occupy_boom")
    local Text_city_occupy_boom_n = ccui.Helper:seekWidgetByName(root, "Text_city_occupy_boom_n")

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local resource_info = dms.atos(city_data, world_city_mould.resource_info)
    local max_boom = dms.atoi(city_data, world_city_mould.max_boom)

    local current_boom = tonumber(self._info.boom)
    local percent = (current_boom * 100) / max_boom
    LoadingBar_city_occupy_boom:setPercent(percent)
    Text_city_occupy_boom_n:setString(""..exChangeNumToString(current_boom).."/"..exChangeNumToString(max_boom))

    -- 产出降低
    local Text_legion_city_occupy_res_yield_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_yield_t")
    local Text_legion_city_occupy_res_yield_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_yield_n")
    local factor = 1
    local is_reduce = false
    if current_boom < max_boom then
        Text_legion_city_occupy_res_yield_t:setVisible(true)
        Text_legion_city_occupy_res_yield_n:setVisible(true)
        is_reduce = true

        local reduce_info = zstring.split(dms.string(dms["world_city_config"], 5, world_city_config.param), "|")
        for k, v in pairs(reduce_info) do
            local info = zstring.split(v, ",")
            if percent > (tonumber(info[1]) * 100) then
                break
            end
            factor = tonumber(info[2])
        end
        Text_legion_city_occupy_res_yield_n:setString(""..((1 - factor) * 100).."%")
    else
        Text_legion_city_occupy_res_yield_t:setVisible(false)
        Text_legion_city_occupy_res_yield_n:setVisible(false)
        is_reduce = false
    end


    -- 资源产量
    local res_info = zstring.split(resource_info, "|")
    local Panel_legion_city_occupy_res_1 = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_occupy_res_1")
    for i = 1, 5 do
        local Text_legion_city_occupy_res = Panel_legion_city_occupy_res_1:getChildByName("Text_legion_city_occupy_res_"..i)
        local Text_legion_city_occupy_res_n = Panel_legion_city_occupy_res_1:getChildByName("Text_legion_city_occupy_res_n_"..i)
        if is_reduce == true then
            Text_legion_city_occupy_res:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
            Text_legion_city_occupy_res_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        else
            Text_legion_city_occupy_res:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
            Text_legion_city_occupy_res_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
        local out_put = 0
        if res_info[i] ~= nil then
            local info = zstring.split(res_info[i], ",")
            out_put = zstring.tonumber(info[2]) * 3600 * factor
        end
        Text_legion_city_occupy_res_n:setString(exChangeNumToString(out_put)..world_city_tip_str[3])
    end

    -- 资源产出
    local res_info = zstring.split(self._info.resource_info, "|")
    local Panel_legion_city_occupy_res_2 = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_occupy_res_2")
    for i = 1, 5 do
        local Text_legion_city_occupy_res_n = Panel_legion_city_occupy_res_2:getChildByName("Text_legion_city_occupy_res_n_"..i)
        local out_put = 0
        if res_info[i] ~= nil then
            local info = zstring.split(res_info[i], ",")
            out_put = zstring.tonumber(info[3])
        end
        Text_legion_city_occupy_res_n:setString(exChangeNumToString(out_put))
    end
end

--初始化界面
function LegionCityOccupyInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_occupy_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_occupy_infor_colse"), nil, 
    {
        terminal_name = "legion_city_occupy_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_occupy_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    -- 恢复
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_occupy_recovery"), nil, 
    {
        terminal_name = "legion_city_occupy_infor_recovery", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)  

    -- 帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_infor"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        infor_type = 5,
    }, nil, 1)  

    self:onUpdateDraw()
end

--初始化
function LegionCityOccupyInfor:init(params)
    self._mould_id = params[1]

    self:onInit()
end

--移除状态机
function LegionCityOccupyInfor:onExit()
    state_machine.remove("legion_city_occupy_infor_recovery")
    state_machine.remove("legion_city_occupy_infor_update_draw")
end