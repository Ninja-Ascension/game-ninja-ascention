----------------------------------------------------------------------------------------------------
-- 说明：开服基金活动
-------------------------------------------------------------------------------------------------------
-- run\res\cocostudio\shop\reward_preview
-- package_preview_list

OpenServerActivity = class("OpenServerActivityClass", Window)

local open_server_activity_open_terminal = {
    _name = "open_server_activity_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("menu_clean_page_state", 0, "home")
        local _openServerActivity = OpenServerActivity:createCell()
        _openServerActivity:init()
        fwin:open(_openServerActivity,fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(open_server_activity_open_terminal)
state_machine.init()
function OpenServerActivity:ctor()
    self.super:ctor()
    self.roots = {}
    self.group = {
        _all_server_fund = nil,
        _all_server_welfare = nil
    }

    self.loaded = false
	
    -- Initialize open server activity page state machine.
    local function init_open_server_activity_terminal()
		local open_server_activity_manager_terminal = {
            _name = "open_server_activity_manager",
            _init = function (terminal) 
                app.load("client.cells.activity.open_server_list_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                else
                    if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                        terminal.last_terminal_name = params._datas.next_terminal_name
                        state_machine.excute(params._datas.next_terminal_name, 0, params)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

                
        -- 进入开服基金活动页面
        local open_server_activity_servers_fund_terminal = {
            _name = "open_server_activity_servers_fund",
            _init = function (terminal) 
                app.load("client.activity.open_server.AllServerFundActivity")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showAllServerFundActivity()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
                    then
                else
    				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20"):setVisible(true)
    				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_21"):setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 进入全民福利活动页面
        local open_server_activity_servers_welfare_terminal = {
            _name = "open_server_activity_servers_welfare",
            _init = function (terminal)
                app.load("client.activity.open_server.AllServerWelfareActivity")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showAllServerWelfareActivity()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
                    then
                else
    				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_21"):setVisible(true)
    				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_20"):setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        local open_server_activity_close_terminal = {
            _name = "open_server_activity_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                for i,v in pairs(instance.group) do
                    if v ~= nil then
                        fwin:close(v)
                    end
                end

                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(open_server_activity_manager_terminal)
        state_machine.add(open_server_activity_servers_fund_terminal)
        state_machine.add(open_server_activity_servers_welfare_terminal)
        state_machine.add(open_server_activity_close_terminal)
        state_machine.init()
    end
    
    -- call func init open server activity state machine.
    init_open_server_activity_terminal()
end

function OpenServerActivity:initAllServerFundActivity()
    local root = self.roots[1]

    self._all_server_fund = AllServerFundActivity:createCell()
    root:addChild(self._all_server_fund)
end

function OpenServerActivity:showAllServerFundActivity()
    if self._all_server_fund == nil then
        self:initAllServerFundActivity()
    end
    self._all_server_fund:setVisible(true)
    if self._all_server_welfare ~= nil then
        self._all_server_welfare:setVisible(false)
    end
end

function OpenServerActivity:initAllServerWelfareActivity()
    local root = self.roots[1]
    self._all_server_welfare = AllServerWelfareActivity:createCell()
    root:addChild(self._all_server_welfare)
end

function OpenServerActivity:showAllServerWelfareActivity()
    if self._all_server_welfare == nil then
        self:initAllServerWelfareActivity()
    end
    self._all_server_welfare:setVisible(true)
    if self._all_server_fund ~= nil then
        self._all_server_fund:setVisible(false)
    end
end

function OpenServerActivity:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    OpenServerActivity._self = self
    
    self:onInit()
end

function OpenServerActivity:unload()
    self:removeAllChildren(true)
    self._all_server_fund = nil
    self._all_server_welfare = nil
    self.loaded = false
    self.roots = {}
end

function OpenServerActivity:onEnterTransitionFinish()

end

function OpenServerActivity:onInit()
    local csbOpenServerActivity = csb.createNode("activity/wonderful/open_service_fund.csb")
    self:addChild(csbOpenServerActivity)

    local root = csbOpenServerActivity:getChildByName("root")
    table.insert(self.roots, root)

    local  SeyPressedActionEnabled = true 
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        SetPressedActionEnabled = false
    end
    -- 开服基金的按钮事件响应
    local fundButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_7"),       nil, 
    {
        terminal_name = "open_server_activity_manager",     
        next_terminal_name = "open_server_activity_servers_fund",     
        current_button_name = "Button_kf_7",
        but_image = "Image_kf_7",       
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity_fund_activity",
    _widget = fundButton,
    _invoke = nil,
    _interval = 0.5,})

    -- 全民福利的按钮事件响应
    local welfareButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_8"),       nil, 
    {
        terminal_name = "open_server_activity_manager",     
        next_terminal_name = "open_server_activity_servers_welfare",     
        current_button_name = "Button_kf_8",
        but_image = "Image_kf_8",       
        terminal_state = 0, 
        isPressedActionEnabled = SetPressedActionEnabled
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity_welfare_activity",
    _widget = welfareButton,
    _invoke = nil,
    _interval = 0.5,})

    -- 前往充值的按钮事件响应
    local rechargeButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_9"),       nil, 
    {
        terminal_name = "shortcut_open_recharge_window",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity_recharge",
    _widget = rechargeButton,
    _invoke = nil,
    _interval = 0.5,})

    state_machine.excute("open_server_activity_manager", 0, {
        _datas = {
            terminal_name = "open_server_activity_manager",     
            next_terminal_name = "open_server_activity_servers_fund",     
            current_button_name = "Button_kf_7",
            but_image = "Image_kf_7",       
            terminal_state = 0, 
            isPressedActionEnabled = true
        }
    })

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local Button_kfjj_close = ccui.Helper:seekWidgetByName(root,"Button_kfjj_close")
        fwin:addTouchEventListener(Button_kfjj_close,       nil, 
        {
            terminal_name = "open_server_activity_close",     
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)        
    end
end


function OpenServerActivity:onExit()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	   state_machine.remove("open_server_activity_close")
    end
end

function OpenServerActivity:init()
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        -- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        -- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        self:lazy() 
    end
end


function OpenServerActivity:createCell()
	local cell = OpenServerActivity:new()
	cell:registerOnNodeEvent(cell)
	return cell
end