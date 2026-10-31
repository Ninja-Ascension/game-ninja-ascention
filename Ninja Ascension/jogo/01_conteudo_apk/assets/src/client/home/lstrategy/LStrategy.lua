
LStrategy = class("LStrategyClass", Window)

local lstrategy_main_open_terminal = {
	_name = "lstrategy_main_open",
	_init = function (terminal)
        app.load("client.home.lstrategy.LStrategyLeftChild")
		app.load("client.home.lstrategy.LStrategyRightParent")
		app.load("client.home.lstrategy.LStrategyRightChild")
        app.load("client.home.lstrategy.LStrategyRightFormation")
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local LStrategyWindow = fwin:find("LStrategyClass")
		if LStrategyWindow ~= nil and LStrategyWindow:isVisible() == true then
			return true
		end
        state_machine.lock("lstrategy_main_open")
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			fwin:open(LStrategy:new(), fwin._view)
		else
			fwin:open(LStrategy:new(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local lstrategy_main_close_terminal = {
	_name = "lstrategy_main_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local LStrategyWindow = fwin:find("LStrategyClass")
		if LStrategyWindow ~= nil then
			fwin:close(LStrategyWindow)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			if fwin:find("MenuClass") == nil then
	            fwin:open(Menu:new(), fwin._taskbar)
	        end
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
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lstrategy_main_open_terminal)
state_machine.add(lstrategy_main_close_terminal)
state_machine.init()

function LStrategy:ctor()
    self.super:ctor()
    self.roots = {}
    self.leftList = nil
    self.rightList = nil
    self.chooseLeftIndex = 0

    local function init_lstrategy_terminal()
		local lstrategy_close_terminal = {
            _name = "lstrategy_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("lstrategy_main_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lstrategy_select_left_once_terminal = {
            _name = "lstrategy_select_left_once",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:changeLeftSelectState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lstrategy_select_right_once_terminal = {
            _name = "lstrategy_select_right_once",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:changeRightSelect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(lstrategy_close_terminal)
		state_machine.add(lstrategy_select_left_once_terminal)
		state_machine.add(lstrategy_select_right_once_terminal)
        state_machine.init()
    end
    init_lstrategy_terminal()
end

function LStrategy:changeLeftSelectState( selectedIndex )
	if self.chooseLeftIndex == selectedIndex then
		return
	end
	self.chooseLeftIndex = selectedIndex
	local items = self.leftList:getItems()
    for i, v in pairs(items) do
    	v:changeSelectedState(i == self.chooseLeftIndex)
    end
    self:onUpdateRightDraw()
end

function LStrategy:changeRightSelect( index )
	local items = self.rightList:getItems()
	local lastHeight = 0
	for k,v in pairs(items) do
		v:setPositionY(lastHeight)
		lastHeight = lastHeight + v:getContentSize().height
	end
    self.rightList:requestRefreshView()
    
    if index >= #items then
    	local function delatEnd( ... )
    		self.rightList:getInnerContainer():setPositionY(0)
		end
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(delatEnd)))
    end
end

function LStrategy:onUpdateRightDraw()
	self.rightList:removeAllChildren(true)
	local kitsData = dms.element(dms["kits"], self.chooseLeftIndex)
    local child_list = zstring.split(dms.atos(kitsData, kits.child_list), ",")
    for k,v in pairs(child_list) do
    	local cell = LStrategyRightParent:createCell()
		cell:init(k, v)
		self.rightList:addChild(cell)
    end
	self.rightList:requestRefreshView()
end

function LStrategy:onUpdateLeftDraw()
	local root = self.roots[1]
	for i,v in pairs(dms["kits"]) do
		local cell = LStrategyLeftChild:createCell()
		cell:init(i)
		self.leftList:addChild(cell)
	end
	self.leftList:requestRefreshView()
	self:changeLeftSelectState(1)
end

function LStrategy:onEnterTransitionFinish()
	local csbStrategy = csb.createNode("system/raiders_xzs.csb")
	self:addChild(csbStrategy)
	local root = csbStrategy:getChildByName("root")
	table.insert(self.roots, root)
	self.leftList = ccui.Helper:seekWidgetByName(root, "ListView_103_0")
	self.rightList = ccui.Helper:seekWidgetByName(root, "ListView_103")
	
	Animations_PlayOpenMainUI({ccui.Helper:seekWidgetByName(root, "Panel_1")}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN,0.5)
	
	self:onUpdateLeftDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_166"), nil, 
	{
		terminal_name = "lstrategy_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 2)
	state_machine.unlock("lstrategy_main_open")
end

function LStrategy:onExit()
	state_machine.remove("lstrategy_close")
end