-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面4子界面
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageFourChild = class("HeroPatchInformationPageFourChildClass", Window)

function HeroPatchInformationPageFourChild:ctor()
    self.super:ctor()
	self.roots = {}
	self.shipId = nil
	self.types = nil
	self.des = nil
	self.name = nil
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
    local function init_hero_patch_information_page_four_child_terminal()
		
		local hero_patch_information_Page_four_child_get_terminal = {
            _name = "hero_patch_information_Page_four_child_get",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._ship
				local types	= params._datas._type
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				if tonumber(types) == 1 then
					cell:init(ship, 1)
				else
					cell:init(ship)
				end
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_patch_information_Page_four_child_get_terminal)
        state_machine.init()
    end
    init_hero_patch_information_page_four_child_terminal()
end

function HeroPatchInformationPageFourChild:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_wj = ccui.Helper:seekWidgetByName(root, "Panel_wj")				 --武将头像
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")			 --武将名字
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")					 --羁绊描述
	--> print("self.types == 0=======",self.types == 0)
	if self.types == 0 then														--武将
		local name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        --进化形象
	        local evo_image = dms.string(dms["ship_mould"], self.shipId, ship_mould.fitSkillTwo)
	        local evo_info = zstring.split(evo_image, ",")
	        --进化模板id
	        -- local ship_evo = zstring.split(self._ship.evolution_status, "|")
	        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.shipId, ship_mould.captain_name)]
	        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
	        local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]
	    else
			name = dms.string(dms["ship_mould"], self.shipId, ship_mould.captain_name)
		end

		local quality = dms.int(dms["ship_mould"], self.shipId, ship_mould.ship_type)+1
		local cell = ShipHeadCell:createCell()
		cell:init(nil, cell.enum_type._SHOW_SHIP_GETWAY, self.shipId)
		Panel_wj:addChild(cell)
		Text_name:setString(name)
		Text_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		Text_2:setString("["..self.name .."]"..self.des)
	elseif self.types == 1 then													--装备
		local name = dms.string(dms["equipment_mould"], self.shipId, equipment_mould.equipment_name)
		local quality = dms.int(dms["equipment_mould"], self.shipId, equipment_mould.grow_level)+1
		local cell = EquipIconCell:createCell()
		cell:init(cell.enum_type._SHOW_EMBOITEMENT_GETWAY,nil, self.shipId)
		Panel_wj:addChild(cell)
		Text_name:setString(name)
		Text_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		Text_2:setString("["..self.name .."]"..self.des)
	end
end

function HeroPatchInformationPageFourChild:onEnterTransitionFinish()
	local csbHeroPatchInformationPageFourChild= csb.createNode("packs/yuanfen_huoqu.csb")
	
    self:addChild(csbHeroPatchInformationPageFourChild)
	local root = csbHeroPatchInformationPageFourChild:getChildByName("root")
	table.insert(self.roots, root)
	
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		-- func_string = [[state_machine.excute("hero_patch_information_Page_four_child_get", 0, "hero_patch_information_Page_four_child_get.'")]]
		terminal_name = "hero_patch_information_Page_four_child_get", 
		terminal_state = 0, 
		_ship = self.shipId,
		_type = self.types,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
end

function HeroPatchInformationPageFourChild:onExit()
	state_machine.remove("hero_patch_information_Page_four_child_get")
end

function HeroPatchInformationPageFourChild:init(shipId,name,des,types)
	self.shipId = shipId
	self.name = name
	self.des = des
	self.types = types
end

function HeroPatchInformationPageFourChild:createCell()
	local cell = HeroPatchInformationPageFourChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end