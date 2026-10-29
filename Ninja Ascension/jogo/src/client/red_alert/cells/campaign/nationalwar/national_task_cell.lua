
--------------------------------------------------------------------------------------------------------------
--  国战任务栏
--------------------------------------------------------------------------------------------------------------
NationalTaskCell = class("NationalTaskCellClass", Window)
NationalTaskCell.__size = nil

--创建cell
local national_task_cell_create_terminal = {
    _name = "national_task_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = NationalTaskCell:new()
        local data = params[1]
        local index = params[2]
        cell:init(data,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)        
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_task_cell_create_terminal)
state_machine.init()

function NationalTaskCell:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.campaign.nationalwar.NationalTaskListNational")
    app.load("client.red_alert.campaign.nationalwar.NationalTaskListPersonal")

    -- var
    -- 国战任务状态 0、进行中 1、领取 2、失败
    self.state = nil

    -- element 数据
    self._task_info = nil
    -- 任务id
    self._task_id = nil
    -- 任务名称
    self._task_name = nil
    -- 任务参数
    self._task_target = nil
    -- 任务奖励
    self.reward_info = nil
    -- 任务描述
    self._remarks = nil
    -- 任务icon
    self._icon = nil
    -- 是否国家任务    
    self._needTimeCoundDown = nil
    -- 任务进度(个人)
    self._task_progress = nil

    -- Initialize national_task_cell state machine.
    local function init_national_task_cell_terminal()
        
        --更新（状态） 
        local national_task_update_terminal = {
            _name = "national_task_cell_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --领取
        local national_task_receive_terminal = {
            _name = "national_task_cell_receive",
            _init = function (terminal)
                    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas._instance
                local function responseNationalTaskCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node._needTimeCoundDown then
                            state_machine.excute("national_task_list_national_cell_remove", 0 , response.node)
                        else
                            state_machine.excute("national_task_list_personal_cell_remove", 0 , response.node)
                        end

                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(56)
                            fwin:open(getRewardWnd, fwin._ui)
                        else
                            state_machine.excute("reward_obtain_window_open",0,{56})
                        end
                    end
                end

                protocol_command.draw_warfare_task_reward.param_list = ""..cell._task_id
                NetworkManager:register(protocol_command.draw_warfare_task_reward.code, nil, nil, nil, cell, responseNationalTaskCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --前往
        local national_task_cell_go_terminal = {
            _name = "national_task_cell_go",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._instance
                local _city_id = params._datas._city_id
                state_machine.excute("national_task_window_close")
                state_machine.excute("national_war_map_from_task",0,{_city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --时间倒计时
        local national_task_cell_update_time_terminal = {
            _name = "national_task_cell_update_time",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params._instance:onUpdateTime(params._time)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_task_update_terminal)
        state_machine.add(national_task_receive_terminal)  
        state_machine.add(national_task_cell_go_terminal)
        state_machine.add(national_task_cell_update_time_terminal)
        state_machine.init()
    end
    
    -- call func init national task cell state machine.
    init_national_task_cell_terminal()

end

-- 界面绘制
function NationalTaskCell:onUpdateDraw(params)

    --数据更新
    local root = self.roots[1]

    -- 进度是否达到目标
    if not self._needTimeCoundDown then
        if self._task_progress >= self._task_target then
            self._task_state = 2
            self._task_progress = self._task_target
        end
    end

    self.Button_national_task_go:setVisible(false)
    self.Button_national_task_go:setTouchEnabled(false)
    self.Image_national_fuilure:setVisible(false)
    self.Button_national_task_receive:setVisible(false)
    self.Button_national_task_receive:setTouchEnabled(false)

    -- print("s-------------------------------",self._task_state)
    -- 按钮显示
    local button_state = {
        [1] = function()    -- for case 1 1st 前往
            if self._needTimeCoundDown then
                self.Button_national_task_go:setVisible(true)
                self.Button_national_task_go:setTouchEnabled(true)
            end
        end,

        [2] = function()    -- for case 2 2nd 领取
            self.Button_national_task_receive:setVisible(true)
            self.Button_national_task_receive:setTouchEnabled(true)

            if self._needTimeCoundDown then
                self:unregisterOnNoteUpdate(self)
                self.Text_national_task_cell_name:setString(string.format("%s ", self._task_name))
            end
        end,

        [3] = function()    -- for case 3 3rd 失败
            self.Image_national_fuilure:setVisible(true)
            self:unregisterOnNoteUpdate(self)
            self.Text_national_task_cell_name:setString(string.format("%s (%s)", self._task_name,red_alert_all_str[54]))
        end,

        [4] = function()    -- for case 4 已领取
            self:unregisterOnNoteUpdate(self)
            self.Text_national_task_cell_name:setString(string.format("%s (%s)", self._task_name,red_alert_all_str[55]))
        end,
    }   
    local button_state_func = button_state[self._task_state]
    if (button_state_func) then
        button_state_func()
    end

    -- 任务描述
    local Text_national_task_cell_infor = ccui.Helper:seekWidgetByName(root, "Text_national_task_cell_infor")
    Text_national_task_cell_infor:setString("")
    Text_national_task_cell_infor:setString(self._remarks)

    -- 任务进度
    local task_status = "(" .. tostring(self._task_progress) .. "/" .. tostring(self._task_target) .. ")"

    -- 任务名字（1、任务名 .. 2、任务进度）
    if not self._needTimeCoundDown then
        self.Text_national_task_cell_name:setString("")
        self.Text_national_task_cell_name:setString(self._task_name .. " " .. task_status)
    end
    -- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
    -- else
        -- 任务icon
        local Panel_national_task_cell_icon = ccui.Helper:seekWidgetByName(root, "Panel_national_task_cell_icon")
        Panel_national_task_cell_icon:removeAllChildren(true)
        Panel_national_task_cell_icon:setBackGroundImage("images/ui/play/nationalwar/rw_" .. self._icon ..".png")

        -- 奖励缓存移除
        for i=1,2 do
            local Panel_national_task_cell_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_national_task_cell_reward_icon_" .. i )
            Panel_national_task_cell_reward_icon:removeAllChildren(true)

            local Text_national_task_cell_reward_name = ccui.Helper:seekWidgetByName(root, "Text_national_task_cell_reward_name_" .. i)
            Text_national_task_cell_reward_name:setString("")
        end

        -- 任务奖励读取
        local table_split_reward_element = zstring.split(self._reward_info, "|")
        for i,v in pairs(table_split_reward_element) do
            -- print("+++++++++++++++++++++++++++++",v,self._task_id)
            local table_split_reward_info = zstring.split(v,",")
            local task_reward_type = tonumber(table_split_reward_info[1])
            local task_reward_item = tonumber(table_split_reward_info[2])
            local task_reward_num = tonumber(table_split_reward_info[3])

            -- 任务奖励icon
            local Panel_national_task_cell_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_national_task_cell_reward_icon_" .. i )
            local data = 
            {
                prop_type = task_reward_type,
                prop_item = task_reward_item,
                item_value = task_reward_num,
            } 
            local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,true})   
            Panel_national_task_cell_reward_icon:addChild(cell)

            --奖励数值
            local Text_national_task_cell_reward_name = ccui.Helper:seekWidgetByName(root, "Text_national_task_cell_reward_name_" .. i)
            Text_national_task_cell_reward_name:setString(task_reward_num)
        end
    -- end
end

function NationalTaskCell:onInit()
    -- 绘图初始化
    local root = cacher.createUIRef(config_csb.cells.campaign.nationalwar.nationalwar_task_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if NationalTaskCell.__size == nil then
        NationalTaskCell.__size = root:getContentSize()
    end

    -- 任务文本信息（需更新）
    self.Text_national_task_cell_name = ccui.Helper:seekWidgetByName(root, "Text_national_task_cell_name")

    -- 状态控件初始化（领取、前往、失败）
    self.Button_national_task_receive = ccui.Helper:seekWidgetByName(root, "Button_national_task_receive")
    self.Button_national_task_go = ccui.Helper:seekWidgetByName(root, "Button_national_task_go")
    self.Image_national_fuilure = ccui.Helper:seekWidgetByName(root, "Image_national_fuilure")

    -- 领取
    fwin:addTouchEventListener(self.Button_national_task_receive, nil, 
    {
        terminal_name = "national_task_cell_receive", 
        terminal_state = 0, 
        isPressedActionEnabled = false,
        _instance = self, 
        _listview_window = self.data._listView_window
    }, nil, 0)

    -- 前往
    fwin:addTouchEventListener(self.Button_national_task_go, nil, 
    {
        terminal_name = "national_task_cell_go", 
        terminal_state = 0, 
        isPressedActionEnabled = false,
        _instance = self, 
        -- 前往id
        _city_id = self._task_target
    }, nil, 0)

    self:onUpdateDraw(self.data)
end

function NationalTaskCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function NationalTaskCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    for i=1,2 do
        local Panel_national_task_cell_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_national_task_cell_reward_icon_" .. i )
        Panel_national_task_cell_reward_icon:removeAllChildren(true)

        local Text_national_task_cell_reward_name = ccui.Helper:seekWidgetByName(root, "Text_national_task_cell_reward_name_" .. i)
        Text_national_task_cell_reward_name:setString("")
    end
    cacher.freeRef(config_csb.cells.campaign.nationalwar.nationalwar_task_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

-- 注册update定时器
function NationalTaskCell:onUpdate(dt)
    local root = self.roots[1]
    if root == nil then
        return
    end
    if self._needTimeCoundDown then
        self._elapsed = self._elapsed + dt
        if  self._elapsed >= self._duration then
            self:unregisterOnNoteUpdate(self)
            if (self._task_state == 3 or self._task_state == 1) then
                self.Text_national_task_cell_name:setString(string.format("%s (%s)", self._task_name,red_alert_all_str[54]))
            end
        else
            state_machine.excute("national_task_cell_update_time", 0, {_instance = self, _time =self._duration - self._elapsed})
        end
    end
end

-- 时间count down
function NationalTaskCell:onUpdateTime(params)
    local time = math.modf(params)
    local hour = math.floor(time/ (60 * 60))
    time = time - (hour * 60 * 60)
    local minute = math.floor(time / 60)
    time = time - minute * 60
    local second = time % 60
    self.Text_national_task_cell_name:setString(string.format("%s (%02d:%02d:%02d)", self._task_name, hour, minute, second))
end

function NationalTaskCell:init(data,index)
    -- 参数赋值
    self.data = data

    -- 倒计时时间初始化
    self._duration = self.data._time
    self._elapsed = 0 

    -- 是否加入计时器（国家独有）
    self._needTimeCoundDown = self.data._needTimeCoundDown

    -- element 数据
    self._task_info = self.data._task_config
    -- 任务id
    self._task_id = dms.atoi(self._task_info, warfare_task.id)
    -- 任务名称
    self._task_name = dms.atos(self._task_info, warfare_task.task_name) .. "  " 
    -- 任务参数
    self._task_target = dms.atoi(self._task_info, warfare_task.task_param)
    -- 任务奖励
    self._reward_info = dms.atos(self._task_info, warfare_task.reward_info)
    -- print("self._reward_info++++++++++++++++++++",self._reward_info)
    -- 任务描述
    self._remarks = dms.atos(self._task_info, warfare_task.remarks)
    -- 任务icon
    self._icon = dms.atos(self._task_info, warfare_task.icon)
    -- 任务状态
    self._task_state = self.data._task_state + 1

    if self._needTimeCoundDown then
        if self._task_state == 1 then
            self:registerOnNoteUpdate(self, 0)
        end
    else
        self._task_progress = self.data._task_progress
    end

    -- 缓存个数设置
    if index ~= nil and index < 7 then
        self:onInit()
    end

    self:setContentSize(NationalTaskCell.__size)
    return self
end

function NationalTaskCell:onExit()
    cacher.freeRef(config_csb.cells.campaign.nationalwar.nationalwar_task_cell, self.roots[1])
    state_machine.remove("national_task_cell_update")
    state_machine.remove("national_task_cell_receive")
    state_machine.remove("national_task_cell_go")
    state_machine.remove("national_task_cell_update_time")
end
