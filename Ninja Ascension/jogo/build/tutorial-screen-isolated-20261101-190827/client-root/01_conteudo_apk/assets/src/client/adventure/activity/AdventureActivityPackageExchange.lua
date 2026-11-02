----------------------------------------------------------------------------------------------------
-- 说明：礼包兑换
----------------------------------------------------------------------------------------------------
AdventureActivityPackageExchange = class("AdventureActivityPackageExchangeClass", Window)
AdventureActivityPackageExchange.__size = nil

function AdventureActivityPackageExchange:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_activity_package_exchange_terminal()
		--前往 验证礼品码
		local adventure_activity_package_exchange_button_terminal = {
            _name = "adventure_activity_package_exchange_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_2")
				text:didNotSelectSelf()
				local codes = text:getString()
				
				if codes == nil or codes == "" or string.len(codes) == 0 then
					TipDlg.drawTextDailog(_string_piece_info[257])
					return
				end
				
				codes = zstring.exchangeTo(codes)
				
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							response.node:setString("")
						end
						app.load("client.adventure.reward.AdventureTipReward")
						local reward = getSceneReward(7)
						if reward ~= nil then 
							fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
						end
					end
				end

				protocol_command.draw_cdkey_reward.param_list = codes.."\r\n"..app.configJson.url
				NetworkManager:register(protocol_command.draw_cdkey_reward.code, nil, nil, nil, text, responseInitCallback, true, nil)
				
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_activity_package_exchange_button_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_activity_package_exchange_terminal()
end

function AdventureActivityPackageExchange:updateDraw()
	local root = self.roots[1]
end

function AdventureActivityPackageExchange:onInit()
	local root = cacher.createUIRef("list/list_code.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_2")
	draw:addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_1"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
	{
		terminal_name = "adventure_activity_package_exchange_button",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	-- Get size for root node.
	if AdventureActivityPackageExchange.__size == nil then
		local size = root:getContentSize()
		AdventureActivityPackageExchange.__size = size
	end
	
	self:updateDraw()
end

function AdventureActivityPackageExchange:onExit()
	cacher.freeRef("list/list_code.csb", self.roots[1])
end

function AdventureActivityPackageExchange:init()
	self:onInit()
	
	self:setContentSize(AdventureActivityPackageExchange.__size)
	return self
end

function AdventureActivityPackageExchange:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureActivityPackageExchange:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_code.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureActivityPackageExchange:createCell()
	local cell = AdventureActivityPackageExchange:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

