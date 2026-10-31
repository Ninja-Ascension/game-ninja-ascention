----------------------------------------------------------------------------------------------------
-- 说明：阵容武将选择上阵界面
-------------------------------------------------------------------------------------------------------

HeroFormationChoiceWear = class("HeroFormationChoiceWearClass", Window)

local hero_formation_choice_wear_window_open_terminal = {
    _name = "hero_formation_choice_wear_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if fwin:find("HeroFormationChoiceWearClass") == nil then 
	        fwin:open(HeroFormationChoiceWear:new():init(params[1], params[2], params[3], params[4], params[5], params[6], params[7]), fwin._ui)
	    end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_formation_choice_wear_window_close_terminal = {
    _name = "hero_formation_choice_wear_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	    	_ED.activity_battle_copy_formation_limit = nil
	    end
        fwin:close(fwin:find("HeroFormationChoiceWearClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_formation_choice_wear_window_open_terminal)
state_machine.add(hero_formation_choice_wear_window_close_terminal)
state_machine.init()
   
function HeroFormationChoiceWear:ctor()
    self.super:ctor()
	self.roots = {}
	self.current_type = 0
	self.enum_type = {
		_THE_BATTLE_OF_WARSHIPS_ONLY = 1,	-- 上阵出战船只
		_THE_BATTLE_OF_SMALL_PARTNERS = 2,		-- 上阵小伙伴
		_THE_BATTLE_RESOURCE_PARTNERS = 3,		-- 资源抢夺上阵
	}
	self._data = nil
	
	self.isShowFightHero = false
	self.shipId = nil
	self.chooseShips = {}

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	self.currentScrollView = nil
	self.currentScrollViewInnerContainer = nil
	self.currentScrollViewInnerContainerPosY  = 0
	self.hero_formation_cells = {}   --用来储存单个的上阵cell

	HEROSORT = {
		ALL = 1,
		OWN = 2,
		UNOWN = 3
	}

	HEROSORTRULE = {
		QUALITY = 1,
		LEVEL = 2,
		FIGHT = 3,
		ORDER = 4,
		STAR = 5
	}
	self.dressList = {
		sQulity = {},	-- 资质
		sType = {},		-- 类型
		sMood = {},		-- 斗魂
		sTerm = {}		-- 排序
	}
	
    local function init_hero_formation_choice_terminal()
		
		local hero_formation_choice_back_terminal = {
            _name = "hero_formation_choice_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            		then
	    --         	if fwin:find("UserInformationHeroStorageClass") ~= nil then
					-- 	fwin:close(fwin:find("UserInformationHeroStorageClass"))
					-- end
				end
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
				else
					state_machine.excute("menu_show_event", 0, "menu_show_event.")
				end	
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local request_choice_hero_the_battle_terminal = {
            _name = "request_choice_hero_the_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if nil ~= instance.call_join_terminal_name then
            		state_machine.excute(instance.call_join_terminal_name, 0, {instance.cell_index, params.ship_id})
            		return true
            	end
            	if instance.current_type == instance.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
            		state_machine.excute("secret_formationChange_add_role_to_formation", 0, params.ship_id.."|"..instance._data)
					fwin:close(instance)
				else
					state_machine.excute("choice_hero_battle_request", 0, params.ship_id.."|"..instance._data)
					fwin:close(instance)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
					else
						state_machine.excute("menu_show_event", 0, "menu_show_event.")
					end	
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local request_choice_hero_the_partners_terminal = {
            _name = "request_choice_hero_the_partners",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("choice_hero_partners_request", 0, params.ship_id.."|"..instance._data)
				fwin:close(instance)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_choice_show_fight_hero_terminal = {
            _name = "hero_choice_show_fight_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            		if instance.isShowFightHero == false then	
            			ccui.Helper:seekWidgetByName(instance.roots[1], "image_hidden_or_show"):setVisible(true)
            			instance.isShowFightHero = true
            			instance:onUpdateDraw()
            		elseif instance.isShowFightHero == true then
						ccui.Helper:seekWidgetByName(instance.roots[1], "image_hidden_or_show"):setVisible(false)
						instance.isShowFightHero = false
						instance:onUpdateDraw()
            		end
            	elseif __lua_project_id == __lua_project_yugioh then
            		if instance.isShowFightHero == false then	
            			ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(false)
            			instance.isShowFightHero = true
            			instance:onUpdateDraw()
            		elseif instance.isShowFightHero == true then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(true)
						instance.isShowFightHero = false
						instance:onUpdateDraw()
            		end
            	else
					if instance.isShowFightHero == false then
						if instance.shipId ~= nil and tonumber(instance.shipId) > 0 then
							local listview = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_list")
							local cell = HeroFormationChoiceWear:createHeroWear(_ED.user_ship[instance.shipId],self.current_type, nil, 0)
							
							listview:insertCustomItem(cell, 0)
						end
						instance.isShowFightHero = true
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(false)
					elseif instance.isShowFightHero == true then
						if instance.shipId ~= nil and tonumber(instance.shipId) > 0 then
							local listview = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_list")
							listview:removeItem(0)
						end
						instance.isShowFightHero = false
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(true)
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

		local request_choice_hero_update_terminal = {
            _name = "request_choice_hero_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:onUpdateDraw()
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --灵魂守卫 隐藏上阵按钮
        local hero_choice_show_hide_soul_terminal = {
            _name = "hero_choice_show_hide_soul",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:onHideHeroCell()
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 英雄排序
		local hero_choice_show_go_sort_view_terminal = {
            _name = "hero_choice_show_go_sort_view",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroSortDressWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil then
					if HeroFormationChoiceWear.myListView then 
						HeroFormationChoiceWear.myListView:jumpToTop()
						HeroFormationChoiceWear.myListView:requestRefreshView()
					end
            		state_machine.excute("hero_sort_dress_window_open",0,{instance.Panel_heroFilter,2})
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 英雄排序刷新
		local hero_choice_show_sort_new_refush_terminal = {
            _name = "hero_choice_show_sort_new_refush",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:sortHeroNew(params)
            	end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(hero_formation_choice_back_terminal)
		state_machine.add(request_choice_hero_the_battle_terminal)
		state_machine.add(request_choice_hero_the_partners_terminal)
		state_machine.add(hero_choice_show_fight_hero_terminal)
		state_machine.add(request_choice_hero_update_terminal)
		state_machine.add(hero_choice_show_hide_soul_terminal)
		state_machine.add(hero_choice_show_go_sort_view_terminal)
		state_machine.add(hero_choice_show_sort_new_refush_terminal)
        state_machine.init()
    end

    init_hero_formation_choice_terminal()
end

-- DB2重塑,敬请期待显示处理
function HeroFormationChoiceWear:showCoomingSoon()
	local Image_coming_soon =  ccui.Helper:seekWidgetByName(self.roots[1], "Image_coming_soon")
	if Image_coming_soon ~= nil then 
		local allHeros = self:getAllHeros()
		local haveFlag = self:isCorreSpondingType(allHeros)
		
		if not haveFlag then 
			Image_coming_soon:setVisible(true)
		else
			Image_coming_soon:setVisible(false)
		end
	end
end

-- DB2重塑,是否有对应筛选类型武将
function HeroFormationChoiceWear:isCorreSpondingType(heroslist)
	for i,v in ipairs(heroslist) do
		local heroId = dms.string(dms["prop_mould"], v, prop_mould.use_of_ship)
		local shipInfo = {mouldId = heroId}
		local isAdd = self:isAddFlag(shipInfo)
		if isAdd then 
			return true
		end
	end
	return false
end

-- DB2重塑,获取所有武将ID
function HeroFormationChoiceWear:getAllHeros()
	local tSortedHeroes = {}
	for i, shipMould in pairs(dms["prop_mould"]) do
		local isAdd = false
		if tonumber(dms.atoi(shipMould, prop_mould.props_type)) == 1 then
     		table.insert(tSortedHeroes, dms.atoi(shipMould, prop_mould.id))
		end
	end
	return tSortedHeroes
end

-- 重新排序
function HeroFormationChoiceWear:sortHeroNew(mDressList)
	
	if mDressList then 
		self.dressList = mDressList
	end

	local mSortHeros = self:getSortedHeroes()

	local select_term = self.dressList.sTerm  -- 0 降序   1 升序

	-- 资质
	local function fightingQuality(a,b)
		local al = dms.int(dms["ship_mould"], tonumber(a.ship_template_id), ship_mould.ability)

		local bl = dms.int(dms["ship_mould"], tonumber(b.ship_template_id), ship_mould.ability)
		local result = false
		if select_term[2] == 0 then
			if al > bl then
				result = true
			end
		else
			if al < bl then
				result = true
			end
		end
		if al == bl then 
			local a2 = tonumber(a.hero_fight)
			local b2 = tonumber(b.hero_fight)
			if al > bl then
				result = true
			end
		end
		return result 
	end

	-- 等级
	local function fightingLevel(a,b)
		local al = tonumber(a.ship_grade)
		local bl = tonumber(b.ship_grade)
		local result = false
		if select_term[2] == 0 then
			if al > bl then
				result = true
			end
		else
			if al < bl then
				result = true
			end
		end
		if al == bl then 
			local a2 = tonumber(a.hero_fight)
			local b2 = tonumber(b.hero_fight)
			if al > bl then
				result = true
			end
		end
		return result 
	end

	-- 战斗力
	local function fightingHeroFight(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if select_term[2] == 0 then
			if al > bl then
				result = true
			end
		else
			if al < bl then
				result = true
			end
		end
		return result 
	end

	-- 品质
	local function fightingOrder(a,b)
		local al = tonumber(a.Order)
		local bl = tonumber(b.Order)
		local result = false
		if select_term[2] == 0 then
			if al > bl then
				result = true
			end
		else
			if al < bl then
				result = true
			end
		end
		if al == bl then 
			local a2 = tonumber(a.hero_fight)
			local b2 = tonumber(b.hero_fight)
			if al > bl then
				result = true
			end
		end
		return result 
	end

	-- 星级
	local function fightingStar(a,b)
		local al = tonumber(a.StarRating)
		local bl = tonumber(b.StarRating)
		local result = false
		if select_term[2] == 0 then
			if al > bl then
				result = true
			end
		else
			if al < bl then
				result = true
			end
		end
		if al == bl then 
			local a2 = tonumber(a.hero_fight)
			local b2 = tonumber(b.hero_fight)
			if al > bl then
				result = true
			end
		end
		return result 
	end

	local tempSortHeros = {}
	for i,v in ipairs(mSortHeros) do
		local shipInfo = {mouldId = v.ship_template_id}
		local isAdd = self:isAddFlag(shipInfo)

		if isAdd then 
			table.insert(tempSortHeros,v)
		end
	end


	if #self.dressList.sQulity == 0 and #self.dressList.sMood == 0 and #self.dressList.sType == 0 and #self.dressList.sTerm > 0 then 
		tempSortHeros = mSortHeros
	end

	if select_term[1] then 
		if HEROSORTRULE.QUALITY == tonumber(select_term[1]) then 
			-- 资质
			table.sort(tempSortHeros,fightingOrder)
		elseif HEROSORTRULE.LEVEL == tonumber(select_term[1]) then
			-- 等级
			table.sort(tempSortHeros,fightingLevel)
		elseif HEROSORTRULE.FIGHT == tonumber(select_term[1]) then
			-- 战斗力
			table.sort(tempSortHeros,fightingHeroFight)
		elseif HEROSORTRULE.ORDER == tonumber(select_term[1]) then
			-- 品质
			table.sort(tempSortHeros,fightingOrder)
		elseif HEROSORTRULE.STAR == tonumber(select_term[1]) then
			-- 星级
			table.sort(tempSortHeros,fightingStar)
		end
	end

	self:onUpdateDraw(tempSortHeros)
	HeroFormationChoiceWear.myListView:jumpToTop()
	HeroFormationChoiceWear.myListView:requestRefreshView()
end

function HeroFormationChoiceWear:isAddFlag(shipInfo)
	local select_qulity = self.dressList.sQulity
	local select_type = self.dressList.sType
	local select_mood = self.dressList.sMood
	

	local isAddQulity = false
	if #select_qulity > 0 then
		for i=1,#select_qulity do
			local ability = dms.int(dms["ship_mould"], tonumber(shipInfo.mouldId), ship_mould.ability)
			if tonumber(select_qulity[i]) == ability then 
				isAddQulity = true
			end
		end
	else
		isAddQulity = true
	end

	local isAddType = false
	if #select_type > 0 then 
		for i=1,#select_type do
			local camp_preference = dms.int(dms["ship_mould"], tonumber(shipInfo.mouldId), ship_mould.camp_preference)
			if tonumber(select_type[i]) == camp_preference then 
				isAddType = true
			end
		end
	else
		isAddType = true
	end

	local isAddMood = false
	if #select_mood > 0 then 
		for i=1,#select_mood do
			local faction_id = zstring.split(dms.string(dms["ship_mould"], tonumber(shipInfo.mouldId), ship_mould.faction_id), ",")[1]
			local soulType = dms.int(dms["ship_soul_mould"], faction_id, ship_soul_mould.soul_type)
			if tonumber(select_mood[i]) == soulType then 
				isAddMood = true
			end
		end
	else
		isAddMood = true
	end

	
	return (isAddQulity and isAddType and isAddMood)
end

function HeroFormationChoiceWear:sortAnother(ship)

	-- 援军时,self.shipId 是null值
	
	local zoariumSkill = dms.int(dms["ship_mould"], ship.ship_base_template_id, ship_mould.zoarium_skill)
	local step = false
	local ser = 0
	local inPreson = {}
	local num = 1
	if zoariumSkill > 0 then
		--画是否有合击
		for i,v in pairs(_ED.user_ship) do
			if zstring.tonumber(v.formation_index) > 0 then
				
				if self.shipId == nil then
					inPreson[num] = v.ship_base_template_id
					num = num + 1
				else
					if (self.shipId ~= nil and tonumber(v.ship_id) ~= tonumber(self.shipId))  then
						inPreson[num] = v.ship_base_template_id
						num = num + 1
					end
				end
			end
		end
	
		local person_s = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould)
		if person_s ~= nil then
			local step_s = zstring.split(person_s,",")
			local number = table.getn(step_s)
			for j,n in pairs(step_s) do
				for i, v in pairs(inPreson) do
					if tonumber(n) == tonumber(v) or tonumber(n) == tonumber(ship.ship_base_template_id) then
						ser = ser + 1
						break
					end
				end
			end
			if ser > 0 and number > 0 and ser == number then
				step = true
				return "one"
			end
		end
	end
	
	--是否缘分激活
	local fettersNumber = 0
	local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.relationship_id), ",")
	local inStates = {}
	local ter = 1
	for i, v in pairs(_ED.user_ship) do
		if zstring.tonumber(v.formation_index) > 0 or zstring.tonumber(v.little_partner_formation_index) > 0 then
		
			if self.shipId == nil then
				inStates[ter] = v.ship_base_template_id
				ter = ter + 1
			else
				
				if (self.shipId ~= nil and tonumber(v.ship_id) ~= tonumber(self.shipId))  then
					inStates[ter] = v.ship_base_template_id
				ter = ter + 1
				end
			
			end
		end
	end
	--   与武将有关的缘分(不包含合击技)
	if myRelatioInfo ~= nil then
		for k,w in pairs(myRelatioInfo) do
			local num = 1
			local person = {}
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) == 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) == 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) == 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) == 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) == 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) == 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
					num = num + 1
				end
			end
			
			local sss = 0
			for j,r in pairs(person) do
				for i, v in pairs(inStates) do
					if tonumber(r) == tonumber(v) then
						sss = sss + 1
						break
					end
				end
			end
			if table.getn(person)-1 == sss and table.getn(person) - 1 > 0 and sss > 0 then
				fettersNumber = fettersNumber + 1
			end
		end
	end
	
	--   与装备有关的缘分(不包含合击技)
	-- self.instatsShipId 武将实例id
	--  _ED.user_ship[self.instatsShipId]  武将实例
	--  _ED.user_ship[self.instatsShipId].equipment  武将装备集合
	local equip = {}
	if self.shipId ~= nil and _ED.user_ship[self.shipId] ~= nil and _ED.user_ship[self.shipId].equipment ~= nil then
		local cc = 1
		for i, v in pairs(_ED.user_ship[self.shipId].equipment) do
			equip[cc] = v.user_equiment_template
			cc = cc + 1
		end
	end
	if myRelatioInfo ~= nil then
		for k,w in pairs(myRelatioInfo) do
			local num = 1
			local person = {}
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= nil and
				dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) > 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= nil and
				dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) > 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= nil and
				dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) > 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= nil and
				dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) > 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= nil and
				dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) > 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5)
					num = num + 1
				end
			end
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= nil and
				dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) > 0 then
				if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6) > 0 then
					person[num] = dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6)
					num = num + 1
				end
			end
			
			local sss = 0
			for j,r in pairs(person) do
				for i, v in pairs(equip) do
					if tonumber(r) == tonumber(v) then
						sss = sss + 1
						break
					end
				end
			end
			if table.getn(person) == sss and table.getn(person)> 0 and sss > 0 then
				fettersNumber = fettersNumber + 1
			end
		
		end
	end
	
	if fettersNumber>0 and step == false then
		return fettersNumber
	end
	return false
end

function HeroFormationChoiceWear:createHeroWear(ship,_type,id, index)
	local cell = HeroFormationWearListCell:createCell()
--	print("再次确认传入的type......",_type)
	cell:init(ship,_type,id, index)
	return cell
end

function HeroFormationChoiceWear:getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	
	local function fightingNums(a,b)
		local a1 = a.cell
		local b1 = b.cell
		local q1 = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
		local q2 = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
		local result = false
		if a1 > b1 or (a1 == b1 and q1 > q2)then
			result = true
		end
		return result 
	end
	
	local function fightingQuality(a,b)
		local a1 = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
		local b1 = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
		local result = false
		if a1 > b1 then
			result = true
		end
		return result 
	end


	local tSortedHeroes = {}
	-- 上阵武将数组
	local arrBusyHeroes = {}
	-- 各星级武将数组
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRead = {}--红
	local allSkill = {}--合击
	local relationship = {}--缘分
	-- 主角放在第一位
	for i, ship in pairs(_ED.user_ship) do
		local inRosouce = false
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			if ship.inResourceFromation == true and tonumber(ship.captain_type) == 0 then
				inRosouce = true
			end
		end
		
		local captain_type = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.captain_type)
		if captain_type == 3 then 
			--宠物
			inRosouce = true
		end
		if ship.ship_id ~= nil and inRosouce == false then
			local shipData = dms.element(dms["ship_mould"], ship.ship_base_template_id)
			local sameBattleShip = false
			local samePartnerShip = false
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				if self.current_type == self.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
				else
					if self.isShowFightHero == false then
						for j = 2, 7 do
							local shipId = _ED.formetion[j]
							if tonumber(shipId) > 0 then
								if tonumber(_ED.user_ship[shipId].ship_base_template_id) == tonumber(ship.ship_base_template_id) and tonumber(shipId) ~= tonumber(self.shipId) then
									sameBattleShip = true
								end
							end
						end	
						for w, v in pairs(_ED.little_companion_state) do
							if tonumber(v) > 0 then
								if tonumber(fundShipWidthId(v).ship_base_template_id) == tonumber(ship.ship_base_template_id) then
									samePartnerShip = true
								end
							end
						end
					else
						for j = 2, 7 do
							local shipId = _ED.formetion[j]
							if tonumber(shipId) > 0 then
								if tonumber(_ED.user_ship[shipId].ship_base_template_id) == tonumber(ship.ship_base_template_id) and tonumber(shipId) ~= tonumber(ship.ship_id) then
									sameBattleShip = true
								end
							end
						end	
						for w, v in pairs(_ED.little_companion_state) do
							if tonumber(v) > 0 then
								if tonumber(fundShipWidthId(v).ship_base_template_id) == tonumber(ship.ship_base_template_id) and tonumber(v) ~= tonumber(ship.ship_id) then
									samePartnerShip = true
								end
							end
						end
					end
				end
			elseif __lua_project_id == __lua_project_yugioh then
				if self.isShowFightHero == true then
				else
					for j = 2, 7 do
						local shipId = _ED.formetion[j]
						if tonumber(shipId) > 0 then
							if tonumber(_ED.user_ship[shipId].ship_base_template_id) == tonumber(ship.ship_base_template_id) and tonumber(shipId) ~= tonumber(self.shipId) then
								sameBattleShip = true
							end
						end
					end	
					for w, v in pairs(_ED.little_companion_state) do
						if tonumber(v) > 0 then
							if tonumber(fundShipWidthId(v).ship_base_template_id) == tonumber(ship.ship_base_template_id) then
								samePartnerShip = true
							end
						end
					end
				end
			else
				for j = 2, 7 do
					local shipId = _ED.formetion[j]
					if tonumber(shipId) > 0 then
						if tonumber(_ED.user_ship[shipId].ship_base_template_id) == tonumber(ship.ship_base_template_id) and tonumber(shipId) ~= tonumber(self.shipId) then
							sameBattleShip = true
						end
					end
				end	
				for w, v in pairs(_ED.little_companion_state) do
					if tonumber(v) > 0 then
						if tonumber(fundShipWidthId(v).ship_base_template_id) == tonumber(ship.ship_base_template_id) then
							samePartnerShip = true
						end
					end
				end
			end
			if dms.atoi(shipData, ship_mould.captain_type) ~= 0 then
				if sameBattleShip==false and samePartnerShip==false then
					if zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							or __lua_project_id == __lua_project_yugioh 
							then
							if self.isShowFightHero == true or 
								self.current_type == self.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
								table.insert(arrBusyHeroes, ship)
							end	
						end
					else
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon 
							or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							table.insert(arrStarLevelHeroesWhite, ship)
						else
							local cell = self:sortAnother(ship)
							if cell == "one" then
								table.insert(allSkill, ship)
							elseif cell ~= false then
								ship.cell = cell
								table.insert(relationship, ship)
							else
								if dms.atoi(shipData, ship_mould.ship_type) == 0 then
									table.insert(arrStarLevelHeroesWhite, ship)
								elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
									table.insert(arrStarLevelHeroesGreen, ship)
								elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
									table.insert(arrStarLevelHeroesKohlrabiblue, ship)
								elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
									table.insert(arrStarLevelHeroesPurple, ship)
								elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
									table.insert(arrStarLevelHeroesOrange, ship)
								elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
									if __lua_project_id == __lua_project_gragon_tiger_gate
										or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
										or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
										or __lua_project_id == __lua_project_red_alert 
										or __lua_project_id == __lua_project_legendary_game 
										then
										table.insert(arrStarLevelHeroesOrange, ship)
									elseif __lua_project_id == __lua_project_warship_girl_a 
										or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
										or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
										or __lua_project_id == __lua_project_koone
										then
										table.insert(arrStarLevelHeroesRead, ship)
									end
								elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
									if __lua_project_id == __lua_project_gragon_tiger_gate
										or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
										or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
										or __lua_project_id == __lua_project_red_alert 
										then
										table.insert(arrStarLevelHeroesOrange, ship)
									end
								end 
							end
						end
					end
				end
			end
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_yugioh 
		then
		table.sort(arrBusyHeroes, fightingCapacity)
	end
	table.sort(allSkill, fightingQuality)
	table.sort(relationship, fightingNums)
	table.sort(arrStarLevelHeroesWhite, fightingCapacity)
	table.sort(arrStarLevelHeroesGreen, fightingCapacity)
	table.sort(arrStarLevelHeroesKohlrabiblue, fightingCapacity)
	table.sort(arrStarLevelHeroesPurple, fightingCapacity)
	table.sort(arrStarLevelHeroesOrange, fightingCapacity)
	table.sort(arrStarLevelHeroesRead, fightingCapacity)
	
	-- 把已排序好的上阵武将加入到 武将排序数组中
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_yugioh 
		then
		for i=1, #arrBusyHeroes do
			table.insert(tSortedHeroes, arrBusyHeroes[i])
		end
	end
	for i=1, #allSkill do
		table.insert(tSortedHeroes, allSkill[i])
	end
	for i=1, #relationship do
		table.insert(tSortedHeroes, relationship[i])
	end
	for i=1, #arrStarLevelHeroesRead do
		table.insert(tSortedHeroes, arrStarLevelHeroesRead[i])
	end
	for i=1, #arrStarLevelHeroesOrange do
		table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
	end
	for i=1, #arrStarLevelHeroesPurple do
		table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
	end
	for i=1, #arrStarLevelHeroesKohlrabiblue do
		table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
	end
	for i=1, #arrStarLevelHeroesGreen do
		table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
	end
	for i=1, #arrStarLevelHeroesWhite do
		table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
	end
	
	if self.current_type == self.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
		local result = {}
		for k,v in pairs(tSortedHeroes) do
			if v.inResourceFromation ~= true then
				if self.chooseShips ~= nil then
					local isChoose = false
					for k1,v1 in pairs(self.chooseShips) do
						if v1 ~= nil and tonumber(v1.ship_base_template_id) == tonumber(v.ship_base_template_id) then
							isChoose = true
						end
					end
					if isChoose == false then
						table.insert(result, v)
					end
				else
					table.insert(result, v)
				end
			end
		end
		return result
	else
		return tSortedHeroes
	end
end

function HeroFormationChoiceWear.loading(texture)
	local myListView = HeroFormationChoiceWear.myListView
	if myListView ~= nil then
		local cell = HeroFormationChoiceWear:createHeroWear(HeroFormationChoiceWear.tSortedHeroes[HeroFormationChoiceWear.asyncIndex],HeroFormationChoiceWear._self.current_type,HeroFormationChoiceWear._self.shipId, HeroFormationChoiceWear.asyncIndex)
		table.insert(HeroFormationChoiceWear._self.roots, cell.roots[1])
		myListView:addChild(cell)
		HeroFormationChoiceWear.asyncIndex = HeroFormationChoiceWear.asyncIndex + 1
		-- myListView:requestRefreshView()
	end
end

function HeroFormationChoiceWear:onUpdateDraw(mSortHeros)
	local root = self.roots[1]
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon
		or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local image_hidden_or_show = ccui.Helper:seekWidgetByName(root, "image_hidden_or_show")
		if image_hidden_or_show ~= nil then
			if self.isShowFightHero == true then
				image_hidden_or_show:setVisible(false)
			else
				image_hidden_or_show:setVisible(true)
			end
		end
	elseif __lua_project_id == __lua_project_yugioh then
		local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
		if self.isShowFightHero == true then
			Image_3:setVisible(false)
		else
			Image_3:setVisible(true)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
	end
	
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_list")

	
	-- for i, v in ipairs(self:getSortedHeroes()) do
	-- 	local cell = HeroFormationChoiceWear:createHeroWear(v,self.current_type,self.shipId)
	-- 	table.insert(self.roots, cell.roots[1])
	-- 	listview:addChild(cell)
	-- 	-- listview:pushBackDefaultItem()
	-- end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		listview:removeAllItems()
	end
	HeroFormationChoiceWear._self = self
	HeroFormationChoiceWear.myListView = listview
	HeroFormationChoiceWear.tSortedHeroes = mSortHeros and mSortHeros or self:getSortedHeroes()
	HeroFormationChoiceWear.asyncIndex = 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		--or __lua_project_id == __lua_project_l_pokemon 
		-- or __lua_project_id == __lua_project_onepiece 
		or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(HeroFormationChoiceWear.tSortedHeroes) do
			--print("传入的type是...........",HeroFormationChoiceWear._self.current_type)
			local cell = HeroFormationChoiceWear:createHeroWear(v, HeroFormationChoiceWear._self.current_type,HeroFormationChoiceWear._self.shipId, i)
			table.insert(HeroFormationChoiceWear._self.roots, cell.roots[1])
			--cell:init(v, i)--?这里传的是个什么意思？我了个去。。。
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(listview, HeroFormationWearListCell.__size)
				listview:addChild(multipleCell)
				multipleCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = multipleCell
				end
			end
			multipleCell:addNode(cell)
			if multipleCell.child2 ~= nil then
				preMultipleCell = multipleCell
				multipleCell = nil
			end
		end
		self.currentListView = listview
		self.currentInnerContainer = self.currentListView:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
		listview:requestRefreshView()
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2  or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		listview:setVisible(false)
		self:createScollView(mSortHeros)
	else
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		for i, v in ipairs(HeroFormationChoiceWear.tSortedHeroes) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end

	-- DB2重塑,敬请期待显示处理
	self:showCoomingSoon()
end

function HeroFormationChoiceWear:createScollView(mSortHeros)
	local m_ScrollView = ccui.Helper:seekWidgetByName(self.roots[1], "ScrollView_generals")
	local tSortedHeroes = mSortHeros and mSortHeros or self:getSortedHeroes()
	m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/3
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	if zstring.tonumber(_ED.server_review) == 1 then
    		wPosition = sWidth/3
    	else
    		wPosition = sWidth/2
    	end
    end
    local Hlindex = 0
    local number = #tSortedHeroes
    local m_number = math.ceil(number/3)
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	if zstring.tonumber(_ED.server_review) == 1 then
    		m_number = math.ceil(number/3)
    	else
    		m_number = math.ceil(number/2)
    	end
    end
    --172 cell的高度，暂时写死 50分割线的高度
    cellHeight = m_number*172
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	if zstring.tonumber(_ED.server_review) == 1 then
    		cellHeight = m_number*420 + 30
    	else
    		cellHeight = m_number*146
		end
	elseif __lua_project_id == __lua_project_l_digital then 
		-- DSC重塑   
		cellHeight = m_number*221
    end
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    for j, v in pairs(tSortedHeroes) do
        local cell = HeroFormationChoiceWear:createHeroWear(v, HeroFormationChoiceWear._self.current_type,HeroFormationChoiceWear._self.shipId, j)
		table.insert(HeroFormationChoiceWear._self.roots, cell.roots[1])
	    local issoul = self:onHideHeroCell(v)
	    if issoul then
	    	if cell.roots[1] then
	    		ccui.Helper:seekWidgetByName(cell.roots[1], "Button_hecheng"):setVisible(false)
	    	end
	    end
        panel:addChild(cell)
        cell_height = cell:getContentSize().height
        tWidth = tWidth + wPosition
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        	if zstring.tonumber(_ED.server_review) == 1 then
	        	if (index-1)%3 ==0 then
		            Hlindex = Hlindex+1
		            tWidth = 0
		            tHeight = sHeight - cell_height*Hlindex  
		        end
		        if index <= 3 then
		            tHeight = sHeight - cell_height
		        end
		    else
	        	if (index-1)%2 ==0 then
		            Hlindex = Hlindex+1
		            tWidth = 0
		            tHeight = sHeight - cell_height*Hlindex  
		        end
		        if index <= 2 then
		            tHeight = sHeight - cell_height
		        end
		    end
	    else
	        if (index-1)%3 ==0 then
	            Hlindex = Hlindex+1
	            tWidth = 0
	            tHeight = sHeight - cell_height*Hlindex  
	        end
	        if index <= 3 then
	            tHeight = sHeight - cell_height
	        end
	   	end
        cell:setPosition(cc.p(tWidth,tHeight))
        index = index + 1
    end

    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()
end

function HeroFormationChoiceWear:onHideHeroCell(ship)
    if not _ED.soul_warding_formation_hero then
    	return false
    end

    if _ED.soul_warding_formation_hero then
		for k,v in pairs(_ED.soul_warding_formation_hero) do
			if tonumber(v.onUseShipMouldId) ==  tonumber(ship.ship_template_id)  then
               return true				
			end
		end
		return false
	end
end


function HeroFormationChoiceWear:onUpdate(dt)
	if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2  or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		if self.currentScrollView ~= nil and self.currentScrollViewInnerContainer ~= nil then
	        local size = self.currentScrollView:getContentSize()
	        local posY = self.currentScrollViewInnerContainer:getPositionY()
	        if self.currentScrollViewInnerContainerPosY == posY then
	            return
	        end
	        self.currentScrollViewInnerContainerPosY = posY
	        local items = self.currentScrollView:getChildren()
	        if items[1] == nil then
	            return
	        end
	        local itemSize = items[1]:getContentSize()
	        for i, v in pairs(items) do
	            local tempY = v:getPositionY() + posY
	            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
	                v:unload()
	            else
	                v:reload()
	            end
	        end
	    end
	else
		if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
			local size = self.currentListView:getContentSize()
			local posY = self.currentInnerContainer:getPositionY()
			if self.currentInnerContainerPosY == posY then
				return
			end
			self.currentInnerContainerPosY = posY
			local items = self.currentListView:getItems()
			if items[1] == nil then
				return
			end
			local itemSize = items[1]:getContentSize()
			for i, v in pairs(items) do
				local tempY = v:getPositionY() + posY
				if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
					v:unload()
				else
					v:reload()
				end
			end
		end
	end
end

function HeroFormationChoiceWear:onEnterTransitionFinish()
	app.load("client.cells.ship.hero_formation_wear_list_cell")
    local csbEquipStorage = csb.createNode("packs/HeroStorage/generals_Choice.csb")
	self:addChild(csbEquipStorage)
	local root = csbEquipStorage:getChildByName("root")
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.isShowFightHero = true
	end
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		app.load("client.player.UserInformationHeroStorage")
		-- fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		local userInformationHeroStorage = UserInformationHeroStorage:new()
		userInformationHeroStorage._rootWindows = self
		fwin:open(userInformationHeroStorage,fwin._view)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fanhui_lwj"), nil, {terminal_name = "hero_formation_choice_back", terminal_state = 0, _data = nil, isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_Check"), nil, {terminal_name = "hero_choice_show_fight_hero", terminal_state = 0}, nil, 0)
	
	-- 英雄排序
	self.Panel_heroFilter = ccui.Helper:seekWidgetByName(root, "Panel_heroFilter")
	-- generals_Choice.csb trae Panel_heroFilter y Panel_filterWindow con el
	-- toque ENCENDIDO y por encima de la lista (son los ultimos hijos de
	-- Panel_20). Esta ventana no usa Panel_filterWindow para nada y de
	-- Panel_heroFilter solo cuelgan Button_filter y la ventana de filtro, que
	-- tienen su propio toque: como paneles solo se tragaban los toques de la
	-- lista y ningun "Despachar" respondia. Apagar el toque del contenedor no
	-- apaga el de sus hijos.
	for _, panelName in ipairs({"Panel_heroFilter", "Panel_filterWindow"}) do
		local panel = ccui.Helper:seekWidgetByName(root, panelName)
		if panel ~= nil then
			panel:setTouchEnabled(false)
		end
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_filter"), nil, 
	{
		terminal_name = "hero_choice_show_go_sort_view", 
		terminal_state = 0
	}, nil, 0)

end

function HeroFormationChoiceWear:init(_data,_type,_ship_id, choose_ships, call_join_terminal_name, cell_index)
	--print("-----------------------------------------------------------",_ship_id)
	self._data = _data
	self.current_type = _type
	self.shipId = _ship_id
	self.call_join_terminal_name = call_join_terminal_name
	self.cell_index = cell_index
	if choose_ships ~= nil then
		self.chooseShips = choose_ships
	end
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	return self
end

function HeroFormationChoiceWear:onExit()
	HeroFormationChoiceWear.myListView = nil
	HeroFormationChoiceWear.asyncIndex = 1
	self.hero_formation_cells = nil
	state_machine.remove("hero_formation_choice_back")
	state_machine.remove("request_choice_hero_the_battle")
	state_machine.remove("hero_choice_show_fight_hero")
	state_machine.remove("request_choice_hero_update")
	state_machine.remove("hero_choice_show_go_sort_view")
	--state_machine.remove("choice_hero_battle_request")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function HeroFormationChoiceWear:createCell()
	local Equip = HeroFormationChoiceWear:new()
	Equip:registerOnNodeEvent(Equip)
	return Equip
end
