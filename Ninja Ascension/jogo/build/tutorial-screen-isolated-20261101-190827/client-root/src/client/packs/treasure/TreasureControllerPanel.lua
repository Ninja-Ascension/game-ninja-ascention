---------------------------------
-- 说明：宝物控制主界面 --控制宝物强化界面 --控制宝物精炼界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureControllerPanel = class("TreasureControllerPanelClass", Window)

function TreasureControllerPanel:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	self.group = {
		-- _self = self,
		_treasureStrengthen = nil,
		_treasureRefine = nil,
		_treasureInformation = nil
	}
	
	self.currentTreasure = nil		-- 当前操作的宝物实例 外部传参
	self._string_type = nil
	self.pageshowindex = 1
	self.open_type = nil
	app.load("client.packs.treasure.TreasureStrengthenPanel")
	
    local function init_treasure_controller_terminal()
		local treasure_controller_manager_terminal = {
            _name = "treasure_controller_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade = 0
				if  tonumber(params._datas.openWinId) == -1 then
					arena_grade = 0
				else
					arena_grade=dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level)
				end
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					if terminal.last_terminal_name ~= params._datas.next_terminal_name then
						-- hide child window
						for i, v in pairs(instance.group) do
							if v ~= nil then
								v:setVisible(false)
							end
						end
						
						terminal.last_terminal_name = params._datas.next_terminal_name
						state_machine.excute(params._datas.next_terminal_name, 0, params)
					end
					
					-- set select ui button is highlighted
					if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
						terminal.select_button:setHighlighted(false)
						terminal.select_button:setTouchEnabled(true)
					end
					terminal.page_name = params._datas.but_image
					if terminal.select_button == nil and params._datas.current_button_name ~= nil then
						terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
					else
						terminal.select_button = params
					end
					if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
						terminal.select_button:setHighlighted(true)
						terminal.select_button:setTouchEnabled(false)
					end
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--返回treasure storage界面
		local treasure_controller_return_storage_terminal = {
            _name = "treasure_controller_return_storage",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureStorage")
				app.load("client.packs.treasure.TreasureStrengthenPanel")
				app.load("client.packs.treasure.TreasureRefinePanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- close child window
				for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				-- fwin:cleanView(fwin._view) 
				
				if instance._string_type == "strengthen_master" then
					local FormationWnd = nil
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						FormationWnd = fwin:find("FormationTigerGateClass")
					else
						FormationWnd = fwin:find("FormationClass")
					end
					local StrengthenMasterWnd = fwin:find("StrengthenMasterClass"):setVisible(true)
					if FormationWnd ~= nil then 
						FormationWnd:setVisible(true)
						-- fwin:close(fwin:find("EquipPlayerInfomationClass"))
					end
					if StrengthenMasterWnd ~= nil then 
						StrengthenMasterWnd:setVisible(true)
					end 
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then
						state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
					end
				elseif instance._string_type == "formation" then
					state_machine.excute("formation_cell_on_show", 0, "formation_cell_on_show.")
					state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")
					state_machine.excute("formation_property_change_by_level_up", 0, "")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						or __lua_project_id == __lua_project_legendary_game 
						then			--龙虎门项目控制
						state_machine.excute("home_show_event", 0, "home_show_event.")
						state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
					end
				else
					state_machine.excute("treasure_storage_back_treasure_storages", 0, "click treasure_storage_back_treasure_storages.")
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("treasure_icon_listView_close",0,"")	
					state_machine.excute("hero_develop_page_show_nowpage",0,"")				
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宝物精炼界面
		local treasure_strengthen_to_refine_terminal = {
            _name = "treasure_strengthen_to_refine",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureRefinePanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._treasureRefine == nil then
					instance.group._treasureRefine = TreasureRefinePanel:new()
					instance.group._treasureRefine:init(instance.currentTreasure, instance._string_type)
					fwin:open(instance.group._treasureRefine, fwin._background)
				end
				instance.group._treasureRefine:setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(false)
				state_machine.excute("treasure_refine_update_of_change_icon",0,"")	
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					self.pageshowindex = 3
					state_machine.excute("treasure_icon_listview_get_contropage",0,3)

				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宝物强化界面
		local treasure_refine_to_strengthen_terminal = {
            _name = "treasure_refine_to_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._treasureStrengthen == nil then
					instance.group._treasureStrengthen = TreasureStrengthenPanel:new()
					instance.group._treasureStrengthen:init(instance.currentTreasure, instance._string_type)
					fwin:open(instance.group._treasureStrengthen, fwin._background)
				end
				instance.group._treasureStrengthen:setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(true)
				state_machine.excute("treasure_refine_change_strengthen_update",0,"")	
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					self.pageshowindex = 2
					state_machine.excute("treasure_icon_listview_get_contropage",0,2)					
				end				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强制hide
		local treasure_controller_hide_terminal = {
            _name = "treasure_controller_hide",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				self:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强制show
		local treasure_controller_show_terminal = {
            _name = "treasure_controller_show",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				self:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
				--宝物信息界面
		local treasure_refine_to_information_terminal = {
            _name = "treasure_refine_to_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

				if instance.group._treasureInformation == nil then
					instance.group._treasureInformation = EquipInformation:new()
					instance.group._treasureInformation:init(instance.currentTreasure, instance._string_type)
					fwin:open(instance.group._treasureInformation, fwin._background)
				end
				instance.group._treasureInformation:setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_4"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_3"):setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					self.pageshowindex = 1
					state_machine.excute("treasure_icon_listview_get_contropage",0,1)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --心法列表图标点击后刷新
        local treasure_refine_update_for_icon_terminal = {
            _name = "treasure_refine_update_for_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local treasure = params
            	for i ,v in pairs(instance.group) do 
            		if v ~= nil and v == instance.group._treasureInformation then
            			v:init(treasure,instance._string_type)
            		elseif v ~= nil and v == instance.group._treasureStrengthen then
            			v:init(treasure,instance._string_type)
            		elseif v ~= nil and v == instance.group._treasureRefine then
            			v:init(treasure,instance._string_type)
            		end
            	end
				instance:setCurrentTreasure(treasure,instance._string_type)

            	if instance.pageshowindex == 1 then
            		state_machine.excute("equip_information_change_equip_update",0,"")
        		elseif instance.pageshowindex == 2 then			
					state_machine.excute("treasure_strengthen_update_of_change_icon",0,"")
        		elseif instance.pageshowindex == 3 then
        			state_machine.excute("treasure_refine_update_of_change_icon",0,"")		
        		end
				instance:onUpdateDrawButton()
 	           	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --只刷新button,
         local treasure_refine_update_button_terminal = {
            _name = "treasure_refine_update_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawButton()
 	           	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

             --单纯的关闭所有,然后到阵容界面
         local treasure_refine_close_all_terminal = {
            _name = "treasure_refine_close_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
 	           	for i, v in pairs(instance.group) do
					if v ~= nil then
						fwin:close(v)
					end
				end
				state_machine.excute("treasure_icon_listView_close",0,"")
				fwin:close(fwin:find("EquipPlayerInfomationClass"))
				fwin:close(fwin:find("UserInformationHeroStorageClass"))
				fwin:close(fwin:find("UserTopInfoAClass"))
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(treasure_controller_return_storage_terminal)
		state_machine.add(treasure_strengthen_to_refine_terminal)
		state_machine.add(treasure_refine_to_strengthen_terminal)
		state_machine.add(treasure_controller_hide_terminal)
		state_machine.add(treasure_controller_show_terminal)
		state_machine.add(treasure_controller_manager_terminal)
		state_machine.add(treasure_refine_to_information_terminal)
		state_machine.add(treasure_refine_update_for_icon_terminal)
		state_machine.add(treasure_refine_update_button_terminal)
		state_machine.add(treasure_refine_close_all_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_controller_terminal()
end
function TreasureControllerPanel:onUpdateDrawButton()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local root = self.roots[1]
		local Panel_line = ccui.Helper:seekWidgetByName(root,"Panel_line")
		local Button_equ_tihuan = ccui.Helper:seekWidgetByName(root,"Button_equ_tihuan")
		local Button_equ_xiexia = ccui.Helper:seekWidgetByName(root,"Button_equ_xiexia")
		local Text_zhuangbei = ccui.Helper:seekWidgetByName(root,"Text_zhuangbei")
		local ship_id = self.currentTreasure.ship_id
		local ship = nil
		local equipType = nil
		if tonumber(ship_id) > 0 then
			ship = _ED.user_ship[ship_id]
			self.ship = ship
			equipType = dms.int(dms["equipment_mould"], self.currentTreasure.user_equiment_template, equipment_mould.equipment_type)
			self.equipType = equipType
			Panel_line:setVisible(true)
			Button_equ_tihuan:setVisible(true)
			Button_equ_xiexia:setVisible(true)
			Text_zhuangbei:setVisible(true)
			if tonumber(ship.captain_type) == 0 then
				Text_zhuangbei:setString(_string_piece_info[5].." ".._ED.user_info.user_name)
				if ___is_open_leadname == true then
					Text_zhuangbei:setFontName("")
					Text_zhuangbei:setFontSize(Text_zhuangbei:getFontSize())
				end
			else
				Text_zhuangbei:setString(_string_piece_info[5].." "..ship.captain_name)
			end
		else
			Button_equ_tihuan:setVisible(false)
			Button_equ_xiexia:setVisible(false)
			Panel_line:setVisible(false)
			Text_zhuangbei:setVisible(false)
			Text_zhuangbei:setString("")
			state_machine.excute("treasure_icon_listview_update_listview",0,self.currentTreasure)
		end

		local treasure_strengthen_button = ccui.Helper:seekWidgetByName(root, "Button_equipment")
		local treasure_refine_button = ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment")
		if tonumber(self.currentTreasure.equipment_type) == 8 then
			treasure_strengthen_button:setTouchEnabled(false)
			treasure_strengthen_button:setBright(false)
			treasure_refine_button:setTouchEnabled(false)
			treasure_refine_button:setBright(false)
		else
			treasure_strengthen_button:setTouchEnabled(true)
			treasure_refine_button:setTouchEnabled(true)
			if self.pageshowindex == 1 then
				treasure_refine_button:setBright(true)
				treasure_strengthen_button:setBright(true)
			elseif self.pageshowindex == 2 then
				treasure_refine_button:setBright(true)
				treasure_strengthen_button:setHighlighted(true)
			elseif self.pageshowindex == 3 then
				treasure_refine_button:setHighlighted(true)
				treasure_strengthen_button:setBright(true)
			end
		end
	end
end
function TreasureControllerPanel:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		state_machine.excute("hero_develop_page_hidden_nowpage",0,"")
	end
	--获取美术资源
    local csbTreasureController = csb.createNode("packs/TreasureStorage/treasure_strengthen.csb")
	local root = csbTreasureController:getChildByName("root")
	root:removeFromParent(false)
    self:addChild(root)
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		app.load("client.packs.treasure.TreasureIconListView")
		state_machine.excute("treasure_icon_listView_open",0,"")
		state_machine.excute("treasure_icon_listview_first_set_index",0,self.currentTreasure)
		self:onUpdateDrawButton()
	end
	--返回treasure storage
	local treasure_return_home_button = ccui.Helper:seekWidgetByName(root, "Button_back")
	fwin:addTouchEventListener(treasure_return_home_button, nil, 
	{
		terminal_name = "treasure_controller_return_storage", 
		next_terminal_name = "", 
		current_button_name = "Button_back", 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--跳到宝物精炼界面
	local setPressedActionEnabled = true
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		setPressedActionEnabled = false
	end
	local treasure_refine_button = ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment")
	fwin:addTouchEventListener(treasure_refine_button, nil, 
	{
		terminal_name = "treasure_controller_manager", 
		next_terminal_name = "treasure_strengthen_to_refine", 
		current_button_name = "Button_pieces_equipment",  	
		but_image = "", 	
		terminal_state = 0, 
		openWinId = 46,
		isPressedActionEnabled = setPressedActionEnabled,
		treasureInstance = self.currentTreasure
	}, 
	nil, 0)
	
	--跳到宝物强化界面
	local treasure_strengthen_button = ccui.Helper:seekWidgetByName(root, "Button_equipment")
	fwin:addTouchEventListener(treasure_strengthen_button, nil, 
	{
		terminal_name = "treasure_controller_manager", 
		next_terminal_name = "treasure_refine_to_strengthen", 
		current_button_name = "Button_equipment",  	
		but_image = "", 	
		terminal_state = 0, 
		openWinId = -1,
		isPressedActionEnabled = setPressedActionEnabled,
		treasureInstance = self.currentTreasure
	}, 
	nil, 0)

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local treasure_infomation_button = ccui.Helper:seekWidgetByName(root, "Button_xinfa_xinxi")
		fwin:addTouchEventListener(treasure_infomation_button, nil, 
		{
			terminal_name = "treasure_controller_manager", 
			next_terminal_name = "treasure_refine_to_information", 
			current_button_name = "Button_xinfa_xinxi",  	
			but_image = "", 	
			terminal_state = 0, 
			openWinId = -1,
			isPressedActionEnabled = setPressedActionEnabled,
			treasureInstance = self.currentTreasure
		}, 
		nil, 0)
		if tonumber(self.currentTreasure.equipment_type) == 8 then --经验心法
			state_machine.excute("treasure_controller_manager", 0, 
			{
				_datas = {
					terminal_name = "treasure_controller_manager", 	
					next_terminal_name = "treasure_refine_to_information",	
					current_button_name = "Button_xinfa_xinxi",  	
					but_image = "", 	
					terminal_state = 0, 
					openWinId = -1,
					isPressedActionEnabled = setPressedActionEnabled,
					treasureInstance = self.currentTreasure
				}
			})
		elseif self.open_type == 1 then
			state_machine.excute("treasure_controller_manager", 0, 
			{
				_datas = {
					terminal_name = "treasure_controller_manager", 	
					next_terminal_name = "treasure_refine_to_strengthen",	
					current_button_name = "Button_equipment",  	
					but_image = "", 	
					terminal_state = 0, 
					openWinId = -1,
					isPressedActionEnabled = setPressedActionEnabled,
					treasureInstance = self.currentTreasure
				}
			})
		elseif self.open_type == 2 then
			state_machine.excute("treasure_controller_manager", 0, 
			{
				_datas = {
					terminal_name = "treasure_controller_manager", 
					next_terminal_name = "treasure_strengthen_to_refine", 
					current_button_name = "Button_pieces_equipment",  	
					but_image = "", 	
					terminal_state = 0, 
					openWinId = 46,
					isPressedActionEnabled = setPressedActionEnabled,
					treasureInstance = self.currentTreasure
				}
			})
		else
			state_machine.excute("treasure_controller_manager", 0, 
			{
				_datas = {
					terminal_name = "treasure_controller_manager", 	
					next_terminal_name = "treasure_refine_to_strengthen",	
					current_button_name = "Button_equipment",  	
					but_image = "", 	
					terminal_state = 0, 
					openWinId = -1,
					isPressedActionEnabled = setPressedActionEnabled,
					treasureInstance = self.currentTreasure
				}
			})			
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_tihuan"), nil, 
		{
			terminal_name = "open_replacement_ship_equip_window", 	
			but_image = "", 	
			terminal_state = 0,
			_self = self, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_xiexia"), nil, 
		{
			terminal_name = "replacement_or_unload_ship_equip_wear_request", 	
			but_image = "", 	
			terminal_state = 0,
			_self = self, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
end

function TreasureControllerPanel:setCurrentTreasure(value, _string_type,open_type)
	self.currentTreasure = value
	self._string_type = _string_type
	self.open_type = open_type
end

function TreasureControllerPanel:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
end

function TreasureControllerPanel:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
end

function TreasureControllerPanel:onExit()
	state_machine.remove("treasure_controller_return_storage")
	state_machine.remove("treasure_strengthen_to_refine")
	state_machine.remove("treasure_refine_to_strengthen")
	state_machine.remove("treasure_controller_hide")
	state_machine.remove("treasure_controller_show")
	state_machine.remove("treasure_controller_manager")
	state_machine.remove("treasure_refine_to_information")
	state_machine.remove("treasure_refine_update_for_icon")
	state_machine.remove("treasure_refine_update_button")
	state_machine.remove("treasure_refine_close_all")
end