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
        -- cell:registerOnNoteUpdate(cell)
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
    --var 
    --任务类型  --  0 主线 1 日常 2 成就    4锦囊
	self._task_type = nil 
    --任务数据 
    self._task_data = nil

    --任务上一次状态
    self._last_count = nil

    --任务是否完成
    self._task_can_get_state = nil

	 -- Initialize task_cell state machine.
    local function init_task_cell_terminal()
		
		--跳转
		local task_cell_goto_function_window_terminal = {
            _name = "task_cell_goto_function_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                local task_mould_id = cell._task_data.task_mould_id
                local achievement_mould_id = dms.int(dms["task_mould"],task_mould_id,task_mould.achieve_mould_id)
                local achievement_short_id = dms.int(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_short_id)
                local achievement_finish_type = dms.int(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_finish_type)
                if achievement_finish_type == 34 then 
                    local item_value = 0
                    local  prop = fundPropWidthId(achievement_short_id)
                    if prop == nil then
                        item_value = 0
                    else
                        item_value= prop.prop_number
                    end
                    local cell = state_machine.excute("get_the_way_window_open",0,{6,achievement_short_id,item_value})
                    return
                end
                if achievement_short_id == 818 then
                    state_machine.excute("task_window_close",0,"")
                    if fwin:find("DuplicateMapClass")  ~= nil then
                        state_machine.excute("duplicate_map_window_close",0,"")
                        state_machine.excute("duplicate_title_window_close",0,"")
                        state_machine.excute("main_window_open", 0, "")
                        state_machine.excute("player_resource_window_show", 0, "")     
                        state_machine.excute("home_button_for_action_window_show",0,"")
                        state_machine.excute("chat_view_window_show",0,"")
                        if fwin:find("PacksClass")  ~= nil then
                            state_machine.excute("packs_window_close",0,"")
                        elseif fwin:find("HeroMainClass")  ~= nil then
                            state_machine.excute("hero_main_window_close",0,"")
                        end
                    end
                    if fwin:find("DuplicateManagerClass")  ~= nil then
                        state_machine.excute("duplicate_manager_window_close",0,"")
                        state_machine.excute("main_window_open", 0, "")
                        state_machine.excute("player_resource_window_show", 0, "")     
                        state_machine.excute("home_button_for_action_window_show",0,"")
                        state_machine.excute("chat_view_window_show",0,"")
                        if fwin:find("PacksClass")  ~= nil then
                            state_machine.excute("packs_window_close",0,"")
                        elseif fwin:find("HeroMainClass")  ~= nil then
                            state_machine.excute("hero_main_window_close",0,"")
                        end
                    end
                    if fwin:find("SevenStarClass")  ~= nil then
                        state_machine.excute("seven_star_window_close",0,"")
                    end
                    return
                end
                state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领奖
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
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{74})
                        if task_type == 0 then
                            state_machine.excute("task_main_line_list_update_listview",0,"")
                            -- state_machine.excute("task_main_line_list_remove_cell",0,cell)
                        elseif task_type == 1 or task_type == 3 then
                            -- state_machine.excute("task_daily_list_update_listview",0,"")
                            state_machine.excute("task_daily_list_remove_cell",0,cell)
                        elseif task_type == 2 then
                            state_machine.excute("task_achieve_list_update_listview",0,"")
                            -- state_machine.excute("task_achieve_list_remove_cell",0,cell)
                        elseif task_type == 4 then
                            state_machine.excute("strategy_update_listview",0,"")
                        end
                    end
                end
                protocol_command.get_task_reward.param_list = task_id .. "\r\n" .. task_mould_id
                NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(task_cell_goto_function_window_terminal)
        state_machine.add(task_cell_get_reward_terminal)
        state_machine.init()
    end
    
    -- call func task_cell create state machine.
    init_task_cell_terminal()

end

function TaskCell:onUpdate()
    -- if self._task_can_get_state == nil or self._task_can_get_state == 1 then
    --     return
    -- end

    -- if zstring.tonumber(self._task_data.task_complete_count) ~= self._last_count then
    --     self:updateDraw()
    -- end
end

function TaskCell:updateDraw()
    local root = self.roots[1]
    local achieve_mould_id = self._task_data.achieve_mould_id
    local achieve_data = dms.element(dms["achievement_mould"],achieve_mould_id)
    local achievement_name = dms.atos(achieve_data,achievement_mould.achievement_name)
    local achievement_dec = dms.atos(achieve_data,achievement_mould.achievement_dec)
    local achievement_reward = dms.atos(achieve_data,achievement_mould.achievement_reward)
    achievement_reward = zstring.split(achievement_reward,"|")
    local achievement_finish_need_info = dms.atos(achieve_data,achievement_mould.achievement_finish_need_info)
    achievement_finish_need_info = zstring.split(achievement_finish_need_info,",")
    local now_complete_count = zstring.tonumber(self._task_data.task_complete_count)
    self._last_count = now_complete_count
    local achievement_finish_type = dms.atos(achieve_data,achievement_mould.achievement_finish_type)            --成就达成类型

    
    
    local BitmapFontLabel_cell_name = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_cell_name")
    local Text_task_cell_infor = ccui.Helper:seekWidgetByName(root,"Text_task_cell_infor")
    local Button_task_go = ccui.Helper:seekWidgetByName(root, "Button_task_go")
    local Button_task_receive = ccui.Helper:seekWidgetByName(root, "Button_task_receive")
    local Text_loading_task = ccui.Helper:seekWidgetByName(root, "Text_loading_task")
    local LoadingBar_task = ccui.Helper:seekWidgetByName(root, "LoadingBar_task")
    local Image_task_cell_2 = ccui.Helper:seekWidgetByName(root, "Image_task_cell_2")
    
    BitmapFontLabel_cell_name:setString("")
    Text_task_cell_infor:setString("")
    Button_task_go:setVisible(false)
    Button_task_receive:setVisible(false)
    Text_loading_task:setString("")
    Text_task_cell_infor:setString(achievement_dec)

    if tonumber(achievement_finish_type) == 28 then 
        now_complete_count = math.max(now_complete_count,zstring.tonumber(self._task_data.need_complete_count))
        BitmapFontLabel_cell_name:setString(achievement_name)
        LoadingBar_task:setVisible(false)
        Image_task_cell_2:setVisible(false)
        if now_complete_count <= zstring.tonumber(self._task_data.need_complete_count) then
            Button_task_receive:setVisible(true)
            self._task_can_get_state = 1
        else
            Button_task_go:setVisible(true)
            self._task_can_get_state = 0
        end
    else
        if tonumber(self._task_data.achieve_mould_id) == 584 or tonumber(self._task_data.achieve_mould_id) == 585 then
            BitmapFontLabel_cell_name:setString(achievement_name)
            LoadingBar_task:setVisible(false)
            Image_task_cell_2:setVisible(false)
            Button_task_receive:setVisible(true)
        else
            now_complete_count = math.min(now_complete_count,zstring.tonumber(self._task_data.need_complete_count))
            BitmapFontLabel_cell_name:setString(achievement_name.." (" .. now_complete_count .. "/" .. zstring.tonumber(self._task_data.need_complete_count) .. ")")
            Text_loading_task:setString(now_complete_count .. "/" .. zstring.tonumber(self._task_data.need_complete_count))
            local progress = math.min(now_complete_count/zstring.tonumber(self._task_data.need_complete_count)*100)
            LoadingBar_task:setPercent(progress)
            LoadingBar_task:setVisible(true)
            Image_task_cell_2:setVisible(true)
            if now_complete_count >= zstring.tonumber(self._task_data.need_complete_count) then
                Button_task_receive:setVisible(true)
                self._task_can_get_state = 1
            else
                Button_task_go:setVisible(true)
                self._task_can_get_state = 0
            end
        end
    end
    
    local task_mould_id = self._task_data.task_mould_id
    local achievement_mould_id = dms.int(dms["task_mould"],task_mould_id,task_mould.achieve_mould_id)
    local achievement_short_id = dms.int(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_short_id)
    if achievement_short_id == -1 then
        Button_task_go:setVisible(false)
    end
    local Panel_task_cell_reward_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_task_cell_reward_icon_1")
    local Panel_task_cell_reward_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_task_cell_reward_icon_2")
    local Text_task_cell_reward_name_1 = ccui.Helper:seekWidgetByName(root,"Text_task_cell_reward_name_1")
    local Text_task_cell_reward_name_2 = ccui.Helper:seekWidgetByName(root,"Text_task_cell_reward_name_2")
    Panel_task_cell_reward_icon_1:removeAllChildren(true)
    Panel_task_cell_reward_icon_2:removeAllChildren(true)
    Text_task_cell_reward_name_1:setString("")
    Text_task_cell_reward_name_2:setString("")
    for i,v in pairs(achievement_reward) do
        local temp_tab = zstring.split(v,",")
        local Panel_task_cell_reward_icon = ccui.Helper:seekWidgetByName(root,"Panel_task_cell_reward_icon_"..i)
        local Text_task_cell_reward_name = ccui.Helper:seekWidgetByName(root,"Text_task_cell_reward_name_"..i)
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }
        if tonumber(reward_data.prop_type) == 6 then    
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(reward_data.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,reward_data,reward_data,touch_type,0,false,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
            end  
        elseif tonumber(reward_data.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,reward_data,reward_data,touch_type,0,false,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,reward_data,reward_data,touch_type,0,false,true})
        end
        Panel_task_cell_reward_icon:addChild(cell)
    end
       
end

function TaskCell:onInit()

    local root = cacher.createUIRef(config_csb.cells.activity.dailytasks.task_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if TaskCell.__size == nil then
        TaskCell.__size = root:getContentSize()
    end

    --跳转
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_go"), nil, 
    {
        terminal_name = "task_cell_goto_function_window", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    --领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_receive"), nil, 
    {
        terminal_name = "task_cell_get_reward", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    
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
end

function TaskCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local root = self.roots[1]
    for i = 1 ,2 do
        local Panel_task_cell_reward_icon = ccui.Helper:seekWidgetByName(root,"Panel_task_cell_reward_icon_"..i)
        Panel_task_cell_reward_icon:removeAllChildren(true)
    end

    cacher.freeRef(config_csb.cells.activity.dailytasks.task_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function TaskCell:init(task_type, task_data , index)
    self._task_type = task_type   --  0 主线 1 日常 2  成就  4 锦囊
    self._task_data = task_data
    if index ~= nil and index < 6 then
	   self:onInit()
    end
    self:setContentSize(TaskCell.__size)
    return self
end

function TaskCell:onExit()
    for i = 1 ,2 do
        local Panel_task_cell_reward_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_task_cell_reward_icon_"..i)
        if Panel_task_cell_reward_icon ~= nil then
            Panel_task_cell_reward_icon:removeAllChildren(true)
        end
    end
    cacher.freeRef(config_csb.cells.activity.dailytasks.task_cell, self.roots[1])
end