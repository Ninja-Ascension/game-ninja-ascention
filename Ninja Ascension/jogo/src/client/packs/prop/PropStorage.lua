-- ----------------------------------------------------------------------------------------------------
-- 说明：仓库
-- 创建时间	06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

PropStorage = class("PropStorageClass", Window)
    
function PropStorage:ctor()
    self.super:ctor()

    self.runState = 0
    
	self.roots = {}
	self.group = {
		_prop = nil,
		materials = nil,
		_equipment = nil,
		_equipment_patch = nil,
		_treasure = nil

	}
	app.load("client.player.EquipPlayerInfomation") 					--顶部用户信息

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then										--0为装备界面   1为碎片界面
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
		app.load("client.packs.treasure.TreasuresListView") --心法
		app.load("client.player.UserInformationHeroStorage")
	end
    -- Initialize prop_storage_storage page state machine.
    local function init_prop_storage_terminal()
		
		local prop_storage_manager_terminal = {
            _name = "prop_storage_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- set select ui button is highlighted
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(false)
					terminal.select_button:setTouchEnabled(true)
				end
				if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
					terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
				end
				if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
					terminal.select_button:setHighlighted(true)
					terminal.select_button:setTouchEnabled(false)
				end
				if terminal.last_terminal_name ~= params._datas.next_terminal_name then
					for i, v in pairs(instance.group) do
						if v ~= nil then
							v:setVisible(false)
						end
					end
					terminal.last_terminal_name = params._datas.next_terminal_name
					state_machine.excute(params._datas.next_terminal_name, 0, params)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--道具按钮
		local prop_storage_chick_prop_storages_terminal = {
            _name = "prop_storage_chick_prop_storages",
            _init = function (terminal) 
                app.load("client.packs.prop.PropPage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._prop == nil then
					instance.group._prop = PropPage:new() 
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						fwin:open(instance.group._prop, fwin._background)
					else
						fwin:open(instance.group._prop, fwin._view)
					end
				end
				instance.group._prop:setVisible(true)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_300003"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_40004"):setVisible(false)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--觉醒道具使用
		local prop_storage_chick_awaken_storages_terminal = {
            _name = "prop_storage_chick_awaken_storages",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
        		app.load("client.packs.prop.AwakenPage")
        		if instance.group.materials == nil then
					instance.group.materials = AwakenPage:new() 
					fwin:open(instance.group.materials, fwin._view)	
				end
				instance.group.materials:setVisible(true)
				-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_300003"):setVisible(false)
				-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_40004"):setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回home界面
		local prop_storage_return_home_close_terminal = {
            _name = "prop_storage_return_home_close",
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
            		if instance == nil then
            			return
            		end
            		-- if self.group._prop ~= nil then
            		-- 	self.group._prop:playCloseAction()
            		-- end
            		instance:playCloseAction()
            		state_machine.excute("menu_back_home_page", 0, "") 
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
		--装备
		local prop_equip_show_list_terminal = {
            _name = "prop_equip_show_list",
            _init = function (terminal) 
                _instance = self
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._equipment == nil then
					instance.group._equipment = EquipListView:new() 
					fwin:open(instance.group._equipment, fwin._background)
				end
				instance.group._equipment:setVisible(true)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        		--装备碎片
		local prop_equip_patch_show_list_terminal = {
            _name = "prop_equip_patch_show_list",
            _init = function (terminal) 
                _instance = self
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._equipment_patch == nil then
					instance.group._equipment_patch = EquipPatchListView:new() 
					fwin:open(instance.group._equipment_patch, fwin._background)
				end
				instance.group._equipment_patch:setVisible(true)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

                		--心法
		local prop_treasure_show_list_terminal = {
            _name = "prop_treasure_show_list",
            _init = function (terminal) 
                _instance = self
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance.group._treasure == nil then
					instance.group._treasure = TreasuresListView:new() 
					fwin:open(instance.group._treasure, fwin._background)
				end
				instance.group._treasure:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(prop_storage_manager_terminal)
		state_machine.add(prop_storage_chick_awaken_storages_terminal)
		state_machine.add(prop_storage_chick_prop_storages_terminal)
		state_machine.add(prop_storage_return_home_close_terminal)
		state_machine.add(prop_equip_show_list_terminal)
		state_machine.add(prop_equip_patch_show_list_terminal)
		state_machine.add(prop_treasure_show_list_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_prop_storage_terminal()
end

function PropStorage:onUpdate(dt)
    if self.runState == 1 then
        state_machine.unlock("menu_manager_change_to_page", 0, "")
        self.runState = self.runState + 1
    end
    if self.runState == 0 then
        self.runState = self.runState + 1
    end
end

function PropStorage:onEnterTransitionFinish()
    local csbPropStorage = csb.createNode("packs/warehouse_list.csb")
    self:addChild(csbPropStorage)
	
	local root = csbPropStorage:getChildByName("root")
	table.insert(self.roots, root)

	local setPressedActionEnabled = true
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		setPressedActionEnabled = false
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
    	Animations_PlayOpenMainUI({ccui.Helper:seekWidgetByName(root, "Panel_2")}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN)
    elseif __lua_project_id == __lua_project_legendary_game then
		local action = csb.createTimeline("packs/warehouse_list.csb")
	    csbPropStorage:runAction(action)
	    self.m_action = action
	    self:playIntoAction()
	end

	-- local myListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	-- for i, prop in pairs(hero) do
		-- local cellitem = EquipPatchListCell:createCell(prop)
		-- myListView:addChild(cellitem)
	-- end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daoju"), nil, 
	{
		terminal_name = "prop_storage_manager", 	
		next_terminal_name = "prop_storage_chick_prop_storages", 			
		current_button_name = "Button_daoju", 		
		but_image = "", 		
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daoju_0"), nil, 
	{
		terminal_name = "prop_storage_manager", 	
		next_terminal_name = "prop_storage_chick_awaken_storages", 			
		current_button_name = "Button_daoju_0", 		
		but_image = "", 		
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled
	}, nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		---返回主页
		local return_home = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daoju_back"), nil, 
		{
			terminal_name = "prop_storage_return_home_close", 
			terminal_state = 0, 
			isPressedActionEnabled = true
		},
		nil, 2)
		--装备
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhuangbei"), nil, 
		{
			terminal_name = "prop_storage_manager", 	
			next_terminal_name = "prop_equip_show_list", 			
			current_button_name = "Button_zhuangbei", 		
			but_image = "", 		
			terminal_state = 0, 
			isPressedActionEnabled = setPressedActionEnabled
		}, nil, 0)
		--装备碎片
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhuangbeisuipin"), nil, 
		{
			terminal_name = "prop_storage_manager", 	
			next_terminal_name = "prop_equip_patch_show_list", 			
			current_button_name = "Button_zhuangbeisuipin", 		
			but_image = "", 		
			terminal_state = 0, 
			isPressedActionEnabled = setPressedActionEnabled
		}, nil, 0)
	    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_equipment_warehouse_fragment",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_zhuangbeisuipin"),
        _invoke = nil,
        _interval = 0.5,})
		--心法
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xinfa"), nil, 
		{
			terminal_name = "prop_storage_manager", 	
			next_terminal_name = "prop_treasure_show_list", 			
			current_button_name = "Button_xinfa", 		
			but_image = "", 		
			terminal_state = 0, 
			isPressedActionEnabled = setPressedActionEnabled
		}, nil, 0)

	end
	
	local userinfo = UserTopInfoA:new()
	local info = fwin:open(userinfo,fwin._view)

    local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
        local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
        Panel_effec:addChild(animation2)
    end
end

function PropStorage:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:actionEndClose()
	elseif __lua_project_id == __lua_project_legendary_game then
		self.m_action:play("window_close", false)
	end
end

function PropStorage:playIntoAction()
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

function PropStorage:actionEndClose( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		for i , v in pairs(self.group) do
			if v ~= nil then
				fwin:close(v)
			end
		end
		fwin:close(self)
		fwin:close(fwin:find("UserTopInfoAClass"))
	end
end

function PropStorage:close( ... )
    local Panel_effec = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function PropStorage:onExit()
	-- fwin:close(fwin:find("UserTopInfoAClass"))
	state_machine.remove("prop_storage_manager")
	state_machine.remove("prop_storage_chick_awaken_storages")
	state_machine.remove("prop_storage_chick_prop_storages")
	state_machine.remove("prop_equip_show_list")
	state_machine.remove("prop_equip_patch_show_list")
	state_machine.remove("prop_treasure_show_list")
end
