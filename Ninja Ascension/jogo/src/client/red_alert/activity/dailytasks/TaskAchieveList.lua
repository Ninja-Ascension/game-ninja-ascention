-----------------------------
--任务 成就
-----------------------------
TaskAchieveList = class("TaskAchieveListClass", Window)

local task_achieve_list_window_open_terminal = {
    _name = "task_achieve_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("TaskAchieveListClass")
        if nil == _Window then
            fwin:open(TaskAchieveList:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_achieve_list_window_open_terminal)
state_machine.init()

function TaskAchieveList:ctor()
    self.super:ctor()
    self.roots = {}
 
    self.listview = nil
    self.listview_poy = nil

    -- Initialize achieve_list state machine.
    local function init_task_achieve_list_terminal()
    
        --显示界面
        local task_achieve_list_window_show_terminal = {
            _name = "task_achieve_list_window_show",
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
        local task_achieve_list_window_hide_terminal = {
            _name = "task_achieve_list_window_hide",
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
        local task_achieve_list_remove_cell_terminal = {
            _name = "task_achieve_list_remove_cell",
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
        local task_achieve_list_update_listview_terminal = {
            _name = "task_achieve_list_update_listview",
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

        state_machine.add(task_achieve_list_window_show_terminal) 
        state_machine.add(task_achieve_list_window_hide_terminal)
        state_machine.add(task_achieve_list_remove_cell_terminal)
        state_machine.add(task_achieve_list_update_listview_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_task_achieve_list_terminal()
end

function TaskAchieveList:onHide()
    self:setVisible(false)
end

function TaskAchieveList:onShow()
    self:setVisible(true)
    -- state_machine.excute("task_achieve_list_update_listview", 0, nil)
end

function TaskAchieveList:removeListCell(cell)
    self.listview:removeItem(self.listview:getIndex(cell))
end

function TaskAchieveList:onUpdateDraw()
    local root = self.roots[1]
    local index = 1
    local ListView_task = ccui.Helper:seekWidgetByName(root,"ListView_task")
    ListView_task:removeAllItems()
    if _ED.user_task_infos["2"] == nil then
        return
    end
    local cells = {}
    local finish_cells = {}
    for i,v in pairs(_ED.user_task_infos["2"]) do
        -- ListView_task:addChild(cell)
        local cell = state_machine.excute("task_create_cell",0, {2,v,index})
        if tonumber(v.task_complete_count) >= tonumber(v.need_complete_count) then
            if tonumber(v.achievement_finish_type) == 28 then
                index = index + 1
                table.insert(cells,cell)
            else
                index = index + 1
                table.insert(finish_cells,cell)
            end
        else
            if tonumber(v.achievement_finish_type) == 28 then
                index = index + 1
                table.insert(finish_cells,cell)
            else
                table.insert(cells,cell)
                index = index + 1
            end
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

function TaskAchieveList:onUpdate(dt)
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

function TaskAchieveList:onEnterTransitionFinish()

end

function TaskAchieveList:onInit( )
    local csbItem = csb.createNode(config_csb.activity.dailytasks.task_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function TaskAchieveList:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function TaskAchieveList:onExit()
    state_machine.remove("task_achieve_list_window_show") 
    state_machine.remove("task_achieve_list_window_hide")
    state_machine.remove("task_achieve_list_remove_cell")
    state_machine.remove("task_achieve_list_update_listview")
end
