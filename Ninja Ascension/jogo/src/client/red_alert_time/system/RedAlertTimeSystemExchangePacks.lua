-- ----------------------------------------------------------------------------------------------------
-- 说明：系统礼包兑换
-------------------------------------------------------------------------------------------------------
RedAlertTimeSystemExchangePacks = class("RedAlertTimeSystemExchangePacksClass", Window)

local red_alert_time_system_exchange_packs_open_terminal = {
    _name = "red_alert_time_system_exchange_packs_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemExchangePacksClass")
        if nil == _homeWindow then
    		fwin:open(RedAlertTimeSystemExchangePacks:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_system_exchange_packs_close_terminal = {
    _name = "red_alert_time_system_exchange_packs_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemExchangePacksClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("RedAlertTimeSystemExchangePacksClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_system_exchange_packs_open_terminal)
state_machine.add(red_alert_time_system_exchange_packs_close_terminal)
state_machine.init()
    
function RedAlertTimeSystemExchangePacks:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_object = nil
	self.m_Listview = nil

	local function init_red_alert_time_system_exchange_packs_terminal()
		
		--前往 验证礼品码
		local red_alert_time_system_exchange_button_terminal = {
            _name = "red_alert_time_system_exchange_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_gift_exchange")
				text:didNotSelectSelf()
				local codes = text:getString()
				
				if codes == nil or codes == "" or string.len(codes) == 0 then
					TipDlg.drawTextDailog(_string_piece_info[257])
					return
				end
				
				codes = zstring.exchangeTo(codes)
				
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
    						local text = ccui.Helper:seekWidgetByName(response.node.roots[1], "TextField_gift_exchange")
    						text:setString("")
                        end
						-- state_machine.excute("reward_obtain_window_open",0,{67})
                        checkRewardObtainDraw()
					end
				end

				protocol_command.draw_cdkey_reward.param_list = codes.."\r\n"..app.configJson.url
				NetworkManager:register(protocol_command.draw_cdkey_reward.code, nil, nil, nil, instance, responseInitCallback, true, nil)
				
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_system_exchange_button_terminal)
	
		state_machine.init()
	end
	
	init_red_alert_time_system_exchange_packs_terminal()
end

function RedAlertTimeSystemExchangePacks:init()
    self:onInit()
    return self
end

function RedAlertTimeSystemExchangePacks:onUpdateDraw()
	local root = self.roots[1]

end

function RedAlertTimeSystemExchangePacks:onInit()
    local csbRedAlertTimeSystemExchangePacks = csb.createNode(config_csb.system.red_alert_time_exchange_packs)
    local root = csbRedAlertTimeSystemExchangePacks:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRedAlertTimeSystemExchangePacks)
	
	
	local TextField_gift_exchange = ccui.Helper:seekWidgetByName(root, "TextField_gift_exchange")
	
    draw:addEditBoxEx(TextField_gift_exchange, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sent"), 40, cc.KEYBOARD_RETURNTYPE_DONE)   
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gift_exchange_close"), nil, 
    {
        terminal_name = "red_alert_time_system_exchange_packs_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_system_exchange_packs_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gift_exchange_sure"),       nil, 
	{
		terminal_name = "red_alert_time_system_exchange_button",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function RedAlertTimeSystemExchangePacks:onExit()
	
end