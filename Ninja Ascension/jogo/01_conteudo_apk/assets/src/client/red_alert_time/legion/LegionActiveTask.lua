-- ------------------------------------------------------------------------------------------------------------
--  说明：军团活跃任务
-- ------------------------------------------------------------------------------------------------------------
LegionActiveTask = class("LegionActiveTaskClass", Window)

--打开界面
local legion_active_task_open_terminal = {
    _name = "legion_active_task_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionActiveTask:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_active_task_open_terminal)
state_machine.init()

function LegionActiveTask:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_legion_active_task_terminal()
        local legion_active_task_show_terminal = {
            _name = "legion_active_task_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                state_machine.excute("legion_active_task_change_level_state", 0, {_datas = {index = 1}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_active_task_hide_terminal = {
            _name = "legion_active_task_hide",
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

        local legion_active_task_change_level_state_terminal = {
            _name = "legion_active_task_change_level_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                instance:changeChooseLevel(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_active_task_update_draw_terminal = {
            _name = "legion_active_task_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_active_task_show_terminal)
        state_machine.add(legion_active_task_hide_terminal)
        state_machine.add(legion_active_task_change_level_state_terminal)
        state_machine.add(legion_active_task_update_draw_terminal)
        state_machine.init()
    end
    init_legion_active_task_terminal()
end

function LegionActiveTask:changeChooseLevel( chooseLevel )
    local root = self.roots[1]
    local Text_active_lv_infor = ccui.Helper:seekWidgetByName(root, "Text_active_lv_infor")
    for i=1,5 do
        local Button_active_lv = ccui.Helper:seekWidgetByName(root, "Button_active_lv_"..i)
        if i == chooseLevel then
            Button_active_lv:setHighlighted(true)
        else
            Button_active_lv:setHighlighted(false)
        end
    end
    local share_res_ratio = dms.float(dms["union_active_level"], chooseLevel, union_active_level.share_res_ratio)
    local first_donate = dms.int(dms["union_active_level"], chooseLevel, union_active_level.first_donate)
    local max_active = dms.int(dms["union_config"], 53, union_config.param)
    share_res_ratio = share_res_ratio * 100
    local info = ""
    if share_res_ratio == 0 then
        info = info .. tipString_legion_info[33].."\r\n"
    else
        info = info .. string.format(tipString_legion_info[34], ""..share_res_ratio).."\r\n"
    end
    if first_donate > 1 then
        info = info .. string.format(tipString_legion_info[35], first_donate).."\r\n"
    end
    if chooseLevel == 5 then
        info = info .. string.format(tipString_legion_info[36], max_active)
    end
    Text_active_lv_infor:setString(info)
end

function LegionActiveTask:onUpdateDraw()
    local root = self.roots[1]
    local ListView_active_task = ccui.Helper:seekWidgetByName(root, "ListView_active_task")
    local Text_active_lv_n = ccui.Helper:seekWidgetByName(root, "Text_active_lv_n")
    local LoadingBar_active_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_active_bar")
    local Text_active_lv_ing = ccui.Helper:seekWidgetByName(root, "Text_active_lv_ing")

    ListView_active_task:jumpToTop()
    ListView_active_task:removeAllItems()

    local current_level = tonumber(_ED.union_active_info.active_level)
    local task_ids = zstring.split(dms.string(dms["union_active_level"], current_level, union_active_level.task_id), "|")
    local need_active = dms.int(dms["union_active_level"], current_level + 1, union_active_level.need_active)
    local max_active = dms.int(dms["union_config"], 53, union_config.param)
    if need_active == nil then
        need_active = max_active
    end
    local current_active = tonumber(_ED.union_active_info.active_point)

    for k, v in pairs(task_ids) do
        local task_info = zstring.split(v, ",")
        local cell = state_machine.excute("legion_active_task_create_cell", 0, {k, tonumber(task_info[1]), tonumber(task_info[2])})
        ListView_active_task:addChild(cell)
    end

    Text_active_lv_n:setString(string.format(red_alert_time_str[33], current_level))
    Text_active_lv_ing:setString(current_active.."/"..need_active)
    LoadingBar_active_bar:setPercent(current_active / need_active * 100)
    self:changeChooseLevel(current_level)
end

function LegionActiveTask:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_active_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_active_infor"), nil, 
    {
        terminal_name = "legion_active_help_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)    

    for i=1,5 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_active_lv_"..i), nil, 
        {
            terminal_name = "legion_active_task_change_level_state", 
            terminal_state = 0, 
            touch_black = true,
            index = i,
        }, nil, 1)
    end
    ccui.Helper:seekWidgetByName(root, "Image_active_arrow_up"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_active_arrow_down"):setVisible(false)

    self:onUpdateDraw()
end

function LegionActiveTask:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow   
    self:onInit()
    return self
end

function LegionActiveTask:onExit()
    state_machine.remove("legion_active_task_show")
    state_machine.remove("legion_active_task_hide")
    state_machine.remove("legion_active_task_change_level_state")
    state_machine.remove("legion_active_task_update_draw")
end