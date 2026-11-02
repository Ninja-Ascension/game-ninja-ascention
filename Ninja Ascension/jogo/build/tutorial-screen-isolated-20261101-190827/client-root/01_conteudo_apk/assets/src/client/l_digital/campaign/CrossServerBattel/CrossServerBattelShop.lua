-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战购买购买页
-------------------------------------------------------------------------------------------------------

CrossServerBattelShop = class("CrossServerBattelShopClass", Window)

local cross_server_battel_shop_open_terminal = {
    _name = "cross_server_battel_shop_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local function responseCrossServerBattelShopInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local CrossServerBattelShopWindow = fwin:find("CrossServerBattelShopClass")
		    	if CrossServerBattelShopWindow == nil then
		    		fwin:open(CrossServerBattelShop:new():init(params), fwin._view)
		    	end
			end
		end
		protocol_command.cross_mine_user_shop_buy.param_list = -1 .. "\r\n" .. 1 .. "\r\n" .. 1
		NetworkManager:register(protocol_command.cross_mine_user_shop_buy.code, nil, nil, nil, nil, responseCrossServerBattelShopInitCallback, false, nil)
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(cross_server_battel_shop_open_terminal)
state_machine.init()

function CrossServerBattelShop:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 2
	self._scroll_view = nil
	self._scroll_view_pox = 0
	self._scroll_view_width = 0
	self.roll_width = 0

	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_shop_cell")

	local function init_cross_server_battel_shop_terminal()
		--
		local cross_server_battel_shop_close_terminal = {
            _name = "cross_server_battel_shop_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("CrossServerBattelShopClass"))
				fwin:close(fwin:find("CrossServerBattelShopTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_shop_scrollView_roll_terminal = {
            _name = "cross_server_battel_shop_scrollView_roll",
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

        state_machine.add(cross_server_battel_shop_close_terminal)
        state_machine.add(cross_server_battel_shop_scrollView_roll_terminal)
		state_machine.init()
	end
	init_cross_server_battel_shop_terminal()
end

function CrossServerBattelShop:onUpdateDraw()
	local root = self.roots[1]
	local ScrollView_commodity = ccui.Helper:seekWidgetByName(root, "ScrollView_commodity")
	ScrollView_commodity:removeAllChildren(true)
	
	local cell_size = nil

	local all = #dms["cross_mine_war_shop"]
	local shopMould = {}
	for i = 1, all do
		local shopInfo = dms.element(dms["cross_mine_war_shop"], i)
		table.insert(shopMould, shopInfo)
	end

	table.sort(shopMould, function(a, b)
		local sortIndexA = dms.atof(a, cross_mine_war_shop.sort_index)
		local sortIndexB = dms.atof(b, cross_mine_war_shop.sort_index)
		return tonumber(sortIndexA) < tonumber(sortIndexB)
	end)

	local width_n = math.ceil(all/2)
	local index = 1
	for _, v in ipairs(shopMould) do
		local shop_info = v
		local cell = CrossServiceShopCell:createCell()
		cell:init(shop_info)
		if cell_size == nil then
			cell_size = cell:getContentSize()
		end
		ScrollView_commodity:addChild(cell)
		cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
		index = index + 1
	end

	if nil ~= cell_size then
		self.roll_width = cell_size.width * 3
		local InnerWidth = math.max(cell_size.width * width_n , ScrollView_commodity:getContentSize().width)
		local InnerHeight = ScrollView_commodity:getInnerContainer():getContentSize().height
		ScrollView_commodity:getInnerContainer():setContentSize(cc.size(InnerWidth , InnerHeight))
	end

    self._scroll_view = ScrollView_commodity
    self._scroll_view_pox = 99999--ScrollView_commodity:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_commodity:getInnerContainer():getPositionX()
end

function CrossServerBattelShop:formatTimeString( _time )--系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossServerBattelShop:onUpdate(dt)
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

function CrossServerBattelShop:onInit()
	local csbCrossServerShop = csb.createNode("campaign/cross_service/cross_service_shop.csb")
	local root = csbCrossServerShop:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbCrossServerShop)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_report_back"), nil, 
	{
		terminal_name = "cross_server_battel_shop_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)

    self.Button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_arrow_right")
    self.Button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_arrow_left")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_right"), nil, 
	{
		terminal_name = "cross_server_battel_shop_scrollView_roll", 
		terminal_state = 0, 
		_type  = 2,
		isPressedActionEnabled = true
	},
	nil, 2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_left"), nil, 
	{
		terminal_name = "cross_server_battel_shop_scrollView_roll", 
		terminal_state = 0, 
		_type  = 1,
		isPressedActionEnabled = true
	},
	nil, 2)
	
	self:onUpdateDraw()

	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop") 					--顶部用户信息
	local userinfo = CrossServerBattelShopTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function CrossServerBattelShop:init(params)
	self.index = params
	self:onInit()
	return self
end

function CrossServerBattelShop:onExit()
	-- state_machine.remove("")
end

