-- ----------------------------------------------------------------------------------------------------
-- 说明：黑商
-------------------------------------------------------------------------------------------------------
AdventureBlackMarket = class("AdventureBlackMarketClass", Window)
    
function AdventureBlackMarket:ctor()
    self.super:ctor()
    self.roots = {}
	self.interval = 0
    self.needUpdateRefreshCd = false
    self.Panel_dingdan0 = nil 
    self.Panel_dingdan1 = nil 
    self.Panel_dingdan2 = nil 
    --  显示CD时间
    self.strtime = nil
    self._Text_22 = nil
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
	app.load("client.adventure.cells.prop.adventure_new_prop_activity_icon_cell")
    -- Initialize adventure black market state machine.
    local function init_adventure_black_market_terminal()
        -- Bouns领取
        local adventure_black_market_draw_terminal = {
            _name = "adventure_black_market_draw",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if zstring.tonumber(_ED.bonusStatus) == 1 then
					local function requestArenaRefushCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							--界面刷新
							
							response.node:onUpdateDrawButton()
							response.node:onUpdateDrawExtraBonus()
							app.load("client.adventure.reward.AdventureTipReward")
							fwin:open(AdventureTipReward:new():init(getSceneReward(56)), fwin._ui)
						end
					end
					NetworkManager:register(protocol_command.draw_black_shop_reward.code, nil, nil, nil, instance, requestArenaRefushCallback, false, nil)
				else
					-- 点击Bouns领取提示订单为完成无法领取 
					TipDlg.drawTextDailog(_string_piece_info[388])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 调用刷新二级窗口
        local adventure_black_market_refresh_cd_terminal = {
            _name = "adventure_black_market_refresh_cd",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.adventure.campaign.arena.AdventureArenaResetLlist")
            	fwin:open(AdventureArenaResetLlist:new():init(2,params._datas.cell.strtime),fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 刷新冷却时间
        local adventure_black_market_refresh__cooltime_cd_terminal = {
            _name = "adventure_black_market_refresh_cooltime_cd",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 刷新界面
            	self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 兑换物品
        local adventure_black_market_exchange_item_request_terminal = {
            _name = "adventure_black_market_exchange_item_request",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = params._datas.operateId
				local function requestArenaRefushCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						--界面刷新
						response.node:onUpdateDraw()
						response.node:onUpdateDrawButton()
						app.load("client.adventure.reward.AdventureTipReward")
						fwin:open(AdventureTipReward:new():init(getSceneReward(56)), fwin._ui)
					end
				end
				protocol_command.black_shop_exchange.param_list = zstring.tonumber(index)-1
				NetworkManager:register(protocol_command.black_shop_exchange.code, nil, nil, nil, instance, requestArenaRefushCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

        state_machine.add(adventure_black_market_draw_terminal)
        state_machine.add(adventure_black_market_refresh_cd_terminal)
        state_machine.add(adventure_black_market_refresh__cooltime_cd_terminal)
        state_machine.add(adventure_black_market_exchange_item_request_terminal)
        state_machine.init()
    end
    
    -- call func init adventure black market state machine.
    init_adventure_black_market_terminal()
end

function AdventureBlackMarket:init()
	return self
end

function AdventureBlackMarket:updateRefreshCd()
	if self.needUpdateRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
	if interval <= 0 then
		self._Text_22:setString("00:00:00")
	else
		self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        self.strtime = timeTabel.hour
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.minute)
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.second)

        self._Text_22:setString(self.strtime)
	end
	
end

function AdventureBlackMarket:onUpdate(dt)
    if self.interval > 0 then
        local interval = (_ED.native_time + zstring.tonumber(_ED.refreshTime)/1000) - os.time()
        if self.interval ~= interval then
            self.interval = interval
            self:updateRefreshCd()
        end
    end
end

function AdventureBlackMarket:onUpdateDrawButton()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Button_wancheng_1")
	for i=1, zstring.tonumber(_ED.black_shop_num) do
		if zstring.tonumber(_ED.black_shop_info[i].exchangeStatus) == 1 then
			ccui.Helper:seekWidgetByName(root, "Button_wancheng_"..i):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(root, "Button_wancheng_"..i):setColor(cc.c3b(255, 255, 255))
		else
			ccui.Helper:seekWidgetByName(root, "Button_wancheng_"..i):setTouchEnabled(false)
			ccui.Helper:seekWidgetByName(root, "Button_wancheng_"..i):setColor(cc.c3b(150, 150, 150))
		end
	end
	
	if zstring.tonumber(_ED.bonusStatus) == 1 then
		ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setColor(cc.c3b(255, 255, 255))
	else
		for i=1, zstring.tonumber(_ED.black_shop_num) do
			if zstring.tonumber(_ED.black_shop_info[i].exchangeStatus) == 1 then
				ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setTouchEnabled(true)
				ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setColor(cc.c3b(255, 255, 255))
				return
			end
		end
		ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setTouchEnabled(false)
		ccui.Helper:seekWidgetByName(root, "Button_lingqu"):setColor(cc.c3b(150, 150, 150))
	end
end

function AdventureBlackMarket:onUpdateDraw()
	local root = self.roots[1]
	-- 类型
	-- 1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 
	-- 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气 18 威名 19 日常任务积分 20功勋 
	-- 21战功 22日常副本基础奖励 23日常副本额外奖励 24出击令 25免战时间 26 战力
	for i=1,3 do
		local onePanel = ccui.Helper:seekWidgetByName(root, "Panel_dingdan_1_"..i)
		local twoPanel = ccui.Helper:seekWidgetByName(root, "Panel_dingdan_2_"..i)
		local rewardPanel = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
		onePanel:removeAllChildren(true)
		twoPanel:removeAllChildren(true)
		rewardPanel:removeAllChildren(true)
	end
	for i=1, zstring.tonumber(_ED.black_shop_num) do
		local demandOneType = _ED.black_shop_info[i].demandTypeOne
		local demandTwoType = _ED.black_shop_info[i].demandTypeTwo
		local exchangeType = _ED.black_shop_info[i].exchangeType
		local cellOne = adventureNewSmallPropActivityCell:createCell()
		local onePanel = ccui.Helper:seekWidgetByName(root, "Panel_dingdan_1_"..i)
		if zstring.tonumber(demandOneType) == 1 then	
			cellOne:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumOne), nil, 0, 0)
			onePanel:addChild(cellOne)
		elseif zstring.tonumber(demandOneType) == 2 then
			cellOne:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumOne), nil, 0, 0)
			onePanel:addChild(cellOne)
		elseif zstring.tonumber(demandOneType) == 3 then
			cellOne:init(0, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumOne), nil, 0, 0)
			onePanel:addChild(cellOne)
		elseif zstring.tonumber(demandOneType) == 4 then
			cellOne:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumOne), nil, 0, 0)
			onePanel:addChild(cellOne)
		elseif zstring.tonumber(demandOneType) == 6 then
			local havePropAmount = 0
			for _, v in pairs(_ED.user_prop) do
				if v.user_prop_template == _ED.black_shop_info[i].demandMouldOne then
					havePropAmount = zstring.tonumber(v.prop_number)
					break	
				end
			end
			
			--print("==========================", _ED.black_shop_info[i].demandMouldOne, havePropAmount)
			--debug.print_r(_ED.user_prop)
			cellOne:init(0, {mould_id = _ED.black_shop_info[i].demandMouldOne} ,havePropAmount .. "/".. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumOne),nil,0,0)
			onePanel:addChild(cellOne)
		end
		
		local cellTwo = adventureNewSmallPropActivityCell:createCell()
		local twoPanel = ccui.Helper:seekWidgetByName(root, "Panel_dingdan_2_"..i)
		if zstring.tonumber(demandTwoType) == 1 then
			cellTwo:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumTwo), nil, 0, 0)
			twoPanel:addChild(cellTwo)
		elseif zstring.tonumber(demandTwoType) == 2 then
			cellTwo:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumTwo), nil, 0, 0)
			twoPanel:addChild(cellTwo)
		elseif zstring.tonumber(demandTwoType) == 3 then
			cellTwo:init(0, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumTwo), nil, 0, 0)
			twoPanel:addChild(cellTwo)
		elseif zstring.tonumber(demandTwoType) == 4 then
			cellTwo:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumTwo), nil, 0, 0)
			twoPanel:addChild(cellTwo)
		elseif zstring.tonumber(demandTwoType) == 6 then
			local havePropAmount = 0
			for _, v in pairs(_ED.user_prop) do
				if v.user_prop_template == _ED.black_shop_info[i].demandMouldTwo then
					havePropAmount = zstring.tonumber(v.prop_number)
					break	
				end
			end
			cellTwo:init(0, {mould_id = _ED.black_shop_info[i].demandMouldTwo} ,havePropAmount .. "/" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].demandNumTwo),nil,0,0)
			twoPanel:addChild(cellTwo)
		end
		 
		local cellExchange = adventureNewSmallPropActivityCell:createCell()
		local rewardPanel = ccui.Helper:seekWidgetByName(root, "Panel_reward_"..i)
		if zstring.tonumber(exchangeType) == 1 then
			cellExchange:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].getGloryNumber), nil, 0, 0)
			rewardPanel:addChild(cellExchange)
		elseif zstring.tonumber(exchangeType) == 2 then
			cellExchange:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].getGloryNumber), nil, 0, 0)
			rewardPanel:addChild(cellExchange)
		elseif zstring.tonumber(exchangeType) == 3 then
			cellExchange:init(0, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].getGloryNumber), nil, 0, 0)
			rewardPanel:addChild(cellExchange)
		elseif zstring.tonumber(exchangeType) == 4 then
			cellExchange:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].getGloryNumber), nil, 0, 0)
			rewardPanel:addChild(cellExchange)
		elseif zstring.tonumber(exchangeType) == 6 then
			cellExchange:init(0, {mould_id = _ED.black_shop_info[i].exchangeMould} ,"" .. getResourceValueToStringForAdventure(_ED.black_shop_info[i].getGloryNumber),nil,0,0)
			rewardPanel:addChild(cellExchange)
		end
		
	end
	
	self:onUpdateDrawExtraBonus()
	
	self:onUpdateDrawButton()
	self.Panel_dingdan0:setVisible(true)
    self.Panel_dingdan1:setVisible(true)
    self.Panel_dingdan2:setVisible(true)
	
	self.interval = (_ED.native_time + zstring.tonumber(_ED.refreshTime)) - os.time()
    self.needUpdateRefreshCd = true
    self:updateRefreshCd()
end

function AdventureBlackMarket:onUpdateDrawExtraBonus()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local extraPanel = ccui.Helper:seekWidgetByName(root, "Panel_20")
	extraPanel:removeAllChildren()

	local cellBouns = adventureNewSmallPropActivityCell:createCell()
	cellBouns:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(_ED.extraBonus), nil, 0, 0)
	extraPanel:addChild(cellBouns)
end

function AdventureBlackMarket:onEnterTransitionFinish()
	local csbAdventureBlackMarket = csb.createNode("system/black_market.csb")
    local root = csbAdventureBlackMarket:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBlackMarket)
    self.Panel_dingdan0 = ccui.Helper:seekWidgetByName(root, "Panel_dingdan") 
    self.Panel_dingdan1 = ccui.Helper:seekWidgetByName(root, "Panel_dingdan_0")  
    self.Panel_dingdan2 = ccui.Helper:seekWidgetByName(root, "Panel_dingdan_1") 
    self.Panel_dingdan0:setVisible(false)
    self.Panel_dingdan1:setVisible(false)
    self.Panel_dingdan2:setVisible(false)
    self._Text_22 = ccui.Helper:seekWidgetByName(root, "Text_22")
	local function responseBlackShopInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			response.node:onUpdateDraw()
		end
	end
	NetworkManager:register(protocol_command.black_shop_init.code, nil, nil, nil, self, responseBlackShopInitCallback, false, nil)
	
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
		terminal_name = "menu_manager",     
		next_terminal_name = "menu_show_home_page", 
		current_button_name = "Button_daditu",
		but_image = "Image_daditu",         
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)

    -- Bouns领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"),       nil, 
    {
        terminal_name = "adventure_black_market_draw",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 刷新冷却时间
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shuaxin"),       nil, 
    {
        terminal_name = "adventure_black_market_refresh_cd",        
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 完成订单1
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wancheng_1"),       nil, 
    {
        terminal_name = "adventure_black_market_exchange_item_request",        
        terminal_state = 0, 
		operateId = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 完成订单2
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wancheng_2"),       nil, 
    {
        terminal_name = "adventure_black_market_exchange_item_request",        
        terminal_state = 0, 
		operateId = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 完成订单3
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wancheng_3"),       nil, 
    {
        terminal_name = "adventure_black_market_exchange_item_request",        
        terminal_state = 0, 
		operateId = 3,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureBlackMarket:onExit()
    state_machine.remove("adventure_black_market_draw")
    state_machine.remove("adventure_black_market_refresh_cd")
    state_machine.remove("adventure_black_market_refresh_cooltime_cd")
    state_machine.remove("adventure_black_market_exchange_item_request")
end