----------------------------------------------------------------------------------------------------
-- 说明：武将的小图标绘制
-------------------------------------------------------------------------------------------------------
ShipIconCell = class("ShipIconCellClass", Window)
ShipIconCell.__userHeroFontName = nil
ShipIconCell.battle_kings_number = 0
function ShipIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FORMATION_CHANGE_SHIP_PAGE_VIEW = 1,	-- 阵容界面武将切换
		_SHOW_SHIP_INFORMATION = 2,				-- 查看武将信息
		_SHOW_SHIP_GETWAY = 3,					-- 查看武将获得途径
		_SHOW_SHIP_HEAD = 4,					-- 只绘制武将头像,布阵界面调用
		_SHOW_SHIP_NOT_CHOOSE = 5,				-- 不能点击
		_SHOW_SHIP_WITH_LEVEL_NOT_CHOOSE = 6,	-- 显示武将等级，无响应事件
		_SMALL_PARTNER_INFORMATION_VIEW = 7,	-- 小伙伴界面查看小伙伴信息
		_HERO_STRENGTHEN = 8,					-- 绘制升级武将里的升级元素
		_BATTLE_SETTLEMENT = 9,					-- 战斗结算
		_ARENA_BATTLE_SETTLEMENT = 10,			-- 竞技场战斗结算
		_BATTLE_OF_KINGS = 11,					-- 王者之战上阵
		_BATTLE_OF_KINGS_ARRANGE_FORMATION = 12,-- 王者之战整理阵型
		_UNION_FIGHTING_CHANGE_FORMATION = 13,-- 工会战整理阵型
	}
	self.ship = nil		-- 当前要绘制的战船实现数据对对象
	self._mouldId = nil
	self.ships = nil
	self.strengShip = nil
	self.panelFour = nil

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_ship_head_cell_terminal()
		
		-- 设计在升级界面，点击武将全身图像需要处理的逻辑
		local ship_head_cell_show_choose_hero_terminal = {
            _name = "ship_head_cell_show_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 这里不处理，而是让他穿透
			
            	-- -- 在这里处理阵容界面，点击武将全身图像后的响应逻辑
            	local ships = params._datas._ships
            	local strengShipId = params._datas._strengShipId
				app.load("client.packs.hero.ChooseHeroToStreng")
				local choose_hero_to_streng = ChooseHeroToStreng:new()
				choose_hero_to_streng:init(ships, strengShipId)
				fwin:open(choose_hero_to_streng, fwin._taskbar)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --王者之战上阵
		local ship_head_cell_battle_kings_go_to_terminal = {
            _name = "ship_head_cell_battle_kings_go_to",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local m_type = 0
				if ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):isVisible() == false then
					if ShipIconCell.battle_kings_number >= 10 then
						return
					end
					ShipIconCell.battle_kings_number = ShipIconCell.battle_kings_number + 1
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):setVisible(true)
					m_type = 0
				else
					ShipIconCell.battle_kings_number = ShipIconCell.battle_kings_number - 1
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):setVisible(false)
					m_type = 1
				end
				
				state_machine.excute("sm_battleof_kings_start_go_to_battle", 0, {m_type, cell.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		-- local ship_head_cell_change_formation_ship_terminal = {
            -- _name = "ship_head_cell_change_formation_ship",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将小图像后的响应逻辑
            	-- local ship = params._datas._ship
				-- state_machine.excute("formation_change_to_ship_page_view", 0, ship)
				
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- 获得途径
		-- local ship_head_cell_change_get_terminal = {
            -- _name = "ship_head_cell_change_get",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- local ship = params._datas._ship
				-- app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				-- local cell = HeroPatchInformationPageGetWay:createCell()
				-- cell:init(ship)
				-- fwin:open(cell, fwin._view)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- 武将信息
		-- local ship_head_cell_info_terminal = {
            -- _name = "ship_head_cell_info",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- app.load("client.formation.HeroInformation")
				-- local ship = params._datas._ship
				-- local heroInfo = HeroInformation:new()
				-- heroInfo:init(ship)
				-- fwin:open(heroInfo, fwin._ui) 
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- 小伙伴信息
		-- local ship_partner_cell_info_terminal = {
            -- _name = "ship_partner_cell_info",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- local ship = params._datas._ship
				-- if ship~=nil then
					-- app.load("client.formation.FormationSeeHeroIn")
					-- local heroInfo = FormationSeeHeroIn:new()
					-- heroInfo:init(ship,1)
					-- fwin:open(heroInfo, fwin._ui) 
				-- end
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(ship_head_cell_show_choose_hero_terminal)	

		state_machine.add(ship_head_cell_battle_kings_go_to_terminal)	

		-- state_machine.add(ship_head_cell_change_formation_ship_terminal)	
		-- state_machine.add(ship_head_cell_change_get_terminal)	
		-- state_machine.add(ship_head_cell_info_terminal)
		-- state_machine.add(ship_partner_cell_info_terminal)	
        state_machine.init()
	end
	init_ship_head_cell_terminal()
end

function ShipIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	-- local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	-- Image_2:setSwallowTouches(false)
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		Panel_prop:removeAllChildren(true)
		local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
		Panel_4:setVisible(false)		
	end
	local Panel_zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_zhenxing")--装备等级底框
	Panel_prop:setSwallowTouches(false)
	Panel_kuang:setVisible(true)

	--阵容
	if self.ship ~= nil then
		local picIndex = 0
		local quality = 0

		local item_index = nil--物品图标索引
		local item_qulityindex = nil--物品品质索引
		local item_nameIndex = nil--物品名称索引
		local item_mouldid = nil--物品模板id
		item_index = ship_mould.head_icon
		item_qulityindex = ship_mould.ship_type
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			if ship_evo[2] == nil then
				item_nameIndex = ""
			else
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				if zstring.tonumber(self.ship.skin_id) ~= 0 then
					evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
				end
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				item_nameIndex = word_info[3]
			end
		else
			item_nameIndex = ship_mould.captain_name
		end
		item_mouldid= self.ship.ship_template_id
		picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
		capacity = dms.int(dms["ship_mould"], item_mouldid, ship_mould.capacity)
		quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			if ship_evo[2] == nil then
				picIndex = self.ship.evolution_status
			else
				local evo_mould_id = smGetSkinEvoIdChange(self.ship)
				if zstring.tonumber(self.ship.skin_id) ~= 0 then
			    	evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
			    end
				picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			end
			quality = tonumber(self.ship.Order)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local Panel_prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
				Panel_prop_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				if Panel_prop ~= nil then
					Panel_prop:addChild(Panel_prop_icon)
				end
				if self.isGrayed ~= nil then
					display:gray(Panel_prop_icon)
				else
					display:ungray(Panel_prop_icon)
				end
			else
				Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			end
			
		else
			if self.ship.captain_type == "0" then
				-- picIndex = tonumber(_ED.user_info.user_head) + 1500
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					-- if dms.int(dms["ship_mould"], tonumber(self.heroInstance.ship_template_id), ship_mould.captain_type) == 0 then
						local fashionEquip, pic = getUserFashion()
						if fashionEquip ~= nil and pic ~= nil then
							picIndex = pic + 1000
						end
					-- end
				end
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
				else
					Panel_prop:setBackGroundImage(string.format("images/face/hero_head/props_%d.png", picIndex))
				end
			else
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
				else
					Panel_prop:setBackGroundImage(string.format("images/face/hero_head/props_%d.png", picIndex))
				end
			end
		end
		
		--local backGroundImage = string.format("images/ui/quality/icon_hero_%d.png", quality)
		-- 只有阵容界面才是 line_kuang_ 前缀的图片
		if self.current_type == self.enum_type._HERO_STRENGTHEN then
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge then 
				Panel_prop:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex-1000))
				Panel_kuang:setVisible(false)
			end
		else
			if __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then
				local faction_id = dms.int(dms["ship_mould"], item_mouldid, ship_mould.faction_id)
				Panel_zhenxing:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", faction_id))
			else
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				else
					Panel_zhenxing:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", capacity))
				end
			end
		end
		local backGroundImage = ""
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			backGroundImage = string.format("images/ui/quality/icon_ditu_%d.png", quality)
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				backGroundImage = string.format("images/ui/quality/icon_enemy_%d.png", quality)
			else
				backGroundImage = string.format("images/ui/quality/icon_hero_%d.png", quality)
			end
		end
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality+1))
			if Panel_kuang_icon ~= nil then
				Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
				if Panel_kuang ~= nil then
					Panel_kuang:addChild(Panel_kuang_icon)
				end
				if self.isGrayed ~= nil then
					display:gray(Panel_kuang_icon)
				else
					display:ungray(Panel_kuang_icon)
				end
			end
			local Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
			if Panel_ditu_icon ~= nil then
				Panel_ditu_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
				if Panel_ditu ~= nil then
					Panel_ditu:addChild(Panel_ditu_icon)
				end
				if self.isGrayed ~= nil then
					display:gray(Panel_ditu_icon)
				else
					display:ungray(Panel_ditu_icon)
				end
			end
		else
			Panel_kuang:setBackGroundImage(backGroundImage)
		end
		
		local name = ccui.Helper:seekWidgetByName(root, "Text_name")
		if ___is_open_leadname == true then
			if ShipIconCell.__userHeroFontName == nil then
				ShipIconCell.__userHeroFontName = name:getFontName()
			end
			if dms.int(dms["ship_mould"], tonumber(item_mouldid), ship_mould.captain_type) == 0 then
				name:setFontName("")
				name:setFontSize(name:getFontSize())-->设置字体大小
			else
				name:setFontName(ShipIconCell.__userHeroFontName)
			end
		end
		if self.current_type == self.enum_type._SHOW_SHIP_HEAD then
			if tonumber(self.ship.captain_type) == 0 then
				name:setString(_ED.user_info.user_name)
			else
				name:setString(self.ship.captain_name)
			end
			name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			ccui.Helper:seekWidgetByName(root, "Image_exp_icon"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_exp_n"):setVisible(false)
			if self.current_type == self.enum_type._BATTLE_SETTLEMENT then
				name:setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_exp_icon"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Image_600"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_exp_n"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_equip_lv"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_equip_lv"):setString(self.ship.ship_grade)
				ccui.Helper:seekWidgetByName(root, "Text_exp_n"):setString("+"..(self.ship_exps or 0))
				if  __lua_project_id == __lua_project_onepiece then
				   ccui.Helper:seekWidgetByName(root, "Text_exp_n"):setColor(cc.c3b(0, 0, 0))
				end
			end
			if self.current_type == self.enum_type._ARENA_BATTLE_SETTLEMENT then
				ccui.Helper:seekWidgetByName(root, "Image_600"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_equip_lv"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_equip_lv"):setString(self.ship.ship_grade)
			end

			if self.current_type == self.enum_type._BATTLE_OF_KINGS 
				or self.current_type == self.enum_type._BATTLE_OF_KINGS_ARRANGE_FORMATION 
				or self.current_type == self.enum_type._UNION_FIGHTING_CHANGE_FORMATION 
				then
				ccui.Helper:seekWidgetByName(root, "Image_600"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_exp_icon"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_exp_n"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Text_equip_lv"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_equip_lv"):setString(self.ship.ship_grade)
				local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
				if Panel_star ~= nil then
					Panel_star:removeAllChildren(true)
				end
				neWshowShipStar(Panel_star,tonumber(self.ship.StarRating))
				-- ccui.Helper:seekWidgetByName(root, "Image_chuzhan"):setVisible(false)
			end
		end

		-- pmc武将图标显示ssr
		if true then
			local ability = dms.int(dms["ship_mould"], tonumber(item_mouldid), ship_mould.ability)
			local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			ssrIcon:setVisible(true)
			ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
		end

		-- 武将限定卡SP标签
		if __lua_project_id == __lua_project_l_digital then 
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			DisplaySpCardTag(tonumber(item_mouldid), spIcon)
		else
			-- 武将限定卡显示
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				DisplayLimitCard(tonumber(item_mouldid) ,Panel_xianding , 1)
			end
		end
	end
	
end

function ShipIconCell:setScalePanel(n)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_29"):setScale(n)
end

function ShipIconCell:onEnterTransitionFinish()

	if table.getn(self.roots) > 0 then
		return
	end

end

function ShipIconCell:onInit()

	if table.getn(self.roots) > 0 then
		return
	end
	local root = cacher.createUIRef("formation/line_up_icon_up.csb", "root")
	-- table.insert(self.roots, root)
	-- local csbItem = csb.createNode("formation/line_up_icon_up.csb")
	-- local root = nil
	-- root = csbItem:getChildByName("root")
	if self.current_type == self.enum_type._HERO_STRENGTHEN then
		root = ccui.Helper:seekWidgetByName(root, "Panel_29")
		root:setPosition(cc.p(0, 0))
		root:setAnchorPoint(cc.p(0, 0))
	end
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	-- local action = csb.createTimeline("formation/line_up_icon_up.csb")
	-- csbItem:runAction(action)
	-- self.cacheAction = action
	
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	if self.current_type == self.enum_type._SHOW_SHIP_HEAD 
		or self.current_type == self.enum_type._BATTLE_OF_KINGS_ARRANGE_FORMATION
		or self.current_type == self.enum_type._UNION_FIGHTING_CHANGE_FORMATION
		then
		ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)
		self:setTouchEnabled(true)
		if self.current_type == self.enum_type._BATTLE_OF_KINGS_ARRANGE_FORMATION 
			or self.current_type == self.enum_type._UNION_FIGHTING_CHANGE_FORMATION 
			then
			self:setTouchEnabled(false)
		end
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_29")
		self:setContentSize(panel:getContentSize())
		panel:setPosition(cc.p(0, 0))
		panel:setAnchorPoint(cc.p(0, 0))
		
	elseif self.current_type ~= self.enum_type._SHOW_SHIP_GETWAY and self.current_type ~= self.enum_type._SHOW_SHIP_NOT_CHOOSE 
	and self.current_type ~= self.enum_type._SHOW_SHIP_INFORMATION and self.current_type ~= self.enum_type._SMALL_PARTNER_INFORMATION_VIEW then
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_cell_change_formation_ship", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
	
	if self.current_type == self.enum_type._HERO_STRENGTHEN then
		ccui.Helper:seekWidgetByName(root, "Panel_29"):setTouchEnabled(true)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_29"), nil, 
		{
			terminal_name = "ship_head_cell_show_choose_hero", 
			terminal_state = 0, 
			_ships = self.ships,
			_strengShipId = self.strengShipId
		}, 
		nil, 0)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self.panelFour = ccui.Helper:seekWidgetByName(root, "Panel_prop")
		self.choose = ccui.Helper:seekWidgetByName(root, "Image_600")
		local images_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
		images_zhushou:setVisible(false)

		if self.current_type == self.enum_type._FORMATION_CHANGE_SHIP_PAGE_VIEW then
			ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Panel_prop")._data = self.ship.ship_id
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_replacement_equipment_ship",
			_widget = ccui.Helper:seekWidgetByName(root, "Panel_prop"),
			_invoke = nil,
			_interval = 0.5,})
		end		
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if self.current_type == self.enum_type._BATTLE_OF_KINGS then
			ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
			{
				terminal_name = "ship_head_cell_battle_kings_go_to", 
				terminal_state = 0, 
				cell = self
			}, 
			nil, 0)
		end
	end
	-- if self.current_type == self.enum_type._FORMATION_CHANGE_SHIP_PAGE_VIEW then
	-- 	ccui.Helper:seekWidgetByName(root, "Panel_prop")._data = self.ship.ship_id
	-- 	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_replacement_equipment_ship",
	-- 	_widget = ccui.Helper:seekWidgetByName(root, "Panel_prop"),
	-- 	_invoke = nil,
	-- 	_interval = 0.5,})
	-- end
end

function ShipIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_29 = ccui.Helper:seekWidgetByName(root, "Panel_29")
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local Image_chuzhan = ccui.Helper:seekWidgetByName(root, "Image_chuzhan")
	local Image_exp_icon = ccui.Helper:seekWidgetByName(root, "Image_exp_icon")
	local Text_exp_n = ccui.Helper:seekWidgetByName(root, "Text_exp_n")
	local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
	local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
	if ssrIcon then
		ssrIcon:setVisible(false)
	end
	if Panel_xianding ~= nil then 
		Panel_xianding:removeAllChildren(true)
	end
	if Panel_prop ~= nil then
		Panel_kuang:removeAllChildren(true)
		Panel_ditu:removeAllChildren(true)
		Panel_prop:setTouchEnabled(true)
		Panel_prop:removeAllChildren(true)
		Panel_prop._data = nil
		Panel_29:setScale(1)
		Panel_29:setTouchEnabled(false)
		Panel_star:removeAllChildren(true)
		Image_chuzhan:setVisible(false)
		Image_exp_icon:setVisible(false)
		Text_exp_n:setVisible(false)
	end
end

function ShipIconCell:onExit()
	local root = self.roots[1]
	self:clearUIInfo()
	-- state_machine.remove("ship_head_cell_show_choose_hero")
	if root ~= nil then
		cacher.freeRef("formation/line_up_icon_up.csb", root)
	    root:stopAllActions()
	    self:unregisterOnNoteUpdate(self)
	    root:removeFromParent(false)
	    self.roots = {}
	end
end

function ShipIconCell:init(ship, interfaceType, mouldId, ships, strengShipId,exps,isGrayed)
	self.ship = ship
	self.current_type = interfaceType
	if mouldId ~= nil then
		self._mouldId = mouldId
	end
	if ships ~= nil then
		self.ships = ships
	end	
	if strengShipId ~= nil then
		self.strengShipId = strengShipId
	end	
	if exps ~= nil then
		self.ship_exps = exps
	end
	if isGrayed ~= nil then
		self.isGrayed = isGrayed
	end
	self:onInit()
end

function ShipIconCell:createCell()
	local cell = ShipIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

