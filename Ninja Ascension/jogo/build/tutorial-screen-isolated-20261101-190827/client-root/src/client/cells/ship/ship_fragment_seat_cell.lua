---------------------------------
---说明：武将碎片选项卡
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

HeroFragmentSeatCell = class("HeroFragmentSeatCellClass", Window)
HeroFragmentSeatCell.__size = nil

function HeroFragmentSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.heroInstance = nil

	app.load("client.cells.prop.prop_icon_new_cell")
	app.load("client.packs.hero.HeroPatchInformation")
	app.load("client.packs.hero.HeroFragmentSeatCombining")
    local function init_hero_fragment_find_terminal()
		--去寻找
		local ship_fragment_seat_find_terminal = {
            _name = "ship_fragment_seat_find",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
				
				state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.HeroPatchListView)
				
				local prop = params._datas._prop.user_prop_template --道具模板id
				local equipId = dms.int(dms["prop_mould"], prop, prop_mould.use_of_ship)
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_yugioh 
					then 
					cell:init(prop,5)
				else
					cell:init(equipId)
				end
				
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--合成
		local ship_fragment_compound_terminal = {
            _name = "ship_fragment_compound",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseCompoundHeroCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						else
							local cell = HeroPatchInformation:new()
							cell:init(response.node._datas._instence,2)
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								fwin:open(cell, fwin._windows)
							else
								fwin:open(cell, fwin._view)
							end
						end
						local cell = HeroFragmentSeatCombining:new()
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							fwin:open(cell, fwin._windows)
						else
							fwin:open(cell, fwin._view)
						end
						state_machine.excute("ship_fragment_seat_cell_update", 0, {_datas = {cell = response.node._datas.cell}})
						state_machine.excute("hero_list_view_insert_cell", 0, _ED.recruit_success_ship_ids)
					end
				end
				if TipDlg.drawStorageTipo({4}) == false then -- 判断英雄仓库是否满  4为英雄参数
					_ED.recruit_success_ship_ids = ""
					protocol_command.prop_compound.param_list = ""..params._datas.mould_id.."\r\n".."1".."\r\n".."1"
					NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, params, responseCompoundHeroCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local ship_fragment_seat_cell_update_terminal = {
            _name = "ship_fragment_seat_cell_update",
            _init = function (terminal) 
            end,
            _inited = false,	
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				if tempCell.heroInstance == nil or tonumber(tempCell.heroInstance.prop_number) <= 0 then
					state_machine.excute("hero_patch_remove_item", 0, tempCell)
				else
					tempCell:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(ship_fragment_seat_find_terminal)
		state_machine.add(ship_fragment_compound_terminal)
		state_machine.add(ship_fragment_seat_cell_update_terminal)
        state_machine.init()
    end
    
    init_hero_fragment_find_terminal()
end


function HeroFragmentSeatCell:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")	
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_1")			--hero_name
	local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")		--数量
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_300")
	local Text_4 = ccui.Helper:seekWidgetByName(root, "Text_41")			--数量不足
	
	local Button_7 = ccui.Helper:seekWidgetByName(root, "Button_7")		--合成按钮
	local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")		--去获取按钮

	local sel = ccui.Helper:seekWidgetByName(root, "Text_7")
	sel:setString("")
	local selNumber = ccui.Helper:seekWidgetByName(root, "Text_6")
	selNumber:setString("")

	
	local mouldData = dms.element(dms["prop_mould"], self.heroInstance.user_prop_template)
	
	local hero_head = PropIconNewCell:createCell()
	hero_head:init(hero_head.enum_type._SHOW_HERO_INFORMATION, self.heroInstance)
	Panel_3:removeAllChildren(true)
	Panel_3:addChild(hero_head)
	
	Text_1:setString(self.heroInstance.prop_name)
	
	local colortype = dms.atoi(mouldData, prop_mould.prop_quality)
	Text_1:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	
	Text_1_0:setString(_string_piece_info[4]..":")

	local str = self.heroInstance.prop_number .."/"..dms.atos(mouldData, prop_mould.split_or_merge_count)
	Text_3:setString(str)
	
	Text_4:setString("")
	if tonumber(self.heroInstance.prop_number) < tonumber(dms.atos(mouldData, prop_mould.split_or_merge_count)) then
		Text_4:setString(_string_piece_info[12])
		Button_1:setVisible(true)
		Button_7:setVisible(false)
	else	
		Text_4:setString("")
		Button_1:setVisible(false)
		Button_7:setVisible(true)
	end	
end

function HeroFragmentSeatCell:onEnterTransitionFinish()
end
function HeroFragmentSeatCell:onInit()

    --获取 武将碎片选项卡 美术资源
 --    local csbListEquipmentSui = csb.createNode("list/list_equipment_sui_1.csb")
	-- local root = csbListEquipmentSui:getChildByName("root")
	-- table.insert(self.roots, root)
	-- self:setContentSize(root:getChildByName("Panel_2"):getContentSize())
 --    self:addChild(csbListEquipmentSui)

 	local root = cacher.createUIRef("list/list_equipment_sui_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if HeroFragmentSeatCell.__size == nil then
 		HeroFragmentSeatCell.__size = root:getChildByName("Panel_2"):getContentSize()
 	end
	
	-- -- 列表控件动画播放
	-- local action = csb.createTimeline("list/list_equipment_sui_1.csb")
	-- csbListEquipmentSui:stopAllActions()
 --    csbListEquipmentSui:runAction(action)
 --    action:play("list_view_cell_open", false)
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_3"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_1"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_7"):setSwallowTouches(false)

	ccui.Helper:seekWidgetByName(root, "Button_1"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Image_10"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Button_7"):setVisible(false)

	-- 去寻找按钮
	local seat_fragment_button = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(seat_fragment_button, nil, 
	{
		terminal_name = "ship_fragment_seat_find", 
		next_terminal_name = "general", 
		but_image = "Image_home", 
		_prop = self.heroInstance,	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	
	local compound_button = ccui.Helper:seekWidgetByName(root, "Button_7")
	fwin:addTouchEventListener(compound_button, nil, 
	{
		terminal_name = "ship_fragment_compound", 
		terminal_state = 0,
		mould_id = self.heroInstance.user_prop_id,
		_instence = self.heroInstance,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--这个csb是缓存的，还是公用的.....别的位置缓存的点击事件，这里无点击事件。所以直接屏蔽了
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1"), nil, 
		{
			terminal_name = "", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	self:onUpdateDraw()
end

function HeroFragmentSeatCell:close( ... )
	local Panel_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	if Panel_3 ~= nil then
		Panel_3:removeAllChildren(true)
	end
end

function HeroFragmentSeatCell:onExit()
	--state_machine.remove("ship_fragment_seat_find")
	--state_machine.remove("ship_fragment_compound")
	--state_machine.remove("ship_fragment_seat_cell_update")
	cacher.freeRef("list/list_equipment_sui_1.csb", self.roots[1])
end

function HeroFragmentSeatCell:init(heroInstance, index)
	self.heroInstance = heroInstance

	if index ~= nil and index < 8 then
		self:onInit()
	end

	self:setContentSize(HeroFragmentSeatCell.__size)
	return self
end

function HeroFragmentSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeroFragmentSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if Panel_3 ~= nil then
		Panel_3:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_sui_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:removeFromParent(false)
	self.roots = {}
	self.csbListEquipmentSui = nil
end

function HeroFragmentSeatCell:createCell()
	local cell = HeroFragmentSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end