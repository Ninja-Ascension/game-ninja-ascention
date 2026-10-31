-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商城道具购买
-------------------------------------------------------------------------------------------------------

ShopPropBuyListView = class("ShopPropBuyListViewClass", Window)

function ShopPropBuyListView:ctor()
    self.super:ctor()
	
	self.roots = {}
	app.load("client.l_digital.shop.SmShopTab")
	app.load("client.l_digital.cells.prop.sm_shop_prop_buy_list_cell")
	self.root = nil
	self.index = 0
	self.page = nil
	self.button_array = {}
	self.fristOpen = true
	self.loadShop = {false, false, false, false, false}
	local function init_shop_prop_buy_list_view_terminal()
		--切换标签
		local shop_prop_buy_list_change_page_terminal = {
            _name = "shop_prop_buy_list_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if funOpenDrawTip(115+params._datas.index-1) == true then
            		return
            	end
            	if params._datas.index == 5 then
            		if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
            			TipDlg.drawTextDailog(_new_interface_text[91])
            			return
            		end
            		local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
					if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
						TipDlg.drawTextDailog(_new_interface_text[195])
						return
					end
            	end
            	if instance.index == params._datas.index then
            		return
            	end
				instance.index = params._datas.index
				for i , v in pairs(instance.button_array) do 
					if i == instance.index then
						v:setHighlighted(true)
						v:setTouchEnabled(false)
					else
						v:setHighlighted(false)
						v:setTouchEnabled(true)
					end
				end
				instance:onUpdateDraw()
				state_machine.excute("notification_center_update", 0, "push_notification_center_sm_chest_store")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local shop_prop_buy_list_scrollView_roll_terminal = {
            _name = "shop_prop_buy_list_scrollView_roll",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local currType = params._datas._type
            	local scrollView = instance.page._scroll_view:getInnerContainer()
            	local scrollViewX = 0
            	if currType == 1 then
            		scrollViewX = scrollView:getPositionX() + instance.page.roll_width
            		scrollViewX = math.max(0 , scrollViewX)
            	else
            		scrollViewX = scrollView:getPositionX() - instance.page.roll_width
            		scrollViewX = math.min(scrollViewX , instance.page._scroll_view:getContentSize().width - scrollView:getContentSize().width)
            	end
                if type(cc.nrSpineCommand)=='function' then
                    local minX=math.min(0,instance.page._scroll_view:getContentSize().width-scrollView:getContentSize().width)
                    local delta=currType==1 and instance.page.roll_width or -instance.page.roll_width
                    scrollViewX=math.max(minX,math.min(0,scrollView:getPositionX()+delta))
                end
            	scrollView:setPositionX(scrollViewX)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local shop_prop_buy_list_scrollView_update_terminal = {
            _name = "shop_prop_buy_list_scrollView_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(shop_prop_buy_list_scrollView_update_terminal)
		state_machine.add(shop_prop_buy_list_change_page_terminal)
		state_machine.add(shop_prop_buy_list_scrollView_roll_terminal)
        state_machine.init()
	end
	init_shop_prop_buy_list_view_terminal()
end

function ShopPropBuyListView:onUpdate( dt )
	if self.Button_arrow_left ~= nil and self.Button_arrow_right ~= nil then
		if self.index == 1 then
			self.Button_arrow_left:setVisible(false)
			self.Button_arrow_right:setVisible(false)
		else
			if self.page ~= nil and self.page._scroll_view ~= nil then
				local InnerContainer = self.page._scroll_view:getInnerContainer()
				if InnerContainer:getPositionX() >= 0 then
					self.Button_arrow_left:setVisible(false)
				else
					self.Button_arrow_left:setVisible(true)
				end
				if InnerContainer:getPositionX() + InnerContainer:getContentSize().width <= self.page._scroll_view:getContentSize().width then
					self.Button_arrow_right:setVisible(false)
				else
					self.Button_arrow_right:setVisible(true)
				end
			end
		end
	end
end
-- Fury: la respuesta puede llegar con la tienda ya cerrada; entonces self es un
-- cobj liberado y runAction revienta ("invalid 'cobj'"). Se suelta el candado igual.
local function unlockChangePageLater(node)
	if node == nil or tolua.isnull(node) then
		state_machine.unlock("shop_prop_buy_list_change_page")
		return false
	end
	node:runAction(cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(function ( sender )
		state_machine.unlock("shop_prop_buy_list_change_page")
	end)}))
	return true
end

function ShopPropBuyListView:onUpdateDraw()
	local root = self.roots[1]

	if self.fristOpen == true then
		app.load("client.packs.prop.SmPropWarehouseSellAll")
		local sellPropList = {}
	    for i, prop in pairs(_ED.user_prop) do
	        if dms.int(dms["prop_mould"], prop.user_prop_template, prop_mould.silver_price) > 0 then
	            table.insert(sellPropList, prop)
	        end
	    end
	    if #sellPropList > 0 then
	    	self:runAction(cc.Sequence:create({cc.DelayTime:create(0.1), cc.CallFunc:create(function ( sender )
	            state_machine.excute("prop_warehouse_sell_all_open", 0, sellPropList)
	        end)}))
	        
	    end
	    self.fristOpen = false
	end

	local Panel_shop_tab = ccui.Helper:seekWidgetByName(root, "Panel_shop_tab")
	Panel_shop_tab:removeAllChildren(true)
	if self.index == 1 then
		app.load("client.l_digital.shop.SmShopChestStore")
		local chest_store = state_machine.excute("sm_shop_chest_store_open",0,self.index)
		Panel_shop_tab:addChild(chest_store)
	elseif self.index == 2 then
		state_machine.lock("shop_prop_buy_list_change_page")
		local function responseShopViewCallBack(response)
			if unlockChangePageLater(self) == false then return end
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil then
					self.page = state_machine.excute("sm_shop_tab_open",0,response.node.index)
					Panel_shop_tab:addChild(self.page)
				end
			end
		end
		-- Fetch current stock on each entry. A failed first request must not
		-- permanently cache an empty catalog; purchases/rotations are saved.
		protocol_command.secret_shop_init.param_list = ""
		NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
	elseif self.index == 3 then
		state_machine.lock("shop_prop_buy_list_change_page")
		local function responseArenaShopInitCallback(response)
			if unlockChangePageLater(self) == false then return end
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and nil ~= response.node.roots then
					self.page = state_machine.excute("sm_shop_tab_open",0,response.node.index)
					Panel_shop_tab:addChild(self.page)
					self.loadShop[self.index] = true
				end
			end
		end

		local function responseArenaInitCallback(response)
			-- Fury: el candado sigue puesto hasta que conteste la tienda. Soltarlo aqui dejaba
			-- cambiar de pestana y la respuesta de la tienda pintaba la pestana equivocada.
			if tolua.isnull(self) or not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) then
				unlockChangePageLater(self)
				return
			end
			do
				protocol_command.arena_shop_init.param_list = "0\r\n0"
				NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, response.node, responseArenaShopInitCallback, false, nil)
			end
		end
		if _ED.local_special_shop then
			protocol_command.arena_shop_init.param_list = "0\r\n0"
			NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, self, responseArenaShopInitCallback, false, nil)
		elseif self.loadShop[self.index] == false then
			protocol_command.arena_init.param_list = "0"
			NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, self, responseArenaInitCallback, false, nil)
		else
			responseArenaShopInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
		end
	elseif self.index == 4 then
		state_machine.lock("shop_prop_buy_list_change_page")
		local function responseGloriesShopInitCallback(response)
			if unlockChangePageLater(self) == false then return end
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and nil ~= response.node.roots then
					self.page = state_machine.excute("sm_shop_tab_open",0,response.node.index)
					Panel_shop_tab:addChild(self.page)
				end
			end
		end
		NetworkManager:register(protocol_command.glories_shop_init.code, nil, nil, nil, self, responseGloriesShopInitCallback, false, nil)
	elseif self.index == 5 then
		state_machine.lock("shop_prop_buy_list_change_page")
		local function responseUnionShopInitCallBack(response)
			if unlockChangePageLater(self) == false then return end
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and nil ~= response.node.roots then
					self.page = state_machine.excute("sm_shop_tab_open",0,response.node.index)
					Panel_shop_tab:addChild(self.page)
				end
			end
		end
		local function responseUnionInitCallback(response)
			-- Fury: el candado sigue puesto hasta que conteste la tienda. Soltarlo aqui dejaba
			-- cambiar de pestana y la respuesta de la tienda pintaba la pestana equivocada.
			if tolua.isnull(self) or not (response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0) then
				unlockChangePageLater(self)
				return
			end
			do
				NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, response.node, responseUnionShopInitCallBack, false, nil)
			end
		end
		if _ED.local_special_shop then
			protocol_command.union_shop_init.param_list = ""
			NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, self, responseUnionShopInitCallBack, false, nil)
		elseif self.loadShop[self.index] == false then
			NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, self, responseUnionInitCallback, false, nil)
			self.loadShop[self.index] = true
		else
			responseUnionShopInitCallBack({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
		end
	end

	-- DSC重塑
    local textTable = {}
    if __lua_project_id == __lua_project_l_digital then
        local Text_tab_1_0 = ccui.Helper:seekWidgetByName(root, "Text_tab_1_0")
        local Text_tab_2_0 = ccui.Helper:seekWidgetByName(root, "Text_tab_2_0")
        local Text_tab_3_0 = ccui.Helper:seekWidgetByName(root, "Text_tab_3_0")
        local Text_tab_4_0 = ccui.Helper:seekWidgetByName(root, "Text_tab_4_0")
        local Text_tab_5_0 = ccui.Helper:seekWidgetByName(root, "Text_tab_5_0")

        table.insert(textTable, Text_tab_1_0)
        table.insert(textTable, Text_tab_2_0)
        table.insert(textTable, Text_tab_3_0)
        table.insert(textTable, Text_tab_4_0)
        table.insert(textTable, Text_tab_5_0)
        
        for i, v in ipairs(textTable) do
            if v ~= nil then
                v:setVisible(false)
            end
        end

		if textTable[self.index] ~= nil then
			textTable[self.index]:setVisible(true)
		end
    end
end

function ShopPropBuyListView:onEnterTransitionFinish()
	local csbShopPropBuyListView = csb.createNode("shop/shop_listview.csb")
	local root = csbShopPropBuyListView:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbShopPropBuyListView)

    self.Button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_arrow_left")
    self.Button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_arrow_right")

    fwin:addTouchEventListener(self.Button_arrow_left, nil, 
	{
		terminal_name = "shop_prop_buy_list_scrollView_roll", 
		terminal_state = 0, 
		_type = 1,
		isPressedActionEnabled = true
	},
	nil, 2)

	fwin:addTouchEventListener(self.Button_arrow_right, nil, 
	{
		terminal_name = "shop_prop_buy_list_scrollView_roll", 
		terminal_state = 0, 
		_type = 2,
		isPressedActionEnabled = true
	},
	nil, 2)

	for i=1, 5 do
		if funOpenDrawTip(115+i-1,false) == true then
			ccui.Helper:seekWidgetByName(root, "Image_lock_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_tab_"..i):setTouchEnabled(false)
		else
			ccui.Helper:seekWidgetByName(root, "Image_lock_"..i):setVisible(false)
			if self.index == 0 then
				self.index = i
			end
			ccui.Helper:seekWidgetByName(root, "Button_tab_"..i):setTouchEnabled(true)
		end
	end
	
	local buttonX_array = {}
    for i = 1 , 5 do 
    	local button = ccui.Helper:seekWidgetByName(root, "Button_tab_"..i)
	    fwin:addTouchEventListener(button, nil, 
		{
			terminal_name = "shop_prop_buy_list_change_page", 
			terminal_state = 0, 
			index = i
			-- isPressedActionEnabled = true
		},
		nil, 2)
		if i == self.index then
			button:setHighlighted(true)
			button:setTouchEnabled(false)
		else
			button:setHighlighted(false)
			button:setTouchEnabled(true)	
		end
		table.insert(self.button_array , button)
		table.insert(buttonX_array , button:getPositionX())
	end

	local widget = ccui.Helper:seekWidgetByName(root, "Button_tab_1")

	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		widget = ccui.Helper:seekWidgetByName(root, "Panel_red_1")
	end

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_chest_store",
	_widget = widget,
	_invoke = nil,
	_interval = 0.5,})

	

	-- if funOpenDrawTip(115,false) == true then
	-- 	for i , v in pairs(self.button_array) do
	-- 		if i == 1 then
	-- 			v:setVisible(false)
	-- 		else
	-- 			v:setPositionX(buttonX_array[i - 1])
	-- 		end
	-- 	end
	-- end 
	-- if funOpenDrawTip(117,false) == true then
	-- 	self.button_array[3]:setVisible(false)
	-- end
	-- if funOpenDrawTip(118,false) == true then
	-- 	self.button_array[4]:setVisible(false)
	-- 	self.button_array[5]:setPositionX(buttonX_array[3])
	-- end
	-- if funOpenDrawTip(119,false) == true then
	-- 	self.button_array[5]:setVisible(false)
	-- end


	local image = ccui.Helper:seekWidgetByName(root, "Image_lock_5")
	image:setVisible(false)
	if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
		image:setVisible(true)
	end
	
	self:onUpdateDraw()
end

function ShopPropBuyListView:init(params)
	self.index = params
end

function ShopPropBuyListView:onExit()
	state_machine.remove("shop_prop_buy_list_change_page")
	state_machine.remove("shop_prop_buy_list_scrollView_roll")
	state_machine.remove("shop_prop_buy_list_scrollView_update")
end

