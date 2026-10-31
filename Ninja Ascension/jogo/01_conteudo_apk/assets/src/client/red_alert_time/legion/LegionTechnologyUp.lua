-- ------------------------------------------------------------------------------------------------------------
--  说明：科技捐献升级
-- ------------------------------------------------------------------------------------------------------------
LegionTechnologyUp = class("LegionTechnologyUpClass", Window)

--打开界面
local legion_technology_up_window_open_terminal = {
    _name = "legion_technology_up_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionTechnologyUpClass") == nil then
            local _win = LegionTechnologyUp:new()
            local science_id = params._datas.science_id
            _win:init(science_id)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_technology_up_window_close_terminal = {
    _name = "legion_technology_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionTechnologyUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_technology_up_window_open_terminal)
state_machine.add(legion_technology_up_window_close_terminal)
state_machine.init()

function LegionTechnologyUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._science_id = 0
    self._can_donate_state = {0, 0, 0, 0, 0}    -- 0：可捐献，1：资源不足

     -- Initialize alert_home state machine.
    local function init_legion_technology_up_terminal()
        local legion_technology_up_update_draw_terminal = {
            _name = "legion_technology_up_update_draw",
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

        local legion_technology_up_donate_terminal = {
            _name = "legion_technology_up_donate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local donate_type = params._datas.donate_type
                if donate_type == 1 then
                    if instance._can_donate_state[index] == 1 then
                        TipDlg.drawTextDailog(string.format(tipString_legion_info[30], tipStringInfo_build_up_info[15 + index]))
                        return
                    end
                else
                    if tonumber(_ED.vip_grade) == 0 then
                        TipDlg.drawTextDailog(tipString_legion_info[32])
                        return
                    end
                end
                state_machine.excute("legion_technology_up_res_window_open", 0, {instance._science_id, index, donate_type})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_technology_up_update_draw_terminal)
        state_machine.add(legion_technology_up_donate_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_technology_up_terminal()
end

-- 显示信息
function LegionTechnologyUp:onUpdateDraw()
    local root = self.roots[1]
    local Text_technology_name_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_name_lv")

    local science_info = _ED.union_science_info[""..self._science_id]
    Text_technology_name_lv:setString(science_info.name..string.format(red_alert_time_str[33], science_info.level))

    local group_id = dms.int(dms["union_science_mould"], self._science_id, union_science_mould.donate_group)
    local times_info = zstring.split(_ED.union_science_donate_times, ",")

    local have_res = {
        tonumber(_ED.user_info.user_iron),
        tonumber(_ED.user_info.oil_field),
        tonumber(_ED.user_info.exploits),
        tonumber(_ED.user_info.tiger_shaped),
        tonumber(_ED.user_info.user_silver),
    }

    for i = 1, 5 do
        local Text_donate_time_n = ccui.Helper:seekWidgetByName(root, "Text_donate_time_n_"..i)
        local Text_donate_res_n = ccui.Helper:seekWidgetByName(root, "Text_donate_res_n_"..i)
        local Text_gold_n = ccui.Helper:seekWidgetByName(root, "Text_gold_n_"..i)
        local Button_donate = ccui.Helper:seekWidgetByName(root, "Button_donate_"..i)
        local Button_donate_gold = ccui.Helper:seekWidgetByName(root, "Button_donate_gold_"..i)
        local current_times = tonumber(times_info[i]) + 1
        local max_times = dms.int(dms["base_consume"], 91, base_consume.vip_0_value + tonumber(_ED.vip_grade))
        Text_donate_time_n:setString(times_info[i].."/"..max_times)
        local cost_res_info = zstring.split(_ED.base_legion_science_level_info[""..group_id][""..current_times].cost_res[i], ",")
        local cost_gold_info = zstring.split(_ED.base_legion_science_level_info[""..group_id][""..current_times].cost_gold[i], ",")
        Text_donate_res_n:setString(exChangeNumToString(cost_res_info[3]) .."/".. exChangeNumToString(have_res[i]))
        Text_gold_n:setString(cost_gold_info[3])
        if tonumber(cost_res_info[3]) > have_res[i] then
            self._can_donate_state[i] = 1
            Text_donate_res_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        else
            self._can_donate_state[i] = 0
            Text_donate_res_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end

        if tonumber(times_info[i]) >= max_times then
            Button_donate:setTouchEnabled(false)
            Button_donate:setBright(false)
            Button_donate_gold:setTouchEnabled(false)
            Button_donate_gold:setBright(false)
        else
            Button_donate:setTouchEnabled(true)
            Button_donate:setBright(true)
            Button_donate_gold:setTouchEnabled(true)
            Button_donate_gold:setBright(true)
        end

        if tonumber(_ED.vip_grade) == 0 then
            Button_donate_gold:setBright(false)
        end
    end
end

--初始化界面
function LegionTechnologyUp:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_technology_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_up_close"), nil, 
    {
        terminal_name = "legion_technology_up_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_technology_up_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    for i = 1, 5 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_donate_"..i), nil, 
        {
            terminal_name = "legion_technology_up_donate", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
            donate_type = 1,
        }, nil, 1)   

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_donate_gold_"..i), nil, 
        {
            terminal_name = "legion_technology_up_donate", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
            donate_type = 2,
        }, nil, 1)   
    end

    self:onUpdateDraw()
end

--初始化
function LegionTechnologyUp:init(science_id)
    self._science_id = science_id
    self:onInit()
end

--移除状态机
function LegionTechnologyUp:onExit()
    state_machine.remove("legion_technology_up_update_draw")
    state_machine.remove("legion_technology_up_donate")
end