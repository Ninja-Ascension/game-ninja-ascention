----------------------------------------------------------------------------------------------------
-- 说明：阵容装备选择穿戴界面
-------------------------------------------------------------------------------------------------------

EquipFormationChoiceWear = class("EquipFormationChoiceWearClass", Window)
   
function EquipFormationChoiceWear:ctor()
    self.super:ctor()
	self.roots = {}
	self._type = nil  -- 装备类型
	self._ship = nil -- 当前武将
	self.isShowFightHero = false

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	fwin:close(fwin:find("EquipFormationChoiceWearClass"))

    local function init_equip_formation_choice_terminal()
		local equip_formation_choice_back_terminal = {
            _name = "equip_formation_choice_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local request_wear_formation_equip_terminal = {
            _name = "request_wear_formation_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("current_ship_equip_wear_request", 0, params.."|"..self._type)
				fwin:close(instance)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_choice_show_fight_hero_terminal = {
            _name = "equip_choice_show_fight_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local image = nil
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            		image = ccui.Helper:seekWidgetByName(instance.roots[1], "equip_wear_image")
            	else
            		image = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3")
            	end
        		if instance.isShowFightHero == false then	
        			image:setVisible(true)
        		elseif instance.isShowFightHero == true then
					image:setVisible(false)
        		end
    			instance.isShowFightHero = not instance.isShowFightHero
				instance:onUpdateDraw()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_formation_choice_hide_terminal = {
            _name = "equip_formation_choice_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if fwin:find("EquipFormationChoiceWearClass") ~= nil then
					fwin:find("EquipFormationChoiceWearClass"):setVisible(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_formation_choice_show_terminal = {
            _name = "equip_formation_choice_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if fwin:find("EquipFormationChoiceWearClass") ~= nil then
					if fwin:find("EquipFormationChoiceWearClass"):isVisible() == false then
						fwin:find("EquipFormationChoiceWearClass"):setVisible(true)
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_formation_choice_back_terminal)
		state_machine.add(equip_choice_show_fight_hero_terminal)
		state_machine.add(request_wear_formation_equip_terminal)
		state_machine.add(equip_formation_choice_hide_terminal)
		state_machine.add(equip_formation_choice_show_terminal)
        state_machine.init()
    end

    init_equip_formation_choice_terminal()
end

function EquipFormationChoiceWear:sortAnother(equip,ship)
		--是否缘分激活
	local Mytype = dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_type)
	local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], ship.ship_base_template_id, ship_mould.relationship_id), ",")
	for k,w in pairs(myRelatioInfo) do
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1_type) ~= 0 then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need1) == tonumber(equip.user_equiment_template) then
				return true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need2) == tonumber(equip.user_equiment_template) then
				return true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need3) == tonumber(equip.user_equiment_template) then
				return true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need4) == tonumber(equip.user_equiment_template) then
				return true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need5) == tonumber(equip.user_equiment_template) then
				return true
			end
		end
		if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6_type) ~= 0  then
			if dms.int(dms["fate_relationship_mould"], w, fate_relationship_mould.relation_need6) == tonumber(equip.user_equiment_template) then
				return true
			end
		end
	end
	return false
end

function EquipFormationChoiceWear:createEquipWear(equip, ship, drawIndex)
	local cell = EquipFormationWearListCell:createCell()
	cell:init(equip,ship, drawIndex)
	return cell
end

function EquipFormationChoiceWear:onUpdateDraw()
	local root = self.roots[1]
	local image = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		image = ccui.Helper:seekWidgetByName(root, "equip_wear_image")
	else
		image = ccui.Helper:seekWidgetByName(root, "Image_3")
	end
	if self.isShowFightHero == true then
		image:setVisible(false)
	else
		image:setVisible(true)
	end

	local listview = ccui.Helper:seekWidgetByName(root, "ListView_list")
	listview:removeAllItems()

	local sortEquip = {}
	local swapSortEquip = {}
	for i, equip in pairs(_ED.user_equiment) do
		if equip.user_equiment_id ~= nil then
			local show_choice = false
			if self.isShowFightHero == false then
				show_choice = (tonumber(equip.ship_id) == 0 and tonumber(equip.equipment_type) == tonumber(self._type))
			elseif self.isShowFightHero == true then
				show_choice = (tonumber(equip.equipment_type) == tonumber(self._type))
			end
			if show_choice == true then
				local temp = equip
				local pos = 1
				for p, v in pairs(sortEquip) do
					if temp ~= nil and (
					(tonumber(equip.ship_id) > 0 and (
							tonumber(v.ship_id) <=0 or
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.grow_level)) or 
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) or
							(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) == dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)and 
							(tonumber(v.user_equiment_grade) < tonumber(equip.user_equiment_grade)))
						)) or
						(tonumber(v.ship_id) <=0 and ((dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.grow_level) < dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.grow_level)) or 
					(dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level)< dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) or 
					((dms.int(dms["equipment_mould"], v.user_equiment_template, equipment_mould.rank_level) == dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.rank_level)) and (tonumber(v.user_equiment_grade) < tonumber(equip.user_equiment_grade)))
					))
					) then
						swapSortEquip[pos] = temp
						pos = pos + 1
						temp = nil
					end
					swapSortEquip[pos] = v
					pos = pos + 1
				end
				if temp ~= nil then
					swapSortEquip[pos] = temp
					temp = nil
				end
				sortEquip = nil
				sortEquip = {}
				for t, s in pairs(swapSortEquip) do
					sortEquip[t] = s
				end
				swapSortEquip = nil
				swapSortEquip = {}
			end
		end
	end
	
	local all = {}
	local relationship = {}
	local normal = {}
	for i,v in pairs(sortEquip) do
		local cell = self:sortAnother(v,self._ship)
		if cell == true then
			table.insert(relationship, v)
		else
			table.insert(normal, v)
		end
	end
	
	for i=1, #relationship do
		table.insert(all, relationship[i])
	end
	
	for i=1, #normal do
		table.insert(all, normal[i])
	end

	EquipFormationChoiceWear._self = self
	EquipFormationChoiceWear.myListView = listview
	EquipFormationChoiceWear.sortEquip = all
	EquipFormationChoiceWear.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(EquipFormationChoiceWear.sortEquip) do
			local cell = EquipFormationChoiceWear:createEquipWear(v,EquipFormationChoiceWear._self._ship, i)
			-- cell:init(v, i)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(EquipFormationChoiceWear.myListView, EquipFormationWearListCell.__size)
				EquipFormationChoiceWear.myListView:addChild(multipleCell)
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
	else
		for i,v in pairs(EquipFormationChoiceWear.sortEquip) do
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			self.loading(nil)
		end
	end
	
	EquipFormationChoiceWear.myListView:requestRefreshView()

	self.currentListView = EquipFormationChoiceWear.myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function EquipFormationChoiceWear:onUpdate(dt)
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
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function EquipFormationChoiceWear.loading(texture)
	local myListView = EquipFormationChoiceWear.myListView
	if myListView ~= nil then
		local cell = EquipFormationChoiceWear:createEquipWear(EquipFormationChoiceWear.sortEquip[EquipFormationChoiceWear.asyncIndex],EquipFormationChoiceWear._self._ship,EquipFormationChoiceWear.asyncIndex )
		myListView:addChild(cell)
		EquipFormationChoiceWear.asyncIndex = EquipFormationChoiceWear.asyncIndex + 1
		myListView:requestRefreshView()
	end
end

function EquipFormationChoiceWear:onEnterTransitionFinish()	
	app.load("client.cells.equip.equip_formation_wear_list_cell")
    local csbEquipStorage = csb.createNode("packs/EquipStorage/equipment_Choice.csb")
	self:addChild(csbEquipStorage)
	local root = csbEquipStorage:getChildByName("root")
	table.insert(self.roots, root)
	--> print([["ccui.Helper:seekWidgetByName(root, "Button_return")"]], root, ccui.Helper:seekWidgetByName(root, "Button_return"))
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lwj_czb"), nil, {func_string = [[state_machine.excute("equip_formation_choice_back", 0, "click equip_formation_choice_back.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_Check"), nil, {terminal_name = "equip_choice_show_fight_hero", terminal_state = 0}, nil, 0)
	self:onUpdateDraw()
	
	
end

function EquipFormationChoiceWear:init(_type,_ship)
	self._type = _type
	self._ship = _ship
end

function EquipFormationChoiceWear:onExit()
	EquipFormationChoiceWear.myListView = nil
	EquipFormationChoiceWear.asyncIndex = 1
	state_machine.remove("equip_formation_choice_back")
	state_machine.remove("request_wear_formation_equip")
	state_machine.remove("equip_choice_show_fight_hero")
	state_machine.remove("equip_formation_choice_hide")
	state_machine.remove("equip_formation_choice_show")
end

function EquipFormationChoiceWear:createCell()
	local Equip = EquipFormationChoiceWear:new()
	Equip:registerOnNodeEvent(Equip)
	return Equip
end