--三国无双的列表项

TrialTowerShopList = class("TrialTowerShopListClass", Window)
TrialTowerShopList.__size = nil
function TrialTowerShopList:ctor()
    self.super:ctor()
	self.roots = {}
	
	app.load("client.campaign.trialtower.TrialTowerShopPropBuyNumberTip")
	
	self.isRefushData = false -- 标记当前是否处于刷新数据的状态
    -- Initialize TrialTowerShopList page state machine.
    local function init_trial_tower_terminal()
		--使用按钮的点击
		local trial_tower_shop_prop_buy_list_buy_terminal = {
            _name = "trial_tower_shop_prop_buy_list_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params._datas._target:onBuy()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(trial_tower_shop_prop_buy_list_buy_terminal)
 
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function TrialTowerShopList:onEnterTransitionFinish()

end

function TrialTowerShopList:onInit()
	local root = cacher.createUIRef("campaign/TrialTower/trial_tower_shop_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if TrialTowerShopList.__size == nil then
	 	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_20")
		local MySize = PanelGeneralsEquipment:getContentSize()

	 	TrialTowerShopList.__size = MySize
	end



    -- local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_shop_list.csb")	
    -- self:addChild(csbCampaign)
	-- local root = csbCampaign:getChildByName("root")
	-- table.insert(self.roots, root)
	-- local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_20")
	-- local MySize = PanelGeneralsEquipment:getContentSize()
	-- self:setContentSize(MySize)
	
	-- 列表控件动画播放
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_shop_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	self:onUpdateDraw()
end


function TrialTowerShopList:getPropCell()
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	
	--if nil == self.propCellConfig then
		local cellConfig = cell:createConfig()
		
		if self.shopType == 3 then
			cellConfig.count = dms.int(dms["dignified_shop_model"], self.index, dignified_shop_model.count)
		end
		
		cellConfig.mouldId = self.mid
		cellConfig.touchShowType = 1
		cellConfig.isDebris = true
		cell:init(cellConfig)
	--	self.propCellConfig = cellConfig
	--else
	--	cell:init(self.propCellConfig )
	--end
	
	return cell
end


function TrialTowerShopList:getShipCell()
	app.load("client.cells.ship.ship_head_cell")
	local cell = ShipHeadCell:createCell()
	cell:init(nil,12,self.mid,1)
	return cell
end

function TrialTowerShopList:getEquipmentCell()

	-- app.load("client.cells.equip.equip_icon_cell")
	-- local cell = EquipIconCell:createCell()
	-- cell:init(8, nil, self.mid, nil)
	
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.mid
	cellConfig.touchShowType = 1
	cellConfig.mouldType = 7
	cell:init(cellConfig)
	return cell
end

function TrialTowerShopList:getGoldCell(goldNum)
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

function TrialTowerShopList:getSilverCell(silverNum)
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

function TrialTowerShopList:onBuy()
	if TipDlg.drawStorageTipo({2}) == false then
		-- 检查威望 够不够
		if self.prestigeprice > zstring.tonumber(_ED.user_info.all_glories) then
			TipDlg.drawTextDailog(tipStringInfo_trialTower[21])
			
			return
		end
		
		-- 检查元宝够不
		if self.gemPrice > zstring.tonumber(_ED.user_info.user_gold) then
			TipDlg.drawTextDailog(_string_piece_info[74])
			
			return
		end
		
		-- 检查额外道具够不
		if self.redDebrisNum > zstring.tonumber(getPropAllCountByMouldId(self.redDebrisMID)) then
			TipDlg.drawTextDailog(tipStringInfo_trialTower[29])
			
			return
		end

		if self.shopType == 3 then 
			local has = zstring.tonumber(_ED.user_info.all_glories)
			local function responseBuGoodsCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if (__lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
				  		then
				  		local num = has - zstring.tonumber(_ED.user_info.all_glories)
				  		if num > 0 then
				  			jttd.consumableItems(_All_tip_string_info._glories,num)
				  		end
				  	end
					TipDlg.drawTextDailog(_string_piece_info[76])
					
					setTrialtowerShopLimitCount(response.node.index, 1)
					
					state_machine.excute("trial_tower_shop_prop_buy_list_refush", 0, {
						shopType = 3,
						mid = response.node.mid,
					})
					state_machine.excute("equip_resolve_over_update", 0, nil)
				end
			end
			
			protocol_command.dignified_shop_buy.param_list = self.index .. "\r\n" .. "1"
			NetworkManager:register(protocol_command.dignified_shop_buy.code, nil, nil, nil, self, responseBuGoodsCallback, false, nil)
		else
			-- mid = nil,--物品的模板id
			-- gtype = nil,--物品类型, 见楼上
			-- price = nil,--单价x货币,诸如威望啊金币啊xxxxx
			-- money = nil,--当前用户持有的x货币的数量
			
			local count = nil
			if self.getCellType == 1 then
				count = self.silverNum
			elseif self.getCellType == 2 then
				count = self.goldNum
			elseif self.getCellType  == 6 then
			elseif self.getCellType == 7 then

			elseif self.getCellType == 13 then

			end	
			
			local config = {
				mid 	= self.mid,
				count 	= count,
				gtype 	= self.getCellType,
				quality = self.quality,
				name 	= self.iconName,
				existingDebris = self.existingDebris,
				price 	= self.prestigeprice,
				money 	= zstring.tonumber(_ED.user_info.all_glories),
				maxBuyNum = zstring.tonumber(self.limit),
				shopType = self.shopType,
				indexId = self.index,
				gemPrice = self.gemPrice,
				redDebrisNum = self.redDebrisNum,
				redDebrisMID = self.redDebrisMID,
			}

			local ntip = TrialTowerShopPropBuyNumberTip:createCell()
			ntip:init(config)
			fwin:open(ntip, fwin._windows)
		end	
	end
end


function TrialTowerShopList:onUpdateDraw()
	local root = self.roots[1]
	local shop = dms["dignified_shop_model"]
	local prop = dms["prop_mould"]
	local equipment = dms["equipment_mould"]
	local ship = dms["ship_mould"]
	--icon
	local iconIndex = ""
	
	--name
	local name = ""
	
	--品质颜色
	local quality = 0
	
	--威名数
	local prestige = dms.int(shop, self.index, dignified_shop_model.price)
	self.prestigeprice = prestige
	--已拥有碎片数
	local existingDebris = nil
	
	--需要的碎片数
	local neededDebris = nil
	
	--碎片数
	local debrisString = "(%d/%d)"
	
	--需要达成的星数
	local star = dms.int(shop, self.index, dignified_shop_model.need_star)
	
	--今日可购买数
	local limit = dms.int(shop, self.index, dignified_shop_model.purchase_count_limit)
	if limit > 0 then
		local yetCount = getTrialtowerShopLimitCount(self.index) --获取当前限定购买中 已经购买过的
		limit = math.max(limit - yetCount, 0)
	end
	self.limit =limit
	
	--类型 0道具 1 武将 2装备
	local ptype = dms.int(shop, self.index, dignified_shop_model.prop_type)

	
	--是否为元宝可购买
	local gemPrice = dms.int(shop, self.index, dignified_shop_model.need_gold)
	self.gemPrice = gemPrice
	
	--是否有需要额外道具的(红碎片)
	local redDebrisMID = dms.int(shop, self.index, dignified_shop_model.additional_prop)
	self.redDebrisMID = redDebrisMID
	
	--是否有需要额外道具的(红碎片)数量
	local redDebrisNum = dms.int(shop, self.index, dignified_shop_model.additional_prop_count)
	self.redDebrisNum = redDebrisNum

	local cell = nil
	local cellType = -1
	if ptype == 0 then
		quality 	= dms.int(prop, self.mid, prop_mould.prop_quality)+1
		name 		= dms.string(prop, self.mid, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        name = setThePropsIcon(self.mid)[2]
		end
		
		cell = self:getPropCell()
		
		-- 是否碎片
		if getIsPropDebris(self.mid) then
			--获取 需要的碎片,并去遍历已有的碎片
			neededDebris = dms.int(prop, self.mid, prop_mould.split_or_merge_count)
			
			existingDebris = getPropAllCountByMouldId(self.mid)
			
			self.existingDebris = existingDebris
		end
		
		cellType = 6

	elseif ptype == 1 then
		quality 	= dms.int(ship, self.mid, ship_mould.ship_type)+1
		name 		= dms.string(ship, self.mid, ship_mould.captain_name)
		
		if false ==  self.isRefushData then
			cell = self:getShipCell()
		end
		
		cellType = 13
		
	elseif ptype == 2 then
		quality 	= dms.int(equipment, self.mid, equipment_mould.grow_level)+1
		name 		= dms.string(equipment, self.mid, equipment_mould.equipment_name)
		
		if false ==  self.isRefushData then
			cell = self:getEquipmentCell()
		end
		
		cellType = 7
		
	elseif ptype == -1 then
		--判定 是否金币
		--是否银币
		local goldNum = dms.int(shop, self.index, dignified_shop_model.reward_gold)
		local silverNum = dms.int(shop, self.index, dignified_shop_model.reward_silver)

		if goldNum > 0 then
			if false ==  self.isRefushData then
				cell = self:getGoldCell(goldNum)
			end
			name = reward_prop_list[2]
			quality = 5
			
			cellType = 2
			
		elseif silverNum > 0 then
			if false ==  self.isRefushData then
				cell = self:getSilverCell(silverNum)
			end
			name = reward_prop_list[1]
			quality = 1
			
			cellType = 1
			
		else
			return
		end
	end
	
	self.getCellType = cellType
	self.iconName = name
	
	self.quality = quality
	
	if nil ~= cell then
		if false ==  self.isRefushData then
			if root == nil then
				return
			end
			ccui.Helper:seekWidgetByName(root, "Panel_3"):removeAllChildren(true)
			ccui.Helper:seekWidgetByName(root, "Panel_3"):addChild(cell)
		end
	end
	
	--name
	ccui.Helper:seekWidgetByName(root, "Text_20"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Text_20"):setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	
	--威名 
	if zstring.tonumber(prestige) > 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_prestige"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_prestige_number"):setString(prestige)
	else
		ccui.Helper:seekWidgetByName(root, "Text_prestige_number"):setString("")
		ccui.Helper:seekWidgetByName(root, "Panel_prestige"):setVisible(false)
	end
	
	--元宝
	if zstring.tonumber(gemPrice) > 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_diamond"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_diamond_number"):setString(gemPrice)
	else
		ccui.Helper:seekWidgetByName(root, "Text_diamond_number"):setString("")
		ccui.Helper:seekWidgetByName(root, "Panel_diamond"):setVisible(false)
	end
	
	--额外道具和数量
	if zstring.tonumber(redDebrisMID) > 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_property"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_property_number"):setString(redDebrisNum)
	else
		ccui.Helper:seekWidgetByName(root, "Text_property_number"):setString("")
		ccui.Helper:seekWidgetByName(root, "Panel_property"):setVisible(false)
	end
	
	--碎片数
	if nil ~= existingDebris and nil ~= neededDebris then
		debrisString = string.format(debrisString, existingDebris, neededDebris)
		ccui.Helper:seekWidgetByName(root, "Text_debris_number"):setString(debrisString)
	else
		ccui.Helper:seekWidgetByName(root, "Text_debris_number"):setString("")
	end
	
	local isShowBuy = false
	--优先判定星级是否够
	--再判定限定个数是否够
	local starValue = nil
	if tonumber(_ED.three_kingdoms_view.history_max_stars) >= star then
		if limit == -1 then
			isShowBuy = true
		elseif limit > 0 then
			isShowBuy = true
				
			if self.shopType == 3 then
				starValue = _string_piece_info[160]..limit.._string_piece_info[173]
			else
				starValue = string.format(tipStringInfo_trialTower[5], limit)
			end
			
		else
			isShowBuy = false
			starValue = string.format(tipStringInfo_trialTower[28])
		end
	else
		starValue = string.format(tipStringInfo_trialTower[6], star)
	end
	
	if nil ~= starValue then
		ccui.Helper:seekWidgetByName(root, "Text_purchase_star"):setString(starValue)
	else
		ccui.Helper:seekWidgetByName(root, "Text_purchase_star"):setString("")
	end

	local buyBtn = ccui.Helper:seekWidgetByName(root, "Button_6")
	
		
	--购买按钮
	if true == isShowBuy then
		
		if false ==  self.isRefushData then
		
			fwin:addTouchEventListener(buyBtn, nil, 
			{
				terminal_name = "trial_tower_shop_prop_buy_list_buy", 
				terminal_state = 0, 
				_instance = self,
				_target = self,
				isPressedActionEnabled = true
			}, 
			nil, 0)	
		
		end
		
		buyBtn:setBright(true)
		buyBtn:setTouchEnabled(true)
	else
		buyBtn:setBright(false)
		buyBtn:setTouchEnabled(false)
	end
end

function TrialTowerShopList:refushData()
	local root = self.roots[1]
	if root == nil then
		return
	end
	-- 主要是更新 已拥有碎片
	-- 今日可购买次数
	--self.isRefushData = true
	self:onUpdateDraw()
end


function TrialTowerShopList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TrialTowerShopList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("campaign/TrialTower/trial_tower_shop_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function TrialTowerShopList:onExit()	
	--state_machine.remove("trial_tower_shop_prop_buy_list_buy")
	-- state_machine.remove("trial_tower_init_treasure")
	
	cacher.freeRef("campaign/TrialTower/trial_tower_shop_list.csb", self.roots[1])
end


-- local data = {
-- mid = dms.int(shop, i, dignified_shop_model.prop_id),
-- ptype = dms.int(shop, i, dignified_shop_model.prop_type),
-- count = dms.int(shop, i, dignified_shop_model.count),	
-- price = dms.int(shop, i, dignified_shop_model.price),
-- star = dms.int(shop, i, dignified_shop_model.need_star),
-- limit = dms.int(shop, i, dignified_shop_model.purchase_count_limit),
-- }

function TrialTowerShopList:init(mid, index, shopType,drawIndex)
	self.mid = mid
	self.index = index
	self.shopType = shopType
	
	if drawIndex ~= nil and drawIndex < 7 then
		self:onInit()
	end
	self:setContentSize(TrialTowerShopList.__size)
	return self
end


function TrialTowerShopList:createCell()
	local cell = TrialTowerShopList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

