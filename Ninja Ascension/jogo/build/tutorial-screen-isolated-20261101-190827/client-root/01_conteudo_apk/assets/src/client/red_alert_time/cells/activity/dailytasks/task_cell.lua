--------------------------------------------------------------------------------------------------------------
--  说明：任务列表项控件
--------------------------------------------------------------------------------------------------------------
TaskCell = class("TaskCellClass", Window)
TaskCell.__size = nil

--创建cell
local task_create_cell_terminal = {
    _name = "task_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local task_type = params[1]
        local task_data = params[2]
        local index = params[3]
        local cell = TaskCell:new()
        cell:init(task_type,task_data,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(task_create_cell_terminal)
state_machine.init()

function TaskCell:ctor()
	self.super:ctor()
	self.roots = {}

	self._task_type = nil
    self._task_data = nil

    self._tick_time = 0
    self._label_time = nil      -- 紧急任务倒计时

    local function init_task_cell_terminal()
		local task_cell_goto_function_window_terminal = {
            _name = "task_cell_goto_function_window",
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
                if missionIsOver() == true then
                    fwin:close(fwin:find("TuitionControllerClass"))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_cell_get_reward_terminal = {
            _name = "task_cell_get_reward",
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
                        -- state_machine.excute("task_main_line_list_update_listview",0,"")
                        state_machine.excute("main_window_update_userinfo", 0, nil)
                        state_machine.excute("home_map_update_build", 0, nil)
                    end
                end
                protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_cell_show_info_terminal = {
            _name = "task_cell_show_info",
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

		state_machine.add(task_cell_goto_function_window_terminal)
        state_machine.add(task_cell_get_reward_terminal)
        state_machine.add(task_cell_show_info_terminal)
        state_machine.init()
    end
    
    init_task_cell_terminal()
end

function TaskCell:updateDraw()
    local root = self.roots[1]
    local Panel_task_icon = ccui.Helper:seekWidgetByName(root,"Panel_task_icon")
    local Text_task_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1")
    local Text_task_infor_2 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_2")
    local Text_task_name = ccui.Helper:seekWidgetByName(root, "Text_task_name")
    local Text_task_speed = ccui.Helper:seekWidgetByName(root,"Text_task_speed")
    local Button_task_receive = ccui.Helper:seekWidgetByName(root, "Button_task_receive")
    local Button_task_go = ccui.Helper:seekWidgetByName(root, "Button_task_go")
    Panel_task_icon:removeAllChildren(true)
    Text_task_infor_1:setString("")
    Text_task_infor_1:removeAllChildren(true)
    Text_task_infor_2:setString("")
    Text_task_infor_2:removeAllChildren(true)
    Text_task_name:setString("")
    Text_task_speed:setString("")
    Text_task_speed:removeAllChildren(true)
    Button_task_go:setVisible(false)
    Button_task_receive:setVisible(false)
    
    -- icon
    local task_mould_id = self._task_data.task_mould_id
    local cell = state_machine.excute("props_icon_create_cell",0,{1,3,task_mould_id,9})
    Panel_task_icon:addChild(cell) 

    local task_type = dms.int(dms["task_mould"],task_mould_id,task_mould.task_type)
    local achieve_mould_id = self._task_data.achieve_mould_id
    local achieve_data = dms.element(dms["achievement_mould"],achieve_mould_id)
    -- name
    local achievement_name = dms.atos(achieve_data,achievement_mould.achievement_name)
    Text_task_name:setString(achievement_name)
    if task_type == 5 then
        Text_task_name:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_task_name:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
    end

    -- 奖励
    local achievement_reward = dms.atos(achieve_data,achievement_mould.achievement_reward)
    achievement_reward = zstring.split(achievement_reward,"|")
    local frist_task_id = 0
    if _ED.user_frist_task ~= nil then
        frist_task_id = zstring.tonumber(_ED.user_frist_task.task_id)
    end
    local task_id = zstring.tonumber(self._task_data.task_id)
    local str_table_1 = {}
    local str_table_2 = {}
    local str_1 = ""
    local str_2 = ""
    local pic_index = nil
    local prop_name = nil
    local info = {}
    local fontSize1 = Text_task_infor_1:getFontSize()
    local fontSize2 = Text_task_infor_2:getFontSize()
    for i,v in pairs(achievement_reward) do
        local temp_tab = zstring.split(v,",")
        if i <= 2 then
            if tonumber(temp_tab[1]) <= 0 then
                prop_name = dms.string(dms["prop_mould"], resource_prop_id[tonumber(temp_tab[2])], prop_mould.prop_name)
                pic_index = dms.string(dms["prop_mould"], resource_prop_id[tonumber(temp_tab[2])], prop_mould.pic_index)
                pic_index = zstring.split(pic_index, ",")
                str_1 = str_1 .."  ".. prop_name.."+"..exChangeNumToString(temp_tab[3])
            else
                if tonumber(temp_tab[2]) == 6 then
                    prop_name = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.prop_name)
                    pic_index = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.pic_index)
                    pic_index = zstring.split(pic_index, ",")
                    str_1 = str_1 .."  "..prop_name .."+"..exChangeNumToString(temp_tab[3])
                else
                    prop_name = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.captain_name)
                    pic_index = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.head_icon)
                    pic_index = zstring.split(pic_index, ",")
                    str_1 = str_1 .."  "..prop_name .."+"..exChangeNumToString(temp_tab[3])
                end
            end
            info = {prop_name,pic_index[2],exChangeNumToString(temp_tab[3])}
            table.insert(str_table_1, info)
        elseif i <= 4 then
            if tonumber(temp_tab[1]) <= 0 then
                prop_name = dms.string(dms["prop_mould"], resource_prop_id[tonumber(temp_tab[2])], prop_mould.prop_name)
                pic_index = dms.string(dms["prop_mould"], resource_prop_id[tonumber(temp_tab[2])], prop_mould.pic_index)
                pic_index = zstring.split(pic_index, ",")
                str_2 = str_2 .."  "..prop_name .."+"..exChangeNumToString(temp_tab[3])
            else
                if tonumber(temp_tab[2]) == 6 then
                    prop_name = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.prop_name)
                    pic_index = dms.string(dms["prop_mould"], temp_tab[1], prop_mould.pic_index)
                    pic_index = zstring.split(pic_index, ",")
                    str_2 = str_2 .."  "..prop_name .."+"..exChangeNumToString(temp_tab[3])
                else
                    prop_name = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.captain_name)
                    pic_index = dms.string(dms["ship_mould"], temp_tab[1], ship_mould.head_icon)
                    pic_index = zstring.split(pic_index, ",")
                    str_2 = str_2 .."  "..prop_name .."+"..exChangeNumToString(temp_tab[3])
                end
            end
            info = {prop_name,pic_index[2],exChangeNumToString(temp_tab[3])}
            table.insert(str_table_2, info)
        end
    end
    if frist_task_id == task_id then
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false) 
        local _richText_2 = ccui.RichText:create()
        _richText_2:ignoreContentAdaptWithSize(false) 
        for i,v in pairs(str_table_1) do
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[v[2]+1][1],color_Type[v[2]+1][2],color_Type[v[2]+1][3]),255, "  "..v[1], "fonts/simhei.ttf",fontSize1)
            _richText_1:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "+"..v[3], "fonts/simhei.ttf",fontSize1)
            _richText_1:pushBackElement(re2)
            
        end
        for i,v in pairs(str_table_2) do
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[v[2]+1][1],color_Type[v[2]+1][2],color_Type[v[2]+1][3]),255, "  "..v[1], "fonts/simhei.ttf",fontSize2)
            _richText_2:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "+"..v[3], "fonts/simhei.ttf",fontSize2)
            _richText_2:pushBackElement(re2)
        end
        _richText_1:setPosition(cc.p(Text_task_infor_1:getContentSize().width/2,Text_task_infor_1:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_task_infor_1:getContentSize().width,20))
        Text_task_infor_1:addChild(_richText_1)
        _richText_2:setPosition(cc.p(Text_task_infor_2:getContentSize().width/2,Text_task_infor_2:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_task_infor_2:getContentSize().width,20))
        Text_task_infor_2:addChild(_richText_2)
    else
        Text_task_infor_1:setString(str_1)
        Text_task_infor_2:setString(str_2)
    end
    
    -- 进度
    local task_complete_count = zstring.tonumber(self._task_data.task_complete_count)
    local need_complete_count = zstring.tonumber(self._task_data.need_complete_count)
    if task_type == 5 then
        self._tick_time = self._task_data.task_end_time - (os.time() + _ED.time_add_or_sub)
        -- 关闭倒计时
        local font_size = Text_task_speed:getFontSize()
        local time_int = cc.Label:createWithTTF(getRedAlertTimeActivityFormat(self._tick_time), config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_int:setName("time_int")
        time_int:setAnchorPoint(cc.p(0, 0.5))
        time_int:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int:setPositionX(Text_task_speed:getContentSize().width - 80)
        time_int:setPositionY(Text_task_speed:getContentSize().height / 2)
        time_int:setTag(100)
        Text_task_speed:addChild(time_int)
        local time_info = cc.Label:createWithTTF(red_alert_time_str[297], config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        time_info:setName("time_info")
        time_info:setAnchorPoint(cc.p(1, 0.5))
        time_info:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info:setPositionX(Text_task_speed:getContentSize().width - 80)
        time_info:setPositionY(Text_task_speed:getContentSize().height / 2)
        time_info:setTag(200)
        Text_task_speed:addChild(time_info)
        self._label_time = time_int
    else
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
            if v == "." then
                len = 0.5
            else
                if string.len(v) > 1 then
                    len = string.len(v) - 1
                end
            end
            len_size = len_size + len
        end
        _richText:setPosition(cc.p(Text_task_speed:getContentSize().width-len_size*10,Text_task_speed:getContentSize().height/2-10))
        _richText:setContentSize(cc.size(Text_task_speed:getContentSize().width,20))
        if tonumber(self._task_data.sort_index) == 2 then
            info = red_alert_all_str[127].._ED.user_info.credit_level..red_alert_all_str[318]
            if verifySupportLanguage(_lua_release_language_en) == true then
                info = red_alert_all_str[127]..red_alert_all_str[318].._ED.user_info.credit_level
            end
            Text_task_speed:setString(info)
        else
            Text_task_speed:addChild(_richText)
        end
    end

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
end

function TaskCell:onUpdate(dt)
    if self._label_time ~= nil then
        self._tick_time = self._tick_time - dt
        self._label_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
    end
end

function TaskCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.task.task_main_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TaskCell.__size == nil then
        TaskCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_go"), nil, 
    {
        terminal_name = "task_cell_goto_function_window", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_infor"), nil, 
    {
        terminal_name = "task_cell_show_info", 
        terminal_state = 0, 
        cell = self, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_receive"), nil, 
    {
        terminal_name = "task_cell_get_reward",
        terminal_state = 0,
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)
    
	self:updateDraw()
end

function TaskCell:onEnterTransitionFinish()

end

function TaskCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function TaskCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_main_cell_2, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function TaskCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_task_icon = ccui.Helper:seekWidgetByName(root,"Panel_task_icon")
    local Text_task_infor_1 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_1")
    local Text_task_infor_2 = ccui.Helper:seekWidgetByName(root, "Text_task_infor_2")
    local Text_task_name = ccui.Helper:seekWidgetByName(root, "Text_task_name")
    local Text_task_speed = ccui.Helper:seekWidgetByName(root,"Text_task_speed")
    local Button_task_receive = ccui.Helper:seekWidgetByName(root, "Button_task_receive")
    local Button_task_go = ccui.Helper:seekWidgetByName(root, "Button_task_go")
    if Panel_task_icon ~= nil then
        Panel_task_icon:removeAllChildren(true)
        Text_task_infor_1:setString("")
        Text_task_infor_1:removeAllChildren(true)
        Text_task_infor_2:setString("")
        Text_task_infor_2:removeAllChildren(true)
        Text_task_name:setString("")
        Text_task_speed:setString("")
        Text_task_speed:removeAllChildren(true)
        Button_task_go:setVisible(false)
        Button_task_receive:setVisible(false)
    end
    self:unregisterOnNoteUpdate(self)
end

function TaskCell:init(task_type, task_data , index)
    self._task_type = task_type
    self._task_data = task_data
    if index ~= nil and index <= 8 then
	   self:onInit()
    end
    self:setContentSize(TaskCell.__size)
    return self
end

function TaskCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.task.task_main_cell_2, self.roots[1])
end