-- ----------------------------------------------------------------------------------------------------
-- 说明：商城Vip礼包购买listView
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopVIPPropBuyListView = class("ShopVIPPropBuyListViewClass", Window)

function ShopVIPPropBuyListView:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.root = nil
	app.load("client.cells.prop.shop_prop_buy_list_cell")
	
	local function init_Shop_vip_prop_buy_list_terminal()
		local shop_vip_prop_buy_list_update_terminal = {
			_name = "shop_vip_prop_buy_list_update",
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
		state_machine.add(shop_vip_prop_buy_list_update_terminal)

        state_machine.init()
	end
	init_Shop_vip_prop_buy_list_terminal()
end

function ShopVIPPropBuyListView:loading_equipment()
	if ShopVIPPropBuyListView.cacheListView == nil then
		return 
	end
	
	local cell = shopPropBuyListCell:createCell()
	cell:init(_ED.return_vip_equipment[ShopVIPPropBuyListView.equipmentIndex],2,1)
	ShopVIPPropBuyListView.cacheListView:addChild(cell)
	ShopVIPPropBuyListView.cacheListView:requestRefreshView()
	ShopVIPPropBuyListView.equipmentIndex = ShopVIPPropBuyListView.equipmentIndex + 1
end

function ShopVIPPropBuyListView:loading_prop()
	if ShopVIPPropBuyListView.cacheListView == nil then
		return 
	end
	
	local prop_instance = _ED.return_vip_prop[ShopVIPPropBuyListView.propIndex]
	local times = zstring.tonumber(prop_instance.VIP_buy_times) - zstring.tonumber(prop_instance.buy_times)
	ShopVIPPropBuyListView.propIndex = ShopVIPPropBuyListView.propIndex + 1
	
	if times <= 0 then 
		return
	end
	
	local cell = shopPropBuyListCell:createCell()
	cell:init(prop_instance,1,1)
	ShopVIPPropBuyListView.cacheListView:addChild(cell)
	ShopVIPPropBuyListView.cacheListView:requestRefreshView()
end

function ShopVIPPropBuyListView:initListView()
	local ret = false
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_10")
	listView:removeAllItems()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	ShopVIPPropBuyListView.equipmentIndex = 1
	ShopVIPPropBuyListView.propIndex = 1
	ShopVIPPropBuyListView.cacheListView = listView

	local count = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		if _ED.return_vip_equipment ~= nil then
			for i, v in pairs(_ED.return_vip_equipment) do
				if tonumber(v.prop_type) == 1 and tonumber(v.VIP_can_buy) <= tonumber(_ED.vip_grade) + 1 then
					local cell = shopPropBuyListCell:createCell()
					cell:init(v,1,1)
					if multipleCell == nil then
						multipleCell = MultipleListViewCell:createCell()
						multipleCell:init(listView, cell:getContentSize())
						listView:addChild(multipleCell)
						multipleCell.prev = preMultipleCell
						if preMultipleCell ~= nil then
							preMultipleCell.next = multipleCell
						end
					end
					multipleCell:addNode(cell)
					if multipleCell.child2 ~= nil then
						preMultipleCell = multipleCell
						multipleCell = nil
					end

					count = count + 1
				end
			end
		end
		
		if _ED.return_vip_prop ~= nil then
			for i, v in pairs(_ED.return_vip_prop) do
				if tonumber(v.prop_type) == 0 and tonumber(v.VIP_can_buy) <= tonumber(_ED.vip_grade) + 2 
					and tonumber(v.VIP_buy_times) - tonumber(v.buy_times) > 0 then
					local cell = shopPropBuyListCell:createCell()
					cell:init(v,1,1)
					if multipleCell == nil then
						multipleCell = MultipleListViewCell:createCell()
						multipleCell:init(listView, cell:getContentSize())
						listView:addChild(multipleCell)
						multipleCell.prev = preMultipleCell
						if preMultipleCell ~= nil then
							preMultipleCell.next = multipleCell
						end
					end
					multipleCell:addNode(cell)
					if multipleCell.child2 ~= nil then
						preMultipleCell = multipleCell
						multipleCell = nil
					end

					count = count + 1
				end
			end
		end
	else
		if _ED.return_vip_equipment ~= nil then
			for i, v in pairs(_ED.return_vip_equipment) do
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					if tonumber(v.prop_type) == 1 then
						cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_equipment, self)	
						count = count + 1
					end
				else
					if tonumber(v.prop_type) == 1 and tonumber(v.VIP_can_buy) <= tonumber(_ED.vip_grade) + 1 then
						-- local cell = shopPropBuyListCell:createCell()
						-- cell:init(v,2,1)
						-- listView:addChild(cell)
						cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_equipment, self)	

						count = count + 1
					end
				end	
			end
		end
		
		if _ED.return_vip_prop ~= nil then
			for i, v in pairs(_ED.return_vip_prop) do
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
					if tonumber(v.prop_type) == 0  then
						cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_prop, self)	
						count = count + 1
					end
				else
					if tonumber(v.prop_type) == 0 and tonumber(v.VIP_can_buy) <= tonumber(_ED.vip_grade) + 2 then
						-- local cell = shopPropBuyListCell:createCell()
						-- cell:init(v,1,1)
						-- listView:addChild(cell)
						cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_prop, self)	
						count = count + 1
					end
				end	
			end
		end
	end
	if count > 0 then
		ret = true
		listView:requestRefreshView()
	end

	return ret
end

function ShopVIPPropBuyListView:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_10")
	
	
	local function responseVIPShopViewCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.initListViews ~= nil then
				response.node:initListView()
			end
		end
	end

	if self:initListView() == false then
		protocol_command.shop_view.param_list = "1"
		NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseVIPShopViewCallBack, false, nil)
	end
end

function ShopVIPPropBuyListView:onEnterTransitionFinish()
	local csbShopVIPPropBuyListView = csb.createNode("shop/shop_listview_1.csb")
	local root = csbShopVIPPropBuyListView:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbShopVIPPropBuyListView)
	
	self:onUpdateDraw()
end

function ShopVIPPropBuyListView:onInit( ... )
	local csbShopVIPPropBuyListView = csb.createNode("shop/shop_listview_1.csb")
	local root = csbShopVIPPropBuyListView:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbShopVIPPropBuyListView)
	
	self:onUpdateDraw()
end

function ShopVIPPropBuyListView:onExit()
	ShopVIPPropBuyListView.equipmentIndex = 1
	ShopVIPPropBuyListView.propIndex = 1
	ShopVIPPropBuyListView.cacheListView = nil
	
	state_machine.remove("shop_vip_prop_buy_list_update")
end

function ShopVIPPropBuyListView:init(interfaceType, prop)

end

function ShopVIPPropBuyListView:createCell()
	local cell = ShopVIPPropBuyListView:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
