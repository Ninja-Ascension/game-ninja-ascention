----------------------------------------------------------------------------------------------------
-- 说明：武将选择信息列(武将出售,经验武将选择)
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PetChooseListCell = class("PetChooseListCellClass", Window)
PetChooseListCell.__size = nil
 
function PetChooseListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.status = false
	self.heroInstance = nil	
	self.interfaceType = 0
	self.num = nil   --宠物强化中 false 未选中，true选中
	self.enum_type = {
		_PET_RESOLVE_CHOOSE = 1, -- 分解，解雇
		_PET_REBORN_CHOOSE = 2, --重生
	}
	
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_pet_choose_list_cell_terminal()
    	--选择分解
		local pet_choose_list_page_resolve_terminal = {
            _name = "pet_choose_list_page_resolve",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local tempCell = params._datas.cell
				state_machine.excute("pet_resolve_show_pet_info", 0, {_datas = {cell = params._datas.cell}})
				state_machine.excute("pet_choose_resolve_page_close", 0, "pet_choose_resolve_page_close.")
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择重生
		local pet_choose_list_page_reborn_terminal = {
			_name = "pet_choose_list_page_reborn",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				
				state_machine.excute("pet_reborn_show_pet_info", 0, {_datas = {cell = params._datas.cell}})
				state_machine.excute("pet_choose_reborn_close", 0, "pet_choose_reborn_close.")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(pet_choose_list_page_resolve_terminal)
		state_machine.add(pet_choose_list_page_reborn_terminal)
        state_machine.init()
    end
	
    init_pet_choose_list_cell_terminal()
end


function PetChooseListCell:onEnterTransitionFinish()
	-- self:setContentSize(cc.size(344,152))
end

function PetChooseListCell.onImageLoaded(texture)
	
end

function PetChooseListCell:onArmatureDataLoad(percent)
	
end

function PetChooseListCell:setSelected(isbool)
	
end

function PetChooseListCell:onLoad()

	self:onInit()
    
end

function PetChooseListCell:onInit()
	local root = cacher.createUIRef("refinery/refinery_pet_cs_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if PetChooseListCell.__size == nil then
	 	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_generals_cs")
		local MySize = PanelGeneralsEquipment:getContentSize()
	 	PetChooseListCell.__size = MySize
	 end
		
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props")
	head:removeAllChildren(true)
	head:removeBackGroundImage()
	local name = ccui.Helper:seekWidgetByName(root, "Text_pet_name")
	local level = ccui.Helper:seekWidgetByName(root, "Label_property_2")
	local train = ccui.Helper:seekWidgetByName(root, "Label_property_4")

	train:setString(""..self.heroInstance.train_level .. _string_piece_info[46])
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.heroInstance.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		_name = word_info[3]
		name:setString(_name)
	else
		name:setString(dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.captain_name))
	end

	level:setString(""..self.heroInstance.ship_grade)

	if self.interfaceType == self.enum_type._PET_RESOLVE_CHOOSE then
		fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Button_Wear"), 
			nil, 
			{
				terminal_name = "pet_choose_list_page_resolve",	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
	elseif self.interfaceType == self.enum_type._PET_REBORN_CHOOSE then
		fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Button_Wear"), 
			nil, 
			{
				terminal_name = "pet_choose_list_page_reborn",	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
	end
	
	local hero_data = dms.element(dms["ship_mould"], self.heroInstance.ship_template_id)
	local colortype = dms.atoi(hero_data, ship_mould.ship_type)
	name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	local hero_head = ShipHeadNewCell:createCell()
	hero_head:init(self.heroInstance,5,self.heroInstance.ship_template_id)
	head:removeAllChildren(true)
	head:addChild(hero_head)

	local awakenLevel = dms.atoi(hero_data, ship_mould.initial_rank_level)  --进阶前的进阶等级
	for i=1,5 do
		local startImage = ccui.Helper:seekWidgetByName(root, "Image_x_"..i)
		local closeImage = ccui.Helper:seekWidgetByName(root, "Image_x_"..i)
		startImage:setVisible(false)
		if i <= awakenLevel then 
			startImage:setVisible(true)
		end
	end
end

function PetChooseListCell:close( ... )
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_props")
	head:removeAllChildren(true)
end

function PetChooseListCell:onExit()
	cacher.freeRef("refinery/refinery_pet_cs_list.csb", self.roots[1])
end

function PetChooseListCell:init(heroInstance, interfaceType, index)
	self.heroInstance = heroInstance
	if interfaceType ~= nil then
		self.interfaceType = interfaceType
	end
	self:onInit()

	self:setContentSize(PetChooseListCell.__size)
	return self
end

function PetChooseListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PetChooseListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local head = ccui.Helper:seekWidgetByName(root, "Panel_props")
	if head ~= nil then
		head:removeAllChildren(true)
	end
	cacher.freeRef("refinery/refinery_pet_cs_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end


function PetChooseListCell:createCell()
	local cell = PetChooseListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end