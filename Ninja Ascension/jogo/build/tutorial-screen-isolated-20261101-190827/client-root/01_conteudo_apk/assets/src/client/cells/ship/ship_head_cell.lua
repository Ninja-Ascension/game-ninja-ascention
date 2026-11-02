----------------------------------------------------------------------------------------------------
-- 说明：武将的小图标绘制
-------------------------------------------------------------------------------------------------------
ShipHeadCell = class("ShipHeadCellClass", Window)

function ShipHeadCell:ctor()
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
		_SMALL_PARTNER_INFORMATION_VIEW = 7,		-- 小伙伴界面查看小伙伴信息
		_HROE_SHOP_HEAD = 8,		-- 小伙伴界面查看小伙伴信息
		_BATTLE_INFO = 9,		-- 战斗结算
		_SHOW_HERO_HEAD_INFO = 10,						-- 武将突破头像点击
		_SHOW_HERO_HEAD_INFO_NPC = 11,						-- NPC 抢夺,不是 ship_mould
		_SHOW_HERO_HEAD_INFO_SHIP = 12,						-- 角色抢夺,只有战船id
		_DUPLICATE = 13,						-- 副本专用
		_FASHION = 14,
	}
	self.ship = nil		-- 当前要绘制的战船实现数据对对象
	self._mouldId = nil
	self.nums = nil
	self.showName = false
	self.fashionPic= nil
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_ship_head_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		local ship_head_cell_change_formation_ship_terminal = {
            _name = "ship_head_cell_change_formation_ship",
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
		local ship_head_cell_change_get_terminal = {
            _name = "ship_head_cell_change_get",
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
		local ship_head_cell_info_terminal = {
            _name = "ship_head_cell_info",
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
					state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = ship, _touch_type = "head_icon", _enter_type = "pack"}})
					-- state_machine.excute("hero_information_open_window", 0, ship)
				else				
					state_machine.excute("hero_information_open_window", 0, ship)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--武将信息 NPC
		local ship_head_cell_info_npc_terminal = {
            _name = "ship_head_cell_info_npc",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--environment_ship
				
				--曲线救国策略---------------------------------------
				--取出 environment_ship 中图片 id,和ship中的图片id比对
				--匹配的就认定是该id,做传入
				
				local shipId = params._datas._target:getComparisonShip(params._datas._ship.pic_index)
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				--local shipid = params._datas._ship
				cell:init(tostring(shipId),nil,nil,2)
				fwin:open(cell, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将信息 SHIP
		local ship_head_cell_info_ship_terminal = {
            _name = "ship_head_cell_info_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				local _mouldId = params._datas._mouldId
				cell:init(tostring(_mouldId),nil,nil,2)
				fwin:open(cell, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--神将商店头像点击武将信息
		local ship_head_cell_info_shop_terminal = {
            _name = "ship_head_cell_info_shop",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroPatchInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = HeroPatchInformation:new()
				local shipid = params._datas._ship
				cell:init(shipid,2,1)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					fwin:open(cell, fwin._windows)
				else
					fwin:open(cell, fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--小伙伴信息
		local ship_partner_cell_info_terminal = {
            _name = "ship_partner_cell_info",
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
		state_machine.add(ship_head_cell_change_formation_ship_terminal)	
		state_machine.add(ship_head_cell_change_get_terminal)	
		state_machine.add(ship_head_cell_info_terminal)
		state_machine.add(ship_partner_cell_info_terminal)	
		state_machine.add(ship_head_cell_info_shop_terminal)	
		state_machine.add(ship_head_cell_info_npc_terminal)
		state_machine.add(ship_head_cell_info_ship_terminal)
		
		
        state_machine.init()
	end
	init_ship_head_cell_terminal()
end


function ShipHeadCell:getComparisonShip(pic_index)
	--曲线救国策略---------------------------------------
	--取出 environment_ship 中图片 id,和ship中的图片id比对
	--匹配的就认定是该id,做传入
	local i = 1
	while true do
		local picIndex = dms.int(dms["ship_mould"], i, ship_mould.head_icon)
		if nil ~= picIndex then
			--> print("picIndex == pic_index --", picIndex , pic_index , i)
			if tonumber(picIndex) == tonumber(pic_index) then
				return i
			else
				i = i + 1
			end
		else
			return nil
		end
	end
end

function ShipHeadCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	-- self.size = root:getContentSize()
	
	-- self:setContentSize(self.size)
	Image_2:setSwallowTouches(false)
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	
	if self.current_type == self.enum_type._SHOW_HERO_HEAD_INFO_SHIP then

		local picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
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
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		else
			quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end

		
		
		--> print(ccui.Helper:seekWidgetByName(root, "Panel_prop"))
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {
			terminal_name = "ship_head_cell_info_ship", 
			terminal_state = 0, 
			_self = self, 
			_mouldId = self._mouldId,
			}, nil, 0)
	
	
	elseif self.current_type == self.enum_type._SHOW_HERO_HEAD_INFO_NPC then
		local picIndex = self.ship.pic_index
		local quality = self.ship.ship_type+1
		
		Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
		
		Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		
		--> print(ccui.Helper:seekWidgetByName(root, "Panel_prop"))
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {
			terminal_name = "ship_head_cell_info_npc", 
			terminal_state = 0, 
			_self = self, 
			_ship = self.ship,
			_target = self
			}, nil, 0)
	elseif self.current_type == self.enum_type._FASHION then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
			local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local quality = 1
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		else
			local picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
			local quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
			if self.fashionPic ~= nil then
				picIndex = self.fashionPic
			end
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%s.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
		
		--> print(ccui.Helper:seekWidgetByName(root, "Panel_prop"))
		
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		-- 	nil, nil, 0)
	
	else
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
				local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[tonumber(ship_evo[1])]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				item_nameIndex = word_info[3]
			else
				item_nameIndex = ship_mould.captain_name
			end
			item_mouldid= self.ship.ship_template_id
			--神将商店英雄小头像
			if item_mouldid == nil and  self.enum_type._HROE_SHOP_HEAD == self.current_type then
				item_mouldid = self.ship.goods_id
			end
			picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
			quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
			
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
				if self.current_type == self.enum_type._SHOW_SHIP_HEAD or self.current_type == self.enum_type._SHOW_HERO_HEAD_INFO then
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
						Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
					else
						Panel_prop:setBackGroundImage(string.format("images/face/hero_head/props_%d.png", picIndex))
					end
				else
					--> print(picIndex,"picIndex-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
				end
			else
				Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
			else
				Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			end
			
			
			-- Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		end
	end
		
	if self.current_type == self.enum_type._SHOW_SHIP_HEAD then
		item_name:setString(self.ship.captain_name)
		local colortype = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
		item_name:setColor(cc.c3b(color_Type[colortype][1],color_Type[colortype][2],color_Type[colortype][3]))
	end
	
	if self.current_type == self.enum_type._SHOW_HERO_HEAD_INFO then
		item_name:setVisible(false)
		
	end
	
	if self.current_type == self.enum_type._BATTLE_INFO then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
			local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local quality = 1
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		else
			local picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
			local quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
	end
	
	if self.current_type == self.enum_type._SHOW_SHIP_GETWAY then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
			local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local quality = 1
			if self.showName == true then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				_name = word_info[3]
				item_name:setString(_name)
				item_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			end
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		else
			local picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
			local quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
			if self.showName == true then
				item_name:setString(dms.string(dms["ship_mould"], self._mouldId, ship_mould.captain_name))
				item_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			end
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_cell_change_get", terminal_state = 0, _self = self, _ship = self._mouldId}, nil, 0)
	end
	if self.current_type == self.enum_type._SHOW_SHIP_NOT_CHOOSE then
		local picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
		local quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
		Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
		
		Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		
	end
	
	
	if self.enum_type._HROE_SHOP_HEAD == self.current_type then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
			{
				terminal_name = "ship_head_cell_info_shop",
				terminal_state = 0,
				_ship = self.ship
				}, nil, 0)
		if self.nums ~= nil and self.nums ~= 0 then
			item_order_level:setString("x"..self.nums)
		end
	end
	
	if self.current_type == self.enum_type._SHOW_SHIP_INFORMATION then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_cell_info", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
	
	if self.current_type == self.enum_type._SMALL_PARTNER_INFORMATION_VIEW then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_partner_cell_info", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
	
	if self.current_type == self.enum_type._SHOW_SHIP_WITH_LEVEL_NOT_CHOOSE then
		local ship_level = "1"
		if self.ship.captain_type == "0" then
			ship_level = _ED.user_info.user_grade
		else
			ship_level = self.ship.ship_grade
		end
		if verifySupportLanguage(_lua_release_language_en) == true then
			item_shuxin:setString(_string_piece_info[6]..ship_level)
		else
			item_shuxin:setString(ship_level.._string_piece_info[6])
		end
	end
	
	if self.current_type == self.enum_type._DUPLICATE then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
			local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local quality = 1
			if self.showName == true then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self._mouldId, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self._mouldId, ship_mould.captain_name)]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				_name = word_info[3]
				item_name:setString(_name)
				item_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			end
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		else
			local picIndex = dms.int(dms["ship_mould"], self._mouldId, ship_mould.head_icon)
			local quality = dms.int(dms["ship_mould"], self._mouldId, ship_mould.ship_type)+1
			if self.showName == true then
				item_name:setString(dms.string(dms["ship_mould"], self._mouldId, ship_mould.captain_name))
				item_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			end
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
				local base_ship_id = dms.int(dms["ship_mould"], self._mouldId, ship_mould.base_mould)
				picIndex = dms.int(dms["ship_mould"], base_ship_id, ship_mould.head_icon)
				Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			else	
				Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			end
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {
			terminal_name = "ship_head_cell_info_ship", 
			terminal_state = 0, 
			_self = self, 
			_mouldId = self._mouldId,ship_head_cell_info_ship
			}, nil, 0)
		if self.nums ~= nil and self.nums ~= 0 then
			item_order_level:setString("x"..self.nums)
		end
	end
	
end

function ShipHeadCell:setActivityDouble( isShow )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	if Image_double ~= nil then
    	Image_double:setVisible(isShow)
    end
end

function ShipHeadCell:onEnterTransitionFinish()
	if table.getn(self.roots) > 0 then
		return
	end
end

function ShipHeadCell:onInit()
	if table.getn(self.roots) > 0 then
		return
	end
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.size = root:getContentSize()
	
	self:setContentSize(self.size)

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end

	self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)

	if self.current_type == self.enum_type._SHOW_SHIP_HEAD or self.current_type == self.enum_type._SHOW_HERO_HEAD_INFO then
		ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)
		self:setTouchEnabled(true)
		-- ccui.Helper:seekWidgetByName(root, "Panel_kuang"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Panel_ditu"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		-- local size = self:getContentSize()
		-- ccui.Helper:seekWidgetByName(root, "Panel_prop"):setContentSize(size)
		
		-- local layer = cc.LayerGradient:create(cc.c4b(255,0,0,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
		-- layer:setAnchorPoint(cc.p(0, 0))
		-- layer:setContentSize(cc.size(self.size.width + 20, self.size.height))
		-- self:addChild(layer, -1)
	elseif self.current_type ~= self.enum_type._SHOW_SHIP_GETWAY and self.current_type ~= self.enum_type._SHOW_SHIP_NOT_CHOOSE 
	and self.current_type ~= self.enum_type._SHOW_SHIP_INFORMATION and self.current_type ~= self.enum_type._SMALL_PARTNER_INFORMATION_VIEW 
	and self.enum_type._HROE_SHOP_HEAD ~= self.current_type 
	and self.enum_type._SHOW_HERO_HEAD_INFO_SHIP ~= self.current_type 
	and self.enum_type._SHOW_HERO_HEAD_INFO_NPC ~= self.current_type
	and self.enum_type._DUPLICATE ~= self.current_type 
	and self.enum_type._BATTLE_INFO ~= self.current_type then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "ship_head_cell_change_formation_ship", terminal_state = 0, _self = self, _ship = self.ship}, nil, 0)
	end
end

function ShipHeadCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root._x ~= nil then
			root:setPositionX(root._x)
		end
		if root._y ~= nil then
			root:setPositionY(root._y)
		end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function ShipHeadCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function ShipHeadCell:constructionShipFromNPC(mouldId)

	local ship = {
		ship_template_id = mouldId,
		goods_id = nil ,
		captain_type = dms.string(dms["environment_ship"], mouldId, environment_ship.captain_type),
		ship_grade  = nil,
		captain_name  = dms.string(dms["environment_ship"], mouldId, environment_ship.ship_name),
		ship_type = dms.int(dms["environment_ship"], mouldId, environment_ship.ship_type),
		pic_index = dms.int(dms["environment_ship"], mouldId, environment_ship.pic_index),
	}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local word_info = dms.element(dms["word_mould"], tonumber(ship.captain_name))
		ship.captain_name = word_info[3]
	end
	
	return ship
end


function ShipHeadCell:init(ship, interfaceType, mouldId, nums, showName, fashionPic)
	self.ship = ship
	self.current_type = interfaceType
	self._mouldId = mouldId
	self.nums = nums
	self.showName = showName
	self.fashionPic =fashionPic -- 用于查看阵容有时装时的形象
	self:onInit()
end

function ShipHeadCell:createCell()
	local cell = ShipHeadCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

