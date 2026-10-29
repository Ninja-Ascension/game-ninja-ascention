-- ------------------------------------------------------------------------------------------------------------
--  说明：批量使用
-- ------------------------------------------------------------------------------------------------------------
PropsBatchUse = class("PropsBatchUseClass", Window)

--打开界面
local props_batch_use_window_open_terminal = {
    _name = "props_batch_use_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsBatchUseClass") == nil then
            local prop_id = params[1]
            local user_prop_id = params[2]
            local max_select_num = params[3]
            local pack_type = params[4]
            local ship_id = params[5]
            local select_num = params[6]
            local _win = PropsBatchUse:new()
            _win:init(prop_id, user_prop_id, max_select_num,pack_type,ship_id,select_num)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_batch_use_window_close_terminal = {
    _name = "props_batch_use_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsBatchUseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_batch_use_window_open_terminal)
state_machine.add(props_batch_use_window_close_terminal)
state_machine.init()

function PropsBatchUse:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop_id = 0
    self._max_select_num = 0
    self._select_num = 0

    self._prop_name = ""
    self._pack_type = 0
    self._ship_id = -1
     -- Initialize alert_home state machine.
    local function init_props_batch_use_terminal()
        --显示所有
        local props_batch_use_window_show_terminal = {
            _name = "props_batch_use_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local props_batch_use_window_hide_terminal = {
            _name = "props_batch_use_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 添加使用数量
        local props_batch_use_change_num_add_terminal = {
            _name = "props_batch_use_change_num_add",
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

        -- 减少使用数量
        local props_batch_use_change_num_mimus_terminal = {
            _name = "props_batch_use_change_num_mimus",
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

        -- 滑块选择
        local props_batch_use_update_slider_terminal = {
            _name = "props_batch_use_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 使用
        local props_batch_use_sure_user_terminal = {
            _name = "props_batch_use_sure_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._select_num > 100 then
                    instance._select_num = 100
                end
                local prop_name = instance._prop_name

                local talent_id = dms.int(dms["prop_mould"], instance._prop_id, prop_mould.use_of_power)
                if talent_id > 0 then
                    local build_buff_id = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.build_buff_id), ",")
                    if tonumber(build_buff_id[1]) > 0 then
                        local can_use = true
                        local add_time = dms.int(dms["talent_mould"], talent_id, talent_mould.add_buff_time)
                        add_time = add_time * 1000 * instance._select_num
                        for k1,v1 in pairs(_ED.factor_info) do
                            for k, v in pairs(build_buff_id) do
                                local current_time = 0
                                if tonumber(v1.build_buff_id) == tonumber(v) then
                                    current_time = v1.factor_cd_time * 1000
                                end
                                local total_time = current_time + add_time
                                if total_time > max_int_tip_info then
                                    can_use = false
                                    break
                                end
                            end
                        end
                        if can_use == false then
                            TipDlg.drawTextDailog(red_alert_time_str[230])  
                            return
                        end
                    end
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if #_ED.show_reward_list_group_ex > 0 then
                                checkRewardObtainDraw()
                            else
                                TipDlg.drawTextDailog(string.format(red_alert_time_str[21], prop_name))
                            end
                            if response.node._ship_id > 0 then
                                local prop_ids = zstring.split(dms.string(dms["prop_config"], 17, prop_config.param), ",")
                                local is_show_name = false
                                for i=1,#prop_ids do
                                    if response.node._prop_id == tonumber(prop_ids[i]) then
                                        is_show_name = true
                                        break
                                    end
                                end
                                if is_show_name == true then
                                    TipDlg.drawTextDailog(string.format(red_alert_time_str[248], prop_name))
                                else
                                    TipDlg.drawTextDailog(red_alert_time_str[70])
                                end
                            end
                        end
                        state_machine.excute("player_info_skill_update_skill_point", 0, nil)
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, "")
                        state_machine.excute("main_window_update_userinfo", 0, nil)
                        state_machine.excute("props_batch_use_window_close", 0, "")
                        state_machine.excute("home_map_update_tanke_info", 0, "")
                        state_machine.excute("leader_leader_up_update_draw", 0, nil)
                        state_machine.excute("leader_info_update", 0, nil)
                        state_machine.excute("leader_team_list_update", 0, nil)
                        state_machine.excute("leader_leader_up_update_prop_use", 0, nil)
                        state_machine.excute("build_up_make_props_update_draw",0,nil)
                        state_machine.excute("build_up_tank_production_proc_update_draw", 0, nil)
                        state_machine.excute("build_up_tank_production_proc_ex_update_draw", 0, nil)
                    end
                end
                local str = "-1"
                if instance._ship_id > 0 then
                    str = "3"
                end
                protocol_command.prop_use.param_list = instance._user_prop_id.."\r\n"..instance._select_num.."\r\n"..str.."\r\n"..instance._ship_id
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, instance, responseCallback, false, nil)
                            

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_batch_use_window_show_terminal)
        state_machine.add(props_batch_use_window_hide_terminal)  
        state_machine.add(props_batch_use_change_num_add_terminal)  
        state_machine.add(props_batch_use_change_num_mimus_terminal)  
        state_machine.add(props_batch_use_update_slider_terminal)  
        state_machine.add(props_batch_use_sure_user_terminal) 
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_batch_use_terminal()
end

--显示
function PropsBatchUse:onShow()
   self:setVisible(true)
end

--隐藏
function PropsBatchUse:onHide()
   self:setVisible(false)
end

function PropsBatchUse:setSelectNum(select_num)
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

--初始化界面
function PropsBatchUse:onInit()
    local csbItem = csb.createNode(config_csb.props.props_batch_use)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    local talent_id = dms.int(dms["prop_mould"], self._prop_id, prop_mould.use_of_power)
    if talent_id > 0 then
        local build_buff_id = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.build_buff_id), ",")
        if tonumber(build_buff_id[1]) > 0 then
            local add_time = dms.int(dms["talent_mould"], talent_id, talent_mould.add_buff_time)
            add_time = add_time * 1000
            for k1,v1 in pairs(_ED.factor_info) do
                for k, v in pairs(build_buff_id) do
                    local current_time = 0
                    if tonumber(v1.build_buff_id) == tonumber(v) then
                        current_time = v1.factor_cd_time * 1000
                    end
                    local max_num = math.floor((max_int_tip_info - current_time) / add_time)
                    if max_num < self._max_select_num then
                        self._max_select_num = max_num
                    end
                end
            end
        end
    end

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props_use_close"), nil, 
    {
        terminal_name = "props_batch_use_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_batch_use_window_close", 
        terminal_state = 0, 
    }, nil, 3) 

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, 
    {
        terminal_name = "props_batch_use_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)  

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, 
    {
        terminal_name = "props_batch_use_sure_use", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_add"), nil, 
    {
        terminal_name = "props_batch_use_change_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_minus"), nil, 
    {
        terminal_name = "props_batch_use_change_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    local Slider_use_num = ccui.Helper:seekWidgetByName(root, "Slider_use_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("props_batch_use_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_use_num._self = self
    Slider_use_num:addEventListener(percentChangedEvent)

    self:onUpdateDraw()
end

-- 显示信息
function PropsBatchUse:onUpdateDraw()
    local root = self.roots[1]

    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")
    local Text_props_infor = ccui.Helper:seekWidgetByName(root, "Text_props_infor")

    Panel_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,1,self._prop_id,1})
    Panel_props_icon:addChild(cell) 

    local name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    Text_props_name:setString(name)
    self._prop_name = name

    local info = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
    Text_props_infor:setString(info)
    if self._ship_id > 0 then
        self:setSelectNum(self._select_num)
    else
        self:setSelectNum(1)
    end
end

function PropsBatchUse:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_use_num = ccui.Helper:seekWidgetByName(root, "Slider_use_num")
    local Text_use_num_n = ccui.Helper:seekWidgetByName(root, "Text_use_num_n")

    self._current_silder = self._select_num / self._max_select_num * 100

    Text_use_num_n:setString(self._select_num)
    Slider_use_num:setPercent(percent)
end

--初始化
function PropsBatchUse:init(prop_id, user_prop_id, max_select_num,pack_type,ship_id,select_num)
    local max_num = dms.int(dms["prop_config"], 34, prop_config.param)
    self._prop_id = prop_id
    self._user_prop_id = user_prop_id
    self._max_select_num = math.min(max_num,max_select_num)
    self._pack_type = pack_type
    self._select_num = select_num
    if ship_id == nil then
        self._ship_id = -1
    else
        self._ship_id = tonumber(ship_id)
    end

    self:onInit()
end

--移除状态机
function PropsBatchUse:onExit()
    state_machine.remove("props_batch_use_window_show")
    state_machine.remove("props_batch_use_window_hide")
    state_machine.remove("props_batch_use_change_num_add")
    state_machine.remove("props_batch_use_change_num_mimus")
    state_machine.remove("props_batch_use_update_slider")
    state_machine.remove("props_batch_use_sure_use")
end