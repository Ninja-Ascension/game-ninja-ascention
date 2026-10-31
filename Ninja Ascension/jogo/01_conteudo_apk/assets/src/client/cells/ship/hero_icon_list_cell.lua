---------------------------------
---说明：
-- 创建时间:2015.11.12
-- 作者：
-- 修改记录：
-- 最后修改人：
---------------------------------
HeroIconListCell = class("HeroIconListCellClass", Window)
HeroIconListCell.__size = nil
   
function HeroIconListCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.ship = nil
	self.ishow = false
	self.showFormation = false
	self.push_node = nil

	self.zOrder = nil					-- 当前层级

	-- 点击事件类型枚举
	self.eventTypeEnum = {
        UPDATESTRENGTHEN = 1,			-- 刷新强化界面
        UPDATEFASHION = 100,			-- 
		UPDATEALLOYMATRIX = 101,		-- 刷新合金
		UPDATESILKBAG = 200,			-- 刷新宠物锦囊
        ROLEDETAIL = 300				-- 打开角色详情界面
    }

	local function init_hero_icon_list_cell_terminal()
		-- 阵容界面头像推送刷新
		local hero_icon_list_cell_formation_hero_icon_push_updata_terminal = {
			_name = "hero_icon_list_cell_formation_hero_icon_push_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params:formatHeroIconPushUpdate(params)
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		-- 武将强化界面头像推送刷新
		local hero_icon_list_cell_hero_develop_hero_icon_push_updata_terminal = {
			_name = "hero_icon_list_cell_hero_develop_hero_icon_push_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				params:heroDevelopHeroIconPushUpdate(params)
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		-- 装备强化界面头像推送刷新
		local hero_icon_list_cell_equip_strength_hero_icon_push_updata_terminal = {
			_name = "hero_icon_list_cell_equip_strength_hero_icon_push_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				params:equipStrengthHeroIconPushUpdate(params)
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}

		-- 打开上阵选择界面
		local hero_icon_list_cell_open_the_battle_window_terminal = {
			_name = "hero_icon_list_cell_open_the_battle_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local formetion_index = 1
				for i=2, 7 do
					if zstring.tonumber(_ED.formetion[i]) == 0 then
						formetion_index = i - 1
						break
					end
				end
				state_machine.excute("open_add_ship_window", 0, {_index = formetion_index, _type = 1, _shipId = -1})
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}

		--设置亮框
		local hero_icon_list_cell_set_index_terminal = {
			_name = "hero_icon_list_cell_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local ship = params._datas.ship
				local cell = params._datas.cell
				if tonumber(ship.captain_type) == 0 and self.pageshowindex == 2 then
					TipDlg.drawTextDailog(_string_piece_info[383])
					return
				end 
				if tonumber(ship.captain_type) == 2 and self.pageshowindex == 3 then
					TipDlg.drawTextDailog(_string_piece_info[384])
					return
				end
				if ship == nil then
					return
				end
				local next_terminal_name = params._datas.next_terminal_name
				state_machine.excute(next_terminal_name,0,ship)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if next_terminal_name == "formation_set_ship" then
						state_machine.excute("hero_listview_set_index",0,{_datas = {next_terminal_name = "formation_set_ship",ship = ship,cell = cell}})
					elseif next_terminal_name == "hero_develop_page_strength_to_update_ship" then
						state_machine.excute("hero_develop_page_strength_to_highlighted",0,cell)
					elseif next_terminal_name == "sm_equipment_qianghua_update_ship" then
						state_machine.excute("sm_equipment_qianghua_to_highlighted",0,cell)
					elseif next_terminal_name == "sm_role_fashion_update" then
						state_machine.excute("sm_role_fashion_choose_ship",0,cell)
					elseif next_terminal_name == "alloy_matrix_ship_update" then
						state_machine.excute("alloy_matrix_ship_choose",0,cell)
					elseif next_terminal_name == "silk_bag_hero_info" then
						state_machine.excute("silk_bag_page_strength_to_highlighted",0,cell)
					end
				end
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}

		-- 打开详情界面
		local hero_icon_list_cell_open_information_terminal = {
			_name = "hero_icon_list_cell_open_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local userID = _ED.chat_user_info.user_id
				local ship = params._datas.ship
				local cell = params._datas.cell
				local zOrder = params._datas.zOrder
				local function responseShowUserInfoCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							app.load("client.packs.hero.SmRoleInformation")
							
							local window = SmRoleInformation:new()
							window.zOrder = zOrder == nil and fwin._ui or zOrder
							window:init({response.node.ship.ship_id,-1})
							fwin:open(window, zOrder)
						end
					end
				end
				protocol_command.get_other_user_ship_info.param_list = userID.."\r\n"..ship.ship_id
				NetworkManager:register(protocol_command.get_other_user_ship_info.code, nil, nil, nil, cell, responseShowUserInfoCallBack, false, nil)
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}

		state_machine.add(hero_icon_list_cell_formation_hero_icon_push_updata_terminal)
		state_machine.add(hero_icon_list_cell_hero_develop_hero_icon_push_updata_terminal)
		state_machine.add(hero_icon_list_cell_equip_strength_hero_icon_push_updata_terminal)
		state_machine.add(hero_icon_list_cell_open_the_battle_window_terminal)
		state_machine.add(hero_icon_list_cell_set_index_terminal)
		state_machine.add(hero_icon_list_cell_open_information_terminal)
		
        state_machine.init()
    end
    
    init_hero_icon_list_cell_terminal()
end

--阵容界面头像推送刷新
function HeroIconListCell:formatHeroIconPushUpdate( cell )
	if cell.noTips == true then
		return
	end
	cell.push_node:setVisible(false)
	local ship = cell.ship
	if ship == nil then
		if getSortedHeroesFormationtips() == true then
			cell.push_node:setVisible(true)
		end
		return
	end
	--升星
	if shipIsCanUpGradeStar(ship) == true then
		cell.push_node:setVisible(true)
		return true
	end
	--进阶
	if shipIsCanEvolution(ship) == true then
		cell.push_node:setVisible(true)
		return true
	end
	if shipIsCanProcess(ship) == true then
    	cell.push_node:setVisible(true)
        return true
    end
	for i = 1 , 6 do
		--装备进阶
		if equipmentIsCanEvolution(ship , i) == true then
			cell.push_node:setVisible(true)
			return true
		end
		--装备觉醒
		if equipmentIsCanAwake(ship , i) == true then
			cell.push_node:setVisible(true)
			return true
		end
	end 

	-- 装备淬炼
	if shipEquipmentIsCanHarden(ship) == true then
    	cell.push_node:setVisible(true)
        return true
    end
end

--武将强化界面头像推送刷新
function HeroIconListCell:heroDevelopHeroIconPushUpdate( cell )
	if cell.noTips == true then
		return
	end
	cell.push_node:setVisible(false)
	local ship = cell.ship
	if shipIsCanEvolution(ship) == true then
		cell.push_node:setVisible(true)
        return true
    end 
    if shipIsCanUpGradeStar(ship) == true then
    	cell.push_node:setVisible(true)
        return true
	end
	
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	self:equipStrengthHeroIconPushUpdate(cell)
    end
end
--装备强化界面头像推送刷新
function HeroIconListCell:equipStrengthHeroIconPushUpdate( cell )
	if cell.noTips == true then
		return
	end
	cell.push_node:setVisible(false)
	local ship = cell.ship
	if shipEquipmentIsCanEvolution(ship) == true then
		cell.push_node:setVisible(true)
        return true
    end
    if shipEquipmentIsCanAwake(ship) == true then
    	cell.push_node:setVisible(true)
        return true
	end
	
	if shipEquipmentIsCanHarden(ship) == true then
    	cell.push_node:setVisible(true)
        return true
    end
	-- for i = 1 , 6 do
 --        if equipmentIsCanEvolution(ship , i) == true then
 --        	cell.push_node:setVisible(true)
 --            return true
 --        end
 --        if equipmentIsCanAwake(ship , i) == true then
 --        	cell.push_node:setVisible(true)
 --            return true
 --        end
 --    end
end

function HeroIconListCell:onUpdateDrawOpen( ... )
-- 28	第2阵位	28	2	0	2级开启	2级开启
-- 29	第3阵位	29	3	0	3级开启	3级开启
-- 30	第4阵位	30	9	0	9级开启	9级开启
-- 31	第5阵位	31	16	0	16级开启	16级开启
-- 32	第6阵位	32	25	0	25级开启	25级开启
	local isopen,tip = getFunopenLevelAndTip(self.index+26)
	if self.index == 1 then
		isopen = true
	end
	local root = self.roots[1]
	local Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
	local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop")
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_zhenxing")
	local images_chuandai =  ccui.Helper:seekWidgetByName(root, "Image_line_equ")
	local images_shangzhen = ccui.Helper:seekWidgetByName(root, "Image_line_role")
	local images_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
	local textlv =  ccui.Helper:seekWidgetByName(root, "Text_equip_lv")
	local Image_600 = ccui.Helper:seekWidgetByName(root,"Image_600")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu")
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local Image_keshangzhen = ccui.Helper:seekWidgetByName(root, "Image_keshangzhen")
	if Panel_star ~= nil then
		Panel_star:removeAllChildren(true)
	end
	if Image_keshangzhen ~= nil then
		Image_keshangzhen:setVisible(false)
	end

	Image_600:setVisible(false)	
	textlv:setString("")
	textlv:setVisible(false)	
	images_chuandai:setVisible(false)
	images_shangzhen:setVisible(false)
	images_zhushou:setVisible(false)

	Panel_ditu:removeBackGroundImage()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", 0))
	else
		Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", 1))
	end
	Panel_zhenxing:removeBackGroundImage()
	Panel_kuang:removeBackGroundImage()
	Panel_prop:removeBackGroundImage()
	Panel_4:setVisible(true)
	local level = dms.int(dms["fun_open_condition"],self.index+26,fun_open_condition.level)

	if isopen == true then
		Panel_4:setVisible(false)
		self:formatHeroIconPushUpdate(self)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "hero_icon_list_cell_open_the_battle_window", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false
			},	
			nil, 0)	
		else
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "formation_back_to_home_page", 
				terminal_state = 0, 
				isPressedActionEnabled = false
			},	
			nil, 0)	
		end
		if Image_keshangzhen ~= nil then
			Image_keshangzhen:setVisible(true)
		end
	else
		Image_4:setVisible(true)
		fwin:removeTouchEventListener(Panel_prop)
	end
end

function HeroIconListCell:onUpdateDraw()
	if self.ship == nil then
		self:onUpdateDrawOpen()
		return
	end
	local root = self.roots[1]
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local Image_keshangzhen = ccui.Helper:seekWidgetByName(root, "Image_keshangzhen")
	local Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	if Panel_star ~= nil then
		Panel_star:removeAllChildren(true)
	end
	if Image_keshangzhen ~= nil then
		Image_keshangzhen:setVisible(false)
	end

	Text_num:setVisible(false)
	Text_time:setVisible(false)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		-- 300 打开数码兽详情界面
		if self.m_type ~= nil then
			if tonumber(self.m_type) == self.eventTypeEnum.UPDATESTRENGTHEN then
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "hero_icon_list_cell_set_index", 
					next_terminal_name = "sm_equipment_qianghua_update_ship", 
					terminal_state = 0, 
					ship = self.ship,
					cell = self,
					isPressedActionEnabled = false
				},	
				nil, 0)
			elseif tonumber(self.m_type) == self.eventTypeEnum.UPDATEFASHION then
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "hero_icon_list_cell_set_index", 
					next_terminal_name = "sm_role_fashion_update", 
					terminal_state = 0, 
					ship = self.ship,
					cell = self,
					isPressedActionEnabled = false
				},	
				nil, 0)
			elseif tonumber(self.m_type) == self.eventTypeEnum.UPDATEALLOYMATRIX then
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "hero_icon_list_cell_set_index", 
					next_terminal_name = "alloy_matrix_ship_update", 
					terminal_state = 0, 
					ship = self.ship,
					cell = self,
					isPressedActionEnabled = false
				},	
				nil, 0)
			elseif tonumber(self.m_type) == self.eventTypeEnum.UPDATESILKBAG then
				fwin:addTouchEventListener(Panel_prop,nil,
				{
					terminal_name = "hero_icon_list_cell_set_index", 
					next_terminal_name = "silk_bag_hero_info", 
					terminal_state = 0,
					ship = self.ship,
					cell = self,
					isPressedActionEnabled = false
			 	},
			 	nil,0)
			elseif tonumber(self.m_type) == self.eventTypeEnum.ROLEDETAIL then
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "hero_icon_list_cell_open_information", 
					terminal_state = 0, 
					ship = self.ship,
					cell = self,
					zOrder = self.zOrder,
					isPressedActionEnabled = false
				},	
				nil, 0)		
			else
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "hero_icon_list_cell_set_index", 
					next_terminal_name = "hero_develop_page_strength_to_update_ship", 
					terminal_state = 0, 
					ship = self.ship,
					cell = self,
					isPressedActionEnabled = false
				},	
				nil, 0)		
			end
		else
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "hero_listview_set_index", 
				next_terminal_name = "formation_set_ship",
				terminal_state = 0, 
				ship = self.ship,
				cell = self,
				isPressedActionEnabled = false
			},	
			nil, 0)		
		end
	else
		fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "hero_listview_set_index", 
				next_terminal_name = "formation_set_ship",
				terminal_state = 0, 
				ship = self.ship,
				cell = self,
				isPressedActionEnabled = false
			},	
			nil, 0)	
	end

	local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
	if Panel_4 ~= nil then
		Panel_4:setVisible(false)
		fwin:removeTouchEventListener(Panel_4)
	end
	local push_node = Panel_prop
	if self.showFormation == true then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			push_node._data = self.ship.ship_id
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_replacement_equipment_ship",
			_widget = push_node,
			_invoke = nil,
			_interval = 0.5,})
		end
	else
		Panel_prop:removeAllChildren(true)
	end	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		push_node = ccui.Helper:seekWidgetByName(root, "Panel_tuisong")
		push_node._data = self.ship
		if self.push_type == 1 then -- 阵容头像推送包含武将强化和装备
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_ship_icon",
			-- _widget = push_node,
			-- _invoke = nil,
			-- _interval = 0.5,})
			-- state_machine.excute("notification_center_update",0,"push_notification_center_formation_ship_icon")
			self:formatHeroIconPushUpdate(self)
		elseif self.push_type == 2 then --武将强化界面图标 只包含武将
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_ship_strength_icon",
			-- _widget = push_node,
			-- _invoke = nil,
			-- _interval = 0.5,})
			-- state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_ship_strength_icon")
			self:heroDevelopHeroIconPushUpdate(self)
		elseif self.push_type == 3 then-- 装备强化界面武将图标 只包含装备
			-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_equip_strength_icon",
			-- _widget = push_node,
			-- _invoke = nil,
			-- _interval = 0.5,})
			-- state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_equip_strength_icon")
			self:equipStrengthHeroIconPushUpdate(self)
		end
	end
	local Panel_zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_zhenxing")
	local images_chuandai =  ccui.Helper:seekWidgetByName(root, "Image_line_equ")
	local images_shangzhen = ccui.Helper:seekWidgetByName(root, "Image_line_role")
	local images_zhushou = ccui.Helper:seekWidgetByName(root, "Image_zhushou")
	local Image_600 = ccui.Helper:seekWidgetByName(root,"Image_600")
	Image_600:setVisible(false)
	Image_600:setVisible(self.ishow)
	local picIndex = 0
	local quality = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.ship.evolution_status, "|")
		local evo_mould_id = smGetSkinEvoIdChange(self.ship)
		if zstring.tonumber(self.ship.skin_id) ~= 0 then
	    	evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
	    end
		picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		quality = tonumber(self.ship.Order)
	else
		picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.head_icon)
		quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		
		neWshowShipStar(Panel_star,tonumber(self.ship.StarRating))
	end
	-- local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
	local capacity = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.capacity)
	Panel_prop:removeBackGroundImage()
	Panel_ditu:removeBackGroundImage()
	Panel_kuang:removeBackGroundImage()
	Panel_zhenxing:removeBackGroundImage()
	Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality+1))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else	
		Panel_zhenxing:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", capacity))
	end
	local textlv =  ccui.Helper:seekWidgetByName(root, "Text_equip_lv")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		textlv:setString(self.ship.ship_grade)
		textlv:setVisible(true)
	else
		textlv:setString("")
		textlv:setVisible(false)
	end

	images_chuandai:setVisible(false)
	images_shangzhen:setVisible(false)
	images_zhushou:setVisible(false)
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
	-- 	then
	-- else
		for i,v in pairs(_ED.user_formetion_status) do
			if self.ship.ship_id == v then
				images_shangzhen:setVisible(true)
				break
			end
		end
		for i,v in pairs(_ED.little_companion_state) do
			if self.ship.ship_id == v then
				images_shangzhen:setVisible(true)
				break
			end
		end
	-- end
	if self.ship.inResourceFromation == true then
		images_zhushou:setVisible(true)
	end	

	-- pmc武将图标显示ssr
	if true then
		local ability = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ability)
		local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
		ssrIcon:setVisible(true)
		ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
	end

	if __lua_project_id == __lua_project_l_digital then 
		-- 武将限定卡SP标签
		local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
		DisplaySpCardTag(self.ship.ship_template_id, spIcon)
	else
		-- 武将限定卡显示
		local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
		if Panel_xianding then 
			Panel_xianding:setVisible(false)
			Panel_xianding:removeAllChildren(true)
			DisplayLimitCard(self.ship.ship_template_id , Panel_xianding , 1)
		end
	end
end

-- 按钮是否可响应点击事件
function HeroIconListCell:onControlClick(canClick)
	local root = self.roots[1]
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:setTouchEnabled(canClick)
end

function HeroIconListCell:onEnterTransitionFinish()

end
function HeroIconListCell:setSelected(params)
	local root = self.roots[1]
	if root == nil or self.roots == {} then
		return
	end
	local Image_600 = ccui.Helper:seekWidgetByName(root,"Image_600")
	if Image_600 ~= nil then
		Image_600:setVisible(params)
	end
end
function HeroIconListCell:onInit()
	local root = cacher.createUIRef("formation/line_up_icon_up.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if HeroIconListCell.__size == nil then
 		local Panel_list_cell_size = ccui.Helper:seekWidgetByName(root,"Panel_list_cell_size")
 		HeroIconListCell.__size = Panel_list_cell_size:getContentSize()
 	end
 -- 	local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop")
	-- fwin:addTouchEventListener(Panel_prop, nil, 
	-- {
	-- 	terminal_name = "hero_listview_set_index", 
	-- 	next_terminal_name = "formation_set_ship",
	-- 	terminal_state = 0, 
	-- 	ship = self.ship,
	-- 	cell = self,
	-- 	isPressedActionEnabled = false
	-- },	
	-- nil, 0)	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local push_node = ccui.Helper:seekWidgetByName(root, "Panel_tuisong")
		local ball = cc.Sprite:create("images/ui/bar/tips.png")
        ball:setAnchorPoint(cc.p(1, 0.7))
        ball:setPosition(cc.p(push_node:getContentSize().width, push_node:getContentSize().height))   
        push_node:addChild(ball)
        self.push_node = push_node
        push_node:setVisible(false)
	end	
	self:onUpdateDraw()
end

function HeroIconListCell:clearUIInfo()
	local root = self.roots[1]
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_zhenxing = ccui.Helper:seekWidgetByName(root, "Panel_zhenxing")
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local textlv =  ccui.Helper:seekWidgetByName(root, "Text_equip_lv")
	local push_node = ccui.Helper:seekWidgetByName(root, "Panel_tuisong")
	local Image_keshangzhen = ccui.Helper:seekWidgetByName(root, "Image_keshangzhen")
	local images_shangzhen = ccui.Helper:seekWidgetByName(root, "Image_line_role")
	local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
	local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
	if ssrIcon then
		ssrIcon:setVisible(false)
	end
	if Panel_xianding ~= nil then 
        Panel_xianding:removeAllChildren(true)
    end

	if Panel_ditu ~= nil then
		Panel_ditu:removeBackGroundImage()
	end
	if Panel_zhenxing ~= nil then
		Panel_zhenxing:removeBackGroundImage()
	end
	if Panel_kuang ~= nil then
		Panel_kuang:removeBackGroundImage()
	end
	if Panel_prop ~= nil then
		Panel_prop:removeBackGroundImage()
	end
	if Panel_star ~= nil then
		Panel_star:removeAllChildren(true)
	end
	if textlv ~= nil then
		textlv:setString("")
	end
	if push_node ~= nil then
		push_node:removeAllChildren(true)
		push_node:setVisible(false)
	end
	if Image_keshangzhen ~= nil then
		Image_keshangzhen:setVisible(false)
	end
	if images_shangzhen ~= nil then
		images_shangzhen:setVisible(false)
	end
end

function HeroIconListCell:onExit()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self:clearUIInfo()
	end
	cacher.freeRef("formation/line_up_icon_up.csb", self.roots[1])
end

function HeroIconListCell:init(ship,index,showFormation,m_type,push_type, noTips)
	self.ship = ship
	self.index = index
	self.showFormation = showFormation
	self.m_type = m_type or nil
	if push_type ~= nil then --推送类型 1 武将，装备都计算 2 只计算武将 3 只计算装备
		self.push_type = push_type
	end
	self.noTips = noTips or nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self:onInit()
	else
		if index ~= nil and index < 7 then
			self:onInit()
		end
	end
	self:setContentSize(HeroIconListCell.__size)
	return self
end

function HeroIconListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeroIconListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("formation/line_up_icon_up.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function HeroIconListCell:createCell()
	local cell = HeroIconListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
