-- ------------------------------------------------------------------------------------------------------------
--  说明：道具信息提示
-- ------------------------------------------------------------------------------------------------------------
PropsBatchBuySure = class("PropsBatchBuySureClass", Window)

--打开界面
local props_batch_buy_sure_window_open_terminal = {
    _name = "props_batch_buy_sure_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsBatchBuySureClass") == nil then
            local _win = PropsBatchBuySure:new()
            _win:init(params)
            fwin:open(_win,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_batch_buy_sure_window_close_terminal = {
    _name = "props_batch_buy_sure_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsBatchBuySureClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_batch_buy_sure_window_open_terminal)
state_machine.add(props_batch_buy_sure_window_close_terminal)
state_machine.init()

function PropsBatchBuySure:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop_id = 0
    self._user_prop_id = 0
    self._select_num = 0
    self._cost = 0

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_props_batch_buy_sure_terminal()
        local props_batch_buy_sure_buy_props_draw_terminal = {
            _name = "props_batch_buy_sure_buy_props",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[26])
                        state_machine.excute("props_batch_buy_window_close", 0, nil)
                        state_machine.excute("props_shop_packs_update_draw", 0, nil)
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, nil)
                        state_machine.excute("player_info_skill_update_skill_point", 0, nil)
                        state_machine.excute("home_map_update_build",0,nil)
                        state_machine.excute("main_window_update_userinfo",0,nil)
                        state_machine.excute("build_up_make_props_update_draw",0,nil)
                        state_machine.excute("build_up_tank_production_proc_update_draw", 0, nil)
                        state_machine.excute("build_up_tank_production_proc_ex_update_draw", 0, nil)
                    end
                end
                protocol_command.avatar_shop_buy.param_list = instance._user_prop_id.."\r\n"..instance._select_num
                NetworkManager:register(protocol_command.avatar_shop_buy.code, nil, nil, nil, nil, responseCallback, false, nil)
                state_machine.excute("props_batch_buy_sure_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_batch_buy_sure_buy_props_draw_terminal) 
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_batch_buy_sure_terminal()
end

--初始化界面
function PropsBatchBuySure:onInit()
    local csbItem = csb.createNode(config_csb.player.player_energy_add_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_time_close"), nil, 
    {
        terminal_name = "props_batch_buy_sure_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_batch_buy_sure_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_sure"), nil, 
    {
        terminal_name = "props_batch_buy_sure_buy_props", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_energy_add_cancel"), nil, 
    {
        terminal_name = "props_batch_buy_sure_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function PropsBatchBuySure:onUpdateDraw()
    local root = self.roots[1]
    -- icon
    local Panel_energ_add_icon = ccui.Helper:seekWidgetByName(root, "Panel_energ_add_icon")
    Panel_energ_add_icon:removeAllChildren(true)
    local cell = nil
    local change_of_equipment = dms.int(dms["prop_mould"], self._prop_id, prop_mould.change_of_equipment)
    if change_of_equipment > 0 then
        cell = state_machine.excute("props_icon_create_cell",0,{9,7, self._prop_id,1,-1,false})
    else
        cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._prop_id,1})
    end
    Panel_energ_add_icon:addChild(cell) 

    -- name
    local Text_but_time_p_1 = ccui.Helper:seekWidgetByName(root, "Text_but_time_p_1")
    local prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    Text_but_time_p_1:setString(prop_name.."*"..self._select_num)

    local Text_consume_buy_time_n = ccui.Helper:seekWidgetByName(root, "Text_consume_buy_time_n")
    Text_consume_buy_time_n:setString(self._cost * self._select_num)
end

--初始化
function PropsBatchBuySure:init(params)
    self._prop_id = params[1]
    self._user_prop_id = params[2]
    self._select_num = params[3]
    self._cost = params[4]
    self:onInit()
end

--移除状态机
function PropsBatchBuySure:onExit()
    state_machine.remove("props_batch_buy_sure_buy_props")
end