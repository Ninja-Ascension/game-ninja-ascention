----------------------------------------------------------------------------------------------------
-- 说明：宠物的阵容小图标绘制
-------------------------------------------------------------------------------------------------------
PetIconCell = class("PetIconCellClass", Window)

function PetIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FORMATION_CHANGE_PET_PAGE_VIEW = 1,	-- 阵容界面ICON战宠
		_FORMATION_UN_UP = 2,					-- 阵容界面宠物未上阵
		_FORMATION_UN_OPEN_PET = 3,				-- 阵容界面宠物未开启
		_SHOW_PET_INFORMATION = 4,				-- 查看战宠信息
		_FORMATION_CHANGE_UN_OPEN = 5,			-- 更换阵型中宠物未开启
		_FORMATION_CHANGE_ON_UP = 6,			-- 更换阵型中宠物未上阵
		_FORMATION_PET_EQUIP_UN_OPEN = 7,	    -- 驯养中宠物未开启
	}
	self.ship = nil		-- 当前要绘制的战船实现数据对对象
	
	self.panelFour = nil
	-- 初始化战宠小像事件响应需要使用的状态机
	local function init_pet_head_cell_terminal()
		
		-- 设计在升级界面，点击战宠全身图像需要处理的逻辑
		local pet_head_cell_show_choose_terminal = {
            _name = "pet_head_cell_show_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 这里不处理，而是让他穿透
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
		state_machine.add(pet_head_cell_show_choose_terminal)		
        state_machine.init()
	end
	init_pet_head_cell_terminal()
end

function PetIconCell:onUpdateDraw()
	local root = self.roots[1]
	
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)

	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_add = ccui.Helper:seekWidgetByName(root, "Panel_add")
	local Panel_lock = ccui.Helper:seekWidgetByName(root, "Panel_lock")
	Panel_lock:setVisible(false)
	Panel_add:setVisible(false)
	Panel_prop:removeBackGroundImage()
	Panel_prop:setSwallowTouches(false)
	--阵容
	if self.ship == 0 then
	else
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
			_name = word_info[3]
			item_nameIndex = _name
		else
			item_nameIndex = ship_mould.captain_name
		end
		item_mouldid= self.ship.ship_template_id
		picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
		capacity = dms.int(dms["ship_mould"], item_mouldid, ship_mould.capacity)
		quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
			
		Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	end

	if self.current_type == self.enum_type._FORMATION_CHANGE_PET_PAGE_VIEW then
	elseif self.current_type == self.enum_type._FORMATION_UN_UP
		or self.current_type == self.enum_type._FORMATION_CHANGE_ON_UP
	then  --未上阵
		Panel_add:setVisible(true)
	elseif self.current_type == self.enum_type._FORMATION_UN_OPEN_PET 
		or self.current_type == self.enum_type._FORMATION_CHANGE_UN_OPEN
		or self.current_type == self.enum_type._FORMATION_PET_EQUIP_UN_OPEN
	 then  --未开启
		Panel_lock:setVisible(true)
	end
	if self.current_type == self.enum_type._FORMATION_PET_EQUIP_UN_OPEN then 
		--不需要显示文字
		ccui.Helper:seekWidgetByName(root, "Text_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_1_0"):setVisible(false)
	end
end

function PetIconCell:setScalePanel(n)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_29"):setScale(n)
end

function PetIconCell:onEnterTransitionFinish()

	if table.getn(self.roots) > 0 then
		return
	end

end

function PetIconCell:onInit()

	if table.getn(self.roots) > 0 then
		return
	end
	local csbItem = csb.createNode("formation/line_up_icon_pet_up.csb")
	local root = nil
	root = csbItem:getChildByName("root")
	if self.current_type == self.enum_type._SHOW_PET_INFORMATION 
	or self.current_type == self.enum_type._FORMATION_CHANGE_UN_OPEN
	or self.current_type == self.enum_type._FORMATION_CHANGE_ON_UP
	or self.current_type == self.enum_type._FORMATION_PET_EQUIP_UN_OPEN
	then
		root = ccui.Helper:seekWidgetByName(root, "Panel_29")
		root:setPosition(cc.p(0, 0))
		root:setAnchorPoint(cc.p(0, 0))
	end
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	self:onUpdateDraw()

	if self.current_type == self.enum_type._HERO_STRENGTHEN then
	
	end
end

function PetIconCell:onExit()
	-- state_machine.remove("pet_head_cell_show_choose")
end

function PetIconCell:init(ship, interfaceType)
	self.ship = ship
	self.current_type = interfaceType
	self:onInit()
end

function PetIconCell:createCell()
	local cell = PetIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

