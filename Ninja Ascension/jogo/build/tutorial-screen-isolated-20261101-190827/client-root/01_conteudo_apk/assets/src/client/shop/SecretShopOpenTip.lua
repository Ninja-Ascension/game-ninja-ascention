-- ----------------------------------------------------------------------------------------------------
-- 说明：神秘商店开启提示
-------------------------------------------------------------------------------------------------------
SecretShopOpenTip = class("SecretShopOpenTipClass", Window)

local secret_shop_open_tip_window_open_terminal = {
    _name = "secret_shop_open_tip_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if true == _ED.secret_shop_open then
            if nil == fwin:find("SecretShopOpenTipClass") then
                if nil == fwin:find("FightClass") then
                    fwin:open(SecretShopOpenTip:new():init(params), fwin._dialog)
                end
            else
                _ED.secret_shop_open = false
            end
    	end
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

local secret_shop_open_tip_window_close_terminal = {
    _name = "secret_shop_open_tip_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SecretShopOpenTipClass"))
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(secret_shop_open_tip_window_open_terminal)
state_machine.add(secret_shop_open_tip_window_close_terminal)
state_machine.init()

function SecretShopOpenTip:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    self._interval = 0
    self._duration = 3

	-- load lua files.
	
	-- Initialize secret shop open tip page state machine.
    local function init_secret_shop_open_tip_terminal()
        -- 窗口动画
        local secret_shop_open_tip_window_animation_open_terminal = {
            _name = "secret_shop_open_tip_window_animation_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local loop = false
                if true == params or 1 == params then
                    loop = true
                end
                instance.actions[1]:play("animation_open", loop)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(secret_shop_open_tip_window_animation_open_terminal)
        state_machine.init()
    end
    
    -- call func init secret shop open tip state machine.
    init_secret_shop_open_tip_terminal()
end

function SecretShopOpenTip:onUpdate(dt) 
    if nil ~= self._interval then
        self._interval = self._interval + dt
        if self._interval > self._duration then
            self._interval = nil
            fwin:addService({
                callback = function ( params )
                    state_machine.excute("secret_shop_open_tip_window_close", 0, 0)
                end,
                delay = 0,
                params = self
            })
        end
    end
end

function SecretShopOpenTip:onEnterTransitionFinish()
	local csbNode = csb.createNode("shop/sm_mysterious_shop_0.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 窗口动画
    local action = csb.createTimeline("shop/sm_mysterious_shop_0.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        
        local str = frame:getEvent()
        if str == "open" then
            state_machine.unlock("secret_shop_open_tip_window_close")
        elseif str == "close" then

        end
    end)

    state_machine.lock("secret_shop_open_tip_window_close")
 --    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_3"), 	nil, 
	-- {
	-- 	terminal_name = "secret_shop_open_tip_window_close",
	-- 	terminal_state = 0,
	-- 	isPressedActionEnabled = true
	-- }, 
	-- nil, 0)

    state_machine.excute("secret_shop_open_tip_window_animation_open", 0, false)
end

function SecretShopOpenTip:init(params)
    _ED.secret_shop_open = false

    state_machine.unlock("secret_shop_open_tip_window_close")
	return self
end

function SecretShopOpenTip:onExit()
    state_machine.remove("secret_shop_open_tip_window_animation_open")
end

function SecretShopOpenTip:destroy( window )

end