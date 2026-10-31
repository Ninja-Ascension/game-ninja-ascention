-----------------------------
--礼品兑换
-----------------------------
ExchangeReward = class("ExchangeRewardClass", Window)

local exchange_reward_window_open_terminal = {
    _name = "exchange_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("ExchangeRewardClass") then
            local panel = ExchangeReward:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exchange_reward_window_open_terminal)
state_machine.init()

function ExchangeReward:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file

    -- Initialize exchange_reward state machine.
    local function init_exchange_reward_terminal()
	
        --前往 验证礼品码
        local exchange_reward_activity_codes_terminal = {
          _name = "exchange_reward_activity_codes",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_input_inner")
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
                      local text = ccui.Helper:seekWidgetByName(response.node.roots[1], "TextField_input_inner")
                      text:setString("")
                      state_machine.excute("reward_obtain_window_open",0,{67})
                      -- response.node:showReward()
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
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_input_inner")
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
			
        
        state_machine.add(exchange_reward_activity_codes_terminal)
        state_machine.add(copy_paste_text_start_terminal)
        state_machine.add(copy_paste_text_terminal)
        state_machine.init()
    end
    
    -- call func init exchange_reward state machine.
    init_exchange_reward_terminal()
end

-- function ExchangeReward:showReward()
  
--   local rewardInfo = {
--     show_reward_item_count = 0,
--     show_reward_list = {}
--   }
  
--   function addItem (prop_item, prop_type, item_value)
--       local item = {
--         prop_item = prop_item,
--         prop_type = prop_type,
--         item_value = item_value,
--       }
      
--       table.insert(rewardInfo.show_reward_list, item)
--   end
  
  
--   local activity = _ED.active_activity[16]
--   local activityInfo = activity.activity_Info[1]

--   local silver = zstring.tonumber(activityInfo.activityInfo_silver)
--   local gold = zstring.tonumber(activityInfo.activityInfo_gold)
--   local food = zstring.tonumber(activityInfo.activityInfo_food)
--   if silver > 0 then
--     addItem(-1,1,silver)
--   end
--   if gold > 0 then
--     addItem(-1,2,gold)
--   end
--   if food > 0 then
--     addItem(-1,12,food)
--   end
  
--   for i = 1 , activityInfo.activityInfo_prop_count do
--       local propInfo = activityInfo.activityInfo_prop_info[i]
--       addItem(propInfo.propMould, 6, propInfo.propMouldCount)
--   end

--   for i = 1 , activityInfo.activityInfo_equip_count do
--       local equipInfo = activityInfo.activityInfo_equip_info[i]
--       addItem(equipInfo.equipMould, 7, equipInfo.equipMouldCount)
--   end

--   rewardInfo.show_reward_item_count = table.getn(rewardInfo.show_reward_list)

--   state_machine.excute("reward_obtain_window_open",0,{nil,rewardInfo})

-- end

function ExchangeReward:onUpdateDraw()
    local root = self.roots[1]
    
end

function ExchangeReward:onEnterTransitionFinish()

end

function ExchangeReward:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.exchange_reward)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    local text = ccui.Helper:seekWidgetByName(root, "TextField_input_inner")
    text:setString("")
    draw:addEditBox(text, _wonderful_string[2], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_sure"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
    --兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sure"), nil, 
    {
        terminal_name = "exchange_reward_activity_codes", 
        terminal_state = 0,
        codes = text:getString(),
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
	
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
		}, nil, 0)
	end
	self:onUpdateDraw()
end

function ExchangeReward:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	  self:onInit()
    return self
end

function ExchangeReward:onExit()
    state_machine.remove("exchange_reward_activity_codes")
end
