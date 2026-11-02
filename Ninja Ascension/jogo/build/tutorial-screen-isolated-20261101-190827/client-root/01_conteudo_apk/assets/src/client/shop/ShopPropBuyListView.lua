-- ----------------------------------------------------------------------------------------------------
-- 说明：商城道具购买listView
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopPropBuyListView = class("ShopPropBuyListViewClass", Window)

function ShopPropBuyListView:ctor()
    self.super:ctor()
	
	self.roots = {}
	app.load("client.cells.prop.shop_prop_buy_list_cell")
	self.listView = nil
	self.listView_posY = nil
	self.root = nil
end

function ShopPropBuyListView:loading_equipment()
	if ShopPropBuyListView.cacheListView == nil then
		return 
	end
	
	local cell = shopPropBuyListCell:createCell()
	cell:init(_ED.return_equipment[ShopPropBuyListView.equipmentIndex],2,0)
	ShopPropBuyListView.cacheListView:addChild(cell)
	-- ShopPropBuyListView.cacheListView:requestRefreshView()
	ShopPropBuyListView.equipmentIndex = ShopPropBuyListView.equipmentIndex + 1
end

function ShopPropBuyListView:loading_prop()
	if ShopPropBuyListView.cacheListView == nil then
		return 
	end
	
	local cell = shopPropBuyListCell:createCell()
	cell:init(_ED.return_prop[ShopPropBuyListView.propIndex],1,0)
	ShopPropBuyListView.cacheListView:addChild(cell)
	ShopPropBuyListView.cacheListView:requestRefreshView()
	ShopPropBuyListView.propIndex = ShopPropBuyListView.propIndex + 1
end

function ShopPropBuyListView:initListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.listView = listView
	local ret = false	
	local count = 0
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	ShopPropBuyListView.equipmentIndex = 1
	ShopPropBuyListView.propIndex = 1
	ShopPropBuyListView.cacheListView = listView
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		app.load("client.cells.utils.multiple_list_view_cell")
		app.load("client.cells.prop.shop_prop_buy_list_cell_new")
		local preMultipleCell = nil
		local multipleCell = nil
		if _ED.return_equipment ~= nil then
			for i,v in pairs(_ED.return_equipment) do
				if tonumber(v.prop_type) == 1 then
					local cell = shopPropBuyListCellNew:createCell()
					cell:init(v,2,0,i)
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
			if _ED.return_prop ~= nil then
				for i,v in pairs(_ED.return_prop) do
					if tonumber(v.prop_type) == 0 then
						local cell = shopPropBuyListCellNew:createCell()
						cell:init(v,1,0,i)
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
		end
	else	
		if _ED.return_equipment ~= nil then
			for i, v in pairs(_ED.return_equipment) do
				if tonumber(v.prop_type) == 1 then
					local cell = shopPropBuyListCell:createCell()
					cell:init(v,2,0)
					listView:addChild(cell)
					-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_equipment, self)	
					
					count = count + 1
				end
			end
		end
		
		if _ED.return_prop ~= nil then
			for i, v in pairs(_ED.return_prop) do
				if tonumber(v.prop_type) == 0 then
					local cell = shopPropBuyListCell:createCell()
					cell:init(v,1,0)
					listView:addChild(cell)
					-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_prop, self)	
					
					count = count + 1
				end
			end
		end
	end
	if count > 0 then
		ret = true
		listView:requestRefreshView()	
	end
	self.listView_posY = listView:getInnerContainer():getPositionY()
	return ret
end
function ShopPropBuyListView:onUpdate()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self.listView ~= nil then
			local size = self.listView:getContentSize()
			local posY = self.listView:getInnerContainer():getPositionY()
			if self.listView_posY == posY then
				return
			end
			self.listView_posY = posY
			local items = self.listView:getItems()
			if items[1] == nil then
				return
			end
			local itemSize = items[1]:getContentSize()
			for i, v in pairs(items) do
				local tempY = v:getPositionY() + posY
				if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
					v:unload()
				else
					v:reload()
				end
			end
		end
	end
end
function ShopPropBuyListView:onUpdateDraw()
	local root = self.roots[1]
	-- local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	-- local count = 0
	
	local function responseShopViewCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.initListView ~= nil then
				response.node:initListView()
			end
		end
		
		-- local listviewContentSize = listView:getContentSize()
		-- local tmpContentSize = listView:getItem(1):getContentSize()
		-- tmpContentSize.height = tmpContentSize.height * count
		-- listView:getInnerContainer():setContentSize(tmpContentSize)
		-- listviewContentSize.width = tmpContentSize.width
		-- listView:setContentSize(listviewContentSize)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if _ED.last_vip_grade ~= _ED.vip_grade then
			_ED.last_vip_grade = _ED.vip_grade 
			protocol_command.shop_view.param_list = "0"
			NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
			return
		end
	end
	if self:initListView() == false then
		protocol_command.shop_view.param_list = "0"
		NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
	end
end

function ShopPropBuyListView:onEnterTransitionFinish()
	local csbShopPropBuyListView = csb.createNode("shop/shop_listview.csb")
	local root = csbShopPropBuyListView:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbShopPropBuyListView)
	
	self:onUpdateDraw()
end

function ShopPropBuyListView:onInit( ... )
	local csbShopPropBuyListView = csb.createNode("shop/shop_listview.csb")
	local root = csbShopPropBuyListView:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbShopPropBuyListView)
	
	self:onUpdateDraw()
end

function ShopPropBuyListView:onExit()
	ShopPropBuyListView.equipmentIndex = 1
	ShopPropBuyListView.propIndex = 1
	ShopPropBuyListView.cacheListView = nil
end

function ShopPropBuyListView:init(interfaceType, prop)

end

function ShopPropBuyListView:createCell()
	local cell = ShopPropBuyListView:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
