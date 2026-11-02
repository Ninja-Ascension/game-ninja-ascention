-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将列表界面
-- 创建时间:
-- 作者：李潮
-------------------------------------------------------------------------------------------------------
PetStorage = class("PetStorageClass", Window)

function PetStorage:ctor()
    self.super:ctor()
	self.roots = {}
	self.group = {
		_petListView = nil,
		_petPatchListView = nil,
		_petHookBook = nil
	}
	
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_seat_cell")
	app.load("client.cells.ship.ship_fragment_seat_cell")
	app.load("client.cells.ship.hero_choose_list_cell")
	app.load("client.packs.pet.PetListView")
	app.load("client.packs.hero.HeroSellChooseByQuality")
	app.load("client.packs.pet.PetPatchListView")
	app.load("client.packs.hero.HeroSellTip")
	app.load("client.packs.pet.PetHandbookPage")
	
	
    local function init_pet_storage_terminal()
		local pet_storage_manager_terminal = {
            _name = "pet_storage_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
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
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回home界面
		local pet_storage_return_home_page_terminal = {
            _name = "pet_storage_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	self:actionEndClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--宠物
		local pet_storage_show_pet_list_terminal = {
            _name = "pet_storage_show_pet_list",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._petListView == nil then
					instance.group._petListView = PetListView:new()
					fwin:open(instance.group._petListView, fwin._background)
				end
				if instance.group._petPatchListView == nil then
					instance.group._petPatchListView = PetPatchListView:new()
					instance.group._petPatchListView:setVisible(false)
					fwin:open(instance.group._petPatchListView, fwin._background)
				end
				if instance.group._petHookBook == nil then
					instance.group._petHookBook = PetHandbookPage:new()
					instance.group._petHookBook:setVisible(false)
					fwin:open(instance.group._petHookBook, fwin._background)
				end
				if instance.group._petListView ~= nil then
					instance.group._petListView:setVisible(true)
				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--宠物碎片
		local pet_storage_show_pet_patch_terminal = {
            _name = "pet_storage_show_pet_patch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._petPatchListView == nil then
					instance.group._petPatchListView = HeroPatchListView:new()
					instance.group._petPatchListView:onUpdateFormationStates()
					fwin:open(instance.group._petPatchListView, fwin._background)
				end
				if instance.group._petListView == nil then
					instance.group._petListView = HeroListView:new()
					instance.group._petListView:setVisible(false)
					fwin:open(instance.group._petListView, fwin._background)
				end
				if instance.group._petHookBook == nil then
					instance.group._petHookBook = PetHandbookPage:new()
					instance.group._petHookBook:setVisible(false)
					fwin:open(instance.group._petHookBook, fwin._background)
				end
				if instance.group._petPatchListView ~= nil then
					instance.group._petPatchListView:setVisible(true)
					instance.group._petPatchListView:onUpdateFormationStates()
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--图鉴
		local pet_storage_show_pet_catalogue_terminal = {
            _name = "pet_storage_show_pet_catalogue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.group._petHookBook == nil then
					instance.group._petHookBook = HeroPatchListView:new()
					fwin:open(instance.group._petPatchListView, fwin._background)
				end
				if instance.group._petListView == nil then
					instance.group._petListView = HeroListView:new()
					instance.group._petListView:setVisible(false)
					fwin:open(instance.group._petListView, fwin._background)
				end
				if instance.group._petPatchListView == nil then
					instance.group._petPatchListView = PetPatchListView:new()
					instance.group._petPatchListView:setVisible(false)
					fwin:open(instance.group._petPatchListView, fwin._background)
				end

				if instance.group._petHookBook ~= nil then
					instance.group._petHookBook:setVisible(true)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local pet_storage_hide_window_terminal = {
            _name = "pet_storage_hide_window",
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
		
		local pet_storage_show_window_terminal = {
            _name = "pet_storage_show_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow(params)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(pet_storage_manager_terminal)
		state_machine.add(pet_storage_return_home_page_terminal)
		state_machine.add(pet_storage_show_pet_list_terminal)
		state_machine.add(pet_storage_show_pet_patch_terminal)
		state_machine.add(pet_storage_hide_window_terminal)
		state_machine.add(pet_storage_show_window_terminal)
		state_machine.add(pet_storage_show_pet_catalogue_terminal)		
        state_machine.init()
    end
    
    init_pet_storage_terminal()
end

function PetStorage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function PetStorage:onShow(_data)
	for i, v in pairs(self.group) do
		if v == self.group._petListView then
			v:setVisible(true)
			break
		end
	end
	self:setVisible(true)
	--state_machine.excute("hero_list_view_update_cell_by_sell", 0,_data)
end

function PetStorage:onEnterTransitionFinish()
    local csbGeneralsList = csb.createNode("packs/PetStorage/PetStorage_list.csb")
	local root = csbGeneralsList:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsList)

	
	app.load("client.player.UserInformationHeroStorage")
	fwin:open(UserInformationHeroStorage:new(), fwin._ui)
	-- ccui.Helper:seekWidgetByName(root, "ImageView_5073_d"):setVisible(true)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "pet_storage_return_home_page", 	
		next_terminal_name = "",	
		current_button_name = "Button_back",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanchong"), nil, 
	{
		terminal_name = "pet_storage_manager", 	
		next_terminal_name = "pet_storage_show_pet_list",	
		current_button_name = "Button_zhanchong",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_suipian"), nil, 
	{
		terminal_name = "pet_storage_manager", 	
		next_terminal_name = "pet_storage_show_pet_patch",	
		current_button_name = "Button_suipian",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pieces_tujian"), nil, 
	{
		terminal_name = "pet_storage_manager", 	
		next_terminal_name = "pet_storage_show_pet_catalogue",	
		current_button_name = "Button_pieces_tujian",  	
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_ship_warehouse_fragment",
	-- _widget = ccui.Helper:seekWidgetByName(root, "Button_pieces_equipment"),
	-- _invoke = nil,
	-- _interval = 0.5,})
end

function PetStorage:playCloseAction()
	
end

function PetStorage:playIntoAction()
	
end

function PetStorage:actionEndClose( ... )
	for i, v in pairs(self.group) do
		if v ~= nil then
			fwin:close(v)
		end
	end
	fwin:cleanView(fwin._view) 
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

function PetStorage:onExit()
	state_machine.remove("pet_storage_manager")
	state_machine.remove("pet_storage_return_home_page")
	state_machine.remove("pet_storage_show_pet_list")
	state_machine.remove("pet_storage_show_pet_patch")
	state_machine.remove("pet_storage_hide_window")
	state_machine.remove("pet_storage_show_window")
	state_machine.remove("pet_storage_show_pet_catalogue")
end
	