-- ----------------------------------------------------------------------------------------------------
-- 个人荣誉弹出窗口
-- ----------------------------------------------------------------------------------------------------
NationalRankPersonalPop = class("NationalRankPersonalPopClass", Window)

-- 打开窗口
local national_rank_personal_pop_window_open_terminal = {
    _name = "national_rank_personal_pop_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalRankPersonalPopWindow = fwin:find("NationalRankPersonalPopClass")
        if nil == nationalRankPersonalPopWindow then
            fwin:open(NationalRankPersonalPop:new():init(params), fwin._view)
        else 
            state_machine.excute("national_rank_personal_pop_window_show", 0, 0)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local national_rank_personal_pop_window_close_terminal = {
    _name = "national_rank_personal_pop_window_close",
    _init = function (terminal)
        fwin:close(fwin:find("NationalRankPersonalPopClass"))
        return true     
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalRankPersonalPopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_rank_personal_pop_window_open_terminal)
state_machine.add(national_rank_personal_pop_window_close_terminal)
state_machine.init()

function NationalRankPersonalPop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- Initialize national rank honour personal pop state machine.
    local function init_rank_personal_pop_terminal()
        --管理
        local national_rank_personal_pop_window_manager_terminal = {
            _name = "national_rank_personal_pop_window_manager",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.select_item ~= params then
                    state_machine.excute(params._datas.next_terminal_name, 0, params)

                    if terminal.select_item ~= nil then
                       terminal.select_item:setHighlighted(false)
                       terminal.select_item:setTouchEnabled(true)
                    end

                    terminal.select_item = params
                    terminal.select_item:setHighlighted(true)
                    terminal.select_item:setTouchEnabled(false)
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示
        local national_rank_personal_pop_window_show_terminal = {
            _name = "national_rank_personal_pop_window_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                state_machine.excute("national_rank_list_personal_window_show", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --隐藏
        local national_rank_personal_pop_window_hide_terminal = {
            _name = "national_rank_personal_pop_window_hide",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                state_machine.excute("national_rank_list_personal_window_hide", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_rank_personal_pop_window_manager_terminal)
        state_machine.add(national_rank_personal_pop_window_show_terminal)
        state_machine.add(national_rank_personal_pop_window_hide_terminal)
        state_machine.init()     
    end

    -- call func init rank personal pop state machine.
    init_rank_personal_pop_terminal()
end


function NationalRankPersonalPop:init(params)
    self._rootWindows = params._rootWindows
    self:onInit(params)
    return self
end

function NationalRankPersonalPop:onInit(params)
    -- 当前页参数
    local currentPageIndex = 1

    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_rank_cell_left)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 1:蜀国 \ 2:魏国 \ 3:吴国
    for i=1, 3 do
        local Button_national = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_" .. i), nil, 
        {
            terminal_name = "national_rank_personal_pop_window_manager",     
            next_terminal_name = "national_rank_list_personal_window_open", 
            current_button_name = "Button_national_" .. i,   
            terminal_state = 0, 
            isPressedActionEnabled = false,
            _listView_rootWindows = params._listView_rootWindows,
            _pageIndex = i
        }, nil, 3)
        if currentPageIndex == i then
            fwin.touch(Button_national, ccui.TouchEventType.ended)
        end
    end
end

function NationalRankPersonalPop:onExit()
    state_machine.remove("national_rank_personal_pop_window_manager")
    state_machine.remove("national_rank_personal_pop_window_show")
    state_machine.remove("national_rank_personal_pop_window_hide")
end