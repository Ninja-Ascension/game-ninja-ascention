-- ----------------------------------------------------------------------------------------------------
-- 说明：首页里面的图鉴
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CatalogueStorage = class("CatalogueStorageClass", Window)

function CatalogueStorage:ctor()
    self.super:ctor()
    self.roots = {}
	self.action = nil
	self.group = {
        _onePage = nil,
        _twoPage = nil,
        _therePage =nil,
        _fourPage =nil,
    }
    -- Initialize CatalogueStorage page state machine.
	app.load("client.home.catalogue.CatalogueStorageOne")
	app.load("client.home.catalogue.CatalogueStorageTwo")
	app.load("client.home.catalogue.CatalogueStorageThree")
	app.load("client.home.catalogue.CatalogueStorageFour")
	app.load("client.home.catalogue.CatalogueStorageList")
	app.load("client.home.catalogue.CatalogueStorageList_new")
    local function init_catalogue_storage_terminal()

        local catalogue_storage_close_terminal = {
            _name = "catalogue_storage_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:cleanView(fwin._windows) 

				fwin:close(fwin:find("CatalogueStorageOneClass"))
				fwin:close(fwin:find("CatalogueStorageTwoClass"))
				fwin:close(fwin:find("CatalogueStorageThreeClass"))
				fwin:close(fwin:find("CatalogueStorageFourClass"))
				fwin:close(fwin:find("CatalogueStorageListClass"))
			
				self.action:play("window_close", false)
				fwin:close(fwin:find("CatalogueStorageClass"))
			
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				else
					state_machine.excute("menu_back_home_page", 0, "") 
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local catalogue_storage_to_one_terminal = {
            _name = "catalogue_storage_to_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_1"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_2"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_3"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_4"):setVisible(false)
				instance:onUpdateDrawOne()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local catalogue_storage_to_two_terminal = {
            _name = "catalogue_storage_to_two",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_2"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_3"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_4"):setVisible(false)
				instance:onUpdateDrawTwo()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local catalogue_storage_to_three_terminal = {
            _name = "catalogue_storage_to_three",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_2"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_3"):setVisible(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_4"):setVisible(false)
				instance:onUpdateDrawThree()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local catalogue_storage_to_four_terminal = {
            _name = "catalogue_storage_to_four",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_1"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_2"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_3"):setVisible(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_tujian_4"):setVisible(true)
				instance:onUpdateDrawFour()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(catalogue_storage_close_terminal)
        state_machine.add(catalogue_storage_to_one_terminal)
        state_machine.add(catalogue_storage_to_two_terminal)
        state_machine.add(catalogue_storage_to_three_terminal)
        state_machine.add(catalogue_storage_to_four_terminal)
        state_machine.init()
    end
    
    init_catalogue_storage_terminal()
end

function CatalogueStorage:onUpdateDrawOne()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		then
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_403")
		
		if self.group._onePage == nil then
			self.group._onePage = CatalogueStorageOne:new()
			self.group._onePage:init()
			panel:addChild(self.group._onePage)
			-- panel:getParent():reorderChild(panel, 100)
		else
			self.group._onePage:setVisible(true)
		end
		if self.group._twoPage ~= nil then
			self.group._twoPage:setVisible(false)
		end
		if self.group._therePage ~= nil then
			self.group._therePage:setVisible(false)
		end
		if self.group._fourPage ~= nil then
			self.group._fourPage:setVisible(false)
		end
	else
		local pageOne = fwin:find("CatalogueStorageOneClass")
		local pageTwo = fwin:find("CatalogueStorageTwoClass")
		local pageThree = fwin:find("CatalogueStorageThreeClass")
		local pageFour = fwin:find("CatalogueStorageFourClass")
		if pageTwo ~= nil then
			pageTwo:setVisible(false)
		end
		
		if pageThree ~= nil then
			pageThree:setVisible(false)
		end
		
		if pageFour ~= nil then
			pageFour:setVisible(false)
		end
		
		if pageOne == nil then
			fwin:open(CatalogueStorageOne:new(),fwin._view)
		else
			pageOne:setVisible(true)
		end
	end
	
	
end

function CatalogueStorage:onUpdateDrawTwo()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		then
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_403")
		
		if self.group._twoPage == nil then
			self.group._twoPage = CatalogueStorageTwo:new()
			self.group._twoPage:init()
			panel:addChild(self.group._twoPage)
		else
			self.group._twoPage:setVisible(true)
		end
		if self.group._onePage ~= nil then
			self.group._onePage:setVisible(false)
		end
		if self.group._therePage ~= nil then
			self.group._therePage:setVisible(false)
		end
		if self.group._fourPage ~= nil then
			self.group._fourPage:setVisible(false)
		end
	else
		local pageOne = fwin:find("CatalogueStorageOneClass")
		local pageTwo = fwin:find("CatalogueStorageTwoClass")
		local pageThree = fwin:find("CatalogueStorageThreeClass")
		local pageFour = fwin:find("CatalogueStorageFourClass")
		if pageOne ~= nil then
			pageOne:setVisible(false)
		end
		
		if pageThree ~= nil then
			pageThree:setVisible(false)
		end
		
		if pageFour ~= nil then
			pageFour:setVisible(false)
		end
		
		if pageTwo == nil then
			fwin:open(CatalogueStorageTwo:new(),fwin._view)
		else
			pageTwo:setVisible(true)
		end
	end
	
end

function CatalogueStorage:onUpdateDrawThree()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		then
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_403")
		
		if self.group._therePage == nil then
			self.group._therePage = CatalogueStorageThree:new()
			self.group._therePage:init()
			panel:addChild(self.group._therePage)
		else
			self.group._therePage:setVisible(true)
		end
		if self.group._onePage ~= nil then
			self.group._onePage:setVisible(false)
		end
		if self.group._twoPage ~= nil then
			self.group._twoPage:setVisible(false)
		end
		if self.group._fourPage ~= nil then
			self.group._fourPage:setVisible(false)
		end
	else
		local pageOne = fwin:find("CatalogueStorageOneClass")
		local pageTwo = fwin:find("CatalogueStorageTwoClass")
		local pageThree = fwin:find("CatalogueStorageThreeClass")
		local pageFour = fwin:find("CatalogueStorageFourClass")
		
		if pageOne ~= nil then
			pageOne:setVisible(false)
		end
		
		if pageTwo ~= nil then
			pageTwo:setVisible(false)
		end
		
		if pageFour ~= nil then
			pageFour:setVisible(false)
		end
		
		if pageThree == nil then
			fwin:open(CatalogueStorageThree:new(),fwin._view)
		else
			pageThree:setVisible(true)
		end
	end
	
end

function CatalogueStorage:onUpdateDrawFour()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
		then
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_403")

		if self.group._fourPage == nil then
			self.group._fourPage = CatalogueStorageFour:new()
			self.group._fourPage:init()
			panel:addChild(self.group._fourPage)
		else
			self.group._fourPage:setVisible(true)
		end
		if self.group._onePage ~= nil then
			self.group._onePage:setVisible(false)
		end
		if self.group._twoPage ~= nil then
			self.group._twoPage:setVisible(false)
		end
		if self.group._therePage ~= nil then
			self.group._therePage:setVisible(false)
		end
	else
		local pageOne = fwin:find("CatalogueStorageOneClass")
		local pageTwo = fwin:find("CatalogueStorageTwoClass")
		local pageThree = fwin:find("CatalogueStorageThreeClass")
		local pageFour = fwin:find("CatalogueStorageFourClass")
		if pageOne ~= nil then
			pageOne:setVisible(false)
		end
		
		if pageTwo ~= nil then
			pageTwo:setVisible(false)
		end
		
		if pageThree ~= nil then
			pageThree:setVisible(false)
		end
		
		if pageFour == nil then
			fwin:open(CatalogueStorageFour:new(),fwin._view)
		else
			pageFour:setVisible(true)
		end
	end
	
end

function CatalogueStorage:onEnterTransitionFinish()
	local csbCatalogueStorage = csb.createNode("system/Atlas.csb")
	self:addChild(csbCatalogueStorage)
	
	local root = csbCatalogueStorage:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("system/Atlas.csb")
    csbCatalogueStorage:runAction(action)
	action:play("window_open", false)
	self.action = action
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "winow_open_over" then
        	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        		or __lua_project_id == __lua_project_red_alert 
        		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        		or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
        		or __lua_project_id == __lua_project_yugioh 
        		or __lua_project_id == __lua_project_warship_girl_b 
        		then
        		state_machine.excute("catalogue_storage_to_three", 0, "click catalogue_storage_to_three.'")
        	else
				state_machine.excute("catalogue_storage_to_one", 0, "click catalogue_storage_to_one.'")
			end
        end
        
    end)

	ccui.Helper:seekWidgetByName(root, "Image_tujian_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_tujian_2"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_tujian_3"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_tujian_4"):setVisible(false)

	local close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tjian_1"), nil, {func_string = [[state_machine.excute("catalogue_storage_close", 0, "click catalogue_storage_close.'")]], 
									isPressedActionEnabled = true}, nil, 2)
	local one = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian_1"), nil, {func_string = [[state_machine.excute("catalogue_storage_to_one", 0, "click catalogue_storage_to_one.'")]], 
								isPressedActionEnabled = true}, nil, 0)
	local two = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian_2"), nil, {func_string = [[state_machine.excute("catalogue_storage_to_two", 0, "click catalogue_storage_to_two.'")]], 
								isPressedActionEnabled = true}, nil, 0)
	local three = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian_3"), nil, {func_string = [[state_machine.excute("catalogue_storage_to_three", 0, "click catalogue_storage_to_three.'")]], 
								isPressedActionEnabled = true}, nil, 0)
	local four = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian_4"), nil, {func_string = [[state_machine.excute("catalogue_storage_to_four", 0, "click catalogue_storage_to_four.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	
	-- three:setBright(false)
	-- three:setTouchEnabled(false)
	-- four:setBright(false)
	-- four:setTouchEnabled(false)
	-- state_machine.excute("catalogue_storage_to_one", 0, "click catalogue_storage_to_one.'")
   
end

function CatalogueStorage:close( ... )
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_403")
	if (__lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b )
		and panel ~= nil then 
		panel:removeAllChildren(true)
	end
end

function CatalogueStorage:onExit()
	state_machine.remove("catalogue_storage_close")
	state_machine.remove("catalogue_storage_to_one")
	state_machine.remove("catalogue_storage_to_two")
	state_machine.remove("catalogue_storage_to_three")
	state_machine.remove("catalogue_storage_to_four")
end