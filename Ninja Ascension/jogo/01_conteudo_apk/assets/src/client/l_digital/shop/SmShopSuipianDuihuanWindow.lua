-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商城碎片兑换界面
-------------------------------------------------------------------------------------------------------
SmShopSuipianDuihuanWindow = class("SmShopSuipianDuihuanWindowClass", Window)

local sm_shop_suipian_duihuan_window_open_terminal = {
    _name = "sm_shop_suipian_duihuan_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local _win = fwin:find("SmShopSuipianDuihuanWindowClass")
    	if _win ~= nil then
    		fwin:close(_win)
    	end
    	local page = SmShopSuipianDuihuanWindow:new():init(params)
    	fwin:open(page , fwin._ui)
		return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_shop_suipian_duihuan_window_close_terminal = {
    _name = "sm_shop_suipian_duihuan_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:close(fwin:find("SmShopSuipianDuihuanWindowClass"))
		return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_shop_suipian_duihuan_window_open_terminal)
state_machine.add(sm_shop_suipian_duihuan_window_close_terminal)
state_machine.init()

function SmShopSuipianDuihuanWindow:ctor()
    self.super:ctor()
	self.roots = {}
	self.prop = nil

	self._have_cost = 0
	self._select_number = 0
	self._max_select_number = 0

	local function init_sm_shop_suipian_duihuan_window_terminal()
		local sm_shop_suipian_duihuan_window_confirm_buy_terminal = {
            _name = "sm_shop_suipian_duihuan_window_confirm_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance._have_cost < (instance.prop.sale_percentage * instance._select_number) then
            		TipDlg.drawTextDailog(string.format( _new_interface_text[93] , _new_interface_text[189]))
            		return
            	end
            	local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(string.format(_string_piece_info[76]))
						state_machine.excute("sm_shop_suipian_duihuan_window_close", 0, "")
						state_machine.excute("sm_shop_debris_exchange_update_money", 0, "")
						state_machine.excute("sm_shop_chest_store_update_debris_count", 0, "")
					end
				end
            	protocol_command.shop_frags_exchange.param_list = ""..instance.prop.good_index.."\r\n"..instance._select_number
				NetworkManager:register(protocol_command.shop_frags_exchange.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local sm_shop_suipian_duihuan_window_change_number_terminal = {
            _name = "sm_shop_suipian_duihuan_window_change_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local number = instance._select_number + params._datas.add_number
            	instance:changeSelectNumber(number)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_suipian_duihuan_window_max_number_terminal = {
            _name = "sm_shop_suipian_duihuan_window_max_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectNumber(self._max_select_number)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_shop_suipian_duihuan_window_confirm_buy_terminal)
		state_machine.add(sm_shop_suipian_duihuan_window_change_number_terminal)
		state_machine.add(sm_shop_suipian_duihuan_window_max_number_terminal)
        state_machine.init()
	end
	init_sm_shop_suipian_duihuan_window_terminal()
end

function SmShopSuipianDuihuanWindow:changeSelectNumber(number)
	local root = self.roots[1]
	number = math.min(self._max_select_number, math.max(1, number))
	if self._max_select_number == 0 then
		number = 1
	end
	if number == self._select_number then
		return
	end
	self._select_number = number
    
	--价格
	local Text_price_n = ccui.Helper:seekWidgetByName(root, "Text_price_n")
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	Text_number:setString(number)

	local have_cost = self._have_cost
	local cost = tonumber(self.prop.sale_percentage) * number
	Text_price_n:setString(cost)
	if cost > have_cost then
		Text_price_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		Text_price_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	end

	local Button_jian = ccui.Helper:seekWidgetByName(root, "Button_jian")
	local Button_jia = ccui.Helper:seekWidgetByName(root, "Button_jia")
	local Button_max = ccui.Helper:seekWidgetByName(root, "Button_max")
	Button_jian:setTouchEnabled(true)
	Button_jian:setBright(true)
	Button_jia:setTouchEnabled(true)
	Button_jia:setBright(true)
	Button_max:setTouchEnabled(true)
	Button_max:setBright(true)
	if number <= 1 then
		Button_jian:setTouchEnabled(false)
		Button_jian:setBright(false)
	end
    if number >= self._max_select_number then
		Button_jia:setTouchEnabled(false)
		Button_jia:setBright(false)
		Button_max:setTouchEnabled(false)
		Button_max:setBright(false)
	end
end

function SmShopSuipianDuihuanWindow:onUpdateDraw()
	local root = self.roots[1]
	local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")
	local image_gem = ccui.Helper:seekWidgetByName(root, "image_gem")
	Panel_packs_props_icon:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	local quality = tonumber(self.prop.prop_quality)
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,nil,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id))
	end
	Panel_packs_props_icon:addChild(cell)
	--名称
	local Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")
	Text_packs_props_name:setString(self.prop.mould_name)
	--描述
	local Text_props_info = ccui.Helper:seekWidgetByName(root, "Text_props_info")
	Text_props_info:setString(self.prop.mould_remarks)

	if self.prop.mould_id == 104 then
		Text_props_info:setFontSize(18)
	end

	--拥有数量
	local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
	local haveNumber = 0
	if tonumber(self.prop.type) == 7 then
		for i, v in pairs(_ED.user_equiment) do
			if v.user_equiment_template == ""..self.prop.mould_id then 
				haveNumber = haveNumber + 1
			end
		end
	else
		haveNumber = getPropAllCountByMouldId(tonumber(self.prop.mould_id))
	end
	Text_have_n:setString("")
	Text_have_n:removeAllChildren(true)
	local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
     local re1 = ccui.RichElementText:create(1, cc.c3b(255,255,255),255, haveNumber, Text_have_n:getFontName(),Text_have_n:getFontSize())
    _richText:pushBackElement(re1)  
     local re2 = ccui.RichElementText:create(1, cc.c3b(225,182,0),255, _new_interface_text[97], Text_have_n:getFontName(),Text_have_n:getFontSize())
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_have_n:getContentSize().width / 2,Text_have_n:getContentSize().height/2 + 3))
    _richText:setContentSize(cc.size(Text_have_n:getContentSize().width,18))
    Text_have_n:addChild(_richText)

    self._max_select_number = math.floor(self._have_cost / tonumber(self.prop.sale_percentage))
    if zstring.tonumber(self.prop.max_buy_times) > 0 then
    	local buy_times = 0
    	for k,v in pairs(_ED.shop_frags_info.shop_list) do
    		if tonumber(v.good_id) == tonumber(self.prop.good_id) then
    			buy_times = tonumber(v.buy_times)
    			break
    		end
    	end
    	if self._max_select_number > zstring.tonumber(self.prop.max_buy_times) - buy_times then
    		self._max_select_number = zstring.tonumber(self.prop.max_buy_times) - buy_times
    	end
    	if buy_times >= zstring.tonumber(self.prop.max_buy_times) then
    		ccui.Helper:seekWidgetByName(root, "Button_sell"):setTouchEnabled(false)
    		ccui.Helper:seekWidgetByName(root, "Button_sell"):setBright(false)
    	end
    end

    self:changeSelectNumber(1)
end

function SmShopSuipianDuihuanWindow:onInit()
	local csbSmShopSuipianDuihuanWindow = csb.createNode("shop/sm_shop_suipian_duihuan_window.csb")
	local root = csbSmShopSuipianDuihuanWindow:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopSuipianDuihuanWindow)

    self._have_cost = tonumber(_ED.user_info.jade)

    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    Image_1:setTouchEnabled(true)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sell"), nil, 
	{
		terminal_name = "sm_shop_suipian_duihuan_window_confirm_buy", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "sm_shop_suipian_duihuan_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian"), nil, 
	{
		terminal_name = "sm_shop_suipian_duihuan_window_change_number", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		add_number = -1,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia"), nil, 
	{
		terminal_name = "sm_shop_suipian_duihuan_window_change_number", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		add_number = 1,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil, 
	{
		terminal_name = "sm_shop_suipian_duihuan_window_max_number", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, 
	nil, 0)
	
	self:onUpdateDraw()
end

function SmShopSuipianDuihuanWindow:init(params)
	self.prop = params[1]
	self.index = params[2]
	self:onInit()
	return self
end

function SmShopSuipianDuihuanWindow:onExit()
	state_machine.remove("sm_shop_suipian_duihuan_window_confirm_buy")
	state_machine.remove("sm_shop_suipian_duihuan_window_change_number")
	state_machine.remove("sm_shop_suipian_duihuan_window_max_number")
end

