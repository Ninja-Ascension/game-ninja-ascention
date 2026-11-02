--------------------------------------------------------------------------------------------------------------
--  说明：日常任务列表项控件
--------------------------------------------------------------------------------------------------------------
TaskDailyCell = class("TaskDailyCellClass", Window)
TaskDailyCell.__size = nil

--创建cell
local task_daily_create_cell_terminal = {
    _name = "task_daily_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local task_type = params[1]
        local task_data = params[2]
        local index = params[3]
        local cell = TaskDailyCell:new()
        cell:init(task_type,task_data,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(task_daily_create_cell_terminal)
state_machine.init()

function TaskDailyCell:ctor()
	self.super:ctor()
	self.roots = {}

	self._task_type = nil 
    self._task_data = nil

    local function init_task_daily_cell_terminal()
		local task_daily_cell_goto_function_window_terminal = {
            _name = "task_daily_cell_goto_function_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                local achievement_mould_id = cell._task_data.achieve_mould_id
                local achievement_short_id = dms.int(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_short_id)
                state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_daily_cell_get_reward_terminal = {
            _name = "task_daily_cell_get_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                local task_data = cell._task_data
                local task_id = task_data.task_id
                local task_mould_id = task_data.task_mould_id
                local task_type = cell._task_type
                _ED.last_user_level = _ED.user_info.user_grade
                _ED.last_prestige_level = _ED.user_info.credit_level
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("task_daily_list_update_listview",0,"")
                        state_machine.excute("main_window_update_userinfo", 0, nil)
                    end
                end
                protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_daily_cell_show_info_terminal = {
            _name = "task_daily_cell_show_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                local achieve_mould_id = cell._task_data.achieve_mould_id
                local achieve_data = dms.element(dms["achievement_mould"], achieve_mould_id)
                local achievement_reward = zstring.split(dms.atos(achieve_data, achievement_mould.achievement_reward), "|")
                state_machine.excute("task_detail_open", 0, {cell._task_data,achievement_reward})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_daily_cell_update_info_terminal = {
            _name = "task_daily_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                local index = params.index
                cell._task_type = params.task_type
                cell._task_data = params.task_data
                if cell._task_data ~= nil then
                    if index <= 8 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(task_daily_cell_goto_function_window_terminal)
        state_machine.add(task_daily_cell_get_reward_terminal)
        state_machine.add(task_daily_cell_show_info_terminal)
        state_machine.add(task_daily_cell_update_info_terminal)
        state_machine.init()
    end
    
    init_task_daily_cell_terminal()
end

function TaskDailyCell:updateDraw()
    local root = self.roots[1]
    local Panel_task_icon = ccui.Helper:seekWidgetByName(root,"Panel_task_icon")
    local Text_task_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1")
    local Text_task_name = ccui.Helper:seekWidgetByName(root, "Text_task_name")
    local Text_task_speed = ccui.Helper:seekWidgetByName(root,"Text_task_speed")
    local Button_task_receive = ccui.Helper:seekWidgetByName(root, "Button_task_receive")
    local Button_task_go = ccui.Helper:seekWidgetByName(root, "Button_task_go")
    Panel_task_icon:removeAllChildren(true)
    Text_task_infor_1:setString("")
    Text_task_name:setString("")
    Text_task_speed:removeAllChildren(true)
    Button_task_go:setVisible(false)
    Button_task_receive:setVisible(false)
    Button_task_receive:setTitleText(red_alert_all_str[170])
    Button_task_receive:setBright(true)
    Button_task_receive:setTouchEnabled(true)

    -- icon
    local task_mould_id = self._task_data.task_mould_id
    local cell = state_machine.excute("props_icon_create_cell",0,{1,3,task_mould_id,9})
    Panel_task_icon:addChild(cell) 

    local achieve_mould_id = self._task_data.achieve_mould_id
    local achieve_data = dms.element(dms["achievement_mould"],achieve_mould_id)
    -- name
    local achievement_name = dms.atos(achieve_data,achievement_mould.achievement_name)
    Text_task_name:setString(achievement_name)

    -- 奖励
    local achievement_reward = dms.atos(achieve_data,achievement_mould.achievement_reward)
    achievement_reward = zstring.split(achievement_reward,"|")
    local str = ""
    for i,v in pairs(achievement_reward) do
        local temp_tab = zstring.split(v,",")
        if tonumber(temp_tab[1]) <= 0 then
            str = str .." "..reward_prop_list[tonumber(temp_tab[2])] .."+"..exChangeNumToString(temp_tab[3])
        else
            if tonumber(temp_tab[2]) == 6 then
                local prop_name = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.prop_name)
                str = str .." "..prop_name .."+"..exChangeNumToString(temp_tab[3])
            else
                local prop_name = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.captain_name)
                str = str .." "..prop_name .."+"..exChangeNumToString(temp_tab[3])
            end
        end
    end
    Text_task_infor_1:setString(str)

    -- 进度
    local task_complete_count = zstring.tonumber(self._task_data.task_complete_count)
    local need_complete_count = zstring.tonumber(self._task_data.need_complete_count)
    local task_state = zstring.tonumber(self._task_data.task_state)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_all_str[127], "fonts/simhei.ttf",20)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, exChangeNumToString(task_complete_count), "fonts/simhei.ttf",20)
    _richText:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..exChangeNumToString(need_complete_count), "fonts/simhei.ttf",20)
    _richText:pushBackElement(re3)
    _richText:ignoreAnchorPointForPosition(true)
    local info = red_alert_all_str[127]..exChangeNumToString(task_complete_count).."/"..exChangeNumToString(need_complete_count)
    local len_size = 0
    local map = string.utf8.chars(info)
    for i,v in pairs(map) do
        local len = string.len(v)
        if string.len(v) > 1 then
            len = string.len(v) - 1
        end
        len_size = len_size + len
    end
    _richText:setPosition(cc.p(Text_task_speed:getContentSize().width-len_size*11.375,Text_task_speed:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_task_speed:getContentSize().width,20))
    Text_task_speed:addChild(_richText)

    -- 按钮状态
    if task_complete_count >= need_complete_count then
        Button_task_receive:setVisible(true)
    else
        Button_task_go:setVisible(true)
    end
    local achievement_short_id = dms.atoi(achieve_data,achievement_mould.achievement_short_id)
    if achievement_short_id == -1 then
        Button_task_go:setVisible(false)
    end
    if task_state == 2 then
        Button_task_receive:setBright(false)
        Button_task_receive:setTouchEnabled(false)
        Button_task_receive:setTitleText(red_alert_all_str[55])
    end
end

function TaskDailyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.task.task_daily_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TaskDailyCell.__size == nil then
        TaskDailyCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_go"), nil, 
    {
        terminal_name = "task_daily_cell_goto_function_window", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_infor"), nil, 
    {
        terminal_name = "task_daily_cell_show_info", 
        terminal_state = 0, 
        cell = self, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_receive"), nil, 
    {
        terminal_name = "task_daily_cell_get_reward",
        terminal_state = 0,
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    
	self:updateDraw()
end

function TaskDailyCell:onEnterTransitionFinish()

end

function TaskDailyCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function TaskDailyCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_daily_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function TaskDailyCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_task_icon = ccui.Helper:seekWidgetByName(root,"Panel_task_icon")
    local Text_task_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1")
    local Text_task_name = ccui.Helper:seekWidgetByName(root, "Text_task_name")
    local Text_task_speed = ccui.Helper:seekWidgetByName(root,"Text_task_speed")
    local Button_task_receive = ccui.Helper:seekWidgetByName(root, "Button_task_receive")
    local Button_task_go = ccui.Helper:seekWidgetByName(root, "Button_task_go")
    if Panel_task_icon ~= nil then
        Panel_task_icon:removeAllChildren(true)
        Text_task_infor_1:setString("")
        Text_task_name:setString("")
        Text_task_speed:removeAllChildren(true)
        Button_task_go:setVisible(false)
        Button_task_receive:setVisible(false)
        Button_task_receive:setTitleText("")
        Button_task_receive:setBright(true)
        Button_task_receive:setTouchEnabled(true)
    end
end

function TaskDailyCell:init(task_type, task_data , index)
    self._task_type = task_type
    self._task_data = task_data
    if index ~= nil and index <= 8 then
	   self:onInit()
    end
    self:setContentSize(TaskDailyCell.__size)
    return self
end

function TaskDailyCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_daily_cell, self.roots[1])
end