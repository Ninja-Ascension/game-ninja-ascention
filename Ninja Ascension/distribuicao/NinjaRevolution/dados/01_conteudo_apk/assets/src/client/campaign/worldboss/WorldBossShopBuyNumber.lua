-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军商店购买选择数量
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

WorldBossShopBuyNumber = class("WorldBossShopBuyNumberClass", Window)
    
function WorldBossShopBuyNumber:ctor()
    self.super:ctor()
    self.roots = {}

	self.prop = nil
	self.type = nil
	self.Tparams = nil
	self.buySum = 1 --要购买的总数
	self.shop_type = nil
	-- Initialize shop page state machine.
    local function init_shop_prop_buy_number_tip_terminal()
	
		local world_boss_shop_prop_buy_sure_terminal = {
            _name = "world_boss_shop_prop_buy_sure",
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
		local world_boss_shop_prop_buy_close_terminal = {
            _name = "world_boss_shop_prop_buy_close",
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
		local world_boss_shop_prop_buy_number_change_terminal = {
            _name = "world_boss_shop_prop_buy_number_change",
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
		state_machine.add(world_boss_shop_prop_buy_sure_terminal)
		
		state_machine.add(world_boss_shop_prop_buy_close_terminal)
		state_machine.add(world_boss_shop_prop_buy_number_change_terminal)
        state_machine.init()
    end
    
    -- call func init shop state machine.
    init_shop_prop_buy_number_tip_terminal()

end



function WorldBossShopBuyNumber:onUpdateDraw()
	local root = self.roots[1]
end


function WorldBossShopBuyNumber:getPropCell(mouldType,count)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = self.config.mid
	cellConfig.touchShowType = 1
	cellConfig.mouldType = mouldType
	cellConfig.count = self.config.count
	cellConfig.isDebris = true
	cellConfig.isBigImg = true
	cell:init(cellConfig)

	return cell
end


function WorldBossShopBuyNumber:getShipCell()
	return self:getPropCell(13)
end


function WorldBossShopBuyNumber:getEquipmentCell()
	return self:getPropCell(7)
end


function WorldBossShopBuyNumber:getIconCell()
	local cell = nil
	if self.config.gtype  == 6 then
		cell = self:getPropCell()
		self:setBuyToProp()
	elseif self.config.gtype == 7 then
		cell = self:getEquipmentCell()
		self:setBuyToProp()
	elseif self.config.gtype == 13 then
		cell = self:getShipCell()
		self:setBuyToProp()
	elseif self.config.gtype == 1 then
		cell = propMoneyIcon:createCell()
		cell:init("1",self.config.count,nil)
		self:setBuyToProp()
	elseif self.config.gtype == 2 then
		cell = propMoneyIcon:createCell()
		cell:init("2",self.config.count,nil)
		self:setBuyToProp()
	end	
	return cell
end


function WorldBossShopBuyNumber:setBuyToProp()
		fwin:addTouchEventListener(self.sureBuy, nil, 
		{
			terminal_name = "world_boss_shop_prop_buy_sure", 
			terminal_state = 0, 
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)

end


function WorldBossShopBuyNumber:checkupPrice(n)
	if self.config.price > 0 and self.config.redDebrisNum > 0 then
		self:calculateRedDebris(n)
	elseif self.config.price > 0 then
		self:calculatePrice(n)
	end
end


-- 普通价格 
function WorldBossShopBuyNumber:calculatePrice(num)
	local n = self.buySum + num
	if n == 0 then
		return
	end
	n = math.max(n,1)
	if n * self.config.price > self.config.money then
		if self.config.originType == 2 and num >= 0 then
			TipDlg.drawTextDailog(tipStringInfo_union_str[70])
		end
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


-- 价钱+道具价格
function WorldBossShopBuyNumber:calculateRedDebris(num)
	local n = self.buySum + num
	n = math.max(n,1)
	if n * self.config.price > self.config.money then
		if self.config.originType == 2 and num >= 0 then
			TipDlg.drawTextDailog(tipStringInfo_union_str[70])
		end
		-- 买的太多,不够付账的
		n = math.floor(self.config.money / self.config.price) 
	end
	n = math.max(n,1)
	

	-- 计算 可用数
	local myRedDebrisNum = zstring.tonumber(getPropAllCountByMouldId(self.config.redDebrisMID))
	if n*self.config.redDebrisNum > myRedDebrisNum then
		if self.config.originType == 2 and num >= 0 then
			TipDlg.drawTextDailog(tipStringInfo_union_str[70])
		end
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


function WorldBossShopBuyNumber:updateMoney()
	local root = self.roots[1]
	
	-- 买多少个
	self.text_buy_num:setString(self.buySum)
	-- 多少钱

	--检测价钱值
	if self.config.price > 0 then
		-- 检查当前是否有可购买数
		if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
			if self.config.originType == 2 then
				ccui.Helper:seekWidgetByName(root, "Image_juntuan"):setVisible(true)
			elseif self.config.originType == 1 then --竞技场声望图标
				local Image_sw = ccui.Helper:seekWidgetByName(root, "Image_sw")
				if Image_sw ~= nil then
					Image_sw:setVisible(true)
				end
			else
				ccui.Helper:seekWidgetByName(root, "Image_zg"):setVisible(true)
			end	
			self.text_buy_price:setString(self.buySum*self.config.price)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local Panel_8 = ccui.Helper:seekWidgetByName(root, "Panel_8")
				local  _imagezg = Panel_8:getChildByName("Image_zg")
				local  _imagesw = Panel_8:getChildByName("Image_sw")
				if self.config.originType == 0  then  --惩奸除恶
					_imagezg:setVisible(true)
					_imagesw:setVisible(false)
				elseif self.config.originType == 1 then --武神台
					_imagezg:setVisible(false)
					_imagesw:setVisible(true)
				end
			else
				local Panel_8_0_zg = ccui.Helper:seekWidgetByName(root, "Panel_8_0_zg")
				local Image_7_3_sw = Panel_8_0_zg:getChildByName("Image_7_3_sw")
				local Image_7_3 = Panel_8_0_zg:getChildByName("Image_7_3")
				if Image_7_3_sw ~= nil and Image_7_3 ~= nil then 
					if self.config.originType == 1 then 
						Image_7_3:setVisible(false)
						Image_7_3_sw:setVisible(true)
					end
				end
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_8"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_8_0_zg"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_buy_7_10_4"):setString(self.buySum*self.config.price)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local Panel_8_0_zg = ccui.Helper:seekWidgetByName(root, "Panel_8_0_zg")
				local  _imagezg = Panel_8_0_zg:getChildByName("Image_7_3")
				local  _imagesw = Panel_8_0_zg:getChildByName("Image_7_3_sw")
				if self.config.originType == 0  then  --惩奸除恶
					_imagezg:setVisible(true)
					_imagesw:setVisible(false)
				elseif self.config.originType == 1 then --武神台
					_imagezg:setVisible(false)
					_imagesw:setVisible(true)
				end
			else
				local Panel_8_0_zg = ccui.Helper:seekWidgetByName(root, "Panel_8_0_zg")
				local Image_7_3_sw = Panel_8_0_zg:getChildByName("Image_7_3_sw")
				local Image_7_3 = Panel_8_0_zg:getChildByName("Image_7_3")
				if Image_7_3_sw ~= nil and Image_7_3 ~= nil then 
					if self.config.originType == 1 then 
						Image_7_3:setVisible(false)
						Image_7_3_sw:setVisible(true)
						
					end
				end
			end
		end
	end
	
	--检查红碎片
	if self.config.redDebrisNum > 0 then
		if ccui.Helper:seekWidgetByName(root, "Panel_8_0_zg"):isVisible() then
			ccui.Helper:seekWidgetByName(root, "Panel_1987_zg_0"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_buy_7_10_0_6_2"):setString(self.buySum*self.config.redDebrisNum)
			local Image_hz_0_6_3 = ccui.Helper:seekWidgetByName(root, "Image_hz_0_6_3")
			if Image_hz_0_6_3 ~= nil then 
				if self.config.redDebrisMID == 2 then 
					Image_hz_0_6_3:setBackGroundImage("images/ui/icon/icon_tuposhi.png")
				else
					Image_hz_0_6_3:setBackGroundImage("images/ui/icon/hongjiang.png")
				end
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_1987_zg"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_buy_7_10_0_6"):setString(self.buySum*self.config.redDebrisNum)
			local Image_hz_0_6 = ccui.Helper:seekWidgetByName(root, "Image_hz_0_6")
			if Image_hz_0_6 ~= nil then 
				Image_hz_0_6:setVisible(true)
				if self.config.redDebrisMID == 2 then 
					Image_hz_0_6:setBackGroundImage("images/ui/icon/icon_tuposhi.png")
				else
					Image_hz_0_6:setBackGroundImage("images/ui/icon/hongjiang.png")
				end
			end
		end
	end
end


-- 买装备
function WorldBossShopBuyNumber:buyGodds()

-- dignified_shop_buy
-- 用户ID
-- 商品ID
-- 商品数量

	if self.config.originType == 0 then
		-- 叛军
		local has = zstring.tonumber(_ED.user_info.exploit)
		local function responseBuGoodsCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if (__lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
			  		then
			  		local num = has - zstring.tonumber(_ED.user_info.exploit)
			  		if num > 0 then
			  			jttd.consumableItems(_All_tip_string_info._exploit,num)
			  		end
			  	end
				TipDlg.drawTextDailog(_string_piece_info[76])
			
				--通知刷新战功减少, 物品购买限定次数变更
				setBetrayArmyLimitCount(response.node.config.indexId,response.node.buySum)
				
				
				state_machine.excute("betray_army_refresh_honor_content",0,0)
				
				state_machine.excute("betray_army_refresh_shop_prop_buy_list", 0, {
					_target = response.node.config._target,
				})
				fwin:close(response.node)
			end
		end

		
		protocol_command.rebel_exploit_shop_exchange.param_list = self.config.indexId .. "," .. self.buySum
		NetworkManager:register(protocol_command.rebel_exploit_shop_exchange.code, nil, nil, nil, self, responseBuGoodsCallback, false, nil)
	
	elseif self.config.originType == 1 then
		-- 演习
		local params = {_datas = {}}
		params._datas._current_buy_count = self.buySum
		params._datas._prop = self.config.indexId
		state_machine.excute("arena_honor_buy_honor", 0, params)
		fwin:close(self)
	elseif self.config.originType == 2 then	
		-- local index = params._datas._index
		local mouldid = self.config.mouldid
		local typeIndex = self.config.typeIndex
		local has = zstring.tonumber(_ED.union.user_union_info.rest_contribution)
		local function responseGetServerListCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if (__lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and __game_data_record_open == true
			  		then 
			  		local num = has - zstring.tonumber(_ED.union.user_union_info.rest_contribution)
			  		if num > 0 then
			  			jttd.consumableItems(_All_tip_string_info._union_exploit,num)
			  		end
			  	end
			  	if response.node ~= nil then
					response.node.config._target:rewadDraw()
					fwin:close(response.node)
				end
			end
		end
		
		protocol_command.union_shop_exchange.param_list = ""..mouldid.."\r\n"..typeIndex.."\r\n"..self.buySum
		
		NetworkManager:register(protocol_command.union_shop_exchange.code, nil, nil, nil, self, responseGetServerListCallback, false, nil)
	end
end



function WorldBossShopBuyNumber:onEnterTransitionFinish()
	local csbShopPropBuyNumberTip = csb.createNode("shop/buy_props.csb")
	local root = csbShopPropBuyNumberTip:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("shop/buy_props.csb")
    csbShopPropBuyNumberTip:runAction(action)
	action:play("window_open", false)
    self:addChild(csbShopPropBuyNumberTip)
	
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
	local cell = self:getIconCell()
	if cell ~= nil then
		headPanel:addChild(self:getIconCell())
	end	
	
	--名字
	local name = ccui.Helper:seekWidgetByName(root, "Text_buy_1")
	name:setString(self.config.name)

	name:setColor(cc.c3b(color_Type[self.config.quality][1],color_Type[self.config.quality][2],color_Type[self.config.quality][3]))
	
	--已有个数 
	local userHave = ccui.Helper:seekWidgetByName(root, "Text_buy_3")
	if self.config.originType == 2 then
		if self.config.gtype == 1  then
			-- userHave:setString(_ED.user_info.user_silver)
			if zstring.tonumber( _ED.user_info.user_silver) > 100000000 then
				userHave:setString(math.floor(_ED.user_info.user_silver/ 100000000) .. string_equiprety_name[39])
			elseif zstring.tonumber( _ED.user_info.user_silver)> 1000000 then
				userHave:setString(math.floor(_ED.user_info.user_silver / 10000) .. string_equiprety_name[38])
			else
				userHave:setString(_ED.user_info.user_silver)
			end
		elseif self.config.gtype == 2 then
			-- serHave:setString(_ED.user_info.user_gold)
			if zstring.tonumber( _ED.user_info.user_gold) > 100000000 then
				userHave:setString(math.floor(_ED.user_info.user_gold/ 100000000) .. string_equiprety_name[39])
			elseif zstring.tonumber( _ED.user_info.user_gold)> 1000000 then
				userHave:setString(math.floor(_ED.user_info.user_gold / 10000) .. string_equiprety_name[38])
			else
				userHave:setString(_ED.user_info.user_gold)
			end
		else
			userHave:setString(getPropAllCountByMouldId(self.config.mid))	
		end	
	else
		userHave:setString(getPropAllCountByMouldId(self.config.mid))
	end	


	
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
	--战功的价格图标 Image_zg
	ccui.Helper:seekWidgetByName(root, "Image_zg"):setVisible(false)
	--荣誉的价格图标 Image_ry  Text_buy_7
	ccui.Helper:seekWidgetByName(root, "Image_ry"):setVisible(false)
	--声望
	local Image_sw = ccui.Helper:seekWidgetByName(root, "Image_sw")
	if Image_sw ~= nil then 
		Image_sw:setVisible(false)
	end
	
	--今日还可购买数 Text_buy_4
	local surplusNumber = ccui.Helper:seekWidgetByName(root, "Text_buy_4")
	self.surplusNumber = surplusNumber
	if nil ~= tonumber(self.config.maxBuyNum) and tonumber(self.config.maxBuyNum) > 0 then
		surplusNumber:setString(string.format(tipStringInfo_betrayArmy_info[1] ,tonumber(self.config.maxBuyNum)))
		ccui.Helper:seekWidgetByName(root, "Text_buy_5"):setString(_string_piece_info[77])
		if self.config.originType == 2  then
			ccui.Helper:seekWidgetByName(root, "Text_buy_5"):setVisible(false)
		end	
	end
	
	fwin:addTouchEventListener(closeButton, nil, {func_string = [[state_machine.excute("world_boss_shop_prop_buy_close", 0, "click shop_prop_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(closeButton2, nil, {func_string = [[state_machine.excute("world_boss_shop_prop_buy_close", 0, "click shop_prop_buy_close.'")]], isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(cutButtonTen, nil, 
		{
			terminal_name = "world_boss_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = -10,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
	fwin:addTouchEventListener(cutButtonOne, nil, 
		{
			terminal_name = "world_boss_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = -1,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonTen, nil, 
		{
			terminal_name = "world_boss_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = 10,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	fwin:addTouchEventListener(addButtonOne, nil, 
		{
			terminal_name = "world_boss_shop_prop_buy_number_change", 
			terminal_state = 0, 
			_number = 1,
			_instance = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		
	
	
	self:updateMoney()
end

function WorldBossShopBuyNumber:onExit()
	
end

function WorldBossShopBuyNumber:createConfig()
	return{	--此处的是个范类型对象,可以是以上类型的任何一个
		quality = nil,
		count = nil, --显示一打商品所包含的数量 如x10
		mid = nil,--物品的模板id
		gtype = nil,--物品类型,
		price = nil,--单价x货币,诸如威望啊金币啊xxxxx
		money = nil,--当前用户持有的x货币的数量
		name = nil,	--物品名
		existingDebris = nil, --碎片
		maxBuyNum = nil, --当前最大可购买次数
		indexId = nil,--位于本地表中的索引id
		redDebrisNum = nil, -- 红装碎片需求兑换数
		redDebrisMID = nil, -- 红装碎片的模板id
		cell = nil,
		originType = nil, --调用的来源,区别显示类型   1:竞技场 
	}
end

function WorldBossShopBuyNumber:init(config)
	self.config = config
end

function WorldBossShopBuyNumber:createCell()
	local cell = WorldBossShopBuyNumber:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


