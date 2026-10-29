--------------------------------------------
-- 攻略
--------------------------------------------
Strategy = class("StrategyClass", Window)

local strategy_main_open_terminal = {
	_name = "strategy_main_open",
	_init = function (terminal)
        -- load lua file
        app.load("client.red_alert_time.strategy.StrategyLeftChild")
		app.load("client.red_alert_time.strategy.StrategyRightParent")
		app.load("client.red_alert_time.strategy.StrategyRightChild")
        app.load("client.red_alert_time.strategy.StrategyRightFormation")
        app.load("client.red_alert_time.cells.activity.dailytasks.task_cell")
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local StrategyWindow = fwin:find("StrategyClass")
		if StrategyWindow ~= nil and StrategyWindow:isVisible() == true then
			return true
		end
        state_machine.lock("strategy_main_open")
        fwin:open(Strategy:new(), fwin._ui)
        cc.UserDefault:getInstance():setStringForKey(getKey("strategy_push_state"), "0")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local strategy_main_close_terminal = {
	_name = "strategy_main_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local StrategyWindow = fwin:find("StrategyClass")
		if StrategyWindow ~= nil then
			fwin:close(StrategyWindow)
		end

        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(strategy_main_open_terminal)
state_machine.add(strategy_main_close_terminal)
state_machine.init()

function Strategy:ctor()
    self.super:ctor()
    self.roots = {}
    self.leftList = nil
    self.rightList = nil
    self.chooseLeftIndex = 0

    local function init_strategy_terminal()
    	--关闭
		local strategy_close_terminal = {
            _name = "strategy_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("strategy_main_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local strategy_select_left_once_terminal = {
            _name = "strategy_select_left_once",
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

        local strategy_select_right_once_terminal = {
            _name = "strategy_select_right_once",
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

		--显示界面
		local strategy_window_show_terminal = {
            _name = "strategy_window_show",
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
		--隐藏界面
		local strategy_window_hide_terminal = {
            _name = "strategy_window_hide",
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

        local strategy_update_listview_terminal = {
            _name = "strategy_update_listview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateRightDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(strategy_close_terminal)
		state_machine.add(strategy_select_left_once_terminal)
		state_machine.add(strategy_select_right_once_terminal)
		state_machine.add(strategy_window_show_terminal)
		state_machine.add(strategy_window_hide_terminal)
		state_machine.add(strategy_update_listview_terminal)
        state_machine.init()
    end
    init_strategy_terminal()
end

function Strategy:onHide()
    self:setVisible(false)
end

function Strategy:onShow()
    self:setVisible(true)
end

function Strategy:changeLeftSelectState( selectedIndex )
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

function Strategy:changeRightSelect( index )
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

function Strategy:onUpdateRightDraw()
	self.rightList:removeAllChildren(true)
	local kitsData = dms.element(dms["kits"], self.chooseLeftIndex)
	if tonumber(dms.atos(kitsData, kits.child_list)) == -1 then
        for i = 1, dms.count( dms["strategy_param"] ) do 
            local cell = StrategyRightFormation:createCell()
            cell:init(i)
            self.rightList:addChild(cell)
        end
	else
	    local child_list = zstring.split(dms.atos(kitsData, kits.child_list), ",")
	    for k,v in pairs(child_list) do
	    	local cell = StrategyRightParent:createCell()
			cell:init(k, v)
			self.rightList:addChild(cell)
	    end
		self.rightList:requestRefreshView()
	end
end

function Strategy:onUpdateLeftDraw()
	local root = self.roots[1]
	for i,v in pairs(dms["kits"]) do
		local cell = StrategyLeftChild:createCell()
		cell:init(i)
		self.leftList:addChild(cell)
	end
	self.leftList:requestRefreshView()
	self:changeLeftSelectState(1)
end

function Strategy:onEnterTransitionFinish()
	local csbStrategy = csb.createNode(config_csb.system.raiders_xzs)
	self:addChild(csbStrategy)
	local root = csbStrategy:getChildByName("root")
	table.insert(self.roots, root)
	self.leftList = ccui.Helper:seekWidgetByName(root, "ListView_103_0")	--左边列表
	self.rightList = ccui.Helper:seekWidgetByName(root, "ListView_103")		--右边列表
	
	Animations_PlayOpenMainUI({ccui.Helper:seekWidgetByName(root, "Panel_1")}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN,0.5)
	
	self:onUpdateLeftDraw()
	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_166"), nil, 
	{
		terminal_name = "strategy_close",
		terminal_state = 0,
		isPressedActionEnabled = true
	}, nil, 1)
	state_machine.unlock("strategy_main_open")
end

function Strategy:onExit()
	state_machine.remove("strategy_close")
    state_machine.remove("strategy_select_left_once")
    state_machine.remove("strategy_select_right_once")
    state_machine.remove("strategy_window_show")
    state_machine.remove("strategy_window_hide")
    state_machine.remove("strategy_update_listview")
end