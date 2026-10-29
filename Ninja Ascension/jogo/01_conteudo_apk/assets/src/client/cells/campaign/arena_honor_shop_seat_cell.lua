-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场荣誉商店列表seat
-- 创建时间：2015-03-30
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaHonorShopSeatCell = class("ArenaHonorShopSeatCellClass", Window)
ArenaHonorShopSeatCell.__size = nil
function ArenaHonorShopSeatCell:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_icon_cell")
	
	self.seatIndex = 0		--index
	self.shopType = -1		--商店类型
	self.shopPosition = 0  	--商品所在数据的位置
	
	self.t_ID = -1			--模板id
	self.t_type = -1		--商品的类型(0:道具 1:英雄 2:装备)
	
	--icon
	self.cacheIconPanel = nil
	
	--holdNums text
	self.cacheHoldText = nil
	
	--price text
	self.cacheForceText = nil
	
	--name text
	self.cacheNameText = nil
	
	--购买按钮
	self.cacheBuyBtn = nil
	
	--购买剩余次数
	self.cacheLimitText = nil
	
	self.currentMinLimit = -1		--当前可购买次数
	
   -- Initialize ArenaHonorShopSeatCell page state machine.
    local function init_arena_honor_shop_terminal()
	
		local arena_honor_buy_excute_checkup_terminal = {
            _name = "arena_honor_buy_excute_checkup",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if nil ~= params._datas.seat then
					params._datas.seat:onBuy(params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_honor_buy_excute_checkup_terminal)
        state_machine.init()
    end
    
   -- call func init hom state machine.
    init_arena_honor_shop_terminal()
end


function ArenaHonorShopSeatCell:onBuy(params)
	
	if TipDlg.drawStorageTipo() == false then
		-- 检查价钱 够不够
		if self.prestigeprice > zstring.tonumber(_ED.user_info.user_honour) then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				--TipDlg.drawTextDailog(_string_piece_info[353])
				state_machine.excute("shortcut_function_silver_to_get_open",0,3)
			elseif __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				TipDlg.drawTextDailog(tipStringInfo_betrayArmy_info[5])
			else
				TipDlg.drawTextDailog(tipStringInfo_betrayArmy_info[2])
			end
			return
		end
		-- 检查额外道具够不
		if self.redDebrisNum > zstring.tonumber(getPropAllCountByMouldId(self.redDebrisMID)) then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
				TipDlg.drawTextDailog(tipStringInfo_betrayArmy_info[5])
			else
				TipDlg.drawTextDailog(tipStringInfo_betrayArmy_info[4])
			end
			return
		end
		local config = nil
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_yugioh 
			then
			config = {
				mid 	= self.mid,
				count 	= self.count,
				gtype 	= self.getCellType,
				quality = self.quality,
				name 	= self.iconName,
				existingDebris = self.existingDebris,
				price 	= self.prestigeprice,
				money 	= zstring.tonumber(_ED.user_info.user_honour),
				maxBuyNum = zstring.tonumber(self.currentMinLimit),
				indexId = self.index,
				redDebrisNum = self.redDebrisNum,
				redDebrisMID = self.redDebrisMID,
				_target = self, --用于刷新该条数据
				originType = 1
			}
		else
			config = {
				mid 	= self.mid,
				count 	= self.count,
				gtype 	= self.getCellType,
				quality = self.quality,
				name 	= self.iconName,
				existingDebris = self.existingDebris,
				price 	= self.prestigeprice,
				money 	= zstring.tonumber(_ED.user_info.user_honour),
				maxBuyNum = zstring.tonumber(self.limit),
				indexId = self.index,
				redDebrisNum = self.redDebrisNum,
				redDebrisMID = self.redDebrisMID,
				_target = self, --用于刷新该条数据
				originType = 1
			}
		end
		params._datas.config = config
		state_machine.excute("arena_honor_buy_excute", 0, params) 
	end
end

function ArenaHonorShopSeatCell:getPropCell(tID,count)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = tID
	cellConfig.count = count
	
	cellConfig.touchShowType = 1
	cellConfig.isDebris = true
	cell:init(cellConfig)
	return cell
end


function ArenaHonorShopSeatCell:getShipCell(tID,count)
	app.load("client.cells.ship.ship_head_cell")
	local cell = ShipHeadCell:createCell()
	cell:init(nil,12,tID,count)
	return cell
end

function ArenaHonorShopSeatCell:getEquipmentCell(tID,count)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = tID
	cellConfig.count = count
	
	
	cellConfig.touchShowType = 1
	cellConfig.mouldType = 7
	cell:init(cellConfig)
	return cell
end
function ArenaHonorShopSeatCell:getGoldCell(goldNum)
	-- app.load("client.cells.prop.prop_money_icon")
	-- local cell = propMoneyIcon:createCell()
	
	-- if nil == self.goldNum then
		-- cell:init("2",goldNum)
		-- self.goldNum = goldNum
	-- else
		-- cell:init("2",self.goldNum )
	-- end
	
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.mid
	cellConfig.touchShowType = 1
	cellConfig.mouldType = 2
	cellConfig.count = goldNum
	cell:init(cellConfig)
	
	if nil == self.goldNum then
		self.goldNum = goldNum
	end
	
	return cell
end
function ArenaHonorShopSeatCell:getSilverCell(silverNum)
	-- app.load("client.cells.prop.prop_money_icon")
	-- local cell = propMoneyIcon:createCell()
	
	-- if nil == self.silverNum then
		-- cell:init("1",silverNum)
		-- self.silverNum = silverNum
	-- else
		-- cell:init("1",self.silverNum )
	-- end
	
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.mid
	cellConfig.touchShowType = 1
	cellConfig.mouldType = 1
	cellConfig.count = silverNum
	cell:init(cellConfig)
	
	if nil == self.silverNum then
		self.silverNum = silverNum
	end
	
	return cell
end
function ArenaHonorShopSeatCell:initDraw()

	local root = self.roots[1]
	-- local prodData = self.gloriesInstance
	
	-- local reawrdID = tonumber(rewardPropInfo[2])
	-- local rewardNum = tonumber(rewardPropInfo[1])
	local tID = self.t_ID
	local pType = self.t_type
	local count = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.sell_count)
	local cellType = 6
	--清空icon panel原有的元素
	for i, v in pairs(self.cacheIconPanel:getChildren()) do
		self.cacheIconPanel:removeChild(v)
	end
	
	local icon = nil
	local quality = 0
	local name = ""
	if tonumber(pType) == 1 then
		----可能是战船模板
		icon = self:getShipCell(tID,count)
		cellType = 13
	elseif tonumber(pType) == 2 then
		icon = self:getEquipmentCell(tID,count)
		cellType = 7
	elseif tonumber(pType) == -1 then
		--判定 是否金币
		--是否银币
		local goldNum = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.reward_gold)
		local silverNum = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.reward_silver)

		if goldNum > 0 then
			
			icon = self:getGoldCell(goldNum)
			
			name = reward_prop_list[2]
			quality = 5
			
			cellType = 2
			
		elseif silverNum > 0 then
			
			icon = self:getSilverCell(silverNum)
			
			name = reward_prop_list[1]
			quality = 1
			
			cellType = 1
		end
	else
		----可能是道具模板
		icon = self:getPropCell(tID,count)
		cellType = 6
	end
	self.cacheIconPanel:addChild(icon)

	--名字显示
	-- local quality = 0
	-- local name = ""
	if tonumber(pType) == 2 then
		quality = tonumber(dms.string(dms["equipment_mould"], tID, equipment_mould.grow_level))+1
		name = dms.string(dms["equipment_mould"], tID, equipment_mould.equipment_name)
		self.cacheNameText:setString(name)
	elseif tonumber(pType) == 1 then
		quality = tonumber(dms.string(dms["ship_mould"], tID, ship_mould.ship_type))+1
		name = dms.string(dms["ship_mould"], tID, ship_mould.captain_name)
		self.cacheNameText:setString(name)
	elseif tonumber(pType) == -1 then
		self.cacheNameText:setString(name)
	else
		quality = tonumber(dms.string(dms["prop_mould"], tID, prop_mould.prop_quality))+1
		name = dms.string(dms["prop_mould"], tID, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            name = setThePropsIcon(tID)[2]
        end
		self.cacheNameText:setString(name)
	end
	self.cacheNameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	
	--价格显示
	local price = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.need_honor)
	self.cacheForceText:setString(price)
	self.price = price
	self.prestigeprice = price

	--是否有需要额外道具的(红碎片)
	local redDebrisMID = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.need_prop)
	local need_prop = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.need_prop)
	local need_prop_count = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.need_prop_count)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		if tonumber(need_prop) > 0 and self.Text_22_22 ~= nil then
			self.Text_22_22:setString(""..need_prop_count)
			if  redDebrisMID == 2 then 
				--突破石
				self.Image_5_5:setBackGroundImage("images/ui/icon/icon_tuposhi.png")
			else
				--16红色精华
				self.Image_5_5:setBackGroundImage("images/ui/icon/hongjiang.png")
			end
			self.Image_5_5:setVisible(true)
		end
	end
	
	--获取已购买的次数
	local purchaseTimes = 0
	if self.shopType == 0 then
		for i, v in pairs(_ED.arena_good) do
			if tonumber(v.good_id) == tonumber(self.seatIndex) then
				purchaseTimes = tonumber(v.exchange_times)
			end
		end
	elseif self.shopType == 1 then
		for j,w in pairs(_ED.arena_good_reward) do
			if tonumber(w.good_id) == tonumber(self.seatIndex) then
				--> print("self.seatIndexself.seatIndexself.seatIndex=="..self.seatIndex)
				purchaseTimes = tonumber(w.exchange_times)
			end
		end
	end
	
	local limit = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.exchange_count_limit)
	
	local minLimit = limit - purchaseTimes
	if minLimit < 0 then minLimit = 0 end
	self.currentMinLimit = minLimit
	
	--重置模式 1每日重置购买次数 0不重置
	local resetMode = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.is_daily_refresh_limit)
	
	if self.shopType == 0 then
		if resetMode == 1 then
		
			self.cacheLimitText:setString(_string_piece_info[69] .. minLimit .. _string_piece_info[70])
			
		else
			if limit == -1 then
				self.cacheLimitText:setString("")
			else
				if minLimit == 0 then
					self.cacheLimitText:setString(_string_piece_info[157])
				else
					self.cacheLimitText:setString(_string_piece_info[69] .. minLimit .. _string_piece_info[70])
				end
			end
		end
		if limit == -1 then
			self.cacheBuyBtn:setBright(true)
			self.cacheBuyBtn:setTouchEnabled(true)
		else
			if minLimit == 0 then
				self.cacheBuyBtn:setBright(false)
				self.cacheBuyBtn:setTouchEnabled(false)
			else
				self.cacheBuyBtn:setBright(true)
				self.cacheBuyBtn:setTouchEnabled(true)
			end
		end
	else
		--重置模式 1每日重置购买次数 0不重置
		local finalStr = string.format(_string_piece_info[372], 1)
		
		if resetMode == 1 then
			finalStr = _string_piece_info[69] .. minLimit .. _string_piece_info[70]
			local needRank = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.ranking)
			if needRank ~= -1 then
				finalStr = finalStr .. "," .. _string_piece_info[158] .. needRank .. _string_piece_info[159]
			end
		else
			if minLimit == 0 then
				finalStr = _string_piece_info[157]
			else
				--finalStr = _string_piece_info[160] .. minLimit .. _string_piece_info[70]
				local needRank = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.ranking)
				if needRank ~= -1 then
					finalStr = _string_piece_info[158] .. needRank .. _string_piece_info[159]
				end
			end
		end
		
		self.cacheLimitText:setString(finalStr)
		if minLimit == 0 or (dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.ranking) >0 and dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.ranking) < tonumber(_ED.max_arena_user_rank)) then
			self.cacheBuyBtn:setBright(false)
			self.cacheBuyBtn:setTouchEnabled(false)
		else
			self.cacheBuyBtn:setBright(true)
			self.cacheBuyBtn:setTouchEnabled(true)
		end
	end
	
	
	self.redDebrisMID = redDebrisMID
	--是否有需要额外道具的(红碎片)数量
	local redDebrisNum = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.need_prop_count)
	self.redDebrisNum = redDebrisNum
	
	--额外道具和数量
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
	else
		if zstring.tonumber(redDebrisMID) > 0 then
			ccui.Helper:seekWidgetByName(root, "Panel_hongjiang"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_hongjiang_nb"):setString(redDebrisNum)
		else
			ccui.Helper:seekWidgetByName(root, "Panel_hongjiang"):setVisible(false)
		end
	end
	
	
	
	--碎片数
	local debrisString = "(%d/%d)"
	--已拥有碎片数
	local existingDebris = nil
	--需要的碎片数
	local neededDebris = nil
	-- 是否碎片
	if getIsPropDebris(tID) then
		--获取 需要的碎片,并去遍历已有的碎片
		neededDebris = dms.int(dms["prop_mould"], tID, prop_mould.split_or_merge_count)
		
		existingDebris = getPropAllCountByMouldId(tID)
	end
	--碎片数
	if nil ~= existingDebris and nil ~= neededDebris then
		debrisString = string.format(debrisString, existingDebris, neededDebris)
		self.cacheHoldText:setString(debrisString)
	end

	self.mid = self.t_ID
	self.count = count
	self.getCellType = cellType
	self.quality = quality
	self.iconName = name
	self.existingDebris = existingDebris
	maxBuyNum = zstring.tonumber(limit)
	self.index = self.seatIndex
end

--更新数据 并且扣除数量
function ArenaHonorShopSeatCell:updateDataForProdID(prodID, nums)
	if self.shopType == 0 then
		for i, v in pairs(_ED.arena_good) do
			if tonumber(v.good_id) == tonumber(prodID) then
				self:initDraw()
				break
			end
		end
	elseif self.shopType == 1 then
		for i, v in pairs(_ED.arena_good_reward) do
			if tonumber(v.good_id) == tonumber(prodID) then
				self:initDraw()
				break
			end
		end
	end
end


--通过模板ID 获得已经购买的次数
function ArenaHonorShopSeatCell:getPurchaseTimesFroTID(aTID)
	local returnValue = 0
	for i, v in pairs(_ED.arena_good) do
		if tonumber(v.good_id) == aTID then
			returnValue = v.exchange_times
			break
		end
	end
	return tonumber(returnValue)
end


function ArenaHonorShopSeatCell:onEnterTransitionFinish()

end

function ArenaHonorShopSeatCell:onInit()
	local root = cacher.createUIRef("campaign/ArenaStorage/ArenaStorage_shop_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if ArenaHonorShopSeatCell.__size == nil then
	 	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_20")
		local MySize = PanelGeneralsEquipment:getContentSize()

	 	ArenaHonorShopSeatCell.__size = MySize
	end
	
	
	-- 列表控件动画播放
	local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_shop_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)

	-- local panel = ccui.Helper:seekWidgetByName(root, "Panel_20")
	-- self:setContentSize(panel:getContentSize())
	
	-- icon
	self.cacheIconPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	-- self.cacheIconPanel:setSwallowTouches(false)
	
	-- holdNums text
	self.cacheHoldText = ccui.Helper:seekWidgetByName(root, "Text_21")
	self.cacheHoldText:setString("")
	-- price text
	self.cacheForceText = ccui.Helper:seekWidgetByName(root, "Text_22")
	self.cacheForceText:setString("")
	-- limit text
	self.cacheLimitText = ccui.Helper:seekWidgetByName(root, "Text_22_0")
	self.cacheLimitText:setString("")
	-- name text
	self.cacheNameText = ccui.Helper:seekWidgetByName(root, "Text_20")
	self.cacheNameText:setString("")
	-- 购买按钮
	self.cacheBuyBtn = ccui.Helper:seekWidgetByName(root, "Button_6")

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		self.Text_22_22 = ccui.Helper:seekWidgetByName(root, "Text_22_22")
		self.Text_22_22:setString("")

		self.Image_5_5 = ccui.Helper:seekWidgetByName(root, "Image_5_5")
		self.Image_5_5:setVisible(false)
	end
	
	local price = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.need_honor)
	self.price = price
	
	--购买按钮点击事件
	local buy_button = fwin:addTouchEventListener(self.cacheBuyBtn, nil, 
	{
		terminal_name = "arena_honor_buy_excute_checkup", --"arena_honor_buy_excute", 	
		next_terminal_name = "arena_honor_buy_excute_checkup", --"arena_honor_buy_excute", 	
		current_button_name = "Button_6",		
		but_image = "honor_shop_buy",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		prodID = self.seatIndex,
		nums = 1,
		shopType = self.shopType,
		price = self.price,
		seat = self
	}, 
	nil, 0)
	
	--添加ICON 点击事件
	--self:createClickEventForIcon(self.cacheIconPanel)
	
	self:initDraw()
end

--添加ICON 点击事件
function ArenaHonorShopSeatCell:createClickEventForIcon(icon)
	fwin:addTouchEventListener(icon, nil, 
	{
		terminal_name = "arena_seat_icon_btn_click", 	
		next_terminal_name = "arena_seat_icon_btn_click", 	
		current_button_name = "Panel_3",		
		but_image = "icon_click",	
		terminal_state = 0, 
		isPressedActionEnabled = false,
		tID = self.t_ID,
		tType = self.t_type
	}, 
	nil, 0)
end


function ArenaHonorShopSeatCell:reload()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self == nil then --说明已经被移除
			return
		end
	end
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaHonorShopSeatCell:unload()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self == nil then --说明已经被移除
			return
		end
	end
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_shop_list.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaHonorShopSeatCell:init(value, shopType ,position, index)
	self.seatIndex = value
	self.shopType = shopType
	self.t_ID = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.item_mould)
	self.t_type = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.item_type)
	self.shopPosition = position
	--次数要传进去
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.limit = dms.int(dms["arena_shop_info"], self.seatIndex, arena_shop_info.exchange_count_limit)
	end
	if index ~= nil and index < 7 then
		self:onInit()
	end
	self:setContentSize(ArenaHonorShopSeatCell.__size)
	return self
end

function ArenaHonorShopSeatCell:createCell()
	local cell = ArenaHonorShopSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function ArenaHonorShopSeatCell:onExit()
	--state_machine.remove("arena_honor_buy_excute_checkup")
	
	cacher.freeRef("campaign/ArenaStorage/ArenaStorage_shop_list.csb", self.roots[1])
end
