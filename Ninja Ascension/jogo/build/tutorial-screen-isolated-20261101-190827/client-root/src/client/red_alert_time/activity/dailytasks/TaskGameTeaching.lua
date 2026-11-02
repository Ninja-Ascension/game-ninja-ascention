-----------------------------
--任务 日常
-----------------------------
TaskGameTeaching = class("TaskGameTeachingClass", Window)

local task_game_teaching_window_open_terminal = {
    _name = "task_game_teaching_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = TaskGameTeaching:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_game_teaching_window_open_terminal)
state_machine.init()

function TaskGameTeaching:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = nil

    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil
    local function init_task_game_teaching_terminal()
        --显示界面
        local task_game_teaching_window_show_terminal = {
            _name = "task_game_teaching_window_show",
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
        local task_game_teaching_window_hide_terminal = {
            _name = "task_game_teaching_window_hide",
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
        local task_game_teaching_update_listview_terminal = {
            _name = "task_game_teaching_update_listview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.listview ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local task_game_teaching_change_page_terminal = {
            _name = "task_game_teaching_change_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(task_game_teaching_window_show_terminal) 
        state_machine.add(task_game_teaching_window_hide_terminal)
        state_machine.add(task_game_teaching_update_listview_terminal)
        state_machine.add(task_game_teaching_change_page_terminal)
        state_machine.init()
    end

    init_task_game_teaching_terminal()
end

function TaskGameTeaching:onHide()
    self:setVisible(false)
end

function TaskGameTeaching:onShow()
    self:setVisible(true)
end

function TaskGameTeaching:changeSelectPage( page )
    local root = self.roots[1]
    local Button_task_daily_battle = ccui.Helper:seekWidgetByName(root, "Button_task_daily_battle")
    local Button_task_daily_legion = ccui.Helper:seekWidgetByName(root, "Button_task_daily_legion")
    local Button_task_daily_develop = ccui.Helper:seekWidgetByName(root, "Button_task_daily_develop")
    local Button_task_daily_privilege = ccui.Helper:seekWidgetByName(root, "Button_task_daily_privilege")
    local Button_task_daily_privilege_0 = ccui.Helper:seekWidgetByName(root, "Button_task_daily_privilege_0")
    Button_task_daily_battle:setHighlighted(false)
    Button_task_daily_legion:setHighlighted(false)
    Button_task_daily_develop:setHighlighted(false)
    Button_task_daily_privilege:setHighlighted(false)
    Button_task_daily_privilege_0:setHighlighted(false)
    if page == 1 then
        Button_task_daily_battle:setHighlighted(true)
    elseif page == 2 then
        Button_task_daily_legion:setHighlighted(true)
    elseif page == 3 then
        Button_task_daily_develop:setHighlighted(true)
    elseif page == 4 then
        Button_task_daily_privilege:setHighlighted(true)
    else
        Button_task_daily_privilege_0:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    self:onUpdateDraw()
end

function TaskGameTeaching:onUpdateDraw( ... )

    local result = {}
    if _ED.help_info[""..self._current_page] ~= nil then
        result = _ED.help_info[""..self._current_page]
    end

    local items = self.listview:getItems()
    for k,v in pairs(items) do
        state_machine.excute("task_game_teaching_cell_update_info", 0, {cell = v, index = k, info = result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self.listview:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("task_game_teaching_cell_create",0, {i, result[i]})
            self.listview:addChild(cell)
        end
    end

    self.listview:requestRefreshView()
    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
end

function TaskGameTeaching:onUpdate(dt)
    if self.listview ~= nil then
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

function TaskGameTeaching:onEnterTransitionFinish()

end

function TaskGameTeaching:initData()
    if _ED.help_info == nil then
        _ED.help_info = {}
        for i = 1, dms.count(dms["build_help"]) do
            local info = {}
            local build_help_mould_info = dms.element(dms["build_help"], i)
            info.page = dms.atoi(build_help_mould_info, build_help.page)
            info.title_name = dms.atos(build_help_mould_info, build_help.title_name)
            info.tital_info = dms.atos(build_help_mould_info, build_help.tital_info)
            info.button_name = dms.atos(build_help_mould_info, build_help.button_name)
            info.fun_id = dms.atoi(build_help_mould_info, build_help.fun_id)
            info.build_id = dms.atoi(build_help_mould_info, build_help.build_id)
            info.distribute = dms.atos(build_help_mould_info, build_help.distribute)
            info.pos = dms.atos(build_help_mould_info, build_help.pos)
            info.pic = dms.atoi(build_help_mould_info, build_help.pic)
            if _ED.help_info[""..info.page] == nil then
                _ED.help_info[""..info.page] = {}
            end
            table.insert(_ED.help_info[""..info.page], info)
        end
    end
end

function TaskGameTeaching:onInit( )
    local csbItem = csb.createNode(config_csb.task.task_game_teaching_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:initData()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_battle"), nil, 
    {
        terminal_name = "task_game_teaching_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_legion"), nil, 
    {
        terminal_name = "task_game_teaching_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_develop"), nil, 
    {
        terminal_name = "task_game_teaching_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_privilege"), nil, 
    {
        terminal_name = "task_game_teaching_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task_daily_privilege_0"), nil, 
    {
        terminal_name = "task_game_teaching_change_page", 
        terminal_state = 0, 
        _page = 6,
    }, nil, 1)

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

    self.listview = ccui.Helper:seekWidgetByName(root, "ListView_task_mine")
    self.listview:removeAllItems()

    self:changeSelectPage(1)
end

function TaskGameTeaching:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function TaskGameTeaching:onExit()
    state_machine.remove("task_game_teaching_window_show") 
    state_machine.remove("task_game_teaching_window_hide")
    state_machine.remove("task_game_teaching_update_listview")
    state_machine.remove("task_game_teaching_change_page")
end