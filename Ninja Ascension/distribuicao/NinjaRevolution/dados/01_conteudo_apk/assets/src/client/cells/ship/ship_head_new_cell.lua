----------------------------------------------------------------------------------------------------
-- 说明：武将的小图标绘制
-------------------------------------------------------------------------------------------------------
ShipHeadNewCell = class("ShipHeadNewCellClass", Window)
function ShipHeadNewCell:ctor()
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
		_SHOW_HERO_PATH_INFO = 8,				-- 查看武将碎片信息
		_SHOW_HERO_FROM_FORMATION = 9,				-- 上阵进来的
		_SHOW_HERO_FROM_WARCRAFT = 10,				-- 排位赛，只做显示
	}
	self.ship = nil		-- 当前要绘制的战船实现数据对对象
	self._mouldId = nil
	self.params = {}
	self.csbLua = nil
	
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_ship_head_new_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		local ship_head_new_cell_change_formation_ship_terminal = {
            _name = "ship_head_new_cell_change_formation_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将小图像后的响应逻辑
            	local ship = params._datas._ship
				state_machine.excute("formation_change_to_ship_page_view", 0, ship)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--获得途径
		local ship_head_new_cell_change_get_terminal = {
            _name = "ship_head_new_cell_change_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._ship
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(ship)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--武将信息
		local ship_head_new_cell_info_terminal = {
            _name = "ship_head_new_cell_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.formation.HeroInformation")
				local ship = params._datas._ship
				-- local heroInfo = HeroInformation:new()
				-- heroInfo:init(ship)
				-- fwin:open(heroInfo, fwin._ui) 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						local cell = params._datas._self
						local chooseIndex = 0
						if cell.params ~= nil and cell.params.chooseIndex ~= nil then
							chooseIndex = cell.params.chooseIndex
						end
						-- if instance.current_type == instance.enum_type._SHOW_HERO_FROM_WARCRAFT then 
						-- 	state_machine.excute("sm_role_information_open", 0, {ship})
						-- else
							state_machine.excute("sm_role_information_open", 0, {ship.ship_template_id, 1, chooseIndex})
						-- end
						
					else
						state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = ship, _touch_type = "head_icon", _enter_type = "pack"}})
					end
					-- state_machine.excute("hero_information_open_window", 0, ship)
				else
					local captain_type = dms.int(dms["ship_mould"],ship.ship_template_id,ship_mould.captain_type)
					if captain_type == 3 then 
						--宠物
						app.load("client.packs.pet.PetInformation")
						state_machine.excute("pet_information_open_window", 0, {ship,1})
					else
						state_machine.excute("hero_information_open_window", 0, ship)
					end
					
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --模板武将信息
		local ship_head_new_cell_mould_info_terminal = {
            _name = "ship_head_new_cell_mould_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.formation.HeroInformation")
				local ship = params._datas._ship
				state_machine.excute("sm_role_information_open", 0, {ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 点击武将碎片小图标需要处理的逻辑
		local ship_head_new_cell_show_hero_info_terminal = {
            _name = "ship_head_new_cell_show_hero_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local shipId = params._datas._ship.ship_base_template_id
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					local ship = params._datas._ship
					if params._datas.from_type == 9 then
						cell:init(shipId, nil , nil, 2,9,ship)
					else
						cell:init(shipId, nil , nil, 2)
					end
				else
					cell:init(shipId, nil , nil, 2)
				end
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--小伙伴信息
		local ship_partner_new_cell_info_terminal = {
            _name = "ship_partner_new_cell_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._ship
				if ship~=nil then
					app.load("client.formation.FormationSeeHeroIn")
					local heroInfo = FormationSeeHeroIn:new()
					heroInfo:init(ship,1)
					fwin:open(heroInfo, fwin._ui) 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(ship_head_new_cell_change_formation_ship_terminal)	
		state_machine.add(ship_head_new_cell_change_get_terminal)	
		state_machine.add(ship_head_new_cell_info_terminal)
		state_machine.add(ship_partner_new_cell_info_terminal)	
		state_machine.add(ship_head_new_cell_show_hero_info_terminal)	
		state_machine.add(ship_head_new_cell_mould_info_terminal)	

        state_machine.init()
	end
	init_ship_head_new_cell_terminal()
end

function ShipHeadNewCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	-- local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	local panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")--右下角标识
	Panel_ditu:setVisible(true)
	if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
	end
	local Image_jiaobiao = ccui.Helper:seekWidgetByName(root, "Image_jiaobiao")
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	local Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	if Image_jiaobiao ~= nil then
		Image_jiaobiao:setVisible(false)
	end
	if Text_time ~= nil then
		Text_time:setVisible(false)
	end
	if Text_num ~= nil then
		Text_num:setVisible(false)
	end

	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_koone
		then
		ccui.Helper:seekWidgetByName(root, "Image_yishangzhen"):setVisible(false)
	end
	Panel_prop:setSwallowTouches(false)

	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	if Panel_star ~= nil then
		Panel_star:removeAllChildren(true)
		-- 阵容推荐去掉品质,星级的显示
		if self.params ~= nil and self.params.isFormationTemplat then 
			Panel_star:setVisible(false)
		end
	end

	--阵容
	--排位赛
	if self.current_type == self.enum_type._SHOW_HERO_FROM_WARCRAFT then 
		Panel_prop:removeAllChildren(true)
		Panel_prop:removeBackGroundImage()
		Panel_kuang:removeAllChildren(true)
		Panel_kuang:removeBackGroundImage()
		local quality = dms.int(dms["ship_mould"], self.ship, ship_mould.ship_type)
		local picIndex = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.ship, ship_mould.captain_name)]
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			quality = 1
			-- neWshowShipStar(root,tonumber(dms.int(dms["ship_mould"], self.ship, ship_mould.ship_star)))
		else
			picIndex = dms.int(dms["ship_mould"], self.ship, ship_mould.head_icon)
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Panel_prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%s.png", "".. picIndex))
			if Panel_prop_icon ~= nil then
				Panel_prop_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(Panel_prop_icon)
			end
			local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality+1))
			if Panel_kuang_icon ~= nil then
				Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
				Panel_kuang:addChild(Panel_kuang_icon)
			end

			local Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
			if Panel_ditu_icon ~= nil then
				Panel_ditu_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
				Panel_ditu:addChild(Panel_ditu_icon)
			end

			if self._mouldId ~= nil and self._mouldId == false then
				if Panel_prop_icon ~= nil then
					display:gray(Panel_prop_icon)
				end
				if Panel_kuang_icon ~= nil then
					display:gray(Panel_kuang_icon)
				end
				if Panel_ditu_icon ~= nil then
					display:gray(Panel_ditu_icon)
				end
			else
				if Panel_prop_icon ~= nil then
					display:ungray(Panel_prop_icon)
				end
				if Panel_kuang_icon ~= nil then
					display:ungray(Panel_kuang_icon)
				end
				if Panel_ditu_icon ~= nil then
					display:ungray(Panel_ditu_icon)
				end
			end
		else
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%s.png", "".. picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality + 1))
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--这里的self._mouldId标识是否需要变灰
			local currStar = dms.int(dms["ship_mould"], self.ship, ship_mould.ship_star)
			if self.params ~= nil and self.params.shipStar ~= nil then
				currStar = self.params.shipStar
			end
			neWshowShipStar(Panel_star,tonumber(currStar),self._mouldId)
		end

		-- pmc武将图标显示ssr
		if true then
			local ability = dms.int(dms["ship_mould"], self.ship, ship_mould.ability)
			local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			ssrIcon:setVisible(true)
			ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
		end

		if __lua_project_id == __lua_project_l_digital then 
			-- 武将限定卡SP标签
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			DisplaySpCardTag(self.ship, spIcon)
		else
			-- 武将限定卡显示
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding  then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				DisplayLimitCard(self.ship , Panel_xianding , 1)

			end
		end
		return
	end 

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
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange(self.ship)
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			item_nameIndex = word_info[3]
		else
			item_nameIndex = ship_mould.captain_name
		end
		item_mouldid= self.ship.ship_template_id
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = smGetSkinEvoIdChange( self.ship )
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		else
			picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			-- Fury: al reconectar con la lista de heroes abierta, el S2C 3 rehace user_ship sin Order
			-- y cada 14104 repinta todas las celdas antes de que llegue el Order de las demas.
			quality = tonumber(self.ship.Order) or 0
		else
			quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
				Panel_prop:removeAllChildren()
				Panel_prop:removeBackGroundImage()
				local Panel_prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%s.png", "".. picIndex))
				if Panel_prop_icon ~= nil then
					Panel_prop_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(Panel_prop_icon)
				end
				if self._mouldId ~= nil and self._mouldId == false then
					if Panel_prop_icon ~= nil then
						display:gray(Panel_prop_icon)
					end
				else
					if Panel_prop_icon ~= nil then
						display:ungray(Panel_prop_icon)
					end
				end
			end
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		else
			if self.ship.captain_type == "0" then
				-- picIndex = tonumber(_ED.user_info.user_head) + 1500
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
						local fashionEquip, pic = getUserFashion()
						if fashionEquip ~= nil and pic ~= nil then
							picIndex = pic + 1000
						end
					end
				end
				Panel_prop:setBackGroundImage(getPropsPath(picIndex))
			else
				Panel_prop:setBackGroundImage(getPropsPath(picIndex))
			end
		end
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
				Panel_kuang_icon:removeAllChildren()
				Panel_kuang_icon:removeBackGroundImage()
				local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality+1))
				if Panel_kuang_icon ~= nil then
					Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
					Panel_kuang:addChild(Panel_kuang_icon)
				end
				if self._mouldId ~= nil and self._mouldId == false then
					if Panel_kuang_icon ~= nil then
						display:gray(Panel_kuang_icon)
					end
				else
					if Panel_kuang_icon ~= nil then
						display:ungray(Panel_kuang_icon)
					end
				end
				-- 阵容推荐去掉品质,星级的显示
				if self.params ~= nil and self.params.isFormationTemplat then 
					if Panel_kuang_icon ~= nil then 
						Panel_kuang_icon:setVisible(false)
					end
				end
			end
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality+1))
				if Panel_kuang_icon ~= nil then
					Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
					Panel_kuang:addChild(Panel_kuang_icon)
				end
				local Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
				if Panel_ditu_icon ~= nil then
					Panel_ditu_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
					Panel_ditu:addChild(Panel_ditu_icon)
				end
				if self._mouldId ~= nil and self._mouldId == false then
					if Panel_kuang_icon ~= nil then
						display:gray(Panel_kuang_icon)
					end
					if Panel_ditu_icon ~= nil then
						display:gray(Panel_ditu_icon)
					end
				else
					if Panel_kuang_icon ~= nil then
						display:ungray(Panel_kuang_icon)
					end
					if Panel_ditu_icon ~= nil then
						display:ungray(Panel_ditu_icon)
					end
				end

				-- 阵容推荐去掉品质,星级的显示
				if self.params ~= nil and self.params.isFormationTemplat then 
					if Panel_kuang_icon ~= nil then 
						Panel_kuang_icon:setVisible(false)
					end
				end
			else
				Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
			end
		end
		-- Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
				neWshowShipStar(Panel_star,tonumber(self.ship.StarRating), self._mouldId)
			else
				neWshowShipStar(Panel_star,tonumber(self.ship.StarRating))
			end
		end
		
		-- pmc武将图标显示ssr
		if true then
			local ability = dms.int(dms["ship_mould"], item_mouldid, ship_mould.ability)
			local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			ssrIcon:setVisible(true)
			ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
		end

		if __lua_project_id == __lua_project_l_digital then 
			-- 武将限定卡SP标签
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			DisplaySpCardTag(tonumber(item_mouldid), spIcon)
		else
			-- 武将限定卡显示
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				DisplayLimitCard(tonumber(item_mouldid) , Panel_xianding , 1)

			end
		end
	end
		
	if self.current_type == self.enum_type._SHOW_SHIP_HEAD then
		if item_name ~= nil then
			item_name:setString(self.ship.captain_name)
			local colortype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
			item_name:setColor(cc.c3b(color_Type[colortype][1],color_Type[colortype][2],color_Type[colortype][3]))
		end
	end
	
	if self.current_type == self.enum_type._SHOW_SHIP_GETWAY then
		local picIndex = 0
		local quality = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			quality = 1
			
		else
			picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
			quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
		end

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		else	
			Panel_prop:setBackGroundImage(getPropsPath(picIndex))
		end
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality))
				if Panel_kuang_icon ~= nil then
					Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
					Panel_kuang:addChild(Panel_kuang_icon)
				end
				local Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
				if Panel_ditu_icon ~= nil then
					Panel_ditu_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
					Panel_ditu:addChild(Panel_ditu_icon)
				end
			else
				Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
			end
		end
		if self.params.isCurrentShip == true then
			if ccui.Helper:seekWidgetByName(root, "Image_dangqian") ~= nil then
				ccui.Helper:seekWidgetByName(root, "Image_dangqian"):setVisible(true)
			end
		end
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_new_cell_change_get", terminal_state = 0, _self = self, _ship = self._mouldId}, nil, 0)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local currStar = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_star)
			if self.params ~= nil and self.params.shipStar ~= nil then
				currStar = self.params.shipStar
			end
			neWshowShipStar(Panel_star,tonumber(currStar))
		end
	end
	if self.current_type == self.enum_type._SHOW_SHIP_NOT_CHOOSE then
		local picIndex = 0
		local quality = 0
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			quality = shipOrEquipSetColour(dms.int(dms["ship_mould"], self._mouldId, ship_mould.initial_rank_level))-1
		else
			picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
			quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
		end
		
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		else
			Panel_prop:setBackGroundImage(getPropsPath(picIndex))
		end
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality))
				if Panel_kuang_icon ~= nil then
					Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
					Panel_kuang:addChild(Panel_kuang_icon)
				end
				local Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
				if Panel_ditu_icon ~= nil then
					Panel_ditu_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
					Panel_ditu:addChild(Panel_ditu_icon)
				end
				local currStar = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_star)
				if self.params ~= nil and self.params.shipStar ~= nil then
					currStar = self.params.shipStar
				end
				neWshowShipStar(Panel_star,tonumber(currStar))
			else
				Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
			end
		end

		-- pmc武将图标显示ssr
		if true then
			local ability = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ability)
			local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			ssrIcon:setVisible(true)
			ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
		end

		if __lua_project_id == __lua_project_l_digital then 
			-- 武将限定卡SP标签
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			DisplaySpCardTag(self._mouldId, spIcon)
		else
			-- 武将限定卡显示
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)

				DisplayLimitCard(self._mouldId , Panel_xianding , 1)

			end
		end
	end
	if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
		local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Panel_prop")
			local function headLayerTouchEvent(sender, evenType)
				local __spoint = sender:getTouchBeganPosition()
				local __mpoint = sender:getTouchMovePosition()
				local __epoint = sender:getTouchEndPosition()
				if ccui.TouchEventType.began == evenType then
					
				elseif evenType == ccui.TouchEventType.moved then
					
				elseif ccui.TouchEventType.ended == evenType or
					ccui.TouchEventType.canceled == evenType then
					if math.abs( __epoint.y - __spoint.y) < 8 then
						state_machine.excute("ship_head_new_cell_info", 0, {_datas = {_self = self, _ship = self.ship}})
					end
				end
			end
		seat_expansion_on_button:addTouchEventListener(headLayerTouchEvent)
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_new_cell_info", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
		if panel_5 ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				panel_5:setVisible(false)
			else
				panel_5:setVisible(true)
				local types = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.capacity)
				if types == 0 then
					panel_5:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", types))
				elseif types == 1 then
					panel_5:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", types))
				elseif types == 2 then
					panel_5:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", types))
				elseif types == 3 then
					panel_5:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", types))
				elseif types == 4 then
					panel_5:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", types))
				end
			end
		end
		
		if zstring.tonumber(self.ship.formation_index) > 0 then
			if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then			--龙虎门项目控制
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if self.current_type == self.enum_type._FORMATION_CHANGE_SHIP_PAGE_VIEW then
						if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
							ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
						end
					end
				else
					if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
						ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
					end
				end
			else
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_koone 
					then
					if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
						ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
					end
				else
					ccui.Helper:seekWidgetByName(root, "Image_yishangzhen"):setVisible(true)
					
				end
				ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[116])
			end
		end
		if zstring.tonumber(self.ship.little_partner_formation_index) > 0 then
			if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then			--龙虎门项目控制
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if self.current_type == self.enum_type._FORMATION_CHANGE_SHIP_PAGE_VIEW then
						if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
							ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
						end
					end
				else
					if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
						ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
					end
				end
			else
				if __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_koone
					then
					if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
						ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
					end
				else
					ccui.Helper:seekWidgetByName(root, "Image_yishangzhen"):setVisible(true)
				end
				ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_string_piece_info[115])
			end
		end


		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			local images_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
			if images_zhushou ~= nil then
				images_zhushou:setVisible(false)
				if self.ship.inResourceFromation == true and zstring.tonumber(self.ship.little_partner_formation_index) <= 0 and zstring.tonumber(self.ship.formation_index) <=0 then
					images_zhushou:setVisible(true)
				end
			end
		end
	end
	
	if self.current_type == self.enum_type._SMALL_PARTNER_INFORMATION_VIEW then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_partner_new_cell_info", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
	
	if self.current_type == self.enum_type._SHOW_SHIP_WITH_LEVEL_NOT_CHOOSE then
		local ship_level = "1"
		if self.ship.captain_type == "0" then
			ship_level = _ED.user_info.user_grade
		else
			ship_level = self.ship.ship_grade
		end
		if item_shuxin ~= nil then
			if verifySupportLanguage(_lua_release_language_en) == true then
				item_shuxin:setString(_string_piece_info[6]..ship_level)
			else
				item_shuxin:setString(ship_level.._string_piece_info[6])
			end
		end
	end
	if self.current_type == self.enum_type._SHOW_HERO_PATH_INFO then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_new_cell_show_hero_info", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
	if self.params ~= nil and self.params.showNum ~= nil then 
		if self.item_order_level ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				if nil ~= fwin:find("HeroListViewClass") or fwin:find("SmTrialTowerChangeWindowListCellClass") == nil then
					self.item_order_level:setVisible(true)
					-- DSC重塑
					if __lua_project_id == __lua_project_l_digital then 
					else
						self.item_order_level:setAnchorPoint(cc.p(0, 0.5))
						self.item_order_level:setPosition(cc.p(25, 40))
					end
				end
				self.item_order_level:setString(self.params.showNum)
			else
				self.item_order_level:setString("x"..self.params.showNum)
			end
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if panel_5 ~= nil then
			panel_5:setVisible(false)
		end
	end
end

function ShipHeadNewCell:onInit()
	if table.getn(self.roots) > 0 then
		return
	end
	local root = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		root = cacher.createUIRef("icon/item.csb","root")
		root:removeFromParent(false)
		self:addChild(root)
		root:setColor(cc.c3b(255, 255, 255))
		table.insert(self.roots, root)
		self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
		if self.item_order_level._anchorPoint == nil then
			self.item_order_level._anchorPoint = self.item_order_level:getAnchorPoint()
		end
		if self.item_order_level._x == nil then
			self.item_order_level._x = self.item_order_level:getPositionX()
		end

		if self.item_order_level._y == nil then
			self.item_order_level._y = self.item_order_level:getPositionY()
		end

		self:onUpdateDraw()
	else
		local csbItem = csb.createNode("icon/item_big.csb")
		root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		root:setColor(cc.c3b(255, 255, 255))
		table.insert(self.roots, root)
		self:onUpdateDraw()
	end

	if self.current_type == self.enum_type._SHOW_SHIP_HEAD then
		ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)
		self:setTouchEnabled(true)
	elseif self.current_type == self.enum_type._SHOW_HERO_FROM_FORMATION then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_new_cell_show_hero_info", terminal_state = 0, _self = self, _ship = self.ship,from_type = 9}, nil, 0)
		end
	elseif self.current_type ~= self.enum_type._SHOW_SHIP_GETWAY and self.current_type ~= self.enum_type._SHOW_SHIP_NOT_CHOOSE 
	and self.current_type ~= self.enum_type._SHOW_SHIP_INFORMATION and self.current_type ~= self.enum_type._SMALL_PARTNER_INFORMATION_VIEW 
	and self.current_type ~= self.enum_type._SHOW_HERO_PATH_INFO then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_new_cell_change_formation_ship", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
end

function ShipHeadNewCell:onEnterTransitionFinish()
	
end

function ShipHeadNewCell:onExit()
	self:clearUIInfo()
end

--params解析
--params.shipStar --战船星级
--params.isCurrentShip --是否是当前武将
--params.showNum --显示数量
function ShipHeadNewCell:init(ship, interfaceType, mouldId, params)
	self.ship = ship
	self.current_type = interfaceType
	self._mouldId = mouldId
	self.params = params or {}
	self:onInit()
end

function ShipHeadNewCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ShipHeadNewCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function ShipHeadNewCell:clearUIInfo()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local root = self.roots[1]
        if root == nil then
            return
        end
        local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
        local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
        local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
        local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")
        local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
			if Panel_star ~= nil then
				Panel_star:setVisible(true)
				Panel_star:removeAllChildren(true)
			end
		end

        if Panel_kuang ~= nil then
        	Panel_kuang:setVisible(true)
        	Panel_kuang:removeAllChildren(true)
        	Panel_kuang:removeBackGroundImage()
        end
        if Panel_prop ~= nil then
        	Panel_prop:setVisible(true)
        	Panel_prop:removeAllChildren(true)
        	Panel_prop:removeBackGroundImage()
        end
        if Panel_ditu ~= nil then
        	Panel_ditu:setVisible(true)
        	Panel_ditu:removeAllChildren(true)
        	Panel_prop:removeBackGroundImage()
        	fwin:removeTouchEventListener(Panel_prop)
        end
        if Panel_num ~= nil then
        	Panel_num:removeAllChildren(true)
        	Panel_num:removeBackGroundImage()
        end
        if Panel_5 ~= nil then
        	Panel_5:removeAllChildren(true)
        	Panel_5:removeBackGroundImage()
        end

        local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
        local Image_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
        local Image_tuijian = ccui.Helper:seekWidgetByName(root, "Image_tuijian") 
        local Image_bidiao = ccui.Helper:seekWidgetByName(root, "Image_bidiao")
        local Image_dangqian = ccui.Helper:seekWidgetByName(root, "Image_dangqian")
        local Image_yichuandai = ccui.Helper:seekWidgetByName(root, "Image_yichuandai")
        local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
        local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")

		local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
		local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
        if ssrIcon then
        	ssrIcon:setVisible(false)
        end
		if Panel_xianding ~= nil then 
			Panel_xianding:removeAllChildren(true)
		end
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
        if Image_4 ~= nil then
        	Image_4:setVisible(false)
        end
        if Image_zhushou ~= nil then
        	Image_zhushou:setVisible(false)
        end
        if Image_tuijian ~= nil then
        	Image_tuijian:setVisible(false)
        end
        if Image_bidiao ~= nil then
        	Image_bidiao:setVisible(false)
        end
        if Image_dangqian ~= nil then
        	Image_dangqian:setVisible(false)
        end
        if Image_yichuandai ~= nil then
        	Image_yichuandai:setVisible(false)
        end

        local Label_lorder_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
        local Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")
        local Label_quantity = ccui.Helper:seekWidgetByName(root, "Label_quantity")
        local Label_shuxin =ccui.Helper:seekWidgetByName(root, "Label_shuxin")
        local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
        if Label_lorder_level ~= nil then
        	Label_lorder_level:setVisible(true)
        	if Label_lorder_level._anchorPoint then
        		Label_lorder_level:setAnchorPoint(Label_lorder_level._anchorPoint)
        	end
	    	if Label_lorder_level._x then
		    	Label_lorder_level:setPositionX(Label_lorder_level._x)
		    end
		    if Label_lorder_level._y then
		    	Label_lorder_level:setPositionY(Label_lorder_level._y)
		    end
	        Label_lorder_level:setString("")
        end
        if Label_name ~= nil then
        	Label_name:setString("")
        	Label_name:setVisible(true)
        end
        if Label_quantity ~= nil then
        	Label_quantity:setString("")
        end
        if Label_shuxin ~= nil then
        	Label_shuxin:setString("")
        end
        if Text_1 ~= nil then
        	Text_1:setString("")
        end
        cacher.freeRef("icon/item.csb", root)
        -- root:stopAllActions()
        -- root:removeFromParent(false)
        self.roots = {}
    end
end

function ShipHeadNewCell:createCell()
	local cell = ShipHeadNewCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

