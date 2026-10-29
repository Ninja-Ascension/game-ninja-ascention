-- ----------------------------------------------------------------------------------------------------
-- 说明：仓库顶部用户信息
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
UserTopInfoA = class("UserTopInfoAClass", Window, true)
    
function UserTopInfoA:ctor()
    self.super:ctor()
	self.roots = {}
	self.fight_capacity = 0
	self.user_food 		= 0			--当前体力
	self.max_user_food 	= 0	--体力上限
	self.endurance = 0
	self.max_endurance = 0
	self.user_silver = 0
	self.user_gold = 0

	self._Text_9 = nil
	self._Text_10 = nil
	self._Text_11 = nil
	self._Text_12 = nil
	
    local function init_user_topinfo_a_terminal()
		-- 用户信息显示
		local user_topinfo_a_show_all_info_terminal = {
            _name = "user_topinfo_a_show_all_info",
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
		state_machine.add(user_topinfo_a_show_all_info_terminal)
        state_machine.init()
    end
    
    init_user_topinfo_a_terminal()
end

function UserTopInfoA:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("utils/public_information_1.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)
	
	self.user_food 		= _ED.user_info.user_food or 0			--当前体力
	self.max_user_food 	= _ED.user_info.max_user_food or 0	--体力上限
	self.endurance = _ED.user_info.endurance
	self.max_endurance = _ED.user_info.max_endurance
	self.user_silver = _ED.user_info.user_silver
	self.user_gold = _ED.user_info.user_gold
	
	local Text_9 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_9")
	local Text_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_10")
	local Text_11 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_11")
	local Text_12 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_12")

	self._Text_9 = Text_9
	self._Text_10 = Text_10
	self._Text_11 = Text_11
	self._Text_12 = Text_12

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
		local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
		Label_power_left:setString(self.user_food)
		Label_power_right:setString(self.max_user_food)
		if tonumber(self.user_food) > tonumber(self.max_user_food) then
			Label_power_left:setColor(cc.c3b(0,255,0))
		else
			Label_power_left:setColor(cc.c3b(255,255,255))
		end
	else
		if tonumber( self.user_food ) > 10000  then
			Text_9:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
		else
			Text_9:setString(self.user_food  .. "/" ..self.max_user_food)
		end
	end

	if Text_10 ~= nil then
		if tonumber( self.endurance) > 10000  or tonumber( self.max_endurance) > 10000 then
			Text_10:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
		else
			Text_10:setString(self.endurance.."/"..self.max_endurance)
		end
	end
	-- if tonumber( self.user_silver) > 100000000 then
	-- 	Text_11:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_silver)> 10000 then
		Text_11:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		Text_11:setString(self.user_silver)
	end

	-- if tonumber(self.user_gold) > 100000000 then
	-- 	Text_12:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_gold)> 1000000 then
		Text_12:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		Text_12:setString(self.user_gold)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("user_topinfo_a_show_all_info", 0, "equip_player_infomation_button.'")]]}, nil, 0)
	if fwin:find("CaptureResourceClass") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Panel_2"):setTouchEnabled(false)
	end	

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
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

function UserTopInfoA:onUpdate(dt)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end
	
	if self.user_food ~= _ED.user_info.user_food then
		self.user_food = _ED.user_info.user_food
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
			local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
			Label_power_left:setString(self.user_food)
			Label_power_right:setString(self.max_user_food)
			if tonumber(self.user_food) > tonumber(self.max_user_food) then
				Label_power_left:setColor(cc.c3b(0,255,0))
			else
				Label_power_left:setColor(cc.c3b(255,255,255))
			end
		else
			if tonumber( self.user_food ) > 10000  then
				self._Text_9:setString(math.floor(self.user_food /1000)..string_equiprety_name[40] .."/"..self.max_user_food)
			else
				self._Text_9:setString(self.user_food  .. "/" ..self.max_user_food)
			end
		end
	end
	
	if self.endurance ~= _ED.user_info.endurance then
		self.endurance = _ED.user_info.endurance
		
		if tonumber( self.endurance) > 10000  or tonumber( self.max_endurance) > 10000 then
			if self._Text_10 ~= nil then
				self._Text_10:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
			end
		else
			if self._Text_10 ~= nil then
				self._Text_10:setString(self.endurance.."/"..self.max_endurance)
			end
		end
	end
	
	if self.max_endurance ~= _ED.user_info.max_endurance then
		self.max_endurance = _ED.user_info.max_endurance
		if self._Text_10 ~= nil then
			self._Text_10:setString(self.endurance.."/"..self.max_endurance)
		end
	end
	
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		-- if tonumber( self.user_silver) > 100000000 then
		-- 	self._Text_11:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_silver)> 10000 then
			self._Text_11:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._Text_11:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		-- if tonumber(self.user_gold) > 100000000 then
		-- 	self._Text_12:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_gold)> 1000000 then
			self._Text_12:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._Text_12:setString(self.user_gold)
		end
	end
end

function UserTopInfoA:onExit()
	state_machine.remove("user_topinfo_a_show_all_info")
end