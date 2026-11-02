----------------------------------------------------------------------------------------------------
-- 说明：武将上阵列表控件
-------------------------------------------------------------------------------------------------------
PetFormationWearListCell = class("PetFormationWearListCellClass", Window)
PetFormationWearListCell.__size = nil

function PetFormationWearListCell:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.cells.ship.ship_head_cell")
	self.ship = nil
	self.current_type = 0
	self.havePet = false -- 是否已经上阵宠物
	self.instatsShipId = nil
	self._hasPet = false --是否以前有宠物
	self._beforePetId = 0 --之前的宠物ID
	self.enum_type = {
		_LIST_FORMATION_PET = 1,	--宠物列表中信息选择更换
		_FORMATION_PET = 2,	-- 上阵换宠
		_CHANGE_FORMATION_PET = 3,	-- 布阵时换宠
		_PET_EQUIP = 4,	--驯养
	}
	
    local function init_pet_formation_wear_list_cell_terminal()
    	--驯养
		local pet_listview_wear_list_cell_equip_terminal = {
            _name = "pet_listview_wear_list_cell_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local t_self = params._datas._self
    	     	local function responsePetEquipCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil then 
							return
						end
						state_machine.excute("formation_advanced_updata", 0,{"upPet",response.node._beforePetId})
						state_machine.excute("pet_formation_choice_back", 0,0)
					end
				end
            	protocol_command.pet_equip.param_list = "" ..t_self.instatsShipId .."\r\n".. t_self.ship.ship_id
				NetworkManager:register(protocol_command.pet_equip.code, nil, nil, nil, t_self, responsePetEquipCallback, false, nil)
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宠物列表信息中选择更换
		local pet_listview_formation_up_terminal = {
            _name = "pet_listview_formation_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	state_machine.excute("pet_information_close", 0, ship)
            	local shipId = params._datas._ship.ship_id 
            	if zstring.tonumber(shipId) == _ED.formation_pet_id then 
            		state_machine.excute("pet_formation_choice_back", 0,0)
            		return
            	end
            	local function responsePetUpCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil then 
							return
						end
						if response.node.current_type == 1 then 
							--宠物信息
							state_machine.excute("pet_list_view_update_formation", 0,0)
						elseif response.node.current_type == 3 then 
							--布阵时换宠
							state_machine.excute("formation_change_pet_update", 0,0)
							local frmationWindow = fwin:find("FormationClass")
							if frmationWindow ~= nil then 
								state_machine.excute("formation_hero_change_pet_update", 0,1)	
							end
						elseif response.node.current_type == 2 then 
							--阵容换宠
							state_machine.excute("formation_hero_change_pet_update", 0,response.node.havePet)
						end
						state_machine.excute("pet_formation_choice_back", 0,0)
					end
				end
				if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then 
					instance.havePet = 0
				else
					instance.havePet = 2
				end
				protocol_command.pet_change_formation.param_list = "" ..shipId .."\r\n".. "0"
				NetworkManager:register(protocol_command.pet_change_formation.code, nil, nil, nil, instance, responsePetUpCallback, false, nil)
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_listview_formation_up_terminal)
		state_machine.add(pet_listview_wear_list_cell_equip_terminal)
        state_machine.init()
    end
    
    init_pet_formation_wear_list_cell_terminal()
end

function PetFormationWearListCell:createHeadHead(ship,objectType)
	
	local cell = ShipHeadNewCell:createCell()
	cell:init(ship,objectType)
	return cell
end

function PetFormationWearListCell:onUpdateDraw()
	local root = self.roots[1]
	local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
	
	-- --画头像
	local heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_6")
	heroIcon:removeAllChildren(true)
	local picCell = nil
	cell = ShipHeadCell:createCell()
	cell:init(self.ship,5,self.ship.ship_template_id)
	heroIcon:addChild(cell)

	local shipData = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	-- --画名称
	local heroName = ccui.Helper:seekWidgetByName(root, "Text_name")
	local rankLevelFront = dms.atoi(shipData,ship_mould.initial_rank_level)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.ship.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		_name = word_info[3]
		heroName:setString(_name)
	else
		heroName:setString(dms.atos(shipData, ship_mould.captain_name))
	end

	heroName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	-- --画等级
	local heroLV = ccui.Helper:seekWidgetByName(root, "Text_dengji")

	heroLV:setString(self.ship.ship_grade.._string_piece_info[6])
	local power = dms.atoi(shipData,ship_mould.initial_power)
	local courage = dms.atoi(shipData,ship_mould.initial_courage)
	local intellect = dms.atoi(shipData,ship_mould.initial_intellect)
	local nimable = dms.atoi(shipData,ship_mould.initial_nimable)

	local petLevel = zstring.tonumber(self.ship.ship_grade)
	ccui.Helper:seekWidgetByName(root, "Text_gj1"):setString("".. (courage + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_courage)) )
	ccui.Helper:seekWidgetByName(root, "Text_sm1"):setString("".. (power + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_power)))
	ccui.Helper:seekWidgetByName(root, "Text_wf1"):setString("".. (intellect + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_intellect)))
	ccui.Helper:seekWidgetByName(root, "Text_ff1"):setString("".. (nimable + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_nimable)))

	local chooseButton = ccui.Helper:seekWidgetByName(self.roots[1], "Button_2")
	local Image_38 = ccui.Helper:seekWidgetByName(root, "Image_38")
	Image_38:setVisible(false)
	if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then
		if _ED.formation_pet_id == zstring.tonumber(self.ship.ship_id) then 
			Image_38:setVisible(true)
			chooseButton:setTouchEnabled(true)
			chooseButton:setColor(cc.c3b(255,255,255))
		end
	end
	local Image_38_1 = ccui.Helper:seekWidgetByName(root, "Image_38_1")
	Image_38_1:setVisible(false)
	if zstring.tonumber(self.ship.pet_equip_ship_id) > 0 then
		-- 驯养中
		Image_38_1:setVisible(true)
		chooseButton:setTouchEnabled(true)
		chooseButton:setColor(cc.c3b(255,255,255))
	end
	if zstring.tonumber(self.instatsShipId) > 0 then 
		local hero = _ED.user_ship["" ..self.instatsShipId]
		self._beforePetId = zstring.tonumber(hero.pet_equip_id)
	else
		self._beforePetId = 0
	end
end

function PetFormationWearListCell:onEnterTransitionFinish()
end

function PetFormationWearListCell:onInit()

	local root = cacher.createUIRef("packs/PetStorage/list_zcshangzhen.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	ccui.Helper:seekWidgetByName(root, "Image_38"):setVisible(false)
	self:onUpdateDraw()
	
	if PetFormationWearListCell.__size == nil then
		local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_5")
		local MySize = PanelGeneralsEquipment:getContentSize()
		-- self:setContentSize(MySize)
		PetFormationWearListCell.__size = MySize
	end
	local chooseButton = ccui.Helper:seekWidgetByName(self.roots[1], "Button_2")
	chooseButton:setTouchEnabled(true)
	chooseButton:setColor(cc.c3b(255,255,255))
	if self.current_type == self.enum_type._PET_EQUIP then 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"), nil, 
		{
			terminal_name = "pet_listview_wear_list_cell_equip", 
			_self = self, 
			isPressedActionEnabled = true
		},
		nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_2"), nil, 
		{
			terminal_name = "pet_listview_formation_up", 
			_ship = self.ship, 
			isPressedActionEnabled = true
		},
		nil, 0)
	end
	
end

function PetFormationWearListCell:onExit()

	cacher.freeRef("packs/PetStorage/list_zcshangzhen.csb", self.roots[1])
end

function PetFormationWearListCell:init(_ship,_type,id, index)
	self.ship = _ship
	self.current_type = _type
	self.instatsShipId = id			--被换下的武将id
	if index~= nil and index < 7 then
		self:onInit()
	end
	self:setContentSize(PetFormationWearListCell.__size)
	return self
end

function PetFormationWearListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PetFormationWearListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local heroIcon = ccui.Helper:seekWidgetByName(root, "Panel_6")
	if heroIcon ~= nil then 
		heroIcon:removeAllChildren(true)
	end
	
	cacher.freeRef("packs/PetStorage/list_zcshangzhen.csb", root)
	
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
	self.csbHeroSell = nil
end

function PetFormationWearListCell:createCell()
	local cell = PetFormationWearListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
