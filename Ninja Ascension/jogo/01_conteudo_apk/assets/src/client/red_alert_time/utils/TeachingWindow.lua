--------------------------------------------------------------------------------------------------------------
--  说明：小助手
--------------------------------------------------------------------------------------------------------------
TeachingWindow = class("TeachingWindowClass", Window)

--打开界面
local teaching_window_open_terminal = {
    _name = "teaching_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("TeachingWindowClass") == nil then
            fwin:open(TeachingWindow:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local teaching_window_close_terminal = {
    _name = "teaching_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TeachingWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(teaching_window_open_terminal)
state_machine.add(teaching_window_close_terminal)
state_machine.init()

function TeachingWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self._choose_index = 0

    local function init_teaching_window_terminal()
        local teaching_window_return_terminal = {
            _name = "teaching_window_return",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updatePanelState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local teaching_window_click_button_terminal = {
            _name = "teaching_window_click_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._choose_index = params._datas.index
                if #_ED.help_info[""..instance._choose_index] <= 1 then
                    state_machine.excute("teaching_window_goto_function", 0, {_datas = {index = 1}})
                else
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local teaching_window_goto_function_terminal = {
            _name = "teaching_window_goto_function",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                local info = _ED.help_info[""..instance._choose_index][index]
                if info ~= nil then
                    if info.fun_id <= 0 then
                        state_machine.excute("home_map_reset_scale", 0, nil)
                        state_machine.excute("home_map_scroll_to_panel_city", 0, {info.build_id, true, info})
                    else
                        state_machine.excute("short_cut_go_to_other_window",0,{info.fun_id, nil, info})
                    end
                    state_machine.excute("teaching_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(teaching_window_return_terminal)
        state_machine.add(teaching_window_click_button_terminal)
        state_machine.add(teaching_window_goto_function_terminal)
        state_machine.init()
    end
    init_teaching_window_terminal()
end

function TeachingWindow:updatePanelState( ... )
    if self._choose_index > 0 then
        self._choose_index = 0
        self:updateDraw()
    else
        state_machine.excute("teaching_window_close", 0, nil)
    end
end

function TeachingWindow:updateDraw()
    local root = self.roots[1]
    local Panel_teaching_up = ccui.Helper:seekWidgetByName(root,"Panel_teaching_up")
    local Panel_teaching_up_0 = ccui.Helper:seekWidgetByName(root,"Panel_teaching_up_0")
    local Text_leader_synopsis_title_0 = ccui.Helper:seekWidgetByName(root,"Text_leader_synopsis_title_0")
    Panel_teaching_up:setVisible(false)
    Panel_teaching_up_0:setVisible(false)
    Text_leader_synopsis_title_0:setString("")
    local title_info = ""
    if self._choose_index > 0 then
        Panel_teaching_up_0:setVisible(true)
        for i=1,6 do
            local button = ccui.Helper:seekWidgetByName(root,"Button_teaching_up_0_"..i)
            button:setVisible(false)
            if _ED.help_info[""..self._choose_index] ~= nil then
                local info = _ED.help_info[""..self._choose_index][i]
                if info ~= nil then
                    button:setVisible(true)
                    button:setTitleText(zstring.exchangeFrom(info.button_name))
                    if title_info == "" then
                        title_info = zstring.exchangeFrom(info.tital_info)
                    end
                end
            end
        end
        Text_leader_synopsis_title_0:setString(title_info)
    else
        Text_leader_synopsis_title_0:setString(red_alert_time_str[269])
        Panel_teaching_up:setVisible(true)
    end
end

--初始化
function TeachingWindow:onInit()
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
            if _ED.help_info[""..info.page] == nil then
                _ED.help_info[""..info.page] = {}
            end
            table.insert(_ED.help_info[""..info.page], info)
        end
    end
    local csbItem = csb.createNode(config_csb.utils.teaching_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_teaching_infor_close"), nil, 
    {
        terminal_name = "teaching_window_return",
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "teaching_window_close",
        terminal_state = 0, 
    }, nil, 3)

    for i=1,6 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_teaching_up_"..i), nil, 
        {
            terminal_name = "teaching_window_click_button",
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 1)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_teaching_up_0_"..i), nil, 
        {
            terminal_name = "teaching_window_goto_function",
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 1)
    end

    self:updateDraw()
    
end

function TeachingWindow:onEnterTransitionFinish()

end

function TeachingWindow:init()
    self:onInit()
    return self
end

function TeachingWindow:onExit()
    state_machine.remove("teaching_window_return")
    state_machine.remove("teaching_window_click_button")
    state_machine.remove("teaching_window_goto_function")
end