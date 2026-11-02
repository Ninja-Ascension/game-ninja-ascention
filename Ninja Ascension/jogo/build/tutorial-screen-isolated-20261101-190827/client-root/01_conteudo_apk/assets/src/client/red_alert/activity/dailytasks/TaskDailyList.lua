-----------------------------
--任务 日常
-----------------------------
TaskDailyList = class("TaskDailyListClass", Window)

local task_daily_list_window_open_terminal = {
    _name = "task_daily_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("TaskDailyListClass")
        if nil == _Window then
            fwin:open(TaskDailyList:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_daily_list_window_open_terminal)
state_machine.init()

function TaskDailyList:ctor()
    self.super:ctor()
    self.roots = {}
 
    self.listview = nil
    self.listview_poy = nil

    -- Initialize task_main_line_list state machine.
    local function init_task_daily_list_terminal()
    
        --显示界面
        local task_daily_list_window_show_terminal = {
            _name = "task_daily_list_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏界面
        local task_daily_list_window_hide_terminal = {
            _name = "task_daily_list_window_hide",
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
        --移除cell
        local task_daily_list_remove_cell_terminal = {
            _name = "task_daily_list_remove_cell",
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

        --重新绘制
        local task_daily_list_update_listview_terminal = {
            _name = "task_daily_list_update_listview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.listview ~= nil then
                    instance:onUpdateDraw()
                    instance.listview:jumpToTop()
                    instance.listview:getInnerContainer():setPositionY(instance.listview:getInnerContainer():getPositionY() - 1)
                    instance.listview:requestRefreshView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        state_machine.add(task_daily_list_window_show_terminal) 
        state_machine.add(task_daily_list_window_hide_terminal)
        state_machine.add(task_daily_list_remove_cell_terminal)
        state_machine.add(task_daily_list_update_listview_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_task_daily_list_terminal()
end

function TaskDailyList:onHide()
    self:setVisible(false)
end

function TaskDailyList:onShow()
    self:setVisible(true)
    -- state_machine.excute("task_daily_list_update_listview", 0, nil)
end

function TaskDailyList:onUpdateDraw()
    local root = self.roots[1]
    local index = 1
    local ListView_task = ccui.Helper:seekWidgetByName(root,"ListView_task")
    ListView_task:removeAllItems()
    if _ED.user_task_infos["1"] == nil then
        return
    end
    local cells = {}
    local finish_cells = {}
    for i,v in pairs(_ED.user_task_infos["1"]) do
        -- ListView_task:addChild(cell)
        local cell = state_machine.excute("task_create_cell",0, {1,v,index})
        if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
            index = index + 1
            table.insert(finish_cells,cell)
        else
            table.insert(cells,cell)
            index = index + 1
        end
    end

    for i,cell in pairs(finish_cells) do
        ListView_task:addChild(cell)
        
    end
    for i,cell in pairs(cells) do
        ListView_task:addChild(cell)
    end
    ListView_task:requestRefreshView()
    self.listview = ListView_task
    self.listview_poy = ListView_task:getInnerContainer():getPositionY()
    self.listview_poy = -1
end

function TaskDailyList:removeListCell(cell)
    self.listview:removeItem(self.listview:getIndex(cell))
end

function TaskDailyList:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

function TaskDailyList:onEnterTransitionFinish()

end

function TaskDailyList:onInit( )
    local csbItem = csb.createNode(config_csb.activity.dailytasks.task_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function TaskDailyList:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function TaskDailyList:onExit()
    state_machine.remove("task_daily_list_window_show") 
    state_machine.remove("task_daily_list_window_hide")
    state_machine.remove("task_daily_list_remove_cell")
    state_machine.remove("task_daily_list_update_listview")
end
