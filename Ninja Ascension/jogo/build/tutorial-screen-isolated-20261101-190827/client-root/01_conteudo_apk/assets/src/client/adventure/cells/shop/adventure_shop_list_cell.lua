----------------------------------------------------------------------------------------------------
-- 说明：商店仓库列表
----------------------------------------------------------------------------------------------------
AdventureShopListCell = class("AdventureShopListCellClass", Window)
AdventureShopListCell.__size = nil

function AdventureShopListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.drawIndex = 0
	self.propInfo = nil
	self.buy_times = 0 --已经购买次数
	app.load("client.adventure.cells.prop.adventure_new_prop_icon_cell")
	app.load("client.adventure.shop.AdventureShopBatch")
	-- Initialize adventure shop list cell state machine.
	local function init_adventure_shop_list_cell_terminal()
		-- 购买
        local adventure_shop_list_cell_buy_terminal = {
            _name = "adventure_shop_list_cell_buy",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--VIP礼包直接购买

            	fwin:open(AdventureShopBatch:new():init(params._datas.cell.propInfo,3,params._datas.cell), fwin._ui)
    --             local function responseBuyPropCallback(response)
				-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				-- 		app.load("client.adventure.reward.AdventureTipReward")
				-- 		fwin:open(AdventureTipReward:new():init(getSceneReward(11)), fwin._ui)
				-- 	end
				-- end
				-- protocol_command.prop_purchase.param_list = params._datas.cell.propInfo.shop_prop_instance .. "\r\n" .."1".. "\r\n" .. "0"
				-- NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, nil, responseBuyPropCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }


        --购买道具成功后刷新
        local adventure_shop_list_cell_buy_update_terminal = {
            _name = "adventure_shop_list_cell_buy_update",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if params.node ~= nil then 
        			params.node:onDrawPropUpdate(zstring.tonumber(params.buyNum))
            	end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_shop_list_cell_buy_terminal)
        state_machine.add(adventure_shop_list_cell_buy_update_terminal)
 
        state_machine.init()
	end

	-- call func init adventure shop list cell state machine.
	init_adventure_shop_list_cell_terminal()
end

function AdventureShopListCell:onInit()
	local root = cacher.createUIRef("list/list_shop.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

	if AdventureShopListCell.__size == nil then
		local sizePanel = ccui.Helper:seekWidgetByName(root, "Panel_5")
		AdventureShopListCell.__size = sizePanel:getContentSize()
	end
	local propnameText = ccui.Helper:seekWidgetByName(root, "Text_daojuname")
	local heronameText = ccui.Helper:seekWidgetByName(root, "Text_heroname")
	propnameText:setString("")
	heronameText:setString("")
	local page_index = dms.int(dms["prop_mould"], self.propInfo.mould_id, prop_mould.storage_page_index)
	if page_index == 1 then  --英雄
		heronameText:setString(dms.string(dms["prop_mould"], self.propInfo.mould_id, prop_mould.prop_name))
	else
		propnameText:setString(dms.string(dms["prop_mould"], self.propInfo.mould_id, prop_mould.prop_name))
	end

	local propDesText = ccui.Helper:seekWidgetByName(root, "Text_daoju_info")
	propDesText:setString(dms.string(dms["prop_mould"], self.propInfo.mould_id, prop_mould.remarks))

	local priceText = ccui.Helper:seekWidgetByName(root, "Text_buy")
	local sellText = ccui.Helper:seekWidgetByName(root, "Text_222")
	local originalText = ccui.Helper:seekWidgetByName(root, "Text_333")
	local buyButton = ccui.Helper:seekWidgetByName(root, "Button_buy")
	buyButton:setColor(cc.c3b(255, 255, 255))
	buyButton:setTouchEnabled(true)

	if zstring.tonumber(self.propInfo.VIP_buy_times) == 0 then
		--无上先购买
	else
		--有上限购买次数
		if zstring.tonumber(self.propInfo.buy_times) >= zstring.tonumber(self.propInfo.VIP_buy_times) then 
			buyButton:setColor(cc.c3b(150, 150, 150))
			buyButton:setTouchEnabled(false)
		end
		ccui.Helper:seekWidgetByName(root, "Text_xiangou"):setString(string.format(_string_piece_info[372],zstring.tonumber(self.propInfo.VIP_buy_times) - zstring.tonumber(self.propInfo.buy_times)))
	end
	self.buy_times = zstring.tonumber(self.propInfo.buy_times)
	
	sellText:setString("")
	originalText:setString("")
	local sellPanel = ccui.Helper:seekWidgetByName(root, "Panel_zhekou")
	if zstring.tonumber(self.propInfo.sell_tag) == 0 then 
		--无折扣
		sellPanel:setVisible(false)
		priceText:setString(self.propInfo.original_cost)
	else
		--有折扣
		sellPanel:setVisible(true)
		priceText:setString(self.propInfo.sale_price)
		sellText:setString(self.propInfo.sale_price)
		originalText:setString(self.propInfo.original_cost)
		self.propInfo.original_cost = zstring.tonumber(self.propInfo.sale_price)
	end

	
	local propItem = ccui.Helper:seekWidgetByName(root, "Panel_daoju")
	propItem:removeAllChildren(true)
	local cell = adventureNewPropIconCell:createCell()
	cell:init(0, self.propInfo, 0,nil,true)
	propItem:addChild(cell)		

	-- local cell = adventurePropIconCell:createCell()
	-- cell:init(cell.enum_type.DIAMIND_SHOP, self.propInfo, nil, nil,true)
	-- propItem:addChild(cell)
	

	-- 购买
	fwin:addTouchEventListener(buyButton, nil, 
	{
		terminal_name = "adventure_shop_list_cell_buy",	
		terminal_state = 0,
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)

end

function AdventureShopListCell:onDrawPropUpdate(buyCounts)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if zstring.tonumber(self.propInfo.VIP_buy_times) == 0 then
		--无上先购买
	else
		--有上限购买次数
		local buyButton = ccui.Helper:seekWidgetByName(root, "Button_buy")
		self.buy_times = self.buy_times + buyCounts
		if zstring.tonumber(self.buy_times) >= zstring.tonumber(self.propInfo.VIP_buy_times) then 
			buyButton:setColor(cc.c3b(150, 150, 150))
			buyButton:setTouchEnabled(false)
		end
		ccui.Helper:seekWidgetByName(root, "Text_xiangou"):setString(string.format(_string_piece_info[372],zstring.tonumber(self.propInfo.VIP_buy_times) -zstring.tonumber(self.buy_times)))
	end
end

function AdventureShopListCell:onExit()
	cacher.freeRef("list/list_shop.csb", self.roots[1])
end

function AdventureShopListCell:init(prop, drawIndex)
	self.drawIndex = drawIndex
	self.propInfo = prop

	if drawIndex ~= nil and drawIndex < 8 then
		self:onInit()
	end

	self:setContentSize(AdventureShopListCell.__size)
	return self
end

function AdventureShopListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureShopListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("list/list_shop.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(true)
	self.roots = {}
end

function AdventureShopListCell:createCell()
	local cell = AdventureShopListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

