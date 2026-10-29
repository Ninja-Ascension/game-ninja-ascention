-----------------------------
--任务 主线
-----------------------------
TaskMainLineList = class("TaskMainLineListClass", Window)

local task_main_line_list_window_open_terminal = {
    _name = "task_main_line_list_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = TaskMainLineList:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_main_line_list_window_open_terminal)
state_machine.init()

function TaskMainLineList:ctor()
    self.super:ctor()
    self.roots = {}
 
	self.listview = nil
	self.listview_poy = nil
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    self._cell_size = nil

    self._isShowTuition = false
    self._need_update = false
    self._is_show = true

    local function init_task_main_line_list_terminal()
		--显示界面
		local task_main_line_list_window_show_terminal = {
            _name = "task_main_line_list_window_show",
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
		local task_main_line_list_window_hide_terminal = {
            _name = "task_main_line_list_window_hide",
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

        --重新绘制
        local task_main_line_list_update_listview_terminal = {
            _name = "task_main_line_list_update_listview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.listview ~= nil then
                    local posY = instance.listview_poy
                    instance:onUpdateDraw()
                    if math.abs(posY) > math.abs(instance.listview_height) then
                        posY = instance.listview_height
                    end
                    instance.listview:getInnerContainer():setPositionY(posY)   
                    instance.listview_poy = posY - 1
                    instance.listview:requestRefreshView()

                    instance._need_update = true
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local task_main_line_list_update_drawtuition_controller_terminal = {
            _name = "task_main_line_list_update_drawtuition_controller",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if nil ~= instance._mcell 
                    and tonumber(_ED.user_info.user_grade) <= 10
                    and missionIsOver() == true 
                    then
                    fwin:addService({
                        callback = function ( params )
                            local mcell = params._mcell
                            if mcell ~= nil and mcell.roots ~= nil and mcell.roots[1] ~= nil then
                                mcell._isShowTuition = true
                                local Button_task_go = ccui.Helper:seekWidgetByName(params._mcell.roots[1], "Button_task_go")
                                state_machine.excute("tuition_controller_touch_normal", 0, {Button_task_go, false})
                            end
                        end,
                        params = instance,
                        delay = 0.5
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(task_main_line_list_window_show_terminal)	
		state_machine.add(task_main_line_list_window_hide_terminal)
        state_machine.add(task_main_line_list_update_listview_terminal)
        state_machine.add(task_main_line_list_update_drawtuition_controller_terminal)
        state_machine.init()
    end
    init_task_main_line_list_terminal()
end

function TaskMainLineList:onHide()
    self:setVisible(false)
    self._is_show = false
end

function TaskMainLineList:onShow()
    self:setVisible(true)
    self._is_show = true
    if self._need_update == true then
        self.listview_poy = self.listview_poy + 1
    end
end

function TaskMainLineList:onUpdateDraw()
    local root = self.roots[1]
    local Panel_main_task = ccui.Helper:seekWidgetByName(root,"Panel_main_task")
    local ListView_task_main = ccui.Helper:seekWidgetByName(root,"ListView_task_main")

    if _ED.user_task_infos["0"] == nil then
        return
    end

    Panel_main_task:removeAllChildren(true)
    if _ED.user_frist_task ~= nil then
        local cell = state_machine.excute("task_create_cell",0, {1, _ED.user_frist_task, 1})
        Panel_main_task:addChild(cell)
        Panel_main_task.roots = cell.roots
    end

    ListView_task_main:jumpToTop()
    ListView_task_main:removeAllItems()

    local role_tasks = {}
    local base_tasks = {}
    local resources_tasks = {}
    local index = 1
    local cell = nil 
    for i,v in pairs(_ED.user_task_infos["0"]) do
        if zstring.tonumber(v.task_state) ~= 4 then
            if v.little_type == 1 then 
                table.insert(role_tasks,v)
            elseif v.little_type == 2 then 
                table.insert(base_tasks,v)
            else
                table.insert(resources_tasks,v)
            end
        end
    end

    if _ED.user_task_infos["5"] ~= nil then
        for i,v in pairs(_ED.user_task_infos["5"]) do
            if zstring.tonumber(v.task_state) ~= 4 then
                if v.little_type == 1 then 
                    table.insert(role_tasks, v)
                elseif v.little_type == 2 then 
                    table.insert(base_tasks, v)
                else
                    table.insert(resources_tasks, v)
                end
            end
        end
    end

    local function sortFunction(a, b)
        return tonumber(a.sort_index) < tonumber(b.sort_index)
    end
    table.sort(role_tasks, sortFunction)
    table.sort(base_tasks, sortFunction)
    table.sort(resources_tasks, sortFunction)

    self._mcell = nil
    local mcell = nil

    -- 角色分类
    if #role_tasks > 0 then
        cell = state_machine.excute("task_title_create_cell",0, {1})
        ListView_task_main:addChild(cell)
        for i,v in pairs(role_tasks) do
            cell = state_machine.excute("task_create_cell",0, {0,v,index})
            ListView_task_main:addChild(cell)
            index = index + 1 

            if nil == mcell and (v.sort_index == 1 or v.sort_index == 8) then
                mcell = cell
            end

            if self._cell_size == nil then
                self._cell_size = cell:getContentSize()
            end
        end
    end

    -- 基地分类
    if #base_tasks > 0 then
        cell = state_machine.excute("task_title_create_cell",0, {2})
        ListView_task_main:addChild(cell)
        for i,v in pairs(base_tasks) do
            cell = state_machine.excute("task_create_cell",0, {0,v,index})
            ListView_task_main:addChild(cell)
            index = index + 1 

            if nil == mcell and (v.sort_index == 1 or v.sort_index == 8) then
                mcell = cell
            end

            if self._cell_size == nil then
                self._cell_size = cell:getContentSize()
            end
        end
    end

    -- 资源分类
    if #resources_tasks > 0 then
        cell = state_machine.excute("task_title_create_cell",0, {3})
        ListView_task_main:addChild(cell)
        for i,v in pairs(resources_tasks) do
            cell = state_machine.excute("task_create_cell",0, {0,v,index})
            ListView_task_main:addChild(cell)
            index = index + 1 

            if self._cell_size == nil then
                self._cell_size = cell:getContentSize()
            end
        end
    end

    ListView_task_main:requestRefreshView()
    self.listview = ListView_task_main
    self.listview_poy = ListView_task_main:getInnerContainer():getPositionY()
    self.listview_height = ListView_task_main:getInnerContainer():getPositionY()

    self._mcell = mcell
end

function TaskMainLineList:onUpdate(dt)
    if self.listview ~= nil then
        local last_list_view_pos = self.listview:getInnerContainer():getPosition()
        if fwin:find("TuitionControllerClass") ~= nil then
            if self.listview_poy ~= last_list_view_pos
                and self._isShowTuition == true 
                then
                self._isShowTuition = false
                state_machine.excute("tuition_controller_exit", 0, nil)
            end
        else
            self._isShowTuition = false
        end
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_player_build_arrow_down:setVisible(true)
        else
            self._Image_player_build_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_player_build_arrow_up:setVisible(true)
        else
            self._Image_player_build_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = self._cell_size
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end

        if self._need_update == true and self._is_show == true then
            self._need_update = false
            self.listview_poy = self.listview_poy + 1
        end
    end
end

function TaskMainLineList:onEnterTransitionFinish()

end

function TaskMainLineList:onInit( )
    local csbItem = csb.createNode(config_csb.task.task_main_tab)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self._Image_player_build_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_down")
    self._Image_player_build_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_player_build_arrow_down:stopAllActions()
    self._Image_player_build_arrow_up:stopAllActions()
    playActions(self._Image_player_build_arrow_down)
    playActions(self._Image_player_build_arrow_up)
    self._Image_player_build_arrow_down:setVisible(false)
    self._Image_player_build_arrow_up:setVisible(false)

	self:onUpdateDraw()
end

function TaskMainLineList:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function TaskMainLineList:onExit()
    state_machine.remove("task_main_line_list_window_show") 
    state_machine.remove("task_main_line_list_window_hide")
    state_machine.remove("task_main_line_list_update_listview")
    state_machine.remove("task_main_line_list_update_drawtuition_controller")
end
