-----------------------------
--礼品兑换
-----------------------------
RedAlertTimeExchangeReward = class("RedAlertTimeExchangeRewardClass", Window)

local red_alert_time_exchange_reward_window_open_terminal = {
    _name = "red_alert_time_exchange_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeExchangeRewardClass") then
            local panel = RedAlertTimeExchangeReward:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_exchange_reward_window_open_terminal)
state_machine.init()

function RedAlertTimeExchangeReward:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file

    -- Initialize red_alert_time_exchange_reward state machine.
    local function init_red_alert_time_exchange_reward_terminal()
	
        --前往 验证礼品码
        local red_alert_time_exchange_reward_activity_codes_terminal = {
          _name = "red_alert_time_exchange_reward_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_gift_exchange_n")
                text:didNotSelectSelf()
                local codes = text:getString()
                
                if codes == nil or codes == "" or string.len(codes) == 0 then
                  TipDlg.drawTextDailog(_wonderful_string[1])
                  return
                end
                
                codes = zstring.exchangeTo(codes)
                
                local function responseInitCallback(response)
                  if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    -- text:setString("")
                    -- instance:showReward()
                    if response.node ~= nil and response.node.roots ~= nil then
                      local text = ccui.Helper:seekWidgetByName(response.node.roots[1], "TextField_gift_exchange_n")
                      text:setString("")
                      -- state_machine.excute("reward_obtain_window_open",0,{67})
                      -- response.node:showReward()
					  checkRewardObtainDraw()
                    end
                  end
                end
                protocol_command.draw_cdkey_reward.param_list = codes.."\r\n"..app.configJson.url
                NetworkManager:register(protocol_command.draw_cdkey_reward.code, nil, nil, nil, instance, responseInitCallback, false, nil)
              
                return true
            end,
            _terminal = nil,
            _terminals = nil
            }
		
		local copy_paste_text_start_terminal = {
          _name = "copy_paste_text_start",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				handlePlatformRequest(0, CC_COPY_PASTE_TEXT_START, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
          }
		  
		local copy_paste_text_terminal = {
          _name = "copy_paste_text",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_gift_exchange_n")
                text:didNotSelectSelf()
				if params == nil or params == "" then
				else
					text:setString(params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
          }
			
        
        state_machine.add(red_alert_time_exchange_reward_activity_codes_terminal)
        state_machine.add(copy_paste_text_start_terminal)
        state_machine.add(copy_paste_text_terminal)
        state_machine.init()
    end
    
    -- call func init red_alert_time_exchange_reward state machine.
    init_red_alert_time_exchange_reward_terminal()
end

function RedAlertTimeExchangeReward:onUpdateDraw()
    local root = self.roots[1]
    
end

function RedAlertTimeExchangeReward:onEnterTransitionFinish()

end

function RedAlertTimeExchangeReward:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_gift_exchange)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    local text = ccui.Helper:seekWidgetByName(root, "TextField_gift_exchange_n")
    text:setString("")
    draw:addEditBoxEx(text, _wonderful_string[2], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_gift_exchange"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
    --兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gift_exchange"), nil, 
    {
        terminal_name = "red_alert_time_exchange_reward_activity_codes", 
        terminal_state = 0,
        codes = text:getString(),
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	local Button_paste = ccui.Helper:seekWidgetByName(root, "Button_paste")
	--粘贴
	if Button_paste~= nil then
		if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPHONE or cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_IPAD then
			Button_paste:setVisible(true)
		end
		fwin:addTouchEventListener(Button_paste, nil, 
		{
			terminal_name = "copy_paste_text_start", 
			terminal_state = 0,
			codes = text:getString(),
			touch_scale = true,
			touch_scale_xy = 0.95, 
		}, nil, 1)
	end
	self:onUpdateDraw()
end

function RedAlertTimeExchangeReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	  self:onInit()
    return self
end

function RedAlertTimeExchangeReward:onExit()
    state_machine.remove("red_alert_time_exchange_reward_activity_codes")
end
