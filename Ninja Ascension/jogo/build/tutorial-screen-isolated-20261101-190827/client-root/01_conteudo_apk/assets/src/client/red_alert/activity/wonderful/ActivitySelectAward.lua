-- ------------------------------------------------
-- 说明：多选一奖励界面
---------------------------------------------------
ActivitySelectAward = class("ActivitySelectAwardClass", Window)

local activity_select_award_open_terminal = {
    _name = "activity_select_award_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ActivitySelectAwardClass") == nil then
            fwin:open(ActivitySelectAward:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_select_award_close_terminal = {
    _name = "activity_select_award_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivitySelectAwardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_select_award_open_terminal)
state_machine.add(activity_select_award_close_terminal)
state_machine.init()

function ActivitySelectAward:ctor()
    self.super:ctor()

    self.roots = {}
    self.actions = {}

    self.selectIndex = 0
    self._reward_cells = {}

    self.rewardList = {}

    self._list_view = nil
    self._list_view_poy = 0

    app.load("client.red_alert.cells.all_resources_cell")
    app.load("client.red_alert.cells.activity.wonderful.select_award_cell")

    local function init_activity_select_award_terminal()
        local activity_select_award_get_reward_terminal = {
            _name = "activity_select_award_get_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = instance.selectIndex
                if index == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[255])
                    return
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("activity_select_award_close", 0, "")
                        state_machine.excute("reward_obtain_window_open",0,{4})
                        state_machine.excute("packs_scrollview_all_update_draw",0,"")
                        state_machine.excute("packs_scrollview_on_update_all",0,"")
                        state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
                        state_machine.excute("packs_scrollview_hero_on_update_all",0,"")
                        state_machine.excute("packs_scrollview_jewelry_onupdate_all_jewelry",0,"")
                        state_machine.excute("packs_update_page",0,"")
                    end
                end
                
                protocol_command.prop_use.param_list = instance._prop.user_prop_id.."\r\n".."1".."\r\n"..index
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, nil, responseCallback, false, nil)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_select_award_change_select_index_terminal = {
            _name = "activity_select_award_change_select_index",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateSelectIndex(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_select_award_on_window_close_terminal = {
            _name = "activity_select_award_on_window_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_select_award_get_reward_terminal)
        state_machine.add(activity_select_award_change_select_index_terminal)
        state_machine.add(activity_select_award_on_window_close_terminal)
        state_machine.init()
    end
    
    init_activity_select_award_terminal()
end

function ActivitySelectAward:updateSelectIndex(index)
    self.selectIndex = index
    for k, v in pairs(self._reward_cells) do
        v:setSelect(false)
    end
end

function ActivitySelectAward:onEnterTransitionFinish()
end

function ActivitySelectAward:onInit()
    local csbItem = csb.createNode(config_csb.activity.wonderful.select_award)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    local action = csb.createTimeline(config_csb.activity.wonderful.select_award)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            state_machine.excute("activity_select_award_close", 0, nil)
        end
    end)
    action:play("window_open", false)

    self._list_view = ccui.Helper:seekWidgetByName(root, "ListView_box")

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "activity_select_award_on_window_close", 
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_select_sure"), nil, 
    {
        terminal_name = "activity_select_award_get_reward", 
        cell = self,
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 2)

    self:updateDraw()
end

function ActivitySelectAward:updateDraw()
    self._list_view:removeAllItems()

    for i, reward_info in pairs(self.rewardList) do
        local cell = state_machine.excute("select_award_cell_create", 0, {i, reward_info})
        self._list_view:addChild(cell)
        table.insert(self._reward_cells, cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function ActivitySelectAward:init(params)
    self._prop = params[1]
    self.rewardList = params[2]
    self:onInit()

    return self
end

function ActivitySelectAward:onExit()
    state_machine.remove("activity_select_award_get_reward")
    state_machine.remove("activity_select_award_change_select_index")
    state_machine.remove("activity_select_award_on_window_close")
end

