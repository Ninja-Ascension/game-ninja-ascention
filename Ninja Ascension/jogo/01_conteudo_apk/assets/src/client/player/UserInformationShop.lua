-- ----------------------------------------------------------------------------------------------------
-- 说明：商城顶部用户信息
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
UserInformationShop = class("UserInformationShopClass", Window, true)
    
function UserInformationShop:ctor()
    self.super:ctor()
	self.roots = {}
	self.fight_capacity = 0
	self.endurance = 0
	self.max_endurance = 0
	self.user_silver = 0
	self.user_gold = 0
	self.user_name		= ""	--用户名
	self.vip_grade 		= 0					--VIP等级
	self.user_food = 0
	self.max_user_food = 0

	self._name = nil
	self._VIP = nil
	self._Text_11 = nil
	self._Text_12 = nil
	self._health = nil
	
    local function init_user_topinfo_shop_terminal()
		-- 用户信息显示
		local user_topinfo_shop_show_all_info_terminal = {
            _name = "user_topinfo_shop_show_all_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.player.PlayerInfomation")
				fwin:open(PlayerInfomation:new(),fwin._windows )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(user_topinfo_shop_show_all_info_terminal)
        state_machine.init()
    end
    
    init_user_topinfo_shop_terminal()
end

function UserInformationShop:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("utils/public_information_4.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)
	
	self.user_silver = _ED.user_info.user_silver
	self.user_gold = _ED.user_info.user_gold
	self.user_name	= _ED.user_info.user_name	--用户名
	self.vip_grade 	= _ED.vip_grade or 0					--VIP等级
	self.user_food = _ED.user_info.user_food
	self.max_user_food 	= _ED.user_info.max_user_food or 0	--体力上限
	
	-- local name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_91_name")
	-- local VIP = ccui.Helper:seekWidgetByName(self.roots[1], "AtlasLabel_1")
	local Text_11 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_112")
	local Text_12 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_122")
	
	-- self._name = name
	-- self._VIP = VIP
	self._Text_11 = Text_11
	self._Text_12 = Text_12
	self._health = ccui.Helper:seekWidgetByName(self.roots[1], "Text_zhanli")

	-- local shipType = 0
	-- for i, ship in pairs(_ED.user_ship) do
	-- 	if ship.ship_id ~= nil then
	-- 		local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
	-- 		if dms.atoi(shipData, ship_mould.captain_type) == 0 then
	-- 			shipType = ship.ship_type + 1
	-- 			name:setColor(cc.c3b(tipStringInfo_quality_color_Type[shipType][1],tipStringInfo_quality_color_Type[shipType][2],tipStringInfo_quality_color_Type[shipType][3]))
	-- 			break
	-- 		end
	-- 	end
	-- end
	
	-- if zstring.tonumber( self.user_silver) > 100000000 then
	-- 	Text_11:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if zstring.tonumber( self.user_silver)> 10000 then
		Text_11:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		Text_11:setString(self.user_silver)
	end

	-- if zstring.tonumber(self.user_gold) > 100000000 then
	-- 	Text_12:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if zstring.tonumber( self.user_gold)> 1000000 then
		Text_12:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		Text_12:setString(self.user_gold)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end

	local health = ccui.Helper:seekWidgetByName(self.roots[1], "Text_zhanli")
	if health ~= nil then 
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
			local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
			Label_power_left:setString(_ED.user_info.user_food)
			Label_power_right:setString(self.max_user_food)
			if tonumber(_ED.user_info.user_food) > tonumber(self.max_user_food) then
				Label_power_left:setColor(cc.c3b(0,255,0))
			else
				Label_power_left:setColor(cc.c3b(255,255,255))
			end
		else
			if zstring.tonumber( _ED.user_info.user_food) > 10000  then
				health:setString(math.floor(_ED.user_info.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
			else
				health:setString(_ED.user_info.user_food .. "/" ..self.max_user_food)
			end
		end
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		name:setString(self.user_name)
		VIP:setString(self.vip_grade)
		if ___is_open_leadname == true then
			name:setFontName("")
			name:setFontSize(name:getFontSize())
		end
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("user_topinfo_shop_show_all_info", 0, "user_topinfo_shop_show_all_info.'")]]}, nil, 0)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zuanshi_add"), nil, 
	    {
	        terminal_name = "activity_home_recharge_button", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuySilverCoins")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jinbi_add"), nil, 
	    {
	        terminal_name = "sm_buy_silver_coinsopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuyPhysical")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tili_add"), nil, 
	    {
	        terminal_name = "sm_buy_physicalopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	end
end

function UserInformationShop:onUpdate(dt)
	if self._health ~= nil then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
		end
		if self.user_food ~= _ED.user_info.user_food then
			self.user_food = _ED.user_info.user_food
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
				local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
				Label_power_left:setString(_ED.user_info.user_food)
				Label_power_right:setString(self.max_user_food)
				if tonumber(_ED.user_info.user_food) > tonumber(self.max_user_food) then
					Label_power_left:setColor(cc.c3b(0,255,0))
				else
					Label_power_left:setColor(cc.c3b(255,255,255))
				end
			else
				if zstring.tonumber( _ED.user_info.user_food) > 10000  then
					self._health:setString(math.floor(_ED.user_info.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
				else
					self._health:setString(_ED.user_info.user_food .. "/" ..self.max_user_food)
				end
			end
		end
	end

	if self.user_name ~= _ED.user_info.user_name then
		self.user_name = _ED.user_info.user_name
		if self._name ~= nil then
			self._name:setString(self.user_name)
		end
	end
	
	if self.vip_grade ~= _ED.vip_grade then
		self.vip_grade = _ED.vip_grade
		if self._VIP ~= nil then
			self._VIP:setString(self.vip_grade)
		end
	end
	
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		-- if zstring.tonumber( self.user_silver) > 100000000 then
		-- 	self._Text_11:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if zstring.tonumber( self.user_silver)> 10000 then
			self._Text_11:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._Text_11:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		-- if zstring.tonumber(self.user_gold) > 100000000 then
		-- 	self._Text_12:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if zstring.tonumber( self.user_gold)> 1000000 then
			self._Text_12:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._Text_12:setString(self.user_gold)
		end
	end
	
end

function UserInformationShop:onExit()
	state_machine.remove("user_topinfo_shop_show_all_info")
end