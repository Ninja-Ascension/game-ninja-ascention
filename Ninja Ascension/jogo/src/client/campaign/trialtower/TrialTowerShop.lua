-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双商店界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TrialTowerShop = class("TrialTowerShopClass", Window)
    
function TrialTowerShop:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions={}
	self.trialTowerPowerValue = "0"					-- user power value.  威名
    self.states = 1
	self.types = nil
	app.load("client.campaign.trialtower.trial_tower_shop_list")
	self.enum_type = {
		_TYPE_COMMODITY = 1, --商品
		_TYPE_PURPLE	= 2, --紫装
		_TYPE_ORANGE = 3, --橙装
		_TYPE_REWARD = 4, --奖励
	}

    -- Initialize TrialTowerShop page state machine.
    local function init_trial_tower_terminal()
	
	-- 
	
	--发生购买了去更新数据
		local trial_tower_shop_prop_buy_list_refush_terminal = {
            _name = "trial_tower_shop_prop_buy_list_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if instance ~= nil then
						instance:refushList(params)
					end
				else
					instance:refushList(params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
	
	
	--返回按钮
		local trial_tower_shop_back_activity_terminal = {
            _name = "trial_tower_shop_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				-- if instance.types ~= nil then
					-- -- fwin:cleanView(fwin._view) 
					-- -- fwin:close(instance)
					
					-- -- app.load("client.campaign.trialtower.TrialTower")
					-- -- if fwin:find("TrialTowerClass") == nil then
						-- -- fwin:open(TrialTower:new(), fwin._view)
					-- -- end
					
					-- --state_machine.excute("menu_back_home_page", 0, "") 
					
					-- --state_machine.excute("shortcut_function_back", 0, {shortcut_function_back_scene = instance.types})
					
				-- end

				-- 不返回装备碎片页面
				-- state_machine.excute("shortcut_function_back", 0, nil)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					fwin:close(fwin:find("UserTopInfoAClass"))
				end
				fwin:close(instance)
				
				-- 检查view
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- --商品按钮
		local trial_tower_shop_button_terminal = {
            _name = "trial_tower_shop_button",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local target = params._datas.target
				local showType = tonumber(params._datas.showType)
				if target.currentType == showType then 
					target:setHighlighted(showType)
					return 
				end
				target.currentType = showType
				target:setHighlighted(showType)
				target:showList(showType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(trial_tower_shop_button_terminal)
		state_machine.add(trial_tower_shop_prop_buy_list_refush_terminal)
		-- state_machine.add(TrialTowerShop_orange_button_terminal)
		-- state_machine.add(TrialTowerShop_reward_button_terminal)
		
		state_machine.add(trial_tower_shop_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

-- 按钮
function TrialTowerShop:setHighlighted(index)

	self.commodityTxt:setVisible(false)
	self.commodityBtn:setHighlighted(false)
	
	self.purpleTxt:setVisible(false)
	self.purpleBtn:setHighlighted(false)
	
	self.orangeTxt:setVisible(false)
	self.orangeBtn:setHighlighted(false)
	
	self.rewardTxt:setVisible(false)
	self.rewardBtn:setHighlighted(false)
	
	if index == self.enum_type._TYPE_COMMODITY then --商品
		self.commodityTxt:setVisible(true)
		self.commodityBtn:setHighlighted(true)
		
	elseif index == self.enum_type._TYPE_PURPLE then --紫装
		self.purpleTxt:setVisible(true)
		self.purpleBtn:setHighlighted(true)
	
	elseif index == self.enum_type._TYPE_ORANGE then --橙装
		self.orangeTxt:setVisible(true)
		self.orangeBtn:setHighlighted(true)
	
	elseif index == self.enum_type._TYPE_REWARD then --奖励
		self.rewardTxt:setVisible(true)
		self.rewardBtn:setHighlighted(true)
	
	end

end


-- 列表
function TrialTowerShop:showList(index)
	self.commodityListView:setVisible(false)
	self.purpleListView:setVisible(false)
	self.orangeListView:setVisible(false)
	self.rewardListView:setVisible(false)

	if index == self.enum_type._TYPE_COMMODITY then --商品
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if #self.commodityListView:getItems() == 0 then
				self:initListViewOne()
			end
			self.commodityListView:setVisible(true)
		else
			self.commodityListView:setVisible(true)
		end
	elseif index == self.enum_type._TYPE_PURPLE then --紫装
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if #self.purpleListView:getItems() == 0 then
				self:initListViewTwo()
			end
			self.purpleListView:setVisible(true)
		else
			self.purpleListView:setVisible(true)
		end
	elseif index == self.enum_type._TYPE_ORANGE then --橙装
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if #self.orangeListView:getItems() == 0 then
				self:initListViewThree()
			end
			self.orangeListView:setVisible(true)
		else	
			self.orangeListView:setVisible(true)
		end
	elseif index == self.enum_type._TYPE_REWARD then --奖励
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if #self.rewardListView:getItems() == 0 then
				self:initListViewFour()
			end
			self.rewardListView:setVisible(true)
		else		
			self.rewardListView:setVisible(true)
		end
	end

end

function TrialTowerShop:drawList(index)
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	
	if nil == TrialTowerShop.list[index].isComplete then
		
	
	end
end

function TrialTowerShop.loading_cell()
	local limit = dms.int(dms["dignified_shop_model"], TrialTowerShop.asyncIndex, dignified_shop_model.purchase_count_limit)
	if limit > 0 then
		local yetCount = getTrialtowerShopLimitCount(TrialTowerShop.asyncIndex) --获取当前限定购买中 已经购买过的
		limit = math.max(limit - yetCount, 0)
	end

	if 0 == limit then
		table.insert(TrialTowerShop.zero, TrialTowerShop.asyncIndex)
	else
		--过滤可见星数限制
		local canLook = dms.int(dms["dignified_shop_model"], TrialTowerShop.asyncIndex, dignified_shop_model.sel_level)
		if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
			local sindex = dms.int(dms["dignified_shop_model"], TrialTowerShop.asyncIndex, dignified_shop_model.prop_index)
			if TrialTowerShop.list[sindex+1] == nil then
				return
			end	
			
			
			local mid = dms.int(dms["dignified_shop_model"], TrialTowerShop.asyncIndex, dignified_shop_model.prop_id)
			local cell = TrialTowerShopList:createCell()
			cell:init(mid, TrialTowerShop.asyncIndex, sindex)
			TrialTowerShop.list[sindex+1]:addChild(cell)
			TrialTowerShop.list[sindex+1]:requestRefreshView()
			cell._mid = mid
		end
	end
	
	TrialTowerShop.asyncIndex = TrialTowerShop.asyncIndex + 1
end

function TrialTowerShop.loading_cell_0()
	local index = TrialTowerShop.zero[TrialTowerShop.asyncIndex_0]
	local sindex = dms.int(dms["dignified_shop_model"], index, dignified_shop_model.prop_index)
	if TrialTowerShop.list[sindex+1] == nil then
		return
	end
	
	
	local mid = dms.int(dms["dignified_shop_model"], index, dignified_shop_model.prop_id)
	local cell = TrialTowerShopList:createCell()
	cell:init(mid, index, sindex)
	TrialTowerShop.list[sindex+1]:addChild(cell)
	cell._mid = mid
	TrialTowerShop.list[sindex+1]:requestRefreshView()
	TrialTowerShop.asyncIndex_0 = TrialTowerShop.asyncIndex_0 + 1
end

-- 初始化4页数据
function TrialTowerShop:initList()
	local shop = dms["dignified_shop_model"]
	
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	
	TrialTowerShop.zero = {} --放可购买为0的
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	TrialTowerShop.asyncIndex = 1
	TrialTowerShop.asyncIndex_0 = 1
	
	local drawIndex_1 = 1
	local drawIndex_2 = 1
	local drawIndex_3 = 1
	local drawIndex_4 = 1
	
	local lastsindex = 1
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--神装商店双列表
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local MylistViewCell = nil
		for i = 1, table.getn(shop) do
			local need_price = dms.int(shop, i, dignified_shop_model.price)
			if need_price == 999999 then
				--print("这个是备用,不添加...")
			else
				local limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit)
				if limit > 0 then
					local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
					limit = math.max(limit - yetCount, 0)
				end
			
				if 0 == limit then
					table.insert(TrialTowerShop.zero, i)
				else
					--过滤可见星数限制
					local canLook = dms.int(shop, i, dignified_shop_model.sel_level)
					if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
						local sindex = dms.int(shop, i, dignified_shop_model.prop_index)
						local mid = dms.int(shop, i, dignified_shop_model.prop_id)
						local cell = TrialTowerShopList:createCell()
						local drawIndex = 0
						if sindex == 0 then
							drawIndex = drawIndex_1
							drawIndex_1 = drawIndex_1 + 1
						elseif sindex == 1 then
							drawIndex = drawIndex_2
							drawIndex_2 = drawIndex_2 + 1
						elseif sindex == 2 then
							drawIndex = drawIndex_3
							drawIndex_3 = drawIndex_3 + 1
						elseif sindex == 3 then
							drawIndex = drawIndex_4
							drawIndex_4 = drawIndex_4 + 1
						end
						cell:init(mid, i, sindex, drawIndex)
						if lastsindex ~= sindex then--如果换列表了，要换行，不能追加在MylistViewCell后面
							MylistViewCell = nil
						end
						lastsindex = sindex
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
							TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
							MylistViewCell.prev = preMultipleCell
							if preMultipleCell ~= nil then
								preMultipleCell.next = MylistViewCell
							end
						end
						MylistViewCell:addNode(cell)
						if MylistViewCell.child2 ~= nil then
							preMultipleCell = MylistViewCell
							MylistViewCell = nil
						end
						cell._mid = mid
					end
					
				end
			end
		end
		
		
		for i = 1, table.getn(TrialTowerShop.zero) do
			local index = TrialTowerShop.zero[i]
			local sindex = dms.int(shop, index, dignified_shop_model.prop_index)
			local mid = dms.int(shop, index, dignified_shop_model.prop_id)
			local cell = TrialTowerShopList:createCell()
			local drawIndex = 0
			if sindex == 0 then
				drawIndex = drawIndex_1
				drawIndex_1 = drawIndex_1 + 1
			elseif sindex == 1 then
				drawIndex = drawIndex_2
				drawIndex_2 = drawIndex_2 + 1
			elseif sindex == 2 then
				drawIndex = drawIndex_3
				drawIndex_3 = drawIndex_3 + 1
			elseif sindex == 3 then
				drawIndex = drawIndex_4
				drawIndex_4 = drawIndex_4 + 1
			end
			cell:init(mid, index, sindex, drawIndex)
			
			if lastsindex ~= sindex then
				MylistViewCell = nil
			end
			lastsindex = sindex
			if MylistViewCell == nil then
				MylistViewCell = MultipleListViewCell:createCell()
				MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
				TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
				MylistViewCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = MylistViewCell
				end
			end
			MylistViewCell:addNode(cell)
			if MylistViewCell.child2 ~= nil then
				preMultipleCell = MylistViewCell
				MylistViewCell = nil
			end
			--TrialTowerShop.list[sindex+1]:addChild(cell)
			cell._mid = mid
			--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell_0)	
		end
	
	else
		local equips = {}
		for i = 1, table.getn(shop) do
			local limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit)
			if limit > 0 then
				local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
				limit = math.max(limit - yetCount, 0)
			end
		
			if 0 == limit then
				table.insert(TrialTowerShop.zero, i)
			else
				--过滤可见星数限制
				local canLook = dms.int(shop, i, dignified_shop_model.sel_level)
				if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
					local sindex = dms.int(shop, i, dignified_shop_model.prop_index)
					local mid = dms.int(shop, i, dignified_shop_model.prop_id)
					local cell = TrialTowerShopList:createCell()
					local drawIndex = 0
					if sindex == 0 then
						drawIndex = drawIndex_1
						drawIndex_1 = drawIndex_1 + 1
					elseif sindex == 1 then
						drawIndex = drawIndex_2
						drawIndex_2 = drawIndex_2 + 1
					elseif sindex == 2 then
						drawIndex = drawIndex_3
						drawIndex_3 = drawIndex_3 + 1
					elseif sindex == 3 then
						drawIndex = drawIndex_4
						drawIndex_4 = drawIndex_4 + 1
					end
					cell:init(mid, i, sindex, drawIndex)
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_yugioh
						or __lua_project_id == __lua_project_pokemon
					then 
						if sindex == 2 then 
							table.insert(equips,cell)
						else
							TrialTowerShop.list[sindex+1]:addChild(cell)
							cell._mid = mid
						end
					else
						TrialTowerShop.list[sindex+1]:addChild(cell)
						cell._mid = mid
					end
				end
				-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell)	
			end
			-- -- TrialTowerShop.asyncIndex = TrialTowerShop.asyncIndex + 1
			--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell)	

		end
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_yugioh
			or __lua_project_id == __lua_project_pokemon
		then
			--数码特殊需求 神装排序
			local function sortType( a, b )
				local quality1 = dms.int(dms["prop_mould"],a.mid,prop_mould.prop_quality)
				local quality2 = dms.int(dms["prop_mould"],b.mid,prop_mould.prop_quality)
		        return quality1 > quality2 
		    end
			table.sort(equips, sortType)
			for k,v in pairs(equips) do
				TrialTowerShop.list[3]:addChild(v)
				v._mid = v.mid
			end
		end
		for i = 1, table.getn(TrialTowerShop.zero) do
			local index = TrialTowerShop.zero[i]
			local sindex = dms.int(shop, index, dignified_shop_model.prop_index)
			local mid = dms.int(shop, index, dignified_shop_model.prop_id)
			local cell = TrialTowerShopList:createCell()
			local drawIndex = 0
			if sindex == 0 then
				drawIndex = drawIndex_1
				drawIndex_1 = drawIndex_1 + 1
			elseif sindex == 1 then
				drawIndex = drawIndex_2
				drawIndex_2 = drawIndex_2 + 1
			elseif sindex == 2 then
				drawIndex = drawIndex_3
				drawIndex_3 = drawIndex_3 + 1
			elseif sindex == 3 then
				drawIndex = drawIndex_4
				drawIndex_4 = drawIndex_4 + 1
			end
			cell:init(mid, index, sindex, drawIndex)
			TrialTowerShop.list[sindex+1]:addChild(cell)
			cell._mid = mid
			--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell_0)	
		end
		
	end
	for i = 1 , #TrialTowerShop.list do
		TrialTowerShop.list[i]:requestRefreshView()
	end

	self.currentInnerContainerCommodity = self.commodityListView:getInnerContainer()
	self.currentInnerContainerPosYCommodity = self.currentInnerContainerCommodity:getPositionY()
	
	self.currentInnerContainerPurple = self.purpleListView:getInnerContainer()
	self.currentInnerContainerPosYPurple = self.currentInnerContainerPurple:getPositionY()
	
	self.currentInnerContainerOrange = self.orangeListView:getInnerContainer()
	self.currentInnerContainerPosYOrange = self.currentInnerContainerOrange:getPositionY()
	
	self.currentInnerContainerReward = self.rewardListView:getInnerContainer()
	self.currentInnerContainerPosYReward = self.currentInnerContainerReward:getPositionY()
	
	self.currentType = 1 
	self:setHighlighted(1)
	self:showList(1)

	
end

function TrialTowerShop:initListViewOne( ... )
	
	local shop = dms["dignified_shop_model"]
	
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	-- TrialTowerShop.zero = {} --放可购买为0的
	local zeros_tabel = {}
	local drawIndex = 1
	app.load("client.cells.utils.multiple_list_view_cell")
	local preMultipleCell = nil
	local MylistViewCell = nil
	for i = 1, table.getn(shop) do
		local sindex = dms.int(shop, i, dignified_shop_model.prop_index)
		if sindex == 0 then		
			local need_price = dms.int(shop, i, dignified_shop_model.price)
			if need_price == 999999 then
				--print("这个是备用,不添加...")
			else
				local limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit)
				if limit > 0 then
					local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
					if yetCount == nil then
						yetCount = 0 
					end
					limit = math.max(limit - yetCount, 0)
				end
			
				if 0 == limit then
					table.insert(zeros_tabel, i)
				else
					--过滤可见星数限制
					local canLook = dms.int(shop, i, dignified_shop_model.sel_level)
					if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
						local mid = dms.int(shop, i, dignified_shop_model.prop_id)
						local cell = TrialTowerShopList:createCell()			
						cell:init(mid, i, sindex, drawIndex)
						drawIndex = drawIndex + 1
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
							TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
							MylistViewCell.prev = preMultipleCell
							if preMultipleCell ~= nil then
								preMultipleCell.next = MylistViewCell
							end
						end
						MylistViewCell:addNode(cell)
						if MylistViewCell.child2 ~= nil then
							preMultipleCell = MylistViewCell
							MylistViewCell = nil
						end
						cell._mid = mid
					end
				end
			end
		end
	end
		
	for i = 1, table.getn(zeros_tabel) do
		local index = zeros_tabel[i]
		local sindex = dms.int(shop, index, dignified_shop_model.prop_index)
		local mid = dms.int(shop, index, dignified_shop_model.prop_id)
		local cell = TrialTowerShopList:createCell()
		local drawIndex = 0
		drawIndex = drawIndex + 1
		cell:init(mid, index, sindex, drawIndex)
		if MylistViewCell == nil then
			MylistViewCell = MultipleListViewCell:createCell()
			MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
			TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
			MylistViewCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = MylistViewCell
			end
		end
		MylistViewCell:addNode(cell)
		if MylistViewCell.child2 ~= nil then
			preMultipleCell = MylistViewCell
			MylistViewCell = nil
		end
		cell._mid = mid	
	end
	self.currentInnerContainerCommodity = self.commodityListView:getInnerContainer()
	self.currentInnerContainerPosYCommodity = self.currentInnerContainerCommodity:getPositionY()
	self.currentType = 1 
	self:setHighlighted(1)
	self:showList(1)	
end

function TrialTowerShop:initListViewTwo( ... )	
	local shop = dms["dignified_shop_model"]
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	local zeros_tabel = {}
	local drawIndex = 1
	app.load("client.cells.utils.multiple_list_view_cell")
	local preMultipleCell = nil
	local MylistViewCell = nil
	for i = 1, table.getn(shop) do
		local sindex = dms.int(shop, i, dignified_shop_model.prop_index)
		if sindex == 1 then		
			local need_price = dms.int(shop, i, dignified_shop_model.price)
			if need_price == 999999 then
				--print("这个是备用,不添加...")
			else
				local limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit)
				if limit > 0 then
					local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
					if yetCount == nil then
						yetCount = 0 
					end					
					limit = math.max(limit - yetCount, 0)
				end
			
				if 0 == limit then
					table.insert(zeros_tabel, i)
				else
					--过滤可见星数限制
					local canLook = dms.int(shop, i, dignified_shop_model.sel_level)
					if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
						local mid = dms.int(shop, i, dignified_shop_model.prop_id)
						local cell = TrialTowerShopList:createCell()			
						cell:init(mid, i, sindex, drawIndex)
						drawIndex = drawIndex + 1
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
							TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
							MylistViewCell.prev = preMultipleCell
							if preMultipleCell ~= nil then
								preMultipleCell.next = MylistViewCell
							end
						end
						MylistViewCell:addNode(cell)
						if MylistViewCell.child2 ~= nil then
							preMultipleCell = MylistViewCell
							MylistViewCell = nil
						end
						cell._mid = mid
					end
				end
			end
		end
	end
		
	for i = 1, table.getn(zeros_tabel) do
		local index = zeros_tabel[i]
		local sindex = dms.int(shop, index, dignified_shop_model.prop_index)
		local mid = dms.int(shop, index, dignified_shop_model.prop_id)
		local cell = TrialTowerShopList:createCell()
		local drawIndex = 0
		drawIndex = drawIndex + 1
		cell:init(mid, index, sindex, drawIndex)
		if MylistViewCell == nil then
			MylistViewCell = MultipleListViewCell:createCell()
			MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
			TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
			MylistViewCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = MylistViewCell
			end
		end
		MylistViewCell:addNode(cell)
		if MylistViewCell.child2 ~= nil then
			preMultipleCell = MylistViewCell
			MylistViewCell = nil
		end
		cell._mid = mid	
	end
	self.currentInnerContainerPurple = self.purpleListView:getInnerContainer()
	self.currentInnerContainerPosYPurple = self.currentInnerContainerPurple:getPositionY()
end

function TrialTowerShop:initListViewThree( ... )
	
	local shop = dms["dignified_shop_model"]
	
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	-- TrialTowerShop.zero = {} --放可购买为0的
	local zeros_tabel = {}
	local drawIndex = 1
	app.load("client.cells.utils.multiple_list_view_cell")
	local preMultipleCell = nil
	local MylistViewCell = nil
	for i = 1, table.getn(shop) do
		local sindex = dms.int(shop, i, dignified_shop_model.prop_index)		
		if sindex == 2 then
			local need_price = dms.int(shop, i, dignified_shop_model.price)
			if need_price == 999999 then
				--print("这个是备用,不添加...")
			else
				local limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit)
				if limit > 0 then
					local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
					if yetCount == nil then
						yetCount = 0 
					end					
					limit = math.max(limit - yetCount, 0)
				end

				if 0 == limit then
					table.insert(zeros_tabel, i)
				else
					local canLook = dms.int(shop, i, dignified_shop_model.sel_level)
					if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
						local mid = dms.int(shop, i, dignified_shop_model.prop_id)
						local cell = TrialTowerShopList:createCell()			
						cell:init(mid, i, sindex, drawIndex)
						drawIndex = drawIndex + 1
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
							TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
							MylistViewCell.prev = preMultipleCell
							if preMultipleCell ~= nil then
								preMultipleCell.next = MylistViewCell
							end
						end
						MylistViewCell:addNode(cell)
						if MylistViewCell.child2 ~= nil then
							preMultipleCell = MylistViewCell
							MylistViewCell = nil
						end
						cell._mid = mid
					end
				end
			end
		end
	end
		
	for i = 1, table.getn(zeros_tabel) do
		local index = zeros_tabel[i]
		local sindex = dms.int(shop, index, dignified_shop_model.prop_index)
		local mid = dms.int(shop, index, dignified_shop_model.prop_id)
		local cell = TrialTowerShopList:createCell()
		local drawIndex = 0
		drawIndex = drawIndex + 1
		cell:init(mid, index, sindex, drawIndex)
		if MylistViewCell == nil then
			MylistViewCell = MultipleListViewCell:createCell()
			MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
			TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
			MylistViewCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = MylistViewCell
			end
		end
		MylistViewCell:addNode(cell)
		if MylistViewCell.child2 ~= nil then
			preMultipleCell = MylistViewCell
			MylistViewCell = nil
		end
		cell._mid = mid	
	end
	self.currentInnerContainerOrange = self.orangeListView:getInnerContainer()
	self.currentInnerContainerPosYOrange = self.currentInnerContainerOrange:getPositionY()
end

function TrialTowerShop:initListViewFour( ... )
	
	local shop = dms["dignified_shop_model"]
	
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	-- TrialTowerShop.zero = {} --放可购买为0的
	local zeros_tabel = {}
	local drawIndex = 1
	app.load("client.cells.utils.multiple_list_view_cell")
	local preMultipleCell = nil
	local MylistViewCell = nil
	for i = 1, table.getn(shop) do
		local sindex = dms.int(shop, i, dignified_shop_model.prop_index)
		if sindex == 3 then
			local need_price = dms.int(shop, i, dignified_shop_model.price)
			if need_price == 999999 then
				--print("这个是备用,不添加...")
			else
				local limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit)
				if limit > 0 then
					local yetCount = getTrialtowerShopLimitCount(i) --获取当前限定购买中 已经购买过的
					if yetCount == nil then
						yetCount = 0 
					end					
					limit = math.max(limit - yetCount, 0)
				end
			
				if 0 == limit then
					table.insert(zeros_tabel, i)
				else
					--过滤可见星数限制
					local canLook = dms.int(shop, i, dignified_shop_model.sel_level)
					if canLook <= tonumber(_ED.three_kingdoms_view.history_max_stars) then
						local mid = dms.int(shop, i, dignified_shop_model.prop_id)
						local cell = TrialTowerShopList:createCell()			
						cell:init(mid, i, sindex, drawIndex)
						drawIndex = drawIndex + 1
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
							TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
							MylistViewCell.prev = preMultipleCell
							if preMultipleCell ~= nil then
								preMultipleCell.next = MylistViewCell
							end
						end
						MylistViewCell:addNode(cell)
						if MylistViewCell.child2 ~= nil then
							preMultipleCell = MylistViewCell
							MylistViewCell = nil
						end
						cell._mid = mid
					end
					
				end
			end
		end
	end
		
	for i = 1, table.getn(zeros_tabel) do
		local index = zeros_tabel[i]
		local sindex = dms.int(shop, index, dignified_shop_model.prop_index)
		local mid = dms.int(shop, index, dignified_shop_model.prop_id)
		local cell = TrialTowerShopList:createCell()
		local drawIndex = 0
		drawIndex = drawIndex + 1
		cell:init(mid, index, sindex, drawIndex)
		if MylistViewCell == nil then
			MylistViewCell = MultipleListViewCell:createCell()
			MylistViewCell:init(TrialTowerShop.list[sindex+1],cell:getContentSize())
			TrialTowerShop.list[sindex+1]:addChild(MylistViewCell)
			MylistViewCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = MylistViewCell
			end
		end
		MylistViewCell:addNode(cell)
		if MylistViewCell.child2 ~= nil then
			preMultipleCell = MylistViewCell
			MylistViewCell = nil
		end
		cell._mid = mid	
	end
	self.currentInnerContainerReward = self.rewardListView:getInnerContainer()
	self.currentInnerContainerPosYReward = self.currentInnerContainerReward:getPositionY()
end
function TrialTowerShop:onUpdate(dt)
	if self.commodityListView ~= nil and self.currentInnerContainerCommodity ~= nil then
		
		if nil == self.currentType then
			return
		end
		
		local size = 0
		local posY = 0
		local items = {}
		local listView = nil
		
		if self.currentType == 1 then
			listView = self.commodityListView
			posY = self.currentInnerContainerCommodity:getPositionY()
			if self.currentInnerContainerPosYCommodity == posY then
				return
			end
			self.currentInnerContainerPosYCommodity = posY
			
		elseif self.currentType == 2 then
			listView = self.purpleListView
			posY = self.currentInnerContainerPurple:getPositionY()
			if self.currentInnerContainerPosYPurple == posY then
				return
			end
			self.currentInnerContainerPosYPurple = posY
			
		elseif self.currentType == 3 then
			listView = self.orangeListView
			posY = self.currentInnerContainerOrange:getPositionY()
			if self.currentInnerContainerPosYOrange == posY then
				return
			end
			self.currentInnerContainerPosYOrange = posY
		
		elseif self.currentType == 4 then
			listView = self.rewardListView
			posY = self.currentInnerContainerReward:getPositionY()
			if self.currentInnerContainerPosYReward == posY then
				return
			end
			self.currentInnerContainerPosYReward = posY
		end
		
		size = listView:getContentSize()
		items = listView:getItems()
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


function TrialTowerShop:refushList(data)
	local mid = data.mid
	local shopType = data.shopType
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_ry_3"):setString(_ED.user_info.all_glories or 0)
	
	TrialTowerShop.list = {
		self.commodityListView,
		self.purpleListView,
		self.orangeListView,
		self.rewardListView,
	} 
	
	local listview  = TrialTowerShop.list[shopType+1]
	for i = 1 , table.getn(listview:getItems()) do
		local item = listview:getItem(i-1) 
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if item.child1 ~= nil then
				if item.child1._mid == mid then
					item.child1:refushData()
					--虚拟物品模板id全-1
					--break
				end
			end
			if item.child2 ~= nil then
				if item.child2._mid == mid then
					item.child2:refushData()
					--虚拟物品模板id全-1
					--break
				end
			end
		else
			if item._mid == mid then
				item:refushData()
				--虚拟物品模板id全-1
				--break
			end
		end
	end


	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge then --刷新外面的威名数
		state_machine.excute("trial_tower_buy_updatenumber",0,"")
	end
end

function TrialTowerShop:onEnterTransitionFinish()

    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_shop.csb")	
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots,root)
   	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
		local action = csb.createTimeline("campaign/TrialTower/trial_tower_shop.csb") 
		table.insert(self.actions, action )
		csbCampaign:runAction(action)
		action:play("window_open", false)
	end
	
	--商品
	self.commodityTxt = ccui.Helper:seekWidgetByName(root, "Image_9")
	self.commodityBtn = ccui.Helper:seekWidgetByName(root, "Button_301")
	self.commodityListView = ccui.Helper:seekWidgetByName(root, "ListView_ry_shop")
	--紫色
	self.purpleTxt = ccui.Helper:seekWidgetByName(root, "Image_9_10")
	self.purpleBtn = ccui.Helper:seekWidgetByName(root, "Button_2")
	self.purpleListView = ccui.Helper:seekWidgetByName(root, "ListView_ry_shop_1")
	--橙色
	self.orangeTxt = ccui.Helper:seekWidgetByName(root, "Image_9_11")
	self.orangeBtn = ccui.Helper:seekWidgetByName(root, "Button_3")
	self.orangeListView = ccui.Helper:seekWidgetByName(root, "ListView_ry_shop_2")

	--奖励
	self.rewardTxt = ccui.Helper:seekWidgetByName(root, "Image_9_12")
	self.rewardBtn = ccui.Helper:seekWidgetByName(root, "Button_4")
	self.rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_ry_shop_3")

	self.commodityListView:removeAllItems()
	self.purpleListView:removeAllItems()
	self.orangeListView:removeAllItems()
	self.rewardListView:removeAllItems()

	local jhText =  ccui.Helper:seekWidgetByName(root, "Text_shu")
	if jhText ~= nil then
		local propsId = zstring.split(dms.string(dms["pirates_config"], 158, pirates_config.param), ",")
		jhText:setString("" ..getPropAllCountByMouldId(propsId[7]))
	end
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_trialtower_equip_shop_reward",
		_widget = self.rewardBtn,
		_invoke = nil,
		_interval = 0.5,})	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:initListViewOne()

	else
		self:initList()
	end
	
	--当前拥有威名
	ccui.Helper:seekWidgetByName(root, "Text_ry_3"):setString(_ED.user_info.all_glories or 0)

	--添加奖励商品按钮点击事件
	fwin:addTouchEventListener(self.commodityBtn, 	nil, 
	{
		terminal_name = "trial_tower_shop_button", 	
		next_terminal_name = "trial_tower_shop_button", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = false,
		showType = self.enum_type._TYPE_COMMODITY,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(self.purpleBtn, 	nil, 
	{
		terminal_name = "trial_tower_shop_button", 	
		next_terminal_name = "trial_tower_shop_button", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = false,
		showType = self.enum_type._TYPE_PURPLE,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(self.orangeBtn, 	nil, 
	{
		terminal_name = "trial_tower_shop_button", 	
		next_terminal_name = "trial_tower_shop_button", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = false,
		showType = self.enum_type._TYPE_ORANGE,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(self.rewardBtn, 	nil, 
	{
		terminal_name = "trial_tower_shop_button", 	
		next_terminal_name = "trial_tower_shop_button", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = false,
		showType = self.enum_type._TYPE_REWARD,
		target = self
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"), 	nil, 
	{
		terminal_name = "trial_tower_shop_back_activity", 	
		next_terminal_name = "trial_tower_shop_back_activity", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = true,
		target = self
	}, 
	nil, 2)
	
	
	app.load("client.player.UserTopInfoA") 					--顶部用户信息
	self.userinfo = UserTopInfoA:new()
	fwin:open(self.userinfo,fwin._view)
end


function TrialTowerShop:init(types)
	self.types = types
end

function TrialTowerShop:onExit()
	TrialTowerShop.asyncIndex = 1
	TrialTowerShop.asyncIndex_0 = 1
	TrialTowerShop.list = {}	
	
	
	
	state_machine.remove("trial_tower_shop_back_activity")
	state_machine.remove("TrialTowerShop_commodity_button")
	state_machine.remove("TrialTowerShop_purple_button")
	state_machine.remove("TrialTowerShop_orange_button")
	state_machine.remove("TrialTowerShop_reward_button")
	-- state_machine.remove("trial_tower_init_treasure")
end
