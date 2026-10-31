--------------------------------------------------------------------------------------------------------------
--  说明：军团商店主界面
--------------------------------------------------------------------------------------------------------------
UnionShop = class("UnionShopClass", Window)

--打开界面
local union_shop_open_terminal = {
	_name = "union_shop_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if  params ~= nil then
			local UnionShopWindow = fwin:find("UnionShopClass")
			if UnionShopWindow ~= nil and UnionShopWindow:isVisible() == true then
				return true
			end
			fwin:close(fwin:find("UnionShopClass"))
			-- state_machine.lock("union_shop_open", 0, "")
			fwin:open(UnionShop:new():init(params),fwin._view)
			if params._datas.terminal_name ~= nil and terminal.last_terminal_name ~= params._datas.terminal_name then
				state_machine.excute(params._datas.terminal_name, 0, params)
			end
			
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local union_shop_close_terminal = {
	_name = "union_shop_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local mcell = params._datas.cell
		for i, v in pairs(mcell.group) do
				 if v ~= nil then
					 fwin:close(v)
				end
		end
		fwin:close(fwin:find("UnionShopClass"))
		state_machine.excute("union_refresh_info", 0, "")
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if fwin:find("UnionTigerGateClass") == nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
			        app.load("client.l_digital.union.UnionTigerGate")
			    else
					app.load("client.union.UnionTigerGate")
				end
				state_machine.excute("Union_open", 0, "")
			end
		else
			if fwin:find("UnionClass") == nil then
				app.load("client.union.Union")
				state_machine.excute("Union_open", 0, "")
			end
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_shop_open_terminal)
state_machine.add(union_shop_close_terminal)
state_machine.init()

function UnionShop:ctor()
	self.super:ctor()
	self.roots = {}
	self.group = {
		_prop = nil,
		_limit = nil,
		_reward = nil,
		_fashion = nil
	}
	self.currentSelectPanel = 0
	
	 -- Initialize union shop machine.
    local function init_union_shop_terminal()
		
		-- 隐藏界面
        local union_shop_hide_event_terminal = {
            _name = "union_shop_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_shop_show_event_terminal = {
            _name = "union_shop_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_shop_refresh_info_terminal = {
            _name = "union_shop_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--切换列表
		local union_shop_select_page_terminal = {
            _name = "union_shop_select_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if terminal.last_terminal_name ~= params._datas.next_terminal_name then
					-- hide shop child window
            		for i, v in pairs(instance.group) do
						if v ~= nil then
							v:setVisible(false)
						end
					end
                    terminal.last_terminal_name = params._datas.next_terminal_name
            		state_machine.excute(params._datas.next_terminal_name, 0, params)
				end
				
				-- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
					terminal.select_button:setTouchEnabled(true)
				end
				terminal.page_name = params._datas.but_image
				instance:onUpdateimage(terminal.page_name)
				if terminal.select_button == nil and params._datas.current_button_name ~= nil then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				else
					terminal.select_button = params
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
		-- 打开道具列表
		local union_shop_to_prop_page_terminal = {
            _name = "union_shop_to_prop_page",
            _init = function (terminal)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        app.load("client.l_digital.union.shop.UnionShopPropPage")
			    else
					app.load("client.union.shop.UnionShopPropPage")
				end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.currentSelectPanel = 1
				if instance.group._prop == nil then
					instance.group._prop = UnionShopPropPage:new()
					fwin:open(instance.group._prop:init(), fwin._view)
					-- fwin:open(UnionShopPropPage:new():init(params),fwin._view)
					-- state_machine.excute("union_shop_prop_page_open", 0, "")
				end
				instance.group._prop:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--打开时装列表
		local union_shop_to_fashion_page_terminal = {
            _name = "union_shop_to_fashion_page",
            _init = function (terminal)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        app.load("client.l_digital.union.shop.UnionShopFashionPage")
			    else
	          	  	app.load("client.union.shop.UnionShopFashionPage")
	          	end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		instance.currentSelectPanel = 4
				if instance.group._fashion == nil then
					instance.group._fashion = UnionShopFashionPage:new()
					fwin:open(instance.group._fashion:init(), fwin._view)
				end
				instance.group._fashion:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--打开限时列表
		local union_shop_to_time_limit_page_terminal = {
            _name = "union_shop_to_time_limit_page",
            _init = function (terminal)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        app.load("client.l_digital.union.shop.UnionShopTimeLimitPage")
			    else
            		app.load("client.union.shop.UnionShopTimeLimitPage")
            	end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.currentSelectPanel = 2
				if instance.group._limit == nil then
					instance.group._limit = UnionShopTimeLimitPage:new()
					fwin:open(instance.group._limit:init(), fwin._view)
					_ED.union_push_notification_info_limit_refresh = false
					_ED.union_push_notification_time = os.time()
				end
				instance.group._limit:setVisible(true)
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--打开奖励列表
		local union_shop_to_reward_page_terminal = {
            _name = "union_shop_to_reward_page",
            _init = function (terminal)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        app.load("client.l_digital.union.shop.UnionShopRewardPage")
			    else
					app.load("client.union.shop.UnionShopRewardPage")
				end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.currentSelectPanel = 3
				if instance.group._reward == nil then
					instance.group._reward = UnionShopRewardPage:new()
					fwin:open(instance.group._reward:init(), fwin._view)
				end
				instance.group._reward:setVisible(true)
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_shop_open_terminal)
		state_machine.add(union_shop_close_terminal)
		state_machine.add(union_shop_hide_event_terminal)
		state_machine.add(union_shop_show_event_terminal)
		state_machine.add(union_shop_refresh_info_terminal)
		state_machine.add(union_shop_select_page_terminal)
		state_machine.add(union_shop_to_prop_page_terminal)
		state_machine.add(union_shop_to_fashion_page_terminal)
		state_machine.add(union_shop_to_time_limit_page_terminal)
		state_machine.add(union_shop_to_reward_page_terminal)
        state_machine.init()
    end
    
    -- call func init union shop  machine.
    init_union_shop_terminal()

end

function UnionShop:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionShop:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end
function UnionShop:onUpdateimage(index)

	local root = self.roots[1]
	 ccui.Helper:seekWidgetByName(root, "Image_15"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_15_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_15_2"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_shizhuang"):setVisible(false)
	if index == nil then
		ccui.Helper:seekWidgetByName(root, "Image_15"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, index):setVisible(true)
	end	
	
end

function UnionShop:onUpdate(dt)
	if _ED.union.user_union_info ~= nil and _ED.union.user_union_info.rest_contribution~= nil then
		if UnionShop.rest_contribution == nil then
			UnionShop.rest_contribution = _ED.union.user_union_info.rest_contribution
		end
		if	UnionShop.rest_contribution ~= nil and _ED.union.user_union_info.rest_contribution ~= UnionShop.rest_contribution then
			UnionShop.rest_contribution = _ED.union.user_union_info.rest_contribution
			local root = self.roots[1]
			if root == nil then
				return
			end
			ccui.Helper:seekWidgetByName(root, "Text_31"):setString(_ED.union.user_union_info.rest_contribution)-- 军团贡献
		end
	end	
end

function UnionShop:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_31"):setString(_ED.union.user_union_info.rest_contribution)-- 军团贡献
end

function UnionShop:onInit()
	-- legion_shop
	local csbUnion = csb.createNode("legion/legion_shop.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)
	self:updateDraw()

	---Button_32 道具
	-- Button_33 限时
	-- Button_34 奖励
	local shopTime = ccui.Helper:seekWidgetByName(root, "Button_33")
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_shop_time",
	_widget = shopTime,
	_invoke = nil,
	_interval = 0.5,})

	local shopReward = ccui.Helper:seekWidgetByName(root, "Button_34")
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_shop_reward",
	_widget = shopReward,
	_invoke = nil,
	_interval = 0.5,})
	
	if __lua_project_id ~= __lua_project_digimon_adventure 
		and __lua_project_id ~= __lua_project_pokemon
		and __lua_project_id ~= __lua_project_rouge 
		and __lua_project_id ~= __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		--推送逻辑中需要读取一个配置表,数码宝贝中这个配置表少数据会导致报错,暂时先屏蔽
		--	local data = dms.searchs(dms["union_shop_mould"], union_shop_mould.shop_page, 1) 没有数据等于1的
		local shopShizhuang = ccui.Helper:seekWidgetByName(root, "Button_shizhuang")
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_shop_fashion",
		_widget = shopShizhuang,
		_invoke = nil,
		_interval = 0.5,})
	end
	
	-- 
	local Button_shizhuang = ccui.Helper:seekWidgetByName(root, "Button_shizhuang")
	if Button_shizhuang ~= nil and Button_shizhuang:isVisible() == true then 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shizhuang"), 		nil, 
		{
			terminal_name = "union_shop_select_page", 	
			next_terminal_name = "union_shop_to_fashion_page", 	
			current_button_name = "Button_shizhuang", 	
			but_image = "Image_shizhuang", 	
			cell = self,
			terminal_state = 0, 
			isPressedActionEnabled = false
		}, 
		nil, 0)
		--推送逻辑中需要读取一个配置表,数码宝贝中这个配置表少数据会导致报错,暂时先屏蔽
		--	local data = dms.searchs(dms["union_shop_mould"], union_shop_mould.shop_page, 1) 没有数据等于1的
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_shop_fashion",
		_widget = Button_shizhuang,
		_invoke = nil,
		_interval = 0.5,})
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_32"), 		nil, 
	{
		terminal_name = "union_shop_select_page", 	
		next_terminal_name = "union_shop_to_prop_page", 	
		current_button_name = "Button_32", 	
		but_image = "Image_15", 	
		cell = self,
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_33"), 		nil, 
	{
		terminal_name = "union_shop_select_page", 	
		next_terminal_name = "union_shop_to_time_limit_page", 	
		current_button_name = "Button_33", 	
		but_image = "Image_15_1", 	
		cell = self,
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_34"), 		nil, 
	{
		terminal_name = "union_shop_select_page", 	
		next_terminal_name = "union_shop_to_reward_page", 	
		current_button_name = "Button_34", 	
		but_image = "Image_15_2", 	
		cell = self,
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_31"), 		nil, 
	{
		terminal_name = "union_shop_close", 
		cell = self,	 	 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
end

function UnionShop:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:close(fwin:find("UserTopInfoAClass"))
	    app.load("client.player.UserTopInfoA")
	    fwin:open(UserTopInfoA:new(), fwin._view)
	end
end

function UnionShop:init(params)
	self:onInit()
	return self
end

function UnionShop:onExit()
	-- state_machine.remove("union_shop_open")
	-- state_machine.remove("union_shop_close")
	state_machine.remove("union_shop_hide_event")
	state_machine.remove("union_shop_show_event")
	state_machine.remove("union_shop_refresh_info")
	state_machine.remove("union_shop_select_page")
	state_machine.remove("union_shop_to_prop_page")
	state_machine.remove("union_shop_to_fashion_page")
	state_machine.remove("union_shop_to_time_limit_page")
	state_machine.remove("union_shop_to_reward_page")
end