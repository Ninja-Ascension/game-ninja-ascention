-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双的商城道具购买二级选择数量界面
-- 创建时间
-- 作者：李彪
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TrialTowerShopPropBuyNumberTip = class("TrialTowerShopPropBuyNumberTipClass", Window)

function TrialTowerShopPropBuyNumberTip:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.prop = nil
	self.type = nil
	self.Tparams = nil
	self.buySum = 1 --要购买的总数
	self.shop_type = nil
	-- Initialize shop page state machine.
    local function init_shop_prop_buy_number_tip_terminal()
	
		local trial_tower_shop_prop_buy_sure_terminal = {
            _name = "trial_tower_shop_prop_buy_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:buyGodds()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local shop_equip_buy_sure_terminal = {
            _name = "trial_tower_shop_equip_buy_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:buyGodds()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local shop_prop_buy_close_terminal = {
            _name = "trial_tower_shop_prop_buy_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local shop_prop_buy_number_change_terminal = {
            _name = "trial_tower_shop_prop_buy_number_change",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
			
				instance:checkupPrice(params._datas._number)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(trial_tower_shop_prop_buy_sure_terminal)
		state_machine.add(shop_equip_buy_sure_terminal)
		state_machine.add(shop_prop_buy_close_terminal)
		state_machine.add(shop_prop_buy_number_change_terminal)
        state_machine.init()
    end
    
    -- call func init shop state machine.
    init_shop_prop_buy_number_tip_terminal()
end

function TrialTowerShopPropBuyNumberTip:drawPrice(_prop)
	
	return price
end	

function TrialTowerShopPropBuyNumberTip:drawDiscount(_prop)
	
	return price
end	

function TrialTowerShopPropBuyNumberTip:onUpdateDraw()
	-- local root = self.roots[1]
	
	-- local textNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
	-- local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	-- local userHave = ccui.Helper:seekWidgetByName(root, "Text_buy_3")
	-- local price = ccui.Helper:seekWidgetByName(root, "Text_buy_7")
	-- local residueTimes = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	-- local tipText = ccui.Helper:seekWidgetByName(root, "Text_buy_5")
	-- local quality = nil
	
	-- prop_purchase_state 道具购买状态
	-- equipment_purchase_state 装备购买状态
	-- three_kingdoms_buy_reset_count  三国无双元宝重置次数
end


function TrialTowerShopPropBuyNumberTip:onExit()
	state_machine.remove("trial_tower_shop_prop_buy_sure")
	state_machine.remove("trial_tower_shop_equip_buy_sure")
	state_machine.remove("trial_tower_shop_prop_buy_close")
	state_machine.remove("trial_tower_shop_prop_buy_number_change")
end



function TrialTowerShopPropBuyNumberTip:getPropCell(mouldType,count)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.config.mid
	cellConfig.touchShowType = 1
	cellConfig.mouldType = mouldType
	cellConfig.count = count 
	cellConfig.isDebris = true
	cellConfig.isBigImg = true
	cell:init(cellConfig)

	return cell
end


function TrialTowerShopPropBuyNumberTip:getShipCell()
	app.load("client.cells.ship.ship_head_cell")
	local cell = ShipHeadCell:createCell()
	cell:init(nil,12,self.config.mid,1)
	return cell
end

function TrialTowerShopPropBuyNumberTip:getEquipmentCell()
	-- app.load("client.cells.equip.equip_icon_cell")
	-- local cell = EquipIconCell:createCell()
	-- cell:init(8, nil, self.config.mid, nil)
	return self:getPropCell(7)
end

function TrialTowerShopPropBuyNumberTip:getGoldCell(goldNum)
	-- app.load("client.cells.prop.prop_money_icon")
	-- local cell = propMoneyIcon:createCell()
	-- cell:init("2",goldNum)
	
	return self:getPropCell(2,goldNum)
end

function TrialTowerShopPropBuyNumberTip:getSilverCell(silverNum)
	-- app.load("client.cells.prop.prop_money_icon")
	-- local cell = propMoneyIcon:createCell()
	-- cell:init("1",silverNum)
	
	return self:getPropCell(1,silverNum)
end


function TrialTowerShopPropBuyNumberTip:getIconCell()

	local cell = nil
	if self.config.gtype == 1 then
		cell = self:getSilverCell(self.config.count)
		self:setBuyToProp()
	elseif self.config.gtype == 2 then
		cell = self:getGoldCell(self.config.count)
		self:setBuyToProp()
	elseif self.config.gtype  == 6 then
		cell = self:getPropCell()
		self:setBuyToProp()
	elseif self.config.gtype == 7 then
		cell = self:getEquipmentCell()
		self:setBuyToEquip()
	elseif self.config.gtype == 13 then
		cell = self:getShipCell()
		--貌似不会直接卖武将也没接口吧
	end	
	
	return cell
end


function TrialTowerShopPropBuyNumberTip:setBuyToProp()
		fwin:addTouchEventListener(self.sureBuy, nil, 
		{
			terminal_name = "trial_tower_shop_prop_buy_sure", 
			terminal_state = 0, 
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)

end



function TrialTowerShopPropBuyNumberTip:setBuyToEquip()
	fwin:addTouchEventListener(self.sureBuy, nil, 
		{
			terminal_name = "trial_tower_shop_equip_buy_sure", 
			terminal_state = 0, 
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)

end


function TrialTowerShopPropBuyNumberTip:checkupPrice(n)
	if self.config.price > 0 and self.config.redDebrisNum > 0 then
		self:calculateRedDebris(n)
	elseif self.config.gemPrice > 0 then
		self:calculateGemPrice(n)
	elseif self.config.price > 0 then
		self:calculatePrice(n)
	end
end

-- 普通价格 荣誉
function TrialTowerShopPropBuyNumberTip:calculatePrice(num)
	local n = self.buySum + num
	n = math.max(n,1)
	if n * self.config.price > self.config.money then
		-- 买的太多,不够付账的
		n = math.floor(self.config.money / self.config.price) 
	end
	n = math.max(n,1)
	
	if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
		n = math.min(n,tonumber(self.config.maxBuyNum))
	end
	self.buySum = n

	self:updateMoney()
end

-- 元宝价格
function TrialTowerShopPropBuyNumberTip:calculateGemPrice(num)
	local n = self.buySum + num
	n = math.max(n,1)
	if n * self.config.gemPrice > zstring.tonumber(_ED.user_info.user_gold) then
		-- 买的太多,不够付账的
		n = math.floor(zstring.tonumber(_ED.user_info.user_gold) / self.config.gemPrice) 
	end
	n = math.max(n,1)
	
	if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
		n = math.min(n,tonumber(self.config.maxBuyNum))
	end
	self.buySum = n

	self:updateMoney()
end

-- 威望+道具价格
function TrialTowerShopPropBuyNumberTip:calculateRedDebris(num)
	local n = self.buySum + num
	n = math.max(n,1)
	if n * self.config.price > self.config.money then
		-- 买的太多,不够付账的
		n = math.floor(self.config.money / self.config.price) 
	end
	n = math.max(n,1)
	

	-- 计算 可用数
	local myRedDebrisNum = zstring.tonumber(getPropAllCountByMouldId(self.config.redDebrisMID))
	if n*self.config.redDebrisNum > myRedDebrisNum then
		-- 买的太多,不够付账的
		n = math.floor(myRedDebrisNum / self.config.redDebrisNum) 
	end
	
	n = math.max(n,1)

	if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
		n = math.min(n,tonumber(self.config.maxBuyNum))
	end
	
	self.buySum = n

	self:updateMoney()
end

function TrialTowerShopPropBuyNumberTip:updateMoney()
	local root = self.roots[1]
	
	-- 买多少个
	self.text_buy_num:setString(self.buySum)
	-- 多少钱

	--检测威望值
	if self.config.price > 0 then
		-- 检查当前是否有可购买数
		if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
			ccui.Helper:seekWidgetByName(root, "Image_ry"):setVisible(true)
			self.text_buy_price:setString(self.buySum*self.config.price)
		else
			ccui.Helper:seekWidgetByName(root, "Panel_8"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_8_0"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_buy_7_10"):setString(self.buySum*self.config.price)
		end
	end
	
	--检查宝石
	if self.config.gemPrice > 0 then
		ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(true)
		self.text_buy_price:setString(self.buySum*self.config.gemPrice)
	end
	
	--检查红碎片
	if self.config.redDebrisNum > 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_1987"):setVisible(true)
		
		ccui.Helper:seekWidgetByName(root, "Text_buy_7_10_0"):setString(self.buySum*self.config.redDebrisNum)
	end
end


-- 买装备
function TrialTowerShopPropBuyNumberTip:buyGodds()

-- dignified_shop_buy
-- 用户ID
-- 商品ID
-- 商品数量
	local has = zstring.tonumber(_ED.user_info.all_glories)
	local function responseBuGoodsCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if (__lua_project_id == __lua_project_warship_girl_a 
				or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
		  		then
		  		local num = has - zstring.tonumber(_ED.user_info.all_glories)
		  		if num > 0 then
		  			jttd.consumableItems(_All_tip_string_info._glories,num)
		  		end
		  	end
			TipDlg.drawTextDailog(_string_piece_info[76])
			-- response.node._datas._current_buy_count = tonumber(self.buy_number)
			--通知刷新 荣誉值减少, 物品购买限定次数变更
			
			setTrialtowerShopLimitCount(response.node.config.indexId,response.node.buySum)
			
			state_machine.excute("trial_tower_shop_prop_buy_list_refush", 0, {
				shopType = response.node.config.shopType,
				mid = response.node.config.mid,
			})
			state_machine.excute("equip_resolve_over_update", 0, nil)
			fwin:close(response.node)
		end
	end
	--if self.buySum * self.config.price <= self.config.money then
	
		--用模板id 找实例id  dignified_shop_model
	
		protocol_command.dignified_shop_buy.param_list = self.config.indexId .. "\r\n" .. self.buySum
		NetworkManager:register(protocol_command.dignified_shop_buy.code, nil, nil, nil, self, responseBuGoodsCallback, false, nil)
	--else
		--TipDlg.drawTextDailog(tipStringInfo_trialTower[21])
	--end
end

function TrialTowerShopPropBuyNumberTip:onEnterTransitionFinish()
	self.buySum = 1

	local csbTrialTowerShopPropBuyNumberTip = csb.createNode("shop/buy_props.csb")
	local root = csbTrialTowerShopPropBuyNumberTip:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("shop/buy_props.csb")
    csbTrialTowerShopPropBuyNumberTip:runAction(action)
	action:play("window_open", false)
    self:addChild(csbTrialTowerShopPropBuyNumberTip)
	
	local sureBuy = ccui.Helper:seekWidgetByName(root, "Button_gmdj_2")
	self.sureBuy = sureBuy
	
	local closeButton = ccui.Helper:seekWidgetByName(root, "Button_gmdj_1")
	local closeButton2 = ccui.Helper:seekWidgetByName(root, "Button_1")
	
	local cutButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jian_1")
	local cutButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jian_2")
	
	local addButtonTen = ccui.Helper:seekWidgetByName(root, "Button_buy_jia_2")
	local addButtonOne = ccui.Helper:seekWidgetByName(root, "Button_jia_1")
	
	--放置icon
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_dj_tx")
	headPanel:addChild(self:getIconCell())
	
	--名字
	local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	name:setString(self.config.name)
	name:setColor(cc.c3b(color_Type[self.config.quality][1],color_Type[self.config.quality][2],color_Type[self.config.quality][3]))
	
	--已有个数
	local userHave = ccui.Helper:seekWidgetByName(root, "Text_buy_3")	
	userHave:setString(getPropAllCountByMouldId(self.config.mid))
	
	--显示要购买数
	local textNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_12")
	self.text_buy_num = textNumber
	
	--显示价钱
	local price = ccui.Helper:seekWidgetByName(root, "Text_buy_7")
	self.text_buy_price = price
	
	--没有购买上限显示 Panel_8_0 Text_buy_7_10

	--显示价格类型图标
	--钻石货币的价格图标 Image_6
	ccui.Helper:seekWidgetByName(root, "Image_6"):setVisible(false)
	--其他货币的价格图标 Image_zg
	ccui.Helper:seekWidgetByName(root, "Image_zg"):setVisible(false)
	--荣誉的价格图标 Image_ry  Text_buy_7
	ccui.Helper:seekWidgetByName(root, "Image_ry"):setVisible(false)

	--今日还可购买数 Text_buy_4
	local surplusNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	self.surplusNumber = surplusNumber

	local tipText = ccui.Helper:seekWidgetByName(root, "Text_buy_5")
	
	
	
	
	if dms.int(dms["dignified_shop_model"], self.config.indexId, dignified_shop_model.purchase_count_limit) == -1 then
		--surplusNumber:setString(_string_piece_info[75])
	else
		if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
			surplusNumber:setString(string.format(tipStringInfo_trialTower[20] ,tonumber(self.config.maxBuyNum)))
			--ccui.Helper:seekWidgetByName(root, "Text_buy_5"):setString(_string_piece_info[77])
		end
		
		if dms.int(dms["dignified_shop_model"], self.config.indexId, dignified_shop_model.is_reset) == 0 then
			-- 不可重置的
			
		else
			-- 可重置的
				
			tipText:setString(_string_piece_info[77])
		end
		
	end
	
	
	
	--购买重置时间 Text_buy_5
	-- local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	-- 
	-- local price = ccui.Helper:seekWidgetByName(root, "Text_buy_7")
	-- local residueTimes = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	

	fwin:addTouchEventListener(closeButton, nil, {func_string = [[state_machine.excute("trial_tower_shop_prop_buy_close", 0, "click shop_prop_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(closeButton2, nil, {func_string = [[state_machine.excute("trial_tower_shop_prop_buy_close", 0, "click shop_prop_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(cutButtonTen, nil, 
		{
			terminal_name = "trial_tower_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = -10,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
	fwin:addTouchEventListener(cutButtonOne, nil, 
		{
			terminal_name = "trial_tower_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = -1,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonTen, nil, 
		{
			terminal_name = "trial_tower_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = 10,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonOne, nil, 
		{
			terminal_name = "trial_tower_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = 1,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
	self:updateMoney()
end


--物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 
--10:功能点 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 
--17:霸气 18 威名 19 日常任务积分 20功勋 21战功 22日常副本基础奖励 23日常副本额外奖励
function TrialTowerShopPropBuyNumberTip:createConfig()
	return{	--此处的是个范类型对象,可以是以上类型的任何一个
		quality = nil,
		count = nil, --显示一打商品所包含的数量 如银钱x10万
		mid = nil,--物品的模板id
		gtype = nil,--物品类型, 见楼上
		price = nil,--单价x货币,诸如威望啊金币啊xxxxx
		money = nil,--当前用户持有的x货币的数量
		name = nil,	--物品名
		existingDebris = nil, --碎片
		maxBuyNum = nil, --当前最大可购买次数
		shopType = nil, --商店类型 -- 就是 商店分页标签0,1,2,3
		indexId = nil,--位于本地表中的索引id
		gemPrice = nil, -- 宝石单价
		redDebrisNum = nil, -- 红装碎片需求兑换数
		redDebrisMID = nil, -- 红装碎片的模板id
	}
end

function TrialTowerShopPropBuyNumberTip:init(config)
	self.config = config
end

function TrialTowerShopPropBuyNumberTip:createCell()
	local cell = TrialTowerShopPropBuyNumberTip:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
