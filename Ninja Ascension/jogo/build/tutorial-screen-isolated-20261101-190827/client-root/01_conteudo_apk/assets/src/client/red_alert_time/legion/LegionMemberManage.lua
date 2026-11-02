--------------------------------------------------------------------------------------------------------------
--  说明：工会成员
--------------------------------------------------------------------------------------------------------------
LegionMemberManage = class("LegionMemberManageClass", Window)

--打开界面
local legion_member_manage_window_open_terminal = {
    _name = "legion_member_manage_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionMemberManage:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_member_manage_window_open_terminal)
state_machine.init()

function LegionMemberManage:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0

    self._memberPanel = nil
    self._conPanel = nil
    self._applyPanel = nil

    local function init_legion_member_manage_terminal()
        -- 显示界面
        local legion_member_manage_show_terminal = {
            _name = "legion_member_manage_show",
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

        -- 隐藏界面
        local legion_member_manage_hide_terminal = {
            _name = "legion_member_manage_hide",
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

        local legion_member_manage_change_page_terminal = {
            _name = "legion_member_manage_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = tonumber(params._datas._page)
                if page == 3 and tonumber(_ED.union.user_union_info.union_post) >= 3 then       -- 普通成员，没有权限
                    TipDlg.drawTextDailog(tipString_legion_info[13])
                    return
                end
                instance:changeSelectPage(page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_member_manage_show_terminal)   
        state_machine.add(legion_member_manage_hide_terminal)   
        state_machine.add(legion_member_manage_change_page_terminal)   
        state_machine.init()
    end
    init_legion_member_manage_terminal()
end

function LegionMemberManage:onHide()
    self:setVisible(false)
end

function LegionMemberManage:onShow()
    self:setVisible(true)
end

function LegionMemberManage:changeSelectPage( page )
    local root = self.roots[1]
    local Panel_legion_pepole_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_legion_pepole_tab_box")
    local Button_legion_pepole = ccui.Helper:seekWidgetByName(root, "Button_legion_pepole")
    local Button_contribution_rank = ccui.Helper:seekWidgetByName(root, "Button_contribution_rank")
    local Button_legion_application = ccui.Helper:seekWidgetByName(root, "Button_legion_application")
    if page == self._current_page then
        if page == 1 then
            Button_legion_pepole:setHighlighted(true)
        elseif page == 2 then
            Button_contribution_rank:setHighlighted(true)
        elseif page == 3 then
            Button_legion_application:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_legion_pepole:setHighlighted(false)
    Button_contribution_rank:setHighlighted(false)
    Button_legion_application:setHighlighted(false)

    state_machine.excute("legion_member_hide", 0, nil)
    state_machine.excute("legion_con_ranks_hide", 0, nil)
    state_machine.excute("legion_application_confirmation_hide", 0, nil)
    if page == 1 then
        Button_legion_pepole:setHighlighted(true)
        if self._memberPanel == nil then
            self._memberPanel = state_machine.excute("legion_member_window_open", 0, {Panel_legion_pepole_tab_box})
        else
            state_machine.excute("legion_member_show", 0, nil)
        end
    elseif page == 2 then
        Button_contribution_rank:setHighlighted(true)
       if self._conPanel == nil then
            self._conPanel = state_machine.excute("legion_con_ranks_window_open", 0, {Panel_legion_pepole_tab_box})
        else
            state_machine.excute("legion_con_ranks_show", 0, nil)
        end
    elseif page == 3 then
        Button_legion_application:setHighlighted(true)
        if self._applyPanel == nil then
            self._applyPanel = state_machine.excute("legion_application_confirmation_window_open", 0, {_datas = {rootWindow = Panel_legion_pepole_tab_box}})
        else
            state_machine.excute("legion_application_confirmation_show", 0, nil)
        end
    -- else
    --     Button_contribution_rank:setHighlighted(true)
    --     if self._conPanel == nil then
    --         self._conPanel = state_machine.excute("legion_con_ranks_window_open", 0, {Panel_legion_pepole_tab_box})
    --     else
    --         state_machine.excute("legion_con_ranks_show", 0, nil)
    --     end
    end
end

function LegionMemberManage:onInit(params)
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_tab, 5))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_pepole"), nil, 
    {
        terminal_name = "legion_member_manage_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_contribution_rank"), nil, 
    {
        terminal_name = "legion_member_manage_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_application"), nil, 
    {
        terminal_name = "legion_member_manage_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_legion_apply",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_legion_application"),
            _invoke = nil,
            _interval = 0.2,})
    end

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
    -- self:updateChatView()
end

function LegionMemberManage:onEnterTransitionFinish()

end

function LegionMemberManage:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit(params)
    return self
end

function LegionMemberManage:onExit()
    state_machine.remove("legion_member_manage_show")
    state_machine.remove("legion_member_manage_hide")
    state_machine.remove("legion_member_manage_change_page")
end