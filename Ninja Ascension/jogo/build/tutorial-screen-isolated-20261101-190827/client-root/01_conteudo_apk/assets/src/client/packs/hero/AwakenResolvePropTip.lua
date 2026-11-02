-- ----------------------------------------------------------------------------------------------------
-- 说明：觉醒道具分解
-------------------------------------------------------------------------------------------------------

AwakenResolvePropTip = class("AwakenResolvePropTipClass", Window)

function AwakenResolvePropTip:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.prop = nil
	self.propId = nil
	self.type = nil
	
	self.Tparams = nil
	self.buy_number = 1
	self.shop_type = nil
	self.prop_totalCounts = 0
	self.cell = nil
	self.sellSoulCount = 0 --分解后得到的个数
	self.exchangeTimes = nil
	-- Initialize shop page state machine.
    local function init_awaken_resolve_prop_tip_terminal()
	
		local awaken_resolve_prop_close_terminal = {
            _name = "awaken_resolve_prop_close",
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
		local awaken_resolve_prop_number_change_terminal = {
            _name = "awaken_resolve_prop_number_change",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.buy_number = self.buy_number + params._datas._number
				local function drawNumber()
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_12"):setString(self.buy_number)
					local soulCounts = zstring.tonumber(self.buy_number) * instance.sellSoulCount
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_jx7"):setString("" ..soulCounts)
				end
				
				if self.buy_number <= 0 then
					self.buy_number = 1
				end
				if self.buy_number >= self.prop_totalCounts then 
					self.buy_number = self.prop_totalCounts
				end
				drawNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local awaken_resolve_prop_sure_terminal = {
            _name = "awaken_resolve_prop_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	          	local function responseResolveCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end
	            		app.load("client.reward.DrawRareReward")
                   		local getRewardWnd = DrawRareReward:new()
                   		getRewardWnd:init(63)
                   		fwin:open(getRewardWnd,fwin._dialog)
                   		local awakenWind = fwin:find("AwakenPageClass")
                   		if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then 
                   			state_machine.excute("awaken_page_reload_list_view_cell", 0, {_datas ={_cell = response.node.cell}})
                   		else
                   			if nil ~= awakenWind then
								state_machine.excute("awaken_list_cell_request_resolve_clean", 0, {_datas ={_cell = response.node.cell}})
							end
                   		end
						
						fwin:close(fwin:find("AwakenResolvePropTipClass"))
		            end
				end
				protocol_command.awaken_refine.param_list = instance.propId .. "\r\n" .. instance.buy_number
				NetworkManager:register(protocol_command.awaken_refine.code, nil, nil, nil, instance, responseResolveCallback, false, nil)
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(awaken_resolve_prop_number_change_terminal)
		state_machine.add(awaken_resolve_prop_close_terminal)
		state_machine.add(awaken_resolve_prop_sure_terminal)
        state_machine.init()
    end
    init_awaken_resolve_prop_tip_terminal()
end

function AwakenResolvePropTip:onUpdateDraw()
	local root = self.roots[1]
	
	local textNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
	local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	local userHave = ccui.Helper:seekWidgetByName(root, "Text_buy_3")
	local price = ccui.Helper:seekWidgetByName(root, "Text_buy_7")
	local residueTimes = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	local tipText = ccui.Helper:seekWidgetByName(root, "Text_buy_5")
	
	textNumber:setString(self.buy_number)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        name:setString(setThePropsIcon(mouldId)[2])
    else
    	name:setString(dms.string(dms["prop_mould"], self.prop, prop_mould.prop_name))
    end
	local quality = dms.int(dms["prop_mould"], self.prop, prop_mould.prop_quality) + 1
	self.sellSoulCount = dms.int(dms["prop_mould"], self.prop, prop_mould.use_of_experience)
	
	ccui.Helper:seekWidgetByName(root, "Text_buy_jx7"):setString("" ..self.sellSoulCount)
	local propNumber = nil
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(self.prop) then
			propNumber = v.prop_number
			break
		end
	end
	self.prop_totalCounts = zstring.tonumber(propNumber) 
	userHave:setString(propNumber .. _string_piece_info[32])
	
	name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2], color_Type[quality][3]))
		
end

function AwakenResolvePropTip:onEnterTransitionFinish()
	local csbAwakenResolvePropTip = csb.createNode("shop/buy_props.csb")
	local root = csbAwakenResolvePropTip:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("shop/buy_props.csb")
    csbAwakenResolvePropTip:runAction(action)
	action:play("window_open", false)
    self:addChild(csbAwakenResolvePropTip)
	
	local sureBuy = ccui.Helper:seekWidgetByName(root, "Button_gmdj_2")
	local closeButton = ccui.Helper:seekWidgetByName(root, "Button_gmdj_1")
	local closeButton2 = ccui.Helper:seekWidgetByName(root, "Button_1")
	local cutButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1")
	local cutButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jian_2")
	local addButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2")
	local addButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jia_1")
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_dj_tx")

	local panelFenj = ccui.Helper:seekWidgetByName(root, "Panel_fenjie")
	ccui.Helper:seekWidgetByName(root, "Panel_8"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_14"):setString(_awaken_tipString_info[4])
	panelFenj:setVisible(true)
	
	app.load("client.cells.prop.prop_icon_new_cell")
	local iconCell = PropIconNewCell:createCell()
	iconCell:init(iconCell.enum_type._SHOW_ARENA_HONOR_SHOP, self.prop)
	headPanel:addChild(iconCell)
	
	fwin:addTouchEventListener(closeButton, nil, {func_string = [[state_machine.excute("awaken_resolve_prop_close", 0, "click awaken_resolve_prop_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(closeButton2, nil, {func_string = [[state_machine.excute("awaken_resolve_prop_close", 0, "click awaken_resolve_prop_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(cutButtonTen, nil, 
		{
			terminal_name = "awaken_resolve_prop_number_change", 
			terminal_state = 0, 
			_number = -10,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(cutButtonOne, nil, 
		{
			terminal_name = "awaken_resolve_prop_number_change", 
			terminal_state = 0, 
			_number = -1,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonTen, nil, 
		{
			terminal_name = "awaken_resolve_prop_number_change", 
			terminal_state = 0, 
			_number = 10,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonOne, nil, 
		{
			terminal_name = "awaken_resolve_prop_number_change", 
			terminal_state = 0, 
			_number = 1,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
		fwin:addTouchEventListener(sureBuy, nil, 
		{
			terminal_name = "awaken_resolve_prop_sure", 
			terminal_state = 0, 
			_prop = self.prop,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	
	self:onUpdateDraw()
end

function AwakenResolvePropTip:onExit()
	state_machine.remove("awaken_resolve_prop_close")
	state_machine.remove("awaken_resolve_prop_sure")
	-- state_machine.remove("shop_prop_buy_close")
	state_machine.remove("awaken_resolve_prop_number_change")
end

function AwakenResolvePropTip:init(propId,propMould,cell)
	self.propId = propId
	self.prop = propMould
	self.cell = cell
	
end

function AwakenResolvePropTip:createCell()
	local cell = AwakenResolvePropTip:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
