---------------------------------
---说明：宠物碎片选项卡
---------------------------------

PetFragmentSeatCell = class("PetFragmentSeatCellClass", Window)
PetFragmentSeatCell.__size = nil

function PetFragmentSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.heroInstance = nil

	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.packs.hero.HeroPatchInformation")
	app.load("client.packs.hero.HeroFragmentSeatCombining")
    local function init_hero_fragment_find_terminal()
		--去寻找
		local pet_fragment_seat_find_terminal = {
            _name = "pet_fragment_seat_find",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.HeroPatchListView)
				
				local prop = params._datas._prop.user_prop_template --道具模板id
				local equipId = dms.int(dms["prop_mould"], prop, prop_mould.use_of_ship)
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(prop,5)
				
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--合成
		local pet_fragment_compound_terminal = {
            _name = "pet_fragment_compound",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseCompoundHeroCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						local cell = HeroPatchInformation:new()
						cell:init(response.node._datas._instence,2)
					
						fwin:open(cell, fwin._view)
						
						local cell = HeroFragmentSeatCombining:new()
						fwin:open(cell, fwin._view)
						
						state_machine.excute("pet_fragment_seat_cell_update", 0, {_datas = {cell = response.node._datas.cell}})
						state_machine.excute("pet_list_view_insert_cell", 0, _ED.recruit_success_ship_ids)
						state_machine.excute("pet_handbook_page_refresh", 0, 0)
						
					end
				end
				
				_ED.recruit_success_ship_ids = ""
				protocol_command.prop_compound.param_list = ""..params._datas.mould_id.."\r\n".."1".."\r\n".."1"
				NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, params, responseCompoundHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_fragment_seat_cell_update_terminal = {
            _name = "pet_fragment_seat_cell_update",
            _init = function (terminal) 
            end,
            _inited = false,	
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				if tempCell.heroInstance == nil or tonumber(tempCell.heroInstance.prop_number) <= 0 then
					state_machine.excute("pet_patch_remove_item", 0, tempCell)
				else
					tempCell:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_fragment_seat_find_terminal)
		state_machine.add(pet_fragment_compound_terminal)
		state_machine.add(pet_fragment_seat_cell_update_terminal)
        state_machine.init()
    end
    
    init_hero_fragment_find_terminal()
end


function PetFragmentSeatCell:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")	
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_name")		--hero_name
	
	local Button_2 = ccui.Helper:seekWidgetByName(root, "Button_2")		--合成按钮
	local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")		--去获取按钮

	local Text_sl = ccui.Helper:seekWidgetByName(root, "Text_shuliang_0")		--数量

	local mouldData = dms.element(dms["prop_mould"], self.heroInstance.user_prop_template)
	
	local str = self.heroInstance.prop_number .."/"..dms.atos(mouldData, prop_mould.split_or_merge_count)
	Text_sl:setString(str)

	local hero_head = PropIconNewCell:createCell()
	hero_head:init(hero_head.enum_type._SHOW_HERO_INFORMATION, self.heroInstance)
	Panel_6:removeAllChildren(true)
	Panel_6:addChild(hero_head)
	
	Text_1:setString(self.heroInstance.prop_name)
	
	local colortype = dms.atoi(mouldData, prop_mould.prop_quality)
	Text_1:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	

	if tonumber(self.heroInstance.prop_number) < tonumber(dms.atos(mouldData, prop_mould.split_or_merge_count)) then
		Button_1:setVisible(true)
		Button_2:setVisible(false)
		Text_sl:setColor(cc.c3b(73, 43, 0))
	else	
		Button_1:setVisible(false)
		Button_2:setVisible(true)
		Text_sl:setColor(cc.c3b(0, 187, 0))
	end	
end

function PetFragmentSeatCell:onDrawFormationStates()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local ship_mould_id = dms.int(dms["prop_mould"],self.heroInstance.user_prop_template,prop_mould.use_of_ship)
	local cell_base_id = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.base_mould)
	local up_formation = ccui.Helper:seekWidgetByName(root, "Text_shangzhen")
	up_formation:setVisible(false)
	if _ED.formation_pet_id ~= nil and _ED.formation_pet_id ~= 0 then 
		local pet_ship = _ED.user_ship["" .. _ED.formation_pet_id]
		if pet_ship ~= nil then 
			local pet_base_mould = dms.int(dms["ship_mould"],pet_ship.ship_template_id,ship_mould.base_mould)
			if cell_base_id == pet_base_mould then 
				up_formation:setVisible(true)
			end
		end
	end
end

function PetFragmentSeatCell:onEnterTransitionFinish()
end

function PetFragmentSeatCell:onInit()

 	local root = cacher.createUIRef("packs/PetStorage/list_suipian.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if PetFragmentSeatCell.__size == nil then
 		PetFragmentSeatCell.__size = root:getChildByName("Panel_5"):getContentSize()
 	end
	
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_6")
	head:removeAllChildren(true)
	
	ccui.Helper:seekWidgetByName(root, "Button_1"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_2"):setSwallowTouches(false)

	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(true)
	
	ccui.Helper:seekWidgetByName(root, "Button_2"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_shangzhen"):setVisible(false)

	-- 去寻找按钮
	local seat_fragment_button = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(seat_fragment_button, nil, 
	{
		terminal_name = "pet_fragment_seat_find", 
		next_terminal_name = "general", 
		but_image = "Image_home", 
		_prop = self.heroInstance,	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local compound_button = ccui.Helper:seekWidgetByName(root, "Button_2")
	fwin:addTouchEventListener(compound_button, nil, 
	{
		terminal_name = "pet_fragment_compound", 
		terminal_state = 0,
		mould_id = self.heroInstance.user_prop_id,
		_instence = self.heroInstance,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function PetFragmentSeatCell:close( ... )
	local Panel_6 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_6")
	if Panel_6 ~= nil then
		Panel_6:removeAllChildren(true)
	end
end

function PetFragmentSeatCell:onExit()
	cacher.freeRef("packs/PetStorage/list_suipian.csb", self.roots[1])
end

function PetFragmentSeatCell:init(heroInstance, index)
	self.heroInstance = heroInstance

	if index ~= nil and index < 8 then
		self:onInit()
	end

	self:setContentSize(PetFragmentSeatCell.__size)
	return self
end

function PetFragmentSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PetFragmentSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	if Panel_6 ~= nil then
		Panel_6:removeAllChildren(true)
	end
	cacher.freeRef("packs/PetStorage/list_suipian.csb", root)
	root:removeFromParent(false)
	self.roots = {}
	self.csbListEquipmentSui = nil
end

function PetFragmentSeatCell:createCell()
	local cell = PetFragmentSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end