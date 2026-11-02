-----------------------------
--国战奖励查看主界面
-----------------------------
NationalReward = class("NationalRewardClass", Window)

-- 打开窗口
local national_reward_window_open_terminal = {
    _name = "national_reward_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalRewardWindow = fwin:find("NationalRewardClass")
        if nil == nationalRewardWindow then
            fwin:open(NationalReward:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local national_reward_window_close_terminal = {
    _name = "national_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_reward_window_open_terminal)
state_machine.add(national_reward_window_close_terminal)
state_machine.init()

function NationalReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load
    app.load("client.red_alert.campaign.nationalwar.NationalRewardListNational")
    app.load("client.red_alert.campaign.nationalwar.NationalRewardListPersonal")
    
    -- Initialize national reward state machine.
    local function init_national_Reward_terminal()
    	-- 管理
        local national_reward_manager_terminal = {
            _name = "national_reward_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    -- excute params._datas.next_terminal_name
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end 
                -- set select ui button is highlighted
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                else
                    terminal.select_button = params
                end

                if terminal.select_button.setHighlighted == nil and params._datas.current_button_name ~= nil then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 国战奖励-国家
        local national_reward_change_to_national_terminal = {
            _name = "national_reward_change_to_national",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("national_reward_list_national_window_open", 0, params._datas)
                state_machine.excute("national_reward_list_personal_window_hide", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 国战奖励-个人
        local national_reward_change_to_personal_terminal = {
            _name = "national_reward_change_to_personal",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("national_reward_list_personal_window_open", 0, params._datas)
                state_machine.excute("national_reward_list_national_window_hide", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_reward_manager_terminal)
        state_machine.add(national_reward_change_to_national_terminal)
        state_machine.add(national_reward_change_to_personal_terminal)
        state_machine.init()     
    end
    -- call func init nationalReward state machine.
    init_national_Reward_terminal()
end

function NationalReward:init(params)
    self:onInit(params)
    return self
end

function NationalReward:onInit(params)
	local currentPageIndex = params.pageIndex or 1

	local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_reward_close"), nil, 
    {
        terminal_name = "national_reward_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 国家城池按钮
    local Button_national_truce_reward_national = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_reward_national"), nil, 
    {
        terminal_name = "national_reward_manager", 
	    next_terminal_name = "national_reward_change_to_national", 
        current_image_name = "Button_national_truce_reward_national",
        terminal_state = 0, 
        isPressedActionEnabled = false,
        _rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_listView"),
    }, nil, 3)

    -- 个人荣誉按钮
    local Button_national_truce_reward_personal = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_reward_personal"), nil, 
    {
        terminal_name = "national_reward_manager", 
       	next_terminal_name = "national_reward_change_to_personal", 
        current_image_name = "Button_national_truce_reward_personal",
        terminal_state = 0, 
        isPressedActionEnabled = false, 
        _rootWindows = ccui.Helper:seekWidgetByName(root,"Panel_listView"),
    }, nil, 3)

	if currentPageIndex == 1 then
        fwin.touch(Button_national_truce_reward_national, ccui.TouchEventType.ended)
    else
        fwin.touch(Button_national_truce_reward_personal, ccui.TouchEventType.ended)
    end
end

function NationalReward:onExit()
	state_machine.remove("national_reward_manager")
    state_machine.remove("national_reward_change_to_national")
    state_machine.remove("national_reward_change_to_personal")
end

