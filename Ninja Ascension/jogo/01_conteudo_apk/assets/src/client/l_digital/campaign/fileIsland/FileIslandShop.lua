-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛商店
-------------------------------------------------------------------------------------------------------

FileIslandShop = class("FileIslandShopClass", Window)

local fileIsland_window_shop_open_terminal = {
    _name = "fileIsland_window_shop_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local function callback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local FileIslandShopWindow = fwin:find("FileIslandShopClass")
		    	if FileIslandShopWindow == nil then
		    		fwin:open(FileIslandShop:new():init(params), fwin._view)
		    	end
			end
		end
		protocol_command.fileIslandShopInfo.param_list = ""
		NetworkManager:register(protocol_command.fileIslandShopInfo.code, nil, nil, nil, nil, callback, false, nil)
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_window_shop_open_terminal)
state_machine.init()

function FileIslandShop:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 2
	self._scroll_view = nil
	self._scroll_view_pox = 0
	self._scroll_view_width = 0
	self.roll_width = 0

	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuy")
	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_shop_cell")

	local function init_fileIsland_shop_terminal()
		--
		local fileIsland_shop_close_terminal = {
            _name = "fileIsland_shop_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("FileIslandShopClass"))
				-- fwin:close(fwin:find("FileIslandShopBuyTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_shop_scrollView_roll_terminal = {
            _name = "fileIsland_shop_scrollView_roll",
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

        state_machine.add(fileIsland_shop_close_terminal)
        state_machine.add(fileIsland_shop_scrollView_roll_terminal)
		state_machine.init()
	end

	init_fileIsland_shop_terminal()
end

function FileIslandShop:onUpdateDraw()
	local root = self.roots[1]
	local ScrollView_explore_shop = ccui.Helper:seekWidgetByName(root, "ScrollView_explore_shop")
	ScrollView_explore_shop:removeAllChildren(true)
	
	local cell_size = nil
	local all = #dms["file_island_shop"]
	local width_n = math.ceil(all / 2)
	local index = 1
	for i = 1, all do
		local shop_info = dms.element(dms["file_island_shop"], i)
		local cell = FileIslandShopCell:createCell()
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
end

function FileIslandShop:onUpdate(dt)
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

function FileIslandShop:onInit()
	local csb_explore_shop = csb.createNode("campaign/explore/explore_shop.csb")
	local root = csb_explore_shop:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_shop)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_shop_report_back"), nil, 
	{
		terminal_name = "fileIsland_shop_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

    self.Button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_arrow_right")
    self.Button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_arrow_left")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_right"), nil, 
	{
		terminal_name = "fileIsland_shop_scrollView_roll", 
		terminal_state = 0, 
		_type  = 2,
		isPressedActionEnabled = true
	},
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_left"), nil, 
	{
		terminal_name = "fileIsland_shop_scrollView_roll", 
		terminal_state = 0, 
		_type  = 1,
		isPressedActionEnabled = true
	},
	nil, 0)
	
	self:onUpdateDraw()

	-- 顶部用户信息
	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop") 					
	local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function FileIslandShop:init(params)
	self.index = 1
	self:onInit()
	return self
end

function FileIslandShop:onExit()
	state_machine.remove("fileIsland_shop_close")
end

