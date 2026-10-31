-- ----------------------------------------------------------------------------------------------------
-- 说明：探索商店
-------------------------------------------------------------------------------------------------------

ExplorationShopWindow = class("ExplorationShopWindowClass", Window)

local exploration_shop_window_open_terminal = {
    _name = "exploration_shop_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local function callback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local ExplorationShopWindowWindow = fwin:find("ExplorationShopWindowClass")
		    	if ExplorationShopWindowWindow == nil then
		    		fwin:open(ExplorationShopWindow:new():init(params), fwin._view)
		    	end
			end
		end
		protocol_command.pokemon_explore_shop_info.param_list = json.encode({type = 0})
		NetworkManager:register(protocol_command.pokemon_explore_shop_info.code, nil, nil, nil, nil, callback, false, nil)
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_shop_window_open_terminal)
state_machine.init()

function ExplorationShopWindow:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 2
	self._scroll_view = nil
	self._scroll_view_pox = 0
	self._scroll_view_width = 0
	self.roll_width = 0

	app.load("client.l_digital.campaign.exploration.ExplorationShopBuy")
	app.load("client.l_digital.campaign.exploration.ExplorationShopCell")

	local function init_exploration_shop_terminal()
		--
		local exploration_shop_close_terminal = {
            _name = "exploration_shop_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("ExplorationShopWindowClass"))
				-- fwin:close(fwin:find("ExplorationShopWindowBuyTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_shop_update_terminal = {
            _name = "exploration_shop_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _type = params._datas._type

				function showConfirmTip(instance,n)
                    if n == 0 then
                        local function callback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								instance:onUpdateDraw()
							end
						end
						protocol_command.pokemon_explore_shop_info.param_list = json.encode({type = _type})
						NetworkManager:register(protocol_command.pokemon_explore_shop_info.code, nil, nil, nil, nil, callback, false, nil)
                    end
                end

                local needCost = 0
                local costParams = zstring.split(dms.string(dms["shop_config"], 19, shop_config.param), ",")
				needCost = costParams[tonumber(_ED.pokemonExplore.shopInfo.shopRefreshTimes) + 1]
				if needCost then
				else
					needCost = costParams[#costParams]
				end

                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, showConfirmTip,string.format(tipStringInfo_exploration_tips[11], tonumber(needCost)))
                fwin:open(tip, fwin._ui)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_shop_scrollView_roll_terminal = {
            _name = "exploration_shop_scrollView_roll",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local currType = params._datas._type
            	local scrollView = instance._scroll_view:getInnerContainer()
            	local scrollViewX = 0
            	if currType == 1 then
            		scrollViewX = scrollView:getPositionX() + instance.roll_width
            		scrollViewX = math.min(0 , scrollViewX)
            	else
            		scrollViewX = scrollView:getPositionX() - instance.roll_width
            		scrollViewX = math.max(scrollViewX , instance._scroll_view:getContentSize().width - scrollView:getContentSize().width)
            	end
            	scrollView:setPositionX(scrollViewX)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_shop_close_terminal)
        state_machine.add(exploration_shop_scrollView_roll_terminal)
        state_machine.add(exploration_shop_update_terminal)
		state_machine.init()
	end

	init_exploration_shop_terminal()
end

function ExplorationShopWindow:onUpdateDraw()
	local root = self.roots[1]
	--排序
	self.ids = {}
	for k,v in pairs(_ED.pokemonExplore.shopInfo.shopBuyTimes) do
		local index1 = dms.int(dms["role_explore_shop"], k, 6)
		table.insert(self.ids, k)
	end

	table.sort( self.ids, function( a,  b )
		local index1 = dms.int(dms["role_explore_shop"], a, 6)
		local index2 = dms.int(dms["role_explore_shop"], b, 6)
		return index1 < index2
	end )

	local ScrollView_explore_shop = ccui.Helper:seekWidgetByName(root, "ScrollView_explore_shop")
	ScrollView_explore_shop:removeAllChildren(true)
	
	local cell_size = nil
	local all = table.nums(self.ids)
	local width_n = math.ceil(all / 2)
	local index = 1
	for i, v in ipairs(self.ids) do
		local index1 = dms.int(dms["role_explore_shop"], v, 6)
		local shop_info = dms.element(dms["role_explore_shop"], tonumber(v))
		local cell = ExplorationShopCell:createCell()
		cell:init(shop_info)
		if cell_size == nil then
			cell_size = cell:getContentSize()
		end
		ScrollView_explore_shop:addChild(cell)
		cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
		index = index + 1
	end

	if nil ~= cell_size then
		self.roll_width = cell_size.width * 3
		local InnerWidth = math.max(cell_size.width * width_n , ScrollView_explore_shop:getContentSize().width)
		local InnerHeight = ScrollView_explore_shop:getInnerContainer():getContentSize().height
		ScrollView_explore_shop:getInnerContainer():setContentSize(cc.size(InnerWidth , InnerHeight))
	end

    self._scroll_view = ScrollView_explore_shop
    self._scroll_view_pox = 99999 --ScrollView_explore_shop:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_explore_shop:getInnerContainer():getPositionX()


    --定点刷新
    local refresh_times = zstring.split(dms.string(dms["shop_config"], 18, shop_config.param) , ",")
	local nextReresh = 0
	local isToday = false
	local str = ""
	local server_time = getCurrentGTM8Time()
	-- local currTimes = os.date("%H", os.time()) * 3600 + os.date("%M", os.time()) * 60 + os.date("%S", os.time())
	local currTimes = server_time.hour * 3600 + server_time.min * 60 + server_time.sec
	local nextTimes = 0
	-- local currhour = os.date("%H", os.time())
	local currhour = server_time.hour
	for i , v in pairs(refresh_times) do
		local _hour = tonumber(zstring.split(v , ":")[1])
		if tonumber(currhour) < _hour then
			nextReresh = _hour
			nextTimes = _hour * 3600
			isToday = true
			break
		end
	end
	if isToday == false then
		nextReresh = tonumber(zstring.split(refresh_times[1] , ":")[1])
		nextTimes = ( nextReresh + 24) * 3600
		str = string.format(_new_interface_text[101], nextReresh)
	else
		str = string.format(_new_interface_text[100], nextReresh)
	end
	local Text_explore_shop_refresh_time = ccui.Helper:seekWidgetByName(root, "Text_explore_shop_refresh_time")
	Text_explore_shop_refresh_time:setString(_new_interface_text[102]..str)

	local function refreshUpdateDraw( ... )
		state_machine.excute("exploration_shop_update", 0 ,{_datas = { _type = 0}})
	end
	self:stopAllActions()
	self:runAction(cc.Sequence:create(cc.DelayTime:create(nextTimes - currTimes), cc.CallFunc:create(refreshUpdateDraw)))

	--刷新
	local maxRefreshFreeTimes = dms.int(dms["shop_config"], 20, shop_config.param)
	local Text_explore_shop_refresh_free_n = ccui.Helper:seekWidgetByName(root, "Text_explore_shop_refresh_free_n")
	local leftIimes = maxRefreshFreeTimes - tonumber(_ED.pokemonExplore.shopInfo.shopRefreshTimes)
	Text_explore_shop_refresh_free_n:setString(leftIimes .. "/" .. maxRefreshFreeTimes)

	local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
	local costParams = zstring.split(dms.string(dms["shop_config"], 19, shop_config.param), ",") 
	local needCost = costParams[tonumber(_ED.pokemonExplore.shopInfo.shopRefreshTimes) + 1]
	if needCost then
		Text_zuanshi_n:setString(needCost)
	else
		Text_zuanshi_n:setString(costParams[#costParams])
	end
end

function ExplorationShopWindow:onUpdate(dt)
    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posX = self._scroll_view:getInnerContainer():getPositionX()
        if self._scroll_view_pox == posX then
            return
        end
        self._scroll_view_pox = posX
        local items = self._scroll_view:getChildren()

	    if posX >= -40 then
	        self.Button_arrow_left:setVisible(false)
	    else
	        self.Button_arrow_left:setVisible(true)
	    end
	    if posX <= -self._scroll_view:getInnerContainer():getContentSize().width + self._scroll_view:getContentSize().width + 40 then
	        self.Button_arrow_right:setVisible(false)
	    else
	        self.Button_arrow_right:setVisible(true)
	    end

        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempX = v:getPositionX() + posX
            if tempX + itemSize.width < 0 or tempX > size.width + itemSize.width then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function ExplorationShopWindow:onInit()
	local csb_explore_shop = csb.createNode("campaign/exploration/exploration_shop.csb")
	local root = csb_explore_shop:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_shop)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_shop_report_back"), nil, 
	{
		terminal_name = "exploration_shop_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

    self.Button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_arrow_right")
    self.Button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_arrow_left")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_right"), nil, 
	{
		terminal_name = "exploration_shop_scrollView_roll", 
		terminal_state = 0, 
		_type  = 2,
		isPressedActionEnabled = true
	},
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_left"), nil, 
	{
		terminal_name = "exploration_shop_scrollView_roll", 
		terminal_state = 0, 
		_type  = 1,
		isPressedActionEnabled = true
	},
	nil, 0)

	-- 刷新
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_shop_refresh"), nil, 
	{
		terminal_name = "exploration_shop_update", 
		terminal_state = 0, 
		_type  = 1,
		isPressedActionEnabled = true
	},
	nil, 0)

	self:onUpdateDraw()

	--    -- 顶部用户信息
    app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop")                   
    local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function ExplorationShopWindow:init(params)
	self.index = 1
	self:onInit()
	return self
end

function ExplorationShopWindow:onExit()
	state_machine.remove("exploration_shop_close")
end

