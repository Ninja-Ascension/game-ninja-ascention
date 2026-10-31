-- ----------------------------------------------------------------------------------------------------
-- 国战任务列表(国家)
-- ----------------------------------------------------------------------------------------------------
NationalTaskListNational = class("NationalTaskListNationalClass", Window)

local national_task_list_national_window_open_terminal = {
    _name = "national_task_list_national_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalTaskListNationalWindow = fwin:find("NationalTaskListNationalClass")
        if nil == nationalTaskListNationalWindow then
            fwin:open(NationalTaskListNational:new():init(params), fwin._view)
        else
            state_machine.excute("national_task_list_national_window_show", 0, params)
            state_machine.excute("national_task_list_national_window_update", 0, 0)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_task_list_national_window_close_terminal = {
    _name = "national_task_list_national_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalTaskListNationalClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_task_list_national_window_open_terminal)
state_machine.add(national_task_list_national_window_close_terminal)
state_machine.init()

function NationalTaskListNational:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load加载 对应createcell模块
    app.load("client.red_alert.cells.campaign.nationalwar.national_task_cell")

    -- var
    self._list_view  = nil
    self._list_view_posy = nil

    -- Initialize national task list national state machine.
    local function init_national_task_list_national_terminal()
        -- 显示
        local national_task_list_national_window_show_terminal = {
            _name = "national_task_list_national_window_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏
        local national_task_list_national_window_hide_terminal = {
            _name = "national_task_list_national_window_hide",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移除cell
        local national_task_list_national_cell_remove_terminal = {
            _name = "national_task_list_national_cell_remove",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeListCell(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新cell
        local national_task_list_national_cell_update_terminal = {
            _name = "national_task_list_national_cell_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_task_list_national_window_show_terminal)
        state_machine.add(national_task_list_national_window_hide_terminal)
        state_machine.add(national_task_list_national_cell_remove_terminal)
        state_machine.add(national_task_list_national_cell_update_terminal)
        state_machine.init()     
    end

    -- call func init national task list national machine.
    init_national_task_list_national_terminal()
end

function NationalTaskListNational:removeListCell(cell)
    local function delayEndFuncN( _sender )
        if _sender ~= nil then
            self._list_view:removeItem(self._list_view:getIndex(_sender))
            state_machine.excute("national_task_list_national_cell_update", 0 , 0)
            self._list_view:requestRefreshView()
            self._list_view:getInnerContainer():setPositionY(self._list_view_posy - 2)
        end
    end 

    local actions = {}
    table.insert(actions, cc.MoveBy:create(0.45, cc.p(-cell:getContentSize().width- 20,0)))
    table.insert(actions, cc.CallFunc:create(delayEndFuncN))
    cell:runAction(cc.Sequence:create(actions))
end

function NationalTaskListNational:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_posy == posY then
            return
        end
        self._list_view_posy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function NationalTaskListNational:onUpdateDraw(params)
    local root = self.roots[1]
    self._list_view = ccui.Helper:seekWidgetByName(root,"ListView_task")

    self._list_view:removeAllChildren(true)

    -- 读取数据任务数据 log信息
    if not _ED.war_task_info.country then
        -- print("_ED.war_task_info.country  is  null ----------")
        TipDlg.drawTextDailog(red_alert_all_str[45])
        return
    else
        -- print("_ED.war_task_info.country  is  getted ----------")
    end

    local task_list_sorted = self:sortTaskList(_ED.war_task_info.country)

    -- print("#_ED.war_task_info.country  ##########",#_ED.war_task_info.country)
    -- 读取国战任务(国家)数据，生成列表
    for i, v in pairs(task_list_sorted) do
        --任务id
        local task_colume = v.task_id
        -- print("task_colume-----------------",task_colume)
        -- 任务状态
        local task_state = v.task_state
        -- print("task_state-----------------",task_state)
        -- 剩余时间
        local task_cd = v.task_cd
        -- print("task_cd-----------------",task_cd)
        local task_info = dms.element(dms["warfare_task"],task_colume)

        local cell = state_machine.excute("national_task_cell_create", 0, {{
            _needTimeCoundDown = true , 
            _time = tonumber(task_cd), 
            _task_state = tonumber(task_state), 
            _task_config = task_info,
        },i})
        self._list_view:addChild(cell)
    end
    self._list_view_posy = self._list_view:getInnerContainer():getPositionY()
end

function  NationalTaskListNational:sortTaskList(task_list_data)
    local unfininshed_task_index = 1
    local fininshed_task_index = 1
    local task_list_sorted = {}
    for i, v in pairs(task_list_data) do
        if tonumber(v.task_state) == 1 then
            table.insert(task_list_sorted, fininshed_task_index , v)
            fininshed_task_index = fininshed_task_index + 1
            unfininshed_task_index = unfininshed_task_index + 1
        elseif tonumber(v.task_state) == 2 then
            table.insert(task_list_sorted, v)
        elseif tonumber(v.task_state) == 3 then
            -- 过滤掉 已完成 任务
        else
            table.insert(task_list_sorted, unfininshed_task_index ,v)
            unfininshed_task_index = unfininshed_task_index + 1
        end
    end
    return task_list_sorted
end

function NationalTaskListNational:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:onUpdateDraw(params)
end

function NationalTaskListNational:init(params)
    self._rootWindows = params._rootWindows
    self:onInit()
    return self
end

function NationalTaskListNational:onExit()
    state_machine.remove("national_task_list_national_window_show")
    state_machine.remove("national_task_list_national_window_hide")
    state_machine.remove("national_task_list_national_cell_remove")
    state_machine.remove("national_task_list_national_cell_update")
end

