-- ----------------------------------------------------------------------------------------------------
-- 说明：战功商店道具购买listView
-- ----------------------------------------------------------------------------------------------------

NationalWarShopListView = class("NationalWarShopListViewClass", Window)

function NationalWarShopListView:ctor()
    self.super:ctor()
	
	self.roots = {}
	app.load("client.cells.prop.shop_prop_buy_list_cell")
	self.listView = nil
	self.listView_posY = nil
end

function NationalWarShopListView:loading_equipment()
	if NationalWarShopListView.cacheListView == nil then
		return 
	end
	
	local cell = shopPropBuyListCell:createCell()
	cell:init(_ED.return_equipment[NationalWarShopListView.equipmentIndex],2,0)
	NationalWarShopListView.cacheListView:addChild(cell)
	-- NationalWarShopListView.cacheListView:requestRefreshView()
	NationalWarShopListView.equipmentIndex = NationalWarShopListView.equipmentIndex + 1
end

function NationalWarShopListView:loading_prop()
	if NationalWarShopListView.cacheListView == nil then
		return 
	end
	
	local cell = shopPropBuyListCell:createCell()
	cell:init(_ED.return_prop[NationalWarShopListView.propIndex],1,0)
	NationalWarShopListView.cacheListView:addChild(cell)
	NationalWarShopListView.cacheListView:requestRefreshView()
	NationalWarShopListView.propIndex = NationalWarShopListView.propIndex + 1
end

function NationalWarShopListView:initListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.listView = listView
	local ret = false	
	local count = 0
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	NationalWarShopListView.equipmentIndex = 1
	NationalWarShopListView.propIndex = 1
	NationalWarShopListView.cacheListView = listView
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_legendary_game 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		app.load("client.cells.prop.shop_prop_buy_list_cell_new")
		local preMultipleCell = nil
		local multipleCell = nil
		if _ED.return_war_equipment ~= nil then
			for i,v in pairs(_ED.return_war_equipment) do
				if tonumber(v.prop_type) == 1 then
					local cell = shopPropBuyListCellNew:createCell()
					cell:init(v,2,0,i,"war_fight")
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
		if _ED.return_war_prop ~= nil then
			for i,v in pairs(_ED.return_war_prop) do
				if tonumber(v.prop_type) == 0 then
					local cell = shopPropBuyListCellNew:createCell()
					cell:init(v,1,0,i,"war_fight")
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
		
		if _ED.return_war_prop ~= nil then
			for i, v in pairs(_ED.return_war_prop) do
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

function NationalWarShopListView:onUpdate()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
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

function NationalWarShopListView:onUpdateDraw()
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

	if self:initListView() == false then
		protocol_command.shop_view.param_list = "0"
		NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
	end
end

function NationalWarShopListView:onEnterTransitionFinish()
	local csbNationalWarShopListView = csb.createNode("shop/shop_listview.csb")
	local root = csbNationalWarShopListView:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNationalWarShopListView)
	
	self:onUpdateDraw()
end

function NationalWarShopListView:onExit()
	NationalWarShopListView.equipmentIndex = 1
	NationalWarShopListView.propIndex = 1
	NationalWarShopListView.cacheListView = nil
end

function NationalWarShopListView:init(interfaceType, prop)

end

function NationalWarShopListView:createCell()
	local cell = NationalWarShopListView:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
