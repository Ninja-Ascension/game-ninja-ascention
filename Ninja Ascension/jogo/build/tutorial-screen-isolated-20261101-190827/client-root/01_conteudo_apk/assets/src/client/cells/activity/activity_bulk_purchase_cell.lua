-- ----------------------------------------------------------------------------------------------------
-- 说明：活动购买二级选择数量界面
-------------------------------------------------------------------------------------------------------

ActivityBulkPurchaseCell = class("ActivityBulkPurchaseCellClass", Window)

function ActivityBulkPurchaseCell:ctor()
    self.super:ctor()
	
	self.roots = {}
	
	self.prop_info = nil
	self.buy_number = 1
	
    local function init_activity_bulk_purchase_cell_terminal()
		local activity_bulk_purchase_close_terminal = {
            _name = "activity_bulk_purchase_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local activity_bulk_purchase_buy_terminal = {
            _name = "activity_bulk_purchase_buy",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mCell = instance.prop_info
				local index = mCell.index
				
				local function responseExchangeCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.variety_shop_exchang_times[index] = zstring.tonumber(_ED.variety_shop_exchang_times[index]) + response.node.buy_number
						state_machine.excute("activity_bulk_purchase_close", 0, "")
						response.node.prop_info:rewadDraw(response.node.prop_info.index)
					end
				end
				protocol_command.activity_superchange_exchange.param_list = ""..tonumber(index).."\r\n"..instance.buy_number
				NetworkManager:register(protocol_command.activity_superchange_exchange.code, nil, nil, nil, instance, responseExchangeCallback, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local activity_bulk_purchase_buy_number_change_terminal = {
            _name = "activity_bulk_purchase_buy_number_change",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local prop_info = params._datas._instance.prop_info
			
				instance.buy_number = instance.buy_number + params._datas._number
				
				local remainNum = zstring.tonumber(prop_info.get_info_arg[1]._maxTimes) - zstring.tonumber(_ED.variety_shop_exchang_times[prop_info.index])
				if instance.buy_number <= 0 then
					instance.buy_number = 1
				else
					if instance.buy_number > remainNum then
						instance.buy_number = remainNum
					end
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_12"):setString(instance.buy_number)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(activity_bulk_purchase_close_terminal)
		state_machine.add(activity_bulk_purchase_buy_terminal)
		state_machine.add(activity_bulk_purchase_buy_number_change_terminal)
        state_machine.init()
    end
    
    init_activity_bulk_purchase_cell_terminal()
end

function ActivityBulkPurchaseCell:onUpdateDraw()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_buy_12"):setString(self.buy_number)
	ccui.Helper:seekWidgetByName(root, "Panel_401"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_8"):setVisible(false)
end

function ActivityBulkPurchaseCell:onEnterTransitionFinish()
	local csbActivityBulkPurchaseCell = csb.createNode("shop/buy_props.csb")
	local root = csbActivityBulkPurchaseCell:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("shop/buy_props.csb")
    csbActivityBulkPurchaseCell:runAction(action)
	action:play("window_open", false)
    self:addChild(csbActivityBulkPurchaseCell)
	
	local cutButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1")
	local cutButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jian_2")
	local addButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2")
	local addButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jia_1")
	
	local sureBuy = ccui.Helper:seekWidgetByName(root, "Button_gmdj_2")
	
	fwin:addTouchEventListener(sureBuy, nil, 
	{
		terminal_name = "activity_bulk_purchase_buy", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "activity_bulk_purchase_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gmdj_1"), nil, 
	{
		terminal_name = "activity_bulk_purchase_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(cutButtonTen, nil, 
	{
		terminal_name = "activity_bulk_purchase_buy_number_change", 
		terminal_state = 0, 
		_number = -10,
		_instance = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(cutButtonOne, nil, 
	{
		terminal_name = "activity_bulk_purchase_buy_number_change", 
		terminal_state = 0, 
		_number = -1,
		_instance = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(addButtonTen, nil, 
	{
		terminal_name = "activity_bulk_purchase_buy_number_change", 
		terminal_state = 0, 
		_number = 10,
		_instance = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(addButtonOne, nil, 
	{
		terminal_name = "activity_bulk_purchase_buy_number_change", 
		terminal_state = 0, 
		_number = 1,
		_instance = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function ActivityBulkPurchaseCell:onExit()
	state_machine.remove("activity_bulk_purchase_close")
	state_machine.remove("activity_bulk_purchase_buy")
	state_machine.remove("activity_bulk_purchase_buy_number_change")
end

function ActivityBulkPurchaseCell:init(_prop_info)
	self.prop_info = _prop_info
	return self
end
