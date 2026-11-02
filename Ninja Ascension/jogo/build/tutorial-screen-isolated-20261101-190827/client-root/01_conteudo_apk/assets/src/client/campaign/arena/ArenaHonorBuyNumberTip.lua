-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场商店道具购买二级选择数量界面
-------------------------------------------------------------------------------------------------------

ArenaHonorBuyNumberTip = class("ArenaHonorBuyNumberTipClass", Window)

function ArenaHonorBuyNumberTip:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.prop = nil
	self.type = nil
	self.arenaId = nil
	self.Tparams = nil
	self.buy_number = 1
	self.shop_type = nil
	self.exchangeTimes = nil
	-- Initialize shop page state machine.
    local function init_arena_honor_buy_number_tip_terminal()
	
		local arena_honor_buy_close_terminal = {
            _name = "arena_honor_buy_close",
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
		local arena_honor_buy_number_change_terminal = {
            _name = "arena_honor_buy_number_change",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.buy_number = self.buy_number + params._datas._number
				local function drawNumber()
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_12"):setString(self.buy_number)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_7"):setString(dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.need_honor)*tonumber(self.buy_number))
				end
				
				if self.buy_number <= 0 then
					self.buy_number = 1
				elseif dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.exchange_count_limit) ~= -1 then
					if self.buy_number > dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.exchange_count_limit) - tonumber(self.exchangeTimes) then
						self.buy_number = dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.exchange_count_limit) - tonumber(self.exchangeTimes)
					end
				end
				drawNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_honor_buy_sure_terminal = {
            _name = "arena_honor_buy_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _price = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_7")
				if zstring.tonumber(_price:getString()) <= zstring.tonumber(_ED.user_info.user_honour) then
					params._datas._current_buy_count = self.buy_number
					params._datas._prop = self.arenaId
					state_machine.excute("arena_honor_buy_honor", 0, params)
					fwin:close(instance)
				else
					TipDlg.drawTextDailog(_string_piece_info[255])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(arena_honor_buy_number_change_terminal)
		state_machine.add(arena_honor_buy_close_terminal)
		state_machine.add(arena_honor_buy_sure_terminal)
        state_machine.init()
    end
    init_arena_honor_buy_number_tip_terminal()
end

function ArenaHonorBuyNumberTip:onUpdateDraw()
	local root = self.roots[1]
	
	local textNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
	local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	local userHave = ccui.Helper:seekWidgetByName(root, "Text_buy_3")
	local price = ccui.Helper:seekWidgetByName(root, "Text_buy_7")
	local residueTimes = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	local tipText = ccui.Helper:seekWidgetByName(root, "Text_buy_5")
	
	textNumber:setString(self.buy_number)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        name:setString(setThePropsIcon(self.prop)[2])
    else
		name:setString(dms.string(dms["prop_mould"], self.prop, prop_mould.prop_name))
	end
	local quality = dms.int(dms["prop_mould"], self.prop, prop_mould.prop_quality) + 1
	
	
	
	for i=1, _ED.arena_good_number do
		if tonumber(_ED.arena_good[i].good_id) == tonumber(self.arenaId) then
			self.exchangeTimes = _ED.arena_good[i].exchange_times
		end
	end
	local times = dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.exchange_count_limit) - tonumber(self.exchangeTimes)
	if dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.exchange_count_limit) == -1 then
		residueTimes:setString(_string_piece_info[75])
	else
		if dms.int(dms["arena_shop_info"], self.arenaId, arena_shop_info.is_daily_refresh_limit) == 0 then
			-- 不可重置的
			
		else
			-- 可重置的
			residueTimes:setString(_string_piece_info[69] .. (times) .. _string_piece_info[70])
			tipText:setString(_string_piece_info[77])
		end
		
	end
	
	price:setString(dms.string(dms["arena_shop_info"], self.arenaId, arena_shop_info.need_honor))
	local propNumber = nil
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(self.prop) then
			propNumber = v.prop_number
		end
	end
	userHave:setString(zstring.tonumber(propNumber) .. _string_piece_info[32])
	
	name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2], color_Type[quality][3]))
		
end

function ArenaHonorBuyNumberTip:onEnterTransitionFinish()
	local csbArenaHonorBuyNumberTip = csb.createNode("shop/buy_props.csb")
	local root = csbArenaHonorBuyNumberTip:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("shop/buy_props.csb")
    csbArenaHonorBuyNumberTip:runAction(action)
	action:play("window_open", false)
    self:addChild(csbArenaHonorBuyNumberTip)
	
	local sureBuy = ccui.Helper:seekWidgetByName(root, "Button_gmdj_2")
	local closeButton = ccui.Helper:seekWidgetByName(root, "Button_gmdj_1")
	local closeButton2 = ccui.Helper:seekWidgetByName(root, "Button_1")
	local cutButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1")
	local cutButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jian_2")
	local addButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2")
	local addButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jia_1")
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_dj_tx")
	
	app.load("client.cells.prop.prop_icon_new_cell")
	local iconCell = PropIconNewCell:createCell()
	iconCell:init(iconCell.enum_type._SHOW_ARENA_HONOR_SHOP, self.prop)
	headPanel:addChild(iconCell)
	
	local currencyImage = ccui.Helper:seekWidgetByName(root, "Image_6")
	currencyImage:setVisible(false)
	local ball = cc.Sprite:create("images/ui/play/arena/icon_shengwang.png")
	ball:setAnchorPoint(cc.p(0.5, 0.5))
	local panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	ball:setPosition(cc.p(currencyImage:getPositionX(),currencyImage:getPositionY()))
	panel_3:addChild(ball)
	ball:setScale(0.5)
	
	
	fwin:addTouchEventListener(closeButton, nil, {func_string = [[state_machine.excute("arena_honor_buy_close", 0, "click arena_honor_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(closeButton2, nil, {func_string = [[state_machine.excute("arena_honor_buy_close", 0, "click arena_honor_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(cutButtonTen, nil, 
		{
			terminal_name = "arena_honor_buy_number_change", 
			terminal_state = 0, 
			_number = -10,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(cutButtonOne, nil, 
		{
			terminal_name = "arena_honor_buy_number_change", 
			terminal_state = 0, 
			_number = -1,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonTen, nil, 
		{
			terminal_name = "arena_honor_buy_number_change", 
			terminal_state = 0, 
			_number = 10,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonOne, nil, 
		{
			terminal_name = "arena_honor_buy_number_change", 
			terminal_state = 0, 
			_number = 1,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
		fwin:addTouchEventListener(sureBuy, nil, 
		{
			terminal_name = "arena_honor_buy_sure", 
			terminal_state = 0, 
			_prop = self.prop,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	
	self:onUpdateDraw()
end

function ArenaHonorBuyNumberTip:onExit()
	state_machine.remove("arena_honor_buy_close")
	state_machine.remove("arena_honor_buy_sure")
	-- state_machine.remove("shop_prop_buy_close")
	state_machine.remove("arena_honor_buy_number_change")
end

function ArenaHonorBuyNumberTip:init(propMould, arenaId)
	-- self.Tparams = params
	self.prop = propMould
	self.arenaId = arenaId
	-- self.type = params._datas._type
	-- self.shop_type = params._datas._shopType
end

function ArenaHonorBuyNumberTip:createCell()
	local cell = ArenaHonorBuyNumberTip:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
