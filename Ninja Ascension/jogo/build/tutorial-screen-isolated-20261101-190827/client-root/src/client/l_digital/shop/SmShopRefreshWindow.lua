-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商店刷新界面
-------------------------------------------------------------------------------------------------------

SmShopRefreshWindow = class("SmShopRefreshWindowClass", Window)

local sm_shop_refresh_window_open_terminal = {
    _name = "sm_shop_refresh_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmShopRefreshWindowWindow = fwin:find("SmShopRefreshWindowClass")
    	if SmShopRefreshWindowWindow ~= nil then
    		SmShopRefreshWindowWindow:setVisible(true)
    		return
    	end
    	local page = SmShopRefreshWindow:new():init(params)
    	fwin:open(page , fwin._ui)
		return page
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_shop_refresh_window_open_terminal)
state_machine.init()

function SmShopRefreshWindow:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.index = 0
	self.cost_number = 0
	self.last_times = 0
	local function init_sm_shop_refresh_window_terminal()
		--
		local sm_shop_refresh_window_update_shop_terminal = {
            _name = "sm_shop_refresh_window_update_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.index == 6 then
            		local numbers = dms.element(dms["base_consume"], 67)
					local nCount = dms.atoi(numbers, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
					alreadyRefresh = nCount - tonumber(_ED.secret_shop_info.refresh_count)
					if alreadyRefresh <= 0 then
						TipDlg.drawTextDailog(_new_interface_text[99])
	            		return
					end
            	else
	            	if self.last_times <= 0 then
	            		TipDlg.drawTextDailog(_new_interface_text[99])
	            		return
	            	end
	            	if self.cost_number > tonumber(_ED.user_info.user_gold) then
	            		TipDlg.drawTextDailog(_string_piece_info[74])
	            		return
	            	end
	            end

            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("sm_shop_tab_updateDraw",0,"")
						state_machine.excute("secret_shop_update_draw", 0, 0)
						state_machine.excute("sm_shop_refresh_window_close",0,"")
					end
				end
				local _type = 0
				if instance.index == 2 then
	            	NetworkManager:register(protocol_command.secret_shop_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
				elseif instance.index == 3 then
					_type = 2
	            	protocol_command.shop_request_product_refresh.param_list = "".._type
					NetworkManager:register(protocol_command.shop_request_product_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
				elseif instance.index == 4 then
					_type = 3
	            	protocol_command.shop_request_product_refresh.param_list = "".._type
					NetworkManager:register(protocol_command.shop_request_product_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
				elseif instance.index == 6 then
					protocol_command.mystical_shop_refresh.param_list = ""
                	NetworkManager:register(protocol_command.mystical_shop_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
				else
					_type = 4
	            	protocol_command.shop_request_product_refresh.param_list = "".._type
					NetworkManager:register(protocol_command.shop_request_product_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_refresh_window_close_terminal = {
            _name = "sm_shop_refresh_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_shop_refresh_window_close_terminal)
        state_machine.add(sm_shop_refresh_window_update_shop_terminal)
        state_machine.init()
	end
	init_sm_shop_refresh_window_terminal()
end

function SmShopRefreshWindow:onUpdateDraw()
	local root = self.roots[1]
	local Text_zuanshi = ccui.Helper:seekWidgetByName(root, "Text_zuanshi")
	local Text_tips_2 = ccui.Helper:seekWidgetByName(root, "Text_tips_2")
	local alreadyRefresh = 0
	if self.index == 2 then
		alreadyRefresh = tonumber(_ED.secret_shop_init_info.refresh_count)
	elseif self.index == 3 then
		alreadyRefresh = tonumber(_ED.arena_shop_refreash_times)
	elseif self.index == 4 then
		alreadyRefresh = tonumber(_ED.glories_shop_refreash_times)
	elseif self.index == 5 then
		alreadyRefresh = tonumber(_ED.union.union_shop_info.treasure.refresh_count)
	elseif self.index == 6 then
		local numbers = dms.element(dms["base_consume"], 67)
		local nCount = dms.atoi(numbers, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
		alreadyRefresh = nCount - tonumber(_ED.secret_shop_info.refresh_count)
	end
	if self.index == 6 then
		Text_tips_2:setString(string.format(_new_interface_text[98] , alreadyRefresh))
		Text_zuanshi:setString(100)
	else
		local max_times = dms.int(dms["shop_config"], 2, shop_config.param)
		local last_times = max_times - alreadyRefresh
		last_times = math.max(0,last_times)
		self.last_times = last_times
		Text_tips_2:setString(string.format(_new_interface_text[98] , last_times))
		local cost_array = zstring.split(dms.string(dms["shop_config"], 3, shop_config.param) , ",")
		self.cost_number = 0
		if (alreadyRefresh + 1) < #cost_array then
			self.cost_number = tonumber(cost_array[alreadyRefresh + 1])
		else
			self.cost_number = tonumber(cost_array[#cost_array])
		end
		Text_zuanshi:setString(self.cost_number)
	end
end

function SmShopRefreshWindow:onInit()
	local csbSmShopRefreshWindow = csb.createNode("shop/sm_shop_refresh_window.csb")
	local root = csbSmShopRefreshWindow:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopRefreshWindow)

    local action = csb.createTimeline("shop/sm_shop_refresh_window.csb")
    table.insert(self.actions, action)
    csbSmShopRefreshWindow:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil, 
	{
		terminal_name = "sm_shop_refresh_window_update_shop", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "sm_shop_refresh_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_5"), nil, 
	{
		terminal_name = "sm_shop_refresh_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
	
	self:onUpdateDraw()
end

function SmShopRefreshWindow:init(params)
	self.index = tonumber(params)
	self:onInit()
	return self
end

function SmShopRefreshWindow:onExit()
	state_machine.remove("sm_shop_refresh_window_update_shop")
	state_machine.remove("sm_shop_refresh_window_close")
end

