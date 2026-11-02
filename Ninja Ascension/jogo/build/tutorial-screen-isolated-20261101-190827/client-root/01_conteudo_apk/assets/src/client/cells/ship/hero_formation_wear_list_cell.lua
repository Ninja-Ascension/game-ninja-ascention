----------------------------------------------------------------------------------------------------
-- 说明：武将上阵列表控件
-------------------------------------------------------------------------------------------------------
HeroFormationWearListCell = class("heroFormationWearListCellClass", Window)
HeroFormationWearListCell.__size = nil

function HeroFormationWearListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.ship = nil
	self.current_type = 0
	self.instatsShipId = nil
	self.enum_type = {
		_THE_BATTLE_OF_WARSHIPS_ONLY = 1,	-- 上阵出战船只
		_THE_BATTLE_OF_SMALL_PARTNERS = 2,	-- 上阵小伙伴
		_THE_BATTLE_RESOURCE_PARTNERS = 3,	-- 资源抢夺上阵
		_THE_REBIRTH_CHOOSE = 4,	-- 重生选择
		_THE_EM_SHIPS = 5,	-- 噩梦副本上阵英雄选择
		_THE_SOUL_WARDING = 6,	--灵魂守卫上阵
	}
	app.load("client.l_digital.cultivate.soulward.SoulWardingWindow")
	app.load("client.packs.FightSpirit.FightSpiritReplaceConfirm")

    local function init_hero_formation_wear_list_cell_terminal()

		local choice_hero_the_battle_request_terminal = {
            _name = "choice_hero_the_battle_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            --print("开始换英雄拉............................")
            	local ship = params._datas._ship
            	if __lua_project_id == __lua_project_yugioh then
	            	if zstring.tonumber(ship.little_partner_formation_index) > 0 or
						zstring.tonumber(ship.formation_index) > 0 then
						TipDlg.drawTextDailog(_string_piece_info[381])
						return
					end
				end
				state_machine.excute("request_choice_hero_the_battle", 0, ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local choice_hero_the_partners_request_terminal = {
            _name = "choice_hero_the_partners_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            --print("开始换小伙伴拉............................")
				state_machine.excute("request_choice_hero_the_partners", 0, params._datas._ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
  
  		--确认是否替换战魂
  		local choice_hero_replace_fight_spirit_terminal = {
            _name = "choice_hero_replace_fight_spirit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,

            _state = 0,
			_invoke = function(terminal, instance, params)
				local canReplace = false
				if _ED.all_ship_fight_spirit_info[tonumber(instance.instatsShipId)] then 
					for i,v in ipairs(_ED.all_ship_fight_spirit_info[tonumber(instance.instatsShipId)]) do
						if tonumber(v) ~= -1 then 
							canReplace = true
							break
						end
					end
				end

            	if instance.instatsShipId and tonumber(instance.instatsShipId) > 0 and canReplace then
	            	state_machine.excute("fight_spirit_replace_confirm_window_open", 0, {
	            		next_terminal_name = params._datas.next_terminal_name,
	            		ship = params._datas._ship,
	            	})
	            else
	            	state_machine.excute(params._datas.next_terminal_name, 0, {_datas = {_ship = params._datas._ship}})
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(choice_hero_the_battle_request_terminal)
		state_machine.add(choice_hero_the_partners_request_terminal)
		state_machine.add(choice_hero_replace_fight_spirit_terminal)
        state_machine.init()
    end
    
    init_hero_formation_wear_list_cell_terminal()
end

function HeroFormationWearListCell:createHeadHead(ship,objectType)
	app.load("client.cells.ship.ship_head_new_cell")
	local cell = ShipHeadNewCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function HeroFormationWearListCell:onUpdateDraw()
	local root = self.roots[1]

	local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
	
	--画头像
	local heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		ccui.Helper:seekWidgetByName(root, "Panel_wujiang"):setVisible(false)
		heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_juese_01")
	end
	heroIcon:removeAllChildren(true)

	if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		local evo_mould_id = smGetSkinEvoIdChange( self.ship )
		picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		local Panel_prop_icon = cc.Sprite:create(string.format("images/face/big_head/big_head_%d.png", "".. picIndex))
		if Panel_prop_icon ~= nil then
			Panel_prop_icon:setPosition(cc.p(heroIcon:getContentSize().width/2,heroIcon:getContentSize().height/2))
			heroIcon:addChild(Panel_prop_icon)
		end
	else
		local picCell = nil
		if __lua_project_id == __lua_project_gragon_tiger_gate then--这个地方新数码用2
			picCell = HeroFormationWearListCell:createHeadHead(self.ship, 9)
		else
			picCell = HeroFormationWearListCell:createHeadHead(self.ship, 2)
		end
		heroIcon:addChild(picCell)
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local btn_onthecamp = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
		local Image_ysz = ccui.Helper:seekWidgetByName(root, "Image_ysz")
		Image_ysz:setVisible(false)
		btn_onthecamp:setBright(true)
		btn_onthecamp:setTouchEnabled(true)
		if _ED.activity_battle_copy_formation_limit ~= nil then
			local camp_preference = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.camp_preference)
            if _ED.activity_battle_copy_formation_limit == camp_preference then
            	btn_onthecamp:setBright(true)
				btn_onthecamp:setTouchEnabled(true)
			else
				btn_onthecamp:setBright(false)
				btn_onthecamp:setTouchEnabled(false)	
            end
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			else
				if self.ship.formation_index ~= nil then
					if tonumber(self.ship.formation_index) > 0 then	
						btn_onthecamp:setBright(false)
						btn_onthecamp:setTouchEnabled(false)
					end
				end
				if self.ship.little_partner_formation_index ~= nil then
					if tonumber(self.ship.little_partner_formation_index) > 0  then
						btn_onthecamp:setBright(false)
						btn_onthecamp:setTouchEnabled(false)
					end
				end
			end
			if self.current_type == self.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
				btn_onthecamp:setBright(true)
				btn_onthecamp:setTouchEnabled(true)
			end
		end
		for i,v in pairs(_ED.user_formetion_status) do
			if tonumber(self.ship.ship_id) == tonumber(v) then
				Image_ysz:setVisible(true)
				break
			end
		end
		local Text_fighting_n_0 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_0")
		if Text_fighting_n_0 ~= nil then
			local ship_id = self.ship.ship_template_id
			if _ED.user_ship_praise_rank_list ~= nil 
				and _ED.user_ship_praise_rank_list[""..ship_id] ~= nil
				then
				local rank = tonumber(_ED.user_ship_praise_rank_list[""..ship_id].rank)
				if rank <= 10 then
					Text_fighting_n_0:setString(_ED.user_ship_praise_rank_list[""..ship_id].count.."(NO."..rank..")")
				else
					Text_fighting_n_0:setString(_ED.user_ship_praise_rank_list[""..ship_id].count)
				end
			else
				Text_fighting_n_0:setString("0")
			end
			if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
				Text_fighting_n_0:setVisible(false)
			end
		end
	end
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
	-- 	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1"), nil, 
	-- 	{
	-- 		terminal_name = "ship_head_new_cell_show_hero_info", 
	-- 		terminal_state = 0, 
	-- 		_self = picCell, 
	-- 		_ship = self.ship,
	-- 		from_type = 9
	-- 	}, 
	-- 	nil, 0)
	-- end
	--画名称
	local heroName = ccui.Helper:seekWidgetByName(root, "Text_dengji")
	local rankLevelFront = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
	local str = ""
	if rankLevelFront ~= 0 then
		str = " +"..rankLevelFront
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.ship.evolution_status, "|")
		local evo_mould_id = smGetSkinEvoIdChange(self.ship)
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		_name = word_info[3]
		if getShipNameOrder(tonumber(self.ship.Order)) > 0 then
	        _name = _name.." +"..getShipNameOrder(tonumber(self.ship.Order))
	    end
		heroName:setString(_name .. str)
		local quality = 1
	    quality = shipOrEquipSetColour(tonumber(self.ship.Order))
	    local color_R = tipStringInfo_quality_color_Type[quality][1]
	    local color_G = tipStringInfo_quality_color_Type[quality][2]
	    local color_B = tipStringInfo_quality_color_Type[quality][3]
	    heroName:setColor(cc.c3b(color_R, color_G, color_B))
	else
		heroName:setString(dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name) .. str)
		heroName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	end
	
	--画等级
	--[[local heroLV = ccui.Helper:seekWidgetByName(root, "Text_333")
	if verifySupportLanguage(_lua_release_language_en) == true then
		heroLV:setString(_string_piece_info[6]..self.ship.ship_grade)
	else
		heroLV:setString(self.ship.ship_grade.._string_piece_info[6])
	end
	
	-- 取出当前武将的合计技
	local zoariumSkill = dms.int(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.zoarium_skill)
	local step = false
	local heroFetters = ccui.Helper:seekWidgetByName(root, "Text_41")
	heroFetters:setString("")
	local temp = nil
	local ser = 0
	local inPreson = {}
	local num = 1
	local otherId = -1
	
	-- 如果存在合计技则遍历已上阵武将
	if zoariumSkill > 0 then
		--画是否有合击
		for i,v in pairs(_ED.user_ship) do
			-- 遍历出已上阵的武将
			if zstring.tonumber(v.formation_index) > 0 then

				if self.instatsShipId == nil or self.current_type ==self.enum_type._THE_BATTLE_OF_SMALL_PARTNERS then
					-- 援军时,不显示合击处理
					--inPreson[num] = v.ship_base_template_id
					--num = num + 1
				else
					if tonumber(v.ship_id) ~= tonumber(self.instatsShipId) then
						inPreson[num] = v.ship_base_template_id
						num = num + 1
					end
				
				end
			end
		end
	
		-- 取出与当前武将可生成合击技对应的id
		local person_s = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould)
		if person_s ~= nil then
			local step_s = zstring.split(person_s,",")
			
			local number = table.getn(step_s)
			-- 取合击技中武将id -> n
			for j,n in pairs(step_s) do
				
				-- 遍历上阵武将id -> v
				for i, v in pairs(inPreson) do
					-- 检查自己在表中,对方也在表中
					if tonumber(n) == tonumber(v) or tonumber(n) == tonumber(self.ship.ship_base_template_id) then
						
						-- 找到对方的id
						if tonumber(n) ~= tonumber(self.ship.ship_base_template_id)  then
							otherId = tonumber(n)
							self.jointPartnerID = otherId
						end
						
						-- 匹配则+1
						ser = ser + 1
						break
					end
				end
			end
			-- 合击统计的人数和当前自己与上阵可合击人数一致
			if ser > 0 and number > 0 and ser == number then
				step = true
				
				-- 取出当前合击对方的名字
				local shipName = ""
				if otherId > 0 then
					
					local ship = fundShipWidthBaseTemplateId(otherId)
					shipName = ship.captain_name
					
				end
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
				 	or __lua_project_id == __lua_project_yugioh then 
				 	--舰娘不用
					heroFetters:setString(_string_piece_info[366])
				else
					heroFetters:setString(string.format(_string_piece_info[366], shipName))
          		end		
			else
				heroFetters:setString(" ")
			end
		end
	end
	
	
	
	--是否缘分激活
	local fettersNumber = 0
	local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], self.ship.ship_base_template_id, ship_mould.relationship_id), ",")
	local inStates = {}
	local ter = 1
	for i, v in pairs(_ED.user_ship) do
	
		if self.current_type ==self.enum_type._THE_BATTLE_OF_SMALL_PARTNERS  then
			if zstring.tonumber(v.formation_index) > 0 then
		
				if self.instatsShipId == nil then
						inStates[ter] = v.ship_base_template_id
						ter = ter + 1
				else
					if tonumber(v.ship_id) ~= tonumber(self.instatsShipId) then
						inStates[ter] = v.ship_base_template_id
						ter = ter + 1
					end
				
				end
			end
		
		else
			if zstring.tonumber(v.formation_index) > 0 or zstring.tonumber(v.little_partner_formation_index) > 0 then
				if __lua_project_id == __lua_project_yugioh then
					inStates[ter] = v.ship_base_template_id
					ter = ter + 1
				else
					if self.instatsShipId == nil then
							inStates[ter] = v.ship_base_template_id
							ter = ter + 1
					else
						if tonumber(v.ship_id) ~= tonumber(self.instatsShipId) then
							inStates[ter] = v.ship_base_template_id
							ter = ter + 1
						end
					
					end
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

			if __lua_project_id == __lua_project_yugioh then
				if (table.getn(person)-1 == sss or table.getn(person) - 1 > 0) and sss > 1 then
					fettersNumber = fettersNumber + 1
				end
			else
				if table.getn(person)-1 == sss and table.getn(person) - 1 > 0 and sss > 0 then
					fettersNumber = fettersNumber + 1
				end
			end
		end
	end
	
	-- 援军不遍历装备缘分
	if self.current_type ~=self.enum_type._THE_BATTLE_OF_SMALL_PARTNERS  then
	
		--   与装备有关的缘分(不包含合击技)
		-- self.instatsShipId 武将实例id
		--  _ED.user_ship[self.instatsShipId]  武将实例
		--  _ED.user_ship[self.instatsShipId].equipment  武将装备集合
		local equip = {}
		if self.instatsShipId ~= nil and _ED.user_ship[self.instatsShipId] ~= nil and _ED.user_ship[self.instatsShipId].equipment ~= nil then
			local cc = 1
			for i, v in pairs(_ED.user_ship[self.instatsShipId].equipment) do
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
	
	end

	if fettersNumber>0 and step == false then
		heroFetters:setString("(".._string_piece_info[67]..fettersNumber..")")
	end
	if self.current_type == self.enum_type._THE_BATTLE_RESOURCE_PARTNERS then
		heroFetters:setString("")
	end]]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--战力
		local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
		Text_fighting_n:setVisible(true)
		if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
			Text_fighting_n:setVisible(false)
		end
		local Text_fighting = ccui.Helper:seekWidgetByName(root, "Text_fighting")
		Text_fighting:setVisible(true)

		local heroFightVal = self.ship.hero_fight
		if heroFightVal == nil or heroFightVal == "" then 
			heroFightVal = getShipByTalent(self.ship).hero_fight
		end
		Text_fighting_n:setString(heroFightVal)
		
		local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
		Panel_strengthen_stye:removeBackGroundImage()
		local camp_preference = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.camp_preference)
		if camp_preference> 0 and camp_preference <=3 then
			Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
		end
		
		-- 组合卡锁定
		local Image_ysd = ccui.Helper:seekWidgetByName(root, "Image_ysd")
		if Image_ysd and self.ship.combLockState and 1 == tonumber(self.ship.combLockState) then 
			local Button_hecheng = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
			Button_hecheng:setVisible(false)
			Image_ysd:setVisible(true)
		else
			if self.current_type == self.enum_type._THE_REBIRTH_CHOOSE then
				local Button_hecheng = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
				Button_hecheng:setVisible(true)
				Button_hecheng:setBright(true)
				Button_hecheng:setTouchEnabled(true)
				-- DSC重塑
				self:setBtnText(_new_interface_text[276])
			else
				local isGoBattle = false
				local temp_user_ship = {}
				table.add(temp_user_ship, _ED.user_formetion_status)
				if self.current_type == 5 then
					temp_user_ship = {}
					table.add(temp_user_ship, _ED.em_user_ship)
				end
				for i,v in pairs(temp_user_ship) do
					if tonumber(v) == tonumber(self.ship.ship_id) then
						isGoBattle = true
						break
					end
				end
				if isGoBattle == true then
					ccui.Helper:seekWidgetByName(root, "Button_hecheng"):setVisible(false)
				else
					ccui.Helper:seekWidgetByName(root, "Button_hecheng"):setVisible(true)
				end
			end

		end
		
	end
	local Image_soul_warding  =  ccui.Helper:seekWidgetByName(root, "Image_soul_warding")
    if Image_soul_warding then
    	Image_soul_warding:setVisible(false)
    end
	if _ED.soul_warding_formation_hero then
		for k,v in pairs(_ED.soul_warding_formation_hero) do
			if tonumber(v.onUseShipMouldId) ==  tonumber(self.ship.ship_template_id)  then
				ccui.Helper:seekWidgetByName(root, "Button_hecheng"):setVisible(false)
                ccui.Helper:seekWidgetByName(root, "Image_soul_warding"):setVisible(true)
			end
		end
	end
end

-- DSC重塑 设置按钮文字
function HeroFormationWearListCell:setBtnText(_str)
	local root = self.roots[1]
	local Text_1_0_0_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0_0_0")
	if __lua_project_id == __lua_project_l_digital and Text_1_0_0_0 then 
		Text_1_0_0_0:setString(_str)
		ccui.Helper:seekWidgetByName(root, "Button_hecheng"):setTitleText("")
	else
		ccui.Helper:seekWidgetByName(root, "Button_hecheng"):setTitleText(_str)
	end
end

function HeroFormationWearListCell:onEnterTransitionFinish()
end

function HeroFormationWearListCell:onInit()
 --    local csbEquipListCell = csb.createNode("list/list_generals_Wear.csb")
	-- --self:addChild(csbEquipListCell)
	-- --local root = csbEquipListCell:getChildByName("root")
	-- --table.insert(self.roots, root)

	local root = cacher.createUIRef("packs/HeroStorage/sm_list_generals_big.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	if HeroFormationWearListCell.__size == nil then
		local MySize = root:getContentSize()
		HeroFormationWearListCell.__size = MySize
	end
	
	self:clearUIInfo()

	-- DSC重塑
	self:setBtnText(_new_interface_text[236])
	if self.current_type == self.enum_type._THE_BATTLE_OF_SMALL_PARTNERS then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hecheng"), nil, {terminal_name = "choice_hero_the_partners_request", terminal_state = 0, _ship = self.ship, isPressedActionEnabled = true}, nil, 0)
	elseif self.current_type == self.enum_type._THE_REBIRTH_CHOOSE then
		-- DSC重塑
		self:setBtnText(_new_interface_text[276])
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hecheng"), nil, {terminal_name = "sm_role_infomation_rebirth_update_ship", terminal_state = 0, _ship = self.ship, isPressedActionEnabled = true}, nil, 0)
	elseif self.current_type == self.enum_type._THE_SOUL_WARDING then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hecheng"), nil, {terminal_name = "soul_warding_window_change", terminal_state = 0, _ship = self.ship, isPressedActionEnabled = true}, nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hecheng"), nil, {
		terminal_name = "choice_hero_replace_fight_spirit", 
		next_terminal_name = "choice_hero_the_battle_request", 
		terminal_state = 0, 
		_ship = self.ship, 
		isPressedActionEnabled = true}, nil, 0)
	end

	self:onUpdateDraw()
end

function HeroFormationWearListCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("packs/HeroStorage/sm_list_generals_big.csb", self.roots[1])
end

function HeroFormationWearListCell:init(_ship,_type,id, index)
	self.ship = _ship
	self.current_type = _type
	self.instatsShipId = id			--被换下的武将id
	--print("---------------------------------,被换下的武将id,换英雄是1，小伙伴是2",id,_type,index)
	if index~= nil and index < 11 then
		self:onInit()
	end
	self:setContentSize(HeroFormationWearListCell.__size)
	return self
end

function HeroFormationWearListCell:clearUIInfo( ... )
	local root = self.roots[1]
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	if __lua_project_id == __lua_project_l_pokemon and zstring.tonumber(_ED.server_review) == 1 then
		local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_juese_01")
		if headPanel ~= nil then
			headPanel:removeAllChildren(true)
		end
	end
	if headPanel ~= nil then
		headPanel:removeAllChildren(true)
	end
	local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
	if Panel_strengthen_stye ~= nil then
		Panel_strengthen_stye:removeBackGroundImage()
		Panel_strengthen_stye:removeAllChildren(true)
	end
	local Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
	if Button_qianghua ~= nil then
		if __lua_project_id == __lua_project_l_digital then
			--
		else
			Button_qianghua:removeAllChildren(true)
		end
		Button_qianghua:setVisible(false)
	end
	local Button_zhuangbei = ccui.Helper:seekWidgetByName(root, "Button_zhuangbei")
	if Button_zhuangbei ~= nil then
		if __lua_project_id == __lua_project_l_digital then
			--
		else
			Button_zhuangbei:removeAllChildren(true)
		end
		Button_zhuangbei:setVisible(false)
	end
	local LoadingBar_number = ccui.Helper:seekWidgetByName(root, "LoadingBar_number")
	if LoadingBar_number ~= nil then
		LoadingBar_number:setPercent(0)
	end
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	if Text_number ~= nil then
		Text_number:setString("")
	end
	local Image_loadingbar_bg = ccui.Helper:seekWidgetByName(root, "Image_loadingbar_bg")
	if Image_loadingbar_bg ~= nil then
		Image_loadingbar_bg:setVisible(false)
	end
	local Text_fighting = ccui.Helper:seekWidgetByName(root, "Text_fighting")
	if Text_fighting ~= nil then
		Text_fighting:setVisible(false)
	end
	local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
	if Text_fighting_n ~= nil then
		Text_fighting_n:setVisible(false)
	end
	local Button_shangzhen = ccui.Helper:seekWidgetByName(root, "Button_shangzhen")
	if Button_shangzhen ~= nil then
		Button_shangzhen:setVisible(false)
	end
	local Button_hecheng = ccui.Helper:seekWidgetByName(root, "Button_hecheng")
	if Button_hecheng ~= nil then
		Button_hecheng:setVisible(false)
	end
	local Button_laiyuan = ccui.Helper:seekWidgetByName(root, "Button_laiyuan")
	if Button_laiyuan ~= nil then
		Button_laiyuan:setVisible(false)
	end

	-- 组合卡已锁定
	local Image_ysd = ccui.Helper:seekWidgetByName(root, "Image_ysd")
	if Image_ysd then
		Image_ysd:setVisible(false)
	end
end

function HeroFormationWearListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeroFormationWearListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("packs/HeroStorage/sm_list_generals_big.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
	self.csbHeroSell = nil
end

function HeroFormationWearListCell:createCell()
	local cell = HeroFormationWearListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
