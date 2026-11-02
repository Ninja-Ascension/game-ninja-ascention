-----------------------------
-- 天赋重置天赋点界面
-----------------------------
SmTalentResetPoint = class("SmTalentResetPointClass", Window)

--打开界面
local sm_talent_reset_point_open_terminal = {
	_name = "sm_talent_reset_point_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTalentResetPointClass") == nil then
			fwin:open(SmTalentResetPoint:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_talent_reset_point_close_terminal = {
	_name = "sm_talent_reset_point_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTalentResetPointClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_reset_point_open_terminal)
state_machine.add(sm_talent_reset_point_close_terminal)
state_machine.init()

function SmTalentResetPoint:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    local function init_sm_talent_reset_point_terminal()
		local sm_talent_reset_point_request_terminal = {
            _name = "sm_talent_reset_point_request",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function requestCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd, fwin._ui)
                            state_machine.excute("sm_talent_main_window_updata",0,"sm_talent_main_window_updata.")
                            state_machine.excute("sm_talent_page_one_update",0,"sm_talent_page_one_update.")
                            state_machine.excute("sm_talent_page_two_update",0,"sm_talent_page_two_update.")
                            state_machine.excute("sm_talent_page_three_update",0,"sm_talent_page_three_update.")
                            state_machine.excute("sm_talent_page_four_update",0,"sm_talent_page_four_update.")
                            state_machine.excute("sm_talent_reset_point_close",0,"sm_talent_reset_point_close.")
                        end
                    end
                end
                NetworkManager:register(protocol_command.ship_talent_reset.code, nil, nil, nil, instance, requestCallBack, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_talent_reset_point_request_terminal)
        state_machine.init()
    end
    init_sm_talent_reset_point_terminal()
end

function SmTalentResetPoint:onUpdateDraw()
    local root = self.roots[1]
    local Text_tip_2 = ccui.Helper:seekWidgetByName(root,"Text_tip_2")
    local str = Text_tip_2:getString()
    local allTalentPoint = 0
    for i ,v in pairs(_ED.digital_talent_page_use_point_array) do
        allTalentPoint = allTalentPoint + tonumber(v)
    end
    Text_tip_2:setString(string.format(str , ""..allTalentPoint))
end

function SmTalentResetPoint:init()
	self:onInit()
    return self
end

function SmTalentResetPoint:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_talent_reset.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    local action = csb.createTimeline("cultivate/cultivate_talent_reset.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_talent_reset_point_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_5"), nil, 
    {
        terminal_name = "sm_talent_reset_point_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_talent_reset_point_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_talent_reset_point_request", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    ccui.Helper:seekWidgetByName(root,"Image_37"):setTouchEnabled(true)
	self:onUpdateDraw()

end

function SmTalentResetPoint:onEnterTransitionFinish()
    
end


function SmTalentResetPoint:onExit()
	state_machine.remove("sm_talent_reset_point_request")
end

