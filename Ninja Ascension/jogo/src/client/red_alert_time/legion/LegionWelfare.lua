-- ------------------------------------------------------------------------------------------------------------
--  说明：军团福利
-- ------------------------------------------------------------------------------------------------------------
LegionWelfare = class("LegionWelfareClass", Window)

--打开界面
local legion_welfare_window_open_terminal = {
    _name = "legion_welfare_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionWelfareClass") == nil then
            local _win = LegionWelfare:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_welfare_window_close_terminal = {
    _name = "legion_welfare_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionWelfareClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_welfare_window_open_terminal)
state_machine.add(legion_welfare_window_close_terminal)
state_machine.init()

function LegionWelfare:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1：奖励仓库，2：军团荣耀
    self._last_page_index = 0

    self._reward_panel = nil
    self._reward_panel = nil

     -- Initialize alert_home state machine.
    local function init_legion_welfare_terminal()
        -- 切换页面
        local legion_welfare_change_page_terminal = {
            _name = "legion_welfare_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw(params._datas.page_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local legion_welfare_update_draw_terminal = {
            _name = "legion_welfare_update_draw",
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

        state_machine.add(legion_welfare_change_page_terminal)
        state_machine.add(legion_welfare_update_draw_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_welfare_terminal()
end


-- 显示信息
function LegionWelfare:onUpdateDraw(page)
    local root = self.roots[1]
    local Panel_welfare_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_welfare_tab_box")
    local Button_legion_reward_packs = ccui.Helper:seekWidgetByName(root, "Button_legion_reward_packs")
    local Button_legion_glory = ccui.Helper:seekWidgetByName(root, "Button_legion_glory")
    if page == self._last_page_index then
        if page == 1 then
            Button_legion_reward_packs:setHighlighted(true)
        else
            Button_legion_glory:setHighlighted(true)
        end
        return
    end
    self._last_page_index = page
    Button_legion_reward_packs:setHighlighted(false)
    Button_legion_glory:setHighlighted(false)
    state_machine.excute("legion_welfare_reward_window_hide", 0, nil)
    state_machine.excute("legion_welfare_glory_window_hide", 0, nil)
    if page == 1 then
        Button_legion_reward_packs:setHighlighted(true)
        if self._reward_panel == nil then
            self._reward_panel = state_machine.excute("legion_welfare_reward_window_open", 0, {Panel_welfare_tab_box})
        else
            state_machine.excute("legion_welfare_reward_window_show", 0, nil)
        end
    else
        Button_legion_glory:setHighlighted(true)
        if self._glory_panel == nil then
            self._glory_panel = state_machine.excute("legion_welfare_glory_window_open", 0, {Panel_welfare_tab_box})
        else
            state_machine.excute("legion_welfare_glory_window_show", 0, nil)
        end
    end
end

--初始化界面
function LegionWelfare:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_welfare)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_welfare_close"), nil, 
    {
        terminal_name = "legion_welfare_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_reward_packs"), nil, 
    {
        terminal_name = "legion_welfare_change_page", 
        terminal_state = 0, 
        page_index = 1,
    }, nil, 1)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_glory"), nil, 
    {
        terminal_name = "legion_welfare_change_page", 
        terminal_state = 0, 
        page_index = 2,
    }, nil, 1)    

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:onUpdateDraw(tonumber(params._datas._page))
    else
        self:onUpdateDraw(1)
    end
end

--初始化
function LegionWelfare:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
end

--移除状态机
function LegionWelfare:onExit()
    state_machine.remove("legion_welfare_change_page")
    state_machine.remove("legion_welfare_update_draw")
end