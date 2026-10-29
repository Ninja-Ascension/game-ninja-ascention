-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景用户信息
-------------------------------------------------------------------------------------------------------
PVEMapInformation = class("PVEMapInformationClass", Window)

function PVEMapInformation:ctor()
    self.super:ctor()
    self.roots = {}
	self.user_grade		= 0		--用户等级
	self.user_food 		= 0		--当前体力
	self.max_user_food 	= 0		--体力上限
	self.user_silver 	= 0		--用户银币
	self.user_gold 		= 0			--元宝
	self.user_experience 				= 9999					--当前经验
	self.user_grade_need_experience 	= 99999					--升级所需经验

	self._Label_user_grade = nil
	self._LoadingBar_user_experience = nil
	self._Label_user_silver = nil
	self._Label_user_food = nil
	self._Label_user_gold = nil

	local function init_pve_map_information_terminal()
		-- 用户信息显示
		local pve_map_information_show_all_info_terminal = {
            _name = "pve_map_information_show_all_info",
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
		state_machine.add(pve_map_information_show_all_info_terminal)
        state_machine.init()
    end
    
    init_pve_map_information_terminal()
end

function PVEMapInformation:onUpdateDraw()
	self.user_grade		= _ED.user_info.user_grade 			--用户等级
	self.user_food 		= _ED.user_info.user_food 			--当前体力
	self.max_user_food 	= _ED.user_info.max_user_food 		--体力上限
	self.user_silver 	= _ED.user_info.user_silver 		--用户银币
	self.user_gold 		= _ED.user_info.user_gold 			--元宝
	self.user_experience 				= zstring.tonumber(_ED.user_info.user_experience)					--当前经验
	self.user_grade_need_experience 	= zstring.tonumber(_ED.user_info.user_grade_need_experience)	--升级所需经验
	self.user_grade_deal 	= self.user_experience/self.user_grade_need_experience *100						--升级所需经验进度条
	--进度条数值限制
	if self.user_grade_deal < 0 then
		self.user_grade_deal = 0
	elseif self.user_grade_deal > 100 then
		self.user_grade_deal = 100
	end
	
	self._Label_user_grade 				= ccui.Helper:seekWidgetByName(self.roots[1], "Label_528_2")
	self._LoadingBar_user_experience 	= ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_exp")
	self._Label_user_silver = ccui.Helper:seekWidgetByName(self.roots[1], "Label_529_1")
	self._Label_user_food = ccui.Helper:seekWidgetByName(self.roots[1], "Label_55831")
	self._Label_user_gold = ccui.Helper:seekWidgetByName(self.roots[1], "Label_528_1")
	
	LoadingBar_user_experience:setPercent(self.user_grade_deal)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
	end

	if tonumber( self.user_food) > 10000  then
		self._Label_user_food:setString(math.floor(self.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
	else
		self._Label_user_food:setString(self.user_food.."/"..self.max_user_food)
	end
	
	-- if tonumber( self.user_silver) > 100000000 then
	-- 	self._Label_user_silver:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_silver)> 10000 then
		self._Label_user_silver:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		self._Label_user_silver:setString(self.user_silver)
	end
	
	-- if tonumber(self.user_gold) > 100000000 then
	-- 	self._Label_user_gold:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_gold)> 1000000 then
		self._Label_user_gold:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		self._Label_user_gold:setString(self.user_gold)
	end
	
	if verifySupportLanguage(_lua_release_language_en) == true then	
		self._Label_user_grade:setString(_string_piece_info[6]..self.user_grade)	
	else
		self._Label_user_grade:setString(self.user_grade.._string_piece_info[6])	
	end
end

function PVEMapInformation:onEnterTransitionFinish()
	local csbPveMap = csb.createNode("utils/public_information_2.csb")
    local root = csbPveMap:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPveMap)
	
    self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_20"), nil, {func_string = [[state_machine.excute("pve_map_information_show_all_info", 0, "equip_player_infomation_button.'")]]}, nil, 0)
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

function PVEMapInformation:onExit()
	state_machine.remove("pve_map_information_show_all_info")
end

function PVEMapInformation:onUpdate(dt)

	if self.user_grade ~= _ED.user_info.user_grade then
		self.user_grade = _ED.user_info.user_grade
		if verifySupportLanguage(_lua_release_language_en) == true then
			self._Label_user_grade:setString(_string_piece_info[6]..self.user_grade)
		else
			self._Label_user_grade:setString(self.user_grade.._string_piece_info[6])
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		-- if tonumber(self.user_gold) > 100000000 then
		-- 	self._Label_user_gold:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_gold)> 1000000 then
			self._Label_user_gold:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._Label_user_gold:setString(self.user_gold)
		end
	end
	
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		-- if tonumber( self.user_silver) > 100000000 then
		-- 	self._Label_user_silver:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_silver)> 10000 then
			self._Label_user_silver:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._Label_user_silver:setString(self.user_silver)
		end
	end
	
	if self.user_experience ~= _ED.user_info.user_experience then
		self.user_experience = _ED.user_info.user_experience
		self._LoadingBar_user_experience:setPercent(self.user_experience / self.user_grade_need_experience * 100)
	end
	
	if self.user_grade_need_experience ~= _ED.user_info.user_grade_need_experience then
		self.user_grade_need_experience = _ED.user_info.user_grade_need_experience
		self._LoadingBar_user_experience:setPercent(self.user_experience / self.user_grade_need_experience * 100)
	end

	if self.user_food ~= _ED.user_info.user_food then
		self.user_food = _ED.user_info.user_food
		if tonumber( self.user_food) > 10000 then
			self._Label_user_food:setString(math.floor(self.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
		else
			self._Label_user_food:setString(self.user_food.."/"..self.max_user_food)
		end
	end
	
	if self.max_user_food ~= _ED.user_info.max_user_food then
		self.max_user_food = _ED.user_info.max_user_food
		if tonumber( self.user_food) > 10000 then
			self._Label_user_food:setString(math.floor(self.user_food/1000)..string_equiprety_name[40] .."/"..self.max_user_food)
		else
			self._Label_user_food:setString(self.user_food.."/"..self.max_user_food)
		end
	end
	
end