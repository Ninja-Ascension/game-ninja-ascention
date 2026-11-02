-- ----------------------------------------------------------------------------------------------------
-- 说明：商城道具购买二级选择数量界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopPropBuyNumberTip = class("ShopPropBuyNumberTipClass", Window)

function ShopPropBuyNumberTip:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.prop = nil
	self.type = nil
	self.Tparams = nil
	self.buy_number = 1
	self.shop_type = nil
	-- Initialize shop page state machine.
    local function init_shop_prop_buy_number_tip_terminal()
	
		local shop_prop_buy_sure_terminal = {
            _name = "shop_prop_buy_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("ggggggggggggggggggggggggggggggggggggggggggg", 1)
				local _price = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_7")
				local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							TipDlg.drawTextDailog(_string_piece_info[76])
							response.node._datas._current_buy_count = tonumber(self.buy_number)
							state_machine.excute("shop_prop_buy_list_refush", 0, response.node)
							state_machine.excute("shop_prop_buy_list_refush_new", 0, response.node)
							fwin:close(instance)
						end
					end
				end
				if instance.from_type == "war_fight" then
					if zstring.tonumber(_price:getString()) <= zstring.tonumber(_ED.user_info.exploits) then
						_ED._buy_item_consumption = _price:getString()
						protocol_command.prop_purchase.param_list = params._datas._prop.shop_prop_instance .. "\r\n" .. tonumber(self.buy_number).. "\r\n" .. tonumber(params._datas._shopType)
						NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, params._datas._instance.Tparams, responseBuyPropCallback, false, nil)
					else
						TipDlg.drawTextDailog(_string_piece_info[425])
					end
				else
					if zstring.tonumber(_price:getString()) <= zstring.tonumber(_ED.user_info.user_gold) then
						_ED._buy_item_consumption = _price:getString()
						protocol_command.prop_purchase.param_list = params._datas._prop.shop_prop_instance .. "\r\n" .. tonumber(self.buy_number).. "\r\n" .. tonumber(params._datas._shopType)
						NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, params._datas._instance.Tparams, responseBuyPropCallback, false, nil)
					else
						TipDlg.drawTextDailog(_string_piece_info[74])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local shop_equip_buy_sure_terminal = {
            _name = "shop_equip_buy_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("ggggggggggggggggggggggggggggggggggggggggggg", 2)
				local _price = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_7")
				local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							TipDlg.drawTextDailog(_string_piece_info[76])
							response.node._datas._current_buy_count = tonumber(self.buy_number)
							state_machine.excute("shop_prop_buy_list_refush", 0, response.node)
							state_machine.excute("shop_prop_buy_list_refush_new", 0, response.node)
							fwin:close(instance)
						end
					end
				end
				if instance.from_type == "war_fight" then
					if zstring.tonumber(_price:getString()) <= zstring.tonumber(_ED.user_info.exploits) then
						_ED._buy_item_consumption = _price:getString()
						protocol_command.equipment_purchase.param_list = params._datas._prop.shop_equipment_instance .. "\r\n" .. tonumber(self.buy_number)
						NetworkManager:register(protocol_command.equipment_purchase.code, nil, nil, nil, params._datas._instance.Tparams, responseBuyPropCallback, false, nil)
					else
						TipDlg.drawTextDailog(_string_piece_info[425])
					end
				else
					if zstring.tonumber(_price:getString()) <= zstring.tonumber(_ED.user_info.user_gold) then
						_ED._buy_item_consumption = _price:getString()
						protocol_command.equipment_purchase.param_list = params._datas._prop.shop_equipment_instance .. "\r\n" .. tonumber(self.buy_number)
						NetworkManager:register(protocol_command.equipment_purchase.code, nil, nil, nil, params._datas._instance.Tparams, responseBuyPropCallback, false, nil)
					else
						TipDlg.drawTextDailog(_string_piece_info[74])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local shop_prop_buy_close_terminal = {
            _name = "shop_prop_buy_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("ggggggggggggggggggggggggggggggggggggggggggg", 3)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local shop_prop_buy_number_change_terminal = {
            _name = "shop_prop_buy_number_change",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("ggggggggggggggggggggggggggggggggggggggggggg", 4)
				local function drawNumber()
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_12"):setString(self.buy_number)
					if zstring.tonumber(""..params._datas._prop.sell_tag) == 1 then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_7"):setString(params._datas._instance:drawDiscount(params._datas._prop))
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_buy_7"):setString(params._datas._instance:drawPrice(params._datas._prop))
					end
				end
			
				self.buy_number = self.buy_number + params._datas._number
				
				if self.buy_number <= 0 then
					self.buy_number = 1
				elseif tonumber(params._datas._prop.VIP_buy_times) ~= -1 then
					if self.buy_number > tonumber(params._datas._prop.VIP_buy_times - params._datas._prop.buy_times ) then
						self.buy_number = tonumber(params._datas._prop.VIP_buy_times - params._datas._prop.buy_times )
					end
				end
				drawNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(shop_prop_buy_sure_terminal)
		state_machine.add(shop_equip_buy_sure_terminal)
		state_machine.add(shop_prop_buy_close_terminal)
		state_machine.add(shop_prop_buy_number_change_terminal)
        state_machine.init()
    end
    
    -- call func init shop state machine.
    init_shop_prop_buy_number_tip_terminal()
end

function ShopPropBuyNumberTip:drawPrice(_prop)
	if tonumber(_prop.price_increase) == -1 then
		return tonumber(_prop.original_cost) * tonumber(self.buy_number)
	end
	local ret = _prop.price_increase
	local ret2 = zstring.split(ret,"!")
	local priceConfig = {}
	for n, v in pairs(ret2) do
		local temp = zstring.split(v,",")
		local range = zstring.split(temp[1], "-")
		local price = {
			_range = range,
			_price = temp[2]
		}
		priceConfig[n] = price
	end

	local buyTimes = tonumber(_prop.buy_times + 1)
	
	local price = 0
	for i=1, self.buy_number do 
		for k, m in pairs(priceConfig) do 
			if tonumber(buyTimes) >= tonumber(m._range[1]) and tonumber(buyTimes) <= tonumber(m._range[2]) then
				price = price + m._price
				buyTimes = buyTimes+1
				break
			end
		end
	end
	return price
end	

function ShopPropBuyNumberTip:drawDiscount(_prop)
	if tonumber(_prop.price_increase) == -1 then
		return tonumber(_prop.sale_price) * tonumber(self.buy_number)
	end
	local ret = _prop.price_increase
	local ret2 = zstring.split(ret,"!")
	local priceConfig = {}
	for n, v in pairs(ret2) do
		local temp = zstring.split(v,",")
		local range = zstring.split(temp[1], "-")
		local price = {
			_range = range,
			_price = temp[2]
		}
		priceConfig[n] = price
	end

	local buyTimes = tonumber(_prop.buy_times + 1)
	
	local price = 0
	for i=1, self.buy_number do 
		for k, m in pairs(priceConfig) do 
			if tonumber(buyTimes) >= tonumber(m._range[1]) and tonumber(buyTimes) <= tonumber(m._range[2]) then
				price = price + m._price
				buyTimes = buyTimes+1
				break
			end
		end
	end
	return price
end	

function ShopPropBuyNumberTip:onUpdateDraw()
	local root = self.roots[1]
	
	local textNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
	local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	local userHave = ccui.Helper:seekWidgetByName(root, "Text_buy_3")
	local price = ccui.Helper:seekWidgetByName(root, "Text_buy_7")
	local residueTimes = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	local tipText = ccui.Helper:seekWidgetByName(root, "Text_buy_5")
	local quality = nil
	if self.type == 1 then
		quality = tonumber(self.prop.prop_quality) + 1
	else
		quality = tonumber(self.prop.equipment_quality) + 1
	end
	textNumber:setString(self.buy_number)
	name:setString(self.prop.mould_name)
	
	local Image_6 = ccui.Helper:seekWidgetByName(root,"Image_6")
	Image_6:setVisible(false)
	local Image_nat_icon = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		Image_nat_icon = ccui.Helper:seekWidgetByName(root,"Image_nat_icon")
		if Image_nat_icon ~= nil then 
			Image_nat_icon:setVisible(false)
		end
	end
	if  self.from_type == "war_fight" then
		if Image_nat_icon ~= nil then
			Image_nat_icon:setVisible(true)
		end
	else
		Image_6:setVisible(true)
	end
	
	
	local times = tonumber(self.prop.VIP_buy_times) - tonumber(self.prop.buy_times)
	if tonumber(self.prop.VIP_buy_times) == -1 then
		residueTimes:setString(_string_piece_info[75])
	else
	
		if dms.int(dms["prop_mould"], tonumber(self.prop.mould_id), prop_mould.is_daily_refresh_limit) == 0 then
			-- 不可重置的
			
		else
			-- 可重置的
			residueTimes:setString(_string_piece_info[69] .. (times) .. _string_piece_info[70])
			tipText:setString(_string_piece_info[77])
		end
		
		residueTimes:setString(_string_piece_info[69] .. (times) .. _string_piece_info[70])
	end
	
	
	
	if zstring.tonumber(""..self.prop.sell_tag) == 1 then
		price:setString(self:drawDiscount(self.prop))
	else
		price:setString(self:drawPrice(self.prop))
	end
	if self.type == 1 then
		local propNumber = 0
		for i, v in pairs(_ED.user_prop) do
			if tonumber(v.user_prop_template) == tonumber(self.prop.mould_id) then
				propNumber = v.prop_number
			end
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			for i, v in pairs(_ED.user_ship) do
				if tonumber(v.ship_template_id) == tonumber(dms.int(dms["prop_mould"],self.prop.mould_id,prop_mould.use_of_ship) ) then
					propNumber = propNumber + 1
				end
			end
		end
		userHave:setString(propNumber .. _string_piece_info[32])
	else
		local equipNumber = 0
		for i, v in pairs(_ED.user_equiment) do
			if tonumber(v.user_equiment_template) == tonumber(self.prop.mould_id) then
				equipNumber = equipNumber + 1
			end
		end
		userHave:setString(equipNumber .. _string_piece_info[32])
	end
	
	name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2], color_Type[quality][3]))
end

function ShopPropBuyNumberTip:onEnterTransitionFinish()
	local csbShopPropBuyNumberTip = csb.createNode("shop/buy_props.csb")
	local root = csbShopPropBuyNumberTip:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("shop/buy_props.csb")
    csbShopPropBuyNumberTip:runAction(action)
	action:play("window_open", false)
    self:addChild(csbShopPropBuyNumberTip)
	
	local sureBuy = ccui.Helper:seekWidgetByName(root, "Button_gmdj_2")
	local closeButton = ccui.Helper:seekWidgetByName(root, "Button_gmdj_1")
	local closeButton2 = ccui.Helper:seekWidgetByName(root, "Button_1")
	local cutButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1")
	local cutButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jian_2")
	local addButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2")
	local addButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jia_1")
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_dj_tx")
	if self.type == 1 then
		local iconCell = PropIconNewCell:createCell()
		iconCell:init(iconCell.enum_type._SHOW_PROP_INFORMATION, self.prop)
		headPanel:addChild(iconCell)
	else
		local iconCell = EquipIconNewCell:createCell()
		iconCell:init(iconCell.enum_type._SHOW_EMENT_BUY, self.prop, nil)
		headPanel:addChild(iconCell)
	end
	
	fwin:addTouchEventListener(closeButton, nil, {func_string = [[state_machine.excute("shop_prop_buy_close", 0, "click shop_prop_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(closeButton2, nil, {func_string = [[state_machine.excute("shop_prop_buy_close", 0, "click shop_prop_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(cutButtonTen, nil, 
		{
			terminal_name = "shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = -10,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(cutButtonOne, nil, 
		{
			terminal_name = "shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = -1,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonTen, nil, 
		{
			terminal_name = "shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = 10,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonOne, nil, 
		{
			terminal_name = "shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = 1,
			_prop = self.prop,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
	if self.type == 1 then
		fwin:addTouchEventListener(sureBuy, nil, 
		{
			terminal_name = "shop_prop_buy_sure", 
			terminal_state = 0, 
			_prop = self.prop,
			_type = self.type,
			_instance = self,
			_shopType = self.shop_type,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	else
		fwin:addTouchEventListener(sureBuy, nil, 
		{
			terminal_name = "shop_equip_buy_sure", 
			terminal_state = 0, 
			_prop = self.prop,
			_type = self.type,
			_instance = self,
			_shopType = self.shop_type,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	
	self:onUpdateDraw()
end

function ShopPropBuyNumberTip:onExit()
	state_machine.remove("shop_prop_buy_sure")
	state_machine.remove("shop_equip_buy_sure")
	state_machine.remove("shop_prop_buy_close")
	state_machine.remove("shop_prop_buy_number_change")
end

function ShopPropBuyNumberTip:init(params)
	self.Tparams = params
	self.prop = params._datas._prop
	self.type = params._datas._type
	self.from_type = params._datas._from_type
	self.shop_type = params._datas._shopType
end

function ShopPropBuyNumberTip:createCell()
	local cell = ShopPropBuyNumberTip:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
