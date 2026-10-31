-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场荣誉商店
-- 创建时间：2015-03-30
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaHonorShop = class("ArenaHonorShopClass", Window)
    
function ArenaHonorShop:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions={}
	app.load("client.cells.campaign.arena_honor_shop_seat_cell")
	
	self.enum_type = {
		_TYPE_HONOR_SHOP = 1,						-- 荣誉商店
		_TYPE_REWARD_SHOP = 2,						-- 奖励商店
	}
	
	self.currentType = self.enum_type._TYPE_HONOR_SHOP	--当前显示的类型
	
	self.cacheHonorText = nil	--缓存荣誉显示文本
	self.cacheListView = nil	--缓存listview
	
	--缓存商品button
	self.cacheHonorCommodityBtn = nil
	
	--缓存奖励button
	self.cacheRewardCommodityBtn = nil
	
	self.cacheCellData = {
		honorCells = {},
		rewardCells = {}
	}

	self.isInitReward = false
	
	self.currentBuyId = -1		--当前购买物品的ID 不是模板ID喔 
	self.currentBuyNums = -1	--当前购买物品的个数
	self.currentBuyShopType = -1--当前购买物品的类型
    -- Initialize ArenaHonorShop page state machine.
    local function init_arena_honor_shop_terminal()
	
		local arena_honor_shop_close_terminal = {
            _name = "arena_honor_shop_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- fwin:open(Campaign:new(), fwin._view)
				fwin:close(instance.userInformationHeroStorage)
				--fwin:close(instance)
				fwin:close(fwin:find("ArenaHonorShopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--荣誉商品点击事件
		local arena_honor_commodity_btn_terminal = {
            _name = "arena_honor_commodity_btn",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				
				if instance.currentType == tonumber(params._datas.showType) then 
					instance:showCacheHonorCommodity()
					return 
				end
				instance:closeHighlighted()
				instance:showCacheHonorCommodity()
				instance.currentType = tonumber(params._datas.showType)
				instance:initDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--奖励商品点击事件
		local arena_reward_commodity_btn_terminal = {
            _name = "arena_reward_commodity_btn",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				if instance.currentType == tonumber(params._datas.showType) then 
					instance:showCacheRewardCommodity()
					return 
				end
				instance:closeHighlighted()
				instance:showCacheRewardCommodity()
				instance.currentType = tonumber(params._datas.showType)
				instance:initDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--确定购买
		local arena_honor_buy_excute_terminal = {
            _name = "arena_honor_buy_excute",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--买买买 路服务器
				if TipDlg.drawStorageTipo({4}) == false then
					instance.currentBuyId = params._datas.prodID
					instance.currentBuyNums = params._datas.nums
					instance.currentBuyShopType = params._datas.shopType
					if tonumber(instance.currentBuyShopType) == 0 then
						app.load("client.campaign.worldboss.WorldBossShopBuyNumber")
						local ntip = WorldBossShopBuyNumber:createCell()
						ntip:init(params._datas.config)
						fwin:open(ntip, fwin._windows)
					else
						instance:requestBuyProd(instance.currentBuyId, instance.currentBuyNums)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--确定购买竞技场商店物品
		local arena_honor_buy_honor_terminal = {
            _name = "arena_honor_buy_honor",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.currentBuyId = params._datas._prop
				self.currentBuyNums = params._datas._current_buy_count
				self.currentBuyShopType = "0"
				self:requestBuyProd(self.currentBuyId, self.currentBuyNums)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--seat Icon点击事件
		local arena_seat_icon_btn_click_terminal = {
            _name = "arena_seat_icon_btn_click",
            _init = function (terminal) 
				app.load("client.packs.hero.HeroPatchInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local t_id = tonumber(params._datas.tID)
				local t_type = tonumber(params._datas.tType)
				
				--物品类型(0:道具 2:英雄 1:装备)
				if t_type == 0 then
					
				elseif t_type == 1 then
					
				elseif t_type == 2 then
					-- HeroPatchInformation
					-- local tmpShipId = dms.int(dms["prop_mould"], t_id, prop_mould.use_of_ship)
					-- local tmpName = dms.string(dms["ship_mould"], tmpShipId, ship_mould.captain_name)
					
					-- local hpi = HeroPatchInformation:new()
					-- hpi:init({ user_prop_template = tmpShipId, prop_name = tmpName }, 2)
					-- fwin:open(hpi, fwin._windows)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_honor_shop_close_terminal)
        state_machine.add(arena_honor_commodity_btn_terminal)
        state_machine.add(arena_reward_commodity_btn_terminal)
        state_machine.add(arena_seat_icon_btn_click_terminal)
        state_machine.add(arena_honor_buy_excute_terminal)
        state_machine.add(arena_honor_buy_honor_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_honor_shop_terminal()
end

function ArenaHonorShop.loadingA(texture)
	if ArenaHonorShop.honorListView == nil then
		return
	end
	
	local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good[ArenaHonorShop.A_index].good_id, arena_shop_info.shop_type)
	local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good[ArenaHonorShop.A_index].good_id, arena_shop_info.item_mould)
	if item_mould ~= -1 then
		local limit = dms.int(dms["arena_shop_info"], _ED.arena_good[ArenaHonorShop.A_index].good_id, arena_shop_info.exchange_count_limit)
		if limit == -1 or limit - tonumber(_ED.arena_good[ArenaHonorShop.A_index].exchange_times) > 0 then
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(_ED.arena_good[ArenaHonorShop.A_index].good_id, tmpType, ArenaHonorShop.A_index)
			ArenaHonorShop.honorListView:addChild(AHSC)
			ArenaHonorShop.honorListView:requestRefreshView()
		end
	end
	ArenaHonorShop.A_index = ArenaHonorShop.A_index + 1
	
	ArenaHonorShop.loadingC(texture)
end

function ArenaHonorShop.loadingB(texture)
	if ArenaHonorShop.honorListView == nil then
		return
	end

	local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good[ArenaHonorShop.B_index].good_id, arena_shop_info.shop_type)
	local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good[ArenaHonorShop.B_index].good_id, arena_shop_info.item_mould)
	if item_mould ~= -1 then
		local limit = dms.int(dms["arena_shop_info"], _ED.arena_good[ArenaHonorShop.B_index].good_id, arena_shop_info.exchange_count_limit)
		if limit ~= -1 and limit - tonumber(_ED.arena_good[ArenaHonorShop.B_index].exchange_times) <= 0 then
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(_ED.arena_good[ArenaHonorShop.B_index].good_id, tmpType, ArenaHonorShop.B_index)
			ArenaHonorShop.honorListView:addChild(AHSC)
			ArenaHonorShop.honorListView:requestRefreshView()
		end
	end
	ArenaHonorShop.B_index = ArenaHonorShop.B_index + 1
	
	ArenaHonorShop.loadingD(texture)
end

function ArenaHonorShop.loadingC(texture)
	if ArenaHonorShop.rewardListView == nil or zstring.tonumber(_ED.arena_good_reward_number) <= ArenaHonorShop.C_index then
		return
	end

	local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[ArenaHonorShop.C_index].good_id, arena_shop_info.shop_type)
	local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[ArenaHonorShop.C_index].good_id, arena_shop_info.item_mould)
	if item_mould ~= -1 then
		local limit = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[ArenaHonorShop.C_index].good_id, arena_shop_info.exchange_count_limit)
		if limit - tonumber(_ED.arena_good_reward[ArenaHonorShop.C_index].exchange_times) > 0 then
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(_ED.arena_good_reward[ArenaHonorShop.C_index].good_id, tmpType, ArenaHonorShop.C_index)
			ArenaHonorShop.rewardListView:addChild(AHSC)
			ArenaHonorShop.rewardListView:requestRefreshView()
		end
	end	
	ArenaHonorShop.C_index = ArenaHonorShop.C_index + 1
end

function ArenaHonorShop.loadingD(texture)
	if ArenaHonorShop.rewardListView == nil or zstring.tonumber(_ED.arena_good_reward_number) <= ArenaHonorShop.D_index then
		return
	end

	local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[ArenaHonorShop.D_index].good_id, arena_shop_info.shop_type)
	local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[ArenaHonorShop.D_index].good_id, arena_shop_info.item_mould)
	if item_mould ~= -1 then
		local limit = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[ArenaHonorShop.D_index].good_id, arena_shop_info.exchange_count_limit)
		if limit - tonumber(_ED.arena_good_reward[ArenaHonorShop.D_index].exchange_times) <= 0 then
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(_ED.arena_good_reward[ArenaHonorShop.D_index].good_id, tmpType, ArenaHonorShop.D_index)
			ArenaHonorShop.rewardListView:addChild(AHSC)
			ArenaHonorShop.rewardListView:requestRefreshView()
		end
	end		
	ArenaHonorShop.D_index = ArenaHonorShop.D_index + 1	
end

function ArenaHonorShop:initListView(_listview,_type)
	
	local canInsert
	--[[
	for i, v in ipairs(dms["arena_shop_info"]) do
	
		canInsert = false
		
		local tmpType = dms.int(dms["arena_shop_info"], i, arena_shop_info.shop_type)
		
		local item_mould = dms.int(dms["arena_shop_info"], i, arena_shop_info.item_mould)
		--类型为-1的不画
		if item_mould ~= -1 then
			if tmpType + 1 == _type then
				canInsert = true
			end
			
			if canInsert == true then
				local AHSC = ArenaHonorShopSeatCell:createCell()
				AHSC:init(i, tmpType)
				-- _listview:pushBackCustomItem(AHSC)
				_listview:addChild(AHSC)
			end
		end
	end
	--]]
	ArenaHonorShop._listview = _listview
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    
	if tonumber(_type) == 1 then
		ArenaHonorShop.A_index = 1
		for i=1, _ED.arena_good_number do
			-- local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good[i].good_id, arena_shop_info.shop_type)
			-- local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good[i].good_id, arena_shop_info.item_mould)
			-- if item_mould ~= -1 then
				-- local limit = dms.int(dms["arena_shop_info"], _ED.arena_good[i].good_id, arena_shop_info.exchange_count_limit)
				-- if limit == -1 or limit - tonumber(_ED.arena_good[i].exchange_times) > 0 then
					-- local AHSC = ArenaHonorShopSeatCell:createCell()
					-- AHSC:init(_ED.arena_good[i].good_id, tmpType, i)
					-- _listview:addChild(AHSC)
				-- end
			-- end
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loadingA)
		end
		ArenaHonorShop.B_index = 1
		for i=1, _ED.arena_good_number do
			-- local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good[i].good_id, arena_shop_info.shop_type)
			-- local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good[i].good_id, arena_shop_info.item_mould)
			-- if item_mould ~= -1 then
				-- local limit = dms.int(dms["arena_shop_info"], _ED.arena_good[i].good_id, arena_shop_info.exchange_count_limit)
				-- if limit ~= -1 and limit - tonumber(_ED.arena_good[i].exchange_times) <= 0 then
					-- local AHSC = ArenaHonorShopSeatCell:createCell()
					-- AHSC:init(_ED.arena_good[i].good_id, tmpType, i)
					-- _listview:addChild(AHSC)
				-- end
			-- end
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loadingB)
		end
	elseif tonumber(_type) == 2 then
		ArenaHonorShop.C_index = 1
		for i=1, _ED.arena_good_reward_number do
			-- local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[i].good_id, arena_shop_info.shop_type)
			-- local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[i].good_id, arena_shop_info.item_mould)
			-- if item_mould ~= -1 then
				-- local limit = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[i].good_id, arena_shop_info.exchange_count_limit)
				-- if limit - tonumber(_ED.arena_good_reward[i].exchange_times) > 0 then
					-- local AHSC = ArenaHonorShopSeatCell:createCell()
					-- AHSC:init(_ED.arena_good_reward[i].good_id, tmpType, i)
					-- _listview:addChild(AHSC)
				-- end
			-- end			
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loadingC)
		end
		ArenaHonorShop.D_index = 1
		for i=1, _ED.arena_good_reward_number do
			-- local tmpType = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[i].good_id, arena_shop_info.shop_type)
			-- local item_mould = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[i].good_id, arena_shop_info.item_mould)
			-- if item_mould ~= -1 then
				-- local limit = dms.int(dms["arena_shop_info"], _ED.arena_good_reward[i].good_id, arena_shop_info.exchange_count_limit)
				-- if limit - tonumber(_ED.arena_good_reward[i].exchange_times) <= 0 then
					-- local AHSC = ArenaHonorShopSeatCell:createCell()
					-- AHSC:init(_ED.arena_good_reward[i].good_id, tmpType, i)
					-- _listview:addChild(AHSC)
				-- end
			-- end			
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loadingD)
		end
	end
	--重置listview的size
	self:reviseListviewSize(_listview)
end

function ArenaHonorShop:initDrawList()
	--self:initListView(ArenaHonorShop.honorListView, self.enum_type._TYPE_HONOR_SHOP)
	--self:initListView(ArenaHonorShop.rewardListView, self.enum_type._TYPE_REWARD_SHOP)
	
	ArenaHonorShop.honorListView:setVisible(false)
	ArenaHonorShop.rewardListView:setVisible(false)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self:onUpdateDrawHonor()
	else
		self:onUpdateDrawHonor()
		self:onUpdateDrawReward()
	end
end


function ArenaHonorShop:onUpdateDrawHonor()
	local root = self.roots[1]
	
	local limitList = {}
	local listView = ArenaHonorShop.honorListView -- 	ArenaHonorShop.honorListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllChildren(true)
	local index = 1
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--双列表				
		app.load("client.cells.utils.multiple_list_view_cell")
		
		local preMultipleCell = nil
		local MylistViewCell = nil
		for i,v in ipairs(_ED.arena_good) do
		
		local good_id = _ED.arena_good[i].good_id
		local tmpType = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_type)
		local item_mould = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.item_mould)
		local shop_display_level = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_display_level)
		
			if item_mould ~= -1 then
				if shop_display_level <= tonumber(_ED.user_info.user_grade)  then
					local limit = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.exchange_count_limit)
					local cell = ArenaHonorShopSeatCell:createCell()
					if limit == -1 or limit - tonumber(_ED.arena_good[i].exchange_times) > 0 then
						cell:init(good_id, tmpType, i, index)
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(listView, cc.size(450,127))
							listView:addChild(MylistViewCell)
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
						index = index +1
					else
						table.insert(limitList, v)
					end
				end
			end
		end
		
		for i,v in ipairs(limitList) do
			local tmpType = dms.int(dms["arena_shop_info"], v.good_id, arena_shop_info.shop_type)
			local cell = ArenaHonorShopSeatCell:createCell()
			cell:init(v.good_id, tmpType, i, index)
			
			if MylistViewCell == nil then
				MylistViewCell = MultipleListViewCell:createCell()
				MylistViewCell:init(listView, cc.size(450,127))
				listView:addChild(MylistViewCell)
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
			index = index +1
		end
	else	
	
		for i,v in ipairs(_ED.arena_good) do
			local good_id = _ED.arena_good[i].good_id
			local tmpType = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_type)
			local item_mould = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.item_mould)
			local shop_display_level = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_display_level)
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if shop_display_level <= tonumber(_ED.user_info.user_grade)  then
					-- 等级足够的才显示
					local limit = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.exchange_count_limit)
					local AHSC = ArenaHonorShopSeatCell:createCell()
					if limit == -1 or limit - tonumber(_ED.arena_good[i].exchange_times) > 0 then
						AHSC:init(good_id, tmpType, i, index)
						listView:addChild(AHSC)
						index = index +1
					else
						table.insert(limitList, v)
					end
				end
			else
				if item_mould ~= -1 then
					if shop_display_level <= tonumber(_ED.user_info.user_grade)  then
						-- 等级足够的才显示
						local limit = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.exchange_count_limit)
						local AHSC = ArenaHonorShopSeatCell:createCell()
						if limit == -1 or limit - tonumber(_ED.arena_good[i].exchange_times) > 0 then
							AHSC:init(good_id, tmpType, i, index)
							listView:addChild(AHSC)
							index = index +1
						else
							table.insert(limitList, v)
						end
					end
				end
			end
		end
		
		for i,v in ipairs(limitList) do
			local tmpType = dms.int(dms["arena_shop_info"], v.good_id, arena_shop_info.shop_type)
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(v.good_id, tmpType, i, index)
			listView:addChild(AHSC)
			index = index +1
		end
	end
	listView:requestRefreshView()
	self.currentInnerContainerHonor = listView:getInnerContainer()
	self.currentInnerContainerPosYHonor = listView:getInnerContainer():getPositionY()
end


function ArenaHonorShop:onUpdateDrawReward()
	local root = self.roots[1]
	
	local limitList = {}
	local listView = ArenaHonorShop.rewardListView
	listView:removeAllChildren(true)
	
	local index = 1
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		--双列表				
		app.load("client.cells.utils.multiple_list_view_cell")
		
		local preMultipleCell = nil
		local MylistViewCell = nil
		for i,v in ipairs(_ED.arena_good_reward) do
			local good_id = _ED.arena_good_reward[i].good_id
			local tmpType = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_type)
			local item_mould = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.item_mould)
			local shop_display_level = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_display_level)
			if item_mould ~= -1 then
				if shop_display_level <= tonumber(_ED.user_info.user_grade)  then
					-- 等级足够的才显示
					local limit = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.exchange_count_limit)
					local AHSC = ArenaHonorShopSeatCell:createCell()
					if limit == -1 or limit - tonumber(_ED.arena_good_reward[i].exchange_times) > 0 then
						AHSC:init(good_id, tmpType, i, index)
						
						if MylistViewCell == nil then
							MylistViewCell = MultipleListViewCell:createCell()
							MylistViewCell:init(listView, cc.size(450,127))
							listView:addChild(MylistViewCell)
							MylistViewCell.prev = preMultipleCell
							if preMultipleCell ~= nil then
								preMultipleCell.next = MylistViewCell
							end
						end
						MylistViewCell:addNode(AHSC)
						if MylistViewCell.child2 ~= nil then
							preMultipleCell = MylistViewCell
							MylistViewCell = nil
						end
						
						--listView:addChild(AHSC)
						index = index +1
					else
						table.insert(limitList, v)
					end
				end
			end
		end
		
		for i,v in ipairs(limitList) do
			local tmpType = dms.int(dms["arena_shop_info"], v.good_id, arena_shop_info.shop_type)
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(v.good_id, tmpType, i, index)
			
			if MylistViewCell == nil then
				MylistViewCell = MultipleListViewCell:createCell()
				MylistViewCell:init(listView, cc.size(450,127))
				listView:addChild(MylistViewCell)
				MylistViewCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = MylistViewCell
				end
			end
			MylistViewCell:addNode(AHSC)
			if MylistViewCell.child2 ~= nil then
				preMultipleCell = MylistViewCell
				MylistViewCell = nil
			end
			
			--listView:addChild(AHSC)
			index = index +1
		end
		
	else	
		for i,v in ipairs(_ED.arena_good_reward) do
			local good_id = _ED.arena_good_reward[i].good_id
			local tmpType = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_type)
			local item_mould = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.item_mould)
			local shop_display_level = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.shop_display_level)
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if shop_display_level <= tonumber(_ED.user_info.user_grade)  then
					-- 等级足够的才显示
					local limit = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.exchange_count_limit)
					local AHSC = ArenaHonorShopSeatCell:createCell()
					if limit == -1 or limit - tonumber(_ED.arena_good_reward[i].exchange_times) > 0 then
						AHSC:init(good_id, tmpType, i, index)
						listView:addChild(AHSC)
						index = index +1
					else
						table.insert(limitList, v)
					end
				end
			else
				if item_mould ~= -1 then
					if shop_display_level <= tonumber(_ED.user_info.user_grade)  then
						-- 等级足够的才显示
						local limit = dms.int(dms["arena_shop_info"], good_id, arena_shop_info.exchange_count_limit)
						local AHSC = ArenaHonorShopSeatCell:createCell()
						if limit == -1 or limit - tonumber(_ED.arena_good_reward[i].exchange_times) > 0 then
							AHSC:init(good_id, tmpType, i, index)
							listView:addChild(AHSC)
							index = index +1
						else
							table.insert(limitList, v)
						end
					end
				end
			end
		end
		
		for i,v in ipairs(limitList) do
			local tmpType = dms.int(dms["arena_shop_info"], v.good_id, arena_shop_info.shop_type)
			local AHSC = ArenaHonorShopSeatCell:createCell()
			AHSC:init(v.good_id, tmpType, i, index)
			listView:addChild(AHSC)
			index = index +1
		end
	end
	listView:requestRefreshView()
	self.currentInnerContainerReward = listView:getInnerContainer()
	self.currentInnerContainerPosYReward = listView:getInnerContainer():getPositionY()
end


function ArenaHonorShop:onUpdate(dt)
	if ArenaHonorShop.honorListView ~= nil and self.currentInnerContainerHonor ~= nil then
	
		local size = 0
		local posY = 0
		local items = {}
		
		if self.currentType == 1 then
			size = ArenaHonorShop.honorListView:getContentSize()
			posY = self.currentInnerContainerHonor:getPositionY()
			
			if self.currentInnerContainerPosYHonor == posY then
				return
			end
			self.currentInnerContainerPosYHonor = posY
			items = ArenaHonorShop.honorListView:getItems()
		else
			size = ArenaHonorShop.rewardListView:getContentSize()
			posY = self.currentInnerContainerReward:getPositionY()
			
			if self.currentInnerContainerPosYReward == posY then
				return
			end
			self.currentInnerContainerPosYReward = posY
			items = ArenaHonorShop.rewardListView:getItems()
		end

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



function ArenaHonorShop:initDraw()
	ArenaHonorShop.rewardListView:setVisible(false)
	ArenaHonorShop.honorListView:setVisible(false)
	if self.currentType == self.enum_type._TYPE_HONOR_SHOP then
		ArenaHonorShop.honorListView:setVisible(true)
	
	elseif self.currentType == self.enum_type._TYPE_REWARD_SHOP then
		ArenaHonorShop.rewardListView:setVisible(true)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
			or __lua_project_id == __lua_project_yugioh
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_warship_girl_b 
			then
			if self.isInitReward == false then
				self.isInitReward = true
				self:onUpdateDrawReward()
			end
		end
	end
end


-- function ArenaHonorShop:initDraw()

	-- --设置可用的荣誉值
	-- self.cacheHonorText:setString(_ED.user_info.user_honour)
	
	-- --初始化已购买数据
	-- -- _ED.arena_good_number = npos(list) 						
	-- -- for i=1, _ED.arena_good_number do
		-- -- local arenaGood = {
		-- -- good_id = npos(list),
		-- -- exchange_times = npos(list),
		-- -- }	
		-- -- _ED.arena_good[i] = arenaGood
	-- -- end
	
	-- --请勿删除 本地数据与服务器不同步 尚未经过技术测试 谁删剁谁手 ~-~!!
	-- -- for i, v in pairs(_ED.arena_good) do
		-- -- print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq", v.good_id, v.exchange_times)
	-- -- end

	-- ---[[ 
	-- if #self.cacheListView:getItems() > 0 then
		-- self.cacheListView:removeAllItems()
		
		-- -- for i, v in pairs(self.cacheListView:getItems()) do
			-- -- self.cacheListView:removeChild(i - 1, false)
		-- -- end
		
		-- -- return
	-- end
	
	-- --在缓存中寻找数据
	-- -- if #self.cacheCellData.rewardCells == 0 then
	
		-- local canInsert
		-- for i, v in ipairs(dms["arena_shop_info"]) do
		
			-- canInsert = false
			
			-- local tmpType = dms.int(dms["arena_shop_info"], i, arena_shop_info.shop_type)
			
			-- if tmpType + 1 == self.currentType then
				-- canInsert = true
			-- end
			
			-- if canInsert == true then
				-- local AHSC = ArenaHonorShopSeatCell:createCell()
				-- AHSC:init(i, tmpType)
				-- self.cacheListView:addChild(AHSC)
				
				-- -- if tmpType + 1 == self.enum_type._TYPE_HONOR_SHOP then
					-- -- table.insert(self.cacheCellData.honorCells, AHSC)
				-- -- elseif tmpType + 1 == self.enum_type._TYPE_REWARD_SHOP then
					-- -- table.insert(self.cacheCellData.rewardCells, AHSC)
				-- -- end
			-- end
			
		-- end
		
	-- -- else
	
		-- -- local tmpCellList
		
		-- -- if self.currentType == self.enum_type._TYPE_HONOR_SHOP then
			-- -- tmpCellList = self.cacheCellData.honorCells
		-- -- else
			-- -- tmpCellList = self.cacheCellData.rewardCells
		-- -- end
	
		-- -- for i, v in pairs(tmpCellList) do
			-- -- print(v)
			-- -- self.cacheListView:addChild(v)
		-- -- end
	
	-- -- end
	
	
	-- --重置listview的size
	-- self:reviseListviewSize(self.cacheListView)
	-- --]]
	
-- end

function ArenaHonorShop:reviseListviewSize(listview)

	if #listview:getItems() <= 0 then return end
	local listviewContentSize = listview:getContentSize()
	local tmpContentSize = listview:getItem(0):getContentSize()
	tmpContentSize.height = tmpContentSize.height * #listview:getItems()
	listview:getInnerContainer():setContentSize(tmpContentSize)
	listviewContentSize.width = tmpContentSize.width
	listview:setContentSize(listviewContentSize)
end



--请求竞技场初始化数据
function ArenaHonorShop:requestInitDatas()

	---[[
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self:initDrawList()
		self:initDraw(self.enum_type._TYPE_HONOR_SHOP)
	else
		local function responseArenaHonorShopInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				
				if nil == fwin:find("ArenaHonorShopClass") then
					return
				end
				if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then 
					return
				end
				response.node:initDrawList()
				response.node:initDraw(self.enum_type._TYPE_HONOR_SHOP)
				-- protocol_command.arena_shop_init.param_list = "1\r\n0"
				-- NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, nil, nil, false, nil)
			end
		end
		
		protocol_command.arena_shop_init.param_list = "0\r\n0"
		NetworkManager:register(protocol_command.arena_shop_init.code, nil, nil, nil, self, responseArenaHonorShopInitCallback, false, nil)
	end
	--]]
end

--撸向服务器 我要买买买
function ArenaHonorShop:requestBuyProd(prodID, nums)
	---[[
	local hasH = zstring.tonumber(_ED.user_info.user_honour)
	local function responseArenaBuyProdCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			-- self:initDraw()
			if (__lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
		  		then 
		  		local getH = hasH - zstring.tonumber(_ED.user_info.user_honour)
		  		if getH > 0 then
		  			jttd.consumableItems(_my_gane_name[3],getH)
		  		end
		  	end
			TipDlg.drawTextDailog(_string_piece_info[76])
			if response.node ~= nil and response.node.roots ~= nil then
				response.node:afterBuyResponse()
			end
			--更新数据
			--设置可用的荣誉值
			-- self.cacheHonorText:setString(_ED.user_info.user_honour)
			
			-- -- 告知 刷新
			-- state_machine.excute("arena_update_information", 0, nil) 
			
			-- if tonumber(self.currentBuyShopType) == 0 then
			
			-- 	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then			
			-- 		for i, v in pairs(ArenaHonorShop.honorListView:getItems()) do
			-- 			if tonumber(v.child1.seatIndex) == tonumber(self.currentBuyId) then
			-- 			v.child1:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
			-- 			local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
			-- 				if limit~= -1 and limit - tonumber(_ED.arena_good[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then					
			-- 						local cell = v.child1
			-- 						cell.unload()
			-- 						cell.reload()
			-- 					return
			-- 				end
			-- 			break
			-- 			end
						
			-- 			if tonumber(v.child2.seatIndex) == tonumber(self.currentBuyId) then
			-- 			v.child2:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
			-- 			local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
			-- 				if limit~= -1 and limit - tonumber(_ED.arena_good[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then					
			-- 						local cell = v.child2
			-- 						cell.unload()
			-- 						cell.reload()
			-- 					return
			-- 				end
			-- 			break
			-- 			end
			-- 		end
			-- 	else
			
			-- 		for i, v in pairs(ArenaHonorShop.honorListView:getItems()) do
			-- 			if tonumber(v.seatIndex) == tonumber(self.currentBuyId) then
			-- 				v:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
			-- 				local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
			-- 				if limit~= -1 and limit - tonumber(_ED.arena_good[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then					
			-- 						local cell = v
			-- 						cell:retain()
			-- 						ArenaHonorShop.honorListView:removeItem(i-1)
			-- 						ArenaHonorShop.honorListView:addChild(cell)
			-- 						cell:release()
			-- 					return
			-- 				end
			-- 				break
			-- 			end
			-- 		end
			-- 	end
			-- elseif tonumber(self.currentBuyShopType) == 1 then
			-- 	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then			
			-- 		for i, v in pairs(ArenaHonorShop.rewardListView:getItems()) do
			-- 			if tonumber(v.child1.seatIndex) == tonumber(self.currentBuyId) then
			-- 				v.child1:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
			-- 				local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
			-- 				if limit - tonumber(_ED.arena_good_reward[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then
			-- 						local cell = v.child1
			-- 						cell.unload()
			-- 						cell.reload()
			-- 				end
			-- 				break
			-- 			end
			-- 			if tonumber(v.child2.seatIndex) == tonumber(self.currentBuyId) then
			-- 				v.child2:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
			-- 				local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
			-- 				if limit - tonumber(_ED.arena_good_reward[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then
			-- 						local cell = v.child2
			-- 						cell.unload()
			-- 						cell.reload()
			-- 				end
			-- 				break
			-- 			end
			-- 		end
			-- 	else
			-- 			for i, v in pairs(ArenaHonorShop.rewardListView:getItems()) do
			-- 			if tonumber(v.seatIndex) == tonumber(self.currentBuyId) then
			-- 				v:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
			-- 				local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
			-- 				if limit - tonumber(_ED.arena_good_reward[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then
			-- 						local cell = v
			-- 						cell:retain()
			-- 						ArenaHonorShop.rewardListView:removeItem(i-1)
			-- 						ArenaHonorShop.rewardListView:addChild(cell)
			-- 						cell:release()
			-- 				end
			-- 				break
			-- 			end
			-- 		end
			-- 	end
			-- end
		end
	end
	
	protocol_command.arena_shop_exchange.param_list = prodID .. "\r\n" .. nums
	NetworkManager:register(protocol_command.arena_shop_exchange.code, nil, nil, nil, self, responseArenaBuyProdCallback, false, nil)
	--]]
end
function ArenaHonorShop:afterBuyResponse()
	self.cacheHonorText:setString(_ED.user_info.user_honour)
	
	-- 告知 刷新
	state_machine.excute("arena_update_information", 0, nil) 
	
	if tonumber(self.currentBuyShopType) == 0 then
	
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then			
			for i, v in pairs(ArenaHonorShop.honorListView:getItems()) do
				if tonumber(v.child1.seatIndex) == tonumber(self.currentBuyId) then
				v.child1:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
				local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
					if limit~= -1 and limit - tonumber(_ED.arena_good[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then					
							local cell = v.child1
							cell.unload()
							cell.reload()
						return
					end
				break
				end
				
				if tonumber(v.child2.seatIndex) == tonumber(self.currentBuyId) then
				v.child2:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
				local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
					if limit~= -1 and limit - tonumber(_ED.arena_good[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then					
							local cell = v.child2
							cell.unload()
							cell.reload()
						return
					end
				break
				end
			end
		else
	
			for i, v in pairs(ArenaHonorShop.honorListView:getItems()) do
				if tonumber(v.seatIndex) == tonumber(self.currentBuyId) then
					v:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
					local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
					if limit~= -1 and limit - tonumber(_ED.arena_good[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then					
							local cell = v
							cell:retain()
							ArenaHonorShop.honorListView:removeItem(i-1)
							ArenaHonorShop.honorListView:addChild(cell)
							cell:release()
						return
					end
					break
				end
			end
		end
	elseif tonumber(self.currentBuyShopType) == 1 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then			
			for i, v in pairs(ArenaHonorShop.rewardListView:getItems()) do
				if tonumber(v.child1.seatIndex) == tonumber(self.currentBuyId) then
					v.child1:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
					local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
					if limit - tonumber(_ED.arena_good_reward[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then
							local cell = v.child1
							cell.unload()
							cell.reload()
					end
					break
				end
				if tonumber(v.child2.seatIndex) == tonumber(self.currentBuyId) then
					v.child2:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
					local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
					if limit - tonumber(_ED.arena_good_reward[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then
							local cell = v.child2
							cell.unload()
							cell.reload()
					end
					break
				end
			end
		else
				for i, v in pairs(ArenaHonorShop.rewardListView:getItems()) do
				if tonumber(v.seatIndex) == tonumber(self.currentBuyId) then
					v:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
					local limit = dms.int(dms["arena_shop_info"], self.currentBuyId, arena_shop_info.exchange_count_limit)
					if limit - tonumber(_ED.arena_good_reward[self:updateDataForProdID(self.currentBuyId,self.currentBuyShopType)].exchange_times) <= 0 then
							local cell = v
							cell:retain()
							ArenaHonorShop.rewardListView:removeItem(i-1)
							ArenaHonorShop.rewardListView:addChild(cell)
							cell:release()
					end
					break
				end
			end
		end
	end	
end
function ArenaHonorShop:updateDataForProdID(prodID, _type)
	if tonumber(_type) == 0 then
		for i, v in pairs(_ED.arena_good) do
			if tonumber(v.good_id) == tonumber(prodID) then
				return i
			end
		end
	elseif tonumber(_type) == 1 then
		for i, v in pairs(_ED.arena_good_reward) do
			if tonumber(v.good_id) == tonumber(prodID) then
				return i
			end
		end
	end
	return 0
end

function ArenaHonorShop:showCacheHonorCommodity()
--荣誉
	self.cacheRewardCommodityTxt:setVisible(false)
	self.cacheHonorCommodityTxt:setVisible(true)
	self.cacheHonorCommodityBtn:setHighlighted(true)

end

function ArenaHonorShop:showCacheRewardCommodity()
--商城
	self.cacheRewardCommodityTxt:setVisible(true)
	self.cacheHonorCommodityTxt:setVisible(false)
	self.cacheRewardCommodityBtn:setHighlighted(true)

end


function ArenaHonorShop:onEnterTransitionFinish()
	
    local csbArenaRankPanel = csb.createNode("campaign/ArenaStorage/ArenaStorage_shop.csb")
	local root = csbArenaRankPanel:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaRankPanel)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
		-- local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_shop.csb") 
		-- table.insert(self.actions, action )
		-- csbArenaRankPanel:runAction(action)
		-- action:play("window_open", false)
		Animations_PlayOpenMainUI({ccui.Helper:seekWidgetByName(root, "Panel_2")}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN)
	end
	
	ArenaHonorShop.honorListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ArenaHonorShop.rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1_0")
	
	self.cacheHonorText = ccui.Helper:seekWidgetByName(root, "Text_3")
	
	--缓存商品button
	self.cacheHonorCommodityBtn = ccui.Helper:seekWidgetByName(root, "Button_jjc_sp")
	
	self.cacheHonorCommodityTxt = ccui.Helper:seekWidgetByName(root, "Image_sp_10")
	
	--缓存奖励button
	self.cacheRewardCommodityBtn = ccui.Helper:seekWidgetByName(root, "Button_jjc_jl")
	
	self.cacheRewardCommodityTxt = ccui.Helper:seekWidgetByName(root, "Image_jl_9")
	
	
	
	--添加返回点击事件
	local setPressedActionEnabled = true
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		setPressedActionEnabled =false -- 不缩放
	end
	local back_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jjc_fh"), 	nil, 
	{
		terminal_name = "arena_honor_shop_close", 	
		next_terminal_name = "arena_honor_shop_close", 	
		current_button_name = "Button_jjc_fh",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--添加荣誉商品按钮点击事件
	fwin:addTouchEventListener(self.cacheHonorCommodityBtn, 	nil, 
	{
		terminal_name = "arena_honor_commodity_btn", 	
		next_terminal_name = "arena_honor_commodity_btn", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled,
		showType = self.enum_type._TYPE_HONOR_SHOP
	}, 
	nil, 0)
	
	--添加奖励商品按钮点击事件
	fwin:addTouchEventListener(self.cacheRewardCommodityBtn, 	nil, 
	{
		terminal_name = "arena_reward_commodity_btn", 	
		next_terminal_name = "arena_reward_commodity_btn", 	
		current_button_name = "",		
		but_image = "",	
		terminal_state = 0, 
		isPressedActionEnabled = setPressedActionEnabled,
		showType = self.enum_type._TYPE_REWARD_SHOP
	}, 
	nil, 0)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_arena_reward_cell",
		_widget = self.cacheRewardCommodityBtn,
		_invoke = nil,
		_interval = 0.5,})
	
	
	self:requestInitDatas()
	
	--设置可用的荣誉值
	self.cacheHonorText:setString(_ED.user_info.user_honour)
	
	app.load("client.player.UserInformationHeroStorage")
	self.userInformationHeroStorage = UserInformationHeroStorage:new()
	fwin:open(self.userInformationHeroStorage, fwin._view)
	
	self:showCacheHonorCommodity()
end

--关闭所有按钮的高亮显示
function ArenaHonorShop:closeHighlighted()
	--缓存商品button
	self.cacheHonorCommodityBtn:setHighlighted(false)
	
	--缓存奖励button
	self.cacheRewardCommodityBtn:setHighlighted(false)
end

-- function ArenaHonorShop:init(role)-- 排名 战力值
	-- if role == -1 then self:setVisible(false) end
	-- self.roleInstance = role
-- end

-- function ArenaHonorShop:createCell()
	-- local cell = ArenaHonorShop:new()
	-- cell:registerOnNodeEvent(cell)
	-- return cell
-- end


function ArenaHonorShop:onExit()
	ArenaHonorShop.A_index = 1
	ArenaHonorShop.B_index = 1
	ArenaHonorShop.C_index = 1
	ArenaHonorShop.D_index = 1
	ArenaHonorShop.honorListView = nil
	ArenaHonorShop.rewardListView = nil

	state_machine.remove("arena_honor_shop_close")
	state_machine.remove("arena_honor_commodity_btn")
	state_machine.remove("arena_reward_commodity_btn")
	state_machine.remove("arena_seat_icon_btn_click")
	state_machine.remove("arena_honor_buy_excute")
end
