----------------------------------------------------------------------------------------------------
-- 说明：装备仓库界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipStorage = class("EquipStorageClass", Window)
   
function EquipStorage:ctor()
    self.super:ctor()
	self.roots = {}
	EquipStorage._pageIndex = 0											--0为装备界面   1为碎片界面
	app.load("data.TipStringInfo")
	app.load("client.packs.equipment.EquipSell")						--出售
	app.load("client.packs.equipment.EquipSellTip")						--出售提示
	app.load("client.packs.equipment.EquipSellTipTwo")					--出售提示
	app.load("client.cells.equip.equip_choose_list_cell")						--装备出售选择信息列
	app.load("client.packs.equipment.EquipSellChooseByQuality")			--装备出售按品质选择界面
	app.load("client.player.EquipPlayerInfomation") 					--顶部用户信息
	app.load("client.cells.equip.equip_list_cell")							--装备仓库信息列
	app.load("client.packs.equipment.EquipListView")					--装备仓库滑动层
	app.load("client.packs.equipment.EquipPatchListView")				--装备碎片仓库滑动层
	app.load("client.cells.equip.equip_list_tan_cell")						--装备仓库信息列隐藏列
	app.load("client.cells.equip.equip_icon_cell")					--小头像
	app.load("client.cells.equip.equip_patch_list_cell")						--装备碎片信息列
	app.load("client.packs.equipment.EquipStrengthenRefineStrorage")	--装备强化精炼主窗口
	app.load("client.packs.equipment.EquipRefinePage")					--装备精炼
	app.load("client.packs.equipment.EquipStrengthenPage")				--装备强化
	app.load("client.packs.equipment.EquipInformation")					--装备信息
	app.load("client.cells.equip.equip_info_suit_list_cell")					--装备信息列
	app.load("client.cells.equip.equip_info_strengthen_list_cell")			--装备信息列
	app.load("client.cells.equip.equip_info_refine_list_cell")				--装备信息列
	app.load("client.cells.equip.equip_info_describe_list_cell")				--装备信息列
	app.load("client.cells.prop.prop_icon_cell")				--装备信息列
	app.load("client.player.UserInformationHeroStorage")
	app.load("client.home.Menu")
    local function init_equip_storage_terminal()
		--返回home界面
		local equip_storage_return_home_page_terminal = {
            _name = "equip_storage_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then
					self:playCloseAction()
					if fwin:find("EquipListViewClass") ~= nil then
						fwin:find("EquipListViewClass"):playCloseAction()
					end
					if fwin:find("EquipPatchListViewClass") ~= nil then
						fwin:find("EquipPatchListViewClass"):playCloseAction()
					end
            	else
	            	fwin:cleanView(fwin._view) 
					fwin:close(instance)
					state_machine.excute("menu_back_home_page", 0, "") 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--装备按钮
		local equip_storage_show_equip_storage_list_terminal = {
            _name = "equip_storage_show_equip_storage_list",
            _init = function (terminal) 
                _instance = self
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				EquipStorage._pageIndex = 0
				-- local sell_button = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_5069")
				-- sell_button:setVisible(true)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh  then 
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_5"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_6"):setVisible(false)
					local Button_pieces_equipment = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pieces_equipment")
					local Button_equipment = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_equipment")
					Button_pieces_equipment:setVisible(true)
					Button_equipment:setVisible(true)
					Button_equipment:setHighlighted(true)
					Button_equipment:setTouchEnabled(false)
					Button_pieces_equipment:setHighlighted(false)
					Button_pieces_equipment:setTouchEnabled(true)
					
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_5"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_6"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pieces_equipment"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_equipment"):setVisible(false)
				end
				
				local equipList = fwin:find("EquipListViewClass")
				local equipPatchList = fwin:find("EquipPatchListViewClass")
				
				if equipList == nil then
					fwin:open(EquipListView:new(),fwin._background)
				else
					equipList:setVisible(true)
				end
				if equipPatchList == nil then
					fwin:open(EquipPatchListView:new(),fwin._background)
				end
				equipPatchList = fwin:find("EquipPatchListViewClass")
				if equipPatchList then
					equipPatchList:setVisible(false)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--装备碎片按钮
		local equip_storage_show_equip_storage_patch_terminal = {
            _name = "equip_storage_show_equip_storage_patch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				EquipStorage._pageIndex = 1
				-- local sell_button = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_5069")
				-- sell_button:setVisible(false)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh  then 
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_5"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_6"):setVisible(false)
					local Button_equipment = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_equipment")
					local Button_pieces_equipment = ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pieces_equipment")
					
					Button_pieces_equipment:setVisible(true)
					Button_equipment:setVisible(true)
					Button_pieces_equipment:setHighlighted(true)
					Button_pieces_equipment:setTouchEnabled(false)
					Button_equipment:setTouchEnabled(true)
					Button_equipment:setHighlighted(false)
					
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_5"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_6"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_pieces_equipment"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_equipment"):setVisible(true)
				end
				
				local equipPatchList = fwin:find("EquipPatchListViewClass")
				local equipList = fwin:find("EquipListViewClass")
				
				if equipPatchList == nil then
					fwin:open(EquipPatchListView:new(),fwin._background)
				else
					equipPatchList:setVisible(true)
				end
				if equipList == nil then
					fwin:open(EquipListView:new(),fwin._background)
				end
				equipList = fwin:find("EquipListViewClass")
				if equipList then
					equipList:setVisible(false)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 隐藏自己
		local equip_storage_not_show_terminal = {
            _name = "equip_storage_not_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示自己
		local equip_storage_show_terminal = {
            _name = "equip_storage_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_storage_close_all_window_terminal = {
            _name = "equip_storage_close_all_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("EquipListViewClass"))
				fwin:close(fwin:find("EquipPatchListViewClass"))
				if fwin:find("EquipSellClass") ~= nil then
					fwin:close(fwin:find("EquipSellClass"))
				end
				if fwin:find("UserInformationHeroStorageClass") ~= nil then
					fwin:close(fwin:find("UserInformationHeroStorageClass"))
				end	
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(equip_storage_return_home_page_terminal)
		state_machine.add(equip_storage_show_equip_storage_list_terminal)
		state_machine.add(equip_storage_show_equip_storage_patch_terminal)
		state_machine.add(equip_storage_not_show_terminal)
		state_machine.add(equip_storage_show_terminal)
		state_machine.add(equip_storage_close_all_window_terminal)
        state_machine.init()
    end
    
    init_equip_storage_terminal()
end

function EquipStorage:onEnterTransitionFinish()
    local csbEquipStorage = csb.createNode("packs/EquipStorage/equipment_list.csb")
	self:addChild(csbEquipStorage)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		local action = csb.createTimeline("packs/EquipStorage/equipment_list.csb")
	    csbEquipStorage:runAction(action)
	    self.m_action = action
	    self:playIntoAction()
	end

	local userinfo = UserInformationHeroStorage:new()
	local info = fwin:open(userinfo,fwin._view)

	local root = csbEquipStorage:getChildByName("root")
	
	table.insert(self.roots, root)
	
	local return_home = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "equip_storage_return_home_page", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
	local isPressedActionEnabled = true
	if __lua_project_id == __lua_project_rouge then
		isPressedActionEnabled = false
	end
	local EquipStorage_list = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment"), nil, {func_string = [[state_machine.excute("equip_storage_show_equip_storage_list", 0, "click equip_storage_show_equip_storage_list.'")]], 
									isPressedActionEnabled = isPressedActionEnabled}, nil, 0)
	local EquipStorage_patch = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment"), nil, {func_string = [[state_machine.excute("equip_storage_show_equip_storage_patch", 0, "click equip_storage_show_equip_storage_patch.'")]], 
									isPressedActionEnabled = isPressedActionEnabled}, nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_equipment_warehouse_fragment",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment"),
	_invoke = nil,
	_interval = 0.5,})
	
	--装备列表
	state_machine.excute("equip_storage_show_equip_storage_list", 0, "equip_storage_show_equip_storage_list.")
end

function EquipStorage:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_close", false)
	end
end

function EquipStorage:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_open", false)
		self.m_action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	
	        elseif str == "window_close_over" then
	            self:actionEndClose()
	        end
	    end)
	end
end

function EquipStorage:actionEndClose( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		fwin:close(fwin:find("EquipListViewClass"))
		fwin:close(fwin:find("EquipPatchListViewClass"))
		fwin:close(fwin:find("UserInformationHeroStorageClass"))
		fwin:close(self)
		if fwin:find("HomeClass") == nil then
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_home_page", 
						current_button_name = "Button_home",
						but_image = "Image_home", 		
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
		end		
		state_machine.excute("menu_back_home_page", 0, "")			
	end
end

function EquipStorage:onShow()
	local st = fwin:find("EquipStorageClass")
	local sl = fwin:find("EquipListViewClass")
	if st ~= nil then
		st:setVisible(true)
	end
	if sl ~= nil then
		sl:setVisible(true)
	end
end

function EquipStorage:onHide()
	local st = fwin:find("EquipStorageClass")
	local sl = fwin:find("EquipListViewClass")
	if st ~= nil then
		st:setVisible(false)
	end
	if sl ~= nil then
		sl:setVisible(false)
	end
end

function EquipStorage:onExit()

	state_machine.remove("equip_storage_return_home_page")
	state_machine.remove("equip_storage_show_equip_storage_list")
	state_machine.remove("equip_storage_show_equip_storage_patch")
	state_machine.remove("equip_storage_not_show")
	state_machine.remove("equip_storage_show")
	state_machine.remove("equip_storage_close_all_window")
end