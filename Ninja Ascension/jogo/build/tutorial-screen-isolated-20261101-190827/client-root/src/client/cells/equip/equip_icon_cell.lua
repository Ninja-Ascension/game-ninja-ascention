----------------------------------------------------------------------------------------------------
-- 说明：装备的小图标绘制
-------------------------------------------------------------------------------------------------------
EquipIconCell = class("EquipIconCellClass", Window)

function EquipIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION = 1,		-- 从阵容界面进入装备信息界面
		_SHOW_EQUIPMENT_INFORMATION = 2,					-- 查看装备信息
		_SHOW_EMBOITEMENT_INFORMATION = 3,					-- 查看套装信息(不能点击响应)
		_SHOW_EMBOITEMENT_GETWAY = 4,						-- 查看获取途径
		_SHOW_EMENT_BUY = 5,								-- 购买装备时查看信息
		_EQUIP_SHOP_HEAD = 6,									-- 神将商店装备小头像
		_SHOW_EMBOITEMENT_INFORMATION_PARTICULARS = 7,			-- 套装装备详情的头像 这个才不可点 3 那个是骗人的
		_VALUE_IS_MOULD = 8,									-- 传参为模板
		_REVIEW_OPPONENT_EQUIP = 9,									-- 查看对手阵容的装备
		_DUPLICATE = 10,									-- 副本专用
		_ACTIVITY_EQUIPICON = 11,								-- 活动专用
		_VIP_SHOW = 12,								-- Vip特权查看
		_BETRAY_ARMY_SHOP = 13,								--叛军商店装备图标
		_MOPPING_RESULT = 14,								--副本扫荡
		_VIP_PACKS = 15 ,										--vip礼包预览
		_EQUIP_SHOW = 16,									--只作显示 不能点击
		_WARCRAFT_SHOP = 17,									--竞技场商店
		_SHRED_INFO = 18,									--显示碎片信息
		_UP_SUCCESS = 19,									--装备升阶成功显示
		_BOX_OPEN_CHOOSE = 20,									--宝箱多选一
		_ROLE_STRENG = 21,									--武将仓库卡牌养成进入
	}
	self.equip = nil		-- 当前要绘制的装备实例数据对对象
	self.mould_id = nil
	self.shipData = nil   --穿戴装备的shipId
	self.is_active = false
	self.num = nil	--数量
	self.isShowName = nil
	self.isHideNameAndCount = false
	self.propName = "" --装备名称
	self.isGrayed = nil
	self.push_node = nil
	self.push_arrow = nil

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_equip_icon_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		local equip_icon_cell_change_ship_equip_terminal = {
            _name = "equip_icon_cell_change_ship_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击武将装备小图像后的响应逻辑
            	if true then
            			-- 装备，觉醒，淬炼在新的界面
						if tonumber(params._datas._equip.m_index) > 4 then
							if funOpenDrawTip(159) == true then
								return
							end
						else
							if funOpenDrawTip(96) == true then
								return
							end
						end
						app.load("client.packs.equipment.SmEquipmentQianghua")
						state_machine.excute("sm_equipment_qianghua_open",0,params._datas._equip)

						-- if tonumber(params._datas._equip.m_index) > 4 then
						-- 	if funOpenDrawTip(159) == false then
						-- 		if fwin:find("SmRoleStrengthenTabClass") ~= nil then
						-- 			state_machine.excute("hero_develop_back_to_switch_equip",0,{_datas = {m_index = params._datas._equip.m_index}})
						-- 		else
						-- 			state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = 2,m_index = params._datas._equip.m_index}})
						-- 		end
						-- 	end
						-- else
						-- 	if funOpenDrawTip(96) == false then
						-- 		if fwin:find("SmRoleStrengthenTabClass") ~= nil then
						-- 			state_machine.excute("hero_develop_back_to_switch_equip",0,{_datas = {m_index = params._datas._equip.m_index}})
						-- 		else
						-- 			state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = 2,m_index = params._datas._equip.m_index}})
						-- 		end
						-- 	end
						-- end
				else	
					local equip = params._datas._equip
	            	local cell = params._datas._cell
	            	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
	            		or __lua_project_id == __lua_project_warship_girl_b 
	            		or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge
	            		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 

	            		or __lua_project_id == __lua_project_yugioh
	            		then 
	            		--数码需要刷新升星数 
	            		state_machine.excute("open_ship_current_equip_window", 0, {_equip = equip,_cell = cell})
	            	else
	            		state_machine.excute("open_ship_current_equip_window", 0, equip)
	            	end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--获得途径
		local equip_icon_cell_change_get_terminal = {
            _name = "equip_icon_cell_change_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._ship
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(ship,1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 设计在装备界面，点击装备小图像需要处理的逻辑
		local equip_icon_cell_change_equip_storage_terminal = {
            _name = "equip_icon_cell_change_equip_storage",
            _init = function (terminal) 
               app.load("client.packs.equipment.EquipInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 设计在装备界面，点击装备小图像后的响应逻辑
            	local equip = params._datas._equip
				local equipInformation = EquipInformation:new()
				equipInformation:init(equip)
				fwin:open(equipInformation, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 设计在道具购买界面，点击装备小图像需要处理的逻辑
		local equip_icon_cell_change_shop_buy_terminal = {
            _name = "equip_icon_cell_change_shop_buy",
            _init = function (terminal) 
               app.load("client.cells.prop.prop_information")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 设计在装备界面，点击装备小图像后的响应逻辑
				local cell = propInformation:new()
				cell:init(params._datas._equip,2)
				fwin:open(cell, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_icon_cell_show_equip_info_terminal = {
            _name = "equip_icon_cell_show_equip_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.equipment.EquipFragmentInfomation")
				local prop = nil
				if params._datas._equip ~= nil then
					prop = params._datas._equip.user_equiment_template
				else
					prop = params._datas._equip2
				end
				
				if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
					and  dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 6 then
					app.load("client.packs.fashion.FashionInformation")
            		state_machine.excute("fashion_information_open", 0, {_datas={_equip = nil,_equip_mould = prop}})
            		return true

            	end
				local FragmentInformation = EquipFragmentInfomation:new()
				
				if dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 4 or 
					dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 5 or
					dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 8 then
					FragmentInformation:init(prop,2,3)
				else
					FragmentInformation:init(prop,nil,2)
				end
				fwin:open(FragmentInformation, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --升星更新了
        local equip_icon_cell_star_up_update_terminal = {
            _name = "equip_icon_cell_star_up_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				if params ~= nil and params._datas._cell ~= nil and params._datas._cell.roots ~= nil and params._datas._cell.onUpdateDraw ~= nil then
					params._datas._cell:onUpdateDraw()
					 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示装备碎片信息
        local equip_icon_cell_show_shred_info_terminal = {
            _name = "equip_icon_cell_show_shred_info",
            _init = function (terminal) 
                app.load("client.packs.hero.SmEquipAwakenPropInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local mouldId = params._datas._ship
            	local sherdMouldId = dms.int(dms["equipment_mould"] , mouldId , equipment_mould.equipment_gem_numbers)
            	if sherdMouldId == -1 then
            	else
            		state_machine.excute("sm_equip_awaken_prop_information_window_open", 0, sherdMouldId)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新推送
        local equip_icon_cell_update_push_terminal = {
            _name = "equip_icon_cell_update_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	params:pushUpdate(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(equip_icon_cell_change_ship_equip_terminal)	
		state_machine.add(equip_icon_cell_change_get_terminal)	
		state_machine.add(equip_icon_cell_change_equip_storage_terminal)	
		state_machine.add(equip_icon_cell_change_shop_buy_terminal)	
		state_machine.add(equip_icon_cell_show_equip_info_terminal)	
		state_machine.add(equip_icon_cell_star_up_update_terminal)
		state_machine.add(equip_icon_cell_show_shred_info_terminal)
		state_machine.add(equip_icon_cell_update_push_terminal)	
		state_machine.init()
	end
	init_equip_icon_cell_terminal()
end

function EquipIconCell:pushUpdate(cell)
	-- Celda ya liberada (la lista de SmEquipmentQianghua la sigue guardando).
	if cell.push_node == nil or tolua.isnull(cell.push_node) then return false end
	cell.push_node:setVisible(false)
	if cell.current_type == cell.enum_type._UP_SUCCESS then
		cell.push_node:setVisible(false)
		cell.push_arrow:setVisible(false)
		return false
	end
	-- cell.push_arrow:setVisible(false)
	local ship = fundShipWidthId(cell.equip.ship_id)
	local index = cell.equip.m_index
	-- Inventory equipment has no assigned hero or formation slot.
	if not ship or not tonumber(index) then
		if cell.push_arrow and not tolua.isnull(cell.push_arrow) then cell.push_arrow:setVisible(false) end
		return false
	end

	if equipmentIsCanEvolution(ship , index) == true and equipmentIsCanLevelUp(ship , index) == true then
		cell.push_node:setVisible(true)
		cell.push_arrow:setVisible(true)
		return true
	end

	if equipmentIsCanAwake(ship , index) == true and equipmentIsCanLevelUp(ship , index) == true then
		cell.push_node:setVisible(true)
		cell.push_arrow:setVisible(true)
		return true
	end

	-- 装备可淬炼
	if equipmentIsCanHarden(ship , index) == true then
		cell.push_node:setVisible(true)
		return true
	end

	--进阶
	if equipmentIsCanEvolution(ship , index) == true then
		cell.push_node:setVisible(true)
		return true
	end
	-- 升级
	if equipmentIsCanLevelUp(ship , index) == true then
		cell.push_arrow:setVisible(true)
		return true
	end
	--觉醒
	if equipmentIsCanAwake(ship , index) == true then
		cell.push_node:setVisible(true)
		return true
	end
end

function EquipIconCell:showCountInfo(info)
	local root = self.roots[1]
	--ccui.Helper:seekWidgetByName(root, "Label_name"):setVisible(false)
	local Label_l_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
	Label_l_order_level:setVisible(true)
	Label_l_order_level:setString(info)
end

function EquipIconCell:hideNameAndCount()
	--local root = self.roots[1]
	--ccui.Helper:seekWidgetByName(root, "Label_name"):setVisible(false)
	--ccui.Helper:seekWidgetByName(root, "Label_l-order_level"):setVisible(false)
	self.isHideNameAndCount = true
end

-- --显示强化等级
-- function EquipIconCell:showGradeLevel()
-- 	local root = self.roots[1]
-- 	local levelText = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
-- 	levelText:setString(self.equip.user_equiment_grade.._string_piece_info[6])
-- 	levelText:setVisible(true)
-- end

function EquipIconCell:onUpdateDraw()
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
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级

	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	if Panel_star ~= nil then
		Panel_star:removeAllChildren(true)
	end
	if Panel_prop ~= nil then
		Panel_prop:setTouchEnabled(true)
		Panel_prop:removeAllChildren(true)
	end
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		if item_order_level ~= nil then
			item_order_level:setColor(cc.c3b(255,255,255))
		end
	end
	
	if self.isHideNameAndCount == true then
		if item_name ~= nil then
			item_name:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setVisible(false)
		end
	end

	-- images/ui/quality
	
	local picIndex = 0
	local quality = 0
	
	item_element={
		"prop_mould",
		"equipment_mould",
		"ship_mould",
	}
	
	local item_index = nil--物品图标索引
	local item_qulityindex = nil--物品品质索引
	local item_nameIndex = nil--物品名称索引
	local item_mouldid = nil--物品模板id

	item_index = equipment_mould.pic_index
	item_qulityindex = equipment_mould.grow_level
	item_nameIndex = equipment_mould.equipment_name
	if self.equip ~= nil then
		item_mouldid= self.equip.user_equiment_template
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if zstring.tonumber(self.equip.ship_id) == 0 then
				if dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.initial_supply_escalate_exp) > 0 then
					local qt = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.grow_level)
					if qt == 1 then
						quality = 2
					elseif qt == 2 then
						quality = 5
					elseif qt == 3 then
						quality = 9
					end
				else
					quality = 1
				end
			else
				local equipInfo= nil
				if self.equip.equipInfo ~= nil then
					equipInfo= self.equip.equipInfo
				else
					equipInfo= _ED.user_ship[""..self.equip.ship_id].equipInfo
				end
				local equipData =  zstring.split(equipInfo ,"|")
				local equipAll = zstring.split(equipData[2] ,",")
				quality = tonumber(equipAll[tonumber(self.equip.m_index)]) + 1
			end
		end
	else
		item_mouldid = self.mould_id
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			quality = 1
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EMENT_BUY then
		item_mouldid = self.equip.mould_id
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if zstring.tonumber(self.equip.ship_id) == 0 then
				quality = 1
			else
				local equipInfo= nil
				if self.equip.equipInfo ~= nil then
					equipInfo= self.equip.equipInfo
				else
					equipInfo= _ED.user_ship[""..self.equip.ship_id].equipInfo
				end
				local equipData =  zstring.split(equipInfo ,"|")
				local equipAll = zstring.split(equipData[2] ,",")
				quality = tonumber(equipAll[tonumber(self.equip.m_index)]) + 1
			end
		end
	end
	--神将商店装备小头像
	if self.current_type == self.enum_type._EQUIP_SHOP_HEAD then
		item_mouldid = self.equip.goods_id
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if zstring.tonumber(self.equip.ship_id) == 0 then
				quality = 1
			else
				local equipInfo= nil
				if self.equip.equipInfo ~= nil then
					equipInfo= self.equip.equipInfo
				else
					equipInfo= _ED.user_ship[""..self.equip.ship_id].equipInfo
				end
				local equipData =  zstring.split(equipInfo ,"|")
				local equipAll = zstring.split(equipData[2] ,",")
				quality = tonumber(equipAll[tonumber(self.equip.m_index)]) + 1
			end
		end
	end
	--直接传模板
	if self.current_type == self.enum_type._VALUE_IS_MOULD or self.current_type == self.enum_type._VIP_SHOW then
		item_mouldid = self.mould_id
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			quality = 1
		end
	end
	
	if self.current_type == self.enum_type._WARCRAFT_SHOP then 
		item_mouldid = self.mould_id
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if zstring.tonumber(self.equip.ship_id) == 0 then
				quality = 1
			else
				local equipInfo= nil
				if self.equip.equipInfo ~= nil then
					equipInfo= self.equip.equipInfo
				else
					equipInfo= _ED.user_ship[""..self.equip.ship_id].equipInfo
				end
				local equipData =  zstring.split(equipInfo ,"|")
				local equipAll = zstring.split(equipData[2] ,",")
				quality = tonumber(equipAll[tonumber(self.equip.m_index)]) + 1
			end
		end
	end
	--> print("item_mouldid***********************************************", item_mouldid)
	picIndex = dms.int(dms["equipment_mould"], item_mouldid, item_index)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
		if self.current_type ~= self.enum_type._FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION then
			if dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.trace_npc_index) > 0 then
				local index = 0
				if dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.trace_npc_index) ==1 then
					index = 2
				elseif dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.trace_npc_index) ==2 then 
					index = 5
				elseif dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.trace_npc_index) ==3 then 
					index = 9
				elseif dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.trace_npc_index) ==4 then 
					index = 14
				elseif dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.trace_npc_index) ==5 then 
					index = 20
				end
				self.Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", index))
			else
				self.Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality))
			end
		else
			self.Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality))
		end
		
		if self.Panel_kuang_icon ~= nil then
			self.Panel_kuang_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
			if Panel_kuang ~= nil then
				Panel_kuang:addChild(self.Panel_kuang_icon)
			end
			if self.isGrayed ~= nil then
				display:gray(self.Panel_kuang_icon)
			else
				display:ungray(self.Panel_kuang_icon)
			end
		end
		if Panel_ditu ~= nil then
			Panel_ditu:setVisible(true)
			if self.current_type == self.enum_type._BOX_OPEN_CHOOSE then
				item_mouldid = self.equip.mould_id
				quality = dms.int(dms["equipment_mould"], tonumber(item_mouldid), equipment_mould.trace_npc_index)+1
				self.Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			else
				if __lua_project_id == __lua_project_l_digital and self.current_type == 1 then
					-- self.current_type = 1 代表从阵容界面进入装备信息界面
					self.Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_bigkuang_%d.png", shipOrEquipSetColour(quality-1)))
				else
					self.Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality-1)))
				end
			end
			if self.Panel_ditu_icon ~= nil then
				self.Panel_ditu_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
				Panel_ditu:addChild(self.Panel_ditu_icon)
				if self.isGrayed ~= nil then
					display:gray(self.Panel_ditu_icon)
				else
					display:ungray(self.Panel_ditu_icon)
				end
			end
		end

		self.Panel_prop_icon = cc.Sprite:create(getPropsPath(picIndex))
		if Panel_prop ~= nil then
			if self.Panel_prop_icon ~= nil then
				self.Panel_prop_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(self.Panel_prop_icon)
				if self.isGrayed ~= nil then
					display:gray(self.Panel_prop_icon)
				else
					display:ungray(self.Panel_prop_icon)
				end
			end
		end
	else
		quality = dms.int(dms["equipment_mould"], item_mouldid, item_qulityindex) + 1
		if Panel_kuang ~= nil then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage(getPropsPath(picIndex))
		end
	end
	
	if item_name ~= nil then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			--获取装备名称索引
			local nameindex = dms.int(dms["equipment_mould"], item_mouldid, item_nameIndex)
			--通过索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local name = word_info[3]
			--绘制
			item_name:setString(name)
			local qua = shipOrEquipSetColour(quality)
			if self.current_type == self.enum_type._BOX_OPEN_CHOOSE then
				qua = quality
			end
			item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[qua][1],tipStringInfo_quality_color_Type[qua][2],tipStringInfo_quality_color_Type[qua][3]))
		else
			item_name:setString(dms.string(dms["equipment_mould"], item_mouldid, item_nameIndex))
			item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
	end

	if Panel_num ~= nil then
		Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))
	end
	if self.equip ~= nil then 
		if item_lv ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				if self.equip.isShowLv ~= nil and self.equip.isShowLv == false then
					item_lv:setString("")
				else
					item_lv:setString("+"..self.equip.user_equiment_grade)
				end
			else
				item_lv:setString(self.equip.user_equiment_grade)
			end
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
	end
	
	if self.current_type == self.enum_type._VIP_SHOW  then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
	end
	if self.current_type == self.enum_type._EQUIP_SHOW then 
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if ccui.Helper:seekWidgetByName(root, "Panel_prop") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)	
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EMBOITEMENT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		local suit_id = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.suit_id)
		if suit_id > 0 then
			if self.equip ~= nil then
				if tonumber(self.equip.ship_id) ~= 0 then
					self.is_active = true
					if Panel_prop ~= nil then
						draw.createEffect("effect_4", "images/ui/effice/zhuangbeidonghua/effect_4.ExportJson", Panel_prop, -1, 10)
					end
				end
			else
				if self.shipData ~= nil then
					for j,v in pairs(self.shipData.equipment) do
						if v ~= nil then
							local mouldId = zstring.tonumber(v.user_equiment_template)
							if mouldId > 0 then
								local temp_suit_id = dms.int(dms["equipment_mould"],mouldId,equipment_mould.suit_id)
								local equipTypes = dms.int(dms["equipment_mould"],mouldId,equipment_mould.equipment_type)
								if tonumber(mouldId) == tonumber(item_mouldid) then
									if suit_id == temp_suit_id then
										self.is_active = true
										if Panel_prop ~= nil then
											draw.createEffect("effect_4", "images/ui/effice/zhuangbeidonghua/effect_4.ExportJson", Panel_prop, -1, 10)
										end
										break
									end
								end
							end
						end
					end
				end
			end
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_get", terminal_state = 0, _self = self, _ship = item_mouldid}, nil, 0)
		else
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_show_equip_info", terminal_state = 0, _equip = self.equip,_equip2 =self.mould_id }, nil, 0)
		end
	end
	if self.current_type == self.enum_type._SHOW_EMBOITEMENT_INFORMATION_PARTICULARS then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		fwin:removeTouchEventListener(Panel_prop)
	end
	if self.current_type == self.enum_type._SHOW_EMBOITEMENT_GETWAY then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_get", terminal_state = 0, _self = self, _ship = item_mouldid}, nil, 0)
	end

	if self.current_type == self.enum_type._SHRED_INFO then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		{
			terminal_name = "equip_icon_cell_show_shred_info", 
			terminal_state = 0, 
			_self = self, 
			_ship = item_mouldid
		}, nil, 0)
	end
	
	if self.current_type == self.enum_type._SHOW_EMENT_BUY then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._EQUIP_SHOP_HEAD then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._REVIEW_OPPONENT_EQUIP then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if Panel_num ~= nil then
				Panel_num:setVisible(false)
			end
		else
			if Panel_num ~= nil then
				Panel_num:setVisible(false)
			end
		end
	end
	
	if self.current_type == self.enum_type._DUPLICATE 
		or self.current_type == self.enum_type._BOX_OPEN_CHOOSE
		then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_order_level ~= nil then
			if self.num ~= nil then
				item_order_level:setString("x"..self.num)
				item_order_level:setVisible(true)
			else
				item_order_level:setString("x".."1")
			end
		end
		if self.current_type == self.enum_type._BOX_OPEN_CHOOSE then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "sm_prop_choose_update_draw", terminal_state = 0, cell = self }, nil, 0)
		else
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_show_equip_info", terminal_state = 0, _equip = self.equip,_equip2 =self.mould_id }, nil, 0)
		end
	end
	if self.current_type == self.enum_type._VIP_PACKS then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			if self.num ~= nil then
				item_order_level:setString("x"..self.num)
			else
				item_order_level:setString("x".."1")
			end
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_show_equip_info", terminal_state = 0, _equip = self.equip,_equip2 =self.mould_id }, nil, 0)
	end
	if self.current_type == self.enum_type._ACTIVITY_EQUIPICON then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			if self.num ~= nil then
				item_order_level:setString("x"..self.num)
			else
				item_order_level:setString("x".."1")
			end
		end
		if self.isShowName ~= nil then
			local vip_double = ccui.Helper:seekWidgetByName(root, "Panel_4")--左上角VIP双倍
			if vip_double ~= nil then
				vip_double:setVisible(true)
				vip_double:setBackGroundImage(string.format("images/ui/vip/mrqd_shuangbei_v%d.png",self.isShowName))
			end
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_show_equip_info", terminal_state = 0, _equip = self.equip,_equip2 =self.mould_id }, nil, 0)
	end
	if self.current_type == self.enum_type._BETRAY_ARMY_SHOP then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_show_equip_info", terminal_state = 0, _equip = self.equip,_equip2 =self.mould_id }, nil, 0)
	end
	if self.current_type == self.enum_type._VALUE_IS_MOULD then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_show_equip_info", terminal_state = 0, _equip = self.equip,_equip2 =self.mould_id }, nil, 0)
	end
	if self.isShowName == false then
		if item_name ~= nil then
			item_name:setVisible(false)
		end
	end
	
	if self.current_type == self.enum_type._MOPPING_RESULT then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--获取装备名称索引
				local nameindex = dms.int(dms["equipment_mould"], tonumber(self.mould_id), equipment_mould.equipment_name)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local name = word_info[3]
				--绘制
				item_name:setString(name)
			else
				local name =dms.string(dms["equipment_mould"],tonumber(self.mould_id),equipment_mould.equipment_name)
				item_name:setString(name)
			end
			item_name:setVisible(true)
		end
		if item_order_level ~= nil then
			if self.num ~= nil then
				item_order_level:setString("x"..self.num)
			else
				item_order_level:setString("x".."1")
			end
		end
		fwin:removeTouchEventListener(Panel_prop)
	end

	if self.current_type == self.enum_type._WARCRAFT_SHOP then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--获取装备名称索引
			local nameindex = dms.int(dms["equipment_mould"], tonumber(self.mould_id),equipment_mould.equipment_name)
			--通过索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local name = word_info[3]
			--绘制
			self.propName = name
		else
			local name =dms.string(dms["equipment_mould"],tonumber(self.mould_id),equipment_mould.equipment_name)
			self.propName = name
		end
		if item_order_level ~= nil then
			if self.num ~= nil then
				item_order_level:setString("x"..self.num)
			else
				item_order_level:setString("x".."1")
			end
		end
	end

	if ccui.Helper:seekWidgetByName(root, "Image_o_1") ~= nil
		and ccui.Helper:seekWidgetByName(root, "Image_o_up_1") ~= nil
		then
		self:showUpStarInfo(item_mouldid)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if item_name ~= nil then
			item_name:setVisible(false)
		end
		self:equipAddLock()
	end
end
function EquipIconCell:equipAddLock()
	local root = self.roots[1]
	local Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
	if Image_lock ~= nil then
		Image_lock:setVisible(false)
		if self.current_type == self.enum_type._FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION or self.current_type == self.enum_type._UP_SUCCESS or self.current_type == self.enum_type._ROLE_STRENG then
			if tonumber(self.equip.m_index) > 4 then
				if funOpenDrawTip(159,false) == true then
					Image_lock:setVisible(true)
				end
			end
		end
	end
end
--显示升星属性
function EquipIconCell:showUpStarInfo(item_mouldid)
	local root = self.roots[1]
	if root == nil then 
		return
	end

	--升星属性
	local imageName = ""
	for i=1,5 do
		ccui.Helper:seekWidgetByName(root, "Image_o_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_o_up_"..i):setVisible(false)
	end
	-- if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION or self.current_type == self.enum_type._SHOW_EQUIP_CHOOSE_REBORN then 
	-- 	--显示上面星星
	-- 	imageName = "Image_o_up_"
	-- end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if self.current_type == self.enum_type._FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION
			or self.current_type == self.enum_type._REVIEW_OPPONENT_EQUIP
			or self.current_type == self.enum_type._UP_SUCCESS
		 	then 
			imageName = "Image_o_up_"
		end 
	else
		if self.current_type == self.enum_type._FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION
			or self.current_type == self.enum_type._REVIEW_OPPONENT_EQUIP
			or self.current_type == self.enum_type._UP_SUCCESS
		 	then 
			--显示下面星星
			imageName = "Image_o_"
		end 
	end

	local maxStar = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.star_level)
	if imageName == "" or maxStar == nil or maxStar == -1 or self.equip == nil or self.equip.current_star_level == nil then 
		return
	end
	local currentStar = zstring.tonumber(self.equip.current_star_level)

	for i=1,5 do
		local startImage = ccui.Helper:seekWidgetByName(root, imageName ..i)
		if startImage ~= nil then
			startImage:setVisible(false)
			if i <= currentStar then 
				startImage:setVisible(true)
			end
		end
	end
end

function EquipIconCell:isActive()
	return self.is_active
end

function EquipIconCell:onEnterTransitionFinish()
end

function EquipIconCell:onInit()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()

	if self.current_type == self.enum_type._FROM_FORMATION_GOTO_EQUIPMENT_INFORMATION or self.current_type == self.enum_type._UP_SUCCESS or self.current_type == self.enum_type._ROLE_STRENG then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_ship_equip", terminal_state = 0, _equip = self.equip ,_cell = self}, nil, 0)
		local push_node = ccui.Helper:seekWidgetByName(root, "Panel_prop")
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			push_node = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
		end
		local ball = cc.Sprite:create("images/ui/bar/tips.png")
        ball:setAnchorPoint(cc.p(1, 1))
		-- DSC重塑
		if __lua_project_id == __lua_project_l_digital then
			ball:setPosition(cc.p(push_node:getContentSize().width + 30, push_node:getContentSize().height + 30))   
		else
			ball:setPosition(cc.p(push_node:getContentSize().width + 10, push_node:getContentSize().height + 10))   
		end
        push_node:addChild(ball)
        self.push_node = ball
        self.push_node:setVisible(false)
		-- pushNode._data = self.equip
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_replacement_equipment",
		-- _widget = pushNode,
		-- _invoke = nil,
		-- _interval = 0.5,})
		-- state_machine.excute("notification_center_update",0,"push_notification_center_formation_replacement_equipment")

		-- local arrowCsb = csb.createNode("icon/item_up.csb")
  --       local arrow = arrowCsb:getChildByName("root")
  		local arrow = cacher.createUIRef("icon/item_up.csb", "root")
        arrow:removeFromParent(false)
		arrow:setAnchorPoint(cc.p(0, 0))
        arrow:setPosition(cc.p((0 - arrow:getContentSize().width) / 2, (0 - arrow:getContentSize().height) / 2))   
		push_node:addChild(arrow)
        self.push_arrow = arrow
        self.push_arrow:setVisible(false)

		self:pushUpdate(self)
	elseif self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_equip_storage", terminal_state = 0, _equip = self.equip}, nil, 0)
	elseif self.current_type == self.enum_type._SHOW_EMENT_BUY then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, {terminal_name = "equip_icon_cell_change_shop_buy", terminal_state = 0, _equip = self.equip}, nil, 0)
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	    if root._x == nil then
	    	root._x = 0
	    	root:setPositionX(root._x)
	    end

	    if root._y == nil then
	    	root._y = 0
	    	root:setPositionY(root._y)
	    end
	end
end

function EquipIconCell:setChooseSelectState( isChoose )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	if Image_xuanzhong ~= nil then
    	Image_xuanzhong:setVisible(isChoose)
    end
end

function EquipIconCell:setActivityDouble( isShow )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	if Image_double ~= nil then
    	Image_double:setVisible(isShow)
    end
end

function EquipIconCell:clearUIInfo( ... )
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
	        Panel_prop:setTouchEnabled(true)
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
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
	    if Image_lock ~= nil then
	    	Image_lock:setVisible(false)
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function EquipIconCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    if self.push_arrow ~= nil  then
	    	cacher.freeRef("icon/item_up.csb", self.push_arrow)
	    end
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function EquipIconCell:init(interfaceType, equip, mould_id, shipData, isShowName, num ,isGrayed)
	self.current_type = interfaceType
	self.equip = equip
	self.mould_id = mould_id
	self.shipData = shipData
	self.isShowName = isShowName
	self.num = num
	self.isGrayed = isGrayed or nil
	
	self:onInit()
end

function EquipIconCell:createCell()
	local cell = EquipIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

