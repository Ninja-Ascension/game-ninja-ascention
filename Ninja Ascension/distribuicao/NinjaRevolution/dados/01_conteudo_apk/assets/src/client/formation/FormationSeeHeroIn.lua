-- ----------------------------------------------------------------------------------------------------
-- 说明：阵容武将信息面板显示
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FormationSeeHeroIn = class("FormationSeeHeroInClass", Window)
FormationSeeHeroIn.__userHeroFontName = nil
function FormationSeeHeroIn:ctor()
    self.super:ctor()
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_SMALL_PARTNER_INFORMATION = 1,				-- 小伙伴的武将信息
	}
	self.hero = nil
	self.shipArray = {}
	self.formationPosition = nil -- 武将所在的位置
	self.pageindex = 0 
	
    -- Initialize HeroInformation state machine.
    local function init_formation_see_heroIn_terminal()
	
		--返回阵容界面
		local return_to_the_squad_screen_terminal = {
            _name = "return_to_the_squad_screen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)	--关闭自己	
                fwin:close(fwin:find("HeroInformationClass"))			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		-- 武将更换
		local hero_info_formation_replacement_hero_terminal = {
            _name = "hero_info_formation_replacement_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)	--关闭自己	
				app.load("client.packs.hero.HeroFormationChoiceWear")
				local HeroFormationChoiceWearWindow = HeroFormationChoiceWear:new()
				HeroFormationChoiceWearWindow:init(params._datas._data, nil, params._datas._ship.ship_id)
				fwin:open(HeroFormationChoiceWearWindow, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		-- 小伙伴更换
		local replacement_of_small_partners_terminal = {
            _name = "replacement_of_small_partners",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				 fwin:close(instance)	--关闭自己	
				app.load("client.packs.hero.HeroFormationChoiceWear")
				local HeroFormationChoiceWearWindow = HeroFormationChoiceWear:new()
				
				HeroFormationChoiceWearWindow:init(params._datas._data,2)
				fwin:open(HeroFormationChoiceWearWindow, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		
		-- 小伙伴卸下
		local remove_the_small_partners_terminal = {
            _name = "remove_the_small_partners",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local paramList = params._datas._ship.."|".."0"
				fwin:close(instance)	--关闭自己	
				state_machine.excute("choice_hero_partners_request", 0, paramList)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		
		--英雄音效播放按钮
		local formation_hero_formation_play_hero_music_terminal = {
            _name = "formation_hero_formation_play_hero_music",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local tempMusicIndex = dms.int(dms["ship_mould"], instance.hero.ship_template_id, ship_mould.sound_index)
					--> print("33333333333333333333333333333333333333333333333", self.hero.ship_template_id,tempMusicIndex)
					if tempMusicIndex ~= nil and tempMusicIndex > 0  then
						playEffect(formatMusicFile("effect", tempMusicIndex))
					end
	
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

		state_machine.add(return_to_the_squad_screen_terminal)	
		state_machine.add(hero_info_formation_replacement_hero_terminal)	
		state_machine.add(formation_hero_formation_play_hero_music_terminal)	
		state_machine.add(remove_the_small_partners_terminal)
		state_machine.add(replacement_of_small_partners_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_formation_see_heroIn_terminal()
end

function FormationSeeHeroIn:createShipBody(ship,objectType)
	local cell = ShipBodyCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function FormationSeeHeroIn:onUpdateDraw()
	local root = self.roots[1]
	
	local hero_name = _ED.user_info.user_name
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")			--武将名字
	local Panel_pinz = ccui.Helper:seekWidgetByName(root, "Text_name")			--白将贴图
	local Text_zizhi = ccui.Helper:seekWidgetByName(root, "Text_zizhi")			--“资质”
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")			--ListView
	ListView_1:removeAllItems()
	ListView_1:requestRefreshView()
	local text_lv = ccui.Helper:seekWidgetByName(root, "Text_LV") --突破等级
	-- local panelWujiang = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	local Text_zizhi_0 = ccui.Helper:seekWidgetByName(root, "Text_zizhi_0") --资质
	
	local quality = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ship_type)
	local heroType = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.capacity)
	local ability = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ability)
	local camp_preference = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.camp_preference)
	local rankLevelFront = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.initial_rank_level)
	if rankLevelFront ~= 0 then
		text_lv:setString(" +"..rankLevelFront)
		text_lv:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	else
		text_lv:setString(" ")
	end
	ccui.Helper:seekWidgetByName(root, "Panel_zhenying"):removeBackGroundImage()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		ccui.Helper:seekWidgetByName(root, "Panel_zhenying"):setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", heroType))
	end
	
	if __lua_project_id == __lua_project_yugioh then
		local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
		local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
		Panel_shuxing:removeBackGroundImage()
		Panel_zhongzu:removeBackGroundImage()
		local faction_id = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.faction_id)
		local attribute_id = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.attribute_id)
		Panel_shuxing:setBackGroundImage(string.format("images/ui/quality/shuxing_%s.png", attribute_id))
		Panel_zhongzu:setBackGroundImage(string.format("images/ui/quality/zhongzu_%s.png", faction_id))
	end

	ccui.Helper:seekWidgetByName(root, "Panel_pinz"):removeBackGroundImage()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage(string.format("images/ui/quality/hero_name_quality_%d.png", quality))
	end
	ccui.Helper:seekWidgetByName(root, "Panel_neixing"):removeBackGroundImage()
	if tonumber(self.hero.captain_type) ~= 0 and camp_preference > 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_neixing"):setBackGroundImage(string.format("images/ui/quality/leixing_%d.png", camp_preference))	
	end
	if dms.int(dms["ship_mould"], tonumber(self.hero.ship_template_id), ship_mould.captain_type) == 0 then
		hero_name = self.hero.ship_name
	else
		hero_name = self.hero.captain_name
	end
	Text_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if ___is_open_leadname == true then
		if FormationSeeHeroIn.__userHeroFontName == nil then
			FormationSeeHeroIn.__userHeroFontName = Text_name:getFontName()
		end
		if dms.int(dms["ship_mould"], tonumber(self.hero.ship_template_id), ship_mould.captain_type) == 0 then
			Text_name:setFontName("")
			Text_name:setFontSize(Text_name:getFontSize())-->设置字体大小
			Text_name:setString(_ED.user_info.user_name)
		else
			Text_name:setFontName(FormationSeeHeroIn.__userHeroFontName)
		end
	end

	--数码宝贝进化形象
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		local ship_basic = dms.int(dms["ship_mould"], tonumber(self.hero.ship_template_id), ship_mould.base_mould)
		local current_ship = ship_basic
		for i=1,4 do
			local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_jh_" .. i)
			rolePanel:removeBackGroundImage()
			rolePanel:removeAllChildren(true)
			local imgIcon = ccui.Helper:seekWidgetByName(root, "Image_jt_" .. (i - 1))
			if imgIcon ~= nil then
				imgIcon:setVisible(false)
			end
			local next_ship_id = dms.int(dms["ship_mould"], current_ship, ship_mould.way_of_gain)
			if current_ship ~= -1 and current_ship ~= nil then
				local AllIcon = dms.int(dms["ship_mould"], current_ship, ship_mould.All_icon)
				rolePanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
				if imgIcon ~= nil then
					imgIcon:setVisible(true)
				end
			end
			current_ship = next_ship_id
		end
	end

	Text_name:setString(hero_name)
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		local isSelf = dms.int(dms["ship_mould"], tonumber(self.hero.ship_template_id), ship_mould.captain_type) == 0 
		if ___is_open_leadname == true and isSelf == false then 
			--繁体情况下，英雄名称读取本地配置
			local hero_name = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(self.hero.evolution_status, "|")
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				hero_name = word_info[3]
			else
				hero_name = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_name)
			end
			Text_name:setString(hero_name)
		end
	end
	Text_zizhi:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if __lua_project_id == __lua_project_yugioh then
		for i=1,12 do
			local Panel_start = ccui.Helper:seekWidgetByName(root, "Panel_start_"..i)
			Panel_start:removeBackGroundImage()
			if i <= tonumber(ability) then
				Panel_start:setBackGroundImage("images/ui/state/zizhi.png")
			end
		end
	else
		Text_zizhi_0:setString(ability)
		Text_zizhi_0:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	end
	-- local AllIcon = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.All_icon)
	-- panelWujiang:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
	
	---------缘分
	local drawLot = {}
	local number = self.hero.relationship_count							-- 缘分数量
	for i = 1, number do
		drawLot[i] = {}
		local relationship_id = self.hero.relationship[i].relationship_id		--缘分id
		local relationship_status = self.hero.relationship[i].is_activited			--是否激活
		local relationship_name = dms.string(dms["fate_relationship_mould"], relationship_id, fate_relationship_mould.relation_name)
		local relationship_describe = dms.string(dms["fate_relationship_mould"], relationship_id, fate_relationship_mould.relation_describe)
		drawLot[i][1] = relationship_status
		drawLot[i][2] = relationship_name
		drawLot[i][3] = relationship_describe
	end
	---------天赋
	local drawTalent = {}
	local tembNumber = self.hero.talent_count								-- 天赋数量
	for i = 1, tembNumber do
		drawTalent[i] = {}
		local talent_id = self.hero.talents[i].talent_id		--缘分id
		local talent_status = self.hero.talents[i].is_activited			--是否激活
		local talent_name = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_name)
		local talent_describe = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_describe)
		drawTalent[i][1] = talent_status
		drawTalent[i][2] = talent_name
		drawTalent[i][3] = talent_describe
	end
	
	---------
	for i =1, 6 do
		if i == 1 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			
			else
				local cell = HeroBaseInformation:createCell()
				cell:init(self.hero, "formation")
				ListView_1:addChild(cell)
			end	
		elseif i == 2 then
			local userfashion = nil 
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if dms.int(dms["ship_mould"], tonumber(self.hero.ship_template_id), ship_mould.captain_type) == 0 then
					local fashionEquip, pic = getUserFashion()
					if fashionEquip ~= nil and pic ~= nil then
						userfashion = fashionEquip
					end
				end
			end
			local cell = FormationHeroSkill:createCell()
			if userfashion ~= nil then
				cell:init(self.hero,userfashion,ListView_1:getPositionX())
			else
				cell:init(self.hero)
			end
			ListView_1:addChild(cell)
		elseif i == 3 then
			local cell = FormationHeroDestiny:createCell()
			cell:init(self.hero,  "formation")
			ListView_1:addChild(cell)
		elseif i == 4 then
			local cell = HeroLuckTalentExplain:createCell()
			cell:init(self.hero,i,drawLot)
			ListView_1:addChild(cell)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local cellSize = cell:getContentSize()
				cellSize.height = cellSize.height + 8
				cell:setContentSize(cellSize)
			end
		elseif i == 5 then
			local cell = HeroLuckTalentExplain:createCell()
			cell:init(self.hero,i,drawTalent)
			ListView_1:addChild(cell)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local cellSize = cell:getContentSize()
				cellSize.height = cellSize.height + 17
				cell:setContentSize(cellSize)
			end
		elseif i == 6 then
			local cell = HeroLuckTalentExplain:createCell()
			cell:init(self.hero,i,nil)
			ListView_1:addChild(cell)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local cellSize = cell:getContentSize()
				cellSize.height = cellSize.height + 17
				cell:setContentSize(cellSize)
			end
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_type) == 0 then
			ccui.Helper:seekWidgetByName(root, "Button_2"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root, "Button_2"):setBright(false)
		else
			ccui.Helper:seekWidgetByName(root, "Button_2"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_2"):setBright(true)
		end
	else
		if dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_type) == 0 then
			ccui.Helper:seekWidgetByName(root, "Button_2"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root, "Button_2"):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Button_2"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_2"):setVisible(true)
		end
	end

	local tempMusicIndex = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.sound_index)
	local playMusicVisible = false 
	if tempMusicIndex ~= nil and tempMusicIndex > 0  then
		playMusicVisible = true
	end
	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(playMusicVisible)
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--等级
		local Text_dj_1 = ccui.Helper:seekWidgetByName(root, "Text_dj_1") 
		Text_dj_1:setString(self.hero.ship_grade)
		
		local lv =ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lv")
		local lan=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lan")
		local zi=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_zi")
		local cheng=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_cheng")
		local hong=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_hong")
		if quality == 0 then
			--print("白色")
			lv:setVisible(false)
			lan:setVisible(false)
			zi:setVisible(false)
			cheng:setVisible(false)
			hong:setVisible(false)
		elseif quality == 1 then
			--print("绿色")
			lv:setVisible(true)
			lan:setVisible(false)
			zi:setVisible(false)
			cheng:setVisible(false)
			hong:setVisible(false)
		elseif quality == 2 then
			--print("蓝色")
			lv:setVisible(false)
			lan:setVisible(true)
			zi:setVisible(false)
			cheng:setVisible(false)
			hong:setVisible(false)
		elseif quality == 3 then
			--print("紫色")
			lv:setVisible(false)
			lan:setVisible(false)
			zi:setVisible(true)
			cheng:setVisible(false)
			hong:setVisible(false)
		elseif quality == 4 then
			--print("橙色")
			lv:setVisible(false)
			lan:setVisible(false)
			zi:setVisible(false)
			cheng:setVisible(true)
			hong:setVisible(false)
		elseif quality == 5 then
			--print("红色")
			lv:setVisible(false)
			lan:setVisible(false)
			zi:setVisible(false)
			cheng:setVisible(false)
			hong:setVisible(true)			
		end
	end
end

function FormationSeeHeroIn:showHeroIcon()
	local root = self.roots[1]
	local panelWujiang = ccui.Helper:seekWidgetByName(root, "Panel_21")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		local temp_bust_index = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			----------------------新的数码的形象------------------------
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.hero.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			--新的形象编号
			temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		else
			temp_bust_index = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.bust_index)
		end
		local shipPanel = panelWujiang
		panelWujiang:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        shipSpine:setScaleX(-1)
		    end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end
	elseif __lua_project_id == __lua_project_pokemon 
		then
		local temp_bust_index = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.bust_index)
		local shipPanel = panelWujiang
		panelWujiang:removeAllChildren(true)
		app.load("client.battle.fight.FightEnum")
		local jsonFile = string.format("sprite/big_head_%s.json", temp_bust_index)
        local atlasFile = string.format("sprite/big_head_%s.atlas", temp_bust_index)
        if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
	        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
	    		spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)
	        shipPanel:addChild(spArmature)
	        spArmature:setPosition(cc.p(shipPanel:getContentSize().width/2, 0))
	    else
	    	local AllIcon = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.All_icon)
			shipPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
		end
	else
		local AllIcon = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.All_icon)
		panelWujiang:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
	end
	
	-- ccui.Helper:seekWidgetByName(root, "arrow_pj"):setVisible(false)
	-- ccui.Helper:seekWidgetByName(root, "arrow_pj_0"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_down"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_down_0"):setVisible(true)
end

function FormationSeeHeroIn:showPageview()
	local root = self.roots[1]
	
	local shipnullindex = 0
	local ships = {}
	local pageview = ccui.Helper:seekWidgetByName(root, "PageView_1")
	for i=1,6 do
		pageview:removePageAtIndex(0)
	end
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if tonumber(shipId) > 0 then
			local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
			local cell = self:createShipBody(_ED.user_ship[shipId],5)
			if tonumber(isleadtype) > 0 then
				pageview:insertPage(cell, i-2)
				table.insert(ships, _ED.user_ship[shipId])
			else
				pageview:insertPage(cell, 0)
				self.shipArray[1] = _ED.user_ship[shipId]
			end
		end
	end
	
	for i = 1, table.getn(ships) do
		table.insert(self.shipArray, ships[i])
    end
	
	for i,v in pairs(self.shipArray) do
		if tonumber(self.hero.ship_id) == tonumber(v.ship_id) then
			pageview:scrollToPage(i-1)
			pageview:update(10)
			self.pageindex = i-1
		end
	end
	
	pageview:setCustomScrollThreshold(20)
	
	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local pageview = sender
            local pageInfo = string.format("page %d " , pageview:getCurPageIndex())
			if self.shipArray[pageview:getCurPageIndex()+1] == 0 then
				self:init(nil)
			else
				self:init(self.shipArray[pageview:getCurPageIndex()+1])
			end
			self:onUpdateDraw()
			self:getshipFormationPosition()
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {terminal_name = "hero_info_formation_replacement_hero", terminal_state = 0, _ship = self.hero, _data = self.formationPosition, isPressedActionEnabled = true}, nil, 0)
			if self.pageindex > pageview:getCurPageIndex() then
				state_machine.excute("formation_other_interface_reset", 0, { _index = 1})
				self.pageindex = pageview:getCurPageIndex()
			elseif self.pageindex < pageview:getCurPageIndex() then
				state_machine.excute("formation_other_interface_reset", 0, { _index = -1})
				self.pageindex = pageview:getCurPageIndex()
			else
				state_machine.excute("formation_other_interface_reset", 0, { _index = 0})
				self.pageindex = pageview:getCurPageIndex()
			end
        end
    end 
    pageview:addEventListener(pageViewEvent)
	
end

function FormationSeeHeroIn:getshipFormationPosition()
	local root = self.roots[1]
	if self.current_type == self.enum_type._SMALL_PARTNER_INFORMATION then
		for i, v in pairs(_ED.little_companion_state) do
			if tonumber(v) == tonumber(self.hero.ship_id) then
				self.formationPosition = i
				return
			end
		end
	else
		for i = 2, 7 do
			if tonumber(_ED.formetion[i]) > 0 then 
				if tonumber(_ED.formetion[i]) == tonumber(self.hero.ship_id) then
					self.formationPosition = i-1
					return
				end
			end
		end
	end
end


function FormationSeeHeroIn:onEnterTransitionFinish()
	app.load("client.cells.ship.ship_hero_base_information_cell")
	app.load("client.cells.ship.ship_hero_skill_cell")
	app.load("client.cells.ship.ship_hero_skill_temp_cell")
	app.load("client.cells.ship.ship_hero_destiny_cell")
	app.load("client.cells.ship.ship_hero_luck_talent_explain_cell")
	app.load("client.cells.ship.ship_body_cell")
    local csbGeneralsInformation_1 = csb.createNode("packs/HeroStorage/generals_information_1.csb")
	local root = csbGeneralsInformation_1:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_1)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		if self.hero == nil then
			local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")			--ListView
			ListView_1:removeAllItems()
			ListView_1:requestRefreshView()
			for i =1, 6 do
				if i == 1 then
					-- local cell = HeroBaseInformation:createCell()
					-- cell:init(nil, "formation")
					-- ListView_1:addChild(cell)
				elseif i == 2 then
					local cell = FormationHeroSkill:createCell()
					cell:init(nil)
					ListView_1:addChild(cell)
				elseif i == 3 then
					local cell = FormationHeroDestiny:createCell()
					cell:init(nil,  "formation")
					ListView_1:addChild(cell)
				elseif i == 4 then
					local cell = HeroLuckTalentExplain:createCell()
					cell:init(nil,i)
					ListView_1:addChild(cell)
				elseif i == 5 then
					local cell = HeroLuckTalentExplain:createCell()
					cell:init(nil,i)
					ListView_1:addChild(cell)
				elseif i == 6 then
					local cell = HeroLuckTalentExplain:createCell()
					cell:init(nil,i)
					ListView_1:addChild(cell)
				end
			end
			ccui.Helper:seekWidgetByName(root, "Button_2"):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root, "Button_2"):setBright(false)
			return
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		--龙虎门没有pageview默认第二个类型
		self.current_type = self.enum_type._SMALL_PARTNER_INFORMATION
	end

	if self.current_type ~= self.enum_type._SMALL_PARTNER_INFORMATION then
		self:showPageview()
	else
		self:showHeroIcon()
	end
	self:onUpdateDraw()
	self:getshipFormationPosition()
	
	local return_line_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1077"), nil, {func_string = [[state_machine.excute("return_to_the_squad_screen", 0, "click return_to_the_squad_screen.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {terminal_name = "hero_info_formation_replacement_hero", terminal_state = 0, _ship = self.hero, _data = self.formationPosition, isPressedActionEnabled = true}, nil, 0)

	local horn = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(horn, nil, {func_string = [[state_machine.excute("formation_hero_formation_play_hero_music", 0, "click  formation_hero_formation_play_hero_music.'")]], isPressedActionEnabled = true}, nil, 0)
	
	if true ~= hasShipSound(self.hero.ship_template_id) then
		horn:setVisible(false)
	end
	
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("hero_formation_chick_replace_hero", 0, "hero_formation_chick_replace_hero.'")]]}, nil, 0)
	if self.current_type == self.enum_type._SMALL_PARTNER_INFORMATION then
		--卸下小伙伴
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {terminal_name = "remove_the_small_partners", terminal_state = 0, _ship = self.hero.ship_id, isPressedActionEnabled = true}, nil, 0)
		--更换小伙伴
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {terminal_name = "replacement_of_small_partners", terminal_state = 0, _ship = self.hero, _data = self.formationPosition, isPressedActionEnabled = true}, nil, 0)
	end
end

function FormationSeeHeroIn:onExit()
	state_machine.remove("return_to_the_squad_screen")
	state_machine.remove("hero_info_formation_replacement_hero")
	state_machine.remove("formation_hero_formation_play_hero_music")
	state_machine.remove("remove_the_small_partners")
	state_machine.remove("replacement_of_small_partners")
end

function FormationSeeHeroIn:init(hero,_type)
	self.hero = hero
	self.current_type = _type
end

function FormationSeeHeroIn:createCell()
	local cell = FormationSeeHeroIn:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
