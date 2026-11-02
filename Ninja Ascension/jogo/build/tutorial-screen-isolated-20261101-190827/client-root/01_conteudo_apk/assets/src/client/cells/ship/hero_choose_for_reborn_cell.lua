----------------------------------------------------------------------------------------------------
-- 说明：武将选择信息列(重生)
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroChooseForRebornCell = class("HeroChooseForRebornCellClass", Window)
 
function HeroChooseForRebornCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.heroInstance = nil	
	
	app.load("client.cells.ship.ship_head_cell")
    local function init_hero_choose_list_cell_terminal()
		local hero_choose_for_reborn_terminal = {
			_name = "hero_choose_for_reborn",
			_init = function (terminal) 
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--> debug.log(true, "aaaaaaaaaaaaaa1231231233", params._datas.cell.heroInstance.ship_id)
				state_machine.excute("hero_reborn_show_hero_info", 0, {_datas = {cell = params._datas.cell}})
				state_machine.excute("hero_choose_reborn_close", 0, "hero_choose_reborn_close.")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(hero_choose_for_reborn_terminal)
        state_machine.init()
    end
	
    init_hero_choose_list_cell_terminal()
end


function HeroChooseForRebornCell:onEnterTransitionFinish()
    local csbHeroChooseForRebornCell = csb.createNode("refinery/refinery_gen_cs_list.csb")
	local root = csbHeroChooseForRebornCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local Panel_generals_cs = ccui.Helper:seekWidgetByName(root, "Panel_generals_cs")
	local MySize = Panel_generals_cs:getContentSize()
	self:setContentSize(MySize)
	
	app.load("client.cells.ship.ship_head_new_cell")
	local hero_mould = self.heroInstance.ship_template_id
	local hero_data = dms.element(dms["ship_mould"], hero_mould)
	
	local hero_color = dms.atoi(hero_data, ship_mould.ship_type)
	local hero_type = dms.atoi(hero_data, ship_mould.capacity)
	
	local hero_level = self.heroInstance.ship_grade
	local hero_rank_level = dms.atoi(hero_data, ship_mould.initial_rank_level)
	local hero_skill_level = self.heroInstance.ship_skillstren.skill_level
	
	-- 图标
	local hero_icon = ShipHeadNewCell:createCell()
	hero_icon:init(self.heroInstance, 8, nil)
	ccui.Helper:seekWidgetByName(root, "Panel_props"):addChild(hero_icon)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_bg_1"), nil, 
		{
			terminal_name = "ship_head_new_cell_show_hero_info", 
			_self = hero_icon, 
			_ship = self.heroInstance
		}, 
		nil, 0)
	end
	
	-- 类型
	local type_name = ""
	if hero_type == 1 then
		type_name = _string_piece_info[58]
	elseif hero_type == 2 then
		type_name = _string_piece_info[59]
	elseif hero_type == 3 then
		type_name = _string_piece_info[60]
	elseif hero_type == 4 then
		type_name = _string_piece_info[61]
	else
		type_name = " "
	end
	ccui.Helper:seekWidgetByName(root, "Text_2"):setString(type_name)
	
	-- 名称
	local name_text = ccui.Helper:seekWidgetByName(root, "Label_717_0")
	name_text:setString(self.heroInstance.captain_name)
	name_text:setColor(cc.c3b(color_Type[hero_color+1][1],color_Type[hero_color+1][2],color_Type[hero_color+1][3]))
	
	-- 等级
	ccui.Helper:seekWidgetByName(root, "Label_property_1"):setString(_string_piece_info[16]..": ")
	ccui.Helper:seekWidgetByName(root, "Label_property_2"):setString(hero_level)
	
	-- 突破
	ccui.Helper:seekWidgetByName(root, "Label_property_3"):setString(_string_piece_info[29]..": ")
	ccui.Helper:seekWidgetByName(root, "Label_property_4"):setString("+"..hero_rank_level)
	
	-- 天命
	ccui.Helper:seekWidgetByName(root, "Label_property_3_0"):setString(_All_tip_string_info._destiny..": ")
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(root, "Label_property_5"):setString(_string_piece_info[6]..hero_skill_level)
	else
		ccui.Helper:seekWidgetByName(root, "Label_property_5"):setString(hero_skill_level.._string_piece_info[6])
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Wear"), nil, 
	{
		terminal_name = "hero_choose_for_reborn", 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function HeroChooseForRebornCell:onExit()

end

function HeroChooseForRebornCell:init(heroInstance)
	self.heroInstance = heroInstance
end

function HeroChooseForRebornCell:createCell()
	local cell = HeroChooseForRebornCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end