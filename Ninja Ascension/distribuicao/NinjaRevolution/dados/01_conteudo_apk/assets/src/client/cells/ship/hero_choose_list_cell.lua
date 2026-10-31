----------------------------------------------------------------------------------------------------
-- 说明：武将选择信息列(武将出售,经验武将选择)
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroChooseListCell = class("HeroChooseListCellClass", Window)
HeroChooseListCell.__size = nil
 
function HeroChooseListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.status = false
	self.heroInstance = nil	
	self.interfaceType = 0
	self.num = nil   --宠物强化中 false 未选中，true选中
	self.enum_type = {
		_HERO_SELL_LIST_VIEW_CHOOSE_SELL_HERO = 0,
		_HERO_STRENGTHEN_CHOOSE_NEED_HERO = 1,
		_HERO_RESOLVE_CHOOSE_NEED_HERO = 2,
		_PET_STRENGTHEN_CHOOSE_NEED_PROP = 3, --宠物强化
	}
	
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_hero_choose_list_cell_terminal()
		local hero_choose_list_page_choose_terminal = {
            _name = "hero_choose_list_page_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local tempCell = params._datas.cell
				if tempCell.status == false then
					if ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10") ~= nil then
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(true)
					end
					tempCell.status = true
				else
					if ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10") ~= nil then
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(false)
					end
					tempCell.status = false
				end
				state_machine.excute("hero_sell_update_cell_status", 0, {cell = tempCell, heroInstance = tempCell.heroInstance})
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_choose_list_page_choose_update_terminal = {
			_name = "hero_choose_list_page_choose_update",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				local sell_quality = params._datas.quality
				local tempStatus =params._datas.status
				local quality = dms.int(dms["ship_mould"], params._datas.cell.heroInstance.ship_template_id, ship_mould.ship_type)
				if sell_quality == quality then
					if  tempStatus == true then
						if tempCell.status == true then
							return
						end
						tempCell.status = false
					else
						tempCell.status = true
					end
					state_machine.excute("hero_choose_list_page_choose", 0, {_datas = {cell = tempCell}})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		local hero_choose_list_cell_for_hero_strengthen_terminal = {
			_name = "hero_choose_list_cell_for_hero_strengthen",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_koone
				then
					state_machine.excute("hero_strengthen_page_check_full", 0, {_datas = {cell = params._datas.cell}})
				else
					state_machine.excute("hero_strengthen_page_check_conut", 0, {_datas = {cell = params._datas.cell}})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--选择宠物
		local pet_choose_list_cell_for_pet_strengthen_terminal = {
			_name = "pet_choose_list_cell_for_pet_strengthen",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("pet_strengthen_page_check_full", 0, {_datas = {cell = params._datas.cell}})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
	
		local hero_choose_list_cell_for_hero_resolve_terminal = {
			_name = "hero_choose_list_cell_for_hero_resolve",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("hero_resolve_page_check_conut", 0, {_datas = {cell = params._datas.cell}})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(hero_choose_list_page_choose_terminal)
		state_machine.add(hero_choose_list_page_choose_update_terminal)
		state_machine.add(hero_choose_list_cell_for_hero_strengthen_terminal)
		state_machine.add(hero_choose_list_cell_for_hero_resolve_terminal)
		state_machine.add(pet_choose_list_cell_for_pet_strengthen_terminal)
        state_machine.init()
    end
	
    
    init_hero_choose_list_cell_terminal()
end


function HeroChooseListCell:onEnterTransitionFinish()
	-- self:setContentSize(cc.size(344,152))
end

function HeroChooseListCell.onImageLoaded(texture)
	
end

function HeroChooseListCell:onArmatureDataLoad(percent)
	
end

function HeroChooseListCell:setSelected(isbool)
	self.status = isbool
	if self.status == true then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_10"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_10"):setVisible(false)
	end
	if self.interfaceType == self.enum_type._PET_STRENGTHEN_CHOOSE_NEED_PROP then 
		self.heroInstance._isSelect = isbool
	end
end

function HeroChooseListCell:onArmatureDataLoadEx(percent)
	-- if percent >= 1 then
	-- 	if self._load_over == false then
	-- 		self._load_over = true
	-- 		self:onInit()
	-- 	end
	-- end
end

function HeroChooseListCell:onLoad()
	-- local effect_paths = {
	-- 	"images/ui/effice/effect_22/effect_22.ExportJson",
	-- 	"images/ui/effice/effect_26/effect_26.ExportJson"
	-- }
	-- for i, v in pairs(effect_paths) do
	-- 	local fileName = v
	-- 	ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
	-- end

	self:onInit()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
end

function HeroChooseListCell:onInit()
 --    local csbHeroChooseListCell = csb.createNode("list/list_equipment_sui_1.csb")
	-- local root = csbHeroChooseListCell:getChildByName("root")
	-- root:removeFromParent(false)
	-- self:addChild(root)
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("list/list_equipment_sui_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if HeroChooseListCell.__size == nil then
	 	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_2")
		local MySize = PanelGeneralsEquipment:getContentSize()

	 	HeroChooseListCell.__size = MySize
	 end
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("list/list_equipment_sui_1.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end

	-- local PanelGeneralsHeroment = ccui.Helper:seekWidgetByName(root, "Panel_6")
	-- local MySize = PanelGeneralsHeroment:getContentSize()
	-- self:setContentSize(MySize)
	-- print("MySizeMySizeMySizeMySize",MySize.width, MySize.height)
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
	head:removeBackGroundImage()
	local name = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_1")
	local head = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local level = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	local levelNumber = ccui.Helper:seekWidgetByName(root, "Text_300")
	local sel = ccui.Helper:seekWidgetByName(root, "Text_7")
	local selNumber = ccui.Helper:seekWidgetByName(root, "Text_6")
	local Text_41 = ccui.Helper:seekWidgetByName(root, "Text_41")
	sel:setString("")
	selNumber:setString("")
	Text_41:setString("")
	if self.interfaceType == self.enum_type._HERO_STRENGTHEN_CHOOSE_NEED_HERO then
		level:setString(_string_piece_info[16] .. ":")
		sel:setString(_All_tip_string_info_description._expNameDescription)
		selNumber:setString(getOfferOfExp(self.heroInstance.ship_id))
		
	elseif self.interfaceType == self.enum_type._HERO_SELL_LIST_VIEW_CHOOSE_SELL_HERO then
		level:setString(_string_piece_info[16] .. ":")
		sel:setString(_string_piece_info[17])
		selNumber:setString(dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.sell_get_money))
		local rank_level = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.initial_rank_level)
		Text_41:setString(_string_piece_info[29]..":"..rank_level)
		
	elseif self.interfaceType == self.enum_type._HERO_RESOLVE_CHOOSE_NEED_HERO then
		level:setString(_string_piece_info[16] .. ":")
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
				tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.heroInstance.ship_id) then
				level = _ED.hero_skillstren_info.level
			else
				level = self.heroInstance.ship_skillstren.skill_level
			end
			if verifySupportLanguage(_lua_release_language_en) == true then
				Text_41:setString( _All_tip_string_info._destiny.." : ".._string_piece_info[6].. (level or "0"))
			else
				Text_41:setString( _All_tip_string_info._destiny.." : ".. (level or "0").._string_piece_info[6])
			end
		else	
			local rank_level = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.initial_rank_level)
			Text_41:setString(_string_piece_info[29]..":"..rank_level)
			-- local rank_level = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.initial_rank_level)
			-- ccui.Helper:seekWidgetByName(root, "Text_41"):setString(_string_piece_info[29]..":"..rank_level)
		end
	elseif self.interfaceType == self.enum_type._PET_STRENGTHEN_CHOOSE_NEED_PROP then
		
		sel:setString(_string_piece_info[134] .. ":")
		selNumber:setString(dms.string(dms["prop_mould"],self.heroInstance.user_prop_template,prop_mould.use_of_experience))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(self.heroInstance.user_prop_template)[2]
	    else
	    	name:setString(dms.string(dms["prop_mould"],self.heroInstance.user_prop_template,prop_mould.prop_name))
	    end
		
		self:setSelected(self.num)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			level:setString(drawPropsDescription(self.heroInstance.user_prop_template))
		else
			level:setString(dms.string(dms["prop_mould"],self.heroInstance.user_prop_template,prop_mould.remarks))
		end
	else 
		level:setString("")
		sel:setString("")
		selNumber:setString("")

		local Text_41 = ccui.Helper:seekWidgetByName(root, "Text_41")
		Text_41:setString("")
	end
	
	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_10"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Button_7"):setVisible(false)
	if self.status == true then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_10"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_10"):setVisible(false)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local rank_level = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.initial_rank_level)
		if tonumber(rank_level) ~= 0 then
			name:setString(self.heroInstance.captain_name .. " +" .. rank_level)
		else
			name:setString(self.heroInstance.captain_name)
		end
	else
		name:setString(self.heroInstance.captain_name)
	end
	if self.interfaceType == self.enum_type._PET_STRENGTHEN_CHOOSE_NEED_PROP then
		--道具模板
		local colortype = dms.int(dms["prop_mould"], self.heroInstance.user_prop_template, prop_mould.prop_quality)
		name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		app.load("client.cells.prop.prop_icon_new_cell")
		local iconCell = PropIconNewCell:createCell()
		iconCell:init(14, self.heroInstance.user_prop_template)
		head:removeAllChildren(true)
		head:addChild(iconCell)
	else
		local colortype = dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.ship_type)
		name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		levelNumber:setString(self.heroInstance.ship_grade)
		local hero_head = ShipHeadNewCell:createCell()
		hero_head:init(self.heroInstance,hero_head.enum_type._SHOW_HERO_PATH_INFO)
		head:removeAllChildren(true)
		head:addChild(hero_head)
	end
	
	if self.interfaceType == self.enum_type._HERO_STRENGTHEN_CHOOSE_NEED_HERO then
		local panel_6 = fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Panel_6"), 
			nil, 
			{
				terminal_name = "hero_choose_list_cell_for_hero_strengthen",	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)

	elseif self.interfaceType == self.enum_type._HERO_SELL_LIST_VIEW_CHOOSE_SELL_HERO then
		fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Panel_6"), 
			nil, 
			{
				terminal_name = "hero_choose_list_page_choose", 	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
			
	elseif self.interfaceType == self.enum_type._HERO_RESOLVE_CHOOSE_NEED_HERO then
		fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Panel_6"), 
			nil, 
			{
				terminal_name = "hero_choose_list_cell_for_hero_resolve", 	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
	elseif self.interfaceType == self.enum_type._PET_STRENGTHEN_CHOOSE_NEED_PROP then 
		--宠物选择
		local panel_6 = fwin:addTouchEventListener(
			ccui.Helper:seekWidgetByName(root, "Panel_6"), 
			nil, 
			{
				terminal_name = "pet_choose_list_cell_for_pet_strengthen",	
				next_terminal_name = "", 	
				but_image = "", 
				terminal_state = 0, 
				cell = self,
				isPressedActionEnabled = false,
			}, 
			nil, 
			0)
	end
	
end

function HeroChooseListCell:close( ... )
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
end

function HeroChooseListCell:onExit()
	-- state_machine.remove("hero_choose_list_page_choose_update")
	-- state_machine.remove("hero_choose_list_page_choose")
	--state_machine.remove("hero_choose_list_cell_for_hero_strengthen")

	cacher.freeRef("list/list_equipment_sui_1.csb", self.roots[1])
end

function HeroChooseListCell:init(heroInstance, interfaceType, num, index)
	self.heroInstance = heroInstance
	if interfaceType ~= nil then
		self.interfaceType = interfaceType
	end
	if num ~= nil then
		self.num = num
	end
	--     self._load_over = false
	-- self:onLoad()
	if index ~= nil and index < 7 then
		self:onInit()
	end
	self:setContentSize(HeroChooseListCell.__size)
	return self
end

function HeroChooseListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeroChooseListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local head = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if head ~= nil then
		head:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_sui_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end


function HeroChooseListCell:createCell()
	local cell = HeroChooseListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end