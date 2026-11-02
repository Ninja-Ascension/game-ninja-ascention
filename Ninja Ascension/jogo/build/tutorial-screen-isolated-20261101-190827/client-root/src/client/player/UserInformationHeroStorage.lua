-- ----------------------------------------------------------------------------------------------------
-- 说明：活动顶部用户栏信息
-- 创建时间:2015.03.16
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
UserInformationHeroStorage = class("UserInformationHeroStorageClass", Window, true)
    
function UserInformationHeroStorage:ctor()
    self.super:ctor()
	self.roots = {}
	self.user_grade = _ED.user_info.user_grade     			--主角等级 
	self.user_experience = _ED.user_info.user_experience	--主角经验
	self.fight_capacity = _ED.user_info.fight_capacity	or "0"		--主角战力
	self.user_silver = _ED.user_info.user_silver    		--用户银币 
	self.user_gold = _ED.user_info.user_gold				--主角金币	

	self._Text_dengji = nil
	self._Text_zhanli = nil
	self._LoadingBar_1 = nil
	self._Text_money = nil
	self._Text_money_0 = nil
	self._Text_exp = nil
	
	 local function init_user_info_hero_storage_terminal()
		-- 用户信息显示
		local user_info_hero_storage_show_terminal = {
            _name = "user_info_hero_storage_show",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				terminal._instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 用户信息显示
		local user_info_hero_storage_update_terminal = {
            _name = "user_info_hero_storage_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 
		local user_info_hero_storage_play_action_terminal = {
            _name = "user_info_hero_storage_play_action",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.action ~= nil then
					instance.action:gotoFrameAndPlay(0, instance.action:getDuration(), false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 用户信息显示
		local user_info_hero_storage_show_all_info_terminal = {
            _name = "user_info_hero_storage_show_all_info",
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

        -- 购买钻石，充值
        local user_info_hero_storage_recharge_terminal = {
            _name = "user_info_hero_storage_recharge",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_adventure then
					if fwin:find("AdventureRechargeClass") == nil then
						app.load("client.adventure.shop.AdventureRecharge")
						fwin:open(AdventureRecharge:new():init(), fwin._view)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(user_info_hero_storage_show_terminal)
		state_machine.add(user_info_hero_storage_update_terminal)
		state_machine.add(user_info_hero_storage_play_action_terminal)
		state_machine.add(user_info_hero_storage_show_all_info_terminal)
		state_machine.add(user_info_hero_storage_recharge_terminal)

        state_machine.init()
    end
    
    init_user_info_hero_storage_terminal()
end

function UserInformationHeroStorage:onUpdateDraw()
	local root = self.roots[1]

	self.user_grade = _ED.user_info.user_grade     			--主角等级 
	self.user_experience = _ED.user_info.user_experience	--主角经验
	self.fight_capacity = _ED.user_info.fight_capacity	or "0"		--主角战力
	self.user_silver = _ED.user_info.user_silver    		--用户银币 
	self.user_gold = _ED.user_info.user_gold				--主角金币	

	self.resource_experience = _ED.user_info.resource_experience	--用户经验资源

    self.user_food 		= _ED.user_info.user_food or 0			--当前体力
	self.max_user_food 	= _ED.user_info.max_user_food or 0	--体力上限
	
	local Text_dengji = ccui.Helper:seekWidgetByName(root, "Text_dengji")
	local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
	local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	local Text_money = ccui.Helper:seekWidgetByName(root, "Text_money")
	local Text_money_0 = ccui.Helper:seekWidgetByName(root, "Text_money_0")
	local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")
	
	self._Text_dengji = Text_dengji
	self._Text_zhanli = Text_zhanli
	self._LoadingBar_1 = LoadingBar_1
	self._Text_money = Text_money
	self._Text_money_0 = Text_money_0
	self._Text_exp = Text_exp

	if __lua_project_id == __lua_project_adventure then
		if Text_dengji ~= nil then
			Text_dengji:setString(self.user_grade)
		end
		--- 人物头像,昵称
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
		local mould_data = dms.element(dms["ship_mould"],  _ED.user_info.user_ship)
		local picIndex = dms.atos(mould_data, ship_mould.head_icon)
		local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
		Panel_role:removeAllChildren(true)
		local armature = ccs.Armature:create("spirte")
		local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(500 + zstring.tonumber(_ED.user_info.user_head)))
        local skinIcon = ccs.Skin:create(spriteIcon)
        skinIcon:getTexture():setAliasTexParameters()
        armature:getBone("big_head_"..1):addDisplay(skinIcon, 0)

        local size = Panel_role:getContentSize()
        local sWidth = (size.width)/2

		armature:setPosition(cc.p(sWidth,0))
		Panel_role:addChild(armature)
		--Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", 500 + zstring.tonumber(_ED.user_info.user_head)))
		
		local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_zhujue_name")
		Text_rolename:setString( _ED.user_info.user_name)
		if ___is_open_leadname == true then
			Text_rolename:setFontName("")
			Text_rolename:setFontSize(Text_rolename:getFontSize())
		end

		if zstring.tonumber( self.fight_capacity) > 1000000000 then
			Text_zhanli:setString(string.format("%.02f",self.fight_capacity/ 1000000000) .. string_equiprety_name[42])
		elseif zstring.tonumber(self.fight_capacity)> 1000000 then
			Text_zhanli:setString(string.format("%.02f",self.fight_capacity / 1000000) .. string_equiprety_name[41])
		elseif zstring.tonumber(self.fight_capacity)> 1000 then
			Text_zhanli:setString(string.format("%.02f",self.fight_capacity / 1000) .. string_equiprety_name[40])
		else
			Text_zhanli:setString(self.fight_capacity)
		end
		
		if zstring.tonumber( self.resource_experience) > 1000000000 then
			Text_exp:setString(string.format("%.02f",self.resource_experience/ 1000000000) .. string_equiprety_name[42])
		elseif zstring.tonumber(self.resource_experience)> 1000000 then
			Text_exp:setString(string.format("%.02f",self.resource_experience / 1000000) .. string_equiprety_name[41])
		elseif zstring.tonumber(self.resource_experience)> 1000 then
			Text_exp:setString(string.format("%.02f",self.resource_experience / 1000) .. string_equiprety_name[40])
		else
			Text_exp:setString(self.resource_experience)
		end
		
		if zstring.tonumber( self.user_silver) > 1000000000 then
			Text_money:setString(string.format("%.02f",self.user_silver/ 1000000000) .. string_equiprety_name[42])
		elseif zstring.tonumber(self.user_silver)> 1000000 then
			Text_money:setString(string.format("%.02f",self.user_silver / 1000000) .. string_equiprety_name[41])
		elseif zstring.tonumber(self.user_silver)> 1000 then
			Text_money:setString(string.format("%.02f",self.user_silver / 1000) .. string_equiprety_name[40])
		else
			Text_money:setString(self.user_silver)
		end
		
		
		if zstring.tonumber( self.user_gold) > 1000000000 then
			Text_money_0:setString(string.format("%.02f",self.user_gold/ 1000000000) .. string_equiprety_name[42])
		elseif zstring.tonumber(self.user_gold)> 1000000 then
			Text_money_0:setString(string.format("%.02f",self.user_gold / 1000000) .. string_equiprety_name[41])
		else
			Text_money_0:setString(self.user_gold)
		end
		
	else
		if Text_dengji ~= nil then
			Text_dengji:setString(self.user_grade)
		end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
				local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
				local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
				Label_power_left:setString(self.user_food)
				Label_power_right:setString(self.max_user_food)
				if tonumber(self.user_food) > tonumber(self.max_user_food) then
					Label_power_left:setColor(cc.c3b(26,157,0))
				else
					Label_power_left:setColor(cc.c3b(255,255,255))
				end
				-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
				-- 	Label_power_left:setColor(cc.c3b(26,157,0))
				-- end
				-- if tonumber( self.user_food ) > 1000000  then
				-- 	Text_zhanli:setString(math.floor(self.user_food /10000)..string_equiprety_name[38] .."/"..self.max_user_food)
				-- else
				-- 	Text_zhanli:setString(self.user_food  .. "/" ..self.max_user_food)
				-- end
			else
				-- if zstring.tonumber( self.fight_capacity) > 100000000 then
				-- 	Text_zhanli:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
				-- else
				if zstring.tonumber(self.fight_capacity)> 10000 then
					Text_zhanli:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
				else
					Text_zhanli:setString(self.fight_capacity)
				end
			end
		
			-- if zstring.tonumber( self.user_silver) > 100000000 then
			-- 	Text_money:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
			-- else
			if zstring.tonumber( self.user_silver)> 10000 then
				Text_money:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
			else
				Text_money:setString(self.user_silver)
			end
		
			-- if zstring.tonumber(self.user_gold) > 100000000 then
			-- 	Text_money_0:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
			-- else
			if zstring.tonumber( self.user_gold)> 1000000 then
				Text_money_0:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
			else
				Text_money_0:setString(self.user_gold)
			end

		if LoadingBar_1 ~= nil then
			LoadingBar_1:setPercent(zstring.tonumber(_ED.user_info.user_experience) / zstring.tonumber(_ED.user_info.user_grade_need_experience) * 100)
		end
	end
end

function UserInformationHeroStorage:onEnterTransitionFinish()
	local csbInformation = csb.createNode("utils/generals_xinxi.csb")
	local action = csb.createTimeline("utils/generals_xinxi.csb")
	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbInformation:runAction(action)
	
	local root = csbInformation:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbInformation)
	
	state_machine.excute("user_info_hero_storage_show", 0, "user_info_hero_storage_show.")

	-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
	-- 	local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
	-- 	Label_power_left:setColor(cc.c3b(26,157,0))
	-- end
	
	if __lua_project_id == __lua_project_adventure then
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_4_u"), nil, {func_string = [[state_machine.excute("user_info_hero_storage_show_all_info", 0, "equip_player_infomation_button.'")]]}, nil, 0)
	end
    -- 购买钻石
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"),       nil, 
    {
        terminal_name = "user_info_hero_storage_recharge",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
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

function UserInformationHeroStorage:onExit()
	state_machine.remove("user_info_hero_storage_show")
	state_machine.remove("user_info_hero_storage_update")
	state_machine.remove("user_info_hero_storage_play_action")
	state_machine.remove("user_info_hero_storage_show_all_info")
	state_machine.remove("user_info_hero_storage_recharge")
end

function UserInformationHeroStorage:onUpdate(dt)
	if self.roots == nil or self.roots[1] == nil then
		return
	end

	if __lua_project_id == __lua_project_adventure then
		local addSilver = 0
		local cd = (_ED.on_hook_reward_os_time + _ED.on_hook_reward_time) - os.time()
		if _ED.max_box_reward_count > _ED.on_hook_reward_count and cd > 0 then
			addSilver = (os.time() - _ED.on_hook_reward_os_time) * _ED.on_hook_reward_gold_s
		end
		if self.user_silver ~= _ED.user_info.user_silver + addSilver then
			self.user_silver = _ED.user_info.user_silver + addSilver
			-- if zstring.tonumber( self.user_silver) > 1000000000 then
			-- 	self._Text_money:setString(string.format("%.02f",self.user_silver/ 1000000000) .. string_equiprety_name[42])
			-- elseif zstring.tonumber(self.user_silver)> 1000000 then
			-- 	self._Text_money:setString(string.format("%.02f",self.user_silver / 1000000) .. string_equiprety_name[41])
			-- else
			if zstring.tonumber(self.user_silver)> 1000 then
				self._Text_money:setString(string.format("%.02f",self.user_silver / 1000) .. string_equiprety_name[40])
			else
				self._Text_money:setString(self.user_silver)
			end
		end
	else
		if self.user_silver ~= _ED.user_info.user_silver then
			self.user_silver = _ED.user_info.user_silver
			-- if zstring.tonumber( self.user_silver) > 100000000 then
			-- 	self._Text_money:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
			-- else
			if zstring.tonumber( self.user_silver)> 10000 then
				self._Text_money:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
			else
				self._Text_money:setString(self.user_silver)
			end
		end
	end
	--
	if self.user_grade ~= _ED.user_info.user_grade then
		self.user_grade = _ED.user_info.user_grade
		if self._Text_dengji ~= nil then 
			self._Text_dengji:setString(self.user_grade)
		end
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end
	--
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		if __lua_project_id == __lua_project_adventure then
			if zstring.tonumber( self.user_gold) > 1000000000 then
				self._Text_money_0:setString(string.format("%.02f",self.user_gold/ 1000000000) .. string_equiprety_name[42])
			elseif zstring.tonumber(self.user_gold)> 1000000 then
				self._Text_money_0:setString(string.format("%.02f",self.user_gold / 1000000) .. string_equiprety_name[41])
			else
				self._Text_money_0:setString(self.user_gold)
			end
		else
			-- if zstring.tonumber(self.user_gold) > 100000000 then
			-- 	self._Text_money_0:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
			-- else
			if zstring.tonumber( self.user_gold)> 1000000 then
				self._Text_money_0:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
			else
				self._Text_money_0:setString(self.user_gold)
			end
		end
	end
	--
	if __lua_project_id == __lua_project_adventure then
		local addExperience = 0
		local cd = (_ED.on_hook_reward_os_time + _ED.on_hook_reward_time) - os.time()
		-- if _ED.max_box_reward_count > _ED.on_hook_reward_count and cd > 0 then
			addExperience = (os.time() - _ED.on_hook_reward_os_time) * _ED.on_hook_reward_experience_s
		-- end
		if self.resource_experience ~= _ED.user_info.resource_experience + addExperience then
			self.resource_experience = _ED.user_info.resource_experience + addExperience
			_ED.user_info.addExperience = tonumber(addExperience)
			if zstring.tonumber( self.resource_experience) > 1000000000 then
				self._Text_exp:setString(string.format("%.02f",self.resource_experience/ 1000000000) .. string_equiprety_name[42])
			elseif zstring.tonumber(self.resource_experience)> 1000000 then
				self._Text_exp:setString(string.format("%.02f",self.resource_experience / 1000000) .. string_equiprety_name[41])
			elseif zstring.tonumber(self.resource_experience)> 1000 then
				self._Text_exp:setString(string.format("%.02f",self.resource_experience / 1000) .. string_equiprety_name[40])
			else
				self._Text_exp:setString(self.resource_experience)
			end
		end
	else
		if self.user_experience ~= _ED.user_info.user_experience then
			self.user_experience = _ED.user_info.user_experience
			if self._LoadingBar_1 ~= nil then
				self._LoadingBar_1:setPercent(zstring.tonumber(_ED.user_info.user_experience) / zstring.tonumber(_ED.user_info.user_grade_need_experience) * 100)
			end
		end
	end
	--
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if self.user_food ~= _ED.user_info.user_food then
			self.user_food = _ED.user_info.user_food
			local Label_power_left = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_left")
			local Label_power_right = ccui.Helper:seekWidgetByName(self.roots[1], "Label_power_right")
			Label_power_left:setString(self.user_food)
			Label_power_right:setString(self.max_user_food)
			if tonumber(self.user_food) > tonumber(self.max_user_food) then
				Label_power_left:setColor(cc.c3b(26,157,0))
			else
				Label_power_left:setColor(cc.c3b(255,255,255))
			end
			-- if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			-- 	Label_power_left:setColor(cc.c3b(26,157,0))
			-- end
			-- if tonumber( self.user_food ) > 1000000  then
			-- 	self._Text_zhanli:setString(math.floor(self.user_food /10000)..string_equiprety_name[38] .."/"..self.max_user_food)
			-- else
			-- 	self._Text_zhanli:setString(self.user_food  .. "/" ..self.max_user_food)
			-- end
		end
	else
		if self.fight_capacity ~= _ED.user_info.fight_capacity then
			self.fight_capacity = _ED.user_info.fight_capacity
			if __lua_project_id == __lua_project_adventure then
				--print()
				if zstring.tonumber( self.fight_capacity) > 1000000000 then
					self._Text_zhanli:setString(string.format("%.02f",self.fight_capacity/ 1000000000) .. string_equiprety_name[42])
				elseif zstring.tonumber(self.fight_capacity)> 1000000 then
					self._Text_zhanli:setString(string.format("%.02f",self.fight_capacity / 1000000) .. string_equiprety_name[41])
				elseif zstring.tonumber(self.fight_capacity)> 1000 then
					self._Text_zhanli:setString(string.format("%.02f",self.fight_capacity / 1000) .. string_equiprety_name[40])
				else
					self._Text_zhanli:setString(self.fight_capacity)
				end
			else
				-- if zstring.tonumber( self.fight_capacity) > 100000000 then
				-- 	self._Text_zhanli:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
				-- else
				if zstring.tonumber(self.fight_capacity)> 10000 then
					self._Text_zhanli:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
				else
					self._Text_zhanli:setString(self.fight_capacity)
				end
			end
		end
	end
end